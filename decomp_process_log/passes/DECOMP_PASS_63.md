# DECOMP PASS 63 - Global DATA8 Alias Closure

## Goal

Close a concrete remaining cleanup area: all remaining `DATA8_` generic aliases in both source trees.

## Result

| Area | Before | After | Status |
|---|---:|---:|---|
| `DATA8_` generics in `project_buildable/src` | 121 | 0 | 100% closed |
| `DATA8_` generics in `source_decompilada/src` | 121 | 0 | 100% closed |
| `SUB_` generics in ASM | 0 | 0 | still closed |
| `DATA16_` generics in ASM | 0 | 0 | still closed |
| `UNK_` generics in ASM | 0 | 0 | still closed |
| Rebuild byte-perfect | OK | OK | preserved |

## Main changes

- Renamed orphan low-bank aliases from `DATA8_00xxxx` to `LegacyLowBankAlias_00xxxx`.
- Renamed legacy EventInstructionPointers comment aliases from `DATA8_00xxxx` to `LegacyEventCmdAlias_00xxxx`.
- The pass is label/comment cleanup only. No ROM bytes changed.

## Validation

```text
MD5 original: c9bf36a816b6d54aed79d43a6c45111a
MD5 rebuild:  c9bf36a816b6d54aed79d43a6c45111a
Result: OK, byte-perfect rebuild preserved.
```

## Remaining generic cleanup

- `DATA8_`: 0 unique remaining in `src`.
- `DATA16_`: 0 unique remaining in `src`.
- `SUB_`: 0 unique remaining in `src`.
- `UNK_`: 0 unique remaining in `src`.
- `CODE_`: still open and should be reduced by semantic clusters.
