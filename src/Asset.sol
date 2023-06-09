// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
import "lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract Asset{
uint id;
AggregatorV3Interface internal priceFeed;
struct Seller{
string ItemName;
uint ItemID;
address ItemContract;
uint ItemPrice;
address ItemOwner;

}

mapping(uint => Seller) sellerId;
mapping(uint => bool) idStatus;




event ItemListed(string ItemName, uint ItemPrice);

event ItemPurchased(string ItemName, uint ItemPrice, address ItemContract);

function listItemForSale(string memory _itemName, uint _itemID, address _itemContract, uint _itemPrice ) external{
_itemListed(_itemName, _itemID, _itemContract, _itemPrice);
emit ItemListed(_itemName, _itemPrice);
}

function _itemListed( string memory _itemName, uint _itemID, address _itemContract, uint _itemPrice) internal{
require(_itemContract != address(this), "You cant input this marketPlace contract Address");
require (IERC721(_itemContract).balanceOf(msg.sender) >=1 , "Your balance can not be zero ");
// IERC721(_itemContract).approve(address(this), _itemID);

// IERC721(_itemContract).transferFrom(msg.sender, address(this), _itemID);

IERC721(_itemContract).transferFrom(msg.sender, address(this), _itemID);
id ++;
Seller storage sId =  sellerId[id];

sId.ItemName= _itemName;
sId.ItemID = _itemID;
sId.ItemContract = _itemContract;
sId.ItemPrice = _itemPrice;
sId.ItemOwner = msg.sender;
idStatus[id] = true;

}


function buyItemListed(uint _id, uint tokenAmount) external {
_buyItemListed(_id, tokenAmount);

}
function _buyItemListed(uint _id, uint tokenAmount) internal{

address TokenCa = 0x6B175474E89094C44Da98b954EedeAC495271d0F;

     priceFeed = AggregatorV3Interface(
            0xEe9F2375b4bdF6387aa8265dD4FB8F16512A1d46
        );
        (
            /* uint80 roundID */,
            int price,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = priceFeed.latestRoundData();
    // uint price = 3;
       
require(idStatus[_id], "No item listed on this Id");

        Seller storage sId =  sellerId[_id];
        uint priceItem = uint(price) * sId.ItemID;
        require(tokenAmount >= priceItem, "Insufficient value entered");
        require(IERC20(TokenCa).balanceOf(msg.sender) >= priceItem, "Insuficient balance");
        IERC20(TokenCa).approve(address(this), tokenAmount);
        IERC20(TokenCa).transferFrom(msg.sender, sId.ItemOwner, tokenAmount);
        IERC721(sId.ItemContract).transferFrom(address(this), msg.sender, sId.ItemID);

        emit ItemPurchased(sId.ItemName, tokenAmount, sId.ItemContract );
      
}



}