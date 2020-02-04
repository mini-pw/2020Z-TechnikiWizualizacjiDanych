<template>
  <div class="block" :style="{ paddingTop: title ? '30px' : '20px' }">
    <div class="blocktitle" v-if="title">{{ title }}</div>
    <slot></slot>
  </div>
</template>

<script>
export default {
  name: 'Block',
  props: {
    title: String
  }
}
</script>

<style>
.block {
  width: calc(100% - 30px);
  height: calc(100% - 30px);
  box-sizing: border-box;
  padding: 20px;
  margin: 15px;
  overflow: hidden;
  background: white;
  box-shadow: 0 4px 8px 0 rgba(0, 0, 0, 0.2), 0 6px 20px 0 rgba(0, 0, 0, 0.19);
  position: relative;
}
.block > .blocktitle {
  position: absolute;
  top: 22px;
  font-size: 20px;
  z-index: 10;
  font-family: Roboto;
  text-align: center;
  width: calc(100% - 40px);
}
</style>
