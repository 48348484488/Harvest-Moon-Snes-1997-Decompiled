# DECOMP PASS 81 - EventScript All Entry Semantic Aliasing

Status: completed.

Pass 81 expands semantic naming from EventScript group-level coverage to every decoded B3-B5 EventScript entry.

This is a metadata/documentation pass. It does not modify ROM bytes or executable instruction bytes.

## Closed in this pass

| Area | Result |
|---|---:|
| EventScript decoded entries | 1288 |
| Entry aliases generated | 1288 |
| Entry alias coverage | 100.000% |
| Direct text-driven aliases preserved from Pass79 | 75 |
| Structural/group-derived aliases generated | 1213 |
| Groups covered | 72/72 |
| EventCmd official dispatch | 90/90 |
| Effective EventScript residuals | 0 |
| Rebuild | byte-perfect |

## Key outputs

- `tools/event_script_entry_semantic_alias_expander_pass81.py`
- `reports/pass81_eventscript_all_entry_semantic_aliases.csv`
- `reports/pass81_eventscript_entry_alias_group_summary.csv`
- `reports/pass81_eventscript_all_entry_semantic_aliasing.md`
- `reports/pass81_remaining_human_semantic_targets.md`

## Interpretation

Every EventScript entry now has a stable alias. Direct-dialog entries keep text-driven names from Pass79. Non-dialog entries receive structural names from Pass80 group semantics plus decoded command/class information.

This closes entry-level alias coverage, but some aliases are still structural rather than perfect human scene titles.
