// SPDX-License-Identifier: MIT

// 1. Deploy mocks when we are on a local anvil chain
// 2. Keep track of contract address across different chain
// Sepolia ETH/USD
// Mainnet ETH/USD
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
contract HelperConfig is Script{
  // if we are on a local anvil, we deploy mocks
  // otherwise, grap the existing address from the live contracts
  NetworkConfig public activeNetworkConfig;
  uint8 public constant DECIMAlS_NUM = 8;
  int256 public constant INITIAL_PRICE = 2000e8;
  struct NetworkConfig{
    address priceFeed;
  }
  constructor(){
    if(block.chainid == 11155111){
      activeNetworkConfig = getSepoliaEthConfig();
    }
    else if(block.chainid == 1){
     activeNetworkConfig = getEthMainnetConfig();
     
    }
    else{
      activeNetworkConfig = getorCreateAnvilEthConfig();
    }
  }
  function getSepoliaEthConfig() public pure returns (NetworkConfig memory){
    // price feed address
    NetworkConfig memory sepoliaEthConfig = NetworkConfig({
      priceFeed : 0x694AA1769357215DE4FAC081bf1f309aDC325306
    });
    return sepoliaEthConfig;

  }
  function getEthMainnetConfig() public pure returns (NetworkConfig memory){
    // price feed address
    NetworkConfig memory ethMainnetConfig = NetworkConfig({
      priceFeed : 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
    });
    return ethMainnetConfig;

  }
  function getorCreateAnvilEthConfig() public returns (NetworkConfig memory){
    if(activeNetworkConfig.priceFeed != address(0)){
      return activeNetworkConfig;
    }
    
    // price feed address
    // 1. Deploy the mocks
    // 2. Return the mock address

    vm.startBroadcast();
    MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMAlS_NUM,INITIAL_PRICE);
    vm.stopBroadcast();

   NetworkConfig memory anvilConfig = NetworkConfig({
      priceFeed : address(mockPriceFeed)
      
    });
   return anvilConfig;
  }
}
