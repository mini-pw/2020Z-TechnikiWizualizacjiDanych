var margin = {top: 20, right: 20, bottom: 40, left: 40},
    width = 700 - margin.left - margin.right,
    height = 400 - margin.top - margin.bottom;

var x = d3.scaleLinear().range([0, width]);
var y = d3.scaleLinear().range([height, 0]);
var xAxis = d3.axisBottom(x);
var yAxis = d3.axisLeft(y);
var xTexts = {"height": "height [yd]", "weight": "weight [t]"};
var xText = xTexts[r2d3.data[0].measN];
var yTexts = {"scars": "scars", "number_of_lost_teeth": "lost teeth"};
var yText = "number of " + yTexts[r2d3.data[0].impN];

r2d3.svg.selectAll("*").remove();

r2d3.svg
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom);
    
r2d3.svg.append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
  
r2d3.data.forEach(function(d) {
    d.meas = +d.meas;
    d.imp = +d.imp;
  });

x.domain(d3.extent(r2d3.data, function(d) {return d.meas;})).nice();
y.domain(d3.extent(r2d3.data, function(d) {return d.imp;})).nice();

var punkty = svg.selectAll(".dot")
      .data(r2d3.data);

r2d3.svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis);
    
r2d3.svg.append("text")
    .attr("class", "label")
    .attr("x", width)
    .attr("y", height-6)
    .style("text-anchor", "end")
    .text(xText);
    
r2d3.svg.append("g")
    .attr("class", "y axis")
    .call(yAxis);
    
r2d3.svg.append("text")
    .attr("class", "label")
    .attr("transform", "rotate(-90)")
    .attr("y", 6)
    .attr("dy", ".71em")
    .style("text-anchor", "end")
    .text(yText);

punkty.enter().append("circle")
      .attr("class", "dot")
      .attr("r", 3.5)
      .attr("cx", function(d) {return x(d.meas);})
      .attr("cy", function(d) {return y(d.imp);})
      .style("fill", function(d) {return d.col;});

punkty.exit().remove();