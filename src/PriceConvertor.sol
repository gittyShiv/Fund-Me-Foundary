// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
library PriceConvertor{

    function getPrice(AggregatorV3Interface priceFeed)
     internal view returns (uint256){
        (,int256 price,,,) = priceFeed.latestRoundData();
        return uint256(price* 1e10) ;
    }

    function getConversionRate(uint256 _ethAmount,AggregatorV3Interface priceFeed) 
    internal view returns(uint256){
        return (getPrice(priceFeed)*(_ethAmount)) / 1e18;
    }
   
}