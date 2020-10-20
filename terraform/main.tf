resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name
  acl    = var.bucket_acl
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
    Name = "${var.default_tag}"
  }
}

resource "aws_instance" "ec2_instance" {
  ami                  = var.ec2_ami
  instance_type        = var.ec2_instance_type
  key_name             = var.ec2_ssh_key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_write_profile.id
  tags = {
    Name = "${var.default_tag}"
  }
  #   user_data = <<EOF
  # #!/bin/bash
  # sudo apt update -y
  # sudo apt install -y curl
  # sudo curl -fsSL https://get.docker.com -o get-docker.sh
  # sudo sh get-docker.sh
  # sudo docker run -e AWS_S3_BUCKET="${var.bucket_name}" ondrejsuchomel/msd-hw-dockerized-app
  # EOF
}

resource "aws_iam_role" "ec2_s3_write_role" {
  name               = "ec2_s3_write_role"
  assume_role_policy = file("data/ec2_assume_policy.json")
  tags = {
    Name = "${var.default_tag}"
  }
}

resource "aws_iam_role_policy" "s3_write_policy" {
  name   = "s3_write_policy"
  role   = aws_iam_role.ec2_s3_write_role.id
  policy = file("data/ec2_policy.json")
}

resource "aws_iam_instance_profile" "ec2_s3_write_profile" {
  name = "ec2_s3_write_profile"
  role = aws_iam_role.ec2_s3_write_role.id
}
