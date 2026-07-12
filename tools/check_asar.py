#!/usr/bin/env python3
from __future__ import annotations
import shutil, subprocess, sys

asar = shutil.which('asar')
if not asar:
    print('asar nao encontrado no PATH.')
    sys.exit(2)
print(f'asar encontrado: {asar}')
try:
    r = subprocess.run([asar, '--version'], capture_output=True, text=True, timeout=10)
    print((r.stdout or r.stderr).strip())
except Exception as e:
    print(f'nao consegui obter versao: {e}')
