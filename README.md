## Document Registry – ECDSA dApp

Proyecto completo para **registrar, firmar, verificar y consultar documentos** en una blockchain local usando **Foundry (Anvil)** y un contrato inteligente `DocumentRegistry`.

### 🔧 Stack principal

- `sc/` – Smart contracts (Foundry)
  - Solidity `DocumentRegistry` con:
    - `storeDocumentHash`, `verifyDocument`, `getDocumentInfo`
    - `getDocumentCount`, `getDocumentHashByIndex`, `isDocumentStored`
    - Firmas **ECDSA** (`bytes signature`) y verificación con `ecrecover`
  - Tests con `forge test` (todos pasando).

- `dapp/` – Frontend (Next.js 14 + TS + Tailwind + **Ethers.js v6**)
  - `MetaMaskContext.tsx` – Deriva 10 wallets desde el mnemonic de Anvil.
  - `useContract.ts` – Hook para interactuar con `DocumentRegistry`.
  - Componentes:
    - `FileUploader` – Sube archivo y calcula hash.
    - `DocumentSigner` – Firma ECDSA y almacena on‑chain.
    - `DocumentVerifier` – Verifica documentos.
    - `DocumentHistory` – Lista todos los documentos.
    - `WalletSelector` – Selector de wallet derivada.
  - Página principal con tabs: **Upload & Sign / Verify / History**.

---

### 🚀 Cómo ejecutar todo

1. **Levantar Anvil**

```bash
cd sc
anvil
```

2. **Desplegar el contrato en Anvil**

En otra terminal:

```bash
cd sc
forge script script/Deploy.s.sol:DeployAnvil --rpc-url http://127.0.0.1:8545 --broadcast
```

3. **Configurar variables de entorno del frontend**

En `dapp/.env.local`:

```env
NEXT_PUBLIC_RPC_URL=http://127.0.0.1:8545
NEXT_PUBLIC_DOCUMENT_REGISTRY_ADDRESS=0x5FbDB2315678afecb367f032d93F642f64180aa3
NEXT_PUBLIC_MNEMONIC=test test test test test test test test test test test junk
```

4. **Instalar dependencias del frontend**

```bash
cd dapp
npm install
```

5. **Levantar la dApp**

```bash
cd dapp
npm run dev
```

Abrir `http://localhost:3000`.

> También puedes usar los scripts de demo descritos en `dapp/DEMO-QUICK-START.md` y `dapp/DEMO.md`.

---

### ✅ Pruebas

#### Smart contracts

```bash
cd sc
forge test
```

Todos los tests de `DocumentRegistry` pasan (incluyendo verificación ECDSA y funciones de historial).

#### Frontend

```bash
cd dapp
npm run build
```

Compila sin errores de TypeScript ni de ESLint.

Detalles adicionales en:

- `PRUEBAS-REALIZADAS.md`
- `CAMBIOS-REALIZADOS.md`

---

### 📚 Documentación útil

- `dapp/README.md` – Guía completa de la dApp (stack, flujo, uso).
- `dapp/DEMO-QUICK-START.md` – Pasos rápidos para una demo.
- `dapp/DEMO.md` – Guion detallado de demo (paso a paso).
- `ANALISIS-TAREA.md` – Comparativa contra la tarea original y justificación de cambios.

---

### 📝 Estado respecto a la tarea

Según el enunciado original de **TAREA PARA ESTUDIANTE**:

- ✅ Contrato refactorizado con `signer`, `bytes signature`, funciones extra y optimización de gas.
?- ✅ Frontend migrado a Ethers.js v6, con componentes `FileUploader`, `DocumentSigner`, `DocumentVerifier`, `DocumentHistory`, `WalletSelector`.
- ✅ Flujo completo funcionando: **Upload → Sign → Store → Verify → History** con historial on‑chain.
- ✅ Pruebas de contrato actualizadas y pasando.

Para revisar rápidamente la implementación, empezar por:

- Contrato: `sc/src/DocumentRegistry.sol`
- Tests: `sc/test/DocumentRegistry.t.sol`
- Frontend: `dapp/app/page.tsx`, `dapp/contexts/MetaMaskContext.tsx`, `dapp/hooks/useContract.ts`


