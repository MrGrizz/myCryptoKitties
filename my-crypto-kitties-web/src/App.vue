<template>
  <div class="main-container">
    <Cat ref="cat" :dna="dna" />
    <button type="button" @click="generateCat" class="btn btn-primary">Generate</button>
    <button type="button" class="btn btn-success">Create cat</button>
  </div>
</template>

<script>
import Cat from './components/Cat'
import {DNA} from './dna/DNA.js';

export default {
  name: 'App',

  data() {
    return {
      dna: 'f6b950a6a930b48ad1ffe4c8c12a8b91',
    }
  },

  components: {
    Cat,
  },

  methods: {
    generateCat() {
      this.dna = DNA.getRandomCatDna();
      this.$refs.cat.$forceUpdate();
    }
  },
}
</script>

<style lang="less">
  @import url(../node_modules/bootstrap/dist/css/bootstrap.min.css);

  #app {
    font-family: Avenir, Helvetica, Arial, sans-serif;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
    text-align: center;
    color: #2c3e50;
    margin-top: 60px;
  }
</style>
