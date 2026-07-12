# Pseudocodigo - Field Status/Menu Visual Bootstrap Core

```c
void IntroScreen_FieldStatusMenuStage09(void) {
    tilemap_to_load = 0x5C;
    AudioBGM_SelectTrackForAreaSeasonTime();
    AudioBGM_FadeOutPreviousTrackFast();

    fade_out(0x0F, 0x01, 0x01);
    ForceBlank();
    ManageGraphicPresets(0x03);
    VRAM_ClearAll();
    Palette_CGRAM_ClearAll();
    PaletteAnim_ClearAllPointer42Slots();
    ClearSpriteDataTables();
    InitializeOBJs();
    MapTilePatchRuntime_ClearAllSlots();
    EventScript_ClearAllSlots();

    player_pos_x = 0;
    player_pos_y = 0;
    transition_dest_x = 0;
    transition_dest_y = 0;
    unknown_0196 = 0;

    tilemap_to_load = 0x5B;
    MapLoad_DecompressAreaGraphicsAndSetCamera();
    Palette_LoadBGHalfToWRAM(0x006D);

    ProgrammedDMA(
        channel = 0,
        destination = 0x22,
        source_bank = 0xA9,
        source_addr = 0xD800,
        size = 0x0200
    );

    tilemap_to_load = 0x5C;
    IntroScreen_MenuVisualBootstrapAndFadeIn();
}

void IntroScreen_MenuVisualBootstrapAndFadeIn(void) {
    demo_timer_90 = 0;
    bg1_x = 0;
    bg1_y = 0;
    bg2_x = 0;
    bg2_y = 0;
    player_pos_x = 0;
    player_pos_y = 0;
    transition_dest_x = 0;
    transition_dest_y = 0;
    unknown_0196 = 0;

    MapLoad_DecompressAreaGraphicsAndSetCamera();
    AudioBGM_FadeOutPreviousTrackIfChanged();
    AudioBGM_StartCurrentTrackAndQueueSamples();
    AudioBGM_FadeInCurrentTrackIfChanged();

    cached_register_0117 = register_0110;
    ResetForceBlank();
    NMI_WaitForNextFrame();
    fade_in(0x01, 0x01, 0x0F);

    intro_stage_95 = 0x04;
    transition_timer_94 = 0;
    IntroScreen_democheck();
}
```
