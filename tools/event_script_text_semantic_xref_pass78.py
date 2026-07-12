#!/usr/bin/env python3
"""Pass 78: cross-reference EventScript dialog/text commands with text catalog.

This is a semantic documentation pass. It does not change assembled bytes.
It decodes all B3-B5 EventScript entries using the current corrected opcode
model, extracts direct text ids from dialog commands, resolves them against the
existing text pointer catalog, and emits per-entry/per-group semantic hints.
"""
from __future__ import annotations
from pathlib import Path
from collections import Counter, defaultdict
import argparse, csv, hashlib, re, sys

TOOL_DIR = Path(__file__).resolve().parent
if str(TOOL_DIR) not in sys.path:
    sys.path.insert(0, str(TOOL_DIR))

from event_script_symbolic_disasm import (  # type: ignore
    EXPECTED_USA_MD5,
    RomView,
    master_groups,
    unique_boundaries,
    decode_entry,
    addr_s,
)

TEXT_ID_RE = re.compile(r"text_id=\$([0-9A-Fa-f]{4})")
TEXT_RELATED_RE = re.compile(r"TextRelated\(a=\$([0-9A-Fa-f]{4})")

NPC_KEYWORDS = {
    "Maria": "npc_maria_romance_or_family",
    "Ann": "npc_ann_romance_or_family",
    "Ellen": "npc_ellen_romance_or_family",
    "Nina": "npc_nina_romance_or_family",
    "Eve": "npc_eve_romance_or_family",
    "wife": "wife_family_event",
    "Wife": "wife_family_event",
    "baby": "child_family_event",
    "child": "child_family_event",
    "son": "child_family_event",
    "daughter": "child_family_event",
    "Florist": "npc_florist_family",
    "Mayor": "npc_mayor_or_festival",
    "fortune": "npc_fortune_teller",
    "Ranch": "ranch_livestock_context",
    "cow": "livestock_cow_context",
    "Cow": "livestock_cow_context",
    "chicken": "livestock_chicken_context",
    "Chicken": "livestock_chicken_context",
    "horse": "livestock_horse_context",
    "dog": "livestock_dog_context",
    "festival": "festival_event",
    "Festival": "festival_event",
    "Harvest": "festival_or_title_context",
    "weather": "weather_context",
    "tomorrow": "weather_context",
    "ship": "shipping_context",
    "sell": "shop_or_shipping_context",
    "buy": "shop_or_purchase_context",
    "shop": "shop_or_purchase_context",
    "money": "money_context",
    "tool": "tool_context",
    "paint": "house_upgrade_context",
    "house": "house_upgrade_or_family_context",
    "Cake": "family_romance_gift_context",
    "cake": "family_romance_gift_context",
}

CATEGORY_HINTS = {
    "Weather": "weather_forecast_system",
    "Romance": "romance_or_marriage_dialogue",
    "Dialog": "npc_or_event_dialogue",
    "Menu": "menu_interface_text",
    "Item": "item_or_inventory_text",
    "Festival": "festival_event_text",
    "System": "system_message",
}

def md5(path: Path) -> str:
    h = hashlib.md5()
    with path.open('rb') as fp:
        for chunk in iter(lambda: fp.read(1024 * 1024), b''):
            h.update(chunk)
    return h.hexdigest()

def clean_preview(s: str, limit: int = 96) -> str:
    s = " ".join((s or "").replace('\n', ' ').split())
    if len(s) > limit:
        return s[:limit-1].rstrip() + "…"
    return s

def infer_text_role(label: str, category: str, preview: str) -> str:
    hay = f"{label} {category} {preview}"
    hits = []
    for key, hint in NPC_KEYWORDS.items():
        if key in hay:
            hits.append(hint)
    if hits:
        return ";".join(sorted(set(hits)))
    return CATEGORY_HINTS.get(category, "event_dialogue_unknown_specific_owner")

def load_text_catalog(path: Path) -> dict[str, dict[str, str]]:
    out: dict[str, dict[str, str]] = {}
    with path.open('r', newline='', encoding='utf-8', errors='replace') as fp:
        for row in csv.DictReader(fp):
            idx = (row.get('index_hex') or '').strip().upper().zfill(4)
            out[idx] = row
    return out

def group_bucket_from_existing(path: Path) -> dict[str, dict[str, str]]:
    d: dict[str, dict[str, str]] = {}
    if not path.exists():
        return d
    with path.open('r', newline='', encoding='utf-8', errors='replace') as fp:
        for row in csv.DictReader(fp):
            d[row.get('group','')] = row
    return d

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument('--rom', required=True, type=Path)
    ap.add_argument('--text-catalog', default=Path('reports/decomp_pass03/text/text_pointer_catalog.csv'), type=Path)
    ap.add_argument('--group-map', default=Path('reports/event_script_group_semantic_map_pass73.csv'), type=Path)
    ap.add_argument('--out-dir', default=Path('reports'), type=Path)
    ap.add_argument('--max-commands', type=int, default=192)
    args = ap.parse_args()
    args.out_dir.mkdir(parents=True, exist_ok=True)

    rom_hash = md5(args.rom)
    if rom_hash != EXPECTED_USA_MD5:
        raise SystemExit(f'ROM MD5 inesperado: {rom_hash}')

    text_catalog = load_text_catalog(args.text_catalog)
    group_map = group_bucket_from_existing(args.group_map)

    rv = RomView(args.rom.read_bytes())
    groups = master_groups(rv)

    direct_rows: list[dict[str, str]] = []
    text_related_rows: list[dict[str, str]] = []
    missing_rows: list[dict[str, str]] = []
    entry_seen = set()
    group_texts: dict[str, set[str]] = defaultdict(set)
    group_direct_counts: Counter[str] = Counter()
    group_related_counts: Counter[str] = Counter()
    group_role_counts: dict[str, Counter[str]] = defaultdict(Counter)
    group_category_counts: dict[str, Counter[str]] = defaultdict(Counter)
    groups_with_dialog = set()
    total_entries = 0
    total_commands = 0
    total_dialog_cmds = 0
    total_text_related_cmds = 0

    for gid, group_addr, targets in groups:
        boundaries = unique_boundaries(targets)
        dup_counter = Counter(targets)
        group_s = f'${gid:02X}'
        bucket = group_map.get(group_s, {}).get('semantic_bucket', '')
        confidence = group_map.get(group_s, {}).get('confidence', '')
        for idx, target in enumerate(targets):
            total_entries += 1
            ent = decode_entry(rv, gid, idx, target, boundaries[target], dup_counter[target], args.max_commands)
            total_commands += len(ent.commands)
            for cmd_index, cmd in enumerate(ent.commands):
                # Direct dialog/textbox commands only: StartTextBox, StartTextBoxCopy, StartTextBoxAndAdvanceSlot.
                m = TEXT_ID_RE.search(cmd.text)
                if m:
                    total_dialog_cmds += 1
                    tid = m.group(1).upper().zfill(4)
                    key = (group_s, str(idx), addr_s(target), str(cmd_index), tid, cmd.name)
                    if key in entry_seen:
                        continue
                    entry_seen.add(key)
                    cat = text_catalog.get(tid)
                    if cat is None:
                        missing_rows.append({
                            'kind': 'direct_dialog_text_id', 'group': group_s, 'entry': str(idx), 'target': addr_s(target),
                            'cmd_index': str(cmd_index), 'cmd_addr': addr_s(cmd.addr), 'cmd_name': cmd.name,
                            'text_id': tid, 'reason': 'text id not found in pointer catalog',
                        })
                        continue
                    label = cat.get('label','')
                    category = cat.get('category','')
                    preview = clean_preview(cat.get('text_preview',''))
                    role = infer_text_role(label, category, preview)
                    row = {
                        'group': group_s,
                        'entry': str(idx),
                        'target': addr_s(target),
                        'cmd_index': str(cmd_index),
                        'cmd_addr': addr_s(cmd.addr),
                        'cmd_name': cmd.name,
                        'text_id': tid,
                        'text_label': label,
                        'text_category': category,
                        'inferred_role': role,
                        'semantic_bucket': bucket,
                        'group_confidence_before_pass78': confidence,
                        'text_preview': preview,
                    }
                    direct_rows.append(row)
                    group_texts[group_s].add(tid)
                    group_direct_counts[group_s] += 1
                    group_category_counts[group_s][category] += 1
                    for part in role.split(';'):
                        if part:
                            group_role_counts[group_s][part] += 1
                    groups_with_dialog.add(group_s)
                # TextRelated(a=$xxxx) is tracked separately because it may be a control/text argument.
                m2 = TEXT_RELATED_RE.search(cmd.text)
                if m2:
                    total_text_related_cmds += 1
                    tid = m2.group(1).upper().zfill(4)
                    cat = text_catalog.get(tid)
                    if cat is None:
                        missing_rows.append({
                            'kind': 'text_related_arg_a', 'group': group_s, 'entry': str(idx), 'target': addr_s(target),
                            'cmd_index': str(cmd_index), 'cmd_addr': addr_s(cmd.addr), 'cmd_name': cmd.name,
                            'text_id': tid, 'reason': 'text-related argument not found in pointer catalog',
                        })
                        continue
                    category = cat.get('category','')
                    role = infer_text_role(cat.get('label',''), category, cat.get('text_preview',''))
                    text_related_rows.append({
                        'group': group_s, 'entry': str(idx), 'target': addr_s(target), 'cmd_index': str(cmd_index),
                        'cmd_addr': addr_s(cmd.addr), 'cmd_name': cmd.name, 'text_id': tid,
                        'text_label': cat.get('label',''), 'text_category': category,
                        'inferred_role': role, 'semantic_bucket': bucket,
                        'text_preview': clean_preview(cat.get('text_preview','')),
                    })
                    group_related_counts[group_s] += 1

    # Write direct xrefs.
    direct_csv = args.out_dir / 'pass78_eventscript_direct_dialog_text_xref.csv'
    direct_fields = ['group','entry','target','cmd_index','cmd_addr','cmd_name','text_id','text_label','text_category','inferred_role','semantic_bucket','group_confidence_before_pass78','text_preview']
    with direct_csv.open('w', newline='', encoding='utf-8') as fp:
        writer = csv.DictWriter(fp, fieldnames=direct_fields)
        writer.writeheader(); writer.writerows(direct_rows)

    related_csv = args.out_dir / 'pass78_eventscript_text_related_arg_xref.csv'
    related_fields = ['group','entry','target','cmd_index','cmd_addr','cmd_name','text_id','text_label','text_category','inferred_role','semantic_bucket','text_preview']
    with related_csv.open('w', newline='', encoding='utf-8') as fp:
        writer = csv.DictWriter(fp, fieldnames=related_fields)
        writer.writeheader(); writer.writerows(text_related_rows)

    missing_csv = args.out_dir / 'pass78_eventscript_text_xref_missing.csv'
    missing_fields = ['kind','group','entry','target','cmd_index','cmd_addr','cmd_name','text_id','reason']
    with missing_csv.open('w', newline='', encoding='utf-8') as fp:
        writer = csv.DictWriter(fp, fieldnames=missing_fields)
        writer.writeheader(); writer.writerows(missing_rows)

    # Per-group summary.
    group_rows: list[dict[str, str]] = []
    for gid, _group_addr, targets in groups:
        gs = f'${gid:02X}'
        categories = group_category_counts[gs].most_common(5)
        roles = group_role_counts[gs].most_common(6)
        texts = sorted(group_texts[gs])
        bucket = group_map.get(gs, {}).get('semantic_bucket', '')
        old_conf = group_map.get(gs, {}).get('confidence', '')
        if group_direct_counts[gs] == 0:
            pass78_conf = old_conf or 'n/a'
            action = 'No direct textbox commands; use RAM/object/sprite analysis.'
        elif len(texts) >= 8 or roles:
            pass78_conf = 'high_text_anchor'
            action = 'Entries can now be split/name-refined using resolved text labels and previews.'
        else:
            pass78_conf = 'medium_text_anchor'
            action = 'Use resolved text IDs plus RAM symbols before final event naming.'
        group_rows.append({
            'group': gs,
            'entries': str(len(targets)),
            'semantic_bucket_before_pass78': bucket,
            'confidence_before_pass78': old_conf,
            'direct_dialog_cmds': str(group_direct_counts[gs]),
            'unique_direct_text_ids': str(len(texts)),
            'text_related_arg_cmds': str(group_related_counts[gs]),
            'top_text_categories': ' '.join(f'{k}:{v}' for k,v in categories) or '-',
            'top_inferred_roles': ' '.join(f'{k}:{v}' for k,v in roles) or '-',
            'pass78_text_anchor_confidence': pass78_conf,
            'recommended_next_action': action,
        })
    group_csv = args.out_dir / 'pass78_eventscript_group_text_semantic_summary.csv'
    with group_csv.open('w', newline='', encoding='utf-8') as fp:
        writer = csv.DictWriter(fp, fieldnames=list(group_rows[0].keys()))
        writer.writeheader(); writer.writerows(group_rows)

    # Focused family/NPC/dialogue matrix MD.
    family_groups = [r for r in group_rows if 'family_romance' in r['semantic_bucket_before_pass78'] or 'romance' in r['top_inferred_roles'] or 'wife_family_event' in r['top_inferred_roles']]
    # Top direct rows in important dialogue groups.
    rows_by_group: dict[str, list[dict[str,str]]] = defaultdict(list)
    for r in direct_rows:
        rows_by_group[r['group']].append(r)

    md = args.out_dir / 'pass78_eventscript_text_semantic_crossref.md'
    with md.open('w', encoding='utf-8') as fp:
        fp.write('# Pass 78 - EventScript text semantic cross-reference\n\n')
        fp.write('Pass 78 links decoded B3-B5 EventScript textbox commands to the existing text pointer catalog. This closes the text-anchor layer for script/event naming: every direct `StartTextBox`, `StartTextBoxCopy`, and `StartTextBoxAndAdvanceSlot` text id found by the decoder is resolved to a text label/category/preview when present in the catalog.\n\n')
        fp.write(f'- ROM MD5: `{rom_hash}`\n')
        fp.write(f'- EventScript groups scanned: `72`\n')
        fp.write(f'- EventScript entries scanned: `{total_entries}`\n')
        fp.write(f'- Commands decoded under corrected model: `{total_commands}`\n')
        fp.write(f'- Direct textbox commands resolved: `{len(direct_rows)}`\n')
        fp.write(f'- Direct textbox ids missing from text catalog: `{sum(1 for r in missing_rows if r["kind"] == "direct_dialog_text_id")}`\n')
        fp.write(f'- TextRelated argument links resolved separately: `{len(text_related_rows)}`\n')
        fp.write(f'- Groups with direct dialog anchors: `{len(groups_with_dialog)}/72`\n\n')
        fp.write('## Closure metric\n\n')
        missing_direct = sum(1 for r in missing_rows if r['kind'] == 'direct_dialog_text_id')
        direct_total = len(direct_rows) + missing_direct
        pct = (len(direct_rows) / direct_total * 100.0) if direct_total else 100.0
        fp.write('| Metric | Value |\n|---|---:|\n')
        fp.write(f'| Direct EventScript textbox commands resolved to text catalog | `{len(direct_rows)}/{direct_total}` |\n')
        fp.write(f'| Direct textbox text-id coverage | `{pct:.3f}%` |\n')
        fp.write(f'| Direct textbox missing ids | `{missing_direct}` |\n')
        fp.write(f'| EventScript groups with at least one direct dialog text anchor | `{len(groups_with_dialog)}/72` |\n')
        fp.write('\n## High-value groups for semantic event naming\n\n')
        fp.write('| Group | Bucket | Direct cmds | Unique text ids | Top inferred roles | Next action |\n')
        fp.write('|---:|---|---:|---:|---|---|\n')
        for row in sorted(group_rows, key=lambda r: int(r['direct_dialog_cmds']), reverse=True)[:16]:
            fp.write(f"| `{row['group']}` | `{row['semantic_bucket_before_pass78']}` | {row['direct_dialog_cmds']} | {row['unique_direct_text_ids']} | `{row['top_inferred_roles']}` | {row['recommended_next_action']} |\n")
        fp.write('\n## Family/romance/NPC dialogue groups\n\n')
        fp.write('| Group | Direct cmds | Unique text ids | Top categories | Top inferred roles |\n')
        fp.write('|---:|---:|---:|---|---|\n')
        for row in sorted(family_groups, key=lambda r: (r['semantic_bucket_before_pass78'], -int(r['direct_dialog_cmds']))):
            fp.write(f"| `{row['group']}` | {row['direct_dialog_cmds']} | {row['unique_direct_text_ids']} | `{row['top_text_categories']}` | `{row['top_inferred_roles']}` |\n")
        fp.write('\n## Sample resolved text anchors\n\n')
        fp.write('| Group | Entry | Text id | Label | Category | Inferred role | Preview |\n')
        fp.write('|---:|---:|---:|---|---|---|---|\n')
        sample = []
        for group in ['$44','$04','$07','$01','$02','$03','$06','$08','$43','$45','$47']:
            sample.extend(rows_by_group.get(group, [])[:4])
        for r in sample[:44]:
            fp.write(f"| `{r['group']}` | {r['entry']} | `${r['text_id']}` | `{r['text_label']}` | `{r['text_category']}` | `{r['inferred_role']}` | {r['text_preview'].replace('|','/')} |\n")
        fp.write('\n## Practical result\n\n')
        fp.write('- EventScript opcode/payload/residual layer was already closed in Pass 77.\n')
        fp.write('- Pass 78 closes the direct text-id resolution layer for decoded dialog commands.\n')
        fp.write('- The next semantic pass should use this xref to rename event entries by real scene/person/festival where the text label is decisive.\n')

    family_md = args.out_dir / 'pass78_family_romance_dialogue_matrix.md'
    with family_md.open('w', encoding='utf-8') as fp:
        fp.write('# Pass 78 - family/romance dialogue matrix\n\n')
        fp.write('This report lists direct dialog anchors for the family/romance-heavy EventScript groups. It is meant as the next manual naming map for wife/child/girl/family milestones.\n\n')
        for gr in ['$01','$02','$03','$04','$05','$06','$07','$08','$44','$45']:
            rr = rows_by_group.get(gr, [])
            if not rr:
                continue
            fp.write(f'## Group `{gr}`\n\n')
            fp.write('| Entry | Target | Text id | Label | Category | Role | Preview |\n')
            fp.write('|---:|---:|---:|---|---|---|---|\n')
            for r in rr[:64]:
                fp.write(f"| {r['entry']} | `{r['target']}` | `${r['text_id']}` | `{r['text_label']}` | `{r['text_category']}` | `{r['inferred_role']}` | {r['text_preview'].replace('|','/')} |\n")
            fp.write('\n')

    print(f'Wrote {direct_csv}')
    print(f'Pass78 direct_dialog_resolved={len(direct_rows)} missing={len(missing_rows)} groups_with_dialog={len(groups_with_dialog)}/72 total_commands={total_commands}')
    return 0

if __name__ == '__main__':
    raise SystemExit(main())
