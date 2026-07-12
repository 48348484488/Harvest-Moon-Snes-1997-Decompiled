# DECOMP PASS 73 - EventScript Residual Boundary Classification

Pass 73 continues after the EventCmd audit closure of Pass 72. It improves the EventScript decompilation handoff by separating official VM opcode coverage from bytes reached by conservative linear scanning after script/table boundaries.

## Closed area

- EventCmd official dispatch metadata remains 90/90.
- Official opcode/class gaps inside `$00-$59`: 46 -> 0.
- `EventCmd $0D / SetCCVelocityOrDelta` is now classified as `cc_state_object` instead of `unknown`.
- Final stray generic source tokens were also removed: `SUB_UNUSED_1` -> `NameEntryScene_UnusedZero099FAndLoad`, and the last comment-only `DATA8_` token was rewritten.
- Remaining scanner hits are now classified as residual/data-boundary candidates, not missing official opcodes.

## Measured result

| Metric | Value |
|---|---:|
| EventScript groups scanned | 72 |
| Pointer entries decoded | 1288 |
| Symbolic commands/markers at max depth 128 | 8590 |
| Known symbolic commands | 7603 |
| Residual markers above `$59` | 987 |
| Official opcode metadata gaps `$00-$59` | 0 |
| Generic label tokens in `src/**/*.asm` | 0 |
| Symbolic known percent | 88.510% |

## New reports/tools

- `tools/event_script_residual_classifier_pass73.py`
- `tools/event_script_full_symbolic_export_pass73.py`
- `reports/pass73_eventscript_residual_classifier.md`
- `reports/pass73_eventscript_residual_entries.csv`
- `reports/pass73_eventscript_residual_group_summary.csv`
- `reports/event_script_full_symbolic_export_pass73.md`
- `reports/event_script_group_semantic_map_pass73.csv`
- `reports/event_script_full_symbolic_entries_pass73.csv`
- `reports/event_script_groups_pass73/`

## Safety

No ROM bytes, assembled data, or source layout bytes were changed. This pass only updates analysis tooling, semantic class metadata, reports, and documentation. Rebuild remains byte-perfect.
