# Document Registry dApp

Una aplicación descentralizada (dApp) completa para interactuar con el contrato inteligente `DocumentRegistry` usando Next.js, TypeScript, Tailwind CSS, Wagmi y viem.

## 📋 Requisitos

Antes de comenzar, asegúrate de tener instalado:

- **Node.js** (versión 18 o superior)
- **npm** o **yarn**
- **Anvil** (Foundry) corriendo en `http://127.0.0.1:8545`
- El contrato `DocumentRegistry` desplegado en Anvil en la dirección:
  ```
  0x5FbDB2315678afecb367f032d93F642f64180aa3
  ```

## 🚀 Instalación

1. Navega a la carpeta `dapp/`:
   ```bash
   cd dapp
   ```

2. Instala las dependencias:
   ```bash
   npm install
   ```

## 🏃 Ejecución

Para iniciar el servidor de desarrollo:

```bash
npm run dev
```

La aplicación estará disponible en `http://localhost:3000`.

## 🔗 Configurar MetaMask para Anvil

Para conectar MetaMask a tu instancia local de Anvil:

1. **Abre MetaMask** y haz clic en el menú de redes (arriba a la izquierda).

2. **Selecciona "Add Network"** o "Agregar red".

3. **Agrega una red personalizada** con los siguientes datos:
   - **Network Name**: `Anvil Local`
   - **RPC URL**: `http://127.0.0.1:8545`
   - **Chain ID**: `31337`
   - **Currency Symbol**: `ETH`

4. **Importa una cuenta de Anvil**:
   - Cuando inicias Anvil, se muestran varias cuentas con sus private keys.
   - En MetaMask, ve a "Import Account" (Importar cuenta).
   - Pega una de las private keys de Anvil (por ejemplo, la primera cuenta que tiene 10000 ETH).
   - Ahora tendrás acceso a esa cuenta en MetaMask.

5. **Conecta la dApp**:
   - Asegúrate de que Anvil esté corriendo.
   - Abre la dApp en el navegador.
   - Haz clic en "Connect Wallet" en la interfaz.
   - MetaMask debería aparecer para confirmar la conexión.

## 📝 Uso de la dApp

### 1. Conectar Wallet

- Haz clic en el botón "Connect Wallet" en la parte superior.
- Acepta la conexión en MetaMask.
- Verás tu dirección conectada y el balance de ETH.

### 2. Registrar un Documento

1. En la tarjeta izquierda "Store Document":
   - Ingresa el contenido del documento en el campo de texto.
   - (Opcional) Ingresa una firma (por ejemplo, "firma-1").
   - Haz clic en "Store Document".

2. La aplicación:
   - Calcula automáticamente el hash `keccak256` del contenido.
   - Muestra el hash calculado.
   - Envía la transacción al contrato.
   - Muestra el estado: loading, éxito o error.
   - Si es exitoso, muestra el hash de la transacción.

### 3. Consultar un Documento

1. En la tarjeta derecha "Get Document Info":
   - Pega el hash del documento (formato: `0x...` con 64 caracteres hexadecimales).
   - Haz clic en "Get Document Info".

2. La aplicación mostrará:
   - **Hash**: El hash del documento.
   - **Owner**: La dirección que registró el documento.
   - **Timestamp**: Fecha y hora de registro (formateada).
   - **Signature**: La firma asociada (si existe).

3. Si el documento no existe:
   - Se mostrará un mensaje amigable indicando que el documento no fue encontrado.

## 🛠️ Scripts Disponibles

- `npm run dev` - Inicia el servidor de desarrollo
- `npm run build` - Construye la aplicación para producción
- `npm run start` - Inicia el servidor de producción
- `npm run lint` - Ejecuta el linter de código

## 📁 Estructura del Proyecto

```
dapp/
├── app/
│   ├── layout.tsx          # Layout principal con WagmiProvider
│   ├── page.tsx             # Página principal
│   └── globals.css          # Estilos globales con Tailwind
├── components/
│   ├── WalletConnector.tsx  # Componente para conectar/desconectar wallet
│   ├── StoreDocumentForm.tsx # Formulario para registrar documentos
│   └── GetDocumentForm.tsx   # Formulario para consultar documentos
├── lib/
│   ├── web3.tsx              # Configuración de Wagmi y viem
│   └── documentRegistry.ts  # ABI y dirección del contrato
├── package.json
├── tsconfig.json
├── tailwind.config.js
└── README.md
```

## 🔧 Configuración

### Dirección del Contrato

La dirección del contrato se puede configurar mediante la variable de entorno:

```bash
NEXT_PUBLIC_DOCUMENT_REGISTRY_ADDRESS=0x5FbDB2315678afecb367f032d93F642f64180aa3
```

Por defecto, usa la dirección: `0x5FbDB2315678afecb367f032d93F642f64180aa3`

### Chain y RPC

La aplicación está configurada para usar:
- **Chain ID**: 31337 (Anvil)
- **RPC URL**: `http://127.0.0.1:8545`

Estos valores están configurados en `lib/web3.tsx`.

## 🐛 Solución de Problemas

### MetaMask no se conecta

- Asegúrate de que Anvil esté corriendo.
- Verifica que MetaMask esté configurado para usar la red Anvil (Chain ID 31337).
- Revisa la consola del navegador para ver errores.

### Error al registrar documento

- Verifica que tu wallet tenga suficiente ETH para gas.
- Asegúrate de que el contrato esté desplegado en la dirección correcta.
- Revisa que no estés intentando registrar un documento que ya existe.

### Error al consultar documento

- Verifica que el hash tenga el formato correcto (`0x` seguido de 64 caracteres hexadecimales).
- Asegúrate de que el documento haya sido registrado previamente.

## 📚 Tecnologías Utilizadas

- **Next.js 14** - Framework React con App Router
- **TypeScript** - Tipado estático
- **Tailwind CSS** - Estilos utilitarios
- **Wagmi v2** - Hooks de React para Ethereum
- **viem** - Cliente Ethereum TypeScript
- **@tanstack/react-query** - Manejo de estado del servidor

## 📄 Licencia

MIT

