svg.selectAll("circle").remove();
svg.selectAll("g").remove();


var margin = {top: 10, right: 30, bottom: 30, left: 60},


dane = data;
//tło
svg
  .append("rect")
    .attr("x", 0)
    .attr("y",0)
    .attr("height", height)
    .attr("width", width - 20)
    .style("fill", "EBEBEB");

// tworzenie osi x
var x = d3.scaleLinear()
  .domain([6,24])
  .range([30, width-80]);
r2d3.svg.append("g")
.attr("transform", "translate(30, 320)")
.call(d3.axisBottom(x));

svg.append("text")
    .attr("text-anchor", "end")
    .attr("x", 0.5*width + 80)
    .attr("y", height - margin.top)
    .text("Mass of the dragons [in 000s pounds]");

    
// tworzenie osi y
var y = d3.scaleLinear()
  .domain([20, 80])
  .range([320, 10]);
r2d3.svg.append("g")
  .attr("transform", "translate(60, 0)")
  .call(d3.axisLeft(y));

svg.append("text")
    .attr("text-anchor", "end")
    .attr("y", 25)
    .attr("x", -100)
    .attr("transform", "rotate(-90)")
    .text("Height of the dragons [in ells]");
   
    
svg.append('g')
    .selectAll("dot")
    .data(data)
    .enter()
    .append("circle")
    .attr("class", function (d) { return "dot " + d.colour} )
      .attr("cx", function (d) { return x(d.weight); } )
      .attr("cy", function (d) { return y(d.height); } )
      .attr("r", 1.5)
      .attr("transform", "translate(30, 0)")
      .style("fill", function (d) { return d.colour});