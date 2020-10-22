# Hosted web page
http://msd-hw-s3bucket.s3-website.eu-central-1.amazonaws.com/


# Instructions for the deployment of the application

1. Clone following github repository: https://github.com/ondrejsuchomel/MSDHomework 
2. Set up Terraform - (https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started)
3. Set up AWS CLI (https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html), aquire AWS credentials (secret and access keys) and set them as enviroment variables via AWS CLI (if necessary, refer to documentation for AWS CLI at link above)
4. Update variables.tf file in *repository/terraform* folder. 

&ensp;&ensp;&ensp;Variables which have to be changed are: 
* credentials_file - if its location differs from the one specified in the file, 
* bucket_name - name provided here is used for provided solution and buckets have to have unique names
* ec2_ssh_key_name - if you want to SSH to the ec2

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

*main.tf* file contains automation for setting up of AWS resources. Resources are created with **terraform apply --auto-approve** command which is inputed into terminal in location of terraform.exe and where system path variable is referencing.
Terraform is also used to create role and policy for EC2 instance so it can access the S3 bucket and role for S3 bucket is also created this way so it can be accessed as static website. Both role and policy were generated in aws console. Role is then assigned to EC2 via instance profile.
Terraform is also used to run basic setup of the AMI - installation of docker, download of docker image and running the docker container.

*provider.tf* is used to store provider information

*terraform.tf* is used to store important terraform setup - locking version of terraform mainly

*variables.tf* is used to define variables and set default of these variables 

## Docker setup

Docker setup is done in Dockerfile located inside of *repository/src* folder. Inside is set of commands to update the container, install required tools and copy files for the application. Environment variables used in application are also defined in Dockerimage - name for the s3 bucket, timer for the application, city ID and API Key for the OpenWeatherMap. Values for those variables are passed to docker container by adding -e "Environment_variable_name"="value" to docker run command (as can be seen in *main.tf* within ec2 setup).

## Application

The application files are located inside of *repository/src* folder. It consists of data folder where the downloaded data is stored in x.json format and script files. *download_data_script.py* downloads and stores the data from OpenWeatherMap inside of *temporary_weather_data.json*. *create_data_file_script.py* is used to combine separate json information from *temporary_weather_data.json* to one json object in *final_weather_data_file.json*. *upload_script.py* is script for uploading the files to the s3bucket. *app.py* itself is mainly used for scheulder of regular download of data and upload of the json file. They are by default set up to run every 60 minutes but can ben be easily changed by running docker image with different value for environment variable.

## Docker image

Docker image was created with **docker build . -t ondrejsuchomel/msd-hw-dockerized-app** command run in terminal inside *repository/src* folder. Then it was uploaded to dockerhub via **docker push ondrejsuchomel/msd-hw-dockerized-app** (after login by **docker login**).

# Possible improvements:

1. Container orchestration

In model scenario when for example more instances of the application (i.e. for different cities) were required to be managed or it would be needed to be flexible with number of instances either way (scale up or down). It would make sence to use some kind of container orchestration tools like Kubernetes. Which would open posibility to create and handle these instances easier. Alternative to Kubernetes for smaller deployments could be Amazon Elastic Container Service (ECS) which should be easier to set up and deploy when working mostly with other Amazon Web Services.

2. Serverless solution

Basicaly an alternative to setting up an managing infrastructure "manualy" as seen in a solution (in this case by terraform) serverless solution (like Amazon Lambda) can be used to replace this. Serverless solution offers less complex solution but also with less flexibility in a way how the infrastructure is set up and managed.

3. Make more use of docker containers

In provided solution Docker is set up from a scratch (from clean ubuntu image) but some parts could excluded from docker image set up (i.e. aws cli) and be integrated as containers. This would also be more interesting if the app would use more tools and be more complex than it actualy is.

4. Focus more on CICD

Automate whole process of integration from building of docker image of the app and pushing it to docker hub and include actual tests / linting to run on application and docker image. All of this can be done in GitLab.