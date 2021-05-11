<template>
  <div class="card">
    <div class="card-header">
      token ID: {{ cat.id }}
    </div>
    <div class="card-body">
      <div class="cat">
        <div class="ears">
          <div class="ear ear-left" v-bind:style="{backgroundColor: color2}">
            <div class="earlobe"></div>
          </div>
          <div class="ear ear-right" v-bind:style="{backgroundColor: color2}">
            <div class="earlobe"></div>
          </div>
        </div>
        <div class="body" :class="headAnimationClass" v-bind:style="{backgroundColor: color1}">
          <div class="eyes">
            <div class="eye">
              <div class="pupils" v-bind:style="{backgroundColor: color3, borderTop: pupilsBorderTop, borderBottom: pupilsBorderBottom}">
                <div class="dot1"></div>
                <div class="dot2"></div>
              </div>
            </div>
            <div class="eye">
              <div class="pupils" v-bind:style="{backgroundColor: color3, borderTop: pupilsBorderTop, borderBottom: pupilsBorderBottom}">
                <div class="dot1"></div>
                <div class="dot2"></div>
              </div>
            </div>
          </div>
          <div class="mouth" v-bind:style="{backgroundColor: color4}">
            <div class="nose">
              <div class="up"></div>
              <div class="down">
                <div class="left" v-bind:style="{borderTopColor: color4, borderLeftColor: color4}"></div>
                <div class="right" v-bind:style="{borderTopColor: color4, borderLeftColor: color4}"></div>
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
    </div>
    <div class="card-footer text-muted">
      <div class="data">
        dna: {{ cat.dna }}
        <br>
        generation: {{ cat.generation }}
      </div>
      <div v-if="buy">
        <br>
        Price: {{ cat.price }} <img src="../assets/ethereum-logo.png" width="15" height="18" /> &nbsp;&nbsp;&nbsp;
        <button type="button" class="btn btn-pink buy-button">Buy</button>
      </div>
    </div>
  </div>
</template>

<script>
import {DNA} from '../dna/DNA.js';

export default {
  name: 'Cat',

  props: {
    cat: Object,
    buy: {
      type: Boolean,
      default: false,
    }
  },

  watch: {
    cat: {
      handler() {
        this.drawCat();
      },
      deep: true,
    }
  },

  beforeMount() {
    this.drawCat();
  },

  data() {
    return {
      DNA: null,
      color1: null,
      color2: null,
      color3: null,
      color4: null,
      pupilsBorderTop: '0px solid',
      pupilsBorderBottom: '0px solid',
      headAnimationClass: null,
    }
  },

  methods: {
    drawCat() {
      this.DNA = new DNA(this.cat.dna);
      this.color1 = this.DNA?.getColor1();
      this.color2 = this.DNA?.getColor2();
      this.color3 = this.DNA?.getColor3();
      this.color4 = this.DNA?.getColor4();

      if (this.DNA?.getCattribute1() > 0) {
        this.pupilsBorderTop = this.DNA?.getCattribute1() + 'px solid';
        this.pupilsBorderBottom = null;
      } else {
        this.pupilsBorderBottom = -this.DNA?.getCattribute1() + 'px solid';
        this.pupilsBorderTop = null;
      }

      switch (this.DNA?.getCattribute2()) {
        case 1:
          this.headAnimationClass = 'movingHead';
          break;
        case 2:
          this.headAnimationClass = 'movingHead2';
          break;
        default :
          this.headAnimationClass = '';
      }
    }
  }
}
</script>

<style lang="less" scoped>
  @import url(@/assets/less/cat.less);
</style>
