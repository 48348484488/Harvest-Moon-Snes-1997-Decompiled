#!/usr/bin/env python3
"""Report undecoded BR glyph/control words from the text comparison CSV."""
from __future__ import annotations
import argparse, csv, re, collections
from pathlib import Path

PAT=re.compile(r'<\$([0-9A-F]{4})>')

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('--repo', default='.')
    ap.add_argument('--compare-csv', default='reports/decomp_pass02/text/text_compare_usa_source_vs_br_rom.csv')
    ap.add_argument('--outdir', default='reports/decomp_pass02/text')
    args=ap.parse_args()
    repo=Path(args.repo); outdir=repo/args.outdir; outdir.mkdir(parents=True, exist_ok=True)
    rows=list(csv.DictReader((repo/args.compare_csv).open(encoding='utf-8')))
    counts=collections.Counter(); ctx=collections.defaultdict(list)
    for r in rows:
        t=r['br_text']
        for m in PAT.finditer(t):
            code=m.group(1); counts[code]+=1
            if len(ctx[code])<12:
                s=max(0,m.start()-28); e=min(len(t),m.end()+28)
                ctx[code].append((r['label'],r['snes_addr'],t[s:e].replace('\n',' / ')))
    md=['# Undecoded BR glyph/control report','', 'These codes remained undecoded after the common BR accent table was applied. Many of them are probably menu glyphs, numbers, prices, choice labels, or special control codes rather than normal text.', '']
    md.append('| Code | Count | Example contexts |')
    md.append('|---:|---:|---|')
    for code,n in counts.most_common():
        examples='<br>'.join(f"`{label}` ${addr}: {text}" for label,addr,text in ctx[code][:4])
        md.append(f"| `${code}` | {n} | {examples} |")
    (outdir/'br_unknown_glyphs.md').write_text('\n'.join(md), encoding='utf-8')
    with (outdir/'br_unknown_glyphs.csv').open('w', newline='', encoding='utf-8') as f:
        w=csv.writer(f); w.writerow(['code','count','example_label','example_addr','example_context'])
        for code,n in counts.most_common():
            ex=ctx[code][0] if ctx[code] else ('','','')
            w.writerow([code,n,*ex])
    print(f"unknown glyph codes={len(counts)}")
if __name__=='__main__': main()
