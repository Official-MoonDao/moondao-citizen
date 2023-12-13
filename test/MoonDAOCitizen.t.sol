// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import {MoonDAOCitizen} from 'src/MoonDAO_Citizen.sol';
import {TestMooney} from 'src/TestMooney.sol';
import "lib/forge-std/src/Test.sol";
import "lib/forge-std/src/Vm.sol";

contract MoonDAOCitizenTest is Test {
    MoonDAOCitizen mdc;
    TestMooney tm;

    function setUp() public {
        tm = new TestMooney("TEST MOONEY", "MOONEY");
        mdc = new MoonDAOCitizen();
        console.log(tm);
    }
}
