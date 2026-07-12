# Pass 86 - Visual Low/Manual Reference Resolution

This pass resolves the remaining low-confidence visual/GOBJ references from Pass 85 by separating final GOBJ IDs from contextual pointers, local EventScript anchors, and CC visual resource pointers. No ROM bytes are changed.

## Headline metrics

| Metric | Value |
|---|---:|
| Low/manual visual references before | 24 |
| Low/manual visual references after | 0 |
| References reclassified in Pass 86 | 24 |
| EventScript visual entries refined | 176 |
| Total visual/GOBJ refs tracked | 263 |

## New classes for the 24 former low/manual refs

| Class | Count |
|---|---:|
| `resolved_eventscript_local_branch_or_table_anchor` | 12 |
| `resolved_cc_visual_pointer_or_animation_resource` | 10 |
| `resolved_contextual_immediate_or_table_value` | 2 |

## Families affected

| Family | Count |
|---|---:|
| `general_livestock` | 16 |
| `cow_livestock` | 3 |
| `npc_family_or_romance` | 3 |
| `chicken_poultry` | 1 |
| `dog_pet` | 1 |

## Resolved references

| Ref | Pass86 alias | Class | Confidence | Entries | Evidence |
|---|---|---|---|---:|---|
| `$B38C` | `EventLocalAnchor_chicken_poultry_B38C` | `resolved_eventscript_local_branch_or_table_anchor` | `high_contextual` | 25 | low-word resolves to B3/B4/B5 event-script source address/pointer-table region |
| `$8001` | `CCVisualPtr_cow_livestock_8001` | `resolved_cc_visual_pointer_or_animation_resource` | `medium_contextual` | 12 | used as ptr/visual argument by CC object visual commands; not a GOBJ catalog ID |
| `$B3DB` | `EventLocalAnchor_general_livestock_B3DB` | `resolved_eventscript_local_branch_or_table_anchor` | `high_contextual` | 11 | low-word resolves to B3/B4/B5 event-script source address/pointer-table region |
| `$812C` | `CCVisualPtr_general_livestock_812C` | `resolved_cc_visual_pointer_or_animation_resource` | `medium_contextual` | 9 | used as ptr/visual argument by CC object visual commands; not a GOBJ catalog ID |
| `$B3DF` | `EventLocalAnchor_general_livestock_B3DF` | `resolved_eventscript_local_branch_or_table_anchor` | `high_contextual` | 9 | low-word resolves to B3/B4/B5 event-script source address/pointer-table region |
| `$80FC` | `CCVisualPtr_cow_livestock_80FC` | `resolved_cc_visual_pointer_or_animation_resource` | `medium_contextual` | 7 | used as ptr/visual argument by CC object visual commands; not a GOBJ catalog ID |
| `$B3E1` | `EventLocalAnchor_general_livestock_B3E1` | `resolved_eventscript_local_branch_or_table_anchor` | `high_contextual` | 6 | low-word resolves to B3/B4/B5 event-script source address/pointer-table region |
| `$B3A7` | `EventLocalAnchor_cow_livestock_B3A7` | `resolved_eventscript_local_branch_or_table_anchor` | `high_contextual` | 5 | low-word resolves to B3/B4/B5 event-script source address/pointer-table region |
| `$B3C6` | `EventLocalAnchor_general_livestock_B3C6` | `resolved_eventscript_local_branch_or_table_anchor` | `high_contextual` | 5 | low-word resolves to B3/B4/B5 event-script source address/pointer-table region |
| `$B5A2` | `EventLocalAnchor_npc_family_or_romance_B5A2` | `resolved_eventscript_local_branch_or_table_anchor` | `high_contextual` | 4 | low-word resolves to B3/B4/B5 event-script source address/pointer-table region |
| `$B59F` | `EventLocalAnchor_general_livestock_B59F` | `resolved_eventscript_local_branch_or_table_anchor` | `high_contextual` | 3 | low-word resolves to B3/B4/B5 event-script source address/pointer-table region |
| `$849F` | `CCVisualPtr_general_livestock_849F` | `resolved_cc_visual_pointer_or_animation_resource` | `medium_contextual` | 2 | used as ptr/visual argument by CC object visual commands; not a GOBJ catalog ID |
| `$881C` | `CCVisualPtr_general_livestock_881C` | `resolved_cc_visual_pointer_or_animation_resource` | `medium_contextual` | 1 | used as ptr/visual argument by CC object visual commands; not a GOBJ catalog ID |
| `$884C` | `CCVisualPtr_general_livestock_884C` | `resolved_cc_visual_pointer_or_animation_resource` | `medium_contextual` | 1 | used as ptr/visual argument by CC object visual commands; not a GOBJ catalog ID |
| `$88CB` | `CCVisualPtr_general_livestock_88CB` | `resolved_cc_visual_pointer_or_animation_resource` | `medium_contextual` | 1 | used as ptr/visual argument by CC object visual commands; not a GOBJ catalog ID |
| `$893C` | `CCVisualPtr_general_livestock_893C` | `resolved_cc_visual_pointer_or_animation_resource` | `medium_contextual` | 1 | used as ptr/visual argument by CC object visual commands; not a GOBJ catalog ID |
| `$899C` | `CCVisualPtr_general_livestock_899C` | `resolved_cc_visual_pointer_or_animation_resource` | `medium_contextual` | 1 | used as ptr/visual argument by CC object visual commands; not a GOBJ catalog ID |
| `$89CC` | `CCVisualPtr_general_livestock_89CC` | `resolved_cc_visual_pointer_or_animation_resource` | `medium_contextual` | 1 | used as ptr/visual argument by CC object visual commands; not a GOBJ catalog ID |
| `$B3D7` | `EventLocalAnchor_general_livestock_B3D7` | `resolved_eventscript_local_branch_or_table_anchor` | `high_contextual` | 1 | low-word resolves to B3/B4/B5 event-script source address/pointer-table region |
| `$B597` | `EventLocalAnchor_dog_pet_B597` | `resolved_eventscript_local_branch_or_table_anchor` | `high_contextual` | 1 | low-word resolves to B3/B4/B5 event-script source address/pointer-table region |
| `$B598` | `EventLocalAnchor_general_livestock_B598` | `resolved_eventscript_local_branch_or_table_anchor` | `high_contextual` | 1 | low-word resolves to B3/B4/B5 event-script source address/pointer-table region |
| `$B5A6` | `EventLocalAnchor_npc_family_or_romance_B5A6` | `resolved_eventscript_local_branch_or_table_anchor` | `high_contextual` | 1 | low-word resolves to B3/B4/B5 event-script source address/pointer-table region |
| `$E8E1` | `ContextualValue_npc_family_or_romance_E8E1` | `resolved_contextual_immediate_or_table_value` | `medium_contextual` | 1 | contextual value extracted from visual command stream; no exact GOBJ catalog match |
| `$FBD7` | `ContextualValue_general_livestock_FBD7` | `resolved_contextual_immediate_or_table_value` | `medium_contextual` | 1 | contextual value extracted from visual command stream; no exact GOBJ catalog match |

## Interpretation

The former low/manual refs are no longer treated as unknown sprite/GOBJ assets. They are classified as one of: local EventScript pointer/table anchor, CC visual/animation pointer, or contextual immediate/state value. The remaining work is final human naming of some medium-confidence visual contexts, not low-level unidentified visual data.
