# Pass 62 - Bank 81 DATA8 Dispatch Alias Cleanup

Scope: rename every remaining `DATA8_` alias referenced by `src/code_banks/bank_81.asm`.

This pass is intentionally byte-safe: it only changes symbolic labels and comments. The table contents and assembled bytes are unchanged.

- Map entry tile-patch dispatch aliases renamed: 56
- Player action dispatch aliases renamed: 26
- Total `DATA8_` aliases removed from bank_81 references: 82

Result target: `grep DATA8_ src/code_banks/bank_81.asm` should return zero matches.
