// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ETF {
    string public name;
    mapping(address => uint) public balances;
    mapping(address => mapping(address => uint)) public allowance;

    uint public totalSupply;
    uint public netAssetValue;
    uint public decimals;
    uint public minimumDeposit = 10 ether;
    uint public unitPrice = 1 ether;

    address public issuer;

    mapping(address => bool) public authorizedInvestors;

    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);
    event Deposit(address indexed depositor, uint value);
    event Redeem(address indexed redeemer, uint value);

    constructor(string memory _name) {
        name = _name;
        issuer = msg.sender;
        authorizedInvestors[msg.sender] = true;
        decimals = 18;
    }

    modifier onlyIssuer() {
        require(msg.sender == issuer, "Only the issuer is authorized to perform this action.");
        _;
    }

    modifier onlyAuthorizedInvestor() {
        require(authorizedInvestors[msg.sender] == true, "Only authorized investors can perform this action.");
        _;
    }

    modifier isMinimumDeposit() {
        require(msg.value >= minimumDeposit, "Deposit amount is less than the minimum deposit amount.");
        _;
    }

    function deposit() external payable onlyAuthorizedInvestor isMinimumDeposit {
        balances[msg.sender] += msg.value;
        totalSupply += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function redeem(uint _amount) external onlyAuthorizedInvestor {
        require(_amount <= balances[msg.sender], "Not enough balance to perform this operation.");
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
        totalSupply -= _amount;
        emit Redeem(msg.sender, _amount);
    }

    function getNav() private view returns (uint) {
        // 计算 ETF 基金净值
        // netAssetValue = ...
        return netAssetValue;
    }

    function minimumInvestment() public view returns (uint) {
        return minimumDeposit / unitPrice;
    }

    function authorizeInvestor(address _investor) external onlyIssuer {
        authorizedInvestors[_investor] = true;
    }

    function revokeInvestor(address _investor) external onlyIssuer {
        authorizedInvestors[_investor] = false;
    }

    function approve(address _spender, uint _amount) external onlyAuthorizedInvestor returns (bool) {
        allowance[msg.sender][_spender] = _amount;
        emit Approval(msg.sender, _spender, _amount);
        return true;
    }

    function transfer(address _recipient, uint _amount) external onlyAuthorizedInvestor returns (bool) {
        require(_amount <= balances[msg.sender], "Sender does not have enough balance to perform this operation.");
        require(_recipient != address(0), "Cannot transfer to the zero address.");
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(msg.sender, _recipient, _amount);
        return true;
    }

    function transferFrom(address _sender, address _recipient, uint _amount) external onlyAuthorizedInvestor returns (bool) {
        require(_sender != address(0), "Cannot transfer from the zero address.");
        require(_recipient != address(0), "Cannot transfer to the zero address.");
        require(_amount <= balances[_sender], "Not enough balance to perform this operation.");
        require(_amount <= allowance[_sender][msg.sender], "Not enough allowance for this operation.");
        balances[_sender] -= _amount;
        balances[_recipient] += _amount;
        allowance[_sender][msg.sender] -= _amount;
        emit Transfer(_sender, _recipient, _amount);
        return true;
    }

    function purchase() external payable onlyAuthorizedInvestor {
        require(msg.value >= unitPrice * minimumInvestment(), "Investment amount is less than the minimum investment amount.");
        uint investmentAmount = msg.value / unitPrice;
        uint nav = getNav();
        uint sharesToIssue = investmentAmount * 10**decimals / nav;
        balances[msg.sender] += sharesToIssue;
        totalSupply += sharesToIssue;
        emit Transfer(address(this), msg.sender, sharesToIssue);
    }

    function sell(uint _shares) external onlyAuthorizedInvestor {
        require(_shares <= balances[msg.sender], "Not enough balance to perform this operation.");
        uint nav = getNav();
        uint redemptionAmount = _shares * nav / 10**decimals;
        balances[msg.sender] -= _shares;
        totalSupply -= _shares;
        payable(msg.sender).transfer(redemptionAmount);
        emit Transfer(msg.sender, address(this), _shares);
    }

    function setUnitPrice(uint _unitPrice) external onlyIssuer {
        unitPrice = _unitPrice;
    }

    function setMinimumDeposit(uint _minimumDeposit) external onlyIssuer {
        minimumDeposit = _minimumDeposit;
    }

    function setNAV(uint _nav) external onlyIssuer {
        netAssetValue = _nav;
    }

    function setIssuer(address _issuer) external onlyIssuer {
        issuer = _issuer;
    }
}