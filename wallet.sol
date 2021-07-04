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

contract MyToken{
    string public constant name = "MyToken";
    string public constant symbol = "MT";
    uint8 public constant decimals = 2;
    
    uint public totalSupply;
    
    mapping (address => uint) balances;
    
    mapping (address => mapping(address => uint)) allowed;
    
    function mint(address _to, uint _value) public{
        require(totalSupply + _value >= totalSupply && balances[_to] + _value >= balances[_to]);
        balances[_to] += _value;
        totalSupply += _value;
    }
    
    function balanceOf(address _owner) public view returns(uint){
        return balances[_owner];
    }
    
    function allowance(address _owner, address _spender) public view returns(uint){
        return allowed[_owner][_spender];
    }
    
    function transfer(address _to, uint _value) public{
        require(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
    }
    
    function transferFrom(address _from, address _to, uint _value) public payable{
        require(balances[_from] >= _value && balances[_to] + _value >= balances[_to] && allowed[_from][msg.sender] >= _value);
        balances[_from] -= _value;
        balances[_to] += _value;
        allowed[_from][msg.sender] -= _value;
    }
    
    
    function approve(address _spender, uint _value) public {
        allowed[msg.sender][_spender] = _value;
    }
}

contract Wallet is owned, MyToken{
    
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
        require(_comission < 100);
        comission = _comission;
    }
}
