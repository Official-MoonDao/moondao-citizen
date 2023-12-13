// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {MoonDAOCitizen} from '../src/MoonDAOCitizen.sol';
import {TestMooney} from '../src/TestMooney.sol';
import "lib/forge-std/src/Test.sol";
import "lib/forge-std/src/Vm.sol";

contract MoonDAOCitizenTest is Test {
    MoonDAOCitizen mdc;
    TestMooney tm;

    function setUp() public {
        tm = new TestMooney("TEST MOONEY", "MOONEY");
        mdc = new MoonDAOCitizen(address(tm), 100000000000000000000, '');
    }

    function testOwnerFunctions() public {
        vm.expectRevert();
        vm.startPrank(address(0));
        mdc.setURI("TEST URI");

        vm.expectRevert();
        mdc.setMinVotingPower(0);

        vm.expectRevert();
        mdc.setVMooneyAddress(address(0));
    }

    function testMinting() public {
        address A = address(0x0); //no mooney
        address B = address(0x0724d0eb7b6d32AEDE6F9e492a5B1436b537262b); //min amount of mooney

        tm.print(B, 100000000000000000000);
        
        vm.startPrank(A);

    // Try minting w/ no mooney acct
        vm.expectRevert();
        mdc.mint();
        vm.stopPrank();

    // Try minting w/ minimum mooney amount
        vm.startPrank(B);
        mdc.mint();
        uint256 nftBalanceB = mdc.balanceOf(B, 0);
        assert(nftBalanceB == 1);
    //Try minting again w/ minimum mooney amount
        vm.expectRevert();
        mdc.mint();
        vm.stopPrank();
    }
}
