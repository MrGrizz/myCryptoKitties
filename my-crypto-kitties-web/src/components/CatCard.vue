<template>
  <div class="card">
    <div class="card-header">
      token ID: {{ cat.id }}
    </div>
    <div class="card-body">
      <Cat :cat="cat" />
    </div>
    <div class="card-footer text-muted">
      <div class="data">
        dna: {{ cat.dna }}
        <br>
        generation: {{ cat.generation }}
      </div>
      <div v-if="!readOnly">
        <br>
        <div v-if="buy">
          Price: {{ cat.price }} <img src="../assets/ethereum-logo.png" width="15" height="18" /> &nbsp;&nbsp;&nbsp;
          <button type="button" class="btn btn-pink buy-button">Buy</button>
        </div>
        <div v-else>
          <button v-if="!approvedForMarketplace" type="button"
                  class="btn btn-pink" @click="approveForMarketplace">Approve for sale
          </button>
          <div v-else>
            <input type="number"> ETH &nbsp;&nbsp;&nbsp;
            <button type="button" class="btn btn-pink">Sell</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import {Wallet} from "../wallet/Wallet";
import {Marketplace} from "../contracts/Marketplace";
import Cat from "./Cat";

export default {
  name: 'CatCard',
  components: {Cat},
  props: {
    cat: Object,
    buy: {
      type: Boolean,
      default: false,
    },
    readOnly: {
      type: Boolean,
      default: false,
    }
  },

  beforeMount() {
    if (!this.buy) {
      Wallet.approvedForMarketplace(this.cat.id).then((response) => {
        this.approvedForMarketplace = response === Marketplace.address;
      });
    }

    console.log(this.readOnly);
  },

  data() {
    return {
      approvedForMarketplace: null,
    }
  },

  methods: {
    approveForMarketplace() {
      Wallet.approveForMarketplace(this.cat.id).then(() => {
        this.approvedForMarketplace = true;
      });
    },
  }
}
</script>

<style lang="less" scoped>
  @import url(@/assets/less/cat-card.less);
</style>
