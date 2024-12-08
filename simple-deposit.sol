// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PrivateBalanceProxy {
    mapping(bytes32 => uint256) private balances;

    event Deposit(
        address indexed sender,
        bytes32 indexed recipientHash,
        uint256 amount
    );
    event Withdrawal(address indexed recipient, uint256 amount);

    /**
     * @dev Allows a sender to deposit funds for a recipient using a hash.
     * @param recipientHash The hashed recipient identifier.
     */
    function deposit(bytes32 recipientHash) external payable {
        require(msg.value > 0, "Deposit amount must be greater than zero");

        balances[recipientHash] += msg.value;

        emit Deposit(msg.sender, recipientHash, msg.value);
    }

    /**
     * @dev Generates a hash for the recipient's address.
     * Use this function to compute the recipientHash off-chain as well.
     * @param recipient The recipient's address.
     * @return The hash of the recipient's address.
     */
    function hashAddress(address recipient) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(recipient));
    }

    /**
     * @dev Allows a recipient to withdraw their funds using their address.
     * @param recipient The address of the recipient.
     */
    function withdraw(address recipient) external {
        bytes32 recipientHash = keccak256(abi.encodePacked(recipient));
        uint256 localAmount = balances[recipientHash];

        require(localAmount > 0, "No balance to withdraw");

        balances[recipientHash] = 0;

        payable(recipient).transfer(localAmount);

        emit Withdrawal(recipient, localAmount);
    }

    /**
     * @dev Allows checking the balance associated with a recipient hash (debugging)
     * @param recipientHash The hash of the recipient.
     * @return The balance associated with the hash.
     */
    function getBalance(bytes32 recipientHash) external view returns (uint256) {
        return balances[recipientHash];
    }
}
