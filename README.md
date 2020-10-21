# Hosted web page
http://msd-hw-s3bucket.s3-website.eu-central-1.amazonaws.com/


# Instructions for the deployment of the application

1. Clone following github repository: https://github.com/ondrejsuchomel/MSDHomework 
2. Set up Terraform - (https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)
3. Set up AWS CLI (https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html), aquire AWS credentials (secret and access keys) and set them as enviroment variables via AWS CLI (if necessary refer to documentation for AWS CLI at link above)
4. Update terraform.tfvars file in *repository/terraform* folder. 

&ensp;&ensp;&ensp;Variables which have to be changed are: 
* credentials_file - if it differs from the one specified in the file, 
* bucket_name - name provided here is used for provided solution and buckets have to have unique names
* ec2_ssh_key_name - if you want to ssh to the ec2

&ensp;&ensp;&ensp;Other variable values can be changed but it is not necessary for function of the terraform.

5. Open *repository/terraform folder* in terminal and run **terraform apply --auto-approve** command. It should deploy all necessary infrastructure for AWS, set up EC2, download dockerized application and launch it on EC2.


# Solution

## Tools used:
* Terraform
* Docker
* Python 3.9.0
* python-boto3
* python-dotenv

## AWS Infrastructure Setup - via Terraform:

Files are inside of *repository/terraform* folder.

main.tf file contains automation for setting up of aws refources. Resources are created with **terraform apply --auto-approve** command which is inputed into terminal in location of terraform.exe and where system path variable is referencing.
Terraform is also used to create role and policy for EC2 instance so it can access the S3 bucket and role for S3 bucket is also created this way so it can be accessed as static website. Both role and policy were generated in aws console. Role is then assigned to EC2 via instance profile.
Terraform is also used to run basic setup of the AMI - installation of docker, download of docker image and running the docker container.

provider.tf is used to store provider information

terraform.tf is used to store important terraform setup - locking version of terraform mainly

variables.tf is used to define variables and set default of these variables 

terraform.tfvars is used as file for setting of variable values 

## Docker setup

Docker setup is done inside Dockerfile located inside of *repository/src* folder. Inside is set of commands to update the container and install required tools and copy files for the application inside. **Enviroment variables**

## Application

The application files are located inside of *repository/src* folder. It consists of data folder where the downloaded data is stored in *.json format and script files. getWeatherInformation.py downloads and stores the data from OpenWeatherMap inside of pragueWeatherSource.json. createJsonFile.py is used to combine separate json information from pragueWeatherSource.json to one json object in pragueWeatherData.json. s3upload.py is script for uploading the files to the s3bucket. app.py itself is mainly used for scheulder of regular downloads **which are set up to run every 10 minutes - regular download is run and file is then uploaded to the s3bucket.**

## Docker image

Docker image was created with **docker build . -t ondrejsuchomel/msd-hw-dockerized-app** command run in terminal inside *repository/src* folder. Then it was uploaded to dockerhub via **docker push ondrejsuchomel/msd-hw-dockerized-app** (after login by **docker login**).

# Possible improvements:
* Visible token in getWeatherInformation script should not be hardcoded. 
* Management of weather information could be done better. In one file not in two where one stores all data and second one which is then converted to usable JSON.

