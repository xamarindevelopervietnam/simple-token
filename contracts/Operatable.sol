pragma solidity ^0.4.24;

// ----------------------------------------------------------------------------
// Operatable - Base contract which allows primary and secondary operator 
// to be enabled for child contract. 
//
// Copyright (c) 2018 Bitcoin Exchange Pte Ltd.
// http://www.btcex.ch/
//
// The MIT Licence.
// ----------------------------------------------------------------------------

import "./zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "./zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./OperatableBasic.sol";

contract Operatable is Ownable, OperatableBasic {
    address public primaryOperator;
    address public secondaryOperator;

    modifier canOperate() {
        require(msg.sender == primaryOperator || msg.sender == secondaryOperator || msg.sender == owner, "Conditions are missed");
        _;
    }
    
    constructor() public {
        primaryOperator = owner;
        secondaryOperator = owner;
    }

    function setPrimaryOperator (address addr) public onlyOwner {
        primaryOperator = addr;
    }

    function setSecondaryOperator (address addr) public onlyOwner {
        secondaryOperator = addr;
    }

    function isPrimaryOperator(address addr) public view returns (bool) {
        return (addr == primaryOperator);
    }

    function isSecondaryOperator(address addr) public view returns (bool) {
        return (addr == secondaryOperator);
    }
}