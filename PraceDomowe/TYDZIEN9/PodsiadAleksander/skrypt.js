svg.selectAll("rect").remove();
svg.selectAll("text").remove();
svg.selectAll("g").remove();


dane = data;
Scale = 100;

if (dane[0].gend == "Male"){
  dane = dane.filter(function(d) { return d.Gender == "men"; });
}
else if (dane[0].gend == "Female"){
dane = dane.filter(function(d) { return d.Gender == "women";});
}
else{}

if (!dane[0].lab){dane = dane.filter(function(d) { return d.Position != "Labour Force";})}
if (!dane[0].man){dane = dane.filter(function(d) { return d.Position != "Managers";})}
if (!dane[0].sen){dane = dane.filter(function(d) { return d.Position != "Senior Mngr.";})}
if (!dane[0].com){dane = dane.filter(function(d) { return d.Position != "Co. Boards";})}
if (!dane[0].topp){dane = dane.filter(function(d) { return d.Position != "TOP 0.1%";})}
if (!dane[0].ceo){dane = dane.filter(function(d) { return d.Position != "CEO'S";})}

var x = d3.scaleBand()
  .range([0, width-200])
  .domain(dane.map(function(d){ return d.Position; }))
  .padding(0.4);

r2d3.svg.append("g")
.attr("transform", "translate(100, 320)")
.call(d3.axisBottom(x))
.selectAll("text")
    .attr("transform", "translate(0,0)");
    
var y = d3.scaleLinear()
  .domain([0, Scale])
  .range([320, 10]);
  
r2d3.svg.append("g")
  .attr("transform", "translate(100, 0)")
  .call(d3.axisLeft(y));
  
function ygrid() {
  return d3.axisLeft(y)
  .ticks(10);
}

svg.append("g")
.attr("class", "grid")
.attr("transform", "translate(100, 0)")
.call(ygrid()
.tickSize(-(width - 200) )
.tickFormat("")
);

svg.selectAll("line")
.style("stroke", "grey");

svg.selectAll("bar")
  .data(dane)
  .enter()
  .append("rect")
    .attr("x", function(d) { return x(d.Position) + 100; })
    .attr("width", x.bandwidth())
    .attr("fill", function(d) { if (d.Gender == "women") return "red"; else return "blue";})
    
    .attr("height", function(d) { return height - y(0) - 80; })
    .attr("y", function(d) { return y(0); });
    
svg.selectAll("rect")
  .transition()
  .duration(800)
  .attr("y", function(d) {return y(d.Percentage)})
  .attr("height", function(d) { return y(0) - y(d.Percentage) })
  .delay(function(d,i){ return(i*10)});
  
svg.selectAll("text")
  .style("font-size", "15px");


