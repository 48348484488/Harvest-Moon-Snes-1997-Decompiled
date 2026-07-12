# Pass 73 - EventScript residual/data-boundary classifier

This report separates true EventCmd metadata from residual bytes reached by the conservative linear script scanner. Official EventScript opcodes are `$00-$59`. Bytes above `$59` are not official VM opcodes in the dispatch table and are classified as residual/data-boundary candidates unless a later manual trace proves otherwise.

- ROM MD5: `c9bf36a816b6d54aed79d43a6c45111a`
- Groups scanned: `72`
- Pointer entries decoded: `1288`
- Max commands per entry: `128`
- Total symbolic commands/markers: `8590`
- Known symbolic commands: `7603`
- Residual markers: `987`
- Symbolic known percent: `88.510%`
- Residual percent: `11.490%`
- Official opcode metadata gaps inside `$00-$59`: `0`

## Closure result

| Metric | Value | Status |
|---|---:|---|
| Official EventCmd dispatch audit | 90/90 | 100% closed |
| Official opcode markers still classed as unknown | 0 | closed |
| Residual markers above `$59` | 987 | classified as data/boundary candidates |
| Groups with no residual markers | 1/72 | documentation target |

## Residual categories

| Category | Count | Percent of residuals | Meaning |
|---|---:|---:|---|
| `entry_starts_as_residual_table_or_pointer_row` | 533 | 54.002% | The pointer target begins with a byte above `$59`; likely table row, pointer row, or non-script body. |
| `short_script_then_inline_residual_payload` | 413 | 41.844% | A short valid script reaches residual bytes; needs target-by-target manual trace. |
| `long_script_then_inline_residual_payload` | 41 | 4.154% | A longer valid script reaches residual bytes; likely inline payload/table after scripted prefix. |

## Top residual bytes

| Byte | Hits | Notes |
|---:|---:|---|
| `$B4` | 107 | Above official dispatch range; classify per entry context. |
| `$5F` | 32 | Above official dispatch range; classify per entry context. |
| `$67` | 30 | Above official dispatch range; classify per entry context. |
| `$C5` | 30 | Above official dispatch range; classify per entry context. |
| `$88` | 29 | Above official dispatch range; classify per entry context. |
| `$F2` | 29 | Above official dispatch range; classify per entry context. |
| `$C6` | 28 | Above official dispatch range; classify per entry context. |
| `$A4` | 27 | Above official dispatch range; classify per entry context. |
| `$D5` | 27 | Above official dispatch range; classify per entry context. |
| `$D8` | 25 | Above official dispatch range; classify per entry context. |
| `$9F` | 18 | Above official dispatch range; classify per entry context. |
| `$68` | 16 | Above official dispatch range; classify per entry context. |
| `$5C` | 15 | Above official dispatch range; classify per entry context. |
| `$F3` | 15 | Above official dispatch range; classify per entry context. |
| `$5B` | 15 | Above official dispatch range; classify per entry context. |
| `$C0` | 15 | Above official dispatch range; classify per entry context. |
| `$89` | 15 | Above official dispatch range; classify per entry context. |
| `$8E` | 15 | Above official dispatch range; classify per entry context. |
| `$E5` | 15 | Above official dispatch range; classify per entry context. |
| `$B5` | 15 | Above official dispatch range; classify per entry context. |
| `$F8` | 15 | Above official dispatch range; classify per entry context. |
| `$75` | 15 | Above official dispatch range; classify per entry context. |
| `$B6` | 15 | Above official dispatch range; classify per entry context. |
| `$C7` | 15 | Above official dispatch range; classify per entry context. |
| `$E3` | 15 | Above official dispatch range; classify per entry context. |

## Groups with no residual markers

`EventScriptGroup_0E`

## Highest residual groups

| Group | Commands | Residual hits | Known % | Dominant category | Top residual bytes |
|---:|---:|---:|---:|---|---|
| `$47` | 657 | 30 | 95.434% | `short_script_then_inline_residual_payload` | $B4:30 |
| `$09` | 76 | 16 | 78.947% | `entry_starts_as_residual_table_or_pointer_row` | $5B:15 $5C:1 |
| `$15` | 62 | 16 | 74.194% | `short_script_then_inline_residual_payload` | $8E:15 $7B:1 |
| `$17` | 17 | 16 | 5.882% | `entry_starts_as_residual_table_or_pointer_row` | $E5:15 $B4:1 |
| `$24` | 36 | 16 | 55.556% | `entry_starts_as_residual_table_or_pointer_row` | $D5:12 $5F:2 $7B:1 $9B:1 |
| `$2E` | 32 | 16 | 50.000% | `short_script_then_inline_residual_payload` | $C7:15 $B4:1 |
| `$2F` | 17 | 16 | 5.882% | `entry_starts_as_residual_table_or_pointer_row` | $E3:15 $B4:1 |
| `$30` | 257 | 16 | 93.774% | `long_script_then_inline_residual_payload` | $B4:16 |
| `$31` | 17 | 16 | 5.882% | `entry_starts_as_residual_table_or_pointer_row` | $5F:15 $B4:1 |
| `$32` | 17 | 16 | 5.882% | `entry_starts_as_residual_table_or_pointer_row` | $76:15 $B4:1 |
| `$33` | 17 | 16 | 5.882% | `entry_starts_as_residual_table_or_pointer_row` | $EA:15 $B4:1 |
| `$34` | 34 | 16 | 52.941% | `short_script_then_inline_residual_payload` | $D0:15 $B4:1 |
| `$35` | 18 | 16 | 11.111% | `entry_starts_as_residual_table_or_pointer_row` | $80:15 $B4:1 |
| `$36` | 17 | 16 | 5.882% | `entry_starts_as_residual_table_or_pointer_row` | $EC:15 $B4:1 |
| `$37` | 19 | 16 | 15.789% | `entry_starts_as_residual_table_or_pointer_row` | $67:15 $B4:1 |
| `$38` | 32 | 16 | 50.000% | `short_script_then_inline_residual_payload` | $D5:15 $B4:1 |
| `$39` | 17 | 16 | 5.882% | `entry_starts_as_residual_table_or_pointer_row` | $92:15 $B4:1 |
| `$3A` | 32 | 16 | 50.000% | `short_script_then_inline_residual_payload` | $DC:14 $B4:2 |
| `$3B` | 18 | 16 | 11.111% | `entry_starts_as_residual_table_or_pointer_row` | $ED:14 $B4:2 |
| `$3C` | 18 | 16 | 11.111% | `entry_starts_as_residual_table_or_pointer_row` | $B4:16 |
| `$3D` | 32 | 16 | 50.000% | `short_script_then_inline_residual_payload` | $FF:14 $B4:2 |
| `$3E` | 32 | 16 | 50.000% | `short_script_then_inline_residual_payload` | $E4:15 $B4:1 |
| `$3F` | 32 | 16 | 50.000% | `short_script_then_inline_residual_payload` | $E7:15 $B4:1 |
| `$40` | 17 | 16 | 5.882% | `entry_starts_as_residual_table_or_pointer_row` | $CF:15 $B4:1 |

## Next manual pass

Recommended next step: inspect the largest `entry_starts_as_residual_table_or_pointer_row` groups first, because those are probably not script opcode gaps; they are likely content tables being reached by pointer export boundaries. After that, inspect the `inline_residual_payload` rows where valid script commands precede a residual marker.
