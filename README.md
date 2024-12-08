This repository contains Solidity smart contracts designed for demonstration purposes only. They explore privacy-focused transactions by obscuring recipient details and balances. These contracts are not production-ready and are intended for educational or experimental use.

## Contracts Overview

### Private Balance Proxy (simple-deposit.sol)

A simple contract that associates EUROe balances with hashed recipient identifiers to obscure recipient details.

**Key Features**
- Recipient Privacy: Uses hashed recipient addresses (keccak256) to store balances.
- Basic Withdrawal: Recipients can claim their funds using their address.

**Core Functions**
- `deposit(bytes32 recipientHash)`: Allows EUROe to be deposited using a recipient’s hashed identifier.
- `withdraw(address recipient)`: Lets the recipient withdraw their funds.

### PrivateTransfer (simple-commit.sol)

A contract implementing a commitment-based transfer mechanism. It allows EUROe to be committed with a hash, requiring the recipient to reveal a secret (salt) to claim the funds.

**Key Features**
- Commitment Scheme: Stores EUROe transfers as hashed commitments for privacy.
- Recipient-Only Access: Only the recipient with the correct secret can withdraw funds.

**Core Functions**
- `commitTransfer(bytes32 commitmentHash)`: Allows EUROe to be committed to a hashed recipient.
- `withdraw(uint256 amount, uint256 salt)`: Enables the recipient to claim the committed funds.

**Notes**
1. These contracts are for demonstration purposes only and should not be used in production.
2. They lack critical security features like advanced validation, proper error handling, and optimized gas usage.
3. Some functions are included primarily for debugging, demonstration and testing purposes.

## How to Use

1. Commit and Deposit
- Use `hashAddress` or `calculateHash` to generate the hash for the recipient.
- Call `commitTransfer` or `deposit` with the hash and the EUROe amount.

2. Withdraw Funds
- The recipient must provide the correct inputs (e.g., salt or recipient address) to claim their balance using the withdraw function.

## Disclaimer

These contracts are not secure and are only intended for educational and experimental use. Do not deploy these contracts with real funds on any mainnet or any live network.
