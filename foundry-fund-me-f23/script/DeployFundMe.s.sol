// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HeloperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        // Before startBroadcast --> Not a real tx --> no gas consumption
        HeloperConfig heloperConfig = new HeloperConfig();
        address ethUsdPriceFeed = heloperConfig.activeNetworkConfig();
        vm.startBroadcast();
        // Before startBroadcast --> real tx!
        FundMe fundMe = new FundMe(ethUsdPriceFeed);
        vm.stopBroadcast();
        return fundMe;
    }
}
