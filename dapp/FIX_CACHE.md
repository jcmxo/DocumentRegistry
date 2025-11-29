# Solución para el Error de Cache

Si estás viendo el error:
```
Error: Failed to read source code from C:\Users\jcmxo\DocumentRegistry\dapp\lib\web3.ts
```

Esto es un problema de caché de Next.js. Sigue estos pasos:

## Solución Rápida

1. **Detén el servidor de desarrollo** (presiona `Ctrl+C` en la terminal donde está corriendo `npm run dev`)

2. **Limpia la caché de Next.js**:
   ```bash
   rm -rf .next
   ```
   
   O usa el script proporcionado:
   ```bash
   ./clean-cache.sh
   ```

3. **Reinicia el servidor**:
   ```bash
   npm run dev
   ```

## Verificación

El archivo `web3.tsx` existe y está correcto. El problema es que Next.js estaba cacheando la referencia al archivo antiguo `web3.ts`.

Para verificar que todo está correcto:
```bash
# Verificar que web3.tsx existe
ls -la lib/web3.tsx

# Verificar que web3.ts NO existe
test -f lib/web3.ts && echo "ERROR" || echo "OK"
```

## Nota sobre los Warnings

Los warnings sobre `@react-native-async-storage/async-storage` y `pino-pretty` son solo advertencias de dependencias opcionales y **no afectan la funcionalidad** de la aplicación. Puedes ignorarlos de forma segura.

