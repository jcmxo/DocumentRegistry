# DocumentRegistry - Smart Contract

A gas-efficient smart contract for registering and querying document hashes with metadata on Ethereum.

## 📋 Overview

`DocumentRegistry` is a smart contract that allows users to register document hashes along with metadata (owner, timestamp, and optional signature). The contract prevents duplicate registrations and provides efficient querying capabilities.

### Key Features

- ✅ Register document hashes with metadata
- ✅ Prevent duplicate registrations
- ✅ Query document information by hash
- ✅ Batch registration of multiple documents
- ✅ Gas-efficient storage and operations
- ✅ Custom errors for better gas usage
- ✅ Event emission for off-chain tracking

## 🏗️ Contract Structure

### Document Struct

```solidity
struct Document {
    bytes32 hash;        // Document hash
    address owner;       // Address that registered the document
    uint256 timestamp;   // Registration timestamp
    string signature;   // Optional signature string
}
```

### Main Functions

- `storeDocument(bytes32 hash, string calldata signature)` - Register a single document
- `getDocumentInfo(bytes32 hash)` - Retrieve all document information
- `getDocumentSignature(bytes32 hash)` - Retrieve document signature
- `storeMultiple(bytes32[] calldata hashes, string[] calldata signatures)` - Batch registration
- `isDocumentStored(bytes32 hash)` - Check if document exists

### Custom Errors

- `DocumentAlreadyExists(bytes32 hash)` - Document hash already registered
- `DocumentNotFound(bytes32 hash)` - Document hash not found
- `ArrayLengthMismatch(uint256 hashesLength, uint256 signaturesLength)` - Array length mismatch in batch operation

## 🚀 Getting Started

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation) installed
- Git (for installing dependencies)

### Installation

1. **Install Foundry** (if not already installed):
   ```bash
   curl -L https://foundry.paradigm.xyz | bash
   foundryup
   ```

2. **Install forge-std** (testing library):
   ```bash
   forge install foundry-rs/forge-std
   ```

### Compilation

Compile the contracts:

```bash
forge build
```

This will compile all contracts and generate artifacts in the `out/` directory.

### Testing

Run all tests:

```bash
forge test
```

Run tests with verbose output:

```bash
forge test -vv
```

Run tests with very verbose output (shows gas usage):

```bash
forge test -vvv
```

Run tests with maximum verbosity:

```bash
forge test -vvvv
```

### Fuzz Testing

Fuzz tests are included in the test suite. They run automatically with `forge test`. To run with more fuzz runs:

```bash
forge test --fuzz-runs 1000
```

### Test Coverage

The test suite includes:

- ✅ Unit tests for all functions
- ✅ Edge case testing
- ✅ Fuzz testing with random inputs
- ✅ Gas optimization verification
- ✅ Event emission verification

## 📊 Gas Reports

Generate gas reports:

```bash
forge test --gas-report
```

The `foundry.toml` is configured to generate gas reports for `DocumentRegistry` contract.

## 🚢 Deployment

### Local Deployment (Anvil)

1. **Start Anvil**:
   ```bash
   anvil
   ```

2. **Deploy using the Anvil script**:
   ```bash
   forge script script/Deploy.s.sol:DeployAnvil --rpc-url http://localhost:8545 --broadcast
   ```

### Testnet/Mainnet Deployment

1. **Set your private key** (use a `.env` file):
   ```bash
   export PRIVATE_KEY=your_private_key_here
   ```

2. **Deploy**:
   ```bash
   forge script script/Deploy.s.sol --rpc-url <RPC_URL> --broadcast --private-key $PRIVATE_KEY
   ```

   Or using environment variable:
   ```bash
   forge script script/Deploy.s.sol --rpc-url <RPC_URL> --broadcast
   ```

### Example Deployment Commands

**Anvil (local):**
```bash
forge script script/Deploy.s.sol:DeployAnvil --rpc-url http://localhost:8545 --broadcast
```

**Sepolia Testnet:**
```bash
forge script script/Deploy.s.sol \
  --rpc-url https://sepolia.infura.io/v3/YOUR_INFURA_KEY \
  --broadcast \
  --verify \
  --etherscan-api-key YOUR_ETHERSCAN_API_KEY
```

**Mainnet:**
```bash
forge script script/Deploy.s.sol \
  --rpc-url https://mainnet.infura.io/v3/YOUR_INFURA_KEY \
  --broadcast \
  --verify \
  --etherscan-api-key YOUR_ETHERSCAN_API_KEY
```

## 🔍 Verification on Etherscan

To verify the contract on Etherscan after deployment:

```bash
forge verify-contract \
  <CONTRACT_ADDRESS> \
  DocumentRegistry \
  --etherscan-api-key <API_KEY> \
  --chain-id <CHAIN_ID>
```

Or use the `--verify` flag during deployment (as shown in examples above).

## 📝 Usage Examples

### Register a Document

```solidity
// Register a document with signature
documentRegistry.storeDocument(
    0x1234...5678,  // document hash
    "signature-string"  // optional signature
);
```

### Query Document Information

```solidity
// Get all document information
Document memory doc = documentRegistry.getDocumentInfo(0x1234...5678);

// Get only the signature
string memory signature = documentRegistry.getDocumentSignature(0x1234...5678);

// Check if document exists
bool exists = documentRegistry.isDocumentStored(0x1234...5678);
```

### Batch Registration

```solidity
bytes32[] memory hashes = new bytes32[](3);
hashes[0] = 0x1111...;
hashes[1] = 0x2222...;
hashes[2] = 0x3333...;

string[] memory signatures = new string[](3);
signatures[0] = "sig1";
signatures[1] = "sig2";
signatures[2] = "sig3";

documentRegistry.storeMultiple(hashes, signatures);
```

## 🔒 Security Features

- **Checks-Effects-Interactions Pattern**: All functions follow the CEI pattern
- **Input Validation**: Strict validation of inputs with custom errors
- **Duplicate Prevention**: Cannot register the same hash twice
- **Gas Optimization**: Efficient storage and custom errors
- **Event Logging**: All operations emit events for off-chain tracking

## 📈 Gas Optimization

The contract is optimized for gas efficiency:

- Uses `calldata` for function parameters where possible
- Custom errors instead of string error messages
- Separate mapping for existence check (cheaper than checking struct)
- Unchecked arithmetic in loops where safe
- Optimizer enabled with 200 runs

## 🧪 Testing

The project includes comprehensive test coverage:

### Test Categories

1. **Unit Tests**: Test all functions individually
2. **Integration Tests**: Test interactions between functions
3. **Fuzz Tests**: Test with random inputs to find edge cases
4. **Gas Tests**: Verify gas efficiency

### Running Specific Tests

Run a specific test:
```bash
forge test --match-test test_StoreDocument_Success
```

Run all fuzz tests:
```bash
forge test --match-test testFuzz
```

## 📁 Project Structure

```
sc/
├── foundry.toml          # Foundry configuration
├── src/
│   └── DocumentRegistry.sol      # Main contract
├── test/
│   └── DocumentRegistry.t.sol    # Test suite
├── script/
│   └── Deploy.s.sol              # Deployment script
└── README.md                     # This file
```

## 🔧 Configuration

The `foundry.toml` is configured with:

- Solidity version: `0.8.23`
- Optimizer: Enabled (200 runs)
- EVM version: Paris
- Gas reports: Enabled for DocumentRegistry

## 📄 License

MIT License - see LICENSE file for details

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Ensure all tests pass
6. Submit a pull request

## 📞 Support

For issues, questions, or contributions, please open an issue or pull request in the repository.

---

**Built with ❤️ using Foundry**
