<template>
  <div class="cat">
    <div class="ears">
      <div class="ear ear-left" v-bind:style="{backgroundColor: bodyColor}">
        <div class="earlobe"></div>
      </div>
      <div class="ear ear-right" v-bind:style="{backgroundColor: bodyColor}">
        <div class="earlobe"></div>
      </div>
    </div>
    <div class="body" v-bind:style="{backgroundColor: bodyColor}">
      <div class="eyes">
        <div class="eye">
          <div class="pupils">
            <div class="dot1"></div>
            <div class="dot2"></div>
          </div>
        </div>
        <div class="eye">
          <div class="pupils">
            <div class="dot1"></div>
            <div class="dot2"></div>
          </div>
        </div>
      </div>
      <div class="mouth">
        <div class="nose">
          <div class="up"></div>
          <div class="down">
            <div class="left"></div>
            <div class="right"></div>
          </div>
        </div>
      </div>
      <div class="mustache">
        <div class="left">
          <div class="mustache1"></div>
          <div class="mustache2"></div>
          <div class="mustache3"></div>
        </div>
        <div class="right">
          <div class="mustache1"></div>
          <div class="mustache2"></div>
          <div class="mustache3"></div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import {DNA} from "../dna/DNA.js";

export default {
  name: 'Cat',

  props: {
    dna: String
  },

  beforeMount() {
    this.DNA = new DNA(this.dna);
    this.bodyColor = this.DNA?.getBodyColor();
  },

  data() {
    return {
      DNA: null,
      bodyColor: null,
    }
  }
}
</script>

<style lang="less" scoped>
  @import url(@/assets/less/cat.less);
</style>
