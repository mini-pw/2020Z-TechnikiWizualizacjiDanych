var render = function(data) {
  var margin = {
      top: 100,
      right: 10,
      bottom: 40,
      left: 50
    },
    width = 600 - margin.left - margin.right,
    height = 600 - margin.top - margin.bottom;

  var canvas = r2d3.svg
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  var xScale = d3.scaleLinear()
    .domain([0,
        d3.max(data, function(d) {
        return +d.number_of_lost_teeth;
      })
    ])
    .range([0, width]);
    
  var xAxis = d3.axisBottom(xScale);
    
  canvas.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis)
    .append("text")
    .attr("class", "labelek")
    .attr("x", width)
    .attr("y", 34)
    .style("font-family", "sans-serif")
    .style("font-size", "15px")
    .style("fill", "#333")
    .style("text-anchor", "end")
    .text("Lost teeth");
  
  var histogram = d3.histogram()
    .value(function(d) { return d.number_of_lost_teeth; })
    .domain(xScale.domain())
    .thresholds(d3.range(0, xScale.domain()[1], xScale.domain()[1]/options.bins));
  
  var bins = histogram(data);
  var blackBins = histogram(data.filter(function(d){return d.colour == "black";}));
  var blueBins = histogram(data.filter(function(d){return d.colour == "blue";}));
  var greenBins = histogram(data.filter(function(d){return d.colour == "green";}));    
  var redBins = histogram(data.filter(function(d){return d.colour == "red";}));
  
  var yScale = d3.scaleLinear()
    .range([height, 0])
    .domain([0, d3.max(bins, function(d) { return d.length; })]);
    
  var yAxis = d3.axisLeft(yScale);
  
   canvas.append("g")
    .attr("class", "y axis")
    .call(yAxis)
    .append("text")
    .attr("class", "labelek")
    .attr("x", 35)
    .attr("y", -15)
    .style("font-family", "sans-serif")
    .style("font-size", "15px")
    .style("fill", "#333")
    .style("text-anchor", "end")
    .text("Frequency");
  
  canvas.append("g")
      .call(d3.axisLeft(yScale));
      
  if(options.divide){
  canvas.append("g").selectAll("rect")
      .data(blackBins)
      .enter()
      .append("rect")
        .attr("x", 1)
        .attr("transform", function(d) { return "translate(" + xScale(d.x0) + "," + yScale(d.length) + ")"; })
        .attr("width", function(d) { return xScale(d.x1) - xScale(d.x0) -1 ; })
        .attr("height", function(d) { return height - yScale(d.length); })
        .style("fill", "#383428")
        .style("opacity", "0.5")
      .exit()
        
  canvas.append("g").selectAll("rect")
      .data(blueBins)
      .enter()
      .append("rect")
        .attr("x", 1)
        .attr("transform", function(d) { return "translate(" + xScale(d.x0) + "," + yScale(d.length) + ")"; })
        .attr("width", function(d) { return xScale(d.x1) - xScale(d.x0) -1 ; })
        .attr("height", function(d) { return height - yScale(d.length); })
        .style("fill", "#0099ff")
        .style("opacity", "0.5")
      .exit()
        
  canvas.append("g").selectAll("rect")
      .data(greenBins)
      .enter()
      .append("rect")
        .attr("x", 1)
        .attr("transform", function(d) { return "translate(" + xScale(d.x0) + "," + yScale(d.length) + ")"; })
        .attr("width", function(d) { return xScale(d.x1) - xScale(d.x0) -1 ; })
        .attr("height", function(d) { return height - yScale(d.length); })
        .style("fill", "#33cc33")
        .style("opacity", "0.5")
        
  canvas.append("g").selectAll("rect")
      .data(redBins)
      .enter()
      .append("rect")
        .attr("x", 1)
        .attr("transform", function(d) { return "translate(" + xScale(d.x0) + "," + yScale(d.length) + ")"; })
        .attr("width", function(d) { return xScale(d.x1) - xScale(d.x0) -1 ; })
        .attr("height", function(d) { return height - yScale(d.length); })
        .style("fill", "#cc3300")
        .style("opacity", "0.5")
  } else {
          canvas.append("g").selectAll("rect")
      .data(bins)
      .enter()
      .append("rect")
        .attr("x", 1)
        .attr("transform", function(d) { return "translate(" + xScale(d.x0) + "," + yScale(d.length) + ")"; })
        .attr("width", function(d) { return xScale(d.x1) - xScale(d.x0) -1 ; })
        .attr("height", function(d) { return height - yScale(d.length); })
        .style("fill", "#383428")
        .style("opacity", "1")
      .exit()
  }      
  var title = svg.append("text")
    .attr("class", "title")
    .attr("x", 0)
    .attr("y", 40)
    .style("font-size", "30px")
    .style("fill", "#333")
    .style("text-anchor", "start")
    .text("Histogram");
    
  var subtitle = svg.append("text")
    .attr("class", "subtitle")
    .attr("x", 0)
    .attr("y", 60)
    .style("font-size", "14px")
    .style("fill", "#333")
    .style("text-anchor", "start")
    .text("...divide by colors works best with 2 colors at most");
};

svg.selectAll("*").remove();
render(data);
