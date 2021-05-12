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