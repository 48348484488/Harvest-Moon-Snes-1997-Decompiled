# DECOMP PASS 95 - Final Human Semantic Closure

Pass 95 closes the remaining optional semantic-refinement lanes left by Pass 94.

## Result

| Area | Result |
|---|---:|
| Optional speaker/cutscene/context refinement targets | 577/577 closed |
| Remaining EventScript entry-layer blockers | 0 |
| Remaining human semantic blocker rows in maintained reports | 0 |
| EventScript groups/entries semantic coverage | 1288/1288 |
| EventCmd official dispatch coverage | 90/90 |
| EventScript true residuals | 0 |
| Generic source labels/tokens CODE_/DATA8_/DATA16_/SUB_/UNK_ | 0 |
| Rebuild byte-perfect | OK |
| Package policy | FULL NO-ROM |

## Important boundary

This pass closes names at the strongest evidence boundary available in the decompilation tables themselves. It does not invent playtest-only speaker identities when the data only proves a matrix row, context row, cutscene-control row, or dialogue branch. Those cases now have stable final names and are no longer decompilation blockers.

Any future work would be optional archival/playtest annotation, not a required decompilation task.

## New reports

- `reports/pass95_optional_literal_refinement_closure.csv`
- `reports/pass95_optional_literal_refinement_lane_summary.csv`
- `reports/pass95_final_decompilation_closure_summary.csv`
- `reports/pass95_remaining_human_semantic_targets.csv`
- `reports/pass95_final_decompilation_closure.md`

## New docs

- `docs/event_script_system/STATUS_PASS95.md`
- `docs/event_script_system/EventScript_FinalHumanSemanticClosure_PASS95.md`
- `docs/pseudocode/EventScript_FinalOptionalRefinementClosure_PASS95.md`
- `docs/handoff/METAS_DECOMP_PASS95.md`
