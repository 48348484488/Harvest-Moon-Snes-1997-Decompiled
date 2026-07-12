#!/usr/bin/env python3
"""Plan Harvest Moon SNES text edits, including long-text repoint candidates.

This is a conservative planner. It does not mutate the source by default. It reads
an edit CSV exported by Pass 04, encodes edited_text with hm_text_codec, then
classifies every edit as:

  - INPLACE_OK: encoded edit fits the original text block budget.
  - REPOINT_NEEDED: encoded edit is valid but too long for the original block.
  - ENCODE_ERROR: unknown character/control markup.
  - UNCHANGED: blank edited_text or identical to original markup_text.

For REPOINT_NEEDED entries, it emits preview ASM blocks and replacement pointer
lines so a human can review the bank/space strategy before applying changes.
"""
from __future__ import annotations
import argparse
import csv
import json
import re
from dataclasses import dataclass, asdict
from pathlib import Path
from typing import Iterable, List, Optional

from hm_text_codec import encode_markup_text, format_dw

BANK_START = {bank: int(f"{bank}8000", 16) for bank in ["B6", "B7", "B8", "B9", "BA", "BB"]}
BANK_END = {bank: int(f"{bank}FFFF", 16) for bank in ["B6", "B7", "B8", "B9", "BA", "BB"]}


@dataclass
class PlanRow:
    index_hex: str
    bank: str
    snes_addr: str
    label: str
    category: str
    max_words: int
    old_bytes: int
    edited_words: Optional[int]
    edited_bytes: Optional[int]
    delta_words: Optional[int]
    delta_bytes: Optional[int]
    status: str
    repoint_label: str
    suggested_pointer_line: str
    note: str


def safe_label_piece(text: str, limit: int = 40) -> str:
    text = re.sub(r"^Text_", "", text)
    text = re.sub(r"[^A-Za-z0-9]+", "_", text).strip("_")
    if not text:
        return "EditedText"
    return text[:limit].strip("_") or "EditedText"


def write_csv(path: Path, rows: List[PlanRow]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as f:
        fieldnames = list(asdict(rows[0]).keys()) if rows else ["status"]
        w = csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader()
        for row in rows:
            w.writerow(asdict(row))


def markdown_escape(s: str) -> str:
    return (s or "").replace("|", "\\|")


def make_markdown(path: Path, rows: List[PlanRow], csv_rel: str, asm_rel: str, ptr_rel: str) -> None:
    total = len(rows)
    counts = {}
    for r in rows:
        counts[r.status] = counts.get(r.status, 0) + 1
    edited = total - counts.get("UNCHANGED", 0)
    repoints = [r for r in rows if r.status == "REPOINT_NEEDED"]
    inplace = [r for r in rows if r.status == "INPLACE_OK"]
    errors = [r for r in rows if r.status.startswith("ENCODE_ERROR")]
    biggest = sorted(repoints, key=lambda r: r.delta_words or 0, reverse=True)[:30]
    lines = [
        "# Pass 05 - text repoint plan",
        "",
        "This report plans edited text insertion without mutating the source automatically.",
        "It separates safe in-place edits from edits that require pointer redirection/repointing.",
        "",
        "## Summary",
        "",
        f"- Entries scanned: **{total}**",
        f"- Edited entries: **{edited}**",
        f"- In-place safe edits: **{len(inplace)}**",
        f"- Repoint-needed edits: **{len(repoints)}**",
        f"- Encoding errors: **{len(errors)}**",
        f"- Unchanged/blank entries: **{counts.get('UNCHANGED', 0)}**",
        "",
        "## Outputs",
        "",
        f"- Plan CSV: `{csv_rel}`",
        f"- New text block preview ASM: `{asm_rel}`",
        f"- Pointer-table replacement preview: `{ptr_rel}`",
        "",
        "## Repoint-needed entries with largest growth",
        "",
        "| index | bank | label | old words | new words | delta words | category |",
        "|---:|---|---|---:|---:|---:|---|",
    ]
    for r in biggest:
        lines.append(f"| ${r.index_hex} | {r.bank} | `{markdown_escape(r.label)}` | {r.max_words} | {r.edited_words} | {r.delta_words} | {markdown_escape(r.category)} |")
    if not biggest:
        lines.append("| - | - | - | - | - | - | - |")
    lines += [
        "",
        "## How to use this safely",
        "",
        "1. Fill `edited_text` in the Pass 04 CSV.",
        "2. Run this planner.",
        "3. Apply `INPLACE_OK` entries directly into the original labels only if you want same-location replacement.",
        "4. For `REPOINT_NEEDED`, place the generated `Text_Repoint_*` blocks in reviewed free/expanded space.",
        "5. Replace only the matching `dl Text_...` pointer-table lines with the generated pointer lines.",
        "6. Rebuild and compare. If you are editing the USA base, byte-perfect is expected only before edits; after edits, use emulator testing and checksum repair.",
        "",
        "The planner intentionally does not guess free space blindly. Long strings should be inserted into a known text expansion area or into a manually expanded ROM/bank layout.",
    ]
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--repo", default=".")
    ap.add_argument("--csv", default="reports/decomp_pass04/text/text_edit_template.csv")
    ap.add_argument("--outdir", default="reports/decomp_pass05/text")
    ap.add_argument("--asm-out", default="patches/pass05_repoint_text_blocks_preview.asm")
    ap.add_argument("--pointer-out", default="patches/pass05_pointer_table_replacements_preview.asm")
    args = ap.parse_args()

    repo = Path(args.repo)
    input_csv = repo / args.csv
    outdir = repo / args.outdir
    outdir.mkdir(parents=True, exist_ok=True)

    rows_raw = list(csv.DictReader(input_csv.open(encoding="utf-8")))
    plan: List[PlanRow] = []
    asm_lines = [
        "; Pass 05 repoint text block preview",
        "; Generated by tools/text_repoint_planner.py",
        "; Not included automatically. Place reviewed blocks in chosen free/expanded space.",
        "",
    ]
    ptr_lines = [
        "; Pass 05 pointer table replacement preview",
        "; Replace matching dl lines in src/code_banks/bank_83.asm only after placing text blocks.",
        "",
    ]

    for row in rows_raw:
        edited = (row.get("edited_text") or "").strip("\ufeff")
        original = row.get("markup_text") or ""
        label = row.get("label") or "Text_Unknown"
        max_words = int(row.get("max_words") or 0)
        status = "UNCHANGED"
        edited_words = edited_bytes = delta_words = delta_bytes = None
        repoint_label = ""
        ptr_line = ""
        note = ""

        if edited and edited != original:
            try:
                encoded = encode_markup_text(edited)
                edited_words = len(encoded)
                edited_bytes = edited_words * 2
                delta_words = edited_words - max_words
                delta_bytes = delta_words * 2
                if edited_words <= max_words:
                    status = "INPLACE_OK"
                    note = "Fits original block budget. Repoint not required."
                else:
                    status = "REPOINT_NEEDED"
                    repoint_label = f"Text_Repoint_{row.get('index_hex','XXX')}_{safe_label_piece(label)}"
                    ptr_line = f"        dl {repoint_label:<48} ; replaces ${row.get('index_hex','???')} {label}"
                    note = "Too long for original block; needs pointer redirection and reviewed free/expanded space."
                    asm_lines.append(f"; index ${row.get('index_hex')} | old {row.get('bank')}:{row.get('snes_addr')} | {label}")
                    asm_lines.append(f"; old budget: {max_words} words / {max_words*2} bytes")
                    asm_lines.append(f"; new size: {edited_words} words / {edited_bytes} bytes | delta {delta_words:+} words")
                    asm_lines.append(f"{repoint_label}:")
                    asm_lines.append(format_dw(encoded))
                    asm_lines.append("")
                    ptr_lines.append(f"; index ${row.get('index_hex')} | {label}")
                    ptr_lines.append(ptr_line)
                    ptr_lines.append("")
            except Exception as exc:  # noqa: BLE001
                status = f"ENCODE_ERROR: {exc}"
                note = "Fix edited_text characters/control markup before planning."

        plan.append(PlanRow(
            index_hex=row.get("index_hex", ""),
            bank=row.get("bank", ""),
            snes_addr=row.get("snes_addr", ""),
            label=label,
            category=row.get("category", ""),
            max_words=max_words,
            old_bytes=max_words * 2,
            edited_words=edited_words,
            edited_bytes=edited_bytes,
            delta_words=delta_words,
            delta_bytes=delta_bytes,
            status=status,
            repoint_label=repoint_label,
            suggested_pointer_line=ptr_line,
            note=note,
        ))

    plan_csv = outdir / "text_repoint_plan.csv"
    write_csv(plan_csv, plan)
    plan_json = outdir / "text_repoint_plan.json"
    plan_json.write_text(json.dumps([asdict(r) for r in plan], indent=2, ensure_ascii=False), encoding="utf-8")

    asm_path = repo / args.asm_out
    asm_path.parent.mkdir(parents=True, exist_ok=True)
    asm_path.write_text("\n".join(asm_lines), encoding="utf-8")

    ptr_path = repo / args.pointer_out
    ptr_path.parent.mkdir(parents=True, exist_ok=True)
    ptr_path.write_text("\n".join(ptr_lines), encoding="utf-8")

    report_md = outdir / "text_repoint_plan.md"
    make_markdown(report_md, plan, str(plan_csv.relative_to(repo)), args.asm_out, args.pointer_out)

    counts = {}
    for r in plan:
        counts[r.status] = counts.get(r.status, 0) + 1
    print(f"Scanned {len(plan)} rows. In-place={counts.get('INPLACE_OK',0)} repoint={counts.get('REPOINT_NEEDED',0)} errors={sum(1 for r in plan if r.status.startswith('ENCODE_ERROR'))}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
