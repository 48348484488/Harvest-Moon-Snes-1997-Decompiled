# DECOMP PASS 78 - EventScript Text Semantic Crossref 100%

Pass 78 continues after the Pass 77 EventScript residual closure. The focus is no longer opcode/payload correctness, because that layer is now closed. This pass attacks the next human-semantic blocker: linking decoded EventScript dialog commands to the existing text pointer catalog so scripts/events/NPC scenes can be named by real dialog anchors instead of only by group/index.

## Result

| Metric | Value |
|---|---:|
| EventCmd official dispatch coverage | 90/90 |
| Effective EventScript residual coverage | 100.000% |
| EventScript groups scanned | 72 |
| EventScript entries scanned | 1288 |
| Commands decoded under corrected model | 12948 |
| Direct textbox commands resolved to text catalog | 959/959 |
| Direct textbox text-id coverage | 100.000% |
| Direct textbox missing ids | 0 |
| Groups with direct dialog anchors | 18/72 |

## New tool

- `project_buildable/tools/event_script_text_semantic_xref_pass78.py`

The tool decodes all B3-B5 EventScript entries using the corrected opcode payload model, extracts direct dialog commands, resolves each text id through `reports/decomp_pass03/text/text_pointer_catalog.csv`, and emits CSV/Markdown reports with text labels, categories, previews, and role hints.

## New reports

- `project_buildable/reports/pass78_eventscript_direct_dialog_text_xref.csv`
- `project_buildable/reports/pass78_eventscript_text_related_arg_xref.csv`
- `project_buildable/reports/pass78_eventscript_text_xref_missing.csv`
- `project_buildable/reports/pass78_eventscript_group_text_semantic_summary.csv`
- `project_buildable/reports/pass78_eventscript_text_semantic_crossref.md`
- `project_buildable/reports/pass78_family_romance_dialogue_matrix.md`

## Human decompilation impact

This pass closes a concrete semantic layer:

| Layer | Before | After |
|---|---:|---:|
| Direct EventScript dialog text-id resolution | unknown/partial | 100.000% |
| Missing direct EventScript text ids | unknown | 0 |
| Family/romance groups with resolved dialogue anchors | partial | mapped |
| NPC/event naming anchors | partial | generated |

## High-value groups now ready for manual semantic naming

| Group | Direct dialog commands | Unique text ids | Main use |
|---:|---:|---:|---|
| `$43` | 186 | 67 | flag/state-gated dialog/event matrix |
| `$01` | 142 | 116 | mixed NPC/event dialogue |
| `$44` | 120 | 55 | family/romance dialogue matrix |
| `$04` | 91 | 61 | family/romance dialogue matrix |
| `$07` | 89 | 68 | family/romance dialogue matrix |
| `$06` | 73 | 48 | family/romance dialogue matrix |
| `$08` | 65 | 38 | family/romance dialogue matrix |
| `$02` | 53 | 44 | family/romance dialogue matrix |
| `$03` | 49 | 38 | family/romance dialogue matrix |
| `$46` | 23 | 23 | livestock/shipping/dialogue mixed group |
| `$45` | 18 | 6 | family/state gate router |
| `$05` | 17 | 14 | family/romance dialogue matrix |

## Build validation

The pass does not change assembled source bytes. Rebuild remains byte-perfect against the clean USA ROM.
