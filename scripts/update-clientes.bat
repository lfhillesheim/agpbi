@echo off
REM AGPBI - Atualizar todos os clientes com mudanças da main
REM Uso: scripts\update-clientes.bat

setlocal enabledelayedexpansion

set "CLIENTES=topmed empresa-x"

echo === AGPBI - Atualizar Clientes com Main ===
echo.

echo 1. Atualizando main...
git checkout main
git pull

echo.
echo 2. Atualizando clientes...
for %%c in (%CLIENTES%) do (
    echo.
    echo Atualizando %%c...
    git checkout %%c
    git merge main
    git push
)

echo.
echo === Concluido! ===
echo.
git checkout main
pause
