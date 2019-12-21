


var a = data[0].a;
var bublesCount = data[0].bublesCount;
var starOnTop = data[0].starOnTop;
var starShining = data[0].starShining;
var babyYoda = data[0].babyYoda;

svg.selectAll('*').remove();


var b = 0.8*a;
var c = 0.6*a;

var trunk = [{"x": 400 - a/8, "y": 680 + a/4},
{"x": 400 + a/8, "y": 680 + a/4},
{"x": 400 + a/8, "y": 680},
{"x": 400 - a/8, "y": 680}];

var lowertriangle = [{"x": 400, "y": 680 - a*Math.sqrt(3)/2},
{"x": 400 + a/2 , "y": 680},
{"x": 400 - a/2 , "y": 680}];

var middletriangle = [{"x": 400, "y": 680 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4},
{"x": 400 + b/2 , "y": 680 - a*Math.sqrt(3)/2 + b*Math.sqrt(3)/4},
{"x": 400 - b/2 , "y": 680 - a*Math.sqrt(3)/2 + b*Math.sqrt(3)/4}];

var uppertriangle = [{"x": 400, "y": 680 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4 - c*Math.sqrt(3)/4},
{"x": 400 + c/2 , "y": 680 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4 + c*Math.sqrt(3)/4},
{"x": 400 - c/2 , "y": 680 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4 + c*Math.sqrt(3)/4}];

var topx = 400;
var topy = 680 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4 - c*Math.sqrt(3)/4;

var k = 0.2*a;

var star = [{"x": topx - k*Math.sin(4*Math.PI/5), "y": topy + k*Math.cos(Math.PI/5)},
{"x": topx + k*Math.sin(2*Math.PI/5), "y": topy - k*Math.cos(2*Math.PI/5)},
{"x": topx - k*Math.sin(2*Math.PI/5), "y": topy - k*Math.cos(2*Math.PI/5)},
{"x": topx + k*Math.sin(4*Math.PI/5), "y": topy + k*Math.cos(Math.PI/5)},
{"x": topx, "y": topy - k}];


svg.append("polygon")
   .data([trunk])
   .attr("fill", "#663300")
   .attr("points",function(d) { 
     return d.map(function(d) {
       return [d.x,d.y].join(",");})
       .join(" ");});
       
svg.append("polygon")
   .data([lowertriangle])
   .attr("fill", "#33cc33")
   .attr("points",function(d) { 
     return d.map(function(d) {
       return [d.x,d.y].join(",");})
       .join(" ");});
       
       
svg.append("polygon")
   .data([middletriangle])
   .attr("fill", "#33cc33")
   .attr("points",function(d) { 
     return d.map(function(d) {
       return [d.x,d.y].join(",");})
       .join(" ");});
       
       
              
svg.append("polygon")
   .data([uppertriangle])
   .attr("fill", "#33cc33")
   .attr("points",function(d) { 
     return d.map(function(d) {
       return [d.x,d.y].join(",");})
       .join(" ");});
       
    
   function getRandomColor() {
        var letters = '0123456789ABCDEF';
        var color = '#';
        for (var i = 0; i < 6; i++) {
            color += letters[Math.floor(Math.random() * 16)];
        }
        return color;
      }
       


var bubles = d3.range(bublesCount).map(function(){
  t = Math.random()*3;
  w = Math.random()*700;
  z = Math.random()*700;
  if(t<=1){  //dolny trojkat
    x = Math.random()*a + 400 - a/2;
    if(x<400){
       y = 680 - Math.random()*(x - (400 - a/2))*Math.sqrt(3);
    }
    else{
       y = 680 - Math.random()*((400 + a/2) - x)*Math.sqrt(3);     }
  }
  else if(t<=2 & t>1){ //srodkowy trojkat choinki
    x = Math.random()*b + 400 - b/2;
    if(x<400){
      y = 680 - a*Math.sqrt(3)/2 + b*Math.sqrt(3)/4 - Math.random()*(x - (400 - b/2))*Math.sqrt(3);
    }
    else{
      y = 680 - a*Math.sqrt(3)/2 + b*Math.sqrt(3)/4 - Math.random()*((400 + b/2) - x)*Math.sqrt(3);
    }
  }
  else { //górny trojkat
    x = Math.random()*c + 400 - c/2;
    if(x<400){
      y = 680 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4 + c*Math.sqrt(3)/4 - Math.random()*(x - (400 - c/2))*Math.sqrt(3);
    }
    else{
      y = 680 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4 + c*Math.sqrt(3)/4 - Math.random()*((400 + c/2) - x)*Math.sqrt(3);    }
    }
return {x, y, w, z, color: getRandomColor()  }});

var bubleSize = a/40;

if (babyYoda){
  svg.selectAll('circle')
    .data(bubles)
    .enter()
    .append('circle')
    .attr('cx', function(d) {return d.x;})
    .attr('cy', function(d) {return d.y;})
    .attr('r', bubleSize)
    .attr('fill', function(d) {return d.color} )
    .transition()
    .duration(3000)
    .delay(50)
    .attr("cx", function(d) {return d.w;})
    .attr("cy", function(d) {return d.z;})
    .style("fill",function(d) {return d.color})
    .attr("r", bubleSize);
    
}else{

svg.selectAll('circle')
    .data(bubles)
    .enter()
    .append('circle')
    .attr('cx', function(d) {return d.x;})
    .attr('cy', function(d) {return d.y;})
    .attr('r', bubleSize)
    .attr('fill', function(d) {return d.color} );
    
}
    
if (starOnTop) {
  svg.append("polygon")
   .data([star])
   .attr("fill", "#ffcc00")
   .attr("points",function(d) { 
     return d.map(function(d) {
       return [d.x,d.y].join(",");})
       .join(" ");});
}
if (starShining){
   svg.append("polygon")
   .data([star])
   .attr("fill", "#ffcc00")
   .attr("points",function(d) { 
     return d.map(function(d) {
       return [d.x,d.y].join(",");})
       .join(" ");})
   .transition()
            .duration(100)
            .on('start', function repeat(){
                d3.active(this)
                .transition()
                .duration(1000)
                .delay(50)
                .attr('fill',"#ffff99")
                .transition()
                .duration(1000)
                .delay(50)
                .attr('fill', "#ffcc00")
                .on('end', repeat)});
}