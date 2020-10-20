import os
import boto3
import mimetypes
from botocore.exceptions import NoCredentialsError

from dotenv import load_dotenv
load_dotenv(verbose=True)


def upload_to_aws(file_name, bucket, s3_name=None):
    s3 = boto3.client('s3')

    file_mime_type, _ = mimetypes.guess_type(file_name)

    if s3_name is None:
        s3_name = file_name

    try:
        s3.upload_file(file_name, bucket, s3_name,
                       ExtraArgs={'ACL': 'public-read', 'ContentType': file_mime_type})
        print("Upload Successful")
        return True
    except FileNotFoundError:
        print("The file was not found")
        return False
    except NoCredentialsError:
        print("Credentials not available")
        return False

