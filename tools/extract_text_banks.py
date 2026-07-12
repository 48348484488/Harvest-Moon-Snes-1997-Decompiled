#!/usr/bin/env python3
"""Extract labeled text entries from src/data_banks/bank_B6-BB.asm."""
from __future__ import annotations
import argparse, csv, json, re
from pathlib import Path
from hm_text_codec import decode_words

DW_RE = re.compile(r"\bdw\s+([^;]+)")
VAL_RE = re.compile(r"\$([0-9A-Fa-f]{1,4})")
LABEL_RE = re.compile(r"^\s*([A-Za-z_][A-Za-z0-9_]*):")
ADDR_RE = re.compile(r";([A-F0-9]{6});")


def parse_bank_file(path: Path):
    entries = []
    current = None

    def finish():
        nonlocal current
        if current:
            current["text"] = decode_words(current["words"])
            current["word_count"] = len(current["words"])
            current["byte_count"] = len(current["words"]) * 2
            current["terminated"] = bool(current["words"] and current["words"][-1] == 0xFFFF)
            entries.append(current)
        current = None

    for lineno, line in enumerate(path.read_text(errors="ignore").splitlines(), start=1):
        label_m = LABEL_RE.match(line)
        if label_m:
            finish()
            label = label_m.group(1)
            addr_m = ADDR_RE.search(line)
            addr = addr_m.group(1) if addr_m else None
            current = {
                "bank_file": path.name,
                "bank": path.stem.split("_")[-1].upper(),
                "label": label,
                "snes_addr": addr or "",
                "source_line": lineno,
                "words": [],
            }
        if current:
            dw_m = DW_RE.search(line)
            if dw_m:
                vals = [int(v, 16) for v in VAL_RE.findall(dw_m.group(1))]
                current["words"].extend(vals)
    finish()
    return entries


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--repo", default=".")
    ap.add_argument("--outdir", default="reports/decomp_pass02/text")
    args = ap.parse_args()
    repo = Path(args.repo)
    outdir = repo / args.outdir
    outdir.mkdir(parents=True, exist_ok=True)

    entries = []
    for bank in ["B6", "B7", "B8", "B9", "BA", "BB"]:
        entries.extend(parse_bank_file(repo / "src" / "data_banks" / f"bank_{bank}.asm"))

    csv_path = outdir / "text_entries_usa_source.csv"
    with csv_path.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=["bank", "bank_file", "label", "snes_addr", "source_line", "word_count", "byte_count", "terminated", "text"])
        w.writeheader()
        for e in entries:
            w.writerow({k: e[k] for k in w.fieldnames})

    json_path = outdir / "text_entries_usa_source.json"
    json_path.write_text(json.dumps([{k: v for k, v in e.items() if k != "words"} for e in entries], indent=2, ensure_ascii=False), encoding="utf-8")

    md = ["# Text entries extracted from source", "", f"Total entries: **{len(entries)}**", ""]
    by_bank = {}
    for e in entries:
        by_bank.setdefault(e["bank"], 0)
        by_bank[e["bank"]] += 1
    md.append("## Entries by bank")
    md.append("")
    md.append("| Bank | Entries |")
    md.append("|---|---:|")
    for bank in sorted(by_bank):
        md.append(f"| {bank} | {by_bank[bank]} |")
    md.append("")
    md.append("## First entries")
    md.append("")
    for e in entries[:40]:
        preview = e["text"].replace("\n", " / ")[:180]
        md.append(f"### {e['label']} @ ${e['snes_addr']}")
        md.append("")
        md.append("```text")
        md.append(preview)
        md.append("```")
        md.append("")
    (outdir / "text_entries_usa_source.md").write_text("\n".join(md), encoding="utf-8")
    print(f"Extracted {len(entries)} text entries to {outdir}")

if __name__ == "__main__":
    main()
