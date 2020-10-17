provider "aws" {
  region     = "eu-central-1"
  version    = "~> 3.11.0"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

resource "aws_instance" "EC2_Instance" {
  ami           = "ami-0474863011a7d1541"
  instance_type = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_write_profile.id
  tags = {
    Name = "MSD HW"
  }
}

resource "aws_s3_bucket" "S3_Bucket" {
  bucket = "MSD HW S3 Bucket"
  acl    = "public-read"
  tags = {
    Name = "MSD HW"
    # Environment = "Dev"
  }
}

resource "aws_iam_role" "ec2_s3_write_role" {
  name = "ec2_s3_write_role"
  assume_role_policy = file("ec2-assume-policy.json")
  tags = {
    Name = "MSD HW"
  }
}

resource "aws_iam_role_policy" "ec2_s3_write_policy" {
  name = "ec2_s3_write_policy"
  role = aws_iam_role.ec2_s3_write_role.id
  policy = file("ec2-policy.json")
}

resource "aws_iam_instance_profile" "ec2_s3_write_profile" {
  name = "ec2_s3_write_profile"
  role = aws_iam_role.ec2_s3_write_role.id
}
