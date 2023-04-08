// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Options {
    enum OptionType {LONG_CALL, LONG_PUT, SHORT_CALL, SHORT_PUT}
        
    address payable public seller;
    address payable public buyer;
    OptionType public optionType;
    uint256 public strikePrice;
    uint256 public premium;
    uint256 public expiration;
    bool public exercised;
    bool public expired;
       
    constructor(address payable _buyer, uint256 _strikePrice, uint256 _premium, uint256 _duration, OptionType _type) payable {
        seller = payable(msg.sender);
        buyer = _buyer;
        optionType = _type;
        strikePrice = _strikePrice;
        premium = _premium;
        expiration = block.timestamp + _duration;
        exercised = false;
        expired = false;
        require(msg.value == _premium, "Invalid premium");
    }
    
    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can perform this operation");
        _;
    }
    
    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only buyer can perform this operation");
        _;
    }
    
    function exercise(uint256 _price) public onlyBuyer {
        require(!expired && !exercised, "Option already expired or exercised");
        if (optionType == OptionType.LONG_CALL && _price > strikePrice) {
            buyer.transfer(address(this).balance + (_price - strikePrice)); 
            exercised = true;
        }
        if (optionType == OptionType.LONG_PUT && _price < strikePrice) {
            buyer.transfer(address(this).balance  + (strikePrice - _price)); 
            exercised = true;
        }
        if (optionType == OptionType.SHORT_CALL && _price > strikePrice) {
            seller.transfer(address(this).balance  + (_price - strikePrice)); 
            exercised = true;
        }
        if (optionType == OptionType.SHORT_PUT && _price < strikePrice) {
            seller.transfer(address(this).balance  + (strikePrice - _price)); 
            exercised = true;
        }
    }
    
    function expire() public onlySeller {
        expired = true;
    }
    
    function refund() public {
        require(expired && !exercised, "Option has not expired or has been exercised");
        if (optionType == OptionType.LONG_CALL || optionType == OptionType.LONG_PUT) {
            buyer.transfer(premium);
        }
        if (optionType == OptionType.SHORT_CALL || optionType == OptionType.SHORT_PUT) {
            seller.transfer(premium);
        }
    }
    
    function status() public view returns(bool, bool) {
        return (expired, exercised);
    }
}





