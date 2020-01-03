//preview r2d3 data=c(0.3, 0.6, 0.8, 0.95, 0.40, 0.20)


var barwidth = Math.floor(width / data.length);

var bars = r2d3.svg.selectAll('rect')
    .data(r2d3.data);
    
var textlabels = r2d3.svg.selectAll("text").data(r2d3.data);

var x = d3.scaleLinear()
    .range([0, width]);

var y = d3.scaleLinear()
    .range([height, 0]);

/*var color = ;*/

var xAxis = d3.axisBottom(x);

var yAxis = d3.axisLeft(y);

var legendtext = r2d3.svg.selectAll("legendtext")
      //.data(d3.map(r2d3.data, function(d){ return d.variable; }).keys());
      .data(['man', 'woman']);
var legendcolor = r2d3.svg.selectAll(".legendcolor")
      .data(d3.scaleOrdinal(["steelblue", "green"]).domain());
       

r2d3.data.forEach(function(d) {
    d.value = +d.value;
  });
  
/*x.domain(data.length);
y.domain(d3.extent(data, function(d) { return d.value; })).nice();

r2d3.svg.append("g")
      .attr("class", "x axis")
      .call(xAxis)
      .append("text")
      .attr("class", "label")
      .attr("x", width-30)
      .attr("y", 29)
      .style("text-anchor", "end")
      .text("Sepal Width (cm)");  
  
  
  r2d3.svg.append("g")
      .attr("class", "y axis")
      .call(yAxis)
      .append("text")*/
  

bars.enter().append('rect')
    .attr('height', function(d) { return d.value/100* height; })
    .attr('width', barwidth)
    .attr('x', function(d, i) { return i * barwidth; })
    .attr('y', function(d) { return height - d.value/100* height; })
    .attr('fill', function(d) { return d.color; });
    
textlabels
    .enter().append("text")
    .attr('y', function(d) { return height - d.value/100* height + 20; })
    .attr('x', function(d, i) { return (0.2 + i) * barwidth; })
    .text(function(d) { return d.value.toString().concat("%"); })
    .attr("font-size", (0.0255*(data.length-30)*(data.length-30)+4).toString().concat("px"));


/*legendcolor.enter().append("g")
    .attr("class", "legendcolor")
    .attr("transform", function(d, i) { return "translate(0," + i * 20 + ")"; })
    .append("rect")
    .attr("x", 63)
    .attr("y", 15)
    .attr("width", 10)
    .attr("height", 10)
    .style("fill", function(d) { return d; });

legendtext.enter().append("g")
    .attr("class", "legendtext")
    .attr("transform", function(d, i) { return "translate(0," + i * 20 + ")"; })
    .append("text")
    .attr("x", 50)
    .attr("y", 20)
    .attr("dy", ".35em")
    .style("text-anchor", 'end')
    .text(function(d) { return d;});*/
    
textlabels.exit().remove();
bars.exit().remove();
/*legendtext.exit().remove();*/
/*legendcolor.exit().remove();*/

bars.transition()
  .duration(150)
  .attr("height", function(d) { return d.value/100 * height; })
  .attr('x', function(d, i) { return i * barwidth; })
  .attr('y', function(d) { return height - d.value/100* height; })
  .attr('width', barwidth)
  .attr('fill', function(d) { return d.color});
  
textlabels.transition()
    .duration(150)
    .attr('y', function(d) { return height - d.value/100* height + 20; })
    .attr('x', function(d, i) { return (0.0001275*(data.length-30)*(data.length-30) + 0.2 + i) * barwidth; })
    //.attr('x', function(d, i) { return i * barwidth})
    .attr("font-size", (0.0255*(data.length-30)*(data.length-30)+4).toString().concat("px"))
    .text(function(d) { return d.value.toString().concat("%"); });
    
    
/*legendcolor.enter().append("g")
    .attr("class", "legendcolor")
    .attr("transform", function(d, i) { return "translate(0," + i * 20 + ")"; })
    .append("rect")
    .attr("x", 63)
    .attr("y", 15)
    .attr("width", 10)
    .attr("height", 10)
    .style("fill", function(d) {return d; });

legendtext.enter().append("g")
    .attr("class", "legendtext")
    .attr("transform", function(d, i) { return "translate(0," + i * 20 + ")"; })
    .append("text")
    .attr("x", 50)
    .attr("y", 20)
    .attr("dy", ".35em")
    .style("text-anchor", 'end')
    .text(function(d) { return d;});*/

    
    
    


  
