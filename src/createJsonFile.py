import json

def createJsonFile():
    # creates data array
    pragueWeatherSourceData = []
    with open('data/pragueWeatherSource.json') as sourceFile:
        for line in sourceFile:
            pragueWeatherSourceData.append(json.loads(line))

    # create / open file and append
    weatherFile = open('data/pragueWeatherData.json', "w")
    # convert python data back to json
    weatherData = json.dumps(pragueWeatherSourceData)
    # write response into the file
    weatherFile.write(weatherData)
    # close the file
    weatherFile.close()