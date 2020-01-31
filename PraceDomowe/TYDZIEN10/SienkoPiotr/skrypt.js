// usuwam poprzedni wykres

svg.selectAll("g").remove();
svg.selectAll("text").remove();


DataDragons = data;

// Filtruje zmienne w zależności od ustawień kontrolek
if(DataDragons[0].colors != "all"){
  DataDragons = DataDragons.filter(function(d) {return d.colour == DataDragons[0].colors});
}

DataDragons = DataDragons.filter(function(d) { return d.year_of_discovery <= DataDragons[0].discovery});

if(DataDragons[0].variable == "scars"){
  Scale = 80;

}
else{
  Scale = 40;
}

// oś x
var x = d3.scaleLinear()
.range([0, 1400])
.domain([500, 4000]);

svg.append("g")
  .attr("transform", "translate(100, 520)")
  .call(d3.axisBottom(x));
    
// oś y
var y = d3.scaleLinear()
  .range([520, 10])
  .domain([0, Scale]);
  
svg.append("g")
  .attr("transform", "translate(100, 0)")
  .call(d3.axisLeft(y));
  

// Tworze punkty w zależności od wybranej zmiennej
if(DataDragons[0].variable == "scars"){
svg.append('g')
    .selectAll("dot")
    .data(DataDragons)
    .enter()
    .append("circle")
      .attr("cx", function (d) { return x(d.life_length); } )
      .attr("cy", function (d) { return y(0); } )
      .attr("transform", "translate(100, 0)")
      .attr("r", 2)
      .style("fill", function(d) { return d.colour});
      
// Ustawiam animacje
svg.selectAll("circle")
  .transition()
  .delay(function(d,i){return(i*1)})
  .duration(750)
  .attr("cx", function (d) { return x(d.life_length); } )
  .attr("cy", function (d) { return y(d.scars); } );
  
// Dodanie tytułu osi Y
svg.append("text")
.attr("class", "title")
.attr("transform", "rotate(-90)")
.attr("y", 50)
.attr("x", -260)
.style("text-anchor", "middle")
.style("font-size", "30px")
.text("Liczba blizn");
  
}

else{
  svg.append('g')
    .selectAll("dot")
    .data(DataDragons)
    .enter()
    .append("circle")
      .attr("cx", function (d) { return x(d.life_length); } )
      .attr("cy", function (d) { return y(0); } )
      .attr("transform", "translate(100, 0)")
      .attr("r", 2)
      .style("fill", function(d) { return d.colour});
      
// Ustawiam animacje
svg.selectAll("circle")
  .transition()
  .delay(function(d,i){return(i*1)})
  .duration(750)
  .attr("cx", function (d) { return x(d.life_length); } )
  .attr("cy", function (d) { return y(d.number_of_lost_teeth); } );
  
// Dodanie tytułu osi Y
svg.append("text")
  .attr("class", "title")
  .attr("transform", "rotate(-90)")
  .attr("y", 50)
  .attr("x", -260)
  .style("text-anchor", "middle")
  .style("font-size", "30px")
  .text("Liczba utraconych zębów");
}
 
// Podpis Oś X 
svg.append("text")
.attr("class", "title")
.attr("y", 580)
.attr("x", 800)
.style("text-anchor", "middle")
.style("font-size", "30px")
.text("Wiek Smoka w latach");
    
    





