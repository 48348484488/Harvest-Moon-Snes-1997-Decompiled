# Pseudocodigo - Field Status/Menu Handoff Core

```c
void FieldLoop_EndOfFrame(void) {
    update_transition();
    update_clock();
    update_textbox();
    update_palette();
    update_input();
    update_events();
    update_objects_and_oam();

    if (!(flags_7F1F5C & 0x0004)) {
        nmi_status = 0;
        wait_for_next_frame();
        return;
    }

    clear_field_menu_scratch();
    intro_stage_95 = 0x09;
    demo_timer_90 = 0;
    IntroScreen_democheck();
}

void FieldLoop_EndOfFrame_WithForcedReturn(void) {
    bool menu_request = flags_7F1F5C & 0x0004;
    bool forced_return = flags_7F1F60 & 0x0080;

    if (!menu_request && !forced_return) {
        nmi_status = 0;
        wait_for_next_frame();
        return;
    }

    clear_field_menu_scratch();

    if (tilemap_to_load < 4) {
        CopyCurrentMaptoFarmMap();
    }

    intro_stage_95 = 0x09;
    demo_timer_90 = 0;
    IntroScreen_democheck();
}

void IntroScreen_democheck(void) {
    switch (intro_stage_95) {
        case 0x09:
            IntroScreen_FieldStatusMenuStage09();
            break;
    }
}

void IntroScreen_FieldStatusMenuStage09(void) {
    tilemap_to_load = 0x5C;
    fade_out_fast_menu_audio_path();
    force_blank_and_clear_video_state();
    load_tilemap_0x5B_and_palette_0x006D();
    queue_menu_dma_from_A9_D800();
    tilemap_to_load = 0x5C;
    continue_shared_menu_stage_setup();
}
```
