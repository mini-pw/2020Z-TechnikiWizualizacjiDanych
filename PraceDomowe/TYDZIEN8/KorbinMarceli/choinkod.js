var triangles = r2d3.svg.selectAll("polygon").data(r2d3.data);

r2d3.svg
  .attr('height', 500)
  .attr('width', 500);

triangles.enter()
  .append("polygon")
  .attr('points', function(d) {return String(d.wys/2)+","+String(d.wys*d.poz/d.pozM/3)+" "+String(d.wys/2-d.wys*d.poz/d.pozM/2)+","+String(d.wys*d.poz/d.pozM)+" "+String(d.wys/2+d.wys*d.poz/d.pozM/2)+","+String(d.wys*d.poz/d.pozM);})
  .attr('fill', function(d) {return d.kolor;});
  
triangles.exit().remove();

triangles.transition()
  .duration(1)
  .attr('points', function(d) {return String(d.wys/2)+","+String(d.wys*d.poz/d.pozM/3)+" "+String(d.wys/2-d.wys*d.poz/d.pozM/2)+","+String(d.wys*d.poz/d.pozM)+" "+String(d.wys/2+d.wys*d.poz/d.pozM/2)+","+String(d.wys*d.poz/d.pozM);})
  .attr('fill', function(d) {return d.kolor;});

var b_n = triangles[0].bombki_n;
var b_r = triangles[0].bombki_r;
var rozm = traingles[0].wys;
var circles = d3.range(b_n).map(function(x) {return {bombki_r: b_r}});

circles.enter()
  .append("circle")
  .attr("cx", Math.random()*rozm)
  .attr("cy", Math.random()*rozm)
  .attr("r", function(d) {return d.bombki_r;})
  .attr("fill", "cyan");

circles.exit().remove();

circles.transition()
  .duration(1)
  .attr("cx", Math.random()*rozm)
  .attr("cy", Math.random()*rozm)
  .attr("r", function(d) {return d.bombki_r;});