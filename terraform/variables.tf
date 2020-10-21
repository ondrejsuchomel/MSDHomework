variable "credentials_file" {
  description = "Path to AWS Credentials file"
  type    = string
  default = "/Users/tf_user/.aws/creds"
}

variable "aws_region" {
  description = "AWS Region which will be used to deploy infrastructure"
  type    = string
  default = "eu-central-1"
}

variable "default_tag" {
  description = "Name of tag used to deploy infrastructure"
  type    = string
  default = "msd-hw"
}

variable "app_timer" {
  description = "Time in seconds between API calls and uploads to s3 performed by the dockerized app"
  type    = number
  default = 60
}

variable "owm_city_id" {
  description = "OpenWeatherMap city id number"
  type    = string
  default = "3067696"
}

variable "owm_api_key" {
  description = "OpenWeatherMap API Key"
  type    = string
  default = "44419df6dc22898347ae3db58aa344d5"
}

variable "bucket_name" {
  description = "Name of S3 Bucket for uploads"
  type    = string
  default = "msd-hw-s3bucket"
}

variable "bucket_acl" {
  description = "Bucket access control list"
  type    = string
  default = "public-read"
}

variable "ec2_ami" {
  description = "Type of Amazon Machine Image"
  type    = string
  default = "ami-0c960b947cbb2dd16"
}

variable "ec2_instance_type" {
  description = "Type of EC2 instance type"
  type    = string
  default = "t2.micro"
}

variable "ec2_ssh_key_name" {
  description = "SSH Key name for EC2 instance"
  type    = string
  default = "EC2 main-key"
}

variable "availability_zone" {
  description = "Specification of AWS availability zone"
  type = string
  default = "eu-central-1a"
}