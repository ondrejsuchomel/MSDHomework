FROM ubuntu:20.04
RUN apt update
RUN apt install -y software-properties-common
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt install -y python3.9
RUN apt install -y python3-pip
RUN pip3 install boto3
RUN pip3 install python-dotenv
COPY . .
ENV AWS_S3_BUCKET = "msd-hw-s3bucket"
CMD python app.py

