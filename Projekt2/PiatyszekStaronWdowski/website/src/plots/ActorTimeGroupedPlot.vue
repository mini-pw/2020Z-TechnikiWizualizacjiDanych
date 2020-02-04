<template>
  <div class="plot-component" v-resize:throttle.500="onResize">
    <div ref="plotcontainer" class="plot-container"></div>
  </div>
</template>

<script>
import Plot from '@/plots/Plot.js'

export default {
  name: 'ActorTimeGroupedPlot',
  mixins: [Plot],
  computed: {
    plotData () {
      var data = []
      if (!this.rawData) return data
      Object.keys(this.rawData).forEach(actorId => {
        let names = this.data[actorId]
        names.forEach(name => {
          let d = this.rawData[actorId][name]
          if (!d) return
          let point = {
            x: d.year,
            y: d.value,
            mode: 'markers',
            name: name + ' ' + actorId, // TODO
            marker: {
              size: this.largeWindow ? 15 : 4
            },
            text: name
          }
          if (d.smoothed && d.smoothed.year) {
            data.push({
              x: d.smoothed.year,
              y: d.smoothed.value,
              name: name + ' ' + actorId, // TODO
              mode: 'lines'
            })
          } else {
            data.push(point)
          }
        })
      })
      return data
    },
    plotLayout () {
      var layout = {
        legend: {
          y: 0.95,
          x: 0.80
        }
      }
      return Object.assign({}, this.commonPlotLayout, layout)
    }
  },
  methods: {
    loadData () {
      this.rawData = {}
      let loadActorData = id => {
        this.$http.get('cast/' + id + '/yeartimeseries/' + this.content).then(response => {
          this.needRedrawing = true
          this.$set(this.rawData, id, response.body)
        }, response => {
          console.error(response)
        })
      }
      Object.keys(this.data).forEach(loadActorData)
    }
  }
}
</script>
