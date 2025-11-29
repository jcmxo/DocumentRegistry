// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title DocumentRegistry
 * @notice Smart contract for registering and verifying document hashes with ECDSA signatures
 * @dev Optimized for gas efficiency by using signer != address(0) to check existence
 *      Implements ECDSA signature verification for document authenticity
 */
contract DocumentRegistry {
    /**
     * @notice Document structure storing all information about a registered document
     * @param hash The hash of the document (bytes32)
     * @param timestamp The timestamp when the document was registered
     * @param signer The address that signed the document
     * @param signature The ECDSA signature (bytes) of the document hash
     */
    struct Document {
        bytes32 hash;
        uint256 timestamp;
        address signer;
        bytes signature;
    }

    /**
     * @notice Mapping from document hash to Document struct
     * @dev Using signer != address(0) to check existence (optimization)
     */
    mapping(bytes32 => Document) private documents;

    /**
     * @notice Array to store all document hashes for iteration
     * @dev Used for getDocumentCount() and getDocumentHashByIndex()
     */
    bytes32[] private documentHashes;

    /**
     * @notice Emitted when a document is stored in the registry
     * @param hash The hash of the document
     * @param signer The address that signed the document
     * @param timestamp The timestamp when the document was registered
     */
    event DocumentStored(bytes32 indexed hash, address indexed signer, uint256 timestamp);

    /**
     * @notice Custom error thrown when attempting to register a document that already exists
     * @param hash The hash that already exists
     */
    error DocumentAlreadyExists(bytes32 hash);

    /**
     * @notice Custom error thrown when attempting to query a document that doesn't exist
     * @param hash The hash that doesn't exist
     */
    error DocumentNotFound(bytes32 hash);

    /**
     * @notice Modifier to ensure document does not already exist
     * @param _hash The hash to check
     */
    modifier documentNotExists(bytes32 _hash) {
        require(documents[_hash].signer == address(0), "Document already exists");
        _;
    }

    /**
     * @notice Modifier to ensure document exists
     * @param _hash The hash to check
     */
    modifier documentExists(bytes32 _hash) {
        require(documents[_hash].signer != address(0), "Document does not exist");
        _;
    }

    /**
     * @notice Stores a document hash with its metadata
     * @param _hash The hash of the document to register
     * @param _timestamp The timestamp when the document was signed
     * @param _signature The ECDSA signature (bytes) of the document hash
     * @param _signer The address that signed the document
     * @dev Reverts if the document hash already exists (DocumentAlreadyExists)
     *      Follows checks-effects-interactions pattern
     */
    function storeDocumentHash(
        bytes32 _hash,
        uint256 _timestamp,
        bytes memory _signature,
        address _signer
    ) external documentNotExists(_hash) {
        // Effects: Update state before any external calls
        documents[_hash] = Document({
            hash: _hash,
            timestamp: _timestamp,
            signer: _signer,
            signature: _signature
        });
        documentHashes.push(_hash);

        // Interactions: Emit event
        emit DocumentStored(_hash, _signer, _timestamp);
    }

    /**
     * @notice Verifies a document signature using ECDSA recovery
     * @param _hash The hash of the document to verify
     * @param _signer The address that should have signed the document
     * @param _signature The signature to verify
     * @return isValid True if the signature is valid, false otherwise
     * @dev Uses ecrecover to verify ECDSA signature
     */
    function verifyDocument(
        bytes32 _hash,
        address _signer,
        bytes memory _signature
    ) external view returns (bool isValid) {
        // Check if document exists
        if (documents[_hash].signer == address(0)) {
            return false;
        }

        // Recover the signer from the signature
        bytes32 messageHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash));
        bytes32 r;
        bytes32 s;
        uint8 v;

        // Extract r, s, v from signature (65 bytes: 32 + 32 + 1)
        if (_signature.length != 65) {
            return false;
        }

        assembly {
            r := mload(add(_signature, 32))
            s := mload(add(_signature, 64))
            v := byte(0, mload(add(_signature, 96)))
        }

        // Handle v values (27 or 28)
        if (v < 27) {
            v += 27;
        }

        // Recover the signer address
        address recoveredSigner = ecrecover(messageHash, v, r, s);

        // Verify the recovered signer matches the expected signer and stored signer
        return (recoveredSigner == _signer && recoveredSigner == documents[_hash].signer && recoveredSigner != address(0));
    }

    /**
     * @notice Retrieves all information about a stored document
     * @param _hash The hash of the document to query
     * @return document The Document struct containing all information
     * @dev Reverts if the document doesn't exist (DocumentNotFound)
     */
    function getDocumentInfo(bytes32 _hash) external view documentExists(_hash) returns (Document memory document) {
        return documents[_hash];
    }

    /**
     * @notice Checks if a document hash exists in the registry
     * @param _hash The hash to check
     * @return exists True if the document exists, false otherwise
     * @dev Uses signer != address(0) for gas-efficient existence check
     */
    function isDocumentStored(bytes32 _hash) external view returns (bool exists) {
        return documents[_hash].signer != address(0);
    }

    /**
     * @notice Returns the total number of documents stored
     * @return count The number of documents in the registry
     */
    function getDocumentCount() external view returns (uint256 count) {
        return documentHashes.length;
    }

    /**
     * @notice Returns the document hash at a specific index
     * @param _index The index of the document (0-based)
     * @return hash The document hash at the specified index
     * @dev Reverts if index is out of bounds
     */
    function getDocumentHashByIndex(uint256 _index) external view returns (bytes32 hash) {
        require(_index < documentHashes.length, "Index out of bounds");
        return documentHashes[_index];
    }
}
