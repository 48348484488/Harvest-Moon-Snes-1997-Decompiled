#!/usr/bin/env python3
"""Pass 07 helper: catalog held-item IDs, item behavior tables, prices and text links.

This script intentionally does not modify ROM data. It reads the clean USA ROM, the
current ASM source and the text catalog generated in Pass 03/04, then emits
human-readable reverse-engineering reports for the held-item system.
"""
from __future__ import annotations

import csv
import html
import json
import re
from pathlib import Path
from typing import Dict, List

ROOT = Path(__file__).resolve().parents[1]
ROM_PATH = ROOT / "roms" / "Harvest Moon (USA).sfc"
SRC_DIR = ROOT / "src"
OUT_DIR = ROOT / "reports" / "decomp_pass07" / "items"
TEXT_CATALOG = ROOT / "reports" / "decomp_pass03" / "text" / "text_pointer_catalog.csv"

ITEM_COUNT = 0x5B  # observed from table sizes: 0x00 through 0x5A
TABLES = {
    "animation_ptr": 0x8196AF,       # 3 bytes per item
    "action_jump": 0x8197C0,         # 2 bytes per item
    "shipping_price": 0x819FDE,      # 2 bytes per item: low=placement/action value, high=shipping value
    "shop_sell": 0x81A094,           # 3 bytes per item: word=text id, byte=direct-sale value
    "tile_interaction": 0x81A2AD,    # 1 byte per item
    "sound_flag": 0x81A308,          # 1 byte per item
}

# Conservative names, mostly from existing RAM comments + linked sell dialog text.
# item_on_hand is NOT always identical to tool_selected; keep ambiguous names marked.
KNOWN_ITEM_NAMES = {
    0x00: "None / empty hand",
    0x01: "Mushroom / generic carried item 01",
    0x02: "Poisonous mushroom / generic carried item 02",
    0x03: "Wild grape / generic carried item 03",
    0x04: "Tropical fruit / generic carried item 04",
    0x05: "Fullmoon Plant berry / rare mountain item",
    0x06: "Unknown carried item 06; shop text 0313 special case",
    0x07: "Fish",
    0x08: "Unknown carried item 08",
    0x09: "Unknown carried item 09",
    0x0A: "Unknown carried item 0A",
    0x0B: "Unknown carried item 0B",
    0x0C: "Unknown carried item 0C",
    0x0D: "Placed/field item candidate 0D",
    0x0E: "Placed/field item candidate 0E",
    0x0F: "Placed/field item candidate 0F",
    0x10: "Corn",
    0x11: "Tomato",
    0x12: "Potato",
    0x13: "Turnip",
    0x14: "Egg",
    0x15: "Milk S / milk item candidate",
    0x16: "Milk M / milk item candidate",
    0x17: "Milk L / milk item candidate",
    0x18: "Good herb / herb item",
    0x19: "Chicken feed when carried from shed",
    0x1A: "Cow feed when carried from shed",
    0x25: "Special carried item; shop text 0313 special case",
    0x26: "Special carried item; shop text 0313 special case",
    0x57: "Animal/field generated carried item 57",
    0x58: "Event/animal carried item 58",
    0x59: "Event/animal carried item 59",
    0x5A: "Event/animal carried item 5A",
}

TABLE_RENAMES = {
    "HeldItem_UseOrInteract_Main": "main dispatcher for current !item_on_hand",
    "HeldItem_LoadAnimationFrameData": "loads graphics/placement metadata for held item",
    "HeldItem_ActionJumpTable": "indirect behavior routine table indexed by item_on_hand",
    "HeldItem_AnimationDataPtrTable": "24-bit metadata pointer table indexed by item_on_hand",
    "HeldItem_ShippingPriceTable": "normal shipping-bin placement/price table",
    "HeldItem_ShopSellDialogAndPriceTable": "direct-sale dialog/price table",
    "HeldItem_TileInteractionTypeTable": "front-tile interaction lookup",
    "HeldItem_UseSoundFlagTable": "sound trigger lookup",
    "HeldItem_DropTargetCoordinateTable": "scripted drop target coordinates",
    "HeldItem_DroppedOnShippingBin": "shipping-bin drop handler",
    "HeldItem_DroppedOnSpecialPlace": "special-place drop fallback",
}


def lorom_to_pc(snes: int) -> int:
    bank = (snes >> 16) & 0xFF
    addr = snes & 0xFFFF
    if addr < 0x8000:
        raise ValueError(f"not LoROM mapped: {snes:06X}")
    return ((bank & 0x7F) * 0x8000) + (addr & 0x7FFF)


def rb(rom: bytes, snes: int, n: int) -> bytes:
    pc = lorom_to_pc(snes)
    return rom[pc:pc+n]


def r8(rom: bytes, snes: int) -> int:
    return rb(rom, snes, 1)[0]


def r16(rom: bytes, snes: int) -> int:
    b = rb(rom, snes, 2)
    return b[0] | (b[1] << 8)


def r24(rom: bytes, snes: int) -> int:
    b = rb(rom, snes, 3)
    return b[0] | (b[1] << 8) | (b[2] << 16)


def load_text_catalog() -> Dict[str, Dict[str, str]]:
    out: Dict[str, Dict[str, str]] = {}
    if not TEXT_CATALOG.exists():
        return out
    with TEXT_CATALOG.open(newline='', encoding='utf-8') as f:
        for row in csv.DictReader(f):
            out[row.get('index_hex', '').upper()] = row
    return out


def scan_xrefs() -> Dict[str, List[str]]:
    refs = {k: [] for k in TABLE_RENAMES}
    patterns = list(refs)
    for p in SRC_DIR.rglob('*.asm'):
        try:
            lines = p.read_text(encoding='utf-8', errors='replace').splitlines()
        except Exception:
            continue
        for i, line in enumerate(lines, 1):
            for pat in patterns:
                if pat in line:
                    refs[pat].append(f"{p.relative_to(ROOT)}:{i}: {line.strip()}")
    return refs


def build_catalog(rom: bytes, textcat: Dict[str, Dict[str, str]]):
    rows = []
    for item_id in range(ITEM_COUNT):
        anim_ptr = r24(rom, TABLES['animation_ptr'] + item_id * 3)
        action_word = r16(rom, TABLES['action_jump'] + item_id * 2)
        action_snes = None if action_word in (0x0000, 0xFFFF) else 0x810000 | action_word
        shipping_low = r8(rom, TABLES['shipping_price'] + item_id * 2)
        shipping_value = r8(rom, TABLES['shipping_price'] + item_id * 2 + 1)
        shop_text = r16(rom, TABLES['shop_sell'] + item_id * 3)
        shop_value = r8(rom, TABLES['shop_sell'] + item_id * 3 + 2)
        tile_interaction = r8(rom, TABLES['tile_interaction'] + item_id)
        sound_flag = r8(rom, TABLES['sound_flag'] + item_id)
        text_hex = f"{shop_text:03X}"
        textrow = textcat.get(text_hex, {})
        rows.append({
            'item_id_hex': f"{item_id:02X}",
            'item_id_dec': item_id,
            'working_name': KNOWN_ITEM_NAMES.get(item_id, ''),
            'action_ptr_snes': '' if action_snes is None else f"{action_snes:06X}",
            'action_ptr_word': f"{action_word:04X}",
            'anim_ptr_snes': f"{anim_ptr:06X}",
            'shipping_tile_or_action_value_hex': f"{shipping_low:02X}",
            'shipping_value_raw': shipping_value,
            'shop_text_id_hex': '' if shop_text == 0 else text_hex,
            'shop_text_label': textrow.get('label', ''),
            'shop_text_preview': textrow.get('text_preview', ''),
            'direct_sell_value_raw': shop_value,
            'tile_interaction_type_hex': f"{tile_interaction:02X}",
            'use_sound_flag': sound_flag,
        })
    return rows


def write_csv(rows):
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    path = OUT_DIR / 'held_item_catalog.csv'
    with path.open('w', newline='', encoding='utf-8') as f:
        w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader(); w.writerows(rows)


def write_json(rows):
    (OUT_DIR / 'held_item_catalog.json').write_text(json.dumps(rows, indent=2, ensure_ascii=False), encoding='utf-8')


def md_table(rows, interesting_only=False):
    if interesting_only:
        rows = [r for r in rows if r['working_name'] or int(r['shipping_value_raw']) or int(r['direct_sell_value_raw']) or r['shop_text_id_hex']]
    lines = ["| ID | Working name | Action | Ship value | Shop text | Direct value | Sound |", "|---:|---|---:|---:|---|---:|---:|"]
    for r in rows:
        text = r['shop_text_label'] or r['shop_text_id_hex']
        lines.append(f"| ${r['item_id_hex']} | {r['working_name']} | {r['action_ptr_snes']} | {r['shipping_value_raw']} | {text} | {r['direct_sell_value_raw']} | {r['use_sound_flag']} |")
    return '\n'.join(lines)


def write_markdown(rows, xrefs):
    notable = [r for r in rows if r['working_name'] or int(r['shipping_value_raw']) or int(r['direct_sell_value_raw']) or r['shop_text_id_hex']]
    sale_rows = [r for r in rows if int(r['shipping_value_raw']) or int(r['direct_sell_value_raw']) or r['shop_text_id_hex']]
    lines = []
    lines.append('# Decomp Pass 07 - Held item / inventory catalog')
    lines.append('')
    lines.append('This report maps the held-item system around `!item_on_hand` (`$091D`) and the tables in bank `$81`.')
    lines.append('The values are extracted from the clean USA ROM, not guessed from comments only.')
    lines.append('')
    lines.append('## Main findings')
    lines.append('')
    lines.append(f'- Item ID range covered by the observed tables: `$00-$5A` ({ITEM_COUNT} entries).')
    lines.append('- `HeldItem_ActionJumpTable` is an indirect behavior routine table indexed by `!item_on_hand * 2`.')
    lines.append('- `HeldItem_AnimationDataPtrTable` is indexed by `!item_on_hand * 3` and provides 24-bit metadata pointers.')
    lines.append('- `HeldItem_ShippingPriceTable` is two bytes per item: the low byte is used by placement/tile logic, the high byte is used as normal shipping value.')
    lines.append('- `HeldItem_ShopSellDialogAndPriceTable` is three bytes per item: word = text/dialog id, byte = direct-sale value.')
    lines.append('- The code checks time before crediting normal shipping: the drop handler rejects same-day value addition after hour `$11`/17 depending on path comments; more behavioral testing is still needed.')
    lines.append('')
    lines.append('## Notable item IDs')
    lines.append('')
    lines.append(md_table(notable, False))
    lines.append('')
    lines.append('## Sell/dialog-linked entries')
    lines.append('')
    for r in sale_rows:
        lines.append(f"### Item ${r['item_id_hex']} - {r['working_name'] or 'unclassified'}")
        lines.append(f"- Action pointer: `{r['action_ptr_snes'] or r['action_ptr_word']}`")
        lines.append(f"- Normal shipping value raw: `{r['shipping_value_raw']}`")
        lines.append(f"- Direct sell value raw: `{r['direct_sell_value_raw']}`")
        lines.append(f"- Direct sell text: `{r['shop_text_id_hex']}` `{r['shop_text_label']}`")
        if r['shop_text_preview']:
            preview = r['shop_text_preview'].replace('|', '\\|')[:500]
            lines.append(f"- Text preview: {preview}")
        lines.append('')
    lines.append('## Xrefs for renamed item tables')
    lines.append('')
    for name, desc in TABLE_RENAMES.items():
        lines.append(f"### `{name}`")
        lines.append(f"{desc}.")
        refs = xrefs.get(name, [])
        lines.append(f"References found: `{len(refs)}`")
        for ref in refs[:20]:
            lines.append(f"- `{ref}`")
        if len(refs) > 20:
            lines.append(f"- ... {len(refs)-20} more")
        lines.append('')
    (OUT_DIR / 'held_item_catalog.md').write_text('\n'.join(lines), encoding='utf-8')


def write_html(rows):
    headers = list(rows[0].keys())
    trs=[]
    for r in rows:
        tds=''.join(f'<td>{html.escape(str(r[h]))}</td>' for h in headers)
        trs.append(f'<tr>{tds}</tr>')
    html_doc = f'''<!doctype html>
<html><head><meta charset="utf-8"><title>HM Held Item Catalog - Pass 07</title>
<style>
body{{font-family:system-ui,Arial,sans-serif;background:#111;color:#eee;margin:24px}}
input{{width:100%;padding:12px;border-radius:8px;border:1px solid #555;background:#1c1c1c;color:#fff;margin:0 0 16px}}
table{{border-collapse:collapse;width:100%;font-size:13px}}
th,td{{border:1px solid #333;padding:6px;vertical-align:top}}
th{{position:sticky;top:0;background:#222}}
tr:nth-child(even){{background:#171717}}
code{{color:#ffd37a}}
</style></head><body>
<h1>Harvest Moon SNES - Held Item Catalog</h1>
<p>Pass 07 catalog generated from the USA ROM tables. Search by item ID, label, text, action pointer or name.</p>
<input id="q" placeholder="Search: egg, corn, 14, Text_357, 8191...">
<table id="tbl"><thead><tr>{''.join(f'<th>{html.escape(h)}</th>' for h in headers)}</tr></thead><tbody>{''.join(trs)}</tbody></table>
<script>
const q=document.getElementById('q'); const rows=[...document.querySelectorAll('tbody tr')];
q.addEventListener('input',()=>{{const s=q.value.toLowerCase(); rows.forEach(r=>r.style.display=r.textContent.toLowerCase().includes(s)?'':'none')}});
</script></body></html>'''
    (OUT_DIR / 'held_item_catalog_viewer.html').write_text(html_doc, encoding='utf-8')


def write_xref_csv(xrefs):
    path = OUT_DIR / 'item_table_xrefs.csv'
    with path.open('w', newline='', encoding='utf-8') as f:
        w = csv.writer(f)
        w.writerow(['symbol', 'description', 'reference'])
        for name, desc in TABLE_RENAMES.items():
            for ref in xrefs.get(name, []):
                w.writerow([name, desc, ref])


def main():
    if not ROM_PATH.exists():
        raise SystemExit(f"ROM not found: {ROM_PATH}")
    rom = ROM_PATH.read_bytes()
    textcat = load_text_catalog()
    xrefs = scan_xrefs()
    rows = build_catalog(rom, textcat)
    write_csv(rows)
    write_json(rows)
    write_markdown(rows, xrefs)
    write_html(rows)
    write_xref_csv(xrefs)
    print(OUT_DIR)

if __name__ == '__main__':
    main()
