# Pseudocodigo - Save/Load Menu Display Core

```text
function LoadSaveMenuScene():
    tilemap_to_load = TITLE_LOAD_MENU_AREA
    select_bgm_for_area()
    fade_out_previous_bgm_fast()
    fade_out_screen()
    force_blank()
    clear_vram()
    load_graphic_preset(3)
    reset_bg_offsets()
    reset_player_and_transition_positions()
    load_background_layer(TITLE_LAYER_A)
    load_background_layer(TITLE_LAYER_B)
    load_palette_for_menu()
    prepare_menu_state()

function DrawSlotSummaryIfValid(slot):
    valid = SaveSystem_LoadSlotSummary(slot)
    if not valid:
        ClearSlotSummaryArea(slot)
        return

    pos = SaveLoadMenu_SlotSummaryVRAMPositionTable[slot]

    draw_player_name(pos.name, summary.player_name)
    draw_year_number(pos.year_number, summary.year + 1)
    draw_year_suffix_or_label(pos.year_label, summary.year)
    draw_day_number(pos.day_number, summary.day)
    Calendar_LoadDateNameBuffers()
    draw_date_name_chars(pos.date_name, calendar_name_buffer)

function ClearSlotSummaryArea(slot):
    base = SaveLoadMenu_ClearAreaBaseOffsetTable[slot]
    for each row in summary_area:
        dma_blank_tiles_to_vram(base + row_offset)

function StartFromLoad():
    selected_slot = menu_selected_slot
    SaveSystem_LoadFullSlot(selected_slot)
    SpawnAfterLoad()
```
