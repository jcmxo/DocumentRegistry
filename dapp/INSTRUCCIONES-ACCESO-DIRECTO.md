# Instrucciones para usar el acceso directo

## ✅ Acceso directo creado

Se ha creado un acceso directo en tu escritorio llamado **"Document Registry dApp"**.

## 🚀 Cómo usar

### Paso 1: Iniciar Anvil
Antes de usar la dApp, asegúrate de que Anvil esté corriendo:

```bash
# En WSL o terminal
cd /mnt/c/Users/jcmxo/DocumentRegistry
anvil
```

O desde Windows:
```cmd
wsl
cd /mnt/c/Users/jcmxo/DocumentRegistry
anvil
```

### Paso 2: Iniciar la dApp
1. Haz doble clic en el acceso directo **"Document Registry dApp"** en tu escritorio.
2. Se abrirá una ventana de terminal que iniciará el servidor de desarrollo.
3. Espera a que veas el mensaje: `✓ Ready in X.Xs`
4. La dApp estará disponible en `http://localhost:3000`

### Paso 3: Abrir en el navegador
1. Abre tu navegador (Brave, Chrome, etc.).
2. Ve a `http://localhost:3000`
3. La dApp debería cargar automáticamente.

## 🔧 Solución de problemas

### Si el acceso directo no funciona:
1. Abre una terminal (CMD o PowerShell).
2. Navega al directorio:
   ```cmd
   cd C:\Users\jcmxo\DocumentRegistry\dapp
   ```
3. Ejecuta:
   ```cmd
   npm run dev
   ```

### Si hay errores de permisos:
- Ejecuta la terminal como administrador.
- O verifica que Node.js esté instalado correctamente.

## 📝 Notas importantes

- **Anvil debe estar corriendo** antes de iniciar la dApp.
- El servidor de desarrollo se ejecuta en `http://localhost:3000`.
- Para detener el servidor, presiona `Ctrl+C` en la terminal.

## 🔗 Archivos creados

- `iniciar-dapp.bat` - Script para iniciar la dApp
- `crear-acceso-directo.vbs` - Script para crear el acceso directo (ya ejecutado)
- Acceso directo en el escritorio: **"Document Registry dApp.lnk"**


