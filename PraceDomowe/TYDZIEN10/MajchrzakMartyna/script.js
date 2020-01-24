svg.selectAll('*').remove();

// set the dimensions and margins of the graph
var margin = {top: 30, right: 30, bottom: 70, left: 60},
    width = 460 - margin.left - margin.right,
    height = 400 - margin.top - margin.bottom;

// append the svg object to the body of the page
svg.attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform",
          "translate(" + margin.left + "," + margin.top + ")");

// X axis
var x = d3.scaleBand()
  .range([ -2, width ])
  .domain(data.map(function(d) { return d.colour; }))
  .padding(0.5);
svg.append("g")
  .attr("transform", "translate(0," + height + ")")
  .call(d3.axisBottom(x))
  .selectAll("text")
    .attr("transform", "translate(-10,0)rotate(-45)")
    .style("text-anchor", "end");

// Add Y axis
var y = d3.scaleLinear()
  .domain([0, 650])
  .range([ height, 0]);
svg.append("g")
  .call(d3.axisLeft(y));
  
// Colours

// Bars
svg.selectAll("mybar")
  .data(data)
  .enter()
  .append("rect")
    .attr("x", function(d) { return x(d.colour); })
    .attr("y", function(d) { return y(d.count); })
    .attr("width", x.bandwidth())
    .attr("height", function(d) { return height - y(d.count); })
    .attr("fill", "#99004C")
    
// text
var totals = svg.selectAll().data(data);
totals.enter().append('text')
.attr('x', function(d) { return x(d.colour)+7; })
.attr('y', function(d, i) { return y(d.count)})
.style('font-family', 'Helvectica')
.text(function(d) {return (Math.round(d.count)).toString(); });