//points
var points = r2d3.svg.selectAll("circle")
  .data(r2d3.data);

points.enter()
  .append("circle")
  .attr("cx", function (d) { return (d.height - 29) / (77 - 29) *300 +100; })
  .attr("cy", function (d) { return 300 - (d.weight - 7) / (23 -7) *300; })
  .attr("r", 2)
  .style("fill", "grey");
  
points.exit().remove();

//axis
svg.append("rect")
  .attr("x", 98)
  .attr("y",0)
  .attr("width",2)
  .attr("height",302)
  .style("fill", "black");
  
svg.append("text")
  .attr("x", 30)
  .attr("y", 150)
  .text("weight")
  .style("fill", "black");
  
svg.append("rect")
  .attr("x", 100)
  .attr("y",300)
  .attr("width",300)
  .attr("height",2)
  .style("fill", "black");
  
svg.append("text")
  .attr("x", 250)
  .attr("y", 330)
  .text("height")
  .style("fill", "black");
  
//y axis labeles
svg
  .append("rect")
  .attr("x", 95)
  .attr("y", 300 - (10 - 7) / (23 -7) *300)
  .attr("width",8)
  .attr("height",2)
  .style("fill", "black");
  
svg.append("text")
  .attr("x", 77)
  .attr("y", 300 - (10 - 7) / (23 -7) *300 + 5)
  .text("10")
  .style("fill", "black");
  
svg
  .append("rect")
  .attr("x", 95)
  .attr("y", 300 - (15 - 7) / (23 -7) *300)
  .attr("width",8)
  .attr("height",2)
  .style("fill", "black");
  
svg.append("text")
  .attr("x", 77)
  .attr("y", 300 - (15 - 7) / (23 -7) *300 + 5)
  .text("15")
  .style("fill", "black");
  
svg
  .append("rect")
  .attr("x", 95)
  .attr("y", 300 - (20 - 7) / (23 -7) *300)
  .attr("width",8)
  .attr("height",2)
  .style("fill", "black");
  
svg.append("text")
  .attr("x", 77)
  .attr("y", 300 - (20 - 7) / (23 -7) *300 + 5)
  .text("20")
  .style("fill", "black");
  
//xaxis labels
svg
  .append("rect")
  .attr("x", (40 - 29) / (77 - 29) *300 +100)
  .attr("y", 297)
  .attr("width",2)
  .attr("height",8)
  .style("fill", "black");
  
svg.append("text")
  .attr("x", (40 - 29) / (77 - 29) *300 +100 - 7)
  .attr("y", 317)
  .text("40")
  .style("fill", "black");

svg
  .append("rect")
  .attr("x", (55 - 29) / (77 - 29) *300 +100 )
  .attr("y", 297)
  .attr("width",2)
  .attr("height",8)
  .style("fill", "black");
  
svg.append("text")
  .attr("x", (55 - 29) / (77 - 29) *300 +100 - 7)
  .attr("y", 317)
  .text("55")
  .style("fill", "black");
  
svg
  .append("rect")
  .attr("x", (70 - 29) / (77 - 29) *300 +100)
  .attr("y", 297)
  .attr("width",2)
  .attr("height",8)
  .style("fill", "black");
  
svg.append("text")
  .attr("x", (70 - 29) / (77 - 29) *300 +100 - 7)
  .attr("y", 317)
  .text("70")
  .style("fill", "black");

