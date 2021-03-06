pragma solidity ^0.4.24;

// ----------------------------------------------------------------------------
// WhiteListed - PTS Token Sale Whitelisting Contract
//
// Copyright (c) 2018 Bitcoin Exchange Pte Ltd.
// http://www.btcex.ch/
//
// The MIT Licence.
// ----------------------------------------------------------------------------

import "./Operatable.sol";
import "./WhiteListedBasic.sol";

// ----------------------------------------------------------------------------
// The PTS Token Sale Whitelist Contract is designed to facilitate the features:
//
// 1. Track whitelisted users and allocations
// Each whitelisted user is tracked by its wallet address as well as the maximum
// PTS allocation it can purchase.
//
// 2. Track batches
// To prevent a gas war, each contributor will be assigned a batch number that
// corresponds to the time that the contributor can start purchasing.
//
// 3. Whitelist Operators
// A primary and a secondary operators can be assigned to facilitate the management
// of the whiteList.
//
// ----------------------------------------------------------------------------

contract WhiteListed is Operatable, WhiteListedBasic {

    struct Batch {
        bool isWhitelisted;
        uint weiAllocated;
        uint batchNumber;
    }

    uint public count;
    mapping (address => Batch) public batchMap;

    event Whitelisted(address indexed addr, uint whitelistedCount, bool isWhitelisted, uint indexed batch, uint weiAllocation);

    function addWhiteListed(address[] addrs, uint[] batches, uint[] weiAllocation) external canOperate {
        require(addrs.length == batches.length, "Invalid wallet address");
        require(addrs.length == weiAllocation.length, "Invalid wallet address");
        for (uint i = 0; i < addrs.length; i++) {
            Batch storage batch = batchMap[addrs[i]];
            if (batch.isWhitelisted != true) {
                batch.isWhitelisted = true;
                batch.weiAllocated = weiAllocation[i];
                batch.batchNumber = batches[i];
                count++;
                emit Whitelisted(addrs[i], count, true, batches[i], weiAllocation[i]);
            }
        }
    }

    function getAllocated(address addr) public view returns (uint) {
        return batchMap[addr].weiAllocated;
    }

    function getBatchNumber(address addr) public view returns (uint) {
        return batchMap[addr].batchNumber;
    }

    function getWhiteListCount() public view returns (uint) {
        return count;
    }

    function isWhiteListed(address addr) public view returns (bool) {
        return batchMap[addr].isWhitelisted;
    }

    function removeWhiteListed(address addr) public canOperate {
        Batch storage batch = batchMap[addr];
        require(batch.isWhitelisted == true, "Whitelisted doesn't contain this wallet"); 
        batch.isWhitelisted = false;
        count--;
        emit Whitelisted(addr, count, false, batch.batchNumber, batch.weiAllocated);
    }

    function setAllocation(address[] addrs, uint[] weiAllocation) public canOperate {
        require(addrs.length == weiAllocation.length, "Invalid wallet address");
        for (uint i = 0; i < addrs.length; i++) {
            if (batchMap[addrs[i]].isWhitelisted == true) {
                batchMap[addrs[i]].weiAllocated = weiAllocation[i];
            }
        }
    }

    function setBatchNumber(address[] addrs, uint[] batch) public canOperate {
        require(addrs.length == batch.length, "Invalid wallet address");
        for (uint i = 0; i < addrs.length; i++) {
            if (batchMap[addrs[i]].isWhitelisted == true) {
                batchMap[addrs[i]].batchNumber = batch[i];
            }
        }
    }
}