// usuwam poprzedni wykres
svg.selectAll("rect").remove();
svg.selectAll("text").remove();
svg.selectAll("g").remove();


dataWeek = data;
Scale = 35;

// wybieram okres z którego pochodzą dane
if (dataWeek[0].data == "Week"){
  dataWeek = dataWeek.filter(function(d) { return d.Type == "1 week"; });
  Scale = 2;
}
else{
dataWeek = dataWeek.filter(function(d) { return d.Type == "YTD"});
}

// "wyciągam" liczbę kolumn które trzeba pokazać
numberOfElements = dataWeek[0].list;
// obcinam ramkę z danymi
dataWeek = dataWeek.slice(dataWeek.length - numberOfElements);

// oś x
var x = d3.scaleBand()
.range([0, width-400])
.domain(dataWeek.map(function(d){ return d.Sector; }))
.padding(0.4);

// podpisy osi x
r2d3.svg.append("g")
.attr("transform", "translate(100, 320)")
.call(d3.axisBottom(x))
.selectAll("text")
    .attr("transform", "translate(0,0)");
    
// oś y
var y = d3.scaleLinear()
  .domain([0, Scale])
  .range([320, 10]);
  
r2d3.svg.append("g")
  .attr("transform", "translate(100, 0)")
  .call(d3.axisLeft(y));
  
// funkcja tworząca siatkę
function ygrid() {
  return d3.axisLeft(y)
  .ticks(10);
}

//  tworzenie siatki y
svg.append("g")
.attr("class", "grid")
.attr("transform", "translate(100, 0)")
.call(ygrid()
.tickSize(-(width - 400) )
.tickFormat("")
);

// zmiana stylu siatki
svg.selectAll("line")
.style("stroke", "grey");


// tworzenie wykresu początkowego - słupki mają na razie h = 0
svg.selectAll("bar")
  .data(dataWeek)
  .enter()
  .append("rect")
    .attr("x", function(d) { return x(d.Sector) + 100; })
    .attr("width", x.bandwidth())
    .attr("fill", dataWeek[0].col)
    
    .attr("height", function(d) { return height - y(0) - 80; })
    .attr("y", function(d) { return y(0); });
    
// opóźnienie tworzenia słupków
svg.selectAll("rect")
  .transition()
  .duration(800)
  .attr("y", function(d) {return y(d.Value)})
  .attr("height", function(d) { return y(0) - y(d.Value) })
  .delay(function(d,i){ return(i*10)});
  
svg.selectAll("text")
  .style("font-size", "15px");

// Tworzenie tytułu osi y
svg.append("text")
.attr("class", "title")
.attr("transform", "rotate(-90)")
.attr("y", 30)
.attr("x", -160)
.style("text-anchor", "middle")
.style("font-size", "25px")
.text("Sector Returns in %");


