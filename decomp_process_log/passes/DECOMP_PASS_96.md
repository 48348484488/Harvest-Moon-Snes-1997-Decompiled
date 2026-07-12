# Decomp Pass 96 - Final Independent Audit & Release Candidate

Pass 96 is not a new semantic rename pass. It is the final independent audit / release-candidate pass for the maintained Harvest Moon SNES decompilation workspace.

## Scope

- Validate byte-perfect rebuild evidence against the clean USA MD5.
- Confirm final package is NO-ROM.
- Confirm `project_buildable/src` and `source_decompilada/src` are identical.
- Confirm generic source labels remain closed.
- Confirm EventCmd/EventScript metrics remain closed.
- Package the workspace as a final release-candidate ZIP.

## Final audit verdict

PASS.

## Core results

| Check | Result |
|---|---:|
| Expected USA MD5 | `c9bf36a816b6d54aed79d43a6c45111a` |
| Rebuild MD5 from Pass96 build log | `c9bf36a816b6d54aed79d43a6c45111a` |
| Byte-perfect rebuild | PASS |
| ROM-like files in final tree | 0 |
| `.sfc/.smc/.fig/.swc/.rom` in final package tree | 0 |
| `project_buildable/src` vs `source_decompilada/src` | identical |
| Generic `CODE_` labels in src | 0 |
| Generic `DATA8_` labels in src | 0 |
| Generic `DATA16_` labels in src | 0 |
| Generic `SUB_` labels in src | 0 |
| Generic `UNK_` labels in src | 0 |
| EventCmd official dispatch | 90/90 |
| EventScript groups semantic names | 72/72 |
| EventScript entry semantic aliases | 1288/1288 |
| Remaining maintained human-semantic targets | 0 |

## New files

- `tools/final_release_audit_pass96.py`
- `reports/pass96_final_audit_matrix.csv`
- `reports/pass96_rom_absence_scan.csv`
- `reports/pass96_final_audit_summary.md`
- `DECOMP_PASS_96.md`
- `VALIDACAO_BUILD_PASS96.md`
- `docs/event_script_system/STATUS_PASS96.md`
- `docs/handoff/METAS_DECOMP_PASS96.md`

## Release status

This workspace is now a Final Release Candidate NO-ROM package. Further work should be treated as modding, playtest annotation, translation, or archival cleanup rather than required decompilation closure.
