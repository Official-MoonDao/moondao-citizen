/*
    NAME: MoonDAO Citizen
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MoonDAOCitizen is ERC1155, Ownable {
    string public name = "MoonDAO Citizen";
    uint256 public minVotingPower = 0;

    address public vMooneyAddress; //polygon

    bool internal locked; //re-entry lock

    constructor(address _vMooneyAddress, uint256 _minVotingPower, string memory _uri) ERC1155("MoonDAO Citizen") {
        setURI(_uri);
        setVMooneyAddress(_vMooneyAddress);
        setMinVotingPower(_minVotingPower);
    }

    //MODIFIERS
    modifier reEntrancyGuard(){ 
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }

    //FUNCTIONS
    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function setVMooneyAddress(address _vMooneyAddress) public onlyOwner {
        vMooneyAddress = _vMooneyAddress;
    }

    function setMinVotingPower(address _minVotingPower) public onlyOwner {
        minVotingPower = _minVotingPower;
    }

    function mint() public reEntrancyGuard {
        (bool success, bytes memory result) = vMooneyAddress.call(abi.encodeWithSignature("balanceOf(address)", msg.sender));
        require(abi.decode(result, (uint256)) >= minVotingPower, "Wallet doesn't have enough vMooney");
        require(this.balanceOf(msg.sender,0) < 1, "Wallet already owns an NFT");
        _mint(msg.sender, 0, 1, "");
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public override {
         if(from != address(0x0)) revert("Cannot transfer citizenship");
        super.safeTransferFrom(from, to, id, amount, data);
    }
}
    