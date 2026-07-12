#!/usr/bin/env python3
"""Agrupa diferencas do CSV de verify_source_against_rom.py em faixas aproximadas."""
from __future__ import annotations
from pathlib import Path
import csv, argparse, datetime

ROOT = Path(__file__).resolve().parents[1]
REPORTS = ROOT / 'reports'


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument('--csv', type=Path, default=REPORTS/'source_vs_rom_data_mismatches.csv')
    ap.add_argument('--max-gap', type=lambda x:int(x,0), default=0x40, help='gap maximo em bytes para unir faixas')
    args = ap.parse_args()
    rows=[]
    with args.csv.open(encoding='utf-8') as f:
        for r in csv.DictReader(f):
            start=int(r['snes_addr'],16)
            # rough: line length, not exact last diff offset; enough for planning
            length=int(r['length'])
            rows.append((start,start+length-1,r))
    rows.sort()
    ranges=[]
    for start,end,r in rows:
        if not ranges or start > ranges[-1]['end'] + args.max_gap:
            ranges.append({'start':start,'end':end,'count':1,'files':{r['file']},'lines':[r['line']]})
        else:
            rg=ranges[-1]
            rg['end']=max(rg['end'],end)
            rg['count']+=1
            rg['files'].add(r['file'])
            if len(rg['lines'])<5: rg['lines'].append(r['line'])
    md=REPORTS/'mismatch_ranges.md'
    out=[]
    out.append('# Faixas de diferenca ASM vs ROM')
    out.append('')
    out.append(f'Gerado em: {datetime.datetime.now().isoformat(timespec="seconds")}')
    out.append('')
    out.append(f'Max gap para juntar faixas: `0x{args.max_gap:X}` bytes.')
    out.append('')
    out.append(f'Total de faixas: `{len(ranges)}`')
    out.append('')
    out.append('| Banco | Inicio | Fim | Tamanho aprox. | Linhas com diff | Arquivos |')
    out.append('|---:|---:|---:|---:|---:|---|')
    for rg in ranges[:200]:
        bank=(rg['start']>>16)&0xff
        size=rg['end']-rg['start']+1
        files=', '.join(sorted(rg['files'])[:3])
        if len(rg['files'])>3: files+=' ...'
        out.append(f"| `{bank:02X}` | `{rg['start']:06X}` | `{rg['end']:06X}` | {size} | {rg['count']} | `{files}` |")
    out.append('')
    out.append('Essas faixas ajudam a localizar onde a ROM BR diverge do source USA. Bancos `B6-BB` sao esperados em traducao, pois parecem conter texto/dialogos.')
    md.write_text('\n'.join(out)+'\n', encoding='utf-8')
    print(md)
    return 0

if __name__ == '__main__':
    raise SystemExit(main())
