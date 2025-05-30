// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {OurToken} from "../src/OurToken.sol";

contract DeployOurToken is Script {
    uint256 constant INITIAL_SUPPLY = 1000 ether;

    function run() external {
        vm.startBroadcast();
        new OurToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
    }
}
