// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./Ownable.sol";

/**
 * @title ShopRegistry
 * @dev Manages shop and seller registrations
 */
abstract contract ShopRegistry is Ownable {
    // Mapping of shop IDs to seller addresses
    mapping(string => address payable) public shopToSeller;
    
    event ShopRegistered(string shopId, address seller);
    
    /**
     * @dev Registers a Shopify store with a seller's address
     * @param _shopId ID of the Shopify store
     * @param _seller Ethereum address of the seller
     */
    function registerShop(string memory _shopId, address payable _seller) external onlyOwner {
        require(_seller != address(0), "Invalid seller address");
        shopToSeller[_shopId] = _seller;
        emit ShopRegistered(_shopId, _seller);
    }
    
    /**
     * @dev Returns the seller address for a shop
     * @param _shopId ID of the Shopify store
     */
    function getSellerAddress(string memory _shopId) external view returns (address) {
        return shopToSeller[_shopId];
    }
    
    /**
     * @dev Checks if a shop is registered
     * @param _shopId ID of the Shopify store
     */
    function isShopRegistered(string memory _shopId) public view returns (bool) {
        return shopToSeller[_shopId] != address(0);
    }
}
