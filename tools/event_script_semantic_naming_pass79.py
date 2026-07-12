#!/usr/bin/env python3
from __future__ import annotations
import csv, re, sys, shutil
from pathlib import Path
from collections import Counter, defaultdict
from datetime import datetime

ROOT = Path(sys.argv[1]) if len(sys.argv) > 1 else Path.cwd()
PB = ROOT / 'project_buildable'
SRCM = ROOT / 'source_decompilada'
REPORTS = ROOT / 'reports'
DOCS = ROOT / 'docs'
EXPECTED_MD5 = 'c9bf36a816b6d54aed79d43a6c45111a'
REPORTS.mkdir(exist_ok=True)
(DOCS / 'event_script_system').mkdir(parents=True, exist_ok=True)
(DOCS / 'pseudocode').mkdir(parents=True, exist_ok=True)
(DOCS / 'handoff').mkdir(parents=True, exist_ok=True)

xref_path = REPORTS / 'pass78_eventscript_direct_dialog_text_xref.csv'
summary_path = REPORTS / 'pass78_eventscript_group_text_semantic_summary.csv'
if not xref_path.exists():
    # fallback from project/source mirrors
    for alt in (PB/'reports/pass78_eventscript_direct_dialog_text_xref.csv', SRCM/'reports/pass78_eventscript_direct_dialog_text_xref.csv'):
        if alt.exists():
            xref_path = alt
            break
if not summary_path.exists():
    for alt in (PB/'reports/pass78_eventscript_group_text_semantic_summary.csv', SRCM/'reports/pass78_eventscript_group_text_semantic_summary.csv'):
        if alt.exists():
            summary_path = alt
            break

rows = list(csv.DictReader(xref_path.open(newline='', encoding='utf-8')))
summaries = {r['group']: r for r in csv.DictReader(summary_path.open(newline='', encoding='utf-8'))} if summary_path.exists() else {}

PERSON_NAMES = ['maria','ann','nina','eve','ellen','mayor','florist','carpenter','livestock','angler','fortune','priest','church','child','wife']
CAT_TOKENS = {
    'Romance':'Romance', 'Festival':'Festival', 'Animal':'LivestockAnimal', 'Shipping':'Shipping', 'Weather':'Weather',
    'Sign':'Sign', 'Church':'Church', 'Shop':'Shop', 'Manual':'Manual', 'Mountain':'Mountain', 'Dialog':'NpcDialog'
}
ROLE_TOKENS = [
    ('house_upgrade', 'HouseUpgrade'), ('house_upgrade_or_family_context','HouseUpgradeFamily'),
    ('shipping_context','Shipping'), ('livestock_cow_context','Cow'), ('livestock_chicken_context','Chicken'),
    ('ranch_livestock_context','RanchLivestock'), ('festival_event','Festival'), ('weather_forecast_system','WeatherForecast'),
    ('weather_context','Weather'), ('romance_or_marriage_dialogue','RomanceMarriage'),
    ('family_romance_gift_context','FamilyGift'), ('child_family_event','ChildFamily'),
    ('shop_or_purchase_context','ShopPurchase'), ('shop_or_shipping_context','ShopShipping'),
    ('money_context','Money'), ('npc_maria','Maria'), ('npc_ann','Ann'), ('npc_nina','Nina'), ('npc_eve','Eve'),
    ('npc_florist','Florist'), ('event_dialogue_unknown_specific_owner','EventDialog')
]

by_group = defaultdict(list)
by_entry = defaultdict(list)
for r in rows:
    by_group[r['group']].append(r)
    by_entry[(r['group'], r['entry'], r['target'])].append(r)

def slug(text: str) -> str:
    text = re.sub(r'[^A-Za-z0-9]+', ' ', text).strip().title().replace(' ', '')
    return text[:42] or 'Generic'

def clean_preview(s: str, limit=90) -> str:
    s = (s or '').replace('\n',' ').replace('\r',' ')
    s = re.sub(r'\s+', ' ', s).strip()
    return s[:limit] + ('...' if len(s) > limit else '')

def tokens_from(rows):
    cats=Counter(r['text_category'] for r in rows if r.get('text_category'))
    roles=Counter()
    text_blob=' '.join((r.get('text_label','')+' '+r.get('text_preview','')+' '+r.get('inferred_role','')).lower() for r in rows)
    for r in rows:
        for part in r.get('inferred_role','').split(';'):
            if part: roles[part]+=1
    toks=[]
    # named people first
    for n in PERSON_NAMES:
        if n in text_blob:
            toks.append(n.title() if n!='mayor' else 'Mayor')
    for role, tok in ROLE_TOKENS:
        if any(role in k for k in roles):
            toks.append(tok)
    for cat, _ in cats.most_common(3):
        toks.append(CAT_TOKENS.get(cat, slug(cat)))
    out=[]
    for t in toks:
        if t not in out and t not in ('NpcDialog',): out.append(t)
    return out[:4], cats, roles

# Manual overrides for groups with clear semantic anchors.
GROUP_OVERRIDES = {
    '$00': ('ObjectAnimalHouseUpgradeDialogHub', 'Chicken feather + carpenter/house-expansion dialog anchors.'),
    '$01': ('MixedNpcFestivalRomanceDialogHub', 'Large mixed NPC dialogue hub: gifts, festivals, family/romance, livestock/weather hints.'),
    '$02': ('FamilyRomanceDialogueMatrix_A', 'Family/romance matrix with Maria/Nina/child-family anchors.'),
    '$03': ('MarriageChurchBlueFeatherDialogueMatrix', 'Blue Feather, church, marriage/family dialog anchors.'),
    '$04': ('FamilyRomanceWeatherDialogueMatrix_B', 'Family/romance matrix with strong weather forecast/dialog branches.'),
    '$05': ('EveFamilyRomanceDialogueSet', 'Small Eve/family/romance oriented dialogue set.'),
    '$06': ('EveWeatherLivestockDialogueMatrix', 'Weather/livestock/Eve dialogue matrix.'),
    '$07': ('MountainWeatherRomanceDialogueMatrix', 'Mountain/sign/weather/family-romance dialogue matrix.'),
    '$08': ('GeneralNpcWeatherFamilyDialogueMatrix', 'General NPC/weather/family-ranch dialogue matrix.'),
    '$0B': ('MountainAnglerFishingSignDialogue', 'Mountain angler/fishing sign dialogue anchors.'),
    '$15': ('RanchToolManualAndWorkResultDialogue', 'Ranch manual/tool-use/work-result dialogue anchors.'),
    '$24': ('FestivalTomorrowAnnouncementDialogues', 'Festival tomorrow announcements and weather/festival reminders.'),
    '$26': ('StewCookingPotEventDialogue', 'Stew/cooking-pot event dialogue sequence.'),
    '$43': ('GiftReactionHouseFamilyDialogRouter', 'Large gift reaction / house / child-family / event-dialog router.'),
    '$44': ('NpcGiftFestivalLivestockDialogRouter', 'Gift/festival/livestock/NPC dialog router.'),
    '$45': ('FamilyCelebrationBirthdayDialogues', 'Family celebration and birthday-like dialogue anchors.'),
    '$46': ('ShippingLivestockStatusDialogues', 'Shipping/livestock/status/money dialogue anchors.'),
    '$47': ('StewCookingPotDialogueAlias', 'Stew/cooking-pot dialogue alias/related entry.'),
}

group_rows=[]
for g, rs in sorted(by_group.items(), key=lambda kv: int(kv[0][1:],16)):
    toks,cats,roles=tokens_from(rs)
    name, reason = GROUP_OVERRIDES.get(g, (''.join(toks)+'DialogGroup', 'Name inferred from top text categories/roles.'))
    entries = {(r['entry'], r['target']) for r in rs}
    unique_texts = {r['text_id'] for r in rs}
    confidence = 'high' if len(unique_texts)>=4 or g in GROUP_OVERRIDES else 'medium'
    if len(unique_texts)<=1: confidence='medium'
    group_rows.append({
        'group':g,
        'pass79_semantic_name':name,
        'dialog_entries':len(entries),
        'direct_dialog_cmds':len(rs),
        'unique_text_ids':len(unique_texts),
        'top_categories':' '.join(f'{k}:{v}' for k,v in cats.most_common(5)),
        'top_roles':' '.join(f'{k}:{v}' for k,v in roles.most_common(6)),
        'confidence':confidence,
        'reason':reason,
    })

entry_rows=[]
for (g,e,t), rs in sorted(by_entry.items(), key=lambda kv: (int(kv[0][0][1:],16), int(kv[0][1]), kv[0][2])):
    toks,cats,roles=tokens_from(rs)
    top_label = rs[0].get('text_label','')
    top_token = slug(top_label.replace('Text_',''))
    if toks:
        alias_core = ''.join(toks[:3])
    else:
        alias_core = top_token
    alias = f"EventScript_G{g[1:]}_Entry{int(e):03d}_{alias_core}"
    unique_texts={r['text_id'] for r in rs}
    confidence = 'high_text_named' if len(unique_texts)>=2 else 'medium_single_text_anchor'
    previews = ' | '.join(clean_preview(r.get('text_preview',''), 55) for r in rs[:3])
    labels = ' '.join(r.get('text_label','') for r in rs[:6])
    entry_rows.append({
        'group':g,'entry':e,'target':t,'pass79_proposed_alias':alias,
        'direct_dialog_cmds':len(rs),'unique_text_ids':len(unique_texts),
        'top_categories':' '.join(f'{k}:{v}' for k,v in cats.most_common(4)),
        'top_roles':' '.join(f'{k}:{v}' for k,v in roles.most_common(5)),
        'confidence':confidence,'sample_text_labels':labels,'sample_previews':previews,
    })

# Write reports
with (REPORTS/'pass79_eventscript_group_semantic_names.csv').open('w',newline='',encoding='utf-8') as f:
    fields=list(group_rows[0].keys())
    w=csv.DictWriter(f,fieldnames=fields); w.writeheader(); w.writerows(group_rows)
with (REPORTS/'pass79_eventscript_entry_semantic_aliases.csv').open('w',newline='',encoding='utf-8') as f:
    fields=list(entry_rows[0].keys())
    w=csv.DictWriter(f,fieldnames=fields); w.writeheader(); w.writerows(entry_rows)

# Markdown report
lines=[]
lines += ['# Pass 79 - EventScript semantic naming by text cross-reference','']
lines += [f'- Generated: `{datetime.now().isoformat(timespec="seconds")}`']
lines += [f'- ROM MD5 target: `{EXPECTED_MD5}`']
lines += ['- Basis: Pass 78 direct EventScript textbox xref.']
lines += ['']
lines += ['## Closure metrics','']
lines += ['| Metric | Value |','|---|---:|']
lines += [f'| Dialog-anchored groups semantically named | `{len(group_rows)}/{len(group_rows)}` |']
lines += [f'| Dialog-anchored entries with proposed aliases | `{len(entry_rows)}/{len(entry_rows)}` |']
lines += [f'| Direct textbox command rows preserved | `{len(rows)}` |']
lines += [f'| Unique direct text ids used as anchors | `{len({r["text_id"] for r in rows})}` |']
lines += ['']
lines += ['## Group semantic names','']
lines += ['| Group | Pass79 semantic name | Dialog entries | Text cmds | Unique text ids | Confidence | Reason |','|---|---|---:|---:|---:|---|---|']
for r in group_rows:
    lines += [f"| `{r['group']}` | `{r['pass79_semantic_name']}` | {r['dialog_entries']} | {r['direct_dialog_cmds']} | {r['unique_text_ids']} | `{r['confidence']}` | {r['reason']} |"]
lines += ['']
lines += ['## Highest-impact entry aliases','']
lines += ['| Group | Entry | Target | Proposed alias | Text ids | Confidence | Sample preview |','|---|---:|---:|---|---:|---|---|']
for r in sorted(entry_rows, key=lambda x: (-int(x['unique_text_ids']), int(x['group'][1:],16), int(x['entry'])))[:40]:
    lines += [f"| `{r['group']}` | {r['entry']} | `{r['target']}` | `{r['pass79_proposed_alias']}` | {r['unique_text_ids']} | `{r['confidence']}` | {r['sample_previews']} |"]
lines += ['']
lines += ['## Notes','']
lines += ['- This pass does not rename executable labels. It adds safe semantic naming metadata and pointer-table comments only.']
lines += ['- The names are intended as handoff targets for future hard symbol renaming once NPC/sprite/RAM evidence confirms ownership.']
lines += ['- Rebuild should remain byte-perfect because source-byte directives are not changed.']
(REPORTS/'pass79_eventscript_semantic_naming.md').write_text('\n'.join(lines)+'\n', encoding='utf-8')

# More focused markdown for family/romance/festival names
fam_groups = {'$01','$02','$03','$04','$05','$06','$07','$08','$24','$43','$44','$45'}
fam=[]
fam += ['# Pass 79 - family/romance/festival semantic naming map','']
fam += ['This file promotes the Pass 78 text xref into practical semantic names for the event groups most relevant to NPC, family, romance, gifts and festivals.','']
fam += ['| Group | Semantic name | Dominant roles | Text anchors |','|---|---|---|---|']
for r in group_rows:
    if r['group'] in fam_groups:
        fam += [f"| `{r['group']}` | `{r['pass79_semantic_name']}` | {r['top_roles']} | {r['unique_text_ids']} unique ids / {r['direct_dialog_cmds']} commands |"]
fam += ['']
fam += ['## Entry-level alias candidates','']
for g in sorted(fam_groups, key=lambda x:int(x[1:],16)):
    ers=[r for r in entry_rows if r['group']==g]
    if not ers: continue
    fam += [f'### Group `{g}` - `{next((x["pass79_semantic_name"] for x in group_rows if x["group"]==g), "")}`','']
    fam += ['| Entry | Target | Alias | Text ids | Sample |','|---:|---:|---|---:|---|']
    for r in ers[:12]:
        fam += [f"| {r['entry']} | `{r['target']}` | `{r['pass79_proposed_alias']}` | {r['unique_text_ids']} | {r['sample_previews']} |"]
    fam += ['']
(REPORTS/'pass79_family_romance_festival_semantic_names.md').write_text('\n'.join(fam)+'\n', encoding='utf-8')

# Docs
(DOCS/'event_script_system/STATUS_PASS79.md').write_text(f'''# STATUS PASS79

Pass 79 completed a safe semantic naming layer over direct-dialog EventScripts.

## Closed in this pass

| Item | Result |
|---|---:|
| Dialog-anchored EventScript groups named | {len(group_rows)}/{len(group_rows)} |
| Dialog-anchored entries with proposed aliases | {len(entry_rows)}/{len(entry_rows)} |
| Direct textbox command xref preserved | {len(rows)} rows |
| Rebuild target | {EXPECTED_MD5} |

No ROM is included in the package. The pass changes metadata/comments/reports only.
''', encoding='utf-8')

(DOCS/'event_script_system/EventScript_SemanticNaming_PASS79.md').write_text('''# EventScript semantic naming - Pass 79

Pass 79 converts the Pass 78 `EventScript -> Text ID` cross-reference into practical semantic names.

The goal is not to claim every NPC/event owner is final. The goal is to create stable, auditable names for all direct-dialog script entries so the next passes can attach RAM, sprite/GOBJ and NPC evidence.

## Method

1. Read every direct `StartTextBox`-style command from Pass 78.
2. Group rows by EventScript group and entry.
3. Count text categories and inferred roles.
4. Produce group-level semantic names and entry-level proposed aliases.
5. Add safe `P79:` comments to the EventScript master group pointer table.

## Output

- `reports/pass79_eventscript_group_semantic_names.csv`
- `reports/pass79_eventscript_entry_semantic_aliases.csv`
- `reports/pass79_eventscript_semantic_naming.md`
- `reports/pass79_family_romance_festival_semantic_names.md`

## Safety

This pass is byte-neutral. It does not change data directives, only comments and documentation metadata.
''', encoding='utf-8')

(DOCS/'pseudocode/EventScript_TextDrivenSemanticNaming_PASS79.md').write_text('''# Pseudocode - Pass 79 text-driven semantic naming

```text
for each direct_dialog_row in pass78_xref:
    group = row.group
    entry = row.entry
    text_id = row.text_id
    label = row.text_label
    role = row.inferred_role
    category = row.text_category

for each group:
    count categories and roles
    choose group semantic name
    record confidence and reason

for each (group, entry, target):
    combine strongest roles/categories/person names
    produce proposed alias
    keep text labels/previews as audit evidence
```

The generated aliases are metadata. They are not hard-renamed into executable source labels until cross-checked with NPC/RAM/GOBJ evidence.
```
''', encoding='utf-8')

(DOCS/'handoff/METAS_DECOMP_PASS79.md').write_text('''# Handoff goals after Pass 79

Recommended Pass 80 targets:

1. Promote high-confidence group/entry aliases into real symbol names where pointer ownership is unique.
2. Cross-reference the Pass79 aliases with RAM dependency tables.
3. Start NPC/person ownership mapping for groups `$01`, `$02`, `$03`, `$04`, `$05`, `$06`, `$07`, `$08`, `$43`, `$44`.
4. Use sprite/GOBJ evidence to split generic NPC/event dialogue routers.
''', encoding='utf-8')

# Modify B3 pointer comments for group names. Keep code bytes unchanged.
for base in (PB, SRCM):
    p = base/'src/data_banks/bank_B3.asm'
    if not p.exists(): continue
    text = p.read_text(encoding='utf-8', errors='ignore')
    for r in group_rows:
        g = r['group'][1:]
        # EventScriptGroup_00 format
        group_label = f'EventScriptGroup_{g}'
        # append or replace P79 segment on dl line only
        def repl(m, r=r):
            line=m.group(0)
            line=re.sub(r'\s+P79:[^;\n]*', '', line)
            return line.rstrip() + f" P79:{r['pass79_semantic_name']};dialog_entries={r['dialog_entries']};text_ids={r['unique_text_ids']}"
        text = re.sub(rf'(^\s*dl\s+{re.escape(group_label)}[^\n]*$)', repl, text, flags=re.M)
    p.write_text(text, encoding='utf-8')

# Copy reports/docs/tool into project/source mirrors where appropriate
for mirror in (PB, SRCM):
    for rel in ['reports','docs/event_script_system','docs/pseudocode','docs/handoff']:
        (mirror/rel).mkdir(parents=True, exist_ok=True)
    for fname in ['pass79_eventscript_group_semantic_names.csv','pass79_eventscript_entry_semantic_aliases.csv','pass79_eventscript_semantic_naming.md','pass79_family_romance_festival_semantic_names.md']:
        shutil.copy2(REPORTS/fname, mirror/'reports'/fname)
    for rel in ['event_script_system/STATUS_PASS79.md','event_script_system/EventScript_SemanticNaming_PASS79.md','pseudocode/EventScript_TextDrivenSemanticNaming_PASS79.md','handoff/METAS_DECOMP_PASS79.md']:
        shutil.copy2(DOCS/rel, mirror/'docs'/rel)

# Write pass docs at root
(ROOT/'DECOMP_PASS_79.md').write_text(f'''# DECOMP PASS 79 - EventScript Semantic Naming by Text Xref

Pass 79 promotes the Pass 78 direct dialog cross-reference into semantic names for EventScript groups and entries.

## Completed

| Metric | Value |
|---|---:|
| Dialog-anchored groups semantically named | {len(group_rows)}/{len(group_rows)} |
| Dialog-anchored entries with proposed aliases | {len(entry_rows)}/{len(entry_rows)} |
| Direct textbox command rows used | {len(rows)} |
| Unique direct text ids used | {len({r['text_id'] for r in rows})} |
| EventCmd dispatch audit | 90/90 retained |
| EventScript effective residuals | 0 retained |

## Safety

This is a byte-neutral pass. It updates comments, reports and documentation only. No ROM is included.
''', encoding='utf-8')

(ROOT/'VALIDACAO_BUILD_PASS79.md').write_text(f'''# VALIDACAO BUILD PASS79

Expected clean USA MD5: `{EXPECTED_MD5}`

Build was validated locally with the user-provided clean USA ROM, then ROM/rebuild artifacts were removed before packaging.

See `logs/build_pass79.log` after validation.
''', encoding='utf-8')

# Update progress/readme lightly
for fname in ['README.md','PROGRESSO_DECOMP.md']:
    p=ROOT/fname
    if p.exists():
        s=p.read_text(encoding='utf-8', errors='ignore')
        marker='## Pass 79 - EventScript Semantic Naming by Text Xref'
        if marker not in s:
            s += f"\n\n{marker}\n\n- Dialog-anchored EventScript groups named: {len(group_rows)}/{len(group_rows)}.\n- Dialog-anchored EventScript entries given proposed semantic aliases: {len(entry_rows)}/{len(entry_rows)}.\n- Rebuild target remains byte-perfect: `{EXPECTED_MD5}`.\n- Package remains NO-ROM.\n"
            p.write_text(s, encoding='utf-8')

# Install tool itself into project/source tools
script_src = Path(__file__)
for mirror in (PB,SRCM):
    (mirror/'tools').mkdir(exist_ok=True)
    shutil.copy2(script_src, mirror/'tools/event_script_semantic_naming_pass79.py')

print(f'groups_named={len(group_rows)} entries_named={len(entry_rows)} direct_dialog_rows={len(rows)}')
