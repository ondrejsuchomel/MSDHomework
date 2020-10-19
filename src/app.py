import sched
import os
import time
import getWeatherInformation
import createJsonFile
import s3upload

from dotenv import load_dotenv
load_dotenv(verbose=True)

s = sched.scheduler(time.time, time.sleep)

def run_data_download(sc): 
    # openweathermap id for Prague
    id = '3067696'
    apiKey = '44419df6dc22898347ae3db58aa344d5'
    units = 'metric'
    url = 'https://api.openweathermap.org/data/2.5/weather'
    # json with data for regular uploads
    pragueWeatherData = 'data/pragueWeatherData.json'
    #bucket and file information
    bucket = os.getenv('AWS_S3_BUCKET')
    s3FileName = 'pragueWeatherData.json'

    print("Running download...")
    getWeatherInformation.downloadWeatherInformation(url, id, apiKey, units)
    createJsonFile.createJsonFile()
    s3upload.upload_to_aws(pragueWeatherData, bucket, s3FileName)
    s.enter(10, 1, run_data_download, (sc,))

s.enter(10, 1, run_data_download, (s,))
s.run()