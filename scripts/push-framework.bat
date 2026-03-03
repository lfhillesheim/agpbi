@echo off
REM AGPBI - Push framework changes
REM Detecta se mudanca é geral (main) ou especifica (branch)
REM Uso: scripts\push-framework.bat "tipo" "descricao"
REM   tipo: main ou branch
REM   descricao: descricao da mudanca

setlocal enabledelayedexpansion

set "TIPO=%~1"
set "DESC=%~2"

if "%TIPO%"=="" (
    echo Uso: scripts\push-framework.bat [main^|branch] "descricao"
    echo.
    echo Exemplos:
    echo   scripts\push-framework.bat main "Nova skill agpbi-xxx"
    echo   scripts\push-framework.bat branch "Projeto topmed-financeiro"
    pause
    exit /b 1
)

if "%DESC%"=="" (
    echo Erro: Descricao obrigatoria
    pause
    exit /b 1
)

echo === AGPBI Push Framework ===
echo Tipo: %TIPO%
echo Descricao: %DESC%
echo.

REM Pegar branch atual
for /f "tokens=*" %%a in ('git branch --show-current') do set CURRENT_BRANCH=%%a

echo Branch atual: %CURRENT_BRANCH%
echo.

if "%TIPO%"=="main" (
    echo [MUDANCA GERAL - vai para main]
    echo.
    echo 1. Stashing changes...
    git stash

    echo 2. Going to main...
    git checkout main

    echo 3. Applying changes...
    git stash pop

    echo 4. Committing to main...
    git add .
    git commit -m "feat: %DESC%"
    git push

    echo 5. Updating client branches...
    REM Lista de clientes - adicione mais conforme necessario
    set CLIENTES=topmed empresa-x

    for %%c in (%CLIENTES%) do (
        echo    Merging to %%c...
        git checkout %%c
        git merge main --no-edit
        git push
    )

    echo 6. Returning to main...
    git checkout main

    echo.
    echo === Done! Mudanca geral aplicada ===
    echo.
    echo Branches atualizadas: %CLIENTES%
    echo Voce esta em: main

) else (
    echo [MUDANCA ESPECIFICA - fica no branch]
    echo.
    echo Committing to %CURRENT_BRANCH%...
    git add .
    git commit -m "feat: %DESC%"
    git push

    echo.
    echo === Done! Mudanca especifica aplicada ===
    echo.
    echo Voce esta em: %CURRENT_BRANCH%
)

echo.
pause
