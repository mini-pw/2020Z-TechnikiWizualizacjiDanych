d3.selectAll("svg").remove();
d3.selectAll(".html-widget-output").remove();

var margin = {top: 50, right: 50, bottom: 50, left: 50},
    width = width - margin.left - margin.right,
    height = height - margin.top - margin.bottom

var svg = d3.selectAll("body")
  .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform",
          "translate(" + margin.left + "," + margin.top + ")");

var x = d3.scaleLinear()
  .domain(d3.extent(data.map(function(d) { return d[data[0].parameter1]; })))
  .range([ 0, width ]);
svg.append("g")
  .attr("transform", "translate(0," + height + ")")
  .call(d3.axisBottom(x));

var y = d3.scaleLinear()
  .range([ height, 0 ])
  .domain(d3.extent(data.map(function(d) { return d[data[0].parameter2]; })))
svg.append("g")
  .call(d3.axisLeft(y))

svg.append('g')
  .selectAll("dot")
  .data(r2d3.data)
  .enter()
  .append("circle")
    .attr("cx", function (d) { return x(d[data[0].parameter1]); } )
    .attr("cy", function (d) { return y(d[data[0].parameter2]); } )
    .attr("r", data[0].dotSize)
    .style("fill", function(d) {
      if (data[0].defaultColor) {
        return d.colour;
      } else {
        return data[0].dotColor;
      }
      })