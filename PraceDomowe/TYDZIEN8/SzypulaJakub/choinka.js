const choinka = r2d3.svg.selectAll("polygon")
    .data(r2d3.data)
    .enter();


choinka.append("polygon")
    .attr('fill', '#007F0E')
    .attr("points",function(d) { return d.punkty});
    

choinka.append("rect")
  .attr('width', 10)
  .attr('height', 20)
  .attr('y', 380)
  .attr('x', 195)
  .attr('fill', '#7C4520')
  
choinka.append("text")
  .text(function(d) {return d.tekst})
  .attr('x', 180)
  .attr('y', -180)
  .attr("font-size", 30)
  .attr("transform", "rotate(90 150,150)")

choinka.append("polygon")
  .attr('fill', '#FFD82C')
  .attr("points", "185,45 200,0 215,45")
  
const cd = r2d3.svg.selectAll('circle')
      .data(r2d3.data)
      .enter()
      .append('circle')
      .attr('r', 10)
      .attr('fill', function(d) {return d.bombkiKolor})
	    .attr("cy", function(d){return d.bombkiY})
	    .attr("cx", function(d){return d.bombkiX})

// Reset
document.getElementById("Reset").addEventListener("click",() => {
	r2d3.svg.selectAll('polygon').remove();
	r2d3.svg.selectAll('rect').remove();
	r2d3.svg.selectAll('circle').remove();
	r2d3.svg.selectAll('text').remove();
	
	const choinka = r2d3.svg.selectAll("polygon")
    .data(r2d3.data)
    .enter();

	choinka.append("polygon")
    .attr('fill', '#007F0E')
    .attr("points",function(d) { return d.punkty});
    

  choinka.append("rect")
    .attr('width', 10)
    .attr('height', 20)
    .attr('y', 380)
    .attr('x', 195)
    .attr('fill', '#7C4520')
    document.getElementById("prezentyChbx").click();
  choinka.append("polygon")
    .attr('fill', '#FFD82C')
    .attr("points", "185,45 200,0 215,45")
  const cd = r2d3.svg.selectAll('circle')
      .data(r2d3.data)
      .enter()
      .append('circle')
      .attr('r', 10)
      .attr('fill', function(d) {return d.bombkiKolor})
	    .attr("cy", function(d){return d.bombkiY})
	    .attr("cx", function(d){return d.bombkiX})
	    
	
	choinka.append("text")
    .text(function(d) {return d.tekst})
    .attr('x', 180)
    .attr('y', -180)
    .attr("font-size", 30)
    .attr("transform", "rotate(90 150,150)")
},false);


const checkbox = document.getElementById('prezentyChbx')

checkbox.addEventListener('change', (event) => {
  if (event.target.checked) {
    choinka.append("rect")
    .attr('width', 50)
    .attr('height', 50)
    .attr('y', 370)
    .attr('x', 240)
    .attr('fill', '#0026FF')
   
   choinka.append("rect")
    .attr('width', 50)
    .attr('height', 50)
    .attr('y', 360)
    .attr('x', 220)
    .attr('fill', '#FF0000')
    
   choinka.append("rect")
    .attr('width', 50)
    .attr('height', 50)
    .attr('y', 355)
    .attr('x', 130)
    .attr('fill', '#FFD800')
  } else {
    r2d3.svg.selectAll('rect').remove();
    choinka.append("rect")
      .attr('width', 10)
      .attr('height', 20)
      .attr('y', 380)
      .attr('x', 195)
      .attr('fill', '#7C4520')
  }
})


