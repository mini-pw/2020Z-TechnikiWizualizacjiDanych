var statistics = data[0].statistics;
var colourpoints = data[0].colourpoints;
var information = data[0].information;

svg.selectAll("g").remove();
svg.selectAll("circle").remove();
svg.selectAll("#title").remove();

//title

var text1;
if(information == "scars") { text1 = "number of scars";}
if(information == "weight") {text1 = "weight of the dragon";}
if(information == "height") {text1 = "height of the dragon";}
if(information == "number_of_lost_teeth") {text1 = "number of teeth that the dragon lost";}
var text2;
if(statistics == "max") {text2 = "Maximum ";}
if(statistics == "min") {text2 = "Minimum ";}
if(statistics == "mean") {text2 = "Average ";}

svg.append("text")
.attr("id", "title")
.attr("x", (width / 2))             
.attr("y", 40)
.style("text-anchor", "middle")
.style("font-size", "20px")
.style("text-decoration", "underline") 
.text(text2+ text1);

//axis titles 

svg.append("text")
.attr("id", "title")
.attr("x", (width / 2)+20)             
.attr("y", 550)
.style("text-anchor", "middle")
.style("font-size", "14px")
.text("dragon colour");

svg.append("text")
.attr("id", "title")
.style("text-anchor", "middle")
.style("font-size", "14px")
  .attr("transform", "translate(30,300) rotate(270)")
  .text(text1);

//values

var groupedbycolour = d3.nest()
  .key(function(d) { return d.colour; })
  .rollup(function(v) {
    if(statistics == "mean"){
      return d3.mean(v, function(d) { return d[information]; });
    }else if(statistics == "min"){
      return d3.min(v, function(d) { return d[information]; });
    }else{
      return d3.max(v, function(d) { return d[information]; });
    }})
  .entries(data);

//axes

var x = d3.scaleBand()
.range([0, width - 80])
.domain(data.map(function(d){ return d.colour;}))
.padding(0);

svg.append("g")
.attr("transform", "translate("+ 70 +"," + 501 + ")")
.call(d3.axisBottom(x))
.selectAll("text")
    .attr("transform", "translate(0,0)");


var valueY = groupedbycolour.map(function(d){ return d.value });
var max =  d3.max(valueY) + d3.mean(valueY)/2;

var y = d3.scaleLinear()
  .domain([0, max])
  .range([460, 40]);
  
svg.append("g")
.attr("transform", "translate("+ 70 +"," + 40 + ")")
  .call(d3.axisLeft(y));
  
svg.append("g")
.attr("transform", "translate("+ 460 +"," + 40  + ")")
  .call(d3.axisLeft(y).tickValues([]));
  
//grid
      
function ygrid() {
  return d3.axisLeft(y)
  .ticks(10);
}

svg.append("g")
.attr("class", "grid")
.attr("transform", "translate(70, 40)")
.call(ygrid()
.tickSize(-(width - 79) )
.tickFormat(""));

svg.selectAll("line")
.style("stroke", "lightgrey");

// points

var div = d3.select("body").append("div")	
    .attr("class", "tooltip")				
    .style("opacity", 0);
    
svg.selectAll("dot")	
        .data(groupedbycolour)			
        .enter()
        .append("circle")								
        .attr("r", 4)		
        .attr("cx", function(d) { return x(d.key) + 120; })		 
        .attr("cy", function(d) { return y(d.value) + 40; })
        .style("fill", colourpoints)
        .on("mouseover", function(d) {		
            div.transition()		
                .duration(200)		
                .style("opacity", 0.9);		
            div	.html(d.value)	
                .style("left", (d3.event.pageX) + "px")		
                .style("top", (d3.event.pageY - 28) + "px");	
            })					
        .on("mouseout", function(d) {		
            div.transition()		
                .duration(500)		
                .style("opacity", 0);	
        });
