// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {MockV3Aggregator} from "chainlink-brownie-contracts/contracts/src/v0.8/tests/MockV3Aggregator.sol";

contract DeployFundMe is Script {
    uint8 constant DECIMALS = 8;
    int256 constant INITIAL_PRICE = 2000e8;

    function run() external returns(FundMe){
        vm.startBroadcast();

        address priceFeedAddress;

        if (block.chainid == 31337) {
            // Local Anvil or Hardhat
            MockV3Aggregator mockFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
            priceFeedAddress = address(mockFeed);
        } else {
            // Sepolia ETH/USD
            priceFeedAddress = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
        }

        FundMe fundMe = new FundMe(priceFeedAddress);
        vm.stopBroadcast();
        return fundMe;
    }
}
