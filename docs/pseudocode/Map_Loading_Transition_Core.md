# Pseudocodigo - Map Loading / Area Transition Core

## Inicio de transicao

```text
function MapTransition_BeginFadeAndLoadDestination():
    if transition_flag_not_set($0196):
        return

    if transition_not_blocked_by_flags():
        tilemap_to_load = transition_dest
        stop_or_update_audio_for_transition()

    if special_flag_7F1F60_0008:
        transition_dest = 0x3C

    ScreenFadeout(param1=0x0F, param2=0x03, param3=0x01)
    ForceBlank()
    MapTransition_ResetRuntimeAndLoadDestination()
```

## Reset antes de carregar area

```text
function MapTransition_ResetRuntimeAndLoadDestination():
    clear_transition_flags_keep_selected_bits()
    clear_area_flags_nibble()
    game_state |= 0x4000

    ZeroesPartialVRAM(0x7000)
    PaletteAnim_ClearAllPointer42Slots()
    ClearsTimeofDayPalette()
    ClearSpriteDataTables()
    InitializeOBJs()
    reset_misc_runtime_structures()
    clear_all_cc_structs()

    tilemap_to_load = transition_dest
    RunsFunctionbyIndex()
    IterateCCStructures()

    MapLoad_LoadAreaByIdAndApplyOverlays(transition_dest)
```

## Load por area

```text
function MapLoad_LoadAreaByIdAndApplyOverlays(area_id):
    tilemap_to_load = area_id
    time_running = 0

    header_flags = MapLoad_ReadAreaHeaderByte(offset=1)

    if header_flags has time_enabled_bit and player_not_in_blocking_state:
        time_running = 1

    if weather_or_festival_overlay_required:
        load overlay map id 0x57 / 0x58 / 0x59
        attach overlay pointer structures
    else:
        MapLoad_DecompressAreaGraphicsAndSetCamera()
```

## Loader central de mapa

```text
function MapLoad_DecompressAreaGraphicsAndSetCamera():
    ptr = MapLoad_AreaGraphicsPointerTable[tilemap_to_load]

    if tilemap_to_load < 0x57:
        current_graphic_preset = ptr.read_byte()
        ManageGraphicPresets(current_graphic_preset)

        flags = ptr.read_word()
        $0196 |= flags

    mode_0181 = ptr.read_byte()
    mode_0182 = ptr.read_byte()

    number_of_tilemaps = ptr.read_byte()
    number_of_charactermaps = ptr.read_byte()

    if normal_map:
        OBJ_clamp_left  = ptr.read_word()
        OBJ_clamp_right = ptr.read_word()
        OBJ_clamp_up    = ptr.read_word()
        OBJ_clamp_down  = ptr.read_word()

    for each tilemap_entry:
        vram_dest = ptr.read_word()
        compressed_source = ptr.read_long()
        DecompressTileMap(compressed_source, destination=$7E2000)
        DMA $7E2000 -> VRAM[vram_dest], size=$2000

    for each character_map_entry:
        vram_dest = ptr.read_word()
        compressed_source = ptr.read_long()

        if raw_copy_flag_not_set:
            DecompressTileMap(compressed_source, destination=$7E2000)
        else:
            copy_raw_data_to_wram()

        if tilemap_to_load in farm_maps:
            FarmMap_ApplyPersistentFarmTileOverlay()

        if one_character_map_and_entry_script_allowed:
            MapLoad_ExecuteMapEntryPointerScript()

        initialize_camera_and_player_offsets()
        queue_vram_chunks_for_character_map()

    move player/camera gradually to transition_dest_X/Y
```

## Camera/scroll

```text
function Camera_UpdatePlayerCenteredOffsets():
    center player around 0x80 screen position
    clamp camera to OBJ_clamp_left/right/up/down
    update OBJ_Offset_X/Y
    update BG_subpixel_offset_X/Y

function Camera_UpdateHorizontalBGOffsetRight():
    update BG1_Map_Offset_X from OBJ_Offset_X
    if map allows smooth scroll:
        accumulate BG_subpixel_offset_X
        when subpixel reaches 8:
            stream next horizontal strip

function Camera_UpdateVerticalBGOffsetDown():
    update BG1_Map_Offset_Y from OBJ_Offset_Y
    if map allows smooth scroll:
        accumulate BG_subpixel_offset_Y
        when subpixel reaches 8:
            stream next vertical strip
```
