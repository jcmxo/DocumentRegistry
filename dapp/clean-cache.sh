#!/bin/bash
# Script para limpiar la caché de Next.js

echo "🧹 Limpiando caché de Next.js..."

# Eliminar directorio .next
if [ -d ".next" ]; then
  rm -rf .next
  echo "✅ Directorio .next eliminado"
else
  echo "ℹ️  Directorio .next no existe"
fi

# Eliminar node_modules/.cache si existe
if [ -d "node_modules/.cache" ]; then
  rm -rf node_modules/.cache
  echo "✅ Caché de node_modules eliminada"
fi

echo "✨ Limpieza completada. Ahora ejecuta: npm run dev"

