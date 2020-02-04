<template>
  <div class="slotcontainer" ref="slotcontainer" :class="{moving: mode === 'moving'}">
    <div class="overlay full" :class="{ visible: singleDropzone, active: activeDropzone === 'full' }">
      <img src="@/assets/replace.svg">
    </div>
    <div class="overlay left" :class="{ visible: dualDropzone, active: activeDropzone === 'left' }" ref="leftdropzone">
      <img src="@/assets/merge.png">
    </div>
    <div class="overlay right" :class="{ visible: dualDropzone, active: activeDropzone === 'right' }" ref="rightdropzone">
      <img src="@/assets/replace.svg">
    </div>
    <img src="@/assets/pin-off.svg" class="pin" v-if="!pinned && pinable" @click="$emit('pin')">
    <img src="@/assets/pin-on.svg" class="pin" v-if="pinned && pinable" @click="$emit('pin')">
    <Block :title="slotv.title" class="{ barplot-block: plotType === 'barplot' }">
      <component :is="slotv.plotType" v-bind="props" @addSlot="$emit('addSlot', $event)" @openPage="$emit('openPage', $event)"/>
    </Block>
  </div>
</template>

<script>
import Block from '@/components/Block.vue'
import ActorTimePlot from '@/plots/ActorTimePlot.vue'
import GenreTimePlot from '@/plots/GenreTimePlot.vue'
import MovieOverview from '@/plots/MovieOverview.vue'
import MovieActors from '@/plots/MovieActors.vue'
import ActorBarPlot from '@/plots/ActorBarPlot.vue'
import ActorTimeGroupedPlot from '@/plots/ActorTimeGroupedPlot.vue'
import About from '@/plots/About.vue'
import interact from 'interactjs'

export default {
  name: 'SlotContainer',
  props: {
    slotv: Object,
    largeWindow: Boolean,
    isPlaceholder: Boolean,
    isMovable: Boolean,
    pinned: Boolean,
    pinable: Boolean
  },
  computed: {
    plotType () { return (this.slotv || {}).plotType },
    content () { return (this.slotv || {}).content },
    contentName () { return (this.slotv || {}).contentName },
    singleDropzone () { return this.mode === 'single-dropzone' },
    dualDropzone () { return this.mode === 'dual-dropzone' },
    props () {
      return Object.assign({
        largeWindow: this.largeWindow,
        reversed: this.content === 'order' && this.plotType === 'ActorTimePlot'
      }, this.slotv)
    }
  },
  components: {
    Block,
    ActorTimePlot,
    GenreTimePlot,
    MovieOverview,
    MovieActors,
    ActorBarPlot,
    ActorTimeGroupedPlot,
    About
  },
  data () {
    return {
      mode: 'normal', // normal, moving, single-dropzone, dual-dropzone
      activeDropzone: 'none', // none, left, right, full,
      mergable: ['ActorTimePlot', 'ActorBarPlot', 'GenreTimePlot', 'MovieOverview', 'MovieActors']
    }
  },
  methods: {
    moveEventFilter (e) {
      if (e.target.className === 'dragcover' && this.mode === 'moving') e.stopPropagation()
    },
    mouseUpEvent (e) {
      if (e.target.className === 'dragcover' && this.mode === 'moving') this.mode = 'normal'
    },
    addValidation (f, mustBeMoving = true) {
      return e => {
        if (!e.relatedTarget.slotcontainer) return
        let target = e.relatedTarget.slotcontainer
        if (target.mode !== 'moving' && mustBeMoving) return
        return f(target)
      }
    },
    initPlaceholder () {
      let common = {
        overlap: 0.20,
        accept: '.slotcontainer',
        ondropactivate: this.addValidation(target => {
          if (this.mode === 'normal') {
            let mergable = this.plotType === target.plotType && this.mergable.includes(this.plotType) && this.content === target.content
            this.mode = mergable ? 'dual-dropzone' : 'single-dropzone'
            this.activeDropzone = 'none'
          }
        }),
        ondropdeactivate: e => {
          if (!e.relatedTarget.slotcontainer) return
          this.mode = 'normal'
        }
      }
      interact(this.$refs.leftdropzone).dropzone(Object.assign({}, common, {
        ondragenter: this.addValidation(target => {
          this.activeDropzone = this.mode === 'dual-dropzone' ? 'left' : 'full'
        }),
        ondragleave: this.addValidation(target => {
          if (this.mode === 'single-dropzone' || this.activeDropzone === 'left') this.activeDropzone = 'none'
        }),
        ondrop: this.addValidation(target => {
          if (this.mode === 'single-dropzone') this.$emit('swap', { a: this.slotv, b: target.slotv })
          else {
            let newSlot = {
              content: this.content,
              plotType: this.plotType,
              contentName: this.contentName,
              title: this.contentName.charAt(0).toUpperCase() + this.contentName.slice(1),
              data: [...(this.slotv.data || []), ...(target.slotv.data || [])]
            }
            this.$emit('merged', { newSlot, sources: [this.slotv, target.slotv] })
          }
        }, false)
      }))
      interact(this.$refs.rightdropzone).dropzone(Object.assign({}, common, {
        ondragenter: this.addValidation(target => {
          this.activeDropzone = this.mode === 'dual-dropzone' ? 'right' : 'full'
        }),
        ondragleave: this.addValidation(target => {
          if (this.mode === 'single-dropzone' || this.activeDropzone === 'right') this.activeDropzone = 'none'
        }),
        ondrop: this.addValidation(target => {
          this.$emit('swap', { a: this.slotv, b: target.slotv })
        }, false)
      }))
    },
    initDragging () {
      document.addEventListener('mousemove', this.moveEventFilter, true)
      document.addEventListener('mouseup', this.mouseUpEvent, true)
      interact(this.$refs.slotcontainer).pointerEvents({
        holdDuration: 250
      }).draggable({
        interia: true,
        autoScroll: true,
        modifiers: [
          interact.modifiers.restrict({
            restriction: '.home',
            endOnly: true
          })
        ],
        onmove: event => {
          if (this.mode !== 'moving') return
          event.preventDefault()
          var target = event.target
          // keep the dragged position in the data-x/data-y attributes
          var x = (parseFloat(target.getAttribute('data-x')) || 0) + event.dx
          var y = (parseFloat(target.getAttribute('data-y')) || 0) + event.dy
          // translate the element
          target.style.webkitTransform =
            target.style.transform =
              'translate(' + x + 'px, ' + y + 'px)'
          // update the posiion attributes
          target.setAttribute('data-x', x)
          target.setAttribute('data-y', y)
        },
        onend: event => {
          this.mode = 'normal'
          this.$el.style.transform = ''
          this.$el.setAttribute('data-x', 0)
          this.$el.setAttribute('data-y', 0)
        }
      }).on('hold', event => {
        this.mode = 'moving'
      }).on('up', event => {
        this.mode = 'normal'
      }, true)
    }
  },
  mounted () {
    this.$refs.slotcontainer.slotcontainer = this
    if (this.isMovable) this.initDragging()
    if (this.isPlaceholder) this.initPlaceholder()
  },
  beforeDestroy () {
    document.removeEventListener('mousemove', this.moveEventFilter, true)
    document.removeEventListener('mouseup', this.mouseUpEvent, true)
  }
}
</script>

<style>
.slotcontainer {
  position: relative;
}
.slotcontainer.moving {
  z-index: 150;
}
.slotcontainer .modebar {
  z-index: 99;
  transform: translateX(50%) rotate(-90deg) translateX(-50%);
}
.slotcontainer .barplot-block .modebar {
  transform: translateX(50%) rotate(-90deg) translateX(-50%) translateX(25px);
}
.slotcontainer .modebar .modebar-btn > svg {
  transform: rotate(90deg);
}
.slotcontainer .modebar [data-title]:hover::before {
  transform: rotate(180deg);
  top: 10px;
}
.slotcontainer .modebar [data-title]:hover::after {
  transform: translateX(-50%) rotate(90deg) translateX(-50%);
  top: -15px;
  right: auto;
}
.barplot-block {
  padding-top: 50px;
}
.slotcontainer.moving .block {
  filter: blur(3px);
}
.slotcontainer > .overlay {
  position: absolute;
  z-index: 100;
  left: 15px;
  top: 15px;
  visibility: hidden;
  width: calc(50% - 15px);
  height: calc(100% - 30px);
  background-color: rgba(10, 180, 180, .2);
}
.slotcontainer > .overlay.left {
  background-color: rgba(200, 50, 100, .2);
}
.slotcontainer > .overlay.right {
  left: unset;
  right: 15px;
}
.slotcontainer > .overlay.full {
  width: calc(100% - 30px);
}
.slotcontainer > .overlay > img {
  width: 10%;
  position: absolute;
  left: 50%;
  top: 50%;
  transform: translate(-50%, -50%);
}
.slotcontainer > .overlay.left.active {
  background-color: rgba(200, 50, 100, .8);
}
.slotcontainer > .overlay.active {
  background-color: rgba(10, 180, 180, .8);
}
.slotcontainer > .overlay.visible {
  visibility: visible;
}
.slotcontainer > .pin {
  position: absolute;
  z-index: 90;
  left: 50%;
  transform: translateX(-50%);
  top: 20px;
  width: 20px;
}
</style>
