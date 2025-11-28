// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

/**
 * @title DocumentRegistry
 * @notice Smart contract for registering and querying document hashes with metadata
 * @dev Allows users to register document hashes with owner, timestamp, and optional signature.
 *      Prevents duplicate registrations and provides efficient querying capabilities.
 */
contract DocumentRegistry {
    /**
     * @notice Document structure storing all information about a registered document
     * @param hash The hash of the document (bytes32)
     * @param owner The address that registered the document
     * @param timestamp The timestamp when the document was registered
     * @param signature Optional signature string associated with the document
     */
    struct Document {
        bytes32 hash;
        address owner;
        uint256 timestamp;
        string signature;
    }

    /**
     * @notice Mapping from document hash to Document struct
     */
    mapping(bytes32 => Document) private documents;

    /**
     * @notice Mapping to track if a document hash has been registered
     */
    mapping(bytes32 => bool) private documentExists;

    /**
     * @notice Emitted when a document is stored in the registry
     * @param hash The hash of the document
     * @param owner The address that registered the document
     * @param timestamp The timestamp when the document was registered
     */
    event DocumentStored(bytes32 indexed hash, address indexed owner, uint256 timestamp);

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
     * @notice Custom error thrown when arrays in batch operation have mismatched lengths
     * @param hashesLength Length of the hashes array
     * @param signaturesLength Length of the signatures array
     */
    error ArrayLengthMismatch(uint256 hashesLength, uint256 signaturesLength);

    /**
     * @notice Stores a document hash with its metadata
     * @param hash The hash of the document to register
     * @param signature Optional signature string associated with the document
     * @dev Reverts if the document hash already exists (DocumentAlreadyExists)
     *      Follows checks-effects-interactions pattern
     */
    function storeDocument(bytes32 hash, string calldata signature) external {
        // Check: Verify document doesn't already exist
        if (documentExists[hash]) {
            revert DocumentAlreadyExists(hash);
        }

        // Effects: Update state before any external calls
        documents[hash] = Document({
            hash: hash,
            owner: msg.sender,
            timestamp: block.timestamp,
            signature: signature
        });
        documentExists[hash] = true;

        // Interactions: Emit event
        emit DocumentStored(hash, msg.sender, block.timestamp);
    }

    /**
     * @notice Retrieves all information about a stored document
     * @param hash The hash of the document to query
     * @return document The Document struct containing all information
     * @dev Reverts if the document doesn't exist (DocumentNotFound)
     */
    function getDocumentInfo(bytes32 hash) external view returns (Document memory document) {
        // Check: Verify document exists
        if (!documentExists[hash]) {
            revert DocumentNotFound(hash);
        }

        return documents[hash];
    }

    /**
     * @notice Retrieves the signature of a stored document
     * @param hash The hash of the document to query
     * @return signature The signature string associated with the document
     * @dev Reverts if the document doesn't exist (DocumentNotFound)
     */
    function getDocumentSignature(bytes32 hash) external view returns (string memory signature) {
        // Check: Verify document exists
        if (!documentExists[hash]) {
            revert DocumentNotFound(hash);
        }

        return documents[hash].signature;
    }

    /**
     * @notice Stores multiple documents in a single transaction
     * @param hashes Array of document hashes to register
     * @param signatures Array of signature strings corresponding to each hash
     * @dev Reverts if arrays have different lengths (ArrayLengthMismatch)
     *      Reverts if any document hash already exists (DocumentAlreadyExists)
     *      Follows checks-effects-interactions pattern
     */
    function storeMultiple(
        bytes32[] calldata hashes,
        string[] calldata signatures
    ) external {
        // Check: Verify arrays have the same length
        if (hashes.length != signatures.length) {
            revert ArrayLengthMismatch(hashes.length, signatures.length);
        }

        // Check: Verify none of the documents already exist
        for (uint256 i = 0; i < hashes.length; ) {
            if (documentExists[hashes[i]]) {
                revert DocumentAlreadyExists(hashes[i]);
            }
            unchecked {
                ++i;
            }
        }

        // Effects: Update state for all documents
        uint256 currentTimestamp = block.timestamp;
        for (uint256 i = 0; i < hashes.length; ) {
            documents[hashes[i]] = Document({
                hash: hashes[i],
                owner: msg.sender,
                timestamp: currentTimestamp,
                signature: signatures[i]
            });
            documentExists[hashes[i]] = true;

            // Interactions: Emit event for each document
            emit DocumentStored(hashes[i], msg.sender, currentTimestamp);

            unchecked {
                ++i;
            }
        }
    }

    /**
     * @notice Checks if a document hash exists in the registry
     * @param hash The hash to check
     * @return exists True if the document exists, false otherwise
     */
    function isDocumentStored(bytes32 hash) external view returns (bool exists) {
        return documentExists[hash];
    }
}

