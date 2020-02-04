import Plotly from 'plotly.js'
import resize from 'vue-resize-directive'

export default {
  props: {
    data: Array,
    content: String,
    largeWindow: Boolean,
    tickprefix: String,
    ticksuffix: String,
    reversed: Boolean
  },
  watch: {
    data: {
      handler: 'loadData',
      immediate: true
    },
    content: {
      handler: 'loadData',
      immediate: true
    },
    plotLayout: {
      handler: 'relayout',
      immediate: true
    },
    plotData: {
      handler: 'redraw',
      immediate: true
    },
    plotConfig: {
      handler: 'redraw',
      immediate: true
    }
  },
  computed: {
    plotConfig () {
      return {
        displayModeBar: this.largeWindow,
        displaylogo: false,
        modeBarButtonsToRemove: ['lasso2d', 'autoScale2d', 'select2d', 'hoverCompareCartesian', 'hoverClosestCartesian', 'toImage']
      }
    },
    commonPlotLayout () {
      var layout = {
        width: this.size.width,
        height: this.size.height,
        autosize: true,
        legend: {
          y: 0.95,
          x: 0.05
        },
        margin: {
          t: 10,
          r: 0,
          b: 15,
          l: 38
        },
        xaxis: {
          autorange: true
        },
        yaxis: {
          tickprefix: this.tickprefix,
          ticksuffix: this.ticksuffix,
          autorange: this.reversed ? 'reversed' : true
        },
        dragmode: 'pan',
        hovermode: 'closest',
        showlegend: (this.data || []).length > 1
      }
      return layout
    }
  },
  methods: {
    relayout () {
      if (this.needRedrawing === true) return this.redraw()
      Plotly.relayout(this.$refs.plotcontainer, JSON.parse(JSON.stringify(this.plotLayout)))
    },
    onResize () {
      this.size = {
        width: this.$refs.plotcontainer.offsetWidth,
        height: this.$refs.plotcontainer.offsetHeight
      }
    },
    redraw () {
      if (!this.plotData || !this.plotLayout || !this.plotConfig || !this.$refs.plotcontainer) {
        this.needRedrawing = true
        return
      }
      Plotly.newPlot(this.$refs.plotcontainer, this.plotData, JSON.parse(JSON.stringify(this.plotLayout)), this.plotConfig)
      this.needRedrawing = false
      if (this.afterRedraw) this.afterRedraw()
    }
  },
  data () {
    return {
      needRedrawing: true,
      size: { width: 0, height: 0 },
      rawData: null
    }
  },
  directives: {
    resize
  }
}
