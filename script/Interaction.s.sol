// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Script ,console} from "forge-std/Script.sol";
import { DevOpsTools } from "foundry-devops/DevOpsTools.sol";
import {FundMe, FundMe__NotEnoughFund, FundMe__NotOwner} from "../src/FundMe.sol";

contract FundFundMe is Script{
    uint256 constant SEND_VALUE = 0.01 ether;
    function fundFundMe(address mostRecentlyDeployed) public{
    vm.startBroadcast();
        FundMe(payable(mostRecentlyDeployed)).fund{value : SEND_VALUE}();
    vm.stopBroadcast();
    console.log("value is funded:",SEND_VALUE);
    }
    function run() external{
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("FundMe",block.chainid);
        fundFundMe(mostRecentlyDeployed);
    }
}