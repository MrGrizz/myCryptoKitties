const Kittycontract = artifacts.require("Kittycontract");
const KittyMarketPlace = artifacts.require("KittyMarketPlace");

module.exports = function (deployer) {
  deployer.deploy(KittyMarketPlace, Kittycontract.address);
};
