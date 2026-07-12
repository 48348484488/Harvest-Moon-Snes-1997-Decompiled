# Pseudocode - Bank 80 Pointer42 Map/Time Installers

```c
void PaletteAnim_RunMapTimeInstaller(void) {
    uint8_t bracket = 0;

    if (hour >= 7)  bracket++;
    if (hour >= 15) bracket++;
    if (hour >= 17) bracket++;
    if (hour >= 18) bracket++;

    uint16_t group_base = tilemap_to_load * 6;

    // Sixth word is not called. It is a seasonal gate flag.
    if (PaletteAnim_MapTimeInstallerTable[group_base + 5] != 0xFFFF) {
        if (season < 2) {
            return; // Spring/Summer
        }
    }

    uint16_t installer = PaletteAnim_MapTimeInstallerTable[group_base + bracket];
    if (installer != 0xFFFF) {
        call(installer);
    }
}
```

Each installer seeds Pointer42 slots through `PaletteAnim_SetPointer42Slot`:

```c
slot.script_ptr = bank80_script_pointer;
slot.color_index = A;
slot.slot_index = X;
slot.palette_row = Y;
slot.delay = 0;
```

The script command stream is the same engine documented in Pass 44: normal commands are `dw color` plus `db delay`, and `$FFFE` plus a 24-bit pointer loops/jumps.
