'use client'

import { useState, useRef } from 'react'
import { Upload } from 'lucide-react'

interface FileUploaderProps {
  onFileSelect: (file: File) => void
  onHashCalculated: (hash: string) => void
  disabled?: boolean
}

export default function FileUploader({ onFileSelect, onHashCalculated, disabled }: FileUploaderProps) {
  const [selectedFile, setSelectedFile] = useState<File | null>(null)
  const [hash, setHash] = useState<string | null>(null)
  const [isCalculating, setIsCalculating] = useState(false)
  const fileInputRef = useRef<HTMLInputElement>(null)

  const calculateHash = async (file: File) => {
    setIsCalculating(true)
    try {
      const arrayBuffer = await file.arrayBuffer()
      const hashBuffer = await crypto.subtle.digest('SHA-256', arrayBuffer)
      const hashArray = Array.from(new Uint8Array(hashBuffer))
      const hashHex = '0x' + hashArray.map(b => b.toString(16).padStart(2, '0')).join('')
      setHash(hashHex)
      onHashCalculated(hashHex)
    } catch (error) {
      console.error('Error calculating hash:', error)
      alert('Error calculating hash. Please try again.')
    } finally {
      setIsCalculating(false)
    }
  }

  const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (file) {
      setSelectedFile(file)
      onFileSelect(file)
      calculateHash(file)
    }
  }

  const handleDrop = (e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault()
    const file = e.dataTransfer.files?.[0]
    if (file) {
      setSelectedFile(file)
      onFileSelect(file)
      calculateHash(file)
    }
  }

  const handleDragOver = (e: React.DragEvent<HTMLDivElement>) => {
    e.preventDefault()
  }

  return (
    <div className="space-y-4">
      <div
        onDrop={handleDrop}
        onDragOver={handleDragOver}
        className={`border-2 border-dashed rounded-lg p-8 text-center transition-colors ${
          disabled
            ? 'border-gray-300 bg-gray-50 cursor-not-allowed'
            : 'border-gray-400 hover:border-blue-500 cursor-pointer'
        }`}
        onClick={() => !disabled && fileInputRef.current?.click()}
      >
        <Upload className="mx-auto h-12 w-12 text-gray-400 mb-4" />
        <p className="text-sm text-gray-600 mb-2">
          {selectedFile ? selectedFile.name : 'Click to upload or drag and drop'}
        </p>
        <p className="text-xs text-gray-500">PDF, DOC, TXT, or any file type</p>
        <input
          ref={fileInputRef}
          type="file"
          onChange={handleFileChange}
          className="hidden"
          disabled={disabled}
        />
      </div>

      {isCalculating && (
        <div className="text-sm text-gray-600 text-center">
          Calculating hash...
        </div>
      )}

      {hash && !isCalculating && (
        <div className="bg-gray-50 p-3 rounded">
          <p className="text-xs text-gray-600 mb-1">Document Hash:</p>
          <p className="font-mono text-xs text-gray-800 break-all">{hash}</p>
        </div>
      )}
    </div>
  )
}

