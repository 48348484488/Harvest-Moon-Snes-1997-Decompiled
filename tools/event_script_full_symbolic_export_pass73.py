#!/usr/bin/env python3
"""
Pass 73 helper: full symbolic EventScript export for B3-B5.

This expands the Pass 57 symbolic decoder from only priority groups into a
complete per-group handoff. The output stays conservative: it uses command
names, text ids, RAM/flag symbols and branch targets, but does not dump dialog
text and does not require changing source bytes.

Usage:
  python3 tools/event_script_full_symbolic_export.py --rom "roms/Harvest Moon (USA).sfc"
"""
from __future__ import annotations

from pathlib import Path
from collections import Counter, defaultdict
from dataclasses import dataclass
import argparse
import csv
import hashlib
import sys

# Allow running from project root without installing the tools package.
TOOL_DIR = Path(__file__).resolve().parent
if str(TOOL_DIR) not in sys.path:
    sys.path.insert(0, str(TOOL_DIR))

from event_script_symbolic_disasm import (  # type: ignore
    EXPECTED_USA_MD5,
    MASTER_GROUP_COUNT,
    RomView,
    addr_s,
    compact_cmds,
    decode_entry,
    master_groups,
    unique_boundaries,
)

# Known RAM names from previous passes. These are documentation hints only.
RAM_HINTS = {
    "$7F1F00": "shed_items_row_1",
    "$7F1F01": "shed_items_row_2",
    "$7F1F02": "shed_items_row_3",
    "$7F1F03": "shed_items_row_4_or_unknown_shed_bits",
    "$7F1F04": "money_low_word",
    "$7F1F06": "money_high_byte",
    "$7F1F07": "shipping_money_low_word",
    "$7F1F09": "shipping_money_high_byte",
    "$7F1F0A": "cow_count",
    "$7F1F0B": "chicken_count",
    "$7F1F0C": "stored_wood",
    "$7F1F10": "stored_grass",
    "$7F1F18": "year",
    "$7F1F19": "season",
    "$7F1F1A": "weekday",
    "$7F1F1B": "day",
    "$7F1F1C": "hour",
    "$7F1F1D": "minutes",
    "$7F1F1E": "seconds",
    "$7F1F1F": "hearts_maria",
    "$7F1F21": "hearts_ann",
    "$7F1F23": "hearts_nina",
    "$7F1F25": "hearts_ellen",
    "$7F1F27": "hearts_eve",
    "$7F1F29": "planted_grass",
    "$7F1F2C": "dog_pos_x",
    "$7F1F2E": "dog_pos_y",
    "$7F1F30": "dog_map",
    "$7F1F33": "happiness",
    "$7F1F35": "development_rate_or_house_upgrade_days",
    "$7F1F36": "power_berry_count",
    "$7F1F37": "kid1_age",
    "$7F1F39": "kid2_age",
    "$7F1F3B": "wife_pregnancy",
    "$7F1F52": "dog_hugs",
    "$7F1F54": "ranch_mastery",
    "$7F1F56": "ranch_development",
    "$7F1F64": "player_house_and_event_flags",
    "$7F1F66": "marriage_flags",
    "$7F1F6C": "family_event_flags",
    "$7F1F6E": "child_flags",
    "$800196": "current_graphic_preset_mirror_or_scene_state",
    "$80091E": "old_item_on_hand_or_event_item_mirror",
    "$800921": "tool_selected_or_event_tool_mirror",
    "$800923": "tool_backpack_or_event_tool_mirror",
    "$800926": "watering_can_water_or_event_item_counter",
    "$80098C": "weather_tomorrow_mirror_or_festival_weather",
}


@dataclass
class GroupProfile:
    gid: int
    label: str
    bank: str
    group_addr: int
    entries: int
    unique_targets: int
    commands: int
    unknown: int
    dominant_classes: str
    dominant_opcodes: str
    semantic_bucket: str
    confidence: str
    top_symbols: str
    top_text_ids: str
    first_ops: str
    recommended_next_action: str


def md5(path: Path) -> str:
    h = hashlib.md5()
    with path.open("rb") as fp:
        for chunk in iter(lambda: fp.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def parse_counter_field(raw: str) -> Counter[str]:
    out: Counter[str] = Counter()
    if not raw:
        return out
    for part in raw.split():
        if ":" not in part:
            continue
        key, value = part.rsplit(":", 1)
        try:
            out[key] += int(value)
        except ValueError:
            continue
    return out


def load_dependency_rows(path: Path):
    by_group_symbol: dict[int, Counter[str]] = defaultdict(Counter)
    by_group_text: dict[int, Counter[str]] = defaultdict(Counter)
    if not path.exists():
        return by_group_symbol, by_group_text
    with path.open("r", encoding="utf-8", newline="") as fp:
        reader = csv.DictReader(fp)
        for row in reader:
            group_raw = row.get("group", "")
            try:
                gid = int(group_raw.replace("$", ""), 16)
            except ValueError:
                continue
            relation = row.get("relation", "")
            symbol = row.get("symbol", "")
            if relation == "dialog_text_id":
                by_group_text[gid][symbol] += 1
            elif symbol:
                hint = RAM_HINTS.get(symbol, symbol)
                by_group_symbol[gid][hint] += 1
    return by_group_symbol, by_group_text


def classify(classes: Counter[str], opcodes: Counter[str], symbol_counter: Counter[str], text_count: int, unknown: int, commands: int) -> tuple[str, str, str]:
    if commands <= 0:
        return "empty_or_pointer_stub", "low", "Inspect pointer table boundaries."
    audio_ratio = classes["audio"] / commands
    dialog_ratio = classes["dialog_text"] / commands
    cond_ratio = classes["conditional"] / commands
    cc_ratio = classes["cc_state_object"] / commands
    item_ratio = classes["items_money"] / commands
    animal_ratio = classes["animals"] / commands
    map_ratio = classes["map_tile_edit"] / commands
    screen_ratio = classes["screen_transition"] / commands
    unknown_ratio = unknown / commands

    symbols = set(symbol_counter)
    if audio_ratio >= 0.65:
        return "audio_sfx_or_tablelike_event_stub", "medium", "Cross-reference opcode $00 ids with the audio/SFX map and split true script bodies from lookup filler."
    if dialog_ratio >= 0.12 and cond_ratio >= 0.10:
        if {"marriage_flags", "family_event_flags", "child_flags", "wife_pregnancy"} & symbols:
            return "family_romance_dialogue_matrix", "high", "Name entries by spouse/child/family milestone after cross-checking text ids."
        if any(s.startswith("hearts_") for s in symbols):
            return "romance_affection_dialogue_matrix", "high", "Name entries by girl/NPC and affection threshold after checking text ids."
        if {"season", "day", "hour", "weekday"} & symbols:
            return "calendar_weather_dialogue_matrix", "high", "Name entries by season/day/time gate and link to festival/weather docs."
        return "conditional_npc_dialogue_matrix", "medium", "Resolve text ids into labels and assign NPC/scene names conservatively."
    if cc_ratio >= 0.35 and animal_ratio > 0:
        return "animal_or_object_visual_setup", "high", "Map visual pointers to sprite/GOBJ docs and name animal/object slots."
    if cc_ratio >= 0.30 and screen_ratio > 0:
        return "cutscene_object_transition_setup", "medium", "Trace transition destination and object positions to map/cutscene names."
    if item_ratio >= 0.20:
        return "item_money_shipping_interaction", "high", "Cross-reference item ids/money deltas with item/shop/shipping docs."
    if map_ratio > 0:
        return "map_tile_patch_event", "high", "Name tile edits by map/coordinates and link to map patch system."
    if unknown_ratio >= 0.60:
        return "unknown_opcode_cluster_needs_manual_decode", "low", "Decode dominant unknown opcodes first before semantic renaming."
    if cond_ratio >= 0.25:
        return "state_gate_or_flag_router", "medium", "Name the RAM/flag condition and branch destinations before changing labels."
    return "mixed_event_script", "medium", "Use text ids, RAM symbols and first opcodes to split into smaller semantic labels."


def write_group_file(out_path: Path, gid: int, group_addr: int, entries, max_commands_written: int) -> None:
    seen_targets: set[int] = set()
    with out_path.open("w", encoding="utf-8") as fp:
        fp.write(f"# EventScriptGroup_{gid:02X} symbolic export\n\n")
        fp.write(f"- Group id: `${gid:02X}`\n")
        fp.write(f"- Group table address: `{addr_s(group_addr)}`\n")
        fp.write(f"- Pointer entries: `{len(entries)}`\n")
        fp.write(f"- Unique targets: `{len(set(e.target for e in entries))}`\n\n")
        fp.write("This file is generated for decompilation handoff. It keeps dialog as text ids only.\n\n")
        for ent in entries:
            duplicate_note = ""
            if ent.target in seen_targets:
                duplicate_note = " duplicate_target"
            seen_targets.add(ent.target)
            fp.write(f"## Entry {ent.pointer_index:02d} -> `{addr_s(ent.target)}`{duplicate_note}\n\n")
            fp.write(f"- Commands decoded: `{len(ent.commands)}`\n")
            fp.write(f"- Stop reason: `{ent.stop_reason}`\n")
            fp.write(f"- Pointer duplicate count: `{ent.duplicate_count}`\n\n")
            fp.write("```text\n")
            for idx, cmd in enumerate(ent.commands[:max_commands_written]):
                fp.write(f"{idx:02d} {addr_s(cmd.addr)} {cmd.text}\n")
            if len(ent.commands) > max_commands_written:
                fp.write(f"... truncated after {max_commands_written} commands; use CSV/index for full count.\n")
            fp.write("```\n\n")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--rom", required=True, type=Path)
    ap.add_argument("--out-dir", default=Path("reports"), type=Path)
    ap.add_argument("--max-commands", type=int, default=128)
    ap.add_argument("--max-commands-written", type=int, default=80)
    args = ap.parse_args()

    rom_hash = md5(args.rom)
    if rom_hash != EXPECTED_USA_MD5:
        raise SystemExit(f"ROM MD5 inesperado: {rom_hash}")

    args.out_dir.mkdir(parents=True, exist_ok=True)
    group_dir = args.out_dir / "event_script_groups_pass73"
    group_dir.mkdir(parents=True, exist_ok=True)

    dep_symbols, dep_text = load_dependency_rows(args.out_dir / "event_script_ram_dependency_pass57.csv")

    rv = RomView(args.rom.read_bytes())
    groups = master_groups(rv)
    all_entries = []
    by_group = {}
    profiles: list[GroupProfile] = []

    for gid, group_addr, targets in groups:
        boundaries = unique_boundaries(targets)
        dup_counter = Counter(targets)
        entries = []
        for idx, target in enumerate(targets):
            ent = decode_entry(rv, gid, idx, target, boundaries[target], dup_counter[target], args.max_commands)
            entries.append(ent)
            all_entries.append(ent)
        by_group[gid] = entries

        classes = Counter(cmd.cls for ent in entries for cmd in ent.commands)
        opcodes = Counter(f"${cmd.op:02X}" for ent in entries for cmd in ent.commands)
        first_ops = Counter(ent.commands[0].name for ent in entries if ent.commands)
        commands = sum(len(e.commands) for e in entries)
        unknown = sum(1 for e in entries for c in e.commands if c.cls == "unknown")
        symbols = dep_symbols.get(gid, Counter())
        text_ids = dep_text.get(gid, Counter())
        bucket, confidence, action = classify(classes, opcodes, symbols, sum(text_ids.values()), unknown, commands)
        profiles.append(GroupProfile(
            gid=gid,
            label=f"EventScriptGroup_{gid:02X}",
            bank=f"${(group_addr >> 16) & 0xFF:02X}",
            group_addr=group_addr,
            entries=len(targets),
            unique_targets=len(set(targets)),
            commands=commands,
            unknown=unknown,
            dominant_classes=" ".join(f"{k}:{v}" for k, v in classes.most_common(6)),
            dominant_opcodes=" ".join(f"{k}:{v}" for k, v in opcodes.most_common(8)),
            semantic_bucket=bucket,
            confidence=confidence,
            top_symbols=" ".join(f"{k}:{v}" for k, v in symbols.most_common(5)),
            top_text_ids=" ".join(f"{k}:{v}" for k, v in text_ids.most_common(5)),
            first_ops=" ".join(f"{k}:{v}" for k, v in first_ops.most_common(5)),
            recommended_next_action=action,
        ))
        write_group_file(group_dir / f"EventScriptGroup_{gid:02X}.md", gid, group_addr, entries, args.max_commands_written)

    profile_csv = args.out_dir / "event_script_group_semantic_map_pass73.csv"
    with profile_csv.open("w", encoding="utf-8", newline="") as fp:
        writer = csv.DictWriter(fp, fieldnames=[
            "group", "label", "bank", "group_addr", "entries", "unique_targets", "commands", "unknown", "semantic_bucket", "confidence",
            "dominant_classes", "dominant_opcodes", "top_symbols", "top_text_ids", "first_ops", "recommended_next_action",
        ])
        writer.writeheader()
        for p in profiles:
            writer.writerow({
                "group": f"${p.gid:02X}",
                "label": p.label,
                "bank": p.bank,
                "group_addr": addr_s(p.group_addr),
                "entries": p.entries,
                "unique_targets": p.unique_targets,
                "commands": p.commands,
                "unknown": p.unknown,
                "semantic_bucket": p.semantic_bucket,
                "confidence": p.confidence,
                "dominant_classes": p.dominant_classes,
                "dominant_opcodes": p.dominant_opcodes,
                "top_symbols": p.top_symbols,
                "top_text_ids": p.top_text_ids,
                "first_ops": p.first_ops,
                "recommended_next_action": p.recommended_next_action,
            })

    entries_csv = args.out_dir / "event_script_full_symbolic_entries_pass73.csv"
    with entries_csv.open("w", encoding="utf-8", newline="") as fp:
        writer = csv.DictWriter(fp, fieldnames=[
            "group", "label", "entry", "target", "duplicate_count", "commands", "unknown_commands", "stop_reason", "first_opcode", "first_name", "classes", "pseudocode_preview",
        ])
        writer.writeheader()
        for ent in all_entries:
            classes = Counter(cmd.cls for cmd in ent.commands)
            writer.writerow({
                "group": f"${ent.group_id:02X}",
                "label": f"EventScriptGroup_{ent.group_id:02X}",
                "entry": ent.pointer_index,
                "target": addr_s(ent.target),
                "duplicate_count": ent.duplicate_count,
                "commands": len(ent.commands),
                "unknown_commands": sum(1 for c in ent.commands if c.cls == "unknown"),
                "stop_reason": ent.stop_reason,
                "first_opcode": f"${ent.commands[0].op:02X}" if ent.commands else "",
                "first_name": ent.commands[0].name if ent.commands else "",
                "classes": " ".join(f"{k}:{v}" for k, v in classes.most_common(6)),
                "pseudocode_preview": compact_cmds(ent, 10),
            })

    md_path = args.out_dir / "event_script_full_symbolic_export_pass73.md"
    sorted_by_priority = sorted(profiles, key=lambda p: (p.confidence != "high", -p.commands, p.unknown, p.gid))
    bucket_counts = Counter(p.semantic_bucket for p in profiles)
    with md_path.open("w", encoding="utf-8") as fp:
        fp.write("# Pass 73 - Full EventScript symbolic export B3-B5\n\n")
        fp.write("Conservative full export generated from the clean USA ROM. Dialog text is not exported; only text ids are retained.\n\n")
        fp.write(f"- ROM MD5: `{rom_hash}`\n")
        fp.write(f"- Groups exported: `{MASTER_GROUP_COUNT}`\n")
        fp.write(f"- Pointer entries decoded: `{len(all_entries)}`\n")
        fp.write(f"- Per-group files: `reports/event_script_groups_pass73/EventScriptGroup_XX.md`\n\n")
        fp.write("## Semantic buckets\n\n")
        fp.write("| Bucket | Groups |\n|---|---:|\n")
        for bucket, count in bucket_counts.most_common():
            fp.write(f"| `{bucket}` | {count} |\n")
        fp.write("\n## High-value groups for manual rename pass\n\n")
        fp.write("| Rank | Group | Label | Bucket | Confidence | Cmds | Unknown | Top symbols/text | Next action |\n")
        fp.write("|---:|---:|---|---|---|---:|---:|---|---|\n")
        for rank, p in enumerate(sorted_by_priority[:24], start=1):
            top = p.top_symbols or p.top_text_ids or p.first_ops
            fp.write(f"| {rank} | `${p.gid:02X}` | `{p.label}` | `{p.semantic_bucket}` | {p.confidence} | {p.commands} | {p.unknown} | {top} | {p.recommended_next_action} |\n")
        fp.write("\n## Complete group map\n\n")
        fp.write("| Group | Bank | Entries | Unique targets | Cmds | Unknown | Bucket | Dominant classes | File |\n")
        fp.write("|---:|---:|---:|---:|---:|---:|---|---|---|\n")
        for p in profiles:
            file_name = f"event_script_groups_pass73/EventScriptGroup_{p.gid:02X}.md"
            fp.write(f"| `${p.gid:02X}` | `{p.bank}` | {p.entries} | {p.unique_targets} | {p.commands} | {p.unknown} | `{p.semantic_bucket}` | {p.dominant_classes} | `{file_name}` |\n")

    hints_path = args.out_dir / "event_script_memory_role_hints_pass73.md"
    global_symbol_counter = Counter()
    for counter in dep_symbols.values():
        global_symbol_counter.update(counter)
    with hints_path.open("w", encoding="utf-8") as fp:
        fp.write("# Pass 73 - EventScript RAM role hints\n\n")
        fp.write("These are documentation hints for future labels. They are derived from event script dependencies and prior RAM aliases; they do not change ROM bytes.\n\n")
        fp.write("| Symbol/hint | Uses | Notes |\n|---|---:|---|\n")
        for symbol, count in global_symbol_counter.most_common(40):
            fp.write(f"| `{symbol}` | {count} | Cross-check before replacing raw operands in source. |\n")

    print(f"Wrote {profile_csv}")
    print(f"Wrote {entries_csv}")
    print(f"Wrote {md_path}")
    print(f"Wrote {group_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
