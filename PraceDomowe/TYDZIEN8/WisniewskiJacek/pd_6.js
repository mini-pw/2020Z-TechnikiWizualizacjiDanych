// !preview r2d3 data=c(a = 150, bombNr = 100)
//
// r2d3: https://rstudio.github.io/r2d3
//
var a = data[0].a;
var bombNr = data[0].bombNr;
var b = 0.8*a;
var c = 0.6*a;
var k = 0.2*a;

svg.selectAll('*').remove();

var base = [{"x": 200 - a/8, "y": 450 + a/4},
    {"x": 200 + a/8, "y": 450 + a/4},
    {"x": 200 + a/8, "y": 450},
    {"x": 200 - a/8, "y": 450}];

var tree1 = [{"x": 200 - a/2, "y": 450},
    {"x": 200 + a/2, "y": 450},
    {"x": 200, "y": 450 - a*Math.sqrt(3)/2}];
    
var tree2 = [{"x": 200 - b/2, "y": 450 - a*Math.sqrt(3)/2 + b*Math.sqrt(3)/4},
    {"x": 200 + b/2, "y": 450 - a*Math.sqrt(3)/2 + b*Math.sqrt(3)/4},
    {"x": 200, "y": 450 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4}];
    
var tree3 = [{"x": 200 - c/2, "y": 450 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4 + c*Math.sqrt(3)/4},
    {"x": 200 + c/2, "y": 450 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4 + c*Math.sqrt(3)/4},
    {"x": 200, "y": 450 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4 - c*Math.sqrt(3)/4}];
    
var t = 450 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4 - c*Math.sqrt(3)/4;

var star = [{"x": 200 - k*Math.sin(4*Math.PI/5), "y": t + k*Math.cos(Math.PI/5)},
    {"x": 200 + k*Math.sin(2*Math.PI/5), "y": t - k*Math.cos(2*Math.PI/5)},
    {"x": 200 - k*Math.sin(2*Math.PI/5), "y": t - k*Math.cos(2*Math.PI/5)},
    {"x": 200 + k*Math.sin(4*Math.PI/5), "y": t + k*Math.cos(Math.PI/5)},
    {"x": 200, "y": t - k}];

function drawTreeElement(data, color) {
    svg.append("polygon")
    .data([data])
    .attr("points",function(d) { 
        return d.map(function(d) {
            return [d.x,d.y].join(",");
        }).join(" ");
    })
    .attr("fill", color);
}


drawTreeElement(base, "#663300");
drawTreeElement(tree1, "#008500");
drawTreeElement(tree2, "#00ae00");
drawTreeElement(tree3, "#00d900");
    
function getRandomColor() {
  var letters = '0123456789ABCDEF';
  var color = '#';
  for (var i = 0; i < 6; i++) {
    color += letters[Math.floor(Math.random() * 16)];
  }
  return color;
}



var bombs = d3.range(bombNr).map(function() {
  level = Math.random();
  if (level < 0.33) {
    x = 200 - a/2 + Math.random()*a;
    if (x < 200) {
      y = 450 - Math.random()*(x - (200 - a/2))*Math.sqrt(3);
    }
    else {
      y = 450 - Math.random()*((200 + a/2) - x)*Math.sqrt(3);
    }
  }
  if (level < 0.66 & level > 0.33) {
    x = 200 - b/2 + Math.random()*b;
    if (x < 200) {
      y = 450 - a*Math.sqrt(3)/2 + b*Math.sqrt(3)/4 - Math.random()*(x - (200 - b/2))*Math.sqrt(3);
    }
    else {
      y = 450 - a*Math.sqrt(3)/2 + b*Math.sqrt(3)/4 - Math.random()*((200 + b/2) - x)*Math.sqrt(3);
    }
  }
  if (level > 0.66) {
    x = 200 - c/2 + Math.random()*c;
    if (x < 200) {
      y = 450 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4 + c*Math.sqrt(3)/4 - Math.random()*(x - (200 - c/2))*Math.sqrt(3);
    }
    else {
      y = 450 - a*Math.sqrt(3)/2 - b*Math.sqrt(3)/4 + c*Math.sqrt(3)/4 - Math.random()*((200 + c/2) - x)*Math.sqrt(3);
    }
  }
  return {x, y, color: getRandomColor()}});

svg.selectAll('circle')
            .data(bombs)
            .enter()
            .append('circle')
            .attr('cx', function(d) {return d.x})
            .attr('cy', function(d) {return d.y})
            .attr('r', a/40)
            .attr("fill", function(d) {return d.color});
            
drawTreeElement(star, "#ffff00");