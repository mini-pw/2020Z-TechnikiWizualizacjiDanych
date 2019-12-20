d3.selection.prototype.moveToFront = function() {
  return this.each(function(){
    this.parentNode.appendChild(this);
  });
};

var generate_bomb_centers = function(n) {
  var data = [];
  for (var i = 0; i < n; i++) {
    var y = d3.randomUniform(58, 402)();
    var x = 0;
    if (321 <= y & y <= 402) {
      x = d3.randomUniform(400-y, -35+y)();
    }
    else if (236 <= y & y <= 321) {
      x = d3.randomUniform(333-y, 32+y)();
    }
    else if (165 <= y & y <= 236) {
      x = d3.randomUniform(277-y, 88+y)();
    }
    else if (58 <= y & y <= 165) {
      x = d3.randomUniform(240-y, 125+y)();
    }
    data.push({"x": x, "y": y});
  }
  return data;
};

function blink(){
  svg.selectAll('#bomb')
      .transition()
        .delay(300)
        .duration(500)
        .style("fill", "rgb(0,255,0)")
      .transition()
        .delay(300)
        .duration(500)
        .style("fill", "rgb(0,0,255)")
      .transition()
        .delay(300)
        .duration(500)
        .style("fill", "rgb(255,0,0)")
  .on("end", blink);
}

function render(){
  svg.select("#layer1").remove();
  var layer1 = svg.append('g').attr('id', 'layer1');
  var stump = layer1;
  var leaves = layer1;
  var star = layer1;
  
  stump
    .selectAll('#stump')
    .data(data)
    .enter()
      .append('rect')
        .attr('id', 'stump')
        .attr('x', 160.4)
        .attr('y', 403.2)
        .attr('height', 83.3)
        .attr('width', 45)
        .style('fill', function(d){return d.col3});
    
  leaves
  .selectAll('#leaves')
  .data(data)
  .enter()
    .append('polygon')
      .attr('id', 'leaves')
      .attr('points', '160.7,403.2 160.7,403.2 205.1,403.2 205.1,403.2 365.9,403.2 283.2,320.6 352,320.6 267.3,235.8 323.8,235.8 253.2,165.1 290.9,165.1 182.9,57.2 74.9,165.1 112.7,165.1 42,235.8 98.6,235.8 13.8,320.6 82.6,320.6 0,403.2')
      .style('fill', function(d){return d.col2});
    
  star
    .selectAll('#star')
    .data(data)
    .enter()
      .append('polygon')
        .attr('id', 'star')
        .attr('points', '165.6,57.2 182.9,48 200.3,57.2 197,37.8 211.1,24.1 191.6,21.3 182.9,3.7 174.2,21.3 154.8,24.1 168.9,37.8')
        .style('fill', function(d) {return d.col1});
      
  var decor = data[0].decor;
    
  if(svg.selectAll("#bomb").size() != decor) {
    svg.select("#layer2").remove();
    var layer2 = svg.append('g').attr('id', 'layer2');
    var bomb = layer2;
    
    bomb
      .selectAll('#bomb')
      .data(generate_bomb_centers(decor))
      .enter()
        .append('circle')
        .attr('id', 'bomb')
        .attr('cx', function(d){return d.x})
        .attr('cy', function(d){return d.y})
        .attr('r', 12)
        .style('fill', 'red')
        .call(d3.drag()
          .on("start", dragstarted)
          .on("drag", dragged)
          .on("end", dragended))
        .on("click", function(){
          d3.select(this).style('fill', 'blue');
        });
  }
  
  svg.select('#layer2').moveToFront();
  
}

function dragstarted(d) {
  d3.select(this).raise().classed("active", true);
}

function dragged(d) {
  d3.select(this).attr("cx", d.x = d3.event.x).attr("cy", d.y = d3.event.y);
}

function dragended(d) {
  d3.select(this).classed("active", false);
}

svg.style("background", null);
render();
blink(); 