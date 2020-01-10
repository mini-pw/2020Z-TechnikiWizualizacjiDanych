d3.selectAll("svg").remove();

// set the dimensions and margins of the graph
var margin = {top: 10, right: 20, bottom: 220, left: 200},
    width = 950 - margin.left - margin.right,
    height = 500 - margin.top - margin.bottom;

// append the svg object to the body of the page
var svg = d3.selectAll("body")
    .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform",
          "translate(" + margin.left + "," + margin.top + ")");

// X axis
var x = d3.scaleBand()
  .range([ 0, width ])
  .domain(data.map(function(d) { return d.Question; }))
  .padding(0.2);
svg.append("g")
  .attr("transform", "translate(0," + height + ")")
  .call(d3.axisBottom(x))
  .selectAll("text")
    .attr("transform", "translate(-10,0)rotate(-45)")
    .style("text-anchor", "end");

// Add Y axis
var y = d3.scaleLinear()
  .domain([0, 100])
  .range([ height, 0]);
svg.append("g")
  .call(d3.axisLeft(y));

// Bars
svg.selectAll("mybar")
  .data(r2d3.data)
  .enter()
  .append("rect")
    .attr("x", function(d) { return x(d.Question); })
    .attr("y", function(d) { return y(d.Value); })
    .attr("width", x.bandwidth())
    .attr("height", function(d) { return height - y(d.Value); })
    .attr("fill", function(d){ return d.col});
    
//Title
svg.append("text")
    .attr("x", (width / 2))             
    .attr("y", 0 + (margin.top))
    .attr("text-anchor", "middle")  
    .style("font-size", "16px") 
    .text("Have you ever done any of the following while driving with your children?");
