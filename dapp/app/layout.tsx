import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { Web3Provider } from '@/lib/web3'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Document Registry dApp',
  description: 'Register and query document hashes on the blockchain',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <Web3Provider>
          {children}
        </Web3Provider>
      </body>
    </html>
  )
}

