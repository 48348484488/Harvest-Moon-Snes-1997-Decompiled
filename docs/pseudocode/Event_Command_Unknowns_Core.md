# Pseudocode - Remaining Event Command Unknowns Core

## EventCmd_37_ClearAttachedObjectSlot

```text
function EventCmd_37_ClearAttachedObjectSlot(slot):
    script_ptr += 1
    attached_obj_slot = slot.word[0x12]
    scratch_A5 = attached_obj_slot
    GameOBJ_ClearSlotAndReleaseComponents(scratch_A5)
```

## EventCmd_38_WaitForFieldMenuGateFlag

```text
function EventCmd_38_WaitForFieldMenuGateFlag(slot):
    if flags_7F1F5A & 0x8000:
        script_ptr += 1
    else:
        slot.word[0x10] += 1
```

## EventCmd_4A_GiveHeldItem08OnAButton

```text
function EventCmd_4A_GiveHeldItem08OnAButton(slot):
    script_ptr += 1

    if slot.byte[0x0C] == 0:
        slot.word[0x10] += 1
        return

    if player_action in [0x000A, 0x000C, 0x000D, 0x001B, 0x0017]:
        slot.word[0x10] += 1
        return

    if game_state & 0x0004:
        slot.word[0x10] += 1
        return

    if flags_7F1F60 & 0x0006:
        slot.word[0x10] += 1
        return

    if !(Joy1_New_Input & 0x0080):
        slot.word[0x10] += 1
        return

    if game_state & 0x0800:
        slot.word[0x10] += 1
        return

    if item_on_hand != 0:
        slot.word[0x10] += 1
        return

    slot.byte[0x00] = 0
    slot.byte[0x01] |= 0x40
    slot.word[0x10] += 1
    item_on_hand = 0x08
    player_action = 0x0004
```
