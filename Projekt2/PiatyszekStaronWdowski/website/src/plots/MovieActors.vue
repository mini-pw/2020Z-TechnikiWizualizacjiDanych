<template>
  <div class="movieactors" :class="{singlemovie: this.data.length <= 1}">
    <div class="moviecolumn" v-for="m in data" :key="m.id">
      <div class="photos-box">
        <div v-for="a in rawData[m.id]" :key="a.id" @click="$emit('openPage', { route: 'Actor', id: a.id})" :title="a.name">
          <img :src="((photos[m.id] || {})[a.id] || {})[0]" class="primary">
          <img :src="((photos[m.id] || {})[a.id] || {})[1]" class="secondary">
          <span class="secondary actorname">{{ a.name }}</span>
        </div>
      </div>
      <h3>{{ m.name }}</h3>
    </div>
  </div>
</template>

<script>
export default {
  name: 'MovieActors',
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
      photos: {}
    }
  },
  methods: {
    loadData () {
      this.rawData = {}
      this.photos = {}
      this.data.forEach(d => this.loadMovieData(d.id))
    },
    loadMovieData (id) {
      this.$http.get('movie/' + id + '/cast/6').then(response => {
        if (response.body && Array.isArray(response.body)) this.$set(this.rawData, id, response.body)
        response.body.forEach(a => this.loadMovieActorPhoto(id, a.id))
      }, response => {
        console.error(response)
      })
    },
    loadMovieActorPhoto (movieId, actorId) {
      this.$http.get('cast/' + actorId + '/photo').then(response => {
        if (!response.body || !Array.isArray(response.body)) return
        if (!this.photos[movieId]) this.$set(this.photos, movieId, {})
        this.$set(this.photos[movieId], actorId, response.body.map(p => 'https://image.tmdb.org/t/p/w154' + p.file_path))
      }, response => {
        console.error(response)
      })
    }
  }
}
</script>
<style>
.movieactors {
  display: grid;
  padding-top: 18px;
  overflow: auto;
  width: calc(100% - 40px);
  position: absolute;
  grid-template-columns: repeat( auto-fit, 260px);
  grid-auto-columns: 260px;
  grid-auto-rows: 100%;
  height: calc(100% - 50px);
  grid-auto-flow: column;
}
.movieactors.singlemovie {
  grid-template-columns: repeat( auto-fit, 100%);
  grid-auto-columns: 100%;
}
.movieactors > .moviecolumn {
  padding: 5px;
  position: relative;
  text-align: center;
}
.movieactors > .moviecolumn > .photos-box {
  width: 250px;
  display: grid;
  grid-template-columns: repeat(2, 125px);
  grid-auto-rows: 125px;
  grid-auto-flow: rows;
}
.movieactors.singlemovie > .moviecolumn > .photos-box {
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
}
.movieactors > .moviecolumn > .photos-box > div > .primary {
  opacity: 1;
}
.movieactors > .moviecolumn > .photos-box > div:hover > .primary {
  opacity: 0;
}
.movieactors > .moviecolumn > .photos-box > div > .secondary {
  opacity: 0;
}
.movieactors > .moviecolumn > .photos-box > div:hover > .secondary {
  opacity: 1;
}
.movieactors > .moviecolumn .photos-box > div > span.actorname {
  position: absolute;
  top: 50%;
  left: 50;
  z-index: 100;
  color: white;
  font-weight: 900;
  font-size: 20px;
  background: rgba(0,0,0,0.4);
  text-align: center;
  transform: translate(-50%, -50%);
}
.movieactors > .moviecolumn > .photos-box > div > img {
  position: absolute;
  left: 50%;
  top: 50%;
  width: 100%;
  transform: translate(-50%, -50%);
  transition: opacity 1s;
}
.movieactors > .moviecolumn > .photos-box > div {
  height: 125px;
  position: relative;
  width: 125px;
  overflow: hidden;
}
.movieactors > .moviecolumn > h3 {
  margin: 5px 0;
  position: absolute;
  left: 50%;
  transform: translateX(-50%);
  bottom: 15px;
}
</style>
