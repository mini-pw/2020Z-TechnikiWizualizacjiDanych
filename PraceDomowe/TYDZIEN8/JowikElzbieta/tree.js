r2d3.svg.selectAll('*').remove()


var tree = r2d3.svg.selectAll('circle')
    .data(r2d3.data)
    .enter()
    .append('circle')
    .attr('cx', function(d){return (1-d.V1)*400;})
    .attr('cy', function(d){return (1-d.V2)*400;})
    .attr('r', function(d){return (d.size);})
    .attr('stroke', function(d){return d.colors;})
    .attr('fill', function(d){return d.colors;})
tree.exit()
    