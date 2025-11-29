'use client'

import { useState, useEffect } from 'react'
import { useContract } from '@/hooks/useContract'
import { Clock, Loader2 } from 'lucide-react'

export default function DocumentHistory() {
  const { getDocumentCount, getDocumentHashByIndex, getDocumentInfo } = useContract()
  const [documents, setDocuments] = useState<any[]>([])
  const [isLoading, setIsLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)

  const loadDocuments = async () => {
    setIsLoading(true)
    setError(null)

    try {
      const count = await getDocumentCount()
      const docs = []

      for (let i = 0; i < count; i++) {
        try {
          const hash = await getDocumentHashByIndex(i)
          const doc = await getDocumentInfo(hash)
          docs.push({
            ...doc,
            hash, // hash from getDocumentHashByIndex
          })
        } catch (err) {
          console.error(`Error loading document at index ${i}:`, err)
        }
      }

      setDocuments(docs)
    } catch (err) {
      console.error('Error loading documents:', err)
      setError(err instanceof Error ? err.message : 'Failed to load documents')
    } finally {
      setIsLoading(false)
    }
  }

  useEffect(() => {
    loadDocuments()
  }, [])

  const formatTimestamp = (timestamp: bigint): string => {
    return new Date(Number(timestamp) * 1000).toLocaleString()
  }

  return (
    <div className="bg-white p-6 rounded-lg shadow-md">
      <div className="flex items-center justify-between mb-4">
        <h2 className="text-xl font-bold flex items-center gap-2">
          <Clock className="h-5 w-5" />
          Document History
        </h2>
        <button
          onClick={loadDocuments}
          disabled={isLoading}
          className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors text-sm"
        >
          {isLoading ? 'Loading...' : 'Refresh'}
        </button>
      </div>

      {isLoading && (
        <div className="flex items-center justify-center py-8">
          <Loader2 className="h-8 w-8 animate-spin text-gray-400" />
        </div>
      )}

      {error && (
        <div className="bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded">
          <p className="text-sm">{error}</p>
        </div>
      )}

      {!isLoading && !error && documents.length === 0 && (
        <div className="text-center py-8 text-gray-500">
          <p>No documents stored yet.</p>
          <p className="text-sm mt-2">Upload and store a document to see it here.</p>
        </div>
      )}

      {!isLoading && !error && documents.length > 0 && (
        <div className="space-y-4">
          {documents.map((doc, index) => (
            <div
              key={index}
              className="border border-gray-200 rounded-lg p-4 hover:bg-gray-50 transition-colors"
            >
              <div className="space-y-2 text-sm">
                <div>
                  <span className="font-medium text-gray-700">Hash:</span>
                  <p className="font-mono text-xs text-gray-800 break-all mt-1">
                    {doc.hash}
                  </p>
                </div>
                <div>
                  <span className="font-medium text-gray-700">Signer:</span>
                  <p className="font-mono text-xs text-gray-800 break-all mt-1">
                    {doc.signer}
                  </p>
                </div>
                <div>
                  <span className="font-medium text-gray-700">Timestamp:</span>
                  <p className="text-gray-800 mt-1">{formatTimestamp(doc.timestamp)}</p>
                </div>
                <div>
                  <span className="font-medium text-gray-700">Signature:</span>
                  <p className="font-mono text-xs text-gray-800 break-all mt-1">
                    {doc.signature.substring(0, 20)}... ({doc.signature.length} bytes)
                  </p>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

