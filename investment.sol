// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InvestmentPlatform{
    struct User{
        bool isRegistered;
        string passwordHash;
        string userName;
        string email;
        uint256 balance;
        bool isLoggedIn;
    }
    mapping (address => User) public users;

    modifier onlyRegistered(){
        require(users[msg.sender].isRegistered, "user not registered");
        _;
    }

    modifier onlyLoggedIn(){
        require(users[msg.sender].isLoggedIn, "user not logged in");
        _;
    }

    //sign up function
    function signUp(string memory _passwordHash, string memory _userName, string memory _email) external {
        require(!
        users[msg.sender].isRegistered, "User already registered");
           users[msg.sender] = User({
            isRegistered: true,
            passwordHash: _passwordHash,
            userName: _userName,
            email: _email, 
            balance: 0,
            isLoggedIn: false
           });
    }
    //loging function
    function loging(string memory _passwordHash, string memory _userName)external onlyRegistered{
        require (keccak256(abi.encodePacked(_passwordHash))==
        keccak256(abi.encodePacked(users[msg.sender].passwordHash)),"Invalid password");

        require (keccak256(abi.encodePacked(_userName))==
        keccak256(abi.encodePacked(users[msg.sender].userName)),"Invalid username");
        
       
        require(!users[msg.sender].isLoggedIn, "Already logged in");
        users[msg.sender].isLoggedIn = true;
    }
    //logout function
    function logout() external  onlyRegistered onlyLoggedIn{
        users[msg.sender].isLoggedIn = false;
    }
    // Invest function
    function invest() external payable onlyRegistered onlyLoggedIn {
        require(msg.value >0, "investment amount must be greater than 0");
        users[msg.sender].balance += msg.value;
    }
    //withdraw function
    function withdraw (uint256 _amount) external onlyRegistered onlyLoggedIn{
        require(_amount > 0, "withdrawal amount must be greater than 0");
        require(users[msg.sender].balance >= _amount, "Insufficient balance");
        users[msg.sender].balance -= _amount;

        (bool success, )= msg.sender.call{value: _amount}("");
        require(success, "withdrawal failed");
    }
    // check balance function
    function checkBalance() external view onlyRegistered onlyLoggedIn returns (uint256){
        return users[msg.sender].balance;
    }
    //function to get contract balance (for admin or debugging purposes)
    function getContractBalance()external view returns(uint256){
        return address(this).balance;
    }

}