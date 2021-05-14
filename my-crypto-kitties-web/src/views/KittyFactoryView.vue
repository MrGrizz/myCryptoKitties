<template>
    <div>
        <h1>Kitty Factory</h1>
        <br>
        <div class="row">
            <div class="offset-4 col-md-4">
                <CatCard ref="cat" :cat="cat" />
                <br>
                <button type="button" @click="generateCat" class="btn btn-primary m-1">Generate random kitty</button>
                <button type="button" @click="createCat" class="btn btn-success">Create kitty</button>
            </div>
        </div>
    </div>
</template>

<script>
    import {DNA} from "../dna/DNA";
    import {Wallet} from "../wallet/Wallet";
    import CatCard from "../components/CatCard";

    export default {
        name: "KittyFactoryView",

        components: {CatCard},

        data() {
            return {
                cat: {
                    id: "",
                    dna: 'f6b950a6a930b48ad1ffe4c8c12a8b91',
                    generation: 0,
                },
            };
        },

        methods: {
            generateCat() {
                this.cat.dna = DNA.getRandomCatDna();
            },

            createCat() {
                Wallet.createKittyGen0(this.cat.dna);
            },
        }
    }
</script>

<style scoped>

</style>