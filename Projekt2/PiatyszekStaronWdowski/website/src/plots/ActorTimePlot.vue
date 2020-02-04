<template>
  <div class="plot-component" v-resize:throttle.500="onResize">
    <div ref="plotcontainer" class="plot-container"></div>
  </div>
</template>

<script>
import Plot from '@/plots/Plot.js'
import PlotPosters from '@/plots/Posters.js'

export default {
  name: 'ActorTimePlot',
  mixins: [Plot, PlotPosters],
  props: {
    reversed: Boolean
  },
  computed: {
    commonMovies () {
      let data = null
      if (!this.rawData) return data
      this.data.forEach(actor => {
        let actorData = this.rawData[actor.id]
        if (!actorData) return
        if (data == null) data = actorData.movieid
        else data = data.filter(d => actorData.movieid.indexOf(d) !== -1)
      })
      return data
    },
    plotData () {
      let colors = ['rgba(120, 20, 130, .7)', 'rgba(200, 50, 100, .7)', 'rgba(10, 180, 180, .8)']
      if (this.data.length === 2) colors = colors.flatMap(c => [c, c])
      let data = []
      if (!this.rawData) return data
      this.data.forEach(actor => {
        let actorData = this.rawData[actor.id]
        if (!actorData) return
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
        if (this.data.length > 2) return
        data.push({
          x: actorData.time,
          y: actorData.value,
          mode: 'markers',
          name: actor.name,
          marker: {
            size: this.largeWindow ? 15 : 4,
            color: colors.pop()
          },
          hoverinfo: this.largeWindow ? 'text' : 'none',
          text: actorData.label,
          movieid: actorData.movieid
        })
      })
      /* if (this.data.length > 2) {
        data.push({
          x: actorData.time,
          y: actorData.value,
          mode: 'markers',
          name: actor.name,
          marker: {
            size: this.largeWindow ? 15 : 4,
            color: colors.pop()
          },
          hoverinfo: this.largeWindow ? 'text' : 'none',
          text: actorData.label,
          movieid: actorData.movieid
        })
      } */
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
      this.data.forEach(d => this.loadActorData(d.id))
    },
    loadActorData (actorId) {
      this.$http.get('cast/' + actorId + '/timeseries/' + this.content).then(response => {
        this.needRedrawing = true
        this.$set(this.rawData, actorId, response.body)
      }, response => {
        console.error(response)
      })
    }
  }
}
</script>
