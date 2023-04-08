// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract WNFT is IERC20 {
    using SafeMath for uint256;

    string constant public name = "Wrapped NFT";
    string constant public symbol = "WNFT";
    uint8 constant public decimals = 18;

    mapping (address => uint256) private balances;
    mapping (address => mapping (address => uint256)) private allowances;
    uint256 private totalSupply_;

    event Deposit(address indexed sender, uint256 value);
    event Withdrawal(address indexed receiver, uint256 value);
    event Burn(address indexed burner, uint256 value);
    event Mint(address indexed minter, uint256 value);

    constructor() {
        totalSupply_ = 0;
    }

    function totalSupply() public view override returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner) public view override returns (uint256 balance) {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens) public override returns (bool success) {
        require(numTokens > 0, "Invalid token amount.");
        require(numTokens <= balances[msg.sender], "Insufficient balance.");
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Transfer(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool success) {
        require(delegate != address(0), "Invalid delegate address.");
        allowances[msg.sender][delegate] = numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate) public view override returns (uint256 remaining) {
        require(owner != address(0), "Invalid owner address.");
        require(delegate != address(0), "Invalid delegate address.");
        return allowances[owner][delegate];
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool success) {
        require(numTokens > 0, "Invalid token amount.");
        require(numTokens <= balances[owner], "Insufficient balance.");
        require(numTokens <= allowances[owner][msg.sender], "Insufficient allowance.");
        allowances[owner][msg.sender] = allowances[owner][msg.sender].sub(numTokens);
        balances[owner] = balances[owner].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Transfer(owner, buyer, numTokens);
        return true;
    }

    function deposit() public payable {
        require(msg.value > 0, "Invalid deposit amount.");
        balances[msg.sender] = balances[msg.sender].add(msg.value);
        totalSupply_ = totalSupply_.add(msg.value);
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) public {
        require(amount > 0, "Invalid withdrawal amount.");
        require(amount <= balances[msg.sender], "Insufficient balance.");
        require(amount <= address(this).balance, "Insufficient balance in contract.");
        balances[msg.sender] = balances[msg.sender].sub(amount);
        totalSupply_ = totalSupply_.sub(amount);
        address payable receiver = payable(msg.sender);
        receiver.transfer(amount);

        emit Withdrawal(msg.sender, amount);
    }

    function burn(uint256 amount) public {
        require(amount > 0, "Invalid token amount.");
        require(amount <= balances[msg.sender], "Insufficient balance.");
        balances[msg.sender] = balances[msg.sender].sub(amount);
        totalSupply_ = totalSupply_.sub(amount);
        emit Burn(msg.sender, amount);
    }

    function mint(uint256 amount, address recipient) public {
        require(amount > 0, "Invalid token amount.");
        require(recipient != address(0), "Invalid recipient address.");
        balances[recipient] = balances[recipient].add(amount);
        totalSupply_ = totalSupply_.add(amount);
        emit Mint(msg.sender, amount);
    }
}