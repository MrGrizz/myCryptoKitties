// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC721.sol";
import "./Ownable.sol";

contract Kittycontract is IERC721, Ownable {

    string public constant override name = "MichalKitties";
    string public constant override symbol = "MKIT";

    event Birth(address owner, uint256 mumId, uint256 dadId, string dna);

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

    function balanceOf(address owner) override external view returns (uint256 balance) {
        balance = balances[owner];
    }

    function totalSupply() override external view returns (uint256 total) {
        total = kitties.length;
    }

    function ownerOf(uint256 tokenId) override external view returns (address owner) {
        require(tokenId < kitties.length, "Token doesn't exist");

        owner = kittyOwner[tokenId];
    }

    function transfer(address to, uint256 tokenId) override external {
        require(to != address(0));
        require(to != address(this));
        require(tokenId < kitties.length, "Token doesn't exist");
        require(_owns(msg.sender, tokenId), "You don't own this token");

        _transfer(msg.sender, to, tokenId);
    }

    function createKittyGen0(string memory _dna) onlyOwner public {
        _createKitty(_dna, 0, 0, 0, msg.sender);
    }

    function _createKitty(
        string memory _dna,
        uint256 _mumId,
        uint256 _dadId,
        uint256 _generation,
        address _owner) internal returns(uint256) {

        Kitty memory kitty = Kitty({
            dna: _dna,
            birthTime: uint64(block.timestamp),
            mumId: uint32(_mumId),
            dadId: uint32(_dadId),
            generation: uint16(_generation)
        });

        kitties.push(kitty);
        uint256 kittyId = kitties.length - 1;

        emit Birth(_owner, _mumId, _dadId, _dna);

        _transfer(address(0), _owner, kittyId);

        return kittyId;
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
