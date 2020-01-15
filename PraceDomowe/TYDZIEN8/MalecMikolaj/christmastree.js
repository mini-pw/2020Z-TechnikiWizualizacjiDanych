    var widthscale = 50;
    var heightscale = 50;
    
    //create svg
    var svg = r2d3.svg
                      .append('svg')
                      .attr('height', heightscale*6)
                      .attr('width', widthscale*6);
                      
    //backround
    svg.append('rect')
        .attr("x", 0)
        .attr("y", 0)
        .attr("width", widthscale*6)
        .attr("height", heightscale*6)
        .attr("fill","black");
    
    //tree1             
    svg.append('rect')
        .attr("x", widthscale*2.5)
        .attr("y", heightscale*1)
        .attr("width", widthscale*1)
        .attr("height", heightscale*1)
        .attr("fill","lime");
    
    //tree2            
    svg.append('rect')
        .attr("x", widthscale*2)
        .attr("y", heightscale*2)
        .attr("width", widthscale*2)
        .attr("height", heightscale*1)
        .attr("fill","lime");
                      
        //tree3             
    svg.append('rect')
        .attr("x", widthscale*1.5)
        .attr("y", heightscale*3)
        .attr("width", widthscale*3)
        .attr("height", heightscale*1)
        .attr("fill","lime");
    
        //tree4             
    svg.append('rect')
        .attr("x", widthscale*1)
        .attr("y", heightscale*4)
        .attr("width", widthscale*4)
        .attr("height", heightscale*1)
        .attr("fill","lime");
        
                //base             
    svg.append('rect')
        .attr("x", widthscale*2.5)
        .attr("y", heightscale*5)
        .attr("width", widthscale*1)
        .attr("height", heightscale*1)
        .attr("fill","#A0522D");
        
    
    var chain_color = function(d) {return d.col_lan}; 
        //chain1             
    svg.data(r2d3.data).append('rect')
        .attr("x", widthscale*2.5)
        .attr("y", heightscale*1.3)
        .attr("width", widthscale*1)
        .attr("height", heightscale*0.4)
        .attr("fill", chain_color);
    
    //chain2            
    svg.data(r2d3.data).append('rect')
        .attr("x", widthscale*2)
        .attr("y", heightscale*2.3)
        .attr("width", widthscale*2)
        .attr("height", heightscale*0.4)
        .attr("fill",chain_color);
                      
        //chain3             
    svg.data(r2d3.data).append('rect')
        .attr("x", widthscale*1.5)
        .attr("y", heightscale*3.3)
        .attr("width", widthscale*3)
        .attr("height", heightscale*0.4)
        .attr("fill",chain_color);
    
        //chain4             
    svg.data(r2d3.data).append('rect')
        .attr("x", widthscale*1)
        .attr("y", heightscale*4.3)
        .attr("width", widthscale*4)
        .attr("height", heightscale*0.4)
        .attr("fill",chain_color);
        
              //star
      var starColor = data[0].col_star;
      var star =data[0].is_star;
      
      svg.append('text')
          .attr("x", widthscale*2.475)
          .attr("y", heightscale*2.2)
          .attr("font-size", widthscale*3)
          .text("*")
          .attr("fill", function(d){
          if( star){return starColor;}
          else{ return "black";}
        });
            
            
        
        //boubles
    
    var r = widthscale/5;
    var n = data[0].num_bom;
    console.log(n);
    var cd = d3.range( Math.floor(n/4)).map( function(){return {
      x1: Math.random()*widthscale*1 + widthscale*2.5,
      x2: Math.random()*widthscale*2 + widthscale*2,
      x3: Math.random()*widthscale*3 + widthscale*1.5,
      x4: Math.random()*widthscale*4 + widthscale*1,
      y1: Math.random()*heightscale*1 + heightscale*1,
      y2: Math.random()*heightscale*1 + heightscale*2,
      y3: Math.random()*heightscale*1 + heightscale*3,
      y4: Math.random()*heightscale*1 + heightscale*4,
      col: "rgb(" + parseInt(Math.random() * 255) + "," + parseInt(Math.random() * 255) + "," + parseInt(Math.random() * 255) + ")"
    };});
    //var col_list = ["red","orange","yellow","green","blue"];
    
    var b = svg.selectAll(".circle")
                .data(cd)
                .enter();
    
    //bouble 1
      b.append('circle')
      .attr('cx', function(d) {return d.x1;})
      .attr('cy', function(d) {return d.y1;})
      .attr('r', r)
      .attr("fill", function(d) {return d.col});
    
        //bouble 2
      b.append('circle')
      .attr('cx', function(d) {return d.x2;})
      .attr('cy', function(d) {return d.y2;})
      .attr('r', r)
      .attr("fill", function(d) {return d.col});
         
          //bouble 3
      b.append('circle')
      .attr('cx', function(d) {return d.x3;})
      .attr('cy', function(d) {return d.y3;})
      .attr('r', r)
      .attr("fill", function(d) {return d.col});
        
          //bouble 4
      b.append('circle')
      .attr('cx', function(d) {return d.x4;})
      .attr('cy', function(d) {return d.y4;})
      .attr('r', r)
      .attr("fill", function(d) {return d.col});
    
    