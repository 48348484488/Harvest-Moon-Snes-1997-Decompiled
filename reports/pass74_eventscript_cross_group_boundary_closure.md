# Pass 74 - EventScript cross-group boundary closure

Pass 73 proved that the official EventCmd dispatch table is complete, but the conservative linear scanner still reported residual bytes. Pass 74 overlays the hard EventScriptGroup start boundaries from the master table and separates false residuals caused by cross-group pointers from true in-group inline payloads.

- ROM MD5: `c9bf36a816b6d54aed79d43a6c45111a`
- Total symbolic commands/markers from Pass 73: `8590`
- Pass 73 known commands: `7603`
- Pass 73 residual markers: `987`
- Cross-group boundary artifacts resolved in Pass 74: `888`
- True in-group inline residuals remaining: `99`
- Effective known coverage after boundary overlay: `98.847%`
- Effective unresolved in-group residual percent: `1.153%`

## Closure result

| Metric | Value | Status |
|---|---:|---|
| Official EventCmd dispatch audit | 90/90 | 100% closed |
| Residual markers reclassified as cross-group artifacts | 888/987 | 89.970% of Pass 73 residuals resolved |
| True in-group residual markers | 99/8590 | 1.153% remains |
| Groups with no true in-group residuals | 36/72 | 50.000% closed at boundary level |

## Pass 74 residual categories

| Category | Count | Percent of Pass 73 residuals | Meaning |
|---|---:|---:|---|
| `cross_group_boundary_artifact` | 888 | 89.970% | The scanner crossed the hard start of the next EventScriptGroup. This is not a missing opcode in the owning group. |
| `true_in_group_inline_residual_needs_manual_trace` | 99 | 10.030% | The residual is still inside the owning group range and needs manual event/content decoding. |

## Original Pass 73 categories mapped

| Pass 73 category | Count |
|---|---:|
| `entry_starts_as_residual_table_or_pointer_row` | 533 |
| `short_script_then_inline_residual_payload` | 413 |
| `long_script_then_inline_residual_payload` | 41 |

## Groups closed after hard-boundary overlay

`EventScriptGroup_04, EventScriptGroup_05, EventScriptGroup_06, EventScriptGroup_07, EventScriptGroup_08, EventScriptGroup_0A, EventScriptGroup_0C, EventScriptGroup_0D, EventScriptGroup_0E, EventScriptGroup_0F, EventScriptGroup_10, EventScriptGroup_11, EventScriptGroup_12, EventScriptGroup_13, EventScriptGroup_14, EventScriptGroup_16, EventScriptGroup_18, EventScriptGroup_19, EventScriptGroup_1A, EventScriptGroup_1D, EventScriptGroup_1E, EventScriptGroup_1F, EventScriptGroup_20, EventScriptGroup_21, EventScriptGroup_22, EventScriptGroup_23, EventScriptGroup_25, EventScriptGroup_27, EventScriptGroup_28, EventScriptGroup_29, EventScriptGroup_2A, EventScriptGroup_2B, EventScriptGroup_2C, EventScriptGroup_2D, EventScriptGroup_44, EventScriptGroup_45`

## Groups still needing manual inline trace

| Group | Commands/markers | True in-group residuals | Effective known % | Status |
|---:|---:|---:|---:|---|
| `$47` | 657 | 30 | 95.434% | needs_manual_inline_trace |
| `$46` | 29 | 13 | 55.172% | needs_manual_inline_trace |
| `$01` | 329 | 7 | 97.872% | needs_manual_inline_trace |
| `$00` | 480 | 5 | 98.958% | needs_manual_inline_trace |
| `$24` | 36 | 4 | 88.889% | needs_manual_inline_trace |
| `$43` | 231 | 4 | 98.268% | needs_manual_inline_trace |
| `$0B` | 91 | 2 | 97.802% | needs_manual_inline_trace |
| `$3A` | 32 | 2 | 93.750% | needs_manual_inline_trace |
| `$3B` | 18 | 2 | 88.889% | needs_manual_inline_trace |
| `$3C` | 18 | 2 | 88.889% | needs_manual_inline_trace |
| `$3D` | 32 | 2 | 93.750% | needs_manual_inline_trace |
| `$42` | 1796 | 2 | 99.889% | needs_manual_inline_trace |
| `$02` | 225 | 1 | 99.556% | needs_manual_inline_trace |
| `$03` | 207 | 1 | 99.517% | needs_manual_inline_trace |
| `$09` | 76 | 1 | 98.684% | needs_manual_inline_trace |
| `$15` | 62 | 1 | 98.387% | needs_manual_inline_trace |
| `$17` | 17 | 1 | 94.118% | needs_manual_inline_trace |
| `$1B` | 17 | 1 | 94.118% | needs_manual_inline_trace |
| `$1C` | 17 | 1 | 94.118% | needs_manual_inline_trace |
| `$26` | 21 | 1 | 95.238% | needs_manual_inline_trace |
| `$2E` | 32 | 1 | 96.875% | needs_manual_inline_trace |
| `$2F` | 17 | 1 | 94.118% | needs_manual_inline_trace |
| `$30` | 257 | 1 | 99.611% | needs_manual_inline_trace |
| `$31` | 17 | 1 | 94.118% | needs_manual_inline_trace |
| `$32` | 17 | 1 | 94.118% | needs_manual_inline_trace |
| `$33` | 17 | 1 | 94.118% | needs_manual_inline_trace |
| `$34` | 34 | 1 | 97.059% | needs_manual_inline_trace |
| `$35` | 18 | 1 | 94.444% | needs_manual_inline_trace |
| `$36` | 17 | 1 | 94.118% | needs_manual_inline_trace |
| `$37` | 19 | 1 | 94.737% | needs_manual_inline_trace |
| `$38` | 32 | 1 | 96.875% | needs_manual_inline_trace |
| `$39` | 17 | 1 | 94.118% | needs_manual_inline_trace |
| `$3E` | 32 | 1 | 96.875% | needs_manual_inline_trace |
| `$3F` | 32 | 1 | 96.875% | needs_manual_inline_trace |
| `$40` | 17 | 1 | 94.118% | needs_manual_inline_trace |
| `$41` | 18 | 1 | 94.444% | needs_manual_inline_trace |

## Recommended next pass

Attack the 99 true in-group inline residuals only. The largest targets are the groups with repeated `B4` inline residuals and the long scripts in groups `$01`, `$00`, `$46`, and `$47`. Do not treat cross-group boundary artifacts as unknown opcodes.
