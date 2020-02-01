var barwidth = Math.floor(width / data.length);

var bars = r2d3.svg.selectAll('rect').data(r2d3.data);
var textlabels = r2d3.svg.selectAll('text.value').data(r2d3.data);
var axislabels = r2d3.svg.selectAll('text.axis').data(r2d3.data);




bars.enter().append('rect')
    .attr('x', function(d, i) { return i * barwidth ; })
    .attr('height', function(d) { return d.n/250* height; })
    .attr('width', barwidth*0.8)
    .style("opacity", 1.0)
    .attr('y', function(d) { return height - d.n/250* height - 0.1*height;})
    .attr('fill', 'purple');
    
bars.exit().remove();

bars.transition()
    .duration(500)
    .attr("height", function(d) { return d.n/250* height ; })
    .attr('x', function(d, i) { return i * barwidth; })
    .attr('y', function(d) { return height - d.n/250* height - 0.1*height;})
    .attr('width', barwidth*0.8)
    .attr('fill', "purple");
    
axislabels.enter().append("text")
.attr("class", "axis")
.attr('x', function(d, i) { return (i) * barwidth+0.2*barwidth; })
.attr('y', height-50)
.text(function(d) { return d.scars.toString();})
.attr("font-size", "13px");

axislabels.transition()
.duration(500)
.attr('x', function(d, i) { return (i) * barwidth+0.2*barwidth; })
.attr('y', height-50)
.text(function(d) { return d.scars.toString();})
.attr("font-size", "13px")

axislabels.exit().remove();


textlabels.enter().append("text")
    .attr("class", "value")
    .attr('x', function(d, i) { return (i) * barwidth+0.1*barwidth; })
    .attr('y', function(d) {  return height - d.n/250* height - 100 })
    .attr('fill', "#111")
    .attr('font-face','bold')
    .text(function(d) { return d.n.toString(); })
    .attr("font-size", "10px");

textlabels.transition()
    .duration(500)
    .attr('x', function(d, i) { return (i) * barwidth+0.1*barwidth; })
    .attr('y', function(d) {  return height - d.n/250* height - 100 })
    .attr("font-size", "10px")
    .text(function(d) { return d.n.toString(); });

textlabels.exit().remove();
    
    
    






/*
*/