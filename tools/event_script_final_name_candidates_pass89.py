#!/usr/bin/env python3
import csv, os, re, json
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path.cwd()
REPORTS = ROOT / 'reports'
DOCS = ROOT / 'docs'
TOOLS = ROOT / 'tools'

IN_CSV = REPORTS / 'pass88_eventscript_owner_precision_tiers.csv'
REMAIN_CSV = REPORTS / 'pass88_remaining_final_name_targets.csv'

OUT_CSV = REPORTS / 'pass89_eventscript_final_name_candidates.csv'
SUMMARY_CSV = REPORTS / 'pass89_final_name_candidate_summary.csv'
PROTOTYPE_CSV = REPORTS / 'pass89_manual_prototype_queue.csv'
GROUP_CSV = REPORTS / 'pass89_group_final_name_candidate_summary.csv'
OWNER_CSV = REPORTS / 'pass89_owner_final_candidate_summary.csv'
MD = REPORTS / 'pass89_eventscript_final_name_candidate_layer.md'


def clean_token(s):
    s = (s or '').strip()
    if not s:
        return 'Unknown'
    s = re.sub(r'[^A-Za-z0-9_:$.-]+', '_', s)
    s = s.strip('_')
    return s or 'Unknown'


def normalize_lane(lane):
    lane = (lane or '').strip()
    if not lane:
        return 'UnknownLane'
    # pass88 structural lanes often look like Name::lane_type
    base = lane.split('::', 1)[0]
    return clean_token(base)


def role_suffix(role):
    role = (role or '').strip()
    mapping = {
        'dialogue_textbox_flow': 'DialogueFlow',
        'text_or_prompt_flow': 'PromptTextFlow',
        'visual_object_setup_or_spawn': 'VisualObjectSetup',
        'object_parameter_setup': 'ObjectParamSetup',
        'script_control_or_table_entry': 'ScriptControlEntry',
        'state_gate_branch_router': 'StateGateRouter',
        'transition_map_flow': 'TransitionFlow',
        'flag_value_update': 'FlagUpdate',
        'motion_velocity_update': 'MotionOrVelocityUpdate',
        'audio_sfx_trigger': 'AudioCue',
    }
    return mapping.get(role, clean_token(role) if role else 'SceneScript')


def candidate_for(row):
    tier = row.get('pass88_precision_tier','')
    owner = clean_token(row.get('pass87_owner_scene_or_character',''))
    lane = normalize_lane(row.get('pass88_refined_owner_lane',''))
    alias = clean_token(row.get('pass81_entry_alias',''))
    role = role_suffix(row.get('pass82_scene_role',''))
    group = row.get('group','').replace('$','G')
    entry = row.get('entry','0').zfill(3)
    if tier == 'exact_text_anchored_owner':
        candidate = f"{owner}_{role}_Entry{entry}"
        status = 'confirmed_text_or_direct_anchor_candidate'
        level = 'high'
        manual = 'optional_review_only'
        prototype = f"exact::{owner}::{role}"
    elif tier == 'domain_specific_owner_inferred':
        candidate = f"{lane}_{role}_Entry{entry}"
        status = 'domain_inferred_final_candidate'
        level = 'medium'
        manual = 'verify_against_map_npc_sprite_schedule_table'
        prototype = f"domain::{lane}::{role}"
    else:
        candidate = f"{lane}_{role}_Entry{entry}"
        status = 'structural_lane_final_candidate'
        level = 'medium_low'
        manual = row.get('pass88_recommended_next_action','manual_review') or 'manual_review'
        prototype = f"structural::{lane}::{role}"
    # Keep aliases from earlier pass as alternate if shorter candidate generic
    return clean_token(candidate), status, level, manual, prototype


def pct(n, d):
    return '0.000' if not d else f'{n*100.0/d:.3f}'


def read_csv(path):
    with path.open(newline='', errors='replace') as f:
        return list(csv.DictReader(f))


def main():
    if not IN_CSV.exists():
        raise SystemExit(f'Missing {IN_CSV}')
    rows = read_csv(IN_CSV)
    out_rows = []
    status_c = Counter(); level_c = Counter(); tier_c = Counter(); group_stats=defaultdict(Counter); owner_stats=defaultdict(Counter); proto=defaultdict(lambda: Counter())
    for r in rows:
        candidate, status, level, manual, prototype = candidate_for(r)
        tier = r.get('pass88_precision_tier','')
        final = dict(r)
        final['pass89_final_name_candidate'] = candidate
        final['pass89_candidate_status'] = status
        final['pass89_confirmation_level'] = level
        final['pass89_manual_confirmation_action'] = manual
        final['pass89_manual_prototype_key'] = prototype
        final['pass89_final_alias_line'] = f"{r.get('target','')} => {candidate}"
        out_rows.append(final)
        status_c[status]+=1; level_c[level]+=1; tier_c[tier]+=1
        group_stats[r.get('group','')][status]+=1
        group_stats[r.get('group','')]['total']+=1
        owner_stats[r.get('pass87_owner_type','')][status]+=1
        owner_stats[r.get('pass87_owner_type','')]['total']+=1
        proto[prototype]['entries'] += 1
        proto[prototype][status] += 1
        proto[prototype][level] += 1
        # Keep sample fields in proto counter using hack separate keys
        proto[prototype][f"sample_group={r.get('group','')}"] += 1
        proto[prototype][f"sample_candidate={candidate}"] += 1
        proto[prototype][f"manual_action={manual}"] += 1
    REPORTS.mkdir(exist_ok=True)
    with OUT_CSV.open('w', newline='') as f:
        fieldnames = list(out_rows[0].keys())
        w=csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader(); w.writerows(out_rows)
    total=len(out_rows)
    with SUMMARY_CSV.open('w', newline='') as f:
        w=csv.writer(f); w.writerow(['metric','entries','percent'])
        w.writerow(['total_entries_with_pass89_final_name_candidate', total, pct(total,total)])
        for k,v in status_c.most_common(): w.writerow([f'status:{k}', v, pct(v,total)])
        for k,v in level_c.most_common(): w.writerow([f'confirmation_level:{k}', v, pct(v,total)])
        for k,v in tier_c.most_common(): w.writerow([f'pass88_tier:{k}', v, pct(v,total)])
        exact=status_c.get('confirmed_text_or_direct_anchor_candidate',0)
        usable=sum(status_c.values())
        w.writerow(['candidate_layer_coverage', usable, pct(usable,total)])
        w.writerow(['nonconfirmed_candidates_requiring_optional_or_manual_validation', total-exact, pct(total-exact,total)])
    with GROUP_CSV.open('w', newline='') as f:
        all_status=list(status_c.keys())
        w=csv.writer(f); w.writerow(['group','total']+all_status+['candidate_coverage_percent'])
        for g,c in sorted(group_stats.items()):
            w.writerow([g,c['total']]+[c.get(s,0) for s in all_status]+[pct(c['total'],c['total'])])
    with OWNER_CSV.open('w', newline='') as f:
        all_status=list(status_c.keys())
        w=csv.writer(f); w.writerow(['owner_type','total']+all_status)
        for o,c in sorted(owner_stats.items(), key=lambda kv:(-kv[1]['total'], kv[0])):
            w.writerow([o,c['total']]+[c.get(s,0) for s in all_status])
    # prototypes: one row per unique prototype, excluding exact optional review if desired but include all
    proto_rows=[]
    for key,c in proto.items():
        status = 'mixed'
        for s in status_c:
            if c.get(s,0): status=s; break
        level='mixed'
        for l in ['high','medium','medium_low']:
            if c.get(l,0): level=l; break
        sample_group = next((k.split('=',1)[1] for k in c if k.startswith('sample_group=')), '')
        sample_candidate = next((k.split('=',1)[1] for k in c if k.startswith('sample_candidate=')), '')
        manual_action = next((k.split('=',1)[1] for k in c if k.startswith('manual_action=')), '')
        proto_rows.append({'prototype_key':key,'entries':c['entries'],'dominant_status':status,'dominant_level':level,'sample_group':sample_group,'sample_candidate':sample_candidate,'recommended_action':manual_action})
    proto_rows.sort(key=lambda r:(r['dominant_level']!='medium_low', -r['entries'], r['prototype_key']))
    with PROTOTYPE_CSV.open('w', newline='') as f:
        fieldnames=['prototype_key','entries','dominant_status','dominant_level','sample_group','sample_candidate','recommended_action']
        w=csv.DictWriter(f, fieldnames=fieldnames); w.writeheader(); w.writerows(proto_rows)
    # Markdown
    exact=status_c.get('confirmed_text_or_direct_anchor_candidate',0)
    domain=status_c.get('domain_inferred_final_candidate',0)
    structural=status_c.get('structural_lane_final_candidate',0)
    md = f"""# Pass 89 - EventScript Final Name Candidate Layer

This pass adds a deterministic final-name candidate layer on top of Pass 88 owner precision tiers.
It does not change ROM bytes or executable source logic.

## Objective metrics

| Metric | Value |
|---|---:|
| EventScript entries processed | {total} |
| Entries with Pass89 final name candidate | {total}/{total} = {pct(total,total)}% |
| Confirmed/direct text anchored candidates | {exact}/{total} = {pct(exact,total)}% |
| Domain inferred final candidates | {domain}/{total} = {pct(domain,total)}% |
| Structural lane final candidates | {structural}/{total} = {pct(structural,total)}% |
| Unique manual prototype keys | {len(proto_rows)} |

## What changed

Pass 88 reduced the problem to owner precision tiers. Pass 89 gives every EventScript entry a stable
`pass89_final_name_candidate`, a `pass89_candidate_status`, a confirmation level, and a manual prototype key.
This reduces the next manual pass from reviewing isolated raw entries to reviewing grouped scene/NPC/object prototypes.

## Output files

- `reports/pass89_eventscript_final_name_candidates.csv`
- `reports/pass89_final_name_candidate_summary.csv`
- `reports/pass89_manual_prototype_queue.csv`
- `reports/pass89_group_final_name_candidate_summary.csv`
- `reports/pass89_owner_final_candidate_summary.csv`

## Interpretation

- `confirmed_text_or_direct_anchor_candidate`: high confidence from text/dialogue or direct anchor.
- `domain_inferred_final_candidate`: useful candidate from a specific domain such as livestock, weather, festival, shipping.
- `structural_lane_final_candidate`: stable candidate based on group/lane/role; still needs exact NPC/festival/cutscene validation.
"""
    MD.write_text(md)
    print(json.dumps({'total':total,'exact':exact,'domain':domain,'structural':structural,'prototypes':len(proto_rows)}, indent=2))

if __name__ == '__main__':
    main()
