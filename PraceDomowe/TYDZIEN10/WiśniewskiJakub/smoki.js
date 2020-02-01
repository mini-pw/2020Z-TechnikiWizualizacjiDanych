svg.selectAll("g").remove();
svg.selectAll(".dot").remove();
svg.selectAll("text").remove();


var xAxis = data[0].X_axis ;
var yAxis = data[0].Y_axis ;
var dragonColors = data[0].dragon_colors ;
var xMax = data[0].X_max;
var yMax = data[0].Y_max;
var xMin = data[0].X_min;
var yMin = data[0].Y_min;

var margin = {top: 0, right: width / 24, bottom: height / 30, left: 0},
    width = width - margin.left - margin.right,
    height = height - margin.top - margin.bottom,
    barWidth = Math.floor(width / 19) - 1;

var x = d3.scaleLinear()
.range([0, width-300])
.domain([xMin, xMax])



r2d3.svg.append("g")
.attr("transform", "translate("+100+"," + 320 + ")")
.call(d3.axisBottom(x))
.transition()
.duration(3000)
.selectAll("text")
.attr("transform", "translate(0,0)");


    

// oś y
var y = d3.scaleLinear()
  .domain([yMin, yMax])
  .range([320,10]);
  
r2d3.svg.append("g")
  .attr("transform", "translate(100, 0)")
  .call(d3.axisLeft(y));
  

function ygrid() {
  return d3.axisLeft(y)
  .ticks(15);
}

svg.append("g")
.attr("class", "grid")
.attr("transform", "translate(100, 0)")
.call(ygrid()
.tickSize(-(width - 300) )
.tickFormat(""));

// nie chcemy czarnego
svg.selectAll("line")
.style("stroke", "lightgrey");

// opis osi Y
svg.append("text")
.attr("class", "title")
.attr("transform", "rotate(-90)")
.attr("y", 40)
.attr("x", -170)
.style("text-anchor", "middle")
.style("font-size", "20px")
.text(yAxis);

svg.append("text")
.attr("class", "title")
.attr("y", 350)
.attr("x", 850)
.style("text-anchor", "middle")
.style("font-size", "20px")
.text(xAxis);



  var div = d3.select("body").append("div")	
    .attr("class", "tooltip")				
    .style("opacity", 0);



svg.selectAll(".dot")
      .data(data)
      .enter()
      .append("circle")
      .attr("class", "dot")
      .attr("r", 3.5)
      .attr("cx", function(d) { return x(d[xAxis])+100; })
      .attr("cy", function(d) { return 320; })
      .style("fill", function(d) {return d.colour} )
      .style("stroke", "black")
      .on("mouseover", function(d) {
       div.transition()
         .duration(200)
         .style("opacity", .9);
       div.html("<b>" +yAxis +": " +  d[yAxis] + "</b><br/>" +"<b>" 
                        + xAxis + " :" + d[xAxis] + "</b><br/>")
         .style("left", (d3.event.pageX) + "px")
         .style("top", (d3.event.pageY - 28) + "px");
       })
     .on("mouseout", function(d) {
       div.transition()
         .duration(500)
         .style("opacity", 0);
       })
       .transition()
      .duration(function(d) {return 500})
      .delay(function(d) {return 500  *Math.random() } )
      .attr("cx", function(d) { return x(d[xAxis])+100 ; })
      .attr("cy", function(d) { return y(d[yAxis]); })
      
svg.append('image')
    .attr('xlink:href', 'https://i.ytimg.com/vi/2FD7Krmfawo/maxresdefault.jpg')
    .attr('width', 200)
    .attr('height', 200)
    .attr('x',1680)
    .attr('y',220)
    .style('opacity', 0);
    
if(data[0].beauty === "Naaaah"){
  svg.selectAll("image")
  .style('opacity', 0)
  
}
else{
  svg.selectAll("image")
  .transition(10000)
  .delay(100)
  .style('opacity', 1)
  .transition(1000)
  .delay(100);
}