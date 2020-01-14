svg.selectAll("g").remove();
svg.selectAll(".dot").remove();
svg.selectAll(".dott").remove();

var value = data[0].pickedColumn;
var value2 = data[0].colToCompare;

var margin = {top: 0, right: width / 24, bottom: height / 30, left: 0},
    width = width - margin.left - margin.right,
    height = height - margin.top - margin.bottom,
    barWidth = Math.floor(width / 19) - 1;


// dyskretna
var x = d3.scaleBand()
.range([0, width-300])
.domain(data.map(function(d){ return d.Rok; })). 
padding(0);

r2d3.svg.append("g")
.attr("transform", "translate("+100+"," + 320 + ")")
.call(d3.axisBottom(x))
.selectAll("text")
    .attr("transform", "translate(0,0)");

// grid y    
function ygrid() {
  return d3.axisLeft(y)
  .ticks(10);
}

// oś y
var y = d3.scaleLinear()
  .domain([0, 7000])
  .range([320, 10]);
  
r2d3.svg.append("g")
  .attr("transform", "translate(100, 0)")
  .call(d3.axisLeft(y));
  

function ygrid() {
  return d3.axisLeft(y)
  .ticks(15);
}

svg.append("g")
.attr("class", "grid")
.attr("transform", "translate(100, 0)")
.call(ygrid()
.tickSize(-(width - 300) )
.tickFormat(""));

// nie chcemy czarnego
svg.selectAll("line")
.style("stroke", "lightgrey");

// opis osi Y
svg.append("text")
.attr("class", "title")
.attr("transform", "rotate(-90)")
.attr("y", 40)
.attr("x", -170)
.style("text-anchor", "middle")
.style("font-size", "15px")
.text("Przeciętne miesięczne wynagrodzenie brutto");

var toAdd = 120 ; 

// linia 1 
svg.append('g')
      .append("path")
      .datum(data)
      .attr("d", d3.line()
          .x(function(d) { return x(d.Rok)+toAdd })
          .y(function(d) { return 320 }))
      .attr("stroke", data[0].lineCol2)
      .style("stroke-width", 4)
        .style("fill", "none")
      .transition()
          .duration(1000)
          .attr("d", d3.line()
            .x(function(d) { return x(d.Rok)+toAdd  })
            .y(function(d) { return y(d[value2]) })
          );
      
// punkt 1 
svg.selectAll(".dot")
      .data(data)
      .enter()
      .append("circle")
      .attr("class", "dot")
      .attr("r", 3.5)
      .attr("cx", function(d) { return x(d.Rok)+toAdd; })
      .attr("cy", function(d) { return 320; })
      .style("fill", data[0].dotCol2)
      .transition()
      .duration(1000)
      .attr("cx", function(d) { return x(d.Rok)+toAdd; })
      .attr("cy", function(d) { return y(d[value2]); });




svg.append('g')
      .append("path")
      .datum(data)
      .attr("d", d3.line()
          .x(function(d) { return x(d.Rok)+toAdd })
          .y(function(d) { return 320 }))
      .attr("stroke", data[0].lineCol)
      .style("stroke-width", 4)
        .style("fill", "none")
      .transition()
          .duration(1000)
          .attr("d", d3.line()
            .x(function(d) { return x(d.Rok)+toAdd  })
            .y(function(d) { return y(d[value]) })
          );
      

svg.selectAll(".dott")
      .data(data)
      .enter()
      .append("circle")
      .attr("class", "dot")
      .attr("r", 3.5)
      .attr("cx", function(d) { return x(d.Rok)+toAdd; })
      .attr("cy", function(d) { return 320; })
      .style("fill", data[0].dotCol)
      .transition()
      .duration(1000)
      .attr("cx", function(d) { return x(d.Rok)+toAdd; })
      .attr("cy", function(d) { return y(d[value]); });
      

