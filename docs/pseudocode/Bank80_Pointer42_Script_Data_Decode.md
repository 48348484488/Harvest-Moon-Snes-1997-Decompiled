# Pseudocodigo - Bank 80 Pointer42 Script Data Decode

```c
struct Pointer42ScriptStep {
    uint16 rgb555_color;
    uint8 delay;
};

void RunPointer42Script(Pointer42Slot *slot) {
    uint16 word = read16(slot->script_ptr);

    if (word == 0xFFFF) {
        slot->script_ptr = 0;
        return;
    }

    if (word == 0xFFFE) {
        slot->script_ptr = read24(slot->script_ptr + 2);
        return;
    }

    if (slot->delay != 0) {
        slot->delay--;
        return;
    }

    PaletteBuffer_WriteColor(
        slot->palette_row,
        slot->color_index,
        word
    );

    slot->delay = read8(slot->script_ptr + 2);
    slot->script_ptr += 3;
}
```

Na Pass 46, o bloco `$80:DD5B-$80:EF1B` foi convertido de `db` bruto para labels `PaletteAnimScript_XXXX` com comandos explicitos.
