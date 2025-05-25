// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title Ownable
 * @dev Basic module for access control based on contract ownership
 */
abstract contract Ownable {
    address payable public owner;
    
    event OwnershipTransferred(
      address indexed previousOwner,
      address indexed newOwner
    );
    
    constructor() {
        owner = payable(msg.sender);
    }
    
    /**
     * @dev Modifier to restrict function access to the owner
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Ownable: caller is not the owner");

        _;
    }
    
    /**
     * @dev Transfers ownership to a new address
     * @param newOwner Address of the new owner
     */
    function transferOwnership(address payable newOwner) external virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}
