# EventScript Residual Classifier - Pass 73

The classifier reads all EventScript group pointer tables B3-B5 and decodes each target with the official `$00-$59` command table.

When the scanner reaches a byte above `$59`, the byte is not treated as an official opcode. It is recorded as a residual marker and categorized by context:

| Category | Meaning |
|---|---|
| `entry_starts_as_residual_table_or_pointer_row` | Pointer target begins with a byte above `$59`; likely data/table row, pointer row, or non-script body. |
| `short_script_then_inline_residual_payload` | A short valid script prefix reaches residual bytes. |
| `long_script_then_inline_residual_payload` | A longer valid script reaches residual bytes. |
| `short_tail_after_valid_script_prefix` | Valid script reaches a very short tail, often padding or boundary data. |
| `official_opcode_metadata_gap` | Should remain zero after Pass 73. |

This does not modify ROM bytes; it improves the handoff layer for future manual naming of scripts/events/NPCs.
