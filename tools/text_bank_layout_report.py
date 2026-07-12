#!/usr/bin/env python3
"""Generate a conservative text-bank layout report for HM SNES text banks B6-BB."""
from __future__ import annotations
import argparse, csv, re
from dataclasses import dataclass
from pathlib import Path
from typing import List

BANKS = ["B6", "B7", "B8", "B9", "BA", "BB"]
BANK_START = {b: int(f"{b}8000", 16) for b in BANKS}
BANK_END_EXCLUSIVE = {b: int(f"{b}0000", 16) + 0x10000 for b in BANKS}

@dataclass
class Entry:
    index_hex: str
    bank: str
    addr: int
    label: str
    words: int
    bytes: int


def read_entries(csv_path: Path) -> List[Entry]:
    rows = list(csv.DictReader(csv_path.open(encoding="utf-8")))
    entries = []
    for r in rows:
        bank = r.get("bank", "")
        if bank not in BANKS:
            continue
        entries.append(Entry(
            index_hex=r.get("index_hex", ""),
            bank=bank,
            addr=int(r.get("snes_addr", "0"), 16),
            label=r.get("label", ""),
            words=int(r.get("max_words") or 0),
            bytes=int(r.get("max_words") or 0) * 2,
        ))
    return entries


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--repo", default=".")
    ap.add_argument("--csv", default="reports/decomp_pass04/text/text_edit_template.csv")
    ap.add_argument("--outdir", default="reports/decomp_pass05/text")
    args = ap.parse_args()
    repo = Path(args.repo)
    entries = read_entries(repo / args.csv)
    outdir = repo / args.outdir
    outdir.mkdir(parents=True, exist_ok=True)

    layout_rows = []
    gap_rows = []
    md = ["# Pass 05 - text bank layout", "", "Conservative layout based on exported text entries and their original word budgets.", ""]
    for bank in BANKS:
        bank_entries = sorted([e for e in entries if e.bank == bank], key=lambda e: e.addr)
        if not bank_entries:
            continue
        used = 0
        prev_end = BANK_START[bank]
        gaps = []
        for e in bank_entries:
            if e.addr > prev_end:
                gaps.append((prev_end, e.addr, e.addr - prev_end, "between_text_entries"))
            end = e.addr + e.bytes
            used += e.bytes
            layout_rows.append({
                "index_hex": e.index_hex,
                "bank": bank,
                "start_snes": f"{e.addr:06X}",
                "end_snes_exclusive": f"{end:06X}",
                "bytes": e.bytes,
                "words": e.words,
                "label": e.label,
            })
            prev_end = max(prev_end, end)
        bank_end = BANK_END_EXCLUSIVE[bank]
        if prev_end < bank_end:
            gaps.append((prev_end, bank_end, bank_end - prev_end, "tail_after_last_text_exported"))
        for start, end, size, kind in gaps:
            gap_rows.append({
                "bank": bank,
                "start_snes": f"{start:06X}",
                "end_snes_exclusive": f"{end:06X}",
                "bytes": size,
                "words": size // 2,
                "kind": kind,
            })
        text_start = bank_entries[0].addr
        text_end = max(e.addr + e.bytes for e in bank_entries)
        md += [
            f"## Bank ${bank}", "",
            f"- Entries: **{len(bank_entries)}**",
            f"- First exported text: `${text_start:06X}`",
            f"- Last exported text end: `${text_end:06X}`",
            f"- Exported text bytes: **{used}**",
            f"- Conservative gaps detected: **{sum(g[2] for g in gaps)} bytes** across **{len(gaps)} ranges**",
            "",
        ]
        if gaps:
            md += ["| start | end excl. | bytes | kind |", "|---:|---:|---:|---|"]
            for g in gaps[:20]:
                md.append(f"| `${g[0]:06X}` | `${g[1]:06X}` | {g[2]} | {g[3]} |")
            if len(gaps) > 20:
                md.append(f"| ... | ... | ... | {len(gaps)-20} more |")
            md.append("")

    for name, rows in [("text_bank_layout.csv", layout_rows), ("text_bank_gaps.csv", gap_rows)]:
        with (outdir / name).open("w", newline="", encoding="utf-8") as f:
            fieldnames = list(rows[0].keys()) if rows else ["empty"]
            w = csv.DictWriter(f, fieldnames=fieldnames)
            w.writeheader(); w.writerows(rows)
    (outdir / "text_bank_layout.md").write_text("\n".join(md), encoding="utf-8")
    print(f"Wrote layout for {len(entries)} text entries; gaps={len(gap_rows)}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
