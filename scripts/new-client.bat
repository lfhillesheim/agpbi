@echo off
REM AGPBI - Criar nova pasta de cliente (Windows)
REM Uso: scripts\new-client.bat "Nome do Cliente"

setlocal enabledelayedexpansion

if "%~1"=="" (
    echo Erro: Nome do cliente nao fornecido
    echo Uso: scripts\new-client.bat "Nome do Cliente"
    exit /b 1
)

set "CLIENT_NAME=%~1"
set "CLIENT_SLUG=%CLIENT_NAME: =-%"
set "CLIENT_SLUG=%CLIENT_SLUG:A=a%"
set "CLIENT_SLUG=%CLIENT_SLUG:B=b%"
set "CLIENT_SLUG=%CLIENT_SLUG:C=c%"
set "CLIENT_SLUG=%CLIENT_SLUG:D=d%"
set "CLIENT_SLUG=%CLIENT_SLUG:E=e%"
set "CLIENT_SLUG=%CLIENT_SLUG:F=f%"
set "CLIENT_SLUG=%CLIENT_SLUG:G=g%"
set "CLIENT_SLUG=%CLIENT_SLUG:H=h%"
set "CLIENT_SLUG=%CLIENT_SLUG:I=i%"
set "CLIENT_SLUG=%CLIENT_SLUG:J=j%"
set "CLIENT_SLUG=%CLIENT_SLUG:K=k%"
set "CLIENT_SLUG=%CLIENT_SLUG:L=l%"
set "CLIENT_SLUG=%CLIENT_SLUG:M=m%"
set "CLIENT_SLUG=%CLIENT_SLUG:N=n%"
set "CLIENT_SLUG=%CLIENT_SLUG:O=o%"
set "CLIENT_SLUG=%CLIENT_SLUG:P=p%"
set "CLIENT_SLUG=%CLIENT_SLUG:Q=q%"
set "CLIENT_SLUG=%CLIENT_SLUG:R=r%"
set "CLIENT_SLUG=%CLIENT_SLUG:S=s%"
set "CLIENT_SLUG=%CLIENT_SLUG:T=t%"
set "CLIENT_SLUG=%CLIENT_SLUG:U=u%"
set "CLIENT_SLUG=%CLIENT_SLUG:V=v%"
set "CLIENT_SLUG=%CLIENT_SLUG:W=w%"
set "CLIENT_SLUG=%CLIENT_SLUG:X=x%"
set "CLIENT_SLUG=%CLIENT_SLUG:Y=y%"
set "CLIENT_SLUG=%CLIENT_SLUG:Z=z%"

set "CLIENT_DIR=clientes\%CLIENT_SLUG%"

if exist "%CLIENT_DIR%" (
    echo Erro: Cliente ja existe em %CLIENT_DIR%
    exit /b 1
)

echo === AGPBI - Novo Cliente ===
echo Cliente: %CLIENT_NAME%
echo Slug: %CLIENT_SLUG%
echo.

echo Criando estrutura...
mkdir "%CLIENT_DIR%\00-contexto" 2>nul
mkdir "%CLIENT_DIR%\01-vision" 2>nul
mkdir "%CLIENT_DIR%\02-validate" 2>nul
mkdir "%CLIENT_DIR%\03-build\projects" 2>nul
mkdir "%CLIENT_DIR%\04-reunioes" 2>nul
mkdir "%CLIENT_DIR%\05-atividades" 2>nul
mkdir "%CLIENT_DIR%\06-decisoes" 2>nul
mkdir "%CLIENT_DIR%\.context" 2>nul

echo.
echo Cliente criado: %CLIENT_DIR%
echo.
echo Proximos passos:
echo   1. cd %CLIENT_DIR%
echo   2. Editar CLAUDE.md e 00-contexto\cliente.md
echo   3. Usar /agpbi-vision para iniciar o primeiro projeto
echo.

pause
