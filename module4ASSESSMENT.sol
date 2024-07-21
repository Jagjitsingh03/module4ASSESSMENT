/*
//Building on Avalanche - ETH + AVAX

Your task is to create a ERC20 token and deploy it on the Avalanche network for Degen Gaming. 
The smart contract should have the following functionality:

Minting new tokens: The platform should be able to create new tokens and distribute them to players as rewards. Only the owner can mint tokens.
Transferring tokens: Players should be able to transfer their tokens to others.
Redeeming tokens: Players should be able to redeem their tokens for items in the in-game store.
Checking token balance: Players should be able to check their token balance at any time.
Burning tokens: Anyone should be able to burn tokens, that they own, that are no longer needed.
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    // Mapping of item names to their cost in tokens
    mapping(string => uint256) public itemCosts;

    // Event declarations
    // Emitted when tokens are redeemed
    event TokensRedeemed(address indexed player, string itemName, uint256 cost);
    event TokensBurned(address indexed burner, uint256 amount);
    event ItemAdded(string itemName, uint256 cost);
    event ItemRemoved(string itemName);

    constructor(address initialOwner) ERC20("Degen Token", "DEGEN") Ownable(initialOwner) {
        // Mint initial supply to the owner
        _mint(initialOwner, 1000000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burnTokens(uint256 amount) external {
        require(amount > 0, "Amount must be greater than zero");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");

        _burn(msg.sender, amount);
        emit TokensBurned(msg.sender, amount);
    }

    // Add an item with its cost
    function addItem(string calldata itemName, uint256 cost) external onlyOwner {
        require(cost > 0, "Cost must be greater than zero");
        itemCosts[itemName] = cost;
        emit ItemAdded(itemName, cost);
    }

    // Remove an item
    function removeItem(string calldata itemName) external onlyOwner {
        require(itemCosts[itemName] > 0, "Item does not exist");
        delete itemCosts[itemName];
        emit ItemRemoved(itemName);
    }

    // Redeem tokens for an item
    function redeemTokens(string calldata itemName) external {
        uint256 cost = itemCosts[itemName];
        require(cost > 0, "Item does not exist");
        require(balanceOf(msg.sender) >= cost, "Insufficient balance");

        _burn(msg.sender, cost);
        //Emits an event logging the redemption of tokens for the item.
        emit TokensRedeemed(msg.sender, itemName, cost);
    }
}
