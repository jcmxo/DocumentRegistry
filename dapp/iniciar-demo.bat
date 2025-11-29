@echo off
setlocal enabledelayedexpansion

echo ========================================
echo   Document Registry dApp - Inicio Demo
echo ========================================
echo.

cd /d "%~dp0"

REM Verificar que estamos en el directorio correcto
if not exist "package.json" (
    echo ERROR: No se encontro package.json
    echo Asegurate de ejecutar este script desde la carpeta dapp/
    pause
    exit /b 1
)

REM Verificar que Node.js este instalado
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Node.js no esta instalado o no esta en PATH
    echo Por favor, instala Node.js desde https://nodejs.org/
    pause
    exit /b 1
)

REM Verificar que npm este instalado
where npm >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: npm no esta instalado o no esta en PATH
    echo npm deberia venir con Node.js
    pause
    exit /b 1
)

echo [1/4] Verificando Anvil...
curl -s http://127.0.0.1:8545 >nul 2>&1
if %errorlevel% neq 0 (
    echo    ERROR: Anvil no esta corriendo
    echo    Por favor, inicia Anvil en otra terminal: anvil
    echo.
    pause
    exit /b 1
)
echo    OK: Anvil esta corriendo en http://127.0.0.1:8545
echo.

echo [2/4] Verificando contrato...
REM Verificar si cast esta disponible
where cast >nul 2>&1
if %errorlevel% equ 0 (
    cast code 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9 --rpc-url http://127.0.0.1:8545 >nul 2>&1
    if %errorlevel% neq 0 (
        echo    ADVERTENCIA: Contrato no encontrado o no desplegado
        echo    Desplega el contrato con:
        echo    cd ..\sc
        echo    forge script script/Deploy.s.sol:DeployAnvil --rpc-url http://127.0.0.1:8545 --broadcast
        echo.
    ) else (
        echo    OK: Contrato verificado en 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9
    )
) else (
    echo    ADVERTENCIA: 'cast' no encontrado (Foundry no esta en PATH)
    echo    No se puede verificar el contrato automaticamente
    echo    Asegurate de que el contrato este desplegado antes de continuar
)
echo.

echo [3/4] Verificando dependencias...
if not exist "node_modules" (
    echo    ADVERTENCIA: node_modules no encontrado
    echo    Instalando dependencias...
    call npm install
    if %errorlevel% neq 0 (
        echo    ERROR: Fallo la instalacion de dependencias
        pause
        exit /b 1
    )
) else (
    echo    OK: Dependencias instaladas
)
echo.

echo [4/4] Iniciando servidor de desarrollo...
echo    La dApp estara disponible en: http://localhost:3000
echo    Abriendo navegador en 3 segundos...
timeout /t 3 /nobreak >nul
start http://localhost:3000
echo.
echo ========================================
echo   Servidor iniciado!
echo   Presiona Ctrl+C para detener
echo ========================================
echo.
call npm run dev

