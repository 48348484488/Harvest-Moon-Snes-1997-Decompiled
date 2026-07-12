# Pass 77 - EventScript final residual closure

Pass 77 fixes the last symbolic payload-length mismatches that made inline payload bytes look like unknown EventScript opcodes. No new official opcode above `$59` is invented; the official EventCmd dispatch table remains `$00-$59` and 90/90 covered.

- ROM MD5: `c9bf36a816b6d54aed79d43a6c45111a`
- EventCmd dispatch audit: `90/90`
- Pass 76 final residual target: `6`
- Pass 77 true in-group non-B4 residuals: `0`
- Raw unknown markers still classified as boundary/B4 artifacts: `890`
- Commands/markers under corrected model: `12948`
- Effective EventScript coverage: `100.000%`
- Groups residual-free: `72/72`

## Payload model corrections

| Opcode | Name | Before | After | Reason |
|---:|---|---:|---:|---|
| `$00` | `PlayAudioOrMusic` | 1 | 2 | Handler reads one audio/control byte and advances one extra stream byte; that skipped byte is inline control/padding, not a new opcode. |
| `$39` | `SetCCObjectParam6` | 4 | 3 | Handler uses one state/mask byte plus a 16-bit timer/value; previous model swallowed the next command byte. |
| `$3A` | `SetCCObjectParam7` | 4 | 3 | Same slot-state/timer pattern as $39; previous model swallowed the next command byte. |
| `$3F` | `DropItemAnimation` | 1 | 0 | Handler only advances past the opcode and sets player_action=$0005; following byte is the next EventCmd. |
| `$49` | `SetCCObjectParam9` | 3 | 2 | Handler reads a 16-bit visual/state pointer into slot+$33; there is no third mode byte. |

## Closure result

| Metric | Before | After | Status |
|---|---:|---:|---|
| EventCmd dispatch audit | 90/90 | 90/90 | 100% maintained |
| Pass 76 remaining EventScript residuals | 6 | 0 | closed |
| Effective EventScript coverage | 99.937% | 100.000% | closed |
| Residual-free groups | 69/72 | 72/72 | closed |

## Remaining true residual bytes

None. The corrected effective EventScript accounting has zero true in-group non-B4 residual rows.

## Raw marker accounting

| Category | Count | Treatment |
|---|---:|---|
| Cross-group/boundary/table artifacts | 890 | Not real EventCmd gaps |
| `$B4` inline tile/object payload rows | 0 | Already classified as inline payload |
| True in-group non-B4 residuals | 0 | Closed |

## Closed Pass 76 rows

| Group | Entry | Target | Residual addr | Residual byte | Closure reason |
|---:|---:|---:|---:|---:|---|
| `$00` | 20 | `$B38DD1` | `$B38DD7` | `$81` | $49 payload length corrected from 3 to 2; $81 is high byte of the 16-bit pointer, not opcode. |
| `$09` | 0 | `$B3E623` | `$B3E6D2` | `$5C` | $00 payload length corrected from 1 to 2; $5C is the skipped/control byte after the audio id. |
| `$24` | 0 | `$B4A475` | `$B4A486` | `$7B` | $3A payload length corrected from 4 to 3; stream realigns to $07 then $1B. |
| `$24` | 1 | `$B4A531` | `$B4A542` | `$9B` | $3A payload length corrected from 4 to 3; stream realigns to $07 then $1B. |
| `$24` | 2 | `$B4A55D` | `$B4A56E` | `$5F` | $3A payload length corrected from 4 to 3; stream realigns to $07 then $1B. |
| `$24` | 3 | `$B4A589` | `$B4A59A` | `$5F` | $3A payload length corrected from 4 to 3; stream realigns to $07 then $1B. |
