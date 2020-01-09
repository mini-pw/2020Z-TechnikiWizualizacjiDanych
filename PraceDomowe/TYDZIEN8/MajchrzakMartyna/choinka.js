// preview r2d3 data=data.frame(height = 200,
//                              width = 100
//                              smallBaubleCount= 15, 
//                              smallBaubleColor = "red", 
//                              bigBaubleCount = 25,
//                              bigBaubleColor="gold",
//                              chainShining=FALSE,)
//
// r2d3: https://rstudio.github.io/r2d3
//

//dane wejściowe
var height = data[0].height;
var width = data[0].width;
var smallBaubleCount = data[0].smallBaubleCount;
var smallBaubleColor = data[0].smallBaubleColor;
var bigBaubleCount = data[0].bigBaubleCount;
var bigBaubleColor = data[0].bigBaubleColor;
var chainShining = data[0].chainShining;

svg.selectAll('*').remove();

// dzięki użyciu tych zmiennych można opisywać punkty parami liczb
//  z [0-5]x[0-8] 
//(0,0) w lewym dolnym rogu
var xp=100;
var yp=450;
var xunit= width/5;
var yunit= height/8;

//współrzędne wielokątów
var trunk = [{"x": 2, "y": 0 },
              {"x": 3, "y": 0},
              {"x": 3, "y": 1},
              {"x": 2, "y": 1}];
              
var level1 =[{"x":0, "y":1},
              {"x":5, "y":1},
              {"x":2.5, "y":4}];
              
var level2 =[{"x":0.5, "y":3},
              {"x":4.5, "y":3},
              {"x":2.5, "y":5.5}];
var level3 =[{"x":1, "y":5},
              {"x":4, "y":5},
              {"x":2.5, "y":7}];
              
var star = [{"x": 2.5, "y": 7.7},
              {"x": 2, "y": 6.5},
              {"x": 3.15, "y": 7.30},
              {"x": 1.85, "y": 7.30},
              {"x": 3, "y": 6.5}
              ];
              

function draw(element, color) {
  //rysuje wielokąt
    svg.append("polygon")
    .data([element])
    .attr("points",function(d) { 
      return d.map(function(d) {
        return [xp+(d.x)*xunit,yp-(d.y)*yunit].join(",");
      }).join(" ");
    })
    .attr("fill", color);
  }

//rysowanie wiekolątów
draw(trunk, "#7A5200");
draw(level1,"#388B46");
draw(level2,"#388B46");
draw(level3,"#388B46");
draw(star,"#ffde00");


// światełka

function RandomColor() {
  // generuje losowy kolor
    var letters = '0123456789ABCDEF';
    var color = '#';
    for (var i = 0; i < 6; i++) {
      color += letters[Math.floor(Math.random() * 16)];
    }
    return color;
  }

function drawChain(xstart, ystart, xend, yend,n){
  // rysuje łańcuch z (xstart,ystart) do (xend,yend), a na nim n    lampek
  xstep=((xend)-(xstart))/n;
  ystep=((yend)-(ystart))/n;
  x=xstart;
  y=ystart;
  
  var lights = d3.range(n).map(function(){
      x=x+xstep;
      y=y+ystep;
      color=RandomColor();
      return{x,y,color}
    });
  
  svg.append('line')
    .style("stroke", "black")
    .style("stroke-width", 2)
    .attr("x1", xstart)
    .attr("y1", ystart)
    .attr("x2", xend)
    .attr("y2", yend);
    
  if(chainShining){
      svg.selectAll('p')
      .data(lights)
      .enter()
      .append('circle')
      .attr('cx', function(d) {return d.x})
      .attr('cy', function(d) {return d.y})
      .attr('r', xunit/17)
      .attr("fill", function(d) {return d.color})
      .transition()
            .duration(5)
            .on('start', function repeat(){
                d3.active(this)
                .transition()
                .duration(1000)
                .delay(5)
                .attr('fill',"grey")
                .transition()
                .duration(1000)
                .delay(50)
                .attr('fill', function(d) {return d.color})
                .on('end', repeat)});
        svg
  }
  else{
          svg.selectAll('p')
          .data(lights)
          .enter()
          .append('circle')
          .attr('cx', function(d) {return d.x})
          .attr('cy', function(d) {return d.y})
          .attr('r', xunit/20)
          .attr("fill", function(d) {return "grey"});
  }

  
}

//rysowanie 3 części łańcucha
drawChain(xp+0.3*xunit,yp-1.4*yunit,xp+4.1*xunit,yp-2.1*yunit,17)
drawChain(xp+0.8*xunit, yp-3.4*yunit, xp+3.7*xunit,yp-4*yunit,14)
drawChain(xp+1.3*xunit,yp-5.4*yunit,xp+3.4*xunit,yp-5.8*yunit,11)


//bombki

function drawBaubles(BaubleCount,BaubleColor, radius){
  //rysuje 'BabuleCount' bombek w kolorze 'BaubleColor' i o promieniu 'radius'
  //generowanie współrzędnych
  var Baubles = d3.range(BaubleCount).map(function(){
    // wspolrzene 7 od 1 do 6.5 (na samym czubku bąbli niepotrzebn     e)
    y=Math.random()*(6.5-1)+1;
    if(y<3){
      min=y-1;
      max=5-(y-1);
      x=Math.random()*(max-min)+min;
    }
      if(y>=3 & y<5){
      min=y-2.5;
      max=5-(y-2.5);
      x=Math.random()*(max-min)+min;
    }
    if (y>=5 & y<6.5){
      min=y-4;
      max=5-(y-4);
      x=Math.random()*(max-min)+min;
    }
    return{x,y}});
  // rysowanie
  svg.selectAll('p')
  .data(Baubles)
  .enter()
  .append('circle')
  .attr('cx', function(d) {return xp+d.x*xunit})
  .attr('cy', function(d) {return yp-d.y*yunit})
  .attr('r', radius)
  .attr("fill", BaubleColor);
}

//rysowanie dużych i małych bombek
drawBaubles(smallBaubleCount, smallBaubleColor, xunit/10);
drawBaubles(bigBaubleCount,bigBaubleColor, xunit/6);