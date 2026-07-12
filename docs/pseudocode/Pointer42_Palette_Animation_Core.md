# Pseudocodigo - Pointer42 Palette Animation Core

```c
struct Pointer42Slot {
    uint24 script;
    uint8 delay;
    uint8 color_index;
    uint8 palette_row;
};

void PaletteAnim_SetPointer42Slot(uint8 slot, uint8 color_index, uint8 palette_row, uint24 script) {
    slot.color_index = color_index;
    slot.palette_row = palette_row;
    slot.delay = 0;
    slot.script = script;
}

void PaletteAnim_UpdatePointer42Slots(void) {
    bool any_update = false;

    for (slot = first_active_slot_for_weather(); slot < 0x10; slot++) {
        if (slot.script == 0) {
            continue;
        }

        uint16 command = read_word(slot.script);

        if (command == 0xFFFF) {
            slot.script = 0;
            continue;
        }

        if (command == 0xFFFE) {
            slot.script = read_long24(slot.script + 2);
            command = read_word(slot.script);
        }

        if (slot.delay != 0) {
            slot.delay--;
            continue;
        }

        PaletteBuffer_WriteColorToSelectedBuffer(
            color = command,
            x = slot.color_index,
            y = slot.palette_row
        );

        slot.delay = read_byte(slot.script + 2);
        slot.script += 3;
        any_update = true;
    }

    if (any_update) {
        queue_cgram_dma(source = 0x7F0900, size = 0x0100);
    }
}
```
