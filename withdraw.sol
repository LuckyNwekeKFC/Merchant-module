// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Deposit {

    function safeWithdraw(uint256, address, address) external returns (bool);
    
}

//intiation of deposit contract
contract withdraw{
    Deposit deposit;
    
    constructor(address _deposit){
        //initiate deposit address
        deposit = Deposit(_deposit);
    }
    //to withdraw function, can only be call by external contract
    function makeWithdraw(uint256 amount, address _token) external returns (bool){
        //check if user can withdraw the amount
        deposit.safeWithdraw(amount, _token, msg.sender);
        return true;
    }
     
}