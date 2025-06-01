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
}
