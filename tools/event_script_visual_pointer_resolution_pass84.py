#!/usr/bin/env python3
from __future__ import annotations
import csv, re
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPORTS = ROOT / 'reports'
DOCS = ROOT / 'docs'
SRC = ROOT / 'src'

PASS83_PTRS = REPORTS / 'pass83_eventscript_visual_pointer_classification.csv'
PASS83_ENTRIES = REPORTS / 'pass83_eventscript_visual_gobj_entry_xref.csv'
PASS81_ALIASES = REPORTS / 'pass81_eventscript_all_entry_semantic_aliases.csv'
GOBJ_CATALOG = REPORTS / 'decomp_pass08' / 'sprites' / 'gobj_sprite_catalog.csv'

HEX_RE = re.compile(r'\$[0-9A-Fa-f]{4}')
ADDR_COMMENT_RE = re.compile(r';([0-9A-Fa-f]{6})')
LABEL_RE = re.compile(r'^\s*([A-Za-z_][A-Za-z0-9_.$]*)\s*:')

def read_csv(path: Path) -> list[dict]:
    with path.open(newline='', encoding='utf-8') as f:
        return list(csv.DictReader(f))

def hex4(v: int) -> str:
    return f'${v & 0xFFFF:04X}'

def parse_hex(s: str) -> int | None:
    try:
        return int(s.replace('$',''), 16)
    except Exception:
        return None

def infer_visual_family_from_context(blob: str) -> str:
    b = blob.lower()
    if 'chicken' in b or 'poultry' in b:
        return 'chicken_poultry'
    if 'cow' in b:
        return 'cow_livestock'
    if 'dog' in b:
        return 'dog_pet'
    if 'horse' in b:
        return 'horse_livestock'
    if any(w in b for w in ['livestock','animal']):
        return 'general_livestock'
    if any(w in b for w in ['family','romance','marriage','wife','girl','npc']):
        return 'npc_family_or_romance'
    if 'festival' in b:
        return 'festival_scene'
    if any(w in b for w in ['shipping','item','tool','object']):
        return 'object_item_scene'
    return 'mixed_visual_context'

def build_source_address_index() -> dict[str, list[dict]]:
    index = defaultdict(list)
    for path in sorted(SRC.rglob('*.asm')):
        bank_guess = None
        m = re.search(r'bank_([0-9A-Fa-f]{2})', path.name)
        if m:
            bank_guess = m.group(1).upper()
        for line_no, line in enumerate(path.read_text(encoding='utf-8', errors='ignore').splitlines(), 1):
            am = ADDR_COMMENT_RE.search(line)
            lm = LABEL_RE.match(line)
            if not am and not lm:
                continue
            full = am.group(1).upper() if am else None
            local = '$' + (full[-4:] if full else '')
            if not full and bank_guess and lm:
                local = None
            label = lm.group(1) if lm else ''
            if full:
                index[local].append({'full_addr': '$'+full, 'label': label, 'file': str(path.relative_to(ROOT)), 'line': line_no})
    return index

def main() -> int:
    REPORTS.mkdir(exist_ok=True)
    (DOCS/'event_script_system').mkdir(parents=True, exist_ok=True)
    (DOCS/'pseudocode').mkdir(parents=True, exist_ok=True)
    (DOCS/'handoff').mkdir(parents=True, exist_ok=True)

    ptr_rows = read_csv(PASS83_PTRS)
    entry_rows = read_csv(PASS83_ENTRIES)
    alias_rows = read_csv(PASS81_ALIASES)
    gobj_rows = read_csv(GOBJ_CATALOG) if GOBJ_CATALOG.exists() else []

    gobj_by_id = {r['gobj_id_hex'].upper(): r for r in gobj_rows if r.get('gobj_id_hex')}
    anim_by_low = defaultdict(list)
    for r in gobj_rows:
        seq = r.get('anim_sequence','').replace('$','').upper()
        if len(seq) >= 4:
            anim_by_low['$'+seq[-4:]].append(r)

    alias_by_low = defaultdict(list)
    alias_by_full = defaultdict(list)
    for r in alias_rows:
        tgt = r.get('target','').replace('$','').upper()
        if len(tgt) >= 4:
            alias_by_low['$'+tgt[-4:]].append(r)
        if len(tgt) == 6:
            alias_by_full['$'+tgt].append(r)

    source_idx = build_source_address_index()

    # entry context for semantic owner/family aggregation
    entry_by_id = {}
    for e in entry_rows:
        entry_by_id[f"{e['group']}:{e['entry']}@{e['target']}"] = e

    resolution_rows = []
    summary = Counter()
    exact_gobj_ids = set()
    exact_anim_refs = set()
    script_refs = set()
    source_refs = set()

    for r in ptr_rows:
        ref = r['visual_or_object_ref'].upper()
        cls = r['pass83_ref_class']
        ref_val = parse_hex(ref)
        examples = r.get('example_entries','').split()
        ctx_rows = [entry_by_id[x] for x in examples if x in entry_by_id]
        ctx_blob = ' '.join(' '.join([x.get('pass81_entry_alias',''), x.get('group_semantic_name',''), x.get('pass82_owner_domain',''), x.get('pass83_visual_domain',''), x.get('pass83_visual_role',''), x.get('pseudocode_preview','')]) for x in ctx_rows)
        family = infer_visual_family_from_context(ctx_blob + ' ' + r.get('domains','') + ' ' + r.get('roles',''))

        gobj_id_matches = []
        if ref in gobj_by_id:
            gobj_id_matches = [gobj_by_id[ref]]
            exact_gobj_ids.add(ref)

        anim_matches = anim_by_low.get(ref, [])
        if anim_matches:
            exact_anim_refs.add(ref)

        script_matches = alias_by_low.get(ref, []) if cls == 'bank_b3_b5_script_target_or_local_pointer' else []
        if script_matches:
            script_refs.add(ref)

        src_matches = source_idx.get(ref, [])
        if src_matches:
            source_refs.add(ref)

        if gobj_id_matches:
            resolution_class = 'exact_gobj_id'
            confidence = 'high_exact_catalog_id'
        elif anim_matches:
            resolution_class = 'exact_gobj_animation_sequence_lowword'
            confidence = 'high_exact_anim_sequence'
        elif script_matches:
            resolution_class = 'eventscript_local_target_alias'
            confidence = 'high_script_target_alias'
        elif cls == 'wram_or_runtime_cc_state_ref':
            resolution_class = 'runtime_cc_state_or_wram_pointer'
            confidence = 'high_runtime_state_ref'
        elif cls in ('low_immediate_param_or_small_id','mid_range_value_or_table_offset'):
            resolution_class = 'visual_param_or_non_gobj_id'
            confidence = 'medium_contextual_param'
        elif src_matches:
            resolution_class = 'source_address_line_match'
            confidence = 'medium_source_address_match'
        else:
            resolution_class = 'unresolved_asset_table_or_immediate'
            confidence = 'low_needs_manual_sprite_table_decode'
        summary[resolution_class] += 1

        def compact_gobj(rows, limit=5):
            out=[]
            for m in rows[:limit]:
                out.append(f"{m.get('gobj_id_hex')}:{m.get('anim_sequence')}:frames={m.get('frame_entries')}:gfx={m.get('graphics_banks')}")
            return ' | '.join(out)
        def compact_alias(rows, limit=5):
            return ' | '.join(f"{x.get('group')}:{x.get('entry')}@{x.get('target')}:{x.get('pass81_entry_alias')}" for x in rows[:limit])
        def compact_src(rows, limit=5):
            return ' | '.join(f"{x.get('full_addr')}:{x.get('label') or '<data>'}:{x.get('file')}:{x.get('line')}" for x in rows[:limit])

        resolution_rows.append({
            'visual_or_object_ref': ref,
            'pass83_ref_class': cls,
            'pass84_resolution_class': resolution_class,
            'pass84_confidence': confidence,
            'entry_count': r.get('entry_count',''),
            'semantic_visual_family': family,
            'gobj_id_match_count': len(gobj_id_matches),
            'gobj_id_matches': compact_gobj(gobj_id_matches),
            'anim_sequence_lowword_match_count': len(anim_matches),
            'anim_sequence_matches': compact_gobj(anim_matches),
            'eventscript_alias_match_count': len(script_matches),
            'eventscript_alias_matches': compact_alias(script_matches),
            'source_address_match_count': len(src_matches),
            'source_address_matches': compact_src(src_matches),
            'groups': r.get('groups',''),
            'domains': r.get('domains',''),
            'roles': r.get('roles',''),
            'example_entries': r.get('example_entries',''),
        })

    # enrich entries with resolved refs
    res_by_ref = {r['visual_or_object_ref']: r for r in resolution_rows}
    entry_out_rows = []
    entry_domain_summary = Counter()
    group_summary = defaultdict(Counter)
    for e in entry_rows:
        refs = e.get('visual_pointer_refs','').split()
        classes = Counter()
        exact_gobjs = []
        anims = []
        families = Counter()
        unresolved = []
        for ref in refs:
            rr = res_by_ref.get(ref.upper())
            if not rr: continue
            classes[rr['pass84_resolution_class']] += 1
            families[rr['semantic_visual_family']] += 1
            if rr['gobj_id_matches']:
                exact_gobjs.append(ref + '=' + rr['gobj_id_matches'].split(' | ')[0])
            if rr['anim_sequence_matches']:
                anims.append(ref + '=' + rr['anim_sequence_matches'].split(' | ')[0])
            if rr['pass84_resolution_class'] == 'unresolved_asset_table_or_immediate':
                unresolved.append(ref)
        dominant_family = families.most_common(1)[0][0] if families else infer_visual_family_from_context(' '.join([e.get('pass81_entry_alias',''), e.get('pass82_owner_domain',''), e.get('pass83_visual_domain','')]))
        if exact_gobjs or anims:
            confidence = 'high_catalog_visual_evidence'
        elif classes.get('eventscript_local_target_alias'):
            confidence = 'high_script_target_visual_flow'
        elif classes.get('runtime_cc_state_or_wram_pointer'):
            confidence = 'medium_high_runtime_visual_state'
        elif unresolved:
            confidence = 'medium_mixed_unresolved_refs'
        else:
            confidence = 'medium_contextual_visual_classification'
        entry_domain_summary[dominant_family] += 1
        group_summary[e['group']]['entries'] += 1
        group_summary[e['group']][dominant_family] += 1
        group_summary[e['group']][confidence] += 1
        row = dict(e)
        row.update({
            'pass84_dominant_visual_family': dominant_family,
            'pass84_visual_resolution_confidence': confidence,
            'pass84_resolution_classes': ' '.join(f'{k}:{v}' for k,v in classes.most_common()),
            'pass84_exact_gobj_id_evidence': ' ; '.join(exact_gobjs[:8]),
            'pass84_anim_sequence_evidence': ' ; '.join(anims[:8]),
            'pass84_unresolved_refs': ' '.join(unresolved),
        })
        entry_out_rows.append(row)

    # write pointer resolution
    ptr_out = REPORTS/'pass84_visual_pointer_resolution.csv'
    fields = list(resolution_rows[0].keys()) if resolution_rows else []
    with ptr_out.open('w',encoding='utf-8',newline='') as f:
        w=csv.DictWriter(f, fieldnames=fields); w.writeheader(); w.writerows(resolution_rows)

    entry_out = REPORTS/'pass84_eventscript_visual_entry_resolved_xref.csv'
    entry_fields = list(entry_out_rows[0].keys()) if entry_out_rows else []
    with entry_out.open('w',encoding='utf-8',newline='') as f:
        w=csv.DictWriter(f, fieldnames=entry_fields); w.writeheader(); w.writerows(entry_out_rows)

    summary_out = REPORTS/'pass84_visual_pointer_resolution_summary.csv'
    with summary_out.open('w',encoding='utf-8',newline='') as f:
        w=csv.DictWriter(f, fieldnames=['resolution_class','unique_refs','percent_of_refs'])
        w.writeheader()
        total = len(resolution_rows) or 1
        for k,v in summary.most_common():
            w.writerow({'resolution_class':k,'unique_refs':v,'percent_of_refs':f'{v*100/total:.3f}'})

    domain_out = REPORTS/'pass84_visual_family_domain_summary.csv'
    with domain_out.open('w',encoding='utf-8',newline='') as f:
        w=csv.DictWriter(f, fieldnames=['visual_family','entries','percent_of_visual_entries'])
        w.writeheader(); total_e=len(entry_out_rows) or 1
        for k,v in entry_domain_summary.most_common():
            w.writerow({'visual_family':k,'entries':v,'percent_of_visual_entries':f'{v*100/total_e:.3f}'})

    group_out = REPORTS/'pass84_visual_group_resolution_summary.csv'
    with group_out.open('w',encoding='utf-8',newline='') as f:
        w=csv.DictWriter(f, fieldnames=['group','visual_entries','top_visual_families','top_confidence'])
        w.writeheader()
        for g,c in sorted(group_summary.items()):
            fams=Counter({k:v for k,v in c.items() if k not in ('entries',) and not k.endswith('evidence') and not k.startswith('medium') and not k.startswith('high')})
            conf=Counter({k:v for k,v in c.items() if k.startswith(('high','medium','low'))})
            w.writerow({'group':g,'visual_entries':c['entries'],'top_visual_families':' '.join(f'{k}:{v}' for k,v in fams.most_common()),'top_confidence':' '.join(f'{k}:{v}' for k,v in conf.most_common())})

    high_exact = summary['exact_gobj_id'] + summary['exact_gobj_animation_sequence_lowword'] + summary['eventscript_local_target_alias'] + summary['runtime_cc_state_or_wram_pointer']
    total_refs = len(resolution_rows)
    md = REPORTS/'pass84_eventscript_visual_pointer_resolution.md'
    md.write_text(f'''# Pass 84 - EventScript Visual Pointer Resolution\n\nThis pass resolves the Pass83 visual/GOBJ candidate references against the sprite/GOBJ catalog, EventScript entry aliases, and source address index. It does not modify ROM bytes.\n\n## Measured results\n\n| Metric | Value |\n|---|---:|\n| Visual/object refs from Pass83 | {total_refs} |\n| Visual EventScript entries | {len(entry_out_rows)} |\n| Exact GOBJ id refs | {summary['exact_gobj_id']} |\n| Exact animation-sequence low-word refs | {summary['exact_gobj_animation_sequence_lowword']} |\n| EventScript local target alias refs | {summary['eventscript_local_target_alias']} |\n| Runtime/WRAM state refs | {summary['runtime_cc_state_or_wram_pointer']} |\n| High-confidence resolved refs | {high_exact}/{total_refs} ({(high_exact*100/(total_refs or 1)):.3f}%) |\n| Entry visual family classifications | {len(entry_out_rows)}/{len(entry_out_rows)} (100.000%) |\n\n## Resolution class summary\n\n''', encoding='utf-8')
    with md.open('a', encoding='utf-8') as f:
        f.write('| Class | Unique refs | Percent |\n|---|---:|---:|\n')
        for k,v in summary.most_common():
            f.write(f'| `{k}` | {v} | {v*100/(total_refs or 1):.3f}% |\n')
        f.write('\n## Notes\n\n- Small refs that match `gobj_id_hex` are treated as exact GOBJ id evidence.\n')
        f.write('- `$80xx-$9xxx` refs that match the low word of a catalogued animation sequence are treated as exact animation-sequence evidence.\n')
        f.write('- `$B3xx-$B5xx` refs are resolved back to EventScript aliases when possible.\n')
        f.write('- Remaining table/immediate refs are still classified, but need manual sprite table decoding for exact object names.\n')

    (DOCS/'event_script_system'/'EventScript_VisualPointerResolution_PASS84.md').write_text(md.read_text(encoding='utf-8'), encoding='utf-8')
    (DOCS/'pseudocode'/'EventScript_VisualPointerResolutionTool_PASS84.md').write_text('''# EventScript Visual Pointer Resolution Tool - Pass84\n\nInput:\n- pass83_eventscript_visual_pointer_classification.csv\n- pass83_eventscript_visual_gobj_entry_xref.csv\n- pass81_eventscript_all_entry_semantic_aliases.csv\n- decomp_pass08/sprites/gobj_sprite_catalog.csv\n\nProcess:\n1. Match visual refs to exact GOBJ ids.\n2. Match pointer-like refs to the low word of GOBJ animation sequence pointers.\n3. Match B3-B5 refs to EventScript aliases.\n4. Classify remaining refs as runtime state, parameters, source address matches, or unresolved asset/table immediates.\n\nOutput:\n- pass84_visual_pointer_resolution.csv\n- pass84_eventscript_visual_entry_resolved_xref.csv\n- pass84_visual_pointer_resolution_summary.csv\n''', encoding='utf-8')
    (DOCS/'event_script_system'/'STATUS_PASS84.md').write_text(f'''# STATUS PASS84\n\n- EventCmd dispatch: 90/90.\n- EventScript real residuals: 0.\n- EventScript groups named: 72/72.\n- EventScript entries aliased: 1288/1288.\n- Visual entries resolved/classified: {len(entry_out_rows)}/{len(entry_out_rows)}.\n- Visual/object refs classified: {total_refs}/{total_refs}.\n- High-confidence catalog/script visual refs: {high_exact}/{total_refs} ({(high_exact*100/(total_refs or 1)):.3f}%).\n''', encoding='utf-8')
    (DOCS/'handoff'/'METAS_DECOMP_PASS84.md').write_text('''# Handoff - Pass84\n\nNext high-value work:\n\n1. Convert medium/unresolved visual refs into exact sprite table/object names.\n2. Split GOBJ ids by actual in-game entity names where text/dialog context is insufficient.\n3. Cross-check visual refs with maps/festivals/cutscene routines.\n4. Promote high-confidence candidates into stable labels only when byte-perfect rebuild remains unchanged.\n''', encoding='utf-8')

    print(f'pass84_visual_refs={total_refs}')
    print(f'pass84_visual_entries={len(entry_out_rows)}')
    print(f'pass84_high_confidence_refs={high_exact}')
    print(f'pass84_high_confidence_percent={(high_exact*100/(total_refs or 1)):.3f}')
    return 0

if __name__ == '__main__':
    raise SystemExit(main())
