<template>
  <div class="about">
    <img v-if="!!imgSrc" :src="imgSrc">
    <video v-if="!!movieSrc" controls>
      <source :src="movieSrc" type="video/mp4">
    </video>
    <h3 v-if="!!about">{{ about }}</h3>
  </div>
</template>

<script>
export default {
  name: 'About',
  props: {
    content: String
  },
  computed: {
    imgSrc () {
      let urls = {
        search: require('@/assets/about-search.png'),
        swaps: require('@/assets/about-swap.png'),
        pins: require('@/assets/about-pin.png'),
        merging: require('@/assets/about-merge.png')
      }
      return urls[this.content] ? urls[this.content] : null
    },
    movieSrc () {
      let urls = {
        movie: require('@/assets/movie.mp4')
      }
      return urls[this.content] ? urls[this.content] : null
    },
    about () {
      if (this.content === 'search') return 'Type the name of your\'s favorite actor to reveal his career. You can also find movies and genres.'
      if (this.content === 'swaps') return 'Do you want to customize your dashboard? Hold your mouse on any plot and then move it over another one. Plots will swap.'
      if (this.content === 'pins') return 'Use that small icon at the top of each plot if you don\'t want to lose it.'
      if (this.content === 'merging') return 'Try to merge two same kind plots. Just hold one plot and drop it on the left side of the other plot.'
      return ''
    }
  }
}
</script>
<style>
div.about > video {
  max-width: 80%;
  position: relative;
  transform: translateX(-50%);
  left: 50%;
  margin-top: 25px;
  box-shadow: 0 0 10px 3px rgba(150,150,150,0.5);
}
div.about > img {
  max-width: 70%;
  position: relative;
  transform: translateX(-50%);
  left: 50%;
  margin-top: 25px;
  box-shadow: 0 0 10px 3px rgba(150,150,150,0.5);
}
</style>
