# EventScript All Entry Semantic Aliasing - Pass 81

Pass 81 produces a complete per-entry semantic index for B3-B5 EventScripts.

## Coverage

| Metric | Value |
|---|---:|
| Groups | 72/72 |
| Entries | 1288/1288 |
| Entry alias coverage | 100.000% |
| Direct text-driven aliases | 75 |
| Structural/group-derived aliases | 1213 |

## Alias tiers

- `direct_text_anchor`: strongest tier, derived from resolved textbox Text IDs.
- `group_semantic_structural`: stable semantic alias derived from Pass80 group names and decoded command/class patterns.
- `table_structural_alias`: compact table-driven event clusters where a structural label is safer than inventing an exact cutscene title.

## Remaining work

The remaining human work is precision refinement: mapping aliases to exact NPC names, sprite/GOBJ objects, cutscene names, festival names, and gameplay context.
