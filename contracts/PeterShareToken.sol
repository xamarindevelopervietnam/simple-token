pragma solidity ^0.4.24;

// ----------------------------------------------------------------------------
// PeterShareToken - ERC20 Token
//
// Copyright (c) 2018 Bitcoin Exchange Pte Ltd.
// http://www.btcex.ch/
//
// The MIT Licence.
// ----------------------------------------------------------------------------

import "./zeppelin-solidity/contracts/token/ERC20/PausableToken.sol";
import "./zeppelin-solidity/contracts/math/SafeMath.sol";
import "./zeppelin-solidity/contracts/token/ERC20/BurnableToken.sol";
import "./PeterShareTokenConfig.sol";
import "./Salvageable.sol";

// ----------------------------------------------------------------------------
// The PTS token is an ERC20 token that:
// 1. Token is paused by default and is only allowed to be unpaused once the
//    Vesting contract is activated.
// 2. Tokens are created on demand up to TOTALSUPPLY or until minting is
//    disabled.
// 3. Token can airdropped to a group of recipients as long as the contract
//    has sufficient balance.
// ----------------------------------------------------------------------------

contract PeterShareToken is BurnableToken, PausableToken, PeterShareTokenConfig, Salvageable {
    using SafeMath for uint;

    string public name = NAME;
    string public symbol = SYMBOL;
    uint8 public decimals = DECIMALS;
    bool public mintingFinished = false;

    event Mint(address indexed to, uint amount);
    event MintFinished();

    modifier canMint() {
        require(!mintingFinished, "Minting finished");
        _;
    }

    constructor() public {
        paused = true;
    }

    function pause() public onlyOwner {
        revert("Can't revert");
    }

    function unpause() public onlyOwner {
        super.unpause();
    }

    function mint(address _to, uint _amount) public onlyOwner canMint returns (bool) {
        require(totalSupply_.add(_amount) <= TOTALSUPPLY, "Amount can't larger than Total Supply");
        totalSupply_ = totalSupply_.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        emit Mint(_to, _amount);
        emit Transfer(address(0), _to, _amount);
        return true;
    }

    function finishMinting() public onlyOwner canMint returns (bool) {
        mintingFinished = true;
        emit MintFinished();
        return true;
    }

    // Airdrop tokens from bounty wallet to contributors as long as there are enough balance
    function airdrop(address bountyWallet, address[] dests, uint[] values) public onlyOwner returns (uint) {
        require(dests.length == values.length, "Invalid wallets address");
        uint i = 0;
        while (i < dests.length && balances[bountyWallet] >= values[i]) {
            this.transferFrom(bountyWallet, dests[i], values[i]);
            i += 1;
        }
        return(i);
    }

    //burnable token
    function burn(uint256 _value) public whenNotPaused {
        super.burn(_value);
    }
}