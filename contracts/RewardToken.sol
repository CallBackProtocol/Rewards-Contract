// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/utils/cryptography/MessageHashUtils.sol";

contract RewardToken is ERC20, Ownable {
    using ECDSA for bytes32;
    using MessageHashUtils for bytes32;

    mapping(uint256 => uint256) public rewardPerUser;
    mapping(uint256 => mapping(address => bool)) public isClaimed;

    uint256 public chainId;

    constructor(
        string memory tokenName,
        string memory symbol,
        address owner
    ) ERC20(tokenName, symbol) Ownable(owner) {
        uint256 id;
        assembly {
            id := chainid()
        }
        chainId = id;
    }

    function createPollAndAddReward(
        uint256 pollId,
        uint256 amount
    ) public onlyOwner {
        rewardPerUser[pollId] = amount;
    }

    function claimReward(uint256 pollId, bytes memory signature) public {
        if (rewardPerUser[pollId] == 0) revert("poll not found");
        if (isClaimed[pollId][msg.sender]) revert("already claimed");

        uint256 amount = rewardPerUser[pollId];
        bytes32 msgHash = getMessageHash(msg.sender, amount);
        if (msgHash.toEthSignedMessageHash().recover(signature) != owner())
            revert("invalid signature");

        _mint(msg.sender, amount);
    }

    function getMessageHash(
        address _to,
        uint256 _amount
    ) public view returns (bytes32) {
        //expects a bytes32 value, which will be the hashed of the encode data.
        return keccak256(abi.encodePacked(_to, _amount, chainId));
    }
}
