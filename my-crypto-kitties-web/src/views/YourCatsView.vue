<template>
    <div>
        <h1>Your Cats</h1>
        <br>
        <div class="container">
            <div v-if="kitties.length > 0" class="row">
                <div class="col-md-1">
                    <router-link :to="{name: 'Breed'}">
                        <button type="button" class="btn btn-pink">Breed</button>
                    </router-link>
                    <br>
                    <br>
                </div>
            </div>
            <div class="row">
                <div v-for="(kitty, index) in kitties" :key="index" class="col-md-4 mb-5">
                    <CatCard ref="cat" :cat="kitty" />
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import {getKittiesMixin} from "../mixin/getKittiesMixin";
    import CatCard from "../components/CatCard";

    export default {
        name: "YourCatsView",

        mixins: [getKittiesMixin],

        components: {CatCard},
    }
</script>

<style scoped>

</style>