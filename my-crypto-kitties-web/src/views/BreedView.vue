<template>
    <div class="breed-view">
        <h1>Breed Cats</h1>
        <br>
        <div v-if="kitties.length > 0" class="container">
            <div class="row">
                <div class="dropdown col-md-6">
                    <button class="btn btn-secondary dropdown-toggle" type="button" @click="toggleSelectCat">
                        Parent 1
                    </button>
                    <br>
                    <br>
                    <div v-if="selectCatListVisible" class="row dropdown-menu">
                        <div v-for="(kitty, index) in kitties" :key="index" @click="selectCat1(kitty)" class="col-md-3 mb-4">
                            <CatCard :cat="kitty" :read-only="true" />
                        </div>
                    </div>
                </div>
                <div class="dropdown col-md-6">
                    <button class="btn btn-secondary dropdown-toggle" type="button" @click="toggleSelectCat2">
                        Parent 2
                    </button>
                    <br>
                    <br>
                    <div v-if="selectCatListVisible2" class="row dropdown-menu">
                        <div v-for="(kitty, index) in kitties" :key="index" @click="selectCat2(kitty)" class="col-md-3 mb-4">
                            <CatCard ref="cat" :cat="kitty" :read-only="true" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div v-if="parent1" class="col-md-6">
                    <CatCard :cat="parent1" :readOnly="true" />
                </div>
                <div v-if="parent2" class="col-md-6">
                    <CatCard :cat="parent2" :readOnly="true" />
                </div>
            </div>
            <br>
            <br>
            <div v-if="parent1 && parent2" class="container">
                <button type="button" class="btn btn-pink breed-button" @click="breed">Give them some privacy</button>
            </div>
            <div v-if="success" class="alert alert-success" role="alert">
                Success! You get new Kitty. Go to <router-link :to="{name: 'YourCats'}">Your Cats</router-link> to see it
            </div>
            <div v-if="error" class="alert alert-danger" role="alert">
                Error
            </div>
        </div>
    </div>
</template>

<script>
    import {getKittiesMixin} from "../mixin/getKittiesMixin";
    import {Wallet} from "../wallet/Wallet";
    import CatCard from "../components/CatCard";

    export default {
        name: "BreedView",

        mixins: [getKittiesMixin],

        components: {CatCard},

        data() {
            return {
                selectCatListVisible: false,
                selectCatListVisible2: false,
                parent1: null,
                parent2: null,
                success: false,
                error: false,
            }
        },

        methods: {
            toggleSelectCat() {
                this.selectCatListVisible = !this.selectCatListVisible;
            },

            toggleSelectCat2() {
                this.selectCatListVisible2 = !this.selectCatListVisible2;
            },

            selectCat1(cat) {
                this.toggleSelectCat();
                this.parent1 = cat;
            },

            selectCat2(cat) {
                this.toggleSelectCat2();
                this.parent2 = cat;
            },

            breed() {
                Wallet.breed(this.parent1.id, this.parent2.id).then(() => {
                    this.parent2 = null;
                    this.parent1 = null;
                    this.success = true;

                    setTimeout(() => {
                        this.success = false;
                    }, 5000);
                }).catch(() => {
                    this.error = true;
                    this.parent2 = null;
                    this.parent1 = null;

                    setTimeout(() => {
                        this.error = false;
                    }, 5000);
                });
            }
        }

    }
</script>

<style lang="less">
    .breed-view {
        .dropdown {
            .cat {
                transform: scale(0.3);
                margin-top: -95px;
            }

            .card {
                cursor: pointer;
            }

            .card-header {
                font-size: 12px;
                text-align: center;
            }

            .card-body {
                height: 80px;
            }

            .card-footer {
                display: none;
            }

            .dropdown-menu {
                width: 100%;
                display: flex;
            }
        }

        .breed-button {
            width: 200px;
        }
    }
</style>