function svg_height() {return parseInt(svg.style('height'))}
function svg_width()  {return parseInt(svg.style('width'))}
function col_top()  {return svg_height() * 0.05; }
function col_left() {return svg_width()  * 0.40; }
function actual_max() {return d3.max(data, function (d) {return d.unemployment; }); }
function col_width()  {return (svg_width() / actual_max()) * 0.55; }
function col_heigth() {return svg_height() / data.length * 0.95; }

var data = r2d3.data;

var bars = svg.selectAll('rect').data(data);
bars.enter().append('rect')
  .attr('x',col_left())
  .attr('y',function(d, i) { return i * col_heigth() + col_top(); })
  .attr('width',function(d) { return d.unemployment * col_width(); })
  .attr('height', col_heigth() * 0.9)
  .attr('fill', function(d) {return d.fill; })
  .attr('id', function(d) {return (d.label); })
  .on('mouseover', function(){
  d3.select(this).attr('fill', function(d) {return d.mouseover; });
  })
  .on('mouseout', function(){
  d3.select(this).attr('fill', function(d) {return d.fill; });
  });
bars.exit().remove();
  
// Identity labels - yAxis
var txt = svg.selectAll('text').data(data);
txt.enter().append('text')
.attr('x', width * 0.01)
.attr('y', function(d, i) { return i * col_heigth() + (col_heigth() / 2) + col_top(); })
.text(function(d) {return d.degree; })
.style('font-family', 'sans-serif');

// Numeric labels
var totals = svg.selectAll().data(data);
totals.enter().append('text')
.attr('x', function(d) { return ((d.unemployment * col_width()) + col_left()) * 1.01; })
.attr('y', function(d, i) { return i * col_heigth() + (col_heigth() / 2) + col_top(); })
.style('font-family', 'sans-serif')
.text(function(d) {return (Math.round(d.unemployment * 1e4)/100).toString() + "%"; });