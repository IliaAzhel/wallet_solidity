pragma solidity ^0.5.12;

contract owned{
    
    address payable owner;
    address payable candidate;
    

    constructor() public payable{
        owner = msg.sender;
    }
    
    modifier onlyOwner {
        require(
            msg.sender == owner,
            "Only owner can call this function."
        );
        _;
    }
    
    function changeOwner(address payable _owner) onlyOwner public{
        candidate = _owner;
    }
    
    function confirmOwner() public{
        require(candidate == msg.sender);
        owner = candidate;
    }
}

contract Wallet is owned{
    
    uint public comission = 50;
    address payable comissionAddress = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    
    function sendEther(address payable _addr) onlyOwner public payable{
        uint percent = 100;
        _addr.transfer(msg.value/percent * (percent - comission));
        comissionAddress.transfer(comission * msg.value/percent );
    }
    
    function getEther() public payable{
        uint percent = 100;
        owner.transfer((percent - comission) * msg.value/percent);
        comissionAddress.transfer(comission * msg.value/percent);
    }
    
    function changeComission(uint _comission) onlyOwner public{
        comission = _comission;
        assert(_comission < 100);
    }
}
