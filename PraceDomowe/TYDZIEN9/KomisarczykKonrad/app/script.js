


r2d3.onRender(function(data, svg, width, height, options) {
  //Parsing data
  data.forEach(function(d) {
    d.date = d3.timeParse("%Y%m")(d.date);
    d.temp = +d.temp;
  });
  
  //removing previous
  svg.selectAll("path").remove();
  svg.selectAll("g").remove();
  
  //adding margin
  var margin = {top: 20, right: 40, bottom: 20, left: 40};
  
  var svg2 = svg.append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
    
  
  //Defining x scale
  var x = d3.scaleTime()
      .domain(d3.extent(data, function(d) { return d.date; }))
      .range([0, width - margin.right - margin.left]);
  
  //Defining y scale   
  var y = d3.scaleLinear()
    .domain([d3.min(data, function(d) { return d.temp; }), d3.max(data, function(d) { return d.temp; })])
    .range([height - margin.top - margin.bottom, 0]).nice();
  
    
  // adding area
  var paths = svg2
    .selectAll("path").data([]);
    
  svg2.append("path")
      .datum(data)
      .attr("fill", "#78c5ef")
      .attr("stroke", "#51a0d5")
      .attr("stroke-width", 1)
      .attr("d", d3.area()
        .x(function(d) { return x(d.date) })
        .y0(y(0))
        .y1(function(d) { return y(d.temp) })
        );
       
  // adding axes      
  var axes = svg2.selectAll("g");
  
  // x axis
  svg2.append("g")
      .attr("class", "x axis")
      .attr("transform", "translate(0," + y(0) + ")")
      .call(d3.axisBottom(x));
  
  // y axis    
  svg2.append("g")
      .attr("class", "y axis")
      .call(d3.axisLeft(y));
});
