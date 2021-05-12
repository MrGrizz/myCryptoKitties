<template>
    <div>
        <h1>Your Cats</h1>
        <br>
        <div class="container">
            <div class="row">
                <div v-for="(kitty, index) in kitties" :key="index" class="col-md-4 mb-5">
                    <Cat ref="cat" :cat="kitty" />
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import Cat from "../components/Cat";
    import {Wallet} from "../wallet/Wallet";
    import {emitter} from "../emitter";

    export default {
        name: "YourCatsView",

        components: {Cat},

        data() {
            return {
                kittyIds: [],
                kitties: [],
            };
        },

        created() {
            emitter.on('WalletConnected', () => {
                this.getKitties();
            });
        },

        beforeMount() {
            if (Wallet.connected) {
                this.getKitties();
            }
        },

        methods: {
            getKitties() {
                Wallet.getMyKittyIds().then((response) => {
                   this.kittyIds = response;
                   for (const tokenId of this.kittyIds) {
                       Wallet.getKitty(tokenId).then((response) => {
                           response.id = tokenId;
                           this.kitties.push(response);
                       });
                   }
                });
            }
        }
    }
</script>

<style scoped>

</style>