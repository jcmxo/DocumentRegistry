'use client'

import { useState } from 'react'
import { useReadContract } from 'wagmi'
import { DOCUMENT_REGISTRY_ADDRESS, documentRegistryAbi } from '@/lib/documentRegistry'
import { type Address } from 'viem'

interface Document {
  hash: `0x${string}`
  owner: Address
  timestamp: bigint
  signature: string
}

export default function GetDocumentForm() {
  const [hashInput, setHashInput] = useState('')
  const [hash, setHash] = useState<`0x${string}` | null>(null)

  // First check if document exists
  const { data: exists, isLoading: isCheckingExists } = useReadContract({
    address: DOCUMENT_REGISTRY_ADDRESS,
    abi: documentRegistryAbi,
    functionName: 'isDocumentStored',
    args: hash ? [hash] : undefined,
    query: {
      enabled: !!hash,
    },
  })

  // Then get document info if it exists
  const { data, isLoading, error, refetch } = useReadContract({
    address: DOCUMENT_REGISTRY_ADDRESS,
    abi: documentRegistryAbi,
    functionName: 'getDocumentInfo',
    args: hash ? [hash] : undefined,
    query: {
      enabled: !!hash && exists === true,
    },
  })

  const document = data as Document | undefined

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault()
    
    // Normalize hash: remove all whitespace and non-hex characters
    let trimmedHash = hashInput.trim().replace(/\s+/g, '')
    
    // Remove 0x if present, we'll add it back
    if (trimmedHash.startsWith('0x') || trimmedHash.startsWith('0X')) {
      trimmedHash = trimmedHash.slice(2)
    }
    
    // Remove any remaining non-hex characters
    trimmedHash = trimmedHash.replace(/[^0-9a-fA-F]/g, '')
    
    // Add 0x prefix
    trimmedHash = '0x' + trimmedHash
    
    // Validate hash format (should be 0x followed by 64 hex characters)
    if (trimmedHash.length !== 66) {
      alert(`Invalid hash format. Hash must be 0x followed by 64 hexadecimal characters.\n\nCurrent length: ${trimmedHash.length - 2} characters (expected 64)`)
      return
    }

    // Validate it's a valid hex string
    if (!/^0x[0-9a-fA-F]{64}$/.test(trimmedHash)) {
      alert('Invalid hash format. Hash must contain only hexadecimal characters (0-9, a-f, A-F).')
      return
    }

    try {
      const normalizedHash = trimmedHash.toLowerCase() as `0x${string}`
      console.log('Setting hash to query:', normalizedHash)
      setHash(normalizedHash)
      // Update input to show normalized hash
      setHashInput(normalizedHash)
      // Trigger refetch when hash changes
      setTimeout(() => {
        console.log('Refetching with hash:', normalizedHash)
        refetch()
      }, 100)
    } catch (err) {
      console.error('Error setting hash:', err)
    }
  }

  const formatTimestamp = (timestamp: bigint): string => {
    const date = new Date(Number(timestamp) * 1000)
    return date.toLocaleString()
  }

  return (
    <div className="bg-white p-6 rounded-lg shadow-md">
      <h2 className="text-xl font-bold mb-4">Get Document Info</h2>
      
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label htmlFor="hash" className="block text-sm font-medium text-gray-700 mb-1">
            Document Hash
          </label>
          <input
            id="hash"
            type="text"
            value={hashInput}
            onChange={(e) => {
              setHashInput(e.target.value)
              setHash(null)
            }}
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 font-mono text-sm"
            placeholder="0x..."
            required
          />
          <p className="text-xs text-gray-500 mt-1">
            Enter the document hash (0x followed by 64 hex characters)
          </p>
        </div>

        <button
          type="submit"
          disabled={isLoading || isCheckingExists}
          className="w-full px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors"
        >
          {isLoading || isCheckingExists ? 'Loading...' : 'Get Document Info'}
        </button>
      </form>

      {hash && exists === false && !isCheckingExists && (
        <div className="mt-4 bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded">
          <p className="font-semibold">Document not found</p>
          <p className="text-sm mt-1">
            The document with the provided hash does not exist in the registry.
          </p>
          <p className="text-xs mt-2 font-mono break-all opacity-75">
            Hash queried: {hash}
          </p>
          <p className="text-xs mt-2 opacity-75">
            Tip: Make sure Anvil is running and the contract is deployed at the correct address.
          </p>
        </div>
      )}

      {error && (
        <div className="mt-4 bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded">
          <p className="font-semibold">Error querying document</p>
          <p className="text-sm mt-1">
            {error.message || String(error)}
          </p>
          {hash && (
            <p className="text-xs mt-2 font-mono break-all opacity-75">
              Hash queried: {hash}
            </p>
          )}
          <p className="text-xs mt-2 opacity-75">
            Contract address: {DOCUMENT_REGISTRY_ADDRESS}
          </p>
        </div>
      )}

      {document && !error && (
        <div className="mt-4 bg-green-50 border border-green-200 p-4 rounded">
          <h3 className="font-semibold text-green-800 mb-3">Document Information</h3>
          <div className="space-y-2 text-sm">
            <div>
              <span className="font-medium text-gray-700">Hash:</span>
              <p className="font-mono text-xs text-gray-800 break-all mt-1">{document.hash}</p>
            </div>
            <div>
              <span className="font-medium text-gray-700">Owner:</span>
              <p className="font-mono text-xs text-gray-800 break-all mt-1">{document.owner}</p>
            </div>
            <div>
              <span className="font-medium text-gray-700">Timestamp:</span>
              <p className="text-gray-800 mt-1">{formatTimestamp(document.timestamp)}</p>
            </div>
            <div>
              <span className="font-medium text-gray-700">Signature:</span>
              <p className="text-gray-800 mt-1 break-all">
                {document.signature || '(empty)'}
              </p>
            </div>
          </div>
        </div>
      )}
    </div>
  )
}

