# ⚡ Inicio Rápido para Demo

## 🚀 Inicio en 3 Pasos

### 1. Verificar Anvil
```bash
# Verifica que Anvil esté corriendo
curl http://127.0.0.1:8545
```

Si no está corriendo:
```bash
anvil
```

### 2. Verificar Contrato
```bash
cd sc
forge script script/Deploy.s.sol:DeployAnvil --rpc-url http://127.0.0.1:8545 --broadcast
```

### 3. Iniciar dApp
```bash
cd dapp
npm run dev
```

Abre: **http://localhost:3000**

---

## ✅ Verificación Rápida

### Windows (CMD/PowerShell):
```bash
cd dapp
iniciar-demo.bat
```

### Linux/Mac/WSL:
```bash
cd dapp
./iniciar-demo.sh
```

### Verificación Detallada (Linux/Mac/WSL):
```bash
cd dapp
./verificar-demo.sh
```

---

## 🎯 Demo en 3 Minutos

1. **Conectar Wallet** (30 seg)
   - Clic en "Connect Wallet"
   - Confirmar en MetaMask

2. **Almacenar Documento** (1 min)
   - Content: `"Demo Document"`
   - Signature: `"DEMO-001"`
   - Clic en "Store Document"
   - Confirmar en MetaMask

3. **Consultar Documento** (30 seg)
   - Copiar hash del campo "Computed Hash"
   - Pegar en "Get Document Info"
   - Clic en "Get Document Info"
   - ✅ Ver información del documento

---

## 📋 Checklist Pre-Demo

- [ ] Anvil corriendo
- [ ] Contrato desplegado
- [ ] MetaMask configurado (Chain ID 31337)
- [ ] Cuenta de Anvil importada en MetaMask
- [ ] dApp corriendo (`npm run dev`)
- [ ] Navegador abierto en http://localhost:3000

---

## 🐛 Problemas Comunes

### "Contract code is empty"
→ Despliega el contrato (ver paso 2 arriba)

### MetaMask no conecta
→ Verifica que MetaMask esté en red "Anvil Local" (31337)

### "Document not found"
→ Verifica que el hash tenga `0x` al inicio y 66 caracteres totales

---

**📖 Para más detalles, ver: `DEMO.md`**

