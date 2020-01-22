// group the data: I want to draw one line per group
var margin = {top: 60, right: 30, bottom: 30, left: 30},
    width = 400 - margin.left - margin.right,
    height = 400 - margin.top - margin.bottom;
    
svg.selectAll('.everything').remove()
var svg1 = svg.append("g")
              .attr("transform",
                    "translate(" + margin.left + "," + margin.top + ")")
              .attr('class', 'everything');
var sumstat = d3.nest() // nest function allows to group the calculation per level of a factor
                .key(function(d) { return d['dragon_colour'];})
                .entries(data);

// Add X axis
var x = d3.scaleLinear()
          .domain(d3.extent(data, function(d) { return d.Year; }))
          .range([ 0, width ]);
svg1.append("g")
    .attr("transform", "translate(0," + height + ")")
    .call(d3.axisBottom(x).tickFormat(d3.format('d')));

// Add X label
svg1.append("text")
    .attr("text-anchor", "middle")
    .attr("x", width/2)
    .attr("y", height + margin.top)
    .attr('font-size', '16px')
    .text("Year");

// Add Y axis
var y = d3.scaleLinear()
          .domain([0, d3.max(data, function(d) { return +d.Population; })])
          .range([ height, 0 ]);
svg1.append("g")
    .call(d3.axisLeft(y));
// add the Y gridlines

svg1.append("g")
    .attr("class", "Ygrid")
    .call(make_y_gridlines()
        .tickSize(-width)
        .tickFormat("")
    );
function make_y_gridlines() {
  return d3.axisLeft(y)
    .ticks();
}

// main title
svg1.append("text")
   .attr("text-anchor", "middle")
   .attr("y", -20)
   .attr("x", height/2)
   .attr('font-size', '20px')
   .text("Dragon Population");

// color palette
var res = sumstat.map(function(d){ return d.key }); // list of group names
var color = d3.scaleOrdinal()
              .domain(res)
              .range(res);

// This allows to find the closest X index of the mouse:
var bisect = d3.bisector(function(d) { return d.Year; }).left;

// Create the circles that travel along the curves of chart
var focus = svg1
  .selectAll('.circles')
  .data(res)
  .enter()
  .append('g')
  .attr('class', 'circles')
  .append('circle')
    .attr("stroke", color)
    .style("opacity", 0);
    
// Draw the line
svg1.selectAll(".line")
    .data(sumstat)
    .enter()
    .append("path")
      .attr("fill", "none")
      .attr("stroke", function(d, i){ return color(d.key) })
      .attr("stroke-width", 2)
      .attr("d", function(d){
        return d3.line()
          .x(function(d) { return x(d.Year); })
          .y(function(d) { return y(+d.Population); })
          (d.values);
      });
// Create a rect on top of the svg area: this rectangle recovers mouse position
  svg1
    .append('rect')
    .style("fill", "none")
    .style("pointer-events", "all")
    .attr('width', width)
    .attr('height', height)
    .on('mouseover', mouseover)
    .on('mousemove', mousemove)
    .on('mouseout', mouseout);      
      // What happens when the mouse move -> show the annotations at the right positions.
  function mouseover() {
    focus.style("opacity", 1);
    focusText.style("opacity",1);
    yearText.style("opacity", 1)
  }

  function mousemove() {
    // recover coordinate we need
    var x0 = x.invert(d3.mouse(this)[0]);
    var j = bisect(data, x0, 1);
    selectedYear = data[j].Year;
    focus
      .attr("cx", x(selectedYear))
      .attr("cy", function(d){
        var filteredData = data.filter(d1 => d1.Year == selectedYear && d1.dragon_colour == d)
      return y(filteredData[0].Population);
      });
    focusText
      .html(function(d) {
        var filteredData = data.filter(d1 => d1.Year == selectedYear && d1.dragon_colour == d)
        return d + " population:" + filteredData[0].Population});
        /*
      .attr("x", x(selectedYear+15))
      .attr("y", function(d){
        var filteredData = data.filter(d1 => d1.Year == selectedYear && d1.dragon_colour == d)
      return y(filteredData[0].Population);
      });*/
      yearText
        .html("Year: " + selectedYear)
    }
  function mouseout() {
    focus.style("opacity", 0)
    focusText.style("opacity", 0)
    yearText.style("opacity", 0)
  }
// Legend
var legendRectSize = 18;
var legendSpacing = 4;
var legend = svg1.selectAll('.legend')
                  .data(res)
                  .enter()
                  .append('g')
                  .attr('class', 'legend')
                  .attr('transform', function(d, i) {
                    var localHeight = legendRectSize + legendSpacing;
                    var offset = localHeight * res.length / 2;
                    var horz = -2 * legendRectSize;
                    var vert = i * localHeight - offset;
                    return 'translate(' + (horz + width + margin.left + margin.right) + ',' + (vert + height / 3) + ')';
                  });

legend.append('rect')
      .attr('width', legendRectSize)
      .attr('height', legendRectSize)
      .style('fill', color)
      .style('stroke', color);
legend.append('text')
      .attr('x', legendRectSize + legendSpacing)
      .attr('y', legendRectSize - legendSpacing)
      .text(function(d) { return d + " dragons"; });
      
      // Create the text that travels along the curve of chart
var textHeight = 18;
var focusText = svg1
  .selectAll('.texts')
  .data(res)
  .enter()
  .append('g')
  .attr('class', 'texts')
  .attr('transform', function(d, i) {
                  var offset = textHeight * res.length / 2;
                  var horz = -2 * textHeight;
                  var vert = (i + 1) * textHeight - offset;
                  return 'translate(' + (horz + width + margin.left + margin.right) + ',' + (vert + height / 3 * 2) + ')';
                })
    .append('text')
      .style("opacity", 1)
      .attr("text-anchor", "left")
      .attr("alignment-baseline", "middle")
      .attr("fill", color)
      .attr("x", 0)
      .attr("y", 0);
var yearText = svg1
      .append('text')
      .style("opacity", 0)
      .attr("font-weight", "bold")
      .attr("text-anchor", "left")
      .attr("alignment-baseline", "middle")
      .attr("x", -2 * textHeight + width + margin.left + margin.right)
      .attr("y", - textHeight * res.length / 2 + height / 3 * 2);