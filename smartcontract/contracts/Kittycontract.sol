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
    mapping(uint256 => address) approvals;
    mapping(address => mapping(address => bool)) approvalsForAll;

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

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
    ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
    ///  `onERC721Received` on `_to` and throws if the return value is not
    ///  `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    /// @param data Additional data with no specified format, sent in call to `_to`
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes calldata data) override external {

    }

    /// @notice Transfers the ownership of an NFT from one address to another address
    /// @dev This works identically to the other function with an extra data parameter,
    ///  except this function just sets data to "".
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) override external {

    }

    function transferFrom(address _from, address _to, uint256 _tokenId) override external {
        require(_tokenId < kitties.length, "Token doesn't exist");
        require(_isApproved(msg.sender, _tokenId), "You are not authorize to transfer this token");
        require(_owns(_from, _tokenId), "_from address isn't current owner");
        require(_to != address(0), "_to address is 0 address");

        _transfer(_from, _to, _tokenId)
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
            delete approvals[tokenId];
        }

        emit Transfer(msg.sender, to, tokenId);
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
