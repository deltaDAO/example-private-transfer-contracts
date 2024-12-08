// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PrivateTransfer {
    mapping(bytes32 => uint256) private commitments;

    event Commit(address indexed sender, bytes32 indexed commitmentHash); // for demonstration purposes
    event Withdraw(address indexed recipient, uint256 amount); // for demonstration purposes

    /**
     * @dev Commit EUROe for a recipient using a hashed commitment.
     * @param commitmentHash The hash representing the recipient, amount, and salt.
     */
    function commitTransfer(bytes32 commitmentHash) external payable {
        require(msg.value > 0, "Must send some EUROe");
        require(commitments[commitmentHash] == 0, "Commitment already exists");

        commitments[commitmentHash] = msg.value;

        emit Commit(msg.sender, commitmentHash);
    }

    /**
     * @dev Withdraw EUROe using the provided amount and salt.
     * @param amount The amount of EUROe to withdraw.
     * @param salt The salt used to generate the commitment hash.
     */
    function withdraw(uint256 amount, uint256 salt) external {
        bytes32 hash = keccak256(abi.encodePacked(msg.sender, amount, salt));

        uint256 committedAmount = commitments[hash];
        require(committedAmount > 0, "Invalid commitment or already withdrawn");
        require(committedAmount == amount, "Amount mismatch");

        commitments[hash] = 0;

        payable(msg.sender).transfer(amount);

        emit Withdraw(msg.sender, amount);
    }

    /**
     * @dev Check the EUROe balance associated with a commitment hash (for debugging).
     * @param commitmentHash The hash of the commitment.
     * @return The amount of EUROe associated with the hash.
     */
    function checkCommitment(
        bytes32 commitmentHash
    ) external view returns (uint256) {
        return commitments[commitmentHash];
    }

    /**
     * @dev Utility function to calculate a commitment hash.
     * @param to The recipient's address.
     * @param amount The amount to commit.
     * @param salt The unique salt for the commitment.
     * @return The calculated commitment hash.
     */
    function calculateHash(
        address to,
        uint256 amount,
        uint256 salt
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(to, amount, salt));
    }
}
