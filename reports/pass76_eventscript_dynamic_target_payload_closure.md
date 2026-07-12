# Pass 76 - EventScript dynamic target payload closure

Pass 76 corrects the symbolic payload model for EventCmd `$1E` and `$1F`. The Bank 84 handlers increment past the opcode and then either read the following 16-bit word as the next script pointer, or skip that word while waiting for the interaction/player-state gate. Earlier tools modeled `$1F` as zero-payload, so the low byte of this target word appeared as a false unknown opcode.

- ROM MD5: `c9bf36a816b6d54aed79d43a6c45111a`
- Pass 75 non-B4 residuals before this fix: `26`
- Residuals closed by `$1E/$1F` dynamic target payload model: `20`
- Remaining non-B4 residuals after this fix: `6`
- Raw symbolic commands/markers after corrected model: `9572`
- Effective EventScript coverage after Pass 76: `99.937%`
- Groups closed at residual level: `69/72`

## Closure result

| Metric | Before | After | Status |
|---|---:|---:|---|
| EventCmd dispatch audit | 90/90 | 90/90 | 100% maintained |
| Pass 75 non-B4 residuals | 26 | 6 | reduced |
| Closed as `$1E/$1F` target payload | 0 | 20 | closed |
| Effective EventScript coverage | 99.697% | 99.937% | improved |
| Groups closed at residual level | 63/72 | 69/72 | improved |

## Remaining groups

| Group | Remaining residuals | Notes |
|---:|---:|---|
| `$24` | 4 | inspect non-B4 inline payload/table tail |
| `$00` | 1 | inspect non-B4 inline payload/table tail |
| `$09` | 1 | inspect non-B4 inline payload/table tail |

## Remaining residual bytes

| Byte | Hits |
|---:|---:|
| `$5F` | 2 |
| `$81` | 1 |
| `$5C` | 1 |
| `$7B` | 1 |
| `$9B` | 1 |

## Technical note

The closed rows were not real EventCmd gaps. They were target low bytes immediately after `$1E/$1F`, especially in family/NPC dialogue scripts. The corrected symbolic model now emits `WaitForInteractionReadyThenJump(target=$xxxx)` and `WaitForInteractionReadyThenJumpDuplicate(target=$xxxx)`.

## Next pass target

The next useful target is the final 6 residual rows in groups `$00`, `$09`, and `$24`. These are not official opcode gaps; they look like short inline payload/table tails after valid prefixes and need target-specific handler tracing.
