import Web3 from 'web3';
import {Kittycontract} from "../contracts/Kittycontract";
import {emitter} from "../emitter";
import {Marketplace} from "../contracts/Marketplace";

export const Wallet = {
    web3: null,
    kittyContractInstance: null,
    marketplaceInstance: null,
    accountAddress: "",
    connected: false,

    init() {
        Wallet.web3 = new Web3(Web3.givenProvider);
    },

    connectWallet(context) {
        window.ethereum.enable().then((accounts) => {
            Wallet.accountAddress = accounts[0];
            Wallet.kittyContractInstance = new Wallet.web3.eth.Contract(Kittycontract.abi, Kittycontract.address, {from: Wallet.accountAddress});
            Wallet.marketplaceInstance = new Wallet.web3.eth.Contract(Marketplace.abi, Marketplace.address, {from: Wallet.accountAddress});
            Wallet.connected = true;
            context.connected = true;
            emitter.emit('WalletConnected');
        });
    },

    getBalance() {
        return Wallet.web3.eth.getBalance(this.accountAddress);
    },

    createKittyGen0(dna) {
        Wallet.kittyContractInstance.methods.createKittyGen0(dna).send({}, (error, txHash) => {
            if (error) {
                console.log(error);
            } else {
                console.log(txHash);
            }
        });
    },

    breed(dadId, mumId) {
        return Wallet.kittyContractInstance.methods.breed(dadId, mumId).send({});
    },

    getMyKittyIds() {
        return Wallet.kittyContractInstance.methods.getMyKittyIds().call({});
    },

    getKitty(tokenId) {
        return Wallet.kittyContractInstance.methods.getKitty(tokenId).call({});
    },

    sell(tokenId, price) {
        return Wallet.marketplaceInstance.methods.setOffer(price, tokenId).send({});
    },

    forSale(tokenId) {
        return Wallet.marketplaceInstance.methods.getOffer(tokenId).call({});
    },

    approveForMarketplace(tokenId) {
        return Wallet.kittyContractInstance.methods.approve(Marketplace.address, tokenId).send({});
    },

    approvedForMarketplace(tokenId) {
        return Wallet.kittyContractInstance.methods.getApproved(tokenId).call({});
    },
}