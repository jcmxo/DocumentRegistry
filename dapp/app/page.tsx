import WalletConnector from '@/components/WalletConnector'
import StoreDocumentForm from '@/components/StoreDocumentForm'
import GetDocumentForm from '@/components/GetDocumentForm'

export default function Home() {
  return (
    <main className="min-h-screen bg-gray-100 py-8 px-4">
      <div className="max-w-6xl mx-auto">
        <h1 className="text-4xl font-bold text-center mb-8 text-gray-800">
          Document Registry dApp
        </h1>

        <div className="mb-6">
          <WalletConnector />
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          <div>
            <StoreDocumentForm />
          </div>
          <div>
            <GetDocumentForm />
          </div>
        </div>
      </div>
    </main>
  )
}

