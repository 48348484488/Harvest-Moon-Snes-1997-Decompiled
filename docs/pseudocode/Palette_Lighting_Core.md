# Pseudocodigo - Palette / Lighting Core

```c
void Palette_SetPendingTransitionIfHourChanged() {
    int bucket = HourToPaletteBucket(hour);
    int palette_id = Palette_TimeOfDayByMapTable[tilemap_to_load * 6 + bucket];

    if (palette_id == 0xFF) return;
    if (palette_id == palette_to_load) return;

    PaletteTransition_BeginTimeOfDayFade(palette_id);
    palette_to_load = palette_id;
}

void PaletteTransition_BeginTimeOfDayFade(int palette_id) {
    next_hourly_palette = palette_id;
    palette_change_countdown = 0;

    if (hour >= 18) {
        palette_change_pointer = 0x7F0B00; // noite usa buffer ja preparado
    } else {
        palette_change_pointer = Palette_PointerTable[palette_id];
    }
}

void PaletteTransition_StepTimeOfDayFade() {
    if (!(time_running & 1)) return;
    if (!palette_change_pointer) return;

    palette_change_countdown++;
    if (palette_change_countdown != 0x20) return;
    palette_change_countdown = 0;

    int size = (hour >= 18) ? 0x0200 : 0x0100;
    bool changed = false;

    for (int off = 0; off < size; off += 2) {
        uint16 current = WRAM_7F0D00[off / 2];
        uint16 target  = palette_change_pointer[off / 2];

        uint16 stepped = StepRGB555OneUnit(current, target, &changed);
        WRAM_7F0900[off / 2] = stepped;
        WRAM_7F0D00[off / 2] = stepped;
    }

    if (!changed) {
        PaletteTransition_CommitLoadedPaletteIndex();
        return;
    }

    QueueCgramDma(src = 0x7F0900, dest = 0x0000, size = size);
}

void Palette_LoadTimeOfDayForCurrentMap() {
    int bg_id = Palette_TimeOfDayByMapTable[tilemap_to_load * 6 + 4];
    LoadPaletteHalf(bg_id, dst = 0x7F0B00, half = BG);

    int obj_id = Palette_OBJHalfByMapDayNightTable[tilemap_to_load * 2 + IsNight()];
    LoadPaletteHalf(obj_id, dst = 0x7F0B00 + 0x0100, half = OBJ);

    Palette_ApplySeasonWifeAndNightSpriteOverrides();
}

void Palette_ApplySeasonWifeAndNightSpriteOverrides() {
    ApplySeasonalOrNightSpriteColors();

    if (wife_pregnancy != 0) {
        int wife_id = MarriageFlagsToWifeIndex(marriage_flags);
        ApplyWifePregnancyPaletteTriples(wife_id);
    }
}
```
