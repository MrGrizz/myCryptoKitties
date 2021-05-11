// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC721.sol";
import "./Ownable.sol";
import "./IERC721Receiver.sol";

contract Kittycontract is IERC721, Ownable {

    string public constant override name = "MichalKitties";
    string public constant override symbol = "MKIT";

    bytes4 internal constant _ERC721_INTERFACE_ID = 0x80ac58cd;
    bytes4 internal constant _ERC165_INTERFACE_ID = 0x01ffc9a7;

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
    mapping(uint256 => address) approvals;
    mapping(address => mapping(address => bool)) approvalsForAll;

    Kitty[] kitties;

    function supportsInterface(bytes4 _interfaceId) external pure returns(bool) {
        return _interfaceId == _ERC721_INTERFACE_ID || _interfaceId == _ERC165_INTERFACE_ID;
    }

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

    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) override external {
        require(_tokenId < kitties.length, "Token doesn't exist");
        require(_isApproved(msg.sender, _tokenId), "You are not authorize to transfer this token");
        require(_owns(_from, _tokenId), "_from address isn't current owner");
        require(_to != address(0), "_to address is 0 address");

        _safeTransfer(_from, _to, _tokenId, data);
    }

    function safeTransferFrom(address _from, address _to, uint256 _tokenId) override external {
        require(_tokenId < kitties.length, "Token doesn't exist");
        require(_isApproved(msg.sender, _tokenId), "You are not authorize to transfer this token");
        require(_owns(_from, _tokenId), "_from address isn't current owner");
        require(_to != address(0), "_to address is 0 address");

        _safeTransfer(_from, _to, _tokenId, "");
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) override external {
        require(_tokenId < kitties.length, "Token doesn't exist");
        require(_isApproved(msg.sender, _tokenId), "You are not authorize to transfer this token");
        require(_owns(_from, _tokenId), "_from address isn't current owner");
        require(_to != address(0), "_to address is 0 address");

        _transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId) override external {
        require(_tokenId < kitties.length, "Token doesn't exist");
        require(_owns(msg.sender, _tokenId), "You don't own this token");

        approvals[_tokenId] = _approved;

        emit Approval(msg.sender, _approved, _tokenId);
    }

    function setApprovalForAll(address _operator, bool _approved) override external {
        require(msg.sender != _operator);

        approvalsForAll[msg.sender][_operator] = _approved;

        emit ApprovalForAll(msg.sender, _operator, _approved);
    }

    function getApproved(uint256 _tokenId) override external view returns (address) {
        require(_tokenId < kitties.length, "Token doesn't exist");

        return approvals[_tokenId];
    }

    function isApprovedForAll(address _owner, address _operator) override external view returns (bool) {
        return approvalsForAll[_owner][_operator];
    }

    function createKittyGen0(string memory dna) onlyOwner public returns(uint256) {
        return _createKitty(dna, 0, 0, 0, msg.sender);
    }

    function getKitty(uint256 tokenId) view external returns (
        string memory dna,
        uint256 birthTime,
        uint256 mumId,
        uint256 dadId,
        uint256 generation,
        address owner) {

        Kitty storage k = kitties[tokenId];

        dna = k.dna;
        birthTime = uint256(k.birthTime);
        mumId = uint256(k.mumId);
        dadId = uint256(k.dadId);
        generation = uint256(k.generation);
        owner = kittyOwner[tokenId];
    }

    function breed(uint256 dadId, uint256 mumId) external returns(uint256) {
        require(_owns(msg.sender, dadId));
        require(_owns(msg.sender, mumId));

        string storage mumDna = kitties[mumId].dna;
        string storage dadDna = kitties[dadId].dna;

        string memory newDna = _mixDna(mumDna, dadDna);
        uint256 generation = (kitties[mumId].generation + kitties[dadId].generation)/2;

        return _createKitty(newDna, mumId, dadId, generation, msg.sender);
    }

    function getMyKittyIds() external view returns(uint[] memory) {
        uint[] memory senderKitties = new uint[](kitties.length);
        uint index = 0;

        for (uint i = 0; i < kitties.length; i++) {
            if (_owns(msg.sender, i)) {
                senderKitties[index] = i;
                index = index + 1;
            }
        }

        return senderKitties;
    }

    function _mixDna(string memory mumDna, string memory dadDna) internal pure returns(string memory) {
        bytes memory mumDnaBytes = bytes(mumDna);
        bytes memory dadDnaBytes = bytes(dadDna);
        bytes memory result = new bytes(32);

        for (uint i = 0; i < 6; i++) {
            result[i] = mumDnaBytes[i];
        }

        for (uint i = 6; i < 12; i++) {
            result[i] = dadDnaBytes[i];
        }

        for (uint i = 12; i < 18; i++) {
            result[i] = dadDnaBytes[i];
        }

        for (uint i = 18; i < 24; i++) {
            result[i] = dadDnaBytes[i];
        }

        for (uint i = 24; i < 30; i++) {
            result[i] = mumDnaBytes[i];
        }

        result[30] = dadDnaBytes[30];
        result[31] = mumDnaBytes[31];

        return string(result);
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

    function _safeTransfer(address _from, address _to, uint256 _tokenId, bytes memory data) internal {
        _transfer(_from, _to, _tokenId);
        require(_checkAddress(_from, _to, _tokenId, data));
    }

    function _transfer(address from, address to, uint256 tokenId) internal {
        kittyOwner[tokenId] = to;
        balances[to] += 1;
        if (from != address(0)) {
            balances[msg.sender] -= 1;
            delete approvals[tokenId];
        }

        emit Transfer(msg.sender, to, tokenId);
    }

    function _checkAddress(address _from, address _to, uint256 _tokenId, bytes memory data) internal returns(bool) {
        if (!_isSmartContract(_to)) {
            return true;
        }

        IERC721Receiver receiver = IERC721Receiver(_to);
        bytes4 result = receiver.onERC721Received(msg.sender, _from, _tokenId, data);

        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")) == result;
    }

    function _isSmartContract(address _to) internal view returns(bool) {
        uint code;
        assembly {
            code := extcodesize(_to)
        }

        return code > 0;
    }

    function _isApproved(address claimant, uint256 tokenId) internal view returns(bool) {
        return _owns(claimant, tokenId) ||
                approvals[tokenId] == claimant ||
                approvalsForAll[kittyOwner[tokenId]][claimant];
    }

    function _owns(address claimant, uint256 tokenId) internal view returns(bool) {
        return kittyOwner[tokenId] == claimant;
    }
}
