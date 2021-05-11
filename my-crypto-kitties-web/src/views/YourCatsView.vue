<template>
    <div>
        <h1>Your Cats</h1>
        <br>
        <div class="container">
            <div class="row">
                <div class="col-md-4">
                    <Cat ref="cat" :cat="cat" />
                </div>
                <div class="col-md-4">
                    <Cat ref="cat" :cat="cat2" />
                </div>
                <div class="col-md-4">
                    <Cat ref="cat" :cat="cat3" />
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import Cat from "../components/Cat";

    export default {
        name: "YourCatsView",

        components: {Cat},

        data() {
            return {
                cat: {
                    id: 1,
                    dna: 'f6b950a6a930b48ad1ffe4c8c12a8b91',
                    generation: 0,
                    price: 0.5,
                },
                cat2: {
                    id: 2,
                    dna: 'a6b910a6a930b44ad1ca83c8a14a8b74',
                    generation: 0,
                    price: 1.2
                },
                cat3: {
                    id: 2,
                    dna: 'caf950b6a434f43ad1ffe4c8c12a8b85',
                    generation: 1,
                    price: 0.24
                },
            };
        },

        methods: {}
    }
</script>

<style scoped>

</style>