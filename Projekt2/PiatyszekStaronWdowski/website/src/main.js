import Vue from 'vue'
import App from './App.vue'
import router from './router'
import VueResource from 'vue-resource'
import '@/plots/Plot.css'

Vue.config.productionTip = false

Vue.use(VueResource)
Vue.http.options.root = 'https://api.twd.wektor.xyz'

new Vue({
  router,
  render: h => h(App)
}).$mount('#app')
