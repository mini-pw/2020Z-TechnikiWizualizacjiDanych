var render = function(data) {
  var margin = {
      top: 215,
      right: 10,
      bottom: 40,
      left: 30
    },
    width = 500 - margin.left - margin.right,
    height = 715 - margin.top - margin.bottom;

  var canvas = r2d3.svg
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
    
  var colorScale = d3.scaleOrdinal()
    .range([options.col1, options.col2]);

  var xScale = d3.scaleLinear()
    .domain([d3.min(data, function(d) {
        return d.Deaths;
      }) - 1,
      d3.max(data, function(d) {
        return d.Deaths;
      }) + 1
    ])
    .range([0, width]);

  var yScale = d3.scaleLinear()
    .domain([d3.min(data, function(d) {
        return d.Kills;
      }) - 1,
      d3.max(data, function(d) {
        return d.Kills;
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
    .text("Deaths");

  canvas.append("g")
    .attr("class", "y axis")
    .call(yAxis)
    .append("text")
    .attr("class", "labelek")
    .attr("y", -15)
    .style("font-family", "sans-serif")
    .style("font-size", "15px")
    .style("fill", "#333")
    .style("text-anchor", "end")
    .text("Deaths")
    .text("Kills");

  var tooltip = d3.select('#d3_1').append("div")
    .attr("class", "tooltip")
    .style("opacity", 0);

  var tipMouseover = function(d) {
    var teamColor = colorScale(d.Team);
    var KDRColor = options.col3;
    if (d.Kills < d.Deaths) KDRColor = options.col4;
    var html = "<span style='color:" + teamColor + ";'>" + d.Player + "</span><br/>" +
      "<b>" + d.Kills + "</b> kills, <b/>" + d.Deaths + "</b> deaths <br/>" +
      "<b><span style='color:" + KDRColor + ";'>" + Math.round((d.Kills / d.Deaths) * 100) / 100 + "</span></b>" + "</b> KDR <br/>";
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

  canvas.selectAll(".dot")
    .data(data)
    .enter().append("circle")
    .attr("class", "dot")
    .attr("r", 5.5)
    .attr("cx", function(d) {
      return xScale(d.Deaths);
    })
    .attr("cy", function(d) {
      return yScale(d.Kills);
    })
    .style("fill", function(d) {
      return colorScale(d.Team);
    })
    .on("mouseover", tipMouseover)
    .on("mouseout", tipMouseout);

  var title = svg.append("text")
    .attr("class", "title")
    .attr("x", 0)
    .attr("y", 85)
    .style("font-size", "30px")
    .style("fill", "#333")
    .style("text-anchor", "start")
    .text("Scatter plot");
    
  var subtitle = svg.append("text")
    .attr("class", "subtitle")
    .attr("x", 0)
    .attr("y", 110)
    .style("font-size", "14px")
    .style("fill", "#333")
    .style("text-anchor", "start")
    .text("...it has tooltips");

  var legend = svg.selectAll(".legend")
    .data(colorScale.domain())
    .enter().append("g")
    .attr("class", "legend")
    .attr("transform", function(d, i) {
      return "translate(0," + i * 20 + ")";
    });

  legend.append("rect")
    .attr("x", width + margin.left - 18)
    .attr("y", 65)
    .attr("width", 18)
    .attr("height", 18)
    .style("fill", colorScale);

  legend.append("text")
    .attr("x", width + margin.left - 28)
    .attr("y", 75)
    .attr("dy", ".35em")
    .style("text-anchor", "end")
    .style("fill", "#333")
    .text(function(d) {
      return d;
    });

  x = d3.max(
    [
      d3.min(data, function(d) {
        return d.Kills;
      }),
      d3.min(data, function(d) {
        return d.Deaths;
      })
    ]
  ) - 1;

  y = d3.min(
    [
      d3.max(data, function(d) {
        return d.Kills;
      }),
      d3.max(data, function(d) {
        return d.Deaths;
      })
    ]
  ) + 1;

  canvas.append("line")
    .attr("x1", xScale(x))
    .attr("y1", yScale(x))
    .attr("x2", xScale(y))
    .attr("y2", yScale(y))
    .style("stroke", "black")
    .style("stroke-width", 2)
    .style("stroke-dasharray", ("3, 3"));
};

svg.selectAll("*").remove();
render(data);