// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC721Receiver {

    function onERC721Received(address _from, address _to, uint256 _tokenId, bytes calldata data) external returns(bytes4);
}