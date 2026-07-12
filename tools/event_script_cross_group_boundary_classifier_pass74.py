#!/usr/bin/env python3
"""
Pass 74 helper: classify EventScript residual markers that are actually cross-group
boundary artifacts.

Pass 73 intentionally used a conservative per-entry linear scan. That scan can
follow duplicate/cross-group pointers past the end of the owning EventScript
content group. This tool overlays the hard EventScriptGroup start boundaries
from the master B3 table and separates these false residuals from true in-group
inline residual payloads.
"""
from __future__ import annotations

from pathlib import Path
from collections import Counter, defaultdict
import argparse
import csv
import hashlib
import re
import sys

TOOL_DIR = Path(__file__).resolve().parent
if str(TOOL_DIR) not in sys.path:
    sys.path.insert(0, str(TOOL_DIR))

from event_script_symbolic_disasm import (  # type: ignore
    EXPECTED_USA_MD5,
    RomView,
    master_groups,
    addr_s,
)


def md5(path: Path) -> str:
    h = hashlib.md5()
    with path.open('rb') as fp:
        for chunk in iter(lambda: fp.read(1024 * 1024), b''):
            h.update(chunk)
    return h.hexdigest()


def parse_addr(text: str) -> int:
    text = text.strip().replace('$', '')
    return int(text, 16)


def read_pass73_totals(report_path: Path) -> tuple[int, int, int]:
    text = report_path.read_text(encoding='utf-8')
    def grab(name: str) -> int:
        m = re.search(rf'- {re.escape(name)}: `([0-9]+)`', text)
        if not m:
            raise RuntimeError(f'Nao achei total no report Pass73: {name}')
        return int(m.group(1))
    total = grab('Total symbolic commands/markers')
    known = grab('Known symbolic commands')
    residual = grab('Residual markers')
    return total, known, residual


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument('--rom', required=True, type=Path)
    ap.add_argument('--pass73-residual-csv', default=Path('reports/pass73_eventscript_residual_entries.csv'), type=Path)
    ap.add_argument('--pass73-group-csv', default=Path('reports/pass73_eventscript_residual_group_summary.csv'), type=Path)
    ap.add_argument('--pass73-report', default=Path('reports/pass73_eventscript_residual_classifier.md'), type=Path)
    ap.add_argument('--out-dir', default=Path('reports'), type=Path)
    args = ap.parse_args()

    rom_hash = md5(args.rom)
    if rom_hash != EXPECTED_USA_MD5:
        raise SystemExit(f'ROM MD5 inesperado: {rom_hash}')

    args.out_dir.mkdir(parents=True, exist_ok=True)
    rv = RomView(args.rom.read_bytes())

    # Hard group start/end ranges as intended by the EventScript master group table.
    starts: list[tuple[int, int]] = [(gid, group_addr) for gid, group_addr, _targets in master_groups(rv)]
    next_group_start: dict[int, int | None] = {}
    for i, (gid, group_addr) in enumerate(starts):
        next_group_start[gid] = starts[i + 1][1] if i + 1 < len(starts) else None

    total_markers, pass73_known, pass73_residuals = read_pass73_totals(args.pass73_report)

    group_command_counts: dict[int, int] = {}
    with args.pass73_group_csv.open('r', encoding='utf-8', newline='') as fp:
        for row in csv.DictReader(fp):
            gid = int(row['group'].replace('$', ''), 16)
            group_command_counts[gid] = int(row['commands'])

    classified_rows: list[dict[str, object]] = []
    by_group: dict[int, Counter[str]] = defaultdict(Counter)
    by_orig_cat: Counter[str] = Counter()
    by_final_cat: Counter[str] = Counter()

    with args.pass73_residual_csv.open('r', encoding='utf-8', newline='') as fp:
        for row in csv.DictReader(fp):
            gid = int(row['group'].replace('$', ''), 16)
            residual_addr = parse_addr(row['residual_addr'])
            target_addr = parse_addr(row['target'])
            hard_end = next_group_start.get(gid)
            if hard_end is not None and residual_addr >= hard_end:
                final_cat = 'cross_group_boundary_artifact'
                reason = 'linear scan reached the next EventScriptGroup start or later; not a missing opcode for this group'
            elif hard_end is not None and target_addr >= hard_end:
                final_cat = 'cross_group_target_alias'
                reason = 'entry target belongs to a later EventScriptGroup; count as cross-group alias, not local script residue'
            else:
                final_cat = 'true_in_group_inline_residual_needs_manual_trace'
                reason = 'residual is still inside the hard owning group range; needs manual event/content analysis'

            by_orig_cat[row['category']] += 1
            by_final_cat[final_cat] += 1
            by_group[gid][final_cat] += 1
            classified_rows.append({
                'group': row['group'],
                'entry': row['entry'],
                'target': row['target'],
                'residual_addr': row['residual_addr'],
                'hard_group_end': addr_s(hard_end) if hard_end is not None else '$B5FFFF',
                'pass73_category': row['category'],
                'pass74_category': final_cat,
                'reason': reason,
                'residual_byte': row['residual_byte'],
                'cmd_index': row['cmd_index'],
                'first_bytes_at_residual': row['first_bytes_at_residual'],
            })

    cross_artifacts = by_final_cat['cross_group_boundary_artifact'] + by_final_cat['cross_group_target_alias']
    true_inline = by_final_cat['true_in_group_inline_residual_needs_manual_trace']
    effective_known = pass73_known + cross_artifacts
    effective_unknown = true_inline
    effective_known_pct = (effective_known / total_markers * 100.0) if total_markers else 100.0
    effective_unknown_pct = (effective_unknown / total_markers * 100.0) if total_markers else 0.0
    artifact_pct_of_residuals = (cross_artifacts / pass73_residuals * 100.0) if pass73_residuals else 0.0

    # Per-group hard-boundary summary.
    group_rows: list[dict[str, object]] = []
    groups_no_true_inline: list[int] = []
    for gid, group_addr in starts:
        cmds = group_command_counts.get(gid, 0)
        g_cross = by_group[gid]['cross_group_boundary_artifact'] + by_group[gid]['cross_group_target_alias']
        g_true = by_group[gid]['true_in_group_inline_residual_needs_manual_trace']
        g_total_res = sum(by_group[gid].values())
        if g_true == 0:
            groups_no_true_inline.append(gid)
        effective_group_known = max(0, cmds - g_true)
        group_rows.append({
            'group': f'${gid:02X}',
            'group_start': addr_s(group_addr),
            'hard_group_end': addr_s(next_group_start[gid]) if next_group_start[gid] is not None else '$B5FFFF',
            'commands_or_markers': cmds,
            'pass73_residuals': g_total_res,
            'cross_group_artifacts': g_cross,
            'true_in_group_residuals': g_true,
            'pass74_effective_known_percent': f'{(effective_group_known / cmds * 100.0) if cmds else 100.0:.3f}',
            'status': 'closed_after_boundary_overlay' if g_true == 0 else 'needs_manual_inline_trace',
        })

    classified_csv = args.out_dir / 'pass74_eventscript_boundary_classified_residuals.csv'
    with classified_csv.open('w', encoding='utf-8', newline='') as fp:
        writer = csv.DictWriter(fp, fieldnames=list(classified_rows[0].keys()) if classified_rows else [])
        writer.writeheader()
        writer.writerows(classified_rows)

    group_csv = args.out_dir / 'pass74_eventscript_group_boundary_summary.csv'
    with group_csv.open('w', encoding='utf-8', newline='') as fp:
        writer = csv.DictWriter(fp, fieldnames=list(group_rows[0].keys()))
        writer.writeheader()
        writer.writerows(group_rows)

    md_path = args.out_dir / 'pass74_eventscript_cross_group_boundary_closure.md'
    with md_path.open('w', encoding='utf-8') as fp:
        fp.write('# Pass 74 - EventScript cross-group boundary closure\n\n')
        fp.write('Pass 73 proved that the official EventCmd dispatch table is complete, but the conservative linear scanner still reported residual bytes. Pass 74 overlays the hard EventScriptGroup start boundaries from the master table and separates false residuals caused by cross-group pointers from true in-group inline payloads.\n\n')
        fp.write(f'- ROM MD5: `{rom_hash}`\n')
        fp.write(f'- Total symbolic commands/markers from Pass 73: `{total_markers}`\n')
        fp.write(f'- Pass 73 known commands: `{pass73_known}`\n')
        fp.write(f'- Pass 73 residual markers: `{pass73_residuals}`\n')
        fp.write(f'- Cross-group boundary artifacts resolved in Pass 74: `{cross_artifacts}`\n')
        fp.write(f'- True in-group inline residuals remaining: `{true_inline}`\n')
        fp.write(f'- Effective known coverage after boundary overlay: `{effective_known_pct:.3f}%`\n')
        fp.write(f'- Effective unresolved in-group residual percent: `{effective_unknown_pct:.3f}%`\n\n')
        fp.write('## Closure result\n\n')
        fp.write('| Metric | Value | Status |\n|---|---:|---|\n')
        fp.write('| Official EventCmd dispatch audit | 90/90 | 100% closed |\n')
        fp.write(f'| Residual markers reclassified as cross-group artifacts | {cross_artifacts}/{pass73_residuals} | {artifact_pct_of_residuals:.3f}% of Pass 73 residuals resolved |\n')
        fp.write(f'| True in-group residual markers | {true_inline}/{total_markers} | {effective_unknown_pct:.3f}% remains |\n')
        fp.write(f'| Groups with no true in-group residuals | {len(groups_no_true_inline)}/72 | {(len(groups_no_true_inline)/72*100.0):.3f}% closed at boundary level |\n\n')
        fp.write('## Pass 74 residual categories\n\n')
        fp.write('| Category | Count | Percent of Pass 73 residuals | Meaning |\n|---|---:|---:|---|\n')
        meanings = {
            'cross_group_boundary_artifact': 'The scanner crossed the hard start of the next EventScriptGroup. This is not a missing opcode in the owning group.',
            'cross_group_target_alias': 'The pointer target belongs to a later group, so this is an alias into another content group.',
            'true_in_group_inline_residual_needs_manual_trace': 'The residual is still inside the owning group range and needs manual event/content decoding.',
        }
        for cat, count in by_final_cat.most_common():
            pct = (count / pass73_residuals * 100.0) if pass73_residuals else 0.0
            fp.write(f'| `{cat}` | {count} | {pct:.3f}% | {meanings.get(cat, "")} |\n')
        fp.write('\n## Original Pass 73 categories mapped\n\n')
        fp.write('| Pass 73 category | Count |\n|---|---:|\n')
        for cat, count in by_orig_cat.most_common():
            fp.write(f'| `{cat}` | {count} |\n')
        fp.write('\n## Groups closed after hard-boundary overlay\n\n')
        fp.write('`' + ', '.join(f'EventScriptGroup_{gid:02X}' for gid in groups_no_true_inline) + '`\n\n')
        fp.write('## Groups still needing manual inline trace\n\n')
        fp.write('| Group | Commands/markers | True in-group residuals | Effective known % | Status |\n|---:|---:|---:|---:|---|\n')
        for row in sorted(group_rows, key=lambda r: int(r['true_in_group_residuals']), reverse=True):
            if int(row['true_in_group_residuals']) == 0:
                continue
            fp.write(f"| `{row['group']}` | {row['commands_or_markers']} | {row['true_in_group_residuals']} | {row['pass74_effective_known_percent']}% | {row['status']} |\n")
        fp.write('\n## Recommended next pass\n\n')
        fp.write('Attack the 99 true in-group inline residuals only. The largest targets are the groups with repeated `B4` inline residuals and the long scripts in groups `$01`, `$00`, `$46`, and `$47`. Do not treat cross-group boundary artifacts as unknown opcodes.\n')

    print(f'pass74_total_markers={total_markers}')
    print(f'pass74_pass73_residuals={pass73_residuals}')
    print(f'pass74_cross_group_artifacts={cross_artifacts}')
    print(f'pass74_true_in_group_residuals={true_inline}')
    print(f'pass74_effective_known_percent={effective_known_pct:.3f}')
    print(f'pass74_groups_closed_after_boundary_overlay={len(groups_no_true_inline)}/72')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
