# Hosted web page
http://msd-hw-s3bucket.s3-website.eu-central-1.amazonaws.com/


# Instructions for the deployment of the application

1. Clone following github repository: https://gitlab.com/ondrejsuchomel/MSDHomework 
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
* GitLab CI/CD

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

In a model scenario where for example more instances of the application (i.e. weather information for different cities) were required to be managed or it would be necessary to be flexible with number of instances in either way (scale up or down) it would make sense to use some kind of container orchestration tools like Kubernetes for example. Which would open posibility to create and handle bigger number of instances easier. I did not try to implement this since it is partialy out of scope of the assignment (since the app is small) and also because whole thing is a bit more complex to set up and run.

2. Serverless solution

Alternative to Kubernetes for smaller deployments could be Amazon Elastic Container Service (ECS) which is easier to set up and deploy when working mostly with other Amazon Web Services. Basicaly it is an alternative to setting up and managing infrastructure "manually". Further abstraction from Docker could be written in Amazon Lambda. Serverless solution in general offers less complex solutions but also less flexibility in a way how the infrastructure is set up and managed. Implementing actual solution of the assignment this way would in my opinion miss the point of whole excercise since it is esentialy a workaround around and would demonstrate just the ability to write the Lambda while evading the infrastructure set up.

3. Make more use of docker containers

In provided solution Docker is set up from a scratch (from clean ubuntu image) but some parts could excluded from docker image set up (i.e. aws cli) and be integrated as containers. This would also be more interesting if the app would use more tools and be more complex than it actualy is.

4. CI/CD

Improve uppon the currently provided CI/CD which is very simple and serves just as a tool to automate the deployment of the AWS infrastructure with terraform. But this basic set up can be build on and improved to include for example automation for building of the docker image, tests to run on the code of application and on the docker image itself or linting.

Author: ondrej_suchomel@centrum.cz
