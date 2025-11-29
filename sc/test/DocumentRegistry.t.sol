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
    address public signer;
    address public user1;
    address public user2;

    bytes32 public constant TEST_HASH_1 = keccak256("document-1");
    bytes32 public constant TEST_HASH_2 = keccak256("document-2");
    bytes32 public constant TEST_HASH_3 = keccak256("document-3");

    event DocumentStored(bytes32 indexed hash, address indexed signer, uint256 timestamp);

    // Helper function to create a signature
    function createSignature(bytes32 hash, uint256 privateKey) internal pure returns (bytes memory) {
        bytes32 messageHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, messageHash);
        return abi.encodePacked(r, s, v);
    }

    function setUp() public {
        registry = new DocumentRegistry();
        signer = address(this);
        user1 = address(0x1);
        user2 = address(0x2);
    }

    // ============ Tests for storeDocumentHash ============

    /**
     * @notice Test storing a single document successfully
     */
    function test_StoreDocumentHash_Success() public {
        bytes memory signature = createSignature(TEST_HASH_1, 1);
        uint256 timestamp = block.timestamp;

        vm.expectEmit(true, true, false, false);
        emit DocumentStored(TEST_HASH_1, signer, timestamp);

        registry.storeDocumentHash(TEST_HASH_1, timestamp, signature, signer);

        // Verify document exists
        assertTrue(registry.isDocumentStored(TEST_HASH_1));

        // Verify document info
        DocumentRegistry.Document memory doc = registry.getDocumentInfo(TEST_HASH_1);
        assertEq(doc.hash, TEST_HASH_1);
        assertEq(doc.signer, signer);
        assertEq(doc.timestamp, timestamp);
        assertEq(doc.signature.length, signature.length);
    }

    /**
     * @notice Test storing a document with empty signature
     */
    function test_StoreDocumentHash_WithEmptySignature() public {
        bytes memory emptySignature = "";
        uint256 timestamp = block.timestamp;

        registry.storeDocumentHash(TEST_HASH_1, timestamp, emptySignature, signer);

        DocumentRegistry.Document memory doc = registry.getDocumentInfo(TEST_HASH_1);
        assertEq(doc.signature.length, 0);
    }

    /**
     * @notice Test that storing the same document twice reverts
     */
    function test_StoreDocumentHash_RevertIfAlreadyExists() public {
        bytes memory signature1 = createSignature(TEST_HASH_1, 1);
        bytes memory signature2 = createSignature(TEST_HASH_1, 2);
        uint256 timestamp = block.timestamp;

        registry.storeDocumentHash(TEST_HASH_1, timestamp, signature1, signer);

        vm.expectRevert("Document already exists");
        registry.storeDocumentHash(TEST_HASH_1, timestamp, signature2, signer);
    }

    /**
     * @notice Test that different users can store different documents
     */
    function test_StoreDocumentHash_DifferentUsers() public {
        bytes memory signature1 = createSignature(TEST_HASH_1, 1);
        bytes memory signature2 = createSignature(TEST_HASH_2, 2);
        uint256 timestamp = block.timestamp;

        vm.prank(user1);
        registry.storeDocumentHash(TEST_HASH_1, timestamp, signature1, user1);

        vm.prank(user2);
        registry.storeDocumentHash(TEST_HASH_2, timestamp, signature2, user2);

        DocumentRegistry.Document memory doc1 = registry.getDocumentInfo(TEST_HASH_1);
        DocumentRegistry.Document memory doc2 = registry.getDocumentInfo(TEST_HASH_2);

        assertEq(doc1.signer, user1);
        assertEq(doc2.signer, user2);
    }

    // ============ Tests for verifyDocument ============

    /**
     * @notice Test verifying a document with valid signature
     */
    function test_VerifyDocument_ValidSignature() public {
        uint256 privateKey = 1;
        address signerAddr = vm.addr(privateKey);
        bytes memory signature = createSignature(TEST_HASH_1, privateKey);
        uint256 timestamp = block.timestamp;

        registry.storeDocumentHash(TEST_HASH_1, timestamp, signature, signerAddr);

        bool isValid = registry.verifyDocument(TEST_HASH_1, signerAddr, signature);
        assertTrue(isValid);
    }

    /**
     * @notice Test verifying a document with invalid signer
     */
    function test_VerifyDocument_InvalidSigner() public {
        uint256 privateKey = 1;
        address signerAddr = vm.addr(privateKey);
        address wrongSigner = vm.addr(2);
        bytes memory signature = createSignature(TEST_HASH_1, privateKey);
        uint256 timestamp = block.timestamp;

        registry.storeDocumentHash(TEST_HASH_1, timestamp, signature, signerAddr);

        bool isValid = registry.verifyDocument(TEST_HASH_1, wrongSigner, signature);
        assertFalse(isValid);
    }

    /**
     * @notice Test verifying a non-existent document
     */
    function test_VerifyDocument_NonExistent() public {
        uint256 privateKey = 1;
        address signerAddr = vm.addr(privateKey);
        bytes memory signature = createSignature(TEST_HASH_1, privateKey);

        bool isValid = registry.verifyDocument(TEST_HASH_1, signerAddr, signature);
        assertFalse(isValid);
    }

    // ============ Tests for getDocumentInfo ============

    /**
     * @notice Test retrieving document information successfully
     */
    function test_GetDocumentInfo_Success() public {
        bytes memory signature = createSignature(TEST_HASH_1, 1);
        uint256 timestamp = block.timestamp;

        registry.storeDocumentHash(TEST_HASH_1, timestamp, signature, signer);

        DocumentRegistry.Document memory doc = registry.getDocumentInfo(TEST_HASH_1);

        assertEq(doc.hash, TEST_HASH_1);
        assertEq(doc.signer, signer);
        assertEq(doc.timestamp, timestamp);
    }

    /**
     * @notice Test that querying non-existent document reverts
     */
    function test_GetDocumentInfo_RevertIfNotFound() public {
        vm.expectRevert("Document does not exist");
        registry.getDocumentInfo(TEST_HASH_1);
    }

    // ============ Tests for isDocumentStored ============

    /**
     * @notice Test isDocumentStored returns true for stored document
     */
    function test_IsDocumentStored_ReturnsTrue() public {
        bytes memory signature = createSignature(TEST_HASH_1, 1);
        uint256 timestamp = block.timestamp;

        registry.storeDocumentHash(TEST_HASH_1, timestamp, signature, signer);
        assertTrue(registry.isDocumentStored(TEST_HASH_1));
    }

    /**
     * @notice Test isDocumentStored returns false for non-existent document
     */
    function test_IsDocumentStored_ReturnsFalse() public {
        assertFalse(registry.isDocumentStored(TEST_HASH_1));
    }

    // ============ Tests for getDocumentCount ============

    /**
     * @notice Test getDocumentCount returns correct count
     */
    function test_GetDocumentCount() public {
        assertEq(registry.getDocumentCount(), 0);

        bytes memory signature1 = createSignature(TEST_HASH_1, 1);
        bytes memory signature2 = createSignature(TEST_HASH_2, 2);
        uint256 timestamp = block.timestamp;

        registry.storeDocumentHash(TEST_HASH_1, timestamp, signature1, signer);
        assertEq(registry.getDocumentCount(), 1);

        registry.storeDocumentHash(TEST_HASH_2, timestamp, signature2, signer);
        assertEq(registry.getDocumentCount(), 2);
    }

    // ============ Tests for getDocumentHashByIndex ============

    /**
     * @notice Test getDocumentHashByIndex returns correct hash
     */
    function test_GetDocumentHashByIndex() public {
        bytes memory signature1 = createSignature(TEST_HASH_1, 1);
        bytes memory signature2 = createSignature(TEST_HASH_2, 2);
        bytes memory signature3 = createSignature(TEST_HASH_3, 3);
        uint256 timestamp = block.timestamp;

        registry.storeDocumentHash(TEST_HASH_1, timestamp, signature1, signer);
        registry.storeDocumentHash(TEST_HASH_2, timestamp, signature2, signer);
        registry.storeDocumentHash(TEST_HASH_3, timestamp, signature3, signer);

        assertEq(registry.getDocumentHashByIndex(0), TEST_HASH_1);
        assertEq(registry.getDocumentHashByIndex(1), TEST_HASH_2);
        assertEq(registry.getDocumentHashByIndex(2), TEST_HASH_3);
    }

    /**
     * @notice Test getDocumentHashByIndex reverts for out of bounds index
     */
    function test_GetDocumentHashByIndex_RevertIfOutOfBounds() public {
        vm.expectRevert("Index out of bounds");
        registry.getDocumentHashByIndex(0);

        bytes memory signature = createSignature(TEST_HASH_1, 1);
        registry.storeDocumentHash(TEST_HASH_1, block.timestamp, signature, signer);

        vm.expectRevert("Index out of bounds");
        registry.getDocumentHashByIndex(1);
    }

    // ============ Fuzz Tests ============

    /**
     * @notice Fuzz test: Store and retrieve document with random hash
     * @param hash Random document hash
     * @param timestamp Random timestamp
     */
    function testFuzz_StoreAndRetrieveDocument(
        bytes32 hash,
        uint256 timestamp
    ) public {
        vm.assume(timestamp > 0);
        vm.assume(!registry.isDocumentStored(hash));

        uint256 privateKey = uint256(keccak256(abi.encodePacked(hash))) % type(uint256).max;
        address signerAddr = vm.addr(privateKey);
        bytes memory signature = createSignature(hash, privateKey);

        registry.storeDocumentHash(hash, timestamp, signature, signerAddr);

        assertTrue(registry.isDocumentStored(hash));

        DocumentRegistry.Document memory doc = registry.getDocumentInfo(hash);
        assertEq(doc.hash, hash);
        assertEq(doc.signer, signerAddr);
        assertEq(doc.timestamp, timestamp);
    }

    /**
     * @notice Fuzz test: Cannot store same hash twice
     * @param hash Random document hash
     * @param timestamp Random timestamp
     */
    function testFuzz_CannotStoreSameHashTwice(
        bytes32 hash,
        uint256 timestamp
    ) public {
        vm.assume(timestamp > 0);
        vm.assume(!registry.isDocumentStored(hash));

        uint256 privateKey1 = uint256(keccak256(abi.encodePacked(hash, "1"))) % type(uint256).max;
        uint256 privateKey2 = uint256(keccak256(abi.encodePacked(hash, "2"))) % type(uint256).max;
        address signerAddr = vm.addr(privateKey1);
        bytes memory signature1 = createSignature(hash, privateKey1);
        bytes memory signature2 = createSignature(hash, privateKey2);

        registry.storeDocumentHash(hash, timestamp, signature1, signerAddr);

        vm.expectRevert("Document already exists");
        registry.storeDocumentHash(hash, timestamp, signature2, signerAddr);
    }

    /**
     * @notice Fuzz test: GetDocumentInfo reverts for non-existent hash
     * @param hash Random document hash
     */
    function testFuzz_GetDocumentInfo_RevertIfNotFound(bytes32 hash) public {
        vm.assume(!registry.isDocumentStored(hash));

        vm.expectRevert("Document does not exist");
        registry.getDocumentInfo(hash);
    }

    /**
     * @notice Fuzz test: VerifyDocument returns false for non-existent hash
     * @param hash Random document hash
     */
    function testFuzz_VerifyDocument_NonExistent(bytes32 hash) public {
        vm.assume(!registry.isDocumentStored(hash));

        uint256 privateKey = uint256(keccak256(abi.encodePacked(hash))) % type(uint256).max;
        address signerAddr = vm.addr(privateKey);
        bytes memory signature = createSignature(hash, privateKey);

        bool isValid = registry.verifyDocument(hash, signerAddr, signature);
        assertFalse(isValid);
    }
}
