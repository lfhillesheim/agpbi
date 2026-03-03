@echo off
REM AGPBI - Criar novo projeto
REM Uso: scripts\new-project.bat cliente-projeto "Descrição do Projeto"

setlocal enabledelayedexpansion

if "%~1"=="" (
    echo Erro: Nome do projeto nao fornecido
    echo Uso: scripts\new-project.bat cliente-projeto "Descrição"
    echo.
    echo Exemplo: scripts\new-project.bat topmed-financeiro "Dashboard Financeiro"
    exit /b 1
)

set "PROJECT_SLUG=%~1"
set "PROJECT_DESC=%~2"

set "VISION_DIR=01-vision\%PROJECT_SLUG%"
set "VALIDATE_DIR=02-validate\%PROJECT_SLUG%"
set "BUILD_DIR=03-build\%PROJECT_SLUG%"

echo === AGPBI - Novo Projeto ===
echo Projeto: %PROJECT_SLUG%
echo.

echo Criando pastas...
mkdir "%VISION_DIR%" 2>nul
mkdir "%VALIDATE_DIR%" 2>nul
mkdir "%BUILD_DIR%\projects" 2>nul

echo Criando arquivos...
(
echo # %PROJECT_SLUG%
echo.
echo ## Contexto
echo.
echo **Cliente**: [Preencher]
echo **Descricao**: %PROJECT_DESC%
echo **Data Inicio**: %date%
echo.
echo ## Stakeholders
echo.
echo ^| Nome ^| Papel ^| Email ^|
echo ^|------^|-------^|-------^|
echo ^| [Nome] ^| [Cargo] ^| [email] ^|
echo.
echo ## Objetivos
echo.
echo 1. [Preencher]
echo 2. [Preencher]
echo.
) > "%VISION_DIR%\contexto.md"

(
echo # Validacao - %PROJECT_SLUG%
echo.
echo ## Data Sources
echo.
echo - [ ] Fonte 1
echo - [ ] Fonte 2
echo.
echo ## Numeros Validados
echo.
echo - [ ] Validar com negocio
echo.
) > "%VALIDATE_DIR%\validacao.md"

echo.
echo === Projeto criado! ===
echo.
echo Pastas criadas:
echo   - 01-vision\%PROJECT_SLUG%
echo   - 02-validate\%PROJECT_SLUG%
echo   - 03-build\%PROJECT_SLUG%
echo.
echo Proximos passos:
echo   1. Abra o Claude em agpbi
echo   2. Use /agpbi-vision para iniciar o discovery
echo   3. Edite 01-vision\%PROJECT_SLUG%\contexto.md
echo.

pause
