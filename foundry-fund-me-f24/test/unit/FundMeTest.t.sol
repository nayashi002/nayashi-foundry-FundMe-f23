//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test{
   FundMe fundMe;
   DeployFundMe deployFundMe;
   address owner;
   address nayashi = makeAddr("nayashi");
   uint256 constant STARTING_BALANCE = 5 ether;
   uint256 constant BASE_GASPRICE = 1;
   function setUp() external {
    //fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    deployFundMe = new DeployFundMe();
    fundMe = deployFundMe.run();
    vm.deal(nayashi,STARTING_BALANCE);
    owner = address(this);
   }
   function testMinimumDollarisFive() public view {
    assertEq(fundMe.MINIMUM_USD(),5e18);
   }
   function testOwnerisMessanger() public view{
    
    assertEq(fundMe.getOwner(), msg.sender);
   }
   function testPriceFeedVersionIsAccurate() public view{
   uint256 version = fundMe.getVersion();
    assertEq(version, 4);
   }
   function testisSufficientAmount() public{
    vm.expectRevert();
    fundMe.fund();
  
    
   }
   function testFundUpdatesDataStructure() public{
    vm.prank(nayashi);
       fundMe.fund{value:STARTING_BALANCE}();
       uint256 amountFunded = fundMe.getAddressToAmountFunded(nayashi);
      assertEq(amountFunded, STARTING_BALANCE);
   }
   function testFunderUpdatesToArrayofFunders() public {
    vm.prank(nayashi);
    fundMe.fund{value:STARTING_BALANCE}();
    address _funder = fundMe.getFunder(0);
    assertEq(_funder, nayashi);
   }
   modifier funded() {
        vm.prank(nayashi);
       fundMe.fund{value:STARTING_BALANCE}();
       _;
   }

   function testOnlyOwnerCanWithdraw() public funded{
      vm.prank(nayashi);
      vm.expectRevert();
      fundMe.withdraw();
   }
     function testWithdrawalwithASingleOwner() public funded{
   // Arrange
  uint256 startingOwnerbalance = fundMe.getOwner().balance;
  uint256 startingFundMeBalance = address(fundMe).balance;

// Act
   vm.prank(fundMe.getOwner());
   fundMe.withdraw();
   // Assert
   uint256 endingOwnerBalance = fundMe.getOwner().balance;
   uint256 endingFundMeBalance = address(fundMe).balance;
   assertEq(endingFundMeBalance, 0);
   assertEq(startingFundMeBalance + startingOwnerbalance, endingOwnerBalance);
  }
  function testWithMultipleFundersCheaperWithdraw() public funded{
      //Arrange
   uint160 startingFunders = 1;
   uint160 numberOfFunders = 10;
   for(uint160 i = startingFunders; i < numberOfFunders; i++){
        
        hoax(address(i),STARTING_BALANCE);
        fundMe.fund{value:STARTING_BALANCE}();
   }
   //ACT
   uint256 startingOwnerbalance = fundMe.getOwner().balance;
  uint256 startingFundMeBalance = address(fundMe).balance;
  vm.startPrank(fundMe.getOwner());
fundMe.cheaperWithdraw();
vm.stopPrank();
//Assert
assert(address(fundMe).balance == 0);
assert(startingFundMeBalance + startingOwnerbalance == fundMe.getOwner().balance);
   
  }
  function testWithMultipleFunders() public funded{
   //Arrange
   uint160 startingFunders = 1;
   uint160 numberOfFunders = 10;
   for(uint160 i = startingFunders; i < numberOfFunders; i++){
        
        hoax(address(i),STARTING_BALANCE);
        fundMe.fund{value:STARTING_BALANCE}();
   }
   //ACT
   uint256 startingOwnerbalance = fundMe.getOwner().balance;
  uint256 startingFundMeBalance = address(fundMe).balance;
  vm.startPrank(fundMe.getOwner());
fundMe.withdraw();
vm.stopPrank();
//Assert
assert(address(fundMe).balance == 0);
assert(startingFundMeBalance + startingOwnerbalance == fundMe.getOwner().balance);
   
  }
function testLengthOfFundersFunding() public funded{
  vm.startPrank(fundMe.getOwner());
  fundMe.withdraw();
  vm.stopPrank();
  uint256 fundersLength = fundMe.getFundersLength();
assertEq(fundersLength, 0);
}
   //What can we do to work with addresses outside our system
   // 1. Unit
   //  -Testing a specific part of our code
   // 2. Integration
   //  - Testing how our code works with other parts of our code
   // 3. Forked
   //  _Testing our code on a simulated real enviroment
   // 4. Staging
   //  -Testing our code in a real enviroment that is not prodl
  
  
  // function checkValue() public payable{
  //  assertEq(fundMe.MINIMUM_USD(), msg.value.getConversionRate());
  // }
}

