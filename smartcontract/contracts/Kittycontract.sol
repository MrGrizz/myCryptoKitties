// SPDX-License-Identifier: MIT
pragma solidity ^0.5.12;

import "./IERC721.sol";

contract Kittycontract is IERC721 {

    string public constant name = "MichalKitties";
    string public constant symbol = "MKIT";

    struct Kitty {
        string dna;
        uint64 birthTime;
        uint32 mumId;
        uint32 dadId;
        uint16 generation;
    }

    mapping(uint256 => address) public kittyOwner;
    mapping(address => uint256) balances;

    Kitty[] kitties;

    function balanceOf(address owner) external view returns (uint256 balance) {
        balance = balances[owner];
    }

    function totalSupply() external view returns (uint256 total) {
        total = kitties.length;
    }

    function ownerOf(uint256 tokenId) external view returns (address owner) {
        require(tokenId < kitties.length, "Token doesn't exist");

        owner = kittyOwner[tokenId];
    }

    function transfer(address to, uint256 tokenId) external {
        require(to != address(0));
        require(to != address(this));
        require(tokenId < kitties.length, "Token doesn't exist");
        require(_owns(msg.sender, tokenId), "You don't own this token");

        _transfer(msg.sender, to, tokenId);
    }

    function _transfer(address from, address to, uint256 tokenId) internal {
        kittyOwner[tokenId] = to;
        balances[to] += 1;
        if (from != address(0)) {
            balances[msg.sender] -= 1;
        }

        emit Transfer(msg.sender, to, tokenId);
    }

    function _owns(address claimant, uint256 tokenId) internal view returns(bool) {
        return kittyOwner[tokenId] == claimant;
    }
}
