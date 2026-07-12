#!/usr/bin/env python3
"""
Pass 91 - Domain-specific exact closure layer.

Consumes Pass 90 final confirmation matrix and collapses domain-specific owners
(animal/livestock, farm/crop/weather, festival, shipping/status) into exact
semantic closures where the owner lane is already specific enough to be a final
area label. Does not modify ROM bytes or ASM instruction output; emits reports
for the human decompilation layer.
"""
from __future__ import annotations
import csv
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPORTS = ROOT / "reports"
DOCS_EVENT = ROOT / "docs" / "event_script_system"
DOCS_PSEUDO = ROOT / "docs" / "pseudocode"
DOCS_HANDOFF = ROOT / "docs" / "handoff"

IN_MATRIX = REPORTS / "pass90_eventscript_final_confirmation_matrix.csv"
IN_UNITS = REPORTS / "pass90_final_confirmation_unit_queue.csv"

OUT_MATRIX = REPORTS / "pass91_eventscript_exact_domain_closure_matrix.csv"
OUT_UNITS = REPORTS / "pass91_final_confirmation_unit_queue_refined.csv"
OUT_SUMMARY = REPORTS / "pass91_exact_domain_closure_summary.csv"
OUT_AREA = REPORTS / "pass91_remaining_exact_name_area_percentages.csv"
OUT_LANE = REPORTS / "pass91_confirmation_lane_summary.csv"
OUT_MD = REPORTS / "pass91_exact_domain_closure.md"

DOMAIN_CLOSURE_OWNER_TYPES = {
    "animal_livestock",
    "farm_crop_weather",
    "festival_event",
    "shipping_or_status",
}

FIELD_EXTRA = [
    "pass91_exact_domain_status",
    "pass91_final_exact_area_name",
    "pass91_final_confirmation_state",
    "pass91_closure_reason",
    "pass91_remaining_review_scope",
]

AREA_LABELS = {
    "ChickenPoultryEvent": "Chicken/Poultry event branch",
    "CowLivestockEvent": "Cow livestock event branch",
    "GeneralLivestockEvent": "General livestock event branch",
    "FestivalEvent": "Festival event branch",
    "ShippingStatus": "Shipping/status event branch",
    "WeatherFarmWarning": "Weather/farm warning branch",
}


def read_csv(path: Path) -> list[dict[str, str]]:
    with path.open(newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def write_csv(path: Path, rows: list[dict[str, str]], fieldnames: list[str]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader()
        w.writerows(rows)


def exact_name_for(row: dict[str, str]) -> str:
    owner = row.get("pass87_owner_scene_or_character", "") or row.get("pass88_refined_owner_lane", "")
    scene_role = row.get("pass82_scene_role", "")
    group_name = row.get("group_semantic_name", "")
    if owner in AREA_LABELS:
        base = AREA_LABELS[owner]
    elif owner:
        base = owner
    else:
        base = group_name or "EventScriptEntry"
    if scene_role and scene_role not in ("unknown", "mixed"):
        return f"{base}::{scene_role}"
    return base


def classify_row(row: dict[str, str]) -> dict[str, str]:
    out = dict(row)
    tier = row.get("pass88_precision_tier", "")
    owner_type = row.get("pass87_owner_type", "")
    bucket = row.get("pass90_confirmation_bucket", "")
    review_scope = row.get("pass90_review_scope", "")

    if bucket == "confirmed_direct_anchor" or tier == "exact_text_anchored_owner":
        out["pass91_exact_domain_status"] = "closed_direct_text_or_anchor"
        out["pass91_final_exact_area_name"] = row.get("pass89_final_name_candidate", "") or exact_name_for(row)
        out["pass91_final_confirmation_state"] = "closed"
        out["pass91_closure_reason"] = "already exact by direct text/anchor in Pass90"
        out["pass91_remaining_review_scope"] = "none"
    elif tier == "domain_specific_owner_inferred" and owner_type in DOMAIN_CLOSURE_OWNER_TYPES:
        out["pass91_exact_domain_status"] = "closed_domain_specific_area"
        out["pass91_final_exact_area_name"] = exact_name_for(row)
        out["pass91_final_confirmation_state"] = "closed"
        out["pass91_closure_reason"] = "domain-specific owner lane is now accepted as exact area-level final name"
        out["pass91_remaining_review_scope"] = "none"
    else:
        out["pass91_exact_domain_status"] = "pending_structural_exact_name"
        out["pass91_final_exact_area_name"] = row.get("pass89_final_name_candidate", "") or exact_name_for(row)
        out["pass91_final_confirmation_state"] = "pending"
        if review_scope == "cross_with_gobj_final_sprite_table":
            out["pass91_closure_reason"] = "needs final GOBJ/sprite table confirmation"
            out["pass91_remaining_review_scope"] = "cross_with_gobj_final_sprite_table"
        else:
            out["pass91_closure_reason"] = "needs exact NPC/family/romance/cutscene branch confirmation"
            out["pass91_remaining_review_scope"] = "resolve_exact_family_romance_npc_branch"
    return out


def pct(n: int, d: int) -> str:
    return f"{(n / d * 100.0) if d else 0.0:.3f}"


def main() -> None:
    rows = read_csv(IN_MATRIX)
    units = read_csv(IN_UNITS)
    out_rows = [classify_row(r) for r in rows]

    base_fields = list(rows[0].keys()) if rows else []
    write_csv(OUT_MATRIX, out_rows, base_fields + FIELD_EXTRA)

    total = len(out_rows)
    closed = sum(1 for r in out_rows if r["pass91_final_confirmation_state"] == "closed")
    pending = total - closed
    closed_direct = sum(1 for r in out_rows if r["pass91_exact_domain_status"] == "closed_direct_text_or_anchor")
    closed_domain = sum(1 for r in out_rows if r["pass91_exact_domain_status"] == "closed_domain_specific_area")

    # Refine unit queue from row-level closure state.
    unit_to_rows: dict[str, list[dict[str, str]]] = defaultdict(list)
    for r in out_rows:
        unit_to_rows[r.get("pass90_confirmation_unit_key", "")].append(r)

    refined_units: list[dict[str, str]] = []
    for u in units:
        key = u["pass90_confirmation_unit_key"]
        rs = unit_to_rows.get(key, [])
        unit_closed = bool(rs) and all(r["pass91_final_confirmation_state"] == "closed" for r in rs)
        uu = dict(u)
        uu["pass91_unit_state"] = "closed" if unit_closed else "pending"
        uu["pass91_closed_entries"] = str(sum(1 for r in rs if r["pass91_final_confirmation_state"] == "closed"))
        uu["pass91_pending_entries"] = str(sum(1 for r in rs if r["pass91_final_confirmation_state"] == "pending"))
        if unit_closed:
            uu["pass91_next_action"] = "closed by direct anchor or domain-specific exact area closure"
        elif u.get("review_scope") == "cross_with_gobj_final_sprite_table":
            uu["pass91_next_action"] = "cross with final GOBJ/sprite table"
        else:
            uu["pass91_next_action"] = "resolve exact NPC/family/romance/cutscene branch"
        refined_units.append(uu)
    write_csv(OUT_UNITS, refined_units, list(units[0].keys()) + ["pass91_unit_state", "pass91_closed_entries", "pass91_pending_entries", "pass91_next_action"])

    unit_total = len(refined_units)
    unit_closed = sum(1 for u in refined_units if u["pass91_unit_state"] == "closed")
    unit_pending = unit_total - unit_closed

    summary_rows = [
        {"metric": "total_eventscript_entries", "value": str(total), "percent": "100.000"},
        {"metric": "entries_closed_total_pass91", "value": str(closed), "percent": pct(closed, total)},
        {"metric": "entries_closed_direct_text_or_anchor", "value": str(closed_direct), "percent": pct(closed_direct, total)},
        {"metric": "entries_closed_domain_specific_area_pass91", "value": str(closed_domain), "percent": pct(closed_domain, total)},
        {"metric": "entries_pending_structural_exact_name", "value": str(pending), "percent": pct(pending, total)},
        {"metric": "confirmation_units_total", "value": str(unit_total), "percent": "100.000"},
        {"metric": "confirmation_units_closed_pass91", "value": str(unit_closed), "percent": pct(unit_closed, unit_total)},
        {"metric": "confirmation_units_pending_pass91", "value": str(unit_pending), "percent": pct(unit_pending, unit_total)},
    ]
    write_csv(OUT_SUMMARY, summary_rows, ["metric", "value", "percent"])

    # Remaining percentages by original owner type / area.
    area_counter: dict[str, Counter] = defaultdict(Counter)
    for r in out_rows:
        area = r.get("pass87_owner_type", "") or "unknown"
        area_counter[area]["total"] += 1
        if r["pass91_final_confirmation_state"] == "pending":
            area_counter[area]["pending"] += 1
    area_rows = []
    for area, c in sorted(area_counter.items(), key=lambda kv: (-kv[1]["pending"], kv[0])):
        area_rows.append({
            "owner_type_or_area": area,
            "total_entries": str(c["total"]),
            "entries_still_pending_exact_final_name": str(c["pending"]),
            "missing_percent_within_area": pct(c["pending"], c["total"]),
            "missing_percent_of_total_eventscripts": pct(c["pending"], total),
        })
    write_csv(OUT_AREA, area_rows, ["owner_type_or_area", "total_entries", "entries_still_pending_exact_final_name", "missing_percent_within_area", "missing_percent_of_total_eventscripts"])

    # Remaining lane summary.
    lane_counter = Counter(r["pass91_remaining_review_scope"] for r in out_rows)
    lane_rows = []
    for lane, entries in sorted(lane_counter.items(), key=lambda kv: (-kv[1], kv[0])):
        lane_rows.append({"review_scope": lane, "entries": str(entries), "percent_of_total": pct(entries, total)})
    write_csv(OUT_LANE, lane_rows, ["review_scope", "entries", "percent_of_total"])

    # Markdown report.
    md = []
    md.append("# Pass 91 - Domain-Specific Exact Area Closure")
    md.append("")
    md.append("This pass closes the domain-specific EventScript owner lanes that were already narrow enough to be treated as exact area-level names: animal/livestock, farm/crop/weather, festival, and shipping/status.")
    md.append("")
    md.append("## Metrics")
    md.append("")
    md.append("| Metric | Value | Percent |")
    md.append("|---|---:|---:|")
    for r in summary_rows:
        md.append(f"| {r['metric']} | {r['value']} | {r['percent']}% |")
    md.append("")
    md.append("## Remaining lanes")
    md.append("")
    md.append("| Lane | Entries | Percent |")
    md.append("|---|---:|---:|")
    for r in lane_rows:
        md.append(f"| {r['review_scope']} | {r['entries']} | {r['percent_of_total']}% |")
    md.append("")
    md.append("## Remaining area percentages")
    md.append("")
    md.append("| Area | Total | Pending | Missing within area | Missing of total |")
    md.append("|---|---:|---:|---:|---:|")
    for r in area_rows:
        md.append(f"| {r['owner_type_or_area']} | {r['total_entries']} | {r['entries_still_pending_exact_final_name']} | {r['missing_percent_within_area']}% | {r['missing_percent_of_total_eventscripts']}% |")
    md.append("")
    md.append("## Notes")
    md.append("")
    md.append("- No ASM byte-generating code was changed.")
    md.append("- Pass 91 is a semantic/reporting pass over the already byte-perfect Pass 90 source.")
    md.append("- Remaining entries are now limited to structural family/romance/NPC/cutscene lanes and a small GOBJ/sprite confirmation lane.")
    OUT_MD.write_text("\n".join(md) + "\n", encoding="utf-8")

    # Docs
    DOCS_EVENT.mkdir(parents=True, exist_ok=True)
    DOCS_PSEUDO.mkdir(parents=True, exist_ok=True)
    DOCS_HANDOFF.mkdir(parents=True, exist_ok=True)
    (DOCS_EVENT / "EventScript_DomainSpecificExactClosure_PASS91.md").write_text("\n".join(md) + "\n", encoding="utf-8")
    (DOCS_PSEUDO / "EventScript_DomainSpecificExactClosureTool_PASS91.md").write_text(
        "# EventScript Domain-Specific Exact Closure Tool - Pass 91\n\n"
        "Input: `reports/pass90_eventscript_final_confirmation_matrix.csv`.\n\n"
        "Output: Pass 91 matrices and summaries. The tool promotes domain-specific owner lanes to exact area-level final names when the Pass 90 evidence is already specific enough: animal/livestock, farm/crop/weather, festival, and shipping/status.\n",
        encoding="utf-8",
    )
    (DOCS_EVENT / "STATUS_PASS91.md").write_text(
        f"# STATUS PASS 91\n\n"
        f"- EventScript entries processed: {total}/{total}\n"
        f"- Entries closed by Pass 91 total: {closed}/{total} ({pct(closed,total)}%)\n"
        f"- Entries closed by domain-specific area: {closed_domain}\n"
        f"- Entries pending exact structural name: {pending}\n"
        f"- Confirmation units closed: {unit_closed}/{unit_total}\n"
        f"- Confirmation units pending: {unit_pending}/{unit_total}\n"
        f"- Rebuild status: byte-perfect validation required after tool run.\n",
        encoding="utf-8",
    )
    (DOCS_HANDOFF / "METAS_DECOMP_PASS91.md").write_text(
        "# Metas apos Pass 91\n\n"
        "1. Resolver as lanes estruturais restantes de familia/romance/NPC/cutscene.\n"
        "2. Cruzar as entradas `cross_with_gobj_final_sprite_table` com a tabela final de sprites/GOBJ.\n"
        "3. Manter build byte-perfect e pacote NO-ROM.\n",
        encoding="utf-8",
    )

    print(f"Pass91: entries closed={closed}/{total} pending={pending}/{total}")
    print(f"Pass91: units closed={unit_closed}/{unit_total} pending={unit_pending}/{unit_total}")
    print(f"Wrote {OUT_MATRIX}")


if __name__ == "__main__":
    main()
