#!/usr/bin/env python3
"""Gera ASM bruto de bancos LoROM a partir de um ROM local.

Nao rode isto para criar codigo final de distribuicao. A utilidade e comparar/estudar
localmente quando uma traducao ou hack nao bate com o source USA.

Uso:
  python tools/make_raw_bank_asm.py --rom ROM.smc --banks B6 BB --out build/raw_br_banks
"""
from __future__ import annotations
from pathlib import Path
import argparse


def lorom_bank_slice(data: bytes, bank: int) -> bytes:
    pc = (bank & 0x7F) * 0x8000
    return data[pc:pc+0x8000]


def parse_bank(s: str) -> int:
    return int(s, 16)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument('--rom', required=True, type=Path)
    ap.add_argument('--banks', nargs=2, metavar=('START_HEX','END_HEX'), default=['80','BF'])
    ap.add_argument('--out', type=Path, default=Path('build/raw_banks'))
    args = ap.parse_args()
    data = args.rom.expanduser().resolve().read_bytes()
    if len(data) % 0x8000 == 512:
        data = data[512:]
    start, end = map(parse_bank, args.banks)
    out_dir = args.out if args.out.is_absolute() else Path.cwd() / args.out
    out_dir.mkdir(parents=True, exist_ok=True)
    for bank in range(start, end+1):
        chunk = lorom_bank_slice(data, bank)
        if len(chunk) != 0x8000:
            print(f'pulado banco {bank:02X}: fora do ROM')
            continue
        p = out_dir / f'bank_{bank:02X}_raw.asm'
        lines = [f'ORG ${bank:02X}8000', '', f'; Banco bruto gerado localmente do ROM: {args.rom.name}', '; Nao redistribua se o ROM nao for livre.', '']
        for i in range(0, len(chunk), 16):
            vals = ','.join(f'${b:02X}' for b in chunk[i:i+16])
            lines.append(f'db {vals} ;{bank:02X}{0x8000+i:04X}')
        p.write_text('\n'.join(lines)+'\n', encoding='utf-8')
        print(p)
    return 0

if __name__ == '__main__':
    raise SystemExit(main())
