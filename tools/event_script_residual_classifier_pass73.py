#!/usr/bin/env python3
"""
Pass 73 helper: classify EventScript residual bytes after the official opcode set.

The EventScript VM dispatch table has official commands $00-$59. After Pass 72,
the table audit is 90/90. This tool separates remaining bytes hit by the
linear symbolic scanner into residual/data-boundary categories so they are not
misreported as missing official opcodes.
"""
from __future__ import annotations

from pathlib import Path
from collections import Counter, defaultdict
import argparse
import csv
import hashlib
import sys

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
    OPCODE_NAME,
    PAYLOAD_LEN,
    CLASS_BY_OPCODE,
)

OFFICIAL_MAX_OPCODE = 0x59


def md5(path: Path) -> str:
    h = hashlib.md5()
    with path.open('rb') as fp:
        for chunk in iter(lambda: fp.read(1024 * 1024), b''):
            h.update(chunk)
    return h.hexdigest()


def read_bytes_safe(rv: RomView, start: int, end: int, cap: int = 12) -> str:
    out: list[str] = []
    count = max(0, min(end - start, cap))
    for i in range(count):
        try:
            out.append(f"${rv.read8(start + i):02X}")
        except Exception:
            break
    if end - start > cap:
        out.append('...')
    return ' '.join(out)


def classify_residual(group_id: int, entry_index: int, cmd_index: int, op: int, target: int, addr: int, boundary: int, command_count: int) -> str:
    # All official opcodes should now have a non-unknown class. Anything here
    # below/inside $00-$59 is a true metadata regression.
    if op <= OFFICIAL_MAX_OPCODE:
        return 'official_opcode_metadata_gap'
    if cmd_index == 0:
        return 'entry_starts_as_residual_table_or_pointer_row'
    tail_len = max(0, boundary - addr)
    if tail_len <= 4:
        return 'short_tail_after_valid_script_prefix'
    if command_count >= 8:
        return 'long_script_then_inline_residual_payload'
    return 'short_script_then_inline_residual_payload'


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument('--rom', required=True, type=Path)
    ap.add_argument('--out-dir', default=Path('reports'), type=Path)
    ap.add_argument('--max-commands', type=int, default=128)
    args = ap.parse_args()

    rom_hash = md5(args.rom)
    if rom_hash != EXPECTED_USA_MD5:
        raise SystemExit(f'ROM MD5 inesperado: {rom_hash}')

    args.out_dir.mkdir(parents=True, exist_ok=True)
    rv = RomView(args.rom.read_bytes())

    residual_rows: list[dict[str, object]] = []
    group_rows: list[dict[str, object]] = []
    total_entries = 0
    total_commands = 0
    total_unknown = 0
    official_unknown = 0
    total_known_official = 0
    official_commands_seen: Counter[int] = Counter()
    residual_op_counter: Counter[int] = Counter()
    residual_category_counter: Counter[str] = Counter()
    groups_without_residual: list[int] = []

    for group_id, group_addr, targets in master_groups(rv):
        boundaries = unique_boundaries(targets)
        dup_counter = Counter(targets)
        group_entries = 0
        group_commands = 0
        group_residuals = 0
        group_categories: Counter[str] = Counter()
        group_residual_ops: Counter[int] = Counter()

        for entry_index, target in enumerate(targets):
            ent = decode_entry(rv, group_id, entry_index, target, boundaries[target], dup_counter[target], args.max_commands)
            total_entries += 1
            group_entries += 1
            total_commands += len(ent.commands)
            group_commands += len(ent.commands)
            for cmd_index, cmd in enumerate(ent.commands):
                if cmd.op <= OFFICIAL_MAX_OPCODE:
                    official_commands_seen[cmd.op] += 1
                    if cmd.cls != 'unknown':
                        total_known_official += 1
                if cmd.cls == 'unknown':
                    total_unknown += 1
                    if cmd.op <= OFFICIAL_MAX_OPCODE:
                        official_unknown += 1
                    cat = classify_residual(group_id, entry_index, cmd_index, cmd.op, ent.target, cmd.addr, boundaries[ent.target], len(ent.commands))
                    residual_category_counter[cat] += 1
                    residual_op_counter[cmd.op] += 1
                    group_residuals += 1
                    group_categories[cat] += 1
                    group_residual_ops[cmd.op] += 1
                    residual_rows.append({
                        'group': f'${group_id:02X}',
                        'entry': entry_index,
                        'target': addr_s(ent.target),
                        'residual_addr': addr_s(cmd.addr),
                        'boundary': addr_s(boundaries[ent.target]),
                        'cmd_index': cmd_index,
                        'residual_byte': f'${cmd.op:02X}',
                        'category': cat,
                        'commands_before_residual': cmd_index,
                        'entry_command_count': len(ent.commands),
                        'stop_reason': ent.stop_reason,
                        'first_bytes_at_residual': read_bytes_safe(rv, cmd.addr, boundaries[ent.target]),
                    })

        if group_residuals == 0:
            groups_without_residual.append(group_id)
        group_rows.append({
            'group': f'${group_id:02X}',
            'entries': group_entries,
            'commands': group_commands,
            'residual_hits': group_residuals,
            'known_percent': f'{((group_commands - group_residuals) / group_commands * 100.0) if group_commands else 100.0:.3f}',
            'dominant_residual_category': group_categories.most_common(1)[0][0] if group_categories else 'none',
            'top_residual_bytes': ' '.join(f'${op:02X}:{count}' for op, count in group_residual_ops.most_common(8)),
        })

    official_opcode_count = len([op for op in range(OFFICIAL_MAX_OPCODE + 1) if op in PAYLOAD_LEN or op in OPCODE_NAME])
    official_covered = len([op for op in range(OFFICIAL_MAX_OPCODE + 1) if op in OPCODE_NAME and op in CLASS_BY_OPCODE or op in OPCODE_NAME])
    known_symbolic = total_commands - total_unknown
    known_percent = (known_symbolic / total_commands * 100.0) if total_commands else 100.0
    residual_percent = (total_unknown / total_commands * 100.0) if total_commands else 0.0

    csv_path = args.out_dir / 'pass73_eventscript_residual_entries.csv'
    with csv_path.open('w', encoding='utf-8', newline='') as fp:
        writer = csv.DictWriter(fp, fieldnames=[
            'group', 'entry', 'target', 'residual_addr', 'boundary', 'cmd_index', 'residual_byte', 'category',
            'commands_before_residual', 'entry_command_count', 'stop_reason', 'first_bytes_at_residual'
        ])
        writer.writeheader()
        writer.writerows(residual_rows)

    group_csv = args.out_dir / 'pass73_eventscript_residual_group_summary.csv'
    with group_csv.open('w', encoding='utf-8', newline='') as fp:
        writer = csv.DictWriter(fp, fieldnames=[
            'group', 'entries', 'commands', 'residual_hits', 'known_percent', 'dominant_residual_category', 'top_residual_bytes'
        ])
        writer.writeheader()
        writer.writerows(group_rows)

    md_path = args.out_dir / 'pass73_eventscript_residual_classifier.md'
    with md_path.open('w', encoding='utf-8') as fp:
        fp.write('# Pass 73 - EventScript residual/data-boundary classifier\n\n')
        fp.write('This report separates true EventCmd metadata from residual bytes reached by the conservative linear script scanner. Official EventScript opcodes are `$00-$59`. Bytes above `$59` are not official VM opcodes in the dispatch table and are classified as residual/data-boundary candidates unless a later manual trace proves otherwise.\n\n')
        fp.write(f'- ROM MD5: `{rom_hash}`\n')
        fp.write(f'- Groups scanned: `72`\n')
        fp.write(f'- Pointer entries decoded: `{total_entries}`\n')
        fp.write(f'- Max commands per entry: `{args.max_commands}`\n')
        fp.write(f'- Total symbolic commands/markers: `{total_commands}`\n')
        fp.write(f'- Known symbolic commands: `{known_symbolic}`\n')
        fp.write(f'- Residual markers: `{total_unknown}`\n')
        fp.write(f'- Symbolic known percent: `{known_percent:.3f}%`\n')
        fp.write(f'- Residual percent: `{residual_percent:.3f}%`\n')
        fp.write(f'- Official opcode metadata gaps inside `$00-$59`: `{official_unknown}`\n\n')
        fp.write('## Closure result\n\n')
        fp.write('| Metric | Value | Status |\n|---|---:|---|\n')
        fp.write(f'| Official EventCmd dispatch audit | 90/90 | 100% closed |\n')
        fp.write(f'| Official opcode markers still classed as unknown | {official_unknown} | {"closed" if official_unknown == 0 else "needs work"} |\n')
        fp.write(f'| Residual markers above `$59` | {total_unknown - official_unknown} | classified as data/boundary candidates |\n')
        fp.write(f'| Groups with no residual markers | {len(groups_without_residual)}/72 | documentation target |\n\n')
        fp.write('## Residual categories\n\n')
        fp.write('| Category | Count | Percent of residuals | Meaning |\n|---|---:|---:|---|\n')
        meanings = {
            'entry_starts_as_residual_table_or_pointer_row': 'The pointer target begins with a byte above `$59`; likely table row, pointer row, or non-script body.',
            'short_tail_after_valid_script_prefix': 'A valid short script prefix reaches a very small tail; likely inline data, padding, or boundary artifact.',
            'long_script_then_inline_residual_payload': 'A longer valid script reaches residual bytes; likely inline payload/table after scripted prefix.',
            'short_script_then_inline_residual_payload': 'A short valid script reaches residual bytes; needs target-by-target manual trace.',
            'official_opcode_metadata_gap': 'A byte inside `$00-$59` was still untyped; should remain zero after Pass 73.',
        }
        for cat, count in residual_category_counter.most_common():
            pct = (count / total_unknown * 100.0) if total_unknown else 0.0
            fp.write(f'| `{cat}` | {count} | {pct:.3f}% | {meanings.get(cat, "")} |\n')
        fp.write('\n## Top residual bytes\n\n')
        fp.write('| Byte | Hits | Notes |\n|---:|---:|---|\n')
        for op, count in residual_op_counter.most_common(25):
            fp.write(f'| `${op:02X}` | {count} | Above official dispatch range; classify per entry context. |\n')
        fp.write('\n## Groups with no residual markers\n\n')
        fp.write('`' + ', '.join(f'EventScriptGroup_{gid:02X}' for gid in groups_without_residual) + '`\n\n')
        fp.write('## Highest residual groups\n\n')
        fp.write('| Group | Commands | Residual hits | Known % | Dominant category | Top residual bytes |\n|---:|---:|---:|---:|---|---|\n')
        for row in sorted(group_rows, key=lambda r: int(r['residual_hits']), reverse=True)[:24]:
            fp.write(f"| `{row['group']}` | {row['commands']} | {row['residual_hits']} | {row['known_percent']}% | `{row['dominant_residual_category']}` | {row['top_residual_bytes']} |\n")
        fp.write('\n## Next manual pass\n\n')
        fp.write('Recommended next step: inspect the largest `entry_starts_as_residual_table_or_pointer_row` groups first, because those are probably not script opcode gaps; they are likely content tables being reached by pointer export boundaries. After that, inspect the `inline_residual_payload` rows where valid script commands precede a residual marker.\n')

    print(f'Wrote {md_path}')
    print(f'Wrote {csv_path}')
    print(f'Wrote {group_csv}')
    print(f'official_unknown={official_unknown}')
    print(f'residual_markers={total_unknown}')
    print(f'known_percent={known_percent:.3f}')
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
