<template>
  <div class="plots">
    <Block class="header">
      <div class="dropdown" style="width: 100px;">
        <button>Layout</button>
        <ul class="dropdown-content">
          <li v-for="l in layouts" :key="l" @click="layout=l"><img :src="getLayoutImg(l)"></li>
        </ul>
      </div>
      <button style="left: 130px;" @click="openPage({ route: 'About', id: 0 })">About</button>
      <Autocomplete :getResultValue="getSearchValue" :search="search" placeholder="Search for an Actor, Movie, Genre..." aria-label="Search for an Actor, Movie, Genre..." @submit="openPage" :autoSelect="true"/>
    </Block>
    <component :is="layout" v-bind="{ slots, pinned }" v-model="layoutPlots"
    @swap="onSwap" @addSlot="addSlot" @pin="pin" @merged="onMerge" @openPage="openPage"/>
    <div class="bottomplots">
      <SlotContainer v-for="(s,i) in slots.slice(layoutPlots)" :slotv="s" :key="s.id" :pinned="!!pinned[i+layoutPlots]" isMovable pinable
      @pin="pin(i+layoutPlots)" @openPage="openPage"/>
    </div>
  </div>
</template>

<script>
import Block from '@/components/Block.vue'
import SlotContainer from '@/components/SlotContainer.vue'
import Autocomplete from '@trevoreyre/autocomplete-vue'
import '@trevoreyre/autocomplete-vue/dist/style.css'
import uuid from 'uuid/v4'
import Layout1 from '@/layouts/Layout1.vue'
import Layout2 from '@/layouts/Layout2.vue'
import Layout3 from '@/layouts/Layout3.vue'
import Fuse from 'fuse.js'

export default {
  name: 'PlotsView',
  components: {
    Block,
    SlotContainer,
    Autocomplete,
    Layout1,
    Layout2,
    Layout3
  },
  props: {
    pageType: String, // e.g. 'Actor'
    pageId: Number // e.g. pageId
  },
  data () {
    return {
      actorList: [],
      genreList: [],
      movieList: [],
      customSlots: [],
      pinned: {},
      slotsOrder: [],
      layoutPlots: 0,
      layout: 'Layout1',
      layouts: ['Layout1', 'Layout2', 'Layout3']
    }
  },
  computed: {
    pageSlots () {
      var slots = []
      if (this.pageType === 'actor' && this.pageId && this.actorName.length > 0) {
        slots.push({
          content: 'popularity',
          plotType: 'ActorTimePlot'
        })
        slots.push({
          content: 'genres',
          plotType: 'ActorBarPlot'
        })
        slots.push({
          content: 'budget',
          tickprefix: '$',
          plotType: 'ActorTimePlot'
        })
        slots.push({
          content: 'revenue',
          tickprefix: '$',
          plotType: 'ActorTimePlot'
        })
        slots.push({
          content: 'vote_average',
          contentName: 'average vote',
          plotType: 'ActorTimePlot'
        })
        slots.push({
          content: 'order',
          plotType: 'ActorTimePlot'
        })
        slots = slots.map(s => Object.assign({
          id: uuid(),
          data: [ { id: this.pageId, name: this.actorName } ],
          contentName: s.content.toLowerCase()
        }, s)).map(s => Object.assign({ title: this.actorName + '\'s movies ' + s.contentName }, s))
      }
      if (this.pageType === 'genre' && this.pageId) {
        slots.push({
          content: 'popularity',
          plotType: 'GenreTimePlot'
        })
        slots.push({
          content: 'budget',
          tickprefix: '$',
          plotType: 'GenreTimePlot'
        })
        slots.push({
          content: 'revenue',
          tickprefix: '$',
          plotType: 'GenreTimePlot'
        })
        slots.push({
          content: 'vote_average',
          contentName: 'average vote',
          plotType: 'GenreTimePlot'
        })
        slots = slots.map(s => Object.assign({
          id: uuid(),
          data: [ { id: this.pageId, name: this.pageName } ],
          contentName: s.content.toLowerCase()
        }, s)).map(s => Object.assign({ title: this.pageName + ' ' + s.contentName }, s))
      }
      if (this.pageType === 'movie' && this.pageId) {
        slots.push({
          content: 'actors',
          plotType: 'MovieActors',
          title: 'Actors'
        })
        slots.push({
          content: 'overview',
          plotType: 'MovieOverview'
        })
        slots = slots.map(s => Object.assign({
          id: uuid(),
          data: [ { id: this.pageId, name: this.pageName } ],
          contentName: s.content.toLowerCase()
        }, s)).map(s => Object.assign({ title: this.pageName + ' ' + s.contentName }, s))
      }
      if (this.pageType === 'about') {
        slots.push({
          content: 'search',
          contentName: 'Searching'
        })
        slots.push({
          content: 'movie',
          contentName: 'Usage'
        })
        slots.push({
          content: 'swaps',
          contentName: 'Swapping plots'
        })
        slots.push({
          content: 'merging',
          contentName: 'Merging plots'
        })
        slots.push({
          content: 'pins',
          contentName: 'Pins'
        })
        slots = slots.map(s => Object.assign({
          id: uuid(),
          title: s.contentName,
          plotType: 'About'
        }, s)).map(s => Object.assign({ title: this.pageName + ' ' + s.contentName }, s))
      }
      return slots
    },
    slots () {
      let joined = [...this.pageSlots, ...this.customSlots]
      let n = 0 // slot container number
      let i = 0 // order array iter index
      let slots = []
      let tmp = true
      while (tmp) {
        if (this.pinned[n]) tmp = this.pinned[n]
        else {
          tmp = joined.find(s => s.id === this.slotsOrder[i])
          i++
        }
        if (tmp) slots[n++] = tmp
      }
      return slots
    },
    pageName () {
      if (this.pageType === 'genre') return (this.genreList.find(g => g.id === this.pageId) || {}).name || ''
      else if (this.pageType === 'actor') return (this.actorList.find(a => a.id === this.pageId) || {}).name || ''
      else if (this.pageType === 'movie') return (this.movieList.find(a => a.id === this.pageId) || {}).name || ''
      return ''
    },
    actorName () { return this.pageName },
    fuse () { // Search api
      let all = [
        ...this.actorList.map(a => { a.route = 'Actor'; a.icon = '👤'; return a }),
        ...this.genreList.map(g => { g.route = 'Genre'; g.icon = '🏷'; return g }),
        ...this.movieList.map(m => { m.route = 'Movie'; m.icon = '🎥'; return m })
      ]
      return new Fuse(all, { keys: ['name'] })
    }
  },
  created () {
    this.$http.get('cast').then(response => {
      if (response.body && response.body.length > 0) this.actorList = response.body
    }, response => {
      console.error(response)
    })
    this.$http.get('genre').then(response => {
      if (response.body && response.body.length > 0) this.genreList = response.body
    }, response => {
      console.error(response)
    })
    this.$http.get('movie').then(response => {
      if (response.body && response.body.length > 0) this.movieList = response.body
    }, response => {
      console.error(response)
    })
  },
  watch: {
    pageId: {
      handler () {
        this.slotsOrder = []
        this.customSlots = []
        /*
        if (this.pageId <= 0 || this.pageType !== 'actor') return
        this.$http.get('cast/' + this.pageId).then(response => {
          if (response.body && response.body[0] && response.body[0].name) this.actorName = response.body[0].name
          this.customSlots = []
          this.slotsOrder = []
        }, response => {
          console.error(response)
        })
        */
      },
      immediate: true
    },
    pageSlots: {
      handler () {
        this.slotsOrder = [...this.pageSlots, ...this.customSlots].map(s => s.id)
      },
      immediate: true
    },
    slots () {
      this.$nextTick(() => {
        let maxN = this.slots.length
        let over = Object.keys(this.pinned).map(k => parseInt(k)).filter(k => k > maxN)
        if (over.length === 0) return
        let minK = Math.min.apply(this, over)
        over.forEach(k => {
          this.pinned[maxN + k - minK] = this.pinned[k]
          delete this.pinned[k]
        })
        this.pinned = Object.assign({}, this.pinned)
      })
    }
  },
  methods: {
    getLayoutImg (name) {
      return require('@/assets/layouts/' + name + '.svg')
    },
    getSlot (n) {
      return Object.assign({}, this.slots[n])
    },
    onMerge ({ n, newSlot, sources }) {
      let srcIds = sources.map(s => s.id)
      this.addSlot(newSlot)
      this.swap(n, this.getSlotNumber(newSlot))
      this.slotsOrder = this.slotsOrder.filter(s => !srcIds.includes(s.id))
    },
    addSlot (slot) {
      if (!slot) return
      if (!slot.id) slot.id = uuid()
      this.customSlots.push(slot)
      this.slotsOrder.push(slot.id)
    },
    pin (n) {
      let tmp = this.slots[n]
      if (!tmp) return
      if (!this.pinned[n]) {
        this.slotsOrder = this.slotsOrder.filter(sId => sId !== tmp.id)
        this.$set(this.pinned, n, tmp)
      } else {
        this.addSlotIfNotPresent(tmp)
        let prePinned = Object.keys(this.pinned).filter(k => k < n).length
        let position = n - prePinned
        this.slotsOrder = [...this.slotsOrder.slice(0, position), tmp.id, ...this.slotsOrder.slice(position)]
        this.$delete(this.pinned, n)
      }
    },
    addSlotIfNotPresent (slot) {
      if (!this.pageSlots.find(s => s.id === slot.id) && !this.customSlots.find(s => s.id === slot.id)) this.customSlots.push(slot)
    },
    getSlotNumber (slot) {
      return this.slots.findIndex(s => s.id === slot || s.id === slot.id)
    },
    onSwap ({ a, b }) {
      this.swap(this.getSlotNumber(a), this.getSlotNumber(b))
    },
    swap (a, b) {
      let va = this.slots[a]
      let vb = this.slots[b]
      this.addSlotIfNotPresent(va)
      this.addSlotIfNotPresent(vb)
      let ia = this.slotsOrder.findIndex(id => id === va.id)
      let ib = this.slotsOrder.findIndex(id => id === vb.id)
      if (this.pinned[a] && this.pinned[b]) {
        this.$set(this.pinned, a, vb)
        this.$set(this.pinned, b, va)
      } else if (!this.pinned[a] && !this.pinned[b]) {
        this.$set(this.slotsOrder, ia, vb.id)
        this.$set(this.slotsOrder, ib, va.id)
      } else if (this.pinned[a] && !this.pinned[b]) {
        this.$set(this.pinned, a, vb)
        this.$set(this.slotsOrder, ib, va.id)
      } else return this.swap(b, a)
    },
    search (input) {
      if (input.length < 1) return []
      // let results = []
      // let filter = obj => obj.name.toLowerCase().startsWith(input.toLowerCase().replace('👤 ', '').replace('🏷 ', '').replace('🎥 ', ''))
      // results = this.actorList.filter(filter).slice(0, 2).map(a => Object.assign({ route: 'Actor', icon: '👤' }, a))
      // results = [...results, ...this.genreList.filter(filter).slice(0, 2).map(g => Object.assign({ route: 'Genre', icon: '🏷' }, g))]
      // results = [...results, ...this.movieList.filter(filter).slice(0, 2).map(g => Object.assign({ route: 'Movie', icon: '🎥' }, g))]
      let results = this.fuse.search(input).slice(0, 10)
      return results
    },
    getSearchValue (obj) {
      return obj.icon + ' ' + obj.name
    },
    openPage (obj) {
      this.$router.push({ name: obj.route, params: { id: obj.id } })
    }
  }
}
</script>
<style>
button {
  outline:none;
}
button::-moz-focus-inner {
  border: 0;
}
button:focus {
  outline:none;
}
.plots {
  position: absolute;
  width: 100%;
  overflow-x: hidden;
  grid-template-columns: 50px auto 50px;
  grid-template-rows: 100px 540px auto;
  display: grid;
  grid-template-areas:
    "header header header"
    ". layout ."
    ". bottomplots ."
}
.layout {
  grid-area: layout;
}
.header {
  grid-area: header;
  margin: 0;
  width: 100%;
  padding: 10px !important;
  margin-bottom: 30px;
  z-index: 190;
  position: unset;
}
.header .autocomplete {
  width: 500px;
  left: 50%;
  position: absolute !important;
  z-index: 200;
  top: 35px;
  transform: translate(-50%, -50%);
}
.header > button {
  position: absolute;
  background-color: white;
  padding: 12px;
  border: 1px solid #eee;
  font-size: 16px;
  line-height: 1.5;
  border-radius: 8px;
  cursor: pointer;
  box-sizing: border-box;
}
.header > .dropdown {
  position: absolute;
  display: inline-block;
}
.dropdown > button {
  background-color: white;
  height: 100%;
  width: 100%;
  padding: 12px;
  border: 1px solid #eee;
  font-size: 16px;
  line-height: 1.5;
  border-radius: 8px;
  cursor: pointer;
  box-sizing: border-box;
}
.dropdown:hover > button {
  border-radius: 8px 8px 0 0;
}
.dropdown > .dropdown-content {
  display: none;
  padding: 0;
  margin-top: -1px;
  border-radius: 0 0 8px 8px;
  border-color: #eee;
  border-style: solid;
  border-width: 0 1px 1px 1px;
  padding-bottom: 8px;
  background-color: white;
  min-width: 100px;
  z-index: 95;
  position: absolute;
  top: 100%;
  width: 100%;
  box-sizing: border-box;
}
.dropdown:hover > .dropdown-content {
  display: block;
}
.dropdown > .dropdown-content > li {
  display: block;
  padding: 8px 0;
  text-align: center;
  font-size: 16px;
  line-height: 1.5;
  border-top: 1px solid #eee;
}
.dropdown > .dropdown-content > li > img {
  height: 16px;
}
.dropdown > .dropdown-content > li:hover {
  background-color: #eee;
}
.bottomplots {
  grid-area: bottomplots;
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-auto-rows: 270px;
}
.bottomplots > .slotcontainer {
  height: 270px;
}
</style>
