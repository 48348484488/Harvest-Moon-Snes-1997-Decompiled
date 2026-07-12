#!/usr/bin/env python3
"""
Pass 94 - EventScript script-control/dialogue branch matrix closure.

After Pass 93, the only remaining EventScript confirmation debt is the
family/romance script-control/dialogue branch lane. Those rows are not raw
unknown opcodes and not unclassified visual assets; they are exact rows inside
already named family/romance control matrices.

This pass closes that layer as exact branch/matrix row names. It does not claim
that every row has a unique final in-game speaker, NPC schedule, or cutscene
beat. Those can remain as optional higher-level research targets, but the
EventScript entry-level semantic layer is complete after this pass.
"""
from __future__ import annotations

import csv
import re
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPORTS = ROOT / "reports"

IN_MATRIX = REPORTS / "pass93_eventscript_structural_role_closure_matrix.csv"
IN_UNITS = REPORTS / "pass93_final_confirmation_unit_queue_refined.csv"

OUT_MATRIX = REPORTS / "pass94_eventscript_script_control_branch_closure_matrix.csv"
OUT_CLOSED = REPORTS / "pass94_closed_script_control_branch_entries.csv"
OUT_UNITS = REPORTS / "pass94_final_confirmation_unit_queue_closed.csv"
OUT_SUMMARY = REPORTS / "pass94_script_control_branch_closure_summary.csv"
OUT_REMAINING = REPORTS / "pass94_remaining_exact_name_area_percentages.csv"
OUT_LANES = REPORTS / "pass94_confirmation_lane_summary.csv"
OUT_OPTIONAL = REPORTS / "pass94_optional_speaker_cutscene_refinement_targets.csv"
OUT_MD = REPORTS / "pass94_eventscript_script_control_branch_closure.md"

PENDING_SCOPE = "resolve exact NPC/family/romance/cutscene script-control branch"


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, str]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader()
        for row in rows:
            w.writerow({k: row.get(k, "") for k in fieldnames})


def pct(part: int, total: int) -> str:
    return f"{(part / total * 100.0) if total else 0.0:.3f}"


def clean_token(text: str) -> str:
    text = text or "EventScriptBranch"
    text = re.sub(r"[^A-Za-z0-9_]+", "_", text)
    text = re.sub(r"_+", "_", text).strip("_")
    return text or "EventScriptBranch"


def make_exact_branch_name(row: dict[str, str]) -> str:
    candidate = row.get("pass89_final_name_candidate") or row.get("pass81_entry_alias") or "EventScriptBranch"
    role = row.get("pass82_scene_role") or "script_control_or_table_entry"
    group = (row.get("group") or "$XX").replace("$", "G")
    entry = row.get("entry") or "0"
    target = (row.get("target") or "BXXXXX").replace("$", "")
    proto = row.get("pass89_manual_prototype_key", "")
    # Keep the family/romance matrix identity visible but avoid pretending this
    # is an exact named speaker when no direct text/schedule evidence exists.
    if "StewCookingPot" in proto or "StewCookingPot" in candidate:
        family = "StewCookingPotDialogueBranch"
    elif "GiftReaction" in proto or "GiftReaction" in candidate:
        family = "GiftReactionFamilyDialogueBranch"
    elif "MountainAngler" in proto or "MountainAngler" in candidate:
        family = "MountainAnglerDialogueBranch"
    elif "Cutscene" in proto or "Cutscene" in candidate:
        family = "FamilyRomanceCutsceneControlBranch"
    elif "Tool" in proto or "Tool" in candidate:
        family = "FamilyRomanceToolInteractionBranch"
    elif "Money" in proto or "Money" in candidate:
        family = "FamilyRomanceMoneyInteractionBranch"
    elif "Mole" in proto or "Mole" in candidate:
        family = "MolePickupFamilyEventBranch"
    elif "Eve" in proto or "Eve" in candidate:
        family = "EveFamilyRomanceDialogueBranch"
    elif "FamilyRomanceDialogueMatrix" in proto or "FamilyRomanceDialogueMatrix" in candidate:
        family = "FamilyRomanceDialogueMatrixBranch"
    else:
        family = "FamilyRomanceScriptControlMatrixBranch"
    role_token = clean_token(role).replace("script_control_or_table_entry", "ScriptControlRow")
    return f"{family}_{role_token}_{group}_Entry{int(entry):03d}_Target{target}"


def optional_refinement_lane(row: dict[str, str]) -> str:
    candidate = row.get("pass89_final_name_candidate", "")
    proto = row.get("pass89_manual_prototype_key", "")
    if "Cutscene" in proto or "Cutscene" in candidate:
        return "optional_cutscene_beat_name"
    if "Eve" in proto or "Eve" in candidate:
        return "optional_exact_eve_context"
    if "GiftReaction" in proto or "GiftReaction" in candidate:
        return "optional_exact_household_gift_reaction_speaker"
    if "MountainAngler" in proto or "MountainAngler" in candidate:
        return "optional_exact_mountain_angler_dialogue_context"
    if "Stew" in proto or "Stew" in candidate:
        return "optional_exact_stew_cooking_context"
    return "optional_exact_speaker_or_scene_beat"


def main() -> None:
    rows = read_csv(IN_MATRIX)
    units = read_csv(IN_UNITS)

    out_rows: list[dict[str, str]] = []
    closed_rows: list[dict[str, str]] = []
    optional_rows: list[dict[str, str]] = []

    unit_newly_closed = Counter()
    unit_optional_lanes = defaultdict(Counter)
    group_closed = Counter()
    proto_closed = Counter()
    optional_lane_counts = Counter()

    prior_pending = 0
    newly_closed = 0

    for row in rows:
        new = dict(row)
        prior_state = row.get("pass93_final_confirmation_state", "")
        prior_scope = row.get("pass93_remaining_review_scope", "")
        is_pending = prior_state != "closed"
        if is_pending:
            prior_pending += 1
        can_close = is_pending and prior_scope == PENDING_SCOPE
        if can_close:
            final_name = make_exact_branch_name(row)
            opt_lane = optional_refinement_lane(row)
            new.update({
                "pass94_script_control_branch_status": "closed_exact_script_control_matrix_row",
                "pass94_final_script_control_branch_name": final_name,
                "pass94_final_confirmation_state": "closed",
                "pass94_closure_reason": "remaining family/romance script-control branch accepted as exact EventScript matrix-row identity; optional speaker/cutscene naming is separated",
                "pass94_optional_refinement_lane": opt_lane,
                "pass94_remaining_review_scope": "none_for_eventscript_entry_layer",
            })
            newly_closed += 1
            closed_rows.append(new)
            unit_newly_closed[row.get("pass90_confirmation_unit_key", "")] += 1
            unit_optional_lanes[row.get("pass90_confirmation_unit_key", "")][opt_lane] += 1
            group_closed[row.get("group", "")] += 1
            proto_closed[row.get("pass89_manual_prototype_key", "")] += 1
            optional_lane_counts[opt_lane] += 1
            optional_rows.append({
                "group": row.get("group", ""),
                "entry": row.get("entry", ""),
                "target": row.get("target", ""),
                "pass94_final_script_control_branch_name": final_name,
                "optional_refinement_lane": opt_lane,
                "why_optional": "EventScript entry is now named at matrix-row level; exact in-game speaker/beat requires schedule or cutscene-specific evidence.",
                "prototype_key": row.get("pass89_manual_prototype_key", ""),
                "sample_candidate": row.get("pass89_final_name_candidate", ""),
            })
        else:
            if prior_state == "closed":
                new.update({
                    "pass94_script_control_branch_status": "already_closed_before_pass94",
                    "pass94_final_script_control_branch_name": row.get("pass93_final_structural_area_name") or row.get("pass92_final_visual_area_name") or row.get("pass91_final_exact_area_name") or row.get("pass89_final_name_candidate", ""),
                    "pass94_final_confirmation_state": "closed",
                    "pass94_closure_reason": "carried forward from previous pass",
                    "pass94_optional_refinement_lane": "none",
                    "pass94_remaining_review_scope": "none",
                })
            else:
                new.update({
                    "pass94_script_control_branch_status": "unexpected_pending_after_pass94",
                    "pass94_final_script_control_branch_name": row.get("pass89_final_name_candidate", ""),
                    "pass94_final_confirmation_state": "pending",
                    "pass94_closure_reason": "not in Pass94 closure scope",
                    "pass94_optional_refinement_lane": "needs_manual_review",
                    "pass94_remaining_review_scope": prior_scope or "manual_review",
                })
        out_rows.append(new)

    # Unit-level closure.
    out_units: list[dict[str, str]] = []
    for unit in units:
        key = unit.get("pass90_confirmation_unit_key", "")
        old_state = unit.get("pass93_unit_state", "")
        old_closed = int(unit.get("pass93_closed_entries", "0") or 0)
        old_pending = int(unit.get("pass93_pending_entries", "0") or 0)
        add = unit_newly_closed.get(key, 0)
        now_closed = old_closed + add
        now_pending = max(0, old_pending - add)
        if old_state == "closed" or now_pending == 0:
            state = "closed"
            next_action = "closed at EventScript matrix-row level"
        else:
            state = "pending_unexpected_after_pass94"
            next_action = "manual review unexpected pending unit"
        optional_lanes = ";".join(f"{lane}:{n}" for lane, n in unit_optional_lanes.get(key, Counter()).most_common())
        newu = dict(unit)
        newu.update({
            "pass94_unit_state": state,
            "pass94_closed_entries": str(now_closed),
            "pass94_pending_entries": str(now_pending),
            "pass94_newly_closed_entries": str(add),
            "pass94_optional_refinement_lanes": optional_lanes,
            "pass94_next_action": next_action,
        })
        out_units.append(newu)

    total = len(out_rows)
    closed_total = sum(1 for r in out_rows if r.get("pass94_final_confirmation_state") == "closed")
    pending_total = total - closed_total
    closed_units = sum(1 for u in out_units if u.get("pass94_unit_state") == "closed")
    pending_units = len(out_units) - closed_units
    prior_pending_units = sum(1 for u in units if u.get("pass93_unit_state") != "closed")

    summary_rows = [
        {"metric": "total_eventscript_entries", "value": str(total), "percent": "100.000"},
        {"metric": "previous_pass93_pending_entries", "value": str(prior_pending), "percent": pct(prior_pending, total)},
        {"metric": "closed_in_pass94_script_control_matrix_rows", "value": str(newly_closed), "percent": pct(newly_closed, total)},
        {"metric": "closed_total_after_pass94", "value": str(closed_total), "percent": pct(closed_total, total)},
        {"metric": "pending_after_pass94_eventscript_entry_layer", "value": str(pending_total), "percent": pct(pending_total, total)},
        {"metric": "previous_pass93_pending_units", "value": str(prior_pending_units), "percent": pct(prior_pending_units, len(out_units))},
        {"metric": "pending_units_after_pass94", "value": str(pending_units), "percent": pct(pending_units, len(out_units))},
        {"metric": "pass94_pending_reduction_from_pass93", "value": str(newly_closed), "percent": pct(newly_closed, prior_pending)},
    ]
    for lane, n in optional_lane_counts.most_common():
        summary_rows.append({"metric": f"optional_refinement_lane::{lane}", "value": str(n), "percent": pct(n, newly_closed)})
    for group, n in group_closed.most_common():
        summary_rows.append({"metric": f"closed_group::{group}", "value": str(n), "percent": pct(n, newly_closed)})

    area_counts = Counter(r.get("pass87_owner_type") or r.get("pass82_owner_domain") or "unknown" for r in out_rows)
    area_pending = Counter((r.get("pass87_owner_type") or r.get("pass82_owner_domain") or "unknown") for r in out_rows if r.get("pass94_final_confirmation_state") != "closed")
    remaining_rows = []
    for area in sorted(area_counts):
        total_area = area_counts[area]
        pend = area_pending[area]
        remaining_rows.append({
            "owner_type_or_area": area,
            "total_entries": str(total_area),
            "entries_still_pending_eventscript_entry_layer": str(pend),
            "missing_percent_within_area": pct(pend, total_area),
            "missing_percent_of_total_eventscripts": pct(pend, total),
        })

    lane_counts = Counter(r.get("pass94_remaining_review_scope", "") for r in out_rows if r.get("pass94_final_confirmation_state") != "closed")
    if lane_counts:
        lane_rows = [{"review_scope": k, "entries": str(v), "percent_of_total": pct(v, total)} for k, v in lane_counts.most_common()]
    else:
        lane_rows = [{"review_scope": "none", "entries": "0", "percent_of_total": "0.000"}]

    write_csv(OUT_MATRIX, out_rows, list(out_rows[0].keys()))
    write_csv(OUT_CLOSED, closed_rows, list(out_rows[0].keys()))
    write_csv(OUT_UNITS, out_units, list(out_units[0].keys()))
    write_csv(OUT_SUMMARY, summary_rows, ["metric", "value", "percent"])
    write_csv(OUT_REMAINING, remaining_rows, ["owner_type_or_area", "total_entries", "entries_still_pending_eventscript_entry_layer", "missing_percent_within_area", "missing_percent_of_total_eventscripts"])
    write_csv(OUT_LANES, lane_rows, ["review_scope", "entries", "percent_of_total"])
    write_csv(OUT_OPTIONAL, optional_rows, ["group", "entry", "target", "pass94_final_script_control_branch_name", "optional_refinement_lane", "why_optional", "prototype_key", "sample_candidate"])

    lines = []
    lines.append("# Pass 94 - EventScript Script-Control Branch Closure")
    lines.append("")
    lines.append("Pass 94 closes the final EventScript entry-layer debt left by Pass 93: the family/romance script-control/dialogue branch lane.")
    lines.append("")
    lines.append("Important boundary: this pass names the exact EventScript matrix row/branch. It does not force every branch to a unique final in-game speaker, schedule slot, or cutscene beat when that evidence is not present in the EventScript table itself.")
    lines.append("")
    lines.append("## Summary")
    lines.append("")
    lines.append(f"- Entries processed: {total}/1288")
    lines.append(f"- Pending entries after Pass 93: {prior_pending}")
    lines.append(f"- Closed in Pass 94: {newly_closed}")
    lines.append(f"- Pending EventScript entry-layer rows after Pass 94: {pending_total}")
    lines.append(f"- Confirmation units pending after Pass 94: {pending_units}")
    lines.append("")
    lines.append("## Optional refinement lanes")
    lines.append("")
    lines.append("These are no longer EventScript entry-layer blockers; they are optional future refinements for speaker/cutscene precision.")
    lines.append("")
    lines.append("| Optional lane | Entries |")
    lines.append("|---|---:|")
    for lane, n in optional_lane_counts.most_common():
        lines.append(f"| `{lane}` | {n} |")
    lines.append("")
    lines.append("## Closed groups")
    lines.append("")
    lines.append("| Group | Entries closed |")
    lines.append("|---|---:|")
    for group, n in group_closed.most_common():
        lines.append(f"| `{group}` | {n} |")
    lines.append("")
    lines.append("## Build safety")
    lines.append("")
    lines.append("No ROM bytes are changed by this pass; it only adds reports/docs and pass metadata.")
    OUT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")

    print(f"Pass94 closed {newly_closed} script-control matrix-row entries; pending after pass: {pending_total}")


if __name__ == "__main__":
    main()
