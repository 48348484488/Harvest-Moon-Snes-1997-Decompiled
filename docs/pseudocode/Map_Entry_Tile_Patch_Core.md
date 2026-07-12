# Pseudocode - Map Entry Tile Patch Core

```c
void MapLoad_ExecuteMapEntryPointerScript(void) {
    uint8 area = tilemap_to_load;
    MapEntryTilePatch_AreaDispatchTable[area]();
}
```

```c
void MapTilePatch_ApplyObjectAndRefresh(uint16 object_id, uint16 x, uint16 y) {
    PlacementRecord rec = MapTilePatch_LoadPlacementRecord(object_id);
    MapTilePatch_CopyTileObjectToWRAM(object_id, x, y);

    if (rec.needs_vram_refresh) {
        MapTilePatch_QueueObjectVRAMDMA(object_id, x, y);
    }
}
```

```c
void MapTilePatchScript_UpdateActive(void) {
    if (active_script_pointer == NULL) return;

    if (script_delay != 0) {
        script_delay--;
        return;
    }

    uint16 command = read16(active_script_pointer);

    if (command == 0xFFFF) {
        active_script_pointer = NULL;
        return;
    }

    if (command == 0xFFFE) {
        active_script_pointer = read24(active_script_pointer + 2);
        // then process new command immediately
    }

    uint16 object_id = read16(ptr + 0);
    uint16 x         = read16(ptr + 2);
    uint16 y         = read16(ptr + 4);
    uint8 delay      = read8(ptr + 6);

    MapTilePatch_ApplyObjectAndRefreshVRAM(object_id, x, y);
    active_script_pointer += 7;
    script_delay = delay;
}
```

```c
void MapEntryTilePatch_ToolShed(void) {
    for (slot = 0; slot < 0x18; slot++) {
        ShopDisplay_DrawConditionalItemTile(slot + 1, row=0, group=1);
    }

    if (event_flag_7F1F68_2000) {
        MapTilePatch_ApplyObjectAndRefresh(object_id=0x00F0, x=0x0070, y=0x0020);
    }
}
```

```c
void MapEntryTilePatch_Barn(void) {
    ShopDisplay_DrawConditionalItemTile(item=0x1A, row=0, group=1);

    for (stall = 0; stall < 13; stall++) {
        if (fed_cows_flags & AnimalFeed_StallBitmaskTable[stall]) {
            pos = Barn_CowFeedTilePositionTable[stall];
            MapTilePatch_ApplyObjectAndRefresh(object_id=0x0099, pos.x, pos.y);
        }
    }
}
```
