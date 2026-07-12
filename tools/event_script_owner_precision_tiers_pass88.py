#!/usr/bin/env python3
"""
Pass 88 - EventScript owner precision tier / manual target triage.

This tool does not alter ROM bytes.  It consumes the Pass 87 owner/scene xref
and turns the remaining broad owner records into deterministic refinement lanes.
The goal is to separate:
  * exact text-anchored owners,
  * domain-specific owners,
  * structural lanes that still need final NPC/festival/cutscene names.
"""
from __future__ import annotations

import csv
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPORTS = ROOT / "reports"
IN_CSV = REPORTS / "pass87_eventscript_character_scene_owner_xref.csv"
OUT_DETAIL = REPORTS / "pass88_eventscript_owner_precision_tiers.csv"
OUT_SUMMARY = REPORTS / "pass88_owner_precision_tier_summary.csv"
OUT_LANES = REPORTS / "pass88_manual_refinement_lane_summary.csv"
OUT_GROUPS = REPORTS / "pass88_owner_precision_group_summary.csv"
OUT_NEXT = REPORTS / "pass88_remaining_final_name_targets.csv"
OUT_MD = REPORTS / "pass88_eventscript_owner_precision_tiers.md"

BROAD_OWNERS = {"FamilyRomanceEvent", "ObjectVisualSetup", "AnimalLivestock", "RomanceDialogue"}
DIRECT_PREFIXES = (
    "direct_named", "direct_named_family", "direct_family", "direct_animal",
    "direct_weather", "direct_static", "direct_service", "direct_location",
    "direct_romance", "direct_category", "direct_event",
)


def norm(s: str) -> str:
    return (s or "").strip()


def classify_lane(row: dict[str, str]) -> tuple[str, str, str, str, str]:
    """Return tier, refined_lane, manual_type, next_action, evidence."""
    owner = norm(row.get("pass87_owner_scene_or_character"))
    owner_type = norm(row.get("pass87_owner_type"))
    conf = norm(row.get("pass87_confidence"))
    group = norm(row.get("group"))
    group_name = norm(row.get("group_semantic_name"))
    domain = norm(row.get("pass82_owner_domain"))
    role = norm(row.get("pass82_scene_role"))
    alias = norm(row.get("pass81_entry_alias"))
    visual_conf = norm(row.get("pass86_visual_name_confidence"))
    visual_names = norm(row.get("pass86_primary_visual_semantic_names"))
    evidence_bits: list[str] = []

    if conf.startswith(DIRECT_PREFIXES):
        tier = "exact_text_anchored_owner"
        lane = owner
        manual_type = "closed_exact_or_text_anchored"
        next_action = "optional_review_only"
        evidence_bits.append(f"pass87_confidence={conf}")
        if row.get("direct_text_labels"):
            evidence_bits.append("direct_text_labels")
        return tier, lane, manual_type, next_action, ";".join(evidence_bits)

    # Domain-specific but not text anchored.  These are not final perfect names,
    # but they are no longer broad unknown owners.
    if owner not in BROAD_OWNERS:
        tier = "domain_specific_owner_inferred"
        lane = owner
        manual_type = "needs_optional_exact_scene_name"
        next_action = "verify_against_map_npc_or_sprite_table"
        evidence_bits.append(f"owner_type={owner_type}")
        evidence_bits.append(f"domain={domain}")
        if visual_conf:
            evidence_bits.append(f"visual={visual_conf}")
        return tier, lane, manual_type, next_action, ";".join(evidence_bits)

    # Broad buckets get split into deterministic lanes.  This is the main Pass 88 value.
    base = group_name or domain or owner or "UnclassifiedEventScriptLane"
    if owner == "FamilyRomanceEvent":
        if "Marriage" in base or "BlueFeather" in base:
            lane_kind = "marriage_blue_feather_family_lane"
            next_action = "resolve_exact_bachelorette_or_family_member_by_nested_text_branch"
        elif "Eve" in base:
            lane_kind = "eve_family_romance_lane"
            next_action = "verify_eve_specific_branch_by_text_or_schedule_table"
        elif "Weather" in base or domain == "farm_weather_crop" or role == "weather_or_farm_warning_dialogue":
            lane_kind = "weather_family_romance_lane"
            next_action = "split_weather_forecast_vs_family_dialogue"
        elif "Festival" in base:
            lane_kind = "festival_family_romance_lane"
            next_action = "attach festival name and participant npc"
        else:
            lane_kind = "family_romance_matrix_lane"
            next_action = "resolve exact npc by nested text branch or event flag"
        refined = f"{base}::{lane_kind}"
        return "structural_owner_lane", refined, "needs_final_npc_or_scene_name", next_action, f"group={group};group_name={group_name};alias={alias}"

    if owner == "ObjectVisualSetup":
        refined = f"{base}::object_visual_setup_lane"
        return "structural_owner_lane", refined, "needs_final_object_or_gobj_name", "cross_with_gobj_final_sprite_table", f"group={group};role={role};visual={visual_conf}"

    if owner == "AnimalLivestock":
        refined = f"{base or domain}::animal_livestock_generic_lane"
        return "structural_owner_lane", refined, "needs_exact_animal_or_livestock_case", "split_cow_chicken_dog_horse_or_generic_livestock", f"domain={domain};visual={visual_names}"

    if owner == "RomanceDialogue":
        refined = f"{base}::romance_generic_dialogue_lane"
        return "structural_owner_lane", refined, "needs_final_romance_character_name", "resolve_bachelorette_from_text_id_or_heart_flag", f"group={group};group_name={group_name}"

    refined = f"{base}::manual_owner_lane"
    return "structural_owner_lane", refined, "needs_manual_review", "inspect_eventscript_entry", f"group={group};group_name={group_name};domain={domain};role={role}"


def main() -> None:
    rows = list(csv.DictReader(IN_CSV.open(newline="", encoding="utf-8")))
    out_rows = []
    for row in rows:
        tier, lane, manual_type, next_action, evidence = classify_lane(row)
        out = dict(row)
        out.update({
            "pass88_precision_tier": tier,
            "pass88_refined_owner_lane": lane,
            "pass88_manual_target_type": manual_type,
            "pass88_recommended_next_action": next_action,
            "pass88_evidence": evidence,
        })
        out_rows.append(out)

    fields = list(out_rows[0].keys()) if out_rows else []
    with OUT_DETAIL.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader(); w.writerows(out_rows)

    tier_counts = Counter(r["pass88_precision_tier"] for r in out_rows)
    manual_counts = Counter(r["pass88_manual_target_type"] for r in out_rows)
    lane_counts = Counter(r["pass88_refined_owner_lane"] for r in out_rows if r["pass88_precision_tier"] == "structural_owner_lane")
    group_counts: dict[str, Counter] = defaultdict(Counter)
    for r in out_rows:
        group_counts[r["group"]][r["pass88_precision_tier"]] += 1

    with OUT_SUMMARY.open("w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["metric", "entries", "percent"])
        total = len(out_rows) or 1
        for k, v in tier_counts.most_common():
            w.writerow([k, v, f"{v*100/total:.3f}"])
        for k, v in manual_counts.most_common():
            w.writerow([f"manual_type:{k}", v, f"{v*100/total:.3f}"])

    with OUT_LANES.open("w", newline="", encoding="utf-8") as f:
        w = csv.writer(f)
        w.writerow(["refined_owner_lane", "entries", "percent_of_structural_lanes"])
        denom = sum(lane_counts.values()) or 1
        for k, v in lane_counts.most_common():
            w.writerow([k, v, f"{v*100/denom:.3f}"])

    with OUT_GROUPS.open("w", newline="", encoding="utf-8") as f:
        fieldnames = ["group", "entries", "exact_text_anchored_owner", "domain_specific_owner_inferred", "structural_owner_lane", "dominant_tier"]
        w = csv.DictWriter(f, fieldnames=fieldnames)
        w.writeheader()
        for group in sorted(group_counts):
            c = group_counts[group]
            total = sum(c.values())
            dom = c.most_common(1)[0][0]
            w.writerow({
                "group": group,
                "entries": total,
                "exact_text_anchored_owner": c.get("exact_text_anchored_owner", 0),
                "domain_specific_owner_inferred": c.get("domain_specific_owner_inferred", 0),
                "structural_owner_lane": c.get("structural_owner_lane", 0),
                "dominant_tier": dom,
            })

    remaining = [r for r in out_rows if r["pass88_precision_tier"] == "structural_owner_lane"]
    rem_fields = ["group", "entry", "target", "pass87_owner_scene_or_character", "pass87_owner_type", "pass88_refined_owner_lane", "pass88_manual_target_type", "pass88_recommended_next_action", "pass81_entry_alias", "group_semantic_name", "pass82_owner_domain", "pass82_scene_role", "pseudocode_preview"]
    with OUT_NEXT.open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=rem_fields)
        w.writeheader()
        for r in remaining:
            w.writerow({k: r.get(k, "") for k in rem_fields})

    total = len(out_rows)
    exact = tier_counts.get("exact_text_anchored_owner", 0)
    domain = tier_counts.get("domain_specific_owner_inferred", 0)
    structural = tier_counts.get("structural_owner_lane", 0)
    broad_before = sum(1 for r in rows if r.get("pass87_owner_scene_or_character") in BROAD_OWNERS)
    md = []
    md.append("# Pass 88 - EventScript Owner Precision Tiers\n")
    md.append("This pass does not change ROM bytes. It converts the broad Pass 87 owner buckets into deterministic precision tiers and refinement lanes.\n")
    md.append("## Summary\n")
    md.append("| Metric | Count | Percent |\n|---|---:|---:|\n")
    for name, count in [
        ("Total EventScript entries", total),
        ("Exact/text-anchored owner", exact),
        ("Domain-specific inferred owner", domain),
        ("Structural owner lane still needing final exact name", structural),
        ("Pass87 broad owners triaged into lanes", broad_before),
    ]:
        md.append(f"| {name} | {count} | {count*100/(total or 1):.3f}% |\n")
    md.append("\n## Remaining final-name work\n")
    md.append("The remaining rows are no longer unbucketed broad owners; they are split into specific refinement lanes in `pass88_remaining_final_name_targets.csv`.\n")
    md.append("\n## Top structural lanes\n")
    md.append("| Lane | Entries |\n|---|---:|\n")
    for lane, count in lane_counts.most_common(20):
        md.append(f"| `{lane}` | {count} |\n")
    OUT_MD.write_text("".join(md), encoding="utf-8")

    print(f"total={total}")
    print(f"exact_text_anchored={exact}")
    print(f"domain_specific={domain}")
    print(f"structural_lane_remaining={structural}")
    print(f"broad_pass87_owners_triaged={broad_before}")

if __name__ == "__main__":
    main()
