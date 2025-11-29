'use client'

import { useState } from 'react'
import { useContract } from '@/hooks/useContract'
import { ethers } from 'ethers'
import { CheckCircle2, XCircle, Loader2 } from 'lucide-react'

export default function DocumentVerifier() {
  const { verifyDocument, getDocumentInfo } = useContract()
  const [file, setFile] = useState<File | null>(null)
  const [hash, setHash] = useState<string>('')
  const [signerAddress, setSignerAddress] = useState<string>('')
  const [isVerifying, setIsVerifying] = useState(false)
  const [verificationResult, setVerificationResult] = useState<{
    isValid: boolean
    documentInfo: any
    error?: string
  } | null>(null)

  const calculateHash = async (file: File) => {
    const arrayBuffer = await file.arrayBuffer()
    const hashBuffer = await crypto.subtle.digest('SHA-256', arrayBuffer)
    const hashArray = Array.from(new Uint8Array(hashBuffer))
    const hashHex = '0x' + hashArray.map(b => b.toString(16).padStart(2, '0')).join('')
    setHash(hashHex)
  }

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const selectedFile = e.target.files?.[0]
    if (selectedFile) {
      setFile(selectedFile)
      calculateHash(selectedFile)
    }
  }

  const handleVerify = async () => {
    if (!hash || !signerAddress) {
      alert('Please provide document hash and signer address')
      return
    }

    setIsVerifying(true)
    setVerificationResult(null)

    try {
      // Get document info first
      const doc = await getDocumentInfo(hash)
      
      // Verify the signature
      const isValid = await verifyDocument(hash, signerAddress, doc.signature)

      setVerificationResult({
        isValid,
        documentInfo: doc,
      })
    } catch (error: any) {
      console.error('Error verifying document:', error)
      setVerificationResult({
        isValid: false,
        documentInfo: null,
        error: error.message || 'Document not found or verification failed',
      })
    } finally {
      setIsVerifying(false)
    }
  }

  return (
    <div className="bg-white p-6 rounded-lg shadow-md">
      <h2 className="text-xl font-bold mb-4">Verify Document</h2>

      <div className="space-y-4">
        <div>
          <label htmlFor="file" className="block text-sm font-medium text-gray-700 mb-1">
            Upload Document
          </label>
          <input
            id="file"
            type="file"
            onChange={handleFileChange}
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
          />
        </div>

        <div>
          <label htmlFor="hash" className="block text-sm font-medium text-gray-700 mb-1">
            Document Hash (or will be calculated from file)
          </label>
          <input
            id="hash"
            type="text"
            value={hash}
            onChange={(e) => setHash(e.target.value)}
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 font-mono text-sm"
            placeholder="0x..."
          />
        </div>

        <div>
          <label htmlFor="signer" className="block text-sm font-medium text-gray-700 mb-1">
            Signer Address
          </label>
          <input
            id="signer"
            type="text"
            value={signerAddress}
            onChange={(e) => setSignerAddress(e.target.value)}
            className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 font-mono text-sm"
            placeholder="0x..."
          />
        </div>

        <button
          onClick={handleVerify}
          disabled={!hash || !signerAddress || isVerifying}
          className="w-full px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors flex items-center justify-center gap-2"
        >
          {isVerifying ? (
            <>
              <Loader2 className="h-4 w-4 animate-spin" />
              Verifying...
            </>
          ) : (
            'Verify Document'
          )}
        </button>

        {verificationResult && (
          <div
            className={`p-4 rounded border ${
              verificationResult.isValid
                ? 'bg-green-50 border-green-200'
                : 'bg-red-50 border-red-200'
            }`}
          >
            <div className="flex items-center gap-2 mb-2">
              {verificationResult.isValid ? (
                <>
                  <CheckCircle2 className="h-5 w-5 text-green-600" />
                  <p className="font-semibold text-green-800">✅ Document is VALID</p>
                </>
              ) : (
                <>
                  <XCircle className="h-5 w-5 text-red-600" />
                  <p className="font-semibold text-red-800">❌ Document is INVALID</p>
                </>
              )}
            </div>

            {verificationResult.error && (
              <p className="text-sm text-red-700 mt-2">{verificationResult.error}</p>
            )}

            {verificationResult.documentInfo && (
              <div className="mt-3 space-y-1 text-sm">
                <div>
                  <span className="font-medium text-gray-700">Hash:</span>
                  <p className="font-mono text-xs text-gray-800 break-all mt-1">
                    {verificationResult.documentInfo.hash}
                  </p>
                </div>
                <div>
                  <span className="font-medium text-gray-700">Signer:</span>
                  <p className="font-mono text-xs text-gray-800 break-all mt-1">
                    {verificationResult.documentInfo.signer}
                  </p>
                </div>
                <div>
                  <span className="font-medium text-gray-700">Timestamp:</span>
                  <p className="text-gray-800 mt-1">
                    {new Date(Number(verificationResult.documentInfo.timestamp) * 1000).toLocaleString()}
                  </p>
                </div>
              </div>
            )}
          </div>
        )}
      </div>
    </div>
  )
}

