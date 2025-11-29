'use client'

import { useAccount, useConnect, useDisconnect, useBalance } from 'wagmi'

export default function WalletConnector() {
  const { address, isConnected, connector } = useAccount()
  const { connectors, connect } = useConnect()
  const { disconnect } = useDisconnect()
  const { data: balance } = useBalance({
    address,
  })

  const injectedConnector = connectors.find((c) => c.id === 'injected' || c.type === 'injected')

  if (isConnected) {
    return (
      <div className="bg-white p-4 rounded-lg shadow-md">
        <div className="flex items-center justify-between">
          <div>
            <p className="text-sm text-gray-600">Connected</p>
            <p className="font-mono text-sm text-gray-800 break-all">
              {address}
            </p>
            {balance && (
              <p className="text-sm text-gray-600 mt-1">
                Balance: {parseFloat(balance.formatted).toFixed(4)} {balance.symbol}
              </p>
            )}
          </div>
          <button
            onClick={() => disconnect()}
            className="px-4 py-2 bg-red-500 text-white rounded hover:bg-red-600 transition-colors"
          >
            Disconnect
          </button>
        </div>
      </div>
    )
  }

  return (
    <div className="bg-white p-4 rounded-lg shadow-md">
      <p className="text-sm text-gray-600 mb-2">Connect your wallet to get started</p>
      {injectedConnector ? (
        <button
          onClick={() => connect({ connector: injectedConnector })}
          className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 transition-colors"
        >
          Connect Wallet
        </button>
      ) : (
        <p className="text-sm text-red-600">No wallet connector available. Please install MetaMask.</p>
      )}
    </div>
  )
}

