<template>
  <div class="barplot plot-component" v-resize:throttle.500="onResize">
    <div ref="plotcontainer" class="plot-container"></div>
    <a class="button first" v-if="Object.keys(selected).length > 0" @click="showTimeseries">Show time series</a>
  </div>
</template>

<script>
import Plotly from 'plotly.js'
import Plot from '@/plots/Plot.js'

export default {
  name: 'ActorBarPlot',
  mixins: [Plot],
  computed: {
    plotData () {
      let data = []
      if (!this.rawData) return data
      let colors = this.colors.slice()
      // Object.keys(this.rawData).forEach(id => {
      this.data.forEach(actor => {
        if (!this.rawData[actor.id]) return
        let id = actor.id
        let d = {
          type: 'bar',
          actorId: id,
          orientation: 'h',
          name: actor.name,
          marker: {
            color: Array(this.rawData[id].value.length).fill(colors.pop())
          },
          x: this.rawData[id].value,
          y: this.rawData[id].name.map(n => n.split(' ').join('<br>')),
          hoverinfo: this.largeWindow ? 'x+y' : 'none'
        }
        if (!this.largeWindow && Object.keys(this.rawData).length === 1) {
          d.x = d.x.slice(0, 6)
          d.y = d.y.slice(0, 6)
        }
        data.push(d)
      })
      return data
    },
    plotLayout () {
      var layout = {
        margin: {
          t: 15,
          r: 0,
          b: 15,
          l: 60
        },
        legend: {
          y: 0.95,
          x: 0.80
        }
      }
      return Object.assign({}, this.commonPlotLayout, layout)
    }
  },
  data () {
    return {
      colors: ['rgba(120, 20, 130, .7)', 'rgba(200, 50, 100, .7)', 'rgba(10, 180, 180, .8)'],
      selected: {}
    }
  },
  methods: {
    afterRedraw () {
      this.$refs.plotcontainer.on('plotly_click', e => this.onPlotlyClick(e.points[0]))
    },
    onPlotlyClick (point) {
      if (!this.largeWindow || !point.fullData.marker) return
      let plt = this.$refs.plotcontainer
      let actorId = point.data.actorId
      if ((this.selected[actorId] || []).includes(point.y)) {
        this.$set(this.selected, actorId, this.selected[actorId].filter(a => a !== point.y))
        if (this.selected[actorId].length === 0) this.$delete(this.selected, actorId)
      } else {
        this.$set(this.selected, actorId, [...(this.selected[actorId] || []), point.y])
      }
      let colors = point.data.y.map(genre => (this.selected[actorId] || []).includes(genre) ? 'grey' : this.colors[this.colors.length - 1 - point.curveNumber])
      Plotly.restyle(plt, { marker: { color: colors } }, [ point.curveNumber ])
    },
    showTimeseries () {
      let selected = JSON.parse(JSON.stringify(this.selected).replace(/<br>/g, ' '))
      let newSlot = {
        content: 'genres',
        contentName: 'Genres',
        plotType: 'ActorTimeGroupedPlot',
        data: selected,
        title: 'Movies genres frequency'
      }
      this.$emit('addSlot', newSlot)
    },
    loadData () {
      this.rawData = {}
      this.selected = {}
      let loadActorData = id => {
        this.$http.get('cast/' + id + '/bars/' + this.content).then(response => {
          this.needRedrawing = true
          this.$set(this.rawData, id, response.body)
        }, response => {
          console.error(response)
        })
      }
      this.data.map(d => d.id).forEach(loadActorData)
    }
  }
}
</script>
<style>
.barplot > a.button {
  position: absolute;
  left: 50%;
  transform: translate(-50%, -50%);
  font-size: 20px;
}
.barplot > a.button.first {
  top: 10%;
}
</style>
