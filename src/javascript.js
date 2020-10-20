async function generateDynamicTable() {
  
  let weatherInfo = "";
  let url = "./pragueWeatherData.json";
  
  async function getJson(url) {
    let response = await fetch(url);
    let data = await response.json()
    return data;
  }

  weatherInfo = await getJson(url);

  var noOfWeatherInfo = weatherInfo.length;

  if (noOfWeatherInfo > 0) {

    // Create dynamic table
    var table = document.createElement("table");
    table.style.width = '50%';
    table.setAttribute('border', '1');
    table.setAttribute('cellspacing', '0');
    table.setAttribute('cellpadding', '5');
    table.setAttribute('text-align', 'center')

    // Create column header
    var col = ["Date", "Temperature [C]", "Feel Temperature [C]", "Pressure [hPa]", "Humidity [%]", "Wind speed [m/s]", "Wind direction [deg]"];

    // Create table head
    var tHead = document.createElement("thead");


    // Create row for table head
    var hRow = document.createElement("tr");

    // Add column header to row of table head
    for (var i = 0; i < col.length; i++) {
      var th = document.createElement("th");
      th.innerHTML = col[i];
      hRow.appendChild(th);
    }
    tHead.appendChild(hRow);
    table.appendChild(tHead);

    // Create table body
    var tBody = document.createElement("tbody");

    // Add column header to row of table head
    for (var i = 0; i < noOfWeatherInfo; i++) {

      var bRow = document.createElement("tr"); // Create row for each record
      var keys = ["dt", "temp", "feels_like", "pressure", "humidity", "speed", "deg"]

      for (var j = 0; j < col.length; j++) {
        var td = document.createElement("td");

        function getValue(key, array, search) {
          if (search == "D") {
            for (var el in array) {
              if (array[el].hasOwnProperty(key)) {
                return array[el][key];
              }
            }
          } else if (search == "S") {
            if (array.hasOwnProperty(key)) {
              return array[key];
            }
          }
        }

        function mapTime(UNIX_timestamp) {
          var a = new Date(UNIX_timestamp * 1000);
          var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
          var year = a.getFullYear();
          var month = months[a.getMonth()];
          var date = a.getDate();
          var hour = a.getHours();
          // var min = a.getMinutes();
          // var sec = a.getSeconds();
          // + ':' + min + ':' + sec
          var time = hour + 'h ' + date + ' ' + month + ' ' + year ;
          return time;
        }

        if (keys[j] == "dt") {
          var value = getValue(keys[j], weatherInfo[i], "S");
          td.innerHTML = mapTime(value);
          bRow.appendChild(td);
        } else if (keys[j] == "description") {
          td.innerHTML = getValue(keys[j], weatherInfo[i], "S");
          bRow.appendChild(td);
        } else {
          td.innerHTML = getValue(keys[j], weatherInfo[i], "D");
          bRow.appendChild(td);
        }

      }
      tBody.appendChild(bRow)

    }
    table.appendChild(tBody);


    // Add created table with JSON data to a container
    var divContainer = document.getElementById("weatherInfo");
    divContainer.innerHTML = "";
    divContainer.appendChild(table);

  }
}