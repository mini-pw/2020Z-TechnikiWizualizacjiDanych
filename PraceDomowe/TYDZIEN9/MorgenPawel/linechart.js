//na podstawie: https://www.d3-graph-gallery.com/graph/line_several_group.html

// group the data: I want to draw one line per group
var margin = {top: 60, right: 30, bottom: 30, left: 30},
    width = 460 - margin.left - margin.right,
    height = 400 - margin.top - margin.bottom;
    
svg.selectAll('.everything').remove()
var svg1 = svg.append("g")
              .attr("transform",
                    "translate(" + margin.left + "," + margin.top + ")")
              .attr('class', 'everything');
var sumstat = d3.nest() // nest function allows to group the calculation per level of a factor
                .key(function(d) { return d['Country.Name'];})
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
          .domain([0, d3.max(data, function(d) { return +d.Value; })])
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
   .attr("y", - 40)
   .attr("x", height/2)
   .attr('font-size', '20px')
   .text("Gross Domestic Product");

// subtitle
svg1.append("text")
    .attr("text-anchor", "middle")
    .attr("y", - 10)
    .attr("x", height/2)
    .attr('font-size', '16px')
    .text("GDP in constant 2010 trillions of US$");

// color palette
var res = sumstat.map(function(d){ return d.key }); // list of group names
var color = d3.scaleOrdinal()
              .domain(res)
              .range(['#e41a1c','#377eb8','#4daf4a','#984ea3','#ff7f00','#ffff33','#a65628','#f781bf','#999999']);
  //var color = d3.scaleOrdinal(d3.schemeCategory20b).domain(res);

// Draw the line
svg1.selectAll(".line")
    .data(sumstat)
    .enter()
    .append("path")
      .attr("fill", "none")
      .attr("stroke", function(d, i){ return color(d.key) })
      .attr("stroke-width", 1.5)
      .attr("d", function(d){
        return d3.line()
          .x(function(d) { return x(d.Year); })
          .y(function(d) { return y(+d.Value); })
          (d.values);
      });
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
                    return 'translate(' + (horz + width + margin.left + margin.right) + ',' + (vert + height / 2) + ')';
                  });

legend.append('rect')
      .attr('width', legendRectSize)
      .attr('height', legendRectSize)
      .style('fill', color)
      .style('stroke', color);
legend.append('text')
      .attr('x', legendRectSize + legendSpacing)
      .attr('y', legendRectSize - legendSpacing)
      .text(function(d) { return d; });