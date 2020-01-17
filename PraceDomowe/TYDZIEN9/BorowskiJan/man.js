// set the dimensions and margins of the graph
svg.selectAll("*").remove()
var margin = {top: 30, right: 30, bottom: 70, left: 60},
    width = 460 - margin.left - margin.right,
    height = 400 - margin.top - margin.bottom;

var svg = 
  svg.append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
  .append("g")
    .attr("transform",
          "translate(" + margin.left + "," + margin.top + ")");

   var groups = d3.map(data, function(d){return(d.V2)}).keys()
  // X axis
  var x = d3.scaleBand()
    .range([ 0, width ])
    .domain(groups)
    .padding(0.2);
  svg.append("g")
    .attr("transform", "translate(0," + height + ")")
    .call(d3.axisBottom(x))
    .selectAll("text")
      .attr("transform", "translate(-10,0)rotate(-45)")
      .style("text-anchor", "end");

  // Add Y axis
  var y = d3.scaleLinear()
    .domain([0, 100])
    .range([ height, 0]);
  svg.append("g")
    .call(d3.axisLeft(y));
  
  
  
      // Bars
  svg.selectAll("mybar")
    .data(data)
    .enter()
    .append("rect")
      .attr("x", function(d) { return x(d.V2); })
      .attr("y", function(d) { return y(d.V3); })
      .attr("width", x.bandwidth())
      .attr("height", function(d) { return height - y(d.V3); })
      .attr("fill", function(d) { return (d.V5); })
      
      svg.append("text")
        .attr("x", (width / 2))             
        .attr("y", 0 - (margin.top / 2))
        .attr("text-anchor", "middle")  
        .style("font-size", "16px") 
        .style("text-decoration", "underline")  
        .text("Zatrudnenie kobiet i mężczyzn w zależności od zawodu");

