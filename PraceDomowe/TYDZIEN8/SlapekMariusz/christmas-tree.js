
// clear previous img
svg.selectAll('*').remove();	

// size of the image
var width = 500;
var height = 400;

// read data
var colBaubles = data[0].colBaubles;
var numBaubles = data[0].numBaubles;
var sizeBaubles = data[0].sizeBaubles;
var sizeStar = data[0].sizeStar;
var boolStar = data[0].boolStar;
var colorTinsel = data[0].colorTinsel;
var colorTree = data[0].colorTree;
var sizeTinsel = data[0].sizeTinsel;


// TREE


var svg = r2d3.svg.append("svg")
            .style('background', '#d9edf7')
            .attr("width", width)
            .attr("height", height);
        

svg.append('polyline')
    .attr('points', '250, 200, 50 350, 450 350')
    .style('fill', colorTree);
svg.append('polyline')
    .attr('points', '250, 100, 50 250, 450 250')
    .style('fill', colorTree);    
svg.append('polyline')
    .attr('points', '250, 50, 50 150, 450 150')
    .style('fill', colorTree);
    
svg.append('rect')
    .attr("x", 230)
    .attr("y", 350)
    .attr("width", 40)
    .attr('height', 40)
    .attr("fill", "brown");

// TINSEL


if(colorTinsel == "random"){
      var colorTinsel = "rgb(" + parseInt(Math.random() * 255) + "," + parseInt(Math.random() * 255) + "," + parseInt(Math.random() * 255) + ")";
}    
       


svg.append('line')
    .attr("x1", 180)
    .attr("y1", 90)
    .attr("x2", 400)
    .attr("y2", 140)
    .attr("href", "#pointer")
    .attr('stroke', colorTinsel)
    .attr("stroke-width", sizeTinsel*3.5)
    .call(d3.drag()
    .on("start", dragstarted3)
    .on("drag", dragged3)
    .on("end", dragended3)
  );
  
svg.append('line')
    .attr("x1", 130)
    .attr("y1", 190)
    .attr("x2", 400)
    .attr("y2", 240)
    .attr("href", "#pointer")
    .attr('stroke', colorTinsel)
    .attr("stroke-width", sizeTinsel*3.5)
    .call(d3.drag()
    .on("start", dragstarted3)
    .on("drag", dragged3)
    .on("end", dragended3)
  );

svg.append('line')
    .attr("x1", 120)
    .attr("y1", 290)
    .attr("x2", 380)
    .attr("y2", 340)
    .attr("href", "#pointer")
    .attr('stroke', colorTinsel)
    .attr("stroke-width", sizeTinsel*3.5)
    .call(d3.drag()
    .on("start", dragstarted3)
    .on("drag", dragged3)
    .on("end", dragended3)
  );



// next 3

svg.append('line')
    .attr("x1", 140)
    .attr("y1", 240)
    .attr("x2", 360)
    .attr("y2", 190)
    .attr("href", "#pointer")
    .attr('stroke', colorTinsel)
    .attr("stroke-width", sizeTinsel*3.5)
    .call(d3.drag()
    .on("start", dragstarted3)
    .on("drag", dragged3)
    .on("end", dragended3)
  );


svg.append('line')
    .attr("x1", 120)
    .attr("y1", 340)
    .attr("x2", 380)
    .attr("y2", 290)
    .attr("href", "#pointer")
    .attr('stroke', colorTinsel)
    .attr("stroke-width", sizeTinsel*3.5)
    .call(d3.drag()
    .on("start", dragstarted3)
    .on("drag", dragged3)
    .on("end", dragended3)
  );

svg.append('line')
    .attr("x1", 120)
    .attr("y1", 140)
    .attr("x2", 340)
    .attr("y2", 90)
    .attr("href", "#pointer")
    .attr('stroke', colorTinsel)
    .attr("stroke-width", sizeTinsel*3.5)
    .call(d3.drag()
    .on("start", dragstarted3)
    .on("drag", dragged3)
    .on("end", dragended3)
  );
  


function dragstarted3() {
    d3.select(this).classed(activeClassName, true);
}

function dragged3() {
    var x = d3.event.dx;
    var y = d3.event.dy;
    
    var line = d3.select(this);
    
    // Update the line properties
    var attributes = {
      x1: parseInt(line.attr('x1')) + x,
      y1: parseInt(line.attr('y1')) + y,

      x2: parseInt(line.attr('x2')) + x,
      y2: parseInt(line.attr('y2')) + y,
    };
  
    line.attr(attributes);
}

function dragended3() {
    d3.select(this).classed(activeClassName, false);
}
    
function dragged2(d){
  d3.select(this)
    .attr("x1", d.x1 = d3.event.x1)
    .attr("y1", d.y1 = d3.event.y1)
    .attr("x2", d.x2 = d3.event.x2)
    .attr("y2", d.y2 = d3.event.y2);
}
    
    
// BOUBLES

var x = d3.range(numBaubles).map(function() {return {
    x: width/2 + Math.random() * 200 - 100,
    y: height/2 + Math.random() * 250 -125
}});

if(colBaubles == "random"){
      var colBaubles = "rgb(" + parseInt(Math.random() * 255) + "," + parseInt(Math.random() * 255) + "," + parseInt(Math.random() * 255) + ")";
}

svg.selectAll('circle')
   .data(x)
   .enter()
   .append('circle')
   .attr('cx', function(d) { return d.x;})
   .attr('cy', function(d) { return d.y;})
   .attr("href", "#pointer")
   .attr('r', sizeBaubles*3)
   .attr('fill', colBaubles)
   .call(d3.drag()
    .on("start", dragstarted)
    .on("drag", dragged)
    .on("end", dragended)
  );

// IMPORTANT: FROM DOCUMENTATION and https://stackoverflow.com/questions/53002251/how-to-perform-d3-drag-and-drop

function dragstarted(d){
  /* 
    Calculate drag bounds at dragStart because it's one event vs many 
    events if done in 'dragged()'
  */    
  d3.select(this).raise().classed("active", true);
}

function dragged(d){
  d3.select(this)
    .attr("cx", d.x = d3.event.x)
    .attr("cy", d.y = d3.event.y);
}

function dragended(d){
  d3.select(this).classed("active", false);
}

   
