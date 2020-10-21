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


resource "aws_iam_role" "ec2_s3_full_access_role" {
  name               = "ec2_s3_full_access_role"
  assume_role_policy = file("data/ec2_assume_policy.json")
  tags = {
    Name = "${var.default_tag}"
  }
}

resource "aws_iam_role_policy" "s3_full_access_policy" {
  name   = "s3_full_access_policy"
  role   = aws_iam_role.ec2_s3_full_access_role.id
  policy = file("data/ec2_policy.json")
}

resource "aws_iam_instance_profile" "ec2_s3_write_profile" {
  name = "ec2_s3_write_profile"
  role = aws_iam_role.ec2_s3_full_access_role.id
}


resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.default_tag}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    ipv6_cidr_block = "::/0"
    gateway_id      = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.default_tag}"
  }
}

resource "aws_subnet" "subnet_1" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name = "${var.default_tag}"
  }
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.subnet_1.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow Web inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.default_tag}"
  }
}

resource "aws_network_interface" "server_nic" {
  subnet_id       = aws_subnet.subnet_1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}

resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.server_nic.id
  associate_with_private_ip = "10.0.1.50"
  depends_on                = [aws_internet_gateway.igw]
}

output "server_public_ip" {
  value = aws_eip.one.public_ip
}


resource "aws_instance" "ec2_instance" {
  ami                  = var.ec2_ami
  instance_type        = var.ec2_instance_type
  key_name             = var.ec2_ssh_key_name
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_write_profile.id
  availability_zone    = var.availability_zone
  tags = {
    Name = "${var.default_tag}"
  }
  user_data = <<EOF
#!/bin/bash
sudo apt update -y
sudo apt install awscli -y
sudo curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo docker run -e AWS_S3_BUCKET="${var.bucket_name}" -e APP_TIMER="${var.app_timer}" -e OWM_API_KEY="${var.owm_api_key}" -e OWM_CITY_ID="${var.owm_city_id}"  ondrejsuchomel/msd-hw-dockerized-app python3 app.py
EOF


  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.server_nic.id
  }
}
