// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ERC20 {

    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
 }


contract Swap {
    
    //create  variables
    
    ERC20 token1;
    ERC20 token2;
     
    //Thi function swaps two tokens with each other
    //*** Important ***
    //this contract needs an allowance to send tokens at token 1, and sufficient amount of token2 needs to be deposited in this contract
     function swap(uint _amount, address _token1, address _token2) public returns(bool){
            //get external tokens
            token1 = ERC20(_token1);
            token2 = ERC20(_token2);
            require(token1.balanceOf(msg.sender) >= _amount, "Insufficient amount");
            require(token2.balanceOf(address(this)) >= _amount, "Token 2 balance too low");
            
            //perform swap, first send token1 to contract
            token1.transferFrom(msg.sender, address(this), _amount);
            //using 1:1 swap rate for now
            token2.transfer(msg.sender, _amount);
            return true; 
        }

         
}