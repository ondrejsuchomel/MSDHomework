# DockerizedApp

Tools used:
Python 3.9.0
boto3
Ansible


AWS Infrastructure Setup   
EC2:
AMI - Amazon Linux AMI 2018.03.0
Instance - General purpose t2.micro

S3:
Create bucket

Possible improvements
Visible token in getWeatherInformation script should not be hardcoded. 
Management of weather information could be done better. In one file not in two where one stores all data and second one which is converted to usable JSON
