// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./Ownable.sol";

/**
 * @title FeeManager
 * @dev Manages platform fees for transactions
 */
abstract contract FeeManager is Ownable {
    uint256 public platformFee = 250; // 2.5% default fee
    
    event FeeUpdated(uint256 oldFee, uint256 newFee);
    
    /**
     * @dev Updates the platform fee (owner only)
     * @param _newFee New fee (multiplied by 100, e.g., 250 = 2.5%)
     */
    function updatePlatformFee(uint256 _newFee) external onlyOwner {
        require(_newFee <= 1000, "Fee cannot exceed 10%");
        uint256 oldFee = platformFee;
        platformFee = _newFee;
        emit FeeUpdated(oldFee, _newFee);
    }
    
    /**
     * @dev Calculates the fee amount for a given payment
     * @param _amount Total payment amount
     * @return Fee amount
     */
    function calculateFee(uint256 _amount) public view returns (uint256) {
        return (_amount * platformFee) / 10000;
    }
}
