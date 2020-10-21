import requests


def download_weather_data(url, id, api_key, units):
    payload = {'id': id, 'units': units, 'appid': api_key} 
    response = requests.get(url, params=payload) # call api
    weather_data = response.text
    temporary_weather_data_file = open('data/temporary_weather_data_file.json', "a") # create / open file and append
    temporary_weather_data_file.write(weather_data + '\n') # write response into the file
    temporary_weather_data_file.close()
