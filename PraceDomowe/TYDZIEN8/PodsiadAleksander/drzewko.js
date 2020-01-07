var scale = data[0].size;

var kolor = data[0].kolor;

var kolor1 = data[0].kolor1;

var kol = data[0].kol;

var bom = data[0].bom;

var a = data[0].gwiazdka;

scaleX = d3.scaleLinear()
        .domain([0,100])
        .range([scale,400 - scale]);

scaleY = d3.scaleLinear()
        .domain([0,100])
        .range([400 - scale ,scale]);

poly = [{"x":50, "y":10},
        {"x":70, "y":30},
        {"x":60, "y":30},
        {"x":80, "y":50},
        {"x":60, "y":50},
        {"x":90, "y":80},
        {"x":60, "y":80},
        {"x":60, "y":90},
        {"x":40, "y":90},
        {"x":40, "y":80},
        {"x":10, "y":80},
        {"x":40, "y":50},
        {"x":20, "y":50},
        {"x":40, "y":30},
        {"x":30, "y":30}];

tree = r2d3.svg.selectAll("polyline")
  .data([poly]);
  
tree.enter().append("polyline")
    .attr("points",function(d) { 
        return d.map(function(d) { return [scaleX(d.x),scaleY(d.y)].join(","); }).join(" ");})
    .style('fill', kolor);
    
tree.exit().remove();

tree.transition()
  .duration(100)
  .attr("points",function(d) { 
        return d.map(function(d) { return [scaleX(d.x),scaleY(d.y)].join(","); }).join(" ");})
    .style('fill', kolor);
    

var x = scaleX(50);
var y = scaleY(10);
    
  

star = [{"x":0.5*a+x, "y":0.16246*a+y},
        {"x":0.118034*a+x, "y":0.16246*a+y},
        {"x":0+x, "y":0.525731*a+y},
        {"x":-0.118034*a+x, "y":0.16246*a+y},
        {"x":-0.5*a+x, "y":0.16246*a+y},
        {"x":-0.190983*a+x, "y":-0.0620541*a+y},
        {"x":-0.309017*a+x, "y":-0.425325*a+y},
        {"x":0+x, "y":-0.200811*a+y},
        {"x":0.309017*a+x, "y":-0.425325*a+y},
        {"x":0.190983*a+x, "y":-0.0620541*a+y}];


var punkt = [scaleX(50), scaleY(10)].join(",");    
    
gwiazda = r2d3.svg.selectAll("polygon")
  .data([star]);
  
gwiazda.enter().append("polygon")
    .attr("points",function(d) { 
        return d.map(function(d) { return [d.x,d.y].join(","); }).join(" ");})
    .style('fill', kolor1);
    
gwiazda.exit().remove();

gwiazda.transition()
  .duration(100)
  .attr("points",function(d) { 
        return d.map(function(d) { return [d.x,d.y].join(","); }).join(" ");})
    .style('fill', kolor1);

bomb = [{"x":70, "y":30},
        {"x":80, "y":50},
        {"x":90, "y":80},
        {"x":10, "y":80},
        {"x":20, "y":50},
        {"x":30, "y":30}];    
    
bombki = r2d3.svg.selectAll("circle").data(bomb);

bombki.enter().append("circle")
  .attr("cx", function(d) {return scaleX(d.x);})
  .attr("cy", function(d) {return scaleY(d.y);})
  .attr("r", bom)
  .attr("fill", kol);

bombki.exit().remove();

bombki.transition()
  .duration(100)
  .attr("cx", function(d) {return scaleX(d.x);})
  .attr("cy", function(d) {return scaleY(d.y);})
  .attr("r", bom)
  .attr("fill", kol);
