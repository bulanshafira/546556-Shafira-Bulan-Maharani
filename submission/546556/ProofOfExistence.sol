// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ProofOfExistence {

    // Stores document hashes with the time they were notarized
    mapping(bytes32 => uint256) internal proofs;
    
    // Address of contract owner
    address public owner;

    event DocumentNotarized(bytes32 indexed documentHash, uint256 timestamp);

    // Set the deployer as owner
    constructor() {
        owner = msg.sender;
    }

    // Ensure the document has not been notarized before
    modifier notNotarized(bytes32 documentHash) {
        require(proofs[documentHash] == 0, "Document already notarized");
        _; // This runs the rest of the function after the check passes
    }

    // Store the hash of a document along with the current timestamp
    function notarizeDocument(bytes32 documentHash) external notNotarized(documentHash) {
        require(documentHash != bytes32(0), "Invalid document hash");
        proofs[documentHash] = block.timestamp;
        emit DocumentNotarized(documentHash, block.timestamp);
    }

    // Check if a document has been notarized
    function verifyDocument(bytes32 documentHash) external view returns (bool) {
        return proofs[documentHash] != 0;
    }

    // Get the timestamp when the document was notarized
    function getTimestamp(bytes32 documentHash) external view returns (uint256) {
        require(proofs[documentHash] != 0, "Document not notarized");
        return proofs[documentHash];
    }

    // Check if a document exists and return its timestamp
    function verifyAndGetTimestamp(bytes32 documentHash)
        external
        view
        returns (bool exists, uint256 timestamp)
    {
        timestamp = proofs[documentHash];
        exists = timestamp != 0;
    }
}
