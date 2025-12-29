// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IFlywheelExecutor {
    event BuybackExecuted(address indexed caller, uint256 amountIn, uint256 amountOut, address route);

    function executeBuyback(uint256 amountIn, uint256 minOut) external returns (uint256 amountOut);
}
