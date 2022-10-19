// Get funds from users
// withdraw funds
// set a minimum funding vulue in USD

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

import "./PriceConverter.sol";
import "hardhat/console.sol";
//954431
//934937 after use constant
// 911466 after use immutable
error FundMe__NotOwner();

//interface , library, contract

/**
 * @title A contract for crowd funding
 * @author Vasu Kushwah
 * @notice This contract is to demo a semple funding contract
 * @dev This implements price feeds as Chainlink library
 */

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 50 * 1e18; // 1e18 == 1 * 10 ** 18 == 1000000000000000000
    address[] private s_funders;
    mapping(address => uint256) private s_addressToFundedAmount;
    address private immutable i_owner;
    AggregatorV3Interface private s_priceFeed;

    modifier onlyOwner() {
        // require(msg.sender == i_owner, "Sender is not owner!");
        if (msg.sender != i_owner) revert FundMe__NotOwner();
        _;
    }

    constructor(address priceFeedAddress) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    function fund() public payable {
        // Want to be able to set a minimum fund amount in USD
        //1. How do we send ETH to this contract

        require(
            msg.value.getEthConverted(s_priceFeed) >= MINIMUM_USD,
            "Didn't Send Enough"
        );
        s_funders.push(msg.sender);
        s_addressToFundedAmount[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {
        for (uint256 fundIndex = 0; fundIndex < s_funders.length; fundIndex++) {
            s_addressToFundedAmount[s_funders[fundIndex]] = 0;
        }
        s_funders = new address[](0);

        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");

        require(success);
    }

    function chiperWithdraw() public onlyOwner {
        address[] memory funders = s_funders;
        for (uint256 fundIndex = 0; fundIndex < funders.length; fundIndex++) {
            s_addressToFundedAmount[funders[fundIndex]] = 0;
        }
        s_funders = new address[](0);

        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");

        require(success);
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getFunder(uint256 funderIndex) public view returns (address) {
        return s_funders[funderIndex];
    }

    function getAddressTOAmountFunded(address funderAddress)
        public
        view
        returns (uint256)
    {
        return s_addressToFundedAmount[funderAddress];
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }
}
