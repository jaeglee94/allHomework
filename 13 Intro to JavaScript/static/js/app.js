// from data.js
var tableData = data;

//Select table body
var table = d3.select("tbody")

//Populate table body with initial data
for(i=0;i<tableData.length;i++){
    var row = table.append('tr')
    if('datetime' in tableData[i]){
        row.append('td').text(tableData[i]['datetime'])
    }
    if('city' in tableData[i]){
        row.append('td').text(tableData[i]['city'])
    }
    if('state' in tableData[i]){
        row.append('td').text(tableData[i]['state'])
    }
    if('country' in tableData[i]){
        row.append('td').text(tableData[i]['country'])
    }
    if('shape' in tableData[i]){
        row.append('td').text(tableData[i]['shape'])
    }
    if('durationMinutes' in tableData[i]){
        row.append('td').text(tableData[i]['durationMinutes'])
    }
    if('comments' in tableData[i]){
        row.append('td').text(tableData[i]['comments'])
    }
}

//get submit button object
var submit = d3.select("#filter-btn");

//submit on action
submit.on("click", filterData);

//submit button function
function filterData() {

    // Prevent the page from refreshing
    d3.event.preventDefault();
  
    // Select the input element and get the raw HTML node
    var inputElement = d3.select("#datetime");
  
    // Get the value property of the input element
    var inputValue = inputElement.property("value");

    //filter data based on user input
    var filteredData = data.filter(sight => sight.datetime === inputValue);
    
    // Clear data
    table.text("")

    //append filtered data to table
    for(i=0;i<filteredData.length;i++){
        row = table.append('tr')
        if('datetime' in filteredData[i]){
            row.append('td').text(filteredData[i]['datetime'])
        }
        if('city' in filteredData[i]){
            row.append('td').text(filteredData[i]['city'])
        }
        if('state' in filteredData[i]){
            row.append('td').text(filteredData[i]['state'])
        }
        if('country' in filteredData[i]){
            row.append('td').text(filteredData[i]['country'])
        }
        if('shape' in filteredData[i]){
            row.append('td').text(filteredData[i]['shape'])
        }
        if('durationMinutes' in filteredData[i]){
            row.append('td').text(filteredData[i]['durationMinutes'])
        }
        if('comments' in filteredData[i]){
            row.append('td').text(filteredData[i]['comments'])
        }
    }
  }
