import os
import boto3
import mimetypes
from botocore.exceptions import NoCredentialsError

from dotenv import load_dotenv
load_dotenv(verbose=True)


def upload_to_s3_bucket(file_name, bucket_name, s3_file_name=None):
    S3 = boto3.client('s3')

    file_mime_type, _ = mimetypes.guess_type(file_name)

    if s3_file_name is None:
        s3_file_name = file_name

    try:
        S3.upload_file(file_name, bucket_name, s3_file_name,
                       ExtraArgs={'ACL': 'public-read', 'ContentType': file_mime_type})
        print("Upload Successful")
        return True
    except FileNotFoundError:
        print("The file was not found")
        return False
    except NoCredentialsError:
        print("Credentials not available")
        return False
