#!/usr/bin/env python3
from __future__ import annotations
import csv, html, re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / 'reports' / 'decomp_pass09' / 'farm'
SRC = ROOT / 'src'
OUT.mkdir(parents=True, exist_ok=True)

season_names = {0:'Spring',1:'Summer',2:'Fall',3:'Winter'}
weather_ids = [
    (0x00,'Sunny / clear default','SetWeatherFlags: usually no bit except special summer sunny path'),
    (0x01,'Rain','Sets weather flag $0002 when not winter; treated as snow in winter'),
    (0x02,'Snow','Sets rain flag in spring, snow flag otherwise'),
    (0x03,'Hurricane','Sets weather flag $0010'),
    (0x04,'Fair / special clear','Sets flag $0200 plus event flags'),
    (0x05,'Thunder / storm special','Sets flag $0100 plus event flags'),
    (0x06,'Flower Festival climate','Festival override: Spring day 22'),
    (0x07,'Harvest Festival climate','Festival override: Fall day 11'),
    (0x08,'Thanksgiving climate','Festival override: Winter day 9'),
    (0x09,'Star Night climate','Festival override: Winter day 23'),
    (0x0A,'New Year climate','Festival override: Winter day 30'),
    (0x0B,'Egg Festival climate','Festival override: Fall day 19'),
]

chance_tables = [
    ('Hurricane_Chance_Table',[0x00,0x1E,0x00,0x00],'Chance denominator by season; nonzero means RNGReturn0toA must return 0. Turtle shell doubles value before RNG call.'),
    ('Rain_Chance_Table',[0x06,0x0A,0x0A,0x00],'Normal rain chance by season.'),
    ('Snow_Chance_Table',[0x00,0x00,0x00,0x03],'Normal snow chance by season.'),
    ('Thunder_Chance_Table',[0x00,0x1E,0x00,0x00],'First-year thunder special chance by season; summer day 29 forced route.'),
    ('Snowstorm_Chance_Table',[0x00,0x00,0x00,0x08],'First-year winter special fair/snowstorm branch chance.'),
]

climate_flags = [
    (0x0004,'Sunny summer special / clear climate bit', 'Climate_Flag_Table[0]'),
    (0x0002,'Rain flag', 'Climate_Flag_Table[1]'),
    (0x0008,'Snow flag', 'Climate_Flag_Table[2]'),
    (0x0010,'Hurricane flag', 'Climate_Flag_Table[3]'),
    (0x0200,'Fair / special clear flag', 'Climate_Flag_Table[4]'),
    (0x0100,'Thunder / special storm flag', 'Climate_Flag_Table[5]'),
]

damage_probs = [
    ('Rain',0x60,0x00,0x00,0x00),
    ('Snow',0x40,0x00,0x00,0x00),
    ('Hurricane',0x08,0x10,0x04,0x00),
    ('Special storm?',0x08,0x00,0x04,0x00),
    ('New Year?',0x00,0x40,0x20,0x00),
]

tile_catalog = [
    (0x00,'empty / invalid for nightly loop','NightlyFarmTilesCheck skips if zero before random trash logic; exact semantic still needs runtime confirmation.'),
    (0x01,'empty low value','Tiles below $03 can receive random trash outside fall/winter every 4 days.'),
    (0x02,'empty/cleared ground target','Climate damage converts damaged grass/soil/crops to $02.'),
    (0x03,'random trash/weed candidate','Nightly random trash uses $03.'),
    (0x05,'fence intact','Climate damage may convert to $06.'),
    (0x06,'fence broken','Nightly has 1/8 branch that sets repair/event flags.'),
    (0x07,'tilled/watered soil state A','Monthly winter reset can convert crops to $07; rain branch can increment.'),
    (0x08,'tilled/unwatered soil state A','Nightly non-rain branch decrements to previous state.'),
    (0x1D,'grass stage zero / planted grass base','Climate damage checks it separately; monthly winter excludes before $1D.'),
    (0x1E,'crop/soil watered state','Nightly rain branch can increment.'),
    (0x1F,'crop/soil unwatered state','Nightly non-rain branch decrements.'),
    (0x20,'crop family lower bound','Nightly crop-growth logic starts around $20.'),
    (0x39,'watered fully-grown tomato','Special no-rain unwater branch.'),
    (0x53,'watered fully-grown corn','Special no-rain unwater branch.'),
    (0x61,'watered fully-grown potato','Special no-rain unwater branch.'),
    (0x6F,'watered fully-grown turnip','Special no-rain unwater branch.'),
    (0x70,'grass family lower bound','Grass tiles branch in climate damage and nightly logic.'),
    (0x73,'grass second-stage converted target','Nightly maps $7C to $73.'),
    (0x76,'mature grass range start','FarmGrass_MarkFirstMatureGrassPatch searches $76-$79.'),
    (0x79,'mature grass / fully grown grass marker','Climate damage decrements $092E then checks grass damage.'),
    (0x7A,'marked mature/cut grass target','Monthly winter and grass-mark routine write $7A.'),
    (0x7C,'grass second stage special','Nightly maps to $73.'),
    (0xA0,'out-of-bounds sentinel threshold','Farm tile routines skip values >= $A0.'),
]

tool_masks = [
    ('sickle / gold sickle',0x01,'requires tile-property bit 0'),
    ('hoe / gold hoe',0x02,'requires tile-property bit 1'),
    ('hammer / gold hammer',0x04,'requires tile-property bit 2'),
    ('axe / gold axe',0x08,'requires tile-property bit 3'),
    ('watering can',None,'farm accepts watering; non-farm can fill from water tile properties $00F0/$00F4'),
    ('sprinkler',None,'routes to sprinkler-specific multi-tile logic'),
    ('crop/grass seeds',None,'routes to seedused branch; actual planting routines are separate'),
    ('paint',None,'paint-specific branch'),
]

routine_notes = [
    ('Weather_LoadDisplayClimateFromTomorrow','82:81C0','Maps !weather_tomorrow and storm flags into display/state byte $0990 using Weather_TomorrowToDisplayClimateTable.'),
    ('SetWeatherFlags','82:8C09','Converts !weather_tomorrow into runtime weather flags at $0196 and some event flags.'),
    ('WeatherTomorrow','82:8CF9','Calculates tomorrow weather from season/day/festival rules and chance tables.'),
    ('ClimateFarmDamagePrep','82:8209','Reads weather flags and loads damage probabilities before calling ClimateFarmDamageCheck.'),
    ('ClimateFarmDamageCheck','82:A713','Iterates farm map $7EA4E6 in 16x16 logical steps and damages fences/grass/crops by RNG.'),
    ('NightlyFarmTilesCheck','82:A811','Nightly farm tile lifecycle: rain/winter growth/drying/trash/broken-fence checks.'),
    ('MonthlyFarmTilesCheck','82:A6A2','Winter/monthly cleanup path: crops/grass ranges are reset to winter-safe tiles.'),
    ('FarmGrass_MarkFirstMatureGrassPatch','82:A9A0','Searches for first mature grass tile $76-$79, converts it to $7A and updates $092E.'),
    ('CalculateFarmDevelopment','82:AA0C','Counts farm-map tiles contributing to ranch development score.'),
    ('CheckToolSuccess','82:AA71','Central field-tool success gate using !tool_selected and tile-property masks.'),
]

# write CSVs
with (OUT/'weather_ids.csv').open('w', newline='') as f:
    w=csv.writer(f); w.writerow(['id_hex','name','notes']);
    for i,n,notes in weather_ids: w.writerow([f'{i:02X}',n,notes])
with (OUT/'weather_chance_tables.csv').open('w', newline='') as f:
    w=csv.writer(f); w.writerow(['table','spring','summer','fall','winter','notes'])
    for name,vals,notes in chance_tables: w.writerow([name]+[f'{v:02X}' for v in vals]+[notes])
with (OUT/'farm_tile_catalog.csv').open('w', newline='') as f:
    w=csv.writer(f); w.writerow(['tile_hex','meaning_inferred','evidence'])
    for t,n,e in tile_catalog: w.writerow([f'{t:02X}',n,e])
with (OUT/'damage_probability_table.csv').open('w', newline='') as f:
    w=csv.writer(f); w.writerow(['climate','fence','grass','crop_or_tilled','unused_4th'])
    for row in damage_probs: w.writerow([row[0]]+[f'{x:02X}' for x in row[1:]])
with (OUT/'tool_success_masks.csv').open('w', newline='') as f:
    w=csv.writer(f); w.writerow(['tool_group','mask_hex','notes'])
    for n,m,notes in tool_masks: w.writerow([n, '' if m is None else f'{m:02X}', notes])
with (OUT/'farm_routine_catalog.csv').open('w', newline='') as f:
    w=csv.writer(f); w.writerow(['routine','address','notes'])
    for r,a,n in routine_notes: w.writerow([r,a,n])

# XRefs
patterns = ['Weather_LoadDisplayClimateFromTomorrow','SetWeatherFlags','WeatherTomorrow','ClimateFarmDamagePrep','ClimateFarmDamageCheck','NightlyFarmTilesCheck','MonthlyFarmTilesCheck','FarmGrass_MarkFirstMatureGrassPatch','CalculateFarmDevelopment','CheckToolSuccess','!farm_map_array','!weather_tomorrow','$0196','DamageProbabilityTable','Rain_Chance_Table','ToolSuccessSquareOffsetsTable']
source_texts=[]
for p in SRC.rglob('*.asm'):
    txt=p.read_text(errors='ignore').splitlines()
    for i,line in enumerate(txt,1):
        for pat in patterns:
            if pat in line:
                source_texts.append((str(p.relative_to(ROOT)),i,pat,line.strip()))
with (OUT/'farm_weather_xrefs.csv').open('w', newline='') as f:
    w=csv.writer(f); w.writerow(['file','line','pattern','source_line']); w.writerows(source_texts)

# Markdown docs
md=[]
md.append('# Pass 09 - Farm / crops / weather catalog\n')
md.append('This report summarizes the safe static reverse-engineering pass for the farm tile lifecycle, weather flags and field-tool success gates. No game behavior was intentionally changed.\n')
md.append('## Main routines\n')
for r,a,n in routine_notes:
    md.append(f'- `{r}` at `{a}`: {n}')
md.append('\n## Weather IDs observed\n')
md.append('| ID | Meaning | Notes |\n|---:|---|---|')
for i,n,notes in weather_ids:
    md.append(f'| ${i:02X} | {n} | {notes} |')
md.append('\n## Chance tables\n')
md.append('| Table | Spring | Summer | Fall | Winter | Notes |\n|---|---:|---:|---:|---:|---|')
for name,vals,notes in chance_tables:
    md.append('| '+name+' | '+' | '.join(f'${v:02X}' for v in vals)+' | '+notes+' |')
md.append('\n## Climate damage table\n')
md.append('| Climate | Fence RNG A | Grass RNG A | Crop/Tilled RNG A | Unused |\n|---|---:|---:|---:|---:|')
for c,f,g,cp,u in damage_probs:
    md.append(f'| {c} | ${f:02X} | ${g:02X} | ${cp:02X} | ${u:02X} |')
md.append('\n## Farm tile IDs observed\n')
md.append('| Tile | Inferred meaning | Evidence |\n|---:|---|---|')
for t,n,e in tile_catalog:
    md.append(f'| ${t:02X} | {n} | {e} |')
md.append('\n## Tool success masks\n')
md.append('| Tool group | Mask | Notes |\n|---|---:|---|')
for n,m,notes in tool_masks:
    md.append(f'| {n} | {"" if m is None else "$%02X"%m} | {notes} |')
(OUT/'farm_weather_tile_catalog.md').write_text('\n'.join(md))

# HTML viewer
html_rows=''.join(f'<tr><td>${t:02X}</td><td>{html.escape(n)}</td><td>{html.escape(e)}</td></tr>' for t,n,e in tile_catalog)
routine_rows=''.join(f'<tr><td>{html.escape(r)}</td><td>{a}</td><td>{html.escape(n)}</td></tr>' for r,a,n in routine_notes)
weather_rows=''.join(f'<tr><td>${i:02X}</td><td>{html.escape(n)}</td><td>{html.escape(notes)}</td></tr>' for i,n,notes in weather_ids)
page=f'''<!doctype html><meta charset="utf-8"><title>HM Pass09 Farm/Weather Viewer</title>
<style>body{{font-family:system-ui,Arial;background:#111;color:#eee;margin:24px}}input{{width:100%;padding:12px;background:#222;color:#fff;border:1px solid #555;border-radius:8px;margin:0 0 16px}}table{{border-collapse:collapse;width:100%;margin:18px 0;background:#181818}}th,td{{border:1px solid #333;padding:8px;text-align:left;vertical-align:top}}th{{background:#242424}}tr.hide{{display:none}}code{{background:#222;padding:2px 4px;border-radius:4px}}</style>
<h1>Harvest Moon SNES - Pass09 Farm/Weather Viewer</h1>
<p>Search tile IDs, weather IDs, routine names, or notes.</p><input id="q" placeholder="ex: rain, $07, crop, NightlyFarmTilesCheck, hurricane">
<h2>Routines</h2><table><thead><tr><th>Routine</th><th>Address</th><th>Notes</th></tr></thead><tbody>{routine_rows}</tbody></table>
<h2>Weather IDs</h2><table><thead><tr><th>ID</th><th>Meaning</th><th>Notes</th></tr></thead><tbody>{weather_rows}</tbody></table>
<h2>Farm Tile IDs</h2><table><thead><tr><th>Tile</th><th>Inferred meaning</th><th>Evidence</th></tr></thead><tbody>{html_rows}</tbody></table>
<script>const q=document.getElementById('q'); q.addEventListener('input',()=>{{const s=q.value.toLowerCase(); document.querySelectorAll('tbody tr').forEach(tr=>{{tr.classList.toggle('hide', !tr.innerText.toLowerCase().includes(s));}});}});</script>
'''
(OUT/'farm_weather_viewer.html').write_text(page)

# Xrefs md summary
xr=['# Farm/weather source xrefs\n', f'Total references found: {len(source_texts)}\n', '| File | Line | Pattern | Source |', '|---|---:|---|---|']
for f,l,p,line in source_texts[:500]:
    xr.append(f'| `{f}` | {l} | `{p}` | `{line.replace("|","\\|")}` |')
(OUT/'farm_weather_xrefs.md').write_text('\n'.join(xr))

print('Wrote pass09 farm reports to', OUT)
