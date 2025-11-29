# 🎬 Guía de Demo - Document Registry dApp

Esta guía te ayudará a realizar una demostración completa de la dApp Document Registry.

## 📋 Checklist Pre-Demo

Antes de comenzar la demo, verifica:

- [ ] **Anvil está corriendo** en `http://127.0.0.1:8545`
- [ ] **Contrato desplegado** en Anvil
- [ ] **MetaMask configurado** con la red Anvil (Chain ID 31337)
- [ ] **Cuenta de Anvil importada** en MetaMask
- [ ] **dApp instalada** (`npm install` completado)
- [ ] **Servidor de desarrollo corriendo** (`npm run dev`)

## 🚀 Inicio Rápido

### 1. Iniciar Anvil (si no está corriendo)

```bash
# En una terminal
anvil
```

**Verifica que veas:**
```
Available Accounts
==================
(0) 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 (10000 ETH)
...
```

### 2. Desplegar el Contrato (si no está desplegado)

```bash
cd sc
forge script script/Deploy.s.sol:DeployAnvil --rpc-url http://127.0.0.1:8545 --broadcast
```

**Copia la dirección del contrato desplegado** (ej: `0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9`)

### 3. Configurar Variables de Entorno

```bash
cd dapp
cat > .env.local << EOF
NEXT_PUBLIC_RPC_URL=http://127.0.0.1:8545
NEXT_PUBLIC_DOCUMENT_REGISTRY_ADDRESS=<DIRECCION_DEL_CONTRATO>
EOF
```

### 4. Iniciar la dApp

```bash
cd dapp
npm run dev
```

Abre: **http://localhost:3000**

## 🎯 Script de Demo (Paso a Paso)

### **Paso 1: Conectar Wallet** ⏱️ 1 min

1. Abre la dApp en el navegador
2. Haz clic en **"Connect Wallet"**
3. MetaMask se abrirá automáticamente
4. Selecciona la cuenta de Anvil (debe tener 10,000 ETH)
5. Confirma la conexión

**✅ Resultado esperado:**
- Ver dirección conectada: `0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266`
- Ver balance: `10000.0000 ETH` (o similar)
- Botón "Disconnect" visible

---

### **Paso 2: Registrar un Documento** ⏱️ 2 min

1. En el formulario **"Store Document"** (izquierda):
   - **Document Content:** Ingresa: `"Contrato de trabajo - Juan Pérez - 2025"`
   - **Signature (optional):** Ingresa: `"HR-2025-001"`
2. Observa que aparece el **"Computed Hash"** automáticamente
3. Haz clic en **"Store Document"**
4. MetaMask se abrirá para confirmar la transacción
5. Confirma la transacción en MetaMask
6. Espera la confirmación (pocos segundos)

**✅ Resultado esperado:**
- Mensaje verde: "Document stored successfully!"
- TX Hash visible
- Hash computado visible (ej: `0x204558076efb2042ebc9b034aab36d85d672d8ac1fa809288da5b453a4714aae`)

**💡 Puntos a destacar:**
- El hash se calcula automáticamente con `keccak256`
- La transacción se confirma en segundos (Anvil es instantáneo)
- El documento queda registrado en la blockchain

---

### **Paso 3: Consultar el Documento** ⏱️ 1 min

1. En el formulario **"Get Document Info"** (derecha):
   - Copia el hash del campo "Computed Hash" del paso anterior
   - Pégalo en el campo "Document Hash"
   - Haz clic en **"Get Document Info"**

**✅ Resultado esperado:**
- Caja verde con la información del documento:
  - **Hash:** El hash del documento
  - **Owner:** `0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266` (tu dirección)
  - **Timestamp:** Fecha y hora de registro
  - **Signature:** `"HR-2025-001"` (la firma que ingresaste)

**💡 Puntos a destacar:**
- Los datos se leen directamente de la blockchain
- El timestamp muestra cuándo se registró
- La información es inmutable y verificable

---

### **Paso 4: Probar Casos Especiales** ⏱️ 2 min

#### 4.1. Documento sin Firma
1. Registra un nuevo documento:
   - **Content:** `"Documento sin firma"`
   - **Signature:** (dejar vacío)
2. Consulta el documento
3. **✅ Verifica:** Signature muestra `"(empty)"`

#### 4.2. Documento Duplicado
1. Intenta registrar el mismo contenido otra vez
2. **✅ Verifica:** Error: "Document already exists" o transacción revertida

#### 4.3. Documento No Encontrado
1. Consulta un hash que no existe (ej: `0x0000000000000000000000000000000000000000000000000000000000000000`)
2. **✅ Verifica:** Mensaje: "Document not found"

---

## 🎤 Puntos Clave para la Presentación

### **Tecnologías Utilizadas**
- ✅ **Next.js 14** - Framework React moderno
- ✅ **TypeScript** - Type safety
- ✅ **Wagmi v2** - React hooks para Ethereum
- ✅ **Viem** - Biblioteca de utilidades Ethereum
- ✅ **Tailwind CSS** - Estilos modernos
- ✅ **Foundry/Anvil** - Desarrollo local de smart contracts

### **Características Destacadas**
- ✅ **Cálculo automático de hash** con keccak256
- ✅ **Validación de formularios** en tiempo real
- ✅ **Manejo de errores** amigable
- ✅ **UI responsiva** y moderna
- ✅ **Transacciones instantáneas** en Anvil
- ✅ **Lectura directa de la blockchain**

### **Arquitectura**
- ✅ **Separación de responsabilidades**: Componentes, lógica, configuración
- ✅ **Type safety** completo con TypeScript
- ✅ **Configuración flexible** con variables de entorno
- ✅ **Código modular** y fácil de escalar

---

## 🐛 Solución Rápida de Problemas

### ❌ "Contract code is empty"
**Solución:** El contrato no está desplegado. Despliega con:
```bash
cd sc
forge script script/Deploy.s.sol:DeployAnvil --rpc-url http://127.0.0.1:8545 --broadcast
```

### ❌ MetaMask no conecta
**Solución:** 
- Verifica que Anvil esté corriendo
- Verifica que MetaMask esté en la red "Anvil Local" (Chain ID 31337)
- Recarga la página

### ❌ "Document not found" al consultar
**Solución:**
- Verifica que el hash tenga el prefijo `0x`
- Verifica que el hash tenga exactamente 66 caracteres (0x + 64 hex)
- Asegúrate de que el documento se haya almacenado correctamente

### ❌ Error al almacenar documento
**Solución:**
- Verifica que tengas ETH en la cuenta (Anvil da 10,000 ETH por defecto)
- Verifica que no estés intentando almacenar un hash duplicado
- Revisa la consola del navegador para más detalles

---

## 📊 Datos de Ejemplo para la Demo

### Documento 1: Contrato de Trabajo
- **Content:** `"Contrato de trabajo - Juan Pérez - 2025"`
- **Signature:** `"HR-2025-001"`

### Documento 2: Certificado
- **Content:** `"Certificado de estudios - María García - Universidad XYZ"`
- **Signature:** `"CERT-2025-042"`

### Documento 3: Sin Firma
- **Content:** `"Documento de prueba sin firma"`
- **Signature:** (vacío)

---

## ✅ Checklist Post-Demo

Después de la demo, verifica:
- [ ] Todos los documentos se almacenaron correctamente
- [ ] Todos los documentos se consultaron correctamente
- [ ] Los errores se manejaron apropiadamente
- [ ] La UI se ve bien en diferentes tamaños de pantalla

---

## 🎬 Duración Estimada de la Demo

- **Setup inicial:** 2-3 minutos
- **Demo básica (conectar + almacenar + consultar):** 4-5 minutos
- **Casos especiales:** 2-3 minutos
- **Total:** ~10 minutos

---

## 📝 Notas Adicionales

- **Anvil es instantáneo:** Las transacciones se confirman inmediatamente
- **Estado persistente:** Si reinicias Anvil, perderás los documentos (es normal en desarrollo)
- **MetaMask warnings:** Es normal ver advertencias de Blockaid en desarrollo local (son falsos positivos)
- **Balance:** Anvil da 10,000 ETH por defecto a cada cuenta, suficiente para miles de transacciones

---

¡Buena suerte con tu demo! 🚀

