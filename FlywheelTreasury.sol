// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FlywheelTreasury {
    event TreasuryFunded(address indexed from, uint256 amount);
    event TreasurySpent(address indexed to, uint256 amount);

    uint256 public floor; // minimum treasury balance that must remain
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "not_owner");
        _;
    }

    constructor(uint256 _floor) {
        owner = msg.sender;
        floor = _floor;
    }

    receive() external payable {
        emit TreasuryFunded(msg.sender, msg.value);
    }

    function setFloor(uint256 _floor) external onlyOwner {
        floor = _floor;
    }

    function spend(address payable to, uint256 amount) external onlyOwner {
        uint256 bal = address(this).balance;
        require(bal >= amount, "insufficient");
        require(bal - amount >= floor, "floor_violation");
        (bool ok,) = to.call{value: amount}("");
        require(ok, "transfer_failed");
        emit TreasurySpent(to, amount);
    }

    function balance() external view returns (uint256) {
        return address(this).balance;
    }
}
