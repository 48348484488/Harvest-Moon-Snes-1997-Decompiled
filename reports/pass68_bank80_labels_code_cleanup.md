# Pass 68 - Bank 80 + labels.asm CODE cleanup
Pass 68 closes two concrete generic CODE areas while preserving byte-perfect rebuild semantics.
## Closed areas
- `bank_80.asm` generic `CODE_` symbols renamed: **157**.
- `src/labels.asm` low-bank generic `CODE_` aliases renamed: **21**.
- Total unique symbols renamed in this pass: **178**.
- Remaining unique `CODE_` symbols in `project_buildable/src`: **1288**.

## Naming policy
- Bank 80 branch labels use `Bank80_MainLogicBranch_80xxxx`.
- Low-bank player-action pointer aliases use `PlayerAction_LowBankDispatchAlias_00xxxx`.
- Other low-bank aliases use `LegacyLowBankCodeAlias_00xxxx`.

## Changed files
- `src/labels.asm`
- `src/code_banks/bank_80.asm`
- `src/code_banks/bank_81.asm`
