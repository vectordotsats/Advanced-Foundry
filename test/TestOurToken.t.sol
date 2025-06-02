// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

contract TestOurToken is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public startingBalance = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(bob, startingBalance);
    }

    function testTotoalSupplyAssignedToDeployer() public view {
        uint256 totalSupply = ourToken.totalSupply();
        uint256 deployerBalance = ourToken.balanceOf(msg.sender);
        assertEq(deployerBalance, totalSupply - startingBalance);
    }

    function testBobBalance() public view {
        uint256 bobBalance = ourToken.balanceOf(bob);
        assertEq(bobBalance, startingBalance);
    }

    function testAllowanceWorks() public {
        uint256 allowanceAmount = 1000;
        uint256 removedBalance = 200;
        uint256 exceededAllowance = 1100;

        vm.prank(bob);
        ourToken.approve(alice, allowanceAmount);

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, removedBalance);

        assertEq(ourToken.balanceOf(bob), startingBalance - removedBalance);
        assertEq(ourToken.balanceOf(alice), removedBalance);
        assertEq(
            ourToken.allowance(bob, alice),
            allowanceAmount - removedBalance
        );

        vm.prank(alice);
        vm.expectRevert();
        ourToken.transferFrom(bob, alice, exceededAllowance);
    }

    function testTransferBetweenAccounts() public {
        uint256 amount = 10 ether;

        vm.prank(bob);
        ourToken.transfer(alice, amount);

        assertEq(ourToken.balanceOf(bob), startingBalance - amount);
        assertEq(ourToken.balanceOf(alice), amount);
    }

    function testTransferInsufficientBalanceReverts() public {
        vm.prank(alice);
        vm.expectRevert();
        ourToken.transfer(bob, 1 ether); // alice has 0
    }

    function testTransferToZeroAddressReverts() public {
        vm.prank(bob);
        vm.expectRevert();
        ourToken.transfer(address(0), 1 ether);
    }

    function testTransferFromWithoutApprovalReverts() public {
        vm.prank(alice);
        vm.expectRevert();
        ourToken.transferFrom(bob, alice, 1 ether);
    }

    function testMetadata() public view {
        assertEq(ourToken.name(), "Our Token");
        assertEq(ourToken.symbol(), "OT");
        assertEq(ourToken.decimals(), 18);
    }
}
