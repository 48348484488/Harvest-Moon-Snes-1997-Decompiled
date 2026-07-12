#!/usr/bin/env python3
"""Pass 81: expand EventScript semantic aliases to every B3-B5 entry.

This tool is intentionally metadata-only.  It reads the symbolic EventScript
entry export, the Pass79 direct-dialog aliases, and the Pass80 group-level
semantic names, then emits a complete per-entry alias table.

The generated aliases are not claimed to be perfect human scene names.  They
are a stable semantic index: direct-dialog entries keep their text-driven alias;
entries without direct text anchors get a structural alias based on the Pass80
group name, first decoded command, command classes, and pseudocode preview.
"""
from __future__ import annotations

import csv
import re
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPORTS = ROOT / "reports"

FULL_ENTRIES = REPORTS / "event_script_full_symbolic_entries_pass73.csv"
PASS79_ALIASES = REPORTS / "pass79_eventscript_entry_semantic_aliases.csv"
PASS80_GROUPS = REPORTS / "pass80_eventscript_all_group_semantic_names.csv"

OUT_ENTRY_CSV = REPORTS / "pass81_eventscript_all_entry_semantic_aliases.csv"
OUT_GROUP_CSV = REPORTS / "pass81_eventscript_entry_alias_group_summary.csv"
OUT_MD = REPORTS / "pass81_eventscript_all_entry_semantic_aliasing.md"
OUT_REMAINING = REPORTS / "pass81_remaining_human_semantic_targets.md"


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open("r", newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def slug(s: str) -> str:
    # Preserve CamelCase from existing semantic names, but strip unsafe chars.
    s = re.sub(r"[^A-Za-z0-9]+", " ", s or "")
    parts = [p for p in s.split() if p]
    if not parts:
        return "Unclassified"
    return "".join(p[:1].upper() + p[1:] for p in parts)


def parse_counter(text: str) -> Counter[str]:
    c = Counter()
    if not text:
        return c
    for part in text.split():
        if ":" not in part:
            continue
        k, v = part.rsplit(":", 1)
        try:
            c[k] += int(v)
        except ValueError:
            pass
    return c


CLASS_PRIORITY = [
    "dialog_text",
    "animals",
    "item_money_shipping",
    "tool_interaction",
    "screen_transition",
    "conditional",
    "flags_values",
    "cc_state_object",
    "player_interaction_control",
    "script_control",
    "audio",
    "special_unknown",
    "unknown",
]

CLASS_SUFFIX = {
    "dialog_text": "Dialog",
    "animals": "AnimalContext",
    "item_money_shipping": "ItemMoneyShipping",
    "tool_interaction": "ToolUse",
    "screen_transition": "Transition",
    "conditional": "StateGate",
    "flags_values": "FlagState",
    "cc_state_object": "ObjectVisual",
    "player_interaction_control": "PlayerInteraction",
    "script_control": "ScriptFlow",
    "audio": "AudioCue",
    "special_unknown": "SpecialInlineData",
    "unknown": "StructuralPayload",
}

FIRST_NAME_SUFFIX = [
    ("StartTextBox", "DialogStart"),
    ("PlayAudioOrMusic", "AudioCue"),
    ("SetTransitionDestination", "MapTransition"),
    ("ChangeMoney", "MoneyChange"),
    ("SetAnimation", "AnimationSetup"),
    ("SetCCObjectVisual", "ObjectVisualSetup"),
    ("SetCCObjectParam", "ObjectParamSetup"),
    ("ChickenRelated", "ChickenContext"),
    ("CowRelated", "CowContext"),
    ("Dog", "DogContext"),
    ("PickupMole", "MolePickup"),
    ("Tool", "ToolInteraction"),
    ("JumpIf", "ConditionalJump"),
    ("Jump", "ScriptJump"),
]

PREVIEW_SUFFIX = [
    ("ChickenRelated", "ChickenContext"),
    ("CowRelated", "CowContext"),
    ("Dog", "DogContext"),
    ("StartTextBox", "Dialog"),
    ("ChangeMoney", "Money"),
    ("SetTransitionDestination", "Transition"),
    ("PlayAudioOrMusic", "Audio"),
    ("SetAnimation", "Animation"),
    ("SetCCObjectVisual", "ObjectVisual"),
]


def infer_suffix(row: dict[str, str]) -> tuple[str, str]:
    first = row.get("first_name", "")
    preview = row.get("pseudocode_preview", "")
    for needle, suffix in FIRST_NAME_SUFFIX:
        if needle in first:
            return suffix, "first_cmd"
    for needle, suffix in PREVIEW_SUFFIX:
        if needle in preview:
            return suffix, "preview_pattern"
    classes = parse_counter(row.get("classes", ""))
    for cls in CLASS_PRIORITY:
        if classes.get(cls, 0) > 0:
            return CLASS_SUFFIX[cls], "class_priority"
    return "StructuralEntry", "fallback"


def alias_for(row: dict[str, str], group_info: dict[str, str], direct_alias: dict[str, str] | None) -> dict[str, str]:
    group = row["group"]
    entry = int(row["entry"])
    if direct_alias:
        alias = direct_alias["pass79_proposed_alias"]
        tier = "direct_text_anchor"
        confidence = direct_alias.get("confidence", "high_text_named")
        reason = "Preserved Pass79 direct-dialog alias built from resolved Text IDs."
        suffix_source = "pass79"
    else:
        group_name = group_info.get("pass80_semantic_group_name", f"EventScriptGroup_{group[1:]}")
        suffix, suffix_source = infer_suffix(row)
        alias = f"EventScript_G{group[1:]}_Entry{entry:03d}_{slug(group_name)}_{suffix}"
        cat = group_info.get("pass80_category", "unknown")
        conf = group_info.get("pass80_confidence", "medium")
        if conf == "high" and cat in {"dialog_anchor", "audio_sequence", "item_money_shipping", "tile_object_payload"}:
            tier = "group_semantic_structural"
            confidence = "medium_high_structural"
        elif cat.startswith("table") or "table" in cat:
            tier = "table_structural_alias"
            confidence = "medium_structural"
        else:
            tier = "group_semantic_structural"
            confidence = "medium_structural"
        reason = f"Derived from Pass80 group semantic name plus {suffix_source}."
    return {
        "group": group,
        "entry": row["entry"],
        "target": row["target"],
        "pass81_entry_alias": alias,
        "alias_tier": tier,
        "confidence": confidence,
        "group_semantic_name": group_info.get("pass80_semantic_group_name", ""),
        "group_category": group_info.get("pass80_category", ""),
        "first_opcode": row.get("first_opcode", ""),
        "first_name": row.get("first_name", ""),
        "classes": row.get("classes", ""),
        "commands": row.get("commands", ""),
        "stop_reason": row.get("stop_reason", ""),
        "reason": reason,
        "pseudocode_preview": row.get("pseudocode_preview", ""),
    }


def main() -> int:
    entries = read_csv(FULL_ENTRIES)
    p79_rows = read_csv(PASS79_ALIASES)
    p80_rows = read_csv(PASS80_GROUPS)

    p79_by_key = {(r["group"], str(int(r["entry"]))): r for r in p79_rows}
    group_by_id = {r["group"]: r for r in p80_rows}

    out_rows: list[dict[str, str]] = []
    for row in entries:
        key = (row["group"], str(int(row["entry"])))
        out_rows.append(alias_for(row, group_by_id.get(row["group"], {}), p79_by_key.get(key)))

    fields = [
        "group", "entry", "target", "pass81_entry_alias", "alias_tier", "confidence",
        "group_semantic_name", "group_category", "first_opcode", "first_name",
        "classes", "commands", "stop_reason", "reason", "pseudocode_preview",
    ]
    with OUT_ENTRY_CSV.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        w.writerows(out_rows)

    group_summary: list[dict[str, str]] = []
    rows_by_group: dict[str, list[dict[str, str]]] = defaultdict(list)
    for r in out_rows:
        rows_by_group[r["group"]].append(r)
    for group in sorted(rows_by_group):
        rows = rows_by_group[group]
        tiers = Counter(r["alias_tier"] for r in rows)
        confs = Counter(r["confidence"] for r in rows)
        group_info = group_by_id.get(group, {})
        group_summary.append({
            "group": group,
            "group_semantic_name": group_info.get("pass80_semantic_group_name", ""),
            "group_category": group_info.get("pass80_category", ""),
            "entries": str(len(rows)),
            "entry_aliases": str(len(rows)),
            "alias_coverage_percent": "100.000",
            "direct_text_anchor": str(tiers.get("direct_text_anchor", 0)),
            "group_semantic_structural": str(tiers.get("group_semantic_structural", 0)),
            "table_structural_alias": str(tiers.get("table_structural_alias", 0)),
            "top_confidence": " ".join(f"{k}:{v}" for k, v in confs.most_common(5)),
            "sample_aliases": " | ".join(r["pass81_entry_alias"] for r in rows[:3]),
        })
    gfields = list(group_summary[0].keys())
    with OUT_GROUP_CSV.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=gfields)
        w.writeheader()
        w.writerows(group_summary)

    total = len(out_rows)
    direct = sum(1 for r in out_rows if r["alias_tier"] == "direct_text_anchor")
    structural = total - direct
    tier_counts = Counter(r["alias_tier"] for r in out_rows)
    cat_counts = Counter(r["group_category"] for r in out_rows)

    md = []
    md.append("# Pass 81 - EventScript All Entry Semantic Aliasing\n")
    md.append("\nMetadata-only pass. No ROM bytes or ASM instruction bytes are changed.\n")
    md.append("\n## Objective\n")
    md.append("\nExpand EventScript semantic naming from group-level coverage to every decoded B3-B5 entry.\n")
    md.append("\n## Coverage\n")
    md.append("\n| Metric | Value |\n|---|---:|\n")
    md.append(f"| EventScript entries decoded | {total} |\n")
    md.append(f"| Pass81 entry aliases generated | {total} |\n")
    md.append("| Entry alias coverage | 100.000% |\n")
    md.append(f"| Direct text-driven aliases preserved from Pass79 | {direct} |\n")
    md.append(f"| Structural/group-derived aliases generated | {structural} |\n")
    md.append("| EventCmd official dispatch coverage | 90/90 |\n")
    md.append("| Effective EventScript residual coverage | 100.000% |\n")
    md.append("\n## Alias tiers\n")
    md.append("\n| Tier | Count |\n|---|---:|\n")
    for tier, count in tier_counts.most_common():
        md.append(f"| `{tier}` | {count} |\n")
    md.append("\n## Entry volume by group category\n")
    md.append("\n| Category | Entries |\n|---|---:|\n")
    for cat, count in cat_counts.most_common():
        md.append(f"| `{cat}` | {count} |\n")
    md.append("\n## Notes\n")
    md.append("\n- `direct_text_anchor` aliases are the strongest names because they are tied to resolved textbox Text IDs.\n")
    md.append("- `group_semantic_structural` aliases are useful stable labels, but some are still structural rather than exact scene names.\n")
    md.append("- `table_structural_alias` entries usually represent compact table-driven event data clusters, not standalone human-readable cutscenes.\n")
    md.append("- This pass closes per-entry alias coverage, but not every entry has a perfect human scene title yet.\n")
    OUT_MD.write_text("".join(md), encoding="utf-8")

    remaining = []
    remaining.append("# Pass 81 Remaining Human Semantic Targets\n\n")
    remaining.append("After Pass81, every decoded EventScript entry has a stable alias. The remaining work is quality refinement, not coverage.\n\n")
    remaining.append("| Target | Remaining issue |\n|---|---|\n")
    remaining.append("| Direct scene names | Structural aliases still need manual confirmation for exact festival/cutscene names. |\n")
    remaining.append("| NPC/person ownership | Many entries are grouped by dialogue/logic, but not always tied to a single named NPC routine. |\n")
    remaining.append("| Sprite/GOBJ ownership | Visual object entries need cross-reference against sprite/GOBJ tables. |\n")
    remaining.append("| Table-driven clusters | Need comments explaining the inline table format for compact event data groups. |\n")
    remaining.append("| Menus/farm/livestock details | Need fine documentation and naming of non-dialogue gameplay flows. |\n")
    OUT_REMAINING.write_text("".join(remaining), encoding="utf-8")

    print(f"entries={total}")
    print(f"aliases={len(out_rows)}")
    print("alias_coverage=100.000")
    print(f"direct_text_anchor={direct}")
    print(f"structural_aliases={structural}")
    print(f"groups={len(group_summary)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
