# Pass 59 Generic Label Closure Report

Pass 59 closes two concrete cleanup buckets to **100%** while keeping the rebuild byte-perfect:

- generic `SUB_` routine labels in `src/**/*.asm`;
- generic `DATA16_` labels in `src/**/*.asm`.

## Result

| Bucket | Before Pass 59 | After Pass 59 | Status |
|---|---:|---:|---|
| Generic `SUB_` labels in source ASM | 8 unique labels | 0 | 100% closed |
| Generic `DATA16_` labels in source ASM | 6 unique labels | 0 | 100% closed |
| Rebuild MD5 | `c9bf36a816b6d54aed79d43a6c45111a` | `c9bf36a816b6d54aed79d43a6c45111a` | byte-perfect |

## Renames

| Old label | New label | File | Address | Reason |
|---|---|---|---|---|
| `SUB_809A64` | `MapTransition_CheckEdgeTriggerAndQueueDestination` | `bank_80.asm` | `$80:9A64` | Main-loop door/edge trigger gate; queues transition destination and time/day restrictions. |
| `SUB_809D0B` | `MapScroll_UpdateFarEdgeOutdoorRightStream` | `bank_80.asm` | `$80:9D0B` | Far-edge outdoor camera/stream helper; updates BG1 X offset and streams columns while moving right/edge side. |
| `SUB_80A152` | `MapScroll_UpdateFarEdgeOutdoorLeftStream` | `bank_80.asm` | `$80:A152` | Companion far-edge camera/stream helper; updates BG1 X offset and streams columns while moving left. |
| `SUB_81809A` | `HeldItem_DispatchActionAndClearUseFlag_Unused` | `bank_81.asm` | `$81:809A` | Unused/legacy held-item action dispatch wrapper that clears the item-use flag. |
| `SUB_82878E` | `Debug_InfiniteLoopBugTrap` | `bank_82.asm` | `$82:878E` | One-byte infinite loop trap preserved as original bug/dead code. |
| `SUB_82D1C0` | `NewGame_ResetSaveStateAndEnterFarmLoop` | `bank_82.asm` | `$82:D1C0` | New-game state reset: clears flags, initializes farm data and enters the first farm loop. |
| `SUB_82E1F1` | `SaveLoadMenu_LoadSlotSelectSceneAndLoop` | `bank_82.asm` | `$82:E1F1` | Loads the save-slot selection scene, draws summaries and enters the slot-select runtime loop. |
| `SUB_82E3D1` | `SaveLoadMenu_SlotSelectLoopTick` | `bank_82.asm` | `$82:E3D1` | Frame tick for the save-slot select scene; animates BG and dispatches selected action. |
| `DATA16_81B963` | `MapTilePatchScript_LongPointerTable` | `bank_81.asm` | `$81:B963` | 24-bit long pointer table used by MapTilePatchScript_StartByIndex. |
| `DATA16_81FAB4` | `MapObject_PickupAvailableBitMaskTable` | `bank_81.asm` | `$81:FAB4` | Set-bit mask table used by pickup/object availability checks. |
| `DATA16_81FAD4` | `MapObject_PickupClearBitMaskTable` | `bank_81.asm` | `$81:FAD4` | Clear-bit mask table used after pickup/object removal. |
| `DATA16_84B4D2` | `EventCmd_PlayerStateBitMaskTable` | `bank_84.asm` | `$84:B4D2` | Bit mask table used by EventCmd_39/3A state gating commands. |
| `DATA16_84C014` | `EventCmd_GenericBitMaskTable16` | `bank_84.asm` | `$84:C014` | Generic 16-bit bitmask table used by event command logic. |
| `DATA16_B8B480` | `Text_20D_Dialog_PleasePickUpWhatYouLike` | `bank_B8.asm` | `$B8:B480` | Dialog text 20D: "Please pick up what you like." |

## Validation commands

```bash
grep -Roh --include='*.asm' '\bSUB_[0-9A-Fa-f]\+' src | sort -u
grep -Roh --include='*.asm' '\bDATA16_[0-9A-Fa-f]\+' src | sort -u
./build_linux.sh
```

Both generic-label checks should return no labels. The build must produce the same MD5 as the clean USA ROM.
