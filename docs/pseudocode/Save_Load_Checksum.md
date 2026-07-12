# Pseudocode - Save / Load / Checksum

## SaveSystem_SaveSlot

```c
void SaveSystem_SaveSlot(int slot_id) {
    uint8 *slot = SRAM_70 + (slot_id ? 0x1000 : 0x0000);

    slot[0x0000] = year;
    slot[0x0001] = season;
    slot[0x0002] = weekday;
    slot[0x0003] = day;

    slot[0x0004] = seeds_grass_N;
    slot[0x0005] = seeds_corn_N;
    slot[0x0006] = seeds_tomato_N;
    slot[0x0007] = seeds_potato_N;
    slot[0x0008] = seeds_turnip_N;

    slot[0x0009] = feed_cow_N;
    slot[0x000A] = feed_chicks_N;
    slot[0x000B] = cow_N;
    slot[0x000C] = chicks_N;
    slot[0x000D] = weather_tomorrow;
    slot[0x000E] = max_stamina;
    slot[0x000F] = tool_selected;
    slot[0x0010] = watering_can_water;

    copy_names_and_family_fields(slot);
    copy_tool_shed_bitfields(slot + 0x0084);
    copy_chickens(slot + 0x0098, chicken_array, 13 * 8);
    copy_cows(slot + 0x0100, cow_array, 12 * 16);
    copy_farm_map(slot + 0x01C0, farm_map_array + 0x00C0, 0x0E40);

    write_signature(slot + 0x003C, "FARM");
    write_u16(slot + 0x002F, calc_save_checksum(slot));
}
```

## SaveSystem_LoadFullSlot

```c
void SaveSystem_LoadFullSlot(int slot_id) {
    uint8 *slot = SRAM_70 + (slot_id ? 0x1000 : 0x0000);

    if (!slot_has_valid_signature_and_checksum(slot)) {
        repair_or_clear_slot(slot);
    }

    year = slot[0x0000];
    season = slot[0x0001];
    weekday = slot[0x0002];
    day = slot[0x0003];

    restore_counts_money_hearts_names(slot);
    restore_tool_shed_bitfields(slot + 0x0084);
    copy_chickens(chicken_array, slot + 0x0098, 13 * 8);
    copy_cows(cow_array, slot + 0x0100, 12 * 16);
    copy_farm_map(farm_map_array + 0x00C0, slot + 0x01C0, 0x0E40);
}
```

## SaveSystem_LoadSlotSummary

```c
void SaveSystem_LoadSlotSummary(int slot_id) {
    uint8 *slot = SRAM_70 + (slot_id ? 0x1000 : 0x0000);

    summary.year = slot[0x0000];
    summary.season = slot[0x0001];
    summary.day = slot[0x0003];
    summary.player_name[0] = slot[0x0080];
    summary.player_name[1] = slot[0x0081];
    summary.player_name[2] = slot[0x0082];
    summary.player_name[3] = slot[0x0083];
}
```
