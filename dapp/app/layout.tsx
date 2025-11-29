import type { Metadata } from 'next'
import { Inter } from 'next/font/google'
import './globals.css'
import { MetaMaskProvider } from '@/contexts/MetaMaskContext'

const inter = Inter({ subsets: ['latin'] })

export const metadata: Metadata = {
  title: 'Document Registry dApp',
  description: 'Register and verify document hashes with ECDSA signatures on the blockchain',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <MetaMaskProvider>
          {children}
        </MetaMaskProvider>
      </body>
    </html>
  )
}

