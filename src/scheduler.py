import sched
import time
import getWeatherInformation
import createJsonFile
import s3upload
s = sched.scheduler(time.time, time.sleep)

def run_hourly_download(sc): 
    # openweathermap id for Prague
    id = '3067696'
    apiKey = '44419df6dc22898347ae3db58aa344d5'
    units = 'metric'
    url = 'https://api.openweathermap.org/data/2.5/weather'
    # json with data for regular uploads
    pragueWeatherData = 'data/pragueWeatherData.json'
    #bucket and file information
    bucket = 'MSD HW S3 Bucket'
    s3FileName = 'pragueWeatherData.json'

    print("Running download...")
    getWeatherInformation.downloadWeatherInformation(url, id, apiKey, units)
    createJsonFile.createJsonFile()
    s3upload.upload_to_aws(pragueWeatherData, bucket, s3FileName)
    s.enter(36, 1, run_hourly_download, (sc,)) #TODO change to 3600

s3upload.upload_to_aws('index.html', 'MSD HW S3 Bucket', 'index.html')
s.enter(36, 1, run_hourly_download, (s,)) #TODO change to 3600
s.run()
