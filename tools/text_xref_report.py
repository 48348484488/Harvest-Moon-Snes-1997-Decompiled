#!/usr/bin/env python3
"""Find source references to labeled B6-BB text blocks."""
from __future__ import annotations
import argparse, csv, re
from pathlib import Path
from extract_text_banks import parse_bank_file

TOKEN_RE = re.compile(r'\b[A-Za-z_][A-Za-z0-9_]*\b')
DEF_RE = re.compile(r'^\s*([A-Za-z_][A-Za-z0-9_]*):')

def load_entries(repo: Path):
    entries=[]
    for bank in ["B6","B7","B8","B9","BA","BB"]:
        entries.extend(parse_bank_file(repo / "src" / "data_banks" / f"bank_{bank}.asm"))
    return entries


def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--repo', default='.')
    ap.add_argument('--outdir', default='reports/decomp_pass02/text')
    args=ap.parse_args()
    repo=Path(args.repo); outdir=repo/args.outdir; outdir.mkdir(parents=True, exist_ok=True)
    entries=load_entries(repo)
    labels={e['label'] for e in entries}
    entry_by_label={e['label']: e for e in entries}
    refs={label: [] for label in labels}

    for p in (repo/'src').rglob('*.asm'):
        rel=str(p.relative_to(repo))
        for i,line in enumerate(p.read_text(errors='ignore').splitlines(), start=1):
            defined = DEF_RE.match(line)
            defined_label = defined.group(1) if defined else None
            for tok in set(TOKEN_RE.findall(line)) & labels:
                if tok == defined_label:
                    continue
                refs[tok].append((rel,i,line.strip()))

    rows=[]
    for e in entries:
        rs=refs[e['label']]
        rows.append({
            'bank':e['bank'], 'label':e['label'], 'snes_addr':e['snes_addr'],
            'xref_count':len(rs),
            'xrefs':' | '.join(f"{rel}:{i}: {line}" for rel,i,line in rs[:8]),
            'text_preview':e['text'].replace('\n',' / ')[:180]
        })
    csv_path=outdir/'text_label_xrefs.csv'
    with csv_path.open('w', newline='', encoding='utf-8') as f:
        w=csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader(); w.writerows(rows)
    total=sum(r['xref_count'] for r in rows)
    linked=sum(1 for r in rows if r['xref_count']>0)
    md=["# Text label cross-reference report", "", f"Text labels checked: **{len(rows)}**", f"Labels with at least one reference outside their definition: **{linked}**", f"Total references found: **{total}**", ""]
    md.append('## Most referenced labels')
    md.append('')
    md.append('| Label | Addr | Refs | First refs |')
    md.append('|---|---:|---:|---|')
    for r in sorted(rows, key=lambda x: x['xref_count'], reverse=True)[:80]:
        if r['xref_count']==0: break
        first=r['xrefs'].replace('|','\\|')[:240]
        md.append(f"| `{r['label']}` | `${r['snes_addr']}` | {r['xref_count']} | {first} |")
    md.append('')
    md.append('## Likely unlinked / not directly referenced labels')
    md.append('')
    unlinked=[r for r in rows if r['xref_count']==0]
    md.append(f"Count: **{len(unlinked)}**")
    md.append('')
    for r in unlinked[:160]:
        md.append(f"- `${r['snes_addr']}` `{r['label']}` — {r['text_preview']}")
    (outdir/'text_label_xrefs.md').write_text('\n'.join(md), encoding='utf-8')
    print(f"xref labels={len(rows)} linked={linked} refs={total}")
if __name__=='__main__': main()
