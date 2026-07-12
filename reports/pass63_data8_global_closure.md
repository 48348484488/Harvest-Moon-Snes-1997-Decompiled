# PASS 63 - Global DATA8 Alias Closure

## Goal

Close the remaining `DATA8_` generic aliases in `src` while preserving the byte-perfect USA rebuild.

## Result

| Area | Before Pass 63 | After Pass 63 | Status |
|---|---:|---:|---|
| `DATA8_` generic labels in `project_buildable/src` | 121 | 0 | 100% closed |
| `DATA8_` generic labels in `source_decompilada/src` | 121 | 0 | 100% closed |
| `SUB_` generic labels in ASM | 0 | 0 | still closed |
| `DATA16_` generic labels in ASM | 0 | 0 | still closed |
| `UNK_` generic labels in ASM | 0 | 0 | still closed |
| Rebuild byte-perfect | OK | OK | preserved |

## What changed

- Replaced orphan/legacy low-bank `DATA8_00xxxx` aliases in `src/labels.asm` with `LegacyLowBankAlias_00xxxx` names.
- Replaced legacy commented `DATA8_00xxxx` entries in the EventInstructionPointers comment block with `LegacyEventCmdAlias_00xxxx`.
- No executable instruction bytes or data bytes were changed.

## Generic count after Pass 63

| Prefix | Unique labels | Occurrences |
|---|---:|---:|
| `DATA8_` | 0 | 0 |
| `DATA16_` | 0 | 0 |
| `SUB_` | 0 | 0 |
| `UNK_` | 0 | 0 |
| `CODE_` | 2322 | 6101 |

## Validation

```text
MD5 original: c9bf36a816b6d54aed79d43a6c45111a
MD5 rebuild:  c9bf36a816b6d54aed79d43a6c45111a
Result: OK, byte-perfect rebuild preserved.
```

## Remaining work

- `CODE_` labels still require semantic naming.
- EventScript unknown opcode clusters still need manual decode.
- NPC/sprite/GOBJ behavior documentation remains the largest human-decompilation gap.
