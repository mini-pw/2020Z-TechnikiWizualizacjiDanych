var area1 = data[0].area1;
var colour1 = data[0].colour1;
var area2 = data[0].area2;
var colour2 = data[0].colour2;


svg.selectAll("g").remove();
svg.selectAll("#title").remove();

//title

if(area2 == "None"){
svg.append("text")
.attr("id", "title")
.attr("x", (width / 2))             
.attr("y", 30)
.style("text-anchor", "middle")
.style("font-size", "20px")
.style("text-decoration", "underline") 
.text(area1);
}else{
svg.append("text")
.attr("id", "title")
.attr("x", (width / 2))             
.attr("y", 30)
.style("text-anchor", "middle")
.style("font-size", "20px")
.style("text-decoration", "underline") 
.text(area1 + " vs " + area2);
}


if(area1 == "USA and CAN"){area1 = "USAandCAN";}
if(area1 == "Euro area"){area1 = "Euroarea";}
if(area1 == "East Asia excluding China"){area1 = "EastAsiaexcludingChina";}
if(area1 == "Other EMDEs"){area1 = "OtherEMDEs";}
if(area1 == "United Kingdom"){area1 = "UnitedKingdom";}
if(area1 == "Rest of world"){area1 = "Restofworld"}

if(area2 == "USA and CAN"){area2 = "USAandCAN";}
if(area2 == "Euro area"){area2 = "Euroarea";}
if(area2 == "East Asia excluding China"){area2 = "EastAsiaexcludingChina";}
if(area2 == "Other EMDEs"){area2 = "OtherEMDEs";}
if(area2 == "United Kingdom"){area2 = "UnitedKingdom";}
if(area2 == "Rest of world"){area2 = "Restofworld"}

//scale, grid, axis

var x = d3.scaleBand()
.range([0, width - 200])
.domain(data.map(function(d){ return d.Year;})). 
padding(0);

svg.append("g")
.attr("transform", "translate("+ 100 +"," + 370 + ")")
.call(d3.axisBottom(x))
.selectAll("text")
    .attr("transform", "translate(0,0)");

var y = d3.scaleLinear()
  .domain([-1, 2])
  .range([370, 50]);

r2d3.svg.append("g")
  .attr("transform", "translate(100, 0)")
  .call(d3.axisLeft(y));


function ygrid() {
  return d3.axisLeft(y)
  .ticks(5);
}

svg.append("g")
.attr("class", "grid")
.attr("transform", "translate(100, 0)")
.call(ygrid()
.tickSize(-(width - 200) )
.tickFormat(""));

svg.selectAll("line")
.style("stroke", "lightgrey");

//line

svg.append('g')
      .append("path")
      .datum(data)
      .attr("d", d3.line()
          .x(function(d) { return x(d.Year) + 130 })
          .y(function(d) { return 370 }))
      .attr("stroke", colour1)
      .style("stroke-width", 3)
        .style("fill", "none")
      .transition()
          .duration(1000)
          .attr("d", d3.line()
            .x(function(d) { return x(d.Year) + 130 })
            .y(function(d) { return y(d[area1]) })
          );

if(area2 != "None"){
  svg.append('g')
      .append("path")
      .datum(data)
      .attr("d", d3.line()
          .x(function(d) { return x(d.Year) + 130 })
          .y(function(d) { return 370 }))
      .attr("stroke", colour2)
      .style("stroke-width", 3)
        .style("fill", "none")
      .transition()
          .duration(1000)
          .attr("d", d3.line()
            .x(function(d) { return x(d.Year) + 130 })
            .y(function(d) { return y(d[area2]) })
          );
}