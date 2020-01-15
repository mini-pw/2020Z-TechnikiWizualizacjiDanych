var barwidth = Math.floor(width / data.length);

var bars = r2d3.svg.selectAll('rect').data(r2d3.data);
var textlabels = r2d3.svg.selectAll('text.value').data(r2d3.data);
var axislabels = r2d3.svg.selectAll('text.axis').data(r2d3.data);


r2d3.data.forEach(function(d) {
    d.value = +d.value;
  });





bars.enter().append('rect')
    .attr('x', function(d, i) { return i * barwidth ; })
    .attr('fill','white')
    .transition().duration(600)
    .attr('height', function(d) { return d.value/100* height; })
    .attr('width', barwidth*0.8)
    .style("opacity", 1.0)
    .attr('y', function(d) { return height - d.value/100* height - 0.1*height;})
    .attr('fill', function(d) { return d.color; });

bars.transition()
    .duration(500)
    .attr("height", function(d) { return d.value/100 * height ; })
    .attr('x', function(d, i) { return i * barwidth; })
    .attr('y', function(d) { return height - d.value/100* height - 0.1*height;})
    .attr('width', barwidth*0.8)
    .attr('fill', function(d) { return d.color});

bars.exit().transition().duration(600)
    .attr('y',1000)
    .attr('fill','white')
    .remove();


textlabels.enter().append("text").attr("class", "value")
    .attr('x', function(d, i) { return (i) * barwidth+0.1*barwidth; })
    .transition().duration(600)
    .attr('y', function(d) { return height - d.value/100*height + (0.12*barwidth)**1.2-barwidth*0.3-0.1*height;})
    .attr('fill', "#111")
    .attr('font-face','bold')
    .text(function(d) { return d.value.toString().concat("%"); })
    .attr("font-size", ((0.12*barwidth)**1.2).toString().concat("px"));

textlabels.transition()
    .duration(500)
    .attr('x', function(d, i) { return (i) * barwidth+0.1*barwidth; })
    .attr('y', function(d) { return height - d.value/100*height + (0.12*barwidth)**1.2-barwidth*0.3-0.1*height;})
    .attr("font-size", ((0.12*barwidth)**1.2).toString().concat("px"))
    .text(function(d) { return d.value.toString().concat("%"); });

textlabels.exit().transition().duration(600)
    .attr('y',1000)
    .style("opacity", 0)
    .remove();

    
axislabels.enter().append("text").attr("class", "axis")
.attr('x', function(d, i) { return (i) * barwidth+0.2*barwidth; })
.transition().duration(600)
.attr('y', height-10)
.text(function(d) { return d.lok_sabha.split(" ",1);})
.attr("font-size", ((0.12*barwidth)**1.2).toString().concat("px"));

axislabels.transition()
.duration(500)
.attr('x', function(d, i) { return (i) * barwidth+0.2*barwidth; })
.attr('y', height-10)
.attr("font-size", ((0.12*barwidth)**1.2).toString().concat("px"))
.text(function(d) { return d.lok_sabha.split(" ",1);})

axislabels.exit().transition().duration(600)
.attr('y',1000)
.style("opacity", 0)
.remove();


/*




*/