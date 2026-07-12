# STATUS PASS73 - EventScript Residual Classification

Pass 73 closes the remaining official EventCmd metadata/class gap and separates residual bytes from actual opcode coverage.

## Closed

- Official EventCmd dispatch audit remains 90/90.
- Official opcode metadata gaps inside `$00-$59`: 0.
- EventCmd `$0D` now belongs to the `cc_state_object` semantic class.
- Residual bytes reached by the conservative linear scanner are now categorized as boundary/data candidates instead of being mixed with official opcode gaps.

## Current measured numbers

| Metric | Value |
|---|---:|
| EventScript groups scanned | 72 |
| Pointer entries decoded | 1288 |
| Symbolic commands/markers at max depth 128 | 8590 |
| Known symbolic commands | 7603 |
| Residual markers above `$59` | 987 |
| Official opcode metadata gaps `$00-$59` | 0 |
| Symbolic known percent | 88.510% |

The remaining residual markers are not missing official VM opcodes. They are candidates for inline data, table rows, pointer rows, or script boundary artifacts.
