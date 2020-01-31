
var barWidth = Math.floor(width / data.length);

var bars = r2d3.svg.selectAll('rect')
.data(r2d3.data);

var labels = r2d3.svg.selectAll("text").data(r2d3.data);


var y = d3.scaleLinear()
.range([height, 0]);
//tylko x potrzebujê, nie wiem jak tam wstawiæ tekst???
  
  
  
  //próba dodania osi x, nie dzia³a (nie wiem jak inaczej ni¿ select All text
                                     //var x = d3.scaleBand()
                                     //  .range([ 0, width ])
                                     //  .domain(data.map(function(d) { return d.description; }))
                                     //  .padding(0.2);
                                     
                                     //r2d3.svg.append("g")
                                     //  .attr("transform", "translate(0," + height + ")")
                                     //  .call(d3.axisBottom(x))
                                     //  .selectAll("text")
                                     //    .attr("transform", "translate(-10,0)rotate(-45)")
                                     //    .style("text-anchor", "end");
                                     //
                                       
                                       
                                       bars.enter().append('rect')
                                     .attr('x', function(d, i) { return i * barWidth; })
                                     .attr('y', function(d) { return height - d.number/600* height; })
                                     .attr('height', function(d) { return d.number/600* height; })
                                     .attr('width', barWidth)
                                     .attr('fill', function(d) { return d.color; });
                                     
                                     labels
                                     .enter().append("text")
                                     .attr('y', function(d) { return height - d.number/600* height - 10; })
                                     .attr('x', function(d, i) {  return (0.0001275*(data.length-30)*(data.length-30) + 0.3 + i) * barWidth; })
                                     .text(function(d) { return d.number.toString(); })
                                     .attr("font-size", (0.03*(data.length-30)*(data.length-30)).toString().concat("px"));
                                     
                                     
                                     labels.exit().remove();
                                     bars.exit().remove();
                                     
                                     
                                     bars.transition()
                                     .duration(100)
                                     .attr('x', function(d, i) { return i * barWidth; })
                                     .attr('y', function(d) { return height - d.number/600*height; })
                                     .attr("height", function(d) { return d.number/600 * height; })
                                     .attr('width', barWidth)
                                     .attr('fill', function(d) { return d.color});
                                     
                                     labels.transition()
                                     .duration(100)
                                     .attr('y', function(d) { return height - d.number/600* height - 10 })
                                     .attr('x', function(d, i) { return (0.0001275*(data.length-30)*(data.length-30) + 0.3 + i) * barWidth; })
                                     .attr("font-size", (0.03*(data.length-30)*(data.length-30)).toString().concat("px"))
                                     .text(function(d) { return d.number.toString(); });
                                     
                                     
                                     