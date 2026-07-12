# Pseudocódigo — Event Script Core

```text
function EventScript_UpdateAllActiveSlots():
    if inputstate == NO_CONTROL_SPECIAL:
        clear_transient_event_flags()
        return

    rng_seed = GetRNG()

    for slot_index in 0..0x30:
        slot = event_slots[slot_index]

        if not slot.active:
            continue

        if slot.wait_timer > 0:
            slot.wait_timer -= 1
        else:
            while slot.wait_timer == 0 and slot.active:
                EventScript_ExecuteNextOpcode(slot)

        if slot.has_object:
            EventScript_UpdateAttachedObjectState(slot)

    clear_transient_event_flags()
```

```text
function EventScript_ExecuteNextOpcode(slot):
    ptr = slot.script_pointer
    bank = slot.script_bank

    opcode = read_u8(bank, ptr)
    handler = EventInstructionPointers[opcode]

    handler(slot)

    slot.script_pointer = ptr_after_handler
    slot.script_bank = bank_after_handler
```

```text
command 12 Jump:
    ptr += 1
    destination = read_u16(script, ptr)
    slot.script_pointer = destination
```

```text
command 14 JumpIfFlagSet:
    ptr += 1
    address = read_u24(script, ptr)
    bit_index = read_u8(script, ptr + 3)
    destination = read_u16(script, ptr + 4)

    if memory[address] has bit bit_index:
        slot.script_pointer = destination
    else:
        slot.script_pointer += 6
```

```text
command 1C StartTextBox:
    ptr += 1
    text_id = read_u16(script, ptr)
    mode = read_u8(script, ptr + 2)
    TextBox_StartByTextId(text_id, mode)
    pause_or_wait_until_text_finishes()
```

```text
command 23 SetFlag:
    ptr += 1
    address = read_u24(script, ptr)
    bit_index = read_u8(script, ptr + 3)
    memory[address] |= (1 << bit_index)
    ptr += 4
```

```text
command 4B EditTileOnMap:
    ptr += 1
    tile_id = read_u8(script, ptr)
    x = read_u16(script, ptr + 1)
    y = read_u16(script, ptr + 3)
    map_tiles[x, y] = tile_id
    ptr += 5
```
