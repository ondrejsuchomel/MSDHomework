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

resource "aws_instance" "EC2 instance" {
  ami           = "ami-0474863011a7d1541"
  instance_type = "t2.micro"
  tags = {
    Name = "MSD HW EC2"
  }
}
