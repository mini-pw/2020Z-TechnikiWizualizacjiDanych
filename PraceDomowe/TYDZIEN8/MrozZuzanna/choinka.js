const x = d3.scaleLinear().range([0, 400]);
const y = d3.scaleLinear().range([0, 400]);

x.domain([0, 400]);
y.domain([0, 400]);

// choinka 
const tree = [{"x":100,"y":300},
            {"x":200,"y":350},
            {"x":300,"y":350},
            {"x":400,"y":300},
            {"x":250,"y":20},
            ];

svg = r2d3.svg.selectAll("polygon")
    .data([tree])
    .enter();
svg.append("polygon")
    .attr('fill', 'green')
    .attr("points",function(d) {return d.map(function(d) {return [x(d.x),y(d.y)].join(",");}).join(" ");});


// dodanie pnia
svg.append('rect')
      .attr('width', 40)
      .attr('height', 60)
      .attr('y', 350 )
      .attr('x', 230)
      .attr('fill', 'brown');
      
svg = r2d3.svg.append('svg')
               .attr('height', 400)
               .attr('width', 400);  
               
               
var chain_color = function(d) {return d.col_chain}; 

//chain1             
svg.data(r2d3.data).append("line").attr("x1", 112.86)
                  .attr("y1", 275.14)
                  .attr("x2", 365.68)
                  .attr("y2", 233.64)
                  .attr("stroke", chain_color)
                  .attr("stroke-width", 15);
    
//chain2            
svg.data(r2d3.data).append("line").attr("x1", 157.88)
                  .attr("y1", 188.1)
                  .attr("x2", 323.83)
                  .attr("y2", 152.75)
                  .attr("stroke", chain_color)
                  .attr("stroke-width", 15);
                      
//chain3             
svg.data(r2d3.data).append("line").attr("x1", 197.74)
                  .attr("y1", 111.03)
                  .attr("x2", 289.34)
                  .attr("y2", 86.07)
                  .attr("stroke", chain_color)
                  .attr("stroke-width", 15);
                  
                  


var bomb_color1 = function(d) {return d.col_bom1}; 

//bomb cz 1
svg.data(r2d3.data).append("circle") 
                   .attr('cx', function() {return Math.random()*100 + 200;})
                   .attr('cy', function() {return Math.random()*80 + 100;})
                   .attr('r', 4)
                   .attr('fill', bomb_color1);
    
//bomb cz 2
svg.data(r2d3.data).append("circle") 
                   .attr('cx', function(d) {return Math.random()*160 + 150})
                   .attr('cy', function(d) {return Math.random()*80 + 180;})
                   .attr('r', 4)
                   .attr('fill', bomb_color1);
         
//bomb cz 3
svg.data(r2d3.data).append("circle") 
                   .attr('cx', function(d) {return Math.random()*220 + 100;})
                   .attr('cy', function(d) {return Math.random()*80 + 240;})
                   .attr('r', 4)
                   .attr('fill', bomb_color1);


//gwiazdka
var star_color = function(d) {return d.col_star}; 
svg.data(r2d3.data).append("text") 
                   .attr('x', 238)
                   .attr('y', 50)
                   .attr('font-size', 60)
                   .text("*")
                   .attr('fill', star_color);
                   
                   
// reset bombek
document.getElementById("reset_bom").addEventListener("click",() => {
	r2d3.svg.selectAll('circle').remove();
},false);

// reset gwiazdki
document.getElementById("reset_star").addEventListener("click",() => {
	r2d3.svg.selectAll('text').remove();
},false);