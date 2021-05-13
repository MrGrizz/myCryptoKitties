// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IKittyMarketplace.sol";
import "./Kittycontract.sol";
import "./Ownable.sol";

contract KittyMarketPlace is IKittyMarketPlace, Ownable {

    address internal kittyContractAddress;
    Kittycontract internal kittycontract;

    struct Order {
        uint tokenId;
        uint price;
        address seller;
        bool active;
    }

    Order[] orders;

    mapping(uint => uint) tokenIdToOrderId;

    /**
    * Set the current KittyContract address and initialize the instance of Kittycontract.
    * Requirement: Only the contract owner can call.
     */
    function setKittyContract(address _kittyContractAddress) override external onlyOwner {
        kittyContractAddress = _kittyContractAddress;
        kittycontract = Kittycontract(_kittyContractAddress);
    }

    /**
    * Get the details about a offer for _tokenId. Throws an error if there is no active offer for _tokenId.
     */
    function getOffer(uint256 _tokenId) override external view returns ( address seller, uint256 price, uint256 index, uint256 tokenId, bool active) {
        uint orderId = tokenIdToOrderId[_tokenId];
        Order storage order = orders[orderId];

        seller = order.seller;
        price = order.price;
        index = orderId;
        tokenId = _tokenId;
        active = order.active;
    }

    /**
    * Get all tokenId's that are currently for sale. Returns an empty arror if none exist.
     */
    function getAllTokenOnSale() override external view  returns(uint256[] memory listOfOffers) {
        listOfOffers = uint[];

        for (uint i = 0; i < orders.length; i++) {
            Order storage order = orders[i];

            if (order.active) {
                listOfOffers.push(i);
            }
        }
    }

    /**
    * Creates a new offer for _tokenId for the price _price.
    * Emits the MarketTransaction event with txType "Create offer"
    * Requirement: Only the owner of _tokenId can create an offer.
    * Requirement: There can only be one active offer for a token at a time.
    * Requirement: Marketplace contract (this) needs to be an approved operator when the offer is created.
     */
    function setOffer(uint256 _price, uint256 _tokenId) override external {
        require(kittycontract.ownerOf(_tokenId) == msg.sender, "You don't own this token");

        Order memory order = Order();
        order.price = _price;
        order.seller = msg.sender;
        order.active = true;
        order.tokenId = _tokenId;

        orders.push(order);
        tokenIdToOrderId[_tokenId] = orders.length - 1;

        emit MarketTransaction("Create offer", msg.sender, _tokenId);
    }

    /**
    * Removes an existing offer.
    * Emits the MarketTransaction event with txType "Remove offer"
    * Requirement: Only the seller of _tokenId can remove an offer.
     */
    function removeOffer(uint256 _tokenId) override external {
        uint orderId = tokenIdToOrderId[_tokenId];
        Order storage order = orders[orderId];

        require(msg.sender == order.seller, "You aren't seller of this token");

        order.active = false;
        delete tokenIdToOrderId[_tokenId];

        emit MarketTransaction("Remove offer", msg.sender, _tokenId);
    }

    /**
    * Executes the purchase of _tokenId.
    * Sends the funds to the seller and transfers the token using transferFrom in Kittycontract.
    * Emits the MarketTransaction event with txType "Buy".
    * Requirement: The msg.value needs to equal the price of _tokenId
    * Requirement: There must be an active offer for _tokenId
     */
    function buyKitty(uint256 _tokenId) override external payable {
        uint orderId = tokenIdToOrderId[_tokenId];
        Order storage order = orders[orderId];

        require(msg.value == order.price, "Value is not equal to price for this token");

        (bool sent, ) = order.seller.call{value: msg.value}("");
        require(sent);

        kittycontract.transferFrom(order.seller, msg.sender, _tokenId);

        order.active = false;
        delete tokenIdToOrderId[_tokenId];

        emit MarketTransaction("Buy", msg.sender, _tokenId);
    }

}
