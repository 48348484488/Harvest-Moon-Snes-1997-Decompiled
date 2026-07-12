# Pass 91 - Domain-Specific Exact Area Closure

This pass closes the domain-specific EventScript owner lanes that were already narrow enough to be treated as exact area-level names: animal/livestock, farm/crop/weather, festival, and shipping/status.

## Metrics

| Metric | Value | Percent |
|---|---:|---:|
| total_eventscript_entries | 1288 | 100.000% |
| entries_closed_total_pass91 | 336 | 26.087% |
| entries_closed_direct_text_or_anchor | 68 | 5.280% |
| entries_closed_domain_specific_area_pass91 | 268 | 20.807% |
| entries_pending_structural_exact_name | 952 | 73.913% |
| confirmation_units_total | 163 | 100.000% |
| confirmation_units_closed_pass91 | 70 | 42.945% |
| confirmation_units_pending_pass91 | 93 | 57.055% |

## Remaining lanes

| Lane | Entries | Percent |
|---|---:|---:|
| resolve_exact_family_romance_npc_branch | 911 | 70.730% |
| none | 336 | 26.087% |
| cross_with_gobj_final_sprite_table | 41 | 3.183% |

## Remaining area percentages

| Area | Total | Pending | Missing within area | Missing of total |
|---|---:|---:|---:|---:|
| family_romance_general | 936 | 936 | 100.000% | 72.671% |
| object_visual_setup | 16 | 16 | 100.000% | 1.242% |
| animal_livestock | 181 | 0 | 0.000% | 0.000% |
| bachelorette_exact | 25 | 0 | 0.000% | 0.000% |
| carpenter_house_upgrade | 3 | 0 | 0.000% | 0.000% |
| church_priest | 3 | 0 | 0.000% | 0.000% |
| family_child | 9 | 0 | 0.000% | 0.000% |
| farm_crop_weather | 33 | 0 | 0.000% | 0.000% |
| festival_event | 31 | 0 | 0.000% | 0.000% |
| romance_general | 1 | 0 | 0.000% | 0.000% |
| romance_marriage_item | 1 | 0 | 0.000% | 0.000% |
| shipping_or_status | 31 | 0 | 0.000% | 0.000% |
| sign_manual_bookshelf | 5 | 0 | 0.000% | 0.000% |
| weather_farm_warning | 5 | 0 | 0.000% | 0.000% |
| wife_family | 8 | 0 | 0.000% | 0.000% |

## Notes

- No ASM byte-generating code was changed.
- Pass 91 is a semantic/reporting pass over the already byte-perfect Pass 90 source.
- Remaining entries are now limited to structural family/romance/NPC/cutscene lanes and a small GOBJ/sprite confirmation lane.
