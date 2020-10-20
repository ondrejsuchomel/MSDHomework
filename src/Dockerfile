FROM ubuntu:20.04
RUN apt update
RUN apt install -y software-properties-common
RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt install -y python3.9
RUN apt install -y python3-pip
RUN pip3 install boto3
RUN pip3 install python-dotenv
RUN apt install awscli -y
COPY . .
ENV AWS_S3_BUCKET = "msd-hw-s3bucket"
ENV APP_TIMER = "10"
ENV OWM_API_KEY = "44419df6dc22898347ae3db58aa344d5"
ENV OWM_CITY_ID = "3067696"