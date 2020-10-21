provider "aws" {
  region                  = var.aws_region
  version                 = "~> 3.11.0"
  shared_credentials_file = var.credentials_file
}
