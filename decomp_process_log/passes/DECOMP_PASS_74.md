# DECOMP PASS 74 - EventScript Cross-Group Boundary Closure

Pass 74 continues after the Pass 73 residual classifier. The goal is to avoid miscounting cross-group pointer/boundary artifacts as unresolved EventScript opcode work.

## Closed area

- Official EventCmd dispatch audit remains 90/90.
- Hard EventScriptGroup boundaries from the master table are now applied over the Pass 73 residual list.
- Cross-group scan artifacts are separated from true in-group inline residual payloads.
- 888 of 987 Pass 73 residual markers are now resolved as cross-group boundary/alias artifacts.
- Only 99 true in-group inline residual markers remain for manual script/content analysis.

## Measured result

| Metric | Value |
|---|---:|
| Total symbolic commands/markers | 8590 |
| Pass 73 known commands | 7603 |
| Pass 73 residual markers | 987 |
| Cross-group artifacts resolved in Pass 74 | 888 |
| True in-group residual markers remaining | 99 |
| Effective known coverage after boundary overlay | 98.847% |
| Effective unresolved in-group residual percent | 1.153% |
| Groups closed after hard-boundary overlay | 36/72 |

## Meaning

Before this pass, all 987 residual markers looked like unresolved bytes. Pass 74 proves that most of them are caused by the conservative scanner crossing into the next EventScriptGroup start or following cross-group aliases. These are not missing official EventCmd opcodes.

The remaining target is now much smaller and sharper: 99 true in-group inline residuals.

## New reports/tools

- `tools/event_script_cross_group_boundary_classifier_pass74.py`
- `reports/pass74_eventscript_cross_group_boundary_closure.md`
- `reports/pass74_eventscript_boundary_classified_residuals.csv`
- `reports/pass74_eventscript_group_boundary_summary.csv`
- `docs/pseudocode/EventScript_CrossGroupBoundaryClassifier_PASS74.md`
- `docs/event_script_system/STATUS_PASS74.md`
- `docs/handoff/METAS_DECOMP_PASS74.md`

## Safety

No ROM bytes, assembled data bytes, or gameplay code bytes were changed. This pass only adds analysis tooling, reports, and documentation. Rebuild remains byte-perfect.
