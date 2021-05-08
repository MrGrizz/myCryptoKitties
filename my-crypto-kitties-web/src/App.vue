<template>
  <div class="main-container">
    <nav class="navbar navbar-expand-lg navbar-dark">
      <a class="navbar-brand">CryptoKitties</a>
      <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mr-auto">
          <li class="nav-item">
            <a class="nav-link" @click="goToMarketPlace">Marketplace</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" @click="goToYourCats">Your cats</a>
          </li>
        </ul>
        <div class="wallet">
          <span v-if="user" class="navbar-text">
            Connected! {{ user }}
          </span>
          <button v-else type="button" @click="connectWallet" class="btn btn-light">Connect Metamask</button>
        </div>
      </div>
    </nav>
    <br>
    <br>
    <div v-if="isYourCatsPage">
      <h1>Your Cats</h1>
      <br>
      <div class="container">
        <div class="row">
          <div class="col-md-4">
            <Cat ref="cat" :dna="dna" />
          </div>
          <div class="col-md-4">
            <Cat ref="cat" :dna="dna2" />
          </div>
          <div class="col-md-4">
            <Cat ref="cat" :dna="dna3" />
          </div>
        </div>
      </div>
      <button type="button" @click="generateCat" class="btn btn-primary">Generate random kitty</button>
      <button type="button" @click="createCat" class="btn btn-success">Create kitty</button>
    </div>
    <div v-if="isMarketPlacePage">
      <h1>Marketplace</h1>
      <br>
    </div>
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
      dna2: 'a6b910a6a930b44ad1ca83c8a14a8b74',
      dna3: 'caf950b6a434f43ad1ffe4c8c12a8b85',
      web3: null,
      instance: null,
      user: null,
      page: 'YOUR_CATS',
    }
  },

  components: {
    Cat,
  },

  mounted() {
    this.web3 = new Web3(Web3.givenProvider);
  },

  computed: {
    isMarketPlacePage() {
      return this.page === 'MARKETPLACE';
    },

    isYourCatsPage() {
      return this.page === 'YOUR_CATS';
    }
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
        this.instance.events.Birth({}).on('data', (event) => {
          console.log(event);
        });
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

    goToMarketPlace() {
      this.page = 'MARKETPLACE';
    },

    goToYourCats() {
      this.page = 'YOUR_CATS';
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
    background-color: #ffe7e9;
    height: 1000px;
    color: #2c3e50;
  }

  .navbar-brand {
    margin-left: 10px;
  }

  .navbar {
    background-color: deeppink;
    color: white;
  }

  .navbar-text {
    margin-right: 10px;
  }

  .nav-link {
    cursor: pointer;
  }

  .navbar-dark .navbar-nav .nav-link {
    color: white;
  }

  .wallet {
    margin-left: auto;
    margin-right: 10px;
  }
</style>
