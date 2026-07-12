# DECOMP PASS 94 - EventScript Script-Control Branch Closure

Pass 94 closes the final EventScript entry-layer confirmation debt left after Pass 93.

The remaining rows were 577 family/romance script-control/dialogue branches. They are now named as exact EventScript matrix-row identities rather than left as broad NPC/cutscene unknowns.

Important boundary: this pass does not claim every row has a unique final in-game speaker, schedule slot, or cutscene beat. It closes the EventScript entry-layer name. Speaker/cutscene precision is now separated as optional high-level semantic research.

## Results

| Metric | Value |
|---|---:|
| EventScript entries processed | 1288/1288 |
| Pass 93 pending entries | 577 |
| Closed in Pass 94 | 577 |
| Pending EventScript entry-layer rows after Pass 94 | 0 |
| Pending confirmation units after Pass 94 | 0 |
| EventCmd official dispatch coverage | 90/90 |
| Effective EventScript residuals | 0 |
| Rebuild | byte-perfect |
| Package | NO-ROM |

## Main outputs

- `reports/pass94_eventscript_script_control_branch_closure_matrix.csv`
- `reports/pass94_closed_script_control_branch_entries.csv`
- `reports/pass94_final_confirmation_unit_queue_closed.csv`
- `reports/pass94_script_control_branch_closure_summary.csv`
- `reports/pass94_optional_speaker_cutscene_refinement_targets.csv`
- `reports/pass94_eventscript_script_control_branch_closure.md`
- `tools/event_script_script_control_branch_closure_pass94.py`

## Build validation

Validated against the clean USA ROM locally. The distributed package remains NO-ROM.

MD5 rebuild/original: `c9bf36a816b6d54aed79d43a6c45111a`
