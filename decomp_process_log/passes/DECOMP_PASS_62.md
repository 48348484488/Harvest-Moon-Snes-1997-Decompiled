# DECOMP PASS 62 - Bank 81 DATA8 Dispatch Alias Closure

## Goal

Close one more concrete decompilation area without changing ROM bytes: every remaining `DATA8_` alias referenced inside `src/code_banks/bank_81.asm`.

## Result

Pass 62 renamed all remaining Bank 81 `DATA8_` dispatch aliases into contextual labels.

| Area | Before | After | Status |
|---|---:|---:|---|
| `DATA8_` aliases referenced by `bank_81.asm` | 82 | 0 | 100% closed |
| Map-entry tile-patch dispatch aliases | 56 | 0 generic | 100% closed |
| Player-action dispatch aliases | 26 | 0 generic | 100% closed |
| `SUB_` generic labels in `src` | 0 | 0 | still closed |
| `DATA16_` generic labels in `src` | 0 | 0 | still closed |
| Rebuild byte-perfect | OK | OK | preserved |

## Main renamed groups

- `DATA8_00B121`..`DATA8_00B2BA` -> `MapEntryTilePatch_DispatchArea28`..`MapEntryTilePatch_DispatchArea5F`
- `DATA8_00DD62` -> `PlayerAction_PickupMapObjectItem74`
- `DATA8_00DD87` -> `PlayerAction_PickupMapObjectItem75`
- `DATA8_00DDAC` -> `PlayerAction_ShopOrNpcPurchaseDialogEntry2E`
- `DATA8_00DE1C` -> `PlayerAction_ShopOrNpcPurchaseDialogEntry2F`
- `DATA8_00E245`..`DATA8_00EBD5` -> contextual `PlayerAction_DispatchEntry30`..`PlayerAction_DispatchEntry45`

## Validation

The rebuilt ROM remains byte-identical to the clean USA ROM.

```text
MD5 original: c9bf36a816b6d54aed79d43a6c45111a
MD5 rebuild:  c9bf36a816b6d54aed79d43a6c45111a
Result: OK, byte-perfect rebuild preserved.
```

## Notes

This pass is label-only/comment-only. It does not alter executable bytes or data bytes.
