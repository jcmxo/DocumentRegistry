#!/bin/bash

echo "========================================"
echo "  Document Registry dApp - Inicio Demo"
echo "========================================"
echo ""

# Cambiar al directorio del script
cd "$(dirname "$0")"

# Verificar que estamos en el directorio correcto
if [ ! -f "package.json" ]; then
    echo "ERROR: No se encontró package.json"
    echo "Asegúrate de ejecutar este script desde la carpeta dapp/"
    exit 1
fi

# Verificar que Node.js/npm esté instalado
NPM_CMD=""
USE_WINDOWS_NPM=false

# Intentar encontrar node/npm en PATH
if command -v node &> /dev/null && command -v npm &> /dev/null; then
    NPM_CMD="npm"
elif [ -f "/mnt/c/Program Files/nodejs/npm.cmd" ]; then
    # npm de Windows disponible - usar cmd.exe para ejecutar
    NPM_CMD="cmd.exe /c"
    NPM_WIN_PATH="C:\\Program Files\\nodejs\\npm.cmd"
    USE_WINDOWS_NPM=true
    echo "    INFO: Usando npm de Windows"
else
    echo "ERROR: Node.js/npm no está instalado o no está accesible"
    echo "Por favor, instala Node.js desde https://nodejs.org/"
    echo ""
    echo "O si Node.js está instalado en Windows, ejecuta desde CMD/PowerShell:"
    echo "  cd dapp"
    echo "  iniciar-demo.bat"
    exit 1
fi

echo "[1/4] Verificando Anvil..."
if curl -s http://127.0.0.1:8545 > /dev/null 2>&1; then
    echo "    OK: Anvil está corriendo en http://127.0.0.1:8545"
else
    echo "    ERROR: Anvil no está corriendo"
    echo "    Por favor, inicia Anvil en otra terminal: anvil"
    echo ""
    exit 1
fi
echo ""

echo "[2/4] Verificando contrato..."
# Verificar si cast está disponible
if command -v cast &> /dev/null; then
    if cast code 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9 --rpc-url http://127.0.0.1:8545 > /dev/null 2>&1; then
        echo "    OK: Contrato verificado en 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9"
    else
        echo "    ADVERTENCIA: Contrato no encontrado o no desplegado"
        echo "    Despliega el contrato con:"
        echo "    cd ../sc"
        echo "    forge script script/Deploy.s.sol:DeployAnvil --rpc-url http://127.0.0.1:8545 --broadcast"
        echo ""
    fi
else
    echo "    ADVERTENCIA: 'cast' no encontrado (Foundry no está en PATH)"
    echo "    No se puede verificar el contrato automáticamente"
    echo "    Asegúrate de que el contrato esté desplegado antes de continuar"
fi
echo ""

echo "[3/4] Verificando dependencias..."
if [ ! -d "node_modules" ] || [ ! -f "node_modules/.package-lock.json" ]; then
    echo "    ADVERTENCIA: node_modules no encontrado o incompleto"
    echo "    Instalando dependencias..."
    if [ "$USE_WINDOWS_NPM" = true ]; then
        # Convertir ruta WSL a Windows y ejecutar npm
        WIN_PATH=$(wslpath -w "$(pwd)")
        cmd.exe /c "cd /d \"$WIN_PATH\" && \"$NPM_WIN_PATH\" install"
    else
        $NPM_CMD install
    fi
    if [ $? -ne 0 ]; then
        echo "    ERROR: Falló la instalación de dependencias"
        exit 1
    fi
else
    echo "    OK: Dependencias instaladas"
fi
echo ""

echo "[4/4] Iniciando servidor de desarrollo..."
echo "    La dApp estará disponible en: http://localhost:3000"
echo "    Abriendo navegador en 3 segundos..."
sleep 3

# Intentar abrir el navegador (funciona en WSL con Windows)
if command -v cmd.exe &> /dev/null; then
    cmd.exe /c start http://localhost:3000 2>/dev/null || \
    powershell.exe -Command "Start-Process http://localhost:3000" 2>/dev/null || \
    echo "    (Abre manualmente http://localhost:3000 en tu navegador)"
else
    # En Linux puro, intentar con xdg-open
    if command -v xdg-open &> /dev/null; then
        xdg-open http://localhost:3000 2>/dev/null &
    else
        echo "    (Abre manualmente http://localhost:3000 en tu navegador)"
    fi
fi

echo ""
echo "========================================"
echo "  Servidor iniciado!"
echo "  Presiona Ctrl+C para detener"
echo "========================================"
echo ""

if [ "$USE_WINDOWS_NPM" = true ]; then
    echo ""
    echo "⚠️  NOTA: Node.js está en Windows. Para mejor compatibilidad,"
    echo "   ejecuta desde CMD/PowerShell:"
    echo "   cd dapp"
    echo "   iniciar-demo.bat"
    echo ""
    echo "   O instala Node.js en WSL: sudo apt install nodejs npm"
    echo ""
    echo "Intentando ejecutar npm de Windows..."
    # Intentar ejecutar npm de Windows
    WIN_PATH=$(wslpath -w "$(pwd)" 2>/dev/null || echo "C:\\Users\\jcmxo\\DocumentRegistry\\dapp")
    cmd.exe /c "cd /d $WIN_PATH && $NPM_WIN_PATH run dev" 2>&1 || {
        echo ""
        echo "❌ No se pudo ejecutar npm de Windows desde WSL"
        echo "   Por favor, ejecuta desde CMD/PowerShell:"
        echo "   cd C:\\Users\\jcmxo\\DocumentRegistry\\dapp"
        echo "   iniciar-demo.bat"
        exit 1
    }
else
    $NPM_CMD run dev
fi

