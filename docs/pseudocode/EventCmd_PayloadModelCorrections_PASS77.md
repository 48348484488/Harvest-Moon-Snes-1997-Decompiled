# EventCmd payload model corrections - Pass 77

Pass 77 corrects five symbolic payload lengths by checking the Bank 84 handlers.

| Opcode | Correct model | Notes |
|---:|---|---|
| `$00` | `PlayAudioOrMusic(id, control)` | Handler reads one byte and advances one extra byte. |
| `$39` | `SetCCObjectParam6(mask, timer_word)` | Previous 4-byte model consumed the next opcode. |
| `$3A` | `SetCCObjectParam7(mask, timer_word)` | Same slot-state/timer pattern as `$39`. |
| `$3F` | `DropItemAnimation()` | No payload. Sets player action state. |
| `$49` | `SetCCObjectParam9(ptr_word)` | Reads a 16-bit pointer into slot state. |

These corrections close the last six effective in-group residuals from Pass 76.
