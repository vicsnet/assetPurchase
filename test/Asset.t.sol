// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Asset.sol";
import "./MockTest/NFTtest.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

interface Usdc {
    function balanceOf(address) external view returns (uint256);
    function approve(address, uint) external returns(uint256);
}

contract AssetPurchase is Test {
    Asset asset;
    Usdc usdc;
    NFT nft;
    address vince = vm.addr(0x1);

    address usdcHolder = 0x25B313158Ce11080524DcA0fD01141EeD5f94b81;

    // console.log(a);
    function setUp() public {

        asset = new Asset();

         vm.startPrank(vince);
        nft = new NFT();
        // nft.approve(asset, 1);
        vm.stopPrank();
    }

    function testListItem() public {
        // vm.startPrank(vince);

        vm.startPrank(vince);
        nft.approve(address(asset), 1);

        asset.listItemForSale("car", 1, address(nft), 2);
        vm.stopPrank();

       uint b = Usdc(0x6B175474E89094C44Da98b954EedeAC495271d0F).balanceOf(usdcHolder);
       console.log(b);
    }

function testBuyItemListed() public{
    testListItem();
    vm.deal(usdcHolder, 10 ether);
    vm.startPrank(usdcHolder);
    IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F).approve(address(asset), 104818599306613964396638610 );
    asset.buyItemListed(1, 104818599306613964396638610);
}
}
