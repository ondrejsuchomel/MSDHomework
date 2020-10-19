# Instructions for the deployment of the application

0. Clone following github repository: https://github.com/ondrejsuchomel/MSDHomework 
1. Set up Terraform
2. Aquire AWS credentials which allow managing of ec2, s3, roles and policies.
3. Create terraform.tfvars file in *repository/terraform* folder. It should contain aws_access_key, aws_secret_key and bucket_name variables with working keys and name of the bucket (other possibilites listed in Solution section). AWS region is set to eu-central-1 by default. It can be changed in main.tf file in *repository/terraform folder*.
4. Open *repository/terraform folder* in terminal and run **terraform apply --auto-approve** command. It should deploy all necessary infrastructure for AWS.


# Solution

## Hosted web page
http://msd-hw-s3bucket.s3-website.eu-central-1.amazonaws.com/

## Tools used:
* Terraform
* Docker
* Python 3.9.0
* python-boto3
* python-dotenv

## AWS Infrastructure Setup - via Terraform:

Files are inside *repository/terraform* folder.

main.tf file contains automation for setting up of EC2 server and S3 bucket. Both are created with "terraform apply --auto-approve" command which is inputed into terminal in location of terraform.exe and where system path variable is referencing.

AWS access keys are provided in variables stored in terraform.tfvars file as a "better" way then hardcoding them into main.tf file. Also name of the s3 bucket should be supplied in this file and should be same as listed bellow (or it needs to be changed in Dockerfile and new Docker image needs to be created).
terraform.tfvars is not supplied but the contents should look like:

  aws_access_key = "AKIAJBFBMR5IHHHUN4OA"

  aws_secret_key = "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"

  bucket_name = "msd-hw-s3bucket"

Correct way would be to i.e. to reference AWS credentials file location - shared_credentials_file = "/Users/tf_user/.aws/creds" inside of declaration of provider in main.tf file.

Terraform is also used to create role and policy for EC2 instance so it can access the S3 bucket and role for S3 bucket is also created this way so it can be accessed as static website. Both role and policy were generated in aws console. Role is then assigned to EC2 via instance profile.

Terraform is also used to run basic setup of the AMI - installation of docker, download of docker image and running the docker container.

## Docker setup

Docker setup is done inside Dockerfile located inside of *repository/src* folder. Inside is set of commands to update the container and install required tools and copy files for the application inside. Docker container also uploads the index.html, error.html and javascript.js to the s3 bucket. S3 bucket name is hardcoded here - for app to uppload to other bucket is need to be changed in Dockerfile and new image has to be created.

## Application

The application files are located inside of *repository/src* folder. It consists of data folder where the downloaded data is stored in *.json format and script files. getWeatherInformation.py downloads and stores the data from openweathermap inside of pragueWeatherSource.json. createJsonFile.py is used to combine separate json information from pragueWeatherSource.json to one json object in pragueWeatherData.json. s3upload.py is script for uploading the pragueWeatherData.json to the s3bucket. app.py itself is mainly used for scheulder of regular downloads which are set up to run every 10 minutes - regular download is run and file is then uploaded to the s3bucket.

## Docker image

Docker image was created with **docker build . -t ondrejsuchomel/msd-hw-dockerized-app** command run in terminal inside *repository/src* folder. Then it was uploaded to dockerhub via **docker push ondrejsuchomel/msd-hw-dockerized-app** (after login by **docker login**).

## Possible improvements:
* Visible token in getWeatherInformation script should not be hardcoded. 
* Management of weather information could be done better. In one file not in two where one stores all data and second one which is then converted to usable JSON.
* Docker on AMI should not be setup by convenience script
* S3 bucket name should not be hardcoded in Dockerfile - possible solution would be to use environment variables. This is also a reason why there is not point in changing the s3 bucket name in terraform file.