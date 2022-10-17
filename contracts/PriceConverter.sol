// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed)
        internal
        view
        returns (uint256)
    {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        uint8 decimals = getDecimals(priceFeed);
        return uint256(price) * ((1 * 10)**(18 - decimals)); // 1e10 == 1 * 10 ** 10 == 10000000000
    }

    function getDecimals(AggregatorV3Interface priceFeed)
        internal
        view
        returns (uint8)
    {
        return priceFeed.decimals();
    }

    function getEthConverted(uint256 ethAmount, AggregatorV3Interface priceFeed)
        internal
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethInUsd = (ethAmount * ethPrice) / 1e18;
        return ethInUsd;
    }
}
