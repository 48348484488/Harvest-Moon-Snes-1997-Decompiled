# Pass 84 - EventScript Visual Pointer Resolution

This pass resolves the Pass83 visual/GOBJ candidate references against the sprite/GOBJ catalog, EventScript entry aliases, and source address index. It does not modify ROM bytes.

## Measured results

| Metric | Value |
|---|---:|
| Visual/object refs from Pass83 | 263 |
| Visual EventScript entries | 176 |
| Exact GOBJ id refs | 69 |
| Exact animation-sequence low-word refs | 10 |
| EventScript local target alias refs | 0 |
| Runtime/WRAM state refs | 1 |
| High-confidence resolved refs | 80/263 (30.418%) |
| Entry visual family classifications | 176/176 (100.000%) |

## Resolution class summary

| Class | Unique refs | Percent |
|---|---:|---:|
| `source_address_line_match` | 139 | 52.852% |
| `exact_gobj_id` | 69 | 26.236% |
| `unresolved_asset_table_or_immediate` | 24 | 9.125% |
| `visual_param_or_non_gobj_id` | 20 | 7.605% |
| `exact_gobj_animation_sequence_lowword` | 10 | 3.802% |
| `runtime_cc_state_or_wram_pointer` | 1 | 0.380% |

## Notes

- Small refs that match `gobj_id_hex` are treated as exact GOBJ id evidence.
- `$80xx-$9xxx` refs that match the low word of a catalogued animation sequence are treated as exact animation-sequence evidence.
- `$B3xx-$B5xx` refs are resolved back to EventScript aliases when possible.
- Remaining table/immediate refs are still classified, but need manual sprite table decoding for exact object names.
