var max_year = data[0].max_year;
var min_year = data[0].min_year;
var red = data[0].red;
var green = data[0].green;
var blue = data[0].blue;
var black = data[0].black;
var colourbar = data[0].colourbar;

//filtering data

var dane = data.filter(function(d){return d.year_of_birth >=  min_year;})
               .filter(function(d){return d.year_of_dead <= max_year;});

if (red === false){
 dane = dane.filter(function(d) {return d.colour!="red";});
}
if (green === false){
 dane = dane.filter(function(d) {return d.colour!="green";});
}
if (blue === false){
 dane = dane.filter(function(d) {return d.colour!="blue";});
}
if (black === false){
 dane = dane.filter(function(d) {return d.colour!="black";});
}

svg.selectAll("g").remove();
svg.selectAll("rect").remove();
svg.selectAll("#title").remove();

//title

var text1;
if(min_year < 0){
  text1 = -min_year + "BC";
}else{
  text1=min_year + "AC";
}
var text2;
if(max_year < 0){
  text2 = -max_year + "BC";
}else{
  text2 = max_year + "AC";
}

svg.append("text")
.attr("id", "title")
.attr("x", (width / 2))             
.attr("y", 40)
.style("text-anchor", "middle")
.style("font-size", "20px")
.style("text-decoration", "underline") 
.text("Population from " + text1 + " to " + text2);

//values

var years = [];
for(var i = min_year; i <= max_year; i++){
  if(i === 0){continue;}
  years.push(i);
}

var values = [];
for(var i = min_year; i <= max_year; i++){
  if(i === 0){continue;}
  var item = 0;
for(var j = 0; j < dane.length; j++){
  if(dane[j].year_of_birth <= i && dane[j].year_of_dead>=i){
    item += 1;
  }
}
values.push(item);
}

//axes

var x = d3.scaleLinear()
.range([30, width - 90])
.domain([min_year,max_year]);

svg.append("g")
.attr("transform", "translate("+ 50 +"," + 501 + ")")
.call(d3.axisBottom(x))
.selectAll("text")
    .attr("transform", "translate(0,0)");

var y = d3.scaleLinear()
  .domain([0, d3.max(values) + 5])
  .range([460, 40]);
  
svg.append("g")
.attr("transform", "translate("+ 50 +"," + 40 + ")")
  .call(d3.axisLeft(y));
  
svg.append("g")
.attr("transform", "translate("+ 499 +"," + 40  + ")")
  .call(d3.axisRight(y).tickValues([]));
  
var x1 = d3.scaleLinear()
.range([0, width - 50]);

svg.append("g")
.attr("transform", "translate("+ 50 +"," + 79  + ")")
  .call(d3.axisBottom(x1).tickValues([]));
  
svg.append("g")
.attr("transform", "translate("+ 50 +"," + 501  + ")")
  .call(d3.axisTop(x1).tickValues([]));

//axis titles

svg.append("text")
.attr("id", "title")
.attr("x", (width / 2)+20)             
.attr("y", 550)
.style("text-anchor", "middle")
.style("font-size", "14px")
.text("years");

svg.append("text")
.attr("id", "title")
.style("text-anchor", "middle")
.style("font-size", "14px")
  .attr("transform", "translate(20,300) rotate(270)")
  .text("population");
  
//grid

function ygrid() {
  return d3.axisLeft(y)
  .ticks(10);
}

svg.append("g")
.attr("class", "grid")
.attr("transform", "translate(50, 40)")
.call(ygrid()
.tickSize(-(width - 50) )
.tickFormat(""));

svg.selectAll("line")
.style("stroke", "lightgrey");

//bar chart

var data2 = d3.entries(values);
for(var i=0; i < values.length; i++){
  data2[i].key = years[i];
}

svg.selectAll("bar")
                .data(data2)
                .enter().append("rect")
                .attr("fill", colourbar)
                .attr("class", "bar")
                .attr("x", function (d) {
                    return x(d.key) + 45;
                })
                .attr("y", function (d) {
                    return y(d.value) + 41;
                })
                .attr("width", (width - 50 - 90 - 30)/values.length)
                .attr("height", function (d) {
                    return 501 - y(d.value) - 41;
                });
                