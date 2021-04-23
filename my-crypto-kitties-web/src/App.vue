<template>
  <div class="main-container">
    <Cat dna="f6b950a6a930b48ad1ffe4c8c12a8b9" />
  </div>
</template>

<script>
import Cat from "./components/Cat";

export default {
  name: 'App',
  components: {
    Cat,
  }
}
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
