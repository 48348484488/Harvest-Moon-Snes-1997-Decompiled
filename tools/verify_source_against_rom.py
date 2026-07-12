#!/usr/bin/env python3
"""Compara diretivas literais db/dw/dl do source com bytes de um ROM LoROM.

Isto NAO monta o codigo. Ele serve para descobrir se os blocos de dados brutos
exportados no ASM ainda batem com o ROM usado como referencia.

Uso:
  python tools/verify_source_against_rom.py --rom "/caminho/rom.smc"

Saidas:
  reports/source_vs_rom_data.md
  reports/source_vs_rom_data_mismatches.csv
"""
from __future__ import annotations
from pathlib import Path
import argparse, csv, datetime, re, hashlib

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src"
REPORTS = ROOT / "reports"
ORG_RE = re.compile(r"\bORG\s+\$([0-9A-Fa-f]{6})")
COMMENT_ADDR_RE = re.compile(r";\s*([0-9A-Fa-f]{6})(?:\b|;)")
DIR_RE = re.compile(r"^\s*(?:[A-Za-z_.$][\w.$]*:\s*)?(db|dw|dl)\b\s*(.*)$", re.I)


def strip_comment(line: str) -> str:
    in_str = False
    out = []
    i = 0
    while i < len(line):
        ch = line[i]
        if ch == '"':
            in_str = not in_str
            out.append(ch)
        elif ch == ';' and not in_str:
            break
        else:
            out.append(ch)
        i += 1
    return ''.join(out).strip()


def split_args(s: str) -> list[str]:
    args, cur, in_str = [], [], False
    for ch in s:
        if ch == '"':
            in_str = not in_str
            cur.append(ch)
        elif ch == ',' and not in_str:
            arg = ''.join(cur).strip()
            if arg:
                args.append(arg)
            cur = []
        else:
            cur.append(ch)
    arg = ''.join(cur).strip()
    if arg:
        args.append(arg)
    return args


def parse_num(tok: str) -> int | None:
    tok = tok.strip()
    # remove asar immediate marker, although data directives rarely use it
    if tok.startswith('#'):
        tok = tok[1:].strip()
    if tok.startswith('$'):
        try: return int(tok[1:], 16)
        except ValueError: return None
    if tok.startswith('%'):
        try: return int(tok[1:], 2)
        except ValueError: return None
    if re.fullmatch(r"[-+]?\d+", tok):
        return int(tok, 10)
    return None


def parse_directive(kind: str, rest: str) -> bytes | None:
    data = bytearray()
    for tok in split_args(rest):
        tok = tok.strip()
        if not tok:
            continue
        if len(tok) >= 2 and tok[0] == '"' and tok[-1] == '"':
            data.extend(tok[1:-1].encode('latin1', errors='replace'))
            continue
        n = parse_num(tok)
        if n is None:
            return None
        if kind.lower() == 'db':
            data.append(n & 0xFF)
        elif kind.lower() == 'dw':
            data.extend((n & 0xFFFF).to_bytes(2, 'little'))
        elif kind.lower() == 'dl':
            data.extend((n & 0xFFFFFF).to_bytes(3, 'little'))
        else:
            return None
    return bytes(data)


def lorom_to_pc(addr: int, rom_len: int) -> int | None:
    bank = (addr >> 16) & 0xFF
    off = addr & 0xFFFF
    if off < 0x8000:
        return None
    pc = ((bank & 0x7F) * 0x8000) + (off & 0x7FFF)
    return pc if 0 <= pc < rom_len else None


def bank_name(addr: int) -> str:
    return f"{(addr >> 16) & 0xFF:02X}"


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument('--rom', required=True, type=Path)
    args = ap.parse_args()
    rom = args.rom.expanduser().resolve()
    raw = rom.read_bytes()
    if len(raw) % 0x8000 == 512:
        raw = raw[512:]
    REPORTS.mkdir(exist_ok=True)

    rows = []
    total_literals = total_bytes = matched_bytes = mismatched_bytes = skipped_expr = unmapped = 0
    by_bank: dict[str, dict[str, int]] = {}

    for path in sorted(SRC.rglob('*.asm')):
        cur_addr: int | None = None
        for lineno, line in enumerate(path.read_text(encoding='utf-8', errors='replace').splitlines(), 1):
            comment_addr = None
            m_addr = COMMENT_ADDR_RE.search(line)
            if m_addr:
                comment_addr = int(m_addr.group(1), 16)
            no_comment = strip_comment(line)
            m_org = ORG_RE.search(no_comment)
            if m_org:
                cur_addr = int(m_org.group(1), 16)
                continue
            m = DIR_RE.match(no_comment)
            if not m:
                continue
            kind, rest = m.group(1), m.group(2)
            data = parse_directive(kind, rest)
            if data is None:
                skipped_expr += 1
                continue
            if not data:
                continue
            total_literals += 1
            addr = comment_addr if comment_addr is not None else cur_addr
            if addr is None:
                unmapped += len(data)
                continue
            pc = lorom_to_pc(addr, len(raw))
            if pc is None or pc + len(data) > len(raw):
                unmapped += len(data)
                if cur_addr is not None:
                    cur_addr = addr + len(data)
                continue
            rom_slice = raw[pc:pc+len(data)]
            same = rom_slice == data
            bnk = bank_name(addr)
            st = by_bank.setdefault(bnk, {'bytes':0,'matched':0,'mismatched':0,'lines':0,'bad_lines':0})
            st['bytes'] += len(data)
            st['lines'] += 1
            total_bytes += len(data)
            if same:
                matched_bytes += len(data)
                st['matched'] += len(data)
            else:
                diff_count = sum(1 for a,b in zip(data, rom_slice) if a != b)
                mismatched_bytes += diff_count
                st['mismatched'] += diff_count
                st['bad_lines'] += 1
                # keep only compact preview, not full ROM dump
                first = next(i for i,(a,b) in enumerate(zip(data, rom_slice)) if a != b)
                rows.append({
                    'file': str(path.relative_to(ROOT)),
                    'line': lineno,
                    'snes_addr': f"{addr+first:06X}",
                    'pc_offset': f"{pc+first:06X}",
                    'directive': kind.lower(),
                    'length': len(data),
                    'first_source_byte': f"{data[first]:02X}",
                    'first_rom_byte': f"{rom_slice[first]:02X}",
                    'diff_bytes_in_line': diff_count,
                })
            if cur_addr is not None:
                cur_addr = addr + len(data)

    csv_path = REPORTS / 'source_vs_rom_data_mismatches.csv'
    with csv_path.open('w', newline='', encoding='utf-8') as f:
        fieldnames = ['file','line','snes_addr','pc_offset','directive','length','first_source_byte','first_rom_byte','diff_bytes_in_line']
        w = csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader()
        w.writerows(rows)

    md_path = REPORTS / 'source_vs_rom_data.md'
    pct = (matched_bytes / total_bytes * 100) if total_bytes else 0.0
    lines = []
    lines.append('# Source ASM vs ROM data check')
    lines.append('')
    lines.append(f"Gerado em: {datetime.datetime.now().isoformat(timespec='seconds')}")
    lines.append('')
    lines.append('Este relatorio compara apenas diretivas literais `db`, `dw` e `dl` contra o ROM. Ele nao substitui uma montagem com `asar`.')
    lines.append('')
    lines.append('## Resumo')
    lines.append('')
    lines.append(f"- ROM usado: `{rom.name}`")
    lines.append(f"- MD5 do ROM analisado: `{hashlib.md5(raw).hexdigest()}`")
    lines.append(f"- Diretivas literais analisadas: `{total_literals}`")
    lines.append(f"- Bytes de dados comparados: `{total_bytes}`")
    lines.append(f"- Bytes que batem: `{matched_bytes}`")
    lines.append(f"- Bytes diferentes: `{mismatched_bytes}`")
    lines.append(f"- Compatibilidade dos dados literais: `{pct:.4f}%`")
    lines.append(f"- Diretivas puladas por expressao/label: `{skipped_expr}`")
    lines.append(f"- Bytes nao mapeados por ORG/LoROM: `{unmapped}`")
    lines.append('')
    lines.append('## Por banco')
    lines.append('')
    lines.append('| Banco | Bytes | Match | Diferentes | Linhas | Linhas com diff |')
    lines.append('|---:|---:|---:|---:|---:|---:|')
    for bnk in sorted(by_bank):
        st = by_bank[bnk]
        lines.append(f"| `{bnk}` | {st['bytes']} | {st['matched']} | {st['mismatched']} | {st['lines']} | {st['bad_lines']} |")
    lines.append('')
    lines.append('## Primeiras diferencas')
    lines.append('')
    if not rows:
        lines.append('Nenhuma diferenca encontrada nos dados literais comparaveis.')
    else:
        lines.append('| Arquivo | Linha | SNES | PC | src | rom | diff bytes na linha |')
        lines.append('|---|---:|---:|---:|---:|---:|---:|')
        for r in rows[:80]:
            lines.append(f"| `{r['file']}` | {r['line']} | `{r['snes_addr']}` | `{r['pc_offset']}` | `{r['first_source_byte']}` | `{r['first_rom_byte']}` | {r['diff_bytes_in_line']} |")
    lines.append('')
    lines.append(f"CSV completo: `reports/{csv_path.name}`")
    lines.append('')
    lines.append('Interpretacao: se o ROM for uma traducao BR, muitas diferencas em bancos de texto/dados sao esperadas. Para validar a recompilacao original, use o ROM USA com o MD5 indicado no README.')
    md_path.write_text('\n'.join(lines)+'\n', encoding='utf-8')
    print(md_path)
    print(csv_path)
    return 0

if __name__ == '__main__':
    raise SystemExit(main())
