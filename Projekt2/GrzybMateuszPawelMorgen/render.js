function render() {
  const myString = document.getElementById("myInput").value
  const myId = /\((.*?)\)/.exec(myString)[1]
  if (myId >= 1 & myId <= 731) {
    var mySuperhero = data.filter(function(d) {
      return d.id == myId
    })[0]
    //console.log(mySuperhero)
    d3.selectAll(".name").text(mySuperhero.name + " (" + myId + ")")
  } else {
    console.log("No such hero found.")
  }

  var myColor = 'DodgerBlue'
  if (mySuperhero.biography.alignment == 'good') {
    myColor = 'green'
  } else if (mySuperhero.biography.alignment == 'bad') {
    myColor = 'red'
  }

svg_image.selectAll(".border")
.transition().duration(1000)
.style("fill", myColor)

  new Promise((resolve, reject) => {
    svg_image.selectAll(".cover")
      .transition().duration(400)
      .style("opacity", 1)
    setTimeout(function() {
      resolve()
    }, 500)
  }).then(() => {
    return new Promise((resolve, reject) => {
      svg_image.selectAll("#image_link").attr("xlink:href", "pictures/" + myId + ".jpg")
      setTimeout(function() {
        resolve()
      }, 200)
    })
  }).then(() => {
    svg_image.selectAll(".cover")
      .transition().duration(400)
      .style("opacity", 0)
  })

  function nanto0(x) {
    if (isNaN(x)) {
      return 0
    } else {
      return x
    }
  }

  var radarData = [{
    name: mySuperhero.name,
    axes: [{
        axis: "Combat",
        value: nanto0(mySuperhero.powerstats.combat)
      },
      {
        axis: "Durability",
        value: nanto0(mySuperhero.powerstats.durability)
      },
      {
        axis: "Intelligence",
        value: nanto0(mySuperhero.powerstats.intelligence)
      },
      {
        axis: "Power",
        value: nanto0(mySuperhero.powerstats.power)
      },
      {
        axis: "Speed",
        value: nanto0(mySuperhero.powerstats.speed)
      },
      {
        axis: "Strength",
        value: nanto0(mySuperhero.powerstats.strength)
      }
    ],
  }]

  radius = Math.min(radarChartOptions.w / 2, radarChartOptions.h / 2)
  maxValue = radarChartOptions.maxValue

  const rScale = d3.scaleLinear()
    .range([0, radius])
    .domain([0, maxValue])

  angleSlice = Math.PI * 2 / radarData[0].axes.map((i, j) => i.axis).length

  const radarLine = d3.radialLine()
    .curve(d3.curveLinearClosed)
    .radius(d => rScale(d.value))
    .angle((d, i) => i * angleSlice)



  svg_radar.selectAll(".radarWrapper").selectAll(".radarArea")
    .data(radarData)
    .transition().duration(500)
      .attr("d", "M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z 0 0")
    .transition().duration(0)
      .style("fill", myColor)
    .transition().duration(500)
      .attr("d", d => radarLine(d.axes))

  svg_radar.selectAll(".radarWrapper").selectAll(".radarStroke")
    .data(radarData)
    .transition().duration(500)
      .attr("d", "M 0 0 L 0 0 L 0 0 L 0 0 L 0 0 L 0 0 Z 0 0")
    .transition().duration(0)
        .style("stroke", myColor)
    .transition().duration(500)
      .attr("d", d => radarLine(d.axes))

  svg_radar.selectAll(".radarWrapper")
    .data(radarData)
    .selectAll(".radarCircle")
    .data(d => d.axes)
    .transition().duration(500)
      .attr("cx", 0)
      .attr("cy", 0)
      .transition().duration(0)
        .style("fill", myColor)
    .transition().duration(500)
      .attr("cx", (d, i) => rScale(d.value) * cos(angleSlice * i - HALF_PI))
      .attr("cy", (d, i) => rScale(d.value) * sin(angleSlice * i - HALF_PI))

  svg_radar.selectAll(".radarCircleWrapper")
    .data(radarData)
    .selectAll(".radarInvisibleCircle")
    .data(d => d.axes)
    .transition().duration(500)
    .attr("cx", 0)
    .attr("cy", 0)
    .transition().duration(500)
    .attr("cx", (d, i) => rScale(d.value) * cos(angleSlice * i - HALF_PI))
    .attr("cy", (d, i) => rScale(d.value) * sin(angleSlice * i - HALF_PI))

  drawGraph(parseInt(myId));
  //console.log('finished')
}
