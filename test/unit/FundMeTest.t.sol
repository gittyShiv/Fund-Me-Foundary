// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {PriceConvertor} from "../../src/PriceConvertor.sol";
import {FundMe, FundMe__NotEnoughFund, FundMe__NotOwner} from "../../src/FundMe.sol";
import {MockV3Aggregator} from "chainlink-brownie-contracts/contracts/src/v0.8/tests/MockV3Aggregator.sol";
uint256  constant GAS_TOLERANCE = 1e16;

contract FundMeTest is Test {
    receive() external payable {} 
    FundMe public fundMe;
    MockV3Aggregator public mockFeed;
    address public owner;
    address public user = address(1);// random user

    uint8 constant DECIMALS = 8;
    int256 constant INITIAL_PRICE = 2000e8; // $2000 with 8 decimals
    uint256 public constant SEND_VALUE = 1 ether;
    uint256 public constant STARTING_BALANCE = 10 ether;

    function setUp() public {
        owner = address(this);

        mockFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        fundMe = new FundMe(address(mockFeed));

        vm.deal(owner, STARTING_BALANCE);
        vm.deal(user, STARTING_BALANCE);
    }

    function testConstructorSetsPriceFeed () view public {
        assertEq(fundMe.getPriceFeedAddress(), address(mockFeed));
    }

function testFundRevertsIfNotEnoughEth() public {
    vm.expectRevert(FundMe__NotEnoughFund.selector);
    fundMe.fund{value: 0}();
}

    function testFundUpdatesDataStructures() public {
        fundMe.fund{value: SEND_VALUE}();
        assertEq(fundMe.s_addressToAmountFunded(owner), SEND_VALUE);
    }

    function testFundRecordsFunderOnce() public {
        fundMe.fund{value: SEND_VALUE}();
        assertEq(fundMe.s_funders(0), owner);
    }

    function testOnlyOwnerCanWithdraw() public {
        vm.prank(user);
        vm.expectRevert(FundMe__NotOwner.selector);
        fundMe.withdraw();
    }

    function testWithdrawWorksForSingleFunder() public {
        fundMe.fund{value: SEND_VALUE}();
        uint256 startOwnerBal = owner.balance;
        uint256 contractBal = address(fundMe).balance;

        uint256 startGas = gasleft();
        fundMe.withdraw();
        uint256 gasUsed = startGas - gasleft();
        uint256 gasPrice = tx.gasprice;
        uint256 gasCost = gasUsed * gasPrice;

        assertEq(address(fundMe).balance, 0);
        assertEq(owner.balance, startOwnerBal + contractBal - gasCost);
    }

    function testWithdrawWithMultipleFunders() public {
        address funder1 = address(11);
        address funder2 = address(12);
        vm.deal(funder1, 1 ether);
        vm.deal(funder2, 1 ether);

        vm.prank(funder1);
        fundMe.fund{value: 0.5 ether}();

        vm.prank(funder2);
        fundMe.fund{value: 0.5 ether}();

        fundMe.fund{value: 1 ether}(); //owner is sending

        uint256 startOwnerBal = owner.balance;
        uint256 contractBal = address(fundMe).balance;

        uint256 startGas = gasleft();
        fundMe.withdraw();
        uint256 gasUsed = startGas - gasleft();
        uint256 gasPrice = tx.gasprice;
        uint256 gasCost = gasUsed * gasPrice;

        assertEq(address(fundMe).balance, 0);
        assertEq(owner.balance, startOwnerBal + contractBal - gasCost);
        assertEq(fundMe.s_addressToAmountFunded(funder1), 0);
        assertEq(fundMe.s_addressToAmountFunded(funder2), 0);
        assertEq(fundMe.s_addressToAmountFunded(owner), 0);
    }
}
