FROM ubuntu:20.04
RUN apt update
RUN apt install -y software-properties-common
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt install -y python3.9
RUN apt install -y python3-pip
RUN pip3 install boto3
RUN pip3 install python-dotenv
RUN apt install awscliv2
COPY . .
CMD [aws s3 cp index.html s3://msd-hw-s3bucket --acl public-read; aws s3 cp error.html s3://msd-hw-s3bucket --acl public-read; aws s3 cp javascript.js s3://msd-hw-s3bucket --acl public-read; python app.py]

