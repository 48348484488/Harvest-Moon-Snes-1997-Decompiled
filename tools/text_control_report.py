#!/usr/bin/env python3
"""Report control-code usage inside text banks."""
from __future__ import annotations
import argparse, csv
from collections import Counter, defaultdict
from pathlib import Path
from extract_text_banks import parse_bank_file
from hm_text_codec import CONTROL_NAMES

BANKS = ["B6", "B7", "B8", "B9", "BA", "BB"]


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--repo", default=".")
    ap.add_argument("--outdir", default="reports/decomp_pass04/text")
    args = ap.parse_args()
    repo = Path(args.repo)
    outdir = repo / args.outdir
    outdir.mkdir(parents=True, exist_ok=True)
    rows = []
    counter = Counter()
    examples = defaultdict(list)
    for bank in BANKS:
        for e in parse_bank_file(repo / "src" / "data_banks" / f"bank_{bank}.asm"):
            for w in e["words"]:
                if w >= 0x00A2 or w in CONTROL_NAMES:
                    name = CONTROL_NAMES.get(w, f"${w:04X}")
                    counter[name] += 1
                    if len(examples[name]) < 8:
                        examples[name].append((e["bank"], e["label"], e["snes_addr"]))
                    rows.append({"word_hex": f"{w:04X}", "name": name, "bank": e["bank"], "label": e["label"], "snes_addr": e["snes_addr"]})
    csv_path = outdir / "text_control_code_usage.csv"
    with csv_path.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=["word_hex", "name", "bank", "label", "snes_addr"])
        w.writeheader(); w.writerows(rows)
    md = ["# Text control-code usage", "", f"Total control/padding words observed: **{sum(counter.values())}**", "", "| Code | Count | Example labels |", "|---|---:|---|"]
    for name, count in counter.most_common():
        ex = "; ".join(f"{bank}:{label}@${addr}" for bank,label,addr in examples[name])
        md.append(f"| `{name}` | {count} | {ex} |")
    (outdir / "text_control_code_usage.md").write_text("\n".join(md), encoding="utf-8")
    print(f"Wrote {csv_path}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
