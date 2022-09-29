// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ERC20 {
    
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
}

//intiation of deposit contract
contract deposit{
    ERC20 token;
    address owner;
    mapping(address => mapping(address => uint256)) data;
    mapping(address => bool) contracts; //to register contracts that can call safe withdraw

    constructor(){
        owner = msg.sender;
    }

    //to accept deposit
    function makeDeposit(address _token, uint256 _amount) public returns(bool){
        //check if user has enough tokens to deposit
        token = ERC20(_token);
        require(token.balanceOf(msg.sender) >= _amount, "Insufficient amount of tokens");
        //make deposit, this only works if user has given contract approval to move tokens
        token.transferFrom(msg.sender, address(this), _amount);
        //save amount deposited
        data[msg.sender][_token] = data[msg.sender][_token] + _amount;
        return true;
    }

    //to withdraw function, can only be call by external contract
    function safeWithdraw(uint256 amount, address _token, address _to) external returns (bool){
        require(contracts[msg.sender] == true, "Not allowed to make this withdraw");
        //check if user can withdraw the amount
        require(data[_to][_token] >= amount, "Insufficient amount of tokens");
        token = ERC20(_token);
        token.transfer(_to, amount);
        //subract amount
        data[_to][_token] = data[_to][_token] - amount;
        return true;
    }

    //function to register contracts that can make withdrawal
    function register(address _address) external returns(bool){
        isOwner();
        contracts[_address] = true;
        return true;
    }
    //to return amount deposited
    function getDeposit(address _token) public view returns(uint256 amount){
        amount = data[msg.sender][_token];
        return amount;
    }
    function isOwner() public {
       require(msg.sender == owner, "Caller is not owner");
    }
    function changeOwner(address newOwner) public  {
         isOwner();
        owner = newOwner;
    }
}