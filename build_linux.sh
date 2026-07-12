#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

ROM="roms/Harvest Moon (USA).sfc"
ASAR="${ASAR:-}"

if [[ -z "$ASAR" ]]; then
  if [[ -x "tools/bin/linux/asar" ]]; then
    ASAR="tools/bin/linux/asar"
  elif command -v asar >/dev/null 2>&1; then
    ASAR="asar"
  else
    echo "ERRO: Asar Linux nao encontrado."
    echo "Coloque o binario Linux em tools/bin/linux/asar ou instale asar no PATH."
    exit 2
  fi
fi

if [[ ! -f "$ROM" ]]; then
  echo "ERRO: ROM original nao encontrada em: $ROM"
  echo "Coloque a ROM USA limpa nessa pasta com esse nome."
  exit 3
fi

python3 tools/rom_info.py --rom "$ROM"
python3 tools/build_and_compare.py --asar "$ASAR" --original "$ROM"

echo "Finalizado. Veja build/ e reports/."
