function buildMetadata(sample) {

  // @TODO: Complete the following function that builds the metadata panel

  // Use `d3.json` to fetch the metadata for a sample
    // Use d3 to select the panel with id of `#sample-metadata`
    var selector = d3.select('#sample-metadata')
    // Use `.html("") to clear any existing metadata
    selector.html("")
    // Use `Object.entries` to add each key and value pair to the panel
    // Hint: Inside the loop, you will need to use d3 to append new
    // tags for each key-value in the metadata.
    d3.json('metadata/' + sample).then(function(data) {
      for(var key in data){
        selector
          .append('p')
          .text(key + ":" + data[key])
      }
    })
    // BONUS: Build the Gauge Chart
    // buildGauge(data.WFREQ);
}

function buildCharts(sample) {

  var selector = d3.select('#pie')

  // @TODO: Use `d3.json` to fetch the sample data for the plots
    d3.json('samples/' + sample).then(function(data) {
      var sampleIds = data['otu_ids']
      var sampleValues =  data['sample_values']
      var sampleLabels = data['otu_labels']
      // @TODO: Build a Pie Chart
      var data = [{
        values: sampleValues.slice(0,10),
        labels: sampleIds.slice(0,10),
        type: 'pie',
        hoverinfo: sampleLabels.slice(0,10)
      }];
      var layout = {
        height: 400,
        width: 500
      };
    Plotly.newPlot('pie', data,layout);

    // @TODO: Build a Bubble Chart using the sample data
    var trace1 = {
      x: sampleIds,
      y: sampleValues,
      text:sampleLabels,
      mode: 'markers',
      marker: {
        color: sampleIds,
        size: sampleValues
      }
    };
    
    var data2 = [trace1];
    
    var layout2 = {
      height: 600,
      width: 1200
    };
    
    Plotly.newPlot('bubble', data2, layout2);
    });
    
    // HINT: You will need to use slice() to grab the top 10 sample_values,
    // otu_ids, and labels (10 each).
}

function init() {
  // Grab a reference to the dropdown select element
  var selector = d3.select("#selDataset");
  
  // Use the list of sample names to populate the select options
  d3.json("/names").then((sampleNames) => {
    sampleNames.forEach((sample) => {
      selector
        .append("option")
        .text(sample)
        .property("value", sample);
    });

    // Use the first sample from the list to build the initial plots
    const firstSample = sampleNames[0];
    buildCharts(firstSample);
    buildMetadata(firstSample);
  });
}

function optionChanged(newSample) {
  // Fetch new data each time a new sample is selected
  buildCharts(newSample);
  buildMetadata(newSample);
}

// Initialize the dashboard

init();
