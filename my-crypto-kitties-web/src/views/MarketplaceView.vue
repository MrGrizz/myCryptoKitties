<template>
    <div>
        <h1>Marketplace</h1>
        <br>
        <div class="container">
            <div class="row">
                <div v-for="(kitty, index) in kitties" :key="index" class="col-md-4 mb-5">
                    <CatCard :cat="kitty" :buy="true" />
                </div>
            </div>
        </div>
        <br>
    </div>
</template>

<script>
    import CatCard from "../components/CatCard";
    import {getOffersMixin} from "../mixin/getOffersMixin";

    export default {
        name: "MarketplaceView",
        mixins: [getOffersMixin],

        components: {CatCard},

        data() {
            return {};
        },

        methods: {
        }
    }
</script>

<style scoped>

</style>