# DECOMP PASS 77 - EventScript Final Residual Closure

Pass 77 closes the final effective EventScript residual target left by Pass 76.

## What changed

- Corrected symbolic payload lengths for EventCmd `$00`, `$39`, `$3A`, `$3F`, and `$49`.
- Preserved the official EventCmd dispatch coverage at `90/90`.
- Closed the final `6` true in-group non-B4 EventScript residual rows.
- Kept raw boundary/table markers classified as artifacts, not missing opcodes.
- Kept the rebuild byte-perfect against the clean USA ROM.

## Payload corrections

| Opcode | Before | After | Meaning |
|---:|---:|---:|---|
| `$00` | 1 | 2 | audio/control byte plus skipped inline control byte |
| `$39` | 4 | 3 | slot-state mask plus 16-bit timer/value |
| `$3A` | 4 | 3 | slot-state mask plus 16-bit timer/value |
| `$3F` | 1 | 0 | no payload; sets drop-item/player action state |
| `$49` | 3 | 2 | 16-bit visual/state pointer only |

## Result

| Metric | Before | After |
|---|---:|---:|
| EventCmd dispatch audit | 90/90 | 90/90 |
| True in-group non-B4 residuals | 6 | 0 |
| Effective EventScript coverage | 99.937% | 100.000% |
| Residual-free EventScript groups | 69/72 | 72/72 |

## Validation

`MD5 original = c9bf36a816b6d54aed79d43a6c45111a`

`MD5 rebuild  = c9bf36a816b6d54aed79d43a6c45111a`

Result: OK, byte-perfect rebuild maintained.
