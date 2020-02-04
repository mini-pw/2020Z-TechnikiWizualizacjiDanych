<template>
  <div class="movieoverview" :class="{singlemovie: this.data.length <= 1}">
    <div class="moviecolumn" v-for="m in rawData" :key="m.movie_id">
      <img v-if="posters[m.movie_id]" :src="posters[m.movie_id]" class="poster">
      <h2>{{ m.title }}</h2>
      <h3>Popularity: <span :style="{ color: m.popularity > 50 ? 'green' : m.popularity < 20 ? 'red' : 'black'}">{{ m.popularity | round2 }}</span></h3>
      <h3>Runtime: {{ m.runtime | runtime }}</h3>
      <h3>Average vote: <span :style="{ color: m.vote_average > 7 ? 'green' : m.vote_average < 4 ? 'red' : 'black'}">{{ m.vote_average }}</span></h3>
      <h3>Budget: {{ m.budget | money}}</h3>
      <h3>Revenue: {{ m.revenue | money }}</h3>
    </div>
  </div>
</template>

<script>
export default {
  name: 'MovieOverview',
  props: {
    data: Array,
    largeWindow: Boolean
  },
  watch: {
    data: {
      handler: 'loadData',
      immediate: true
    }
  },
  data () {
    return {
      rawData: {},
      posters: {}
    }
  },
  filters: {
    round2 (v) {
      return (Math.round(v * 100) / 100).toFixed(2)
    },
    runtime (v) {
      return Math.floor(147 / 60) + 'h ' + 147 % 60 + ' min'
    },
    money (v) {
      return '$' + Math.round(v / 1000000) + ' mln'
    }
  },
  methods: {
    loadData () {
      this.rawData = {}
      this.posters = {}
      this.data.forEach(d => this.loadMovieData(d.id))
      this.data.forEach(d => this.loadMoviePoster(d.id))
    },
    loadMovieData (id) {
      this.$http.get('movie/' + id).then(response => {
        if (response.body && Array.isArray(response.body) && response.body.length === 1) this.$set(this.rawData, id, response.body[0])
      }, response => {
        console.error(response)
      })
    },
    loadMoviePoster (id) {
      this.$http.get('movie/' + id + '/poster').then(response => {
        if ((response.body || {}).path && Array.isArray(response.body.path) && response.body.path.length === 1) this.$set(this.posters, id, response.body.path[0])
      }, response => {
        console.error(response)
      })
    }
  }
}
</script>
<style>
.movieoverview {
  display: grid;
  padding-top: 18px;
  overflow: auto;
  width: calc(100% - 40px);
  position: absolute;
  grid-template-columns: repeat( auto-fit, 190px);
  grid-auto-columns: 190px;
  grid-auto-rows: 100%;
  height: calc(100% - 50px);
  grid-auto-flow: column;
}
.movieoverview.singlemovie {
  grid-template-columns: repeat( auto-fit, 100%);
  grid-auto-columns: 100%;
}
.movieoverview > .moviecolumn {
  padding: 5px;
  text-align: center;
}
.movieoverview > .moviecolumn > .poster {
  position: relative;
  height: 60%;
  max-width: 90%;
}
.movieoverview > .moviecolumn > h2 {
  margin: 5px 0;
}
.movieoverview > .moviecolumn > h3 {
  margin: 1px 0;
}
</style>
