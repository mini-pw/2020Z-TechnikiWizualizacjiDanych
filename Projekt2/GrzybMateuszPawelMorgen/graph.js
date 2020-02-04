//create somewhere to put the force directed graph

//drawGraph(69);
// So far just for Bats
// var center_id = 70;
async function drawGraph(center_id){
  let allPlaces = await d3.json("new_data/allPlaces.json");
  let allGroups = await d3.json("new_data/allGroups.json");
  let heroData = await loadData;

  const center_hero = heroData[center_id - 1];
  nodes_data = [
    {"name": center_hero.name[0],
    "type": "hero",
    "id" : center_hero.id[0],
    "hero_id" : center_id,
    "alignment" : center_hero.biography.alignment[0],
    "fx" : graph_width / 2,
    "fy" : graph_height / 2}
  ];
  // Czytamy miejsca i grupy:
  const center_bases = center_hero.work.base.filter(base => base != "-");
  const center_groups = center_hero.connections["group-affiliation"].filter(group => group != "-" && group != "Mobile");
  function uniqueGenerals(array){
    // array na wejściu to tablica stringów
    // każdy z nich to łańcuch powiązanych ze sobą miejsc lub grup
    // zadanie: znaleźć unikatowe grupy / bazy najwyższego rzędu
    const generals = array.map(str => str.split(', ').pop()).sort();
    return d3.range(generals.length)
             .map(i => {return i == generals.length -1 ? i : (generals[i] != generals[i+1] ? i : -1);})
             .filter(i => i != -1)
             .map(i => generals[i]);
  };
  var places = uniqueGenerals(center_bases).map(generalBase => {
    var regex = new RegExp(generalBase + '\\s*$');
    var out = Object.keys(allPlaces).filter(str => regex.test(str));
    if(out.indexOf(generalBase) == -1){out.push(generalBase)};
    return out;
  });

  const allHeroNames = heroData.map(hero => hero.name[0]);

  var groups = uniqueGenerals(center_groups).map(generalGroup => {
    var out = Object.keys(allGroups).filter(str => str.includes(generalGroup));
    if(out.indexOf(generalGroup) == -1){out.push(generalGroup)};
    return out;
  });

  var hero_groups = center_groups.filter(group => allHeroNames.some(name => name == group));
  groups = groups.filter(group => hero_groups.every(hGroup => hGroup != group));

  var allGenerals = [uniqueGenerals(center_groups),
                       uniqueGenerals(center_bases)].flat()
                       .map(gen =>
                         hero_groups.indexOf(gen) == -1 ? gen : heroData[allHeroNames.indexOf(group)].id[0]);

  // Każde z nich będzie na naszym grafie:
  nodes_data.push.apply(nodes_data, places.flat().map(function(base){return {"name": base.split(',')[0],
                                                                    "type":"place",
                                                                     "id" : base}}));

  nodes_data.push.apply(nodes_data, groups.flat().map(function(group){
    return {"name": group.split(',')[0],
            "type":"group",
            "id" : group}}));

  nodes_data.push.apply(nodes_data, hero_groups.map(group => {
    var hero = heroData[allHeroNames.indexOf(group)];
    return {"name": hero.name[0],
            "type": "hero",
            "id" : hero.id[0],
            "hero_id" : hero.id[0],
            "alignment" : hero.biography.alignment[0]};
  }));

  // Ustawiamy odpowiednio powiązania:
  // place jedno z drugim jest podłączone, jeśli jedno zawiera drugie

  links_data = places.map(function(place_chain){
    var out = [];
    place_chain.forEach(function(place){
      // Interesują nas połączenia najmniejszego stopnia
      if(/^[^,]*$/.test(place)){return; }
      var place_parent = place;
      while(true){
        place_parent = place_parent.replace(/^[^,]*,\s/, "");
        if(place_chain.some(s => s == place_parent)){break;}
      }
      out.push(
          {"source" : place,
           "target" : place_parent,
           "color" : 'black'}
      );
    });
    return out;
  }).flat();

  // podobnie group
  Array.prototype.push.apply(links_data, groups.map(function(group_chain){
    var out = [];
    var lengths = group_chain.map(str => str.length);
    var genIndex = lengths.indexOf(d3.min(lengths));
    d3.range(group_chain.length).forEach(i => {
    if(i == genIndex){return;}
    out.push({"source" : group_chain[genIndex],
         "target" : group_chain[i],
         "color" : "black"})
    })
    return out;
  }).flat());

  function chooseColor(alignment){
    if(alignment === 'good'){return 'green';}
    if(alignment === 'bad'){return 'red';}
    return 'blue';
  };

  Array.prototype.push.apply(links_data, hero_groups.map(group => {
    var hero = heroData[allHeroNames.indexOf(group)];
    return {"source" : center_hero.id[0],
            "target" : hero.id[0],
            "color" : chooseColor(center_hero.biography.alignment[0])};
  }));

  // Jedziemy dalej.
  // Każdy place może (nie musi) mieć podłączonych innych bohaterów.

  places.flat().forEach(function(place){
    var alignments;
    if(!(place in allPlaces)){alignments = ['neutral']}
    else{
      // Mamy co wyświetlać
      alignments = allPlaces[place].map(function(hero){
        var flag = hero.id[0] == center_hero.id[0];
        if(flag){
          links_data.push({"source" : place,
                           "target" : hero.id[0],
                           "color" : chooseColor(hero.alignment[0])});
          return hero.alignment[0];
        }
        links_data.push({"source" : place,
                    "target" : hero.id[0] + "_" + place,
                    "color" : chooseColor(hero.alignment[0])});
        nodes_data.push({"name":hero.name[0],
                    "type" : "hero",
                    "id" : hero.id[0] + "_" + place,
                    "hero_id" : hero.id[0],
                    "alignment" : hero.alignment[0]});
        return hero.alignment[0];
      });
    }
    // alignments to tablica informująca, ile jest postaci dobrych, złych i neutralnych
    var alSum1 = [alignments.filter(alignment => alignment == 'good').length,
                  alignments.filter(alignment => alignment != 'good' && alignment != 'bad').length,
                  alignments.filter(alignment => alignment == 'bad').length];
    var alSum2 = Array(3);
    d3.range(3).forEach(i => {
      if(i == 0){
        alSum2[0] = [0, alSum1[0] / d3.sum(alSum1) * 2 * Math.PI];
        return;
      }
      alSum2[i] = [alSum2[i-1][1], alSum2[i-1][1] + alSum1[i] / d3.sum(alSum1) * 2 * Math.PI];
      return;
    })
    alSum2 = alSum2.map(angles => angles.map(angle => angle + Math.PI / 2));
    var alignmentsSummary = {goods : alSum2[0],
                            others : alSum2[1],
                              bads : alSum2[2]};
    // Przypisz naszemu node'owi atrybut z informacjami o postaciach związanych z tym node'em
    nodes_data.find(node => node.id == place).alignmentInfo = alignmentsSummary;
  })

  //podobnie z groups
  groups.flat().forEach(function(group){
    var alignments;
    if(!(group in allGroups)){alignments = ['neutral'];}
    else {
      // Mamy co wyświetlać
      var alignments = allGroups[group].map(function(hero){
        var flag = hero.id[0] == center_hero.id[0];
        if(flag){
          links_data.push({"source" : group,
                           "target" : hero.id[0],
                           "color" : chooseColor(hero.alignment[0])});
          return hero.alignment[0];
        }
        links_data.push({"source" : group,
                         "target" : hero.id[0] + "_" + group,
                          "color" : chooseColor(hero.alignment[0])})
                    // Jeśli już go mamy, to nie dodajemy nowego węzła:
        nodes_data.push({"name":hero.name[0],
                         "type" : "hero",
                         "id" : hero.id[0] + "_" + group,
                         "hero_id" : hero.id[0],
                         "alignment" : hero.alignment[0]});
        return hero.alignment[0];
      });
    }
    // alignments to tablica informująca, ile jest postaci dobrych, złych i neutralnych
    var alSum1 = [alignments.filter(alignment => alignment == 'good').length,
    alignments.filter(alignment => alignment != 'good' && alignment != 'bad').length,
    alignments.filter(alignment => alignment == 'bad').length];
    var alSum2 = Array(3);
    d3.range(3).forEach(i => {
      if(i == 0){
        alSum2[0] = [0, alSum1[0] / d3.sum(alSum1) * 2 * Math.PI];
        return;
      }
      alSum2[i] = [alSum2[i-1][1], alSum2[i-1][1] + alSum1[i] / d3.sum(alSum1) * 2 * Math.PI];
      return;
    });
    alSum2 = alSum2.map(angles => angles.map(angle => angle + Math.PI / 2));
    var alignmentsSummary = {goods : alSum2[0],
                      others : alSum2[1],
                      bads : alSum2[2]};
    // Przypisz naszemu node'owi atrybut z informacjami o postaciach związanych z tym node'em
    nodes_data.find(node => node.id == group).alignmentInfo = alignmentsSummary;
  });

  function count(node){
    // Policz stopień wierzchołka
    return d3.sum(links_data.map(function(link1){
      if(link1.source == node.id || link1.target == node.id){
        return 1;}
        return 0;
    }));
  }

  nodes_data.forEach(nd => {
    nd.degree = count(nd);
  });

  //set up the simulation
  var simulation = d3.forceSimulation()
                      //add nodes
                     .nodes(nodes_data);


  //add forces
  //we're going to add a charge to each node
  //also going to add a centering force
  //and a link force


  var link_force =  d3.forceLink(links_data)
                      .id(function(d) { return d.id; })
                      .distance(150)
                      /*
                      .strength(function(link){
                        var types = [link.source, link.target]
                                    .map(searched_node => nodes_data.find(node => node.id == searched_node.id))
                                    .map(node => node.type);
                        if(types.some(type => type == 'hero')){
                          return 1 / (Math.min(count(link.source), count(link.target)) + 3);
                        }
                        return 1 / Math.min(count(link.source), count(link.target));
                       });
                       */

  var node_degrees = allGenerals
    .map(nd => nodes_data.filter(ndd => ndd.id == nd)[0]);
    //.map(function(nd){return {id: nd.id,
      //                        deg: count(nd)}});
  var degree_sum = d3.sum(node_degrees.map(nd => nd.degree));
  var arch_angles = node_degrees.map(function(nd){return {id : nd.id,
                                        angle : nd.degree / degree_sum * 2 * Math.PI};});
  var angles = d3.range(arch_angles.length).map(i => {
    var half_angle = arch_angles[i].angle / 2;
    if(i == 0){return {id : arch_angles[i].id,
                       angle: half_angle}};
    return {id: arch_angles[i].id,
            angle : d3.sum(d3.range(i).map(j => arch_angles[j].angle)) + half_angle}
  });

  function tidying_force(alpha) {
    var k = alpha;
    nodes_data.filter(nd => allGenerals.indexOf(nd.id) != -1)
         .forEach(nd => {
           var this_angle = angles.filter(ang => ang.id == nd.id)[0].angle;
           var radius = 500;
           nd.vx -= (nd.x - (radius * Math.cos(this_angle) + graph_width / 2)) * k;
           nd.vy -= (nd.y - (radius * Math.sin(this_angle) + graph_height / 2)) * k;
         });
   }
  simulation
    .force("charge_force", d3.forceManyBody().strength(-100)
                                        .distanceMax(Math.sqrt(graph_height ** 2 + graph_width ** 2)))
    .force("links",link_force)

  //  .force('radial_force', d3.forceRadial(500, graph_height/2, graph_width / 2))
    .force('tidy', tidying_force);

  //add tick instructions:
  simulation.on("tick", tickActions );

  //delete everything
  svg_graph.selectAll('*').remove();
  //add encopassing selection for zoom
  allElements = svg_graph.append("g")
                   .attr("class", "everything")
                   .style('opacity', 0);
  //draw lines for the links
  var link = allElements.append("g")
                        .attr("class", "links")
                        .selectAll("line")
                        .data(links_data)
                        .enter().append("line")
                        .attr("stroke-width", 2)
                        .attr('stroke', function(d){return d.color;});

  //draw objects for the hero nodes

  var heroNode = allElements.append("g")
                            .attr("class", "heroNodes")
                            .selectAll(".heroNode")
                            .data(nodes_data.filter(function(d){return d.type == "hero";}))
                            .enter().append("g").attr('class', 'heroNode')

  // Add shapes
  var rectHeight = 128 * 0.7 + 30;
  var rectWidth = 96 * 0.7;
  var margin = 1;
  var rectangles = heroNode.append("rect")
                           .attr('height', rectHeight + margin * 2)
                           .attr('width', rectWidth + margin * 2)
                           .attr('x', -rectWidth / 2 - margin)
                           .attr('y', -rectHeight / 2 - margin)
                           .attr('stroke', function(d){
                              if(d.alignment === 'good'){return 'green';}
                              if(d.alignment === 'bad'){return 'red';}
                              return 'blue';
                            });

  // Add images
  var pictures = heroNode.append('image')
                          .attr('height', rectHeight - 30)
                          .attr('width', rectWidth)
                          .attr('x', -rectWidth / 2)
                          .attr('y', -rectHeight / 2)
                          .attr('href', function(d){
                            return 'pictures/' + d["hero_id"] + '.jpg'
                          })
                          .on('click', function(d){
                            var new_id = d.hero_id;
                            //console.log(new_id);
                            document.getElementById("myInput").value = heroData[new_id-1].name[0] + " (" + heroData[new_id-1].id[0] + ")";
                            render();
                          });
  // Add texts
  // Formatting.
  // Let's assume, that we will want to split the string if it's above 12 characters long.
  // To do later.
  var labels = heroNode.append("text")
                        .text(function(d) {
                          var string = d.name;
                          if (string.length >= 12){
                            string = string.substring(0,9) + "...";
                          }
                          return string;
                        })
                        .attr('x', 0)
                        .attr('y', rectHeight / 2 - 15 + margin)
                        .attr('text-anchor', 'middle')
                        .attr('font-size', function(d){
                          if(d.name.length <= 7){return 16;}
                          if(d.name.length <= 12){
                            return 16 - (d.name.length - 7) * 0.8;
                          }
                          return 12;
                        })
                        .attr('font-weight', function(d){
                          if (d.id == center_hero.id){return 'bold';}
                          return 'normal';
                        });
                        /*
                        .attr('textLength', function(d){
                          var x123 = d3.min([d.name.length, 14]) * (rectWidth * 1.6) / 14;
                          return d3.min([d.name.length, 14]) * 8;
                        })
                        .attr('lengthAdjust', "spacingAndGlyphs");
                        */
                        heroNode.append("title")
                        .text(function(d) { return d.name; });





  //draw objects for the other nodes

  var otherNode = allElements.append("g")
                              .attr("class", "otherNodes")
                              .selectAll("g")
                              .data(nodes_data.filter(function(d){return d.type != "hero";}))
                              .enter().append("g")

  // Add circles

  function calculateRadius(d){
    return 30 + d.degree * 0.7;
  }
  var circles =  otherNode.append("circle")
                          .attr('r', calculateRadius);

  //add a collision force to the simulation
  simulation.force('collision', d3.forceCollide().radius(d3.max([Math.sqrt(rectHeight ** 2 + rectWidth ** 2) / 2,
                                                                  d3.max(nodes_data.map(calculateRadius))])));

  // Add circle strokes

  function calculateArc(r){return d3.arc()
              .innerRadius(r)
              .outerRadius(r);}
  var goodStroke = otherNode.append("path")
                            .attr("fill", "none")
                            .attr("stroke-width", 5)
                            .attr("stroke", "green")
                            .attr("d", function(d){
                              var r = calculateRadius(d);
                              return calculateArc(r)({startAngle:d.alignmentInfo.goods[0],
                                                      endAngle:d.alignmentInfo.goods[1]});});

  var otherStroke = otherNode.append("path")
                              .attr("fill", "none")
                              .attr("stroke-width", 5)
                              .attr("stroke", "blue")
                              .attr("d", function(d){
                                var r = calculateRadius(d);
                                return calculateArc(r)({startAngle:d.alignmentInfo.others[0],
                                                       endAngle:d.alignmentInfo.others[1]});});

  var badStroke = otherNode.append("path")
                            .attr("fill", "none")
                            .attr("stroke-width", 5)
                            .attr("stroke", "red")
                            .attr("d", function(d){
                              var r = calculateRadius(d);
                              return calculateArc(r)({startAngle:d.alignmentInfo.bads[0],
                                                      endAngle:d.alignmentInfo.bads[1]});})

  // Add texts
  var labels = otherNode.append("text")
                        .text(function(d) {
                          var string = d.name;
                          if (string.length >= 12){
                            string = string.substring(0,9) + "...";
                          }
                          return string;
                        })
                        .attr('x', 0)
                        .attr('y', 0)
                        .attr('text-anchor', 'middle')
                        .attr('font-size', function(d){
                          var r = calculateRadius(d);
                          return 10 + r / 7;
                        })
                        .attr('font-weight', function(d){
                          if (d.degree > 10){return 'bold';}
                          return 'normal';
                        });
                        otherNode.append("title")
                        .text(function(d) { return d.name; });

  // set visibily
  allElements.transition()
             .duration(2000)
             .style('opacity', 1)

  var drag_handler = d3.drag()
                      .on("start", drag_start)
                      .on("drag", drag_drag)
                      .on("end", drag_end);

  //same as u	sing .call on the node variable as in https://bl.ocks.org/mbostock/4062045
  drag_handler(goodStroke)
  drag_handler(otherStroke)
  drag_handler(badStroke)
  drag_handler(circles)
  drag_handler(pictures)
  drag_handler(rectangles)
  //add zoom capabilities
  var zoom_handler = d3.zoom()
                       .scaleExtent([0.33, 3])
                       .on("zoom", zoom_actions);

  //reset zoom
  svg_graph.call(zoom_handler.transform, d3.zoomIdentity.scale(1));

  zoom_handler(svg_graph);
  //Zoom functions
  function zoom_actions(){
    allElements.attr("transform", d3.event.transform)
  }

  // Add the highlighting functionality
  node_mouseover_handler = function(d){
    // Highlight the connections
    link
      .style('stroke-opacity', function (link_d) { return link_d.source.id === d.id || link_d.target.id === d.id ? 1 : 0.25;})
      .style('stroke-width', function (link_d) { return link_d.source.id === d.id || link_d.target.id === d.id ? 3 : 1;})
    // Highlight the connected nodes
    var connected_ids = links_data.filter(link_d => link_d.source.id === d.id || link_d.target.id === d.id)
                                  .map(link_d => link_d.source.id === d.id ? link_d.target.id : link_d.source.id);
    if(d.type === "hero"){
      var selected_id = d.hero_id;
      nodes_data.filter(nd => nd.type === "hero")
                .filter(nd => /^\d+/.exec(nd.id)[0] == selected_id)
                .forEach(nd => connected_ids.push(nd.id))};
    connected_ids.push(d.id);
    heroNode
      .style('opacity', function (node_d) { return connected_ids.indexOf(node_d.id) === -1 ? 0.25 : 1;})
    otherNode
      .style('opacity', function (node_d) { return connected_ids.indexOf(node_d.id) === -1 ? 0.25 : 1;})
    };

  node_mouseout_handler = function (d) {
    //nodes.style('fill', "#69b3a2")
    link
      .style('stroke-opacity', '1')
      .style('stroke-width', '1')
    heroNode
      .style('opacity', 1)
    otherNode
      .style('opacity', 1)
  };

  otherNode
    .on('mouseover', node_mouseover_handler )
    .on('mouseout', node_mouseout_handler)
  heroNode
    .on('mouseover', node_mouseover_handler )
    .on('mouseout', node_mouseout_handler)
  /** Functions **/

  //drag handler
  //d is the node
  function drag_start(d) {
    if (!d3.event.active) simulation.alphaTarget(0.3).restart();
    d.fx = d.x;
    d.fy = d.y;
  }

  function drag_drag(d) {
    d.fx = d3.event.x;
    d.fy = d3.event.y;
  }

  function drag_end(d) {
    if (!d3.event.active) simulation.alphaTarget(0);
    if(d.id == center_hero.id[0]) return;
    d.fx = null;
    d.fy = null;
  }
  function tickActions() {
  //update circle positions each tick of the simulation
    heroNode
      .attr("transform", function(d) {
        return "translate(" + d.x + "," + d.y + ")";
      });
    otherNode
      .attr("transform", function(d) {
        return "translate(" + d.x + "," + d.y + ")";
      });
    //simply tells one end of the line to follow one node around
    //and the other end of the line to follow the other node around
    link
    .attr("x1", function(d) { return d.source.x; })
    .attr("y1", function(d) { return d.source.y; })
    .attr("x2", function(d) { return d.target.x; })
    .attr("y2", function(d) { return d.target.y; });
  }


}
