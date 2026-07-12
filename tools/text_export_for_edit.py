#!/usr/bin/env python3
"""Export Harvest Moon text entries to editable CSV/JSON templates.

The exporter is intentionally non-destructive: it does not modify ASM files.
Use text_edit_validator.py after editing the CSV to check length/codec safety.
"""
from __future__ import annotations
import argparse, csv, json, re
from pathlib import Path
from collections import Counter, defaultdict

from extract_text_banks import parse_bank_file
from hm_text_codec import decode_words_markup

BANKS = ["B6", "B7", "B8", "B9", "BA", "BB"]

CATEGORY_RE = re.compile(r"^Text_(?:[0-9A-F]{3}_)?([A-Za-z]+)_")


def infer_category(label: str, text: str) -> str:
    known_prefixes = {
        "Forecast": "Weather", "Weather": "Weather", "Diary": "Diary",
        "Sign": "Sign", "Manual": "Manual", "Cow": "Animal", "Animal": "Animal",
        "Shop": "Shop", "Bar": "Shop", "Shipping": "Shipping",
        "Church": "Church", "Festival": "Festival", "Romance": "Romance",
        "Recipe": "Recipe", "Name": "Naming", "Menu": "Menu",
    }
    parts = label.split("_")
    for p in parts[1:4]:
        if p in known_prefixes:
            return known_prefixes[p]
    m = CATEGORY_RE.match(label)
    if m:
        return m.group(1)
    low = text.lower()
    if "weather" in low or "rain" in low or "sunny" in low or "hurricane" in low:
        return "Weather"
    if "cow" in low or "chicken" in low or "horse" in low or "dog" in low:
        return "Animal"
    if "gold" in low or "shipping" in low or "ship" in low:
        return "Shipping"
    if "church" in low or "god" in low or "pray" in low:
        return "Church"
    return "Dialog"


def load_entries(repo: Path):
    entries = []
    for bank in BANKS:
        path = repo / "src" / "data_banks" / f"bank_{bank}.asm"
        for e in parse_bank_file(path):
            e = dict(e)
            e["index"] = len(entries)
            e["index_hex"] = f"{len(entries):03X}"
            e["category"] = infer_category(e["label"], e["text"])
            e["markup_text"] = decode_words_markup(e["words"])
            e["max_words"] = len(e["words"])
            e["max_bytes"] = len(e["words"]) * 2
            e["original_words_hex"] = " ".join(f"{w:04X}" for w in e["words"])
            entries.append(e)
    return entries


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--repo", default=".")
    ap.add_argument("--outdir", default="reports/decomp_pass04/text")
    args = ap.parse_args()
    repo = Path(args.repo)
    outdir = repo / args.outdir
    outdir.mkdir(parents=True, exist_ok=True)
    entries = load_entries(repo)

    fieldnames = [
        "index_hex", "bank", "snes_addr", "source_line", "label", "category",
        "max_words", "max_bytes", "current_words", "free_words", "markup_text",
        "edited_text", "notes"
    ]
    csv_path = outdir / "text_edit_template.csv"
    with csv_path.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader()
        for e in entries:
            w.writerow({
                "index_hex": e["index_hex"],
                "bank": e["bank"],
                "snes_addr": e["snes_addr"],
                "source_line": e["source_line"],
                "label": e["label"],
                "category": e["category"],
                "max_words": e["max_words"],
                "max_bytes": e["max_bytes"],
                "current_words": e["word_count"],
                "free_words": 0,
                "markup_text": e["markup_text"],
                "edited_text": "",
                "notes": "",
            })

    json_path = outdir / "text_edit_template.json"
    json_path.write_text(json.dumps([
        {k: v for k, v in e.items() if k not in {"words"}}
        for e in entries
    ], indent=2, ensure_ascii=False), encoding="utf-8")

    by_bank = Counter(e["bank"] for e in entries)
    by_cat = Counter(e["category"] for e in entries)
    md = [
        "# Pass 04 - editable text export", "",
        f"Total text entries exported: **{len(entries)}**", "",
        "## Files", "",
        f"- `{csv_path.relative_to(repo)}` - spreadsheet-style template; fill `edited_text` only.",
        f"- `{json_path.relative_to(repo)}` - richer catalog for scripts/tools.", "",
        "## Entries by bank", "", "| Bank | Entries |", "|---|---:|",
    ]
    for bank, count in sorted(by_bank.items()):
        md.append(f"| {bank} | {count} |")
    md += ["", "## Entries by category", "", "| Category | Entries |", "|---|---:|"]
    for cat, count in by_cat.most_common():
        md.append(f"| {cat} | {count} |")
    md += ["", "## Editing rule", "", "Do not edit `markup_text`. Copy it to `edited_text`, change only what you need, then run `tools/text_edit_validator.py`."]
    (outdir / "text_edit_export_report.md").write_text("\n".join(md), encoding="utf-8")
    print(f"Exported {len(entries)} entries to {csv_path}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
