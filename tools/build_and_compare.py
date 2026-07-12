#!/usr/bin/env python3
"""
Compila o projeto com asar, se ele estiver instalado, e opcionalmente compara com o ROM original.
Nao inclui nem baixa ROM.

Uso:
  python tools/build_and_compare.py
  python tools/build_and_compare.py --original "/caminho/Harvest Moon (USA).sfc"
  python tools/build_and_compare.py --asar "tools/bin/windows/asar.exe" --original "roms/Harvest Moon (USA).sfc"
"""
from __future__ import annotations
from pathlib import Path
import argparse
import hashlib
import shutil
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
SRC_MAIN = ROOT / "src" / "main.asm"
OUT_ROM = ROOT / "build" / "Harvest_Moon_USA_rebuild.sfc"
EXPECTED_USA_MD5 = "c9bf36a816b6d54aed79d43a6c45111a"


def md5(path: Path) -> str:
    h = hashlib.md5()
    with path.open("rb") as fp:
        for chunk in iter(lambda: fp.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--original", type=Path, help="ROM original legal para comparacao byte-a-byte")
    parser.add_argument("--asar", type=Path, help="Caminho manual para o binario do Asar")
    args = parser.parse_args()

    if args.asar:
        asar = str(args.asar.expanduser().resolve())
        if not Path(asar).exists():
            print(f"ERRO: Asar informado nao existe: {asar}")
            return 2
    else:
        asar = shutil.which("asar")

    if not asar:
        print("ERRO: asar nao encontrado no PATH.")
        print("Instale o asar ou use --asar /caminho/para/asar.")
        return 2

    OUT_ROM.parent.mkdir(exist_ok=True)
    cmd = [str(asar), str(SRC_MAIN), str(OUT_ROM)]
    print("Rodando:", " ".join(cmd))
    try:
        proc = subprocess.run(cmd, cwd=ROOT, text=True, capture_output=True)
    except OSError as exc:
        print(f"ERRO: nao foi possivel executar o Asar: {exc}")
        print("Se voce esta no Linux, confira se o binario e Linux x86_64 e se tem permissao de execucao.")
        print("Um asar.exe de Windows precisa ser rodado no Windows ou via Wine.")
        return 2
    if proc.stdout:
        print(proc.stdout)
    if proc.stderr:
        print(proc.stderr, file=sys.stderr)
    if proc.returncode != 0:
        print(f"Falha na montagem. Codigo: {proc.returncode}")
        return proc.returncode

    print(f"ROM reconstruido: {OUT_ROM}")
    print(f"MD5 rebuild: {md5(OUT_ROM)}")

    if args.original:
        original = args.original.expanduser().resolve()
        if not original.exists():
            print(f"ERRO: original nao existe: {original}")
            return 3
        original_md5 = md5(original)
        print(f"MD5 original: {original_md5}")
        if original_md5.lower() != EXPECTED_USA_MD5:
            print("AVISO: o MD5 do original nao bate com o README do projeto.")
        rebuilt = OUT_ROM.read_bytes()
        orig = original.read_bytes()
        if rebuilt == orig:
            print("OK: rebuild identico byte-a-byte ao original.")
        else:
            limit = min(len(rebuilt), len(orig))
            first = next((i for i in range(limit) if rebuilt[i] != orig[i]), None)
            if first is None and len(rebuilt) != len(orig):
                first = limit
            print("DIFERENTE: rebuild ainda nao bate byte-a-byte.")
            print(f"Tamanho rebuild/original: {len(rebuilt)} / {len(orig)}")
            print(f"Primeira diferenca em offset 0x{first:X}" if first is not None else "Sem diferenca nos bytes comuns.")
            return 1
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
