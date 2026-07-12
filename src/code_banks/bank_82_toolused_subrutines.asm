;00:nothing, 01:sickle, 02:hoe, 03:hammer, 04:axe
;05:yellow seed, 06:red seed, 07:brown seed, 08:white seed
;09:cow medicine, 0A:cow icon, 0B:bell,
;0C:grass seed, 0D:paint, 0E:milker,0F:brush, 10:watering,
;11:gold sickle, 12:gold hoe, 13:gold hammer, 14:gold axe, 15:sprinkler,
;16:bean, 17:gem, 18:blue feather, 19:chicken feed, 20:cow feed


;;;;;;;;
ToolUsedNoAction: ;82931E
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action

        RTS

;;;;;;;;
ToolUsedSickle: ;829328      ;PASS16: cuts weeds/grass, can trigger summer frog event, costs -2 stamina
        %Set16bit(!MX)
        JSR.W ToolAction_CheckTargetTileSingle
        BNE .tilecuttable
        JMP.W .return

    .tilecuttable:
        %Set8bit(!M)
        LDA.L !season
        CMP.B #$03
        BNE .notwinter
        JMP.W .return

    .notwinter:
        LDA.B !tilemap_to_load
        CMP.B #$04
        BCC .inthefarm
        %Set16bit(!M)
        CPX.W #$0035
        BEQ .ToolUsedSickle_Branch_829352
        LDA.W #$00DD
        JMP.W .cutother

    .ToolUsedSickle_Branch_829352:
        %Set16bit(!M)
        LDA.W #$00DE
        JMP.W .cutother

    .inthefarm:
        %Set16bit(!M)
        CPX.W #$0003
        BEQ .cutweed
        CPX.W #$0079
        BEQ .cutgrass
        LDA.W #$0017
        JMP.W .cutother

    .cutweed:
        %Set16bit(!M)
        LDA.W #$000E
        JMP.W .cutother

    .cutgrass:
        %Set16bit(!M)
        LDA.W #$0001
        JSL.L AddGrass
        %Set16bit(!M)
        LDA.W $092E
        DEC A
        STA.W $092E
        %Set16bit(!M)
        LDA.W #$0052
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM                    ;TODO spawn object effect?
        %Set16bit(!M)
        LDA.W !tile_in_front_X
        STA.W $0980
        LDA.W !tile_in_front_Y
        STA.W $0982
        %Set16bit(!MX)
        LDA.W #$00C1
        STA.W $097A
        LDA.W #$0000
        STA.W $097E
        %Set8bit(!M)
        LDA.B #$03
        STA.W $0974
        LDA.B #$00
        STA.W $0975
        LDA.B #$00
        STA.W $0976
        JSL.L MapTilePatchRuntime_AllocateVisualEffectObjectSlot
        BRA .frogcheck

    .cutother:
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM
        %Set16bit(!M)
        LDA.W !tile_in_front_X
        STA.W $0980
        LDA.W !tile_in_front_Y
        STA.W $0982
        %Set16bit(!MX)
        LDA.W #$00B7
        STA.W $097A
        LDA.W #$0000
        STA.W $097E
        %Set8bit(!M)
        LDA.B #$03
        STA.W $0974
        LDA.B #$00
        STA.W $0975
        LDA.B #$00
        STA.W $0976
        JSL.L MapTilePatchRuntime_AllocateVisualEffectObjectSlot

    .frogcheck:
        %Set8bit(!M)
        LDA.L !season
        CMP.B #$01
        BNE .return                          ;its summer
        %Set16bit(!M)
        LDA.L $7F1F60
        AND.W #$0008                         ;FLAG60
        BNE .return
        LDA.L $7F1F5A
        AND.W #$2000                         ;FLAG5A
        BNE .return
        %Set8bit(!M)
        LDA.B #$10
        JSL.L RNG_GetRange0ToAExclusiveStyle
        BNE .return
        %Set16bit(!MX)
        LDA.W #$0012
        LDX.W #$0000
        LDY.W #$0032
        JSL.L EventScript_LoadScriptPointerForFacingTile                    ;TODO Spawn frog subrutine?
        %Set16bit(!MX)
        LDA.W #$0002
        JSL.L Social_AddPlayerHappiness             ; :3
        %Set16bit(!M)
        LDA.L $7F1F5A
        ORA.W #$2000                         ;FLAG5A
        STA.L $7F1F5A

    .return:
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set8bit(!M)
        LDA.B #$FE
        JSL.L Stamina_ApplyDeltaAndFatigueState

        RTS

;;;;;;;;
ToolUsedHoe: ;829460         ;PASS16: tills soil, can trigger mole/coin/money bag/power berry checks, costs -2 stamina
        %Set16bit(!MX)
        JSR.W ToolAction_CheckTargetTileSingle
        BNE .molecheck
        JMP.W .return

    .molecheck:
        %Set16bit(!M)                        ;mole check?
        LDA.W #$0017
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM
        %Set8bit(!M)
        LDA.L !season
        CMP.B #$02
        BCS .coincheck                       ;not winter
        %Set16bit(!M)
        LDA.L $7F1F60
        AND.W #$0008                         ;FLAG60
        BNE .coincheck
        LDA.L $7F1F5A
        AND.W #$1000                         ;FLAG5A
        BNE .coincheck
        %Set8bit(!M)
        LDA.B #$20
        JSL.L RNG_GetRange0ToAExclusiveStyle
        BNE .coincheck
        %Set16bit(!MX)
        LDA.W #$0011
        LDX.W #$0000
        LDY.W #$0030
        JSL.L EventScript_LoadScriptPointerForFacingTile
        %Set8bit(!M)
        STZ.W $093A
        %Set16bit(!M)
        LDA.L $7F1F5A
        ORA.W #$1000                         ;FLAG5A
        STA.L $7F1F5A
        JMP.W .return

    .coincheck:
        %Set16bit(!MX)
        LDA.L $7F1F60
        AND.W #$0008                         ;FLAG60
        BNE .powerberry1check
        LDA.L $7F1F5C
        AND.W #$0200                         ;FLAG5C
        BNE .powerberry1check
        %Set8bit(!M)
        LDA.B #$10
        JSL.L RNG_GetRange0ToAExclusiveStyle
        BNE .moneybagcheck
        %Set16bit(!MX)
        LDA.L $7F1F5C
        ORA.W #$0200                         ;FLAG5C
        STA.L $7F1F5C
        LDA.W #$000F
        LDX.W #$0000
        LDY.W #$003A
        JSL.L EventScript_LoadScriptPointerForFacingTile
        %Set16bit(!M)
        LDA.W #$0001
        STA.B $72
        %Set8bit(!M)
        LDA.B #$00
        STA.B $74
        JSL.L AddMoney
        JMP.W .return

    .moneybagcheck:
        %Set8bit(!M)
        LDA.B #$10
        JSL.L RNG_GetRange0ToAExclusiveStyle
        BNE .powerberry1check
        %Set16bit(!MX)
        LDA.L $7F1F5C
        ORA.W #$0200                         ;FLAG5C
        STA.L $7F1F5C
        %Set16bit(!MX)
        LDA.W #$000F
        LDX.W #$0000
        LDY.W #$003B
        JSL.L EventScript_LoadScriptPointerForFacingTile
        %Set16bit(!M)
        LDA.W #$0005
        STA.B $72
        %Set8bit(!M)
        LDA.B #$00
        STA.B $74
        JSL.L AddMoney
        BRA .return

    .powerberry1check:
        %Set8bit(!M)
        LDA.B #$40
        JSL.L RNG_GetRange0ToAExclusiveStyle
        BNE .return
        %Set16bit(!MX)
        LDA.L $7F1F60
        AND.W #$0008                         ;FLAG60
        BNE .return
        LDA.L $7F1F5C
        AND.W #$0100                         ;FLAG5C
        BNE .return
        LDA.L $7F1F5C
        ORA.W #$0100                         ;FLAG5C
        STA.L $7F1F5C
        LDA.L !player_house_and_event_flags
        AND.W #$0800                         ;FLAG64
        BNE .powerberry2check
        LDA.L !player_house_and_event_flags
        ORA.W #$0800                         ;FLAG64
        STA.L !player_house_and_event_flags
        BRA .powerberryspawn

    .powerberry2check:
        %Set16bit(!MX)
        LDA.L !player_house_and_event_flags
        AND.W #$1000                         ;FLAG64
        BNE .return
        LDA.L !player_house_and_event_flags
        ORA.W #$1000                         ;FLAG64
        STA.L !player_house_and_event_flags

    .powerberryspawn:
        %Set16bit(!MX)
        LDA.W #$0010
        LDX.W #$0000
        LDY.W #$001F
        JSL.L EventScript_LoadScriptPointerForFacingTile
        BRA .return

    .return:
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set8bit(!M)
        LDA.B #$FE
        JSL.L Stamina_ApplyDeltaAndFatigueState

        RTS

;;;;;;;;
ToolUsedHammer: ;8295C0      ;PASS16: breaks stones; big rocks need 6 hit-count steps; can trigger fork-statue event
        %Set16bit(!MX)
        JSR.W ToolAction_CheckTargetTileSingle
        BNE .ToolUsedHammer_Branch_8295CA
        JMP.W .forkstatuecheck

    .ToolUsedHammer_Branch_8295CA:
        CPX.W #$0006
        BEQ .smallstone
        CPX.W #$0004
        BNE .bigstone
        %Set8bit(!M)
        LDA.B !tilemap_to_load
        CMP.B #$04
        BCC .infarm                          ;up to winter farm
        LDA.B !tilemap_to_load
        CMP.B #$29
        BCS .incaves                         ;mountain cave+ElfTunnel
        %Set16bit(!M)
        LDA.W #$00DD
        BRA .ToolUsedHammer_Branch_8295F5

    .incaves:
        %Set16bit(!M)
        LDA.W #$00E3
        BRA .ToolUsedHammer_Branch_8295F5

    .infarm:
        %Set16bit(!M)
        LDA.W #$000E

    .ToolUsedHammer_Branch_8295F5:
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM
        %Set16bit(!M)
        LDA.W !tile_in_front_X
        STA.W $0980
        LDA.W !tile_in_front_Y
        STA.W $0982
        %Set16bit(!MX)
        LDA.W #$00C8
        STA.W $097A
        LDA.W #$0000
        STA.W $097E
        %Set8bit(!M)
        LDA.B #$03
        STA.W $0974
        LDA.B #$00
        STA.W $0975
        LDA.B #$00
        STA.W $0976
        JSL.L MapTilePatchRuntime_AllocateVisualEffectObjectSlot
        JMP.W .return

    .smallstone:
        %Set16bit(!M)
        LDA.W #$000E
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM                    ;TODO
        JMP.W .return

    .bigstone:
        %Set8bit(!M)                         ;count number of hits
        LDA.W $096D
        INC A
        STA.W $096D
        CMP.B #$06
        BEQ .findstonecorner
        JMP.W .rockhiteffect

    .findstonecorner:
        STZ.W $096D
        %Set16bit(!M)
        LDA.W !tile_in_front_X
        SEC
        SBC.W #$0010
        STA.W !tile_in_front_X
        LDA.W !tile_in_front_Y
        SEC
        SBC.W #$0010
        STA.W !tile_in_front_Y
        CPX.W #$0010
        BEQ .cornerfound
        LDA.W !tile_in_front_X
        CLC
        ADC.W #$0010
        STA.W !tile_in_front_X
        CPX.W #$000F
        BEQ .cornerfound
        LDA.W !tile_in_front_X
        SEC
        SBC.W #$0010
        STA.W !tile_in_front_X
        LDA.W !tile_in_front_Y
        CLC
        ADC.W #$0010
        STA.W !tile_in_front_Y
        CPX.W #$000E
        BEQ .cornerfound
        LDA.W !tile_in_front_X
        CLC
        ADC.W #$0010
        STA.W !tile_in_front_X

    .cornerfound:
        %Set8bit(!M)
        LDA.B !tilemap_to_load
        CMP.B #$04
        BCC .ToolUsedHammer_Branch_8296B4
        %Set16bit(!M)
        LDA.W #$00DF
        BRA .rockbreaks

    .ToolUsedHammer_Branch_8296B4:
        %Set16bit(!M)
        LDA.W #$000D

    .rockbreaks:
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM
        %Set16bit(!M)
        LDA.W !tile_in_front_X
        CLC
        ADC.W #$0008
        STA.W $0980
        LDA.W !tile_in_front_Y
        CLC
        ADC.W #$0008
        STA.W $0982
        %Set16bit(!MX)
        LDA.W #$00C9
        STA.W $097A
        LDA.W #$0000
        STA.W $097E
        %Set8bit(!M)
        LDA.B #$03
        STA.W $0974
        LDA.B #$00
        STA.W $0975
        LDA.B #$00
        STA.W $0976
        JSL.L MapTilePatchRuntime_AllocateVisualEffectObjectSlot                    ;TODO
        BRA .return

    .rockhiteffect:
        %Set16bit(!M)
        LDA.W !tile_in_front_X
        STA.W $0980
        LDA.W !tile_in_front_Y
        STA.W $0982
        %Set16bit(!MX)
        LDA.W #$00CB
        STA.W $097A
        LDA.W #$0000
        STA.W $097E
        %Set8bit(!M)
        LDA.B #$03
        STA.W $0974
        LDA.B #$00
        STA.W $0975
        LDA.B #$00
        STA.W $0976
        JSL.L MapTilePatchRuntime_AllocateVisualEffectObjectSlot

    .return:
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set8bit(!M)
        LDA.B #$FE
        JSL.L Stamina_ApplyDeltaAndFatigueState

        RTS

    .forkstatuecheck:
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B !tilemap_to_load
        CMP.B #$0C
        BCC .return
        CMP.B #$10
        BCS .return
        CPX.W #$00F8
        BNE .return
        %Set16bit(!MX)
        LDA.L $7F1F5C
        AND.W #$0080                         ;FLAG5C
        BNE .return
        %Set16bit(!M)
        LDA.W #$0015
        LDX.W #$0000
        LDY.W #$0016
        JSL.L EventScript_LoadScriptPointerShort                    ;TODO
        %Set8bit(!M)
        LDA.B #$04
        JSL.L RNG_GetRange0ToAExclusiveStyle
        BNE .return
        %Set16bit(!MX)
        LDA.L !player_house_and_event_flags
        AND.W #$0200                         ;FLAG64
        BNE .return
        LDA.L !player_house_and_event_flags
        ORA.W #$0200                         ;FLAG64
        STA.L !player_house_and_event_flags
        %Set16bit(!MX)
        LDA.B !player_pos_X
        CLC
        ADC.W #$0010
        STA.W !tile_in_front_X
        LDA.B !player_pos_Y
        SEC
        SBC.W #$0010
        STA.W !tile_in_front_Y
        LDA.W #$0010
        LDX.W #$0000
        LDY.W #$001F
        JSL.L EventScript_LoadScriptPointerForFacingTile                    ;TODO
        %Set16bit(!MX)
        LDA.L $7F1F5C
        ORA.W #$0080                         ;FLAG5C
        STA.L $7F1F5C
        JMP.W .return


;;;;;;;;
ToolUsedAxe: ;8297BD         ;PASS16: chops logs/stumps; normal axe uses 6 hit-count steps and adds wood
        %Set16bit(!MX)
        JSR.W ToolAction_CheckTargetTileSingle
        BNE .cuttinglog
        JMP.W .goldenaxeeventcheck

    .cuttinglog:
        %Set8bit(!M)
        LDA.W $096D
        INC A
        STA.W $096D
        CMP.B #$06
        BEQ .findcornerTL
        JMP.W .ToolUsedAxe_Branch_829918

    .findcornerTL:
        STZ.W $096D
        %Set16bit(!M)
        LDA.W !tile_in_front_X
        SEC
        SBC.W #$0010
        STA.W !tile_in_front_X
        LDA.W !tile_in_front_Y
        SEC
        SBC.W #$0010
        STA.W !tile_in_front_Y
        CPX.W #$000C
        BEQ .berrycheck
        CPX.W #$0014
        BNE .findcornerDL
        JMP.W .ToolUsedAxe_Branch_8298BC

    .findcornerDL:
        LDA.W !tile_in_front_X
        CLC
        ADC.W #$0010
        STA.W !tile_in_front_X
        CPX.W #$000B
        BEQ .berrycheck
        CPX.W #$0013
        BNE .findcornerTR
        JMP.W .ToolUsedAxe_Branch_8298BC

    .findcornerTR:
        LDA.W !tile_in_front_X
        SEC
        SBC.W #$0010
        STA.W !tile_in_front_X
        LDA.W !tile_in_front_Y
        CLC
        ADC.W #$0010
        STA.W !tile_in_front_Y
        CPX.W #$000A
        BEQ .berrycheck
        CPX.W #$0012
        BNE .findcornerDR
        JMP.W .ToolUsedAxe_Branch_8298BC

    .findcornerDR:
        LDA.W !tile_in_front_X
        CLC
        ADC.W #$0010
        STA.W !tile_in_front_X
        CPX.W #$0009
        BEQ .berrycheck
        CPX.W #$0011
        BEQ .ToolUsedAxe_Branch_8298BC

    .berrycheck:
        %Set8bit(!M)
        LDA.B !tilemap_to_load
        CMP.B #$04
        BCC .ToolUsedAxe_Branch_8298C3                     ;ignore if you are on the farm
        %Set16bit(!M)
        LDA.L $7F1F60
        AND.W #$0008                         ;FLAG60
        BNE .ToolUsedAxe_Branch_8298B5
        %Set8bit(!M)
        LDA.B #$10
        JSL.L RNG_GetRange0ToAExclusiveStyle
        BNE .ToolUsedAxe_Branch_8298B5
        %Set16bit(!MX)
        LDA.L !player_house_and_event_flags
        AND.W #$0400                         ;FLAG64
        BNE .ToolUsedAxe_Branch_8298B5
        LDA.L !player_house_and_event_flags
        ORA.W #$0400                         ;FLAG64
        STA.L !player_house_and_event_flags
        %Set16bit(!MX)
        LDA.W !tile_in_front_X
        CLC
        ADC.W #$0008
        STA.W !tile_in_front_X
        LDA.W !tile_in_front_Y
        CLC
        ADC.W #$0008
        STA.W !tile_in_front_Y
        LDA.W #$0010
        LDX.W #$0000
        LDY.W #$001F
        JSL.L EventScript_LoadScriptPointerForFacingTile
        %Set16bit(!MX)
        LDA.W !tile_in_front_X
        SEC
        SBC.W #$0008
        STA.W !tile_in_front_X
        LDA.W !tile_in_front_Y
        SEC
        SBC.W #$0008
        STA.W !tile_in_front_Y

    .ToolUsedAxe_Branch_8298B5:
        %Set16bit(!MX)
        LDA.W #$00DF
        BRA .treebroken

    .ToolUsedAxe_Branch_8298BC:
        %Set16bit(!MX)
        LDA.W #$00E0
        BRA .treebroken

    .ToolUsedAxe_Branch_8298C3:
        %Set16bit(!MX)
        LDA.W #$000D

    .treebroken:
        %Set16bit(!MX)
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM
        %Set16bit(!M)
        LDA.W !tile_in_front_X
        CLC
        ADC.W #$0008
        STA.W $0980
        LDA.W !tile_in_front_Y
        CLC
        ADC.W #$0008
        STA.W $0982
        %Set16bit(!MX)
        LDA.W #$00B8
        STA.W $097A
        LDA.W #$0000
        STA.W $097E
        %Set8bit(!M)
        LDA.B #$03
        STA.W $0974
        LDA.B #$00
        STA.W $0975
        LDA.B #$00
        STA.W $0976
        JSL.L MapTilePatchRuntime_AllocateVisualEffectObjectSlot
        %Set16bit(!M)
        LDA.W #$0006
        JSL.L AddWood
        BRA .return

    .ToolUsedAxe_Branch_829918:
        %Set16bit(!M)
        LDA.W !tile_in_front_X
        STA.W $0980
        LDA.W !tile_in_front_Y
        STA.W $0982
        %Set16bit(!MX)
        LDA.W #$00CB
        STA.W $097A
        LDA.W #$0000
        STA.W $097E
        %Set8bit(!M)
        LDA.B #$03
        STA.W $0974
        LDA.B #$00
        STA.W $0975
        LDA.B #$00
        STA.W $0976
        JSL.L MapTilePatchRuntime_AllocateVisualEffectObjectSlot
        BRA .return

    .goldenaxeeventcheck:
        %Set8bit(!M)
        LDA.B !tilemap_to_load
        CMP.B #$10
        BCC .return
        CMP.B #$14
        BCS .return
        CPX.W #$00F4
        BNE .return
        %Set16bit(!MX)
        LDA.W $0196
        AND.W #$001A
        BNE .return
        LDA.L $7F1F6A
        AND.W #$0020                         ;FLAG6A
        BNE .return
        LDA.L $7F1F6A
        ORA.W #$0020                         ;FLAG6A
        STA.L $7F1F6A
        %Set16bit(!MX)
        LDA.W #$0000
        LDX.W #$0017
        LDY.W #$0000
        JSL.L EventScript_LoadScriptPointerLong

    .return:
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set8bit(!M)
        LDA.B #$FE
        JSL.L Stamina_ApplyDeltaAndFatigueState

        RTS

;;;;;;;;
ToolUsedCornSeeds: ;82A9999  ;PASS16: plants corn 3x3 pattern in summer, decrements seed count after 9 steps
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$00
        XBA
        LDA.W $096B
        JSR.W ToolAction_CheckTargetTileSquare
        BNE .ToolUsedCornSeeds_Branch_8299AB
        JMP.W .planting

    .ToolUsedCornSeeds_Branch_8299AB:
        %Set16bit(!MX)
        LDX.W #$0019
        %Set8bit(!M)
        LDA.L !season
        CMP.B #$01
        BEQ .ToolUsedCornSeeds_Branch_8299BD
        LDX.W #$00EB

    .ToolUsedCornSeeds_Branch_8299BD:
        %Set16bit(!M)
        TXA
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM

    .planting:
        %Set8bit(!M)
        LDA.W $096B
        INC A
        STA.W $096B
        CMP.B #$09
        BNE .return
        STZ.W $096B
        %Set8bit(!M)
        LDA.W !seeds_corn_N
        DEC A
        STA.W !seeds_corn_N
        BNE .endplanting
        STZ.W !tool_selected

    .endplanting:
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set8bit(!M)
        LDA.B #$FF
        JSL.L Stamina_ApplyDeltaAndFatigueState

    .return: RTS

;;;;;;;;
ToolUsedTomatoSeeds: ;8299F8 ;PASS16: plants tomato 3x3 pattern in summer, decrements seed count after 9 steps
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$00
        XBA
        LDA.W $096B
        JSR.W ToolAction_CheckTargetTileSquare
        BNE .ToolUsedTomatoSeeds_Branch_829A0A
        JMP.W .planting

    .ToolUsedTomatoSeeds_Branch_829A0A:
        %Set16bit(!MX)
        LDX.W #$001A
        %Set8bit(!M)
        LDA.L !season
        CMP.B #$01
        BEQ .ToolUsedTomatoSeeds_Branch_829A1C
        LDX.W #$00EB

    .ToolUsedTomatoSeeds_Branch_829A1C:
        %Set16bit(!M)
        TXA
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM

    .planting:
        %Set8bit(!M)
        LDA.W $096B
        INC A
        STA.W $096B
        CMP.B #$09
        BNE .ToolUsedTomatoSeeds_Branch_829A56
        STZ.W $096B
        %Set8bit(!M)
        LDA.W !seeds_tomato_N
        DEC A
        STA.W !seeds_tomato_N
        BNE .endplanting
        STZ.W !tool_selected

    .endplanting:
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set8bit(!M)
        LDA.B #$FF
        JSL.L Stamina_ApplyDeltaAndFatigueState

    .ToolUsedTomatoSeeds_Branch_829A56: RTS

;;;;;;;;
ToolUsedPotatoSeeds: ;829A57 ;PASS16: plants potato 3x3 pattern in spring, decrements seed count after 9 steps
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$00
        XBA
        LDA.W $096B
        JSR.W ToolAction_CheckTargetTileSquare
        BNE .ToolUsedPotatoSeeds_Branch_829A69
        JMP.W .planting

    .ToolUsedPotatoSeeds_Branch_829A69:
        %Set16bit(!MX)
        LDX.W #$001B
        %Set8bit(!M)
        LDA.L !season
        BEQ .ToolUsedPotatoSeeds_Branch_829A79
        LDX.W #$00EB

    .ToolUsedPotatoSeeds_Branch_829A79:
        %Set16bit(!M)
        TXA
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM

    .planting:
        %Set8bit(!M)
        LDA.W $096B
        INC A
        STA.W $096B
        CMP.B #$09
        BNE .return
        STZ.W $096B
        %Set8bit(!M)
        LDA.W !seeds_potato_N
        DEC A
        STA.W !seeds_potato_N
        BNE .endplanting
        STZ.W !tool_selected

    .endplanting:
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set8bit(!M)
        LDA.B #$FF
        JSL.L Stamina_ApplyDeltaAndFatigueState

    .return: RTS

;;;;;;;;
ToolUsedTurnipSeeds: ;829AB4 ;PASS16: plants turnip 3x3 pattern in spring, decrements seed count after 9 steps
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$00
        XBA
        LDA.W $096B
        JSR.W ToolAction_CheckTargetTileSquare
        BNE .ToolUsedTurnipSeeds_Branch_829AC6
        JMP.W .planting

    .ToolUsedTurnipSeeds_Branch_829AC6:
        %Set16bit(!MX)
        LDX.W #$001C
        %Set8bit(!M)
        LDA.L !season
        BEQ .ToolUsedTurnipSeeds_Branch_829AD6
        LDX.W #$00EB

    .ToolUsedTurnipSeeds_Branch_829AD6:
        %Set16bit(!M)
        TXA
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM

    .planting:
        %Set8bit(!M)
        LDA.W $096B
        INC A
        STA.W $096B
        CMP.B #$09
        BNE .return
        STZ.W $096B
        %Set8bit(!M)
        LDA.W !seeds_turnip_N
        DEC A
        STA.W !seeds_turnip_N
        BNE .endplanting
        STZ.W !tool_selected

    .endplanting:
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set8bit(!M)
        LDA.B #$FF
        JSL.L Stamina_ApplyDeltaAndFatigueState

    .return: RTS

;;;;;;;;
ToolUsedCowMedicine: ;829B11
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set8bit(!M)
        STZ.W !tool_selected
        LDA.B #$FF
        JSL.L Stamina_ApplyDeltaAndFatigueState
        %Set16bit(!M)
        LDA.L $7F1F5A
        ORA.W #$0080                         ;FLAG5A
        STA.L $7F1F5A

        RTS

;;;;;;;;
ToolUsedMiraclePotion: ;829B31
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set8bit(!M)
        STZ.W !tool_selected
        LDA.B #$FF
        JSL.L Stamina_ApplyDeltaAndFatigueState
        %Set16bit(!M)
        LDA.L $7F1F5A
        ORA.W #$0100                         ;FLAG5A
        STA.L $7F1F5A

        RTS

;;;;;;;;
ToolUsedBell: ;829B51
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set8bit(!M)
        LDA.B #$FF
        JSL.L Stamina_ApplyDeltaAndFatigueState

        RTS

;;;;;;;;
ToolUsedGrassSeeds: ;829B61  ;PASS16: plants grass 3x3 pattern outside winter, increments planted_grass
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$00
        XBA
        LDA.W $096B
        JSR.W ToolAction_CheckTargetTileSquare
        BNE .ToolUsedGrassSeeds_Branch_829B73
        JMP.W .ToolUsedGrassSeeds_Branch_829B9D

    .ToolUsedGrassSeeds_Branch_829B73:
        %Set16bit(!MX)
        LDX.W #$00ED
        %Set8bit(!M)
        LDA.L !season
        CMP.B #$02
        BCS .ToolUsedGrassSeeds_Branch_829B90
        %Set16bit(!M)
        LDA.L !planted_grass
        INC A
        STA.L !planted_grass
        LDX.W #$001E

    .ToolUsedGrassSeeds_Branch_829B90:
        %Set16bit(!M)
        TXA
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM

    .ToolUsedGrassSeeds_Branch_829B9D:
        %Set8bit(!M)
        LDA.W $096B
        INC A
        STA.W $096B
        CMP.B #$09
        BNE .ToolUsedGrassSeeds_Branch_829BCA
        STZ.W $096B
        %Set8bit(!M)
        LDA.W !seeds_grass_N
        DEC A
        STA.W !seeds_grass_N
        BNE .ToolUsedGrassSeeds_Branch_829BBB
        STZ.W !tool_selected

    .ToolUsedGrassSeeds_Branch_829BBB:
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set8bit(!M)
        LDA.B #$FF
        JSL.L Stamina_ApplyDeltaAndFatigueState

    .ToolUsedGrassSeeds_Branch_829BCA: RTS

;;;;;;;;
ToolUsedPaint: ;829BCB
        %Set16bit(!MX)
        JSR.W ToolAction_CheckTargetTileSingle
        BNE .ToolUsedPaint_Branch_829BD5
        JMP.W .ToolUsedPaint_Branch_829CB0

    .ToolUsedPaint_Branch_829BD5:
        %Set16bit(!MX)
        CPX.W #$00E2
        BEQ .ToolUsedPaint_Branch_829C1D
        CPX.W #$00E3
        BEQ .ToolUsedPaint_Branch_829C50
        CPX.W #$00E4
        BNE .ToolUsedPaint_Branch_829BE9
        JMP.W .ToolUsedPaint_Branch_829C80

    .ToolUsedPaint_Branch_829BE9:
        %Set16bit(!MX)
        LDA.L !marriage_flags
        AND.W #$0200                         ;FLAG66
        BEQ .ToolUsedPaint_Branch_829BF7
        JMP.W .ToolUsedPaint_Branch_829CB0

    .ToolUsedPaint_Branch_829BF7:
        LDA.W #$000A
        JSL.L Social_AddPlayerHappiness
        %Set16bit(!M)
        LDA.W #$0059
        LDX.W #$0080
        LDY.W #$0130
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM
        %Set16bit(!MX)
        LDA.L !marriage_flags
        ORA.W #$0200                         ;FLAG66
        STA.L !marriage_flags
        JMP.W .ToolUsedPaint_Branch_829CB0

    .ToolUsedPaint_Branch_829C1D:
        %Set16bit(!MX)
        LDA.L !marriage_flags
        AND.W #$0400                         ;FLAG66
        BEQ .ToolUsedPaint_Branch_829C2B
        JMP.W .ToolUsedPaint_Branch_829CB0

    .ToolUsedPaint_Branch_829C2B:
        LDA.W #$000A
        JSL.L Social_AddPlayerHappiness
        %Set16bit(!M)
        LDA.W #$0058
        LDX.W #$0060
        LDY.W #$0130
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM
        %Set16bit(!MX)
        LDA.L !marriage_flags
        ORA.W #$0400                         ;FLAG66
        STA.L !marriage_flags
        BRA .ToolUsedPaint_Branch_829CB0

    .ToolUsedPaint_Branch_829C50:
        %Set16bit(!MX)
        LDA.L !marriage_flags
        AND.W #$0800                         ;FLAG66
        BNE .ToolUsedPaint_Branch_829CB0
        LDA.W #$000A
        JSL.L Social_AddPlayerHappiness
        %Set16bit(!M)
        LDA.W #$005A
        LDX.W #$0090
        LDY.W #$0130
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM
        %Set16bit(!MX)
        LDA.L !marriage_flags
        ORA.W #$0800                         ;FLAG66
        STA.L !marriage_flags
        BRA .ToolUsedPaint_Branch_829CB0

    .ToolUsedPaint_Branch_829C80:
        %Set16bit(!MX)
        LDA.L !marriage_flags
        AND.W #$1000                         ;FLAG66
        BNE .ToolUsedPaint_Branch_829CB0
        LDA.W #$000A
        JSL.L Social_AddPlayerHappiness
        %Set16bit(!M)
        LDA.W #$005C
        LDX.W #$00B0
        LDY.W #$0130
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM
        %Set16bit(!MX)
        LDA.L !marriage_flags
        ORA.W #$1000                         ;FLAG66
        STA.L !marriage_flags
        BRA .ToolUsedPaint_Branch_829CB0

    .ToolUsedPaint_Branch_829CB0:
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set8bit(!M)
        LDA.B #$FE
        JSL.L Stamina_ApplyDeltaAndFatigueState

        RTS

;;;;;;;;
ToolUsedMilker: ;829CC0
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action

        RTS

;;;;;;;;
ToolUsedBrush: ;829CC8
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set8bit(!M)
        LDA.B #$FF
        JSL.L Stamina_ApplyDeltaAndFatigueState

        RTS

;;;;;;;;
ToolUsedWateringCan: ;829CD8 ;PASS16: consumes water, edits watered crop tile when target accepts water
        %Set8bit(!M)
        %Set16bit(!X)
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$00
        STA.W $0114
        LDA.B #$07
        STA.W $0115
        JSL.L AudioSFX_PlayQueuedEffectDefaultVolume
        JSR.W ToolAction_CheckTargetTileSingle
        %Set8bit(!M)
        CMP.B #$02
        BEQ .return
        LDA.W !watering_can_water
        BEQ .return
        DEC A
        STA.W !watering_can_water
        JSR.W ToolAction_CheckTargetTileSingle
        BNE .ToolUsedWateringCan_Branch_829D08
        JMP.W .return

    .ToolUsedWateringCan_Branch_829D08:
        %Set16bit(!MX)
        TXA
        INC A
        PHA
        %Set8bit(!M)
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L EditTileonMap
        %Set16bit(!M)
        PLA
        ASL A
        ASL A
        TAY
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B [$0D],Y
        %Set16bit(!M)
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM

    .return:
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set8bit(!M)
        LDA.B #$FE
        JSL.L Stamina_ApplyDeltaAndFatigueState

        RTS

;;;;;;;;
ToolUsedGoldSickle: ;829D42 ;PASS16: 3x3 sickle pattern over 9 steps, costs -8 stamina at completion
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$00
        XBA
        LDA.W $096B
        JSR.W ToolAction_CheckTargetTileSquare
        BNE .ToolUsedGoldSickle_Branch_829D54
        JMP.W .ToolUsedGoldSickle_Branch_829E6E

    .ToolUsedGoldSickle_Branch_829D54:
        %Set8bit(!M)
        LDA.L !season
        CMP.B #$03
        BNE .ToolUsedGoldSickle_Branch_829D61
        JMP.W .ToolUsedGoldSickle_Branch_829E8D

    .ToolUsedGoldSickle_Branch_829D61:
        LDA.B !tilemap_to_load
        CMP.B #$04
        BCC .ToolUsedGoldSickle_Branch_829D7A
        %Set16bit(!M)
        CPX.W #$0035
        BEQ .ToolUsedGoldSickle_Branch_829D73
        LDA.W #$00DD
        BRA .ToolUsedGoldSickle_Branch_829DE6

    .ToolUsedGoldSickle_Branch_829D73:
        %Set16bit(!M)
        LDA.W #$00DE
        BRA .ToolUsedGoldSickle_Branch_829DE6

    .ToolUsedGoldSickle_Branch_829D7A:
        %Set16bit(!M)
        CPX.W #$0003
        BEQ .ToolUsedGoldSickle_Branch_829D8B
        CPX.W #$0079
        BEQ .ToolUsedGoldSickle_Branch_829D92
        LDA.W #$0017
        BRA .ToolUsedGoldSickle_Branch_829DE6

    .ToolUsedGoldSickle_Branch_829D8B:
        %Set16bit(!M)
        LDA.W #$000E
        BRA .ToolUsedGoldSickle_Branch_829DE6

    .ToolUsedGoldSickle_Branch_829D92:
        %Set16bit(!M)
        LDA.W #$0001
        JSL.L AddGrass
        %Set16bit(!M)
        LDA.W $092E
        DEC A
        STA.W $092E
        %Set16bit(!M)
        LDA.W #$0052
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM
        %Set16bit(!M)
        LDA.W !tile_in_front_X
        STA.W $0980
        LDA.W !tile_in_front_Y
        STA.W $0982
        %Set16bit(!MX)
        LDA.W #$00C1
        STA.W $097A
        LDA.W #$0000
        STA.W $097E
        %Set8bit(!M)
        LDA.B #$03
        STA.W $0974
        LDA.B #$00
        STA.W $0975
        LDA.B #$00
        STA.W $0976
        JSL.L MapTilePatchRuntime_AllocateVisualEffectObjectSlot
        BRA .ToolUsedGoldSickle_Branch_829E21

    .ToolUsedGoldSickle_Branch_829DE6:
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM
        %Set16bit(!M)
        LDA.W !tile_in_front_X
        STA.W $0980
        LDA.W !tile_in_front_Y
        STA.W $0982
        %Set16bit(!MX)
        LDA.W #$00B7
        STA.W $097A
        LDA.W #$0000
        STA.W $097E
        %Set8bit(!M)
        LDA.B #$03
        STA.W $0974
        LDA.B #$00
        STA.W $0975
        LDA.B #$00
        STA.W $0976
        JSL.L MapTilePatchRuntime_AllocateVisualEffectObjectSlot

    .ToolUsedGoldSickle_Branch_829E21:
        %Set8bit(!M)
        LDA.L !season
        CMP.B #$01
        BNE .ToolUsedGoldSickle_Branch_829E6E
        %Set16bit(!M)
        LDA.L $7F1F60
        AND.W #$0008                         ;FLAG60
        BNE .ToolUsedGoldSickle_Branch_829E6E
        LDA.L $7F1F5A
        AND.W #$2000                         ;FLAG5A
        BNE .ToolUsedGoldSickle_Branch_829E6E
        %Set8bit(!M)
        LDA.B #$10
        JSL.L RNG_GetRange0ToAExclusiveStyle
        BNE .ToolUsedGoldSickle_Branch_829E6E
        %Set16bit(!MX)
        LDA.W #$0012
        LDX.W #$0000
        LDY.W #$0032
        JSL.L EventScript_LoadScriptPointerForFacingTile
        %Set16bit(!MX)
        LDA.W #$0002
        JSL.L Social_AddPlayerHappiness
        %Set16bit(!M)
        LDA.L $7F1F5A
        ORA.W #$2000                         ;FLAG5A
        STA.L $7F1F5A

    .ToolUsedGoldSickle_Branch_829E6E:
        %Set8bit(!M)
        LDA.W $096B
        INC A
        STA.W $096B
        CMP.B #$09
        BNE .ToolUsedGoldSickle_Branch_829E8D
        STZ.W $096B
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set8bit(!M)
        LDA.B #$F8
        JSL.L Stamina_ApplyDeltaAndFatigueState

    .ToolUsedGoldSickle_Branch_829E8D: RTS


;;;;;;;;
ToolUsedGoldHoe: ;829E8E    ;PASS16: line hoe pattern over 6 steps, costs -8 stamina at completion
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$00
        XBA
        LDA.W $096B
        JSR.W ToolAction_CheckTargetTileLine
        BNE .molecheck
        JMP.W .ToolUsedGoldHoe_Branch_829FF0

    .molecheck:
        %Set16bit(!M)
        LDA.W #$0017
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM
        %Set8bit(!M)
        LDA.L !season
        CMP.B #$02
        BCS .coincheck
        %Set16bit(!M)
        %Set16bit(!M)
        LDA.L $7F1F60
        AND.W #$0008                         ;FLAG60
        BNE .coincheck
        LDA.L $7F1F5A
        AND.W #$1000                         ;FLAG5A
        BNE .coincheck
        %Set8bit(!M)
        LDA.B #$20
        JSL.L RNG_GetRange0ToAExclusiveStyle
        BNE .coincheck
        %Set16bit(!MX)
        LDA.W #$0011
        LDX.W #$0000
        LDY.W #$0030
        JSL.L EventScript_LoadScriptPointerForFacingTile
        %Set16bit(!M)
        LDA.L $7F1F5A
        ORA.W #$1000                         ;FLAG5A
        STA.L $7F1F5A
        JMP.W .ToolUsedGoldHoe_Branch_829FE3

    .coincheck:
        %Set16bit(!MX)
        LDA.L $7F1F60
        AND.W #$0008                         ;FLAG60
        BNE .berry1check
        LDA.L $7F1F5C
        AND.W #$0200                         ;FLAG5C
        BNE .berry1check
        %Set8bit(!M)
        LDA.B #$10
        JSL.L RNG_GetRange0ToAExclusiveStyle
        BNE .moneybagcheck
        %Set16bit(!MX)
        LDA.L $7F1F5C
        ORA.W #$0200                         ;FLAG5C
        STA.L $7F1F5C
        LDA.W #$000F
        LDX.W #$0000
        LDY.W #$003A
        JSL.L EventScript_LoadScriptPointerForFacingTile
        %Set16bit(!M)
        LDA.W #$0001
        STA.B $72
        %Set8bit(!M)
        LDA.B #$00
        STA.B $74
        JSL.L AddMoney
        JMP.W .ToolUsedGoldHoe_Branch_829FE3

    .moneybagcheck:
        %Set8bit(!M)
        LDA.B #$10
        JSL.L RNG_GetRange0ToAExclusiveStyle
        BNE .berry1check
        %Set16bit(!MX)
        LDA.L $7F1F5C
        ORA.W #$0200                         ;FLAG5C
        STA.L $7F1F5C
        %Set16bit(!MX)
        LDA.W #$000F
        LDX.W #$0000
        LDY.W #$003B
        JSL.L EventScript_LoadScriptPointerForFacingTile
        %Set16bit(!M)
        LDA.W #$0005
        STA.B $72
        %Set8bit(!M)
        LDA.B #$00
        STA.B $74
        JSL.L AddMoney
        BRA .ToolUsedGoldHoe_Branch_829FE3

    .berry1check:
        %Set8bit(!M)
        LDA.B #$40
        JSL.L RNG_GetRange0ToAExclusiveStyle
        BNE .ToolUsedGoldHoe_Branch_829FE3
        %Set16bit(!MX)
        LDA.L $7F1F60
        AND.W #$0008                         ;FLAG60
        BNE .ToolUsedGoldHoe_Branch_829FE3
        LDA.L $7F1F5C
        AND.W #$0100                         ;FLAG5C
        BNE .ToolUsedGoldHoe_Branch_829FE3
        LDA.L $7F1F5C
        ORA.W #$0100                         ;FLAG5C
        STA.L $7F1F5C
        LDA.L !player_house_and_event_flags
        AND.W #$0800                         ;FLAG64
        BNE .berry2check
        LDA.L !player_house_and_event_flags
        ORA.W #$0800                         ;FLAG64
        STA.L !player_house_and_event_flags
        BRA .berryspawn

    .berry2check:
        %Set16bit(!MX)
        LDA.L !player_house_and_event_flags
        AND.W #$1000                         ;FLAG64
        BNE .ToolUsedGoldHoe_Branch_829FE3
        LDA.L !player_house_and_event_flags
        ORA.W #$1000                         ;FLAG64
        STA.L !player_house_and_event_flags

    .berryspawn:
        %Set16bit(!MX)
        LDA.W #$0010
        LDX.W #$0000
        LDY.W #$001F
        JSL.L EventScript_LoadScriptPointerForFacingTile
        BRA .ToolUsedGoldHoe_Branch_829FE3

    .ToolUsedGoldHoe_Branch_829FE3:
        %Set8bit(!M)
        LDA.W $096B
        INC A
        STA.W $096B
        CMP.B #$06
        BNE .ToolUsedGoldHoe_Branch_82A004

    .ToolUsedGoldHoe_Branch_829FF0:
        %Set8bit(!M)
        STZ.W $096B
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set8bit(!M)
        LDA.B #$F8
        JSL.L Stamina_ApplyDeltaAndFatigueState

    .ToolUsedGoldHoe_Branch_82A004: RTS

;;;;;;;;
ToolUsedGoldHammer: ;82A005 ;PASS16: enhanced hammer effect, breaks large rocks without 6-hit normal counter
        %Set16bit(!MX)
        JSR.W ToolAction_CheckTargetTileSingle
        BNE .ToolUsedGoldHammer_Branch_82A00F
        JMP.W .ToolUsedGoldHammer_Branch_82A141

    .ToolUsedGoldHammer_Branch_82A00F:
        CPX.W #$0006
        BEQ .ToolUsedGoldHammer_Branch_82A07B
        CPX.W #$0004
        BEQ .ToolUsedGoldHammer_Branch_82A01C
        JMP.W .ToolUsedGoldHammer_Branch_82A08D

    .ToolUsedGoldHammer_Branch_82A01C:
        %Set8bit(!M)
        LDA.B !tilemap_to_load
        CMP.B #$04
        BCC .ToolUsedGoldHammer_Branch_82A038
        LDA.B !tilemap_to_load
        CMP.B #$29
        BCS .ToolUsedGoldHammer_Branch_82A031
        %Set16bit(!M)
        LDA.W #$00DD
        BRA .ToolUsedGoldHammer_Branch_82A03D

    .ToolUsedGoldHammer_Branch_82A031:
        %Set16bit(!M)
        LDA.W #$00E3
        BRA .ToolUsedGoldHammer_Branch_82A03D

    .ToolUsedGoldHammer_Branch_82A038:
        %Set16bit(!M)
        LDA.W #$000E

    .ToolUsedGoldHammer_Branch_82A03D:
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM
        %Set16bit(!M)
        LDA.W !tile_in_front_X
        STA.W $0980
        LDA.W !tile_in_front_Y
        STA.W $0982
        %Set16bit(!MX)
        LDA.W #$00C8
        STA.W $097A
        LDA.W #$0000
        STA.W $097E
        %Set8bit(!M)
        LDA.B #$03
        STA.W $0974
        LDA.B #$00
        STA.W $0975
        LDA.B #$00
        STA.W $0976
        JSL.L MapTilePatchRuntime_AllocateVisualEffectObjectSlot
        JMP.W .return

    .ToolUsedGoldHammer_Branch_82A07B:
        %Set16bit(!M)
        LDA.W #$000E
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM
        JMP.W .return

    .ToolUsedGoldHammer_Branch_82A08D:
        %Set16bit(!M)
        LDA.W !tile_in_front_X
        SEC
        SBC.W #$0010
        STA.W !tile_in_front_X
        LDA.W !tile_in_front_Y
        SEC
        SBC.W #$0010
        STA.W !tile_in_front_Y
        CPX.W #$0010
        BEQ .ToolUsedGoldHammer_Branch_82A0DA
        LDA.W !tile_in_front_X
        CLC
        ADC.W #$0010
        STA.W !tile_in_front_X
        CPX.W #$000F
        BEQ .ToolUsedGoldHammer_Branch_82A0DA
        LDA.W !tile_in_front_X
        SEC
        SBC.W #$0010
        STA.W !tile_in_front_X
        LDA.W !tile_in_front_Y
        CLC
        ADC.W #$0010
        STA.W !tile_in_front_Y
        CPX.W #$000E
        BEQ .ToolUsedGoldHammer_Branch_82A0DA
        LDA.W !tile_in_front_X
        CLC
        ADC.W #$0010
        STA.W !tile_in_front_X

    .ToolUsedGoldHammer_Branch_82A0DA:
        %Set8bit(!M)
        LDA.B !tilemap_to_load
        CMP.B #$04
        BCC .ToolUsedGoldHammer_Branch_82A0E9
        %Set16bit(!M)
        LDA.W #$00DF
        BRA .ToolUsedGoldHammer_Branch_82A0EE

    .ToolUsedGoldHammer_Branch_82A0E9:
        %Set16bit(!M)
        LDA.W #$000D

    .ToolUsedGoldHammer_Branch_82A0EE:
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM
        %Set16bit(!M)
        LDA.W !tile_in_front_X
        CLC
        ADC.W #$0008
        STA.W $0980
        LDA.W !tile_in_front_Y
        CLC
        ADC.W #$0008
        STA.W $0982
        %Set16bit(!MX)
        LDA.W #$00C9
        STA.W $097A
        LDA.W #$0000
        STA.W $097E
        %Set8bit(!M)
        LDA.B #$03
        STA.W $0974
        LDA.B #$00
        STA.W $0975
        LDA.B #$00
        STA.W $0976
        JSL.L MapTilePatchRuntime_AllocateVisualEffectObjectSlot

    .return:
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set8bit(!M)
        LDA.B #$FC
        JSL.L Stamina_ApplyDeltaAndFatigueState

        RTS

    .ToolUsedGoldHammer_Branch_82A141:
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B !tilemap_to_load
        CMP.B #$0C
        BCC .return
        CMP.B #$10
        BCS .return
        CPX.W #$00F8
        BNE .return
        %Set16bit(!MX)
        LDA.L $7F1F5C
        AND.W #$0080
        BNE .return
        %Set16bit(!M)
        LDA.W #$0015
        LDX.W #$0000
        LDY.W #$0016
        JSL.L EventScript_LoadScriptPointerShort
        %Set8bit(!M)
        LDA.B #$04
        JSL.L RNG_GetRange0ToAExclusiveStyle
        BNE .return
        %Set16bit(!MX)
        LDA.L !player_house_and_event_flags
        AND.W #$0200
        BNE .return
        LDA.L !player_house_and_event_flags
        ORA.W #$0200
        STA.L !player_house_and_event_flags
        %Set16bit(!MX)
        LDA.B !player_pos_X
        CLC
        ADC.W #$0010
        STA.W !tile_in_front_X
        LDA.B !player_pos_Y
        SEC
        SBC.W #$0010
        STA.W !tile_in_front_Y
        LDA.W #$0010
        LDX.W #$0000
        LDY.W #$001F
        JSL.L EventScript_LoadScriptPointerForFacingTile
        %Set16bit(!MX)
        LDA.L $7F1F5C
        ORA.W #$0080
        STA.L $7F1F5C
        JMP.W .return

;;;;;;;;
ToolUsedGoldAxe: ;82A1BF    ;PASS16: enhanced axe effect, chops large logs/stumps directly, costs -8 stamina
        %Set16bit(!MX)
        JSR.W ToolAction_CheckTargetTileSingle
        BNE .ToolUsedGoldAxe_Branch_82A1C9
        JMP.W .ToolUsedGoldAxe_Branch_82A2F7

    .ToolUsedGoldAxe_Branch_82A1C9:
        %Set16bit(!M)
        LDA.W !tile_in_front_X
        SEC
        SBC.W #$0010
        STA.W !tile_in_front_X
        LDA.W !tile_in_front_Y
        SEC
        SBC.W #$0010
        STA.W !tile_in_front_Y
        CPX.W #$000C
        BEQ .ToolUsedGoldAxe_Branch_82A235
        CPX.W #$0014
        BNE .ToolUsedGoldAxe_Branch_82A1EC
        JMP.W .ToolUsedGoldAxe_Branch_82A29D

    .ToolUsedGoldAxe_Branch_82A1EC:
        LDA.W !tile_in_front_X
        CLC
        ADC.W #$0010
        STA.W !tile_in_front_X
        CPX.W #$000B
        BEQ .ToolUsedGoldAxe_Branch_82A235
        CPX.W #$0013
        BNE .ToolUsedGoldAxe_Branch_82A203
        JMP.W .ToolUsedGoldAxe_Branch_82A29D

    .ToolUsedGoldAxe_Branch_82A203:
        LDA.W !tile_in_front_X
        SEC
        SBC.W #$0010
        STA.W !tile_in_front_X
        LDA.W !tile_in_front_Y
        CLC
        ADC.W #$0010
        STA.W !tile_in_front_Y
        CPX.W #$000A
        BEQ .ToolUsedGoldAxe_Branch_82A235
        CPX.W #$0012
        BEQ .ToolUsedGoldAxe_Branch_82A29D
        LDA.W !tile_in_front_X
        CLC
        ADC.W #$0010
        STA.W !tile_in_front_X
        CPX.W #$0009
        BEQ .ToolUsedGoldAxe_Branch_82A235
        CPX.W #$0011
        BEQ .ToolUsedGoldAxe_Branch_82A29D

    .ToolUsedGoldAxe_Branch_82A235:
        %Set8bit(!M)
        LDA.B !tilemap_to_load
        CMP.B #$04
        BCC .ToolUsedGoldAxe_Branch_82A2A4
        %Set8bit(!M)
        LDA.B #$10
        JSL.L RNG_GetRange0ToAExclusiveStyle
        BNE .ToolUsedGoldAxe_Branch_82A296
        %Set16bit(!MX)
        LDA.L !player_house_and_event_flags
        AND.W #$0400                         ;FLAG64
        BNE .ToolUsedGoldAxe_Branch_82A296
        LDA.L !player_house_and_event_flags
        ORA.W #$0400                         ;FLAG64
        STA.L !player_house_and_event_flags
        %Set16bit(!MX)
        LDA.W !tile_in_front_X
        CLC
        ADC.W #$0008
        STA.W !tile_in_front_X
        LDA.W !tile_in_front_Y
        CLC
        ADC.W #$0008
        STA.W !tile_in_front_Y
        LDA.W #$0010
        LDX.W #$0000
        LDY.W #$001F
        JSL.L EventScript_LoadScriptPointerForFacingTile
        %Set16bit(!MX)
        LDA.W !tile_in_front_X
        SEC
        SBC.W #$0008
        STA.W !tile_in_front_X
        LDA.W !tile_in_front_Y
        SEC
        SBC.W #$0008
        STA.W !tile_in_front_Y

    .ToolUsedGoldAxe_Branch_82A296:
        %Set16bit(!MX)
        LDA.W #$00DF
        BRA .ToolUsedGoldAxe_Branch_82A2A9

    .ToolUsedGoldAxe_Branch_82A29D:
        %Set16bit(!MX)
        LDA.W #$00E0
        BRA .ToolUsedGoldAxe_Branch_82A2A9

    .ToolUsedGoldAxe_Branch_82A2A4:
        %Set16bit(!MX)
        LDA.W #$000D

    .ToolUsedGoldAxe_Branch_82A2A9:
        %Set16bit(!MX)
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM
        %Set16bit(!M)
        LDA.W !tile_in_front_X
        CLC
        ADC.W #$0008
        STA.W $0980
        LDA.W !tile_in_front_Y
        CLC
        ADC.W #$0008
        STA.W $0982
        %Set16bit(!MX)
        LDA.W #$00B8
        STA.W $097A
        LDA.W #$0000
        STA.W $097E
        %Set8bit(!M)
        LDA.B #$03
        STA.W $0974
        LDA.B #$00
        STA.W $0975
        LDA.B #$00
        STA.W $0976
        JSL.L MapTilePatchRuntime_AllocateVisualEffectObjectSlot
        %Set16bit(!M)
        LDA.W #$0006
        JSL.L AddWood

    .ToolUsedGoldAxe_Branch_82A2F7:
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set8bit(!M)
        LDA.B #$F8
        JSL.L Stamina_ApplyDeltaAndFatigueState

        RTS

;;;;;;;;
ToolUsedSprinkler: ;82A307  ;PASS16: waters 3x3 square over 9 steps, costs -8 stamina at completion
        %Set8bit(!M)
        %Set16bit(!X)
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$00
        STA.W $0114
        LDA.B #$07
        STA.W $0115
        JSL.L AudioSFX_PlayQueuedEffectDefaultVolume
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.W $096B
        JSR.W ToolAction_CheckTargetTileSquare
        BNE .ToolUsedSprinkler_Branch_82A32D
        JMP.W .ToolUsedSprinkler_Branch_82A357

    .ToolUsedSprinkler_Branch_82A32D:
        %Set16bit(!MX)
        TXA
        INC A
        PHA
        %Set8bit(!M)
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L EditTileonMap
        %Set16bit(!M)
        PLA
        ASL A
        ASL A
        TAY
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B [$0D],Y
        %Set16bit(!M)
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM

    .ToolUsedSprinkler_Branch_82A357:
        %Set8bit(!M)
        LDA.W $096B
        INC A
        STA.W $096B
        CMP.B #$09
        BNE .ToolUsedSprinkler_Branch_82A376
        STZ.W $096B
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set8bit(!M)
        LDA.B #$F8
        JSL.L Stamina_ApplyDeltaAndFatigueState

    .ToolUsedSprinkler_Branch_82A376: RTS

;;;;;;;;
ToolUsedMagicBeans: ;82A377
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.L !hour
        CMP.B #$11
        BCS .ToolUsedMagicBeans_Branch_82A3A2
        LDA.B !tilemap_to_load
        CMP.B #$31
        BNE .ToolUsedMagicBeans_Branch_82A3A2
        %Set16bit(!MX)
        LDA.L $7F1F68
        ORA.W #$0200                         ;
        STA.L $7F1F68
        LDA.W #$0042
        JSL.L MapTilePatchScript_StartByIndex
        %Set8bit(!M)
        STZ.W !tool_selected

    .ToolUsedMagicBeans_Branch_82A3A2:
        %Set16bit(!MX)                             ;82A3A2;      ;
        LDA.W #$0000                         ;82A3A4;      ;
        STA.B !player_action                            ;82A3A7;0000D4;

        RTS                                  ;82A3A9;      ;

;;;;;;;;
ToolUsedGemSeed: ;82A3AA
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.L !hour
        CMP.B #$11
        BCS .ToolUsedGemSeed_Branch_82A3F5
        LDA.B !tilemap_to_load
        CMP.B #$34
        BNE .ToolUsedGemSeed_Branch_82A3F5
        %Set16bit(!MX)
        LDA.W #$0001
        LDX.W #$0000
        LDY.W #$0000
        JSL.L PlayerTarget_CalculateTileInFront
        %Set16bit(!MX)
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        LDA.W #$0000
        JSL.L TileProperty_CheckToolUseAllowed
        %Set16bit(!MX)
        CPX.W #$00F6
        BNE .ToolUsedGemSeed_Branch_82A3F5
        %Set16bit(!MX)
        LDA.W #$0000
        LDX.W #$0012
        LDY.W #$0000
        JSL.L EventScript_LoadScriptPointerLong
        %Set8bit(!M)
        STZ.W !tool_selected

    .ToolUsedGemSeed_Branch_82A3F5:
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action

        RTS

;;;;;;;;
ToolUsedBlueFeather: ;82A3FD
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set16bit(!M)
        LDA.L $7F1F5E
        ORA.W #$0040                         ;FLAG5E
        STA.L $7F1F5E

        RTS

;;;;;;;;
ToolUsedChickenFeed: ;82A414 ;PASS16: coop-only feed placement, updates fed_chicks flags/count and feed inventory
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B !tilemap_to_load
        CMP.B #$28                           ;Coop
        BNE .ToolUsedChickenFeed_Branch_82A473
        %Set16bit(!M)
        LDA.W #$0001
        LDX.W #$0006
        LDY.W #$0006
        JSL.L PlayerTarget_CalculateTileInFront
        %Set16bit(!MX)
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        LDA.W #$0000
        JSL.L TileProperty_CheckToolUseAllowed
        CPX.W #$00E2
        BCC .ToolUsedChickenFeed_Branch_82A473
        CPX.W #$00EF
        BCS .ToolUsedChickenFeed_Branch_82A473
        %Set16bit(!M)
        TXA
        SEC
        SBC.W #$00E2
        ASL A
        TAX
        LDA.L AnimalFeed_StallBitmaskTable,X               ;has that name, but its just precoked flags
        ORA.W !fed_chicks_flags
        STA.W !fed_chicks_flags
        %Set8bit(!M)
        LDA.W !fed_chicks_N
        INC A
        STA.W !fed_chicks_N
        %Set16bit(!M)
        LDA.W #$0099
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM
        BRA .ToolUsedChickenFeed_Branch_82A4A4

    .ToolUsedChickenFeed_Branch_82A473:
        %Set16bit(!M)
        LDA.W !tile_in_front_X
        STA.W $0980
        LDA.W !tile_in_front_Y
        STA.W $0982
        %Set16bit(!MX)
        LDA.W #$00C4
        STA.W $097A
        LDA.W #$0000
        STA.W $097E
        %Set8bit(!M)
        LDA.B #$03
        STA.W $0974
        LDA.B #$00
        STA.W $0975
        LDA.B #$00
        STA.W $0976
        JSL.L MapTilePatchRuntime_AllocateVisualEffectObjectSlot

    .ToolUsedChickenFeed_Branch_82A4A4:
        %Set8bit(!M)
        LDA.W !feed_chicks_N
        DEC A
        STA.W !feed_chicks_N
        BNE .ToolUsedChickenFeed_Branch_82A4B2
        STZ.W !tool_selected

    .ToolUsedChickenFeed_Branch_82A4B2:
        %Set8bit(!M)
        LDA.B #$FE
        JSL.L Stamina_ApplyDeltaAndFatigueState
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action

        RTS

;;;;;;;;
ToolUsedCowFeed: ;82A4C2     ;PASS16: barn-only feed placement, updates fed_cows flags/count and feed inventory
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B !tilemap_to_load
        CMP.B #$27
        BNE .ToolUsedCowFeed_Branch_82A521
        %Set16bit(!M)
        LDA.W #$0001
        LDX.W #$0006
        LDY.W #$0006
        JSL.L PlayerTarget_CalculateTileInFront
        %Set16bit(!MX)
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        LDA.W #$0000
        JSL.L TileProperty_CheckToolUseAllowed
        CPX.W #$00E2
        BCC .ToolUsedCowFeed_Branch_82A521
        CPX.W #$00EF
        BCS .ToolUsedCowFeed_Branch_82A521
        %Set16bit(!M)
        TXA
        SEC
        SBC.W #$00E2
        ASL A
        TAX
        LDA.L AnimalFeed_StallBitmaskTable,X
        ORA.W !fed_cows_flags
        STA.W !fed_cows_flags
        %Set8bit(!M)
        LDA.W !fed_cows_N
        INC A
        STA.W !fed_cows_N
        %Set16bit(!M)
        LDA.W #$0099
        LDX.W !tile_in_front_X
        LDY.W !tile_in_front_Y
        JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM
        BRA .ToolUsedCowFeed_Branch_82A552

    .ToolUsedCowFeed_Branch_82A521:
        %Set16bit(!M)
        LDA.W !tile_in_front_X
        STA.W $0980
        LDA.W !tile_in_front_Y
        STA.W $0982
        %Set16bit(!MX)
        LDA.W #$00C4
        STA.W $097A
        LDA.W #$0000
        STA.W $097E
        %Set8bit(!M)
        LDA.B #$03
        STA.W $0974
        LDA.B #$00
        STA.W $0975
        LDA.B #$00
        STA.W $0976
        JSL.L MapTilePatchRuntime_AllocateVisualEffectObjectSlot

    .ToolUsedCowFeed_Branch_82A552:
        %Set8bit(!M)
        LDA.W !feed_cow_N
        DEC A
        STA.W !feed_cow_N
        BNE .ToolUsedCowFeed_Branch_82A560
        STZ.W !tool_selected

    .ToolUsedCowFeed_Branch_82A560:
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set8bit(!M)
        LDA.B #$FE
        JSL.L Stamina_ApplyDeltaAndFatigueState
        RTS

;;;;;;;;
ToolUsedUNK: ;82A570
        RTS