const wykres = svg.selectAll("polygon");

svg.selectAll('*').remove();

// box
wykres.data(r2d3.data).enter() // Jesli podajesz dane do funkcji data(), to bez [0]
    .append("polygon")
    .attr("fill", '#FFFFFF')
    .style("stroke", "black")
    .attr("points", "20,0 20,380 300,380 300,0");

var time = [r2d3.data[0].time1, r2d3.data[0].time2, r2d3.data[0].time3, r2d3.data[0].time4, r2d3.data[0].time5, r2d3.data[0].time6, r2d3.data[0].time7, r2d3.data[0].time8, r2d3.data[0].time9, r2d3.data[0].time10, r2d3.data[0].time11, r2d3.data[0].time12, r2d3.data[0].time13]; // Jesli odwolujesz sie do jednek jonkretnej informacji to w [0]
var czas = [r2d3.data[0].czas1, r2d3.data[0].czas2, r2d3.data[0].czas3, r2d3.data[0].czas4, r2d3.data[0].czas5, r2d3.data[0].czas6, r2d3.data[0].czas7, r2d3.data[0].czas8, r2d3.data[0].czas9, r2d3.data[0].czas10, r2d3.data[0].czas11, r2d3.data[0].czas12, r2d3.data[0].czas13];
var miejsce = [r2d3.data[0].miejsce1, r2d3.data[0].miejsce2, r2d3.data[0].miejsce3, r2d3.data[0].miejsce4, r2d3.data[0].miejsce5, r2d3.data[0].miejsce6, r2d3.data[0].miejsce7, r2d3.data[0].miejsce8, r2d3.data[0].miejsce9, r2d3.data[0].miejsce10, r2d3.data[0].miejsce11, r2d3.data[0].miejsce12, r2d3.data[0].miejsce13];

var time_scale = function(t){
  return t*(250/7722) + 20;
};
var i_scale = function(i){
  return i*350/12 + 5;
};

var text = svg.selectAll("text")
                        .data(r2d3.data).enter();
    
for(var i = 0; i < 13; i++){
wykres.data(r2d3.data).enter()
    .append("rect")
    .attr('width', time_scale(time[i]))
    .attr('height', 20)
    .attr('y', i_scale(i))
    .attr('x', 20)
    .attr('fill', '#EB79FF');
}

if(r2d3.data[0].czy_czas){
  for(var i = 0; i < 13; i++){
    text.append("text")
          .attr("x", time_scale(time[i]) - 30)
          .attr("y", i_scale(i) + 15)
          .text(czas[i])
          .attr("fill", "white");
  }
}

if(r2d3.data[0].czy_rekord){
    text.append("text")
        .attr("x", time_scale(time[11]) - 120)
        .attr("y", i_scale(11) + 15)
        .text("World Record")
        .attr("fill", "white");
  
}

if(r2d3.data[0].czy_miejsce){
  for(var i = 0; i < 13; i++){
    text.append("text")
        .attr("x", 23)
        .attr("y", i_scale(i) + 15)
        .text(miejsce[i])
        .attr("fill", "white");
  }
}