// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract SushiBar {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;

    struct Staking {
        uint256 amount;
        uint256 stakedAt;
    }

    mapping(address => Staking) public stakings;

    IERC20 public sushiToken;
    uint256 public constant TIME_LOCK = 2 days;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);

    constructor(address _sushiToken) {
        sushiToken = IERC20(_sushiToken);
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(stakings[msg.sender].amount == 0, "Already staked");

        stakings[msg.sender] = Staking(amount, block.timestamp);

        sushiToken.safeTransferFrom(msg.sender, address(this), amount);

        emit Staked(msg.sender, amount);
    }

    function unstake() external {
        require(stakings[msg.sender].amount > 0, "No staking found");

        uint256 amount = stakings[msg.sender].amount;
        uint256 stakedAt = stakings[msg.sender].stakedAt;
        uint256 stakingDuration = block.timestamp.sub(stakedAt);
        uint256 unstakeAmount = calculateUnstakeAmount(amount, stakingDuration);

        delete stakings[msg.sender];

        sushiToken.safeTransfer(msg.sender, unstakeAmount);

        emit Unstaked(msg.sender, unstakeAmount);
    }

    function calculateUnstakeAmount(uint256 amount, uint256 stakingDuration) internal pure returns (uint256) {
        if (stakingDuration < TIME_LOCK) {
            return 0;
        } else if (stakingDuration < TIME_LOCK.mul(2)) {
            return amount.mul(25).div(100);
        } else if (stakingDuration < TIME_LOCK.mul(3)) {
            return amount.mul(50).div(100);
        } else if (stakingDuration < TIME_LOCK.mul(4)) {
            return amount.mul(75).div(100);
        } else {
            return amount;
        }
    }
}
