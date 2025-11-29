'use client'

import { useState } from 'react'
import { useAccount, useWriteContract, useWaitForTransactionReceipt } from 'wagmi'
import { keccak256, stringToBytes } from 'viem'
import { DOCUMENT_REGISTRY_ADDRESS, documentRegistryAbi } from '@/lib/documentRegistry'

export default function StoreDocumentForm() {
  const { address, isConnected } = useAccount()
  const [content, setContent] = useState('')
  const [signature, setSignature] = useState('')
  const [computedHash, setComputedHash] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)

  const { data: hash, writeContract, isPending, error: writeError } = useWriteContract()
  
  const { isLoading: isConfirming, isSuccess, data: receipt } = useWaitForTransactionReceipt({
    hash,
  })

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault()
    setError(null)
    setComputedHash(null)

    if (!isConnected) {
      setError('Please connect your wallet first')
      return
    }

    if (!content.trim()) {
      setError('Please enter document content')
      return
    }

    try {
      // Calculate hash using keccak256
      const contentBytes = stringToBytes(content)
      const documentHash = keccak256(contentBytes)
      setComputedHash(documentHash)

      // Call storeDocument
      writeContract({
        address: DOCUMENT_REGISTRY_ADDRESS,
        abi: documentRegistryAbi,
        functionName: 'storeDocument',
        args: [documentHash, signature || ''],
      })
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Failed to store document')
    }
  }

  const handleReset = () => {
    setContent('')
    setSignature('')
    setComputedHash(null)
    setError(null)
  }

  return (
    <div className="bg-white p-6 rounded-lg shadow-md">
      <h2 className="text-xl font-bold mb-4">Store Document</h2>
      
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label htmlFor="content" className="block text-sm font-medium text-gray-700 mb-1">
            Document Content
          </label>
          <textarea
            id="content"
            value={content}
            onChange={(e) => setContent(e.target.value)}
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            rows={4}
            placeholder="Enter document content..."
            disabled={isPending || isConfirming}
          />
        </div>

        <div>
          <label htmlFor="signature" className="block text-sm font-medium text-gray-700 mb-1">
            Signature (optional)
          </label>
          <input
            id="signature"
            type="text"
            value={signature}
            onChange={(e) => setSignature(e.target.value)}
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
            placeholder="e.g., firma-1"
            disabled={isPending || isConfirming}
          />
        </div>

        {computedHash && (
          <div className="bg-gray-50 p-3 rounded">
            <div className="flex items-center justify-between mb-1">
              <p className="text-xs text-gray-600">Computed Hash:</p>
              <button
                type="button"
                onClick={() => {
                  navigator.clipboard.writeText(computedHash)
                  alert('Hash copied to clipboard!')
                }}
                className="text-xs text-blue-600 hover:text-blue-800 underline"
              >
                Copy
              </button>
            </div>
            <p className="font-mono text-xs text-gray-800 break-all">{computedHash}</p>
          </div>
        )}

        {error && (
          <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded">
            {error}
          </div>
        )}

        {writeError && (
          <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded">
            Error: {writeError.message}
          </div>
        )}

        {isSuccess && receipt && (
          <div className="bg-green-50 border border-green-200 text-green-700 px-4 py-3 rounded">
            <p className="font-semibold">Document stored successfully!</p>
            {hash && (
              <p className="text-xs mt-1 font-mono break-all">
                TX Hash: {hash}
              </p>
            )}
            {receipt.status === 'success' && computedHash && (
              <p className="text-xs mt-2 text-green-600">
                ✅ Transaction confirmed. Document hash: {computedHash}
              </p>
            )}
            {receipt.status === 'reverted' && (
              <p className="text-xs mt-2 text-red-600">
                ⚠️ Transaction reverted. The document may not have been stored.
              </p>
            )}
          </div>
        )}

        <div className="flex gap-2">
          <button
            type="submit"
            disabled={isPending || isConfirming || !isConnected}
            className="flex-1 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors"
          >
            {isPending || isConfirming ? 'Processing...' : 'Store Document'}
          </button>
          {(isSuccess || error) && (
            <button
              type="button"
              onClick={handleReset}
              className="px-4 py-2 bg-gray-500 text-white rounded hover:bg-gray-600 transition-colors"
            >
              Reset
            </button>
          )}
        </div>
      </form>
    </div>
  )
}

