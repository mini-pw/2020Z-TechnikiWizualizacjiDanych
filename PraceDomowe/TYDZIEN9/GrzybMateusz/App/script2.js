var render = function(data) {
  var margin = {
      top: 215,
      right: 10,
      bottom: 40,
      left: 60
    },
    width = 500 - margin.left - margin.right,
    height = 715 - margin.top - margin.bottom;

  var canvas = r2d3.svg
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  var colorScale = d3.scaleOrdinal()
    .range([options.col3, options.col4])
    .domain(["Above", "Below"]);
    
  var colorScale2 = d3.scaleOrdinal()
    .range([options.col1, options.col2])

  var xScale = d3.scaleLinear()
    .range([0, width])
    .domain([-1*d3.max(data, function(d) {
      return Math.abs(d.KDR_2)+0.1;
    }), d3.max(data, function(d) {
      return Math.abs(d.KDR_2)+0.1;
    })]);

  var yScale = d3.scaleBand()
    .range([height, 0])
    .padding(0.1)
    .domain(data.map(function(d) {
      return d.Player;
    }));

  var xAxis = d3.axisBottom(xScale);
  
  var yAxis = d3.axisLeft(yScale);

  canvas.append("g")
    .attr("class", "y axis")
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
    .text("Standarized KDR");
 
  canvas.append("g")
    .attr("class", "x axis")  
    .call(yAxis)
    .append("text")
    .attr("class", "labelek")
    .attr("y", -15)
    .style("font-family", "sans-serif")
    .style("font-size", "15px")
    .style("fill", "#333")
    .style("text-anchor", "end")
    .text("Player");
    
  var tooltip = d3.select('#d3_2').append("div")
    .attr("class", "tooltip")
    .style("opacity", 0);

  var tipMouseover = function(d) {
    var teamColor = colorScale2(d.Team);
    var KDRColor = colorScale(d.KDR_2_type);
    var html = "<span style='color:" + teamColor + ";'>" + d.Player + "</span><br/>" +
      "<b><span style='color:" + KDRColor + ";'>" + d.KDR_2 + "</span></b>" + "</b> Standarized KDR <br/>";
    var x = 0;
    if (d3.select(this).attr('x')<xScale(0)){
      x = xScale(0);
    }
    else {
      x = xScale(0)+parseFloat(d3.select(this).attr('width'));
    }
    var y = parseFloat(d3.select(this).attr('y')+d3.select(this).attr('height'));
    tooltip.html(html)
      .style("left", (x + margin.left - margin.right+30) + "px")
      .style("top", (y + margin.top - margin.bottom+43) + "px")
      .transition()
      .duration(200)
      .style("opacity", 0.9);

  };

  var tipMouseout = function(d) {
    tooltip.transition()
      .duration(300)
      .style("opacity", 0);
  };

  canvas.selectAll(".bar")
    .data(data)
    .enter()
    .append("rect")
    .attr("class", "bar")
    .attr("x", function(d) {
      if(d.KDR_2_type=="Below"){
        return xScale(d.KDR_2)/2;
      }
      else {
        return xScale(0);
      }
    })
    .attr("y", function(d) {
      return yScale(d.Player);
    })
    .attr("width", function(d) {
      return xScale(Math.abs(d.KDR_2))/2;
    })
    .attr("height", yScale.bandwidth())
    .style("fill", function(d) {
      return colorScale(d.KDR_2_type);
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
    .text("Bar plot");
    
  var subtitle = svg.append("text")
    .attr("class", "subtitle")
    .attr("x", 0)
    .attr("y", 110)
    .style("font-size", "14px")
    .style("fill", "#333")
    .style("text-anchor", "start")
    .text("...so does this one");
    
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
};

svg.selectAll("*").remove();
render(data);