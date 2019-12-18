// preview r2d3 data=data.frame(bombAmount = 30, chainTension = 500, starArmsAmount = 5, presentAmount = 5)

var bombAmount = data[0].bombAmount;
var chainTension = data[0].chainTension;
var starArmsAmount = data[0].starArmsAmount;
var presentAmount = data[0].presentAmount;

// Czyścimy poprzedni rysunek
svg.selectAll('*').remove();

// generator liczb losowych 
// Źródło: https://stackoverflow.com/questions/424292/seedable-javascript-random-number-generator
function RNG(seed) {
  // LCG using GCC's constants
  this.m = 0x80000000; // 2**31;
  this.a = 1103515245;
  this.c = 12345;

  this.state = seed ? seed : Math.floor(Math.random() * (this.m - 1));
}
RNG.prototype.nextInt = function() {
  this.state = (this.a * this.state + this.c) % this.m;
  return this.state;
};
RNG.prototype.nextFloat = function() {
  // returns in range [0,1]
  return this.nextInt() / (this.m - 1);
};
var bombRng = new RNG(2019);
var presentRng = new RNG(2019);

var imgSize = {x:500, y:500};
var lineFunction = d3.line()
                         .x(function(d) { return d.x; })
                         .y(function(d) { return d.y; })
                         .curve(d3.curveLinear);
var lineSmoothFunction = d3.line()
                         .x(function(d) { return d.x; })
                         .y(function(d) { return d.y; })
                         .curve(d3.curveNatural);
/*
d3.select("body").append("svg")
                  .attr("width", imgSize.x)
                  .attr("height", imgSize.y);
*/
// var svgContainer = r2d3.svg.selectAll('*');

function createTrianglePoints(triangleSize, angle, bottomCoord, imgSize){
  // Tworzy punkty dla trójkąta równoramiennego:
  // o podstawie długości triangleSize
  // kąt przy podstawie równy angle (podawane w stopniach)
  // podstawa na wysokości bottomCoord
  // w osi symetrii obrazka (którego dolny bok ma długość imgSize)
  return [ { "x": imgSize/2 - triangleSize/2, "y": bottomCoord},
                 { "x": imgSize/2 + triangleSize/2, "y": bottomCoord},
                 { "x": imgSize/2,  "y": bottomCoord - getHeight(triangleSize, angle)}, 
                 { "x": imgSize/2 - triangleSize/2, "y": bottomCoord}];
}
function getHeight(triangleSize, angle){
  return triangleSize*Math.tan(angle / 180 * Math.PI)/2;
}
function addTriangle(triangleSize, angle, bottomCoord){
svg.append("path")
            .attr("d", lineFunction(createTrianglePoints(triangleSize, angle, bottomCoord,   imgSize.x)))
            .attr("stroke", "none")
            .attr("fill", "green");
            return;
}
var angle = 60;
var yDiff = 125;
var sizeDiff = 75;
var bottomSize = imgSize.x - 200;
var levelAmount = 3;
var levelHeights = d3.range(levelAmount).map(function(i){return imgSize.y - i * yDiff - 50;});
var triangleSizes = d3.range(levelAmount).map(function(i){return bottomSize - i * sizeDiff;});
addTriangle(triangleSizes[0], angle, levelHeights[0]);
addTriangle(triangleSizes[1], angle, levelHeights[1]);
addTriangle(triangleSizes[2], angle, levelHeights[2]);

function getWidth(y){
  // Funkcja zwraca szerokość choinki na poziomie y
  var i = Math.floor((levelHeights[0] - y) / yDiff);
  var height = i * yDiff + getHeight(triangleSizes[i], angle);
  var y1 = levelHeights[0] - height;
  // Zaczepiamy u-d w (imgSize/2, y)
  var x = y1 - y;
  return x / Math.tan(angle / 180 *Math.PI);
}

//Dodajemy pieniek na dole
var rectWidth = 50;
svg.append('rect')
            .attr('x', imgSize.x/2 - rectWidth/2)
            .attr('y', levelHeights[0])
            .attr('width', rectWidth)
            .attr('height', rectWidth)
            .attr('fill', 'brown');

// Łańcuchy
function createChainPoints(h1, h2, L, a, margin){
  /*
   h1, h2 - wysokości (h1 to lewa, h2 to prawa)
   h2 >= h1
   L - odległość na osi X między wysokościami
   a - współczynnik naprężenia
   Położenia punktów asymetrycznego łańcucha spełniają równanie
   y = a * cosh(x/a) + c
   Więcej: https://steemit.com/mathematics/@mes/video-notes-hyperbolic-functions-asymmetric-catenaries-determining-parameters
   Problem: nie wiemy, gdzie zaczyna się u-d współrzędnych
   L = abs(x1) + abs(x2)
   x1 < 0 & x2 > 0, więc
   L = x2 - x1
   h1 = a * cosh(x1/a) + c
   h2 = a * cosh(x2/a) + c
   h1 - h2 = a * (cosh(x1 / a) - cosh(x2 / a))
   niech z1 = x1 / a
   z2 = x2 / a
   dH = (h1 - h2) / a
   dH = cosh(z1) - cosh(z2) = 2 * sinh((z1 + z2) / 2) * sinh((z1 - z2) / 2)
   z1 - z2 = (x1 - x2) / a = - L / a
   dH = 2 * sinh((z1 + z2) / 2) * sinh(- L / (2 * a))
   stąd
   sinh((z1 + z2) / 2) = dH / 2 / sinh(-L / 2 / a)
   z1 + z2 = 2 * asinh(dH / 2 / sinh(-L / 2 / a))
   2 * z1 = 2 * asinh(dH / 2 / sinh(-L / 2 / a)) - L / a
   z1 = asinh(dH / 2 / sinh(-L / 2 / a)) - L / a / 2
   x1 = a * asinh(dH / 2 / sinh(-L / 2 / a)) - L / 2
   x2 = L + x1
  */
  var dH = (h1 - h2) / a;
  var x1 = a * Math.asinh(dH / 2 / Math.sinh(- L / 2 / a)) - L / 2;
  var x2 = L + x1;
  var c = h1 - Math.cosh(x1 / a) * a;
  // generujemy krzywą
  
  var x_coords = d3.range(1000).map(function(i){
     return x1 + i * L / 1000;
  });
  var y_coords = x_coords.map(function(x){
     return a * Math.cosh(x / a) + c;
  });
   
   // przenosimy się do u-du wsp obrazka
  return d3.range(1000).map(function(i){
     return{x:x_coords[i] - x1 + margin, y:imgSize.y - y_coords[i]};
  });
}
// Każdy poziom ma jeden łańcuch, biegnący od 1/3 wysokości z lewej do 2/3 wysokości z prawej

function addChain(level, tension){
  // level - liczba oznaczająca, na którym poziomie choinki chcemy dodać łańcuch
  var y1 = levelHeights[level] - yDiff / 3;
  var y2 = y1 - yDiff / 3;
  if(level == levelAmount-1){
    y2 = y2 + yDiff / 6;
  }
  var x1 = imgSize.x / 2 + getWidth(y1);
  var x2 = imgSize.x / 2 - getWidth(y2);
  var L = x2 - x1;
svg.append("path")
            .attr("d", lineFunction(createChainPoints(h1 = imgSize.y - y1,
                                                      h2 = imgSize.y - y2,
                                                      L = L, 
                                                      a = tension * L / imgSize.x, 
                                                      margin = x1)))
            .attr("stroke", "gold")
            .attr("stroke-width", 12)
            .attr("fill", "none");
            return;
}
for(var i in d3.range(levelAmount)) addChain(i, chainTension);




// Bombki
var bombRadius = 8;
var starRadius = 40;
// Ustalić wysokość choinki
var treeHeight = (levelAmount - 1) * yDiff + getHeight(triangleSizes[levelAmount-1], angle);
var bombYCoord = d3.range(bombAmount).map(function(){
  // Chcemy, by bombki pojawiały się w losowych punktach naszej choinki.
  // Zrobimy to w 2 krokach: najpierw wylosujemy zmienną Y (wysokość),
  // A potem na jej podstawie wylosujemy zmienną X z określonego przedziału.
  // O ile zmienną X możemy losować z rozkładu jednostajnego, o tyle Y przydałoby się losować porządniej.
  var xMax = treeHeight - starRadius;
  var xLos = bombRng.nextFloat()*xMax;
  var yLos = bombRng.nextFloat()*triangleSizes[0]/2;
  // Jeśli punkt znalazł się nad prostą y = (triangleSizes[0]/treeHeight) x,
  // To odbij punkt symetrycznie wzdłuż prostej x=treeHeight/2
  if (yLos > triangleSizes[0] / xMax * xLos) xLos = treeHeight / 2 - xLos;
  // Przenosimy się do u-du współrzędnych obrazka
  return {y:levelHeights[0] - xMax + xLos};
});
//var bombYCoord = [{y: imgSize - 50}];
svg.selectAll('circle')
            .data(bombYCoord)
            .enter()
            .append('circle')
            .attr('cy', function(d) {return d.y; })
            .attr('cx', function(d){
              
                //Ustalamy, na jakim poziomie jesteśmy
                var y2 = getWidth(d.y);
                var y3 = bombRng.nextFloat()*2*y2 - y2;
                //return imgSize - y2;
                return imgSize.x/2 + y3;
            })
            .attr('r', bombRadius)
            .attr('fill',function(){
              var colors = ["gold", "blue", "yellow", "grey", "pink", "brown", "slateblue", "orange"];
              var los = Math.floor(bombRng.nextFloat()*colors.length);
              return colors[los];
            });


// Gwiazdka

function createStarPoints(radius, cx, cy, armAmount){
  // radius - promień gwiazdki (od środka do zewnętrznego wierzchołka)
  // cx, cy - współrzędne środka
  // armAmount - ile ramion ma mieć gwiazdka
  // Najpierw pracujemy w układzie współrzędnych ze środkiem w (0,0)
  var angles = d3.range(armAmount + 1).map(function(i){return i * (Math.PI * 2 / armAmount) - Math.PI / 2;});
  var outers = angles.map(function(angle){
    return {x:Math.cos(angle)*radius, y:Math.sin(angle)*radius};
  });
  var inners = angles.map(function(angle){
    return {x:Math.cos(angle + Math.PI / armAmount) * radius / 2,
            y:Math.sin(angle + Math.PI / armAmount) * radius / 2};
  });
  var points = d3.range(2 * armAmount + 1).map(function(i){
    if(i % 2 === 0)return outers[i/2];
    else return inners[(i-1)/2];
  });
  
  //Środek na szczycie - (imgSize / 2, imgSize - treeHeight)
  return points.map(function(i){
    return{x: i.x + cx, y:i.y + cy};
  });
}

// Dodajemy gwiazdkę
svg.append("path")
            .attr("d", lineFunction(createStarPoints(starRadius, imgSize.x/2, levelHeights[0] - treeHeight, starArmsAmount)))
            .attr("stroke", "none")
            .attr("fill", "gold");

// Prezenty

function addPresent(presentPlace, presentSize, color){
var topHeight = presentSize / 3;
svg.append('rect')
            .attr('x', presentPlace.x)
            .attr('y', presentPlace.y)
            .attr('height', presentSize - topHeight / 2)
            .attr('width', presentSize)
            .attr('fill', color)
            .attr('stroke','black')
            .attr('stroke-width', 3);
svg.append('rect')
            .attr('x', presentPlace.x - topHeight / 2)
            .attr('y', presentPlace.y - topHeight)
            .attr('height', topHeight)
            .attr('width', presentSize + topHeight)
            .attr('fill', color)
            .attr('stroke','black')
            .attr('stroke-width', 3);
// Wstążki na pudełku
svg.append('rect')
            .attr('x', presentPlace.x + presentSize / 2 - presentSize / 10)
            .attr('y', presentPlace.y)
            .attr('width', presentSize / 5)
            .attr('height', presentSize - topHeight/2)
            .attr('fill', 'black')
            .attr('stroke', 'none');

// Kokardka
var bowWidth = 7 / 50 * presentSize;
// Kokardka to będą 4 punkty z deltoidu,przez które puścimy krzywą typu curveBasic
// Najpierw w układzie współrzędnych o środku w "krzyżyku" kokardki
// współrzędne biegunowe
var bowPoints = [ {r:3*bowWidth, fi:Math.PI * 1.5},
                  {r:bowWidth, fi:Math.PI},
                  {r:bowWidth, fi:Math.PI / 2},
                  {r:bowWidth, fi:0},
                  {r:3*bowWidth, fi:Math.PI * 1.5}];
// Teraz obracamy wszystko 60 stopni w prawo/lewo,
// Następnie przechodzimy na wsp kartezjańskie
bowPointsLeft = bowPoints.map(function(point){
  var fi = point.fi + Math.PI / 3;
  return {x:point.r * Math.cos(fi),
          y:point.r * Math.sin(fi)};
});
bowPointsRight = bowPoints.map(function(point){
  var fi = point.fi - Math.PI / 3;
  return {x:point.r * Math.cos(fi),
          y:point.r * Math.sin(fi)};
});
// Przesuwamy punkty tak, by dolny punkt krzyżyka był w środku u-d u
var vec = bowPointsRight[0];
bowPointsRight = bowPointsRight.map(function(point){
  return{x:point.x - vec.x, y:point.y - vec.y};
});
vec = bowPointsLeft[0];
bowPointsLeft = bowPointsLeft.map(function(point){
  return{x:point.x - vec.x, y:point.y - vec.y};
});
// Przesuwamy punkty do u-d u wsp obrazka
vec = {x:presentPlace.x + presentSize / 2, y:presentPlace.y - topHeight};
bowPointsRight = bowPointsRight.map(function(point){
  return{x:point.x + vec.x, y:vec.y - point.y};
});
bowPointsLeft = bowPointsLeft.map(function(point){
  return{x:point.x + vec.x, y:vec.y - point.y};
});

svg.append("path")
            .attr("d", lineSmoothFunction(bowPointsLeft))
            .attr("stroke", "black")
            .attr('stroke-width', 3)
            .attr("fill", "none");

svg.append("path")
            .attr("d", lineSmoothFunction(bowPointsRight))
            .attr("stroke", "black")
            .attr('stroke-width', 3)
            .attr("fill", "none");
return;
}
var presentSizes = d3.range(presentAmount).map(function(){
  return presentRng.nextFloat() * 10 + 20;
}).sort().reverse();
var presentPlaces = d3.range(presentAmount).map(function(i){
  return {x:presentRng.nextFloat()*(triangleSizes[0] - presentSizes[i]) + (imgSize.x / 2 - triangleSizes[0] / 2),
          y:imgSize.y - presentSizes[i] + 3};
});
var presentColors = d3.range(presentAmount).map(function(){
  var colors = ["gold", "blue", "yellow", "grey", "pink",'red', "brown", "slateblue", "orange"];
  var los = Math.floor(presentRng.nextFloat()*colors.length);
  return colors[los];  
})
d3.range(presentAmount).map(function(i){
  addPresent(presentPlaces[i], presentSizes[i], presentColors[i]);
  return;
})

            