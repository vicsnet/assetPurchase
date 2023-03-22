// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
import "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

contract Asset{

struct Seller{
uint ItemName;
uint ItemID;
address ItemContract;
uint ItemPrice;

}

mapping(address => Seller) seller;

event ItemListed(uint ItemName, uint ItemPrice);
function listItemForSale(uint _itemName, uint _itemID, address _itemContract, uint _itemPrice ) public{
_itemListed(_itemName, _itemID, _itemContract, _itemPrice);
emit ItemListed(_itemName, _itemPrice);
}

function _itemListed( uint _itemName, uint _itemID, address _itemContract, uint _itemPrice) internal{
require(_itemContract != address(this), "You cant input this marketPlace contract Address");
require (IERC721(_itemContract).balanceOf(msg.sender) >=1 , "Your balance can not be zero ");
IERC721(_itemContract).approve(address(this), _itemID);
IERC721(_itemContract).safeTransferFrom(msg.sender, address(this), _itemID);

Seller storage s = seller[msg.sender];

s.ItemName= _itemName;
s.ItemID = _itemID;
s.ItemContract = _itemContract;
s.ItemPrice = _itemPrice;

}

}