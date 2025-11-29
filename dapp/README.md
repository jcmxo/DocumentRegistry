🚀 Document Registry dApp  
DApp completa para **registro, firma ECDSA, verificación y consulta de documentos** en blockchain.

Una aplicación descentralizada que permite almacenar y verificar documentos en la blockchain usando un contrato inteligente propio (`DocumentRegistry`), construida con:

- Next.js 14 (App Router)
- React + TypeScript
- **Ethers.js v6** (sin Wagmi)
- Tailwind CSS
- Foundry (Anvil)

🏁 Características Principales

- ✔ Registro seguro de documentos por **hash** en la blockchain
- ✔ Firmas digitales **ECDSA** (se firma el hash del documento)
- ✔ Verificación on‑chain de firmas usando `ecrecover`
- ✔ Historial completo de documentos almacenados
- ✔ Flujo completo: **Upload → Sign → Store → Verify → History**
- ✔ Wallets derivadas automáticamente desde el **mnemonic de Anvil**
- ✔ Integración total con Anvil (Foundry)
- ✔ UI moderna y responsiva
- ✔ Código modular y fácil de escalar

📦 Requisitos

Asegúrate de tener instalado:

Requisito	Versión
Node.js	≥ 18
npm o yarn	Cualquiera
Foundry	anvil para red local
MetaMask	Última versión

Además, necesitas Anvil corriendo en:

`http://127.0.0.1:8545`

Y tu contrato `DocumentRegistry` desplegado en Anvil.

**Nota:** La dirección del contrato puede variar según el despliegue.  
Ejemplo de dirección típica al usar `DeployAnvil`:

`0x5FbDB2315678afecb367f032d93F642f64180aa3`

Si redesplegas el contrato, actualiza la dirección en `.env.local`.

⚙️ Instalación

1. **Instalar dependencias:**
```bash
cd dapp
npm install
```

2. **Desplegar el contrato en Anvil (si aún no está desplegado):**
```bash
# Desde la raíz del proyecto
cd sc
forge script script/Deploy.s.sol:DeployAnvil --rpc-url http://127.0.0.1:8545 --broadcast
```

3. **Configurar variables de entorno:**

Crea un archivo `.env.local` en la carpeta `dapp/` con la dirección del contrato desplegado:

```env
NEXT_PUBLIC_RPC_URL=http://127.0.0.1:8545
NEXT_PUBLIC_DOCUMENT_REGISTRY_ADDRESS=<dirección_del_contrato_desplegado>
NEXT_PUBLIC_MNEMONIC=test test test test test test test test test test test junk
```

▶️ Ejecución de la dApp

**Opción 1: Script automático (recomendado)**

Windows (CMD/PowerShell):
```bash
cd dapp
iniciar-demo.bat
```

Linux/Mac/WSL:
```bash
cd dapp
./iniciar-demo.sh
```

El script verificará automáticamente:
- ✅ Anvil está corriendo
- ✅ Contrato desplegado
- ✅ Dependencias instaladas
- ✅ Abrirá el navegador automáticamente

**Opción 2: Manual**

Inicia el servidor de desarrollo:
```bash
npm run dev
```

Luego visita: **http://localhost:3000**

🔗 Configuración de MetaMask con Anvil

MetaMask no es estrictamente necesaria para que la dApp funcione (las wallets se derivan del mnemonic de Anvil y se usan con Ethers.js), pero es muy útil para inspeccionar transacciones y balances.

1. **Agregar red personalizada**

Abrir MetaMask → Networks → Add Network

Campo | Valor
-----|------
Network Name | Anvil Local
RPC URL | `http://127.0.0.1:8545`
Chain ID | `31337`
Currency | `ETH`

2. **Importar una cuenta de Anvil (opcional)**

Desde tu terminal, Anvil muestra cuentas como:

- (0) `0xf39F...`  
  Private Key: `0xac09...`

En MetaMask: **Import Account → pegar private key**.

3. **Relación con la dApp**

La dApp **no depende** de la extensión de MetaMask para firmar. En su lugar:

- Deriva 10 wallets usando `NEXT_PUBLIC_MNEMONIC` (el mnemonic de Anvil).
- Ofrece un selector de wallet en el UI (Wallet 0–9).
- Todas las firmas y transacciones se hacen con **Ethers.js v6**.

📝 Cómo usar la dApp

1️⃣ Seleccionar Wallet

- En la parte superior, haz clic en **“Select Wallet”**.
- Elige una wallet (`Wallet 0`, `Wallet 1`, etc.).
- Verás el estado **Connected** y la dirección de la wallet.

2️⃣ Subir y Firmar un Documento

Pestaña **Upload & Sign**:

- Haz clic en el área de upload o arrastra un archivo.
- Se calcula automáticamente el **hash SHA‑256** del archivo.
- Pulsa **“Sign Document”**.
  - Se genera una firma ECDSA con la wallet seleccionada.
  - Verás un mensaje: *“Document signed successfully!”*.

3️⃣ Guardar en la Blockchain

- Pulsa **“Store on Blockchain”**.
- Se envía una transacción a `storeDocumentHash(hash, timestamp, signature, signer)`.
- Cuando se confirma, verás:
  - 🟢 *“Document stored successfully!”* y el **TX Hash**.

4️⃣ Verificar un Documento

Pestaña **Verify**:

- Sube el mismo archivo o pega el hash manualmente.
- Introduce la dirección del signer (por ejemplo, Wallet 0).
- Pulsa **“Verify Document”**.

La dApp:

- Recupera la información con `getDocumentInfo(hash)`.
- Llama a `verifyDocument(hash, signer, signature)` en el contrato.
- Muestra:
  - ✅ **Document is VALID** si la firma coincide.
  - ❌ **Document is INVALID** si no existe o no coincide.

5️⃣ Ver Historial de Documentos

Pestaña **History**:

- Pulsa **“Refresh”**.
- La dApp llama a `getDocumentCount()` y `getDocumentHashByIndex()` para cada índice.
- Recupera cada documento con `getDocumentInfo(hash)`.
- Muestra:
  - Hash
  - Signer
  - Timestamp (formateado)
  - Tamaño de la firma (bytes)

📁 Estructura del Proyecto

`dapp/`

- `app/`
  - `layout.tsx` – Layout principal con `MetaMaskProvider`
  - `page.tsx` – Página principal con tabs (**Upload & Sign / Verify / History**)
  - `globals.css` – Estilos globales Tailwind
- `components/`
  - `FileUploader.tsx` – Subida de archivo y cálculo de hash
  - `DocumentSigner.tsx` – Firma ECDSA y almacenamiento on‑chain
  - `DocumentVerifier.tsx` – Verificación de documentos
  - `DocumentHistory.tsx` – Historial completo de documentos
  - `WalletSelector.tsx` – Selector de wallet derivada del mnemonic
- `contexts/`
  - `MetaMaskContext.tsx` – Deriva wallets desde `NEXT_PUBLIC_MNEMONIC` y expone `provider`, `signer`, etc.
- `hooks/`
  - `useContract.ts` – Hook de alto nivel para interactuar con `DocumentRegistry` usando Ethers.js v6
- `lib/`
  - `documentRegistry.ts` – Dirección del contrato + ABI completo
- `.env.local` – Variables de entorno (no se sube a git)
- `package.json` – Dependencias del proyecto
- `tsconfig.json` – Configuración TypeScript
- `next.config.js` – Configuración Next.js
- `tailwind.config.js` – Configuración Tailwind CSS
- `iniciar-dapp.bat` – Script básico para iniciar la dApp (Windows)
- `iniciar-demo.bat` – Script completo para demo con verificaciones (Windows)
- `iniciar-demo.sh` – Script completo para demo con verificaciones (Linux/Mac/WSL)
- `crear-acceso-directo.vbs` – Script para crear acceso directo (Windows)
- `clean-cache.sh` – Script para limpiar caché de Next.js
- `README.md` – Este archivo
- `TEST_RESULTS.md` – Resultados de pruebas
- `FIX_CACHE.md` – Guía para solucionar problemas de caché

🧠 Descripción del Contrato

El contrato `DocumentRegistry` administra documentos por hash y firma ECDSA:

- `storeDocumentHash(bytes32 _hash, uint256 _timestamp, bytes _signature, address _signer)`
  - Guarda un documento único por hash.
  - Registra:
    - `hash` – hash del documento (`bytes32`).
    - `timestamp` – marca de tiempo de registro.
    - `signer` – dirección que firmó el documento.
    - `signature` – firma ECDSA (`bytes`).
  - Previene duplicados mediante el modificador `documentNotExists`.

- `getDocumentInfo(bytes32 _hash) → Document`
  - Devuelve la `struct Document` con:
    - `hash`
    - `timestamp`
    - `signer`
    - `signature`

- `verifyDocument(bytes32 _hash, address _signer, bytes _signature) → bool`
  - Verifica la firma ECDSA usando `ecrecover`.
  - Devuelve `true` si:
    - El documento existe.
    - El signer recuperado coincide con `_signer` y con el signer almacenado.

- `getDocumentCount()` y `getDocumentHashByIndex(uint256)`
  - Permiten iterar sobre todos los documentos (se usan en la pestaña **History**).

🧩 Variables de Entorno

Crea (o actualiza) un archivo `.env.local` en la carpeta `dapp/` con:

```env
NEXT_PUBLIC_RPC_URL=http://127.0.0.1:8545
NEXT_PUBLIC_DOCUMENT_REGISTRY_ADDRESS=0x5FbDB2315678afecb367f032d93F642f64180aa3
NEXT_PUBLIC_MNEMONIC=test test test test test test test test test test test junk
```

**Importante:** Si redesplegas el contrato en Anvil, actualiza `NEXT_PUBLIC_DOCUMENT_REGISTRY_ADDRESS` con la nueva dirección.

Para desplegar el contrato:
```bash
cd sc
forge script script/Deploy.s.sol:DeployAnvil --rpc-url http://127.0.0.1:8545 --broadcast
```

❗ Solución de Problemas
❌ MetaMask no conecta

Verifica que Anvil está corriendo

MetaMask debe estar en red 31337

Revisa la consola del navegador

❌ Error al guardar documento

Intentas registrar el mismo hash dos veces

Tu wallet no tiene ETH

RPC incorrecto

❌ Error al consultar

Hash mal formateado

Documento no existe

❌ "Contract code is empty" o "returned no data"

El contrato no está desplegado en la dirección configurada. Despliega el contrato:

```bash
cd sc
forge script script/Deploy.s.sol:DeployAnvil --rpc-url http://127.0.0.1:8545 --broadcast
```

Luego actualiza la dirección en `.env.local` con la dirección mostrada en el output.

📚 Tecnologías Utilizadas

- Next.js 14 (App Router)
- React + TypeScript
- **Ethers.js v6**
- TailwindCSS
- Foundry + Anvil

📄 Licencia

MIT — Puedes usar, modificar y compartir libremente.