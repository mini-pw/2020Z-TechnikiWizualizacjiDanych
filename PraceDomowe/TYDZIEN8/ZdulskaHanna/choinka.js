svg.selectAll('*').remove();
var x = d3.scaleLinear().range([0, 500]);
var y = d3.scaleLinear().range([400, 0]);
 
x.domain([0, 100]);
y.domain([0, 100]);
  
var poly = [{"x":50, "y":100},
        {"x":30,"y":75},
        {"x":38,"y":75},
        {"x":20,"y":45},
        {"x":28,"y":45},
        {"x":10,"y":10},
        {"x":45,"y":10},
        {"x":45,"y":0},
        {"x":55,"y":0},
        {"x":55,"y":10},
        {"x":90,"y":10},
        {"x":72,"y":45},
        {"x":80,"y":45},
        {"x":62,"y":75},
        {"x":70,"y":75}];
        
        
var poly2 = [{"x":45,"y":10},
        {"x":45,"y":0},
        {"x":55,"y":0},
        {"x":55,"y":10}]
  
svg.selectAll("polygon")
  .data([poly])
  .enter().append("polygon")
  .attr("points",function(d) { return d.map(function(d) {return [x(d.x),y(d.y)].join(","); }).join(" ");})
  .data(data)
  .attr("fill", function(d){return d.col})
  
  svg
  .data([poly2])
  .append("polygon")
  .attr("points",function(d) { return d.map(function(d) {return [x(d.x),y(d.y)].join(","); }).join(" ");})
  .attr("fill", '#69331D')
  
  if(data[0].prog == "Stały"){
  svg.selectAll('#lancuch')
  .data(data)
  .enter()
  .append("circle")
  .attr("r", function(d){return d.rl})
  .attr("cx", function(d){return x(d.lx)})
  .attr("cy", function(d){return y(d.ly)})
  .attr('fill', function(d){return d.coll})
  }
  
  if(data[0].prog == "Migoczący 1"){
  svg.selectAll('#lancuch')
  .data(data)
  .enter()
  .append("circle")
  .attr("r", function(d){return d.rl})
  .attr("cx", function(d){return x(d.lx)})
  .attr("cy", function(d){return y(d.ly)})
  .attr('fill', function(d){return d.coll})
  .transition()
  .duration(function(d){return d.freq})
    .on("start", function repeat() {
        d3.active(this)
              .style("fill", "black")
              .transition()
              .style("fill", function(d){return d.coll})
              .transition()
              .on("start", repeat);
      });
  }
  
  if(data[0].prog == "Migoczący 2"){
  svg.selectAll('#lancuch')
  .data(data)
  .enter()
  .append("circle")
  .attr("r", function(d){return d.rl})
  .attr("cx", function(d){return x(d.lx)})
  .attr("cy", function(d){return y(d.ly)})
  .attr('fill', function(d){return d.coll})
  .transition()
    .delay(function(d, i) { return i  * d.freq / 10 ; })
    .on("start", function repeat() {
        d3.active(this)
            .style("fill", "red")
          .transition()
            .style("fill", "green")
          .transition()
            .style("fill", "blue")
          .transition()
            .style("fill", "yellow")
          .transition()
            .on("start", repeat);
      });
  }

  
  
  svg.selectAll('#bombki').
  data(data)
  .enter()
  .append("circle")
  .attr("r", function(d){return d.r}) 
  .attr("cx", function(d){return x(d.bombkx)})
  .attr("cy", function(d){return y(d.bombky)})
  .attr('fill', function(d){return d.colb})