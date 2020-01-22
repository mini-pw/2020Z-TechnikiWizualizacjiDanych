var render = function(data) {
  var margin = {
      top: 100,
      right: 10,
      bottom: 40,
      left: 50
    },
    width = 600 - margin.left - margin.right,
    height = 600 - margin.top - margin.bottom;

  var canvas = r2d3.svg
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  var xScale = d3.scaleLinear()
    .domain([d3.min(data, function(d) {
        return d.weight;
      }) - 1,
      d3.max(data, function(d) {
        return d.weight;
      }) + 1
    ])
    .range([0, width]);

  var yScale = d3.scaleLinear()
    .domain([d3.min(data, function(d) {
        return d.height;
      }) - 1,
      d3.max(data, function(d) {
        return d.height;
      }) + 1
    ])
    .range([height, 0]);

  var xAxis = d3.axisBottom(xScale);

  var yAxis = d3.axisLeft(yScale);

  canvas.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0," + height + ")")
    .call(xAxis)
    .append("text")
    .attr("class", "labelek")
    .attr("x", width)
    .attr("y", 34)
    .style("font-family", "sans-serif")
    .style("font-size", "15px")
    .style("fill", "#333")
    .style("text-anchor", "end")
    .text("Weight");

  canvas.append("g")
    .attr("class", "y axis")
    .call(yAxis)
    .append("text")
    .attr("class", "labelek")
    .attr("x", 20)
    .attr("y", -15)
    .style("font-family", "sans-serif")
    .style("font-size", "15px")
    .style("fill", "#333")
    .style("text-anchor", "end")
    .text("Height");

  var tooltip = d3.select('#d3_1').append("div")
    .attr("class", "tooltip")
    .style("opacity", 0);

  var tipMouseover = function(d) {
    var colour = "yellow";
    if (d.colour=="black"){
      color = "#383428";
    }
    else if (d.colour=="blue"){
      color = "#0099ff";
    }
    else if (d.colour=="green"){
      color = "#33cc33";
    }
    else if (d.colour=="red"){
      color = "#cc3300";
    }
    var html = "<b> Weight: </b><span style='color:" + color + ";'>" + Math.round(100*d.weight)/100 + "</span><br/>" +
               "<b> Height: </b><span style='color:" + color + ";'>" + Math.round(100*d.height)/100 + "</span><br/>" +
               "<b> Life length: </b><span style='color:" + color + ";'>" + Math.round(d.life_length) + "</span><br/>"
               
    var x = parseFloat(d3.select(this).attr('cx'));
    var y = parseFloat(d3.select(this).attr('cy'));
    tooltip.html(html)
      .style("left", (x + margin.left - margin.right + 40) + "px")
      .style("top", (y + margin.top - margin.bottom + 14) + "px")
      .transition()
      .duration(200)
      .style("opacity", 0.9);

  };

  var tipMouseout = function(d) {
    tooltip.transition()
      .duration(300)
      .style("opacity", 0);
  };

  var sScale = d3.scaleLinear()
    .domain([511.1847, 3952.703])
    .range([3, 15]);

  canvas.selectAll(".dot")
    .data(data)
    .enter().append("circle")
    .attr("class", "dot")
    .attr("r", function(d) {
      if(options.show) {
        return sScale(d.life_length)
      } else {
        return 6
      }
    })
    .attr("cx", function(d) {
      return xScale(d.weight);
    })
    .attr("cy", function(d) {
      return yScale(d.height);
    })
    .style("fill", function(d) {
      if (d.colour=="black"){
        return "#383428";
      }
      else if (d.colour=="blue"){
        return "#0099ff";
      }
      else if (d.colour=="green"){
        return "#33cc33";
      }
      else if (d.colour=="red"){
        return "#cc3300";
      }
    })
    .style("opacity", options.opacity)
    .on("mouseover", tipMouseover)
    .on("mouseout", tipMouseout);

  var title = svg.append("text")
    .attr("class", "title")
    .attr("x", 0)
    .attr("y", 40)
    .style("font-size", "30px")
    .style("fill", "#333")
    .style("text-anchor", "start")
    .text("Scatter plot");
    
  var subtitle = svg.append("text")
    .attr("class", "subtitle")
    .attr("x", 0)
    .attr("y", 60)
    .style("font-size", "14px")
    .style("fill", "#333")
    .style("text-anchor", "start")
    .text("...it has tooltips");
};

svg.selectAll("*").remove();
render(data);