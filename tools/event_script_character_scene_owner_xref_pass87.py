#!/usr/bin/env python3
from __future__ import annotations
import csv, os, re, collections, json
from pathlib import Path

ROOT = Path('/mnt/data/hm_pass87_work/HM-Decomp-Codex-Workspace-Pass86-FULL-NO-ROM/project_buildable')
REPORTS = ROOT / 'reports'
TOOLS = ROOT / 'tools'
DOCS = ROOT / 'docs'


def read_csv(name):
    path = REPORTS / name
    with path.open(newline='', encoding='utf-8') as f:
        return list(csv.DictReader(f))

def write_csv(path: Path, rows, fields):
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open('w', newline='', encoding='utf-8') as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        for r in rows:
            w.writerow({k: r.get(k, '') for k in fields})

def norm(s):
    return (s or '').lower()

# Direct text commands are the most reliable evidence for character/scene identity.
dialog_rows = read_csv('pass78_eventscript_direct_dialog_text_xref.csv')
entry_rows = read_csv('pass82_eventscript_entry_ownership_xref.csv')
visual_rows = read_csv('pass86_eventscript_visual_named_xref_refined.csv')
entry_alias_rows = read_csv('pass81_eventscript_all_entry_semantic_aliases.csv')
group_rows = read_csv('pass80_eventscript_all_group_semantic_names.csv')

entry_key = lambda r: (r.get('group',''), r.get('entry',''))

dialog_by_entry = collections.defaultdict(list)
for r in dialog_rows:
    dialog_by_entry[entry_key(r)].append(r)

visual_by_entry = {entry_key(r): r for r in visual_rows}
alias_by_entry = {entry_key(r): r for r in entry_alias_rows}
group_by_group = {r['group']: r for r in group_rows}

# Priority-ordered rules. The earliest rule wins for exact text identity.
# Each rule: owner, owner_type, confidence, keyword list for label/preview/category.
TEXT_RULES = [
    ('Maria', 'bachelorette_exact', 'direct_named_text', ['maria']),
    ('Nina', 'bachelorette_exact', 'direct_named_text', ['nina']),
    ('Ann', 'bachelorette_exact', 'direct_named_text', ['anncan', "ann's", ' ann ', 'ann.', 'ann?']),
    ('Ellen', 'bachelorette_exact', 'direct_named_text', ['ellen']),
    ('Eve', 'bachelorette_exact', 'direct_named_text', ['eve']),
    ('BabyChildFamily', 'family_child', 'direct_named_family_text', ['baby', 'child', 'children']),
    ('WifeFamilyRoutine', 'wife_family', 'direct_family_role_text', ['wife', 'anniversary', 'cook', 'married', 'marriage']),
    ('BlueFeatherMarriageProposal', 'romance_marriage_item', 'direct_romance_item_text', ['bluefeather', 'blue feather', 'marry', 'marriage']),
    ('ChurchPriest', 'church_priest', 'direct_location_or_role_text', ['church', 'priest', 'god bless', 'pray', 'organ']),
    ('MayorFamily', 'mayor_town_authority', 'direct_location_or_role_text', ['mayor']),
    ('FlowerShopFlorist', 'shop_or_town_npc', 'direct_shop_location_text', ['flowershop', 'flower shop', 'florist']),
    ('LivestockDealer', 'shop_or_town_npc', 'direct_shop_location_text', ['livestock dealer', 'livestock delaer']),
    ('GeneralStoreShopkeeper', 'shop_or_town_npc', 'direct_shop_location_text', ['generalstore', 'general store', 'bag of seed', 'shop', 'store']),
    ('CarpenterHouseUpgrade', 'carpenter_house_upgrade', 'direct_service_text', ['carpenter', 'workman', 'enlarge your house', 'build a terrific', 'wood house']),
    ('BarNpc', 'bar_tavern_npc', 'direct_location_or_role_text', ['bar']),
    ('FestivalEvent', 'festival_event', 'direct_event_text', ['festival', 'flower festival', 'star night', 'egg festival', 'thanksgiving', 'new years', 'new year']),
    ('AnimalLivestock', 'animal_livestock', 'direct_animal_text', ['animal', 'chicken', 'cow', 'cows', 'dog', 'horse', 'livestock', 'feather', 'fodder']),
    ('WeatherFarmWarning', 'weather_farm_warning', 'direct_weather_text', ['weather', 'hurricane', 'snow', 'rain', 'storm']),
    ('ShippingStatus', 'shipping_or_status', 'direct_status_text', ['shipping', 'ranch developing rate', 'love <ctrl', "love d"]),
    ('BookcaseSignManual', 'sign_manual_bookshelf', 'direct_static_text', ['bookcase', 'sign', 'manual']),
]

# Domain fallback for entries without direct text.
DOMAIN_RULES = [
    ('animal_chicken_or_poultry', 'ChickenPoultryEvent', 'animal_livestock', 'domain_inferred'),
    ('cow_livestock', 'CowLivestockEvent', 'animal_livestock', 'domain_inferred'),
    ('general_livestock', 'GeneralLivestockEvent', 'animal_livestock', 'domain_inferred'),
    ('dog_pet', 'DogPetEvent', 'animal_livestock', 'domain_inferred'),
    ('npc_family_event', 'FamilyNpcEvent', 'family_npc', 'domain_inferred'),
    ('festival', 'FestivalEvent', 'festival_event', 'domain_inferred'),
    ('shipping', 'ShippingStatus', 'shipping_or_status', 'domain_inferred'),
    ('item_money', 'ItemMoneyShopEvent', 'item_shop_money', 'domain_inferred'),
    ('crop', 'CropFarmEvent', 'farm_crop_weather', 'domain_inferred'),
    ('weather', 'WeatherFarmWarning', 'farm_crop_weather', 'domain_inferred'),
    ('menu', 'MenuInterfaceEvent', 'menu_interface', 'domain_inferred'),
]

def exact_name_hits(rows):
    text = "\n".join((r.get('text_label','') + ' ' + r.get('text_preview','')) for r in rows)
    hits=[]
    patterns = [
        ('Maria', r'(?i)(?:^|[^A-Za-z])Maria(?:[^A-Za-z]|$)|_Maria'),
        ('Nina', r'(?i)(?:^|[^A-Za-z])Nina(?:[^A-Za-z]|$)|_Nina'),
        ('Ann', r'(?i)(?:^|[^A-Za-z])Ann(?:[^A-Za-z]|$)|_Ann|Anncan|AnnsLove'),
        ('Ellen', r'(?i)(?:^|[^A-Za-z])Ellen(?:[^A-Za-z]|$)|_Ellen'),
        ('Eve', r'(?i)(?:^|[^A-Za-z])Eve(?:[^A-Za-z]|$)|_Eve|EvesLove'),
    ]
    for owner, pat in patterns:
        if re.search(pat, text):
            hits.append(owner)
    return hits

def detect_from_text(rows):
    # Exact bachelorette names are handled with regex so words such as
    # "every" or "even" do not accidentally match Eve.
    exact = exact_name_hits(rows)
    if exact:
        return exact[0], 'bachelorette_exact', 'direct_named_text', ';'.join(f'{x}:regex' for x in exact)

    blob_parts = []
    for r in rows:
        blob_parts += [r.get('text_label',''), r.get('text_preview',''), r.get('text_category',''), r.get('inferred_role','')]
    blob = ' ' + norm(' '.join(blob_parts)).replace('_',' ') + ' '
    hits = []
    # Skip the exact name rules here because exact_name_hits already handled them safely.
    for owner, typ, conf, keys in TEXT_RULES[5:]:
        for k in keys:
            if k in blob:
                hits.append((owner, typ, conf, k))
                break
    if hits:
        owner, typ, conf, key = hits[0]
        return owner, typ, conf, ';'.join(f'{h[0]}:{h[3]}' for h in hits)
    # fallback by text category
    cats = {r.get('text_category','') for r in rows}
    if 'Romance' in cats:
        return 'RomanceDialogue', 'romance_general', 'direct_category_text', 'category:Romance'
    if 'Festival' in cats:
        return 'FestivalEvent', 'festival_event', 'direct_category_text', 'category:Festival'
    if 'Animal' in cats:
        return 'AnimalLivestock', 'animal_livestock', 'direct_category_text', 'category:Animal'
    if 'Church' in cats:
        return 'ChurchPriest', 'church_priest', 'direct_category_text', 'category:Church'
    if 'Weather' in cats:
        return 'WeatherFarmWarning', 'farm_crop_weather', 'direct_category_text', 'category:Weather'
    if 'Shipping' in cats:
        return 'ShippingStatus', 'shipping_or_status', 'direct_category_text', 'category:Shipping'
    return '', '', '', ''

def fallback_owner(entry, visual, alias, group):
    blob = ' '.join([
        entry.get('pass82_owner_domain',''), entry.get('pass82_scene_role',''),
        entry.get('group_semantic_name',''), entry.get('pass81_entry_alias',''),
        visual.get('pass83_visual_domain','') if visual else '',
        visual.get('pass84_dominant_visual_family','') if visual else '',
        visual.get('pass86_primary_visual_semantic_names','') if visual else '',
        group.get('pass80_semantic_group_name','') if group else '',
    ])
    n = norm(blob).replace('_',' ')
    for needle, owner, typ, conf in DOMAIN_RULES:
        if needle.replace('_',' ') in n or needle in norm(blob):
            return owner, typ, conf, f'domain:{needle}'
    # group/category fallbacks
    if 'family' in n or 'romance' in n or 'wife' in n:
        return 'FamilyRomanceEvent', 'family_romance_general', 'group_semantic_inferred', 'group/alias:family_romance'
    if 'festival' in n:
        return 'FestivalEvent', 'festival_event', 'group_semantic_inferred', 'group/alias:festival'
    if 'cutscene' in n or 'transition' in n:
        return 'CutsceneTransition', 'cutscene_transition', 'group_semantic_inferred', 'group/alias:cutscene_transition'
    if 'object' in n or 'visual' in n or 'gobj' in n:
        return 'ObjectVisualSetup', 'object_visual_setup', 'group_semantic_inferred', 'group/alias:object_visual'
    if 'dialog' in n:
        return 'GenericDialogEvent', 'dialog_general', 'group_semantic_inferred', 'group/alias:dialog'
    return 'StructuralEventScriptEntry', 'structural_or_unknown_scene', 'structural_inferred', 'no direct npc text; structural alias only'

out_rows = []
for e in entry_rows:
    key = entry_key(e)
    drows = dialog_by_entry.get(key, [])
    visual = visual_by_entry.get(key, {})
    alias = alias_by_entry.get(key, {})
    group = group_by_group.get(e.get('group',''), {})
    owner = typ = conf = evidence = ''
    if drows:
        owner, typ, conf, evidence = detect_from_text(drows)
    if not owner:
        owner, typ, conf, evidence = fallback_owner(e, visual, alias, group)
    labels = '|'.join(sorted({r.get('text_label','') for r in drows if r.get('text_label')}))
    previews = ' || '.join([r.get('text_preview','')[:90] for r in drows[:3] if r.get('text_preview')])
    text_ids = ' '.join(sorted({r.get('text_id','') for r in drows if r.get('text_id')}))
    out_rows.append({
        'group': e.get('group',''),
        'entry': e.get('entry',''),
        'target': e.get('target',''),
        'pass87_owner_scene_or_character': owner,
        'pass87_owner_type': typ,
        'pass87_confidence': conf,
        'pass87_evidence': evidence,
        'direct_dialog_count': str(len(drows)),
        'direct_text_ids': text_ids,
        'direct_text_labels': labels,
        'text_preview_sample': previews,
        'pass81_entry_alias': e.get('pass81_entry_alias',''),
        'group_semantic_name': e.get('group_semantic_name',''),
        'pass82_owner_domain': e.get('pass82_owner_domain',''),
        'pass82_scene_role': e.get('pass82_scene_role',''),
        'pass86_visual_name_confidence': visual.get('pass86_visual_name_confidence',''),
        'pass86_primary_visual_semantic_names': visual.get('pass86_primary_visual_semantic_names',''),
        'pseudocode_preview': e.get('pseudocode_preview',''),
    })

fields = ['group','entry','target','pass87_owner_scene_or_character','pass87_owner_type','pass87_confidence','pass87_evidence','direct_dialog_count','direct_text_ids','direct_text_labels','text_preview_sample','pass81_entry_alias','group_semantic_name','pass82_owner_domain','pass82_scene_role','pass86_visual_name_confidence','pass86_primary_visual_semantic_names','pseudocode_preview']
write_csv(REPORTS/'pass87_eventscript_character_scene_owner_xref.csv', out_rows, fields)

# summaries
summary_type = collections.Counter(r['pass87_owner_type'] for r in out_rows)
summary_owner = collections.Counter(r['pass87_owner_scene_or_character'] for r in out_rows)
summary_conf = collections.Counter(r['pass87_confidence'] for r in out_rows)
summary_group = collections.defaultdict(lambda: collections.Counter())
for r in out_rows:
    summary_group[r['group']][r['pass87_owner_type']] += 1

type_rows = [{'owner_type':k,'entries':v,'percent':f'{v*100/len(out_rows):.3f}'} for k,v in summary_type.most_common()]
owner_rows = [{'owner_scene_or_character':k,'entries':v,'percent':f'{v*100/len(out_rows):.3f}'} for k,v in summary_owner.most_common()]
conf_rows = [{'confidence':k,'entries':v,'percent':f'{v*100/len(out_rows):.3f}'} for k,v in summary_conf.most_common()]
group_rows_out=[]
for g,c in sorted(summary_group.items()):
    top = c.most_common(5)
    group_rows_out.append({'group':g,'entries':sum(c.values()),'top_owner_types':' '.join(f'{k}:{v}' for k,v in top),'dominant_owner_type':top[0][0] if top else '', 'dominant_count':top[0][1] if top else 0})
write_csv(REPORTS/'pass87_character_scene_owner_type_summary.csv', type_rows, ['owner_type','entries','percent'])
write_csv(REPORTS/'pass87_character_scene_owner_summary.csv', owner_rows, ['owner_scene_or_character','entries','percent'])
write_csv(REPORTS/'pass87_character_scene_confidence_summary.csv', conf_rows, ['confidence','entries','percent'])
write_csv(REPORTS/'pass87_character_scene_group_summary.csv', group_rows_out, ['group','entries','dominant_owner_type','dominant_count','top_owner_types'])

# focus table for exact named direct text rows/entries
exact_names = {'Maria','Nina','Ann','Ellen','Eve'}
exact_direct = [r for r in out_rows if r['pass87_owner_scene_or_character'] in exact_names]
character_rows=[]
for name in sorted(exact_names):
    rows=[r for r in exact_direct if r['pass87_owner_scene_or_character']==name]
    character_rows.append({
        'character': name,
        'entries': len(rows),
        'groups': ' '.join(f'{g}:{c}' for g,c in collections.Counter(r['group'] for r in rows).most_common()),
        'example_entries': ' '.join(f"{r['group']}:{r['entry']}@{r['target']}" for r in rows[:10]),
        'example_text_ids': ' '.join(sorted(set(x for r in rows for x in r['direct_text_ids'].split()))[:20]),
    })
write_csv(REPORTS/'pass87_bachelorette_exact_text_xref.csv', character_rows, ['character','entries','groups','example_entries','example_text_ids'])

# remaining manual targets = not exact direct or direct category; useful for future pass.
manual = [r for r in out_rows if r['pass87_confidence'] in ('group_semantic_inferred','structural_inferred','domain_inferred')]
write_csv(REPORTS/'pass87_remaining_character_scene_manual_targets.csv', manual, fields)

# markdown report
md = []
md.append('# Pass 87 - EventScript Character / Scene Owner Xref\n')
md.append('This pass adds a character/scene owner layer above the Pass 81/82/86 semantic EventScript tables. It does not alter ROM bytes.\n')
md.append('## Measured coverage\n')
md.append(f'- EventScript entries classified with a Pass87 owner bucket: **{len(out_rows)}/{len(entry_rows)} = {len(out_rows)*100/len(entry_rows):.3f}%**\n')
md.append(f'- Direct-dialog EventScript rows analyzed: **{len(dialog_rows)}**\n')
md.append(f'- Entries with direct dialog evidence: **{len(dialog_by_entry)}**\n')
md.append(f'- Exact bachelorette named-text entry anchors: **{len(exact_direct)}**\n')
md.append(f'- Remaining structural/domain-inferred character-scene targets: **{len(manual)}**\n')
md.append('\n## Owner type summary\n\n| Owner type | Entries | Percent |\n|---|---:|---:|\n')
for r in type_rows[:30]:
    md.append(f"| `{r['owner_type']}` | {r['entries']} | {r['percent']}% |\n")
md.append('\n## Confidence summary\n\n| Confidence | Entries | Percent |\n|---|---:|---:|\n')
for r in conf_rows:
    md.append(f"| `{r['confidence']}` | {r['entries']} | {r['percent']}% |\n")
md.append('\n## Exact named bachelorette anchors\n\n| Character | Entries | Groups | Example entries |\n|---|---:|---|---|\n')
for r in character_rows:
    md.append(f"| {r['character']} | {r['entries']} | `{r['groups']}` | `{r['example_entries']}` |\n")
md.append('\n## Files\n')
for fn in [
    'pass87_eventscript_character_scene_owner_xref.csv',
    'pass87_character_scene_owner_type_summary.csv',
    'pass87_character_scene_owner_summary.csv',
    'pass87_character_scene_confidence_summary.csv',
    'pass87_character_scene_group_summary.csv',
    'pass87_bachelorette_exact_text_xref.csv',
    'pass87_remaining_character_scene_manual_targets.csv',
]:
    md.append(f'- `reports/{fn}`\n')
(REPORTS/'pass87_eventscript_character_scene_owner_xref.md').write_text(''.join(md), encoding='utf-8')

print(json.dumps({
    'entries': len(out_rows),
    'direct_dialog_rows': len(dialog_rows),
    'direct_dialog_entries': len(dialog_by_entry),
    'exact_bachelorette_entries': len(exact_direct),
    'manual_targets': len(manual),
    'confidence_summary': dict(summary_conf),
}, indent=2))
