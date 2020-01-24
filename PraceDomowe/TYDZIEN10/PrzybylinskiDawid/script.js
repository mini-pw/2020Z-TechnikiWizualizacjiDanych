svg.selectAll("circle").remove();
svg.selectAll("text").remove();
svg.selectAll("g").remove();

dane = data;

//filtr po bliznach
if (dane[0].choice == "Calm (less than 20 scars)"){
 dane = data.filter(function(d) {return d.scars<20;});
}
else if (dane[0].choice == "Fierce (at least 20 scars)"){
 dane = data.filter(function(d) {return d.scars>=20;});
}

//filtr po kolorze 
if (dane[0].red === false){
 dane = dane.filter(function(d) {return d.colour!="red";});
}

if (dane[0].green === false){
 dane = dane.filter(function(d) {return d.colour!="green";});
}
if (dane[0].black === false){
 dane = dane.filter(function(d) {return d.colour!="black";});
}
if (dane[0].blue === false){
 dane = dane.filter(function(d) {return d.colour!="blue";});
}

// skale, osie, i podpisy osi
var xscale = d3.scaleLinear()
    .domain([0, 4000])
    .range([0, width-100]);

var yscale = d3.scaleLinear()
        .domain([0, 14])
        .range([height/1.4, 0]);

var x_axis = d3.axisBottom()
        .scale(xscale);

var y_axis = d3.axisLeft()
        .scale(yscale);

    svg.append("g")
       .attr("transform", "translate(50, 10)")
       .call(y_axis);

    svg.append("g")
            .attr("transform", "translate(50, " + (height/1.4 + 10)  +")")
            .call(x_axis);
            
    svg.append("text")             
      .attr("transform", "translate(" + (width/2) + " ," + (height - 50) + ")")
      .style("text-anchor", "middle")
      .text("Dragon life length");
      
    svg.append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 0)
      .attr("x",0 - (height / 2) + 50)
      .attr("dy", "1em")
      .style("text-anchor", "middle")
      .text("Dragon Body Mass Index"); 
      
      
    svg.append("text")             
      .attr("transform", "translate(" + (width/2) + " ," + (height - 20) + ")")
      .style("text-anchor", "middle")
      .text("Dragon BMI equals weight/height^2[kg/m^2]");

//tworzenie siatki
function create_grid() {
  return d3.axisLeft(yscale)
  .ticks(10);
}

svg.append("g")
.attr("class", "grid")
.attr("transform", "translate(50, 10)")
.call(create_grid()
.tickSize(-(width - 100) )
.tickFormat("")
);

svg.selectAll("line")
.style("stroke", "lightgrey");

// tworzenie punktow na wykresie
svg.selectAll("dot")
  .data(dane)
  .enter()
  .append("circle")
    .attr("cx", function (d) { return xscale(d.life_length)+50; } )
    .attr("cy", function (d) { return yscale(d.BMI); } )
    .attr("r", 2.3)
    .style("fill", function(d){ 
      if (d.colour == "black") {return "black"}
      if (d.colour == "red") {return "red"}
      if (d.colour == "blue") {return "#0b77bf"}
      if (d.colour == "green") {return "#59ed42"}
    });
  