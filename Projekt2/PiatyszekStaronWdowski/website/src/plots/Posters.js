import Plotly from 'plotly.js'

export default {
  methods: {
    onPlotlyClick (point) {
      if (!this.largeWindow || !point.fullData.marker) return
      let movieid = point.data.movieid[point.pointIndex]
      this.$http.get('movie/' + movieid + '/poster').then(response => {
        this.addPlotlyImage(point, response.body.path[0])
      }, response => {
        console.error(response)
      })
    },
    addPlotlyImage (point, src) {
      if (!this.largeWindow || !point.fullData.marker) return
      let plt = this.$refs.plotcontainer
      let ylen = point.yaxis._r[1] - point.yaxis._r[0]
      let yBottomLine = point.yaxis._r[0] + 0.3 * ylen
      let yTopLine = point.yaxis._r[1] - 0.3 * ylen
      let yMiddleLine = point.yaxis._r[0] + 0.5 * ylen

      let pointY = point.yaxis.d2l(point.y)
      let pos = pointY > yMiddleLine
      if (this.reversed) pos = !pos

      let newImage = {
        source: src,
        x: point.xaxis.d2l(point.x),
        y: pos ? yBottomLine : yTopLine,
        xref: 'x',
        yref: 'y',
        sizex: 1200000000000,
        sizey: ylen * 0.2, // will be bounded by x
        xanchor: 'center',
        yanchor: pos ? 'top' : 'bottom'
      }
      let newArrow = {
        x0: newImage.x,
        y0: newImage.y,
        x1: newImage.x,
        y1: pointY,
        xref: 'x',
        yref: 'y',
        type: 'line',
        line: {
          color: point.fullData.marker.color,
          width: 3
        }
      }
      let newIndex = (plt.layout.images || []).length
      let foundCopy = false
      if (plt.layout.images) {
        plt.layout.images.forEach((image, imageIndex) => {
          if (image.source === newImage.source) {
            Plotly.relayout(plt, 'images[' + imageIndex + ']', 'remove')
            Plotly.relayout(plt, 'shapes[' + imageIndex + ']', 'remove')
            foundCopy = true
          }
        })
      }
      if (foundCopy) return
      Plotly.relayout(plt, 'images[' + newIndex + ']', newImage)
      Plotly.relayout(plt, 'shapes[' + newIndex + ']', newArrow)
    }
  }
}
