# Pass 92 - Visual/GOBJ Exact-Area Lane Closure

Pass 92 closes the remaining EventScript entries routed through the visual/GOBJ final-sprite review lane.

## Result

| Metric | Value |
|---|---:|
| EventScript entries processed | 1288 |
| Entries already closed before Pass 92 | 336 |
| Visual/GOBJ lane entries closed in Pass 92 | 41 |
| Total closed entries after Pass 92 | 377 |
| Pending entries after Pass 92 | 911 |
| Confirmation units closed in Pass 92 | 9 |
| Confirmation units pending after Pass 92 | 84 |

The closed entries are not treated as newly discovered opcodes. They are EventScript entries whose visual/GOBJ references were already classified in Pass 83-85 and whose low/manual visual refs were resolved in Pass 86. Pass 92 accepts those entries as exact visual-area names, leaving the remaining work concentrated in NPC/family/romance/cutscene semantic naming.

## Generated reports

- `reports/pass92_eventscript_visual_lane_closure_matrix.csv`
- `reports/pass92_final_confirmation_unit_queue_refined.csv`
- `reports/pass92_closed_visual_gobj_area_entries.csv`
- `reports/pass92_visual_gobj_lane_closure_summary.csv`
- `reports/pass92_remaining_exact_name_area_percentages.csv`
- `reports/pass92_confirmation_lane_summary.csv`
