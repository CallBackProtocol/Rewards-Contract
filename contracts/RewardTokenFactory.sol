// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./RewardToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RewardTokenFactory is Ownable {
    event RewardTokenDeployed(
        address indexed tokenContract,
        string name,
        string symbol
    );

    constructor() Ownable(msg.sender) {}

    function deployRewardToken(
        string memory name,
        string memory symbol
    ) public onlyOwner {
        RewardToken token = new RewardToken(name, symbol, msg.sender);
        emit RewardTokenDeployed(address(token), name, symbol);
    }
}
