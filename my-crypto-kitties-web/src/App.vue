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
          <span v-if="connected" class="navbar-text">
            Balance: {{ balance }} <img src="./assets/ethereum-logo.png" width="20" height="24" />&nbsp;&nbsp;&nbsp;
            Connected! {{ SmartContract.accountAddress }}
          </span>
          <button v-else type="button" @click="connectWallet" class="btn btn-light">Connect Metamask</button>
        </div>
      </div>
    </nav>
    <br>
    <br>
    <router-view :key="$route.fullPath" />
  </div>
</template>

<script>
import {Wallet} from "./wallet/Wallet";

export default {
  name: 'App',

  watch: {
    connected: function () {
      Wallet.getBalance().then((response) => {
        this.balance = Wallet.web3.utils.fromWei(response, "ether");
      });
    }
  },

  data() {
    return {
      SmartContract: Wallet,
      connected: Wallet.connected,
      balance: 0,
    }
  },

  beforeMount() {
    Wallet.init();
  },

  methods: {
    connectWallet() {
      Wallet.connectWallet(this);
    }
  }
}
</script>

<style lang="less">
  @import url(../node_modules/bootstrap/dist/css/bootstrap.min.css);
  @import "./assets/less/app";
</style>
