'use client'

import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react'
import { ethers } from 'ethers'

interface Wallet {
  address: string
  privateKey: string
}

interface MetaMaskContextType {
  wallets: Wallet[]
  selectedWalletIndex: number | null
  provider: ethers.JsonRpcProvider | null
  signer: ethers.Wallet | null
  connect: (walletIndex: number) => Promise<void>
  disconnect: () => void
  signMessage: (message: string) => Promise<string>
  getSigner: () => ethers.Wallet | null
  switchWallet: (walletIndex: number) => Promise<void>
}

const MetaMaskContext = createContext<MetaMaskContextType | undefined>(undefined)

// Anvil default mnemonic
const ANVIL_MNEMONIC = process.env.NEXT_PUBLIC_MNEMONIC || 
  "test test test test test test test test test test test junk"

// RPC URL
const RPC_URL = process.env.NEXT_PUBLIC_RPC_URL || 'http://localhost:8545'

export function MetaMaskProvider({ children }: { children: ReactNode }) {
  const [wallets, setWallets] = useState<Wallet[]>([])
  const [selectedWalletIndex, setSelectedWalletIndex] = useState<number | null>(null)
  const [provider, setProvider] = useState<ethers.JsonRpcProvider | null>(null)
  const [signer, setSigner] = useState<ethers.Wallet | null>(null)

  // Derive wallets from mnemonic on mount
  useEffect(() => {
    try {
      const derivedWallets: Wallet[] = []
      for (let i = 0; i < 10; i++) {
        const path = `m/44'/60'/0'/0/${i}`
        const wallet = ethers.HDNodeWallet.fromPhrase(ANVIL_MNEMONIC, undefined, path)
        derivedWallets.push({
          address: wallet.address,
          privateKey: wallet.privateKey,
        })
      }
      setWallets(derivedWallets)

      // Create provider
      const jsonRpcProvider = new ethers.JsonRpcProvider(RPC_URL)
      setProvider(jsonRpcProvider)
    } catch (error) {
      console.error('Error deriving wallets:', error)
    }
  }, [])

  const connect = async (walletIndex: number) => {
    if (!provider || walletIndex < 0 || walletIndex >= wallets.length) {
      throw new Error('Invalid wallet index or provider not available')
    }

    try {
      const wallet = wallets[walletIndex]
      // Create wallet instance with provider to get a signer
      const walletInstance = new ethers.Wallet(wallet.privateKey, provider)
      
      setSelectedWalletIndex(walletIndex)
      setSigner(walletInstance)
    } catch (error) {
      console.error('Error connecting wallet:', error)
      throw error
    }
  }

  const disconnect = () => {
    setSelectedWalletIndex(null)
    setSigner(null)
  }

  const signMessage = async (message: string): Promise<string> => {
    if (!signer) {
      throw new Error('No wallet connected')
    }

    try {
      const signature = await signer.signMessage(message)
      return signature
    } catch (error) {
      console.error('Error signing message:', error)
      throw error
    }
  }

  const getSigner = (): ethers.Wallet | null => {
    return signer
  }

  const switchWallet = async (walletIndex: number) => {
    await connect(walletIndex)
  }

  return (
    <MetaMaskContext.Provider
      value={{
        wallets,
        selectedWalletIndex,
        provider,
        signer,
        connect,
        disconnect,
        signMessage,
        getSigner,
        switchWallet,
      }}
    >
      {children}
    </MetaMaskContext.Provider>
  )
}

export function useMetaMask() {
  const context = useContext(MetaMaskContext)
  if (context === undefined) {
    throw new Error('useMetaMask must be used within a MetaMaskProvider')
  }
  return context
}

