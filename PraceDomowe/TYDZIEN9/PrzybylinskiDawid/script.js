svg.selectAll("rect").remove();
svg.selectAll("text").remove();
svg.selectAll("g").remove();

dane = data;
Scale = 800;

// wybór kategorii
if (dane[0].choice == "Wszystkie"){
  dane = data.filter(function(d) {return d.type == "all_notes";});
}
else if (dane[0].choice == "Obie kategorie"){dane = data;}
else{dane = data.filter(function(d) { return d.type == "only20"});}

// tworzenie osi x
var x = d3.scaleBand()
.range([0, width-400])
.domain(dane.map(function(d){return d.years;}))
.padding(0.3);

// podpisy na osi x
r2d3.svg.append("g")
.attr("transform", "translate(100, 320)")
.call(d3.axisBottom(x))
.selectAll("text")
    .attr("transform", "translate(0,0)");
    
// tworzenie osi y
var y = d3.scaleLinear()
  .domain([0, Scale])
  .range([320, 10]);
r2d3.svg.append("g")
  .attr("transform", "translate(100, 0)")
  .call(d3.axisLeft(y));
  
// funkcja tworząca siatkę
function create_grid() {
  return d3.axisLeft(y)
  .ticks(10);
}

// tworzenie siatki
svg.append("g")
.attr("class", "grid")
.attr("transform", "translate(100, 0)")
.call(create_grid()
.tickSize(-(width - 400) )
.tickFormat("")
);

// zmiana koloru siatki
svg.selectAll("line")
.style("stroke", "lightgrey");

// tworzenie poczatkowych barów
svg.selectAll("bar")
  .data(dane)
  .enter()
  .append("rect")
    .attr("x", function(d) {return x(d.years)+100;})
    .attr("width", x.bandwidth())
    .attr("height", function(d) {return height-y(0)-80;})
    .attr("y", function(d) { return y(0); })
    .attr("fill", function(d){ 
      if (d.type == "all_notes") {
        if (dane[0].col1 == "czerwony") {return "red";}
        if (dane[0].col1 == "niebieski") {return "blue";}
        if (dane[0].col1 == "zielony") {return "green";}
      } 
      else {
        if (dane[0].col2 == "czerwony") return "red";
        if (dane[0].col2 == "niebieski") return "blue";
        if (dane[0].col2 == "zielony") return "green"; 
      }
    });
    
// transition dla słupków
svg.selectAll("rect")
  .transition()
  .duration(750)
  .attr("y", function(d) {return y(d.quantities)})
  .attr("height", function(d) {return y(0)-y(d.quantities)})
  .delay(function(d,i) {return(i*10)});
  
svg.selectAll("text")
  .style("font-size", "15px");

// Tworzenie tytułu osi y
svg.append("text")
.attr("transform", "rotate(-90)")
.attr("y", 30)
.attr("x", -170)
.style("text-anchor", "middle")
.style("font-size", "20px")
.text("Liczba banknotów (w tysiąch)");

