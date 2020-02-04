import Vue from 'vue'
import VueRouter from 'vue-router'
// import Home from '../views/Home.vue'
import PlotsView from '../views/PlotsView.vue'

Vue.use(VueRouter)

const routes = [
/*  {
    path: '/',
    name: 'home',
    component: Home
  },
*/
  {
    path: '/actor/:id',
    name: 'Actor',
    props (route) {
      const props = { ...route.params }
      props.pageId = +props.id
      props.pageType = 'actor'
      return props
    },
    component: PlotsView
  },
  {
    path: '/genre/:id',
    name: 'Genre',
    props (route) {
      const props = { ...route.params }
      props.pageId = +props.id
      props.pageType = 'genre'
      return props
    },
    component: PlotsView
  },
  {
    path: '/keyword/:id',
    name: 'Keyword',
    props (route) {
      const props = { ...route.params }
      props.pageId = +props.id
      props.pageType = 'keyword'
      return props
    },
    component: PlotsView
  },
  {
    path: '/movie/:id',
    name: 'Movie',
    props (route) {
      const props = { ...route.params }
      props.pageId = +props.id
      props.pageType = 'movie'
      return props
    },
    component: PlotsView
  },
  {
    path: '/',
    name: 'Home',
    props (route) {
      const props = { ...route.params }
      props.pageType = 'about'
      props.pageId = 0
      return props
    },
    component: PlotsView
  },
  {
    path: '/about',
    name: 'About',
    props (route) {
      const props = { ...route.params }
      props.pageType = 'about'
      props.pageId = 0
      return props
    },
    component: PlotsView
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

export default router
