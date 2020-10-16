# DockerizedApp

Tools used:
Python 3.9.0
Terraform


AWS Infrastructure Setup - via Terraform
Files are inside terraform folder.  
main.tf file contains automation for setting up of EC2 server and S3 bucket. Both are created with "terraform apply --auto-approve" command which is inputed into terminal in location of terraform.exe and where system path variable is referencing.
AWS credentials are provided in variables stored in provided terraform.tfvars file as a "better" way then hardcoding them into main.tf file. Correct way would be to i.e. to reference AWS credentials file location - shared_credentials_file = "/Users/tf_user/.aws/creds" inside of declaration of provider in main.tf file.

Possible improvements
Visible token in getWeatherInformation script should not be hardcoded. 
Management of weather information could be done better. In one file not in two where one stores all data and second one which is converted to usable JSON
