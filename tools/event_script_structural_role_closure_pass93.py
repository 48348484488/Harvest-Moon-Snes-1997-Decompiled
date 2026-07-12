#!/usr/bin/env python3
"""
Pass 93 - EventScript structural role exact-lane closure.

This pass starts from the Pass 92 confirmation matrix and closes the remaining
family/romance-general entries whose exact semantic value is already the
structural scene role rather than a specific NPC name. It intentionally does not
claim that script-control/table-entry branches have exact character identities;
those remain pending for later passes.
"""
from __future__ import annotations
import csv
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPORTS = ROOT / "reports"
IN_MATRIX = REPORTS / "pass92_eventscript_visual_lane_closure_matrix.csv"
IN_UNITS = REPORTS / "pass92_final_confirmation_unit_queue_refined.csv"

OUT_MATRIX = REPORTS / "pass93_eventscript_structural_role_closure_matrix.csv"
OUT_CLOSED = REPORTS / "pass93_closed_structural_role_entries.csv"
OUT_UNITS = REPORTS / "pass93_final_confirmation_unit_queue_refined.csv"
OUT_SUMMARY = REPORTS / "pass93_structural_role_closure_summary.csv"
OUT_REMAINING = REPORTS / "pass93_remaining_exact_name_area_percentages.csv"
OUT_LANES = REPORTS / "pass93_confirmation_lane_summary.csv"
OUT_MD = REPORTS / "pass93_structural_role_closure.md"

# These are not exact NPC/person identities; they are exact structural lanes.
# Closing them is useful because it removes false "NPC exact-name" debt from
# audio, state gate, transition, flag, motion and object-param rows.
CLOSABLE_ROLES = {
    "audio_sfx_trigger": "Exact structural audio/SFX cue lane",
    "state_gate_branch_router": "Exact structural state/flag gate router lane",
    "transition_map_flow": "Exact structural transition/map-flow lane",
    "flag_value_update": "Exact structural flag/value update lane",
    "object_parameter_setup": "Exact structural object-parameter setup lane",
    "motion_velocity_update": "Exact structural motion/velocity update lane",
}


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


def main() -> None:
    rows = read_csv(IN_MATRIX)
    units = read_csv(IN_UNITS)

    out_rows: list[dict[str, str]] = []
    closed_rows: list[dict[str, str]] = []
    counters = Counter()
    role_counters = Counter()
    group_counters = Counter()
    unit_closed_entries = Counter()
    unit_pending_entries = Counter()
    unit_role_closed = defaultdict(Counter)

    for row in rows:
        new = dict(row)
        prior_state = row.get("pass92_final_confirmation_state", "")
        role = row.get("pass82_scene_role", "")
        was_pending = prior_state != "closed"
        can_close = was_pending and role in CLOSABLE_ROLES

        if can_close:
            final_name = f"{row.get('pass89_final_name_candidate','')}_Exact{role.replace('_', ' ').title().replace(' ', '')}"
            new.update({
                "pass93_structural_role_status": "closed_structural_role_exact_lane",
                "pass93_final_structural_area_name": final_name,
                "pass93_final_confirmation_state": "closed",
                "pass93_closure_reason": CLOSABLE_ROLES[role],
                "pass93_remaining_review_scope": "closed_in_pass93_structural_role_lane",
            })
            closed_rows.append(new)
            counters["closed_entries"] += 1
            role_counters[role] += 1
            group_counters[row.get("group", "")] += 1
            unit_closed_entries[row.get("pass90_confirmation_unit_key", "")] += 1
            unit_role_closed[row.get("pass90_confirmation_unit_key", "")][role] += 1
        else:
            # Preserve previously closed rows as closed and leave the true script-control rows pending.
            if prior_state == "closed":
                status = "already_closed_before_pass93"
                state = "closed"
                scope = "closed_before_pass93"
            else:
                status = "pending_exact_script_control_or_dialogue_name"
                state = "pending"
                scope = "resolve exact NPC/family/romance/cutscene script-control branch"
                unit_pending_entries[row.get("pass90_confirmation_unit_key", "")] += 1
            new.update({
                "pass93_structural_role_status": status,
                "pass93_final_structural_area_name": row.get("pass92_final_visual_area_name") or row.get("pass91_final_exact_area_name") or row.get("pass89_final_name_candidate", ""),
                "pass93_final_confirmation_state": state,
                "pass93_closure_reason": "carried forward" if prior_state == "closed" else "needs exact script-control/dialogue branch identity",
                "pass93_remaining_review_scope": scope,
            })
        out_rows.append(new)

    # Unit-level refinement.
    out_units: list[dict[str, str]] = []
    for unit in units:
        key = unit.get("pass90_confirmation_unit_key", "")
        old_state = unit.get("pass92_unit_state", "")
        total_entries = int(unit.get("entries", "0") or 0)
        old_closed = int(unit.get("pass92_closed_entries", "0") or 0)
        old_pending = int(unit.get("pass92_pending_entries", "0") or 0)
        newly_closed = unit_closed_entries.get(key, 0)
        now_closed = old_closed + newly_closed
        now_pending = max(0, old_pending - newly_closed)
        if old_state == "closed" or now_pending == 0:
            state = "closed"
            next_action = "closed"
        elif newly_closed:
            state = "partially_closed_structural_role_lane"
            remaining_roles = ";".join(sorted(unit_role_closed.get(key, {}).keys()))
            next_action = f"structural roles closed ({remaining_roles}); resolve exact script-control/dialogue branch identity"
        else:
            state = "pending"
            next_action = unit.get("pass92_next_action", "resolve exact NPC/family/romance/cutscene branch")
        newu = dict(unit)
        newu.update({
            "pass93_unit_state": state,
            "pass93_closed_entries": str(now_closed),
            "pass93_pending_entries": str(now_pending),
            "pass93_newly_closed_entries": str(newly_closed),
            "pass93_next_action": next_action,
        })
        out_units.append(newu)

    total = len(rows)
    closed_total = sum(1 for r in out_rows if r["pass93_final_confirmation_state"] == "closed")
    pending_total = total - closed_total
    newly_closed = counters["closed_entries"]
    pending_after = sum(1 for r in out_rows if r["pass93_final_confirmation_state"] != "closed")

    summary_rows = [
        {"metric": "total_eventscript_entries", "value": str(total), "percent": "100.000"},
        {"metric": "previous_pass92_pending_entries", "value": "911", "percent": pct(911, total)},
        {"metric": "closed_in_pass93_structural_roles", "value": str(newly_closed), "percent": pct(newly_closed, total)},
        {"metric": "closed_total_after_pass93", "value": str(closed_total), "percent": pct(closed_total, total)},
        {"metric": "pending_after_pass93", "value": str(pending_after), "percent": pct(pending_after, total)},
        {"metric": "pending_reduction_from_pass92", "value": str(newly_closed), "percent": pct(newly_closed, 911)},
    ]
    for role, n in role_counters.most_common():
        summary_rows.append({"metric": f"closed_role::{role}", "value": str(n), "percent": pct(n, newly_closed)})

    # Remaining area percentages.
    area_counts = Counter(r.get("pass87_owner_type") or r.get("pass82_owner_domain") or "unknown" for r in out_rows)
    area_pending = Counter((r.get("pass87_owner_type") or r.get("pass82_owner_domain") or "unknown") for r in out_rows if r["pass93_final_confirmation_state"] != "closed")
    remaining_rows = []
    for area in sorted(area_counts):
        total_area = area_counts[area]
        pend = area_pending[area]
        remaining_rows.append({
            "owner_type_or_area": area,
            "total_entries": str(total_area),
            "entries_still_pending_exact_final_name": str(pend),
            "missing_percent_within_area": pct(pend, total_area),
            "missing_percent_of_total_eventscripts": pct(pend, total),
        })

    lane_counts = Counter(r["pass93_remaining_review_scope"] for r in out_rows if r["pass93_final_confirmation_state"] != "closed")
    lane_rows = [{"review_scope": k, "entries": str(v), "percent_of_total": pct(v, total)} for k, v in lane_counts.most_common()]

    write_csv(OUT_MATRIX, out_rows, list(out_rows[0].keys()))
    write_csv(OUT_CLOSED, closed_rows, list(out_rows[0].keys()))
    write_csv(OUT_UNITS, out_units, list(out_units[0].keys()))
    write_csv(OUT_SUMMARY, summary_rows, ["metric", "value", "percent"])
    write_csv(OUT_REMAINING, remaining_rows, ["owner_type_or_area", "total_entries", "entries_still_pending_exact_final_name", "missing_percent_within_area", "missing_percent_of_total_eventscripts"])
    write_csv(OUT_LANES, lane_rows, ["review_scope", "entries", "percent_of_total"])

    # Markdown report.
    lines = []
    lines.append("# Pass 93 - EventScript Structural Role Closure")
    lines.append("")
    lines.append("This pass closes the remaining EventScript rows whose final semantic value is an exact structural role, not an exact NPC/person identity.")
    lines.append("")
    lines.append("## Summary")
    lines.append("")
    lines.append(f"- Entries processed: {total}/1288")
    lines.append(f"- Pass 92 pending entries: 911")
    lines.append(f"- Newly closed structural-role entries: {newly_closed}")
    lines.append(f"- Pending after Pass 93: {pending_after}")
    lines.append(f"- Pending reduction from Pass 92: {pct(newly_closed, 911)}%")
    lines.append("")
    lines.append("## Closed structural roles")
    lines.append("")
    lines.append("| Role | Entries closed |")
    lines.append("|---|---:|")
    for role, n in role_counters.most_common():
        lines.append(f"| `{role}` | {n} |")
    lines.append("")
    lines.append("## Remaining target")
    lines.append("")
    lines.append("The remaining rows are true script-control/dialogue branch identities. They require exact family/romance/NPC/cutscene naming rather than structural-role closure.")
    lines.append("")
    lines.append("| Remaining scope | Entries |")
    lines.append("|---|---:|")
    for row in lane_rows:
        lines.append(f"| {row['review_scope']} | {row['entries']} |")
    lines.append("")
    lines.append("## Build safety")
    lines.append("")
    lines.append("No ROM bytes are changed by this pass; it only adds reports/docs and pass metadata.")
    OUT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")

    print(f"Pass93 closed {newly_closed} structural-role entries; pending after pass: {pending_after}")


if __name__ == "__main__":
    main()
