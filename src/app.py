import os
import sched
import time
import download_data_script
import create_data_file_script
import upload_script

from dotenv import load_dotenv
load_dotenv(verbose=True)

SCHEDULER = sched.scheduler(time.time, time.sleep)
BUCKET_NAME = os.getenv('AWS_S3_BUCKET')
APP_TIMER = int(os.getenv('APP_TIMER'))


def run_data_download(sc):
    CITY_ID = os.getenv('OWM_CITY_ID') # openweathermap id for Prague
    API_KEY = os.getenv('OWM_API_KEY')
    UNITS = 'metric'
    OWM_URL = 'https://api.openweathermap.org/data/2.5/weather'
    PRAGUE_WEATHER_DATA = 'data/final_weather_data_file.json' # json with data for regular uploads
    BUCKET_NAME = os.getenv('AWS_S3_BUCKET')
    S3_FILE_NAME = 'final_weather_data_file.json'
    APP_TIMER = int(os.getenv('APP_TIMER'))
    print("Running download...")
    download_data_script.download_weather_data(OWM_URL, CITY_ID, API_KEY, UNITS)
    create_data_file_script.create_final_weather_data_file()
    upload_script.upload_to_s3_bucket(PRAGUE_WEATHER_DATA, BUCKET_NAME, S3_FILE_NAME)
    SCHEDULER.enter(APP_TIMER, 1, run_data_download, (sc,))

upload_script.upload_to_s3_bucket('index.html', BUCKET_NAME)
upload_script.upload_to_s3_bucket('javascript.js', BUCKET_NAME)
upload_script.upload_to_s3_bucket('error.html', BUCKET_NAME)
SCHEDULER.enter(APP_TIMER, 1, run_data_download, (SCHEDULER,))
SCHEDULER.run()
