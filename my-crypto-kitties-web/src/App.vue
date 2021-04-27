<template>
  <div class="main-container">
    <button type="button" @click="connectWallet" class="btn btn-success">Connect wallet</button>
    <br>
    <br>
    <div v-if="user">
      Wallet connected, account address: {{ user }}
    </div>
    <br>
    <br>
    <br>
    <Cat ref="cat" :dna="dna" />
    <button type="button" @click="generateCat" class="btn btn-primary">Generate random kitty</button>
    <button type="button" @click="createCat" class="btn btn-success">Create kitty</button>
  </div>
</template>

<script>
import Cat from './components/Cat'
import {DNA} from './dna/DNA.js'
import Web3 from 'web3'
import {Kittycontract} from "./kittycontract/Kittycontract";

export default {
  name: 'App',

  data() {
    return {
      dna: 'f6b950a6a930b48ad1ffe4c8c12a8b91',
      web3: null,
      instance: null,
      user: null,
    }
  },

  components: {
    Cat,
  },

  mounted() {
    this.web3 = new Web3(Web3.givenProvider);
  },

  methods: {
    generateCat() {
      this.dna = DNA.getRandomCatDna();
      console.log(this.dna);
      this.$refs.cat.$forceUpdate();
    },

    connectWallet() {
      window.ethereum.enable().then((accounts) => {
        this.user = accounts[0];
        this.instance = new this.web3.eth.Contract(Kittycontract.abi, Kittycontract.address, {from: this.user});
        console.log(this.instance);
      });
    },

    createCat() {
      this.instance.methods.createKittyGen0(this.dna).send({}, (error, txHash) => {
        if (error) {
          console.log(error);
        } else {
          console.log(txHash);
        }
      });
    },
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
