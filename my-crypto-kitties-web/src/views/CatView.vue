<template>
    <div>
        <h1>Cat {{ catId }}</h1>
        <br>
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <div class="card cat-container">
                        <div class="card-body d-flex justify-content-center">
                            <Cat v-if="renderCat" :cat="cat" />
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    DNA: {{ cat.dna }}
                    <br>
                    generation: {{ cat.generation }}
                    <br>
                    birth date: {{ formatDate(cat.birthTime) }}
                    <br>
                    owner: {{ owner }}
                </div>
            </div>
            <br>
            <br>
            <br>
            <div class="row parent">
                <div v-if="parent1.id && parent1.id != 0" class="col-md-6">
                    Parent 1
                    <CatCard :read-only="true" :cat="parent1" />
                </div>
                <div v-if="parent2.id && parent2.id != 0" class="col-md-6">
                    Parent 2
                    <CatCard :read-only="true" :cat="parent2" />
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import {Wallet} from "../wallet/Wallet";
    import Cat from "../components/Cat";
    import CatCard from "../components/CatCard";

    export default {
        name: "CatView",

        computed: {
            renderCat() {
                return this.cat.id;
            }
        },

        data() {
          return {
              catId: null,
              cat: this.getClearCat(),
              owner: null,
              parent1: this.getClearCat(),
              parent2: this.getClearCat(),
          }
        },

        beforeMount() {
            this.catId = this.$route.params.id;

            Wallet.getKitty(this.catId).then((response) => {
               this.cat = response;
               this.cat.id = this.catId;
               Wallet.getKitty(this.cat.dadId).then((response) => {
                   this.parent1 = response;
                   this.parent1.id = this.cat.dadId;
               });
                Wallet.getKitty(this.cat.mumId).then((response) => {
                    this.parent2 = response;
                    this.parent2.id = this.cat.mumId;
                });
            });

            Wallet.ownerOf(this.catId).then((response) => {
                this.owner = response;
            })
        },

        components: {CatCard, Cat},

        methods: {
            getClearCat() {
                return {
                    id: null,
                    dna: null,
                    birthTime: null,
                    mumId: null,
                    dadId: null,
                }
            },

            formatDate(timestamp) {
                const date = new Date(timestamp * 1000);
                const year = date.getFullYear();
                const month = "0" + (date.getMonth() + 1);
                const day = "0" + date.getUTCDay();
                const hours = date.getHours();
                const minutes = "0" + date.getMinutes();
                const seconds = "0" + date.getSeconds();

                return year + '-' + month.substr(-2) + '-' + day.substr(-2) + ' ' + hours + ':'
                    + minutes.substr(-2) + ':' + seconds.substr(-2);
            }
        }
    }
</script>

<style scoped>
    .cat-container {
        width: 350px;
    }
    .card-body {
        z-index: 2;
    }
    .parent .card {
        margin-top: -60px;
        transform: scale(0.6);
    }
</style>