var triangles = r2d3.svg.selectAll("polygon").data(r2d3.data);

r2d3.svg
  .attr('height', 500)
  .attr('width', 500);

triangles.enter()
  .append("polygon")
  .attr('points', function(d) {return String(d.szr/2)+","+String(d.szr*d.poz/d.pozM/3)+" "+String(d.szr/2-d.szr*d.poz/d.pozM/2)+","+String(d.szr*d.poz/d.pozM)+" "+String(d.szr/2+d.szr*d.poz/d.pozM/2)+","+String(d.szr*d.poz/d.pozM);})
  .attr('fill', function(d) {return d.kolor;});
  
triangles.exit().remove();

triangles.transition()
  .duration(1)
  .attr('points', function(d) {return String(d.szr/2)+","+String(d.szr*d.poz/d.pozM/3)+" "+String(d.szr/2-d.szr*d.poz/d.pozM/2)+","+String(d.szr*d.poz/d.pozM)+" "+String(d.szr/2+d.szr*d.poz/d.pozM/2)+","+String(d.szr*d.poz/d.pozM);})
  .attr('fill', function(d) {return d.kolor;});