# DockerizedApp

Tools used:
Python 3.9.0
boto3
Terraform


AWS Infrastructure Setup - via Terraform:

Files are inside terraform folder.

main.tf file contains automation for setting up of EC2 server and S3 bucket. Both are created with "terraform apply --auto-approve" command which is inputed into terminal in location of terraform.exe and where system path variable is referencing.

AWS access keys are provided in variables stored in terraform.tfvars file as a "better" way then hardcoding them into main.tf file.
terraform.tfvars is not supplied but the contents should look like:

  aws_access_key = "AKIAJBFBMR5IHHHUN4OA"
  aws_secret_key = "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"

Correct way would be to i.e. to reference AWS credentials file location - shared_credentials_file = "/Users/tf_user/.aws/creds" inside of declaration of provider in main.tf file.

Terraform is also used to create role and policy for EC2 instance so it can access the S3 bucket. Both role and policy were generated in aws console. Role is then assigned to EC2 via instance profile.


Possible improvements:
Visible token in getWeatherInformation script should not be hardcoded. 
Management of weather information could be done better. In one file not in two where one stores all data and second one which is converted to usable JSON
