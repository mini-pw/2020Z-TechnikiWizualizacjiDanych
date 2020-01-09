
// długość boku największego trójkąta (dolnego)
var a = data[0].a;
// długość boku średniego trójkąta (środkowego)
var b = 0.8*a;
// długość boku najmniejszego trójkąta (górnego)
var c = 0.6*a;
// rozmiar gwiazdy
var k = 0.2*a;
// rozmiar bombek
var bubleSize = a/28;
// liczba bombek
var bublesCount = data[0].bublesCount;
// łańcuchy
var addChain = data[0].addChain;
// kolor łańcucha
var chainColour = data[0].chainColour;
// gwiazda na czubku
var starOnTop = data[0].starOnTop;
// gwiazda świecąca
var starShining = data[0].starShining;
// specjalny przycisk mocy
var babyYoda = data[0].babyYoda;

// usuwamy poprzedni obrazek
svg.selectAll('*').remove();

// koordynaty pnia
var trunk = [{"x": 400 - a/8, "y": 680 + a/4},
             {"x": 400 + a/8, "y": 680 + a/4},
             {"x": 400 + a/8, "y": 680},
             {"x": 400 - a/8, "y": 680}];

// koodrynaty choinki 
// dolny trójkąt
var lowertriangle = [{"x": 400, "y": 680 - a*Math.sqrt(3)/2},
                     {"x": 400 + a/2 , "y": 680},
                     {"x": 400 - a/2 , "y": 680}];

// środkowy trójkąt
var middletriangle = [{"x": 400, "y": 680 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4},
                      {"x": 400 + b/2 , "y": 680 - a*Math.sqrt(3)/2 + b*Math.sqrt(3)/4},
                      {"x": 400 - b/2 , "y": 680 - a*Math.sqrt(3)/2 + b*Math.sqrt(3)/4}];
                      
// górny trójkąt
var uppertriangle = [{"x": 400, "y": 680 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4 - c*Math.sqrt(3)/4},
                     {"x": 400 + c/2 , "y": 680 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4 + c*Math.sqrt(3)/4},
                     {"x": 400 - c/2 , "y": 680 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4 + c*Math.sqrt(3)/4}];

// koordynaty czubka
var topx = 400;
var topy = 680 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4 - c*Math.sqrt(3)/4;

// kordynaty gwiazdy
var star = [{"x": topx - k*Math.sin(4*Math.PI/5), "y": topy + k*Math.cos(Math.PI/5)},
            {"x": topx + k*Math.sin(2*Math.PI/5), "y": topy - k*Math.cos(2*Math.PI/5)},
            {"x": topx - k*Math.sin(2*Math.PI/5), "y": topy - k*Math.cos(2*Math.PI/5)},
            {"x": topx + k*Math.sin(4*Math.PI/5), "y": topy + k*Math.cos(Math.PI/5)},
            {"x": topx, "y": topy - k}];

// rysujemy pień
svg.append("polygon")
   .data([trunk])
   .attr("fill", "#663300")
   .attr("points",function(d) { 
     return d.map(function(d) {
       return [d.x,d.y].join(",");})
       .join(" ");});

// rysujemy choinkę       
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
       
// funkcja generująca randomowe kolory -  do pokolorowania bombek    
function getRandomColor() {
    var letters = '0123456789ABCDEF';
    var color = '#';
    for (var i = 0; i < 6; i++) {
        color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
  }
  
// łańcuchy  

if (addChain){
// dolny łańcuch
svg.append('line')
    .style('stroke', chainColour)
    .style('stroke-width', a/30)
    .style('stroke-linecap', 'round')
    .attr('x1', 400+a/4)
    .attr('y1', 680 - a*Math.sqrt(3)/4)
    .attr('x2',400 - 3*a/8)
    .attr('y2',680 - a*Math.sqrt(3)/8);
    
// środkowy łańcuch
svg.append('line')
    .style('stroke', chainColour)
    .style('stroke-width', a/30)
    .style('stroke-linecap', 'round')
    .attr('x1', 400 - b/4)
    .attr('y1', 680 - a*Math.sqrt(3)/2)
    .attr('x2',400 + 3*b/8)
    .attr('y2',680 - a*Math.sqrt(3)/2 + b*Math.sqrt(3)/8);
    
// górny łańcuch    
svg.append('line')
    .style('stroke', chainColour)
    .style('stroke-width', a/30)
    .style('stroke-linecap', 'round')
    .attr('x1', 400+c/4)
    .attr('y1', 680 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4)
    .attr('x2',400 - 3*c/8)
    .attr('y2',680 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4 + c*Math.sqrt(3)/8);
}
       
// bombeczki       
var bubles = d3.range(bublesCount).map(function(){
  t = Math.random()*3; // losujemy trójkąt choinki
  w = Math.random()*700;
  z = Math.random()*700;
  // wpadające w dolny trójkąt choinki
  if(t<=1){  
    x = Math.random()*a + 400 - a/2;
    if(x<400){
       y = 680 - Math.random()*(x - (400 - a/2))*Math.sqrt(3);
    }
    else{
       y = 680 - Math.random()*((400 + a/2) - x)*Math.sqrt(3);     }
  }
  // wpadające w środkowy trójkąt choinki
  else if(t<=2 & t>1){ 
    x = Math.random()*b + 400 - b/2;
    if(x<400){
      y = 680 - a*Math.sqrt(3)/2 + b*Math.sqrt(3)/4 - Math.random()*(x - (400 - b/2))*Math.sqrt(3);
    }
    else{
      y = 680 - a*Math.sqrt(3)/2 + b*Math.sqrt(3)/4 - Math.random()*((400 + b/2) - x)*Math.sqrt(3);
    }
  }
  // wpadające w górny trójkąt choinki
  else { 
    x = Math.random()*c + 400 - c/2;
    if(x<400){
      y = 680 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4 + c*Math.sqrt(3)/4 - Math.random()*(x - (400 - c/2))*Math.sqrt(3);
    }
    else{
      y = 680 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4 + c*Math.sqrt(3)/4 - Math.random()*((400 + c/2) - x)*Math.sqrt(3);    }
    }
return {x, y, w, z, color: getRandomColor()  }});

// użycie mocy
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

// normalne rozmieszczenie bombek (losowe, ale tak, żeby wpadały na choinke)
svg.selectAll('circle')
    .data(bubles)
    .enter()
    .append('circle')
    .attr('cx', function(d) {return d.x;})
    .attr('cy', function(d) {return d.y;})
    .attr('r', bubleSize)
    .attr('fill', function(d) {return d.color} );
    
}
    
// dodanie gwiazdki   
if (starOnTop) {
  svg.append("polygon")
   .data([star])
   .attr("fill", "#ffcc00")
   .attr("points",function(d) { 
     return d.map(function(d) {
       return [d.x,d.y].join(",");})
       .join(" ");});
}

// gwiazdka świeci
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
