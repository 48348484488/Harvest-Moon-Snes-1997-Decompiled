#!/usr/bin/env python3
"""Recalcula e grava checksum/complemento SNES em ROM LoROM.

Uso:
  python tools/fix_snes_checksum.py --rom build/out.sfc --out build/out_fixed.sfc
"""
from __future__ import annotations
from pathlib import Path
import argparse


def checksum16(data: bytes) -> int:
    return sum(data) & 0xFFFF


def main() -> int:
    ap=argparse.ArgumentParser()
    ap.add_argument('--rom', required=True, type=Path)
    ap.add_argument('--out', required=True, type=Path)
    args=ap.parse_args()
    raw=bytearray(args.rom.read_bytes())
    header_shift = 512 if len(raw) % 0x8000 == 512 else 0
    hdr = header_shift + 0x7FC0
    if hdr+0x20 > len(raw):
        raise SystemExit('ROM curto demais para header LoROM')
    # Zera checksum antes de calcular, padrao comum para SNES.
    raw[hdr+0x1C:hdr+0x20] = b'\x00\x00\x00\x00'
    # Como o checksum/complemento tambem ficam dentro da soma,
    # os quatro bytes contribuem 0x1FE quando complemento = checksum ^ 0xFFFF.
    chk = (checksum16(raw[header_shift:]) + 0x01FE) & 0xFFFF
    comp = chk ^ 0xFFFF
    raw[hdr+0x1C:hdr+0x1E] = comp.to_bytes(2,'little')
    raw[hdr+0x1E:hdr+0x20] = chk.to_bytes(2,'little')
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_bytes(raw)
    print(f'gravado: {args.out}')
    print(f'checksum=0x{chk:04X} complement=0x{comp:04X}')
    return 0

if __name__=='__main__':
    raise SystemExit(main())
