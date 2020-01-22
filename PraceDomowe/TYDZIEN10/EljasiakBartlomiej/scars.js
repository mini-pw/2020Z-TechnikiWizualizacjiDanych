
//
//**   Osie   **/
//

var x = d3.scaleLinear()
    .domain([500,4000])
    .range([0.1*width, 0.9*width])
    .nice();

var y = d3.scaleLinear()
    .domain([0,80])
    .range([0.1*height, 0.9*height])
    .nice();

var xAxis = d3.axisBottom(x)
    .ticks(15)
    .tickPadding(10);

var yAxis = d3.axisRight(y)
    .ticks(10)
    .tickSize(10)
    .tickPadding(10);

var gX = svg.append("g")
    .call(xAxis)
    .style('fill','#e4e4e4')
    .style("font-size", "16px")

svg.append("text")             
    .attr("transform",
        "translate(" + (width/2) + " ," + (80) + ")")
    .style("text-anchor", "middle")
    .text("Wiek [lata]")
    .style('fill','#666')
    .style("font-size", "24px")

var gY = svg.append("g")
    .call(yAxis)
    .style('fill','#e4e4e4')
    .style("font-size", "16px")


svg.append("text")
    .attr("transform", "rotate(-90)")
    .attr("y",80)
    .attr("x",0 - (height / 2))
    .style("font-size", "24px")
    .style('fill','#666')
    .style("text-anchor", "middle")
    .text("Blizny"); 

//
//**   Elementy Ruchome   **/
//

var text_x =svg.append('text')
    .attr('y', height-40)
    .attr('x',width/2)
    .style('fill','#666')
    .style("font-size", "24px")
    .style('opacity',1)
    .style("text-anchor", "middle")
    .text(""); 

var text_y =svg.append('text')
    .attr("transform", "rotate(-90)")
    .attr('y',width-40)
    .attr('x',-height/2)
    .style('fill','#666')
    .style("font-size", "24px")
    .style('opacity',1)
    .text(""); 

var circle_x =svg.append('circle')
    .attr('cy',5)
    .attr('cx',width/2)
    .style('fill','#666')
    .attr('r',5)
    .style('opacity',1)

var circle_y =svg.append('circle')
    .attr('cx',5)
    .attr('cy',height/2)
    .style('fill','#666')
    .attr('r',5)
    .style('opacity',1)
  

//
//**   Wykres   **/
//

var dots = svg.selectAll("circle").data(data)


 
//
//**   Animacja wejścia   **/
//
dots.enter()
    .append("circle")
    .attr("cx", function (d) { return Math.random()*width; } )
    .attr("cy", function (d) { return Math.random()*height; } )
    .attr('fill', 'grey')
    .attr('r',2)
    .style('opacity',0)

    //
    //**   Sterowanie ruchomymi punktami   **/
    //
    .on("mouseover", function(d) {		
        d3.select(this).transition().duration(400)
            .attr('r',6)

        text_x.transition().duration(800)
            .attr('x', x(d.life_length))
            .text(Math.round(d.life_length*100)/100)
            .style('fill',d.colour)
            .style('opacity',1)

        text_y.transition().duration(800)
            .attr('x', -y(d.scars))
            .text(Math.round(d.scars*100)/100)
            .style('fill',d.colour)
            .style('opacity',1)

        circle_x.transition().duration(800).ease(d3.easeCubic)
            .attr('cx', x(d.life_length))
            .style('fill',d.colour)
            .style('opacity',1)

        circle_y.transition().duration(800).ease(d3.easeCubic)
            .attr('cy', y(d.scars))
            .style('fill',d.colour)
            .style('opacity',1)
        })		
                    
    .on("mouseout", function(d) {		
        d3.select(this).transition().duration(400)
            .attr('r',2)

        text_x.transition().duration(600)
            .style('opacity',0)

        text_y.transition().duration(600)
            .style('opacity',0)
            
        circle_x.transition().duration(600)
            .style('opacity',0)

        circle_y.transition().duration(600)
            .style('opacity',0)
    })

//
//**   Animacja docelowa   **/
//

    .transition().ease(d3.easeCircle).duration(700)
        .attr("cx", function (d) { return x(d.life_length); } )
        .attr("cy", function (d) { return y(d.scars); } )
        .attr('fill', function(d) { return d.colour;})
        .style('opacity',0.8)

//
//**   Animacja wyjścia   **/
//

dots.exit().transition().ease(d3.easeCircle).duration(700)
    .attr("cx", function (d) { return Math.random()*width; } )
    .attr("cy", function (d) { return Math.random()*height; } )
    .style('opacity',0)
    .remove()

