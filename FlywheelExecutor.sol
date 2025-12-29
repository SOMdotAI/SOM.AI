// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interfaces/IFlywheelExecutor.sol";

contract FlywheelExecutor is IFlywheelExecutor {
    address public owner;
    address public route; // placeholder for an AMM/router

    modifier onlyOwner() {
        require(msg.sender == owner, "not_owner");
        _;
    }

    constructor(address _route) {
        owner = msg.sender;
        route = _route;
    }

    function setRoute(address _route) external onlyOwner {
        route = _route;
    }

    // NOTE: Stub. Integrate router swap here for the target chain.
    function executeBuyback(uint256 amountIn, uint256 minOut) external override returns (uint256 amountOut) {
        // In a real implementation:
        // 1) pull funds from treasury (or hold funds here)
        // 2) call router with minOut protection
        // 3) emit BuybackExecuted with route used
        amountOut = amountIn; // placeholder (no swap)
        require(amountOut >= minOut, "min_out");
        emit BuybackExecuted(msg.sender, amountIn, amountOut, route);
        return amountOut;
    }
}
