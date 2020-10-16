import requests

def downloadWeatherInformation(url, id, apiKey, units):
    # call api
    payload = {'id': id, 'units': units, 'appid': apiKey} 
    response = requests.get(url, params=payload)
    weatherinfo = response.text
    # create / open file and append
    weatherSourceFile = open('data/pragueWeatherSource.json', "a")
    # write response into the file
    weatherSourceFile.write(weatherinfo + '\n')
    # close the file
    weatherSourceFile.close()