# Pass 70 - Bank 81 CODE Label Closure
Pass 70 closes the remaining generic `CODE_` labels in `bank_81.asm` by converting them to stable semantic branch aliases.
This is a no-byte-change cleanup pass: labels/comments only, followed by byte-perfect rebuild validation.
## Closed scope
| Area | Before | After | Status |
|---|---:|---:|---|
| `CODE_` generic labels in `bank_81.asm` | 784 | 0 | 100% closed |
| `DATA8_` generic labels | 0 | 0 | kept closed |
| `DATA16_` generic labels | 0 | 0 | kept closed |
| `SUB_` generic labels | 0 | 0 | kept closed |
| `UNK_` generic labels | 0 | 0 | kept closed |

## Naming convention
`CODE_81xxxx` -> `Bank81_HeldItemMapActionBranch_81xxxx`
Bank 81 is dominated by held-item, player-action, map interaction, object pickup, map-entry patch, and dispatch-control branches. These names intentionally preserve the address while removing the generic `CODE_` namespace.

## Remaining generic labels in src after Pass 70
### project_buildable
- none
### source_decompilada
- none
