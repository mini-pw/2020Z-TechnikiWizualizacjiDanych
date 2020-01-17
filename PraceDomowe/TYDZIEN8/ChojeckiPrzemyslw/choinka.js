var df = r2d3.data;
svg.selectAll('*').remove();

const choinka = r2d3.svg.selectAll("polygon");

choinka.data(df).enter()
    .append("polygon")
    .attr('fill', '#007F0E')
    .attr("points", function(d) { return d.rogi }); // d.rogi choinki



var x = [];
var y = [];
for(var j = 0; j<df[0].ilosc_bombek; j++){
  x.push(200+(Math.random()-0.5)*df[0].max_szerokosc*0.7);
  y_max = 25+Math.abs(x[j]-200)*600/df[0].max_szerokosc;
  y.push(y_max + Math.random()*(df[0].glebokosc-y_max));
}
  
for (var i = 0; i < df[0].ilosc_bombek; i++){
  
  
  choinka.data(df).enter()
         .append("circle")
         .attr("cx", function(d) { return x[i] })
         .attr("cy", function(d) { return y[i] })
         .attr("r", function(d) { return 10 })
         .style("fill", function(d){ return d.kolor_bombek; });
  //choinka.enter().append("") //kreski
}

var star = d3.symbol()
            .type(d3.symbolStar)
            .size(700);
svg.append('path')
    .attr('d', star)
    .attr('stroke', 'none')
    .attr('fill', '#DAA520')
    .attr('transform', 'translate('+ 200 + ',' + 25 + ')' ); 


// pieniek
choinka.data(df).enter()
  .append("rect")
  .attr('width', function(d){ return d.max_szerokosc*30/340 })
  .attr('height', 30)
  .attr('y', df[0].glebokosc)
  .attr('x', 190)
  .attr('fill', '#7C4520');