#!/usr/bin/env python3
"""Pass 90: build an exact-name confirmation queue for EventScript entries.

This pass does not change ROM bytes. It takes the Pass 89 final-name candidate layer
and converts it into a precise review matrix: every EventScript entry receives a
confirmation tier, a pending/closed state, and a prototype-level review unit.
"""
from __future__ import annotations

import csv
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPORTS = ROOT / "reports"
SRC = REPORTS / "pass89_eventscript_final_name_candidates.csv"

MATRIX_OUT = REPORTS / "pass90_eventscript_final_confirmation_matrix.csv"
UNITS_OUT = REPORTS / "pass90_final_confirmation_unit_queue.csv"
SUMMARY_OUT = REPORTS / "pass90_final_confirmation_summary.csv"
AREA_OUT = REPORTS / "pass90_remaining_exact_name_area_percentages.csv"
LANE_OUT = REPORTS / "pass90_confirmation_lane_summary.csv"
MD_OUT = REPORTS / "pass90_eventscript_final_confirmation_queue.md"
REMAINING_MD = REPORTS / "pass90_remaining_human_semantic_targets.md"


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, object]], fieldnames: list[str] | None = None) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    if fieldnames is None:
        keys: list[str] = []
        seen = set()
        for r in rows:
            for k in r.keys():
                if k not in seen:
                    seen.add(k); keys.append(k)
        fieldnames = keys
    with path.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader()
        for r in rows:
            w.writerow(r)


def pct(n: int, d: int) -> str:
    return f"{(n / d * 100.0) if d else 0.0:.3f}"


def normalized(s: str) -> str:
    return (s or "").strip()


def confirmation_bucket(row: dict[str, str]) -> tuple[str, str, str, int, str]:
    """Return bucket, closed_state, review_scope, priority, next_action."""
    status = row.get("pass89_candidate_status", "")
    level = row.get("pass89_confirmation_level", "")
    target_type = row.get("pass88_manual_target_type", "")
    action = row.get("pass88_recommended_next_action", "")
    owner_type = row.get("pass87_owner_type", "")
    scene_role = row.get("pass82_scene_role", "")

    if status == "confirmed_text_or_direct_anchor_candidate" or level == "high" or target_type == "closed_exact_or_text_anchored":
        return (
            "confirmed_direct_anchor",
            "closed_for_pass90",
            "no_manual_review_required_unless_renaming_style_changes",
            4,
            "optional_review_only",
        )
    if status == "domain_inferred_final_candidate" or level == "medium" or target_type == "needs_optional_exact_scene_name":
        return (
            "domain_specific_needs_exact_scene_name",
            "pending_exact_scene_name",
            "review_against_map_npc_sprite_schedule_table",
            2,
            action or "verify_against_map_npc_sprite_schedule_table",
        )
    # Structural lanes are still the largest exact-name blocker.
    priority = 1
    review_scope = "resolve_exact_npc_scene_or_cutscene_branch"
    next_action = action or "resolve exact npc by nested text branch or event flag"
    if owner_type == "object_visual_setup" or "visual" in scene_role:
        review_scope = "cross_with_gobj_final_sprite_table"
        next_action = "cross_with_gobj_final_sprite_table"
    elif owner_type == "festival_event":
        review_scope = "resolve_exact_festival_or_calendar_scene"
    elif owner_type == "family_romance_general":
        review_scope = "resolve_exact_family_romance_npc_branch"
    return (
        "structural_lane_needs_exact_owner_or_scene",
        "pending_exact_owner_scene_or_cutscene_name",
        review_scope,
        priority,
        next_action,
    )


def manual_unit_key(row: dict[str, str], bucket: str) -> str:
    if bucket == "confirmed_direct_anchor":
        return "closed::" + normalized(row.get("pass89_final_name_candidate", ""))
    proto = normalized(row.get("pass89_manual_prototype_key", ""))
    if proto:
        return proto
    lane = normalized(row.get("pass88_refined_owner_lane", "")) or normalized(row.get("pass87_owner_scene_or_character", ""))
    role = normalized(row.get("pass82_scene_role", ""))
    return f"{bucket}::{lane}::{role}"


def main() -> int:
    rows = read_csv(SRC)
    total = len(rows)
    matrix = []
    by_unit: dict[str, list[dict[str, str]]] = defaultdict(list)
    bucket_counts: Counter[str] = Counter()
    closed_counts: Counter[str] = Counter()
    owner_counts: Counter[str] = Counter()
    lane_counts: Counter[str] = Counter()
    area_missing: Counter[str] = Counter()

    for r in rows:
        bucket, closed_state, review_scope, priority, action = confirmation_bucket(r)
        unit = manual_unit_key(r, bucket)
        out = dict(r)
        out.update({
            "pass90_confirmation_bucket": bucket,
            "pass90_closed_or_pending": closed_state,
            "pass90_review_scope": review_scope,
            "pass90_priority": priority,
            "pass90_recommended_next_action": action,
            "pass90_confirmation_unit_key": unit,
        })
        matrix.append(out)
        by_unit[unit].append(out)
        bucket_counts[bucket] += 1
        closed_counts[closed_state] += 1
        owner_counts[r.get("pass87_owner_type", "unknown")] += 1
        lane_counts[review_scope] += 1
        if closed_state != "closed_for_pass90":
            area_missing[r.get("pass87_owner_type", "unknown")] += 1

    units = []
    for unit, rs in by_unit.items():
        buckets = Counter(x["pass90_confirmation_bucket"] for x in rs)
        states = Counter(x["pass90_closed_or_pending"] for x in rs)
        owners = Counter(x.get("pass87_owner_type", "unknown") for x in rs)
        scopes = Counter(x["pass90_review_scope"] for x in rs)
        actions = Counter(x["pass90_recommended_next_action"] for x in rs)
        groups = sorted(set(x.get("group", "") for x in rs))
        samples = " | ".join(x.get("pass89_final_name_candidate", "") for x in rs[:3])
        priority = min(int(x["pass90_priority"]) for x in rs)
        units.append({
            "pass90_confirmation_unit_key": unit,
            "entries": len(rs),
            "dominant_bucket": buckets.most_common(1)[0][0],
            "dominant_state": states.most_common(1)[0][0],
            "dominant_owner_type": owners.most_common(1)[0][0],
            "review_scope": scopes.most_common(1)[0][0],
            "recommended_next_action": actions.most_common(1)[0][0],
            "priority": priority,
            "groups": " ".join(groups),
            "sample_candidates": samples,
        })
    units.sort(key=lambda r: (int(r["priority"]), r["dominant_state"] == "closed_for_pass90", -int(r["entries"]), r["pass90_confirmation_unit_key"]))

    pending_entries = sum(v for k, v in closed_counts.items() if k != "closed_for_pass90")
    closed_entries = closed_counts["closed_for_pass90"]
    pending_units = sum(1 for u in units if u["dominant_state"] != "closed_for_pass90")
    closed_units = len(units) - pending_units

    summary_rows = [
        {"metric": "total_eventscript_entries", "entries": total, "percent": "100.000"},
        {"metric": "entries_closed_by_direct_text_or_anchor", "entries": closed_entries, "percent": pct(closed_entries, total)},
        {"metric": "entries_pending_exact_final_name", "entries": pending_entries, "percent": pct(pending_entries, total)},
        {"metric": "confirmation_units_total", "entries": len(units), "percent": "100.000"},
        {"metric": "confirmation_units_closed", "entries": closed_units, "percent": pct(closed_units, len(units))},
        {"metric": "confirmation_units_pending", "entries": pending_units, "percent": pct(pending_units, len(units))},
        {"metric": "pending_entries_collapsed_to_pending_units", "entries": f"{pending_entries}->{pending_units}", "percent": pct(pending_units, pending_entries)},
    ]
    for k, v in bucket_counts.most_common():
        summary_rows.append({"metric": f"bucket:{k}", "entries": v, "percent": pct(v, total)})
    for k, v in closed_counts.most_common():
        summary_rows.append({"metric": f"state:{k}", "entries": v, "percent": pct(v, total)})

    lane_rows = []
    for k, v in lane_counts.most_common():
        lane_rows.append({"review_scope": k, "entries": v, "percent_of_total": pct(v, total)})

    area_rows = []
    for owner, total_owner in owner_counts.most_common():
        missing = area_missing.get(owner, 0)
        area_rows.append({
            "owner_type_or_area": owner,
            "total_entries": total_owner,
            "entries_still_pending_exact_final_name": missing,
            "missing_percent_within_area": pct(missing, total_owner),
            "missing_percent_of_total_eventscripts": pct(missing, total),
        })

    write_csv(MATRIX_OUT, matrix)
    write_csv(UNITS_OUT, units)
    write_csv(SUMMARY_OUT, summary_rows, ["metric", "entries", "percent"])
    write_csv(AREA_OUT, area_rows)
    write_csv(LANE_OUT, lane_rows)

    # Markdown reports
    def md_table(rows: list[dict[str, object]], cols: list[str]) -> str:
        out = ["| " + " | ".join(cols) + " |", "|" + "|".join(["---"] * len(cols)) + "|"]
        for r in rows:
            out.append("| " + " | ".join(str(r.get(c, "")) for c in cols) + " |")
        return "\n".join(out)

    md = []
    md.append("# Pass 90 - EventScript Final Confirmation Queue\n")
    md.append("This pass does not change ROM bytes. It converts Pass 89 final-name candidates into a precise confirmation queue.\n")
    md.append("## Summary\n")
    md.append(md_table(summary_rows[:7], ["metric", "entries", "percent"]))
    md.append("\n## Confirmation buckets\n")
    md.append(md_table([r for r in summary_rows if str(r["metric"]).startswith("bucket:")], ["metric", "entries", "percent"]))
    md.append("\n## Review lanes\n")
    md.append(md_table(lane_rows, ["review_scope", "entries", "percent_of_total"]))
    md.append("\n## Top pending confirmation units\n")
    md.append(md_table([u for u in units if u["dominant_state"] != "closed_for_pass90"][:30], ["pass90_confirmation_unit_key", "entries", "dominant_owner_type", "review_scope", "recommended_next_action", "priority"]))
    MD_OUT.write_text("\n".join(md) + "\n", encoding="utf-8")

    rem = []
    rem.append("# Pass 90 - Remaining human semantic targets\n")
    rem.append("The rebuild/source layer is unchanged and still byte-perfect. Remaining work is exact human naming.\n")
    rem.append("## Missing exact final-name percentages by owner/area\n")
    rem.append(md_table(area_rows, ["owner_type_or_area", "total_entries", "entries_still_pending_exact_final_name", "missing_percent_within_area", "missing_percent_of_total_eventscripts"]))
    rem.append("\n## Practical interpretation\n")
    rem.append(f"- Exact/direct closed entries: {closed_entries}/{total} ({pct(closed_entries, total)}%).")
    rem.append(f"- Entries still requiring exact final name validation: {pending_entries}/{total} ({pct(pending_entries, total)}%).")
    rem.append(f"- Those pending rows collapse into {pending_units} prototype review units.")
    rem.append("- This pass closes the queue structure, not the final manual identification itself.")
    REMAINING_MD.write_text("\n".join(rem) + "\n", encoding="utf-8")

    print(f"total={total}")
    print(f"closed_entries={closed_entries}")
    print(f"pending_entries={pending_entries}")
    print(f"units_total={len(units)}")
    print(f"pending_units={pending_units}")
    print(f"closed_units={closed_units}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
