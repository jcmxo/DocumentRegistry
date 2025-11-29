# 📊 Análisis: Qué falta según la Tarea

Comparación entre el proyecto actual y los requisitos de la tarea: [TAREA PARA ESTUDIANTE](https://github.com/codecrypto-academy/documentSignStorage/blob/main/TAREA%20PARA%20ESTUDIANTE.md)

---

## 🔴 FASE 1: Smart Contracts - FALTANTE

### ❌ Estructura del Contrato

**Requisito de la tarea:**
```solidity
struct Document {
    bytes32 hash;
    uint256 timestamp;
    address signer;      // ❌ Actualmente es "owner"
    bytes signature;     // ❌ Actualmente es "string signature"
}
```

**Estado actual:**
- ✅ Tiene `hash`, `timestamp`
- ❌ Tiene `owner` en lugar de `signer`
- ❌ Tiene `string signature` en lugar de `bytes signature`

### ❌ Optimización de Gas

**Requisito de la tarea:**
- ❌ NO usar campo `bool exists` (redundante)
- ❌ NO usar mapping `hashExists` separado (redundante)
- ✅ Usar `documents[hash].signer != address(0)` para verificar existencia

**Estado actual:**
- ❌ Tiene mapping `documentExists` (redundante, ~39% más gas)
- ❌ No usa optimización con `signer != address(0)`

### ❌ Funciones Faltantes

**Requisito de la tarea:**
1. ✅ `storeDocumentHash()` - Parcialmente (falta `signer` y `bytes signature`)
2. ❌ `verifyDocument(bytes32 hash, address signer, bytes signature)` - **FALTA COMPLETAMENTE**
3. ✅ `getDocumentInfo()` - Existe pero con estructura diferente
4. ✅ `isDocumentStored()` - Existe
5. ❌ `getDocumentCount()` - **FALTA**
6. ❌ `getDocumentHashByIndex(uint256 index)` - **FALTA**

**Estado actual:**
- Solo tiene: `storeDocument()`, `getDocumentInfo()`, `isDocumentStored()`, `storeMultiple()`

### ❌ Modifiers Faltantes

**Requisito de la tarea:**
```solidity
modifier documentNotExists(bytes32 _hash) {
    require(documents[_hash].signer == address(0), "Document already exists");
    _;
}

modifier documentExists(bytes32 _hash) {
    require(documents[_hash].signer != address(0), "Document does not exist");
    _;
}
```

**Estado actual:**
- ❌ No tiene modifiers

### ❌ Verificación de Firmas ECDSA

**Requisito de la tarea:**
- Función `verifyDocument()` que verifica firma ECDSA usando `ecrecover()`

**Estado actual:**
- ❌ No tiene verificación de firmas criptográficas
- Solo almacena `string signature` (no es una firma ECDSA real)

---

## 🔴 FASE 2: Frontend dApp - FALTANTE

### ❌ Stack Tecnológico Diferente

**Requisito de la tarea:**
- ✅ Next.js 14
- ✅ TypeScript
- ✅ Tailwind CSS
- ❌ **Ethers.js v6** (requerido)
- ❌ **lucide-react** (iconos)

**Estado actual:**
- ❌ Usa **Wagmi v2** + **viem** (diferente a lo requerido)
- ❌ No usa Ethers.js v6
- ❌ No tiene lucide-react

### ❌ Context Provider para Wallets

**Requisito de la tarea:**
- Archivo: `dapp/contexts/MetaMaskContext.tsx`
- Derivar wallets desde mnemonic de Anvil
- Usar `JsonRpcProvider` (no BrowserProvider)
- Funciones: `connect()`, `disconnect()`, `signMessage()`, `getSigner()`, `switchWallet()`

**Estado actual:**
- ❌ No tiene Context Provider
- ❌ No deriva wallets desde mnemonic
- ❌ Usa Wagmi (diferente arquitectura)
- ❌ No tiene selector de wallet

### ❌ Hook useContract

**Requisito de la tarea:**
- Archivo: `dapp/hooks/useContract.ts`
- Funciones para interactuar con el contrato usando Ethers.js

**Estado actual:**
- ❌ No tiene hook `useContract`
- Usa hooks de Wagmi directamente en componentes

### ❌ Componentes Faltantes

**Requisito de la tarea:**
1. ❌ `FileUploader` - **FALTA COMPLETAMENTE**
2. ❌ `DocumentSigner` - **FALTA COMPLETAMENTE** (con alerts de confirmación)
3. ❌ `DocumentVerifier` - **FALTA COMPLETAMENTE**
4. ❌ `DocumentHistory` - **FALTA COMPLETAMENTE**

**Estado actual:**
- ✅ `WalletConnector` - Existe pero diferente
- ✅ `StoreDocumentForm` - Existe pero diferente (no sube archivos)
- ✅ `GetDocumentForm` - Existe pero diferente (no verifica firmas)

### ❌ Página Principal con Tabs

**Requisito de la tarea:**
- Página con tabs: "Upload & Sign", "Verify", "History"
- Selector de wallet (dropdown)

**Estado actual:**
- ❌ No tiene tabs
- ❌ No tiene selector de wallet
- Solo tiene dos formularios lado a lado

### ❌ Funcionalidad de Firmas Digitales

**Requisito de la tarea:**
- Firmar hash del documento con ECDSA
- Almacenar firma como `bytes` en blockchain
- Verificar firma usando `ecrecover()`

**Estado actual:**
- ❌ No tiene firmas digitales ECDSA
- Solo almacena `string signature` (texto, no firma criptográfica)

---

## 🔴 FASE 3: Integración - FALTANTE

### ❌ Flujo Completo

**Requisito de la tarea:**
1. Upload archivo → Calcular hash
2. Sign hash → Generar firma ECDSA
3. Store en blockchain → Almacenar hash + firma + signer + timestamp
4. Verify → Verificar firma ECDSA del documento

**Estado actual:**
- ✅ Calcula hash del contenido
- ❌ No firma digitalmente
- ✅ Almacena en blockchain (pero sin firma ECDSA)
- ❌ No verifica firmas

### ❌ Historial de Documentos

**Requisito de la tarea:**
- Mostrar lista de todos los documentos almacenados
- Usar `getDocumentCount()` y `getDocumentHashByIndex()`

**Estado actual:**
- ❌ No tiene historial
- ❌ No puede listar documentos (falta función en contrato)

---

## 🔴 FASE 4: Testing - FALTANTE

### ❌ Tests del Contrato

**Requisito de la tarea:**
- 11/11 tests pasando
- Tests para: almacenar, verificar, rechazar duplicados, obtener info, contar, iterar

**Estado actual:**
- ✅ Tiene tests pero probablemente no cubren todas las funciones requeridas
- ❌ No tiene tests para `verifyDocument()` (no existe)
- ❌ No tiene tests para `getDocumentCount()` (no existe)
- ❌ No tiene tests para `getDocumentHashByIndex()` (no existe)

### ❌ Tests de Integración

**Requisito de la tarea:**
- Happy path completo
- Documento duplicado
- Verificación con firmante incorrecto
- Documento no existente
- Cambio de wallet

**Estado actual:**
- ❌ No tiene tests de integración del frontend

---

## 📋 RESUMEN: Lo que FALTA

### Smart Contracts (Crítico)
- [ ] Cambiar `owner` → `signer` en struct Document
- [ ] Cambiar `string signature` → `bytes signature`
- [ ] Eliminar mapping `documentExists` (optimización)
- [ ] Agregar función `verifyDocument()` con ECDSA
- [ ] Agregar función `getDocumentCount()`
- [ ] Agregar función `getDocumentHashByIndex()`
- [ ] Agregar modifiers `documentNotExists` y `documentExists`
- [ ] Actualizar tests para cubrir nuevas funciones

### Frontend (Crítico)
- [ ] Migrar de Wagmi a Ethers.js v6
- [ ] Crear `MetaMaskContext.tsx` con wallets derivadas desde mnemonic
- [ ] Crear hook `useContract.ts`
- [ ] Crear componente `FileUploader.tsx`
- [ ] Crear componente `DocumentSigner.tsx` (con alerts)
- [ ] Crear componente `DocumentVerifier.tsx`
- [ ] Crear componente `DocumentHistory.tsx`
- [ ] Implementar página con tabs
- [ ] Agregar selector de wallet
- [ ] Implementar firmas digitales ECDSA

### Funcionalidad (Crítico)
- [ ] Flujo completo: Upload → Sign → Store → Verify
- [ ] Verificación de firmas ECDSA
- [ ] Historial de documentos

### Testing
- [ ] Actualizar tests del contrato (11/11)
- [ ] Agregar tests de integración

---

## 🎯 PRIORIDADES

### 🔴 ALTA PRIORIDAD (Requisitos de la tarea)
1. **Smart Contract:** Cambiar estructura y agregar funciones faltantes
2. **Frontend:** Migrar a Ethers.js v6 y crear componentes faltantes
3. **Firmas:** Implementar firmas digitales ECDSA
4. **Flujo:** Implementar flujo completo Upload → Sign → Store → Verify

### 🟡 MEDIA PRIORIDAD
1. Optimización de gas (eliminar mapping redundante)
2. Historial de documentos
3. Tests completos

### 🟢 BAJA PRIORIDAD
1. Mejoras de UI/UX
2. Documentación adicional

---

## 💡 RECOMENDACIÓN

El proyecto actual es funcional pero **NO cumple con los requisitos de la tarea**. Necesita:

1. **Refactorización del Smart Contract** para cumplir con la estructura requerida
2. **Reescritura del Frontend** para usar Ethers.js v6 en lugar de Wagmi
3. **Implementación de firmas digitales ECDSA** (crítico)
4. **Nuevos componentes** según la especificación

**Tiempo estimado para completar:** 12-16 horas adicionales

---

**Última actualización:** Noviembre 2025

