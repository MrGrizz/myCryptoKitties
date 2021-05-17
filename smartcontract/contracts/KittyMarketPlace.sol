// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IKittyMarketplace.sol";
import "./Kittycontract.sol";
import "./Ownable.sol";

contract KittyMarketPlace is IKittyMarketPlace, Ownable {

    Kittycontract internal kittycontract;

    struct Offer {
        uint tokenId;
        uint price;
        address seller;
        bool active;
    }

    Offer[] offers;

    mapping(uint => uint) tokenIdToOfferId;

    constructor(address _kittyContractAddress) {
        kittycontract = Kittycontract(_kittyContractAddress);
        Offer memory offer = Offer(0, 0, msg.sender, false);
        offers.push(offer);
    }
    
    function setKittyContract(address _kittyContractAddress) override external onlyOwner {
        kittycontract = Kittycontract(_kittyContractAddress);
    }

    function getOffer(uint256 _tokenId) override external view returns ( address seller, uint256 price, uint256 index, uint256 tokenId, bool active) {
        uint offerId = tokenIdToOfferId[_tokenId];
        Offer storage offer = offers[offerId];
        
        require(offer.active, "No active offer for this token");

        seller = offer.seller;
        price = offer.price/1000000000;
        index = offerId;
        tokenId = _tokenId;
        active = offer.active;
    }

    function getAllTokenOnSale() override external view returns(uint256[] memory) {
        uint[] memory result = new uint[](offers.length);

        for (uint i = 0; i < offers.length; i++) {
            Offer storage offer = offers[i];

            if (offer.active) {
                result[i] = offer.tokenId;
            }
        }

        return result;
    }

    function setOffer(uint256 _price, uint256 _tokenId) override external {
        require(kittycontract.ownerOf(_tokenId) == msg.sender, "You don't own this token");
        require(offers[tokenIdToOfferId[_tokenId]].active == false, "Exist active offer for this token");
        require(kittycontract.getApproved(_tokenId) == address(this), "Marketplace isn't approved operator of this token");

        Offer memory offer = Offer(_tokenId, _price * 1000000000, msg.sender, true);

        offers.push(offer);
        tokenIdToOfferId[_tokenId] = offers.length - 1;

        emit MarketTransaction("Create offer", msg.sender, _tokenId);
    }

    function removeOffer(uint256 _tokenId) override external {
        uint offerId = tokenIdToOfferId[_tokenId];
        Offer storage offer = offers[offerId];

        require(msg.sender == offer.seller, "You aren't seller of this token");

        offer.active = false;
        delete tokenIdToOfferId[_tokenId];

        emit MarketTransaction("Remove offer", msg.sender, _tokenId);
    }

    function buyKitty(uint256 _tokenId) override external payable {
        uint offerId = tokenIdToOfferId[_tokenId];
        Offer storage offer = offers[offerId];

        require(msg.value == offer.price, "Value is not equal to price for this token");
        require(offer.active, "There isn't active offer for this token");

        (bool sent, ) = payable(offer.seller).call{value: msg.value}("");
        require(sent);

        kittycontract.transferFrom(offer.seller, msg.sender, _tokenId);

        offer.active = false;
        delete tokenIdToOfferId[_tokenId];

        emit MarketTransaction("Buy", msg.sender, _tokenId);
    }
}
