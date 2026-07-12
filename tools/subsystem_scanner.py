#!/usr/bin/env python3
"""
Scan HM-Decomp source for variables tied to selected gameplay subsystems.
Outputs Markdown and CSV cross-reference reports.
No ROM is required.
"""
from __future__ import annotations

import csv
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / "src"
OUT_DIR = ROOT / "reports" / "decomp_pass"
OUT_DIR.mkdir(parents=True, exist_ok=True)

SUBSYSTEMS = {
    "time_day_cycle": [
        "time_running", "year", "season", "weekday", "day", "hour", "minutes", "seconds",
        "weather_tomorrow", "palette_to_load", "next_hourly_palette",
    ],
    "stamina": [
        "max_stamina", "current_stamina", "exaustion_level", "player_action", "game_state",
    ],
    "shipping_money": [
        "shipping_moneyL", "shipping_moneyH", "moneyL", "moneyH",
    ],
    "tools_items": [
        "item_on_hand", "old_item_on_hand", "tool_selected", "tool_backpack", "watering_can_water",
        "seeds_grass_N", "seeds_corn_N", "seeds_tomato_N", "seeds_potato_N", "seeds_turnip_N",
        "feed_cow_N", "feed_chicks_N", "shed_items_row_1", "shed_items_row_2", "shed_items_row_3", "shed_items_row_4",
    ],
}

ASM_FILES = sorted(SRC.rglob("*.asm"))

rows: list[dict[str, str | int]] = []
for file in ASM_FILES:
    try:
        lines = file.read_text(encoding="utf-8", errors="replace").splitlines()
    except Exception:
        continue
    for lineno, line in enumerate(lines, 1):
        stripped = line.strip()
        for subsystem, names in SUBSYSTEMS.items():
            for name in names:
                if re.search(rf"!{re.escape(name)}\b", line):
                    rows.append({
                        "subsystem": subsystem,
                        "symbol": "!" + name,
                        "file": str(file.relative_to(ROOT)),
                        "line": lineno,
                        "text": stripped,
                    })

csv_path = OUT_DIR / "subsystem_xrefs.csv"
with csv_path.open("w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=["subsystem", "symbol", "file", "line", "text"])
    writer.writeheader()
    writer.writerows(rows)

md_path = OUT_DIR / "subsystem_xrefs.md"
with md_path.open("w", encoding="utf-8") as f:
    f.write("# Decomp Pass 01 - Subsystem Cross References\n\n")
    f.write(f"Total references found: `{len(rows)}`\n\n")
    for subsystem in SUBSYSTEMS:
        subrows = [r for r in rows if r["subsystem"] == subsystem]
        f.write(f"## {subsystem}\n\n")
        f.write(f"References: `{len(subrows)}`\n\n")
        counts: dict[str, int] = {}
        for r in subrows:
            counts[str(r["symbol"])] = counts.get(str(r["symbol"]), 0) + 1
        f.write("| Symbol | References |\n|---|---:|\n")
        for sym, count in sorted(counts.items(), key=lambda item: (-item[1], item[0])):
            f.write(f"| `{sym}` | {count} |\n")
        f.write("\n### First references\n\n")
        f.write("| Symbol | Location | Code |\n|---|---|---|\n")
        for r in subrows[:80]:
            code = str(r["text"]).replace("|", "\\|")
            f.write(f"| `{r['symbol']}` | `{r['file']}:{r['line']}` | `{code}` |\n")
        f.write("\n")

print(f"Wrote {csv_path}")
print(f"Wrote {md_path}")
