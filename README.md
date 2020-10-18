# Big Data Platform  –  Deploy Dockerized Application

## Goal: 
Demonstrate the ability to automate the deployment of dockerized application 

## Infrastructure and tools:
* AWS EC2 (or other AWS server-less service)
* AWS S3
* Docker and your preferred docker image
* Ansible / terraform
* Python

## Task:
1. Download regularly (e.g. daily / hourly) some dataset from the free data provider. If you down know any, choose from:
  https://github.com/CSSEGISandData/COVID-19/
  https://openweathermap.org/current
2. Store downloaded dataset to S3 bucket
3. From every downloaded dataset, extract some specific data (eg data relevant for Czechia, Prague, ...)
4. Display all extracted data using a single HTML page served from S3. A simple table is enough.
5. Present the result

## Instructions:
* Use well-known language (preferable  Python 3) to create an application
* Create a docker to encapsulate the application logic
* Use latest ansible / terraform to automate the deployment of the application
* Put all your source code in a public git repository (e.g. Github)
* Use Readme.MD file for the documentation (while evaluating we will use it)
* If you find problems, or not implement something, you should mention it there
* You don't need to provide automation for AWS infrastructure (EC2, S3) setup but you should document it

## Bonus points:
Replace EC2 with AWS serverless offering
Document the next steps to make this small application being ready for production
Create a CI / CD pipelines
Use your imagination and provide more than expected


# Solution

## Tools used:
Python 3.9.0
boto3
python-dotenv
Docker
Terraform

## AWS Infrastructure Setup - via Terraform:

Files are inside terraform folder.

main.tf file contains automation for setting up of EC2 server and S3 bucket. Both are created with "terraform apply --auto-approve" command which is inputed into terminal in location of terraform.exe and where system path variable is referencing.

AWS access keys are provided in variables stored in terraform.tfvars file as a "better" way then hardcoding them into main.tf file.
terraform.tfvars is not supplied but the contents should look like:

  aws_access_key = "AKIAJBFBMR5IHHHUN4OA"
  aws_secret_key = "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"

Correct way would be to i.e. to reference AWS credentials file location - shared_credentials_file = "/Users/tf_user/.aws/creds" inside of declaration of provider in main.tf file.

Terraform is also used to create role and policy for EC2 instance so it can access the S3 bucket and role for S3 bucket is also created this way so it can be accessed as static website. Both role and policy were generated in aws console. Role is then assigned to EC2 via instance profile.

## Possible improvements:
In general lot of the things vere hardcoded i.e. bucket name in the application.
Visible token in getWeatherInformation script should not be hardcoded. 
Management of weather information could be done better. In one file not in two where one stores all data and second one which is converted to usable JSON
