# Pseudocodigo - Video / PPU / NMI / DMA Core

## Reset e bootstrap

```text
System_ResetHardwareAndBoot():
    disable_interrupts()
    enter_native_65816_mode()
    set_stack($1F00)
    clear_direct_page()

    clear_all_known_snes_registers()
    enable_fastrom()

    clear_low_wram($0000-$1FFF)
    clear_wram_bank_7E($7E2000-$7EFFFF)
    clear_wram_bank_7F($7F0000-$7FFFFF)
    clear_joypad_mirrors()

    upload_spc_driver_and_music_tables()

    VideoPPU_InitScreenModeAndLayerRegisters()
    VRAM_ClearAll()
    OAM_ClearAll()
    Palette_CGRAM_ClearAll()
    clear_sprite_runtime_tables()
    initialize_game_objects()
    SaveSystem_CheckSRAMIntegrity()

    force_blank_screen()
    enable_nmi_without_joypad()
    unblank_screen()
    enable_interrupts()
    jump_to_intro_screen()
```

## NMI por frame

```text
NMI_Handler_UpdatePPUInputAndDMA():
    save_registers()
    acknowledge_nmi()

    read_joypad_ports()
    update_current_previous_new_released_inputs()
    update_autorepeat_timer()

    if NMI_Status == waiting_for_dma:
        DMA_StartProgrammedTransfer()
        run_queued_oam_dma_if_needed()

    write_bg1_scroll_offsets()
    write_bg2_scroll_offsets()
    write_bg3_scroll_offsets()
    write_bg4_scroll_offsets()

    NMI_Status = complete
    restore_registers()
    return_from_interrupt()
```

## DMA programado

```text
DMA_StartProgrammedTransfer():
    read_programmed_dma_slots()
    for each active slot:
        configure_dmap/bbad/source/destination/size
        trigger_mdma_channel()
        clear_slot_or_advance_queue()
```

## Fade

```text
VideoFade_In(start, step_delay, target):
    current = start unless start == $FF
    while current != target:
        PPU_SetScreenBrightness(current)
        wait step_delay frames
        current++

VideoFade_Out(start, step_delay, target):
    current = start unless start == $FF
    while current != target:
        PPU_SetScreenBrightness(current)
        wait step_delay frames
        current--
```
