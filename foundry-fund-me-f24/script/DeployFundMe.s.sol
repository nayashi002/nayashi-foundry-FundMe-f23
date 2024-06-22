//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
contract DeployFundMe is Script{
    FundMe fundme;
    HelperConfig helperConfig;
    function run() external returns (FundMe){
        //Before startBroadcast => not a "real" tx
         helperConfig = new HelperConfig();
      address ethUsdPriceFeed = helperConfig.activeNetworkConfig();
     //After startBroadcast => is a "real" tx
     vm.startBroadcast();
     fundme = new FundMe(ethUsdPriceFeed);
     vm.stopBroadcast();
     return fundme;
    }
    
}