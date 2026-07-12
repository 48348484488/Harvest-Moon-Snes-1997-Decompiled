@echo off
setlocal
cd /d "%~dp0"

set "ROM=roms\Harvest Moon (USA).sfc"
set "ASAR=tools\bin\windows\asar.exe"

if not exist "%ASAR%" (
  echo ERRO: Asar nao encontrado em %ASAR%
  pause
  exit /b 2
)

if not exist "%ROM%" (
  echo ERRO: ROM original nao encontrada em %ROM%
  echo Coloque a ROM USA limpa nessa pasta com esse nome.
  pause
  exit /b 3
)

python tools\rom_info.py --rom "%ROM%"
python tools\build_and_compare.py --asar "%ASAR%" --original "%ROM%"

echo.
echo Finalizado. Veja build\ e reports\.
pause
