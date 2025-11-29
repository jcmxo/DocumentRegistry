'use client'

import { useState } from 'react'
import { useMetaMask } from '@/contexts/MetaMaskContext'
import { Wallet, LogOut } from 'lucide-react'

export default function WalletSelector() {
  const { wallets, selectedWalletIndex, connect, disconnect } = useMetaMask()
  const [isConnecting, setIsConnecting] = useState(false)

  const handleConnect = async (index: number) => {
    setIsConnecting(true)
    try {
      await connect(index)
    } catch (error) {
      console.error('Error connecting wallet:', error)
      alert('Error connecting wallet. Please try again.')
    } finally {
      setIsConnecting(false)
    }
  }

  const handleDisconnect = () => {
    disconnect()
  }

  return (
    <div className="bg-white p-4 rounded-lg shadow-md">
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <Wallet className="h-5 w-5 text-gray-600" />
          <div>
            {selectedWalletIndex !== null ? (
              <>
                <p className="text-sm text-gray-600">Connected</p>
                <p className="font-mono text-sm text-gray-800 break-all">
                  Wallet {selectedWalletIndex}: {wallets[selectedWalletIndex]?.address}
                </p>
              </>
            ) : (
              <p className="text-sm text-gray-600">No wallet connected</p>
            )}
          </div>
        </div>

        {selectedWalletIndex !== null ? (
          <button
            onClick={handleDisconnect}
            className="px-4 py-2 bg-red-500 text-white rounded hover:bg-red-600 transition-colors flex items-center gap-2 text-sm"
          >
            <LogOut className="h-4 w-4" />
            Disconnect
          </button>
        ) : (
          <div className="flex gap-2">
            <select
              onChange={(e) => handleConnect(Number(e.target.value))}
              disabled={isConnecting}
              className="px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 text-sm"
              defaultValue=""
            >
              <option value="">Select Wallet</option>
              {wallets.map((wallet, index) => (
                <option key={index} value={index}>
                  Wallet {index}: {wallet.address.substring(0, 10)}...
                </option>
              ))}
            </select>
          </div>
        )}
      </div>
    </div>
  )
}

