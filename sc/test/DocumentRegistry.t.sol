// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {Test} from "forge-std/Test.sol";
import {DocumentRegistry} from "../src/DocumentRegistry.sol";

/**
 * @title DocumentRegistryTest
 * @notice Comprehensive test suite for DocumentRegistry contract
 * @dev Tests cover all functions, edge cases, and fuzz testing
 */
contract DocumentRegistryTest is Test {
    DocumentRegistry public registry;
    address public owner;
    address public user1;
    address public user2;

    bytes32 public constant TEST_HASH_1 = keccak256("document-1");
    bytes32 public constant TEST_HASH_2 = keccak256("document-2");
    bytes32 public constant TEST_HASH_3 = keccak256("document-3");
    string public constant TEST_SIGNATURE_1 = "signature-1";
    string public constant TEST_SIGNATURE_2 = "signature-2";
    string public constant EMPTY_SIGNATURE = "";

    event DocumentStored(bytes32 indexed hash, address indexed owner, uint256 timestamp);

    function setUp() public {
        registry = new DocumentRegistry();
        owner = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
    }

    // ============ Tests for storeDocument ============

    /**
     * @notice Test storing a single document successfully
     */
    function test_StoreDocument_Success() public {
        vm.expectEmit(true, true, false, false);
        emit DocumentStored(TEST_HASH_1, owner, block.timestamp);

        registry.storeDocument(TEST_HASH_1, TEST_SIGNATURE_1);

        // Verify document exists
        assertTrue(registry.isDocumentStored(TEST_HASH_1));

        // Verify document info
        DocumentRegistry.Document memory doc = registry.getDocumentInfo(TEST_HASH_1);
        assertEq(doc.hash, TEST_HASH_1);
        assertEq(doc.owner, owner);
        assertEq(doc.timestamp, block.timestamp);
        assertEq(doc.signature, TEST_SIGNATURE_1);
    }

    /**
     * @notice Test storing a document with empty signature
     */
    function test_StoreDocument_WithEmptySignature() public {
        registry.storeDocument(TEST_HASH_1, EMPTY_SIGNATURE);

        DocumentRegistry.Document memory doc = registry.getDocumentInfo(TEST_HASH_1);
        assertEq(doc.signature, EMPTY_SIGNATURE);
    }

    /**
     * @notice Test that storing the same document twice reverts
     */
    function test_StoreDocument_RevertIfAlreadyExists() public {
        registry.storeDocument(TEST_HASH_1, TEST_SIGNATURE_1);

        vm.expectRevert(
            abi.encodeWithSelector(
                DocumentRegistry.DocumentAlreadyExists.selector,
                TEST_HASH_1
            )
        );
        registry.storeDocument(TEST_HASH_1, TEST_SIGNATURE_2);
    }

    /**
     * @notice Test that different users can store different documents
     */
    function test_StoreDocument_DifferentUsers() public {
        vm.prank(user1);
        registry.storeDocument(TEST_HASH_1, TEST_SIGNATURE_1);

        vm.prank(user2);
        registry.storeDocument(TEST_HASH_2, TEST_SIGNATURE_2);

        DocumentRegistry.Document memory doc1 = registry.getDocumentInfo(TEST_HASH_1);
        DocumentRegistry.Document memory doc2 = registry.getDocumentInfo(TEST_HASH_2);

        assertEq(doc1.owner, user1);
        assertEq(doc2.owner, user2);
    }

    // ============ Tests for getDocumentInfo ============

    /**
     * @notice Test retrieving document information successfully
     */
    function test_GetDocumentInfo_Success() public {
        registry.storeDocument(TEST_HASH_1, TEST_SIGNATURE_1);

        DocumentRegistry.Document memory doc = registry.getDocumentInfo(TEST_HASH_1);

        assertEq(doc.hash, TEST_HASH_1);
        assertEq(doc.owner, owner);
        assertEq(doc.timestamp, block.timestamp);
        assertEq(doc.signature, TEST_SIGNATURE_1);
    }

    /**
     * @notice Test that querying non-existent document reverts
     */
    function test_GetDocumentInfo_RevertIfNotFound() public {
        vm.expectRevert(
            abi.encodeWithSelector(
                DocumentRegistry.DocumentNotFound.selector,
                TEST_HASH_1
            )
        );
        registry.getDocumentInfo(TEST_HASH_1);
    }

    // ============ Tests for getDocumentSignature ============

    /**
     * @notice Test retrieving document signature successfully
     */
    function test_GetDocumentSignature_Success() public {
        registry.storeDocument(TEST_HASH_1, TEST_SIGNATURE_1);

        string memory signature = registry.getDocumentSignature(TEST_HASH_1);
        assertEq(signature, TEST_SIGNATURE_1);
    }

    /**
     * @notice Test that querying signature of non-existent document reverts
     */
    function test_GetDocumentSignature_RevertIfNotFound() public {
        vm.expectRevert(
            abi.encodeWithSelector(
                DocumentRegistry.DocumentNotFound.selector,
                TEST_HASH_1
            )
        );
        registry.getDocumentSignature(TEST_HASH_1);
    }

    // ============ Tests for storeMultiple ============

    /**
     * @notice Test storing multiple documents successfully
     */
    function test_StoreMultiple_Success() public {
        bytes32[] memory hashes = new bytes32[](3);
        hashes[0] = TEST_HASH_1;
        hashes[1] = TEST_HASH_2;
        hashes[2] = TEST_HASH_3;

        string[] memory signatures = new string[](3);
        signatures[0] = TEST_SIGNATURE_1;
        signatures[1] = TEST_SIGNATURE_2;
        signatures[2] = EMPTY_SIGNATURE;

        registry.storeMultiple(hashes, signatures);

        // Verify all documents exist
        assertTrue(registry.isDocumentStored(TEST_HASH_1));
        assertTrue(registry.isDocumentStored(TEST_HASH_2));
        assertTrue(registry.isDocumentStored(TEST_HASH_3));

        // Verify document info
        DocumentRegistry.Document memory doc1 = registry.getDocumentInfo(TEST_HASH_1);
        DocumentRegistry.Document memory doc2 = registry.getDocumentInfo(TEST_HASH_2);
        DocumentRegistry.Document memory doc3 = registry.getDocumentInfo(TEST_HASH_3);

        assertEq(doc1.owner, owner);
        assertEq(doc2.owner, owner);
        assertEq(doc3.owner, owner);
        assertEq(doc1.signature, TEST_SIGNATURE_1);
        assertEq(doc2.signature, TEST_SIGNATURE_2);
        assertEq(doc3.signature, EMPTY_SIGNATURE);
    }

    /**
     * @notice Test that storeMultiple reverts if arrays have different lengths
     */
    function test_StoreMultiple_RevertIfArrayLengthMismatch() public {
        bytes32[] memory hashes = new bytes32[](2);
        hashes[0] = TEST_HASH_1;
        hashes[1] = TEST_HASH_2;

        string[] memory signatures = new string[](3);
        signatures[0] = TEST_SIGNATURE_1;
        signatures[1] = TEST_SIGNATURE_2;
        signatures[2] = TEST_SIGNATURE_1;

        vm.expectRevert(
            abi.encodeWithSelector(
                DocumentRegistry.ArrayLengthMismatch.selector,
                2,
                3
            )
        );
        registry.storeMultiple(hashes, signatures);
    }

    /**
     * @notice Test that storeMultiple reverts if any hash already exists
     */
    function test_StoreMultiple_RevertIfAnyHashExists() public {
        // Store first document
        registry.storeDocument(TEST_HASH_1, TEST_SIGNATURE_1);

        // Try to store multiple including the existing one
        bytes32[] memory hashes = new bytes32[](2);
        hashes[0] = TEST_HASH_1;
        hashes[1] = TEST_HASH_2;

        string[] memory signatures = new string[](2);
        signatures[0] = TEST_SIGNATURE_2;
        signatures[1] = TEST_SIGNATURE_2;

        vm.expectRevert(
            abi.encodeWithSelector(
                DocumentRegistry.DocumentAlreadyExists.selector,
                TEST_HASH_1
            )
        );
        registry.storeMultiple(hashes, signatures);
    }

    /**
     * @notice Test storing empty arrays
     */
    function test_StoreMultiple_EmptyArrays() public {
        bytes32[] memory hashes = new bytes32[](0);
        string[] memory signatures = new string[](0);

        // Should not revert, just do nothing
        registry.storeMultiple(hashes, signatures);
    }

    // ============ Tests for isDocumentStored ============

    /**
     * @notice Test isDocumentStored returns true for stored document
     */
    function test_IsDocumentStored_ReturnsTrue() public {
        registry.storeDocument(TEST_HASH_1, TEST_SIGNATURE_1);
        assertTrue(registry.isDocumentStored(TEST_HASH_1));
    }

    /**
     * @notice Test isDocumentStored returns false for non-existent document
     */
    function test_IsDocumentStored_ReturnsFalse() public {
        assertFalse(registry.isDocumentStored(TEST_HASH_1));
    }

    // ============ Fuzz Tests ============

    /**
     * @notice Fuzz test: Store and retrieve document with random hash
     * @param hash Random document hash
     * @param signature Random signature string
     */
    function testFuzz_StoreAndRetrieveDocument(
        bytes32 hash,
        string calldata signature
    ) public {
        // Skip if hash already exists (unlikely but possible)
        vm.assume(!registry.isDocumentStored(hash));

        registry.storeDocument(hash, signature);

        assertTrue(registry.isDocumentStored(hash));

        DocumentRegistry.Document memory doc = registry.getDocumentInfo(hash);
        assertEq(doc.hash, hash);
        assertEq(doc.owner, owner);
        assertEq(doc.signature, signature);
    }

    /**
     * @notice Fuzz test: Cannot store same hash twice
     * @param hash Random document hash
     * @param signature1 First signature
     * @param signature2 Second signature
     */
    function testFuzz_CannotStoreSameHashTwice(
        bytes32 hash,
        string calldata signature1,
        string calldata signature2
    ) public {
        vm.assume(!registry.isDocumentStored(hash));

        registry.storeDocument(hash, signature1);

        vm.expectRevert(
            abi.encodeWithSelector(
                DocumentRegistry.DocumentAlreadyExists.selector,
                hash
            )
        );
        registry.storeDocument(hash, signature2);
    }

    /**
     * @notice Fuzz test: GetDocumentInfo reverts for non-existent hash
     * @param hash Random document hash
     */
    function testFuzz_GetDocumentInfo_RevertIfNotFound(bytes32 hash) public {
        vm.assume(!registry.isDocumentStored(hash));

        vm.expectRevert(
            abi.encodeWithSelector(
                DocumentRegistry.DocumentNotFound.selector,
                hash
            )
        );
        registry.getDocumentInfo(hash);
    }

    /**
     * @notice Fuzz test: GetDocumentSignature reverts for non-existent hash
     * @param hash Random document hash
     */
    function testFuzz_GetDocumentSignature_RevertIfNotFound(bytes32 hash) public {
        vm.assume(!registry.isDocumentStored(hash));

        vm.expectRevert(
            abi.encodeWithSelector(
                DocumentRegistry.DocumentNotFound.selector,
                hash
            )
        );
        registry.getDocumentSignature(hash);
    }

    /**
     * @notice Fuzz test: StoreMultiple with random arrays (limited size)
     * @param hash1 First hash
     * @param hash2 Second hash
     * @param hash3 Third hash
     * @param signature1 First signature
     * @param signature2 Second signature
     * @param signature3 Third signature
     */
    function testFuzz_StoreMultiple_RandomArrays(
        bytes32 hash1,
        bytes32 hash2,
        bytes32 hash3,
        string calldata signature1,
        string calldata signature2,
        string calldata signature3
    ) public {
        // Ensure hashes are different
        vm.assume(hash1 != hash2);
        vm.assume(hash2 != hash3);
        vm.assume(hash1 != hash3);
        vm.assume(!registry.isDocumentStored(hash1));
        vm.assume(!registry.isDocumentStored(hash2));
        vm.assume(!registry.isDocumentStored(hash3));

        bytes32[] memory hashes = new bytes32[](3);
        hashes[0] = hash1;
        hashes[1] = hash2;
        hashes[2] = hash3;

        string[] memory signatures = new string[](3);
        signatures[0] = signature1;
        signatures[1] = signature2;
        signatures[2] = signature3;

        registry.storeMultiple(hashes, signatures);

        // Verify all documents were stored
        assertTrue(registry.isDocumentStored(hash1));
        assertTrue(registry.isDocumentStored(hash2));
        assertTrue(registry.isDocumentStored(hash3));

        DocumentRegistry.Document memory doc1 = registry.getDocumentInfo(hash1);
        DocumentRegistry.Document memory doc2 = registry.getDocumentInfo(hash2);
        DocumentRegistry.Document memory doc3 = registry.getDocumentInfo(hash3);

        assertEq(doc1.owner, owner);
        assertEq(doc2.owner, owner);
        assertEq(doc3.owner, owner);
        assertEq(doc1.signature, signature1);
        assertEq(doc2.signature, signature2);
        assertEq(doc3.signature, signature3);
    }

    /**
     * @notice Fuzz test: StoreMultiple reverts if arrays have different lengths
     * @param hashesLength Length of hashes array
     * @param signaturesLength Length of signatures array
     */
    function testFuzz_StoreMultiple_RevertIfArrayLengthMismatch(
        uint8 hashesLength,
        uint8 signaturesLength
    ) public {
        vm.assume(hashesLength != signaturesLength);
        vm.assume(hashesLength <= 10);
        vm.assume(signaturesLength <= 10);

        bytes32[] memory hashes = new bytes32[](hashesLength);
        string[] memory signatures = new string[](signaturesLength);

        // Initialize arrays with dummy data
        for (uint256 i = 0; i < hashesLength; ) {
            hashes[i] = keccak256(abi.encodePacked("hash", i, block.timestamp));
            unchecked {
                ++i;
            }
        }
        for (uint256 i = 0; i < signaturesLength; ) {
            signatures[i] = "signature";
            unchecked {
                ++i;
            }
        }

        vm.expectRevert(
            abi.encodeWithSelector(
                DocumentRegistry.ArrayLengthMismatch.selector,
                uint256(hashesLength),
                uint256(signaturesLength)
            )
        );
        registry.storeMultiple(hashes, signatures);
    }

    /**
     * @notice Fuzz test: StoreMultiple reverts if any hash already exists
     * @param hash1 First hash
     * @param hash2 Second hash
     * @param hash3 Third hash
     * @param signature1 First signature
     * @param signature2 Second signature
     * @param signature3 Third signature
     */
    function testFuzz_StoreMultiple_RevertIfAnyHashExists(
        bytes32 hash1,
        bytes32 hash2,
        bytes32 hash3,
        string calldata signature1,
        string calldata signature2,
        string calldata signature3
    ) public {
        // Ensure hashes are different
        vm.assume(hash1 != hash2);
        vm.assume(hash2 != hash3);
        vm.assume(hash1 != hash3);
        vm.assume(!registry.isDocumentStored(hash1));
        vm.assume(!registry.isDocumentStored(hash2));
        vm.assume(!registry.isDocumentStored(hash3));

        // Store first hash
        registry.storeDocument(hash1, signature1);

        // Try to store multiple including the existing one
        bytes32[] memory hashes = new bytes32[](3);
        hashes[0] = hash1;
        hashes[1] = hash2;
        hashes[2] = hash3;

        string[] memory signatures = new string[](3);
        signatures[0] = signature2;
        signatures[1] = signature2;
        signatures[2] = signature3;

        vm.expectRevert(
            abi.encodeWithSelector(
                DocumentRegistry.DocumentAlreadyExists.selector,
                hash1
            )
        );
        registry.storeMultiple(hashes, signatures);
    }

    /**
     * @notice Fuzz test: Multiple users can store different documents
     * @param hash1 First hash
     * @param hash2 Second hash
     * @param signature1 First signature
     * @param signature2 Second signature
     */
    function testFuzz_DifferentUsers_StoreDifferentDocuments(
        bytes32 hash1,
        bytes32 hash2,
        string calldata signature1,
        string calldata signature2
    ) public {
        vm.assume(hash1 != hash2);
        vm.assume(!registry.isDocumentStored(hash1));
        vm.assume(!registry.isDocumentStored(hash2));

        vm.prank(user1);
        registry.storeDocument(hash1, signature1);

        vm.prank(user2);
        registry.storeDocument(hash2, signature2);

        DocumentRegistry.Document memory doc1 = registry.getDocumentInfo(hash1);
        DocumentRegistry.Document memory doc2 = registry.getDocumentInfo(hash2);

        assertEq(doc1.owner, user1);
        assertEq(doc2.owner, user2);
        assertEq(doc1.signature, signature1);
        assertEq(doc2.signature, signature2);
    }
}

