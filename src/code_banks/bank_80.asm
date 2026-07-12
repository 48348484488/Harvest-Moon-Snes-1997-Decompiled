ORG $808000

;;;;;;;; Spawns you after you start a game, from load or new game
SpawnAfterLoad:  ;808000
        %Set16bit(!MX)
        %Set8bit(!M)
        LDA.B #$15                           ;House lvl 1
        STA.B !tilemap_to_load
        JSL.L AudioBGM_SelectTrackForAreaSeasonTime
        JSL.L AudioBGM_FadeOutPreviousTrackFast
        %Set8bit(!M)
        LDA.B #15
        STA.B !param1
        LDA.B #03
        STA.B !param2
        LDA.B #01
        STA.B !param3
        JSL.L VideoFade_Out
        JSL.L ForceBlank
        JSL.L VRAM_ClearAll
        JSL.L Palette_CGRAM_ClearAll
        JSL.L DayCycle_FirstMorningResetAfterLoad
        JSL.L AudioBGM_SelectTrackForAreaSeasonTime
        %Set16bit(!M)
        LDA.W #$0100
        STA.W !BG3_Map_Offset_Y
        %Set8bit(!M)
        LDA.B #$01
        STA.W !inputstate
        %Set16bit(!MX)
        LDA.W #$0088                         ;Position of the chair you wake up in
        STA.W !transition_dest_X
        LDA.W #$0078
        STA.W !transition_dest_Y
        %Set8bit(!M)
        LDA.B !map_house_1
        STA.W !transition_dest
        JSL.L Romance_UpdateMostLovedGirlNameBuffer
        JSL.L MapTransition_ResetRuntimeAndLoadDestination
        %Set16bit(!M)
        LDA.L $7F1F68
        AND.W #$0001                        ;FLAG68
        BEQ GameLoop
        %Set8bit(!M)
        LDA.B #$03
        JSL.L RNG_GetRange0ToAExclusiveStyle
        %Set8bit(!M)
        STA.W !what_to_eat
        %Set16bit(!MX)
        LDA.B !game_state
        ORA.W #$0004
        STA.B !game_state

;;;;;;;; I think this is the Big Main Loop from the topdown part at least
GameLoop: ;808083
        %Set8bit(!M)
        LDA.B !NMI_Status                    ;Wait for next NMI
        BEQ GameLoop

        %Set16bit(!M)
        LDA.W #$1800
        STA.B $C7
        LDA.W $0196
        AND.W #$2000                         ;FLAG196
        BEQ .enterloop
        JMP.W .skip2

    .enterloop:
        JSL.L MapTransition_BeginFadeAndLoadDestination
        JSL.L MapTransition_CheckEdgeTriggerAndQueueDestination
        ; PASS13_MAIN_LOOP_CLOCK_HOOK: updates time/day events once per game loop.
        JSL.L Clock_UpdateAndDispatchHourlyEvents
        JSL.L TextBox_UpdateRendererAndControlCodes
        JSL.L PaletteTransition_StepTimeOfDayFade
        JSL.L PaletteAnim_UpdatePointer42Slots
        JSL.L Input_DispatchByState
        JSL.L MapTilePatchRuntime_UpdateActiveSlots
        JSL.L PlayerAction_DispatchAndUpdateCamera
        JSL.L AutoMapScrolling
        JSL.L EventScript_UpdateAllActiveSlots
        JSL.L MapTilePatchScript_UpdateActive
        JSL.L GameOBJ_UpdateAnimationFrames
        JSL.L SpriteComponent_BuildVRAMUploadQueue
        JSL.L PrepareOAMData
        %Set8bit(!M)
        STZ.B !NMI_Status
        JMP.W GameLoop


    .skip2:
        %Set16bit(!MX)
        LDA.W $0196
        AND.W #$DFFF
        STA.W $0196
        JML.L NameEntryScene_LoadAndRun

;;;;;;;; Moves the player name from the temp location to the final location
SetPlayerName: ;8080ED
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$0F
        STA.B !param1
        LDA.B #$03
        STA.B !param2
        LDA.B #$01
        STA.B !param3
        JSL.L VideoFade_Out
        JSL.L ForceBlank
        JSL.L VRAM_ClearAll
        JSL.L Palette_CGRAM_ClearAll
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.W !temp_name_1
        STA.W !player_name_sort_1
        %Set16bit(!M)
        STA.W !player_name_long_1
        %Set8bit(!M)
        LDA.W !temp_name_2
        STA.W !player_name_sort_2
        %Set16bit(!M)
        STA.W !player_name_long_2
        %Set8bit(!M)
        LDA.W !temp_name_3
        STA.W !player_name_sort_3
        %Set16bit(!M)
        STA.W !player_name_long_3
        %Set8bit(!M)
        LDA.W !temp_name_4
        STA.W !player_name_sort_4
        %Set16bit(!M)
        STA.W !player_name_long_4
        %Set16bit(!M)
        LDA.W $0196
        ORA.W #$4000                         ;FLAG196
        STA.W $0196
        LDA.W #$0100
        STA.W !BG3_Map_Offset_Y
        %Set8bit(!M)
        LDA.B #$01
        STA.W !inputstate
        JMP.W GameLoop

;;;;;;;; Moves the Cow name from the temp location to the final location, and creates her
SetCowNameBought: ;80815F
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$0F
        STA.B !param1
        LDA.B #$03
        STA.B !param2
        LDA.B #$01
        STA.B !param3
        JSL.L VideoFade_Out
        JSL.L ForceBlank
        JSL.L VRAM_ClearAll
        JSL.L Palette_CGRAM_ClearAll
        %Set16bit(!M)
        LDA.W #$0000
        JSL.L AddNewCow
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000C
        LDA.W !temp_name_1
        STA.B [$72],Y
        LDY.W #$000D
        LDA.W !temp_name_2
        STA.B [$72],Y
        LDY.W #$000E
        LDA.W !temp_name_3
        STA.B [$72],Y
        LDY.W #$000F
        LDA.W !temp_name_4
        STA.B [$72],Y
        %Set16bit(!M)
        LDA.W $0196
        ORA.W #$4000                         ;FLAG196
        STA.W $0196
        LDA.L $7F1F5A
        AND.W #$FFFD                         ;FLAG5A
        STA.L $7F1F5A
        LDA.W #$0100
        STA.W !BG3_Map_Offset_Y
        %Set8bit(!M)
        LDA.B #$01
        STA.W !inputstate
        JMP.W GameLoop

;;;;;;;; Moves the Cow name from the temp location to the final location, and creates her
SetCowNameBorn: ;8081D2
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$0F
        STA.B !param1
        LDA.B #$03
        STA.B !param2
        LDA.B #$01
        STA.B !param3
        JSL.L VideoFade_Out
        JSL.L ForceBlank
        JSL.L VRAM_ClearAll
        JSL.L Palette_CGRAM_ClearAll
        %Set16bit(!M)
        LDA.W #$0001
        JSL.L AddNewCow
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000C
        LDA.W !temp_name_1
        STA.B [$72],Y
        LDY.W #$000D
        LDA.W !temp_name_2
        STA.B [$72],Y
        LDY.W #$000E
        LDA.W !temp_name_3
        STA.B [$72],Y
        LDY.W #$000F
        LDA.W !temp_name_4
        STA.B [$72],Y
        %Set16bit(!M)
        LDA.L !player_house_and_event_flags
        AND.W #$FFFB
        STA.L !player_house_and_event_flags
        %Set16bit(!M)
        LDA.L !player_house_and_event_flags
        AND.W #$FFF7
        STA.L !player_house_and_event_flags
        %Set16bit(!M)
        LDA.W $0196
        ORA.W #$4000                         ;FLAG196
        STA.W $0196
        LDA.W #$0100
        STA.W !BG3_Map_Offset_Y
        %Set8bit(!M)
        LDA.B #$01
        STA.W !inputstate
        JMP.W GameLoop

;;;;;;;; Moves the Dog name from the temp location to the final location
SetDogName: ;808254
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$0F
        STA.B !param1
        LDA.B #$03
        STA.B !param2
        LDA.B #$01
        STA.B !param3
        JSL.L VideoFade_Out
        JSL.L ForceBlank
        JSL.L VRAM_ClearAll
        JSL.L Palette_CGRAM_ClearAll
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.W !temp_name_1
        STA.W !dog_name_short_1
        %Set16bit(!M)
        STA.W !dog_name_long_1
        %Set8bit(!M)
        LDA.W !temp_name_2
        STA.W !dog_name_short_2
        %Set16bit(!M)
        STA.W !dog_name_long_2
        %Set8bit(!M)
        LDA.W !temp_name_3
        STA.W !dog_name_short_3
        %Set16bit(!M)
        STA.W !dog_name_long_3
        %Set8bit(!M)
        LDA.W !temp_name_4
        STA.W !dog_name_short_4
        %Set16bit(!M)
        STA.W !dog_name_long_4
        %Set16bit(!M)
        LDA.W $0196
        ORA.W #$4000                         ;FLAG196
        STA.W $0196
        LDA.W #$0100
        STA.W !BG3_Map_Offset_Y
        %Set8bit(!M)
        LDA.B #$01
        STA.W !inputstate
        JMP.W GameLoop

;;;;;;;; Moves the Horse name from the temp location to the final location
SetHorseName: ;8082C6
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$0F
        STA.B !param1
        LDA.B #$03
        STA.B !param2
        LDA.B #$01
        STA.B !param3
        JSL.L VideoFade_Out
        JSL.L ForceBlank
        JSL.L VRAM_ClearAll
        JSL.L Palette_CGRAM_ClearAll
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.W !temp_name_1
        STA.W !horse_name_short_1
        %Set16bit(!M)
        STA.W !horse_name_long_1
        %Set8bit(!M)
        LDA.W !temp_name_2
        STA.W !horse_name_short_2
        %Set16bit(!M)
        STA.W !horse_name_long_2
        %Set8bit(!M)
        LDA.W !temp_name_3
        STA.W !horse_name_short_3
        %Set16bit(!M)
        STA.W !horse_name_long_3
        %Set8bit(!M)
        LDA.W !temp_name_4
        STA.W !horse_name_short_4
        %Set16bit(!M)
        STA.W !horse_name_long_4
        %Set16bit(!M)
        LDA.W $0196
        ORA.W #$4000                         ;FLAG196
        STA.W $0196
        LDA.W #$0100
        STA.W !BG3_Map_Offset_Y
        %Set8bit(!M)
        LDA.B #$01
        STA.W !inputstate
        JMP.W GameLoop

;;;;;;;; Moves the Kid1 name from the temp location to the final location
SetKid1Name: ;808338
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$0F
        STA.B !param1
        LDA.B #$03
        STA.B !param2
        LDA.B #$01
        STA.B !param3
        JSL.L VideoFade_Out
        JSL.L ForceBlank
        JSL.L VRAM_ClearAll
        JSL.L Palette_CGRAM_ClearAll
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.W !temp_name_1
        STA.L !kid1_name_sort_1
        %Set16bit(!M)
        STA.W !kid1_name_long_1
        %Set8bit(!M)
        LDA.W !temp_name_2
        STA.L !kid1_name_sort_2
        %Set16bit(!M)
        STA.W !kid1_name_long_2
        %Set8bit(!M)
        LDA.W !temp_name_3
        STA.L !kid1_name_sort_3
        %Set16bit(!M)
        STA.W !kid1_name_long_3
        %Set8bit(!M)
        LDA.W !temp_name_4
        STA.L !kid1_name_sort_4
        %Set16bit(!M)
        STA.W !kid1_name_long_4
        %Set16bit(!M)
        LDA.W $0196
        ORA.W #$4000                         ;FLAG196
        STA.W $0196
        LDA.W #$0100
        STA.W !BG3_Map_Offset_Y
        %Set8bit(!M)
        LDA.B #$01
        STA.W !inputstate
        JMP.W GameLoop

;;;;;;;; Moves the Kid2 name from the temp location to the final location
SetKid2Name: ;8083AE
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$0F
        STA.B !param1
        LDA.B #$03
        STA.B !param2
        LDA.B #$01
        STA.B !param3
        JSL.L VideoFade_Out
        JSL.L ForceBlank
        JSL.L VRAM_ClearAll
        JSL.L Palette_CGRAM_ClearAll
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.W !temp_name_1
        STA.L !kid2_name_sort_1
        %Set16bit(!M)
        STA.W !kid2_name_long_1
        %Set8bit(!M)
        LDA.W !temp_name_2
        STA.L !kid2_name_sort_2
        %Set16bit(!M)
        STA.W !kid2_name_long_2
        %Set8bit(!M)
        LDA.W !temp_name_3
        STA.L !kid2_name_sort_3
        %Set16bit(!M)
        STA.W !kid2_name_long_3
        %Set8bit(!M)
        LDA.W !temp_name_4
        STA.L !kid2_name_sort_4
        %Set16bit(!M)
        STA.W !kid2_name_long_4
        %Set16bit(!M)
        LDA.W $0196
        ORA.W #$4000                         ;FLAG196
        STA.W $0196
        LDA.W #$0100
        STA.W !BG3_Map_Offset_Y
        %Set8bit(!M)
        LDA.B #$01
        STA.W !inputstate
        JMP.W GameLoop

;;;;;;;; These values are used during the VRAM and OBJRAM Initializers.
Value_0000: dw $0000 ;808424
Value_00F0: dw $00F0 ;808426

;;;;;;;; Reset IRQ location, beguining of the program, basically
;;;;;;;; Sets all hardware registers and blanks some WRAM locations
;;;;;;;; PASS34_VIDEO_PPU_NMI_DMA_CORE:
; Hardware/video bootstrap and frame-update core.
; This scope maps the reset path, NMI handler, joypad sampling,
; programmed DMA dispatcher, VRAM/OAM/CGRAM clearing helpers, BG register
; presets and brightness/fade control. These routines are the low-level
; video foundation used by maps, menus, textbox, sprites and transitions.
System_ResetHardwareAndBoot:   ;808428
        SEI                                  ;Disable IRQ Interrupt
        CLC
        XCE                                  ;Disable Emulation Mode
        %Set16bit(!MX)
        LDX.W #$1F00
        TXS                                  ;Initialize Stack to $1F00
        LDA.W #$0000
        TCD                                  ;Set Page Register to $00

        ;Setting every hardware register to 0 with a few exceptions
        %Set8bit(!MX)
        STZ.W !NMITIMEN
        STZ.W !MDMAEN
        STZ.W !HDMAEN
        LDA.B #$FF
        STA.W !WRIO                          ;not sure why it sets FF here
        STZ.W !WRMPYA
        STZ.W !WRMPYB
        STZ.W !WRDIVL
        STZ.W !WRDIVH
        STZ.W !WRDIVB
        STZ.W !HTIMEL
        STZ.W !HTIMEH
        STZ.W !VTIMEL
        STZ.W !VTIMEH
        STZ.W !MDMAEN
        STZ.W !HDMAEN
        LDA.B #$01                           ;FastRom
        STA.W !MEMSEL
        STZ.W !RDNMI
        STZ.W !TIMEUP
        STZ.W !HVBJOY
        STZ.W !RDIO
        STZ.W !RDDIVL
        STZ.W !RDDIVH
        STZ.W !RDMPYL
        STZ.W !RDMPYH
        STZ.W !JOY1L
        STZ.W !JOY1H
        STZ.W !JOY2L
        STZ.W !JOY2H
        STZ.W !JOY3L
        STZ.W !JOY3H
        STZ.W !JOY4L
        STZ.W !JOY4H
        STZ.W !INIDISP
        STZ.W !OBSEL
        STZ.W !OAMADDL
        STZ.W !OAMADDH
        STZ.W !OAMDATA
        STZ.W !OAMDATA
        STZ.W !BGMODE
        STZ.W !MOSAIC
        STZ.W !BG1SC
        STZ.W !BG2SC
        STZ.W !BG3SC
        STZ.W !BG4SC
        STZ.W !BG12NBA
        STZ.W !BG34NBA
        STZ.W !BG1HOFS
        STZ.W !BG1HOFS
        STZ.W !BG1VOFS
        STZ.W !BG1VOFS
        STZ.W !BG2HOFS
        STZ.W !BG2HOFS
        STZ.W !BG2VOFS
        STZ.W !BG2VOFS
        STZ.W !BG3HOFS
        STZ.W !BG3HOFS
        STZ.W !BG3VOFS
        STZ.W !BG3VOFS
        STZ.W !BG4HOFS
        STZ.W !BG4HOFS
        STZ.W !BG4VOFS
        STZ.W !BG4VOFS
        LDA.B #$80
        STA.W !VMAIN                         ;Increment by 1 after writing 16 bits
        STZ.W !VMADDL
        STZ.W !VMADDH
        STZ.W !VMDATAL
        STZ.W !VMDATAH
        STZ.W !M7SEL                         ;Thank Gog we dont use Mode7, sounds hard
        STZ.W !M7A
        STZ.W !M7A
        STZ.W !M7B
        STZ.W !M7B
        STZ.W !M7C
        STZ.W !M7C
        STZ.W !M7D
        STZ.W !M7D
        STZ.W !M7X
        STZ.W !M7X
        STZ.W !M7Y
        STZ.W !M7Y
        STZ.W !CGADD
        STZ.W !CGDATA
        STZ.W !CGDATA
        STZ.W !W12SEL
        STZ.W !W34SEL
        STZ.W !WOBJSEL
        STZ.W !WH0
        STZ.W !WH1
        STZ.W !WH2
        STZ.W !WH3
        STZ.W !WBGLOG
        STZ.W !WOBJLOG
        STZ.W !TM
        STZ.W !TS
        STZ.W !TMW
        STZ.W !TSW
        LDA.B #$30
        STA.W !CGWSEL                        ;Prevent color math = Always
        STZ.W !CGADSUB
        LDA.B #$E0
        STA.W !COLDATA                       ;Substract half of backdrops
        STZ.W !SETINI
        STZ.W !MPYL
        STZ.W !MPYM
        STZ.W !MPYH
        STZ.W !SLHV
        STZ.W !OAMDATAREAD
        STZ.W !VMDATALREAD
        STZ.W !VMDATAHREAD
        STZ.W !CGDATAREAD
        STZ.W !CGDATAREAD
        STZ.W !OPHCT
        STZ.W !OPVCT
        STZ.W !STAT77
        STZ.W !STAT78
        STZ.W !WMDATA
        STZ.W !WMADDL
        STZ.W !WMADDM
        STZ.W !WMADDH

        ;Zeroes low WRAM
        %Set16bit(!MX)
        LDX.W #$0000
        LDA.W #$0000
      - STA.W $0000,X
        INX
        INX
        CPX.W #$2000
        BNE -

        ;Zeroes rest of bank $7E
        %Set16bit(!MX)
        LDX.W #$0000
        LDA.W #$0000
      - STA.L $7E2000,X
        INX
        INX
        CPX.W #$E000
        BNE -

        ;Zeroes bank $7F0000
        %Set16bit(!MX)
        LDX.W #$0000
        LDA.W #$0000
      - STA.L $7F0000,X
        INX
        INX
        CPX.W #$0000
        BNE -

        ;Zeroes Joypad memory location? that was zeroed already...
        STZ.W !Joy1_Current
        STZ.W !Joy1_New_Input
        STZ.W !Joy1_Last_Frame
        STZ.W !Joy1_New_Unpressed
        STZ.W !Joy2_Current
        STZ.W !Joy2_New_Input
        STZ.W !Joy2_Last_Frame
        STZ.W !Joy2_Unused2

        ;Sets audio processor
        %Set16bit(!MX)
        LDA.W #$8000
        STA.B $0A
        LDA.W #$00AD
        STA.B $0C
        JSL.L AudioSPC_UploadDriverBootstrap
        %Set8bit(!M)
        LDA.B #$00
        JSL.L AudioSPC_SendCommand0B_SetGlobalParam
        JSL.L AudioSPC_UploadInitialMusicTables
        JSL.L AudioSPC_UploadSecondDriverBlock

        ; Initializes all graphical memories and registers
        JSL.L VideoPPU_InitScreenModeAndLayerRegisters
        JSL.L VRAM_ClearAll
        JSL.L OAM_ClearAll
        JSL.L Palette_CGRAM_ClearAll
        JSL.L ClearSpriteDataTables
        JSL.L InitializeOBJs
        JSL.L SaveSystem_CheckSRAMIntegrity
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B !INIDISP_FORCE_BLANK
        STA.W !INIDISP
        STZ.W $0148                          ;Is this never used?
        LDA.B !NMITIMEN_ENABLE_NMI_NO_JOY
        STA.W !NMITIMEN
        STZ.W !INIDISP
        CLI

        JML.L IntroScreen


;;;;;;;;; Waits for the next NMI
NMI_WaitForNextFrame: ;808645
        PHP
        %Set16bit(!M)
        PHA
        %Set8bit(!M)
        LDA.B !NMITIMEN_ENABLE_NMI_AND_JOY
        STA.L !NMITIMEN24                    ;Interrupt Enable Register 24bit Address
        CLI                                  ;Clear Interrupt Flag
        STZ.B !NMI_Status

      - LDA.B !NMI_Status                    ;Infinite loop till an NMI changes the value
        BEQ -
        %Set16bit(!M)
        PLA
        PLP
        RTL


;;;;;;;;; Waits for a number of NMIs
;;;;;;;;; Params: A = Number of "frames"
NMI_WaitForFrames: ;80865D
        PHP
     -- %Set16bit(!M)
        PHA
        %Set8bit(!M)
        LDA.B !NMITIMEN_ENABLE_NMI_AND_JOY
        STA.L !NMITIMEN24                    ;Interrupt Enable Register 24bit Address
        CLI                                  ;Clear Interrupt Flag
        STZ.B !NMI_Status

      - LDA.B !NMI_Status                    ;Infinite loop till an NMI changes the value
        BEQ -
        %Set16bit(!M)
        PLA
        DEC A
        CMP.W #$0000
        BNE --                               ;Loops back till A is 0
        PLP
        RTL


;;;;;;;; Nothing much happens here, just calls the UpdateGraphics subrutine
;;;;;;;; PASS34: Runs once per vertical blank. It reads joypads, services queued DMA,
; updates scroll registers/BG offsets, then marks !NMI_Status as complete.
NMI_Handler_UpdatePPUInputAndDMA: ;80867B
        %Set16bit(!MX)
        PHA
        PHX
        PHY
        PHD
        PHB
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B !NMITIMEN_ENABLE_NMI_AND_JOY
        STA.L !NMITIMEN24
        CLI                                  ;Enable Interrupts
        JSR.W UpdateGraphics
        %Set16bit(!MX)
        PLB
        PLD
        PLY
        PLX
        PLA
        RTI


;;;;;;;; This feels gutted, doesnt do enything, just continues execution
COP_Interrupt: ;808699
        %Set16bit(!MX)
        PHB
        PHA
        PHX
        PHY
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.W !TIMEUP
        JSR.W COP_Return                     ;emtpy subrutine
        %Set16bit(!MX)
        PLY
        PLX
        PLA
        PLB
        RTI

;;;;;;;; This is the main DMA subrutine
UpdateGraphics: ;8086B1
        PHP
        %Set8bit(!M)
        LDA.B !NMI_Status

        BNE .notwaitingforDMA
        JSL.L DMA_StartProgrammedTransfer
        %Set8bit(!M)
        LDA.B !ProgDMA_OAM_channel           ;DMA Channel 4 holds the OAM changes
        STA.W !MDMAEN
        STZ.B !ProgDMA_OAM_channel
        STZ.W !MDMAEN
        JSL.L CopiesWRAMtoOBJVGRAM
        STZ.B !ProgDMA_OAM_channel
        STZ.W !MDMAEN

    .notwaitingforDMA:
        JSR.W ReadJoypad
        JSL.L RNG_GetNextByte

    ;Update Offsets
        %Set8bit(!M)
        LDA.W !BG1_Map_Offset_X
        STA.W !BG1HOFS
        LDA.W !BG1_Map_Offset_XH
        STA.W !BG1HOFS
        LDA.W !BG1_Map_Offset_Y
        STA.W !BG1VOFS
        LDA.W !BG1_Map_Offset_YH
        STA.W !BG1VOFS
        LDA.W !BG2_Map_Offset_X
        STA.W !BG2HOFS
        LDA.W !BG2_Map_Offset_XH
        STA.W !BG2HOFS
        LDA.W !BG2_Map_Offset_Y
        STA.W !BG2VOFS
        LDA.W !BG2_Map_Offset_YH
        STA.W !BG2VOFS
        LDA.W !BG3_Map_Offset_X
        STA.W !BG3HOFS
        LDA.W !BG3_Map_Offset_XH
        STA.W !BG3HOFS
        LDA.W !BG3_Map_Offset_Y
        STA.W !BG3VOFS
        LDA.W !BG3_Map_Offset_YH
        STA.W !BG3VOFS
        %Set8bit(!M)
        LDA.B #$01
        STA.B !NMI_Status                    ;Update done
        PLP
        RTS


;;;;;;;;; Seems to be an gutted BSOD or debugging menu
COP_Return: ;80872A
        RTS

;;;;;;;; Read joypad, not too much to say, except that its obviously taken
;;;;;;;; from another project/framwork/code example, as it has a ton of unused vars
;;;;;;;; This thing could be 1/3rd its size and operational cost
ReadJoypad: ;80872B;
        PHP

    .waitforready
        %Set8bit(!M)
        LDA.W !HVBJOY
        BIT.B !HVBJOY_Joy_Ready
        BNE .waitforready

    ;Move old imput to last frame's memory location
        %Set16bit(!MX)
        LDA.W !Joy1_Current
        STA.W !Joy1_Last_Frame
        LDA.W !Joy2_Current
        STA.W !Joy2_Last_Frame
        %Set8bit(!M)

        LDA.B $00
        BEQ +

    ;Never run, would read only 8 bit and then use those values as a mask later?
        LDA.W !JOY1L
        STA.W !Joy1_Unused
        LDA.W !JOY2L
        STA.W !Joy2_Current
        BRA ++

    ;read Joypads
      + %Set16bit(!M)
        LDA.W !JOY1L
        ORA.W !Joy1_Unused                   ;always 0, so no changes
        STA.W !Joy1_Current
        LDA.W !JOY2L
        ORA.W !Joy2_Unused                   ;always 0, so no changes
        STA.W !Joy2_Current
        STZ.W !Joy1_Unused
        STZ.W !Joy2_Unused

    ;Get useful variables, some unused variables, and the whole Joy2 is not used
     ++ %Set16bit(!M)
        LDA.W !JOY1L
        EOR.W !Joy1_Last_Frame
        AND.W !Joy1_Current
        STA.W !Joy1_New_Input
        STA.W !Joy1_Autorepeat
        LDA.W !JOY1L
        EOR.W !Joy1_Last_Frame
        AND.W !Joy1_Last_Frame
        STA.W !Joy1_New_Unpressed
        LDA.W !JOY2L
        EOR.W !Joy2_Last_Frame
        AND.W !Joy2_Current
        STA.W !Joy2_New_Input
        STA.W !Joy2_Autorepeat
        LDA.W !JOY1L
        EOR.W !Joy2_Last_Frame
        AND.W !Joy2_Last_Frame
        STA.W !Joy2_Unused2

    ;Key timer code, Keeps how long keys have been pressed, amd updates Autorepeat
        LDA.W !Joy1_Current
        BEQ +                                ;No key pressed
        INC.B !Joy1_Key_Pressed_Timer
        BRA ++                               ;skip reset
      + STZ.B !Joy1_Key_Pressed_Timer
     ++ %Set8bit(!M)

        LDA.B !Joy1_Key_Pressed_Timer
        CMP.B #30                            ;Timer goes till 30
        BEQ +                                ;No need to reset
        BRA ++                               ;Go to end

      + %Set16bit(!M)
        LDA.W !Joy1_Current
        STA.W !Joy1_Autorepeat               ;Updates Autorepeat
        %Set8bit(!M)
        LDA.B #25                            ;resets back to 25
        STA.B !Joy1_Key_Pressed_Timer

     ++ PLP
        RTS

;;;;;;;;; Makes the VideoFade_In effect
;;;;;;;;; Params: $92:Start Brightness $93:Frames per step $94:Target brightness
VideoFade_In: ;8087CE
        !start_brightness = $92
        !frames_per_step = $93
        !target_brightness = $94

        %Set8bit(!MX)
        LDA.B !start_brightness              ;This is probably a special case, I dont think its used
        CMP.B #$FF
        BEQ +

        LDA.B !start_brightness
        STA.B !fade_current_brightness

      + LDA.B !frames_per_step
        STA.B !fade_current_frame

    ;Loops till target Brightness is achived
     -- LDA.B !fade_current_brightness
        JSL.L PPU_SetScreenBrightness
        LDA.B !fade_current_brightness
        CMP.B !target_brightness
        BEQ +                                ;Target Bright Achieved

        INC.B !fade_current_brightness

    ;Loop till enough frames have passed
      - JSL.L NMI_WaitForNextFrame
        DEC.B !fade_current_frame
        LDA.B !fade_current_frame
        BNE -

        LDA.B !frames_per_step
        STA.B !fade_current_frame
        BRA --

      + %Set16bit(!M)
        LDA.L $7F1F5A
        ORA.W #$8000                         ;FLAG5A
        STA.L $7F1F5A
        RTL

;;;;;;;;; Makes the fadeout effect
;;;;;;;;; Params: $92:Start Brightness $93:Frames per step $94:Target brightness
VideoFade_Out: ;80880A
        !start_brightness = $92
        !frames_per_step = $93
        !target_brightness = $94

        %Set8bit(!MX)
        LDA.B !start_brightness
        CMP.B #$FF                           ;This is probably a special case, I dont think its used
        BEQ +

        LDA.B !start_brightness
        STA.B !fade_current_brightness

      + LDA.B !frames_per_step
        STA.B !fade_current_frame

    ;Loops till target Brightness is achived
     -- LDA.B !fade_current_brightness
        JSL.L PPU_SetScreenBrightness
        LDA.B !fade_current_brightness
        CMP.B !target_brightness
        BEQ +                                ;Target Bright Achieved

        DEC.B !fade_current_brightness

    ;Loop till enough frames have passed
      - JSL.L NMI_WaitForNextFrame
        DEC.B !fade_current_frame
        LDA.B !fade_current_frame
        BNE -

        LDA.B !frames_per_step
        STA.B !fade_current_frame
        BRA --

      + %Set16bit(!M)
        LDA.L $7F1F5A
        AND.W #$7FFF                         ;FLAG5A
        STA.L $7F1F5A

        RTL

;;;;;;;; Initializes the VRAM with 0s
VRAM_ClearAll: ;808846
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B !INIDISP_FORCE_BLANK
        STA.W !INIDISP
        STZ.W !NMITIMEN                      ;Disable Interrupts
        LDA.B !VMAIN_16BIT_MODE              ;Sets up the DMA to VRAM
        STA.W !VMAIN
        %Set16bit(!M)
        STZ.W !VMADDL
        %Set8bit(!M)
        LDA.B !DMAPX_16BIT_FIXED_SOURCE
        STA.W !DMAP0
        LDA.B !BBADX_DMA_VRAMPORT
        STA.W !BBAD0
        %Set16bit(!M)
        LDA.W #$8424                         ;src -> $808424 = #$0000
        STA.W !A1T0L
        %Set8bit(!M)
        LDA.B #$80
        STA.W !A1B0
        %Set16bit(!M)
        LDA.W #$0000                         ;Size: A full page
        STA.W !DAS0L
        %Set8bit(!M)
        LDA.B !MDMAEN_Enable_Channel_1
        STA.W !MDMAEN
        RTL

;;;;;;;;Clears the OAM VRAM with 0s
OAM_ClearAll: ;808887
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B !INIDISP_FORCE_BLANK
        STA.W !INIDISP
        STZ.W !NMITIMEN                      ;Disable Interrupts
        %Set16bit(!M)
        STZ.W !OAMADDL                       ;Sets up start of OAM
        %Set8bit(!M)
        LDA.B !DMAPX_16BIT_FIXED_SOURCE
        STA.W !DMAP0
        LDA.B !BBADX_DMA_OAMPORT
        STA.W !BBAD0
        %Set16bit(!M)
        LDA.W #$8424                         ;src -> $808424 = #$0000
        STA.W !A1T0L
        %Set8bit(!M)
        LDA.B #$80
        STA.W !A1B0
        %Set16bit(!M)
        LDA.W #$043F                         ;size -> $043F = 1087 bytes, literally twice the OAM
        STA.W !DAS0L
        %Set8bit(!M)
        LDA.B !MDMAEN_Enable_Channel_1
        STA.W !MDMAEN
        RTL

;;;;;;;; UNUSED, should prepare OAM, but never triggers
UNUSED1: ;8088C3
        %Set16bit(!MX)
        STZ.W !OAMADDL
        %Set8bit(!M)
        LDA.B !DMAPX_8BIT_FIXED_SOURCE
        STA.W !DMAP0
        LDA.B !BBADX_DMA_OAMPORT
        STA.W !BBAD0
        %Set16bit(!M)
        LDA.W #$8426                         ;src -> $808426, $00F0
        STA.W !A1T0L
        %Set8bit(!M)
        LDA.B #$80
        STA.W !A1B0
        %Set16bit(!M)
        LDA.W #$0200
        STA.W !DAS0L
        %Set8bit(!M)
        LDA.B !MDMAEN_Enable_Channel_1
        STA.W !MDMAEN
        %Set16bit(!MX)
        LDA.W #$0100
        STA.W !OAMADDL
        %Set8bit(!M)
        LDA.B !DMAPX_8BIT_FIXED_SOURCE
        STA.W !DMAP0
        LDA.B #$04
        STA.W !BBAD0
        %Set16bit(!M)
        LDA.W #$8424
        STA.W !A1T0L
        %Set8bit(!M)
        LDA.B #$80
        STA.W !A1B0
        %Set16bit(!M)
        LDA.W #$0020
        STA.W !DAS0L
        %Set8bit(!M)
        LDA.B #$01
        STA.W !MDMAEN
        %Set16bit(!M)
        STZ.W !OAMADDL
        %Set8bit(!M)
        %Set16bit(!X)
        LDX.W #$0000
        STX.W !OAMADDL
        STZ.W $4340
        LDA.B #$04
        STA.W $4341
        LDA.B #$00
        STA.W $4342
        LDA.B #$A0
        STA.W $4343
        LDA.B #$7E
        STA.W $4344
        LDX.B $AF
        STX.W $4345
        LDA.B #$10
        STA.W !MDMAEN
        LDX.W #$0100
        STX.W !OAMADDL
        STZ.W $4340
        LDA.B #$04
        STA.W $4341
        LDA.B #$00
        STA.W $4342
        LDA.B #$A0
        CLC
        ADC.B #$02
        STA.W $4343
        LDA.B #$7E
        STA.W $4344
        LDX.W #$0020
        STX.W $4345
        LDA.B #$10
        STA.W !MDMAEN
        RTL

;;;;;;;;Clears the CGRAM VRAM with 0s
Palette_CGRAM_ClearAll: ;808980
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B !NMITIMEN_ENABLE_NMI_NO_JOY
        STA.W !INIDISP
        STZ.W !NMITIMEN                      ;Disable Interrupts
        %Set16bit(!M)
        STZ.W !CGADD                         ;Sets start of CGRAM
        %Set8bit(!M)
        LDA.B !DMAPX_16BIT_FIXED_SOURCE
        STA.W !DMAP0
        LDA.B !BBADX_DMA_CGRAMPORT
        STA.W !BBAD0
        %Set16bit(!M)
        LDA.W #$8424                         ;src -> $808424, $0000
        STA.W !A1T0L
        %Set8bit(!M)
        LDA.B #$80
        STA.W !A1B0
        %Set16bit(!M)
        LDA.W #$03FF                         ;size -> $03FF = 1023 bytes
        STA.W !DAS0L
        %Set8bit(!M)
        LDA.B !MDMAEN_Enable_Channel_1
        STA.W !MDMAEN
        RTL

;;;;;;;; Clears a chunk of 1000 of the VRAM. Param: A, the starting location
VRAM_ClearBlock4KB: ;8089BC
        %Set16bit(!MX)
        STA.W !VMADDL
        %Set8bit(!M)
        LDA.B !INIDISP_FORCE_BLANK
        STA.W !INIDISP
        STZ.W !NMITIMEN
        LDA.B !VMAIN_16BIT_MODE
        STA.W !VMAIN
        LDA.B !DMAPX_16BIT_FIXED_SOURCE
        STA.W !DMAP0
        LDA.B !BBADX_DMA_VRAMPORT
        STA.W !BBAD0
        %Set16bit(!M)
        LDA.W #$8424                         ;src -> $808424 = #$0000
        STA.W !A1T0L
        %Set8bit(!M)
        LDA.B #$80
        STA.W !A1B0
        %Set16bit(!M)
        LDA.W #$0FFF                         ;size -> $0FFF = 4k
        STA.W !DAS0L
        %Set8bit(!M)
        LDA.B !MDMAEN_Enable_Channel_1
        STA.W !MDMAEN
        RTL

;;;;;;;; PASS35_MATH_RNG_CORE: bounded RNG helper used by weather, crops, tools, events and animal logic.
;;;;;;;; Input A = upper-range parameter. Output A = selected small range value.
;;;;;;;; Internally divides 255 by the requested range, samples RNG_GetNextByte, then buckets the result.
RNG_GetRange0ToAExclusiveStyle: ;8089F9
        %Set8bit(!MX)
        STA.B !scratch92
        PHA
        STZ.B !scratch93
        %Set16bit(!M)
        LDA.W #$00FF
        STA.B !scratch7E
        LDA.B !scratch92
        STA.B !scratch80
        JSL.L Math_DivideUnsigned16By16
        %Set8bit(!M)
        STA.B !scratch93
        JSL.L RNG_GetNextByte
        %Set8bit(!MX)
        STA.B !scratch94
        PLA
        DEC A
        STA.B !scratch92
        LDX.B #$00
        LDA.B !scratch93

      - CMP.B !scratch94
        BCS +
        INX
        CPX.B !scratch92
        BEQ +
        CLC
        ADC.B !scratch93
        BRA -

      + TXA
        RTL

;;;;;;;; Prepares a DMA channel to later copy during NMI, more info on ram.asm
;;;;;;;; Params A:Control Registers, X:VRAM/CGRAM Dest Addresses, Y(DMA Size), $72 & $74 24b src
AddProgrammedDMA: ;808A33
        !src_address = $72
        !src_bank = $74

        %Set16bit(!MX)
        PHA
        TXA
        PHA
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B !ProgDMA_Channel_Index
        ASL A
        TAX
        %Set16bit(!M)
        PLA
        STA.B !ProgDMA_Destination_Addr_Table,X
        TXA
        LSR A
        TAX
        PLA
        %Set8bit(!M)
        STA.B !ProgDMA_Control_Register_Table,X
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B !ProgDMA_Channel_Index
        ASL A
        ASL A
        ASL A
        ASL A
        %Set16bit(!M)
        TAX
        %Set8bit(!M)
        LDA.B !ProgDMA_Destination_Memory
        CMP.B !BBADX_DMA_VRAMPORT
        BNE .CGRAM
        LDA.B !DMAPX_16BIT
        STA.W !DMAP0,X
        BRA ++

    .CGRAM
        STZ.W !DMAP0,X                       ;1 register write once

     ++ LDA.B !ProgDMA_Destination_Memory
        STA.W !BBAD0,X
        %Set16bit(!M)
        LDA.B !src_address
        STA.W !A1T0L,X
        %Set8bit(!M)
        LDA.B !src_bank
        STA.W !A1B0,X
        %Set16bit(!M)
        TYA
        STA.W !DAS0L,X
        LDA.B $C7                            ;TODO
        SEC
        SBC.W !DAS0L,X
        STA.B $C7
        TXA
        LSR A
        LSR A
        LSR A
        LSR A
        TAX
        %Set8bit(!M)
        LDA.B !ProgDMA_Channel_Flag_to_Copy
        ORA.L DMA_Channels_Flag_Table,X
        STA.B !ProgDMA_Channel_Flag_to_Copy

        RTL

;;;;;;;; Removes a DMA channel
RemoveProgrammedDMA: ;808AA0
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B !ProgDMA_Channel_Index
        TAX
        LDA.L DMA_Channels_Flag_Table,X
        EOR.B #$FF
        AND.B !ProgDMA_Channel_Flag_to_Copy
        STA.B !ProgDMA_Channel_Flag_to_Copy
        RTL

;;;;;;;; Only copies the last Programmed DMA, and kinda ditches the rest by zeroing ProgDMA_Channel_Flag_to_Copy
;;;;;;;; But doesnt reset the channel index, so the Programmed DMA states is in a dirty state?
;;;;;;;; I guess its only used during vblank and when you only are copying one thing at a time
;;;;;;;; still, a STZ !ProgDMA_Channel_Index at the end would make this so much pretty
StartLastPreparedDMA: ;808AB2
        %Set8bit(!MX)
        LDA.B !ProgDMA_Channel_Index
        PHA
        ASL A
        ASL A
        ASL A
        ASL A
        TAX
        LDA.W !BBAD0,X
        CMP.B !BBADX_DMA_VRAMPORT
        BNE .CGRAM
        PLX
        LDA.B !ProgDMA_Control_Register_Table,X
        STA.W !VMAIN
        %Set16bit(!M)
        TXA
        ASL A
        TAX
        LDA.B !ProgDMA_Destination_Addr_Table,X
        STA.W !VMADDL
        BRA .write

    .CGRAM:
        PLX
        TXA
        ASL A
        TAX
        LDA.B !ProgDMA_Destination_Addr_Table,X
        STA.W !CGADD

    .write:
        %Set8bit(!M)
        TXA
        LSR A
        TAX
        LDA.L DMA_Channels_Flag_Table,X
        STA.W !MDMAEN
        STZ.B !ProgDMA_Channel_Flag_to_Copy
        STZ.W !MDMAEN
        RTL

;;;;;;;; Start the prepared DMA changes
;;;;;;;; PASS34: central programmed DMA dispatcher. It consumes the queued
; source/destination/size registers and performs graphics/tilemap/palette uploads.
DMA_StartProgrammedTransfer: ;808AF0
        %Set8bit(!MX)
        LDX.B #$00

    .nextPort:
        LDA.L DMA_Channels_Flag_Table,X
        AND.B !ProgDMA_Channel_Flag_to_Copy
        BEQ .skipChannel
        PHX                                  ;saves current Channel
        TXA
        ASL A
        ASL A
        ASL A
        ASL A
        TAX                                  ;Mult X by 8, as thats the separation between channels
        LDA.W !BBAD0,X                       ;Reads current destination of the DMA
        CMP.B !BBADX_DMA_VRAMPORT
        BNE .copyCGRAM                       ;checks what memory has to update

    ;copyVRAM
        PLX                                  ;Retrieves current Channel
        LDA.B !ProgDMA_Control_Register_Table,X
        STA.W !VMAIN
        %Set16bit(!M)
        TXA
        ASL A
        TAX                                  ;Doubles X as next value is 16bit
        LDA.B !ProgDMA_Destination_Addr_Table,X
        STA.W !VMADDL
        BRA .write

    .copyCGRAM:
        PLX                                  ;Retrieves current Channel
        TXA
        ASL A
        TAX                                  ;Doubles X as next value is 16bit
        LDA.B !ProgDMA_Destination_Addr_Table,X
        STA.W !CGADD

    .write:
        %Set8bit(!M)
        TXA
        LSR A
        TAX                                  ;Halves X, to restore last doubling
        LDA.L DMA_Channels_Flag_Table,X
        STA.W !MDMAEN                        ;Copies that Channel

    .skipChannel:
        INX
        CPX.B #$08                           ;if last channel just happened
        BNE .nextPort
        STZ.B !ProgDMA_Channel_Flag_to_Copy
        STZ.W !MDMAEN
        RTL

;;;;;;;; Each channels flag
DMA_Channels_Flag_Table: db $01,$02,$04,$08,$10,$20,$40,$80 ;808B3C
;The game can be in 11 different "Graphic presets", those set most PPU function Registers
;Unknown if all are used, some are repeated.
;The current graphic mode is stored in $8019B6 (remap of $7E19B6)
VideoPPU_OBSELPresetTable:      db $60,$60,$60,$60,$60,$60,$03,$03,$03,$03,$63;808B44;Table Object Size and Character Size Register
Table_BGMODE_Presets:     db $09,$09,$09,$09,$09,$09,$09,$09,$09,$09,$09;808B4F;Table BG Mode and Character Size Register
VideoPPU_BG1SCPresetTable:      db $63,$63,$63,$63,$13,$13,$51,$51,$51,$51,$51;808B5A;Table BG Tilemap Address Registers (BG1)
VideoPPU_BG2SCPresetTable:      db $72,$72,$72,$73,$63,$63,$59,$59,$59,$59,$59;808B65;Table BG Tilemap Address Registers (BG2)
VideoPPU_BG3SCPresetTable:      db $7A,$7A,$7A,$7A,$7A,$7A,$09,$09,$0A,$0A,$09;808B70;Table BG Tilemap Address Registers (BG3)
VideoPPU_BG4SCPresetTable:      db $7C,$7C,$7C,$7C,$7C,$7C,$70,$70,$70,$70,$70;808B7B;Table BG Tilemap Address Registers (BG4)
VideoPPU_BG12NBAPresetTable:    db $22,$22,$22,$22,$22,$22,$11,$11,$11,$11,$11;808B86;Table BG Character Address Registers (BG1&2)
VideoPPU_BG34NBAPresetTable:    db $55,$55,$55,$55,$55,$22,$00,$00,$00,$00,$00;808B91;Table BG Character Address Registers (BG3&4)
VideoPPU_MainScreenLayerMaskPresetTable:         db $15,$17,$17,$17,$17,$17,$13,$13,$13,$13,$15;808B9C;Table Main Screen Designation
VideoPPU_SubScreenLayerMaskPresetTable:         db $02,$00,$00,$00,$00,$00,$04,$04,$04,$04,$00;808BA7;Table Subscreen Designation
Table_TMW_Presets:        db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00;808BB2;Table Window Mask Designation for the Main Screen
Table_TSW_Presets:        db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00;808BBD;Table Window Mask Designation for the Sub Screen
VideoPPU_ColorMathSelectPresetTable:     db $02,$02,$02,$02,$02,$02,$00,$02,$02,$02,$00;808BC8;Table Color Math Registers1
VideoPPU_ColorMathAddSubPresetTable:    db $73,$73,$73,$73,$73,$73,$00,$53,$13,$53,$00;808BD3;Table Color Math Registers2
Table_SETINI_Presets:     db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00;808BDE;Table Screen Mode Select Register
Table_W12SEL_Presets:     db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00;808BE9;Table Window Mask Settings (BG1&BG2)
Table_W34SEL_Presets:     db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00;808BF4;Table Window Mask Settings (BG1&BG2)
Table_WOBJSEL_Presets:    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00;808BFF;Table Window Mask Settings (OBJ)
Table_WH0_Presets:        db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00;808C0A;Table Window Position Registers (WH0)
Table_WH1_Presets:        db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00;808C15;Table Window Position Registers (WH1)
Table_WH2_Presets:        db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00;808C20;Table Window Position Registers (WH2)
Table_WH3_Presets:        db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00;808C2B;Table Window Position Registers (WH3)
Table_WBGLOG_Presets:     db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00;808C36;Table Window Mask Logic registers (BG)
Table_WOBJLOG_Presets:    db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00;808C41;Table Window Mask Logic registers (OBJ)

;;;;;;;; like... why? this is longer than the calling stz $24 and then JSR Force blank...
;;;;;;;; PASS34: initializes the current screen-mode preset: BG mode, layer tilemap
; bases, character bases, visible layers, color math and related PPU mirrors.
VideoPPU_InitScreenModeAndLayerRegisters:      ;808C4C
        PHP
        %Set16bit(!X)
        %Set8bit(!M)
        STZ.B !copyof_INIDISP
        %Set16bit(!M)
        PLP
        JMP.W ForceBlank

;;;;;;;; The game has a 11 of preprogramed graphic modes, they dictate the PPU status. This
;;;;;;;; function sets the PPU Register dictated by the value of A and a bunch of tables above
;;;;;;;; This OBVIOUSLY something they copypasted from either an early SNES coding documentation
;;;;;;;; or some old projects where they didnt even underestand the architecture. It access
;;;;;;;; evertythig the SLOWEST way posible, and sets a CRAB TON of memory values THAT ARE NEVER
;;;;;;;; READ ANYWHERE ELSE, NOT EVEN IN THIS FUNCTION. This needs a full rewrite. Or fire.
;;;;;;;; Params: A=New Graphic Mode
ManageGraphicPresets: ;808C59
        PHP
        %Set8bit(!MX)
        STA.L !graphic_preset
        TAX
        LDA.L VideoPPU_OBSELPresetTable,X
        STA.L !OBSEL_preset
        STA.L !OBSEL24
        XBA
        %Set16bit(!M)
        AND.W #$0700
        ASL A
        ASL A
        ASL A
        ASL A
        ASL A
        STA.L !graphic_preset_unknown
        %Set8bit(!M)
        LDA.L Table_BGMODE_Presets,X
        STA.L !BGMODE_preset
        STA.L !BGMODE24

        STZ.W !graphic_preset_unused01
        STZ.W !graphic_preset_unused02
        STZ.W !graphic_preset_unused03
        STZ.W !graphic_preset_unused04

        LDA.L VideoPPU_BG1SCPresetTable,X
        STA.L !BG1SC_preset
        STA.L !BG1SC24
        AND.B #$FC                           ;removes flip flags
        STA.L !BG1SC_noflip_preset
        LDA.L VideoPPU_BG2SCPresetTable,X
        STA.L !BG2SC_preset
        STA.L !BG2SC24
        AND.B #$FC                           ;removes flip flags
        STA.L !BG2SC_noflip_preset
        LDA.L VideoPPU_BG3SCPresetTable,X
        STA.L !BG3SC_preset
        STA.L !BG3SC24
        AND.B #$FC                           ;removes flip flags
        STA.L !BG3SC_noflip_preset
        LDA.L VideoPPU_BG4SCPresetTable,X
        STA.L !BG4SC_preset
        STA.L !BG4SC24
        AND.B #$FC                           ;removes flip flags
        STA.L !BG4SC_noflip_preset
        LDA.L VideoPPU_BG12NBAPresetTable,X
        STA.L !BG12NBA_preset
        STA.L !BG12NBA24
        LDA.L VideoPPU_BG34NBAPresetTable,X
        STA.L !BG34NBA_preset
        STA.L !BG34NBA24

        %Set16bit(!M)
        LDA.W #$0000
        STA.L !graphic_preset_unused05
        STA.L !graphic_preset_unused06
        STA.L !graphic_preset_unused07
        STA.L !graphic_preset_unused08
        STA.L !graphic_preset_unused09
        STA.L !graphic_preset_unused10
        STA.L !graphic_preset_unused11
        STA.L !graphic_preset_unused12
        %Set8bit(!M)
        BIT.B !copyof_INIDISP
        BPL .skip                            ;Always false?

        PHX
        LDX.B #$00

      - STA.L !BG1HOFS24,X                   ;Sets all BG Scroll register to 0
        STA.L !BG1HOFS24,X
        STA.L !BG1VOFS24,X
        STA.L !BG1VOFS24,X
        INX
        INX
        CPX.B #$08
        BNE -
        PLX

    .skip:
        STA.L !M7SEL_preset
        STA.L !M7SEL24
        LDA.L Table_W12SEL_Presets,X
        STA.L !W12SEL_preset
        STA.L !W12SEL24
        LDA.L Table_W34SEL_Presets,X
        STA.L !W34SEL_preset
        STA.L !W34SEL24
        LDA.L Table_WOBJSEL_Presets,X
        STA.L !WOBJSEL_preset
        STA.L !WOBJSEL24
        LDA.L Table_WBGLOG_Presets,X
        STA.L !WBGLOG_preset
        STA.L !WBGLOG24
        LDA.L Table_WOBJLOG_Presets,X
        STA.L !WOBJLOG_preset
        STA.L !WOBJLOG24
        LDA.L Table_WH0_Presets,X
        STA.L !WH0_preset
        STA.L !WH024
        LDA.L Table_WH1_Presets,X
        STA.L !WH1_preset
        STA.L !WH124
        LDA.L Table_WH2_Presets,X
        STA.L !WH2_preset
        STA.L !WH224
        LDA.L Table_WH3_Presets,X
        STA.L !WH3_preset
        STA.L !WH324
        LDA.L VideoPPU_MainScreenLayerMaskPresetTable,X
        STA.L !TM_preset
        STA.L !TM24
        LDA.L VideoPPU_SubScreenLayerMaskPresetTable,X
        STA.L !TS_preset
        STA.L !TS24
        LDA.L Table_TMW_Presets,X
        STA.L !TMW_preset
        STA.L !TMW24
        LDA.L Table_TSW_Presets,X
        STA.L !TSW_preset
        STA.L !TSW24
        LDA.L VideoPPU_ColorMathSelectPresetTable,X
        STA.L !CGWSEL_preset
        STA.L !CGWSEL24
        LDA.L VideoPPU_ColorMathAddSubPresetTable,X
        STA.L !CGADSUB_preset
        STA.L !CGADSUB24
        LDA.B #$E0
        STA.L !COLDATA_preset
        STA.L !COLDATA24
        LDA.L Table_SETINI_Presets,X
        STA.L !SETINI_preset
        STA.L !SETINI24
        PLP
        RTL

;;;;;;;; sets the Forces Blank flag
ForceBlank: ;808E0F
        PHP
        %Set8bit(!M)
        LDA.B !copyof_INIDISP
        ORA.B #$80                           ;modify only the blank bit
        STA.B !copyof_INIDISP
        STA.L !INIDISP24                     ;24bit direction of INIDISP
        PLP
        RTL

;;;;;;;; resets the Forces Blank flag
ResetForceBlank: ;808E1E
        PHP
        %Set8bit(!M)
        LDA.B !copyof_INIDISP
        AND.B #$0F                           ;conserves Brightness
        STA.B !copyof_INIDISP
        STA.L !INIDISP24
        PLP
        RTL

;;;;;;;; Param Desired Brightness in A. It forces blank if bright = 0
PPU_SetScreenBrightness: ;808E2D
        PHP
        %Set8bit(!M)
        AND.B #$0F                           ;keeps what would be only brightness
        BNE +                                ;if 0, just force blank
        LDA.B !INIDISP_FORCE_BLANK

      + STA.L $80007E                        ;A scratch memory, but accesed as 24bit???
        LDA.B !copyof_INIDISP
        AND.B #$80                           ;keeps current force blank
        ORA.B $7E                            ;same scratch memory, retrives bright from there
        STA.B !copyof_INIDISP
        STA.L !INIDISP24
        PLP
        RTL

;;;;;;;; PASS44_POINTER42_PALETTE_ENGINE:
;;;;;;;; Installs one palette-animation Pointer42 slot.
;;;;;;;; Params: A=palette color index, Y=palette row, X=slot, $72/$74=script pointer.
PaletteAnim_SetPointer42Slot: ;808E48
        %Set8bit(!MX)
        STA.W $015A,X
        TYA
        STA.W $016A,X
        STZ.W $014A,X
        %Set16bit(!M)
        TXA
        STA.B $7E
        ASL A
        CLC
        ADC.B $7E
        TAX
        LDA.B $72
        STA.B $42,X
        %Set8bit(!M)
        LDA.B $74
        STA.B $44,X

        RTL

;;;;;;;;
;;;;;;;; Advances active Pointer42 palette scripts, writes colors into the selected
;;;;;;;; CGRAM buffer, and queues a CGRAM DMA when at least one slot updated.
;;;;;;;; Script commands: color word + delay byte, $FFFF=end, $FFFE=jump long.
PaletteAnim_UpdatePointer42Slots: ;808E69
        %Set16bit(!MX)
        %Set8bit(!M)
        STZ.B $92
        STZ.B $93
        LDY.W #$0000
        %Set16bit(!M)
        LDA.W $0196
        AND.W #$000A                         ;FLAG196 snowy or raining
        BNE .snowyorrainy
        LDY.W #$0004

    .snowyorrainy:
        %Set16bit(!M)
        TYA
        STA.B $7E
        ASL A
        CLC
        ADC.B $7E                            ;mult by 3, either 0 or 4
        TAX
        LDA.B $42,X
        BNE .pointerset
        %Set8bit(!M)
        LDA.B $44,X
        BNE .pointerset
        CPY.W #$0004
        BCC .smallloop
        JMP.W .Bank80_MainLogicBranch_808F2C

    .pointerset:
        %Set8bit(!M)
        LDA.B #$01
        STA.B $93
        %Set16bit(!M)
        PHY
        LDA.B $42,X
        STA.B $72
        %Set8bit(!M)
        LDA.B $44,X
        STA.B $74
        %Set16bit(!M)
        LDA.B [$72]
        CMP.W #$FFFF
        BNE .Bank80_MainLogicBranch_808EBC
        JMP.W .Bank80_MainLogicBranch_808F57

    .Bank80_MainLogicBranch_808EBC:
        CMP.W #$FFFE
        BNE .bigloop
        JMP.W .Bank80_MainLogicBranch_808F62

    .bigloop:
            PLY
            TYX
            %Set8bit(!M)
            LDA.W $014A,X
            BEQ .Bank80_MainLogicBranch_808ED0
            JMP.W .Bank80_MainLogicBranch_808F52

        .Bank80_MainLogicBranch_808ED0:
            PHY
            TYX
            LDA.B #$00
            XBA
            LDA.W $016A,X
            %Set16bit(!M)
            PHA
            TYX
            %Set8bit(!M)
            LDA.B #$00
            XBA
            LDA.W $015A,X
            %Set16bit(!M)
            PHA
            LDA.B [$72]
            PLX
            PLY
            JSL.L PaletteBuffer_WriteColorToSelectedBuffer
            %Set16bit(!MX)
            PLY
            PHY
            TYX
            LDY.W #$0002
            %Set8bit(!M)
            LDA.B [$72],Y
            STA.W $014A,X
            %Set16bit(!M)
            PLY
            TYA
            STA.B $7E
            ASL A
            CLC
            ADC.B $7E
            TAX
            LDA.B $42,X
            CLC
            ADC.W #$0003
            STA.B $42,X
            %Set8bit(!M)
            LDA.B $44,X
            ADC.B #$00
            STA.B $44,X

        .smallloop:
                %Set16bit(!M)
                TYA
                STA.B $7E
                ASL A
                CLC
                ADC.B $7E
                TAX
                INY
                CPY.W #$0010
                BEQ .Bank80_MainLogicBranch_808F2C
                JMP.W $8E81

            .Bank80_MainLogicBranch_808F2C:
                %Set8bit(!M)
                LDA.B $93
                BEQ .return
                LDA.B #$05
                STA.B !ProgDMA_Channel_Index
                LDA.B !BBADX_DMA_CGRAMPORT
                STA.B !ProgDMA_Destination_Memory
                %Set16bit(!M)
                LDY.W #$0100
                LDX.W #$0000
                LDA.W #$0900
                STA.B $72
                %Set8bit(!M)
                LDA.B #$7F
                STA.B $74
                JSL.L AddProgrammedDMA

            .return: RTL

            .Bank80_MainLogicBranch_808F52:
                DEC.W $014A,X
                BRA .smallloop

        .Bank80_MainLogicBranch_808F57:
            %Set16bit(!M)
            STZ.B $42,X
            %Set8bit(!M)
            STZ.B $44,X
            JMP.W .bigloop

    .Bank80_MainLogicBranch_808F62:
        %Set16bit(!M)
        LDY.W #$0002
        LDA.B [$72],Y
        STA.B $42,X
        INY
        INY
        %Set8bit(!M)
        LDA.B [$72],Y
        STA.B $44,X
        %Set16bit(!M)
        LDA.B $42,X
        STA.B $72
        %Set8bit(!M)
        LDA.B $44,X
        STA.B $74
        JMP.W .bigloop

;;;;;;;; Clears one Pointer42 palette-animation slot. Param A=slot.
PaletteAnim_ClearPointer42Slot: ;808F82
        %Set16bit(!MX)
        STA.B $7E
        ASL A
        CLC
        ADC.B $7E
        TAX
        STZ.B $42,X
        %Set8bit(!M)
        STZ.B $44,X

        RTL

;;;;;;; Clears Pointer42 palette-animation slots from Y through slot $0F.
PaletteAnim_ClearPointer42SlotsFromIndex: ;808F92
        %Set16bit(!MX)

    .loop:
        %Set16bit(!M)
        TYA
        STA.B $7E
        ASL A
        CLC
        ADC.B $7E
        TAX
        STZ.B $42,X
        %Set8bit(!M)
        STZ.B $44,X
        INY
        CPY.W #$0010
        BNE .loop

        RTL

;;;;;;;;
;;;;;;;; Clears every Pointer42 palette-animation slot.
PaletteAnim_ClearAllPointer42Slots: ;808FAB
        %Set16bit(!MX)
        LDY.W #$0000

    .loop:
        %Set16bit(!M)
        TYA
        STA.B $7E
        ASL A
        CLC
        ADC.B $7E
        TAX
        STZ.B $42,X
        %Set8bit(!M)
        STZ.B $44,X
        INY
        CPY.W #$0010
        BNE .loop

        RTL

;;;;;;;; Pass 32: starts a gradual fade from current CGRAM buffer to a target time-of-day palette.
;;;;;;;; Param A: target palette id from Palette_TimeOfDayByMapTable / Palette_PointerTable.
PaletteTransition_BeginTimeOfDayFade: ;808FC7
        %Set8bit(!M)
        %Set16bit(!X)
        STA.W $017C
        STZ.W !palette_change_countdow
        XBA
        LDA.B #$00
        XBA
        %Set16bit(!M)
        STA.B $7E
        %Set8bit(!M)
        LDA.L !hour
        CMP.B #$12
        BCC .before6PM
        %Set16bit(!M)
        LDA.W #$0B00
        STA.B !palette_change_pointer
        %Set8bit(!M)
        LDA.B #$7F
        STA.B $06
        BRA .return

    .before6PM:
        %Set16bit(!M)
        LDA.B $7E
        ASL A
        CLC
        ADC.B $7E
        TAX
        LDA.L Palette_PointerTable,X
        STA.B !palette_change_pointer
        INX
        INX
        %Set8bit(!M)
        LDA.L Palette_PointerTable,X
        STA.B $06

    .return: RTL

;;;;;;;; Pass 32: per-frame/periodic palette transition step.
;;;;;;;; It moves each RGB555 component one step toward the destination palette,
;;;;;;;; mirrors the result into WRAM palette buffers and schedules CGRAM DMA.
PaletteTransition_StepTimeOfDayFade: ;80900C
        !howmuchtocopy = $84
        !palettechanged = $92

        %Set8bit(!M)
        %Set16bit(!X)
        LDA.W !time_running
        AND.B #$01                           ;time is running
        BNE .timenotrunning
        JMP.W .return

    .timenotrunning:
        %Set16bit(!M)
        LDA.B !palette_change_pointer
        BNE .pointerset
        %Set8bit(!M)
        LDA.B $06
        BNE .pointerset
        JMP.W .return

    .pointerset:
        %Set8bit(!M)
        LDA.W !palette_change_countdow
        INC A
        STA.W !palette_change_countdow
        CMP.B #$20
        BEQ .changepalette
        JMP.W .return

    .changepalette:
        STZ.W !palette_change_countdow
        %Set16bit(!M)
        LDA.W #$0100
        STA.B !howmuchtocopy
        %Set8bit(!M)
        LDA.L !hour
        CMP.B #18
        BCC .notnight
        %Set16bit(!M)
        LDA.W #$0200
        STA.B !howmuchtocopy

    .notnight:
        %Set8bit(!M)
        STZ.B !palettechanged
        LDY.W #$0000

    .loop:
        %Set8bit(!M)
        %Set16bit(!X)
        CPY.W #$0002
        BNE .dontchangey
        LDY.W #$0018
        %Set16bit(!M)
        LDA.W $0196
        AND.W #$0004                         ;FLAG196 Sunny
        BNE .dontchangey
        LDY.W #$0020

    .dontchangey:
        TYX
        %Set16bit(!M)
        LDA.L $7F0D00,X
        AND.W #$001F                         ;separate red
        STA.B $7E
        LDA.B [!palette_change_pointer],Y
        AND.W #$001F
        CMP.B $7E
        BEQ .comparegreen                    ;color achieved
        BCS .getredbrighter
        DEC.B $7E
        BRA .getreddarker

    .getredbrighter:
        INC.B $7E

    .getreddarker:
        %Set8bit(!M)
        LDA.B #$01
        STA.B !palettechanged

    .comparegreen:
        %Set16bit(!M)
        LDA.L $7F0D00,X
        AND.W #$03E0                         ;separate green
        LSR A
        LSR A
        LSR A
        LSR A
        LSR A
        STA.B $80
        LDA.B [!palette_change_pointer],Y
        AND.W #$03E0
        LSR A
        LSR A
        LSR A
        LSR A
        LSR A
        CMP.B $80
        BEQ .compareblue
        BCS .getgreenbrighter
        DEC.B $80
        BRA .getgreendarker

    .getgreenbrighter:
        INC.B $80

    .getgreendarker:
        %Set8bit(!M)
        LDA.B #$01
        STA.B !palettechanged

    .compareblue:
        %Set16bit(!M)
        LDA.L $7F0D00,X
        AND.W #$7C00                         ;separate blue
        LSR A
        LSR A
        LSR A
        LSR A
        LSR A
        LSR A
        LSR A
        LSR A
        LSR A
        LSR A
        STA.B $82
        LDA.B [!palette_change_pointer],Y
        AND.W #$7C00
        LSR A
        LSR A
        LSR A
        LSR A
        LSR A
        LSR A
        LSR A
        LSR A
        LSR A
        LSR A
        CMP.B $82
        BEQ .joincolors
        BCS .getbluebrighter
        DEC.B $82
        BRA .getbluedarker

    .getbluebrighter:
        INC.B $82

    .getbluedarker:
        %Set8bit(!M)
        LDA.B #$01
        STA.B !palettechanged

    .joincolors:
        %Set16bit(!M)
        ASL.B $80
        ASL.B $80
        ASL.B $80
        ASL.B $80
        ASL.B $80
        ASL.B $82
        ASL.B $82
        ASL.B $82
        ASL.B $82
        ASL.B $82
        ASL.B $82
        ASL.B $82
        ASL.B $82
        ASL.B $82
        ASL.B $82
        LDA.B $7E
        ORA.B $80
        ORA.B $82
        STA.L $7F0900,X
        STA.L $7F0D00,X
        INY
        INY
        CPY.B !howmuchtocopy
        BEQ .exitloop
        JMP.W .loop

    .exitloop:
        %Set8bit(!M)
        LDA.B !palettechanged                            ;If nothing to change, you are done!
        BEQ PaletteTransition_CommitLoadedPaletteIndex
        %Set8bit(!M)
        LDA.B #$06
        STA.B !ProgDMA_Channel_Index
        LDA.B #$22
        STA.B !ProgDMA_Destination_Memory
        %Set16bit(!M)
        LDY.B !howmuchtocopy
        LDX.W #$0000
        LDA.W #$0900
        STA.B $72
        %Set8bit(!M)
        LDA.B #$7F
        STA.B $74
        JSL.L AddProgrammedDMA

        .return: RTL

;;;;;;;; Resets !palette_change_pointer and moves the next hour's palettes index
PaletteTransition_CommitLoadedPaletteIndex: ;809157
        %Set16bit(!M)
        STZ.B !palette_change_pointer
        %Set8bit(!M)
        STZ.B $06
        LDA.W $017C
        STA.W !palette_to_load

        RTL

;;;;;;;; Resets !palette_change_pointer
PaletteTransition_ClearPending: ;809166
        %Set16bit(!MX)
        STZ.B !palette_change_pointer
        %Set8bit(!M)
        STZ.B $06

        RTL

;;;;;;;;
;;;;;;;; Params in A, Y, X and $92
PaletteBuffer_WriteColorToSelectedBuffer: ;80916F
        %Set16bit(!MX)
        STA.B $82
        STY.B $7E
        TXA
        ASL A
        STA.B $80
        LDA.B $7E
        ASL A
        ASL A
        ASL A
        ASL A
        ASL A
        CLC
        ADC.B $80
        TAX
        %Set8bit(!M)
        LDA.B $92
        BNE .Bank80_MainLogicBranch_809194
        %Set16bit(!M)
        LDA.B $82
        STA.L $7F0900,X
        BRA .return

    .Bank80_MainLogicBranch_809194:
        %Set16bit(!M)
        LDA.B $82
        STA.L $7F0B00,X

    .return: RTL

;;;;;;;;
;;;;;;;; Params in A, Y, X and $92:update only B00 copy of cgram
PaletteBuffer_WriteColorToActiveAndBackup: ;80919D
        %Set16bit(!MX)
        STA.B $82
        STY.B $7E
        TXA
        ASL A
        STA.B $80
        LDA.B $7E
        ASL A
        ASL A
        ASL A
        ASL A
        ASL A
        CLC
        ADC.B $80
        TAX
        %Set8bit(!M)
        LDA.B $92
        BNE .Bank80_MainLogicBranch_8091C6
        %Set16bit(!M)
        LDA.B $82
        STA.L $7F0900,X
        STA.L $7F0D00,X
        BRA .return

    .Bank80_MainLogicBranch_8091C6:
        %Set16bit(!M)
        LDA.B $82
        STA.L $7F0B00,X

    .return: RTL

;;;;;;;; Pass 32: load palette entries $00-$7F / first $0100 bytes into WRAM buffers.
;;;;;;;; Param A: palette id in Palette_PointerTable.
Palette_LoadBGHalfToWRAM: ;8091CF
        %Set16bit(!MX)
        STA.B $7E
        ASL A
        CLC
        ADC.B $7E                            ;*3
        TAX
        LDA.L Palette_PointerTable,X
        STA.B $72
        INX
        INX
        %Set8bit(!M)
        LDA.L Palette_PointerTable,X
        STA.B $74
        %Set16bit(!M)
        LDA.W #$0100
        STA.B $7E
        LDX.W #$0000
        LDY.W #$0000

      - LDA.B [$72],Y
        STA.L $7F0900,X
        STA.L $7F0D00,X
        INY
        INY
        INX
        INX
        CPY.B $7E
        BNE -

        RTL

;;;;;;;; Pass 32: load palette entries $80-$FF / second $0100 bytes into WRAM buffers.
;;;;;;;; Param A: palette id in Palette_PointerTable.
Palette_LoadOBJHalfToWRAM: ;809208
        %Set16bit(!MX)
        STA.B $7E
        ASL A
        CLC
        ADC.B $7E                            ; * 3
        TAX
        LDA.L Palette_PointerTable,X
        STA.B $72
        INX
        INX
        %Set8bit(!M)
        LDA.L Palette_PointerTable,X
        STA.B $74
        %Set16bit(!M)
        LDA.W #$0100                         ;a whole row
        STA.B $7E
        LDX.W #$0100
        LDY.W #$0000

    .fillcolorloop: ;80922E
        LDA.B [$72],Y
        STA.L $7F0900,X
        STA.L $7F0D00,X
        INY
        INY
        INX
        INX
        CPY.B $7E
        BNE .fillcolorloop

        RTL

;;;;;;;; Pass 32: load full palette for current map before CGRAM upload.
;;;;;;;; Uses Palette_TimeOfDayByMapTable for BG half and Palette_OBJHalfByMapDayNightTable for OBJ half.
Palette_LoadTimeOfDayForCurrentMap: ;809241
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$00
        XBA
        LDA.B !tilemap_to_load
        %Set16bit(!M)
        STA.B $80
        ASL A
        ASL A
        CLC
        ADC.B $80
        ADC.B $80
        ADC.W #$0004                         ; * 6 + 4
        TAX
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.L Palette_TimeOfDayByMapTable,X
        %Set16bit(!M)
        STA.B $7E
        ASL A
        CLC
        ADC.B $7E                            ; * 3
        TAX
        LDA.L Palette_PointerTable,X
        STA.B $72
        INX
        INX
        %Set8bit(!M)
        LDA.L Palette_PointerTable,X
        STA.B $74
        %Set16bit(!M)
        LDA.W #$0100
        STA.B $7E
        LDX.W #$0000
        LDY.W #$0000

        .loop1:
            LDA.B [$72],Y
            STA.L $7F0B00,X
            INY
            INY
            INX
            INX
            CPY.B $7E
            BNE .loop1

        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B !tilemap_to_load
        ASL A
        TAX
        INX
        LDA.W Palette_OBJHalfByMapDayNightTable,X
        %Set16bit(!M)
        STA.B $7E
        ASL A
        CLC
        ADC.B $7E
        TAX
        LDA.L Palette_PointerTable,X
        STA.B $72
        INX
        INX
        %Set8bit(!M)
        LDA.L Palette_PointerTable,X
        STA.B $74
        %Set16bit(!M)
        LDA.W #$0100
        STA.B $7E
        LDX.W #$0100
        LDY.W #$0000

        .loop2:
            LDA.B [$72],Y
            STA.L $7F0B00,X
            INY
            INY
            INX
            INX
            CPY.B $7E
            BNE .loop2

        %Set8bit(!M)
        LDA.B #$01
        STA.B $92
        JSL.L Palette_ApplySeasonWifeAndNightSpriteOverrides

        RTL

;;;;;;;; Pass 32: choose current BG palette id by hour bucket and map id, then load BG half.
Palette_LoadCurrentTimeOfDayBGHalf: ;8092E2
        %Set8bit(!M)
        %Set16bit(!X)
        LDX.W #$0000
        LDA.L !hour
        CMP.B #$07
        BCC .timeFound
        INX
        CMP.B #$0F
        BCC .timeFound
        INX
        CMP.B #$11
        BCC .timeFound
        INX
        CMP.B #$12
        BCC .timeFound
        INX

    .timeFound:
        STX.B $7E
        LDA.B #$00
        XBA
        LDA.B !tilemap_to_load
        %Set16bit(!M)
        STA.B $80                            ;Map
        ASL A
        ASL A
        CLC
        ADC.B $80
        ADC.B $80                            ;*6, as theres 6 values
        ADC.B $7E                            ;+ current seleceted
        TAX
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.L Palette_TimeOfDayByMapTable,X
        STA.W !palette_to_load
        %Set16bit(!M)
        JSL.L Palette_LoadBGHalfToWRAM

        RTL

;;;;;;;; Pass 32: choose and load OBJ/sprite palette half for current map and event flags.
Palette_LoadCurrentAreaSpriteHalf: ;809329
        %Set16bit(!MX)
        LDA.L $7F1F5E
        AND.W #$0080                         ;Flag5E
        BNE .Bank80_MainLogicBranch_80936E
        LDA.L $7F1F5E
        AND.W #$0100                         ;Flag5E
        BNE .Bank80_MainLogicBranch_809380
        LDA.L $7F1F5E
        AND.W #$0200                         ;Flag5E
        BNE .Bank80_MainLogicBranch_809392
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B !tilemap_to_load
        ASL A
        TAX
        LDA.L !hour
        CMP.B #$12                           ;18
        BCC .Bank80_MainLogicBranch_809358
        INX

    .Bank80_MainLogicBranch_809358:
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.W Palette_OBJHalfByMapDayNightTable,X
        %Set16bit(!M)
        JSL.L Palette_LoadOBJHalfToWRAM
        %Set8bit(!M)
        STZ.B $92
        JSL.L Palette_ApplySeasonWifeAndNightSpriteOverrides

        RTL

    .Bank80_MainLogicBranch_80936E: ;80936E
        %Set16bit(!MX)
        LDA.W #$0071
        JSL.L Palette_LoadOBJHalfToWRAM
        %Set8bit(!M)
        STZ.B $92
        JSL.L Palette_ApplySeasonWifeAndNightSpriteOverrides

        RTL

    .Bank80_MainLogicBranch_809380: ;809380
        %Set16bit(!MX)
        LDA.W #$0072
        JSL.L Palette_LoadOBJHalfToWRAM
        %Set8bit(!M)
        STZ.B $92
        JSL.L Palette_ApplySeasonWifeAndNightSpriteOverrides

        RTL

    .Bank80_MainLogicBranch_809392: ;809392
        %Set16bit(!MX)
        LDA.W #$0073
        JSL.L Palette_LoadOBJHalfToWRAM
        %Set8bit(!M)
        STZ.B $92
        JSL.L Palette_ApplySeasonWifeAndNightSpriteOverrides

        RTL

;;;;;;;; Pass 32: apply small color overrides after base sprite palette load.
;;;;;;;; Covers seasonal/winter visual variants, night variants and spouse/pregnancy palette details.
Palette_ApplySeasonWifeAndNightSpriteOverrides: ;8093A3
        %Set16bit(!MX)
        STZ.B $7E
        %Set8bit(!M)
        LDA.B $92                            ;TODO
        BNE .skip
        LDA.L !hour
        CMP.B #18
        BCC .before6PM
        LDA.B !tilemap_to_load
        CMP.B #$31                           ;Map summit spring
        BCS .skip                            ;most maps
        CMP.B #$15                           ;seasonal maps
        BCS .before6PM

    .skip:
        %Set16bit(!M)
        LDA.W #$0004
        STA.B $7E

    .before6PM:
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.W $0022                          ;tilemap_to_load
        CMP.B #$04                           ;farm
        BCS .notfarm

    .seasonloop:
            %Set8bit(!M)
            LDA.L !season
            %Set16bit(!M)
            STA.B $82
            BRA .continue

        .notfarm:
            %Set8bit(!M)
            CMP.B #$10
            BCC .seasonloop                  ;Check Fork
            CMP.B #$14
            BCS .seasonloop                  ;Check Mountain

        %Set16bit(!M)
        SEC
        SBC.W #$0008
        STA.B $82

    .continue:
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B $82
        CLC
        ADC.B $7E
        STA.B $80
        %Set16bit(!M)
        ASL A
        CLC
        ADC.B $80
        ASL A
        TAX
        PHX
        LDA.L PaletteOverride_SeasonalSpriteColorTriples,X
        LDX.W #$000A
        LDY.W #$000F
        JSL.L PaletteBuffer_WriteColorToActiveAndBackup
        %Set16bit(!MX)
        PLX
        INX
        INX
        PHX
        LDA.L PaletteOverride_SeasonalSpriteColorTriples,X
        LDX.W #$000B
        LDY.W #$000F
        JSL.L PaletteBuffer_WriteColorToActiveAndBackup
        %Set16bit(!MX)
        PLX
        INX
        INX
        LDA.L PaletteOverride_SeasonalSpriteColorTriples,X
        LDX.W #$000C
        LDY.W #$000F
        JSL.L PaletteBuffer_WriteColorToActiveAndBackup
        %Set16bit(!MX)
        STZ.B $7E
        %Set8bit(!M)
        LDA.B $92
        BNE .Bank80_MainLogicBranch_809457
        LDA.L !hour
        CMP.B #$12
        BCC .Bank80_MainLogicBranch_809460
        LDA.B !tilemap_to_load
        CMP.B #$31
        BCS .Bank80_MainLogicBranch_809457
        CMP.B #$15
        BCS .Bank80_MainLogicBranch_809460

    .Bank80_MainLogicBranch_809457:
        %Set16bit(!M)
        LDA.W #$0006
        STA.B $7E
        BRA .Bank80_MainLogicBranch_809460

    .Bank80_MainLogicBranch_809460:
        %Set16bit(!MX)
        LDA.L !wife_pregnancy
        BNE .Bank80_MainLogicBranch_80946B
        JMP.W .returnAAAA

    .Bank80_MainLogicBranch_80946B:
        LDA.L !marriage_flags
        AND.W #$0001
        BNE .Bank80_MainLogicBranch_80949A
        LDA.L !marriage_flags
        AND.W #$0002
        BNE .Bank80_MainLogicBranch_8094A1
        LDA.L !marriage_flags
        AND.W #$0004
        BNE .Bank80_MainLogicBranch_8094A8
        LDA.L !marriage_flags
        AND.W #$0008
        BNE .Bank80_MainLogicBranch_8094AF
        LDA.L !marriage_flags
        AND.W #$0010
        BNE .Bank80_MainLogicBranch_8094B6
        BRA .returnAAAA

    .Bank80_MainLogicBranch_80949A:
        %Set16bit(!MX)
        LDA.W #$0001
        BRA .Bank80_MainLogicBranch_8094BD

    .Bank80_MainLogicBranch_8094A1:
        %Set16bit(!MX)
        LDA.W #$0002
        BRA .Bank80_MainLogicBranch_8094BD

    .Bank80_MainLogicBranch_8094A8:
        %Set16bit(!MX)
        LDA.W #$0003
        BRA .Bank80_MainLogicBranch_8094BD

    .Bank80_MainLogicBranch_8094AF:
        %Set16bit(!MX)
        LDA.W #$0004
        BRA .Bank80_MainLogicBranch_8094BD

    .Bank80_MainLogicBranch_8094B6:
        %Set16bit(!MX)
        LDA.W #$0005
        BRA .Bank80_MainLogicBranch_8094BD

    .Bank80_MainLogicBranch_8094BD:
        %Set16bit(!MX)
        CLC
        ADC.B $7E
        STA.B $80
        ASL A
        CLC
        ADC.B $80
        ASL A
        TAX
        PHX
        LDA.L PaletteOverride_WifePregnancyColorTriples,X
        LDX.W #$0008
        LDY.W #$000B
        JSL.L PaletteBuffer_WriteColorToActiveAndBackup
        %Set16bit(!MX)
        PLX
        INX
        INX
        PHX
        LDA.L PaletteOverride_WifePregnancyColorTriples,X
        LDX.W #$0009
        LDY.W #$000B
        JSL.L PaletteBuffer_WriteColorToActiveAndBackup
        %Set16bit(!MX)
        PLX
        INX
        INX
        LDA.L PaletteOverride_WifePregnancyColorTriples,X
        LDX.W #$000A
        LDY.W #$000B
        JSL.L PaletteBuffer_WriteColorToActiveAndBackup

    .returnAAAA:
        RTL

;;;;;;;; Pass 32: check current hour/map palette id and start transition when it changed.
Palette_SetPendingTransitionIfHourChanged: ;809501
        %Set8bit(!M)
        %Set16bit(!X)
        LDX.W #$0000
        LDA.L !hour
        CMP.B #7
        BCC .hourfound
        INX
        CMP.B #15
        BCC .hourfound
        INX
        CMP.B #17
        BCC .hourfound
        INX
        CMP.B #18
        BCC .hourfound
        INX

    .hourfound:
        STX.B $7E
        LDA.B #$00
        XBA
        LDA.B !tilemap_to_load
        %Set16bit(!M)
        STA.B $80
        ASL A
        ASL A
        CLC
        ADC.B $80
        ADC.B $80                           ;tilemap_to_load * 6
        ADC.B $7E                           ; + hour found index
        TAX
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.L Palette_TimeOfDayByMapTable,X
        CMP.W !palette_to_load
        BEQ .return
        CMP.B #$FF
        BEQ .return
        PHA
        JSL.L PaletteTransition_BeginTimeOfDayFade
        %Set8bit(!M)
        PLA
        STA.W !palette_to_load

        .return: RTL

;;;;;;;;
; PASS45_BANK80_POINTER42_INSTALLERS:
; Chooses the map/time installer for Pointer42 palette animation scripts.
; Table layout is six words per tilemap: five hour brackets plus a seasonal gate.
PaletteAnim_RunMapTimeInstaller: ;809553
        %Set8bit(!M)
        %Set16bit(!X)
        LDX.W #$0000
        LDA.L !hour
        CMP.B #07
        BCC .timeFound
        INX
        CMP.B #15
        BCC .timeFound
        INX
        CMP.B #17
        BCC .timeFound
        INX
        CMP.B #18
        BCC .timeFound
        INX

    .timeFound:
        STX.B $7E                            ;hour bracket: <7, <15, <17, <18, >=18
        LDA.B #$00
        XBA
        LDA.B !tilemap_to_load
        %Set16bit(!M)
        STA.B $80
        ASL A
        ASL A
        CLC
        ADC.B $80
        ADC.B $80
        STA.B $80                           ;tilemap_to_load * 6 table entries
        ASL A
        CLC
        ADC.W #$000A                        ;+10 bytes: sixth word controls season gating
        TAX
        LDA.W PaletteAnim_MapTimeInstallerTable,X
        CMP.W #$FFFF
        BEQ .skipSeasonCheck
        %Set8bit(!M)
        LDA.L !season
        CMP.B #$02
        BCC .return                         ;Spring or Summer skip gated groups

    .skipSeasonCheck:
        %Set16bit(!M)
        LDA.B $80
        CLC
        ADC.B $7E
        ASL A
        TAX
        LDA.W PaletteAnim_MapTimeInstallerTable,X
        CMP.W #$FFFF
        BEQ .return
        JSR.W (PaletteAnim_MapTimeInstallerTable,X)

        .return: RTL

;;;;;;;;
AutoMapScrolling: ;8095B3
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.W !map_scrolling_timer
        BEQ .return
        DEC A
        STA.W !map_scrolling_timer
        %Set16bit(!M)
        LDA.B !OBJ_Offset_X
        CLC
        ADC.W !map_scrolling_X_speed
        STA.B !OBJ_Offset_X
        STA.W !BG1_Map_Offset_X
        LDA.B !OBJ_Offset_Y
        CLC
        ADC.W !map_scrolling_Y_speed
        STA.B !OBJ_Offset_Y
        STA.W !BG1_Map_Offset_Y
        BPL .return
        STZ.W !BG1_Map_Offset_Y

    .return RTL

;;;;;;;; sets audio flags
AudioBGM_SelectTrackForAreaSeasonTime: ;8095DE
        %Set8bit(!M)                             ;;      ;
        %Set16bit(!X)                             ;8095E0;      ;
        LDA.B !tilemap_to_load                            ;8095E2;000022;
        CMP.B #$1E                           ;8095E4;      ;
        BEQ $0D                              ;8095E6;8095F5;chek if !tilemap_to_load = $1E
        %Set8bit(!M)                             ;8095E8;      ;
        LDA.L !hour                        ;8095EA;7F1F1C;Hour
        CMP.B #$12                           ;8095EE;      ;
        BCC $03                              ;8095F0;8095F5;Before 12PM
        JMP.W Max7E0110                      ;8095F2;809669;Exit Point
                                                ;      ;      ;
        %Set8bit(!M)                             ;8095F5;      ;
        %Set16bit(!X)                             ;8095F7;      ;
        STZ.W $0110                          ;8095F9;000110;$7E0110
        %Set16bit(!M)                             ;8095FC;      ;
        LDA.W $0196                          ;8095FE;000196;$7E0196
        AND.W #$0010                         ;809601;      ;
        BNE .flag10                          ;809604;80965F;
        LDA.W $0196                          ;809606;000196;$7E0196
        AND.W #$0002                         ;809609;      ;
        BNE .flag02                          ;80960C;809639;
                                                ;      ;      ;
        .loop1: %Set8bit(!M)                             ;80960E;      ;
        LDA.B #$00                           ;809610;      ;
        XBA                                  ;809612;      ;
        LDA.B !tilemap_to_load                            ;809613;000022;$7E0022
        %Set16bit(!M)                             ;809615;      ;
        ASL A                                ;809617;      ;A*2
        TAX                                  ;809618;      ;
        LDA.L AudioBGM_AreaSeasonTrackPointerTable,X;809619;80B8E7;
        CMP.W #$FFFF                         ;80961D;      ;
        BEQ .return                          ;809620;809668;not terminator
        STA.B $7E                            ;809622;00007E;$7E007E
        %Set8bit(!M)                             ;809624;      ;
        LDA.B #$00                           ;809626;      ;
        XBA                                  ;809628;      ;
        LDA.L !season                        ;809629;7F1F19;Season
        %Set16bit(!M)                             ;80962D;      ;
        TAY                                  ;80962F;      ;
        %Set8bit(!M)                             ;809630;      ;
        LDA.B ($7E),Y                        ;809632;00007E;
        STA.W $0110                          ;809634;000110;$7E0110
        BRA .return                          ;809637;809668;
                                                ;      ;      ;
                                                ;      ;      ;
        .flag02: %Set8bit(!M)                             ;809639;      ;
        LDA.B !tilemap_to_load                            ;80963B;000022;$7E0022
        CMP.B #$5B                           ;80963D;      ;more than 91
        BCS .loop1                           ;80963F;80960E;
        CMP.B #$57                           ;809641;      ;more than 57
        BCS .return                          ;809643;809668;
        CMP.B #$31                           ;809645;      ;more than 49
        BCS .skip1                           ;809647;80964D;
        CMP.B #$15                           ;809649;      ;more than 15
        BCS .skip2                           ;80964B;809656;
                                                ;      ;      ;
        .skip1: %Set8bit(!M)                             ;80964D;      ;
        LDA.B #$13                           ;80964F;      ;
        STA.W $0110                          ;809651;000110;
        BRA .return                          ;809654;809668;
                                                ;      ;      ;
                                                ;      ;      ;
        .skip2: %Set8bit(!M)                             ;809656;      ;
        LDA.B #$14                           ;809658;      ;
        STA.W $0110                          ;80965A;000110;
        BRA .return                          ;80965D;809668;
                                                ;      ;      ;
                                                ;      ;      ;
        .flag10: %Set8bit(!M)                             ;80965F;      ;
        LDA.B #$16                           ;809661;      ;
        STA.W $0110                          ;809663;000110;$7E0110
        BRA .return                          ;809666;809668;
                                                ;      ;      ;
                                                ;      ;      ;
        .return: RTL                                  ;809668;      ;
                                                ;      ;      ;
                                                ;      ;      ;
        Max7E0110: %Set8bit(!M)                             ;809669;      ;
        LDA.B #$FF                           ;80966B;      ;
        STA.W $0110                          ;80966D;000110;
        RTL                                  ;809670;      ;Max7E0110

;;;;;;;; Wrong name TODO
;;;;;;;; Pass 26: Core de transicao de area.
;;;;;;;; Verifica flags de transicao, copia o destino para !tilemap_to_load,
;;;;;;;; executa fade/blank e entrega o fluxo para o loader central.
MapTransition_BeginFadeAndLoadDestination: ;809671
        %Set16bit(!MX)
        LDA.W $0196
        AND.W #$4000                         ;FLAG196
        BNE .transitioning

        JMP.W ScreenTransitionReturn

    .transitioning:
        LDA.L $7F1F5E
        AND.W #$8000                         ;FLAG5E
        BNE .skip1

        LDA.L $7F1F60
        AND.W #$0100                         ;FLAG60

        BNE .loop
        LDA.L $7F1F60
        AND.W #$0040                         ;FLAG60
        BEQ .loop
        JMP.W ScreenTransitionReturn

    .loop:
        %Set8bit(!M)
        LDA.W !transition_dest
        STA.B !tilemap_to_load
        JSL.L AudioBGM_SelectTrackForAreaSeasonTime
        JSL.L AudioBGM_FadeOutPreviousTrackFast

    .skip1:
        %Set16bit(!M)
        LDA.L $7F1F60
        AND.W #$0008                         ;FLAG60
        BEQ .skip2
        %Set8bit(!M)
        LDA.B #$3C                           ;TODO
        STA.W !transition_dest

    .skip2:
        %Set8bit(!M)
        LDA.B #$0F
        STA.B !param1
        LDA.B #$03
        STA.B !param2
        LDA.B #$01
        STA.B !param3
        JSL.L VideoFade_Out
        JSL.L ForceBlank

;;;;;;;;
;;;;;;;; Pass 26: Reset de runtime antes de carregar area.
;;;;;;;; Limpa objetos, CC structs, VRAM parcial, paleta dinamica e dados
;;;;;;;; temporarios antes de chamar scripts/loader do destino.
MapTransition_ResetRuntimeAndLoadDestination: ;8096D3
        %Set16bit(!MX)
        LDA.W $0196
        AND.W #$3FDE                         ;FLAG196 resets many flags, keeping others
        STA.W $0196
        LDA.L $7F1F5C
        AND.W #$FFF0                         ;FLAG5C resets a nibble
        STA.L $7F1F5C
        %Set16bit(!MX)
        LDA.B !game_state
        ORA.W #$4000                         ;sets a flag
        STA.B !game_state
        %Set16bit(!M)
        LDA.W #$7000
        JSL.L VRAM_ClearBlock4KB
        JSL.L PaletteAnim_ClearAllPointer42Slots
        JSL.L PaletteTransition_ClearPending
        JSL.L ClearSpriteDataTables
        JSL.L InitializeOBJs
        JSL.L MapTilePatchRuntime_ClearAllSlots
        JSL.L EventScript_ClearAllSlots
        %Set8bit(!M)
        LDA.W !transition_dest
        STA.B !tilemap_to_load
        JSL.L NPCMapEvent_DispatchByCurrentArea
        JSL.L EventScript_UpdateAllActiveSlots
        %Set8bit(!M)
        LDA.W !transition_dest
        JSL.L MapLoad_LoadAreaByIdAndApplyOverlays

;;;;;;;;
ScreenTransitionReturn: ;80972B
        RTL                                  ;Used by this and previous Subrutine

;;;;;;;; Param in A tilema to load
;;;;;;;; Pass 26: Entrada principal de load por area/tilemap id.
;;;;;;;; Aplica regras de time_running, overlays de clima/festival
;;;;;;;; e chama o carregador de graficos/tilemaps.
MapLoad_LoadAreaByIdAndApplyOverlays: ;80972C
        %Set8bit(!M)
        %Set16bit(!X)
        STA.B !tilemap_to_load
        PHA
        %Set8bit(!M)
        STZ.W !time_running
        %Set16bit(!MX)
        LDY.W #$0001
        JSL.L MapLoad_ReadAreaHeaderByte
        %Set8bit(!M)
        PHA
        AND.B #$20
        BEQ .Bank80_MainLogicBranch_80975A
        %Set16bit(!M)
        LDA.L $7F1F5C
        AND.W #$0001
        BNE .Bank80_MainLogicBranch_80975A
        %Set8bit(!M)
        LDA.B #$01
        STA.W !time_running

    .Bank80_MainLogicBranch_80975A:
        %Set8bit(!M)
        PLA
        AND.B #$C0
        BNE .Bank80_MainLogicBranch_809764
        JMP.W .Bank80_MainLogicBranch_8098A8

    .Bank80_MainLogicBranch_809764:
        AND.B #$80                           ;809764;      ;
        BNE .Bank80_MainLogicBranch_809775                      ;809766;809775;
        %Set16bit(!M)                             ;809768;      ;
        LDA.W $0196                          ;80976A;000196;
        AND.W #$0004                         ;80976D;      ;
        BEQ .Bank80_MainLogicBranch_809775                      ;809770;809775;
        JMP.W .Bank80_MainLogicBranch_8098A8                    ;809772;8098A8;

    .Bank80_MainLogicBranch_809775:
        %Set16bit(!M)                             ;809775;      ;
        LDA.L $7F1F5C                        ;809777;7F1F5C;
        AND.W #$0002                         ;80977B;      ;
        BEQ .Bank80_MainLogicBranch_809783                      ;80977E;809783;
        JMP.W .Bank80_MainLogicBranch_8098A8                    ;809780;8098A8;

    .Bank80_MainLogicBranch_809783:
        %Set16bit(!M)                             ;809783;      ;
        LDA.W $0196                          ;809785;000196;
        AND.W #$0002                         ;809788;      ;
        BEQ .Bank80_MainLogicBranch_809806                      ;80978B;809806;
        %Set8bit(!M)                             ;80978D;      ;
        LDA.B #$57                           ;80978F;      ;
        STA.B !tilemap_to_load                            ;809791;000022;
        JSL.L MapLoad_DecompressAreaGraphicsAndSetCamera           ;809793;80A7C6;
        %Set16bit(!M)                             ;809797;      ;
        %Set8bit(!X)                             ;809799;      ;
        LDA.W #$B9D7                         ;80979B;      ;
        STA.B $72                            ;80979E;000072;
        %Set8bit(!M)                             ;8097A0;      ;
        LDA.B #$80                           ;8097A2;      ;
        STA.B $74                            ;8097A4;000074;
        %Set8bit(!M)                             ;8097A6;      ;
        LDA.B #$0C                           ;8097A8;      ;
        LDX.B #$00                           ;8097AA;      ;
        LDY.B #$00                           ;8097AC;      ;
        JSL.L PaletteAnim_SetPointer42Slot            ;8097AE;808E48;
        %Set16bit(!M)                             ;8097B2;      ;
        %Set8bit(!X)                             ;8097B4;      ;
        LDA.W #$B9DC                         ;8097B6;      ;
        STA.B $72                            ;8097B9;000072;
        %Set8bit(!M)                             ;8097BB;      ;
        LDA.B #$80                           ;8097BD;      ;
        STA.B $74                            ;8097BF;000074;
        %Set8bit(!M)                             ;8097C1;      ;
        LDA.B #$0D                           ;8097C3;      ;
        LDX.B #$01                           ;8097C5;      ;
        LDY.B #$00                           ;8097C7;      ;
        JSL.L PaletteAnim_SetPointer42Slot            ;8097C9;808E48;
        %Set16bit(!M)                             ;8097CD;      ;
        %Set8bit(!X)                             ;8097CF;      ;
        LDA.W #$B9E2                         ;8097D1;      ;
        STA.B $72                            ;8097D4;000072;
        %Set8bit(!M)                             ;8097D6;      ;
        LDA.B #$80                           ;8097D8;      ;
        STA.B $74                            ;8097DA;000074;
        %Set8bit(!M)                             ;8097DC;      ;
        LDA.B #$0E                           ;8097DE;      ;
        LDX.B #$02                           ;8097E0;      ;
        LDY.B #$00                           ;8097E2;      ;
        JSL.L PaletteAnim_SetPointer42Slot            ;8097E4;808E48;
        %Set16bit(!M)                             ;8097E8;      ;
        %Set8bit(!X)                             ;8097EA;      ;
        LDA.W #$B9DF                         ;8097EC;      ;
        STA.B $72                            ;8097EF;000072;
        %Set8bit(!M)                             ;8097F1;      ;
        LDA.B #$80                           ;8097F3;      ;
        STA.B $74                            ;8097F5;000074;
        %Set8bit(!M)                             ;8097F7;      ;
        LDA.B #$0F                           ;8097F9;      ;
        LDX.B #$03                           ;8097FB;      ;
        LDY.B #$00                           ;8097FD;      ;
        JSL.L PaletteAnim_SetPointer42Slot            ;8097FF;808E48;
        JMP.W .Bank80_MainLogicBranch_8098A8                    ;809803;8098A8;

    .Bank80_MainLogicBranch_809806:
        %Set16bit(!M)                             ;809806;      ;
        LDA.W $0196                          ;809808;000196;
        AND.W #$0004                         ;80980B;      ;
        BEQ .Bank80_MainLogicBranch_809828                      ;80980E;809828;
        %Set8bit(!M)                             ;809810;      ;
        LDA.L !hour                        ;809812;7F1F1C;
        CMP.B #$11                           ;809816;      ;
        BCC .Bank80_MainLogicBranch_80981D                      ;809818;80981D;
        JMP.W .Bank80_MainLogicBranch_8098A8                    ;80981A;8098A8;

    .Bank80_MainLogicBranch_80981D:
        LDA.B #$58                           ;80981D;      ;
        STA.B !tilemap_to_load                            ;80981F;000022;
        JSL.L MapLoad_DecompressAreaGraphicsAndSetCamera           ;809821;80A7C6;
        JMP.W .Bank80_MainLogicBranch_8098A8                    ;809825;8098A8;

    .Bank80_MainLogicBranch_809828:
        %Set16bit(!M)                             ;809828;      ;
        LDA.W $0196                          ;80982A;000196;
        AND.W #$0008                         ;80982D;      ;
        BEQ .Bank80_MainLogicBranch_8098A8                      ;809830;8098A8;
        %Set8bit(!M)                             ;809832;      ;
        LDA.B #$59                           ;809834;      ;
        STA.B !tilemap_to_load                            ;809836;000022;
        JSL.L MapLoad_DecompressAreaGraphicsAndSetCamera           ;809838;80A7C6;
        %Set16bit(!M)                             ;80983C;      ;
        %Set8bit(!X)                             ;80983E;      ;
        LDA.W #$B9EA                         ;809840;      ;
        STA.B $72                            ;809843;000072;
        %Set8bit(!M)                             ;809845;      ;
        LDA.B #$80                           ;809847;      ;
        STA.B $74                            ;809849;000074;
        %Set8bit(!M)                             ;80984B;      ;
        LDA.B #$0C                           ;80984D;      ;
        LDX.B #$00                           ;80984F;      ;
        LDY.B #$00                           ;809851;      ;
        JSL.L PaletteAnim_SetPointer42Slot            ;809853;808E48;
        %Set16bit(!M)                             ;809857;      ;
        %Set8bit(!X)                             ;809859;      ;
        LDA.W #$B9EF                         ;80985B;      ;
        STA.B $72                            ;80985E;000072;
        %Set8bit(!M)                             ;809860;      ;
        LDA.B #$80                           ;809862;      ;
        STA.B $74                            ;809864;000074;
        %Set8bit(!M)                             ;809866;      ;
        LDA.B #$0D                           ;809868;      ;
        LDX.B #$01                           ;80986A;      ;
        LDY.B #$00                           ;80986C;      ;
        JSL.L PaletteAnim_SetPointer42Slot            ;80986E;808E48;
        %Set16bit(!M)                             ;809872;      ;
        %Set8bit(!X)                             ;809874;      ;
        LDA.W #$B9F2                         ;809876;      ;
        STA.B $72                            ;809879;000072;
        %Set8bit(!M)                             ;80987B;      ;
        LDA.B #$80                           ;80987D;      ;
        STA.B $74                            ;80987F;000074;
        %Set8bit(!M)                             ;809881;      ;
        LDA.B #$0E                           ;809883;      ;
        LDX.B #$02                           ;809885;      ;
        LDY.B #$00                           ;809887;      ;
        JSL.L PaletteAnim_SetPointer42Slot            ;809889;808E48;
        %Set16bit(!M)                             ;80988D;      ;
        %Set8bit(!X)                             ;80988F;      ;
        LDA.W #$B9F5                         ;809891;      ;
        STA.B $72                            ;809894;000072;
        %Set8bit(!M)                             ;809896;      ;
        LDA.B #$80                           ;809898;      ;
        STA.B $74                            ;80989A;000074;
        %Set8bit(!M)                             ;80989C;      ;
        LDA.B #$0F                           ;80989E;      ;
        LDX.B #$03                           ;8098A0;      ;
        LDY.B #$00                           ;8098A2;      ;
        JSL.L PaletteAnim_SetPointer42Slot            ;8098A4;808E48;

    .Bank80_MainLogicBranch_8098A8:
        JSL.L TextBox_LoadDialogueFrameAndFontGraphics
        %Set8bit(!M)
        PLA
        STA.B !tilemap_to_load
        JSL.L LoadMap
        JSL.L MapLoad_DecompressAreaGraphicsAndSetCamera
        JSL.L Palette_LoadCurrentTimeOfDayBGHalf
        JSL.L Palette_LoadCurrentAreaSpriteHalf
        JSL.L PaletteAnim_RunMapTimeInstaller
        JSL.L Palette_LoadTimeOfDayForCurrentMap
        JSL.L PaletteAnim_UpdatePointer42Slots
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$00
        STA.B !ProgDMA_Channel_Index
        LDA.B !BBADX_DMA_CGRAMPORT
        STA.B !ProgDMA_Destination_Memory
        %Set16bit(!M)
        LDY.W #$0200
        LDX.W #$0000
        LDA.W #$0900
        STA.B $72
        %Set8bit(!M)
        LDA.B #$7F
        STA.B $74
        JSL.L AddProgrammedDMA
        JSL.L StartLastPreparedDMA

        %Set16bit(!MX)
        STZ.B $1E
        LDA.B !OBJ_Offset_X
        STA.W !BG2_Map_Offset_X
        LDA.B !OBJ_Offset_Y
        STA.W !BG2_Map_Offset_Y
        %Set8bit(!M)
        LDA.B !tilemap_to_load
        CMP.B #$26                           ;Tool shed
        BNE .Bank80_MainLogicBranch_809912
        %Set16bit(!M)
        LDA.W #$0100
        STA.W !BG2_Map_Offset_Y

    .Bank80_MainLogicBranch_809912:
        %Set8bit(!M)
        STZ.W $091C
        %Set16bit(!M)
        LDA.L $7F1F5A
        AND.W #$FDFF
        STA.L $7F1F5A
        LDA.W #$0000
        STA.L $7F1F7A
        STZ.W $0878
        LDA.B !player_pos_X
        STA.W $0907
        LDA.B !player_pos_Y
        STA.W $0909
        %Set8bit(!M)
        STZ.W $098A
        STZ.W $0919
        %Set16bit(!MX)
        LDA.W #$0080
        EOR.W #$FFFF
        AND.B !game_state
        STA.B !game_state
        %Set16bit(!M)
        STZ.W $08FD
        STZ.W $08FF
        %Set16bit(!MX)
        LDA.W #$1000
        EOR.W #$FFFF
        AND.B !game_state
        STA.B !game_state
        %Set8bit(!M)
        LDA.W !item_on_hand
        BEQ .Bank80_MainLogicBranch_8099BC
        CMP.B #$0D
        BEQ .Bank80_MainLogicBranch_8099B1
        CMP.B #$0E
        BEQ .Bank80_MainLogicBranch_8099B1
        CMP.B #$0F
        BEQ .Bank80_MainLogicBranch_8099B1
        CMP.B #$57
        BEQ .Bank80_MainLogicBranch_8099B1
        STA.W $0984
        %Set16bit(!M)
        LDY.W #$0001
        JSL.L HeldItem_LoadAnimationFrameData
        LDA.W $090B
        STA.W $0980
        LDA.W $090D
        STA.W $0982
        %Set8bit(!M)
        LDA.B #$01
        STA.W $0974
        LDA.B #$01
        STA.W $0975
        LDA.B #$02
        STA.W $0976
        JSL.L MapTilePatchRuntime_AllocateVisualEffectObjectSlot
        %Set16bit(!MX)
        LDA.W #$0014
        CLC
        ADC.B !player_direction
        STA.W $0901
        BRA .Bank80_MainLogicBranch_8099CD

    .Bank80_MainLogicBranch_8099B1:
        %Set16bit(!MX)
        LDA.W #$0000
        CLC
        ADC.B !player_direction
        STA.W $0901

    .Bank80_MainLogicBranch_8099BC:
        %Set8bit(!M)
        STZ.W !item_on_hand
        %Set16bit(!MX)
        LDA.W #$0002
        EOR.W #$FFFF
        AND.B !game_state
        STA.B !game_state

    .Bank80_MainLogicBranch_8099CD:
        JSL.L PlayerAction_SpawnHeldObjectGOBJFromActionFrame
        JSL.L PlayerAction_DispatchAndUpdateCamera
        %Set16bit(!MX)
        LDA.L $7F1F5E
        AND.W #$0002
        BNE .Bank80_MainLogicBranch_8099E4
        JSL.L Livestock_SpawnVisibleAnimalObjects

    .Bank80_MainLogicBranch_8099E4:
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        JSL.L AudioBGM_FadeOutPreviousTrackIfChanged
        JSL.L AudioBGM_StartCurrentTrackAndQueueSamples
        JSL.L AudioBGM_FadeInCurrentTrackIfChanged
        JSL.L AudioTool_PlayToolUseSoundIfEnabled
        %Set8bit(!M)
        LDA.W $0110
        STA.W $0117
        JSL.L NMI_WaitForNextFrame
        %Set16bit(!M)
        LDA.W #$1800
        STA.B $C7
        JSL.L MapTilePatchRuntime_UpdateActiveSlots
        JSL.L EventScript_UpdateAllActiveSlots
        JSL.L GameOBJ_UpdateAnimationFrames
        JSL.L SpriteComponent_BuildVRAMUploadQueue
        JSL.L PrepareOAMData
        %Set8bit(!M)
        STZ.B !NMI_Status
        JSL.L NMI_WaitForNextFrame
        %Set16bit(!M)
        LDA.W #$1800
        STA.B $C7
        JSL.L MapTilePatchRuntime_UpdateActiveSlots
        JSL.L EventScript_UpdateAllActiveSlots
        JSL.L GameOBJ_UpdateAnimationFrames
        JSL.L SpriteComponent_BuildVRAMUploadQueue
        JSL.L PrepareOAMData
        %Set8bit(!M)
        STZ.B !NMI_Status
        JSL.L NMI_WaitForNextFrame
        JSL.L ResetForceBlank
        %Set8bit(!M)
        LDA.B #$03
        STA.B $92
        LDA.B #$03
        STA.B $93
        LDA.B #$0F
        STA.B $94
        JSL.L VideoFade_In

        RTL

;;;;;;;; Related to Transition?
; PASS13_TRANSITION_TIME_GATES: map/tile transition dispatcher.
; This routine is not the clock itself, but it gates some transitions by
; hour/week/season/day/festival flags and can stop !time_running during
; destination transitions.
MapTransition_CheckEdgeTriggerAndQueueDestination: ;809A64
        %Set16bit(!MX)
        LDA.W $0878
        CMP.W #192;C0
        BCS .aboveC0_1
        JMP.W .return

    .aboveC0_1:
        CMP.W #208;D0
        BCC .belowD0_1
        JMP.W MapScroll_UpdateFarEdgeOutdoorRightStream

    .belowD0_1:
        LDA.W $087A
        CMP.W #192;C0
        BCS .aboveC0_2
        JMP.W .return

    .aboveC0_2:
        CMP.W #208;D0
        BCC .belowD0_2
        JMP.W MapScroll_UpdateFarEdgeOutdoorRightStream

    .belowD0_2:
        %Set16bit(!MX)
        LDA.B !game_state
        AND.W #$0010                         ;FLAGD2
        BEQ .continue
        JMP.W .return

    .continue:
        %Set16bit(!M)
        LDA.L $7F1F60
        AND.W #$0006                         ;FLAG60
        BEQ .continue6
        JMP.W .return

    .continue6:
        %Set16bit(!M)
        LDA.L !family_event_flags
        AND.W #$0001
        BEQ .skip1
        %Set16bit(!M)
        LDA.W $0878
        ASL A
        ASL A
        TAY                                  ;*4
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B [$0D],Y
        %Set16bit(!M)
        ASL A
        ASL A
        ASL A
        TAX
        %Set8bit(!M)
        LDA.L Unk_Table13,X
        CMP.B #$1C
        BNE .skip1
        JMP.W .return

    .skip1:
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set16bit(!MX)
        LDA.B !game_state
        ORA.W #$0080                         ;FLAGD2 Carring dog
        STA.B !game_state
        %Set8bit(!M)
        LDA.W $098A
        CMP.B #$01
        BNE .Bank80_MainLogicBranch_809AEF
        JMP.W .Bank80_MainLogicBranch_809C5D

    .Bank80_MainLogicBranch_809AEF:
        CMP.B #$02
        BCC .Bank80_MainLogicBranch_809AF6
        JMP.W .Bank80_MainLogicBranch_809C67

    .Bank80_MainLogicBranch_809AF6:
        INC A
        STA.W $098A
        %Set16bit(!M)
        LDA.W $0878
        ASL A
        ASL A
        TAY
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B [$0D],Y
        %Set16bit(!M)
        ASL A
        ASL A
        ASL A
        TAX
        %Set8bit(!M)
        LDA.L Unk_Table13,X
        STA.W !transition_dest
        INX
        INX
        %Set8bit(!M)
        LDA.L Unk_Table13,X
        STA.B $92
        INX
        LDA.L Unk_Table13,X
        AND.B #$01
        BEQ .Bank80_MainLogicBranch_809B36
        LDA.W !transition_dest
        CLC
        ADC.L !season
        STA.W !transition_dest

    .Bank80_MainLogicBranch_809B36:
        %Set8bit(!M)
        LDA.L Unk_Table13,X
        AND.B #$40
        BEQ .Bank80_MainLogicBranch_809B7D
        LDA.L !day
        CMP.B #$01
        BEQ .Bank80_MainLogicBranch_809B5F
        CMP.B #$18
        BEQ .Bank80_MainLogicBranch_809B6E
        CMP.B #$0A
        BCC .Bank80_MainLogicBranch_809B7D
        CMP.B #$0D
        BCS .Bank80_MainLogicBranch_809B7D
        LDA.W !transition_dest
        CLC
        ADC.B #$04
        STA.W !transition_dest
        BRA .Bank80_MainLogicBranch_809B7D

    .Bank80_MainLogicBranch_809B5F:
        %Set8bit(!M)
        LDA.L !season
        BNE .Bank80_MainLogicBranch_809B7D
        LDA.B #$3A
        STA.W !transition_dest
        BRA .Bank80_MainLogicBranch_809B7D

    .Bank80_MainLogicBranch_809B6E:
        %Set8bit(!M)
        LDA.L !season
        CMP.B #$03
        BNE .Bank80_MainLogicBranch_809B7D
        LDA.B #$39
        STA.W !transition_dest

    .Bank80_MainLogicBranch_809B7D:
        %Set8bit(!M)
        LDA.B !tilemap_to_load
        CMP.B #$0B
        BNE .Bank80_MainLogicBranch_809B88
        JMP.W .Bank80_MainLogicBranch_809C14

    .Bank80_MainLogicBranch_809B88:
        LDA.L Unk_Table13,X
        AND.B #$02
        BEQ .Bank80_MainLogicBranch_809B9A
        LDA.L !hour
        CMP.B #$11
        BCC .Bank80_MainLogicBranch_809B9A
        BRA .Bank80_MainLogicBranch_809C14

    .Bank80_MainLogicBranch_809B9A:
        %Set8bit(!M)
        LDA.L Unk_Table13,X
        AND.B #$04
        BEQ .Bank80_MainLogicBranch_809BAE
        LDA.L !hour
        CMP.B #$11
        BCS .Bank80_MainLogicBranch_809BAE
        BRA .Bank80_MainLogicBranch_809C14

    .Bank80_MainLogicBranch_809BAE:
        %Set8bit(!M)
        LDA.L Unk_Table13,X
        AND.B #$08
        BEQ .Bank80_MainLogicBranch_809BC4
        LDA.L !weekday
        BEQ .Bank80_MainLogicBranch_809BC4
        CMP.B #$06
        BEQ .Bank80_MainLogicBranch_809BC4
        BRA .Bank80_MainLogicBranch_809C14

    .Bank80_MainLogicBranch_809BC4:
        %Set8bit(!M)
        LDA.L Unk_Table13,X
        AND.B #$10
        BEQ .Bank80_MainLogicBranch_809BEC
        LDA.L !season
        CMP.B #$03
        BNE .Bank80_MainLogicBranch_809BE0
        LDA.L !day
        CMP.B #$0A
        BNE .Bank80_MainLogicBranch_809BE0
        BRA .Bank80_MainLogicBranch_809C14

    .Bank80_MainLogicBranch_809BE0:
        %Set8bit(!M)
        LDA.L !weekday
        CMP.B #$06
        BNE .Bank80_MainLogicBranch_809BEC
        BRA .Bank80_MainLogicBranch_809C14

    .Bank80_MainLogicBranch_809BEC:
        %Set8bit(!M)
        LDA.L Unk_Table13,X
        AND.B #$20
        BEQ .Bank80_MainLogicBranch_809BFE
        LDA.L !weekday
        BNE .Bank80_MainLogicBranch_809BFE
        BRA .Bank80_MainLogicBranch_809C14

    .Bank80_MainLogicBranch_809BFE:
        %Set8bit(!M)
        LDA.L Unk_Table13,X
        AND.B #$80
        BEQ .Bank80_MainLogicBranch_809C30
        %Set16bit(!M)
        LDA.W $0196
        AND.W #$0010
        BEQ .Bank80_MainLogicBranch_809C30
        BRA .Bank80_MainLogicBranch_809C14

    .Bank80_MainLogicBranch_809C14:
        %Set16bit(!MX)
        LDA.W #$0080
        EOR.W #$FFFF
        AND.B !game_state
        STA.B !game_state
        %Set16bit(!M)
        STZ.W $0878
        STZ.W $087A
        %Set8bit(!M)
        STZ.W $098A
        JMP.W .return

    .Bank80_MainLogicBranch_809C30:
        %Set8bit(!M)
        STZ.W !time_running
        INX
        %Set16bit(!M)
        LDA.L Unk_Table13,X
        STA.W !transition_dest_X
        INX
        INX
        LDA.L Unk_Table13,X
        STA.W !transition_dest_Y
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B $92
        CMP.B #$00
        BNE .Bank80_MainLogicBranch_809C56
        JMP.W .return

    .Bank80_MainLogicBranch_809C56:
        JSL.L MapTilePatchScript_StartByIndex
        JMP.W .return

    .Bank80_MainLogicBranch_809C5D:
        %Set16bit(!M)
        LDA.W $00CF
        BEQ .Bank80_MainLogicBranch_809C67
        JMP.W .return

    .Bank80_MainLogicBranch_809C67:
        %Set8bit(!M)
        LDA.W $098A
        CMP.B #$0D
        BEQ .Bank80_MainLogicBranch_809CD3
        INC A
        STA.W $098A
        %Set16bit(!MX)
        LDA.W #$0001
        STA.B !player_action
        %Set16bit(!M)
        LDA.B !player_direction
        CMP.W #$0000
        BEQ .Bank80_MainLogicBranch_809CA0
        CMP.W #$0001
        BEQ .Bank80_MainLogicBranch_809CB1
        CMP.W #$0002
        BEQ .Bank80_MainLogicBranch_809CC2
        %Set16bit(!MX)
        LDA.W #$0003
        STA.B !player_direction
        %Set16bit(!MX)
        LDA.W #$0003
        STA.W $0911
        JMP.W .return

    .Bank80_MainLogicBranch_809CA0:
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_direction
        %Set16bit(!MX)
        LDA.W #$0000
        STA.W $0911
        BRA .return

    .Bank80_MainLogicBranch_809CB1:
        %Set16bit(!MX)                             ;809CB1;      ;
        LDA.W #$0001                         ;809CB3;      ;
        STA.B !player_direction                            ;809CB6;0000DA;
        %Set16bit(!MX)                             ;809CB8;      ;
        LDA.W #$0001                         ;809CBA;      ;
        STA.W $0911                          ;809CBD;000911;
        BRA .return                          ;809CC0;809D0A;

    .Bank80_MainLogicBranch_809CC2:
        %Set16bit(!MX)                             ;809CC2;      ;
        LDA.W #$0002                         ;809CC4;      ;
        STA.B !player_direction                            ;809CC7;0000DA;
        %Set16bit(!MX)                             ;809CC9;      ;
        LDA.W #$0002                         ;809CCB;      ;
        STA.W $0911                          ;809CCE;000911;
        BRA .return                          ;809CD1;809D0A;

    .Bank80_MainLogicBranch_809CD3:
        %Set8bit(!M)                             ;809CD3;      ;
        LDA.W $0022                          ;809CD5;000022;
        CMP.B #$04                           ;809CD8;      ;
        BCS .Bank80_MainLogicBranch_809CE0                      ;809CDA;809CE0;
        JSL.L CopyCurrentMaptoFarmMap                          ;809CDC;82A682;

    .Bank80_MainLogicBranch_809CE0:
        %Set8bit(!M)                             ;809CE0;      ;
        LDA.B !tilemap_to_load                            ;809CE2;000022;
        CMP.B #$0C                           ;809CE4;      ;
        BCC .Bank80_MainLogicBranch_809CFF                      ;809CE6;809CFF;
        LDA.B !tilemap_to_load                            ;809CE8;000022;
        CMP.B #$10                           ;809CEA;      ;
        BCS .Bank80_MainLogicBranch_809CFF                      ;809CEC;809CFF;
        LDA.L !hour                        ;809CEE;7F1F1C;
        CMP.B #$12                           ;809CF2;      ;
        BEQ .Bank80_MainLogicBranch_809CFF                      ;809CF4;809CFF;
        INC A                                ;809CF6;      ;
        STA.L !hour                        ;809CF7;7F1F1C;
        JSL.L DayCycle_HaveLunchAtNoon                          ;809CFB;8280AA;

    .Bank80_MainLogicBranch_809CFF:
        %Set16bit(!MX)                             ;809CFF;      ;
        LDA.W $0196                          ;809D01;000196;
        ORA.W #$4000                         ;809D04;      ;
        STA.W $0196                          ;809D07;000196;Stores to 196

    .return: RTL                                  ;809D0A;      ;END_MapTransition_CheckEdgeTriggerAndQueueDestination

;;;;;;;;
MapScroll_UpdateFarEdgeOutdoorRightStream: ;809D0B
        %Set8bit(!M)                             ;      ;
        %Set16bit(!X)                             ;809D0D;      ;
        LDA.B !tilemap_to_load                            ;809D0F;000022;
        CMP.B #$04                           ;809D11;      ;
        BCS Bank80_MainLogicBranch_809D18                      ;809D13;809D18;
        JMP.W $9EBB                          ;809D15;809EBB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809D18: %Set8bit(!M)                             ;809D18;      ;
        LDA.B !tilemap_to_load                            ;809D1A;000022;
        CMP.B #$10                           ;809D1C;      ;
        BCS Bank80_MainLogicBranch_809D23                      ;809D1E;809D23;
        JMP.W $9EBB                          ;809D20;809EBB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809D23:
        CMP.B #$14                           ;809D23;      ;
        BCC Bank80_MainLogicBranch_809D2A                      ;809D25;809D2A;
        JMP.W $9EBB                          ;809D27;809EBB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809D2A:
        %Set16bit(!MX)                             ;809D2A;      ;
        LDA.W $0196                          ;809D2C;000196;
        AND.W #$001A                         ;809D2F;      ;
        BEQ Bank80_MainLogicBranch_809D37                      ;809D32;809D37;
        JMP.W $9EBB                          ;809D34;809EBB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809D37:
        LDA.W $0878                          ;809D37;000878;
        CMP.W #$00F9                         ;809D3A;      ;
        BNE Bank80_MainLogicBranch_809D42                      ;809D3D;809D42;
        JMP.W Bank80_MainLogicBranch_809DFD                    ;809D3F;809DFD;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809D42:
        LDA.W $087A                          ;809D42;00087A;
        CMP.W #$00F9                         ;809D45;      ;
        BNE Bank80_MainLogicBranch_809D4D                      ;809D48;809D4D;
        JMP.W Bank80_MainLogicBranch_809DFD                    ;809D4A;809DFD;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809D4D:
        LDA.W $0878                          ;809D4D;000878;
        CMP.W #$00FA                         ;809D50;      ;
        BNE Bank80_MainLogicBranch_809D58                      ;809D53;809D58;
        JMP.W Bank80_MainLogicBranch_809E3F                    ;809D55;809E3F;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809D58:
        LDA.W $087A                          ;809D58;00087A;
        CMP.W #$00FA                         ;809D5B;      ;
        BNE Bank80_MainLogicBranch_809D63                      ;809D5E;809D63;
        JMP.W Bank80_MainLogicBranch_809E3F                    ;809D60;809E3F;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809D63:
        LDA.W $0878                          ;809D63;000878;
        CMP.W #$00FB                         ;809D66;      ;
        BNE Bank80_MainLogicBranch_809D6E                      ;809D69;809D6E;
        JMP.W Bank80_MainLogicBranch_809E7D                    ;809D6B;809E7D;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809D6E:
        LDA.W $087A                          ;809D6E;00087A;
        CMP.W #$00FB                         ;809D71;      ;
        BNE Bank80_MainLogicBranch_809D79                      ;809D74;809D79;
        JMP.W Bank80_MainLogicBranch_809E7D                    ;809D76;809E7D;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809D79:
        %Set16bit(!M)                             ;809D79;      ;
        LDA.L $7F1F5A                        ;809D7B;7F1F5A;
        AND.W #$0200                         ;FLAG5A
        BNE Bank80_MainLogicBranch_809D87                      ;809D82;809D87;
        JMP.W $9EBB                          ;809D84;809EBB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809D87:
        %Set16bit(!MX)                             ;809D87;      ;
        LDA.B !game_state                            ;809D89;0000D2;
        AND.W #$0002                         ;809D8B;      ;
        BEQ Bank80_MainLogicBranch_809D93                      ;809D8E;809D93;
        JMP.W $9EBB                          ;809D90;809EBB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809D93:
        %Set16bit(!MX)                             ;809D93;      ;
        LDA.B !game_state                            ;809D95;0000D2;
        AND.W #$0010                         ;809D97;      ;
        BEQ Bank80_MainLogicBranch_809D9F                      ;809D9A;809D9F;
        JMP.W $9EBB                          ;809D9C;809EBB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809D9F:
        %Set16bit(!MX)                             ;809D9F;      ;
        LDA.B !game_state                            ;809DA1;0000D2;
        AND.W #$0800                         ;809DA3;      ;
        BEQ Bank80_MainLogicBranch_809DAB                      ;809DA6;809DAB;
        JMP.W $9EBB                          ;809DA8;809EBB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809DAB:
        %Set16bit(!M)                             ;809DAB;      ;
        LDA.W $0878                          ;809DAD;000878;
        CMP.W #$00F8                         ;809DB0;      ;
        BEQ Bank80_MainLogicBranch_809DB8                      ;809DB3;809DB8;
        JMP.W $9EBB                          ;809DB5;809EBB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809DB8:
        LDA.W $087A                          ;809DB8;00087A;
        CMP.W #$00F8                         ;809DBB;      ;
        BEQ Bank80_MainLogicBranch_809DC3                      ;809DBE;809DC3;
        JMP.W $9EBB                          ;809DC0;809EBB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809DC3:
        %Set16bit(!MX)                             ;809DC3;      ;
        LDA.B !player_action                            ;809DC5;0000D4;
        CMP.W #$0010                         ;809DC7;      ;
        BNE Bank80_MainLogicBranch_809DCF                      ;809DCA;809DCF;
        JMP.W $9EBB                          ;809DCC;809EBB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809DCF:
        %Set16bit(!MX)                             ;809DCF;      ;
        LDA.B !player_action                            ;809DD1;0000D4;
        CMP.W #$0011                         ;809DD3;      ;
        BNE Bank80_MainLogicBranch_809DDB                      ;809DD6;809DDB;
        JMP.W $9EBB                          ;809DD8;809EBB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809DDB:
        %Set16bit(!MX)                             ;809DDB;      ;
        LDA.B !player_action                            ;809DDD;0000D4;
        CMP.W #$0012                         ;809DDF;      ;
        BNE Bank80_MainLogicBranch_809DE7                      ;809DE2;809DE7;
        JMP.W $9EBB                          ;809DE4;809EBB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809DE7:
        %Set16bit(!MX)                             ;809DE7;      ;
        LDA.B !player_action                            ;809DE9;0000D4;
        CMP.W #$0013                         ;809DEB;      ;
        BNE Bank80_MainLogicBranch_809DF3                      ;809DEE;809DF3;
        JMP.W $9EBB                          ;809DF0;809EBB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809DF3:
        %Set16bit(!MX)                             ;809DF3;      ;
        LDA.W #$000F                         ;809DF5;      ;
        STA.B !player_action                            ;809DF8;0000D4;
        JMP.W $9EBB                          ;809DFA;809EBB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809DFD:
        %Set8bit(!M)                             ;809DFD;      ;
        %Set16bit(!X)                             ;809DFF;      ;
        LDA.L !season                        ;809E01;7F1F19;
        BEQ Bank80_MainLogicBranch_809E0A                      ;809E05;809E0A;
        JMP.W $9EBB                          ;809E07;809EBB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809E0A:
        LDA.B #$10                           ;809E0A;      ;
        JSL.L RNG_GetRange0ToAExclusiveStyle                  ;809E0C;8089F9;
        BEQ Bank80_MainLogicBranch_809E15                      ;809E10;809E15;
        JMP.W $9EBB                          ;809E12;809EBB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809E15:
        %Set16bit(!M)                             ;809E15;      ;
        LDA.L $7F1F5C                        ;809E17;7F1F5C;
        AND.W #$2000                         ;809E1B;      ;
        BEQ Bank80_MainLogicBranch_809E23                      ;809E1E;809E23;
        JMP.W $9EBB                          ;809E20;809EBB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809E23:
        LDA.L $7F1F5C                        ;809E23;7F1F5C;
        ORA.W #$2000                         ;809E27;      ;
        STA.L $7F1F5C                        ;809E2A;7F1F5C;
        %Set16bit(!MX)                             ;809E2E;      ;
        LDA.W #$0011                         ;809E30;      ;
        LDX.W #$002C                         ;809E33;      ;
        LDY.W #$0000                         ;809E36;      ;
        JSL.L EventScript_LoadScriptPointerLong                            ;809E39;848097;
        BRA $7C                              ;809E3D;809EBB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809E3F:
        %Set8bit(!M)                             ;809E3F;      ;
        %Set16bit(!X)                             ;809E41;      ;
        LDA.L !season                        ;809E43;7F1F19;
        CMP.B #$02                           ;809E47;      ;
        BNE $70                              ;809E49;809EBB;
        LDA.B #$10                           ;809E4B;      ;
        JSL.L RNG_GetRange0ToAExclusiveStyle                  ;809E4D;8089F9;
        BEQ Bank80_MainLogicBranch_809E56                      ;809E51;809E56;
        JMP.W $9EBB                          ;809E53;809EBB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809E56:
        %Set16bit(!M)                             ;809E56;      ;
        LDA.L $7F1F5C                        ;809E58;7F1F5C;
        AND.W #$4000                         ;809E5C;      ;
        BNE $5A                              ;809E5F;809EBB;
        LDA.L $7F1F5C                        ;809E61;7F1F5C;
        ORA.W #$4000                         ;809E65;      ;
        STA.L $7F1F5C                        ;809E68;7F1F5C;
        %Set16bit(!MX)                             ;809E6C;      ;
        LDA.W #$0013                         ;809E6E;      ;
        LDX.W #$002B                         ;809E71;      ;
        LDY.W #$0000                         ;809E74;      ;
        JSL.L EventScript_LoadScriptPointerLong                            ;809E77;848097;
        BRA $3E                              ;809E7B;809EBB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809E7D:
        %Set8bit(!M)                             ;809E7D;      ;
        %Set16bit(!X)                             ;809E7F;      ;
        LDA.L !season                        ;809E81;7F1F19;
        CMP.B #$03                           ;809E85;      ;
        BNE !ProgDMA_Destination_Addr_Table                               ;809E87;809EBB;
        LDA.B #$10                           ;809E89;      ;
        JSL.L RNG_GetRange0ToAExclusiveStyle                  ;809E8B;8089F9;
        BEQ Bank80_MainLogicBranch_809E94                      ;809E8F;809E94;
        JMP.W $9EBB                          ;809E91;809EBB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_809E94:
        %Set16bit(!M)                             ;809E94;      ;
        LDA.L $7F1F5C                        ;809E96;7F1F5C;
        AND.W #$8000                         ;809E9A;      ;
        BNE $1C                              ;809E9D;809EBB;
        LDA.L $7F1F5C                        ;809E9F;7F1F5C;
        ORA.W #$8000                         ;809EA3;      ;
        STA.L $7F1F5C                        ;809EA6;7F1F5C;
        %Set16bit(!MX)                             ;809EAA;      ;
        LDA.W #$0012                         ;809EAC;      ;
        LDX.W #$002A                         ;809EAF;      ;
        LDY.W #$0000                         ;809EB2;      ;
        JSL.L EventScript_LoadScriptPointerLong                            ;809EB5;848097;
        BRA !NMI_Status                              ;809EB9;809EBB;
                                            ;      ;      ;
        RTL                                  ;809EBB;      ;END_MapScroll_UpdateFarEdgeOutdoorRightStream

;;;;;;;; I think this moves the BGs and OBJs offsets to the right position when changing screens
Camera_UpdatePlayerCenteredOffsets: ;809EBC
        %Set16bit(!MX)
        LDA.B !player_pos_X
        SEC
        SBC.W #$0080                         ;128
        CMP.B !OBJ_clamp_left
        BMI .movableposx
        BEQ .movableposx
        BCS .fixedposx

    .movableposx:
        %Set16bit(!M)
        CLC
        ADC.W #$0080                         ;restore the 128
        SEC
        SBC.B !OBJ_clamp_left
        STA.W $090B
        %Set8bit(!M)
        LDA.B #$00
        STA.B !BG_subpixel_offset_X
        %Set16bit(!M)
        LDA.B !OBJ_clamp_left
        STA.B !OBJ_Offset_X
        BRA .ycoordinate

    .fixedposx:
        %Set16bit(!M)
        CMP.B !OBJ_clamp_right
        BCS .adjustsubpixelx                 ;Too close to the left wall
        STA.B !OBJ_Offset_X
        LDA.W #$0080
        STA.W $090B
        BRA .ycoordinate

    .adjustsubpixelx:
        %Set16bit(!M)
        CLC
        ADC.W #$0080
        SEC
        SBC.B !OBJ_clamp_right
        STA.W $090B
        %Set8bit(!M)
        LDA.B #$08
        STA.B !BG_subpixel_offset_X
        %Set16bit(!M)
        LDA.B !OBJ_clamp_right
        STA.B !OBJ_Offset_X

    .ycoordinate:
        %Set16bit(!M)
        LDA.B !player_pos_Y
        SEC
        SBC.W #$0080
        CMP.B !OBJ_clamp_up
        BMI .movableposy
        BEQ .movableposy
        BCS .fixedposy

    .movableposy:
        %Set16bit(!M)
        CLC
        ADC.W #$0080
        SEC
        SBC.B !OBJ_clamp_up
        STA.W $090D
        %Set8bit(!M)
        LDA.B #$00
        STA.B !BG_subpixel_offset_Y
        %Set16bit(!M)
        LDA.B !OBJ_clamp_up
        STA.B !OBJ_Offset_Y
        BRA .return

    .fixedposy:
        %Set16bit(!M)
        CMP.B !OBJ_clamp_down
        BCS .adjustsubpixely

        STA.B !OBJ_Offset_Y
        LDA.W #$0080
        STA.W $090D
        BRA .return

    .adjustsubpixely:
        %Set16bit(!M)
        CLC
        ADC.W #$0080
        SEC
        SBC.B !OBJ_clamp_down
        STA.W $090D
        %Set8bit(!M)
        LDA.B #$08
        STA.B !BG_subpixel_offset_Y
        %Set16bit(!M)
        LDA.B !OBJ_clamp_down
        STA.B !OBJ_Offset_Y

    .return: RTL

;;;;;;;; I think this checks for map scrolling in locked places, like tool shed
Camera_UpdateBG2WeatherOrParallaxScroll: ;809F61
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B !tilemap_to_load
        CMP.B #$26                           ;Tool Shed
        BNE +
        JMP.W .return

      + CMP.B #$31
        BCC .Bank80_MainLogicBranch_809FB3                     ;MapSummitSpring?

        %Set16bit(!M)
        LDA.B !OBJ_Offset_Y
        CMP.B !OBJ_clamp_up
        BNE .Bank80_MainLogicBranch_809F7D
        JMP.W .return

    .Bank80_MainLogicBranch_809F7D:
        CMP.B !OBJ_clamp_down
        BNE .Bank80_MainLogicBranch_809F84
        JMP.W .return

    .Bank80_MainLogicBranch_809F84:
        LDA.B !OBJ_Offset_X
        STA.W !BG2_Map_Offset_X
        LDA.B $1E
        ASL A
        STA.B $1E
        %Set16bit(!MX)
        LDA.B !player_direction
        CMP.W #$0002                         ;left
        BNE .Bank80_MainLogicBranch_809F9A
        JMP.W .return

    .Bank80_MainLogicBranch_809F9A:
        %Set16bit(!MX)
        LDA.B !player_direction
        CMP.W #$0003                         ;Right
        BNE .Bank80_MainLogicBranch_809FA6
        JMP.W .return

    .Bank80_MainLogicBranch_809FA6:
        LDA.B !OBJ_Offset_Y
        LSR A
        CLC
        ADC.W #$0080
        STA.W !BG2_Map_Offset_Y
        JMP.W .return

    .Bank80_MainLogicBranch_809FB3:
        %Set16bit(!MX)
        LDA.W $0196
        AND.W #$0002                         ;FLAG196 not raining???
        BEQ .Bank80_MainLogicBranch_809FCA
        LDA.B !OBJ_Offset_X
        STA.W !BG2_Map_Offset_X
        LDA.B !OBJ_Offset_Y
        STA.W !BG2_Map_Offset_Y
        JMP.W .return

    .Bank80_MainLogicBranch_809FCA:
        %Set16bit(!MX)
        LDA.W $0196
        AND.W #$0004                         ;FLAG196 Sunny
        BNE .Bank80_MainLogicBranch_809FD7
        JMP.W .Bank80_MainLogicBranch_80A096

    .Bank80_MainLogicBranch_809FD7:
        %Set16bit(!MX)
        LDA.B !player_direction
        CMP.W #$0000                         ;down
        BNE .Bank80_MainLogicBranch_809FE3
        JMP.W .Bank80_MainLogicBranch_80A033

    .Bank80_MainLogicBranch_809FE3:
        %Set16bit(!MX)
        LDA.B !player_direction
        CMP.W #$0001                         ;up
        BNE .Bank80_MainLogicBranch_809FEF
        JMP.W .Bank80_MainLogicBranch_80A04A

    .Bank80_MainLogicBranch_809FEF:
        %Set16bit(!MX)
        LDA.B !player_direction
        CMP.W #$0002                         ;left
        BNE .Bank80_MainLogicBranch_809FFB
        JMP.W .Bank80_MainLogicBranch_80A061

    .Bank80_MainLogicBranch_809FFB:
        %Set16bit(!MX)
        LDA.B !player_direction
        CMP.W #$0003                         ;right
        BNE .Bank80_MainLogicBranch_80A007
        JMP.W .Bank80_MainLogicBranch_80A078

    .Bank80_MainLogicBranch_80A007:
        %Set8bit(!M)
        LDA.W $091C
        INC A
        STA.W $091C
        CMP.B #$0A
        BEQ .Bank80_MainLogicBranch_80A017
        JMP.W .return

    .Bank80_MainLogicBranch_80A017:
        STZ.W $091C
        %Set16bit(!M)
        LDA.W !BG2_Map_Offset_X
        CLC
        ADC.W #$0001
        STA.W !BG2_Map_Offset_X
        LDA.W !BG2_Map_Offset_Y
        SEC
        SBC.W #$0001
        STA.W !BG2_Map_Offset_Y
        JMP.W .return

    .Bank80_MainLogicBranch_80A033:
        %Set16bit(!MX)
        LDA.B !OBJ_Offset_Y
        CMP.B !OBJ_clamp_up
        BEQ .Bank80_MainLogicBranch_80A007
        CMP.B !OBJ_clamp_down
        BEQ .Bank80_MainLogicBranch_80A007
        LDA.W !BG2_Map_Offset_Y
        CLC
        ADC.B $1E
        STA.W !BG2_Map_Offset_Y
        BRA .Bank80_MainLogicBranch_80A007

    .Bank80_MainLogicBranch_80A04A:
        %Set16bit(!MX)
        LDA.B !OBJ_Offset_Y
        CMP.B !OBJ_clamp_up
        BEQ .Bank80_MainLogicBranch_80A007
        CMP.B !OBJ_clamp_down
        BEQ .Bank80_MainLogicBranch_80A007
        LDA.W !BG2_Map_Offset_Y
        SEC
        SBC.B $1E
        STA.W !BG2_Map_Offset_Y
        BRA .Bank80_MainLogicBranch_80A007

    .Bank80_MainLogicBranch_80A061:
        %Set16bit(!MX)
        LDA.B !OBJ_Offset_X
        CMP.B !OBJ_clamp_left
        BEQ .Bank80_MainLogicBranch_80A007
        CMP.B !OBJ_clamp_right
        BEQ .Bank80_MainLogicBranch_80A007
        LDA.W !BG2_Map_Offset_X
        CLC
        ADC.B $1E
        STA.W !BG2_Map_Offset_X
        BRA .Bank80_MainLogicBranch_80A007

    .Bank80_MainLogicBranch_80A078:
        %Set16bit(!MX)
        LDA.B !OBJ_Offset_X
        CMP.B !OBJ_clamp_left
        BNE .Bank80_MainLogicBranch_80A083
        JMP.W .Bank80_MainLogicBranch_80A007

    .Bank80_MainLogicBranch_80A083:
        CMP.B !OBJ_clamp_right
        BNE .Bank80_MainLogicBranch_80A08A
        JMP.W .Bank80_MainLogicBranch_80A007
    .Bank80_MainLogicBranch_80A08A:
        LDA.W !BG2_Map_Offset_X
        SEC
        SBC.B $1E
        STA.W !BG2_Map_Offset_X
        JMP.W .Bank80_MainLogicBranch_80A007

    .Bank80_MainLogicBranch_80A096:
        %Set16bit(!MX)
        LDA.W $0196
        AND.W #$0008
        BEQ .return
        LDA.B !OBJ_Offset_X
        STA.W !BG2_Map_Offset_X
        LDA.B !OBJ_Offset_Y
        STA.W !BG2_Map_Offset_Y

    .return: RTL

;;;;;;;;
Camera_UpdateVerticalBGOffsetDown: ;80A0AB
        %Set16bit(!MX)
        LDA.B !OBJ_Offset_Y
        STA.W !BG1_Map_Offset_Y
        CMP.B !OBJ_clamp_up
        BEQ .return
        CMP.B !OBJ_clamp_down
        BEQ .return
        CMP.B $1E
        BCS .bigger
        STA.B $1E

    .bigger:
        %Set16bit(!M)
        LDA.W $0196
        AND.W #$0001
        BEQ .return
        %Set8bit(!M)
        LDA.B !BG_subpixel_offset_Y
        CLC
        ADC.B $1E
        STA.B !BG_subpixel_offset_Y
        CMP.B #$08
        BCC .return
        SEC
        SBC.B #$08
        STA.B !BG_subpixel_offset_Y
        JSL.L MapRenderer_StreamRowsForVerticalScrollDown

    .return: RTL

;;;;;;;;
Camera_UpdateVerticalBGOffsetUp: ;80A0E1
        %Set16bit(!MX)
        LDA.B !OBJ_Offset_Y
        STA.W !BG1_Map_Offset_Y
        CMP.B !OBJ_clamp_up
        BEQ $2F
        CMP.B !OBJ_clamp_down
        BEQ $2B
        LDA.B !OBJ_clamp_down
        SEC
        SBC.B !OBJ_Offset_Y
        CMP.B $1E
        BCS .Bank80_MainLogicBranch_80A0FB
        STA.B $1E

    .Bank80_MainLogicBranch_80A0FB:
        %Set16bit(!M)
        LDA.W $0196
        AND.W #$0001
        BEQ $16
        %Set8bit(!M)
        LDA.B !BG_subpixel_offset_Y
        SEC
        SBC.B $1E
        STA.B !BG_subpixel_offset_Y
        BPL $0B
        LDA.B #$08
        CLC
        ADC.B !BG_subpixel_offset_Y
        STA.B !BG_subpixel_offset_Y
        JSL.L MapRenderer_StreamRowsForVerticalScrollUp
        RTL

;;;;;;;;
Camera_UpdateHorizontalBGOffsetRight: ;80A11C
        %Set16bit(!MX)
        LDA.B !OBJ_Offset_X
        STA.W !BG1_Map_Offset_X
        CMP.B !OBJ_clamp_left
        BEQ .return
        CMP.B !OBJ_clamp_right
        BEQ .return
        CMP.B $1E
        BCS .Bank80_MainLogicBranch_80A131
        STA.B $1E

    .Bank80_MainLogicBranch_80A131:
        %Set16bit(!M)
        LDA.W $0196
        AND.W #$0001                         ;FLAG196 Fair climate?
        BEQ .return
        %Set8bit(!M)
        LDA.B !BG_subpixel_offset_X
        CLC
        ADC.B $1E
        STA.B !BG_subpixel_offset_X
        CMP.B #$08
        BCC .return
        SEC
        SBC.B #$08
        STA.B !BG_subpixel_offset_X
        JSL.L MapRenderer_StreamColumnsForHorizontalScrollRight
                                            ;      ;      ;
        .return: RTL                                  ;80A151;      ;END_ASSSS

;;;;;;;;
MapScroll_UpdateFarEdgeOutdoorLeftStream: ;80A152
        %Set16bit(!MX)                             ;      ;
        LDA.B !OBJ_Offset_X                            ;80A154;0000F5;
        STA.W !BG1_Map_Offset_X                          ;80A156;00013C;
        CMP.B !OBJ_clamp_left                            ;80A159;0000ED;
        BEQ Bank80_MainLogicBranch_80A18C                      ;80A15B;80A18C;
        CMP.B !OBJ_clamp_right                            ;80A15D;0000F1;
        BEQ Bank80_MainLogicBranch_80A18C                      ;80A15F;80A18C;
        LDA.B !OBJ_clamp_right                            ;80A161;0000F1;
        SEC                                  ;80A163;      ;
        SBC.B !OBJ_Offset_X                            ;80A164;0000F5;
        CMP.B $1E                            ;80A166;00001E;
        BCS Bank80_MainLogicBranch_80A16C                      ;80A168;80A16C;
        STA.B $1E                            ;80A16A;00001E;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A16C: %Set16bit(!M)                             ;80A16C;      ;
        LDA.W $0196                          ;80A16E;000196;
        AND.W #$0001                         ;80A171;      ;
        BEQ Bank80_MainLogicBranch_80A18C                      ;80A174;80A18C;
        %Set8bit(!M)                             ;80A176;      ;
        LDA.B !BG_subpixel_offset_X                            ;80A178;000020;
        SEC                                  ;80A17A;      ;
        SBC.B $1E                            ;80A17B;00001E;
        STA.B !BG_subpixel_offset_X                            ;80A17D;000020;
        BPL Bank80_MainLogicBranch_80A18C                      ;80A17F;80A18C;
        LDA.B #$08                           ;80A181;      ;
        CLC                                  ;80A183;      ;
        ADC.B !BG_subpixel_offset_X                            ;80A184;000020;
        STA.B !BG_subpixel_offset_X                            ;80A186;000020;
        JSL.L MapRenderer_StreamColumnsForHorizontalScrollLeft                    ;80A188;80A617;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A18C: RTL                                  ;80A18C;      ;END_MapScroll_UpdateFarEdgeOutdoorLeftStream

;;;;;;;;
MapRenderer_StreamRowsForVerticalScrollDown: ;80A18D
        %Set16bit(!MX)                             ;      ;Some data copying?
        LDA.B $12                            ;80A18F;000012;
        CMP.W #$0020                         ;80A191;      ;
        BCC Bank80_MainLogicBranch_80A1B1                      ;80A194;80A1B1;
        CMP.W #$0040                         ;80A196;      ;
        BCC Bank80_MainLogicBranch_80A1BB                      ;80A199;80A1BB;
        CMP.W #$0060                         ;80A19B;      ;
        BCC Bank80_MainLogicBranch_80A1CB                      ;80A19E;80A1CB;
        CMP.W #$0080                         ;80A1A0;      ;
        BCC Bank80_MainLogicBranch_80A1DB                      ;80A1A3;80A1DB;
        CMP.W #$00A0                         ;80A1A5;      ;
        BCC Bank80_MainLogicBranch_80A1EE                      ;80A1A8;80A1EE;
        CMP.W #$00C0                         ;80A1AA;      ;
        BCC Bank80_MainLogicBranch_80A201                      ;80A1AD;80A201;
        BRA Bank80_MainLogicBranch_80A21A                      ;80A1AF;80A21A;
                                            ;      ;      ;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A1B1:
        STZ.B $7E                            ;80A1B1;00007E;
        STZ.B $80                            ;80A1B3;000080;
        STZ.B $82                            ;80A1B5;000082;
        STZ.B $84                            ;80A1B7;000084;
        BRA Bank80_MainLogicBranch_80A21A                      ;80A1B9;80A21A;
                                            ;      ;      ;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A1BB:
        LDA.B $12                            ;80A1BB;000012;
        SEC                                  ;80A1BD;      ;
        SBC.W #$0020                         ;80A1BE;      ;
        STA.B $7E                            ;80A1C1;00007E;
        STA.B $80                            ;80A1C3;000080;
        STZ.B $82                            ;80A1C5;000082;
        STZ.B $84                            ;80A1C7;000084;
        BRA Bank80_MainLogicBranch_80A21A                      ;80A1C9;80A21A;
                                            ;      ;      ;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A1CB:
        LDA.B $12                            ;80A1CB;000012;
        SEC                                  ;80A1CD;      ;
        SBC.W #$0020                         ;80A1CE;      ;
        STA.B $7E                            ;80A1D1;00007E;
        STA.B $80                            ;80A1D3;000080;
        STZ.B $82                            ;80A1D5;000082;
        STZ.B $84                            ;80A1D7;000084;
        BRA Bank80_MainLogicBranch_80A21A                      ;80A1D9;80A21A;
                                            ;      ;      ;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A1DB:
        LDA.W #$0080                         ;80A1DB;      ;
        STA.B $7E                            ;80A1DE;00007E;
        STZ.B $80                            ;80A1E0;000080;
        LDA.B $12                            ;80A1E2;000012;
        SEC                                  ;80A1E4;      ;
        SBC.W #$0060                         ;80A1E5;      ;
        STA.B $82                            ;80A1E8;000082;
        STA.B $84                            ;80A1EA;000084;
        BRA Bank80_MainLogicBranch_80A21A                      ;80A1EC;80A21A;
                                            ;      ;      ;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A1EE:
        LDA.W #$0080                         ;80A1EE;      ;
        STA.B $7E                            ;80A1F1;00007E;
        STZ.B $80                            ;80A1F3;000080;
        LDA.B $12                            ;80A1F5;000012;
        SEC                                  ;80A1F7;      ;
        SBC.W #$0060                         ;80A1F8;      ;
        STA.B $82                            ;80A1FB;000082;
        STA.B $84                            ;80A1FD;000084;
        BRA Bank80_MainLogicBranch_80A21A                      ;80A1FF;80A21A;
                                            ;      ;      ;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A201:
        LDA.B $12                            ;80A201;000012;
        SEC                                  ;80A203;      ;
        SBC.W #$0020                         ;80A204;      ;
        STA.B $7E                            ;80A207;00007E;
        LDA.B $12                            ;80A209;000012;
        SEC                                  ;80A20B;      ;
        SBC.W #$00A0                         ;80A20C;      ;
        STA.B $80                            ;80A20F;000080;
        LDA.W #$0080                         ;80A211;      ;
        STA.B $82                            ;80A214;000082;
        STZ.B $84                            ;80A216;000084;
        BRA Bank80_MainLogicBranch_80A21A                      ;80A218;80A21A;
                                            ;      ;      ;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A21A:
        LDA.B $1C                            ;80A21A;00001C;
        LSR A                                ;80A21C;      ;
        LSR A                                ;80A21D;      ;
        STA.B $86                            ;80A21E;000086;
        LDA.W #$2000                         ;80A220;      ;
        CLC                                  ;80A223;      ;
        ADC.B $16                            ;80A224;000016;
        ADC.B $1C                            ;80A226;00001C;
        SEC                                  ;80A228;      ;
        SBC.B $86                            ;80A229;000086;
        STA.B $72                            ;80A22B;000072;
        CLC                                  ;80A22D;      ;
        ADC.W #$0040                         ;80A22E;      ;
        STA.B $75                            ;80A231;000075;
        %Set8bit(!M)                             ;80A233;      ;
        LDA.B #$7E                           ;80A235;      ;
        STA.B $74                            ;80A237;000074;
        STA.B $77                            ;80A239;000077;
        %Set16bit(!M)                             ;80A23B;      ;
        LDX.W #$0000                         ;80A23D;      ;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A240:
        PHX                                  ;80A240;      ;
        LDA.B $80                            ;80A241;000080;
        CMP.W #$0040                         ;80A243;      ;
        BNE Bank80_MainLogicBranch_80A252                      ;80A246;80A252;
        STZ.B $80                            ;80A248;000080;
        LDA.B $7E                            ;80A24A;00007E;
        CLC                                  ;80A24C;      ;
        ADC.W #$0040                         ;80A24D;      ;
        STA.B $7E                            ;80A250;00007E;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A252:
        LDA.B $84                            ;80A252;000084;
        CMP.W #$0040                         ;80A254;      ;
        BNE Bank80_MainLogicBranch_80A263                      ;80A257;80A263;
        STZ.B $84                            ;80A259;000084;
        LDA.B $82                            ;80A25B;000082;
        CLC                                  ;80A25D;      ;
        ADC.W #$0040                         ;80A25E;      ;
        STA.B $82                            ;80A261;000082;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A263:
        LDY.B $7E                            ;80A263;00007E;
        LDX.B $80                            ;80A265;000080;
        LDA.B [$72],Y                        ;80A267;000072;
        STA.W $0746,X                        ;80A269;000746;
        LDY.B $82                            ;80A26C;000082;
        LDX.B $84                            ;80A26E;000084;
        LDA.B [$75],Y                        ;80A270;000075;
        STA.W $07C6,X                        ;80A272;0007C6;
        INC.B $7E                            ;80A275;00007E;
        INC.B $7E                            ;80A277;00007E;
        INC.B $80                            ;80A279;000080;
        INC.B $80                            ;80A27B;000080;
        INC.B $82                            ;80A27D;000082;
        INC.B $82                            ;80A27F;000082;
        INC.B $84                            ;80A281;000084;
        INC.B $84                            ;80A283;000084;
        PLX                                  ;80A285;      ;
        INX                                  ;80A286;      ;
        INX                                  ;80A287;      ;
        CPX.W #$0040                         ;80A288;      ;
        BNE Bank80_MainLogicBranch_80A240                      ;80A28B;80A240;
        %Set8bit(!M)                             ;80A28D;      ;
        LDA.B #$00                           ;80A28F;      ;
        STA.B !ProgDMA_Channel_Index                            ;80A291;000027;
        LDA.B #$18                           ;80A293;      ;
        STA.B !ProgDMA_Destination_Memory                            ;80A295;000029;
        %Set16bit(!M)                             ;80A297;      ;
        LDY.W #$0040                         ;80A299;      ;
        LDA.B $14                            ;80A29C;000014;
        CLC                                  ;80A29E;      ;
        ADC.W #$6000                         ;80A29F;      ;
        TAX                                  ;80A2A2;      ;
        LDA.W #$0746                         ;80A2A3;      ;
        STA.B $72                            ;80A2A6;000072;
        %Set8bit(!M)                             ;80A2A8;      ;
        LDA.B #$80                           ;80A2AA;      ;
        STA.B $74                            ;80A2AC;000074;
        %Set16bit(!M)                             ;80A2AE;      ;
        LDA.W #$0080                         ;80A2B0;      ;
        JSL.L AddProgrammedDMA                ;80A2B3;808A33;
        %Set8bit(!M)                             ;80A2B7;      ;
        LDA.B #$01                           ;80A2B9;      ;
        STA.B !ProgDMA_Channel_Index                            ;80A2BB;000027;
        LDA.B #$18                           ;80A2BD;      ;
        STA.B !ProgDMA_Destination_Memory                            ;80A2BF;000029;
        %Set16bit(!M)                             ;80A2C1;      ;
        LDY.W #$0040                         ;80A2C3;      ;
        LDA.B $14                            ;80A2C6;000014;
        CLC                                  ;80A2C8;      ;
        ADC.W #$6000                         ;80A2C9;      ;
        ADC.W #$0400                         ;80A2CC;      ;
        TAX                                  ;80A2CF;      ;
        LDA.W #$07C6                         ;80A2D0;      ;
        STA.B $72                            ;80A2D3;000072;
        %Set8bit(!M)                             ;80A2D5;      ;
        LDA.B #$80                           ;80A2D7;      ;
        STA.B $74                            ;80A2D9;000074;
        %Set16bit(!M)                             ;80A2DB;      ;
        LDA.W #$0080                         ;80A2DD;      ;
        JSL.L AddProgrammedDMA                ;80A2E0;808A33;
        %Set16bit(!MX)                             ;80A2E4;      ;
        LDA.B $16                            ;80A2E6;000016;
        CLC                                  ;80A2E8;      ;
        ADC.B $1A                            ;80A2E9;00001A;
        STA.B $16                            ;80A2EB;000016;
        LDA.B $14                            ;80A2ED;000014;
        CLC                                  ;80A2EF;      ;
        ADC.W #$0020                         ;80A2F0;      ;
        CMP.W #$0400                         ;80A2F3;      ;
        BNE Bank80_MainLogicBranch_80A2FD                      ;80A2F6;80A2FD;
        LDA.W #$0800                         ;80A2F8;      ;
        BRA Bank80_MainLogicBranch_80A305                      ;80A2FB;80A305;
                                            ;      ;      ;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A2FD:
        CMP.W #$0C00                         ;80A2FD;      ;
        BNE Bank80_MainLogicBranch_80A305                      ;80A300;80A305;
        LDA.W #$0000                         ;80A302;      ;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A305:
        STA.B $14                            ;80A305;000014;
        RTL                                  ;80A307;      ;END_MapRenderer_StreamRowsForVerticalScrollDown

;;;;;;;;
MapRenderer_StreamRowsForVerticalScrollUp: ;80A308
        %Set16bit(!MX)                             ;      ;
        LDA.B $12                            ;80A30A;000012;
        CMP.W #$0020                         ;80A30C;      ;
        BCC Bank80_MainLogicBranch_80A32C                      ;80A30F;80A32C;
        CMP.W #$0040                         ;80A311;      ;
        BCC Bank80_MainLogicBranch_80A336                      ;80A314;80A336;
        CMP.W #$0060                         ;80A316;      ;
        BCC Bank80_MainLogicBranch_80A346                      ;80A319;80A346;
        CMP.W #$0080                         ;80A31B;      ;
        BCC Bank80_MainLogicBranch_80A356                      ;80A31E;80A356;
        CMP.W #$00A0                         ;80A320;      ;
        BCC Bank80_MainLogicBranch_80A369                      ;80A323;80A369;
        CMP.W #$00C0                         ;80A325;      ;
        BCC Bank80_MainLogicBranch_80A37C                      ;80A328;80A37C;
        BRA Bank80_MainLogicBranch_80A395                      ;80A32A;80A395;
                                            ;      ;      ;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A32C:
        STZ.B $7E                            ;80A32C;00007E;
        STZ.B $80                            ;80A32E;000080;
        STZ.B $82                            ;80A330;000082;
        STZ.B $84                            ;80A332;000084;
        BRA Bank80_MainLogicBranch_80A395                      ;80A334;80A395;
                                            ;      ;      ;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A336:
        LDA.B $12                            ;80A336;000012;
        SEC                                  ;80A338;      ;
        SBC.W #$0020                         ;80A339;      ;
        STA.B $7E                            ;80A33C;00007E;
        STA.B $80                            ;80A33E;000080;
        STZ.B $82                            ;80A340;000082;
        STZ.B $84                            ;80A342;000084;
        BRA Bank80_MainLogicBranch_80A395                      ;80A344;80A395;
                                            ;      ;      ;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A346:
        LDA.B $12                            ;80A346;000012;
        SEC                                  ;80A348;      ;
        SBC.W #$0020                         ;80A349;      ;
        STA.B $7E                            ;80A34C;00007E;
        STA.B $80                            ;80A34E;000080;
        STZ.B $82                            ;80A350;000082;
        STZ.B $84                            ;80A352;000084;
        BRA Bank80_MainLogicBranch_80A395                      ;80A354;80A395;
                                            ;      ;      ;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A356:
        LDA.W #$0080                         ;80A356;      ;
        STA.B $7E                            ;80A359;00007E;
        STZ.B $80                            ;80A35B;000080;
        LDA.B $12                            ;80A35D;000012;
        SEC                                  ;80A35F;      ;
        SBC.W #$0060                         ;80A360;      ;
        STA.B $82                            ;80A363;000082;
        STA.B $84                            ;80A365;000084;
        BRA Bank80_MainLogicBranch_80A395                      ;80A367;80A395;
                                            ;      ;      ;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A369:
        LDA.W #$0080                         ;80A369;      ;
        STA.B $7E                            ;80A36C;00007E;
        STZ.B $80                            ;80A36E;000080;
        LDA.B $12                            ;80A370;000012;
        SEC                                  ;80A372;      ;
        SBC.W #$0060                         ;80A373;      ;
        STA.B $82                            ;80A376;000082;
        STA.B $84                            ;80A378;000084;
        BRA Bank80_MainLogicBranch_80A395                      ;80A37A;80A395;
                                            ;      ;      ;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A37C:
        LDA.B $12                            ;80A37C;000012;
        SEC                                  ;80A37E;      ;
        SBC.W #$0020                         ;80A37F;      ;
        STA.B $7E                            ;80A382;00007E;
        LDA.B $12                            ;80A384;000012;
        SEC                                  ;80A386;      ;
        SBC.W #$00A0                         ;80A387;      ;
        STA.B $80                            ;80A38A;000080;
        LDA.W #$0080                         ;80A38C;      ;
        STA.B $82                            ;80A38F;000082;
        STZ.B $84                            ;80A391;000084;
        BRA Bank80_MainLogicBranch_80A395                      ;80A393;80A395;
                                            ;      ;      ;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A395:
        LDA.B $1C                            ;80A395;00001C;
        LSR A                                ;80A397;      ;
        LSR A                                ;80A398;      ;
        STA.B $86                            ;80A399;000086;
        LDA.W #$2000                         ;80A39B;      ;
        CLC                                  ;80A39E;      ;
        ADC.B $16                            ;80A39F;000016;
        SEC                                  ;80A3A1;      ;
        SBC.B $86                            ;80A3A2;000086;
        STA.B $72                            ;80A3A4;000072;
        CLC                                  ;80A3A6;      ;
        ADC.W #$0040                         ;80A3A7;      ;
        STA.B $75                            ;80A3AA;000075;
        %Set8bit(!M)                             ;80A3AC;      ;
        LDA.B #$7E                           ;80A3AE;      ;
        STA.B $74                            ;80A3B0;000074;
        STA.B $77                            ;80A3B2;000077;
        %Set16bit(!M)                             ;80A3B4;      ;
        LDX.W #$0000                         ;80A3B6;      ;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A3B9:
        PHX                                  ;80A3B9;      ;
        LDA.B $80                            ;80A3BA;000080;
        CMP.W #$0040                         ;80A3BC;      ;
        BNE Bank80_MainLogicBranch_80A3CB                      ;80A3BF;80A3CB;
        STZ.B $80                            ;80A3C1;000080;
        LDA.B $7E                            ;80A3C3;00007E;
        CLC                                  ;80A3C5;      ;
        ADC.W #$0040                         ;80A3C6;      ;
        STA.B $7E                            ;80A3C9;00007E;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A3CB:
        LDA.B $84                            ;80A3CB;000084;
        CMP.W #$0040                         ;80A3CD;      ;
        BNE Bank80_MainLogicBranch_80A3DC                      ;80A3D0;80A3DC;
        STZ.B $84                            ;80A3D2;000084;
        LDA.B $82                            ;80A3D4;000082;
        CLC                                  ;80A3D6;      ;
        ADC.W #$0040                         ;80A3D7;      ;
        STA.B $82                            ;80A3DA;000082;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A3DC:
        LDY.B $7E                            ;80A3DC;00007E;
        LDX.B $80                            ;80A3DE;000080;
        LDA.B [$72],Y                        ;80A3E0;000072;
        STA.W $0746,X                        ;80A3E2;000746;
        LDY.B $82                            ;80A3E5;000082;
        LDX.B $84                            ;80A3E7;000084;
        LDA.B [$75],Y                        ;80A3E9;000075;
        STA.W $07C6,X                        ;80A3EB;0007C6;
        INC.B $7E                            ;80A3EE;00007E;
        INC.B $7E                            ;80A3F0;00007E;
        INC.B $80                            ;80A3F2;000080;
        INC.B $80                            ;80A3F4;000080;
        INC.B $82                            ;80A3F6;000082;
        INC.B $82                            ;80A3F8;000082;
        INC.B $84                            ;80A3FA;000084;
        INC.B $84                            ;80A3FC;000084;
        PLX                                  ;80A3FE;      ;
        INX                                  ;80A3FF;      ;
        INX                                  ;80A400;      ;
        CPX.W #$0040                         ;80A401;      ;
        BNE Bank80_MainLogicBranch_80A3B9                      ;80A404;80A3B9;
        %Set8bit(!M)                             ;80A406;      ;
        LDA.B #$00                           ;80A408;      ;
        STA.B !ProgDMA_Channel_Index                            ;80A40A;000027;
        LDA.B #$18                           ;80A40C;      ;
        STA.B !ProgDMA_Destination_Memory                            ;80A40E;000029;
        %Set16bit(!M)                             ;80A410;      ;
        LDY.W #$0040                         ;80A412;      ;
        LDA.B $14                            ;80A415;000014;
        CLC                                  ;80A417;      ;
        ADC.W #$6000                         ;80A418;      ;
        TAX                                  ;80A41B;      ;
        LDA.W #$0746                         ;80A41C;      ;
        STA.B $72                            ;80A41F;000072;
        %Set8bit(!M)                             ;80A421;      ;
        LDA.B #$80                           ;80A423;      ;
        STA.B $74                            ;80A425;000074;
        %Set16bit(!M)                             ;80A427;      ;
        LDA.W #$0080                         ;80A429;      ;
        JSL.L AddProgrammedDMA                ;80A42C;808A33;
        %Set8bit(!M)                             ;80A430;      ;
        LDA.B #$01                           ;80A432;      ;
        STA.B !ProgDMA_Channel_Index                            ;80A434;000027;
        LDA.B #$18                           ;80A436;      ;
        STA.B !ProgDMA_Destination_Memory                            ;80A438;000029;
        %Set16bit(!M)                             ;80A43A;      ;
        LDY.W #$0040                         ;80A43C;      ;
        LDA.B $14                            ;80A43F;000014;
        CLC                                  ;80A441;      ;
        ADC.W #$6000                         ;80A442;      ;
        ADC.W #$0400                         ;80A445;      ;
        TAX                                  ;80A448;      ;
        LDA.W #$07C6                         ;80A449;      ;
        STA.B $72                            ;80A44C;000072;
        %Set8bit(!M)                             ;80A44E;      ;
        LDA.B #$80                           ;80A450;      ;
        STA.B $74                            ;80A452;000074;
        %Set16bit(!M)                             ;80A454;      ;
        LDA.W #$0080                         ;80A456;      ;
        JSL.L AddProgrammedDMA                ;80A459;808A33;
        %Set16bit(!MX)                             ;80A45D;      ;
        LDA.B $16                            ;80A45F;000016;
        SEC                                  ;80A461;      ;
        SBC.B $1A                            ;80A462;00001A;
        STA.B $16                            ;80A464;000016;
        LDA.B $14                            ;80A466;000014;
        SEC                                  ;80A468;      ;
        SBC.W #$0020                         ;80A469;      ;
        CMP.W #$FFE0                         ;80A46C;      ;
        BNE Bank80_MainLogicBranch_80A476                      ;80A46F;80A476;
        LDA.W #$0BE0                         ;80A471;      ;
        BRA Bank80_MainLogicBranch_80A47E                      ;80A474;80A47E;
                                            ;      ;      ;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A476:
        CMP.W #$07E0                         ;80A476;      ;
        BNE Bank80_MainLogicBranch_80A47E                      ;80A479;80A47E;
        LDA.W #$03E0                         ;80A47B;      ;
                                            ;      ;      ;
    Bank80_MainLogicBranch_80A47E:
        STA.B $14                            ;80A47E;000014;
        RTL                                  ;80A480;      ;END_MapRenderer_StreamRowsForVerticalScrollUp

;;;;;;;;
MapRenderer_StreamColumnsForHorizontalScrollRight: ;80A481
        %Set16bit(!MX)                             ;80A481;      ;
        LDA.B $16                            ;80A483;000016;
        CMP.W #$1000                         ;80A485;      ;
        BCC Bank80_MainLogicBranch_80A4A6                      ;80A488;80A4A6;
        CMP.W #$2000                         ;80A48A;      ;
        BCC Bank80_MainLogicBranch_80A4B1                      ;80A48D;80A4B1;
        CMP.W #$3000                         ;80A48F;      ;
        BCC Bank80_MainLogicBranch_80A4C6                      ;80A492;80A4C6;
        CMP.W #$4000                         ;80A494;      ;
        BCC Bank80_MainLogicBranch_80A4DB                      ;80A497;80A4DB;
        CMP.W #$5000                         ;80A499;      ;
        BCC Bank80_MainLogicBranch_80A4F3                      ;80A49C;80A4F3;
        CMP.W #$6000                         ;80A49E;      ;
        BCC Bank80_MainLogicBranch_80A50B                      ;80A4A1;80A50B;
        JMP.W Bank80_MainLogicBranch_80A529                    ;80A4A3;80A529;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A4A6:
        STZ.B $7E                            ;80A4A6;00007E;
        STZ.B $80                            ;80A4A8;000080;
        STZ.B $82                            ;80A4AA;000082;
        STZ.B $84                            ;80A4AC;000084;
        JMP.W Bank80_MainLogicBranch_80A529                    ;80A4AE;80A529;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A4B1:
        LDA.B $16                            ;80A4B1;000016;
        SEC                                  ;80A4B3;      ;
        SBC.W #$1000                         ;80A4B4;      ;
        STA.B $7E                            ;80A4B7;00007E;
        XBA                                  ;80A4B9;      ;
        AND.W #$001F                         ;80A4BA;      ;
        ASL A                                ;80A4BD;      ;
        STA.B $80                            ;80A4BE;000080;
        STZ.B $82                            ;80A4C0;000082;
        STZ.B $84                            ;80A4C2;000084;
        BRA Bank80_MainLogicBranch_80A529                      ;80A4C4;80A529;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A4C6:
        LDA.B $16                            ;80A4C6;000016;
        SEC                                  ;80A4C8;      ;
        SBC.W #$1000                         ;80A4C9;      ;
        STA.B $7E                            ;80A4CC;00007E;
        XBA                                  ;80A4CE;      ;
        AND.W #$001F                         ;80A4CF;      ;
        ASL A                                ;80A4D2;      ;
        STA.B $80                            ;80A4D3;000080;
        STZ.B $82                            ;80A4D5;000082;
        STZ.B $84                            ;80A4D7;000084;
        BRA Bank80_MainLogicBranch_80A529                      ;80A4D9;80A529;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A4DB:
        LDA.W #$4000                         ;80A4DB;      ;
        STA.B $7E                            ;80A4DE;00007E;
        STZ.B $80                            ;80A4E0;000080;
        LDA.B $16                            ;80A4E2;000016;
        SEC                                  ;80A4E4;      ;
        SBC.W #$3000                         ;80A4E5;      ;
        STA.B $82                            ;80A4E8;000082;
        XBA                                  ;80A4EA;      ;
        AND.W #$001F                         ;80A4EB;      ;
        ASL A                                ;80A4EE;      ;
        STA.B $84                            ;80A4EF;000084;
        BRA Bank80_MainLogicBranch_80A529                      ;80A4F1;80A529;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A4F3:
        LDA.W #$4000                         ;80A4F3;      ;
        STA.B $7E                            ;80A4F6;00007E;
        STZ.B $80                            ;80A4F8;000080;
        LDA.B $16                            ;80A4FA;000016;
        SEC                                  ;80A4FC;      ;
        SBC.W #$3000                         ;80A4FD;      ;
        STA.B $82                            ;80A500;000082;
        XBA                                  ;80A502;      ;
        AND.W #$001F                         ;80A503;      ;
        ASL A                                ;80A506;      ;
        STA.B $84                            ;80A507;000084;
        BRA Bank80_MainLogicBranch_80A529                      ;80A509;80A529;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A50B:
        LDA.B $16                            ;80A50B;000016;
        SEC                                  ;80A50D;      ;
        SBC.W #$1000                         ;80A50E;      ;
        STA.B $7E                            ;80A511;00007E;
        LDA.B $16                            ;80A513;000016;
        SEC                                  ;80A515;      ;
        SBC.W #$5000                         ;80A516;      ;
        XBA                                  ;80A519;      ;
        AND.W #$000F                         ;80A51A;      ;
        ASL A                                ;80A51D;      ;
        STA.B $80                            ;80A51E;000080;
        LDA.W #$4000                         ;80A520;      ;
        STA.B $82                            ;80A523;000082;
        STZ.B $84                            ;80A525;000084;
        BRA Bank80_MainLogicBranch_80A529                      ;80A527;80A529;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A529:
        LDA.W #$2000                         ;80A529;      ;
        CLC                                  ;80A52C;      ;
        ADC.B $12                            ;80A52D;000012;
        ADC.W #$0060                         ;80A52F;      ;
        STA.B $72                            ;80A532;000072;
        ADC.W #$2000                         ;80A534;      ;
        STA.B $75                            ;80A537;000075;
        %Set8bit(!M)                             ;80A539;      ;
        LDA.B #$7E                           ;80A53B;      ;
        STA.B $74                            ;80A53D;000074;
        STA.B $77                            ;80A53F;000077;
        %Set16bit(!M)                             ;80A541;      ;
        LDX.W #$0000                         ;80A543;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A546:
        PHX                                  ;80A546;      ;
        LDA.B $80                            ;80A547;000080;
        CMP.W #$0040                         ;80A549;      ;
        BNE Bank80_MainLogicBranch_80A558                      ;80A54C;80A558;
        STZ.B $80                            ;80A54E;000080;
        LDA.B $7E                            ;80A550;00007E;
        CLC                                  ;80A552;      ;
        ADC.W #$2000                         ;80A553;      ;
        STA.B $7E                            ;80A556;00007E;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A558:
        LDA.B $84                            ;80A558;000084;
        CMP.W #$0040                         ;80A55A;      ;
        BNE Bank80_MainLogicBranch_80A569                      ;80A55D;80A569;
        STZ.B $84                            ;80A55F;000084;
        LDA.B $82                            ;80A561;000082;
        CLC                                  ;80A563;      ;
        ADC.W #$2000                         ;80A564;      ;
        STA.B $82                            ;80A567;000082;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A569:
        LDY.B $7E                            ;80A569;00007E;
        LDX.B $80                            ;80A56B;000080;
        LDA.B [$72],Y                        ;80A56D;000072;
        STA.W $0746,X                        ;80A56F;000746;
        LDY.B $82                            ;80A572;000082;
        LDX.B $84                            ;80A574;000084;
        LDA.B [$75],Y                        ;80A576;000075;
        STA.W $07C6,X                        ;80A578;0007C6;
        LDA.B $7E                            ;80A57B;00007E;
        CLC                                  ;80A57D;      ;
        ADC.W #$0100                         ;80A57E;      ;
        STA.B $7E                            ;80A581;00007E;
        INC.B $80                            ;80A583;000080;
        INC.B $80                            ;80A585;000080;
        LDA.B $82                            ;80A587;000082;
        CLC                                  ;80A589;      ;
        ADC.W #$0100                         ;80A58A;      ;
        STA.B $82                            ;80A58D;000082;
        INC.B $84                            ;80A58F;000084;
        INC.B $84                            ;80A591;000084;
        PLX                                  ;80A593;      ;
        INX                                  ;80A594;      ;
        INX                                  ;80A595;      ;
        CPX.W #$0040                         ;80A596;      ;
        BNE Bank80_MainLogicBranch_80A546                      ;80A599;80A546;
        %Set8bit(!M)                             ;80A59B;      ;
        LDA.B #$00                           ;80A59D;      ;
        STA.B !ProgDMA_Channel_Index                            ;80A59F;000027;
        LDA.B #$18                           ;80A5A1;      ;
        STA.B !ProgDMA_Destination_Memory                            ;80A5A3;000029;
        %Set16bit(!M)                             ;80A5A5;      ;
        LDY.W #$0040                         ;80A5A7;      ;
        LDA.B $10                            ;80A5AA;000010;
        CLC                                  ;80A5AC;      ;
        ADC.W #$6000                         ;80A5AD;      ;
        TAX                                  ;80A5B0;      ;
        LDA.W #$0746                         ;80A5B1;      ;
        STA.B $72                            ;80A5B4;000072;
        %Set8bit(!M)                             ;80A5B6;      ;
        LDA.B #$80                           ;80A5B8;      ;
        STA.B $74                            ;80A5BA;000074;
        %Set16bit(!M)                             ;80A5BC;      ;
        LDA.W #$0081                         ;80A5BE;      ;
        JSL.L AddProgrammedDMA                ;80A5C1;808A33;
        %Set8bit(!M)                             ;80A5C5;      ;
        LDA.B #$01                           ;80A5C7;      ;
        STA.B !ProgDMA_Channel_Index                            ;80A5C9;000027;
        LDA.B #$18                           ;80A5CB;      ;
        STA.B !ProgDMA_Destination_Memory                            ;80A5CD;000029;
        %Set16bit(!M)                             ;80A5CF;      ;
        LDY.W #$0040                         ;80A5D1;      ;
        LDA.B $10                            ;80A5D4;000010;
        CLC                                  ;80A5D6;      ;
        ADC.W #$6000                         ;80A5D7;      ;
        ADC.W #$0800                         ;80A5DA;      ;
        TAX                                  ;80A5DD;      ;
        LDA.W #$07C6                         ;80A5DE;      ;
        STA.B $72                            ;80A5E1;000072;
        %Set8bit(!M)                             ;80A5E3;      ;
        LDA.B #$80                           ;80A5E5;      ;
        STA.B $74                            ;80A5E7;000074;
        %Set16bit(!M)                             ;80A5E9;      ;
        LDA.W #$0081                         ;80A5EB;      ;
        JSL.L AddProgrammedDMA                ;80A5EE;808A33;
        %Set16bit(!MX)                             ;80A5F2;      ;
        LDA.B $12                            ;80A5F4;000012;
        CLC                                  ;80A5F6;      ;
        ADC.W #$0002                         ;80A5F7;      ;
        STA.B $12                            ;80A5FA;000012;
        LDA.B $10                            ;80A5FC;000010;
        CLC                                  ;80A5FE;      ;
        ADC.W #$0001                         ;80A5FF;      ;
        CMP.W #$0020                         ;80A602;      ;
        BNE Bank80_MainLogicBranch_80A60C                      ;80A605;80A60C;
        LDA.W #$0400                         ;80A607;      ;
        BRA Bank80_MainLogicBranch_80A614                      ;80A60A;80A614;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A60C:
        CMP.W #$0420                         ;80A60C;      ;
        BNE Bank80_MainLogicBranch_80A614                      ;80A60F;80A614;
        LDA.W #$0000                         ;80A611;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A614:
        STA.B $10                            ;80A614;000010;

        RTL                                  ;80A616;      ;

;;;;;;;;
MapRenderer_StreamColumnsForHorizontalScrollLeft: ;80A617
        %Set16bit(!MX)                             ;      ;
        LDA.B $16                            ;80A619;000016;
        CMP.W #$1000                         ;80A61B;      ;
        BCC Bank80_MainLogicBranch_80A63C                      ;80A61E;80A63C;
        CMP.W #$2000                         ;80A620;      ;
        BCC Bank80_MainLogicBranch_80A646                      ;80A623;80A646;
        CMP.W #$3000                         ;80A625;      ;
        BCC Bank80_MainLogicBranch_80A65B                      ;80A628;80A65B;
        CMP.W #$4000                         ;80A62A;      ;
        BCC Bank80_MainLogicBranch_80A670                      ;80A62D;80A670;
        CMP.W #$5000                         ;80A62F;      ;
        BCC Bank80_MainLogicBranch_80A688                      ;80A632;80A688;
        CMP.W #$6000                         ;80A634;      ;
        BCC Bank80_MainLogicBranch_80A6A0                      ;80A637;80A6A0;
        JMP.W Bank80_MainLogicBranch_80A6BE                    ;80A639;80A6BE;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A63C:
        STZ.B $7E                            ;80A63C;00007E;
        STZ.B $80                            ;80A63E;000080;
        STZ.B $82                            ;80A640;000082;
        STZ.B $84                            ;80A642;000084;
        BRA Bank80_MainLogicBranch_80A6BE                      ;80A644;80A6BE;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A646:
        LDA.B $16                            ;80A646;000016;
        SEC                                  ;80A648;      ;
        SBC.W #$1000                         ;80A649;      ;
        STA.B $7E                            ;80A64C;00007E;
        XBA                                  ;80A64E;      ;
        AND.W #$001F                         ;80A64F;      ;
        ASL A                                ;80A652;      ;
        STA.B $80                            ;80A653;000080;
        STZ.B $82                            ;80A655;000082;
        STZ.B $84                            ;80A657;000084;
        BRA Bank80_MainLogicBranch_80A6BE                      ;80A659;80A6BE;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A65B:
        LDA.B $16                            ;80A65B;000016;
        SEC                                  ;80A65D;      ;
        SBC.W #$1000                         ;80A65E;      ;
        STA.B $7E                            ;80A661;00007E;
        XBA                                  ;80A663;      ;
        AND.W #$001F                         ;80A664;      ;
        ASL A                                ;80A667;      ;
        STA.B $80                            ;80A668;000080;
        STZ.B $82                            ;80A66A;000082;
        STZ.B $84                            ;80A66C;000084;
        BRA Bank80_MainLogicBranch_80A6BE                      ;80A66E;80A6BE;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A670:
        LDA.W #$4000                         ;80A670;      ;
        STA.B $7E                            ;80A673;00007E;
        STZ.B $80                            ;80A675;000080;
        LDA.B $16                            ;80A677;000016;
        SEC                                  ;80A679;      ;
        SBC.W #$3000                         ;80A67A;      ;
        STA.B $82                            ;80A67D;000082;
        XBA                                  ;80A67F;      ;
        AND.W #$001F                         ;80A680;      ;
        ASL A                                ;80A683;      ;
        STA.B $84                            ;80A684;000084;
        BRA Bank80_MainLogicBranch_80A6BE                      ;80A686;80A6BE;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A688:
        LDA.W #$4000                         ;80A688;      ;
        STA.B $7E                            ;80A68B;00007E;
        STZ.B $80                            ;80A68D;000080;
        LDA.B $16                            ;80A68F;000016;
        SEC                                  ;80A691;      ;
        SBC.W #$3000                         ;80A692;      ;
        STA.B $82                            ;80A695;000082;
        XBA                                  ;80A697;      ;
        AND.W #$001F                         ;80A698;      ;
        ASL A                                ;80A69B;      ;
        STA.B $84                            ;80A69C;000084;
        BRA Bank80_MainLogicBranch_80A6BE                      ;80A69E;80A6BE;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A6A0:
        LDA.B $16                            ;80A6A0;000016;
        SEC                                  ;80A6A2;      ;
        SBC.W #$1000                         ;80A6A3;      ;
        STA.B $7E                            ;80A6A6;00007E;
        LDA.B $16                            ;80A6A8;000016;
        SEC                                  ;80A6AA;      ;
        SBC.W #$5000                         ;80A6AB;      ;
        XBA                                  ;80A6AE;      ;
        AND.W #$001F                         ;80A6AF;      ;
        ASL A                                ;80A6B2;      ;
        STA.B $80                            ;80A6B3;000080;
        LDA.W #$4000                         ;80A6B5;      ;
        STA.B $82                            ;80A6B8;000082;
        STZ.B $84                            ;80A6BA;000084;
        BRA Bank80_MainLogicBranch_80A6BE                      ;80A6BC;80A6BE;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A6BE:
        LDA.W #$2000                         ;80A6BE;      ;
        CLC                                  ;80A6C1;      ;
        ADC.B $12                            ;80A6C2;000012;
        SEC                                  ;80A6C4;      ;
        SBC.W #$0020                         ;80A6C5;      ;
        STA.B $72                            ;80A6C8;000072;
        CLC                                  ;80A6CA;      ;
        ADC.W #$2000                         ;80A6CB;      ;
        STA.B $75                            ;80A6CE;000075;
        %Set8bit(!M)                             ;80A6D0;      ;
        LDA.B #$7E                           ;80A6D2;      ;
        STA.B $74                            ;80A6D4;000074;
        STA.B $77                            ;80A6D6;000077;
        %Set16bit(!M)                             ;80A6D8;      ;
        LDX.W #$0000                         ;80A6DA;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A6DD:
        PHX                                  ;80A6DD;      ;
        LDA.B $80                            ;80A6DE;000080;
        CMP.W #$0040                         ;80A6E0;      ;
        BNE Bank80_MainLogicBranch_80A6EF                      ;80A6E3;80A6EF;
        STZ.B $80                            ;80A6E5;000080;
        LDA.B $7E                            ;80A6E7;00007E;
        CLC                                  ;80A6E9;      ;
        ADC.W #$2000                         ;80A6EA;      ;
        STA.B $7E                            ;80A6ED;00007E;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A6EF:
        LDA.B $84                            ;80A6EF;000084;
        CMP.W #$0040                         ;80A6F1;      ;
        BNE Bank80_MainLogicBranch_80A700                      ;80A6F4;80A700;
        STZ.B $84                            ;80A6F6;000084;
        LDA.B $82                            ;80A6F8;000082;
        CLC                                  ;80A6FA;      ;
        ADC.W #$2000                         ;80A6FB;      ;
        STA.B $82                            ;80A6FE;000082;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A700:
        LDY.B $7E                            ;80A700;00007E;
        LDX.B $80                            ;80A702;000080;
        LDA.B [$72],Y                        ;80A704;000072;
        STA.W $0746,X                        ;80A706;000746;
        LDY.B $82                            ;80A709;000082;
        LDX.B $84                            ;80A70B;000084;
        LDA.B [$75],Y                        ;80A70D;000075;
        STA.W $07C6,X                        ;80A70F;0007C6;
        LDA.B $7E                            ;80A712;00007E;
        CLC                                  ;80A714;      ;
        ADC.W #$0100                         ;80A715;      ;
        STA.B $7E                            ;80A718;00007E;
        INC.B $80                            ;80A71A;000080;
        INC.B $80                            ;80A71C;000080;
        LDA.B $82                            ;80A71E;000082;
        CLC                                  ;80A720;      ;
        ADC.W #$0100                         ;80A721;      ;
        STA.B $82                            ;80A724;000082;
        INC.B $84                            ;80A726;000084;
        INC.B $84                            ;80A728;000084;
        PLX                                  ;80A72A;      ;
        INX                                  ;80A72B;      ;
        INX                                  ;80A72C;      ;
        CPX.W #$0040                         ;80A72D;      ;
        BNE Bank80_MainLogicBranch_80A6DD                      ;80A730;80A6DD;
        %Set8bit(!M)                             ;80A732;      ;
        LDA.B #$00                           ;80A734;      ;
        STA.B !ProgDMA_Channel_Index                            ;80A736;000027;
        LDA.B #$18                           ;80A738;      ;
        STA.B !ProgDMA_Destination_Memory                            ;80A73A;000029;
        %Set16bit(!M)                             ;80A73C;      ;
        LDY.W #$0040                         ;80A73E;      ;
        LDA.B $10                            ;80A741;000010;
        CLC                                  ;80A743;      ;
        ADC.W #$6000                         ;80A744;      ;
        TAX                                  ;80A747;      ;
        LDA.W #$0746                         ;80A748;      ;
        STA.B $72                            ;80A74B;000072;
        %Set8bit(!M)                             ;80A74D;      ;
        LDA.B #$80                           ;80A74F;      ;
        STA.B $74                            ;80A751;000074;
        %Set16bit(!M)                             ;80A753;      ;
        LDA.W #$0081                         ;80A755;      ;
        JSL.L AddProgrammedDMA                ;80A758;808A33;
        %Set8bit(!M)                             ;80A75C;      ;
        LDA.B #$01                           ;80A75E;      ;
        STA.B !ProgDMA_Channel_Index                            ;80A760;000027;
        LDA.B #$18                           ;80A762;      ;
        STA.B !ProgDMA_Destination_Memory                            ;80A764;000029;
        %Set16bit(!M)                             ;80A766;      ;
        LDY.W #$0040                         ;80A768;      ;
        LDA.B $10                            ;80A76B;000010;
        CLC                                  ;80A76D;      ;
        ADC.W #$6000                         ;80A76E;      ;
        ADC.W #$0800                         ;80A771;      ;
        TAX                                  ;80A774;      ;
        LDA.W #$07C6                         ;80A775;      ;
        STA.B $72                            ;80A778;000072;
        %Set8bit(!M)                             ;80A77A;      ;
        LDA.B #$80                           ;80A77C;      ;
        STA.B $74                            ;80A77E;000074;
        %Set16bit(!M)                             ;80A780;      ;
        LDA.W #$0081                         ;80A782;      ;
        JSL.L AddProgrammedDMA                ;80A785;808A33;
        %Set16bit(!MX)                             ;80A789;      ;
        LDA.B $12                            ;80A78B;000012;
        SEC                                  ;80A78D;      ;
        SBC.W #$0002                         ;80A78E;      ;
        STA.B $12                            ;80A791;000012;
        LDA.B $10                            ;80A793;000010;
        SEC                                  ;80A795;      ;
        SBC.W #$0001                         ;80A796;      ;
        CMP.W #$FFFF                         ;80A799;      ;
        BNE Bank80_MainLogicBranch_80A7A3                      ;80A79C;80A7A3;
        LDA.W #$041F                         ;80A79E;      ;
        BRA Bank80_MainLogicBranch_80A7AB                      ;80A7A1;80A7AB;
                                            ;      ;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A7A3:
        CMP.W #$03FF                         ;80A7A3;      ;
        BNE Bank80_MainLogicBranch_80A7AB                      ;80A7A6;80A7AB;
        LDA.W #$001F                         ;80A7A8;      ;
                                            ;      ;      ;
        Bank80_MainLogicBranch_80A7AB:
        STA.B $10                            ;80A7AB;000010;
        RTL                                  ;80A7AD;      ;

;;;;;;;;Sees to only be used in one place to get the value of $1, half of the data ORed with 196
;;;;;;;; Pass 26: Le byte do header de area em MapLoad_AreaGraphicsPointerTable.
;;;;;;;; Parametro: Y = offset dentro do bloco de area.
MapLoad_ReadAreaHeaderByte: ;80A7AE
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$00
        XBA
        LDA.B !tilemap_to_load
        %Set16bit(!M)
        ASL A
        TAX
        LDA.L MapLoad_AreaGraphicsPointerTable,X
        STA.B !tilemap_pointer
        %Set8bit(!M)
        LDA.B (!tilemap_pointer),Y
        RTL

;;;;;;;; Loads map data, including
;;;;;;;; Pass 26: Loader central de mapa/background.
;;;;;;;; Le o header da area, aplica preset grafico, decompressa tilemaps
;;;;;;;; e character maps para WRAM/VRAM, configura clamps de camera
;;;;;;;; e reposiciona player/background apos transicao.
MapLoad_DecompressAreaGraphicsAndSetCamera: ;80A7C6
        !number_of_tilemaps = $92
        !number_of_charactermaps = $93

        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$00
        XBA
        LDA.B !tilemap_to_load
        %Set16bit(!M)
        ASL A
        TAX
        LDA.L MapLoad_AreaGraphicsPointerTable,X
        STA.B !tilemap_pointer
        %Set8bit(!M)
        LDY.W #$0000
        LDA.B !tilemap_to_load
        CMP.B #$57                           ;after that value, theres splash screens
        BCS .singletilemapskip

        LDA.B (!tilemap_pointer),Y
        STA.W !current_graphic_preset
        JSL.L ManageGraphicPresets
        %Set16bit(!MX)
        INY
        LDA.B (!tilemap_pointer),Y
        ORA.W $0196                          ;FLAG196
        STA.W $0196
        %Set16bit(!M)
        LDA.L $7F1F5C
        AND.W #$0001                         ;FLAG5C
        BEQ .skip1

        %Set16bit(!MX)
        LDA.W $0196
        AND.W #$FFDF                         ;FLAG196
        STA.W $0196

    .skip1: %Set16bit(!MX)
        INY
        INY

    .singletilemapskip:
        %Set8bit(!M)
        LDA.B (!tilemap_pointer),Y
        STA.W $0181                          ;related to tables
        INY
        LDA.B (!tilemap_pointer),Y
        STA.W $0182                          ;never used except here?
        CMP.B #$03                           ;TODO
        BCC .skip2

        %Set16bit(!M)
        LDA.W $0196
        ORA.W #$0001                         ;FLAG196
        STA.W $0196

    .skip2:
        %Set8bit(!M)
        INY
        LDA.B (!tilemap_pointer),Y
        STA.B !number_of_tilemaps
        INY
        LDA.B (!tilemap_pointer),Y
        STA.B !number_of_charactermaps
        INY
        LDA.B !tilemap_to_load
        CMP.B #$57
        BCS .singletilemapskip2

        %Set16bit(!M)
        LDA.B (!tilemap_pointer),Y
        STA.B !OBJ_clamp_left
        INY
        INY
        LDA.B (!tilemap_pointer),Y
        STA.B !OBJ_clamp_right
        INY
        INY
        LDA.B (!tilemap_pointer),Y
        STA.B !OBJ_clamp_up
        INY
        INY
        LDA.B (!tilemap_pointer),Y
        STA.B !OBJ_clamp_down
        INY
        INY

    .singletilemapskip2:
        %Set8bit(!M)
        LDA.B !number_of_tilemaps
        BEQ .charactermaploop

    .tilemaploop:
            %Set16bit(!M)
            LDA.B (!tilemap_pointer),Y       ;loads destination in VRAM
            PHA
            INY
            INY
            LDA.B (!tilemap_pointer),Y       ;loads compressed map location
            STA.B $72
            INY
            INY
            %Set8bit(!M)
            LDA.B (!tilemap_pointer),Y       ;loads compressed map location bank
            STA.B $74
            %Set16bit(!M)
            INY
            PHY
            LDA.W #$2000
            STA.B $75
            %Set8bit(!M)
            LDA.B #$7E                      ;Destination adress, current graphical map
            STA.B $77
            JSL.L DecompressTileMap
            %Set8bit(!M)
            LDA.B #$00
            STA.B !ProgDMA_Channel_Index
            LDA.B !BBADX_DMA_VRAMPORT
            STA.B !ProgDMA_Destination_Memory
            %Set16bit(!MX)
            PLY
            PLA
            PHY
            TAX                              ;destination in VRAM
            LDY.W #$2000                     ;size
            LDA.W #$2000
            STA.B $72
            %Set8bit(!M)
            LDA.B #$7E                       ;source
            STA.B $74
            %Set16bit(!M)
            LDA.W #$0080
            JSL.L AddProgrammedDMA
            JSL.L StartLastPreparedDMA
            %Set16bit(!MX)
            PLY
            %Set8bit(!M)
            LDA.B !number_of_tilemaps
            DEC A
            STA.B !number_of_tilemaps
            BNE .tilemaploop

    .charactermaploop:
            %Set16bit(!MX)
            LDA.B (!tilemap_pointer),Y       ;dest?
            STA.B $8A
            INY
            INY
            LDA.B (!tilemap_pointer),Y
            STA.B $72
            INY
            INY
            %Set8bit(!M)
            LDA.B (!tilemap_pointer),Y       ;source?
            STA.B $74
            %Set16bit(!M)
            INY
            PHY
            LDA.W #$2000
            STA.B $75
            %Set8bit(!M)
            LDA.B #$7E
            STA.B $77
            %Set16bit(!M)
            LDA.W $0196
            AND.W #$8000                         ;FLAG196
            BNE .skip5                           ;TODO
            JSL.L DecompressTileMap
            BRA .farmcheck

        .skip5:
            %Set16bit(!MX)
            LDY.W #$0000

            .extradatareadloop:
                LDA.B [$72],Y                    ;TODO
                STA.B [$75],Y
                INY
                INY
                CPY.W #$8000
                BNE .extradatareadloop

        .farmcheck:
            %Set8bit(!M)
            LDA.B !tilemap_to_load
            CMP.B #$04
            BCS .notfarm                         ;Farms by season
            JSL.L FarmMap_ApplyPersistentFarmTileOverlay                 ;TODO

        .notfarm:
            %Set8bit(!M)
            LDA.B !number_of_charactermaps
            CMP.B #$01
            BNE .setoffsets
            %Set16bit(!MX)
            LDA.L $7F1F5E
            AND.W #$0002                         ;FLAG5E
            BNE .setoffsets
            JSL.L MapLoad_ExecuteMapEntryPointerScript

        .setoffsets:
            %Set16bit(!M)
            STZ.B !OBJ_Offset_X
            STZ.B !OBJ_Offset_Y
            LDA.W #$410
            STA.B $10
            LDA.W #$0A00
            STA.B $14
            STZ.B $12
            STZ.B $16
            %Set8bit(!M)
            STZ.B !BG_subpixel_offset_X
            STZ.B !BG_subpixel_offset_Y
            %Set16bit(!M)
            STZ.B !player_pos_X
            STZ.B !player_pos_Y
            %Set8bit(!M)
            LDA.B #$00
            XBA
            LDA.W $0181
            %Set16bit(!M)
            ASL A
            TAX
            LDA.L MapLoad_CharacterMapRowStrideTable,X
            STA.B $1A
            SEC
            SBC.W #$0040
            STA.B $80
            LDA.L MapLoad_CharacterMapVRAMBaseTable,X
            STA.B $1C
            %Set16bit(!M)
            LDA.W #$0000
            STA.B $7E
            LDX.B $8A
            LDY.W #$0040
            LDA.W #$0000

            .copycharacters40atatime:
                %Set16bit(!M)
                PHA
                LDA.W #$0000

                .loop2:
                    %Set16bit(!MX)
                    PHA
                    JSR.W MapLoad_QueueVRAMChunkWithOffset
                    %Set16bit(!MX)
                    LDA.B $7E
                    CLC
                    ADC.W #$0040
                    STA.B $7E
                    TXA
                    CLC
                    ADC.W #$0400
                    TAX
                    %Set8bit(!M)
                    LDA.B !tilemap_to_load
                    CMP.B #$5B               ;splash screens
                    BCS .skip9
                    LDY.B $8A
                    CPY.W #$7000
                    BEQ .skip10

                .skip9:
                    LDY.W #$0040
                    JSR.W MapLoad_QueueVRAMChunkWithOffset

                .skip10:
                    %Set16bit(!MX)
                    LDA.B $7E
                    CLC
                    ADC.B $80
                    STA.B $7E
                    TXA
                    SEC
                    SBC.W #$03E0
                    TAX
                    LDY.W #$0040
                    PLA
                    INC A
                    CMP.W #$0020
                    BNE .loop2

                %Set8bit(!M)
                LDA.B !tilemap_to_load
                CMP.B #$5B
                BCS .skip11
                LDY.B $8A
                CPY.W #$7000
                BEQ .skip12

            .skip11:
                %Set16bit(!M)
                TXA
                CLC
                ADC.W #$0400
                TAX

            .skip12:
                %Set16bit(!MX)
                LDY.W #$0040
                PLA
                INC A
                CMP.W #$0002
                BNE .copycharacters40atatime

            %Set16bit(!MX)
            PLY
            %Set8bit(!M)
            LDA.B !number_of_charactermaps
            DEC A
            STA.B !number_of_charactermaps
            BEQ .exitcharactermaploop
            JMP.W .charactermaploop

    .exitcharactermaploop:
        %Set8bit(!M)
        LDA.B !tilemap_to_load
        CMP.B #$57
        BCS .return
        %Set8bit(!M)
        LDA.B #$08
        STA.B $1E

        .loop33:
            %Set16bit(!M)
            LDA.B !player_pos_X
            CMP.W !transition_dest_X
            BEQ .skip14
            LDA.B !player_pos_X
            CLC
            ADC.B $1E
            STA.B !player_pos_X
            JSL.L Camera_UpdatePlayerCenteredOffsets
            JSL.L Camera_UpdateHorizontalBGOffsetRight
            JSL.L DMA_StartProgrammedTransfer
            BRA .loop33

    .skip14:
        %Set16bit(!M)
        LDA.B !player_pos_Y
        CMP.W !transition_dest_Y
        BEQ .return
        LDA.B !player_pos_Y
        CLC
        ADC.B $1E
        STA.B !player_pos_Y
        JSL.L Camera_UpdatePlayerCenteredOffsets
        JSL.L Camera_UpdateVerticalBGOffsetDown
        JSL.L DMA_StartProgrammedTransfer
        BRA .skip14

    .return: RTL

;;;;;;; Params $7E: offset to add, X: VRAM/CGRAM Dest Addresses and Y:DMA Size
;;;;;;;; Pass 26: Fila DMA de chunk 0x40 a partir de $7E2000 + offset.
;;;;;;;; Usado pelo loader para enviar partes do character map/tile data para VRAM.
MapLoad_QueueVRAMChunkWithOffset: ;80AA38
        !offset = $7E

        %Set16bit(!MX)
        PHX
        PHY
        %Set8bit(!M)
        LDA.B #$00
        STA.B !ProgDMA_Channel_Index
        LDA.B !BBADX_DMA_VRAMPORT
        STA.B !ProgDMA_Destination_Memory
        %Set16bit(!M)
        LDA.W #$2000
        CLC
        ADC.B !offset
        STA.B $72
        %Set8bit(!M)
        LDA.B #$7E
        STA.B $74                            ;sets $72 as pointer to $7E2000+offset
        %Set16bit(!M)
        LDA.W #$0080                         ;reverse Direction???
        JSL.L AddProgrammedDMA
        JSL.L StartLastPreparedDMA
        %Set16bit(!MX)
        PLY
        PLX
        RTS
                                                            ;      ;      ;
        ;Related to 0181, stored in A1, sprite size?
MapLoad_CharacterMapRowStrideTable: dw $0000,$0040,$0080,$0100,$0100;80AA68;      ;
MapLoad_CharacterMapVRAMBaseTable: dw $0000,$1000,$2000,$4000,$4000;80AA72;      ;used on MapLoad_DecompressAreaGraphicsAndSetCamera
                                                            ;      ;      ;
incsrc "../maps/Maps_Graphics.asm"
                                                            ;      ;      ;
          Unk_Table13: db $0C,$00,$00,$01,$E8,$00,$80,$00,$15,$01,$0D,$00,$80,$00,$C8,$00;80B6F5;      ;
                       db $16,$01,$0D,$00,$80,$00,$C8,$00,$17,$01,$0D,$00,$80,$00,$C8,$00;80B705;      ;
                       db $27,$01,$0E,$00,$80,$00,$68,$01,$28,$01,$0F,$00,$80,$00,$C8,$00;80B715;      ;
                       db $26,$01,$10,$00,$80,$00,$C8,$00,$2A,$00,$00,$00,$90,$00,$90,$02;80B725;      ;
                       db $2A,$00,$00,$00,$B0,$00,$60,$01,$00,$00,$00,$81,$88,$00,$58,$01;80B735;      ;
                       db $00,$00,$00,$01,$A8,$01,$E8,$01,$2A,$00,$23,$00,$60,$00,$98,$00;80B745;      ;
                       db $00,$00,$00,$01,$48,$01,$68,$01,$00,$00,$00,$01,$C8,$01,$68,$01;80B755;      ;
                       db $00,$02,$00,$01,$18,$00,$C0,$01,$04,$03,$00,$01,$E8,$02,$A8,$01;80B765;      ;
                       db $10,$01,$00,$01,$48,$01,$D8,$02,$0C,$02,$00,$01,$18,$00,$80,$00;80B775;      ;
                       db $18,$01,$14,$22,$80,$00,$A8,$00,$1B,$01,$15,$02,$80,$00,$C8,$01;80B785;      ;
                       db $1C,$01,$16,$32,$90,$00,$C8,$01,$1E,$01,$17,$24,$90,$00,$C8,$01;80B795;      ;
                       db $20,$01,$18,$32,$90,$00,$C8,$01,$22,$01,$19,$32,$90,$00,$C8,$01;80B7A5;      ;
                       db $24,$01,$1A,$32,$80,$00,$C8,$00,$24,$00,$00,$32,$58,$00,$48,$00;80B7B5;      ;
                       db $25,$01,$1B,$32,$80,$00,$C8,$00,$0C,$00,$00,$01,$80,$00,$18,$00;80B7C5;      ;
                       db $2B,$01,$13,$32,$80,$00,$C8,$00,$29,$01,$00,$00,$78,$01,$80,$00;80B7D5;      ;
                       db $29,$05,$00,$00,$C8,$00,$88,$01,$31,$01,$00,$41,$80,$00,$C8,$01;80B7E5;      ;
                       db $10,$00,$00,$01,$A8,$00,$A8,$01,$10,$00,$00,$01,$88,$01,$18,$00;80B7F5;      ;
                       db $10,$00,$00,$01,$08,$02,$28,$02,$04,$00,$00,$01,$98,$00,$98,$00;80B805;      ;
                       db $19,$01,$1C,$00,$B0,$01,$98,$01,$18,$00,$00,$00,$98,$00,$48,$00;80B815;      ;
                       db $1A,$00,$00,$00,$98,$00,$58,$01,$19,$01,$1D,$00,$50,$01,$98,$01;80B825;      ;
                       db $04,$00,$00,$01,$70,$01,$98,$00,$04,$00,$00,$01,$58,$02,$E8,$00;80B835;      ;
                       db $1D,$01,$1E,$00,$68,$00,$B8,$00,$1C,$00,$00,$00,$68,$00,$48,$01;80B845;      ;
                       db $04,$00,$00,$01,$58,$02,$78,$03,$04,$01,$1F,$01,$48,$02,$28,$03;80B855;      ;
                       db $04,$00,$00,$01,$18,$01,$68,$03,$21,$01,$20,$00,$68,$00,$C8,$00;80B865;      ;
                       db $20,$00,$00,$00,$68,$00,$48,$01,$04,$00,$00,$01,$98,$01,$68,$03;80B875;      ;
                       db $23,$01,$21,$00,$68,$00,$B8,$00,$22,$00,$00,$00,$68,$00,$48,$01;80B885;      ;
                       db $04,$00,$00,$01,$98,$00,$68,$03,$1F,$01,$22,$00,$88,$00,$C8,$00;80B895;      ;
                       db $1E,$00,$00,$00,$88,$00,$48,$01,$04,$00,$00,$01,$48,$02,$68,$02;80B8A5;      ;
                       db $26,$00,$00,$00,$78,$00,$48,$00,$00,$00,$00,$01,$28,$03,$58,$03;80B8B5;      ;
                       db $04,$03,$00,$01,$68,$02,$68,$01   ;80B8C5;      ;
                                                            ;      ;      ;
       AudioBGM_AreaProfileIndexTable: db $00,$04,$02,$05,$03,$03,$03,$04,$03,$01,$02,$03,$03,$03,$01,$04;80B8CD;      ;
                       db $03,$03,$04,$01,$01,$03,$01,$01,$01,$02;80B8DD;      ;
                                                            ;      ;      ;
AudioBGM_AreaSeasonTrackPointerTable: db $A7,$B9,$A7,$B9,$A7,$B9,$A7,$B9,$AB,$B9,$AB,$B9,$AB,$B9,$AB,$B9;80B8E7;      ;
                       db $B3,$B9,$B3,$B9,$B7,$B9,$BB,$B9,$A7,$B9,$A7,$B9,$A7,$B9,$A7,$B9;80B8F7;      ;
                       db $AF,$B9,$AF,$B9,$AF,$B9,$AF,$B9,$AF,$B9,$A7,$B9,$A7,$B9,$A7,$B9;80B907;      ;
                       db $AB,$B9,$AB,$B9,$AB,$B9,$BF,$B9,$AB,$B9,$AB,$B9,$D3,$B9,$AB,$B9;80B917;      ;
                       db $AB,$B9,$AB,$B9,$AB,$B9,$AB,$B9,$AB,$B9,$AB,$B9,$A7,$B9,$A7,$B9;80B927;      ;
                       db $A7,$B9,$FF,$FF,$C3,$B9,$AF,$B9,$C7,$B9,$A7,$B9,$A7,$B9,$A7,$B9;80B937;      ;
                       db $A7,$B9,$AF,$B9,$AF,$B9,$AF,$B9,$AF,$B9,$AF,$B9,$AF,$B9,$AF,$B9;80B947;      ;
                       db $AF,$B9,$AF,$B9,$AF,$B9,$AF,$B9,$CF,$B9,$FF,$FF,$FF,$FF,$FF,$FF;80B957;      ;
                       db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF;80B967;      ;
                       db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF;80B977;      ;
                       db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF;80B987;      ;
                       db $FF,$FF,$FF,$FF,$FF,$FF,$CF,$B9,$CB,$B9,$FF,$FF,$C7,$B9,$C7,$B9;80B997;      ;
                                                            ;      ;      ;
AudioBGM_SeasonIndexTrackTable: db $01,$02,$07,$04,$05,$05,$05,$05,$06,$06,$06,$06,$03,$03,$03,$03;80B9A7;      ;
                       db $0E,$0E,$0E,$0E,$0D,$0D,$0D,$0D,$09,$09,$09,$09,$0F,$0F,$0F,$0F;80B9B7;      ;
                       db $0A,$0A,$0A,$0A,$0B,$0B,$0B,$0B,$12,$12,$12,$12,$08,$08,$08,$08;80B9C7;      ;
                       db $68,$49,$08,$FF,$FF,$68,$49,$08,$17,$7F,$08,$71,$72,$08,$FE,$FF;80B9D7;      ;
                       db $DC,$B9,$80,$10,$52,$28,$FF,$FF,$10,$52,$28,$10,$52,$28,$BD,$7F;80B9E7;      ;
                       db $28,$FE,$FF,$EF,$B9,$80           ;80B9F7;      ;
                                                            ;      ;      ;
Palette_PointerTable: dl Palette01                         ;80B9FD;A89400;1
                     dl Palette02                         ;80BA00;A89600;2
                     dl Palette03                         ;80BA03;A89800;3
                     dl Palette04                         ;80BA06;A88A00;4
                     dl GFX_A88C00                        ;80BA09;A88C00;5
                     dl GFX_A88E00                        ;80BA0C;A88E00;6
                     dl GFX_A89000                        ;80BA0F;A89000;7
                     dl GFX_A89200                        ;80BA12;A89200;8
                     dl GFX_A88000                        ;80BA15;A88000;9
                     dl GFX_A88200                        ;80BA18;A88200;A
                     dl GFX_A88400                        ;80BA1B;A88400;B
                     dl GFX_A88600                        ;80BA1E;A88600;C
                     dl GFX_A88800                        ;80BA21;A88800;D
                     dl GFX_A89A00                        ;80BA24;A89A00;E
                     dl GFX_A89C00                        ;80BA27;A89C00;F
                     dl GFX_A89E00                        ;80BA2A;A89E00;10
                     dl GFX_A8A000                        ;80BA2D;A8A000;11
                     dl GFX_A8A200                        ;80BA30;A8A200;12
                     dl GFX_A8F400                        ;80BA33;A8F400;13
                     dl GFX_A8F800                        ;80BA36;A8F800;14
                     dl GFX_A8FA00                        ;80BA39;A8FA00;15
                     dl GFX_A8FC00                        ;80BA3C;A8FC00;16
                     dl GFX_A8BA00                        ;80BA3F;A8BA00;17
                     dl GFX_A8BC00                        ;80BA42;A8BC00;18
                     dl GFX_A8BE00                        ;80BA45;A8BE00;19
                     dl GFX_A8C000                        ;80BA48;A8C000;1A
                     dl GFX_A8C200                        ;80BA4B;A8C200;1B
                     dl GFX_A8C600                        ;80BA4E;A8C600;1C
                     dl GFX_A8C800                        ;80BA51;A8C800;1D
                     dl GFX_A8CA00                        ;80BA54;A8CA00;1F
                     dl GFX_A98000                        ;80BA57;A98000;20
                     dl GFX_A98200                        ;80BA5A;A98200;21
                     dl GFX_A98400                        ;80BA5D;A98400;22
                     dl GFX_A98600                        ;80BA60;A98600;23
                     dl GFX_A8F600                        ;80BA63;A8F600;24
                     dl GFX_A8C400                        ;80BA66;A8C400;25
                     dl GFX_A98A00                        ;80BA69;A98A00;26
                     dl GFX_A98800                        ;80BA6C;A98800;27
                     dl GFX_A8FE00                        ;80BA6F;A8FE00;28
                     dl GFX_A8CC00                        ;80BA72;A8CC00;29
                     dl GFX_A8CE00                        ;80BA75;A8CE00;2A
                     dl GFX_A8D000                        ;80BA78;A8D000;2B
                     dl GFX_A8D200                        ;80BA7B;A8D200;2C
                     dl GFX_A8D400                        ;80BA7E;A8D400;2D
                     dl GFX_A8EA00                        ;80BA81;A8EA00;2E
                     dl GFX_A8EC00                        ;80BA84;A8EC00;2F
                     dl GFX_A8EE00                        ;80BA87;A8EE00;30
                     dl GFX_A8F000                        ;80BA8A;A8F000;31
                     dl GFX_A8F200                        ;80BA8D;A8F200;32
                     dl GFX_A8D600                        ;80BA90;A8D600;33
                     dl GFX_A8D800                        ;80BA93;A8D800;34
                     dl GFX_A8DA00                        ;80BA96;A8DA00;35
                     dl GFX_A8DC00                        ;80BA99;A8DC00;36
                     dl GFX_A8DE00                        ;80BA9C;A8DE00;37
                     dl GFX_A8E000                        ;80BA9F;A8E000;38
                     dl GFX_A8E200                        ;80BAA2;A8E200;39
                     dl GFX_A8E400                        ;80BAA5;A8E400;3A
                     dl GFX_A8E600                        ;80BAA8;A8E600;3B
                     dl GFX_A8E800                        ;80BAAB;A8E800;3C
                     dl GFX_A9C800                        ;80BAAE;A9C800;3D
                     dl GFX_A9CA00                        ;80BAB1;A9CA00;3E
                     dl GFX_A9CC00                        ;80BAB4;A9CC00;3F
                     dl GFX_A9CE00                        ;80BAB7;A9CE00;40
                     dl GFX_A9B800                        ;80BABA;A9B800;41
                     dl GFX_A9BA00                        ;80BABD;A9BA00;42
                     dl GFX_A9BC00                        ;80BAC0;A9BC00;43
                     dl GFX_A9BE00                        ;80BAC3;A9BE00;44
                     dl GFX_A9C000                        ;80BAC6;A9C000;45
                     dl GFX_A9C200                        ;80BAC9;A9C200;46
                     dl GFX_A9C400                        ;80BACC;A9C400;47
                     dl GFX_A9C600                        ;80BACF;A9C600;48
                     dl GFX_A9D000                        ;80BAD2;A9D000;49
                     dl GFX_A9D200                        ;80BAD5;A9D200;4A
                     dl GFX_A9D400                        ;80BAD8;A9D400;4B
                     dl GFX_A9D600                        ;80BADB;A9D600;4C
                     dl GFX_A8A600                        ;80BADE;A8A600;4D
                     dl GFX_A8A800                        ;80BAE1;A8A800;4E
                     dl GFX_A8AA00                        ;80BAE4;A8AA00;4F
                     dl GFX_A8AC00                        ;80BAE7;A8AC00;50
                     dl GFX_A8AE00                        ;80BAEA;A8AE00;51
                     dl GFX_A8B000                        ;80BAED;A8B000;52
                     dl GFX_A8B200                        ;80BAF0;A8B200;53
                     dl GFX_A8B400                        ;80BAF3;A8B400;54
                     dl GFX_A8B600                        ;80BAF6;A8B600;55
                     dl GFX_A8B800                        ;80BAF9;A8B800;56
                     dl GFX_A98E00                        ;80BAFC;A98E00;57
                     dl GFX_A9B600                        ;80BAFF;A9B600;58
                     dl GFX_A8A400                        ;80BB02;A8A400;59
                     dl GFX_A99200                        ;80BB05;A99200;5A
                     dl GFX_A99000                        ;80BB08;A99000;5B
                     dl GFX_A9A600                        ;80BB0B;A9A600;5C
                     dl GFX_A9A800                        ;80BB0E;A9A800;5D
                     dl GFX_A9AA00                        ;80BB11;A9AA00;5E
                     dl GFX_A9AC00                        ;80BB14;A9AC00;5F
                     dl GFX_A99C00                        ;80BB17;A99C00;60
                     dl GFX_A99E00                        ;80BB1A;A99E00;61
                     dl GFX_A9A000                        ;80BB1D;A9A000;62
                     dl GFX_A9A200                        ;80BB20;A9A200;63
                     dl GFX_A99400                        ;80BB23;A99400;64
                     dl GFX_A99600                        ;80BB26;A99600;65
                     dl GFX_A99800                        ;80BB29;A99800;66
                     dl GFX_A99A00                        ;80BB2C;A99A00;67
                     dl GFX_A9AE00                        ;80BB2F;A9AE00;68
                     dl GFX_A9B000                        ;80BB32;A9B000;69
                     dl GFX_A9B200                        ;80BB35;A9B200;6A
                     dl GFX_A9B400                        ;80BB38;A9B400;6B
                     dl GFX_A9A400                        ;80BB3B;A9A400;6C
                     dl GFX_A9DE00                        ;80BB3E;A9DE00;6D
                     dl GFX_A9E000                        ;80BB41;A9E000;6E
                     dl GFX_A9D800                        ;80BB44;A9D800;6F
                     dl CG_Natsume_Title                  ;80BB47;A9DA00;70
                     dl GFX_A98C00                        ;80BB4A;A98C00;71
                     dl GFX_A9DC00                        ;80BB4D;A9DC00;72
                     dl GFX_A9E200                        ;80BB50;A9E200;73
                     dl GFX_A9E400                        ;80BB53;A9E400;74
                     dl GFX_A9E600                        ;80BB56;A9E600;75
                     dl GFX_A9E800                        ;80BB59;A9E800;76
                                                            ;      ;      ;
         Palette_TimeOfDayByMapTable: db $00,$01,$02,$06,$07,$FF,$03,$04,$05,$06,$07,$FF,$08,$09,$0A,$0B;80BB5C;      ;
                       db $0C,$FF,$0D,$0E,$0F,$10,$11,$FF,$FF,$12,$13,$14,$15,$FF,$FF,$16;80BB6C;      ;
                       db $17,$18,$19,$FF,$FF,$1A,$1B,$1C,$1D,$FF,$FF,$1E,$1F,$20,$21,$FF;80BB7C;      ;
                       db $FF,$22,$22,$FF,$FF,$FF,$FF,$23,$23,$FF,$FF,$FF,$FF,$FF,$FF,$24;80BB8C;      ;
                       db $25,$FF,$FF,$26,$FF,$FF,$FF,$FF,$27,$28,$29,$2A,$2B,$FF,$2C,$2D;80BB9C;      ;
                       db $2E,$2F,$30,$FF,$31,$32,$33,$34,$35,$FF,$36,$37,$38,$39,$3A,$FF;80BBAC;      ;
                       db $FF,$3B,$3C,$3D,$3E,$FF,$FF,$3F,$40,$41,$42,$FF,$FF,$43,$44,$45;80BBBC;      ;
                       db $46,$FF,$FF,$47,$48,$49,$4A,$FF,$FF,$FF,$FF,$FF,$4A,$FF,$4B,$4B;80BBCC;      ;
                       db $4B,$4B,$4B,$4C,$4B,$4B,$4B,$4B,$4B,$4C,$4B,$4B,$4B,$4B,$4B,$4C;80BBDC;      ;
                       db $FF,$4D,$4D,$FF,$FF,$FF,$FF,$4D,$4D,$FF,$FF,$FF,$FF,$4D,$4D,$FF;80BBEC;      ;
                       db $FF,$FF,$FF,$4E,$4E,$FF,$FF,$FF,$FF,$4F,$4F,$FF,$FF,$FF,$FF,$4F;80BBFC;      ;
                       db $4F,$FF,$FF,$FF,$FF,$FF,$FF,$50,$50,$FF,$FF,$FF,$FF,$50,$50,$FF;80BC0C;      ;
                       db $FF,$51,$51,$FF,$FF,$FF,$FF,$51,$51,$FF,$FF,$FF,$FF,$52,$52,$FF;80BC1C;      ;
                       db $FF,$FF,$FF,$52,$52,$FF,$FF,$FF,$FF,$53,$53,$FF,$FF,$FF,$FF,$54;80BC2C;      ;
                       db $54,$FF,$FF,$FF,$55,$55,$55,$55,$55,$FF,$56,$56,$56,$56,$56,$FF;80BC3C;      ;
                       db $56,$56,$56,$56,$56,$FF,$FF,$57,$57,$57,$57,$FF,$57,$57,$57,$57;80BC4C;      ;
                       db $57,$FF,$FF,$58,$58,$FF,$FF,$FF,$FF,$59,$FF,$FF,$FF,$FF,$FF,$12;80BC5C;      ;
                       db $FF,$FF,$FF,$FF,$FF,$16,$FF,$FF,$FF,$FF,$FF,$1A,$FF,$FF,$FF,$FF;80BC6C;      ;
                       db $FF,$1E,$FF,$FF,$FF,$FF,$FF,$5A,$5B,$5C,$5D,$FF,$FF,$5E,$5F,$60;80BC7C;      ;
                       db $61,$FF,$FF,$62,$63,$64,$65,$FF,$FF,$66,$67,$68,$69,$FF,$FF,$5A;80BC8C;      ;
                       db $5B,$5C,$5D,$FF,$FF,$5E,$5F,$60,$61,$FF,$FF,$62,$63,$64,$65,$FF;80BC9C;      ;
                       db $FF,$66,$67,$68,$69,$FF,$FF,$FF,$FF,$FF,$69,$FF,$69,$6A,$6A,$6A;80BCAC;      ;
                       db $6A,$FF,$FF,$5A,$5B,$5C,$5D,$FF,$28,$FF,$FF,$FF,$FF,$FF,$04,$FF;80BCBC;      ;
                       db $FF,$FF,$FF,$FF,$04,$FF,$FF,$FF,$FF,$FF,$04,$FF,$FF,$FF,$FF,$FF;80BCCC;      ;
                       db $04,$FF,$FF,$FF,$FF,$FF,$04,$FF,$FF,$FF,$FF,$FF,$16,$FF,$FF,$FF;80BCDC;      ;
                       db $FF,$FF,$04,$FF,$FF,$FF,$FF,$FF,$04,$FF,$FF,$FF,$FF,$FF,$04,$FF;80BCEC;      ;
                       db $FF,$FF,$FF,$FF,$04,$FF,$FF,$FF,$FF,$FF,$04,$FF,$FF,$FF,$FF,$FF;80BCFC;      ;
                       db $3F,$FF,$FF,$FF,$FF,$FF,$04,$FF,$FF,$FF,$FF,$FF,$04,$FF,$FF,$FF;80BD0C;      ;
                       db $FF,$FF,$70,$FF,$FF,$FF,$FF,$FF,$70,$FF,$FF,$FF,$FF,$FF,$70,$FF;80BD1C;      ;
                       db $FF,$FF,$FF,$FF,$70,$FF,$FF,$FF,$FF,$FF,$70,$FF,$FF,$FF,$FF,$FF;80BD2C;      ;
                       db $70,$FF,$FF,$FF,$FF,$FF,$70,$FF,$FF,$FF,$FF,$FF,$70,$FF,$FF,$FF;80BD3C;      ;
                       db $FF,$FF,$70,$FF,$FF,$FF,$FF,$FF,$70,$FF,$FF,$FF,$FF,$FF,$70,$FF;80BD4C;      ;
                       db $FF,$FF,$FF,$FF,$70,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF;80BD5C;      ;
                       db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF;80BD6C;      ;
                       db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF;80BD7C;      ;
                       db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF;80BD8C;      ;
                                                            ;      ;      ;
           PaletteOverride_SeasonalSpriteColorTriples: db $F8,$3B,$D0,$26,$46,$09,$8C,$23,$48,$16,$24,$01,$D7,$22,$71,$01;80BD9C;      ;
                       db $A9,$0C,$8C,$23,$EF,$3D,$7B,$7F,$A8,$15,$07,$15,$A2,$00,$A8,$15;80BDAC;      ;
                       db $07,$15,$A2,$00,$4C,$01,$E8,$00,$66,$00,$A8,$15,$EF,$3D,$73,$56;80BDBC;      ;
                       db $76,$3B,$92,$2A,$07,$11,$8C,$23,$48,$16,$24,$01,$7C,$0A,$54,$01;80BDCC;      ;
                       db $A8,$08,$76,$3B,$92,$2A,$07,$11,$CE,$19,$2A,$11,$85,$08,$CF,$1D;80BDDC;      ;
                       db $2B,$0D,$66,$00,$70,$01,$CC,$04,$24,$00,$CE,$19,$2A,$11,$85,$08;80BDEC;      ;
                                                            ;      ;      ;
          PaletteOverride_WifePregnancyColorTriples: db $00,$00,$00,$00,$00,$00,$29,$7A,$A0,$5D,$00,$41,$1F,$03,$DF,$01;80BDFC;      ;
                       db $F8,$00,$1F,$73,$5E,$62,$B9,$41,$56,$1A,$B0,$0D,$2D,$1D,$FF,$53;80BE0C;      ;
                       db $FE,$02,$16,$02,$00,$00,$00,$00,$00,$00,$EA,$61,$80,$51,$20,$45;80BE1C;      ;
                       db $DB,$1D,$78,$01,$B5,$00,$7D,$6A,$F9,$55,$14,$31,$8F,$09,$2B,$1D;80BE2C;      ;
                       db $09,$15,$FC,$0A,$7B,$02,$92,$01   ;80BE3C;      ;
                                                            ;      ;      ;
          Palette_OBJHalfByMapDayNightTable: db $6B,$6C,$6B,$6C,$6B,$6C,$6B,$6C,$6B,$6C,$6B,$6C,$6B,$6C,$6B,$6C;80BE44;      ;
                       db $6B,$6B,$6B,$6B,$6B,$6C,$6B,$6B,$6B,$6C,$6B,$6C,$6B,$6C,$6B,$6C;80BE54;      ;
                       db $6B,$6C,$6B,$6C,$6B,$6C,$6B,$6C,$6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B;80BE64;      ;
                       db $6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B;80BE74;      ;
                       db $6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B;80BE84;      ;
                       db $6B,$6B,$6C,$6C,$6C,$6C,$6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B,$6B;80BE94;      ;
                       db $6B,$6B,$6B,$6C,$6B,$6C,$6B,$6C,$6B,$6C,$6B,$6C,$6B,$6C,$6B,$6C;80BEA4;      ;
                       db $6B,$6C,$6B,$6C,$6B,$6B,$6B,$6C,$6B,$6C,$6B,$6C,$6B,$6C,$6B,$6C;80BEB4;      ;
                       db $6B,$6C,$6B,$6C,$6B,$6C,$6B,$6C,$6B,$6C,$6B,$6C,$6B,$6C,$6B,$6C;80BEC4;      ;
                       db $6B,$6C,$6B,$6C,$6B,$6C,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF;80BED4;      ;
                       db $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF   ;80BEE4;      ;

incsrc "bank_80_pointersubrutines.asm"


; PASS46_BANK80_POINTER42_SCRIPT_DATA_DECODED:
; Decoded Pointer42 palette animation scripts used by bank 80 map/time installers.
; Format: dw RGB555_color ; db frame_delay. A script normally ends with dw $FFFE ; dl target_script.
; This block replaces the previous raw db stream with labels and explicit commands, while preserving bytes.
PaletteAnim_Bank80Pointer42ScriptData:

PaletteAnimScript_DD5B: ;80DD5B; colors=8 delays=$10 refs=1 jump=DD5B
        dw $7F79 : db $10 ; color RGB555, delay
        dw $3A11 : db $10 ; color RGB555, delay
        dw $6A8E : db $10 ; color RGB555, delay
        dw $5E0D : db $10 ; color RGB555, delay
        dw $6AD2 : db $10 ; color RGB555, delay
        dw $5E0D : db $10 ; color RGB555, delay
        dw $6A8E : db $10 ; color RGB555, delay
        dw $3A11 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DD5B ; loop/jump

PaletteAnimScript_DD78: ;80DD78; colors=8 delays=$10 refs=1 jump=DD78
        dw $6AD2 : db $10 ; color RGB555, delay
        dw $6A8E : db $10 ; color RGB555, delay
        dw $5E0D : db $10 ; color RGB555, delay
        dw $6AD2 : db $10 ; color RGB555, delay
        dw $3A11 : db $10 ; color RGB555, delay
        dw $6AD2 : db $10 ; color RGB555, delay
        dw $5E0D : db $10 ; color RGB555, delay
        dw $6A8E : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DD78 ; loop/jump

PaletteAnimScript_DD95: ;80DD95; colors=8 delays=$10 refs=1 jump=DD95
        dw $6A8E : db $10 ; color RGB555, delay
        dw $5E0D : db $10 ; color RGB555, delay
        dw $6AD2 : db $10 ; color RGB555, delay
        dw $3A11 : db $10 ; color RGB555, delay
        dw $5E0D : db $10 ; color RGB555, delay
        dw $3A11 : db $10 ; color RGB555, delay
        dw $6AD2 : db $10 ; color RGB555, delay
        dw $5E0D : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DD95 ; loop/jump

PaletteAnimScript_DDB2: ;80DDB2; colors=8 delays=$10 refs=1 jump=DDB2
        dw $5E0D : db $10 ; color RGB555, delay
        dw $6AD2 : db $10 ; color RGB555, delay
        dw $4253 : db $10 ; color RGB555, delay
        dw $5E0D : db $10 ; color RGB555, delay
        dw $6A8E : db $10 ; color RGB555, delay
        dw $5E0D : db $10 ; color RGB555, delay
        dw $4253 : db $10 ; color RGB555, delay
        dw $6AD2 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DDB2 ; loop/jump

PaletteAnimScript_DDCF: ;80DDCF; colors=8 delays=$10 refs=1 jump=DDCF
        dw $539D : db $10 ; color RGB555, delay
        dw $2E12 : db $10 ; color RGB555, delay
        dw $1DFB : db $10 ; color RGB555, delay
        dw $1D94 : db $10 ; color RGB555, delay
        dw $2EFE : db $10 ; color RGB555, delay
        dw $1D94 : db $10 ; color RGB555, delay
        dw $1DFB : db $10 ; color RGB555, delay
        dw $2E12 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DDCF ; loop/jump

PaletteAnimScript_DDEC: ;80DDEC; colors=8 delays=$10 refs=1 jump=DDEC
        dw $2EFE : db $10 ; color RGB555, delay
        dw $1DFB : db $10 ; color RGB555, delay
        dw $1D94 : db $10 ; color RGB555, delay
        dw $2EFE : db $10 ; color RGB555, delay
        dw $2E12 : db $10 ; color RGB555, delay
        dw $2EFE : db $10 ; color RGB555, delay
        dw $1D94 : db $10 ; color RGB555, delay
        dw $1DFB : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DDEC ; loop/jump

PaletteAnimScript_DE09: ;80DE09; colors=8 delays=$10 refs=1 jump=DE09
        dw $1DFB : db $10 ; color RGB555, delay
        dw $1D94 : db $10 ; color RGB555, delay
        dw $2EFE : db $10 ; color RGB555, delay
        dw $2E12 : db $10 ; color RGB555, delay
        dw $1D94 : db $10 ; color RGB555, delay
        dw $2E12 : db $10 ; color RGB555, delay
        dw $2EFE : db $10 ; color RGB555, delay
        dw $1D94 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DE09 ; loop/jump

PaletteAnimScript_DE26: ;80DE26; colors=8 delays=$10 refs=1 jump=DE26
        dw $1D94 : db $10 ; color RGB555, delay
        dw $2EFE : db $10 ; color RGB555, delay
        dw $2E74 : db $10 ; color RGB555, delay
        dw $1DFB : db $10 ; color RGB555, delay
        dw $1DFB : db $10 ; color RGB555, delay
        dw $1DFB : db $10 ; color RGB555, delay
        dw $2E74 : db $10 ; color RGB555, delay
        dw $2EFE : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DE26 ; loop/jump

PaletteAnimScript_DE43: ;80DE43; colors=8 delays=$10 refs=1 jump=DE43
        dw $5A52 : db $10 ; color RGB555, delay
        dw $314C : db $10 ; color RGB555, delay
        dw $356B : db $10 ; color RGB555, delay
        dw $2908 : db $10 ; color RGB555, delay
        dw $5A52 : db $10 ; color RGB555, delay
        dw $2908 : db $10 ; color RGB555, delay
        dw $356B : db $10 ; color RGB555, delay
        dw $314C : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DE43 ; loop/jump

PaletteAnimScript_DE60: ;80DE60; colors=8 delays=$10 refs=1 jump=DE60
        dw $45EF : db $10 ; color RGB555, delay
        dw $49EF : db $10 ; color RGB555, delay
        dw $2908 : db $10 ; color RGB555, delay
        dw $5A52 : db $10 ; color RGB555, delay
        dw $314C : db $10 ; color RGB555, delay
        dw $5A52 : db $10 ; color RGB555, delay
        dw $2908 : db $10 ; color RGB555, delay
        dw $49EF : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DE60 ; loop/jump

PaletteAnimScript_DE7D: ;80DE7D; colors=8 delays=$10 refs=1 jump=DE7D
        dw $356B : db $10 ; color RGB555, delay
        dw $394A : db $10 ; color RGB555, delay
        dw $5A52 : db $10 ; color RGB555, delay
        dw $314C : db $10 ; color RGB555, delay
        dw $2908 : db $10 ; color RGB555, delay
        dw $314C : db $10 ; color RGB555, delay
        dw $5A52 : db $10 ; color RGB555, delay
        dw $394A : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DE7D ; loop/jump

PaletteAnimScript_DE9A: ;80DE9A; colors=8 delays=$10 refs=1 jump=DE9A
        dw $2908 : db $10 ; color RGB555, delay
        dw $5A52 : db $10 ; color RGB555, delay
        dw $314C : db $10 ; color RGB555, delay
        dw $356B : db $10 ; color RGB555, delay
        dw $356B : db $10 ; color RGB555, delay
        dw $356B : db $10 ; color RGB555, delay
        dw $314C : db $10 ; color RGB555, delay
        dw $5A52 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DE9A ; loop/jump

PaletteAnimScript_DEB7: ;80DEB7; colors=8 delays=$10 refs=1 jump=DEB7
        dw $456B : db $10 ; color RGB555, delay
        dw $1CE7 : db $10 ; color RGB555, delay
        dw $28E7 : db $10 ; color RGB555, delay
        dw $2908 : db $10 ; color RGB555, delay
        dw $456B : db $10 ; color RGB555, delay
        dw $2908 : db $10 ; color RGB555, delay
        dw $28E7 : db $10 ; color RGB555, delay
        dw $1CE7 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DEB7 ; loop/jump

PaletteAnimScript_DED4: ;80DED4; colors=8 delays=$10 refs=1 jump=DED4
        dw $3508 : db $10 ; color RGB555, delay
        dw $3508 : db $10 ; color RGB555, delay
        dw $28E7 : db $10 ; color RGB555, delay
        dw $2908 : db $10 ; color RGB555, delay
        dw $456B : db $10 ; color RGB555, delay
        dw $2908 : db $10 ; color RGB555, delay
        dw $28E7 : db $10 ; color RGB555, delay
        dw $3508 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DED4 ; loop/jump

PaletteAnimScript_DEF1: ;80DEF1; colors=8 delays=$10 refs=1 jump=DEF1
        dw $28E7 : db $10 ; color RGB555, delay
        dw $28E7 : db $10 ; color RGB555, delay
        dw $456B : db $10 ; color RGB555, delay
        dw $1CE7 : db $10 ; color RGB555, delay
        dw $290B : db $10 ; color RGB555, delay
        dw $1CE7 : db $10 ; color RGB555, delay
        dw $456B : db $10 ; color RGB555, delay
        dw $28E7 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DEF1 ; loop/jump

PaletteAnimScript_DF0E: ;80DF0E; colors=8 delays=$10 refs=1 jump=DF0E
        dw $28C5 : db $10 ; color RGB555, delay
        dw $456B : db $10 ; color RGB555, delay
        dw $3508 : db $10 ; color RGB555, delay
        dw $28E7 : db $10 ; color RGB555, delay
        dw $1CE7 : db $10 ; color RGB555, delay
        dw $28E7 : db $10 ; color RGB555, delay
        dw $3508 : db $10 ; color RGB555, delay
        dw $456B : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DF0E ; loop/jump

PaletteAnimScript_DF2B: ;80DF2B; colors=8 delays=$10 refs=1 jump=DF2B
        dw $7F99 : db $10 ; color RGB555, delay
        dw $320F : db $10 ; color RGB555, delay
        dw $5A8E : db $10 ; color RGB555, delay
        dw $524D : db $10 ; color RGB555, delay
        dw $62D2 : db $10 ; color RGB555, delay
        dw $524D : db $10 ; color RGB555, delay
        dw $5A8E : db $10 ; color RGB555, delay
        dw $320F : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DF2B ; loop/jump

PaletteAnimScript_DF48: ;80DF48; colors=8 delays=$10 refs=1 jump=DF48
        dw $62D2 : db $10 ; color RGB555, delay
        dw $5A8E : db $10 ; color RGB555, delay
        dw $524D : db $10 ; color RGB555, delay
        dw $62D2 : db $10 ; color RGB555, delay
        dw $320F : db $10 ; color RGB555, delay
        dw $62D2 : db $10 ; color RGB555, delay
        dw $524D : db $10 ; color RGB555, delay
        dw $5A8E : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DF48 ; loop/jump

PaletteAnimScript_DF65: ;80DF65; colors=8 delays=$10 refs=1 jump=DF65
        dw $5A8E : db $10 ; color RGB555, delay
        dw $524D : db $10 ; color RGB555, delay
        dw $62D2 : db $10 ; color RGB555, delay
        dw $320F : db $10 ; color RGB555, delay
        dw $5A8E : db $10 ; color RGB555, delay
        dw $320F : db $10 ; color RGB555, delay
        dw $62D2 : db $10 ; color RGB555, delay
        dw $524D : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DF65 ; loop/jump

PaletteAnimScript_DF82: ;80DF82; colors=8 delays=$10 refs=1 jump=DF82
        dw $524D : db $10 ; color RGB555, delay
        dw $62D2 : db $10 ; color RGB555, delay
        dw $320F : db $10 ; color RGB555, delay
        dw $5A8E : db $10 ; color RGB555, delay
        dw $524D : db $10 ; color RGB555, delay
        dw $5A8E : db $10 ; color RGB555, delay
        dw $320F : db $10 ; color RGB555, delay
        dw $62D2 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DF82 ; loop/jump

PaletteAnimScript_DF9F: ;80DF9F; colors=8 delays=$10 refs=1 jump=DF9F
        dw $23FE : db $10 ; color RGB555, delay
        dw $2298 : db $10 ; color RGB555, delay
        dw $11DB : db $10 ; color RGB555, delay
        dw $029B : db $10 ; color RGB555, delay
        dw $031F : db $10 ; color RGB555, delay
        dw $029B : db $10 ; color RGB555, delay
        dw $11DB : db $10 ; color RGB555, delay
        dw $2298 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DF9F ; loop/jump

PaletteAnimScript_DFBC: ;80DFBC; colors=8 delays=$10 refs=1 jump=DFBC
        dw $031F : db $10 ; color RGB555, delay
        dw $11DC : db $10 ; color RGB555, delay
        dw $01B6 : db $10 ; color RGB555, delay
        dw $031F : db $10 ; color RGB555, delay
        dw $2276 : db $10 ; color RGB555, delay
        dw $031F : db $10 ; color RGB555, delay
        dw $01B6 : db $10 ; color RGB555, delay
        dw $11DC : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DFBC ; loop/jump

PaletteAnimScript_DFD9: ;80DFD9; colors=8 delays=$10 refs=1 jump=DFD9
        dw $11DB : db $10 ; color RGB555, delay
        dw $01B6 : db $10 ; color RGB555, delay
        dw $031F : db $10 ; color RGB555, delay
        dw $2276 : db $10 ; color RGB555, delay
        dw $125F : db $10 ; color RGB555, delay
        dw $2276 : db $10 ; color RGB555, delay
        dw $031F : db $10 ; color RGB555, delay
        dw $01B6 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DFD9 ; loop/jump

PaletteAnimScript_DFF6: ;80DFF6; colors=8 delays=$10 refs=1 jump=DFF6
        dw $01B6 : db $10 ; color RGB555, delay
        dw $031F : db $10 ; color RGB555, delay
        dw $2276 : db $10 ; color RGB555, delay
        dw $11DB : db $10 ; color RGB555, delay
        dw $01B6 : db $10 ; color RGB555, delay
        dw $11DB : db $10 ; color RGB555, delay
        dw $2276 : db $10 ; color RGB555, delay
        dw $031F : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DFF6 ; loop/jump

PaletteAnimScript_E013: ;80E013; colors=8 delays=$10 refs=1 jump=E013
        dw $51CD : db $10 ; color RGB555, delay
        dw $216B : db $10 ; color RGB555, delay
        dw $496B : db $10 ; color RGB555, delay
        dw $4587 : db $10 ; color RGB555, delay
        dw $51CD : db $10 ; color RGB555, delay
        dw $4587 : db $10 ; color RGB555, delay
        dw $496B : db $10 ; color RGB555, delay
        dw $216B : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E013 ; loop/jump

PaletteAnimScript_E030: ;80E030; colors=8 delays=$10 refs=1 jump=E030
        dw $496B : db $10 ; color RGB555, delay
        dw $496B : db $10 ; color RGB555, delay
        dw $4587 : db $10 ; color RGB555, delay
        dw $51CD : db $10 ; color RGB555, delay
        dw $216B : db $10 ; color RGB555, delay
        dw $51CD : db $10 ; color RGB555, delay
        dw $4587 : db $10 ; color RGB555, delay
        dw $496B : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E030 ; loop/jump

PaletteAnimScript_E04D: ;80E04D; colors=8 delays=$10 refs=1 jump=E04D
        dw $11DB : db $10 ; color RGB555, delay
        dw $01B6 : db $10 ; color RGB555, delay
        dw $031F : db $10 ; color RGB555, delay
        dw $2276 : db $10 ; color RGB555, delay
        dw $125F : db $10 ; color RGB555, delay
        dw $2276 : db $10 ; color RGB555, delay
        dw $031F : db $10 ; color RGB555, delay
        dw $01B6 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E04D ; loop/jump

PaletteAnimScript_E06A: ;80E06A; colors=8 delays=$10 refs=1 jump=E06A
        dw $3507 : db $10 ; color RGB555, delay
        dw $51CD : db $10 ; color RGB555, delay
        dw $216B : db $10 ; color RGB555, delay
        dw $696B : db $10 ; color RGB555, delay
        dw $4587 : db $10 ; color RGB555, delay
        dw $496B : db $10 ; color RGB555, delay
        dw $216B : db $10 ; color RGB555, delay
        dw $51CD : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E06A ; loop/jump

PaletteAnimScript_E087: ;80E087; colors=8 delays=$10 refs=1 jump=E087
        dw $6140 : db $10 ; color RGB555, delay
        dw $20C6 : db $10 ; color RGB555, delay
        dw $4104 : db $10 ; color RGB555, delay
        dw $30C0 : db $10 ; color RGB555, delay
        dw $4564 : db $10 ; color RGB555, delay
        dw $30C0 : db $10 ; color RGB555, delay
        dw $4104 : db $10 ; color RGB555, delay
        dw $20C6 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E087 ; loop/jump

PaletteAnimScript_E0A4: ;80E0A4; colors=8 delays=$10 refs=1 jump=E0A4
        dw $4564 : db $10 ; color RGB555, delay
        dw $4104 : db $10 ; color RGB555, delay
        dw $30C0 : db $10 ; color RGB555, delay
        dw $4564 : db $10 ; color RGB555, delay
        dw $20C6 : db $10 ; color RGB555, delay
        dw $4564 : db $10 ; color RGB555, delay
        dw $30C0 : db $10 ; color RGB555, delay
        dw $4104 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E0A4 ; loop/jump

PaletteAnimScript_E0C1: ;80E0C1; colors=8 delays=$10 refs=1 jump=E0C1
        dw $4104 : db $10 ; color RGB555, delay
        dw $30C0 : db $10 ; color RGB555, delay
        dw $4564 : db $10 ; color RGB555, delay
        dw $20C6 : db $10 ; color RGB555, delay
        dw $4104 : db $10 ; color RGB555, delay
        dw $20C6 : db $10 ; color RGB555, delay
        dw $4564 : db $10 ; color RGB555, delay
        dw $30C0 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E0C1 ; loop/jump

PaletteAnimScript_E0DE: ;80E0DE; colors=8 delays=$10 refs=1 jump=E0DE
        dw $30C0 : db $10 ; color RGB555, delay
        dw $4564 : db $10 ; color RGB555, delay
        dw $20C6 : db $10 ; color RGB555, delay
        dw $4104 : db $10 ; color RGB555, delay
        dw $30C0 : db $10 ; color RGB555, delay
        dw $4104 : db $10 ; color RGB555, delay
        dw $20C6 : db $10 ; color RGB555, delay
        dw $4564 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E0DE ; loop/jump

PaletteAnimScript_E0FB: ;80E0FB; colors=4 delays=$08 refs=1 jump=E0FB
        dw $0150 : db $08 ; color RGB555, delay
        dw $0153 : db $08 ; color RGB555, delay
        dw $0150 : db $08 ; color RGB555, delay
        dw $0153 : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E0FB ; loop/jump

PaletteAnimScript_E10C: ;80E10C; colors=4 delays=$08 refs=1 jump=E10C
        dw $09D7 : db $08 ; color RGB555, delay
        dw $09D9 : db $08 ; color RGB555, delay
        dw $09D7 : db $08 ; color RGB555, delay
        dw $09D9 : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E10C ; loop/jump

PaletteAnimScript_E11D: ;80E11D; colors=4 delays=$08 refs=1 jump=E11D
        dw $029F : db $08 ; color RGB555, delay
        dw $039F : db $08 ; color RGB555, delay
        dw $029F : db $08 ; color RGB555, delay
        dw $039F : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E11D ; loop/jump

PaletteAnimScript_E12E: ;80E12E; colors=4 delays=$08 refs=1 jump=E12E
        dw $019C : db $08 ; color RGB555, delay
        dw $029F : db $08 ; color RGB555, delay
        dw $019C : db $08 ; color RGB555, delay
        dw $029F : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E12E ; loop/jump

PaletteAnimScript_E13F: ;80E13F; colors=4 delays=$08 refs=1 jump=E13F
        dw $0138 : db $08 ; color RGB555, delay
        dw $019C : db $08 ; color RGB555, delay
        dw $0138 : db $08 ; color RGB555, delay
        dw $019C : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E13F ; loop/jump

PaletteAnimScript_E150: ;80E150; colors=4 delays=$08 refs=1 jump=E150
        dw $00EA : db $08 ; color RGB555, delay
        dw $011C : db $08 ; color RGB555, delay
        dw $00EA : db $08 ; color RGB555, delay
        dw $00EA : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E150 ; loop/jump

PaletteAnimScript_E161: ;80E161; colors=4 delays=$08 refs=1 jump=E161
        dw $012D : db $08 ; color RGB555, delay
        dw $012D : db $08 ; color RGB555, delay
        dw $012D : db $08 ; color RGB555, delay
        dw $013B : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E161 ; loop/jump

PaletteAnimScript_E172: ;80E172; colors=2 delays=$08 refs=1 jump=E172
        dw $0048 : db $08 ; color RGB555, delay
        dw $000C : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E172 ; loop/jump

PaletteAnimScript_E17D: ;80E17D; colors=2 delays=$08 refs=1 jump=E17D
        dw $0017 : db $08 ; color RGB555, delay
        dw $001A : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E17D ; loop/jump

PaletteAnimScript_E188: ;80E188; colors=2 delays=$08 refs=1 jump=E188
        dw $001F : db $08 ; color RGB555, delay
        dw $017F : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E188 ; loop/jump

PaletteAnimScript_E193: ;80E193; colors=2 delays=$08 refs=1 jump=E193
        dw $01B4 : db $08 ; color RGB555, delay
        dw $0219 : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E193 ; loop/jump

PaletteAnimScript_E19E: ;80E19E; colors=2 delays=$08 refs=1 jump=E19E
        dw $004C : db $08 ; color RGB555, delay
        dw $0052 : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E19E ; loop/jump

PaletteAnimScript_E1A9: ;80E1A9; colors=2 delays=$08 refs=1 jump=E1A9
        dw $02BF : db $08 ; color RGB555, delay
        dw $017F : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E1A9 ; loop/jump

PaletteAnimScript_E1B4: ;80E1B4; colors=2 delays=$08 refs=1 jump=E1B4
        dw $009F : db $08 ; color RGB555, delay
        dw $035F : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E1B4 ; loop/jump

PaletteAnimScript_E1BF: ;80E1BF; colors=2 delays=$08 refs=1 jump=E1BF
        dw $029F : db $08 ; color RGB555, delay
        dw $039F : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E1BF ; loop/jump

PaletteAnimScript_E1CA: ;80E1CA; colors=4 delays=$08 refs=1 jump=E1CA
        dw $218D : db $08 ; color RGB555, delay
        dw $2E10 : db $08 ; color RGB555, delay
        dw $2E10 : db $08 ; color RGB555, delay
        dw $2E10 : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E1CA ; loop/jump

PaletteAnimScript_E1DB: ;80E1DB; colors=4 delays=$08 refs=1 jump=E1DB
        dw $5F9C : db $08 ; color RGB555, delay
        dw $5F7B : db $08 ; color RGB555, delay
        dw $4AF9 : db $08 ; color RGB555, delay
        dw $5F7B : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E1DB ; loop/jump

PaletteAnimScript_E1EC: ;80E1EC; colors=4 delays=$08 refs=1 jump=E1EC
        dw $4AF9 : db $08 ; color RGB555, delay
        dw $4AF9 : db $08 ; color RGB555, delay
        dw $261F : db $08 ; color RGB555, delay
        dw $4AF9 : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E1EC ; loop/jump

PaletteAnimScript_E1FD: ;80E1FD; colors=4 delays=$08 refs=1 jump=E1FD
        dw $261F : db $08 ; color RGB555, delay
        dw $261F : db $08 ; color RGB555, delay
        dw $053E : db $08 ; color RGB555, delay
        dw $261F : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E1FD ; loop/jump

PaletteAnimScript_E20E: ;80E20E; colors=4 delays=$08 refs=1 jump=E20E
        dw $053E : db $08 ; color RGB555, delay
        dw $261F : db $08 ; color RGB555, delay
        dw $4AF9 : db $08 ; color RGB555, delay
        dw $261F : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E20E ; loop/jump

PaletteAnimScript_E21F: ;80E21F; colors=4 delays=$08 refs=1 jump=E21F
        dw $261F : db $08 ; color RGB555, delay
        dw $4AF9 : db $08 ; color RGB555, delay
        dw $4AF9 : db $08 ; color RGB555, delay
        dw $4AF9 : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E21F ; loop/jump

PaletteAnimScript_E230: ;80E230; colors=4 delays=$08 refs=1 jump=E230
        dw $03BF : db $08 ; color RGB555, delay
        dw $261F : db $08 ; color RGB555, delay
        dw $03BF : db $08 ; color RGB555, delay
        dw $261F : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E230 ; loop/jump

PaletteAnimScript_E241: ;80E241; colors=4 delays=$08 refs=1 jump=E241
        dw $03BF : db $08 ; color RGB555, delay
        dw $261F : db $08 ; color RGB555, delay
        dw $053E : db $08 ; color RGB555, delay
        dw $261F : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E241 ; loop/jump

PaletteAnimScript_E252: ;80E252; colors=2 delays=$08 refs=1 jump=E252
        dw $123F : db $08 ; color RGB555, delay
        dw $06BF : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E252 ; loop/jump

PaletteAnimScript_E25D: ;80E25D; colors=2 delays=$08 refs=1 jump=E25D
        dw $0048 : db $08 ; color RGB555, delay
        dw $004D : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E25D ; loop/jump

PaletteAnimScript_E268: ;80E268; colors=2 delays=$08 refs=1 jump=E268
        dw $021F : db $08 ; color RGB555, delay
        dw $013A : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E268 ; loop/jump

PaletteAnimScript_E273: ;80E273; colors=2 delays=$08 refs=1 jump=E273
        dw $00FA : db $08 ; color RGB555, delay
        dw $033F : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E273 ; loop/jump

PaletteAnimScript_E27E: ;80E27E; colors=2 delays=$08 refs=1 jump=E27E
        dw $0048 : db $08 ; color RGB555, delay
        dw $004F : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E27E ; loop/jump

PaletteAnimScript_E289: ;80E289; colors=2 delays=$08 refs=1 jump=E289
        dw $1E9A : db $08 ; color RGB555, delay
        dw $1F1F : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E289 ; loop/jump

PaletteAnimScript_E294: ;80E294; colors=2 delays=$08 refs=1 jump=E294
        dw $021F : db $08 ; color RGB555, delay
        dw $0037 : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E294 ; loop/jump

PaletteAnimScript_E29F: ;80E29F; colors=2 delays=$08 refs=1 jump=E29F
        dw $0019 : db $08 ; color RGB555, delay
        dw $0025 : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E29F ; loop/jump

PaletteAnimScript_E2AA: ;80E2AA; colors=2 delays=$08 refs=1 jump=E2AA
        dw $2E7F : db $08 ; color RGB555, delay
        dw $233F : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E2AA ; loop/jump

PaletteAnimScript_E2B5: ;80E2B5; colors=2 delays=$08 refs=1 jump=E2B5
        dw $0088 : db $08 ; color RGB555, delay
        dw $008C : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E2B5 ; loop/jump

PaletteAnimScript_E2C0: ;80E2C0; colors=2 delays=$08 refs=1 jump=E2C0
        dw $009D : db $08 ; color RGB555, delay
        dw $029F : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E2C0 ; loop/jump

PaletteAnimScript_E2CB: ;80E2CB; colors=2 delays=$08 refs=1 jump=E2CB
        dw $021F : db $08 ; color RGB555, delay
        dw $011F : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E2CB ; loop/jump

PaletteAnimScript_E2D6: ;80E2D6; colors=2 delays=$08 refs=1 jump=E2D6
        dw $0090 : db $08 ; color RGB555, delay
        dw $009C : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E2D6 ; loop/jump

PaletteAnimScript_E2E1: ;80E2E1; colors=2 delays=$08 refs=1 jump=E2E1
        dw $01DE : db $08 ; color RGB555, delay
        dw $02BF : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E2E1 ; loop/jump

PaletteAnimScript_E2EC: ;80E2EC; colors=2 delays=$08 refs=1 jump=E2EC
        dw $004F : db $08 ; color RGB555, delay
        dw $00D0 : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E2EC ; loop/jump

PaletteAnimScript_E2F7: ;80E2F7; colors=3 delays=$10 refs=1 jump=E2F7
        dw $5E0F : db $10 ; color RGB555, delay
        dw $4A54 : db $10 ; color RGB555, delay
        dw $7F17 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E2F7 ; loop/jump

PaletteAnimScript_E305: ;80E305; colors=3 delays=$10 refs=1 jump=E305
        dw $4A54 : db $10 ; color RGB555, delay
        dw $7F17 : db $10 ; color RGB555, delay
        dw $5E0F : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E305 ; loop/jump

PaletteAnimScript_E313: ;80E313; colors=3 delays=$10 refs=1 jump=E313
        dw $7F17 : db $10 ; color RGB555, delay
        dw $5E0F : db $10 ; color RGB555, delay
        dw $4A54 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E313 ; loop/jump

PaletteAnimScript_E321: ;80E321; colors=3 delays=$10 refs=1 jump=E321
        dw $4213 : db $10 ; color RGB555, delay
        dw $4257 : db $10 ; color RGB555, delay
        dw $56FC : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E321 ; loop/jump

PaletteAnimScript_E32F: ;80E32F; colors=3 delays=$10 refs=1 jump=E32F
        dw $4257 : db $10 ; color RGB555, delay
        dw $56FC : db $10 ; color RGB555, delay
        dw $4213 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E32F ; loop/jump

PaletteAnimScript_E33D: ;80E33D; colors=3 delays=$10 refs=1 jump=E33D
        dw $56FC : db $10 ; color RGB555, delay
        dw $4213 : db $10 ; color RGB555, delay
        dw $4257 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E33D ; loop/jump

PaletteAnimScript_E34B: ;80E34B; colors=3 delays=$10 refs=1 jump=E34B
        dw $3D4A : db $10 ; color RGB555, delay
        dw $3D4A : db $10 ; color RGB555, delay
        dw $458C : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E34B ; loop/jump

PaletteAnimScript_E359: ;80E359; colors=3 delays=$10 refs=1 jump=E359
        dw $3D4A : db $10 ; color RGB555, delay
        dw $458C : db $10 ; color RGB555, delay
        dw $3D4A : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E359 ; loop/jump

PaletteAnimScript_E367: ;80E367; colors=3 delays=$10 refs=1 jump=E367
        dw $458C : db $10 ; color RGB555, delay
        dw $3D4A : db $10 ; color RGB555, delay
        dw $3D4A : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E367 ; loop/jump

PaletteAnimScript_E375: ;80E375; colors=3 delays=$10 refs=1 jump=E375
        dw $3129 : db $10 ; color RGB555, delay
        dw $2908 : db $10 ; color RGB555, delay
        dw $316B : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E375 ; loop/jump

PaletteAnimScript_E383: ;80E383; colors=3 delays=$10 refs=1 jump=E383
        dw $2908 : db $10 ; color RGB555, delay
        dw $316B : db $10 ; color RGB555, delay
        dw $3129 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E383 ; loop/jump

PaletteAnimScript_E391: ;80E391; colors=3 delays=$10 refs=1 jump=E391
        dw $316B : db $10 ; color RGB555, delay
        dw $3129 : db $10 ; color RGB555, delay
        dw $2908 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E391 ; loop/jump

PaletteAnimScript_E39F: ;80E39F; colors=3 delays=$10 refs=1 jump=E39F
        dw $6250 : db $10 ; color RGB555, delay
        dw $7271 : db $10 ; color RGB555, delay
        dw $7F79 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E39F ; loop/jump

PaletteAnimScript_E3AD: ;80E3AD; colors=3 delays=$10 refs=1 jump=E3AD
        dw $7271 : db $10 ; color RGB555, delay
        dw $7F79 : db $10 ; color RGB555, delay
        dw $6250 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E3AD ; loop/jump

PaletteAnimScript_E3BB: ;80E3BB; colors=3 delays=$10 refs=1 jump=E3BB
        dw $7F79 : db $10 ; color RGB555, delay
        dw $6250 : db $10 ; color RGB555, delay
        dw $7271 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E3BB ; loop/jump

PaletteAnimScript_E3C9: ;80E3C9; colors=3 delays=$10 refs=1 jump=E3C9
        dw $5E78 : db $10 ; color RGB555, delay
        dw $5654 : db $10 ; color RGB555, delay
        dw $7F19 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E3C9 ; loop/jump

PaletteAnimScript_E3D7: ;80E3D7; colors=3 delays=$10 refs=1 jump=E3D7
        dw $5654 : db $10 ; color RGB555, delay
        dw $7F19 : db $10 ; color RGB555, delay
        dw $5E78 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E3D7 ; loop/jump

PaletteAnimScript_E3E5: ;80E3E5; colors=3 delays=$10 refs=1 jump=E3E5
        dw $7F19 : db $10 ; color RGB555, delay
        dw $5E78 : db $10 ; color RGB555, delay
        dw $5654 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E3E5 ; loop/jump

PaletteAnimScript_E3F3: ;80E3F3; colors=3 delays=$10 refs=1 jump=E3F3
        dw $3D4A : db $10 ; color RGB555, delay
        dw $3D4A : db $10 ; color RGB555, delay
        dw $458C : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E3F3 ; loop/jump

PaletteAnimScript_E401: ;80E401; colors=3 delays=$10 refs=1 jump=E401
        dw $3D4A : db $10 ; color RGB555, delay
        dw $458C : db $10 ; color RGB555, delay
        dw $3D4A : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E401 ; loop/jump

PaletteAnimScript_E40F: ;80E40F; colors=3 delays=$10 refs=1 jump=E40F
        dw $458C : db $10 ; color RGB555, delay
        dw $3D4A : db $10 ; color RGB555, delay
        dw $3D4A : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E40F ; loop/jump

PaletteAnimScript_E41D: ;80E41D; colors=3 delays=$10 refs=1 jump=E41D
        dw $30E7 : db $10 ; color RGB555, delay
        dw $30E7 : db $10 ; color RGB555, delay
        dw $3529 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E41D ; loop/jump

PaletteAnimScript_E42B: ;80E42B; colors=3 delays=$10 refs=1 jump=E42B
        dw $30E7 : db $10 ; color RGB555, delay
        dw $3529 : db $10 ; color RGB555, delay
        dw $30E7 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E42B ; loop/jump

PaletteAnimScript_E439: ;80E439; colors=3 delays=$10 refs=1 jump=E439
        dw $3529 : db $10 ; color RGB555, delay
        dw $30E7 : db $10 ; color RGB555, delay
        dw $30E7 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E439 ; loop/jump

PaletteAnimScript_E447: ;80E447; colors=3 delays=$10 refs=1 jump=E447
        dw $4A91 : db $10 ; color RGB555, delay
        dw $62CE : db $10 ; color RGB555, delay
        dw $6374 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E447 ; loop/jump

PaletteAnimScript_E455: ;80E455; colors=3 delays=$10 refs=1 jump=E455
        dw $62CE : db $10 ; color RGB555, delay
        dw $6374 : db $10 ; color RGB555, delay
        dw $4A91 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E455 ; loop/jump

PaletteAnimScript_E463: ;80E463; colors=3 delays=$10 refs=1 jump=E463
        dw $6374 : db $10 ; color RGB555, delay
        dw $4A91 : db $10 ; color RGB555, delay
        dw $62CE : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E463 ; loop/jump

PaletteAnimScript_E471: ;80E471; colors=3 delays=$10 refs=1 jump=E471
        dw $3694 : db $10 ; color RGB555, delay
        dw $3254 : db $10 ; color RGB555, delay
        dw $3AFC : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E471 ; loop/jump

PaletteAnimScript_E47F: ;80E47F; colors=3 delays=$10 refs=1 jump=E47F
        dw $3254 : db $10 ; color RGB555, delay
        dw $3AFC : db $10 ; color RGB555, delay
        dw $3694 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E47F ; loop/jump

PaletteAnimScript_E48D: ;80E48D; colors=3 delays=$10 refs=1 jump=E48D
        dw $3AEC : db $10 ; color RGB555, delay
        dw $3694 : db $10 ; color RGB555, delay
        dw $3254 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E48D ; loop/jump

PaletteAnimScript_E49B: ;80E49B; colors=3 delays=$10 refs=1 jump=E49B
        dw $2DCB : db $10 ; color RGB555, delay
        dw $2DCB : db $10 ; color RGB555, delay
        dw $360E : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E49B ; loop/jump

PaletteAnimScript_E4A9: ;80E4A9; colors=3 delays=$10 refs=1 jump=E4A9
        dw $2DCB : db $10 ; color RGB555, delay
        dw $360E : db $10 ; color RGB555, delay
        dw $2DCB : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E4A9 ; loop/jump

PaletteAnimScript_E4B7: ;80E4B7; colors=3 delays=$10 refs=1 jump=E4B7
        dw $360E : db $10 ; color RGB555, delay
        dw $2DCB : db $10 ; color RGB555, delay
        dw $2DCB : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E4B7 ; loop/jump

PaletteAnimScript_E4C5: ;80E4C5; colors=3 delays=$10 refs=1 jump=E4C5
        dw $30E7 : db $10 ; color RGB555, delay
        dw $3127 : db $10 ; color RGB555, delay
        dw $356A : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E4C5 ; loop/jump

PaletteAnimScript_E4D3: ;80E4D3; colors=3 delays=$10 refs=1 jump=E4D3
        dw $3127 : db $10 ; color RGB555, delay
        dw $356A : db $10 ; color RGB555, delay
        dw $30E7 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E4D3 ; loop/jump

PaletteAnimScript_E4E1: ;80E4E1; colors=3 delays=$10 refs=1 jump=E4E1
        dw $356A : db $10 ; color RGB555, delay
        dw $30E7 : db $10 ; color RGB555, delay
        dw $3127 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E4E1 ; loop/jump

PaletteAnimScript_E4EF: ;80E4EF; colors=4 delays=$0A,$10 refs=1 jump=E4EF
        dw $2162 : db $0A ; color RGB555, delay
        dw $2190 : db $0A ; color RGB555, delay
        dw $25D2 : db $10 ; color RGB555, delay
        dw $2190 : db $0A ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E4EF ; loop/jump

PaletteAnimScript_E500: ;80E500; colors=4 delays=$0A,$10 refs=1 jump=E500
        dw $0E58 : db $0A ; color RGB555, delay
        dw $129A : db $0A ; color RGB555, delay
        dw $16DC : db $10 ; color RGB555, delay
        dw $129A : db $0A ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E500 ; loop/jump

PaletteAnimScript_E511: ;80E511; colors=4 delays=$0A,$10 refs=1 jump=E511
        dw $377D : db $0A ; color RGB555, delay
        dw $479F : db $0A ; color RGB555, delay
        dw $53DF : db $10 ; color RGB555, delay
        dw $479F : db $0A ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E511 ; loop/jump

PaletteAnimScript_E522: ;80E522; colors=4 delays=$0A,$10 refs=1 jump=E522
        dw $092C : db $0A ; color RGB555, delay
        dw $116F : db $0A ; color RGB555, delay
        dw $11B1 : db $10 ; color RGB555, delay
        dw $116F : db $0A ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E522 ; loop/jump

PaletteAnimScript_E533: ;80E533; colors=4 delays=$0A,$10 refs=1 jump=E533
        dw $0D8E : db $0A ; color RGB555, delay
        dw $0DB1 : db $0A ; color RGB555, delay
        dw $0DB4 : db $10 ; color RGB555, delay
        dw $0DB1 : db $0A ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E533 ; loop/jump

PaletteAnimScript_E544: ;80E544; colors=4 delays=$0A,$10 refs=1 jump=E544
        dw $36D7 : db $0A ; color RGB555, delay
        dw $3719 : db $0A ; color RGB555, delay
        dw $377F : db $10 ; color RGB555, delay
        dw $3719 : db $0A ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E544 ; loop/jump

PaletteAnimScript_E555: ;80E555; colors=4 delays=$0A,$10 refs=1 jump=E555
        dw $27DE : db $0A ; color RGB555, delay
        dw $3FFF : db $0A ; color RGB555, delay
        dw $53FF : db $10 ; color RGB555, delay
        dw $3FFF : db $0A ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E555 ; loop/jump

PaletteAnimScript_E566: ;80E566; colors=4 delays=$0A,$10 refs=1 jump=E566
        dw $196E : db $0A ; color RGB555, delay
        dw $1970 : db $0A ; color RGB555, delay
        dw $1992 : db $10 ; color RGB555, delay
        dw $1970 : db $0A ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E566 ; loop/jump

PaletteAnimScript_E577: ;80E577; colors=4 delays=$0A,$10 refs=1 jump=E577
        dw $150A : db $0A ; color RGB555, delay
        dw $1D4F : db $0A ; color RGB555, delay
        dw $1D90 : db $10 ; color RGB555, delay
        dw $1D4F : db $0A ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E577 ; loop/jump

PaletteAnimScript_E588: ;80E588; colors=4 delays=$0A,$10 refs=1 jump=E588
        dw $0A18 : db $0A ; color RGB555, delay
        dw $0A1C : db $0A ; color RGB555, delay
        dw $0A9F : db $10 ; color RGB555, delay
        dw $0A1C : db $0A ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E588 ; loop/jump

PaletteAnimScript_E599: ;80E599; colors=4 delays=$0A,$10 refs=1 jump=E599
        dw $2F7C : db $0A ; color RGB555, delay
        dw $2FBE : db $0A ; color RGB555, delay
        dw $4BDF : db $10 ; color RGB555, delay
        dw $2FBE : db $0A ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E599 ; loop/jump

PaletteAnimScript_E5AA: ;80E5AA; colors=4 delays=$0A,$10 refs=1 jump=E5AA
        dw $090C : db $0A ; color RGB555, delay
        dw $116E : db $0A ; color RGB555, delay
        dw $1190 : db $10 ; color RGB555, delay
        dw $116E : db $0A ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E5AA ; loop/jump

PaletteAnimScript_E5BB: ;80E5BB; colors=4 delays=$0A,$10 refs=1 jump=E5BB
        dw $1CE8 : db $0A ; color RGB555, delay
        dw $210A : db $0A ; color RGB555, delay
        dw $216F : db $10 ; color RGB555, delay
        dw $210A : db $0A ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E5BB ; loop/jump

PaletteAnimScript_E5CC: ;80E5CC; colors=4 delays=$0A,$10 refs=1 jump=E5CC
        dw $29F3 : db $0A ; color RGB555, delay
        dw $2A19 : db $0A ; color RGB555, delay
        dw $327B : db $10 ; color RGB555, delay
        dw $2A19 : db $0A ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E5CC ; loop/jump

PaletteAnimScript_E5DD: ;80E5DD; colors=4 delays=$0A,$10 refs=1 jump=E5DD
        dw $3EB8 : db $0A ; color RGB555, delay
        dw $3F3D : db $0A ; color RGB555, delay
        dw $437F : db $10 ; color RGB555, delay
        dw $3F3D : db $0A ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E5DD ; loop/jump

PaletteAnimScript_E5EE: ;80E5EE; colors=4 delays=$0A,$10 refs=1 jump=E5EE
        dw $1D6C : db $0A ; color RGB555, delay
        dw $218E : db $0A ; color RGB555, delay
        dw $25AF : db $10 ; color RGB555, delay
        dw $218E : db $0A ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E5EE ; loop/jump

PaletteAnimScript_E5FF: ;80E5FF; colors=6 delays=$0C,$0F,$10 refs=1 jump=E5FF
        dw $7F3B : db $10 ; color RGB555, delay
        dw $6EB5 : db $10 ; color RGB555, delay
        dw $5E2E : db $0F ; color RGB555, delay
        dw $51F0 : db $10 ; color RGB555, delay
        dw $5233 : db $0C ; color RGB555, delay
        dw $6EB7 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E5FF ; loop/jump

PaletteAnimScript_E616: ;80E616; colors=6 delays=$0C,$0F,$10 refs=1 jump=E616
        dw $6EB7 : db $10 ; color RGB555, delay
        dw $5E2E : db $10 ; color RGB555, delay
        dw $51F0 : db $0F ; color RGB555, delay
        dw $7F39 : db $10 ; color RGB555, delay
        dw $51F0 : db $0C ; color RGB555, delay
        dw $5233 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E616 ; loop/jump

PaletteAnimScript_E62D: ;80E62D; colors=6 delays=$0C,$0F,$10 refs=1 jump=E62D
        dw $5E2E : db $10 ; color RGB555, delay
        dw $51F0 : db $10 ; color RGB555, delay
        dw $7F3B : db $0F ; color RGB555, delay
        dw $6EB7 : db $10 ; color RGB555, delay
        dw $7F39 : db $0C ; color RGB555, delay
        dw $4DD1 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E62D ; loop/jump

PaletteAnimScript_E644: ;80E644; colors=6 delays=$0C,$0F,$10 refs=1 jump=E644
        dw $51F0 : db $10 ; color RGB555, delay
        dw $7F39 : db $10 ; color RGB555, delay
        dw $6EB7 : db $0F ; color RGB555, delay
        dw $5E2E : db $10 ; color RGB555, delay
        dw $6EB7 : db $0C ; color RGB555, delay
        dw $7F39 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E644 ; loop/jump

PaletteAnimScript_E65B: ;80E65B; colors=6 delays=$0C,$0F,$10 refs=1 jump=E65B
        dw $41F0 : db $10 ; color RGB555, delay
        dw $3DF1 : db $10 ; color RGB555, delay
        dw $4211 : db $0F ; color RGB555, delay
        dw $41F1 : db $10 ; color RGB555, delay
        dw $4211 : db $0C ; color RGB555, delay
        dw $3DF1 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E65B ; loop/jump

PaletteAnimScript_E672: ;80E672; colors=6 delays=$0C,$0F,$10 refs=1 jump=E672
        dw $537B : db $10 ; color RGB555, delay
        dw $42BB : db $10 ; color RGB555, delay
        dw $3234 : db $0F ; color RGB555, delay
        dw $3233 : db $10 ; color RGB555, delay
        dw $3234 : db $0C ; color RGB555, delay
        dw $42BB : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E672 ; loop/jump

PaletteAnimScript_E689: ;80E689; colors=6 delays=$0C,$0F,$10 refs=1 jump=E689
        dw $42B8 : db $10 ; color RGB555, delay
        dw $3234 : db $10 ; color RGB555, delay
        dw $3233 : db $0F ; color RGB555, delay
        dw $42DB : db $10 ; color RGB555, delay
        dw $3233 : db $0C ; color RGB555, delay
        dw $3234 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E689 ; loop/jump

PaletteAnimScript_E6A0: ;80E6A0; colors=6 delays=$0C,$0F,$10 refs=1 jump=E6A0
        dw $3234 : db $10 ; color RGB555, delay
        dw $3233 : db $10 ; color RGB555, delay
        dw $42DB : db $0F ; color RGB555, delay
        dw $32B8 : db $10 ; color RGB555, delay
        dw $42DB : db $0C ; color RGB555, delay
        dw $3233 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E6A0 ; loop/jump

PaletteAnimScript_E6B7: ;80E6B7; colors=6 delays=$0C,$0F,$10 refs=1 jump=E6B7
        dw $3233 : db $10 ; color RGB555, delay
        dw $42DB : db $10 ; color RGB555, delay
        dw $32B8 : db $0F ; color RGB555, delay
        dw $3234 : db $10 ; color RGB555, delay
        dw $32B8 : db $0C ; color RGB555, delay
        dw $42DB : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E6B7 ; loop/jump

PaletteAnimScript_E6CE: ;80E6CE; colors=6 delays=$0C,$0F,$10 refs=1 jump=E6CE
        dw $21B1 : db $10 ; color RGB555, delay
        dw $25D1 : db $10 ; color RGB555, delay
        dw $29D1 : db $0F ; color RGB555, delay
        dw $3234 : db $10 ; color RGB555, delay
        dw $29D1 : db $0C ; color RGB555, delay
        dw $25D1 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E6CE ; loop/jump

PaletteAnimScript_E6E5: ;80E6E5; colors=6 delays=$0C,$0F,$10 refs=1 jump=E6E5
        dw $3213 : db $10 ; color RGB555, delay
        dw $1D8C : db $10 ; color RGB555, delay
        dw $29CF : db $0F ; color RGB555, delay
        dw $2E11 : db $10 ; color RGB555, delay
        dw $29CF : db $0C ; color RGB555, delay
        dw $1D8C : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E6E5 ; loop/jump

PaletteAnimScript_E6FC: ;80E6FC; colors=6 delays=$0C,$0F,$10 refs=1 jump=E6FC
        dw $2DF1 : db $10 ; color RGB555, delay
        dw $3233 : db $10 ; color RGB555, delay
        dw $1D8C : db $0F ; color RGB555, delay
        dw $29CF : db $10 ; color RGB555, delay
        dw $1D8C : db $0C ; color RGB555, delay
        dw $3233 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E6FC ; loop/jump

PaletteAnimScript_E713: ;80E713; colors=6 delays=$0C,$0F,$10 refs=1 jump=E713
        dw $21AF : db $10 ; color RGB555, delay
        dw $2E11 : db $10 ; color RGB555, delay
        dw $3233 : db $0F ; color RGB555, delay
        dw $1D8C : db $10 ; color RGB555, delay
        dw $3233 : db $0C ; color RGB555, delay
        dw $2E11 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E713 ; loop/jump

PaletteAnimScript_E72A: ;80E72A; colors=6 delays=$0C,$0F,$10 refs=1 jump=E72A
        dw $1D6C : db $10 ; color RGB555, delay
        dw $29CF : db $10 ; color RGB555, delay
        dw $2E11 : db $0F ; color RGB555, delay
        dw $3233 : db $10 ; color RGB555, delay
        dw $2E11 : db $0C ; color RGB555, delay
        dw $29CF : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E72A ; loop/jump

PaletteAnimScript_E741: ;80E741; colors=6 delays=$0C,$0F,$10 refs=1 jump=E741
        dw $1D4C : db $10 ; color RGB555, delay
        dw $1D4C : db $10 ; color RGB555, delay
        dw $214C : db $0F ; color RGB555, delay
        dw $214C : db $10 ; color RGB555, delay
        dw $214C : db $0C ; color RGB555, delay
        dw $1D4C : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E741 ; loop/jump

PaletteAnimScript_E758: ;80E758; colors=6 delays=$0C,$0F,$10 refs=1 jump=E758
        dw $218B : db $10 ; color RGB555, delay
        dw $192A : db $10 ; color RGB555, delay
        dw $1D4B : db $0F ; color RGB555, delay
        dw $1D4B : db $10 ; color RGB555, delay
        dw $1D4B : db $0C ; color RGB555, delay
        dw $192A : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E758 ; loop/jump

PaletteAnimScript_E76F: ;80E76F; colors=6 delays=$0C,$0F,$10 refs=1 jump=E76F
        dw $1D4B : db $10 ; color RGB555, delay
        dw $216B : db $10 ; color RGB555, delay
        dw $192A : db $0F ; color RGB555, delay
        dw $1D4B : db $10 ; color RGB555, delay
        dw $192A : db $0C ; color RGB555, delay
        dw $216B : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E76F ; loop/jump

PaletteAnimScript_E786: ;80E786; colors=6 delays=$0C,$0F,$10 refs=1 jump=E786
        dw $1D2A : db $10 ; color RGB555, delay
        dw $1D48 : db $10 ; color RGB555, delay
        dw $214B : db $0F ; color RGB555, delay
        dw $192A : db $10 ; color RGB555, delay
        dw $214B : db $0C ; color RGB555, delay
        dw $1D48 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E786 ; loop/jump

PaletteAnimScript_E79D: ;80E79D; colors=6 delays=$0C,$0F,$10 refs=1 jump=E79D
        dw $1928 : db $10 ; color RGB555, delay
        dw $1D4B : db $10 ; color RGB555, delay
        dw $1D4B : db $0F ; color RGB555, delay
        dw $1D6B : db $10 ; color RGB555, delay
        dw $1D4B : db $0C ; color RGB555, delay
        dw $1D4B : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E79D ; loop/jump

PaletteAnimScript_E7B4: ;80E7B4; colors=6 delays=$0C,$0F,$10 refs=1 jump=E7B4
        dw $7F52 : db $10 ; color RGB555, delay
        dw $5D66 : db $10 ; color RGB555, delay
        dw $7D86 : db $0F ; color RGB555, delay
        dw $7E4B : db $10 ; color RGB555, delay
        dw $7D86 : db $0C ; color RGB555, delay
        dw $5D66 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E7B4 ; loop/jump

PaletteAnimScript_E7CB: ;80E7CB; colors=6 delays=$0C,$0F,$10 refs=1 jump=E7CB
        dw $7E4B : db $10 ; color RGB555, delay
        dw $4F32 : db $10 ; color RGB555, delay
        dw $5D66 : db $0F ; color RGB555, delay
        dw $7D86 : db $10 ; color RGB555, delay
        dw $5D66 : db $0C ; color RGB555, delay
        dw $7F32 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E7CB ; loop/jump

PaletteAnimScript_E7E2: ;80E7E2; colors=6 delays=$0C,$0F,$10 refs=1 jump=E7E2
        dw $7D86 : db $10 ; color RGB555, delay
        dw $7E4B : db $10 ; color RGB555, delay
        dw $7F32 : db $0F ; color RGB555, delay
        dw $5D66 : db $10 ; color RGB555, delay
        dw $7F32 : db $0C ; color RGB555, delay
        dw $7E4B : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E7E2 ; loop/jump

PaletteAnimScript_E7F9: ;80E7F9; colors=6 delays=$0C,$0F,$10 refs=1 jump=E7F9
        dw $5D66 : db $10 ; color RGB555, delay
        dw $7D86 : db $10 ; color RGB555, delay
        dw $7E4B : db $0F ; color RGB555, delay
        dw $7F32 : db $10 ; color RGB555, delay
        dw $7E4B : db $0C ; color RGB555, delay
        dw $7D86 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E7F9 ; loop/jump

PaletteAnimScript_E810: ;80E810; colors=6 delays=$0C,$0F,$10 refs=1 jump=E810
        dw $5D66 : db $10 ; color RGB555, delay
        dw $6186 : db $10 ; color RGB555, delay
        dw $6586 : db $0F ; color RGB555, delay
        dw $69A6 : db $10 ; color RGB555, delay
        dw $6586 : db $0C ; color RGB555, delay
        dw $6186 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E810 ; loop/jump

PaletteAnimScript_E827: ;80E827; colors=6 delays=$0C,$0F,$10 refs=1 jump=E827
        dw $3F9E : db $10 ; color RGB555, delay
        dw $169E : db $10 ; color RGB555, delay
        dw $1218 : db $0F ; color RGB555, delay
        dw $1174 : db $10 ; color RGB555, delay
        dw $1218 : db $0C ; color RGB555, delay
        dw $169E : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E827 ; loop/jump

PaletteAnimScript_E83E: ;80E83E; colors=6 delays=$0C,$0F,$10 refs=1 jump=E83E
        dw $169E : db $10 ; color RGB555, delay
        dw $1218 : db $10 ; color RGB555, delay
        dw $1174 : db $0F ; color RGB555, delay
        dw $2AFA : db $10 ; color RGB555, delay
        dw $1174 : db $0C ; color RGB555, delay
        dw $1218 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E83E ; loop/jump

PaletteAnimScript_E855: ;80E855; colors=6 delays=$0C,$0F,$10 refs=1 jump=E855
        dw $1218 : db $10 ; color RGB555, delay
        dw $1174 : db $10 ; color RGB555, delay
        dw $3F9E : db $0F ; color RGB555, delay
        dw $169E : db $10 ; color RGB555, delay
        dw $3F9E : db $0C ; color RGB555, delay
        dw $1174 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E855 ; loop/jump

PaletteAnimScript_E86C: ;80E86C; colors=6 delays=$0C,$0F,$10 refs=1 jump=E86C
        dw $1174 : db $10 ; color RGB555, delay
        dw $267B : db $10 ; color RGB555, delay
        dw $169E : db $0F ; color RGB555, delay
        dw $1218 : db $10 ; color RGB555, delay
        dw $169E : db $0C ; color RGB555, delay
        dw $267B : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E86C ; loop/jump

PaletteAnimScript_E883: ;80E883; colors=6 delays=$0C,$0F,$10 refs=1 jump=E883
        dw $1DB1 : db $10 ; color RGB555, delay
        dw $1DB2 : db $10 ; color RGB555, delay
        dw $1DB3 : db $0F ; color RGB555, delay
        dw $1DB3 : db $10 ; color RGB555, delay
        dw $1DB3 : db $0C ; color RGB555, delay
        dw $1DB2 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E883 ; loop/jump

PaletteAnimScript_E89A: ;80E89A; colors=6 delays=$0C,$0F,$10 refs=1 jump=E89A
        dw $0DB3 : db $10 ; color RGB555, delay
        dw $09B3 : db $10 ; color RGB555, delay
        dw $0991 : db $0F ; color RGB555, delay
        dw $0172 : db $10 ; color RGB555, delay
        dw $0991 : db $0C ; color RGB555, delay
        dw $09B3 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E89A ; loop/jump

PaletteAnimScript_E8B1: ;80E8B1; colors=6 delays=$0C,$0F,$10 refs=1 jump=E8B1
        dw $09B3 : db $10 ; color RGB555, delay
        dw $0991 : db $10 ; color RGB555, delay
        dw $0172 : db $0F ; color RGB555, delay
        dw $0DB3 : db $10 ; color RGB555, delay
        dw $0172 : db $0C ; color RGB555, delay
        dw $0991 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E8B1 ; loop/jump

PaletteAnimScript_E8C8: ;80E8C8; colors=6 delays=$0C,$0F,$10 refs=1 jump=E8C8
        dw $0991 : db $10 ; color RGB555, delay
        dw $0172 : db $10 ; color RGB555, delay
        dw $0DB3 : db $0F ; color RGB555, delay
        dw $09B3 : db $10 ; color RGB555, delay
        dw $0DB3 : db $0C ; color RGB555, delay
        dw $0172 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E8C8 ; loop/jump

PaletteAnimScript_E8DF: ;80E8DF; colors=6 delays=$0C,$0F,$10 refs=1 jump=E8DF
        dw $0172 : db $10 ; color RGB555, delay
        dw $0DB3 : db $10 ; color RGB555, delay
        dw $09B3 : db $0F ; color RGB555, delay
        dw $0991 : db $10 ; color RGB555, delay
        dw $09B3 : db $0C ; color RGB555, delay
        dw $0DB3 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E8DF ; loop/jump

PaletteAnimScript_E8F6: ;80E8F6; colors=6 delays=$0C,$0F,$10 refs=1 jump=E8F6
        dw $194E : db $10 ; color RGB555, delay
        dw $110C : db $10 ; color RGB555, delay
        dw $110B : db $0F ; color RGB555, delay
        dw $110B : db $10 ; color RGB555, delay
        dw $110B : db $0C ; color RGB555, delay
        dw $110C : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E8F6 ; loop/jump

PaletteAnimScript_E90D: ;80E90D; colors=6 delays=$0C,$0F,$10 refs=1 jump=E90D
        dw $110C : db $10 ; color RGB555, delay
        dw $110B : db $10 ; color RGB555, delay
        dw $110B : db $0F ; color RGB555, delay
        dw $194E : db $10 ; color RGB555, delay
        dw $110B : db $0C ; color RGB555, delay
        dw $110B : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E90D ; loop/jump

PaletteAnimScript_E924: ;80E924; colors=6 delays=$0C,$0F,$10 refs=1 jump=E924
        dw $110B : db $10 ; color RGB555, delay
        dw $110B : db $10 ; color RGB555, delay
        dw $194E : db $0F ; color RGB555, delay
        dw $110C : db $10 ; color RGB555, delay
        dw $194E : db $0C ; color RGB555, delay
        dw $110B : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E924 ; loop/jump

PaletteAnimScript_E93B: ;80E93B; colors=6 delays=$0C,$0F,$10 refs=1 jump=E93B
        dw $110B : db $10 ; color RGB555, delay
        dw $194E : db $10 ; color RGB555, delay
        dw $110C : db $0F ; color RGB555, delay
        dw $110B : db $10 ; color RGB555, delay
        dw $110C : db $0C ; color RGB555, delay
        dw $194E : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E93B ; loop/jump

PaletteAnimScript_E952: ;80E952; colors=6 delays=$0C,$0F,$10 refs=1 jump=E952
        dw $21AC : db $10 ; color RGB555, delay
        dw $1D8B : db $10 ; color RGB555, delay
        dw $0D2B : db $0F ; color RGB555, delay
        dw $0D2B : db $10 ; color RGB555, delay
        dw $0D2B : db $0C ; color RGB555, delay
        dw $1D8B : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E952 ; loop/jump

PaletteAnimScript_E969: ;80E969; colors=6 delays=$0C,$0F,$10 refs=1 jump=E969
        dw $0D2B : db $10 ; color RGB555, delay
        dw $0D2B : db $10 ; color RGB555, delay
        dw $1D8B : db $0F ; color RGB555, delay
        dw $21AC : db $10 ; color RGB555, delay
        dw $1D8B : db $0C ; color RGB555, delay
        dw $0D2B : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E969 ; loop/jump

PaletteAnimScript_E980: ;80E980; colors=6 delays=$0C,$0F,$10 refs=1 jump=E980
        dw $32FE : db $10 ; color RGB555, delay
        dw $21EE : db $10 ; color RGB555, delay
        dw $29D1 : db $0F ; color RGB555, delay
        dw $2214 : db $10 ; color RGB555, delay
        dw $29D1 : db $0C ; color RGB555, delay
        dw $21EE : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E980 ; loop/jump

PaletteAnimScript_E997: ;80E997; colors=6 delays=$0C,$0F,$10 refs=1 jump=E997
        dw $29F5 : db $10 ; color RGB555, delay
        dw $2E76 : db $10 ; color RGB555, delay
        dw $21EE : db $0F ; color RGB555, delay
        dw $29D1 : db $10 ; color RGB555, delay
        dw $21EE : db $0C ; color RGB555, delay
        dw $2E76 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E997 ; loop/jump

PaletteAnimScript_E9AE: ;80E9AE; colors=6 delays=$0C,$0F,$10 refs=1 jump=E9AE
        dw $15F4 : db $10 ; color RGB555, delay
        dw $3214 : db $10 ; color RGB555, delay
        dw $2E33 : db $0F ; color RGB555, delay
        dw $21EE : db $10 ; color RGB555, delay
        dw $2E33 : db $0C ; color RGB555, delay
        dw $3214 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E9AE ; loop/jump

PaletteAnimScript_E9C5: ;80E9C5; colors=6 delays=$0C,$0F,$10 refs=1 jump=E9C5
        dw $1DD3 : db $10 ; color RGB555, delay
        dw $29D1 : db $10 ; color RGB555, delay
        dw $2E34 : db $0F ; color RGB555, delay
        dw $1DD1 : db $10 ; color RGB555, delay
        dw $2E34 : db $0C ; color RGB555, delay
        dw $29D1 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E9C5 ; loop/jump

PaletteAnimScript_E9DC: ;80E9DC; colors=6 delays=$0C,$0F,$10 refs=1 jump=E9DC
        dw $25EF : db $10 ; color RGB555, delay
        dw $25CE : db $10 ; color RGB555, delay
        dw $25AE : db $0F ; color RGB555, delay
        dw $25AD : db $10 ; color RGB555, delay
        dw $25AE : db $0C ; color RGB555, delay
        dw $25CE : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E9DC ; loop/jump

PaletteAnimScript_E9F3: ;80E9F3; colors=6 delays=$0C,$0F,$10 refs=1 jump=E9F3
        dw $214E : db $10 ; color RGB555, delay
        dw $1D4F : db $10 ; color RGB555, delay
        dw $1DB4 : db $0F ; color RGB555, delay
        dw $1DB4 : db $10 ; color RGB555, delay
        dw $1DB4 : db $0C ; color RGB555, delay
        dw $1D4F : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_E9F3 ; loop/jump

PaletteAnimScript_EA0A: ;80EA0A; colors=6 delays=$0C,$0F,$10 refs=1 jump=EA0A
        dw $1DB4 : db $10 ; color RGB555, delay
        dw $1D72 : db $10 ; color RGB555, delay
        dw $1D72 : db $0F ; color RGB555, delay
        dw $1D4F : db $10 ; color RGB555, delay
        dw $1D72 : db $0C ; color RGB555, delay
        dw $1D72 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EA0A ; loop/jump

PaletteAnimScript_EA21: ;80EA21; colors=6 delays=$0C,$0F,$10 refs=1 jump=EA21
        dw $377F : db $10 ; color RGB555, delay
        dw $21B0 : db $10 ; color RGB555, delay
        dw $161C : db $0F ; color RGB555, delay
        dw $1A59 : db $10 ; color RGB555, delay
        dw $161C : db $0C ; color RGB555, delay
        dw $21B0 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EA21 ; loop/jump

PaletteAnimScript_EA38: ;80EA38; colors=6 delays=$0C,$0F,$10 refs=1 jump=EA38
        dw $1A59 : db $10 ; color RGB555, delay
        dw $1A9B : db $10 ; color RGB555, delay
        dw $21B0 : db $0F ; color RGB555, delay
        dw $161C : db $10 ; color RGB555, delay
        dw $21B0 : db $0C ; color RGB555, delay
        dw $1A9B : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EA38 ; loop/jump

PaletteAnimScript_EA4F: ;80EA4F; colors=6 delays=$0C,$0F,$10 refs=1 jump=EA4F
        dw $161C : db $10 ; color RGB555, delay
        dw $1A59 : db $10 ; color RGB555, delay
        dw $1B1F : db $0F ; color RGB555, delay
        dw $21B0 : db $10 ; color RGB555, delay
        dw $1B1F : db $0C ; color RGB555, delay
        dw $1A59 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EA4F ; loop/jump

PaletteAnimScript_EA66: ;80EA66; colors=6 delays=$0C,$0F,$10 refs=1 jump=EA66
        dw $0994 : db $10 ; color RGB555, delay
        dw $161C : db $10 ; color RGB555, delay
        dw $1A59 : db $0F ; color RGB555, delay
        dw $1A9B : db $10 ; color RGB555, delay
        dw $1A59 : db $0C ; color RGB555, delay
        dw $161C : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EA66 ; loop/jump

PaletteAnimScript_EA7D: ;80EA7D; colors=6 delays=$0C,$0F,$10 refs=1 jump=EA7D
        dw $2190 : db $10 ; color RGB555, delay
        dw $21B0 : db $10 ; color RGB555, delay
        dw $2191 : db $0F ; color RGB555, delay
        dw $21B1 : db $10 ; color RGB555, delay
        dw $2191 : db $0C ; color RGB555, delay
        dw $21B0 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EA7D ; loop/jump

PaletteAnimScript_EA94: ;80EA94; colors=6 delays=$0C,$0F,$10 refs=1 jump=EA94
        dw $1D4C : db $10 ; color RGB555, delay
        dw $218E : db $10 ; color RGB555, delay
        dw $21B0 : db $0F ; color RGB555, delay
        dw $21B2 : db $10 ; color RGB555, delay
        dw $21B0 : db $0C ; color RGB555, delay
        dw $218E : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EA94 ; loop/jump

PaletteAnimScript_EAAB: ;80EAAB; colors=6 delays=$0C,$0F,$10 refs=1 jump=EAAB
        dw $21B2 : db $10 ; color RGB555, delay
        dw $1D4C : db $10 ; color RGB555, delay
        dw $218E : db $0F ; color RGB555, delay
        dw $21B0 : db $10 ; color RGB555, delay
        dw $218E : db $0C ; color RGB555, delay
        dw $1D4C : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EAAB ; loop/jump

PaletteAnimScript_EAC2: ;80EAC2; colors=6 delays=$0C,$0F,$10 refs=1 jump=EAC2
        dw $21B0 : db $10 ; color RGB555, delay
        dw $21B2 : db $10 ; color RGB555, delay
        dw $1D4C : db $0F ; color RGB555, delay
        dw $218E : db $10 ; color RGB555, delay
        dw $1D4C : db $0C ; color RGB555, delay
        dw $21B2 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EAC2 ; loop/jump

PaletteAnimScript_EAD9: ;80EAD9; colors=6 delays=$0C,$0F,$10 refs=1 jump=EAD9
        dw $218E : db $10 ; color RGB555, delay
        dw $21B0 : db $10 ; color RGB555, delay
        dw $21B2 : db $0F ; color RGB555, delay
        dw $1D4C : db $10 ; color RGB555, delay
        dw $21B2 : db $0C ; color RGB555, delay
        dw $21B0 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EAD9 ; loop/jump

PaletteAnimScript_EAF0: ;80EAF0; colors=6 delays=$0C,$0F,$10 refs=1 jump=EAF0
        dw $1D6C : db $10 ; color RGB555, delay
        dw $1509 : db $10 ; color RGB555, delay
        dw $1D2C : db $0F ; color RGB555, delay
        dw $1D4C : db $10 ; color RGB555, delay
        dw $1D2C : db $0C ; color RGB555, delay
        dw $1509 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EAF0 ; loop/jump

PaletteAnimScript_EB07: ;80EB07; colors=6 delays=$0C,$0F,$10 refs=1 jump=EB07
        dw $1D4C : db $10 ; color RGB555, delay
        dw $1D6C : db $10 ; color RGB555, delay
        dw $1509 : db $0F ; color RGB555, delay
        dw $1D2C : db $10 ; color RGB555, delay
        dw $1509 : db $0C ; color RGB555, delay
        dw $1D6C : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EB07 ; loop/jump

PaletteAnimScript_EB1E: ;80EB1E; colors=6 delays=$0C,$0F,$10 refs=1 jump=EB1E
        dw $1D2C : db $10 ; color RGB555, delay
        dw $1D4C : db $10 ; color RGB555, delay
        dw $1D6C : db $0F ; color RGB555, delay
        dw $1509 : db $10 ; color RGB555, delay
        dw $1D6C : db $0C ; color RGB555, delay
        dw $1D4C : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EB1E ; loop/jump

PaletteAnimScript_EB35: ;80EB35; colors=6 delays=$0C,$0F,$10 refs=1 jump=EB35
        dw $1509 : db $10 ; color RGB555, delay
        dw $1D2C : db $10 ; color RGB555, delay
        dw $1D4C : db $0F ; color RGB555, delay
        dw $1D6C : db $10 ; color RGB555, delay
        dw $1D4C : db $0C ; color RGB555, delay
        dw $1D2C : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EB35 ; loop/jump

PaletteAnimScript_EB4C: ;80EB4C; colors=4 delays=$10 refs=1 jump=EB4C
        dw $77DB : db $10 ; color RGB555, delay
        dw $7398 : db $10 ; color RGB555, delay
        dw $7398 : db $10 ; color RGB555, delay
        dw $7398 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EB4C ; loop/jump

PaletteAnimScript_EB5D: ;80EB5D; colors=4 delays=$10 refs=1 jump=EB5D
        dw $7398 : db $10 ; color RGB555, delay
        dw $7398 : db $10 ; color RGB555, delay
        dw $77DB : db $10 ; color RGB555, delay
        dw $7398 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EB5D ; loop/jump

PaletteAnimScript_EB6E: ;80EB6E; colors=4 delays=$10 refs=1 jump=EB6E
        dw $5F7D : db $10 ; color RGB555, delay
        dw $4B3B : db $10 ; color RGB555, delay
        dw $4B3B : db $10 ; color RGB555, delay
        dw $4B3B : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EB6E ; loop/jump

PaletteAnimScript_EB7F: ;80EB7F; colors=4 delays=$10 refs=1 jump=EB7F
        dw $4B3B : db $10 ; color RGB555, delay
        dw $4B3B : db $10 ; color RGB555, delay
        dw $5F7D : db $10 ; color RGB555, delay
        dw $4B3B : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EB7F ; loop/jump

PaletteAnimScript_EB90: ;80EB90; colors=4 delays=$10 refs=1 jump=EB90
        dw $3295 : db $10 ; color RGB555, delay
        dw $2E52 : db $10 ; color RGB555, delay
        dw $2E52 : db $10 ; color RGB555, delay
        dw $2E52 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EB90 ; loop/jump

PaletteAnimScript_EBA1: ;80EBA1; colors=4 delays=$10 refs=1 jump=EBA1
        dw $2E52 : db $10 ; color RGB555, delay
        dw $2E52 : db $10 ; color RGB555, delay
        dw $3295 : db $10 ; color RGB555, delay
        dw $2E52 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EBA1 ; loop/jump

PaletteAnimScript_EBB2: ;80EBB2; colors=4 delays=$10 refs=1 jump=EBB2
        dw $314A : db $10 ; color RGB555, delay
        dw $2D29 : db $10 ; color RGB555, delay
        dw $2D29 : db $10 ; color RGB555, delay
        dw $2D29 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EBB2 ; loop/jump

PaletteAnimScript_EBC3: ;80EBC3; colors=4 delays=$10 refs=1 jump=EBC3
        dw $2D29 : db $10 ; color RGB555, delay
        dw $2D29 : db $10 ; color RGB555, delay
        dw $314A : db $10 ; color RGB555, delay
        dw $2D29 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EBC3 ; loop/jump

PaletteAnimScript_EBD4: ;80EBD4; colors=4 delays=$10 refs=1 jump=EBD4
        dw $7799 : db $10 ; color RGB555, delay
        dw $6334 : db $10 ; color RGB555, delay
        dw $6334 : db $10 ; color RGB555, delay
        dw $6334 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EBD4 ; loop/jump

PaletteAnimScript_EBE5: ;80EBE5; colors=4 delays=$10 refs=1 jump=EBE5
        dw $6334 : db $10 ; color RGB555, delay
        dw $6334 : db $10 ; color RGB555, delay
        dw $77DB : db $10 ; color RGB555, delay
        dw $6334 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EBE5 ; loop/jump

PaletteAnimScript_EBF6: ;80EBF6; colors=4 delays=$10 refs=1 jump=EBF6
        dw $677E : db $10 ; color RGB555, delay
        dw $471C : db $10 ; color RGB555, delay
        dw $471C : db $10 ; color RGB555, delay
        dw $471C : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EBF6 ; loop/jump

PaletteAnimScript_EC07: ;80EC07; colors=4 delays=$10 refs=1 jump=EC07
        dw $471C : db $10 ; color RGB555, delay
        dw $471C : db $10 ; color RGB555, delay
        dw $677E : db $10 ; color RGB555, delay
        dw $471C : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EC07 ; loop/jump

PaletteAnimScript_EC18: ;80EC18; colors=4 delays=$10 refs=1 jump=EC18
        dw $5694 : db $10 ; color RGB555, delay
        dw $4E31 : db $10 ; color RGB555, delay
        dw $4E31 : db $10 ; color RGB555, delay
        dw $4E31 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EC18 ; loop/jump

PaletteAnimScript_EC29: ;80EC29; colors=4 delays=$10 refs=1 jump=EC29
        dw $4E31 : db $10 ; color RGB555, delay
        dw $4E31 : db $10 ; color RGB555, delay
        dw $5694 : db $10 ; color RGB555, delay
        dw $4E31 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EC29 ; loop/jump

PaletteAnimScript_EC3A: ;80EC3A; colors=4 delays=$10 refs=1 jump=EC3A
        dw $498C : db $10 ; color RGB555, delay
        dw $414A : db $10 ; color RGB555, delay
        dw $414A : db $10 ; color RGB555, delay
        dw $414A : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EC3A ; loop/jump

PaletteAnimScript_EC4B: ;80EC4B; colors=4 delays=$10 refs=1 jump=EC4B
        dw $414A : db $10 ; color RGB555, delay
        dw $414A : db $10 ; color RGB555, delay
        dw $498C : db $10 ; color RGB555, delay
        dw $414A : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EC4B ; loop/jump

PaletteAnimScript_EC5C: ;80EC5C; colors=4 delays=$10 refs=1 jump=EC5C
        dw $7376 : db $10 ; color RGB555, delay
        dw $6334 : db $10 ; color RGB555, delay
        dw $6334 : db $10 ; color RGB555, delay
        dw $6334 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EC5C ; loop/jump

PaletteAnimScript_EC6D: ;80EC6D; colors=4 delays=$10 refs=1 jump=EC6D
        dw $6334 : db $10 ; color RGB555, delay
        dw $6334 : db $10 ; color RGB555, delay
        dw $7376 : db $10 ; color RGB555, delay
        dw $6334 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EC6D ; loop/jump

PaletteAnimScript_EC7E: ;80EC7E; colors=4 delays=$10 refs=1 jump=EC7E
        dw $537F : db $10 ; color RGB555, delay
        dw $42FB : db $10 ; color RGB555, delay
        dw $42FB : db $10 ; color RGB555, delay
        dw $42FB : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EC7E ; loop/jump

PaletteAnimScript_EC8F: ;80EC8F; colors=4 delays=$10 refs=1 jump=EC8F
        dw $42FB : db $10 ; color RGB555, delay
        dw $42FB : db $10 ; color RGB555, delay
        dw $537F : db $10 ; color RGB555, delay
        dw $42FB : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EC8F ; loop/jump

PaletteAnimScript_ECA0: ;80ECA0; colors=4 delays=$10 refs=1 jump=ECA0
        dw $4671 : db $10 ; color RGB555, delay
        dw $3E31 : db $10 ; color RGB555, delay
        dw $3E31 : db $10 ; color RGB555, delay
        dw $3E31 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_ECA0 ; loop/jump

PaletteAnimScript_ECB1: ;80ECB1; colors=4 delays=$10 refs=1 jump=ECB1
        dw $3E31 : db $10 ; color RGB555, delay
        dw $3E31 : db $10 ; color RGB555, delay
        dw $4671 : db $10 ; color RGB555, delay
        dw $3E31 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_ECB1 ; loop/jump

PaletteAnimScript_ECC2: ;80ECC2; colors=4 delays=$10 refs=1 jump=ECC2
        dw $316A : db $10 ; color RGB555, delay
        dw $2D49 : db $10 ; color RGB555, delay
        dw $2D49 : db $10 ; color RGB555, delay
        dw $2D49 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_ECC2 ; loop/jump

PaletteAnimScript_ECD3: ;80ECD3; colors=4 delays=$10 refs=1 jump=ECC2
        dw $2D49 : db $10 ; color RGB555, delay
        dw $2D49 : db $10 ; color RGB555, delay
        dw $316A : db $10 ; color RGB555, delay
        dw $2D49 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_ECC2 ; loop/jump

PaletteAnimScript_ECE4: ;80ECE4; colors=4 delays=$10 refs=1 jump=ECE4
        dw $779B : db $10 ; color RGB555, delay
        dw $7377 : db $10 ; color RGB555, delay
        dw $7377 : db $10 ; color RGB555, delay
        dw $7377 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_ECE4 ; loop/jump

PaletteAnimScript_ECF5: ;80ECF5; colors=4 delays=$10 refs=1 jump=ECF5
        dw $7377 : db $10 ; color RGB555, delay
        dw $7377 : db $10 ; color RGB555, delay
        dw $779B : db $10 ; color RGB555, delay
        dw $7377 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_ECF5 ; loop/jump

PaletteAnimScript_ED06: ;80ED06; colors=4 delays=$10 refs=1 jump=ED06
        dw $6F59 : db $10 ; color RGB555, delay
        dw $6B37 : db $10 ; color RGB555, delay
        dw $6B37 : db $10 ; color RGB555, delay
        dw $6B37 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_ED06 ; loop/jump

PaletteAnimScript_ED17: ;80ED17; colors=4 delays=$10 refs=1 jump=ED17
        dw $6B37 : db $10 ; color RGB555, delay
        dw $6B37 : db $10 ; color RGB555, delay
        dw $6F59 : db $10 ; color RGB555, delay
        dw $6B37 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_ED17 ; loop/jump

PaletteAnimScript_ED28: ;80ED28; colors=4 delays=$10 refs=1 jump=ED28
        dw $5AB5 : db $10 ; color RGB555, delay
        dw $5273 : db $10 ; color RGB555, delay
        dw $5273 : db $10 ; color RGB555, delay
        dw $5273 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_ED28 ; loop/jump

PaletteAnimScript_ED39: ;80ED39; colors=4 delays=$10 refs=1 jump=ED39
        dw $5273 : db $10 ; color RGB555, delay
        dw $5273 : db $10 ; color RGB555, delay
        dw $5AB5 : db $10 ; color RGB555, delay
        dw $5273 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_ED39 ; loop/jump

PaletteAnimScript_ED4A: ;80ED4A; colors=4 delays=$10 refs=1 jump=ED4A
        dw $4DEE : db $10 ; color RGB555, delay
        dw $45CE : db $10 ; color RGB555, delay
        dw $45CE : db $10 ; color RGB555, delay
        dw $45CE : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_ED4A ; loop/jump

PaletteAnimScript_ED5B: ;80ED5B; colors=4 delays=$10 refs=1 jump=ED5B
        dw $45CE : db $10 ; color RGB555, delay
        dw $45CE : db $10 ; color RGB555, delay
        dw $4DEE : db $10 ; color RGB555, delay
        dw $45CE : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_ED5B ; loop/jump

PaletteAnimScript_ED6C: ;80ED6C; colors=6 delays=$0C refs=1 jump=ED6C
        dw $5185 : db $0C ; color RGB555, delay
        dw $61E8 : db $0C ; color RGB555, delay
        dw $6E4C : db $0C ; color RGB555, delay
        dw $7F0C : db $0C ; color RGB555, delay
        dw $6E4C : db $0C ; color RGB555, delay
        dw $61E8 : db $0C ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_ED6C ; loop/jump

PaletteAnimScript_ED83: ;80ED83; colors=6 delays=$0C refs=1 jump=ED83
        dw $69E7 : db $0C ; color RGB555, delay
        dw $7988 : db $0C ; color RGB555, delay
        dw $69E7 : db $0C ; color RGB555, delay
        dw $6167 : db $0C ; color RGB555, delay
        dw $69E7 : db $0C ; color RGB555, delay
        dw $7988 : db $0C ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_ED83 ; loop/jump

PaletteAnimScript_ED9A: ;80ED9A; colors=4 delays=$0F refs=1 jump=ED9A
        dw $7E2C : db $0F ; color RGB555, delay
        dw $7F97 : db $0F ; color RGB555, delay
        dw $7F53 : db $0F ; color RGB555, delay
        dw $7EE7 : db $0F ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_ED9A ; loop/jump

PaletteAnimScript_EDAB: ;80EDAB; colors=4 delays=$0F refs=1 jump=EDAB
        dw $7EEF : db $0F ; color RGB555, delay
        dw $7E2C : db $0F ; color RGB555, delay
        dw $7F97 : db $0F ; color RGB555, delay
        dw $7F53 : db $0F ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EDAB ; loop/jump

PaletteAnimScript_EDBC: ;80EDBC; colors=4 delays=$0F refs=1 jump=EDBC
        dw $7F53 : db $0F ; color RGB555, delay
        dw $7EEF : db $0F ; color RGB555, delay
        dw $7E2C : db $0F ; color RGB555, delay
        dw $7F97 : db $0F ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EDBC ; loop/jump

PaletteAnimScript_EDCD: ;80EDCD; colors=4 delays=$0F refs=1 jump=EDCD
        dw $7F97 : db $0F ; color RGB555, delay
        dw $7F53 : db $0F ; color RGB555, delay
        dw $7EE7 : db $0F ; color RGB555, delay
        dw $7E2C : db $0F ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EDCD ; loop/jump

PaletteAnimScript_EDDE: ;80EDDE; colors=3 delays=$0F refs=1 jump=EDDE
        dw $0070 : db $0F ; color RGB555, delay
        dw $0E5F : db $0F ; color RGB555, delay
        dw $03FF : db $0F ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EDDE ; loop/jump

PaletteAnimScript_EDEC: ;80EDEC; colors=3 delays=$0F refs=1 jump=EDEC
        dw $0E5F : db $0F ; color RGB555, delay
        dw $0070 : db $0F ; color RGB555, delay
        dw $03FF : db $0F ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EDEC ; loop/jump

PaletteAnimScript_EDFA: ;80EDFA; colors=3 delays=$0F refs=1 jump=EDFA
        dw $03FF : db $0F ; color RGB555, delay
        dw $0E5F : db $0F ; color RGB555, delay
        dw $0070 : db $0F ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EDFA ; loop/jump

PaletteAnimScript_EE08: ;80EE08; colors=3 delays=$08 refs=1 jump=EE08
        dw $000C : db $08 ; color RGB555, delay
        dw $000A : db $08 ; color RGB555, delay
        dw $0009 : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EE08 ; loop/jump

PaletteAnimScript_EE16: ;80EE16; colors=3 delays=$08 refs=1 jump=EE16
        dw $000A : db $08 ; color RGB555, delay
        dw $00D8 : db $08 ; color RGB555, delay
        dw $027E : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EE16 ; loop/jump

PaletteAnimScript_EE24: ;80EE24; colors=3 delays=$08 refs=1 jump=EE24
        dw $017F : db $08 ; color RGB555, delay
        dw $029F : db $08 ; color RGB555, delay
        dw $00D2 : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EE24 ; loop/jump

PaletteAnimScript_EE32: ;80EE32; colors=3 delays=$08 refs=1 jump=EE32
        dw $031F : db $08 ; color RGB555, delay
        dw $035F : db $08 ; color RGB555, delay
        dw $03FF : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EE32 ; loop/jump

PaletteAnimScript_EE40: ;80EE40; colors=3 delays=$10 refs=1 jump=EE40
        dw $2279 : db $10 ; color RGB555, delay
        dw $229B : db $10 ; color RGB555, delay
        dw $22DC : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EE40 ; loop/jump

PaletteAnimScript_EE4E: ;80EE4E; colors=3 delays=$10 refs=1 jump=EE4E
        dw $0854 : db $10 ; color RGB555, delay
        dw $08DE : db $10 ; color RGB555, delay
        dw $08DC : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EE4E ; loop/jump

PaletteAnimScript_EE5C: ;80EE5C; colors=3 delays=$10 refs=1 jump=EE5C
        dw $089D : db $10 ; color RGB555, delay
        dw $08DE : db $10 ; color RGB555, delay
        dw $091F : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EE5C ; loop/jump

PaletteAnimScript_EE6A: ;80EE6A; colors=3 delays=$10 refs=1 jump=EE6A
        dw $08DF : db $10 ; color RGB555, delay
        dw $08DF : db $10 ; color RGB555, delay
        dw $0A1F : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EE6A ; loop/jump

PaletteAnimScript_EE78: ;80EE78; colors=3 delays=$10 refs=1 jump=EE78
        dw $08DF : db $10 ; color RGB555, delay
        dw $0A3F : db $10 ; color RGB555, delay
        dw $0A9F : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EE78 ; loop/jump

PaletteAnimScript_EE86: ;80EE86; colors=3 delays=$10 refs=1 jump=EE86
        dw $029F : db $10 ; color RGB555, delay
        dw $029F : db $10 ; color RGB555, delay
        dw $031F : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EE86 ; loop/jump

PaletteAnimScript_EE94: ;80EE94; colors=3 delays=$10 refs=1 jump=EE94
        dw $035F : db $10 ; color RGB555, delay
        dw $03DF : db $10 ; color RGB555, delay
        dw $03FF : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EE94 ; loop/jump

PaletteAnimScript_EEA2: ;80EEA2; colors=4 delays=$0C refs=1 jump=EEA2
        dw $0A3C : db $0C ; color RGB555, delay
        dw $00DB : db $0C ; color RGB555, delay
        dw $00DF : db $0C ; color RGB555, delay
        dw $00DF : db $0C ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EEA2 ; loop/jump

PaletteAnimScript_EEB3: ;80EEB3; colors=4 delays=$0C refs=1 jump=EEB3
        dw $09B3 : db $0C ; color RGB555, delay
        dw $11FF : db $0C ; color RGB555, delay
        dw $0A5F : db $0C ; color RGB555, delay
        dw $125F : db $0C ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EEB3 ; loop/jump

PaletteAnimScript_EEC4: ;80EEC4; colors=4 delays=$0C refs=1 jump=EEC4
        dw $0992 : db $0C ; color RGB555, delay
        dw $0A15 : db $0C ; color RGB555, delay
        dw $023A : db $0C ; color RGB555, delay
        dw $133F : db $0C ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EEC4 ; loop/jump

PaletteAnimScript_EED5: ;80EED5; colors=6 delays=$10 refs=1 jump=EED5
        dw $2A98 : db $10 ; color RGB555, delay
        dw $433D : db $10 ; color RGB555, delay
        dw $2A98 : db $10 ; color RGB555, delay
        dw $4F7F : db $10 ; color RGB555, delay
        dw $4F5F : db $10 ; color RGB555, delay
        dw $433D : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EED5 ; loop/jump

PaletteAnimScript_EEEC: ;80EEEC; colors=7 delays=$10 refs=1 jump=EEEC
        dw $42FA : db $10 ; color RGB555, delay
        dw $2A98 : db $10 ; color RGB555, delay
        dw $42FA : db $10 ; color RGB555, delay
        dw $2ADB : db $10 ; color RGB555, delay
        dw $371C : db $10 ; color RGB555, delay
        dw $2A98 : db $10 ; color RGB555, delay
        dw $2ADB : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EEEC ; loop/jump

PaletteAnimScript_EF06: ;80EF06; colors=2 delays=$08 refs=1 jump=EF06
        dw $0049 : db $08 ; color RGB555, delay
        dw $004C : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EF06 ; loop/jump

PaletteAnimScript_EF11: ;80EF11; colors=2 delays=$08 refs=1 jump=EF11
        dw $0037 : db $08 ; color RGB555, delay
        dw $013D : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EF11 ; loop/jump

PaletteAnimScript_EF1C: ;80EF1C; colors=2 delays=$08 refs=1 jump=EF1C
        dw $025F : db $08 ; color RGB555, delay
        dw $02DF : db $08 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_EF1C ; loop/jump

                       ;these are required for asar or it adds random stuff at the end
                       db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                       db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                       db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                       db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                       db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
