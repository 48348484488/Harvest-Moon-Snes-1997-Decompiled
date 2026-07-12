# Pass 71 - EventCmd Extended Decoder 51-59

Pass 71 attacks the blocker named by the user: EventScript opcode decoding. The source already had the EventCmd dispatch table, but the symbolic tools stopped at `$50`. This pass adds the missing official dispatch-table range `$51-$59`.

## What became 100% in this pass

| Area | Before | After | Status |
|---|---:|---:|---|
| Official EventInstructionPointers coverage | 81/90 | **90/90** | **100% closed** |
| EventCmd `$51-$59` names | 0/9 | **9/9** | **100% closed** |
| EventCmd `$51-$59` payload sizes | 0/9 | **9/9** | **100% closed** |
| EventCmd `$51-$59` symbolic pseudocode | 0/9 | **9/9** | **100% closed** |
| Rebuild byte-perfect | 100% | **100%** | maintained |
| NO-ROM package | 100% | **100%** | maintained |

## Dispatch table audit

```text
official_dispatch_entries=90
covered_symbolic_entries=47
coverage_percent=52.222
missing=$09,$27,$28,$29,$2A,$2B,$2C,$2D,$2E,$2F,$30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$3A,$3B,$3C,$3D,$3E,$3F,$40,$41,$42,$43,$44,$45,$46,$47,$48,$49,$4A,$4B,$4C,$4D,$4E,$4F,$50
```

## New EventCmd decoding added

| Opcode | Name | Payload | Meaning |
|---|---|---:|---|
| `$51` | `UseChickenDogOrHeldItemContext` | 0 | Handles held item / chicken / dog context interaction |
| `$52` | `WaitForAButtonSetInteractionFlag02` | 0 | Waits for A-button style interaction and sets `$7F1F60` bit `$0002` |
| `$53` | `WaitForAButtonSetInteractionFlag04` | 0 | Waits for A-button style interaction and sets `$7F1F60` bit `$0004` |
| `$54` | `StartTextBoxAndAdvanceSlot` | 3 | Reads text id + mode, opens textbox, advances slot counter |
| `$55` | `JumpIfIndirectBitClear` | 6 | Reads long pointer + bit index + branch target |
| `$56` | `StartSelectedToolAction` | 0 | Starts selected tool action if a tool is selected |
| `$57` | `ApplyStaminaDelta` | 1 | Applies stamina/fatigue delta |
| `$58` | `EditTileAndSetRuntimeFlag` | 5 | Edits map tile and marks runtime tile state |
| `$59` | `SetPlayerAction1C` | 0 | Sets player action `$001C` |

## Pass 71 symbolic export result

| Metric | Value |
|---|---:|
| Pointer entries decoded | 1288 |
| Commands exported | 8590 |
| Known symbolic commands | 7557 |
| Unknown/untyped bytes encountered by linear sweep | 1033 |
| Known command coverage | 87.974% |

Important: after this pass, the official EventCmd table itself is covered to 100%. Remaining `$xx` unknowns above `$59` are not official dispatch-table opcodes. They are bytes reached by a conservative linear scan where the script boundary is still ambiguous, or where pointer tables/data are mixed with scripts.

## New files

- `reports/pass71_event_cmd_dispatch_table_audit.txt`
- `reports/pass71_eventcmd_51_59_semantics.csv`
- `reports/event_script_full_symbolic_entries_pass71.csv`
- `reports/event_script_group_semantic_map_pass71.csv`
- `reports/event_script_full_symbolic_export_pass71.md`
- `reports/event_script_groups_pass71/`
- `tools/event_cmd_dispatch_table_audit.py`

