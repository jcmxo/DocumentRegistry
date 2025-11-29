#!/bin/bash

echo "🔍 Verificando estado de la demo..."
echo ""

# Verificar Anvil
echo "1. Verificando Anvil..."
if curl -s http://127.0.0.1:8545 > /dev/null 2>&1; then
    echo "   ✅ Anvil está corriendo en http://127.0.0.1:8545"
else
    echo "   ❌ Anvil NO está corriendo"
    echo "   💡 Ejecuta: anvil"
    exit 1
fi

# Verificar contrato
echo ""
echo "2. Verificando contrato desplegado..."
CONTRACT_ADDRESS="0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9"
if cast code "$CONTRACT_ADDRESS" --rpc-url http://127.0.0.1:8545 2>&1 | grep -q "0x608"; then
    echo "   ✅ Contrato desplegado en: $CONTRACT_ADDRESS"
else
    echo "   ❌ Contrato NO está desplegado"
    echo "   💡 Ejecuta: cd sc && forge script script/Deploy.s.sol:DeployAnvil --rpc-url http://127.0.0.1:8545 --broadcast"
    exit 1
fi

# Verificar .env.local
echo ""
echo "3. Verificando configuración..."
if [ -f ".env.local" ]; then
    echo "   ✅ Archivo .env.local existe"
    if grep -q "NEXT_PUBLIC_DOCUMENT_REGISTRY_ADDRESS" .env.local; then
        echo "   ✅ Variable NEXT_PUBLIC_DOCUMENT_REGISTRY_ADDRESS configurada"
    else
        echo "   ⚠️  Variable NEXT_PUBLIC_DOCUMENT_REGISTRY_ADDRESS no encontrada en .env.local"
    fi
else
    echo "   ⚠️  Archivo .env.local no existe"
    echo "   💡 Crea .env.local con las variables de entorno"
fi

# Verificar node_modules
echo ""
echo "4. Verificando dependencias..."
if [ -d "node_modules" ]; then
    echo "   ✅ Dependencias instaladas"
else
    echo "   ❌ Dependencias NO instaladas"
    echo "   💡 Ejecuta: npm install"
    exit 1
fi

# Verificar servidor
echo ""
echo "5. Verificando servidor de desarrollo..."
if curl -s http://localhost:3000 > /dev/null 2>&1; then
    echo "   ✅ Servidor corriendo en http://localhost:3000"
else
    echo "   ⚠️  Servidor NO está corriendo"
    echo "   💡 Ejecuta: npm run dev"
fi

echo ""
echo "✅ Verificación completada!"
echo ""
echo "📋 Próximos pasos:"
echo "   1. Asegúrate de que MetaMask esté configurado con la red Anvil (Chain ID 31337)"
echo "   2. Importa una cuenta de Anvil en MetaMask"
echo "   3. Abre http://localhost:3000 en tu navegador"
echo "   4. Sigue la guía en DEMO.md"
echo ""

