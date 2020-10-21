import json


def create_final_weather_data_file():
    temporary_weather_data = [] # creates data array
    with open('data/temporary_weather_data_file.json') as source_file: # takes each line from Source file and appends it to array
        for line in source_file:
            temporary_weather_data.append(json.loads(line))

    final_weather_data_file = open('data/final_weather_data_file.json', "w") # create / open file and write
    weather_data = json.dumps(temporary_weather_data)  # convert python data back to json
    final_weather_data_file.write(weather_data)
    final_weather_data_file.close()
