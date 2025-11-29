// ABI extracted from sc/out/DocumentRegistry.sol/DocumentRegistry.json
export const documentRegistryAbi = [
  {
    type: 'function',
    name: 'storeDocumentHash',
    inputs: [
      {
        name: '_hash',
        type: 'bytes32',
        internalType: 'bytes32',
      },
      {
        name: '_timestamp',
        type: 'uint256',
        internalType: 'uint256',
      },
      {
        name: '_signature',
        type: 'bytes',
        internalType: 'bytes',
      },
      {
        name: '_signer',
        type: 'address',
        internalType: 'address',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'verifyDocument',
    inputs: [
      {
        name: '_hash',
        type: 'bytes32',
        internalType: 'bytes32',
      },
      {
        name: '_signer',
        type: 'address',
        internalType: 'address',
      },
      {
        name: '_signature',
        type: 'bytes',
        internalType: 'bytes',
      },
    ],
    outputs: [
      {
        name: 'isValid',
        type: 'bool',
        internalType: 'bool',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getDocumentInfo',
    inputs: [
      {
        name: '_hash',
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
            name: 'timestamp',
            type: 'uint256',
            internalType: 'uint256',
          },
          {
            name: 'signer',
            type: 'address',
            internalType: 'address',
          },
          {
            name: 'signature',
            type: 'bytes',
            internalType: 'bytes',
          },
        ],
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'isDocumentStored',
    inputs: [
      {
        name: '_hash',
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
    name: 'getDocumentCount',
    inputs: [],
    outputs: [
      {
        name: 'count',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'getDocumentHashByIndex',
    inputs: [
      {
        name: '_index',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [
      {
        name: 'hash',
        type: 'bytes32',
        internalType: 'bytes32',
      },
    ],
    stateMutability: 'view',
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
        name: 'signer',
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

export interface Document {
  hash: string
  timestamp: bigint
  signer: string
  signature: string
}
