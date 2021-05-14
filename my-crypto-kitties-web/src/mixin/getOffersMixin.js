import {Wallet} from "../wallet/Wallet";
import {emitter} from "../emitter";

export const getOffersMixin = {
    data() {
        return {
            kittyIds: [],
            kitties: [],
        };
    },

    created() {
        emitter.on('WalletConnected', () => {
            this.getOffers();
        });
    },

    beforeMount() {
        this.getOffers();
    },

    methods: {
        getOffers() {
            this.kittyIds = [];
            this.kitties = [];

            Wallet.getOfferIds().then((response) => {
                this.kittyIds = response;
                for (const tokenId of this.kittyIds) {
                    if (tokenId != 0) {
                        Wallet.getOffer(tokenId).then((response) => {
                            console.log(response);
                            response.id = tokenId;
                            const offer = response;
                            Wallet.getKitty(tokenId).then((response) => {
                                response.price = offer.price;
                                response.id = tokenId;
                                this.kitties.push(response);
                            });
                        });
                    }
                }
            });
        }
    }
}
