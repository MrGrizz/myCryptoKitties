<template>
  <div class="main-container">
    <nav class="navbar navbar-expand-lg navbar-dark">
      <a class="navbar-brand">CryptoKitties</a>
      <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav mr-auto">
          <li class="nav-item">
            <router-link class="nav-link" :to="{name: 'Marketplace'}" >
              Marketplace
            </router-link>
          </li>
          <li class="nav-item">
            <router-link class="nav-link" :to="{name: 'YourCats'}" >
              Your cats
            </router-link>
          </li>
        </ul>
        <div class="wallet">
          <span v-if="user" class="navbar-text">
            Your balance: 50 <img src="./assets/ethereum-logo.png" width="20" height="24" />&nbsp;&nbsp;&nbsp;
            Connected! {{ user }}
          </span>
          <button v-else type="button" @click="connectWallet" class="btn btn-light">Connect Metamask</button>
        </div>
      </div>
    </nav>
    <br>
    <br>
    <router-view />
  </div>
</template>

<script>
import Web3 from 'web3'
import {Kittycontract} from "./kittycontract/Kittycontract";

export default {
  name: 'App',

  data() {
    return {
      web3: null,
      instance: null,
      user: null,
    }
  },

  mounted() {
    this.web3 = new Web3(Web3.givenProvider);
  },

  methods: {
    connectWallet() {
      window.ethereum.enable().then((accounts) => {
        this.user = accounts[0];
        this.instance = new this.web3.eth.Contract(Kittycontract.abi, Kittycontract.address, {from: this.user});
        this.instance.events.Birth({}).on('data', (event) => {
          console.log(event);
        });
      });
    },
  },
}
</script>

<style lang="less">
  @import url(../node_modules/bootstrap/dist/css/bootstrap.min.css);
  @import "./assets/less/app";
</style>
