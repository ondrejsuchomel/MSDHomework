variable "credentials_file" {
  type = string
  default = "/Users/tf_user/.aws/creds"
}

variable "aws_region" {
  type    = string
  default = "eu-central-1"
}

variable "default_tag" {
  type = string
  default = "msd-hw"
}

variable "bucket_name" {
  type    = string
  default = "msd-hw-s3bucket"
}

variable "bucket_acl" {
  type = string
  default = "public-read"
}

variable "ec2_ami" {
  type = string
  default = "ami-00a205cb8e06c3c4e"
}

variable "ec2_instance_type" {
  type = string
  default = "t2.micro"
}

variable "ec2_ssh_key_name" {
  type = string
  default = "EC2 main-key"
}