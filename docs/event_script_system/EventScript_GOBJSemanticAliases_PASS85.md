# Pass 85 - EventScript Visual/GOBJ Semantic Alias Layer

This pass adds a semantic alias layer on top of the Pass84 visual pointer resolution. It does not change ROM bytes.

## Measured results

| Metric | Value |
|---|---:|
| Visual/object references classified by Pass84 | 263 |
| References with Pass85 semantic aliases | 263/263 (100.000%) |
| High-confidence final visual aliases | 80/263 (30.418%) |
| Medium contextual visual aliases | 159/263 (60.456%) |
| Low/manual visual aliases | 24/263 (9.125%) |
| Visual EventScript entries named | 176/176 (100.000%) |
| Entries with high catalog/runtime visual evidence | 110/176 (62.500%) |
| EventCmd official audit | 90/90 (100.000%) |
| Effective EventScript residuals | 0 |

## Alias classes

| Alias class | Refs |
|---|---:|
| `context_source_address_not_final_gobj` | 139 |
| `final_exact_gobj_semantic_alias` | 69 |
| `manual_asset_table_decode_needed` | 24 |
| `visual_param_not_final_gobj` | 20 |
| `final_exact_animation_sequence_alias` | 10 |
| `runtime_state_semantic_alias` | 1 |

## Notes

- Exact GOBJ IDs are promoted to `GOBJ_<family>_<id>_FramesX_GfxY` aliases.
- Exact animation sequence low-word matches are promoted to `AnimSeq_<family>_<lowword>_<addr>` aliases.
- Runtime/WRAM references are named as runtime state references, not static sprite assets.
- Source-address and parameter-only matches are preserved as contextual aliases instead of pretending they are final GOBJ names.
- Manual targets are isolated in `reports/pass85_remaining_visual_manual_targets.csv`.
