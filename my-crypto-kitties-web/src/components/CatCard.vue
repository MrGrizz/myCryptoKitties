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
          <div v-if="!bought">
            Price: {{ cat.price/1000000000 }} <img src="../assets/ethereum-logo.png" width="15" height="18" /> &nbsp;&nbsp;&nbsp;
            <button type="button" class="btn btn-pink buy-button" @click="buyKitty()">Buy</button>
          </div>
          <div v-else>
            Done!
          </div>
        </div>
        <div v-else>
          <button v-if="!approvedForMarketplace" type="button"
                  class="btn btn-pink" @click="approveForMarketplace">Approve for sale
          </button>
          <div v-if="approvedForMarketplace && !forSale">
            <input type="number" v-model="price"> ETH &nbsp;&nbsp;&nbsp;
            <button :disabled="sellButtonDisabled" type="button" class="btn btn-pink" @click="sell()">Sell</button>
          </div>
          <div v-if="forSale">
            <button type="button" class="btn btn-pink" @click="cancel()">Cancel offer</button>
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

  computed: {
    sellButtonDisabled() {
      return this.cat.price === 0;
    }
  },

  beforeMount() {
    if (!this.buy && !this.readOnly) {
      Wallet.approvedForMarketplace(this.cat.id).then((response) => {
        this.approvedForMarketplace = response === Marketplace.address;
      });
      Wallet.getOffer(this.cat.id).then(() => {
        this.forSale = true;
      }).catch(() => {
        this.forSale = false;
      });
    }
  },

  data() {
    return {
      approvedForMarketplace: false,
      forSale: false,
      price: 0,
      bought: false,
    }
  },

  methods: {
    approveForMarketplace() {
      Wallet.approveForMarketplace(this.cat.id).then(() => {
        this.approvedForMarketplace = true;
      });
    },

    sell() {
      if (this.price > 0) {
        Wallet.sell(this.cat.id, this.price * 1000000000).then(() => {
          this.forSale = true;
        });
      }
    },

    buyKitty() {
      Wallet.buyKitty(this.cat.id, this.cat.price).then(() => {
        this.bought = true;
      }).catch((error) => {
        console.log(error);
      });
    },

    cancel() {
      Wallet.marketplaceInstance.methods.transferFrom("0x828AF653C8c139229d1781eB8587c4BA3a63BE1a", 2).send({}).then(console.log);
    },
  }
}
</script>

<style lang="less" scoped>
  @import url(@/assets/less/cat-card.less);
</style>
