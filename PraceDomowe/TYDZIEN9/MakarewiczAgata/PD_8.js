// usuwamy poprzedni obrazek
svg.selectAll("rect").remove();
svg.selectAll("text").remove();
svg.selectAll("g").remove();

// dodajemy oś x
var x = d3.scaleBand()
  .range([ 0, width - 200 ])
  .domain(data.map(function(d) { return d.Group; }))
  // ustalamy przerwy między słupkami
  .padding(0.3);

r2d3.svg.append("g")
.attr("transform", "translate(100, 350)")
.call(d3.axisBottom(x))
.selectAll("text")
    .attr("transform", "translate(0,0)");

// dodajemy oś y
var y = d3.scaleLinear()
  .domain([0, 100])
  .range([350, 10]);

r2d3.svg.append("g")
  .attr("transform", "translate(100, 0)")
  .call(d3.axisLeft(y));


// dodajemy linie siatki ( poziome )
function ygrid() {
  return d3.axisLeft(y)
  .ticks(10);
}

r2d3.svg.append("g")
.attr("class", "grid")
.attr("transform", "translate(100, 0)")
.call(ygrid()
.tickSize(-(width - 200) )
.tickFormat("")
);


// wybieramy styl linii siatki
r2d3.svg.selectAll("line")
.style("stroke", "lightgrey");


// tworzymy bar plot 
r2d3.svg.selectAll("bar")
  .data(r2d3.data)
  .enter()
  .append("rect")
  // group, value - nadajemy nazwy kolumn w app.R
    .attr("x", function(d) { return x(d.Group) + 100; })
    .attr("y", function(d) { return y(0); })
    .attr("width", x.bandwidth())
    .attr("height", function(d) { return height - 80 - y(0); })
     // col - kolor dołączamy jako kolumnę do ramki danych  w app.R 
    .attr("fill",function(d){ return d.col});
    
// dodanie "opóźnienia" - słupki za każdym razem "rosną" od nowa
r2d3.svg.selectAll("rect")
  .transition()
  .duration(800)
  .attr("y", function(d) {return y(d.Value)})
  .attr("height", function(d) { return y(0) - y(d.Value) });
  
r2d3.svg.selectAll("text")
  .style("font-size", "13px");
  
// dodanie ylabel (w dwóch częściach)  
r2d3.svg.append("text")
  .attr("class", "title")
  .attr("transform", "rotate(-90)")
  .attr("y", 35)
  .attr("x", -180)
  .style("text-anchor", "middle")
  .style("font-size", "18px")
  .text("% of respondents citing each reason");
  
r2d3.svg.append("text")
  .attr("class", "title")
  .attr("transform", "rotate(-90)")
  .attr("y", 50)
  .attr("x", -180)
  .style("text-anchor", "middle")
  .style("font-size", "15px")
  .text("(more than one could be given)");
  
// próba dodania procentów na każdym słupku
// wyświetlają się na osi x 
/*
var textlabels = r2d3.svg.selectAll("text").data(r2d3.data);

textlabels.attr('y', function(d) { return y(d.Group) })
    .attr('x', function(d) { return x(d.Value) })
    .attr("font-size", "15px")
    .text(function(d) { return d.Value.toString().concat("%"); });*/
