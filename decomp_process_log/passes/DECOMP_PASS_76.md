# DECOMP PASS 76 - EventScript dynamic target payload closure

Pass 76 continues from Pass 75 and closes the dominant remaining non-B4 EventScript residual pattern.

## Main result

The symbolic decoder now models EventCmd `$1E` and `$1F` as commands with a dynamic 16-bit target payload. Bank 84 shows that these handlers either load the following word as the next script pointer or skip it while the interaction/player-state gate is not ready. Earlier tooling treated `$1F` as zero-payload, so the low byte of this target word appeared as a false unknown opcode.

## Metrics

| Metric | Before Pass 76 | After Pass 76 |
|---|---:|---:|
| EventCmd dispatch audit | 90/90 | 90/90 |
| Pass 75 non-B4 residuals | 26 | 6 |
| Residuals closed by `$1E/$1F` target payload model | 0 | 20 |
| Effective EventScript coverage | 99.697% | 99.937% |
| Groups closed at residual level | 63/72 | 69/72 |
| Rebuild byte-perfect | 100% | 100% |

## Tool changes

- Updated `tools/event_script_symbolic_disasm.py`:
  - `$1E` payload length: 2 bytes
  - `$1F` payload length: 2 bytes
  - `$1E` name: `WaitForInteractionReadyThenJump`
  - `$1F` name: `WaitForInteractionReadyThenJumpDuplicate`
- Added `tools/event_script_dynamic_target_payload_classifier_pass76.py`.

## Remaining target

Only 6 non-B4 residual rows remain after this pass, in groups `$00`, `$09`, and `$24`. These are not official opcode gaps; they are short inline payload/table tails after valid prefixes and need target-specific handler tracing.
