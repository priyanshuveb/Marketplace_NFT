// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
import '@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol';


contract MToken is ERC20 {

    uint totalTokens = 20000;
    //uint decimal = 18;

    constructor() ERC20('MToken', 'MTK'){
        _mint(msg.sender,totalTokens*1e18);
    }

}