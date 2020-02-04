<template>
  <div class="plot-component" v-resize:throttle.500="onResize">
    <div ref="plotcontainer" class="plot-container"></div>
  </div>
</template>

<script>
import Plot from '@/plots/Plot.js'
import PlotPosters from '@/plots/Posters.js'

export default {
  name: 'GenreTimePlot',
  mixins: [Plot, PlotPosters],
  computed: {
    plotData () {
      let colors = ['rgba(120, 20, 130, .7)', 'rgba(200, 50, 100, .7)', 'rgba(10, 180, 180, .8)']
      let markerColor = 'rgba(200, 50, 100, .1)'
      let data = []
      if (!this.rawData) return data
      this.data.forEach(actor => {
        let actorData = this.rawData[actor.id]
        if (!actorData) return
        if (this.data.length === 1) {
          data.push({
            x: actorData.time,
            y: actorData.value,
            mode: 'markers',
            name: actor.name,
            marker: {
              size: this.largeWindow ? 15 : 4,
              color: markerColor
            },
            hoverinfo: this.largeWindow ? 'text' : 'none',
            text: actorData.label,
            movieid: actorData.movieid
          })
        }
        data.push({
          x: actorData.smoothed.time,
          y: actorData.smoothed.value,
          mode: 'lines',
          name: actor.name,
          line: {
            color: colors.pop(),
            width: this.largeWindow ? 4 : 2
          },
          transforms: [{
            type: 'sort',
            target: 'x',
            order: 'ascending'
          }],
          hoverinfo: this.largeWindow ? 'x+y' : 'none'
        })
      })
      return data
    },
    plotLayout () {
      var layout = {
        images: []
      }
      return Object.assign({}, this.commonPlotLayout, layout)
    }
  },
  methods: {
    afterRedraw () {
      this.$refs.plotcontainer.on('plotly_click', e => this.onPlotlyClick(e.points[0]))
    },
    loadData () {
      this.rawData = {}
      this.data.forEach(d => this.loadGenreData(d.id))
    },
    loadGenreData (genreId) {
      this.$http.get('genre/' + genreId + '/timeseries/' + this.content).then(response => {
        this.needRedrawing = true
        this.$set(this.rawData, genreId, response.body)
      }, response => {
        console.error(response)
      })
    }
  }
}
</script>
