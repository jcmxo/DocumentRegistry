'use client'

import { useMemo } from 'react'
import { ethers } from 'ethers'
import { useMetaMask } from '@/contexts/MetaMaskContext'
import { DOCUMENT_REGISTRY_ADDRESS, documentRegistryAbi, type Document } from '@/lib/documentRegistry'

export function useContract() {
  const { provider, signer } = useMetaMask()

  const contract = useMemo(() => {
    if (!provider) return null
    return new ethers.Contract(DOCUMENT_REGISTRY_ADDRESS, documentRegistryAbi, provider) as ethers.Contract & {
      storeDocumentHash: (hash: string, timestamp: number, signature: Uint8Array, signerAddress: string) => Promise<ethers.ContractTransactionResponse>
      verifyDocument: (hash: string, signerAddress: string, signature: string) => Promise<boolean>
      getDocumentInfo: (hash: string) => Promise<Document>
      isDocumentStored: (hash: string) => Promise<boolean>
      getDocumentCount: () => Promise<bigint>
      getDocumentHashByIndex: (index: number) => Promise<string>
    }
  }, [provider])

  const contractWithSigner = useMemo(() => {
    if (!contract || !signer) return null
    return contract.connect(signer) as typeof contract
  }, [contract, signer])

  const storeDocumentHash = async (
    hash: string,
    timestamp: number,
    signature: Uint8Array | string,
    signerAddress: string
  ) => {
    if (!contractWithSigner) {
      throw new Error('Contract not connected or signer not available')
    }

    try {
      // Convert signature to bytes if it's a string
      const signatureBytes = typeof signature === 'string' 
        ? ethers.getBytes(signature)
        : signature

      const tx = await contractWithSigner.storeDocumentHash(
        hash,
        timestamp,
        signatureBytes,
        signerAddress
      )
      return tx
    } catch (error) {
      console.error('Error storing document:', error)
      throw error
    }
  }

  const verifyDocument = async (
    hash: string,
    signerAddress: string,
    signature: string
  ): Promise<boolean> => {
    if (!contract) {
      throw new Error('Contract not connected')
    }

    try {
      const isValid = await contract.verifyDocument(hash, signerAddress, signature)
      return isValid
    } catch (error) {
      console.error('Error verifying document:', error)
      throw error
    }
  }

  const getDocumentInfo = async (hash: string): Promise<Document> => {
    if (!contract) {
      throw new Error('Contract not connected')
    }

    try {
      const doc = await contract.getDocumentInfo(hash)
      return {
        hash: doc.hash,
        timestamp: doc.timestamp,
        signer: doc.signer,
        signature: ethers.hexlify(doc.signature),
      }
    } catch (error) {
      console.error('Error getting document info:', error)
      throw error
    }
  }

  const isDocumentStored = async (hash: string): Promise<boolean> => {
    if (!contract) {
      throw new Error('Contract not connected')
    }

    try {
      return await contract.isDocumentStored(hash)
    } catch (error) {
      console.error('Error checking if document is stored:', error)
      throw error
    }
  }

  const getDocumentCount = async (): Promise<number> => {
    if (!contract) {
      throw new Error('Contract not connected')
    }

    try {
      const count = await contract.getDocumentCount()
      return Number(count)
    } catch (error) {
      console.error('Error getting document count:', error)
      throw error
    }
  }

  const getDocumentHashByIndex = async (index: number): Promise<string> => {
    if (!contract) {
      throw new Error('Contract not connected')
    }

    try {
      return await contract.getDocumentHashByIndex(index)
    } catch (error) {
      console.error('Error getting document hash by index:', error)
      throw error
    }
  }

  return {
    contract,
    contractWithSigner,
    storeDocumentHash,
    verifyDocument,
    getDocumentInfo,
    isDocumentStored,
    getDocumentCount,
    getDocumentHashByIndex,
  }
}

