# STATUS PASS 62

Closed in Pass 62:

- `bank_81.asm` no longer references any `DATA8_` labels.
- 56 map-entry tile-patch aliases renamed.
- 26 player-action dispatch aliases renamed.
- Rebuild remains byte-perfect.
- `SUB_`, `DATA16_`, and `UNK_` remain at zero in `src`.

Still open after Pass 62:

- Global `DATA8_` aliases outside Bank 81: 121 unique labels.
- Many `CODE_` labels still need semantic names.
- EventScript individual scene/opcode interpretation still needs deeper passes.
