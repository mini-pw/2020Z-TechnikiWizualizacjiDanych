var margin = {top: 10, right: 20, bottom: 50, left: 50},
    width = 1100 - margin.left - margin.right,
    height = 620 - margin.top - margin.bottom;
    
   
var svgText2 = d3.select("#plot")
.append("svg")
.attr("id", "Text2")
.attr("height", 800)
.attr("width", document.body.clientWidth * 0.35)
.attr("transform", "translate (" + 50 + "," + -20 + ")" )

// Tekst
svgText2.append("foreignObject")
.attr("width", document.body.clientWidth * 0.35)
.attr("height", 1000)
.append("xhtml:div")
.style("font", "25px Helvetica Neue")
.html("<h1> PKB per capita oraz emisja gazów cieplarnianych</h1><p>Wraz z rozwojem gospodarki i zwiększeniem importu w państwach biedniejszych można się spodziewać rosnącej emisji dwutlenku węgla oraz metanu. W jakim stopniu natomiast udało się bogatszym państwom zmiejszyć tę emisję u siebie dzięki zwiększonemu importowi?</p>")


svgText2.append("text")
.style("font-size", "25px")
.text("Polska")
.attr("x", documentwidth * 0.04 )
.attr("y", 490)

svgText2.append("circle")
.attr("cx", documentwidth * 0.04 - 32 )
.attr("cy", 484)
.attr("r",15)
.attr('fill','#cc00cc')

svgText2.append("text")
.style("font-size", "25px")
.text("Niemcy")
.attr("x", documentwidth * 0.04 )
.attr("y", 550)

svgText2.append("circle")
.attr("cx", documentwidth * 0.04 - 32 )
.attr("cy", 544)
.attr("r",15)
.attr('fill','black')

svgText2.append("text")
.style("font-size", "25px")
.text("Francja")
.attr("x", documentwidth * 0.04 )
.attr("y", 610)

svgText2.append("circle")
.attr("cx", documentwidth * 0.04 -32 )
.attr("cy", 604)
.attr("r",15)
.attr('fill','blue')

svgText2.append("text")
.style("font-size", "25px")
.text("UK")
.attr("x", documentwidth * 0.04 )
.attr("y", 670)

svgText2.append("circle")
.attr("cx", documentwidth * 0.04 - 32)
.attr("cy", 664)
.attr("r",15)
.attr('fill','red')

//-------------

svgText2.append("text")
.style("font-size", "25px")
.text("Meksyk")
.attr("x", documentwidth * 0.04 + 32 + 260)
.attr("y", 490)

svgText2.append("circle")
.attr("cx", documentwidth * 0.04 + 260 )
.attr("cy", 484)
.attr("r",15)
.attr('fill','#e8cb4a')

svgText2.append("text")
.style("font-size", "25px")
.text("Turcja")
.attr("x", documentwidth * 0.04 + 32 + 260)
.attr("y", 550)

svgText2.append("circle")
.attr("cx", documentwidth * 0.04 + 260 )
.attr("cy", 544)
.attr("r",15)
.attr('fill','#326ba8')

svgText2.append("text")
.style("font-size", "25px")
.text("Brazylia")
.attr("x", documentwidth * 0.04 + 32 + 260)
.attr("y", 610)

svgText2.append("circle")
.attr("cx", documentwidth * 0.04 + 260 )
.attr("cy", 604)
.attr("r",15)
.attr('fill','#999900')

svgText2.append("text")
.style("font-size", "25px")
.text("Indonezja")
.attr("x", documentwidth * 0.04 + 32 + 260)
.attr("y", 670)

svgText2.append("circle")
.attr("cx", documentwidth * 0.04 + 260 )
.attr("cy", 664)
.attr("r",15)
.attr('fill','#ff1a75')


// Dodanie linii oddzielających instrukcje
svgText2.append("line")
.style("stroke", "black")  
  .attr("x1", 0)     
  .attr("y1", 450)      
  .attr("x2", 600)     
  .attr("y2", 450);    

svgText2.append("line")
.style("stroke", "black")  
  .attr("x1", 0)     
  .attr("y1", 705)      
  .attr("x2", 600)     
  .attr("y2", 705);    
   
   
var svg2 = d3.select("#gdpPlot")
  .append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform","translate(" + margin.left + "," + margin.top + ")");

var x = d3.scaleLinear()
    .domain([0, 50000])
    .range([ 20, width -10]);
  svg2.append("g")
	.style("font-size", "16px")
    .attr("transform", "translate(0," + (height-20)+ ")")
    .call(d3.axisBottom(x));

var y = d3.scaleLinear()
    .domain([0, 12])
    .range([ height-20, 0]);
  svg2.append("g")
	.style("font-size", "16px")
	.attr("transform", "translate(" + 20 + ",0)")
    .call(d3.axisLeft(y));
    

  
svg2.append("text")             
      .attr("transform","translate(" + (width/2) + " ," + (height + margin.top  + 35) + ")")
      .style("text-anchor", "middle")
	  .style("font", "24px Helvetica Neue")
      .text("PKB per Capita w $");

svg2.append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 0 - margin.left)
      .attr("x", 25 - (height / 2))
      .attr("dy", "1em")
      .style("text-anchor", "middle")
	  .style("font", "24px Helvetica Neue")
      .text("Emisja CO2 w tonach metrycznych na mieszkańca");  

    
var div = d3.select(".box2")
    .append("div")
      .style("opacity", 0)
      .attr("class", "tooltip")

var showTooltip = function(d, id) {
	//tooltip.style("top", (event.pageY-800)+"px").style("left",(event.pageX-800)+"px");}
    div
      .transition()
      .duration(200)
    div
      .style("opacity", 1)
      .html(d.country + ", "+ id)
      .style("left", (d3.event.pageX) + "px")// (d3.mouse(this)[0]+30) + "px")
      .style("top", (d3.event.pageY) + "px")//(d3.mouse(this)[1]+30) + "px")
	
  }
  
  
  var moveTooltip = function(d) {
    
    div
      .style("left", (d3.event.pageX) + "px")// (d3.mouse(this)[0]+30) + "px")
      .style("top", (d3.event.pageY) + "px")//(d3.mouse(this)[1]+30) + "px")
  }
  
  
  var hideTooltip = function(d) {
    div
      .transition()
      .duration(200)
      .style("opacity", 0)
  }    

//var cnt = ['USA', 'Japan', 'China', 'Germany', 'India', 'Great Britain', 'France', 'Italy', 'Brazil', 'Canada'];
var cnt = ['Niemcy', 'Wlk. Bryt.', 'Francja', 'Meksyk', 'Indonezja', 'Brazylia', 'Turcja'];

var getCol1 = function(cnt){
	if (cnt=="Niemcy") return "black";
	if (cnt=="Wlk. Bryt.") return "red";
	return "blue";
}

var getCol1 = function(cnt){
	if (cnt=="Niemcy") return "black";
	if (cnt=="Wlk. Bryt.") return "red";
	if (cnt=="Francja") return "blue";
	if (cnt=="Indonezja") return "#ff1a75";
	if (cnt=="Meksyk") return "#e8cb4a";
	if (cnt=="Turcja") return "#326ba8";
	if (cnt=="Brazylia") return "#999900";
	return "#cc00cc";
}

var getCol2 = function(cnt){
	if (cnt=="Niemcy") return "#14141f";
	if (cnt=="Wlk. Bryt.") return "#ff3333";
	if (cnt=="Francja") return "#3377ff";
	if (cnt=="Indonezja") return "#ff1a75";
	if (cnt=="Meksyk") return "#ffff99";
	if (cnt=="Turcja") return "#8080ff";
	if (cnt=="Brazylia") return "#33cc33";
	return "#ffd633";
}

    
var makeDots = function(){
  d3.csv("pkb.csv", function(data) {
  data = data.filter(function(d){return cnt.includes(d.country)})
  //data = data.filter(function(d){return d.year == document.getElementById('year').value})
  
  svg2.selectAll('circle').remove();
  svg2.append('g')
    .selectAll("dot")
    .data(data)
    .enter()
    .append("circle")
      .attr("class", "bubbles")
	  .attr("id", function (d) { return document.getElementById('year').value})
      .attr("cx", function (d) { return x(d['pkb' + document.getElementById('year').value]); } )
      .attr("cy", function (d) { return y(d['emission' + document.getElementById('year').value]); } )
      .attr("r", function (d) { return 20; } )
      .style("fill",  function(d){return getCol1(d.country)})
	  .on("mouseover", function(d){showTooltip(d,d3.select(this).attr("id"));})
      .on("mousemove", moveTooltip )
      .on("mouseleave", hideTooltip )
})}

var moveDots = function(year1){
  d3.csv("pkb.csv", function(data) {
  data = data.filter(function(d){return cnt.includes(d.country)})
  //data = data.filter(function(d){return d.year == document.getElementById('year').value})
  svg2.selectAll('circle').attr("r",7).style('fill', function(d){return getCol1(d.country);}) //lightblue
  svg2.append('g')
    .selectAll("dot")
    .data(data)
    .enter()
    .append("circle")
      .attr("class", "bubbles")
	  .attr("id", function (d) { return document.getElementById('year').value})
      .attr("cx", function (d) { return x(d['pkb' + year1]); } )
      .attr("cy", function (d) { return y(d['emission' + year1]); } )
      .attr("r", function (d) { return 20; } )
      .style("fill",  function(d){return getCol1(d.country);})
	  .on("mouseover", function(d){
		showTooltip(d,d3.select(this).attr("id"));
	} )
    .on("mousemove", moveTooltip )
    .on("mouseleave", hideTooltip )
    .transition()
      .duration(180)
      .attr("cx", function (d) { return x(d['pkb' + document.getElementById('year').value]); } )
      .attr("cy", function (d) { return y(d['emission' + document.getElementById('year').value]); } )
})}


var makeDots2 = function(){
  d3.csv("pkb.csv", function(data) {
  data = data.filter(function(d){return cnt.includes(d.country)})
  //data = data.filter(function(d){return d.year == document.getElementById('year').value})
  
  svg2.selectAll('circle').remove();
  svg2.append('g')
    .selectAll("dot")
    .data(data)
    .enter()
    .append("circle")
      .attr("class", "bubbles")
	  .attr("id", function (d) { return document.getElementById('year').value})
      .attr("cx", function (d) { return x(d['pkb' + document.getElementById('year').value]); } )
      .attr("cy", function (d) { return y(d['emissionn' + document.getElementById('year').value]); } )
      .attr("r", function (d) { return 20; } )
      .style("fill",  function(d){return getCol1(d.country)})
	  .on("mouseover", function(d){showTooltip(d,d3.select(this).attr("id"));})
      .on("mousemove", moveTooltip )
      .on("mouseleave", hideTooltip )
})}

var moveDots2 = function(year1){
  d3.csv("pkb.csv", function(data) {
  data = data.filter(function(d){return cnt.includes(d.country)})
  //data = data.filter(function(d){return d.year == document.getElementById('year').value})
  svg2.selectAll('circle').attr("r",7).style('fill', function(d){return getCol1(d.country);}) //lightblue
  svg2.append('g')
    .selectAll("dot")
    .data(data)
    .enter()
    .append("circle")
      .attr("class", "bubbles")
	  .attr("id", function (d) { return document.getElementById('year').value})
      .attr("cx", function (d) { return x(d['pkb' + year1]); } )
      .attr("cy", function (d) { return y(d['emissionn' + year1]); } )
      .attr("r", function (d) { return 20; } )
      .style("fill",  function(d){return getCol1(d.country);})
	  .on("mouseover", function(d){
		showTooltip(d,d3.select(this).attr("id"));
	} )
    .on("mousemove", moveTooltip )
    .on("mouseleave", hideTooltip )
    .transition()
      .duration(180)
      .attr("cx", function (d) { return x(d['pkb' + document.getElementById('year').value]); } )
      .attr("cy", function (d) { return y(d['emissionn' + document.getElementById('year').value]); } )
})}
    

var changeYear = function(){
  var a = document.getElementById("newCnt").value;
  var lastCnt = 'Turcja';
  if(a == '0'){
    if(cnt[cnt.length - 1] != lastCnt){cnt.pop();}
	if(document.getElementById("emission").value == 0) makeDots();
	if(document.getElementById("emission").value == 1) makeDots2();
  }
  if(a == 'Polska'){
    if(cnt[cnt.length - 1] != lastCnt){cnt.pop();}
   cnt.push('Polska');
    if(document.getElementById("emission").value == 0) makeDots();
	if(document.getElementById("emission").value == 1) makeDots2();
  }
  
}

makeDots();

var myInput = document.getElementById('year');
var myInputCntnr = document.getElementById('gdpPlot');
var prevYear;
myInputCntnr.onwheel = function(e) {
  prevYear = myInput.value
  if(e.deltaY < 1 && myInput.value < 2017) {
    myInput.value++;
  } else if (e.deltaY > -1 && myInput.value > 1994) {
    myInput.value--;
  }
  
  if(document.getElementById("emission").value == 0) moveDots(prevYear);
  if(document.getElementById("emission").value == 1) moveDots2(prevYear);
  return false;
}



var drawCO2 = function(){
	x = d3.scaleLinear()
    .domain([0, 50000])
    .range([ 20, width -10]);
	svg2.append("g")
	.style("font-size", "16px")
    .attr("transform", "translate(0," + (height-20)+ ")")
    .call(d3.axisBottom(x));

	y = d3.scaleLinear()
    .domain([0, 12])
    .range([ height-20, 0]);
	svg2.append("g")
	.style("font-size", "16px")
	.attr("transform", "translate(" + 20 + ",0)")
    .call(d3.axisLeft(y));

	svg2.append("text")             
      .attr("transform","translate(" + (width/2) + " ," + (height + margin.top + 35) + ")")
      .style("text-anchor", "middle")
	  .style("font", "24px Helvetica Neue")
      .text("PKB per Capita w $");

	svg2.append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 0 - margin.left)
      .attr("x", 25 - (height / 2))
      .attr("dy", "1em")
      .style("text-anchor", "middle")
	  .style("font", "24px Helvetica Neue")
      .text("Emisja CO2 w tonach metrycznych na mieszkańca");  
	
	makeDots();
  
}


var drawCH4 = function(){
	
	x = d3.scaleLinear()
    .domain([0, 50000])
    .range([ 20, width -10]);
	svg2.append("g")
	.style("font-size", "16px")
    .attr("transform", "translate(0," + (height-20)+ ")")
    .call(d3.axisBottom(x));

	y = d3.scaleLinear()
    .domain([0, 3.25])
    .range([ height-20, 0]);
	svg2.append("g")
	.style("font-size", "16px")
	.attr("transform", "translate(" + 20 + ",0)")
    .call(d3.axisLeft(y));
	
	svg2.append("text")             
      .attr("transform","translate(" + (width/2) + " ," + (height + margin.top+35) + ")")
      .style("text-anchor", "middle")
	  .style("font", "24px Helvetica Neue")
      .text("PKB per Capita w $");

	svg2.append("text")
      .attr("transform", "rotate(-90)")
      .attr("y", 0 - margin.left)
      .attr("x", 25 - (height / 2))
      .attr("dy", "1em")
      .style("text-anchor", "middle")
	  .style("font", "24px Helvetica Neue")
      .text("Emisja CH4 w tonach metrycznych na mieszkańca");  
	
	makeDots2();
	
}


var changeEmission = function(){
	svg2.selectAll('g').remove();
	svg2.selectAll('text').remove();
	if(document.getElementById("emission").value == 0) drawCO2();
	if(document.getElementById("emission").value == 1) drawCH4();
}


  
  