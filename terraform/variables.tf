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

variable "app_timer" {
  type = number
  default = 3600 
}

variable "owm_city_id" {
  type = string
  default = "3067696"
}

variable "owm_api_key" {
  type = string
  default = "44419df6dc22898347ae3db58aa344d5"
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
  default = "ami-0c960b947cbb2dd16"
}

variable "ec2_instance_type" {
  type = string
  default = "t2.micro"
}

variable "ec2_ssh_key_name" {
  type = string
  default = "EC2 main-key"
}