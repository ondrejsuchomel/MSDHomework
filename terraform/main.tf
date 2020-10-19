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

variable "bucket_name" {
  type = string
}

resource "aws_s3_bucket" "S3_Bucket" {
  bucket = var.bucket_name
  acl    = "public-read"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "PublicReadForGetBucketObjects",
          "Effect": "Allow",
          "Principal": {
            "AWS": "*"
          },
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::${var.bucket_name}/*"
      }
  ]
}
EOF

  website {
    index_document = "index.html"
    error_document = "error.html"

    routing_rules = <<EOF
[{
    "Condition": {
        "KeyPrefixEquals": "docs/"
    },
    "Redirect": {
        "ReplaceKeyPrefixWith": "documents/"
    }
}]
EOF
  }

  tags = {
    Name = "MSD HW"
    # Environment = "Dev"
  }
}

resource "aws_instance" "EC2_Instance" {
  ami                  = "ami-00a205cb8e06c3c4e"
  instance_type        = "t2.micro"
  key_name             = "EC2 main-key"
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_write_profile.id
  tags = {
    Name = "MSD HW"
  }
    user_data = <<EOF
  #!/bin/bash
  sudo apt update -y
  sudo apt install -y curl
  sudo curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  sudo docker run -e AWS_S3_BUCKET="${var.bucket_name}" ondrejsuchomel/msd-hw-dockerized-app
  EOF
}

resource "aws_iam_role" "ec2_s3_write_role" {
  name               = "ec2_s3_write_role"
  assume_role_policy = file("ec2_assume_policy.json")
  tags = {
    Name = "MSD HW"
  }
}

resource "aws_iam_role_policy" "s3_write_policy" {
  name   = "s3_write_policy"
  role   = aws_iam_role.ec2_s3_write_role.id
  policy = file("ec2_policy.json")
}

resource "aws_iam_instance_profile" "ec2_s3_write_profile" {
  name = "ec2_s3_write_profile"
  role = aws_iam_role.ec2_s3_write_role.id
}
