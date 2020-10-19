FROM ubuntu:20.04
RUN apt update
RUN apt install -y software-properties-common
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt install -y python3.9
RUN apt install -y python3-pip
RUN pip3 install boto3
RUN pip install python-dotenv
RUN apt install -y curl
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.0.30.zip" -o "awscliv2.zip"
RUN unzip awscliv2.zip
RUN ./aws/install
COPY . .
RUN aws s3 cp index.html s3://msd-hw-s3-bucket --acl public-read
RUN aws s3 cp error.html s3://msd-hw-s3-bucket --acl public-read
RUN aws s3 cp javascript.js s3://msd-hw-s3-bucket --acl public-read
RUN python app.py

