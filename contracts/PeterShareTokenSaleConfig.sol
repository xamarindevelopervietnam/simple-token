pragma solidity ^0.4.24;

// ----------------------------------------------------------------------------
// PeterShareTokenSaleConfig - PTS Token Sale Configuration
//
// Copyright (c) 2018 Bitcoin Exchange Pte Ltd.
// http://www.btcex.ch/
//
// The MIT Licence.
// ----------------------------------------------------------------------------

import "./PeterShareTokenConfig.sol";

contract PeterShareTokenSaleConfig is PeterShareTokenConfig 
{
    uint public constant TOKEN_FOUNDINGTEAM =  50000000 * DECIMALSFACTOR;
    uint public constant TOKEN_EARLYSUPPORTERS = 100000000 * DECIMALSFACTOR;
    uint public constant TOKEN_PRESALE = 100000000 * DECIMALSFACTOR;
    uint public constant TOKEN_TREASURY = 150000000 * DECIMALSFACTOR;
    uint public constant MILLION = 1000000;
    uint public constant PUBLICSALE_USD_PER_MSENC =  80000;
    uint public constant PRIVATESALE_USD_PER_MSENC =  64000;
    uint public constant MIN_CONTRIBUTION      = 120 finney;
}