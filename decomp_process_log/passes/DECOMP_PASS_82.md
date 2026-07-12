# DECOMP PASS 82 - EventScript NPC/Sprite/Scene Ownership Xref

Status: completed.

Pass 82 moves from entry aliases to broad ownership classification for every EventScript entry.

| Area | Result |
|---|---:|
| EventScript entries classified | 1288/1288 |
| Owner-domain coverage | 100.000% |
| Scene-role coverage | 100.000% |
| Direct-dialog anchored entries | 75 |
| Entries with visual/object pointer refs | 176 |
| Unique visual/object pointer refs | 263 |
| EventCmd official dispatch | 90/90 |
| Effective EventScript residuals | 0 |

## New reports

- `reports/pass82_eventscript_entry_ownership_xref.csv`
- `reports/pass82_eventscript_ownership_domain_summary.csv`
- `reports/pass82_eventscript_scene_role_summary.csv`
- `reports/pass82_eventscript_group_owner_summary.csv`
- `reports/pass82_visual_pointer_refs.csv`
- `reports/pass82_eventscript_npc_sprite_scene_ownership.md`
- `reports/pass82_remaining_human_semantic_targets.md`

## Interpretation

All 1288 entries now have a broad owner domain and scene-role tag. This closes broad NPC/sprite/scene ownership coverage; remaining work is exact person/object/cutscene naming.
