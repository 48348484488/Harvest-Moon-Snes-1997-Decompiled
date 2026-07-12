# Pseudocodigo - Map / Tileset Renderer Core

```text
function LoadAreaGraphics(area_id):
    pointer = MapLoad_AreaGraphicsPointerTable[area_id]

    if area_id < splash_screen_start:
        preset = read_byte(pointer)
        ManageGraphicPresets(preset)
        update_visual_flags(pointer)

    map_mode = read_byte(pointer)
    number_of_tilemaps = read_byte(pointer)
    number_of_character_maps = read_byte(pointer)

    if area_id is normal_map:
        camera_clamp_left  = read_word(pointer)
        camera_clamp_right = read_word(pointer)
        camera_clamp_up    = read_word(pointer)
        camera_clamp_down  = read_word(pointer)

    for each tilemap_entry:
        vram_destination = read_word(pointer)
        compressed_source = read_long(pointer)
        DecompressTileMap(compressed_source, WRAM_7E2000)
        DMA(WRAM_7E2000, VRAM[vram_destination], size=$2000)

    for each character_map_entry:
        vram_base = read_word(pointer)
        compressed_source = read_long(pointer)

        if raw_copy_flag is set:
            copy_raw_data(compressed_source, WRAM_7E2000)
        else:
            DecompressTileMap(compressed_source, WRAM_7E2000)

        if area_id is farm_season_map:
            FarmMap_ApplyPersistentFarmTileOverlay()

        stream_character_map_chunks_to_vram(vram_base)

    if area_has_entry_script:
        MapLoad_ExecuteMapEntryPointerScript()

    initialize_camera_offsets()
    scroll_player_and_camera_to_transition_destination()
```

```text
function ScrollRendererUpdate(direction):
    update_BG_offsets_from_player_position()

    if camera is clamped:
        return

    accumulate_subpixel_scroll(direction)

    if accumulated_scroll >= 8 pixels:
        if direction == down:
            MapRenderer_StreamRowsForVerticalScrollDown()
        if direction == up:
            MapRenderer_StreamRowsForVerticalScrollUp()
        if direction == right:
            MapRenderer_StreamColumnsForHorizontalScrollRight()
        if direction == left:
            MapRenderer_StreamColumnsForHorizontalScrollLeft()

        StartProgramedDMA()
```
