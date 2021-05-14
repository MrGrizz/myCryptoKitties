import {Wallet} from "../wallet/Wallet";
import {emitter} from "../emitter";

export const getKittiesMixin = {
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
            this.kittyIds = [];
            this.kitties = [];

            Wallet.getMyKittyIds().then((response) => {
                this.kittyIds = response;
                for (const tokenId of this.kittyIds) {
                    if (tokenId != 0) {
                        Wallet.getKitty(tokenId).then((response) => {
                            response.id = tokenId;
                            this.kitties.push(response);
                        });
                    }
                }
            });
        }
    }
}