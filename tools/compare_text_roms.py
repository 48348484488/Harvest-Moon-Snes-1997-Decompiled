#!/usr/bin/env python3
"""Compare USA-source text blocks against a BR ROM at the same SNES addresses.

The tool uses labels/start addresses from src/data_banks/bank_B6-BB.asm, then
reads words from the supplied ROM until FFFF or a safety boundary. This is useful
for translation-hack analysis: changed text is detected without needing to fully
reverse the pointer tables first.
"""
from __future__ import annotations
import argparse, csv, json, re
from pathlib import Path
from hm_text_codec import decode_words
from extract_text_banks import parse_bank_file


def snes_to_pc(addr_hex: str) -> int:
    addr = int(addr_hex, 16)
    bank = (addr >> 16) & 0xFF
    off = addr & 0xFFFF
    if off < 0x8000:
        raise ValueError(f"Not a LoROM mapped address: ${addr_hex}")
    return ((bank & 0x7F) * 0x8000) + (off & 0x7FFF)


def read_words_until(data: bytes, pc: int, max_words: int) -> list[int]:
    words = []
    for i in range(max_words):
        p = pc + i * 2
        if p + 1 >= len(data):
            break
        word = data[p] | (data[p + 1] << 8)
        words.append(word)
        if word == 0xFFFF:
            break
    return words


def load_source_entries(repo: Path):
    entries = []
    for bank in ["B6", "B7", "B8", "B9", "BA", "BB"]:
        entries.extend(parse_bank_file(repo / "src" / "data_banks" / f"bank_{bank}.asm"))
    entries = [e for e in entries if e.get("snes_addr")]
    # Add next start within same bank, for safe bounds.
    by_bank = {}
    for e in entries:
        by_bank.setdefault(e["bank"], []).append(e)
    for bank_entries in by_bank.values():
        bank_entries.sort(key=lambda e: int(e["snes_addr"], 16))
        for idx, e in enumerate(bank_entries):
            e["next_snes_addr"] = bank_entries[idx + 1]["snes_addr"] if idx + 1 < len(bank_entries) else ""
    return entries


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--repo", default=".")
    ap.add_argument("--br-rom", required=True, help="Path to BR translated ROM .sfc/.smc")
    ap.add_argument("--outdir", default="reports/decomp_pass02/text")
    args = ap.parse_args()
    repo = Path(args.repo)
    br_rom = Path(args.br_rom)
    outdir = repo / args.outdir
    outdir.mkdir(parents=True, exist_ok=True)
    data = br_rom.read_bytes()

    rows = []
    entries = load_source_entries(repo)
    for e in entries:
        pc = snes_to_pc(e["snes_addr"])
        max_words = max(len(e["words"]), 1)
        # Allow a little slack for translated strings, but do not run into the
        # next source label when known.
        if e.get("next_snes_addr"):
            next_pc = snes_to_pc(e["next_snes_addr"])
            max_by_next = max(1, (next_pc - pc) // 2)
            max_words = min(max_by_next, max(max_words + 64, max_words))
        else:
            max_words = min(max_words + 64, 0x400)
        br_words = read_words_until(data, pc, max_words)
        usa_words = e["words"]
        equal = usa_words == br_words[:len(usa_words)] and len(usa_words) == len(br_words)
        changed = usa_words != br_words
        row = {
            "bank": e["bank"],
            "label": e["label"],
            "snes_addr": e["snes_addr"],
            "pc_offset": f"0x{pc:06X}",
            "usa_word_count": len(usa_words),
            "br_word_count": len(br_words),
            "changed": changed,
            "usa_text": decode_words(usa_words),
            "br_text": decode_words(br_words),
        }
        rows.append(row)

    csv_path = outdir / "text_compare_usa_source_vs_br_rom.csv"
    with csv_path.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader()
        w.writerows(rows)

    json_path = outdir / "text_compare_usa_source_vs_br_rom.json"
    json_path.write_text(json.dumps(rows, indent=2, ensure_ascii=False), encoding="utf-8")

    by_bank = {}
    changed_rows = [r for r in rows if r["changed"]]
    for r in rows:
        b = by_bank.setdefault(r["bank"], {"entries": 0, "changed": 0})
        b["entries"] += 1
        b["changed"] += int(bool(r["changed"]))

    md = ["# USA source text vs BR ROM text", "", f"Total text entries checked: **{len(rows)}**", f"Changed at same address: **{len(changed_rows)}**", ""]
    md.append("## Changed entries by bank")
    md.append("")
    md.append("| Bank | Entries | Changed | Changed % |")
    md.append("|---|---:|---:|---:|")
    for bank in sorted(by_bank):
        stats = by_bank[bank]
        pct = (stats["changed"] / stats["entries"] * 100) if stats["entries"] else 0
        md.append(f"| {bank} | {stats['entries']} | {stats['changed']} | {pct:.1f}% |")
    md.append("")
    md.append("## First changed examples")
    md.append("")
    for r in changed_rows[:80]:
        md.append(f"### {r['label']} @ ${r['snes_addr']} / {r['pc_offset']}")
        md.append("")
        md.append("USA/source:")
        md.append("```text")
        md.append(r["usa_text"][:800])
        md.append("```")
        md.append("BR ROM same address:")
        md.append("```text")
        md.append(r["br_text"][:800])
        md.append("```")
        md.append("")
    (outdir / "text_compare_usa_source_vs_br_rom.md").write_text("\n".join(md), encoding="utf-8")

    changed_label_list = "\n".join(f"{r['bank']} ${r['snes_addr']} {r['label']}" for r in changed_rows)
    (outdir / "changed_text_labels.txt").write_text(changed_label_list + "\n", encoding="utf-8")
    print(f"Compared {len(rows)} entries; changed={len(changed_rows)}")

if __name__ == "__main__":
    main()
