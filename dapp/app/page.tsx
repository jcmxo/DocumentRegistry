'use client'

import { useState } from 'react'
import WalletSelector from '@/components/WalletSelector'
import FileUploader from '@/components/FileUploader'
import DocumentSigner from '@/components/DocumentSigner'
import DocumentVerifier from '@/components/DocumentVerifier'
import DocumentHistory from '@/components/DocumentHistory'

export default function Home() {
  const [activeTab, setActiveTab] = useState<'upload' | 'verify' | 'history'>('upload')
  const [documentHash, setDocumentHash] = useState<string | null>(null)
  const [signature, setSignature] = useState<string | null>(null)

  const handleFileSelect = (file: File) => {
    // File selected, hash will be calculated by FileUploader
  }

  const handleHashCalculated = (hash: string) => {
    setDocumentHash(hash)
  }

  const handleSigned = (sig: string) => {
    setSignature(sig)
  }

  return (
    <main className="min-h-screen bg-gray-100 py-8 px-4">
      <div className="max-w-6xl mx-auto">
        <h1 className="text-4xl font-bold text-center mb-8 text-gray-800">
          Document Registry dApp
        </h1>

        <div className="mb-6">
          <WalletSelector />
        </div>

        {/* Tabs */}
        <div className="mb-6 bg-white rounded-lg shadow-md p-1 flex gap-1">
          <button
            onClick={() => setActiveTab('upload')}
            className={`flex-1 px-4 py-2 rounded transition-colors ${
              activeTab === 'upload'
                ? 'bg-blue-500 text-white'
                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
            }`}
          >
            Upload & Sign
          </button>
          <button
            onClick={() => setActiveTab('verify')}
            className={`flex-1 px-4 py-2 rounded transition-colors ${
              activeTab === 'verify'
                ? 'bg-blue-500 text-white'
                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
            }`}
          >
            Verify
          </button>
          <button
            onClick={() => setActiveTab('history')}
            className={`flex-1 px-4 py-2 rounded transition-colors ${
              activeTab === 'history'
                ? 'bg-blue-500 text-white'
                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
            }`}
          >
            History
          </button>
        </div>

        {/* Tab Content */}
        {activeTab === 'upload' && (
          <div className="space-y-6">
            <FileUploader
              onFileSelect={handleFileSelect}
              onHashCalculated={handleHashCalculated}
            />
            <DocumentSigner
              documentHash={documentHash}
              onSigned={handleSigned}
            />
          </div>
        )}

        {activeTab === 'verify' && <DocumentVerifier />}

        {activeTab === 'history' && <DocumentHistory />}
      </div>
    </main>
  )
}
