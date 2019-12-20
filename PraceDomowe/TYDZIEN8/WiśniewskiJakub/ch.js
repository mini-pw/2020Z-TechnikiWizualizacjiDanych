// usuwanie bombek
document.getElementById("Resetbombki").addEventListener("click",() => {
	r2d3.svg.selectAll('circle').remove();
},false)

// nie wiem po co to ale bez tego nie działa
const x = d3.scaleLinear().range([0, 400]);
const y = d3.scaleLinear().range([0, 400]);

  
x.domain([0, 400]);
y.domain([0, 400]);


// choinka 
const tree = [{"x":0,"y":350},
            {"x":500,"y":350},
            {"x":400,"y":250},
            {"x":460,"y":250},
            {"x":350,"y":150},
            {"x":420,"y":150},
            {"x":250,"y":20},
            {"x":80,"y":150},
            {"x":150,"y":150},
            {"x":40,"y":250},
            {"x":100,"y":250},
            ]

// Choinka
const z = r2d3.svg.selectAll("polygon")
    .data([tree])
    .enter();

z.append("polygon")
    .attr('fill', '#108525')
    .attr("points",function(d) { return d.map(function(d) {return [x(d.x),y(d.y)].join(",");}).join(" ");})

// dodanie pnia
z.append('rect')
      .attr('width', 40)
      .attr('height', 60)
      .attr('y', 350 )
      .attr('x', 230)
      .attr('fill', '#361d01');


// bombki - już z ustalonymi koordynatami w schiny 
const cd = r2d3.svg.selectAll('circle')
      .data(r2d3.data)
      .enter()
      .append('circle')
      .attr('cx', 10)
      .attr('cy', 10)
      .attr('r', 3)
      .attr('fill', 'blue')
      .transition()
	    .duration(3000)
	    .delay(50)
	    .attr("cx", function(d){return d.bombkix}) // funkcja na x
	    .attr("cy", function(d){return d.bombkiy}) // funkcja na y
	    .style("fill", document.querySelector(".item").dataset.value)
	    .attr("r",5 );
	    
	    

