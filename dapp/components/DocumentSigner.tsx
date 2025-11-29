'use client'

import { useState } from 'react'
import { useMetaMask } from '@/contexts/MetaMaskContext'
import { useContract } from '@/hooks/useContract'
import { ethers } from 'ethers'
import { FileCheck, Loader2 } from 'lucide-react'

interface DocumentSignerProps {
  documentHash: string | null
  onSigned: (signature: string) => void
}

export default function DocumentSigner({ documentHash, onSigned }: DocumentSignerProps) {
  const { signer, selectedWalletIndex, wallets } = useMetaMask()
  const { storeDocumentHash } = useContract()
  const [signature, setSignature] = useState<string | null>(null)
  const [isSigning, setIsSigning] = useState(false)
  const [isStoring, setIsStoring] = useState(false)
  const [txHash, setTxHash] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)

  const handleSign = async () => {
    if (!documentHash) {
      alert('Please upload a document first')
      return
    }

    if (selectedWalletIndex === null) {
      alert('Please connect a wallet first')
      return
    }

    setIsSigning(true)
    setError(null)

    try {
      // Confirm signing
      const confirmed = window.confirm(
        `Do you want to sign this document hash?\n\nHash: ${documentHash}\n\nWallet: ${wallets[selectedWalletIndex].address}`
      )

      if (!confirmed) {
        setIsSigning(false)
        return
      }

      if (!signer) {
        throw new Error('Signer not available')
      }

      // The contract expects signature of message: "\x19Ethereum Signed Message:\n32" + hash
      // Ethers.js signMessage automatically adds "\x19Ethereum Signed Message:\n" + length
      // For a 32-byte hash, it will add "\x19Ethereum Signed Message:\n32" which matches!
      // So we can use signMessage directly with the hash bytes
      const hashBytes = ethers.getBytes(documentHash)
      const sig = await signer.signMessage(hashBytes)
      setSignature(sig)
      onSigned(sig)

      alert(`Document signed successfully!\n\nSignature: ${sig.substring(0, 20)}...`)
    } catch (err) {
      console.error('Error signing document:', err)
      setError(err instanceof Error ? err.message : 'Failed to sign document')
      alert('Error signing document. Please try again.')
    } finally {
      setIsSigning(false)
    }
  }

  const handleStore = async () => {
    if (!documentHash || !signature) {
      alert('Please sign the document first')
      return
    }

    if (selectedWalletIndex === null) {
      alert('Please connect a wallet first')
      return
    }

    setIsStoring(true)
    setError(null)

    try {
      // Confirm storing
      const confirmed = window.confirm(
        `Do you want to store this document on the blockchain?\n\nHash: ${documentHash}\n\nThis will cost gas.`
      )

      if (!confirmed) {
        setIsStoring(false)
        return
      }

      const signerAddress = wallets[selectedWalletIndex].address
      const timestamp = Math.floor(Date.now() / 1000)

      const tx = await storeDocumentHash(
        documentHash,
        timestamp,
        signature,
        signerAddress
      )

      setTxHash(tx.hash)

      // Wait for transaction
      await tx.wait()

      alert(`Document stored successfully!\n\nTX Hash: ${tx.hash}`)
    } catch (err) {
      console.error('Error storing document:', err)
      setError(err instanceof Error ? err.message : 'Failed to store document')
      alert('Error storing document. Please try again.')
    } finally {
      setIsStoring(false)
    }
  }

  return (
    <div className="bg-white p-6 rounded-lg shadow-md">
      <h2 className="text-xl font-bold mb-4 flex items-center gap-2">
        <FileCheck className="h-5 w-5" />
        Sign & Store Document
      </h2>

      <div className="space-y-4">
        {documentHash && (
          <div className="bg-gray-50 p-3 rounded">
            <p className="text-xs text-gray-600 mb-1">Document Hash:</p>
            <p className="font-mono text-xs text-gray-800 break-all">{documentHash}</p>
          </div>
        )}

        {signature && (
          <div className="bg-green-50 p-3 rounded border border-green-200">
            <p className="text-xs text-green-700 mb-1">Signature:</p>
            <p className="font-mono text-xs text-green-800 break-all">{signature}</p>
          </div>
        )}

        {txHash && (
          <div className="bg-blue-50 p-3 rounded border border-blue-200">
            <p className="text-xs text-blue-700 mb-1">Transaction Hash:</p>
            <p className="font-mono text-xs text-blue-800 break-all">{txHash}</p>
          </div>
        )}

        {error && (
          <div className="bg-red-50 p-3 rounded border border-red-200">
            <p className="text-xs text-red-700">{error}</p>
          </div>
        )}

        <div className="flex gap-2">
          <button
            onClick={handleSign}
            disabled={!documentHash || isSigning || selectedWalletIndex === null}
            className="flex-1 px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors flex items-center justify-center gap-2"
          >
            {isSigning ? (
              <>
                <Loader2 className="h-4 w-4 animate-spin" />
                Signing...
              </>
            ) : (
              'Sign Document'
            )}
          </button>

          <button
            onClick={handleStore}
            disabled={!signature || isStoring || selectedWalletIndex === null}
            className="flex-1 px-4 py-2 bg-green-500 text-white rounded hover:bg-green-600 disabled:bg-gray-400 disabled:cursor-not-allowed transition-colors flex items-center justify-center gap-2"
          >
            {isStoring ? (
              <>
                <Loader2 className="h-4 w-4 animate-spin" />
                Storing...
              </>
            ) : (
              'Store on Blockchain'
            )}
          </button>
        </div>
      </div>
    </div>
  )
}

