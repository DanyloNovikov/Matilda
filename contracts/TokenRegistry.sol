// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./Ownable.sol";
import "./interfaces/IERC20.sol";

/**
 * @title TokenRegistry
 * @dev Manages supported tokens for payments
 */
abstract contract TokenRegistry is Ownable {
    // Mapping of supported tokens
    mapping(address => bool) public supportedTokens;
    
    // USDC and USDT addresses for mainnet
    address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; // Mainnet
    address public constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7; // Mainnet
    
    event TokenStatusUpdated(address indexed token, bool supported);
    
    constructor() {
        // By default support USDC and USDT
        supportedTokens[USDC] = true;
        supportedTokens[USDT] = true;
        
        emit TokenStatusUpdated(USDC, true);
        emit TokenStatusUpdated(USDT, true);
    }
    
    /**
     * @dev Add or remove a token from the supported list
     * @param _token Token address
     * @param _supported Support status
     */
    function setTokenSupport(address _token, bool _supported) external onlyOwner {
        // Check that this is actually an ERC-20 token
        if (_supported) {
            require(isERC20(_token), "Not a valid ERC-20 token");
        }
        
        supportedTokens[_token] = _supported;
        emit TokenStatusUpdated(_token, _supported);
    }
    
    /**
     * @dev Check if a token is supported
     * @param _token Token address to check
     */
    function isTokenSupported(address _token) public view returns (bool) {
        return supportedTokens[_token];
    }
    
    /**
     * @dev Check if an address is an ERC-20 token
     * @param _token Address to check
     */
    function isERC20(address _token) internal view returns (bool) {
        // Basic check that the contract supports the ERC-20 interface
        // In production, a more reliable check can be used
        IERC20 token = IERC20(_token);
        try token.totalSupply() returns (uint256) {
            return true;
        } catch {
            return false;
        }
    }
}
