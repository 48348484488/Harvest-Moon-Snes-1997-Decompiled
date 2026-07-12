# Pass 81 - EventScript All Entry Semantic Aliasing

Metadata-only pass. No ROM bytes or ASM instruction bytes are changed.

## Objective

Expand EventScript semantic naming from group-level coverage to every decoded B3-B5 entry.

## Coverage

| Metric | Value |
|---|---:|
| EventScript entries decoded | 1288 |
| Pass81 entry aliases generated | 1288 |
| Entry alias coverage | 100.000% |
| Direct text-driven aliases preserved from Pass79 | 75 |
| Structural/group-derived aliases generated | 1213 |
| EventCmd official dispatch coverage | 90/90 |
| Effective EventScript residual coverage | 100.000% |

## Alias tiers

| Tier | Count |
|---|---:|
| `group_semantic_structural` | 749 |
| `table_structural_alias` | 464 |
| `direct_text_anchor` | 75 |

## Entry volume by group category

| Category | Entries |
|---|---:|
| `table_driven_scene` | 464 |
| `dialog_anchor` | 424 |
| `state_gate_router` | 96 |
| `tool_interaction` | 80 |
| `transition_router` | 32 |
| `audio_sequence` | 32 |
| `object_visual_setup` | 32 |
| `held_item_context` | 32 |
| `item_money_shipping` | 32 |
| `cutscene_motion` | 16 |
| `item_object_interaction` | 16 |
| `cutscene_object_transition` | 16 |
| `tile_object_payload` | 16 |

## Notes

- `direct_text_anchor` aliases are the strongest names because they are tied to resolved textbox Text IDs.
- `group_semantic_structural` aliases are useful stable labels, but some are still structural rather than exact scene names.
- `table_structural_alias` entries usually represent compact table-driven event data clusters, not standalone human-readable cutscenes.
- This pass closes per-entry alias coverage, but not every entry has a perfect human scene title yet.
