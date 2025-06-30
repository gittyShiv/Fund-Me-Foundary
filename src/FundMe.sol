// Get funds fro user
// Withdraw funds
// Set a min fund value in USD // 885504 ->835921->748019 optimisation steps
// optimisations change variable to (const and immutaable),error authorize with if statment,

// SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConvertor} from "./PriceConvertor.sol";

error FundMe__NotOwner ();
error FundMe__UnableToWithdrawl();
error FundMe__NotEnoughFund();

/**
 * @title A crowd funding contract
 * @author Shivam Maurya
 * @notice Funding contract
 * @dev implements price fee as our library
 */
contract FundMe{
    // important
    using PriceConvertor for uint256;// must define

    mapping(address=>uint256) public s_addressToAmountFunded;
    address[] public s_funders;
    AggregatorV3Interface public s_priceFeed;
    address public immutable i_owner;
    uint256 public constant MINIMUM_USD = 50 * 1e18;

    modifier onlyOwner{
        if(msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    constructor(address priceFeedAddress){
        i_owner = msg.sender; // whoever deploy this contract will become owner
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    receive() external payable { 
        fund();
    }
    // fallback
    fallback() external payable {
        fund();
     }

    function getPriceFeedAddress() public view returns (address) {
    return address(s_priceFeed);
    }
    
    function fund() public payable{
        // Want to be able to set a minimum fund amount
        //1.How do we send ETH to this contract
        // if require dont work it will revert and prior changes will not happen like number = 5; will still be zero
        // require(getConversionRate(msg.value) >= minimumUsd,"Didn't send,Not enough ETH"); // ethereum in wei
        // require(msg.value.getConversionRate() >= MINIMUM_USD,"Didn't send,Not enough ETH");
        if(msg.value.getConversionRate(s_priceFeed) < MINIMUM_USD) revert FundMe__NotEnoughFund();
        if (s_addressToAmountFunded[msg.sender] == 0) {
            s_funders.push(msg.sender);
        }
            s_addressToAmountFunded[msg.sender] += msg.value;

    }
   
   
    function withdraw() public onlyOwner{
        address[] memory funders = s_funders; // gas optimisation
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
           address funder =  funders[funderIndex];
           s_addressToAmountFunded[funder] = 0;
        }
        // reset
        s_funders = new address[](0);
        // actually withdraw the funds
        //transfer
        // payable(msg.sender).transfer(address(this).balance);
        //send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess,"send failed");
        //call
        // (bool callSuccess,) = payable(msg.sender).call{value:address(this).balance}("");
        // require(callSuccess, "Call failed");
        (bool callSuccess,) = i_owner.call{value:address(this).balance}("");//i-owmer
        if(!callSuccess) revert FundMe__UnableToWithdrawl();

    }
}
