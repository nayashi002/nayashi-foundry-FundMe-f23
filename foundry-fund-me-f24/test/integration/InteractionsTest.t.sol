//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test,console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe,WithdrawFundMe} from "../../script/interaction.s.sol";

contract InteractionsTest is Test{
    FundMe fundMe;
   address nayashi = makeAddr("nayashi");
   uint256 constant STARTING_BALANCE = 5 ether;
   uint256 constant BASE_GASPRICE = 1;
 function setUp() external{
    DeployFundMe deployFundMe = new DeployFundMe();
    fundMe = deployFundMe.run();
    vm.deal(nayashi,STARTING_BALANCE);

    }
    function testUserCanFundInteractions() public{
   
   FundFundMe fundFundMe = new FundFundMe();
   
   fundFundMe.fundFundMe(address(fundMe));
   WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
   withdrawFundMe.withdrawFundedMe(address(fundMe));
  assert(address(fundMe).balance == 0);

    }
}