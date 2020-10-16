import sched
import time
import getWeatherInformation
import createJsonFile
s = sched.scheduler(time.time, time.sleep)

def run_hourly_download(sc): 
    # openweathermap id for Prague
    id = '3067696'
    apiKey = '44419df6dc22898347ae3db58aa344d5'
    units = 'metric'
    url = 'https://api.openweathermap.org/data/2.5/weather'

    print("Running download...")
    getWeatherInformation.downloadWeatherInformation(url, id, apiKey, units)
    createJsonFile.createJsonFile()
    s.enter(3600, 1, run_hourly_download, (sc,))

s.enter(3600, 1, run_hourly_download, (s,))
s.run()
