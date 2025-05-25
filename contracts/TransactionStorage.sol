// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title TransactionStorage
 * @dev Manages storage and retrieval of transaction data
 */
abstract contract TransactionStorage {
    struct Transaction {
        address payable seller;
        address buyer;
        uint256 amount;
        string orderId;
        uint256 timestamp;
        bool completed;
        address tokenAddress;
    }
    
    // Transactions storage
    mapping(string => Transaction) public transactions;
    
    event PaymentProcessed(
        string orderId, 
        address indexed seller, 
        address indexed buyer, 
        uint256 amount,
        address tokenAddress,
        uint256 timestamp
    );
    
    /**
     * @dev Checks if an order has been paid
     * @param _orderId ID of the Shopify order
     * @return bool Payment status
     */
    function isOrderPaid(string memory _orderId) external view returns (bool) {
        return transactions[_orderId].completed;
    }
    
    /**
     * @dev Gets transaction information
     * @param _orderId ID of the Shopify order
     */
    function getTransaction(string memory _orderId) external view returns (
        address seller,
        address buyer,
        uint256 amount,
        address tokenAddress,
        uint256 timestamp,
        bool completed
    ) {
        Transaction memory txn = transactions[_orderId];
        return (
            txn.seller,
            txn.buyer,
            txn.amount,
            txn.tokenAddress,
            txn.timestamp,
            txn.completed
        );
    }
    
    /**
     * @dev Records a completed transaction
     * @param _orderId Order identifier
     * @param _seller Seller address
     * @param _buyer Buyer address
     * @param _amount Transaction amount
     * @param _tokenAddress Address of the token used for payment
     */
    function _recordTransaction(
        string memory _orderId,
        address payable _seller,
        address _buyer,
        uint256 _amount,
        address _tokenAddress
    ) internal {
        transactions[_orderId] = Transaction({
            seller: _seller,
            buyer: _buyer,
            amount: _amount,
            orderId: _orderId,
            timestamp: block.timestamp,
            completed: true,
            tokenAddress: _tokenAddress
        });
        
        emit PaymentProcessed(_orderId, _seller, _buyer, _amount, _tokenAddress, block.timestamp);
    }
}
