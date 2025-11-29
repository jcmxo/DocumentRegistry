// ABI extracted from sc/out/DocumentRegistry.sol/DocumentRegistry.json
export const documentRegistryAbi = [
  {
    type: 'function',
    name: 'getDocumentInfo',
    inputs: [
      {
        name: 'hash',
        type: 'bytes32',
        internalType: 'bytes32',
      },
    ],
    outputs: [
      {
        name: 'document',
        type: 'tuple',
        internalType: 'struct DocumentRegistry.Document',
        components: [
          {
            name: 'hash',
            type: 'bytes32',
            internalType: 'bytes32',
          },
          {
            name: 'owner',
            type: 'address',
            internalType: 'address',
          },
          {
            name: 'timestamp',
            type: 'uint256',
            internalType: 'uint256',
          },
          {
            name: 'signature',
            type: 'string',
            internalType: 'string',
          },
        ],
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getDocumentSignature',
    inputs: [
      {
        name: 'hash',
        type: 'bytes32',
        internalType: 'bytes32',
      },
    ],
    outputs: [
      {
        name: 'signature',
        type: 'string',
        internalType: 'string',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'isDocumentStored',
    inputs: [
      {
        name: 'hash',
        type: 'bytes32',
        internalType: 'bytes32',
      },
    ],
    outputs: [
      {
        name: 'exists',
        type: 'bool',
        internalType: 'bool',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'storeDocument',
    inputs: [
      {
        name: 'hash',
        type: 'bytes32',
        internalType: 'bytes32',
      },
      {
        name: 'signature',
        type: 'string',
        internalType: 'string',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'storeMultiple',
    inputs: [
      {
        name: 'hashes',
        type: 'bytes32[]',
        internalType: 'bytes32[]',
      },
      {
        name: 'signatures',
        type: 'string[]',
        internalType: 'string[]',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'event',
    name: 'DocumentStored',
    inputs: [
      {
        name: 'hash',
        type: 'bytes32',
        indexed: true,
        internalType: 'bytes32',
      },
      {
        name: 'owner',
        type: 'address',
        indexed: true,
        internalType: 'address',
      },
      {
        name: 'timestamp',
        type: 'uint256',
        indexed: false,
        internalType: 'uint256',
      },
    ],
    anonymous: false,
  },
  {
    type: 'error',
    name: 'ArrayLengthMismatch',
    inputs: [
      {
        name: 'hashesLength',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: 'signaturesLength',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
  },
  {
    type: 'error',
    name: 'DocumentAlreadyExists',
    inputs: [
      {
        name: 'hash',
        type: 'bytes32',
        internalType: 'bytes32',
      },
    ],
  },
  {
    type: 'error',
    name: 'DocumentNotFound',
    inputs: [
      {
        name: 'hash',
        type: 'bytes32',
        internalType: 'bytes32',
      },
    ],
  },
] as const

export const DOCUMENT_REGISTRY_ADDRESS =
  (process.env.NEXT_PUBLIC_DOCUMENT_REGISTRY_ADDRESS as `0x${string}`) ||
  '0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9'
