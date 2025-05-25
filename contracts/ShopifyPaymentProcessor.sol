// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./Ownable.sol";
import "./FeeManager.sol";
import "./ShopRegistry.sol";
import "./TransactionStorage.sol";
import "./TokenRegistry.sol";

import "./interfaces/IERC20.sol";

/**
 * @title ShopifyPaymentProcessor
 * @dev Contract for secure payment transfer from buyer to seller with Shopify
 */
contract ShopifyPaymentProcessor is Ownable, FeeManager, ShopRegistry, TransactionStorage, TokenRegistry {
    
    /**
     * @dev Processes payment in ERC-20 tokens for a Shopify order
     * @param _shopId ID of the Shopify store
     * @param _orderId ID of the Shopify order
     * @param _tokenAddress Address of the ERC-20 token
     * @param _amount Amount of tokens to pay
     */
    function processTokenPayment(
        string memory _shopId, 
        string memory _orderId, 
        address _tokenAddress, 
        uint256 _amount
    ) external {
        // Validations
        require(_amount > 0, "Payment amount must be greater than zero");
        require(isShopRegistered(_shopId), "Shop not registered");
        require(transactions[_orderId].timestamp == 0, "Order already processed");
        require(isTokenSupported(_tokenAddress), "Token not supported");
        
        // Get the seller's address
        address payable seller = shopToSeller[_shopId];
        
        // Get token reference
        IERC20 token = IERC20(_tokenAddress);
        
        // Check that the buyer has approved the transfer
        require(
            token.allowance(msg.sender, address(this)) >= _amount, 
            "Insufficient token allowance"
        );
        
        // Calculate fee
        uint256 fee = calculateFee(_amount);
        uint256 sellerAmount = _amount - fee;
        
        // Record the transaction
        _recordTransaction(_orderId, seller, msg.sender, _amount, _tokenAddress);
        
        // Transfer tokens from buyer to seller and platform owner
        require(
            token.transferFrom(msg.sender, seller, sellerAmount),
            "Transfer to seller failed"
        );
        
        require(
            token.transferFrom(msg.sender, owner, fee),
            "Transfer of fee failed"
        );
    }
    
    /**
     * @dev Processes payment in ETH for backward compatibility
     * @param _shopId ID of the Shopify store
     * @param _orderId ID of the Shopify order
     */
    function processPayment(
        string memory _shopId,
        string memory _orderId
    ) external payable {
        require(msg.value > 0, "Payment amount must be greater than zero");
        require(isShopRegistered(_shopId), "Shop not registered");
        require(transactions[_orderId].timestamp == 0, "Order already processed");
        
        address payable seller = shopToSeller[_shopId];
        
        // Calculate fee
        uint256 fee = calculateFee(msg.value);
        uint256 sellerAmount = msg.value - fee;
        
        // Record the transaction (use address(0) for ETH)
        _recordTransaction(_orderId, seller, msg.sender, msg.value, address(0));
        
        // Send funds to seller
        seller.transfer(sellerAmount);
        
        // Send fee to platform owner
        owner.transfer(fee);
    }
}
