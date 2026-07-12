#!/usr/bin/env python3
"""Validate an edited Harvest Moon text CSV and emit safe ASM preview blocks.

Input: reports/decomp_pass04/text/text_edit_template.csv
Fill only the `edited_text` column. This validator checks whether the edit can be
encoded with the known text table and whether it fits the original word budget.
"""
from __future__ import annotations
import argparse, csv
from pathlib import Path
from hm_text_codec import encode_markup_text, format_dw


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--repo", default=".")
    ap.add_argument("--csv", default="reports/decomp_pass04/text/text_edit_template.csv")
    ap.add_argument("--outdir", default="reports/decomp_pass04/text")
    ap.add_argument("--asm-out", default="patches/pass04_text_edit_preview.asm")
    args = ap.parse_args()
    repo = Path(args.repo)
    csv_path = repo / args.csv
    outdir = repo / args.outdir
    outdir.mkdir(parents=True, exist_ok=True)

    rows = list(csv.DictReader(csv_path.open(encoding="utf-8")))
    results = []
    asm_blocks = [
        "; Pass 04 text edit preview",
        "; This file is generated for manual review. It is NOT automatically included by src/main.asm.",
        "; Copy validated blocks into the matching bank file only after reviewing size/pointer constraints.",
        "",
    ]

    changed = 0
    ok = 0
    too_long = 0
    errors = 0
    unchanged = 0

    for row in rows:
        edited = (row.get("edited_text") or "").strip("\ufeff")
        original = row.get("markup_text") or ""
        if not edited or edited == original:
            status = "UNCHANGED"
            encoded_len = ""
            delta = ""
            unchanged += 1
        else:
            changed += 1
            try:
                encoded = encode_markup_text(edited)
                encoded_len_i = len(encoded)
                max_words = int(row["max_words"])
                delta_i = encoded_len_i - max_words
                encoded_len = str(encoded_len_i)
                delta = str(delta_i)
                if encoded_len_i <= max_words:
                    status = "OK_FITS"
                    ok += 1
                    asm_blocks.append(f"; index ${row['index_hex']} | {row['bank']}:{row['snes_addr']} | {row['label']}")
                    asm_blocks.append(f"; original budget: {max_words} words / {max_words*2} bytes")
                    asm_blocks.append(f"{row['label']}:")
                    asm_blocks.append(format_dw(encoded))
                    if encoded_len_i < max_words:
                        padding = [0x00B1] * (max_words - encoded_len_i)
                        asm_blocks.append("; optional padding to preserve exact block size")
                        asm_blocks.append(format_dw(padding))
                    asm_blocks.append("")
                else:
                    status = "TOO_LONG"
                    too_long += 1
            except Exception as exc:  # noqa: BLE001 - CLI report should keep going
                status = f"ENCODE_ERROR: {exc}"
                encoded_len = ""
                delta = ""
                errors += 1
        results.append({
            "index_hex": row.get("index_hex", ""),
            "bank": row.get("bank", ""),
            "label": row.get("label", ""),
            "category": row.get("category", ""),
            "max_words": row.get("max_words", ""),
            "encoded_words": encoded_len,
            "delta_words": delta,
            "status": status,
        })

    result_csv = outdir / "text_edit_validation.csv"
    with result_csv.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=list(results[0].keys()) if results else ["status"])
        w.writeheader()
        w.writerows(results)

    asm_path = repo / args.asm_out
    asm_path.parent.mkdir(parents=True, exist_ok=True)
    asm_path.write_text("\n".join(asm_blocks), encoding="utf-8")

    md = [
        "# Pass 04 - text edit validation", "",
        f"Input CSV: `{csv_path.relative_to(repo)}`", "",
        "## Summary", "",
        f"- Entries scanned: **{len(rows)}**",
        f"- Edited entries: **{changed}**",
        f"- OK and fitting: **{ok}**",
        f"- Too long: **{too_long}**",
        f"- Encoding errors: **{errors}**",
        f"- Unchanged/blank: **{unchanged}**", "",
        "## Output", "",
        f"- `{result_csv.relative_to(repo)}`",
        f"- `{asm_path.relative_to(repo)}`", "",
        "A text edit is safe only when it is `OK_FITS`. Long text usually needs repointing/free-space work, not just replacement.",
    ]
    (outdir / "text_edit_validation.md").write_text("\n".join(md), encoding="utf-8")
    print(f"Validated {len(rows)} rows. Edited={changed}, OK={ok}, too_long={too_long}, errors={errors}")
    return 0 if too_long == 0 and errors == 0 else 1

if __name__ == "__main__":
    raise SystemExit(main())
