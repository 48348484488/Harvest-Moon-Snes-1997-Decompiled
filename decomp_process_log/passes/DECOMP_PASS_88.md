# DECOMP PASS 88 - EventScript Owner Precision Tiers

Pass 88 refines the Pass 87 character/scene ownership map. It does not change ROM bytes.

## Main closure

- Total EventScript entries processed: 1288/1288.
- Exact/text anchored owners: 68.
- Domain-specific inferred owners: 268.
- Structural owner lanes still needing final exact NPC/scene names: 952.
- Pass87 broad owner rows triaged into deterministic lanes: 960.
- Rebuild remains byte-perfect.

## New files

- `tools/event_script_owner_precision_tiers_pass88.py`
- `reports/pass88_eventscript_owner_precision_tiers.csv`
- `reports/pass88_owner_precision_tier_summary.csv`
- `reports/pass88_manual_refinement_lane_summary.csv`
- `reports/pass88_owner_precision_group_summary.csv`
- `reports/pass88_remaining_final_name_targets.csv`
- `reports/pass88_eventscript_owner_precision_tiers.md`

## Meaning

The remaining broad Pass87 rows are no longer one large unknown bucket. They are now separated into exact/text anchored, domain-specific, and structural lanes for final manual naming.
