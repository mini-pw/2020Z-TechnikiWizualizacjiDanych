

var h = data[0].height/2;



svg.append("polygon")
  .transition()
  .duration(1000)
  .attr('points', '200,'+(160-h)+' '+(100+100/340*(150-h)) +',350 '+(300-100/340*(150-h))+',350')
  .style('fill', data[0].treeColour)
  .transition()
  .duration(2000)
  .remove();
  
svg.append('rect')
  .attr("x", 180 - 0.05*h + 7.5)
  .attr("y", 350)
  .attr("width", 0.1*h + 25)
  .attr("height", 15/100*h + 37.5)
  .transition()
  .duration(1000)
  .style("fill", "#8B4513")
  .transition()
  .duration(2000)
  .remove()
 
svg.append('path')
  .attr('d', d3.symbol()
              .type(d3.symbolStar)
              .size(200))
  .attr('stroke', 'none')
  .attr('transform', 'translate(200,'+(160-h)+')' )
  .transition()
  .duration(1000)
  .style('fill', data[0].starColour)
  .transition()
  .duration(2000)
  .remove();


var cd = d3.range(data[0].numberOfBalls).map(function() {return {
  y: Math.random()*200 + 80 - h*0.8 + 100,
  r1: Math.random(),
  r2: Math.random(),
  col:      "rgb(" + parseInt(Math.random() * 255) +
            "," + 
            parseInt(Math.random() * 255) + 
            "," + 
            parseInt(Math.random() * 255) +
            ")"
};})


svg.selectAll("circle")
.data(cd)
.enter()
.append('circle')
	    .attr("cy", function(d) {return d.y})
	    .attr("cx", function(d)
	    {return ((d.r1 - d.r2)*110*(1/280*d.y - 220/500) + 200)})
	   
	    .attr("fill",function(d) {return d.col})
	    .attr("r",5)
	    .transition()
	    .duration(3000)
	    .remove();
