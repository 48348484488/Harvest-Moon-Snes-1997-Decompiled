#!/usr/bin/env python3
"""Harvest Moon SNES save/SRAM system catalog helper.

This is a conservative documentation generator for the save-slot layout
visible in bank_83's save/load/checksum routines. It does not modify ROM data.
"""
from __future__ import annotations
import csv, html, json, re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "reports" / "decomp_pass11" / "save"
SRC = ROOT / "src" / "code_banks"
OUT.mkdir(parents=True, exist_ok=True)

DIRECT = [
    (0x0000, "!year", "!year", "!year", "8-bit year counter"),
    (0x0001, "!season", "!season", "!season", "8-bit season"),
    (0x0002, "!weekday", "!weekday", "", "8-bit weekday"),
    (0x0003, "!day", "!day", "!day", "8-bit day of season"),
    (0x0004, "!seeds_grass_N", "!seeds_grass_N", "", "grass seed count"),
    (0x0005, "!seeds_corn_N", "!seeds_corn_N", "", "corn seed count"),
    (0x0006, "!seeds_tomato_N", "!seeds_tomato_N", "", "tomato seed count"),
    (0x0007, "!seeds_potato_N", "!seeds_potato_N", "", "potato seed count"),
    (0x0008, "!seeds_turnip_N", "!seeds_turnip_N", "", "turnip seed count"),
    (0x0009, "!feed_cow_N", "!feed_cow_N", "", "cow feed count"),
    (0x000A, "!feed_chicks_N", "!feed_chicks_N", "", "chicken feed count"),
    (0x000B, "!cow_N", "!cow_N", "", "cow count"),
    (0x000C, "!chicks_N", "!chicks_N", "", "chicken count"),
    (0x000D, "!weather_tomorrow", "!weather_tomorrow", "", "tomorrow weather"),
    (0x000E, "!max_stamina", "!max_stamina", "", "max stamina"),
    (0x000F, "!tool_selected", "!tool_selected", "", "selected tool"),
    (0x0010, "!watering_can_water", "!watering_can_water", "", "watering can water"),
    (0x0011, "$7F1F12", "$7F1F12", "", "unknown persistent byte"),
    (0x0012, "$7F1F2B", "$7F1F2B", "", "unknown persistent byte"),
    (0x0013, "!dog_map", "!dog_map", "", "dog map/location id"),
    (0x0014, "$7F1F31", "$7F1F31", "", "unknown persistent byte"),
    (0x0015, "$7F1F32", "$7F1F32", "", "unknown persistent byte"),
    (0x0016, "!development_rate", "!development_rate", "", "farm development rate"),
    (0x0017, "!power_berry_N", "!power_berry_N", "", "power berry count"),
    (0x0018, "$09A3", "$09A3", "", "unknown WRAM value"),
    (0x0019, "$0937", "$0937", "", "unknown WRAM value"),
    (0x001A, "!tool_backpack", "!tool_backpack", "", "backpack tool"),
    (0x002E, "slot marker / checksum scratch", "", "", "temporarily zeroed during checksum; also slot-state marker"),
    (0x002F, "checksum low/high", "", "", "16-bit additive checksum starts here"),
    (0x0031, "!shipped_corn", "!shipped_corn", "", "corn shipped count"),
    (0x0033, "!shipped_tomatoes", "!shipped_tomatoes", "", "tomatoes shipped count"),
    (0x0035, "!shipped_turnips", "!shipped_turnips", "", "turnips shipped count"),
    (0x0037, "!shipped_potatoes", "!shipped_potatoes", "", "potatoes shipped count"),
    (0x0039, "!moneyL", "!moneyL", "", "money low 16 bits"),
    (0x003B, "!moneyH", "!moneyH", "", "money high byte"),
    (0x003C, "ASCII FARM", "ASCII FARM", "FARM check", "valid slot signature bytes $46,$41,$52,$4D"),
    (0x0040, "!stored_wood", "!stored_wood", "", "stored wood"),
    (0x0042, "!stored_grass", "!stored_grass", "", "stored grass/fodder"),
    (0x0044, "$0196", "$0196", "", "unknown 16-bit value"),
    (0x0046, "!planted_grass", "!planted_grass", "", "planted grass count"),
    (0x0048, "!hearts_maria", "!hearts_maria", "", "Maria affection"),
    (0x004A, "!hearts_ann", "!hearts_ann", "", "Ann affection"),
    (0x004C, "!hearts_nina", "!hearts_nina", "", "Nina affection"),
    (0x004E, "!hearts_ellen", "!hearts_ellen", "", "Ellen affection"),
    (0x0050, "!hearts_eve", "!hearts_eve", "", "Eve affection"),
    (0x0060, "$7F1F64", "$7F1F64", "", "unknown persistent word"),
    (0x0062, "$7F1F66", "$7F1F66", "", "unknown persistent word"),
    (0x0064, "$7F1F68", "$7F1F68", "", "unknown persistent word"),
    (0x0066, "$7F1F6A", "$7F1F6A", "", "unknown persistent word"),
    (0x0068, "!dog_pos_X", "!dog_pos_X", "", "dog X position"),
    (0x006A, "!dog_pos_Y", "!dog_pos_Y", "", "dog Y position"),
    (0x006C, "!happiness", "!happiness", "", "player/farm happiness"),
    (0x006E, "$7F1F45", "$7F1F45", "", "unknown persistent word"),
    (0x0070, "$7F1F6C", "$7F1F6C", "", "unknown persistent word"),
    (0x0072, "$7F1F6E", "$7F1F6E", "", "unknown persistent word"),
    (0x0074, "$7F1F70", "$7F1F70", "", "unknown persistent word"),
    (0x0076, "$7F1F72", "$7F1F72", "", "unknown persistent word"),
    (0x0078, "!wife_pregnancy", "!wife_pregnancy", "", "wife pregnancy state"),
    (0x007A, "!kid1_age", "!kid1_age", "", "kid 1 age"),
    (0x007C, "!kid2_age", "!kid2_age", "", "kid 2 age"),
    (0x007E, "!dog_hugs", "!dog_hugs", "", "dog hug counter"),
]
for base, prefix in [(0x0080, "player_name_sort"), (0x0088, "dog_name_short"), (0x008C, "horse_name_short"), (0x0090, "kid1_name_sort"), (0x0094, "kid2_name_sort")]:
    label_prefix = prefix.replace("_sort", "").replace("_short", "")
    for i in range(4):
        summary = f"{label_prefix} character {i+1}"
        var = f"!{prefix}_{i+1}"
        DIRECT.append((base+i, var, var, var if base == 0x0080 else "", summary))
for i in range(4):
    DIRECT.append((0x0084+i, f"!shed_items_row_{i+1}", f"!shed_items_row_{i+1}", "", "tool shed bitfield row"))
DIRECT.extend([
    (0x0098, "!chicken_array", "!chicken_array", "", "block copy: 13 chickens x 8 bytes = 104 bytes"),
    (0x0100, "!cow_array", "!cow_array", "", "block copy: 12 cows x 16 bytes = 192 bytes"),
    (0x01C0, "!farm_map_array[$00C0-$0EFF]", "!farm_map_array[$00C0-$0EFF]", "", "block copy: farm map/tile state to end of slot"),
])
DIRECT = sorted(DIRECT, key=lambda r: r[0])

BLOCKS = [
    ("$0000-$001A", 0x0000, 0x001A, "Scalar 8-bit early fields", "Date, seed/feed counts, selected tool, stamina and misc flags."),
    ("$002E", 0x002E, 0x002E, "Active/latest-slot marker byte", "Temporarily zeroed for checksum; values 0/1 are used by slot-state flow."),
    ("$002F-$0030", 0x002F, 0x0030, "Save checksum", "16-bit additive checksum over $0000-$0FFF with $002E and $002F-$0030 zeroed first."),
    ("$0031,$0033,$0035,$0037", 0x0031, 0x0037, "Shipped crop counters", "Stored at separated odd offsets."),
    ("$0039-$003B", 0x0039, 0x003B, "Money", "24-bit money value split into !moneyL and !moneyH."),
    ("$003C-$003F", 0x003C, 0x003F, "FARM signature", "ASCII F,A,R,M. Used as a basic slot validity marker."),
    ("$0040-$007E", 0x0040, 0x007E, "16-bit counters/hearts/family/dog state", "Wood/grass, crop totals, bachelorette hearts, persistent flags, dog position, happiness, pregnancy/kids."),
    ("$0080-$0083", 0x0080, 0x0083, "Player name", "Four character bytes."),
    ("$0084-$0087", 0x0084, 0x0087, "Tool shed bitfields", "Rows of stored tools/seeds/items; see pass07 report."),
    ("$0088-$008B", 0x0088, 0x008B, "Dog name", "Four character bytes."),
    ("$008C-$008F", 0x008C, 0x008F, "Horse name", "Four character bytes."),
    ("$0090-$0093", 0x0090, 0x0093, "Kid 1 name", "Four character bytes."),
    ("$0094-$0097", 0x0094, 0x0097, "Kid 2 name", "Four character bytes."),
    ("$0098-$00FF", 0x0098, 0x00FF, "Chicken array", "13 chickens x 8 bytes = 104 bytes."),
    ("$0100-$01BF", 0x0100, 0x01BF, "Cow array", "12 cows x 16 bytes = 192 bytes."),
    ("$01C0-$0FFF", 0x01C0, 0x0FFF, "Farm map/tile state block", "Copied from !farm_map_array index $00C0-$0EFF into SRAM $01C0-$0FFF."),
]

patterns = [
    "SaveSystem_LoadFullSlot", "SaveSystem_SaveSlot", "SaveSystem_LoadSlotSummary", "SaveSystem_CheckSRAMIntegrity",
    "$098E", "$7F1F60", "FARM", "!cow_array", "!chicken_array", "!farm_map_array",
]
xrefs = []
for pat in patterns:
    locs=[]
    for p in sorted(SRC.glob("*.asm")):
        try: txt=p.read_text(errors="ignore").splitlines()
        except Exception: continue
        for i,line in enumerate(txt,1):
            if pat in line:
                locs.append(f"{p.relative_to(ROOT)}:{i}")
    xrefs.append((pat, len(locs), locs))

with (OUT/"save_slot_direct_offsets.csv").open("w", newline="") as f:
    w=csv.writer(f); w.writerow(["offset","dec","save_source","load_target","summary_target","notes"])
    for off,src,load,summary,notes in DIRECT:
        w.writerow([f"${off:04X}", off, src, load, summary, notes])
with (OUT/"save_slot_block_layout.csv").open("w", newline="") as f:
    w=csv.writer(f); w.writerow(["range","start","end","size","name","notes"])
    for rng,start,end,name,notes in BLOCKS:
        w.writerow([rng,start,end,end-start+1,name,notes])
with (OUT/"save_slot_layout.json").open("w") as f:
    json.dump({"direct_offsets":[{"offset":f"${o:04X}","dec":o,"save_source":s,"load_target":l,"summary_target":sm,"notes":n} for o,s,l,sm,n in DIRECT],"blocks":[{"range":rng,"start":s,"end":e,"size":e-s+1,"name":n,"notes":notes} for rng,s,e,n,notes in BLOCKS]}, f, indent=2)

md=[]
md.append("# Pass 11 - Save Slot Layout / SRAM\n")
md.append("Catalogo conservador do layout de slot salvo observado em `SaveSystem_LoadFullSlot`, `SaveSystem_SaveSlot`, `SaveSystem_LoadSlotSummary` e `SaveSystem_CheckSRAMIntegrity`.\n")
md.append("## Descobertas principais\n")
for line in [
    "SRAM usado pelos slots: banco `$70`.",
    "Slot 1 base: `$70:0000`.",
    "Slot 2 base: `$70:1000`.",
    "Cada slot e iterado como `$1000` bytes durante o checksum.",
    "Em falha de integridade, a rotina limpa `$0800` bytes e restaura a assinatura `FARM`.",
    "Marcador de validade: ASCII `FARM` em `$003C-$003F`.",
    "Checksum fica em `$002F-$0030`; `$002E` tambem e zerado temporariamente no calculo.",
]: md.append(f"- {line}\n")
md.append("\n## Blocos do slot\n\n| Range | Size | Name | Notes |\n|---:|---:|---|---|\n")
for rng,start,end,name,notes in BLOCKS:
    md.append(f"| `{rng}` | `{end-start+1}` | {name} | {notes} |\n")
md.append("\n## Offset direto\n\n| Offset | Save source | Load target | Summary load | Notes |\n|---:|---|---|---|---|\n")
for off,src,load,summary,notes in DIRECT:
    md.append(f"| `${off:04X}` | `{src}` | `{load}` | `{summary}` | {notes} |\n")
(OUT/"save_slot_layout.md").write_text("".join(md))

xref_md=["# Save System Xrefs\n\n| Pattern | Count | Locations |\n|---|---:|---|\n"]
for pat,count,locs in xrefs:
    joined="<br>".join(f"`{html.escape(x)}`" for x in locs[:30])
    if len(locs)>30: joined += f"<br>... +{len(locs)-30} more"
    xref_md.append(f"| `{pat}` | {count} | {joined} |\n")
(OUT/"save_system_xrefs.md").write_text("".join(xref_md))

# Minimal searchable HTML
rows="\n".join(f"<tr><td>${o:04X}</td><td>{o}</td><td>{html.escape(s)}</td><td>{html.escape(l)}</td><td>{html.escape(sm)}</td><td>{html.escape(n)}</td></tr>" for o,s,l,sm,n in DIRECT)
html_doc=f'''<!doctype html><html><head><meta charset="utf-8"><title>HM Save Slot Viewer</title>
<style>body{{font-family:Arial,sans-serif;background:#111;color:#eee;margin:20px}}input{{width:100%;padding:10px;background:#222;color:#eee;border:1px solid #555;margin:10px 0}}table{{border-collapse:collapse;width:100%}}th,td{{border:1px solid #444;padding:6px;text-align:left;font-size:13px}}th{{background:#222;position:sticky;top:0}}tr:nth-child(even){{background:#181818}}code{{color:#ffd479}}</style></head><body>
<h1>Harvest Moon SNES - Save Slot Viewer</h1><p>Search offsets, symbols, notes, animal arrays, FARM signature, checksum, etc.</p><input id="q" oninput="filter()" placeholder="Search: money, cow, FARM, $0098, checksum, !year">
<table id="t"><thead><tr><th>Offset</th><th>Dec</th><th>Save source</th><th>Load target</th><th>Summary</th><th>Notes</th></tr></thead><tbody>{rows}</tbody></table>
<script>function filter(){{let q=document.getElementById('q').value.toLowerCase();document.querySelectorAll('#t tbody tr').forEach(tr=>{{tr.style.display=tr.textContent.toLowerCase().includes(q)?'':'none';}})}}</script></body></html>'''
(OUT/"save_slot_layout_viewer.html").write_text(html_doc)
print(f"Wrote save reports to {OUT}")
