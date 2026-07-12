#!/usr/bin/env python3
"""
Auditoria estatica do HM-Decomp.
Nao precisa do ROM. Gera relatorios com TODOs, UNKs, DATA8/DATA16 e linhas por banco.
Uso:
  python tools/decomp_audit.py
"""
from __future__ import annotations
from pathlib import Path
import csv
import re
from collections import Counter, defaultdict

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src"
REPORTS = ROOT / "reports"
REPORTS.mkdir(exist_ok=True)

LABEL_DEF_RE = re.compile(r"^\s*([A-Za-z_.$][\w.$]*)\s*:", re.M)
EQU_RE = re.compile(r"^\s*(!?[A-Za-z_.$][\w.$]*)\s*=", re.M)
REF_RE = re.compile(r"\b(?:JSL\.L|JMP\.W|JSR\.W|BRA|BEQ|BNE|BCC|BCS|BMI|BPL|BVC|BVS|LDA\.L|LDA\.W|STA\.L|STA\.W|ADC\.L|ADC\.W|SBC\.L|SBC\.W|CMP\.L|CMP\.W|CPX\.W|CPY\.W)\s+([A-Za-z_.$][\w.$]*)")


def read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="replace")


def classify_file(path: Path) -> str:
    s = str(path).replace("\\", "/")
    if "/code_banks/" in s:
        return "code"
    if "/data_banks/" in s:
        return "data"
    if "/constants/" in s:
        return "constants"
    if "/maps/" in s:
        return "maps"
    return "misc"


def main() -> None:
    files = sorted(SRC.rglob("*.asm"))
    rows = []
    all_defs = set()
    refs = Counter()
    ref_locations = defaultdict(list)
    todo_lines = []

    for f in files:
        text = read_text(f)
        rel = f.relative_to(ROOT).as_posix()
        lines = text.splitlines()
        for m in LABEL_DEF_RE.finditer(text):
            all_defs.add(m.group(1))
        for m in EQU_RE.finditer(text):
            all_defs.add(m.group(1))
        for i, line in enumerate(lines, 1):
            if "TODO" in line.upper() or "????" in line or "UNKNOWN" in line.upper():
                todo_lines.append((rel, i, line.rstrip()))
            for m in REF_RE.finditer(line):
                name = m.group(1)
                refs[name] += 1
                if len(ref_locations[name]) < 8:
                    ref_locations[name].append((rel, i))

        rows.append({
            "file": rel,
            "kind": classify_file(f),
            "lines": len(lines),
            "todo": sum(1 for l in lines if "TODO" in l.upper()),
            "unknown_comments": sum(1 for l in lines if "????" in l or "UNKNOWN" in l.upper()),
            "unk_refs": len(re.findall(r"\bUNK_[A-Za-z0-9_]+", text)),
            "data8_refs": len(re.findall(r"\bDATA8_[0-9A-F]{6}", text)),
            "data16_refs": len(re.findall(r"\bDATA16_[0-9A-F]{6}", text)),
            "sub_labels": len(re.findall(r"^\s*SUB_[0-9A-F]{6}:", text, re.M)),
            "code_labels": len(re.findall(r"^\s*CODE_[0-9A-F]{6}:", text, re.M)),
            "db_lines": sum(1 for l in lines if re.search(r"\bdb\b", l, re.I)),
            "dw_lines": sum(1 for l in lines if re.search(r"\bdw\b", l, re.I)),
            "dl_lines": sum(1 for l in lines if re.search(r"\bdl\b", l, re.I)),
        })

    unresolved = []
    for name, count in refs.items():
        if name.startswith("."):
            continue
        if name not in all_defs and not name.startswith(("DATA8_", "DATA16_", "CODE_", "SUB_", "UNK_")):
            unresolved.append((name, count, ref_locations[name]))
    unresolved.sort(key=lambda x: (-x[1], x[0]))

    csv_path = REPORTS / "decomp_audit.csv"
    with csv_path.open("w", newline="", encoding="utf-8") as fp:
        writer = csv.DictWriter(fp, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)

    md_path = REPORTS / "decomp_audit.md"
    total = Counter()
    for r in rows:
        for k, v in r.items():
            if isinstance(v, int):
                total[k] += v
    by_kind = defaultdict(Counter)
    for r in rows:
        kind = r["kind"]
        for k, v in r.items():
            if isinstance(v, int):
                by_kind[kind][k] += v

    with md_path.open("w", encoding="utf-8") as fp:
        fp.write("# Relatorio automatico do HM-Decomp\n\n")
        fp.write("Este relatorio e gerado sem ROM original. Ele mede o estado do codigo Assembly exportado.\n\n")
        fp.write("## Totais\n\n")
        fp.write(f"- Arquivos ASM analisados: {len(rows)}\n")
        fp.write(f"- Linhas ASM: {total['lines']}\n")
        fp.write(f"- Marcacoes TODO: {total['todo']}\n")
        fp.write(f"- Referencias UNK_: {total['unk_refs']}\n")
        fp.write(f"- Referencias DATA8_: {total['data8_refs']}\n")
        fp.write(f"- Referencias DATA16_: {total['data16_refs']}\n")
        fp.write(f"- Labels SUB_: {total['sub_labels']}\n")
        fp.write(f"- Labels CODE_: {total['code_labels']}\n")
        fp.write(f"- Linhas db/dw/dl: {total['db_lines']}/{total['dw_lines']}/{total['dl_lines']}\n\n")
        fp.write("## Resumo por tipo\n\n")
        fp.write("| Tipo | Linhas | TODO | UNK | DATA8 | DATA16 | db | dw | dl |\n")
        fp.write("|---|---:|---:|---:|---:|---:|---:|---:|---:|\n")
        for kind in sorted(by_kind):
            c = by_kind[kind]
            fp.write(f"| {kind} | {c['lines']} | {c['todo']} | {c['unk_refs']} | {c['data8_refs']} | {c['data16_refs']} | {c['db_lines']} | {c['dw_lines']} | {c['dl_lines']} |\n")
        fp.write("\n## Bancos/arquivos que mais precisam de revisao\n\n")
        fp.write("| Arquivo | Linhas | TODO | UNK | DATA8 | DATA16 | db | dw | dl |\n")
        fp.write("|---|---:|---:|---:|---:|---:|---:|---:|---:|\n")
        priority = sorted(rows, key=lambda r: (-(r['todo']*20 + r['unk_refs'] + r['data8_refs'] + r['data16_refs']//4), r['file']))[:25]
        for r in priority:
            fp.write(f"| `{r['file']}` | {r['lines']} | {r['todo']} | {r['unk_refs']} | {r['data8_refs']} | {r['data16_refs']} | {r['db_lines']} | {r['dw_lines']} | {r['dl_lines']} |\n")
        fp.write("\n## TODOs encontrados\n\n")
        for rel, line_no, line in todo_lines[:300]:
            fp.write(f"- `{rel}:{line_no}` `{line.strip()}`\n")
        if len(todo_lines) > 300:
            fp.write(f"\n...mais {len(todo_lines)-300} linhas omitidas. Veja o CSV para detalhes.\n")
        fp.write("\n## Possiveis referencias nao resolvidas\n\n")
        if not unresolved:
            fp.write("Nenhuma referencia obvia nao resolvida encontrada pelo analisador simples.\n")
        else:
            for name, count, locs in unresolved[:80]:
                loc_txt = ", ".join(f"{rel}:{n}" for rel, n in locs)
                fp.write(f"- `{name}` usado {count}x em {loc_txt}\n")

    print(f"Gerado: {md_path}")
    print(f"Gerado: {csv_path}")

if __name__ == "__main__":
    main()
