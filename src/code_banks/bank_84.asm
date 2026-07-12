ORG $848000

;;;;;;;;
EventScript_ClearAllSlots: ;848000
        %Set16bit(!MX)
        LDX.W #$0000

        .loop:
            PHX
            TXA
            JSL.L EventScript_SetCCPointerBySlot
            %Set8bit(!M)
            %Set16bit(!X)
            LDY.W #$0000
            LDA.B #$00
            STA.B [$CC],Y
            %Set16bit(!MX)
            PLX
            INX
            CPX.W #$0031
            BNE .loop

        RTL

;;;;;;;; Param in A, $CC index
EventScript_ClearSlotAndAttachedObject: ;848020
        %Set16bit(!MX)
        JSL.L EventScript_SetCCPointerBySlot
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0000
        LDA.B #$00
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$0012
        LDA.B [$CC],Y
        STA.B $A5
        JSL.L GameOBJ_ClearSlotAndReleaseComponents

        RTL

;;;;;;;; Param in A $CC index, X: $7E, Y: %80
EventScript_LoadScriptPointerShort: ;84803F
        %Set16bit(!MX)
        JSL.L EventScript_SetCCPointerBySlot
        %Set16bit(!MX)
        STX.B $7E
        STY.B $80
        LDX.W #$0000
        LDA.L Events_Bank_Table,X
        STA.B $75
        INX
        INX
        %Set8bit(!M)
        LDA.L Events_Bank_Table,X
        STA.B $77
        %Set16bit(!M)
        LDA.B $7E
        ASL A
        CLC
        ADC.B $7E
        TAY
        LDA.B [$75],Y
        STA.B $78
        INY
        INY
        %Set8bit(!M)
        LDA.B [$75],Y
        STA.B $7A
        %Set16bit(!M)
        LDA.B $80
        ASL A
        TAY
        LDA.B [$78],Y
        %Set16bit(!MX)
        LDY.W #$0030
        STA.B [$CC],Y
        STA.B $C9
        %Set8bit(!M)
        LDA.B $7A
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0032
        STA.B [$CC],Y
        STA.B $CB
        JSR.W ResetsCurrentCCStructureShort

        RTL

;;;;;;;;
;;;;;;;; params in A: $CC Pointer index, X: index to B38000 data Y: $C9 pointer index
EventScript_LoadScriptPointerLong: ;848097
        %Set16bit(!MX)
        PHA
        JSL.L EventScript_SetCCPointerBySlot
        %Set16bit(!MX)
        STX.B $7E
        STY.B $80
        LDX.W #$0000
        LDA.L Events_Bank_Table,X
        STA.B $72
        INX
        INX
        %Set8bit(!M)
        LDA.L Events_Bank_Table,X            ;B38000
        STA.B $74
        %Set16bit(!M)
        LDA.B $7E
        ASL A
        CLC
        ADC.B $7E                            ;X * 3
        TAY
        LDA.B [$72],Y                        ;loads pointer from B38000 into it
        STA.B $C9
        INY
        INY
        %Set8bit(!M)
        LDA.B [$72],Y
        STA.B $CB
        %Set16bit(!M)
        LDA.B $80
        ASL A
        TAY
        LDA.B [$C9],Y
        %Set16bit(!MX)
        LDY.W #$0030
        STA.B [$CC],Y
        %Set8bit(!M)
        LDA.B $CB
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0032
        STA.B [$CC],Y
        JSR.W ResetsCurrentCCStructureLong
        %Set16bit(!MX)
        PLA
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        STA.B [$CC],Y

        RTL

;;;;;;;; Param in A
EventScript_LoadScriptPointerForFacingTile: ;8480F8
        %Set16bit(!MX)
        PHA
        JSL.L EventScript_SetCCPointerBySlot
        %Set16bit(!MX)
        STX.B $7E
        STY.B $80
        LDX.W #$0000
        LDA.L Events_Bank_Table,X
        STA.B $72
        INX
        INX
        %Set8bit(!M)
        LDA.L Events_Bank_Table,X
        STA.B $74
        %Set16bit(!M)
        LDA.B $7E
        ASL A
        CLC
        ADC.B $7E
        TAY
        LDA.B [$72],Y
        STA.B $C9
        INY
        INY
        %Set8bit(!M)
        LDA.B [$72],Y
        STA.B $CB
        %Set16bit(!M)
        LDA.B $80
        ASL A
        TAY
        LDA.B [$C9],Y
        %Set16bit(!MX)
        LDY.W #$0030
        STA.B [$CC],Y
        %Set8bit(!M)
        LDA.B $CB
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0032
        STA.B [$CC],Y
        JSR.W ResetsCurrentCCStructureLong
        %Set16bit(!MX)
        PLA
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.W !tile_in_front_X
        %Set16bit(!MX)
        LDY.W #$001A
        STA.B [$CC],Y
        LDA.W !tile_in_front_Y
        %Set16bit(!MX)
        LDY.W #$001C
        STA.B [$CC],Y

        RTL

;;;;;;;;
EventScript_UpdateAllActiveSlots: ;84816F
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.W !inputstate
        CMP.B #$02                           ;No control
        BNE .EventScriptBank84_Branch_84817D
        JMP.W .setflagsandquit

    .EventScriptBank84_Branch_84817D:
        CMP.B #$06                           ;TODO
        BNE .EventScriptBank84_Branch_848184
        JMP.W .setflagsandquit

    .EventScriptBank84_Branch_848184:
        %Set16bit(!MX)
        LDA.B !player_action
        CMP.W #$0003                         ;TODO Jumping?
        BNE .getRNGandsetCC
        JMP.W .setflagsandquit

    .getRNGandsetCC:
        JSL.L RNG_GetNextByte
        %Set8bit(!M)
        STA.B $DE
        %Set16bit(!M)
        LDA.W #$B586
        STA.B $CC
        %Set8bit(!M)
        LDA.B #$7E
        STA.B $CE
        %Set16bit(!M)
        LDX.W #$0000

        .loop:
            %Set16bit(!MX)
            PHX
            %Set8bit(!M)
            %Set16bit(!X)
            LDY.W #$0000
            LDA.B [$CC],Y
            AND.B #$01                       ;check if this struct is set
            BEQ .skipindex
            %Set16bit(!MX)
            LDY.W #$0010
            LDA.B [$CC],Y
            BNE .EventScriptBank84_Branch_8481DF

            .EventScriptBank84_Branch_8481C3:
                %Set8bit(!M)
                %Set16bit(!X)
                LDY.W #$0001
                LDA.B [$CC],Y
                AND.B #$08
                BNE .EventScriptBank84_Branch_8481DA
                %Set16bit(!M)
                LDY.W #$0003
                LDA.W #$0000
                STA.B [$CC],Y

            .EventScriptBank84_Branch_8481DA:
                JSR.W EventScript_ExecuteNextOpcode
                BRA .EventScriptBank84_Branch_8481E7

            .EventScriptBank84_Branch_8481DF:
                DEC A
                %Set16bit(!MX)
                LDY.W #$0010
                STA.B [$CC],Y

            .EventScriptBank84_Branch_8481E7:
                %Set16bit(!MX)
                LDY.W #$0010
                LDA.B [$CC],Y
                BEQ .EventScriptBank84_Branch_8481C3

            %Set8bit(!M)
            LDA.B $DE
            CLC
            ADC.B #$33
            STA.B $DE
            %Set8bit(!M)
            %Set16bit(!X)
            LDY.W #$0001
            LDA.B [$CC],Y
            AND.B #$01
            BEQ .skipindex
            JSR.W EventScript_UpdateAttachedObjectState

        .skipindex:
            %Set16bit(!MX)
            LDA.B $CC
            CLC
            ADC.W #$0040
            STA.B $CC
            PLX
            INX
            CPX.W #$0031
            BNE .loop

    .setflagsandquit:
        %Set16bit(!M)
        LDA.L $7F1F5A
        AND.W #$FE2F
        STA.L $7F1F5A
        LDA.L $7F1F5C
        AND.W #$FBFF
        STA.L $7F1F5C
        LDA.L $7F1F5E
        AND.W #$FFBF
        STA.L $7F1F5E
        LDA.L $7F1F60
        AND.W #$FFEF
        STA.L $7F1F60

        RTL

;;;;;;;;
EventScript_ExecuteNextOpcode: ;848249
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDY.W #$0030
        LDA.B [$CC],Y
        STA.B $C9
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0032
        LDA.B [$CC],Y
        STA.B $CB
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B [$C9]
        %Set16bit(!M)
        ASL A
        TAX
        JSR.W (EventInstructionPointers,X)
        %Set16bit(!MX)
        LDA.B $C9
        %Set16bit(!MX)
        LDY.W #$0030
        STA.B [$CC],Y
        %Set8bit(!M)
        LDA.B $CB
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0032
        STA.B [$CC],Y

        RTS

;;;;;;;;
EventScript_UpdateAttachedObjectState: ;848286
        %Set16bit(!MX)
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        AND.B #$10
        BNE .EventScriptBank84_Branch_84829B
        JSR.W EventScript_UpdateAttachedObjectMotionPattern
        JSR.W EventScript_ApplyAttachedObjectVelocity

    .EventScriptBank84_Branch_84829B:
        %Set16bit(!MX)
        LDY.W #$0012
        LDA.B [$CC],Y
        STA.B $A5
        LDY.W #$0014
        LDA.B [$CC],Y
        STA.B $9F
        LDY.W #$001A
        LDA.B [$CC],Y
        STA.B $9B
        LDY.W #$001C
        LDA.B [$CC],Y
        STA.B $9D
        LDY.W #$0016
        LDA.B [$CC],Y
        STA.B $A1
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        AND.B #$40
        BNE .EventScriptBank84_Branch_84830A
        LDA.B [$CC],Y
        AND.B #$02
        BNE .EventScriptBank84_Branch_8482DF
        LDA.B [$CC],Y
        AND.B #$04
        BNE .EventScriptBank84_Branch_8482F0
        JSL.L GameOBJ_UpdateExistingSlotTransform
        BRA .EventScriptBank84_Branch_84830E

    .EventScriptBank84_Branch_8482DF:
        JSL.L GameOBJ_AllocateAndInitNewSlot
        %Set16bit(!MX)
        LDA.B $A5
        %Set16bit(!MX)
        LDY.W #$0012
        STA.B [$CC],Y
        BRA .EventScriptBank84_Branch_84830E

    .EventScriptBank84_Branch_8482F0:
        %Set16bit(!MX)
        LDY.W #$0016
        LDA.B [$CC],Y
        STA.B $7E
        %Set16bit(!MX)
        LDY.W #$0018
        LDA.B [$CC],Y
        CMP.B $7E
        BEQ .EventScriptBank84_Branch_84830E
        JSL.L GameOBJ_ReinitializeExistingSlotMetadata
        BRA .EventScriptBank84_Branch_84830E

    .EventScriptBank84_Branch_84830A:
        JSL.L GameOBJ_ClearSlotAndReleaseComponents

    .EventScriptBank84_Branch_84830E:
        %Set16bit(!MX)
        LDY.W #$0016
        LDA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$0018
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        AND.B #$E9
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        STA.B [$CC],Y

        RTS

;;;;;;;; Applies signed per-frame velocity from slot offsets $03/$04 into
;;;;;;;; attached object position at offsets $1A/$1C when flag $20 is set.
EventScript_ApplyAttachedObjectVelocity: ;848331
        %Set16bit(!MX)
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        AND.B #$20
        BNE .EventScriptBank84_Branch_848343
        JMP.W .return

    .EventScriptBank84_Branch_848343:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0006
        LDA.B [$CC],Y
        DEC A
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0006
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0006
        LDA.B [$CC],Y
        BNE .return
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0005
        LDA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0006
        STA.B [$CC],Y
        %Set16bit(!M)
        LDA.W #$0000
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0003
        LDA.B [$CC],Y
        BMI .EventScriptBank84_Branch_848385
        BRA .EventScriptBank84_Branch_84838B

    .EventScriptBank84_Branch_848385:
        %Set8bit(!M)
        XBA
        LDA.B #$FF
        XBA

    .EventScriptBank84_Branch_84838B:
        %Set16bit(!M)
        STA.B $7E
        LDA.W #$0000
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0004
        LDA.B [$CC],Y
        BMI .EventScriptBank84_Branch_84839F
        BRA .EventScriptBank84_Branch_8483A5

    .EventScriptBank84_Branch_84839F:
        %Set8bit(!M)
        XBA
        LDA.B #$FF
        XBA

    .EventScriptBank84_Branch_8483A5:
        %Set16bit(!M)
        STA.B $80
        %Set16bit(!MX)
        LDY.W #$001A
        LDA.B [$CC],Y
        CLC
        ADC.B $7E
        %Set16bit(!MX)
        LDY.W #$001A
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$001C
        LDA.B [$CC],Y
        CLC
        ADC.B $80
        %Set16bit(!MX)
        LDY.W #$001C
        STA.B [$CC],Y

    .return: RTS

;;;;;;;; Updates scripted attached-object movement/pattern state.
;;;;;;;; Uses slot timers/direction fields ($05-$0B/$0F) to choose movement,
;;;;;;;; reload visual state when needed and eventually request GameOBJ refresh.
EventScript_UpdateAttachedObjectMotionPattern: ;8483CC
        %Set16bit(!MX)
        %Set8bit(!M)
        LDY.W #$0001
        LDA.B [$CC],Y
        AND.B #$08
        BNE .EventScriptBank84_Branch_8483DC
        JMP.W .return

    .EventScriptBank84_Branch_8483DC:
        LDY.W #$0006
        LDA.B [$CC],Y
        STA.B $92
        LDY.W #$0005
        LDA.B [$CC],Y
        CMP.B $92
        BEQ .EventScriptBank84_Branch_8483EF
        JMP.W .return

    .EventScriptBank84_Branch_8483EF:
        LDY.W #$0008
        LDA.B [$CC],Y
        BNE .EventScriptBank84_Branch_848446
        LDY.W #$0007
        LDA.B [$CC],Y
        LDY.W #$0008
        STA.B [$CC],Y
        LDY.W #$000F
        LDA.B [$CC],Y
        BEQ .EventScriptBank84_Branch_848423
        CMP.B #$01
        BNE .EventScriptBank84_Branch_84840E
        JMP.W .EventScriptBank84_Branch_84852C

    .EventScriptBank84_Branch_84840E:
        CMP.B #$02
        BNE .EventScriptBank84_Branch_848415
        JMP.W .EventScriptBank84_Branch_84858E

    .EventScriptBank84_Branch_848415:
        CMP.B #$04
        BNE .EventScriptBank84_Branch_84841C
        JMP.W .EventScriptBank84_Branch_8485F0

    .EventScriptBank84_Branch_84841C:
        CMP.B #$08
        BNE .EventScriptBank84_Branch_848423
        JMP.W .EventScriptBank84_Branch_848652

    .EventScriptBank84_Branch_848423:
        %Set8bit(!M)
        LDA.B $DE
        CMP.B #$00
        BNE .EventScriptBank84_Branch_84842E
        JMP.W .EventScriptBank84_Branch_84852C

    .EventScriptBank84_Branch_84842E:
        CMP.B #$01
        BNE .EventScriptBank84_Branch_848435
        JMP.W .EventScriptBank84_Branch_84858E

    .EventScriptBank84_Branch_848435:
        CMP.B #$02
        BNE .EventScriptBank84_Branch_84843C
        JMP.W .EventScriptBank84_Branch_8485F0

    .EventScriptBank84_Branch_84843C:
        CMP.B #$03
        BNE .EventScriptBank84_Branch_848443
        JMP.W .EventScriptBank84_Branch_848652

    .EventScriptBank84_Branch_848443:
        JMP.W .EventScriptBank84_Branch_8486B3

    .EventScriptBank84_Branch_848446:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        AND.B #$80
        BEQ .EventScriptBank84_Branch_848456
        JMP.W .EventScriptBank84_Branch_84871D

    .EventScriptBank84_Branch_848456:
        %Set8bit(!M)
        LDY.W #$0002
        LDA.B [$CC],Y
        CMP.B #$00
        BEQ .EventScriptBank84_Branch_848470
        CMP.B #$01
        BEQ .EventScriptBank84_Branch_84849F
        CMP.B #$02
        BEQ .EventScriptBank84_Branch_8484CE
        CMP.B #$03
        BNE .EventScriptBank84_Branch_848470
        JMP.W .EventScriptBank84_Branch_8484FD

    .EventScriptBank84_Branch_848470:
        %Set16bit(!M)
        LDA.W #$0000
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000A
        LDA.B [$CC],Y
        %Set16bit(!M)
        STA.B $7E
        %Set16bit(!MX)
        LDY.W #$001C
        LDA.B [$CC],Y
        STA.B $80
        %Set16bit(!MX)
        LDY.W #$0020
        LDA.B [$CC],Y
        CLC
        ADC.B $7E
        CMP.B $80
        BCS .EventScriptBank84_Branch_84849C
        JMP.W .EventScriptBank84_Branch_8486B3

    .EventScriptBank84_Branch_84849C:
        JMP.W .EventScriptBank84_Branch_84871D

    .EventScriptBank84_Branch_84849F:
        %Set16bit(!M)
        LDA.W #$0000
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000A
        LDA.B [$CC],Y
        %Set16bit(!M)
        STA.B $7E
        %Set16bit(!MX)
        LDY.W #$001C
        LDA.B [$CC],Y
        STA.B $80
        %Set16bit(!MX)
        LDY.W #$0020
        LDA.B [$CC],Y
        SEC
        SBC.B $7E
        CMP.B $80
        BCC .EventScriptBank84_Branch_8484CB
        JMP.W .EventScriptBank84_Branch_8486B3

    .EventScriptBank84_Branch_8484CB:
        JMP.W .EventScriptBank84_Branch_84871D

    .EventScriptBank84_Branch_8484CE:
        %Set16bit(!M)
        LDA.W #$0000
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0009
        LDA.B [$CC],Y
        %Set16bit(!M)
        STA.B $7E
        %Set16bit(!MX)
        LDY.W #$001A
        LDA.B [$CC],Y
        STA.B $80
        %Set16bit(!MX)
        LDY.W #$001E
        LDA.B [$CC],Y
        CLC
        ADC.B $7E
        CMP.B $80
        BCS .EventScriptBank84_Branch_8484FA
        JMP.W .EventScriptBank84_Branch_8486B3

    .EventScriptBank84_Branch_8484FA:
        JMP.W .EventScriptBank84_Branch_84871D

    .EventScriptBank84_Branch_8484FD:
        %Set16bit(!M)
        LDA.W #$0000
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0009
        LDA.B [$CC],Y
        %Set16bit(!M)
        STA.B $7E
        %Set16bit(!MX)
        LDY.W #$001A
        LDA.B [$CC],Y
        STA.B $80
        %Set16bit(!MX)
        LDY.W #$001E
        LDA.B [$CC],Y
        SEC
        SBC.B $7E
        CMP.B $80
        BCC .EventScriptBank84_Branch_848529
        JMP.W .EventScriptBank84_Branch_8486B3

    .EventScriptBank84_Branch_848529:
        JMP.W .EventScriptBank84_Branch_84871D

    .EventScriptBank84_Branch_84852C:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        AND.B #$80
        BNE .EventScriptBank84_Branch_848565
        %Set16bit(!M)
        LDA.W #$0000
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000A
        LDA.B [$CC],Y
        %Set16bit(!M)
        STA.B $7E
        %Set16bit(!MX)
        LDY.W #$001C
        LDA.B [$CC],Y
        STA.B $80
        %Set16bit(!MX)
        LDY.W #$0020
        LDA.B [$CC],Y
        CLC
        ADC.B $7E
        CMP.B $80
        BCS .EventScriptBank84_Branch_848565
        JMP.W .EventScriptBank84_Branch_8486B3

    .EventScriptBank84_Branch_848565:
        %Set8bit(!M)
        LDY.W #$000B
        LDA.B [$CC],Y
        LDY.W #$0005
        STA.B [$CC],Y
        LDY.W #$0006
        STA.B [$CC],Y
        LDY.W #$0003
        LDA.B #$00
        STA.B [$CC],Y
        LDY.W #$0004
        LDA.B #$01
        STA.B [$CC],Y
        LDY.W #$0002
        LDA.B #$00
        STA.B [$CC],Y
        JMP.W .EventScriptBank84_Branch_8486F4

    .EventScriptBank84_Branch_84858E:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        AND.B #$80
        BNE .EventScriptBank84_Branch_8485C7
        %Set16bit(!M)
        LDA.W #$0000
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000A
        LDA.B [$CC],Y
        %Set16bit(!M)
        STA.B $7E
        %Set16bit(!MX)
        LDY.W #$001C
        LDA.B [$CC],Y
        STA.B $80
        %Set16bit(!MX)
        LDY.W #$0020
        LDA.B [$CC],Y
        SEC
        SBC.B $7E
        CMP.B $80
        BCC .EventScriptBank84_Branch_8485C7
        JMP.W .EventScriptBank84_Branch_8486B3

    .EventScriptBank84_Branch_8485C7:
        %Set8bit(!M)
        LDY.W #$000B
        LDA.B [$CC],Y
        LDY.W #$0005
        STA.B [$CC],Y
        LDY.W #$0006
        STA.B [$CC],Y
        LDY.W #$0003
        LDA.B #$00
        STA.B [$CC],Y
        LDY.W #$0004
        LDA.B #$FF
        STA.B [$CC],Y
        LDY.W #$0002
        LDA.B #$01
        STA.B [$CC],Y
        JMP.W .EventScriptBank84_Branch_8486F4

    .EventScriptBank84_Branch_8485F0:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        AND.B #$80
        BNE .EventScriptBank84_Branch_848629
        %Set16bit(!M)
        LDA.W #$0000
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0009
        LDA.B [$CC],Y
        %Set16bit(!M)
        STA.B $7E
        %Set16bit(!MX)
        LDY.W #$001A
        LDA.B [$CC],Y
        STA.B $80
        %Set16bit(!MX)
        LDY.W #$001E
        LDA.B [$CC],Y
        CLC
        ADC.B $7E
        CMP.B $80
        BCS .EventScriptBank84_Branch_848629
        JMP.W .EventScriptBank84_Branch_8486B3

    .EventScriptBank84_Branch_848629:
        %Set8bit(!M)
        LDY.W #$000B
        LDA.B [$CC],Y
        LDY.W #$0005
        STA.B [$CC],Y
        LDY.W #$0006
        STA.B [$CC],Y
        LDY.W #$0003
        LDA.B #$01
        STA.B [$CC],Y
        LDY.W #$0004
        LDA.B #$00
        STA.B [$CC],Y
        LDY.W #$0002
        LDA.B #$02
        STA.B [$CC],Y
        JMP.W .EventScriptBank84_Branch_8486F4

    .EventScriptBank84_Branch_848652:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        AND.B #$80
        BNE .EventScriptBank84_Branch_84868B
        %Set16bit(!M)
        LDA.W #$0000
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0009
        LDA.B [$CC],Y
        %Set16bit(!M)
        STA.B $7E
        %Set16bit(!MX)
        LDY.W #$001A
        LDA.B [$CC],Y
        STA.B $80
        %Set16bit(!MX)
        LDY.W #$001E
        LDA.B [$CC],Y
        SEC
        SBC.B $7E
        CMP.B $80
        BCC .EventScriptBank84_Branch_84868B
        JMP.W .EventScriptBank84_Branch_8486B3

    .EventScriptBank84_Branch_84868B:
        %Set8bit(!M)
        LDY.W #$000B
        LDA.B [$CC],Y
        LDY.W #$0005
        STA.B [$CC],Y
        LDY.W #$0006
        STA.B [$CC],Y
        LDY.W #$0003
        LDA.B #$FF
        STA.B [$CC],Y
        LDY.W #$0004
        LDA.B #$00
        STA.B [$CC],Y
        LDY.W #$0002
        LDA.B #$03
        STA.B [$CC],Y
        BRA .EventScriptBank84_Branch_8486F4

    .EventScriptBank84_Branch_8486B3:
        %Set8bit(!M)
        LDY.W #$0003
        LDA.B #$00
        STA.B [$CC],Y
        LDY.W #$0004
        LDA.B #$00
        STA.B [$CC],Y
        LDY.W #$0008
        LDA.B #$00
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$0033
        LDA.B [$CC],Y
        STA.B $72
        %Set8bit(!M)
        LDA.B #$B3
        STA.B $74
        JSL.L EventScript_LoadAttachedObjectVisualState
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        ORA.B #$04
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        STA.B [$CC],Y
        JMP.W .return

    .EventScriptBank84_Branch_8486F4:
        %Set16bit(!MX)
        LDY.W #$0036
        LDA.B [$CC],Y
        STA.B $72
        %Set8bit(!M)
        LDA.B #$B3
        STA.B $74
        JSL.L EventScript_LoadAttachedObjectVisualState
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        ORA.B #$04
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        STA.B [$CC],Y
        BRA .EventScriptBank84_Branch_848730

    .EventScriptBank84_Branch_84871D:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0008
        LDA.B [$CC],Y
        DEC A
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0008
        STA.B [$CC],Y

    .EventScriptBank84_Branch_848730:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0003
        LDA.B [$CC],Y
        BNE .EventScriptBank84_Branch_848749
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0004
        LDA.B [$CC],Y
        BNE .EventScriptBank84_Branch_848749
        JMP.W .return

    .EventScriptBank84_Branch_848749:
        %Set16bit(!M)
        %Set16bit(!MX)
        LDY.W #$001A
        LDA.B [$CC],Y
        STA.B $DF
        %Set16bit(!MX)
        LDY.W #$001C
        LDA.B [$CC],Y
        STA.B $E1
        LDA.W #$0000
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0003
        LDA.B [$CC],Y
        BMI .EventScriptBank84_Branch_84876D
        BRA .EventScriptBank84_Branch_848772

    .EventScriptBank84_Branch_84876D:
        %Set8bit(!M)
        EOR.B #$FF
        INC A

    .EventScriptBank84_Branch_848772:
        %Set16bit(!M)
        STA.B $E5
        LDA.W #$0000
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0004
        LDA.B [$CC],Y
        BMI .EventScriptBank84_Branch_848786
        BRA .EventScriptBank84_Branch_84878B

    .EventScriptBank84_Branch_848786:
        %Set8bit(!M)
        EOR.B #$FF
        INC A

    .EventScriptBank84_Branch_84878B:
        %Set16bit(!M)
        STA.B $E7
        STZ.B $E3
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        AND.B #$80
        BEQ .EventScriptBank84_Branch_8487E3
        %Set16bit(!M)
        LDA.W #$0000
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0002
        LDA.B [$CC],Y
        %Set16bit(!M)
        JSL.L Collision_CheckObjectOverlapAtDirection
        %Set16bit(!M)
        PHA
        LDA.B $E9
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000E
        STA.B [$CC],Y
        %Set16bit(!M)
        PLA
        CMP.W #$0000
        BEQ .EventScriptBank84_Branch_8487CB
        JMP.W .EventScriptBank84_Branch_848817

    .EventScriptBank84_Branch_8487CB:
        LDA.B $E9
        CMP.W #$00FF
        BEQ .EventScriptBank84_Branch_848817
        CMP.W #$00E1
        BEQ .EventScriptBank84_Branch_848854
        CMP.W #$00C0
        BCC .EventScriptBank84_Branch_8487E3
        CMP.W #$00D0
        BCS .EventScriptBank84_Branch_8487E3
        BRA .EventScriptBank84_Branch_848817

    .EventScriptBank84_Branch_8487E3:
        %Set16bit(!M)
        LDA.B $EB
        CMP.W #$00FF
        BEQ .EventScriptBank84_Branch_848817
        CMP.W #$00E1
        BEQ .EventScriptBank84_Branch_848868
        CMP.W #$00C0
        BCC .EventScriptBank84_Branch_8487FD
        CMP.W #$00D0
        BCS .EventScriptBank84_Branch_8487FD
        BRA .EventScriptBank84_Branch_848817

    .EventScriptBank84_Branch_8487FD:
        %Set16bit(!M)
        LDA.W #$0000
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0002
        LDA.B [$CC],Y
        %Set16bit(!M)
        JSL.L CDDDD
        CMP.W #$0000
        BNE .EventScriptBank84_Branch_848817

    .return: RTS

    .EventScriptBank84_Branch_848817:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0003
        LDA.B #$00
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0004
        LDA.B #$00
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000B
        LDA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0005
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0006
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000F
        LDA.B #$00
        STA.B [$CC],Y

        RTS

    .EventScriptBank84_Branch_848854:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        LDA.B [$CC],Y
        CMP.B #$24
        BCS .EventScriptBank84_Branch_848817
        CMP.B #$18
        BCC .EventScriptBank84_Branch_848817
        JMP.W .EventScriptBank84_Branch_8487E3

    .EventScriptBank84_Branch_848868:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        LDA.B [$CC],Y
        CMP.B #$24
        BCS .EventScriptBank84_Branch_848817
        CMP.B #$18
        BCC .EventScriptBank84_Branch_848817
        JMP.W .EventScriptBank84_Branch_8487FD

;;;;;;;; Param in A: EventScript slot index.
;;;;;;;; Sets $CC-$CE to $7E:B586 + index*$40. Each slot stores script state,
;;;;;;;; motion parameters and optional GameOBJ attachment metadata.
EventScript_SetCCPointerBySlot: ;84887C
        %Set16bit(!MX)
        ASL A
        ASL A
        ASL A
        ASL A
        ASL A
        ASL A                                ;a << 6 (*64)
        STA.B $7E
        LDA.W #$B586                         ;startin from here
        CLC
        ADC.B $7E
        STA.B $CC
        %Set8bit(!M)
        LDA.B #$7E                           ;7EB586 + a <<6
        STA.B $CE

        RTL

;;;;;;;; Loads object visual state from a B3 triplet table selected by slot offset $02.
;;;;;;;; Writes sprite/animation state to slot offsets $16 and $14.
EventScript_LoadAttachedObjectVisualState: ;848895
        %Set16bit(!MX)
        %Set8bit(!M)
        LDA.B #$00
        XBA
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0002
        LDA.B [$CC],Y
        %Set16bit(!M)
        STA.B $7E
        ASL A
        CLC
        ADC.B $7E
        TAY
        %Set16bit(!M)
        LDA.B [$72],Y
        PHY
        %Set16bit(!MX)
        LDY.W #$0016
        STA.B [$CC],Y
        PLY
        INY
        INY
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B [$72],Y
        %Set16bit(!M)
        ASL A
        ASL A
        ASL A
        ASL A
        ASL A
        ASL A
        %Set16bit(!MX)
        LDY.W #$0014
        STA.B [$CC],Y

        RTL

;;;;;;;; Resets some important variables of the structure and sets it as used
;;;;;;;; CC must be set
ResetsCurrentCCStructureLong: ;8488D4
        %Set16bit(!MX)
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W !CCSTRUCT_USED
        LDA.B #$01
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B #$00
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000F
        LDA.B #$00
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0003
        LDA.B #$00
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0004
        LDA.B #$00
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0005
        LDA.B #$00
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0006
        LDA.B #$00
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000C
        LDA.B #$00
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$0010
        LDA.W #$0000
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$001A
        LDA.W #$0000
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$001C
        LDA.W #$0000
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$0012
        LDA.W #$0000
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$0014
        LDA.W #$0000
        STA.B [$CC],Y

        RTS

;;;;;;;; Resets less variables than the previous subrutine
;;;;;;;; CC must be set
ResetsCurrentCCStructureShort: ;848961
        %Set16bit(!MX)
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W !CCSTRUCT_USED
        LDA.B #$01
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B #$01
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000F
        LDA.B #$00
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0003
        LDA.B #$00
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0004
        LDA.B #$00
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0005
        LDA.B #$00
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0006
        LDA.B #$00
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$0010
        LDA.W #$0000
        STA.B [$CC],Y

        RTS

;;;;;;;;
EventCmd_00_SetAudioControlByte: ;8489BB
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.W $0110
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_01_EnableTimeFlow: ;8489E3
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B #$01
        STA.W !time_running
        %Set16bit(!M)
        LDA.L $7F1F5C
        AND.W #$FFFE                         ;FLAG5C
        STA.L $7F1F5C
        LDA.W $0196
        ORA.W #$0020                         ;FLAG196
        STA.W $0196

        RTS

;;;;;;;;
EventCmd_02_StopTimeFlow: ;808A0D
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B #$00
        STA.W !time_running
        %Set16bit(!M)
        LDA.L $7F1F5C
        ORA.W #$0001                         ;FLAG5C
        STA.L $7F1F5C
        %Set16bit(!MX)
        LDA.W $0196
        AND.W #$FFDF                         ;FLAG196
        STA.W $0196

        RTS

;;;;;;;;
EventCmd_03_SetHour: ;848A39
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.L !hour
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_04_Nop: ;848A58
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9

        RTS

EventCmd_05_SetPlayerPosition: ;848A65
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        LDA.B [$C9]
        STA.W !transition_dest_X
        STA.B !player_pos_X
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        LDA.B [$C9]
        STA.W !transition_dest_Y
        STA.B !player_pos_Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9

        RTS

EventCmd_06_SetTransitionDestination: ;848A94
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.W !transition_dest
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!MX)
        LDY.W #$0010
        LDA.B [$CC],Y
        CLC
        ADC.W #$0001
        STA.B [$CC],Y

        RTS

;;;;;;;;
EventCmd_07_SetPlayerDirection: ;848ABF
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B [$C9]
        %Set16bit(!M)
        STA.B !player_direction
        STA.W $0911
        STA.W $0901
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_08_SetGameStateControl: ;848AE7
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!MX)
        LDA.W #$4000
        EOR.W #$FFFF                         ;FLAGD2
        AND.B !game_state
        STA.B !game_state
        %Set16bit(!M)
        STZ.W $08FD
        STZ.W $08FF

        RTS

;;;;;;;;
EventCmd_09_StartNestedScriptSlot: ;848B08
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        LDA.B $CC
        STA.B $72
        %Set8bit(!M)
        LDA.B $CE
        STA.B $74
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0032
        LDA.B [$CC],Y
        %Set8bit(!M)
        PHA
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B [$C9]
        %Set16bit(!M)
        JSL.L EventScript_SetCCPointerBySlot
        %Set8bit(!M)
        %Set16bit(!X)
        PLA
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0032
        STA.B [$CC],Y
        %Set8bit(!M)
        LDA.B [$C9]
        PHA
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        LDA.B [$C9]
        %Set16bit(!MX)
        LDY.W #$0030
        STA.B [$CC],Y
        JSR.W ResetsCurrentCCStructureLong
        %Set8bit(!M)
        PLA
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        STA.B [$CC],Y
        %Set16bit(!M)
        LDA.B $72
        STA.B $CC
        %Set8bit(!M)
        LDA.B $74
        STA.B $CE
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_0A_ScreenFadeIn: ;848B83
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B #$03
        STA.B $92
        LDA.B #$03
        STA.B $93
        LDA.B #$0F
        STA.B $94
        JSL.L VideoFade_In

        RTS

;;;;;;;;
EventCmd_0B_SetSlotLocalFlag7A: ;848BAC
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B [$C9]
        %Set16bit(!M)
        ASL A
        TAX
        %Set16bit(!M)
        LDA.L Events_Flags_Table,X
        ORA.L $7F1F7A                        ;FLAG7A
        STA.L $7F1F7A
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_0C_TestSlotLocalFlag7A:;848BDC
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B [$C9]
        %Set16bit(!M)
        ASL A
        TAX
        %Set16bit(!M)
        LDA.L Events_Flags_Table,X
        AND.L $7F1F7A                        ;FLAG7A
        BEQ .EventScriptBank84_Branch_848C0A
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9

        RTS

    .EventScriptBank84_Branch_848C0A:
        %Set16bit(!MX)
        LDA.B $C9
        SEC
        SBC.W #$0001
        STA.B $C9
        %Set16bit(!MX)
        LDY.W #$0010
        LDA.B [$CC],Y
        CLC
        ADC.W #$0001
        STA.B [$CC],Y

        RTS

;;;;;;;;
EventCmd_0D_SetSlotStateAndDelay: ;848C22
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0003
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0004
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0010
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0005
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0006
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        ORA.B #$20
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_0E_AudioCommandShort: ;848CA8
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        JSL.L AudioBGM_FadeOutPreviousTrackFast

        RTS

;;;;;;;;
EventCmd_0F_ScreenFadeOut: ;848CB9
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B #$0F
        STA.B $92
        LDA.B #$03
        STA.B $93
        LDA.B #$00
        STA.B $94
        JSL.L VideoFade_Out

        RTS

;;;;;;;;
EventCmd_10_DisableScriptSlot:;848CE2
        %Set16bit(!MX)
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0000
        LDA.B #$00
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$0010
        LDA.B [$CC],Y
        CLC
        ADC.W #$0001
        STA.B [$CC],Y

        RTS

;;;;;;;;
EventCmd_11_SetGameStateControl2: ;848CFD
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!MX)
        LDA.B !game_state
        ORA.W #$4000                         ;FLAGD2
        STA.B !game_state

        RTS

;;;;;;;;
EventCmd_12_Jump: ;848D13
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        LDA.B [$C9]
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_13_SetWaitTimer: ;848D24
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        LDA.B [$C9]
        %Set16bit(!MX)
        LDY.W #$0010
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_14_JumpIfFlagSet: ;848D44
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $72
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.B $74
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B [$C9]
        %Set16bit(!M)
        ASL A
        TAX
        LDA.L Events_Flags_Table,X
        STA.B $7E
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$72]
        AND.B $7E
        BEQ .flagnotset
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $C9

        RTS

    .flagnotset:
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_15_JumpIfByteEquals: ;848DA5
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $72
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.B $74
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.B $92
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$72]
        CMP.B $92
        BNE .numberdifferent
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $C9

        RTS

    .numberdifferent:
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_16_JumpIfByteBetween: ;848DFB
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $72
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.B $74
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.B $92
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        INC A
        STA.B $93
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$72]
        CMP.B $92
        BCC .boundry
        LDA.B [$72]
        CMP.B $93
        BCS .boundry
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $C9

        RTS

    .boundry:
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_17_RNG_GetNextByte: ;848E68
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        JSL.L RNG_GetRange0ToAExclusiveStyle
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000D
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_18_JumpIfRNGEquals: ;848E90
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        LDA.B [$C9]
        STA.B $92
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000D
        LDA.B [$CC],Y
        CMP.B $92
        BNE .notequal
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $C9

        RTS

    .notequal:
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0003
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_19_SetAnimationState: ;848EC9
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        LDA.B [$C9]
        STA.W $0901                          ;player action copy?
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B [$C9]
        %Set16bit(!M)
        ASL A
        ASL A
        ASL A
        ASL A
        ASL A
        ASL A
        STA.W $090F
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!MX)
        LDA.B !game_state
        ORA.W #$2000                         ;FLAGD2
        STA.B !game_state

        RTS

;;;;;;;; first 2 are stored in CC$1A, next 2 in CC$1C, next 2 in CC$33, final 1 in CC$02.
;;;;;;;; increases CC$10 by one, calls function that sets a pointer, sets CC$10 by one
EventCmd_1A_SetSlotObjectMotionParams: ;848F0A
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        LDA.B [$C9]
        %Set16bit(!MX)
        LDY.W #$001A
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        LDA.B [$C9]
        %Set16bit(!MX)
        LDY.W #$001C
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        LDA.B [$C9]
        %Set16bit(!MX)
        LDY.W #$0033
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0002
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        ORA.B #$03
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$0033
        LDA.B [$CC],Y
        STA.B $72
        %Set8bit(!M)
        LDA.B #$B3
        STA.B $74
        JSL.L EventScript_LoadAttachedObjectVisualState
        %Set16bit(!MX)
        LDY.W #$0010
        LDA.B [$CC],Y
        CLC
        ADC.W #$0001
        STA.B [$CC],Y

        RTS

;;;;;;;;
EventCmd_1B_SetSlotObjectState: ;848F9B
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        LDA.B [$C9]
        %Set16bit(!MX)
        LDY.W #$0016
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B [$C9]
        %Set16bit(!M)
        ASL A
        ASL A
        ASL A
        ASL A
        ASL A
        ASL A
        %Set16bit(!MX)
        LDY.W #$0014
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        ORA.B #$04
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        STA.B [$CC],Y

        RTS

;;;;;;;;
EventCmd_1C_StartTextBox: ;848FEF
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        TAX
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.W $0191
        %Set8bit(!M)
        LDA.B #$02
        STA.W !inputstate
        JSL.L TextBox_StartByTextId
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!MX)
        LDY.W #$0010
        LDA.B [$CC],Y
        CLC
        ADC.W #$0001
        STA.B [$CC],Y

        RTS

;;;;;;;;
EventCmd_1D_StartTextBoxCopy: ;849034
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        TAX
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.W $0191
        %Set8bit(!M)
        LDA.B #$02
        STA.W !inputstate
        JSL.L TextBox_StartByTextId
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!MX)
        LDY.W #$0010
        LDA.B [$CC],Y
        CLC
        ADC.W #$0001
        STA.B [$CC],Y

        RTS

;;;;;;;;
EventCmd_1E_SetSlotState: ;809079
EventCmd_1F_SetSlotStateDuplicate:
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000C
        LDA.B [$CC],Y
        CMP.B #$00
        BNE .EventScriptBank84_Branch_849095
        JMP.W .EventScriptBank84_Branch_849185

    .EventScriptBank84_Branch_849095:
        %Set16bit(!MX)
        LDA.B !player_action
        CMP.W #$000A                         ;Using Tool
        BNE .EventScriptBank84_Branch_8490A1
        JMP.W .EventScriptBank84_Branch_849185

    .EventScriptBank84_Branch_8490A1:
        %Set16bit(!MX)
        LDA.B !player_action
        CMP.W #$000C                         ;Showing Tool
        BNE .EventScriptBank84_Branch_8490AD
        JMP.W .EventScriptBank84_Branch_849185

    .EventScriptBank84_Branch_8490AD:
        %Set16bit(!MX)
        LDA.B !player_action
        CMP.W #$000D                         ;whistle horse
        BNE .EventScriptBank84_Branch_8490B9
        JMP.W .EventScriptBank84_Branch_849185

    .EventScriptBank84_Branch_8490B9:
        %Set16bit(!MX)
        LDA.B !player_action
        CMP.W #$001B                         ;whistle dog
        BNE .EventScriptBank84_Branch_8490C5
        JMP.W .EventScriptBank84_Branch_849185

    .EventScriptBank84_Branch_8490C5:
        %Set16bit(!M)
        LDA.B !game_state
        AND.W #$0004                         ;item on hand
        BEQ .EventScriptBank84_Branch_8490D1
        JMP.W .EventScriptBank84_Branch_849185

    .EventScriptBank84_Branch_8490D1:
        LDA.L $7F1F60
        AND.W #$0006                         ;
        BEQ .EventScriptBank84_Branch_8490DD
        JMP.W .EventScriptBank84_Branch_849185

    .EventScriptBank84_Branch_8490DD:
        %Set16bit(!M)
        LDA.W !Joy1_New_Input
        BIT.W #$0080                         ;A Key
        BNE .EventScriptBank84_Branch_8490EA
        JMP.W .EventScriptBank84_Branch_849185

    .EventScriptBank84_Branch_8490EA:
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $C9
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0007
        LDA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0008
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0003
        LDA.B #$00
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0004
        LDA.B #$00
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000C
        LDA.B #$00
        STA.B [$CC],Y
        %Set16bit(!M)
        LDA.B !player_direction
        EOR.W #$0001
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0002
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$0033
        LDA.B [$CC],Y
        STA.B $72
        %Set8bit(!M)
        LDA.B #$B3
        STA.B $74
        JSL.L EventScript_LoadAttachedObjectVisualState
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        ORA.B #$14
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        STA.B [$CC],Y
        %Set8bit(!M)
        LDA.B #$56
        STA.W $096E
        STZ.W $096F
        STZ.W $0970
        %Set16bit(!MX)
        LDA.B !game_state
        ORA.W #$0040                         ;FLAGD2
        STA.B !game_state
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set16bit(!MX)
        LDY.W #$0010
        LDA.B [$CC],Y
        CLC
        ADC.W #$0001
        STA.B [$CC],Y

        RTS

    .EventScriptBank84_Branch_849185:
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set16bit(!MX)
        LDY.W #$0010
        LDA.B [$CC],Y
        CLC
        ADC.W #$0001
        STA.B [$CC],Y

        RTS

;;;;;;;;
EventCmd_20_JumpIfPromptValueEquals: ;84919D
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.B $92
        LDA.W $018F
        CMP.B $92
        BNE .EventScriptBank84_Branch_8491C7
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $C9

        RTS

    .EventScriptBank84_Branch_8491C7:
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0003
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_21_TextBoxRelatedControl: ;8091D2
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $72
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.B $74
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B [$C9]
        BPL .EventScriptBank84_Branch_84920B
        XBA
        LDA.B #$FF
        XBA

    .EventScriptBank84_Branch_84920B:
        %Set16bit(!M)
        STA.B $7E
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B [$72]
        %Set16bit(!M)
        CLC
        ADC.B $7E
        BMI .EventScriptBank84_Branch_849232
        CMP.W #$00FF
        BCC .EventScriptBank84_Branch_849238
        %Set8bit(!M)
        LDA.B #$FF
        BRA .EventScriptBank84_Branch_849238

    .EventScriptBank84_Branch_849232:
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$00

    .EventScriptBank84_Branch_849238:
        %Set8bit(!M)
        %Set16bit(!X)
        STA.B [$72]

        RTS

;;;;;;;;
EventCmd_22_SetSlotObjectAndPositionState: ;84923F
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0009
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000A
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000B
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0005
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0006
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        LDA.B [$C9]
        %Set16bit(!MX)
        LDY.W #$0036
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0007
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0008
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        ORA.B #$28
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$001A
        LDA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$001E
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$001C
        LDA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$0020
        STA.B [$CC],Y

        RTS

;;;;;;;;
EventCmd_23_SetFlag: ;849306
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $72
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.B $74
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B [$C9]
        %Set16bit(!M)
        ASL A
        TAX
        LDA.L Events_Flags_Table,X
        STA.B $7E
        %Set16bit(!M)
        LDA.B [$72]
        ORA.B $7E
        STA.B [$72]
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_24_SetTimeOfDayPalette: ;849356
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        JSL.L PaletteTransition_BeginTimeOfDayFade
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_25_SetSlotStateFlag: ;849375
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        LDA.B $CC
        STA.B $72
        %Set8bit(!M)
        LDA.B $CE
        STA.B $74
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B [$C9]
        %Set16bit(!M)
        JSL.L EventScript_SetCCPointerBySlot
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!MX)
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0000
        LDA.B #$00
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$0012
        LDA.B [$CC],Y
        STA.B $A5
        JSL.L GameOBJ_ClearSlotAndReleaseComponents
        %Set16bit(!M)
        LDA.B $72
        STA.B $CC
        %Set8bit(!M)
        LDA.B $74
        STA.B $CE

        RTS

;;;;;;;;
EventCmd_26_ResetFlag: ;8093C9
EventCmd_27_ResetFlagAlias:
EventCmd_28_ResetFlagAlias:
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $72
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.B $74
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.B [$C9]
        %Set16bit(!M)
        ASL A
        TAX
        LDA.L Events_Inverse_Flags_Tables,X
        STA.B $7E
        %Set16bit(!M)
        LDA.B [$72]
        AND.B $7E
        STA.B [$72]
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9

        RTS

EventInstructionPointers: ;849419
dw $89BB,$89E3,$8A0D,$8A39,$8A58,$8A65,$8A94,$8ABF
dw $8AE7,$8B08,$8B83,$8BAC,$8BDC,$8C22,$8CA8,$8CB9
dw $8CE2,$8CFD,$8D13,$8D24,$8D44,$8DA5,$8DFB,$8E68
dw $8E90,$8EC9,$8F0A,$8F9B,$8FEF,$9034,$9079,$9079
dw $919D,$91D2,$923F,$9306,$9356,$9375,$93C9,$93C9
dw $93C9,$9513,$9553,$957D,$95E8,$9633,$9777,$9810
dw $9857,$9AD4,$A90F,$A94C,$AA5D,$AB27,$AF06,$B34B
dw $B365,$B389,$B427,$B4DC,$B503,$B52D,$B556,$B57B
dw $B58F,$B5A9,$B602,$B666,$B6BC,$B72D,$B79A,$B84C
dw $B889,$B8D9,$B93C,$BA10,$BA51,$BA72,$BB31,$BB4B
dw $BBDA,$BC9C,$BD44,$BE0D,$BED6,$BF20,$BF81,$BFA0
dw $BFBF,$C000
;dw EventCmd_00_SetAudioControlByte                ;00;89BB
;dw EventCmd_01_EnableTimeFlow                     ;01;89E3
;dw EventCmd_02_StopTimeFlow                       ;02;8A0D
;dw EventCmd_03_SetHour                            ;03;8A39
;dw EventCmd_04_Nop                                ;04;8A58
;dw EventCmd_05_SetPlayerPosition                  ;05;8A65
;dw EventCmd_06_SetTransitionDestination           ;06;8A94
;dw EventCmd_07_SetPlayerDirection                 ;07;8ABF
;dw EventCmd_08_SetGameStateControl                ;08;8AE7
;dw EventCmd_09_StartNestedScriptSlot              ;09;8B08
;dw EventCmd_0A_ScreenFadeIn                       ;0A;8B83
;dw EventCmd_0B_SetSlotLocalFlag7A                 ;0B;8BAC
;dw EventCmd_0C_TestSlotLocalFlag7A                ;0C;8BDC
;dw EventCmd_0D_SetSlotStateAndDelay               ;0D;8C22
;dw EventCmd_0E_AudioCommandShort                  ;0E;8CA8
;dw EventCmd_0F_ScreenFadeOut                      ;0F;8CB9

;dw EventCmd_10_DisableScriptSlot                  ;10;8CE2
;dw EventCmd_11_SetGameStateControl2               ;11;8CFD
;dw EventCmd_12_Jump                               ;12;8D13
;dw EventCmd_13_SetWaitTimer                       ;13;8D24
;dw EventCmd_14_JumpIfFlagSet                      ;14;8D44
;dw EventCmd_15_JumpIfByteEquals                   ;15;8DA5
;dw EventCmd_16_JumpIfByteBetween                  ;16;8DFB
;dw EventCmd_17_RNG_GetNextByte                    ;17;8E68
;dw EventCmd_18_JumpIfRNGEquals                    ;18;8E90
;dw EventCmd_19_SetAnimationState                  ;19;8EC9
;dw EventCmd_1A_SetSlotObjectMotionParams          ;1A;8F0A
;dw EventCmd_1B_SetSlotObjectState                 ;1B;8F9B
;dw EventCmd_1C_StartTextBox                       ;1C;8FEF
;dw EventCmd_1D_StartTextBoxCopy                   ;1D;9034
;dw EventCmd_1E_SetSlotState                       ;1E;9079
;dw EventCmd_1F_SetSlotStateDuplicate              ;1F;9079

;dw EventCmd_20_JumpIfPromptValueEquals            ;20;919D
;dw EventCmd_21_TextBoxRelatedControl              ;21;91D2
;dw EventCmd_22_SetSlotObjectAndPositionState      ;22;923F
;dw EventCmd_23_SetFlag                            ;23;9306
;dw EventCmd_24_SetTimeOfDayPalette                ;24;9356
;dw EventCmd_25_SetSlotStateFlag                   ;25;9375
;dw EventCmd_26_ResetFlag                          ;26;93C9
;dw EventCmd_27_ResetFlagAlias                     ;27;93C9
;dw EventCmd_28_ResetFlagAlias                     ;28;93C9
;dw EventCmd_29_MapScrolling                       ;29;9513
;dw EventCmd_2A_SetScrollOrCameraFlag              ;2A;9553
;dw EventCmd_2B_SetSlotObjectPosition              ;2B;957D
;dw EventCmd_2C_AudioCommandLong                   ;2C;95E8
;dw EventCmd_2D_SetSlotObjectMotion                ;2D;9633
;dw EventCmd_2E_SetSlotExtendedState               ;2E;9777
;dw EventCmd_2F_SetSlotShortState                  ;2F;9810

;dw EventCmd_30_ChickenRelated                     ;30;9857
;dw EventCmd_31_CowRelated                         ;31;9AD4
;dw EventCmd_32_StoreValue                         ;32;A90F
;dw EventCmd_33_PickupMoleRelated                  ;33;A94C
;dw EventCmd_34_FishingRelated                     ;34;AA5D
;dw EventCmd_35_PlayerPositionCheck                ;35;AB27
;dw EventCmd_36_DogRelated                         ;36;AF06
;dw EventCmd_37_ClearAttachedObjectSlot            ;37;B34B
;dw EventCmd_38_WaitForFieldMenuGateFlag           ;38;B365
;dw EventCmd_39_SetSlotState12                     ;39;B389
;dw EventCmd_3A_SetSlotState13                     ;3A;B427
;dw EventCmd_3B_ChangeItemOnHand                   ;3B;B4DC
;dw EventCmd_3C_TransitionToHouse                  ;3C;B503
;dw EventCmd_3D_TransitionToArea                   ;3D;B52D
;dw EventCmd_3E_SetItemOnHand                      ;3E;B556
;dw EventCmd_3F_DropItemAnimation                  ;3F;B57B

;dw EventCmd_40_SetFlag5CState                     ;40;B58F
;dw EventCmd_41_SetSlotState14                     ;41;B5A9
;dw EventCmd_42_ChangeMoney                        ;42;B602
;dw EventCmd_43_JumpIfWordValueEquals              ;43;B666
;dw EventCmd_44_JumpIfLongValueEquals              ;44;B6BC
;dw EventCmd_45_JumpIfWordValueBetween             ;45;B72D
;dw EventCmd_46_JumpIfLongValueBetween             ;46;B79A
;dw EventCmd_47_SetByteValue                       ;47;B84C
;dw EventCmd_48_SetLongValue                       ;48;B889
;dw EventCmd_49_SetSlotState15                     ;49;B8D9
;dw EventCmd_4A_GiveHeldItem08OnAButton            ;4A;B93C
;dw EventCmd_4B_EditTileOnMap                      ;4B;BA10
;dw EventCmd_4C_SetSlotState16                     ;4C;BA51
;dw EventCmd_4D_SetSlotState17                     ;4D;BA72
;dw EventCmd_4E_ResetFlag5CState                   ;4E;BB31
;dw EventCmd_4F_SetFlag60State                     ;4F;BB4B

;dw EventCmd_50_ChickenRelated2                    ;50;BBDA
;dw EventCmd_51_UseChickenDogOrHeldItemContext     ;51;BC9C
;dw EventCmd_52_WaitForAButtonSetInteractionFlag02 ;52;BD44
;dw EventCmd_53_WaitForAButtonSetInteractionFlag04 ;53;BE0D
;dw EventCmd_54_StartTextBoxAndAdvanceSlot         ;54;BED6
;dw EventCmd_55_JumpIfIndirectBitClear             ;55;BF20
;dw EventCmd_56_StartSelectedToolAction            ;56;BF81
;dw EventCmd_57_ApplyStaminaDelta                  ;57;BFA0
;dw EventCmd_58_EditTileAndSetRuntimeFlag          ;58;BFBF
;dw EventCmd_59_SetPlayerAction1C                  ;59;C000

Events_Bank_Table: ;8494CD
        dl $B38000
        dl $B48000

Events_Flags_Table: ;8494D3
        dw $0001,$0002,$0004,$0008,$0010,$0020,$0040,$0080
        dw $0100,$0200,$0400,$0800,$1000,$2000,$4000,$8000

Events_Inverse_Flags_Tables: ;8494F3
        dw $FFFE,$FFFD,$FFFB,$FFF7,$FFEF,$FFDF,$FFBF,$FF7F
        dw $FEFF,$FDFF,$FBFF,$F7FF,$EFFF,$DFFF,$BFFF,$7FFF

;;;;;;;;
EventCmd_29_MapScrolling: ;809513
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        STA.W !map_scrolling_X_speed
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        STA.W !map_scrolling_Y_speed
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.W !map_scrolling_timer
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_2A_SetScrollOrCameraFlag: ;809553
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        LDA.B [$C9]
        JSL.L MapTilePatchScript_StartByIndex
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set16bit(!MX)
        LDY.W #$0010
        LDA.B [$CC],Y
        CLC
        ADC.W #$0001
        STA.B [$CC],Y

        RTS


;;;;;;;;
EventCmd_2B_SetSlotObjectPosition: ;84957D
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        LDA.B [$C9]
        %Set16bit(!MX)
        LDY.W #$0033
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0002
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        ORA.B #$03
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$0033
        LDA.B [$CC],Y
        STA.B $72
        %Set8bit(!M)
        LDA.B #$B3
        STA.B $74
        JSL.L EventScript_LoadAttachedObjectVisualState
        %Set16bit(!MX)
        LDY.W #$0010
        LDA.B [$CC],Y
        CLC
        ADC.W #$0001
        STA.B [$CC],Y

        RTS

;;;;;;;;
EventCmd_2C_AudioCommandLong: ;8095E8
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        PHA
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        PHA
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        TAY
        PLX
        %Set8bit(!M)
        PLA
        JSL.L AudioSFX_PlayEffectIdWithDuration
        %Set8bit(!M)
        STZ.W $0119
        JSL.L AudioTool_PlayToolUseSoundIfEnabled
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_2D_SetSlotObjectMotion: ;809633
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000C
        LDA.B [$CC],Y
        CMP.B #$00
        BNE .EventScriptBank84_Branch_84964F
        JMP.W .EventScriptBank84_Branch_84975F

    .EventScriptBank84_Branch_84964F:
        %Set16bit(!MX)
        LDA.B !player_action
        CMP.W #$000A
        BNE .EventScriptBank84_Branch_84965B
        JMP.W .EventScriptBank84_Branch_84975F

    .EventScriptBank84_Branch_84965B:
        %Set16bit(!MX)
        LDA.B !player_action
        CMP.W #$000C
        BNE .EventScriptBank84_Branch_849667
        JMP.W .EventScriptBank84_Branch_84975F

    .EventScriptBank84_Branch_849667:
        %Set16bit(!MX)
        LDA.B !player_action
        CMP.W #$000D
        BNE .EventScriptBank84_Branch_849673
        JMP.W .EventScriptBank84_Branch_84975F

    .EventScriptBank84_Branch_849673:
        %Set16bit(!MX)
        LDA.B !player_action
        CMP.W #$001B
        BNE .EventScriptBank84_Branch_84967F
        JMP.W .EventScriptBank84_Branch_84975F

    .EventScriptBank84_Branch_84967F:
        %Set16bit(!M)
        LDA.B !game_state
        AND.W #$0004
        BEQ .EventScriptBank84_Branch_84968B
        JMP.W .EventScriptBank84_Branch_84975F

    .EventScriptBank84_Branch_84968B:
        LDA.L $7F1F60
        AND.W #$0006
        BEQ .EventScriptBank84_Branch_849697
        JMP.W .EventScriptBank84_Branch_84975F

    .EventScriptBank84_Branch_849697:
        %Set16bit(!M)
        LDA.W !Joy1_New_Input
        BIT.W #$0080
        BNE .EventScriptBank84_Branch_8496A4
        JMP.W .EventScriptBank84_Branch_84975F

    .EventScriptBank84_Branch_8496A4:
        %Set16bit(!MX)
        LDA.B !player_action
        CMP.W #$0005
        BEQ .EventScriptBank84_Branch_8496B0
        JMP.W .EventScriptBank84_Branch_8496C4

    .EventScriptBank84_Branch_8496B0:
        %Set8bit(!M)
        LDA.W !item_on_hand
        BEQ .EventScriptBank84_Branch_8496C4
        STA.W !old_item_on_hand
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9

    .EventScriptBank84_Branch_8496C4:
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $C9
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0007
        LDA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0008
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0003
        LDA.B #$00
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0004
        LDA.B #$00
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000C
        LDA.B #$00
        STA.B [$CC],Y
        %Set16bit(!M)
        LDA.B !player_direction
        EOR.W #$0001
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0002
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$0033
        LDA.B [$CC],Y
        STA.B $72
        %Set8bit(!M)
        LDA.B #$B3
        STA.B $74
        JSL.L EventScript_LoadAttachedObjectVisualState
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        ORA.B #$14
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        STA.B [$CC],Y
        %Set8bit(!M)
        LDA.B #$56
        STA.W $096E
        STZ.W $096F
        STZ.W $0970
        %Set16bit(!MX)
        LDA.B !game_state
        ORA.W #$0040
        STA.B !game_state
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set16bit(!MX)
        LDY.W #$0010
        LDA.B [$CC],Y
        CLC
        ADC.W #$0001
        STA.B [$CC],Y

        RTS

    .EventScriptBank84_Branch_84975F:
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0004
        STA.B $C9
        %Set16bit(!MX)
        LDY.W #$0010
        LDA.B [$CC],Y
        CLC
        ADC.W #$0001
        STA.B [$CC],Y

        RTS

;;;;;;;;
EventCmd_2E_SetSlotExtendedState: ;849777
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000B
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0005
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0006
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        LDA.B [$C9]
        %Set16bit(!MX)
        LDY.W #$0036
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0007
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0008
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        ORA.B #$A8
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$001A
        LDA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$001E
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$001C
        LDA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$0020
        STA.B [$CC],Y

        RTS

;;;;;;;;
EventCmd_2F_SetSlotShortState: ;849810
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        LDA.B [$C9]
        %Set16bit(!MX)
        LDY.W #$0033
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set16bit(!MX)
        LDY.W #$0033
        LDA.B [$CC],Y
        STA.B $72
        %Set8bit(!M)
        LDA.B #$B3
        STA.B $74
        JSL.L EventScript_LoadAttachedObjectVisualState
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        ORA.B #$04
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        STA.B [$CC],Y

        RTS

;;;;;;;;
EventCmd_30_ChickenRelated: ;849857
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        LDA.B [$CC],Y
        SEC
        SBC.B #$24
        XBA
        LDA.B #$00
        XBA
        %Set16bit(!M)
        JSL.L GetChickenPointer
        %Set16bit(!MX)
        LDY.W #$001A
        LDA.B [$CC],Y
        LDY.W #$0004
        STA.B [$72],Y
        %Set16bit(!MX)
        LDY.W #$001C
        LDA.B [$CC],Y
        LDY.W #$0006
        STA.B [$72],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000E
        LDA.B [$CC],Y
        CMP.B #$E0
        BNE .EventScriptBank84_Branch_8498A1
        JMP.W .EventScriptBank84_Branch_849A4F

    .EventScriptBank84_Branch_8498A1:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000C
        LDA.B [$CC],Y
        CMP.B #$00
        BNE .EventScriptBank84_Branch_8498B1
        JMP.W .EventScriptBank84_Branch_8499C8

    .EventScriptBank84_Branch_8498B1:
        %Set16bit(!M)
        LDA.B !player_action
        CMP.W #$000A
        BNE .EventScriptBank84_Branch_8498BD
        JMP.W .EventScriptBank84_Branch_8499C8

    .EventScriptBank84_Branch_8498BD:
        CMP.W #$000C
        BNE .EventScriptBank84_Branch_8498C5
        JMP.W .EventScriptBank84_Branch_8499C8

    .EventScriptBank84_Branch_8498C5:
        CMP.W #$000D
        BNE .EventScriptBank84_Branch_8498CD
        JMP.W .EventScriptBank84_Branch_8499C8

    .EventScriptBank84_Branch_8498CD:
        CMP.W #$001B
        BNE .EventScriptBank84_Branch_8498D5
        JMP.W .EventScriptBank84_Branch_8499C8

    .EventScriptBank84_Branch_8498D5:
        LDA.B !game_state
        AND.W #$0004
        BEQ .EventScriptBank84_Branch_8498DF
        JMP.W .EventScriptBank84_Branch_8499C8

    .EventScriptBank84_Branch_8498DF:
        LDA.B !game_state
        AND.W #$0040
        BEQ .EventScriptBank84_Branch_8498E9
        JMP.W .EventScriptBank84_Branch_8499C8

    .EventScriptBank84_Branch_8498E9:
        LDA.L $7F1F60
        AND.W #$0006                         ;FLAG60
        BEQ .EventScriptBank84_Branch_8498F5
        JMP.W .EventScriptBank84_Branch_8499C8

    .EventScriptBank84_Branch_8498F5:
        %Set16bit(!M)
        LDA.W !Joy1_New_Input
        BIT.W #$0080
        BNE .EventScriptBank84_Branch_849902
        JMP.W .EventScriptBank84_Branch_8499C8

    .EventScriptBank84_Branch_849902:
        %Set16bit(!MX)
        LDA.B !game_state
        AND.W #$0800
        BEQ .EventScriptBank84_Branch_84990E
        JMP.W .EventScriptBank84_Branch_8499C8

    .EventScriptBank84_Branch_84990E:
        LDA.B !player_action
        CMP.W #$0017
        BNE .EventScriptBank84_Branch_849918
        JMP.W .EventScriptBank84_Branch_8499C8

    .EventScriptBank84_Branch_849918:
        LDA.B !player_action
        CMP.W #$0004
        BNE .EventScriptBank84_Branch_849922
        JMP.W .EventScriptBank84_Branch_8499C8

    .EventScriptBank84_Branch_849922:
        %Set8bit(!M)
        LDA.W !item_on_hand
        BEQ .EventScriptBank84_Branch_84992C
        JMP.W .EventScriptBank84_Branch_8499C8

    .EventScriptBank84_Branch_84992C:
        %Set8bit(!M)
        LDY.W #$0000
        LDA.B [$72],Y
        AND.B #$40
        BEQ .EventScriptBank84_Branch_84993A
        JMP.W .EventScriptBank84_Branch_849A41

    .EventScriptBank84_Branch_84993A:
        LDA.B [$72],Y
        AND.B #$0E
        BNE .EventScriptBank84_Branch_849943
        JMP.W .EventScriptBank84_Branch_849A41

    .EventScriptBank84_Branch_849943:
        LDA.B [$72],Y
        ORA.B #$20
        STA.B [$72],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        LDA.B [$CC],Y
        STA.W $0920
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0000
        LDA.B #$00
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        ORA.B #$40
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$0010
        LDA.B [$CC],Y
        CLC
        ADC.W #$0001
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        LDA.B [$CC],Y
        CMP.B #$24
        BCS .EventScriptBank84_Branch_849991
        JMP.W .EventScriptBank84_Branch_849A41

    .EventScriptBank84_Branch_849991:
        %Set8bit(!M)
        LDY.W #$0000
        LDA.B [$72],Y
        AND.B #$04
        BEQ .EventScriptBank84_Branch_8499AB
        %Set8bit(!M)
        LDA.B #$26
        STA.W !item_on_hand
        %Set16bit(!MX)
        LDA.W #$0004
        STA.B !player_action

        RTS

    .EventScriptBank84_Branch_8499AB:
        %Set8bit(!M)
        LDY.W #$0000
        LDA.B [$72],Y
        AND.B #$08
        BNE .EventScriptBank84_Branch_8499B9
        JMP.W .EventScriptBank84_Branch_849A41

    .EventScriptBank84_Branch_8499B9:
        %Set8bit(!M)
        LDA.B #$25
        STA.W !item_on_hand
        %Set16bit(!MX)
        LDA.W #$0004
        STA.B !player_action

        RTS

    .EventScriptBank84_Branch_8499C8:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0000
        LDA.B [$72],Y
        AND.B #$08
        BEQ .EventScriptBank84_Branch_849A41
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        LDA.B [$CC],Y
        SEC
        SBC.B #$24
        XBA
        LDA.B #$00
        XBA
        %Set16bit(!M)
        ASL A
        TAX
        LDA.W $093B,X
        CMP.W #$0200
        BEQ .EventScriptBank84_Branch_8499F8
        INC A
        STA.W $093B,X
        JMP.W .EventScriptBank84_Branch_849A41

    .EventScriptBank84_Branch_8499F8:
        %Set16bit(!MX)
        STZ.W $093B,X
        %Set8bit(!M)
        LDA.B $DE
        CMP.B #$55
        BCC .EventScriptBank84_Branch_849A23
        %Set16bit(!MX)
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        LDA.B [$CC],Y
        XBA
        LDA.B #$00
        XBA
        %Set16bit(!M)
        LDX.W #$0000
        LDY.W #$005D
        JSL.L EventScript_LoadScriptPointerShort
        JMP.W .EventScriptBank84_Branch_849A41

    .EventScriptBank84_Branch_849A23:
        %Set16bit(!MX)
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        LDA.B [$CC],Y
        XBA
        LDA.B #$00
        XBA
        %Set16bit(!M)
        LDX.W #$0000
        LDY.W #$005C
        JSL.L EventScript_LoadScriptPointerShort
        JMP.W .EventScriptBank84_Branch_849A41

    .EventScriptBank84_Branch_849A41:
        %Set16bit(!MX)
        LDY.W #$0010
        LDA.B [$CC],Y
        CLC
        ADC.W #$0001
        STA.B [$CC],Y

        RTS

    .EventScriptBank84_Branch_849A4F:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0000
        LDA.B [$72],Y
        AND.B #$08
        BNE .EventScriptBank84_Branch_849A5F
        JMP.W .EventScriptBank84_Branch_8498A1

    .EventScriptBank84_Branch_849A5F:
        %Set16bit(!M)
        LDA.L $7F1F5A
        AND.W #$0008
        BNE .EventScriptBank84_Branch_849A6D
        JMP.W .EventScriptBank84_Branch_8498A1

    .EventScriptBank84_Branch_849A6D:
        LDA.L $7F1F5A
        AND.W #$FFF7                         ;FLAG5A
        STA.L $7F1F5A
        %Set16bit(!M)
        LDA.W #$0032
        STA.L $7F1F15
        %Set8bit(!M)
        LDA.B #$00
        STA.L $7F1F17
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        LDA.B [$CC],Y
        STA.W $09A1
        %Set8bit(!M)
        LDA.B #$44
        STA.W $096E
        STZ.W $096F
        STZ.W $0970
        %Set16bit(!MX)
        LDA.B !game_state
        ORA.W #$0040
        STA.B !game_state
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000E
        LDA.B #$00
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        AND.B #$57
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        STA.B [$CC],Y
        JMP.W .EventScriptBank84_Branch_849A41

;;;;;;;;
EventCmd_31_CowRelated: ;849AD4
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        LDA.B [$CC],Y
        SEC
        SBC.B #$18
        XBA
        LDA.B #$00
        XBA
        %Set16bit(!M)
        JSL.L GetCowPointer
        %Set16bit(!MX)
        LDY.W #$001A
        LDA.B [$CC],Y
        LDY.W #$0008
        STA.B [$72],Y
        %Set16bit(!MX)
        LDY.W #$001C
        LDA.B [$CC],Y
        LDY.W #$000A
        STA.B [$72],Y
        %Set8bit(!M)
        LDA.B !tilemap_to_load
        CMP.B #$27
        BNE .inthebarn
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000E
        LDA.B [$CC],Y
        CMP.B #$C2
        BNE .inthebarn
        JMP.W .EventScriptBank84_Branch_84A595

    .inthebarn:
        %Set8bit(!M)
        LDA.B !tilemap_to_load
        CMP.B #$04
        BCS .EventScriptBank84_Branch_849B45
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000E
        LDA.B [$CC],Y
        CMP.B #$E0
        BNE .EventScriptBank84_Branch_849B3E
        JMP.W .EventScriptBank84_Branch_84A498

    .EventScriptBank84_Branch_849B3E:
        CMP.B #$E1
        BNE .EventScriptBank84_Branch_849B45
        JMP.W .EventScriptBank84_Branch_84A540

    .EventScriptBank84_Branch_849B45:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000C
        LDA.B [$CC],Y
        CMP.B #$00
        BNE .EventScriptBank84_Branch_849B55
        JMP.W .EventScriptBank84_Branch_84A0B9

    .EventScriptBank84_Branch_849B55:
        %Set16bit(!MX)
        LDA.B !player_action
        CMP.W #$000A
        BNE .EventScriptBank84_Branch_849B61
        JMP.W .EventScriptBank84_Branch_84A0B9

    .EventScriptBank84_Branch_849B61:
        %Set16bit(!MX)
        LDA.B !player_action
        CMP.W #$000C
        BNE .EventScriptBank84_Branch_849B6D
        JMP.W .EventScriptBank84_Branch_84A0B9

    .EventScriptBank84_Branch_849B6D:
        %Set16bit(!MX)
        LDA.B !player_action
        CMP.W #$000D
        BNE .EventScriptBank84_Branch_849B79
        JMP.W .EventScriptBank84_Branch_84A0B9

    .EventScriptBank84_Branch_849B79:
        %Set16bit(!MX)
        LDA.B !player_action
        CMP.W #$001B
        BNE .EventScriptBank84_Branch_849B85
        JMP.W .EventScriptBank84_Branch_84A0B9

    .EventScriptBank84_Branch_849B85:
        %Set16bit(!M)
        LDA.B !game_state
        AND.W #$0004
        BEQ .EventScriptBank84_Branch_849B91
        JMP.W .EventScriptBank84_Branch_84A0B9

    .EventScriptBank84_Branch_849B91:
        LDA.B !game_state
        AND.W #$0040
        BEQ .EventScriptBank84_Branch_849B9B
        JMP.W .EventScriptBank84_Branch_84A0B9

    .EventScriptBank84_Branch_849B9B:
        LDA.L $7F1F60
        AND.W #$0006
        BEQ .EventScriptBank84_Branch_849BA7
        JMP.W .EventScriptBank84_Branch_84A0B9

    .EventScriptBank84_Branch_849BA7:
        %Set16bit(!M)
        LDA.W !Joy1_New_Input
        BIT.W #$0080
        BNE .EventScriptBank84_Branch_849BEC
        %Set8bit(!M)
        LDY.W #$0000
        LDA.B [$72],Y
        AND.B #$08
        BNE .EventScriptBank84_Branch_849BBF
        JMP.W .EventScriptBank84_Branch_849BDB

    .EventScriptBank84_Branch_849BBF:
        %Set16bit(!M)
        LDA.L $7F1F5A
        AND.W #$0100
        BEQ .EventScriptBank84_Branch_849BCD
        JMP.W .EventScriptBank84_Branch_849E4E

    .EventScriptBank84_Branch_849BCD:
        %Set16bit(!M)
        LDA.L $7F1F5A
        AND.W #$0080
        BEQ .EventScriptBank84_Branch_849BDB
        JMP.W .EventScriptBank84_Branch_849FBC

    .EventScriptBank84_Branch_849BDB:
        %Set16bit(!M)
        LDA.L $7F1F5A
        AND.W #$0040
        BEQ .EventScriptBank84_Branch_849BE9
        JMP.W .EventScriptBank84_Branch_849DBE

    .EventScriptBank84_Branch_849BE9: JMP.W .EventScriptBank84_Branch_84A0B9

    .EventScriptBank84_Branch_849BEC:
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$00
        XBA
        LDY.W #$000C
        LDA.B [$72],Y
        %Set16bit(!M)
        STA.W $0889
        %Set8bit(!M)
        LDY.W #$000D
        LDA.B [$72],Y
        %Set16bit(!M)
        STA.W $088B
        %Set8bit(!M)
        LDY.W #$000E
        LDA.B [$72],Y
        %Set16bit(!M)
        STA.W $088D
        %Set8bit(!M)
        LDY.W #$000F
        LDA.B [$72],Y
        %Set16bit(!M)
        STA.W $088F
        %Set8bit(!M)
        LDY.W #$0000
        LDA.B [$72],Y
        AND.B #$40
        BNE .EventScriptBank84_Branch_849C4D
        LDA.B [$72],Y
        AND.B #$20
        BNE .EventScriptBank84_Branch_849C46
        LDA.B [$72],Y
        AND.B #$10
        BNE .EventScriptBank84_Branch_849C3F
        %Set16bit(!MX)
        LDX.W #$002F
        BRA .EventScriptBank84_Branch_849C64

    .EventScriptBank84_Branch_849C3F:
        %Set16bit(!MX)
        LDX.W #$0030
        BRA .EventScriptBank84_Branch_849C64

    .EventScriptBank84_Branch_849C46:
        %Set16bit(!MX)
        LDX.W #$0031
        BRA .EventScriptBank84_Branch_849C64

    .EventScriptBank84_Branch_849C4D:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0003
        LDA.B [$72],Y
        BEQ .EventScriptBank84_Branch_849C5D
        LDX.W #$0032
        BRA .EventScriptBank84_Branch_849C64

    .EventScriptBank84_Branch_849C5D:
        %Set16bit(!MX)
        LDX.W #$0145
        BRA .EventScriptBank84_Branch_849C64

    .EventScriptBank84_Branch_849C64:
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$00
        STA.W $0191
        LDA.B #$02
        STA.W !inputstate
        JSL.L TextBox_StartByTextId
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$72],Y
        AND.B #$04
        BEQ .EventScriptBank84_Branch_849C86
        JMP.W .EventScriptBank84_Branch_84A0B9

    .EventScriptBank84_Branch_849C86:
        LDY.W #$0001
        LDA.B [$72],Y
        ORA.B #$04
        STA.B [$72],Y
        %Set16bit(!M)
        LDA.W #$0001
        JSL.L .AddCowHappiness
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0000
        LDA.B [$72],Y
        AND.B #$30
        BEQ .EventScriptBank84_Branch_849CA8
        JMP.W .EventScriptBank84_Branch_84A0B9

    .EventScriptBank84_Branch_849CA8:
        %Set8bit(!M)
        LDY.W #$0000
        LDA.B [$72],Y
        AND.B #$02
        BEQ .EventScriptBank84_Branch_849CB6
        JMP.W .EventScriptBank84_Branch_849CCE

    .EventScriptBank84_Branch_849CB6:
        LDA.B [$72],Y
        AND.B #$04
        BEQ .EventScriptBank84_Branch_849CBF
        JMP.W .EventScriptBank84_Branch_849D46

    .EventScriptBank84_Branch_849CBF:
        LDY.W #$0000
        LDA.B [$72],Y
        AND.B #$40
        BEQ .EventScriptBank84_Branch_849CCB
        JMP.W .EventScriptBank84_Branch_84A044

    .EventScriptBank84_Branch_849CCB: JMP.W .EventScriptBank84_Branch_849FD0

    .EventScriptBank84_Branch_849CCE:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0002
        LDA.B [$CC],Y
        CMP.B #$00
        BEQ .EventScriptBank84_Branch_849CE7
        CMP.B #$01
        BEQ .EventScriptBank84_Branch_849CFD
        CMP.B #$02
        BEQ .EventScriptBank84_Branch_849D13
        CMP.B #$03
        BEQ .EventScriptBank84_Branch_849D29

    .EventScriptBank84_Branch_849CE7:
        %Set16bit(!M)
        LDA.W #$0000
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        LDA.B [$CC],Y
        LDX.W #$0000
        LDY.W #$0064
        BRA .EventScriptBank84_Branch_849D3F

    .EventScriptBank84_Branch_849CFD:
        %Set16bit(!M)
        LDA.W #$0000
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        LDA.B [$CC],Y
        LDX.W #$0000
        LDY.W #$0065
        BRA .EventScriptBank84_Branch_849D3F

    .EventScriptBank84_Branch_849D13:
        %Set16bit(!M)
        LDA.W #$0000
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        LDA.B [$CC],Y
        LDX.W #$0000
        LDY.W #$0066
        BRA .EventScriptBank84_Branch_849D3F

    .EventScriptBank84_Branch_849D29:
        %Set16bit(!M)
        LDA.W #$0000
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        LDA.B [$CC],Y
        LDX.W #$0000
        LDY.W #$0067
        BRA .EventScriptBank84_Branch_849D3F

    .EventScriptBank84_Branch_849D3F:
        JSL.L EventScript_LoadScriptPointerShort
        JMP.W .EventScriptBank84_Branch_84A46E

    .EventScriptBank84_Branch_849D46:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0002
        LDA.B [$CC],Y
        CMP.B #$00
        BEQ .EventScriptBank84_Branch_849D5F
        CMP.B #$01
        BEQ .EventScriptBank84_Branch_849D75
        CMP.B #$02
        BEQ .EventScriptBank84_Branch_849D8B
        CMP.B #$03
        BEQ .EventScriptBank84_Branch_849DA1

    .EventScriptBank84_Branch_849D5F:
        %Set16bit(!M)
        LDA.W #$0000
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        LDA.B [$CC],Y
        LDX.W #$0000
        LDY.W #$0060
        BRA .EventScriptBank84_Branch_849DB7

    .EventScriptBank84_Branch_849D75:
        %Set16bit(!M)
        LDA.W #$0000
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        LDA.B [$CC],Y
        LDX.W #$0000
        LDY.W #$0061
        BRA .EventScriptBank84_Branch_849DB7

    .EventScriptBank84_Branch_849D8B:
        %Set16bit(!M)
        LDA.W #$0000
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        LDA.B [$CC],Y
        LDX.W #$0000
        LDY.W #$0062
        BRA .EventScriptBank84_Branch_849DB7

    .EventScriptBank84_Branch_849DA1:
        %Set16bit(!M)
        LDA.W #$0000
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        LDA.B [$CC],Y
        LDX.W #$0000
        LDY.W #$0063
        BRA .EventScriptBank84_Branch_849DB7

    .EventScriptBank84_Branch_849DB7:
        JSL.L EventScript_LoadScriptPointerShort
        JMP.W .EventScriptBank84_Branch_84A46E

    .EventScriptBank84_Branch_849DBE:
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.W !tool_selected
        BNE .EventScriptBank84_Branch_849DCA
        JMP.W .EventScriptBank84_Branch_84A0B9

    .EventScriptBank84_Branch_849DCA:
        CMP.B #$05
        BCS .EventScriptBank84_Branch_849DD1
        JMP.W .EventScriptBank84_Branch_849F04

    .EventScriptBank84_Branch_849DD1:
        CMP.B #$0E
        BEQ .EventScriptBank84_Branch_849DED
        CMP.B #$0F
        BNE .EventScriptBank84_Branch_849DDC
        JMP.W .EventScriptBank84_Branch_849EAE

    .EventScriptBank84_Branch_849DDC:
        CMP.B #$11
        BCS .EventScriptBank84_Branch_849DE3
        JMP.W .EventScriptBank84_Branch_84A0B9

    .EventScriptBank84_Branch_849DE3:
        CMP.B #$15
        BCS .EventScriptBank84_Branch_849DEA
        JMP.W .EventScriptBank84_Branch_849F04

    .EventScriptBank84_Branch_849DEA: JMP.W .EventScriptBank84_Branch_84A0B9

    .EventScriptBank84_Branch_849DED:
        %Set8bit(!M)
        LDY.W #$0000
        LDA.B [$72],Y
        AND.B #$08
        BNE .EventScriptBank84_Branch_849DFB
        JMP.W .EventScriptBank84_Branch_84A0B9

    .EventScriptBank84_Branch_849DFB:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$72],Y
        AND.B #$02
        BEQ .EventScriptBank84_Branch_849E0B
        JMP.W .EventScriptBank84_Branch_84A0B9

    .EventScriptBank84_Branch_849E0B:
        LDY.W #$0000
        LDA.B [$72],Y
        AND.B #$70
        BEQ .EventScriptBank84_Branch_849E17
        JMP.W .EventScriptBank84_Branch_84A0B9

    .EventScriptBank84_Branch_849E17:
        LDY.W #$0001
        LDA.B [$72],Y
        ORA.B #$02
        STA.B [$72],Y
        %Set8bit(!M)
        LDA.B #$15
        STA.W !item_on_hand
        LDY.W #$0004
        LDA.B [$72],Y
        CMP.B #$60
        BCC .EventScriptBank84_Branch_849E44
        CMP.B #$C0
        BCC .EventScriptBank84_Branch_849E3D
        %Set8bit(!M)
        LDA.B #$17
        STA.W !item_on_hand
        BRA .EventScriptBank84_Branch_849E44

    .EventScriptBank84_Branch_849E3D:
        %Set8bit(!M)
        LDA.B #$16
        STA.W !item_on_hand

    .EventScriptBank84_Branch_849E44:
        %Set16bit(!MX)
        LDA.W #$0004
        STA.B !player_action
        JMP.W .EventScriptBank84_Branch_849FD0

    .EventScriptBank84_Branch_849E4E:
        %Set16bit(!MX)
        LDA.L !player_house_and_event_flags
        AND.W #$0004
        BEQ .EventScriptBank84_Branch_849E5C
        JMP.W .EventScriptBank84_Branch_84A0B9

    .EventScriptBank84_Branch_849E5C:
        %Set8bit(!M)
        LDA.L !cow_N
        CMP.B #$0C
        BNE .EventScriptBank84_Branch_849E69
        JMP.W .EventScriptBank84_Branch_84A0B9

    .EventScriptBank84_Branch_849E69:
        %Set16bit(!M)
        LDA.L !player_house_and_event_flags
        ORA.W #$0004
        STA.L !player_house_and_event_flags
        %Set8bit(!M)
        LDY.W #$0000
        LDA.B [$72],Y
        AND.B #$CF
        STA.B [$72],Y
        LDY.W #$0001
        LDA.B [$72],Y
        ORA.B #$80
        STA.B [$72],Y
        %Set16bit(!M)
        LDA.W #$000A
        JSL.L .AddCowHappiness
        %Set8bit(!M)
        LDY.W #$0003
        LDA.B #$15
        STA.B [$72],Y
        STA.L $7F1F12
        %Set8bit(!M)
        LDA.L !cow_N
        INC A
        STA.L !cow_N
        JMP.W .EventScriptBank84_Branch_849FD0

    .EventScriptBank84_Branch_849EAE:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$72],Y
        AND.B #$01
        BEQ .EventScriptBank84_Branch_849EBE
        JMP.W .EventScriptBank84_Branch_84A0B9

    .EventScriptBank84_Branch_849EBE:
        LDY.W #$0001
        LDA.B [$72],Y
        ORA.B #$01
        STA.B [$72],Y
        %Set16bit(!M)
        LDA.W #$0003
        JSL.L .AddCowHappiness
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0000
        LDA.B [$72],Y
        AND.B #$30
        BEQ .EventScriptBank84_Branch_849EE0
        JMP.W .EventScriptBank84_Branch_84A0B9

    .EventScriptBank84_Branch_849EE0:
        LDY.W #$0000                         ;849EE0;      ;
        LDA.B [$72],Y                        ;849EE3;000072;
        AND.B #$02                           ;849EE5;      ;
        BEQ .EventScriptBank84_Branch_849EEC                      ;849EE7;849EEC;
        JMP.W .EventScriptBank84_Branch_849CCE                    ;849EE9;849CCE;

    .EventScriptBank84_Branch_849EEC:
        LDA.B [$72],Y                        ;849EEC;000072;
        AND.B #$04                           ;849EEE;      ;
        BEQ .EventScriptBank84_Branch_849EF5                      ;849EF0;849EF5;
        JMP.W .EventScriptBank84_Branch_849D46                    ;849EF2;849D46;

    .EventScriptBank84_Branch_849EF5:
        LDY.W #$0000                         ;849EF5;      ;
        LDA.B [$72],Y                        ;849EF8;000072;
        AND.B #$40                           ;849EFA;      ;
        BEQ .EventScriptBank84_Branch_849F01                      ;849EFC;849F01;
        JMP.W .EventScriptBank84_Branch_84A044                    ;849EFE;84A044;

    .EventScriptBank84_Branch_849F01: JMP.W .EventScriptBank84_Branch_849FD0                    ;849F01;849FD0;

    .EventScriptBank84_Branch_849F04:
        %Set8bit(!M)                             ;849F04;      ;
        LDY.W #$0000                         ;849F06;      ;
        LDA.B [$72],Y                        ;849F09;000072;
        AND.B #$08                           ;849F0B;      ;
        BEQ .EventScriptBank84_Branch_849F12                      ;849F0D;849F12;
        JMP.W .EventScriptBank84_Branch_849F24                    ;849F0F;849F24;

    .EventScriptBank84_Branch_849F12:
        LDA.B [$72],Y                        ;849F12;000072;
        AND.B #$04                           ;849F14;      ;
        BEQ .EventScriptBank84_Branch_849F1B                      ;849F16;849F1B;
        JMP.W .EventScriptBank84_Branch_849F43                    ;849F18;849F43;

    .EventScriptBank84_Branch_849F1B:
        LDA.B [$72],Y                        ;849F1B;000072;
        AND.B #$02                           ;849F1D;      ;
        BEQ .EventScriptBank84_Branch_849F24                      ;849F1F;849F24;
        JMP.W .EventScriptBank84_Branch_849F62                    ;849F21;849F62;

    .EventScriptBank84_Branch_849F24:
        %Set16bit(!MX)                             ;849F24;      ;
        LDA.W #$000A                         ;849F26;      ;
        STA.B $7E                            ;849F29;00007E;
        %Set8bit(!M)                             ;849F2B;      ;
        %Set16bit(!X)                             ;849F2D;      ;
        LDY.W #$0002                         ;849F2F;      ;
        LDA.B [$CC],Y                        ;849F32;0000CC;
        BEQ .EventScriptBank84_Branch_849F81                      ;849F34;849F81;
        CMP.B #$02                           ;849F36;      ;
        BEQ .EventScriptBank84_Branch_849F81                      ;849F38;849F81;
        %Set16bit(!M)                             ;849F3A;      ;
        LDA.W #$000B                         ;849F3C;      ;
        STA.B $7E                            ;849F3F;00007E;
        BRA .EventScriptBank84_Branch_849F81                      ;849F41;849F81;

    .EventScriptBank84_Branch_849F43:
        %Set16bit(!MX)                             ;849F43;      ;
        LDA.W #$0068                         ;849F45;      ;
        STA.B $7E                            ;849F48;00007E;
        %Set8bit(!M)                             ;849F4A;      ;
        %Set16bit(!X)                             ;849F4C;      ;
        LDY.W #$0002                         ;849F4E;      ;
        LDA.B [$CC],Y                        ;849F51;0000CC;
        BEQ .EventScriptBank84_Branch_849F81                      ;849F53;849F81;
        CMP.B #$02                           ;849F55;      ;
        BEQ .EventScriptBank84_Branch_849F81                      ;849F57;849F81;
        %Set16bit(!M)                             ;849F59;      ;
        LDA.W #$0069                         ;849F5B;      ;
        STA.B $7E                            ;849F5E;00007E;
        BRA .EventScriptBank84_Branch_849F81                      ;849F60;849F81;

    .EventScriptBank84_Branch_849F62:
        %Set16bit(!MX)                             ;849F62;      ;
        LDA.W #$006A                         ;849F64;      ;
        STA.B $7E                            ;849F67;00007E;
        %Set8bit(!M)                             ;849F69;      ;
        %Set16bit(!X)                             ;849F6B;      ;
        LDY.W #$0002                         ;849F6D;      ;
        LDA.B [$CC],Y                        ;849F70;0000CC;
        BEQ .EventScriptBank84_Branch_849F81                      ;849F72;849F81;
        CMP.B #$02                           ;849F74;      ;
        BEQ .EventScriptBank84_Branch_849F81                      ;849F76;849F81;
        %Set16bit(!M)                             ;849F78;      ;
        LDA.W #$006B                         ;849F7A;      ;
        STA.B $7E                            ;849F7D;00007E;
        BRA .EventScriptBank84_Branch_849F81                      ;849F7F;849F81;

    .EventScriptBank84_Branch_849F81:
        %Set8bit(!M)                             ;849F81;      ;
        %Set16bit(!X)                             ;849F83;      ;
        LDY.W #$0000                         ;849F85;      ;
        LDA.B [$72],Y                        ;849F88;000072;
        AND.B #$70                           ;849F8A;      ;
        BEQ .EventScriptBank84_Branch_849F91                      ;849F8C;849F91;
        JMP.W .EventScriptBank84_Branch_84A0B9                    ;849F8E;84A0B9;

    .EventScriptBank84_Branch_849F91:
        %Set16bit(!M)                             ;849F91;      ;
        LDA.W #$0000                         ;849F93;      ;
        %Set8bit(!M)                             ;849F96;      ;
        %Set16bit(!X)                             ;849F98;      ;
        LDY.W #$003F                         ;849F9A;      ;
        LDA.B [$CC],Y                        ;849F9D;0000CC;
        LDX.W #$0000                         ;849F9F;      ;
        LDY.B $7E                            ;849FA2;00007E;
        JSL.L EventScript_LoadScriptPointerShort                    ;849FA4;84803F;
        %Set8bit(!M)                             ;849FA8;      ;
        LDY.W #$0005                         ;849FAA;      ;
        LDA.B [$72],Y                        ;849FAD;000072;
        CMP.B #$0A                           ;849FAF;      ;
        BNE .EventScriptBank84_Branch_849FB6                      ;849FB1;849FB6;
        JMP.W .EventScriptBank84_Branch_84A0B9                    ;849FB3;84A0B9;

    .EventScriptBank84_Branch_849FB6:
        INC A                                ;849FB6;      ;
        STA.B [$72],Y                        ;849FB7;000072;
        JMP.W .EventScriptBank84_Branch_84A0B9                    ;849FB9;84A0B9;

    .EventScriptBank84_Branch_849FBC:
        %Set8bit(!M)                             ;849FBC;      ;
        %Set16bit(!X)                             ;849FBE;      ;
        LDY.W #$0000                         ;849FC0;      ;
        LDA.B [$72],Y                        ;849FC3;000072;
        AND.B #$DF                           ;849FC5;      ;
        STA.B [$72],Y                        ;849FC7;000072;
        LDY.W #$0003                         ;849FC9;      ;
        LDA.B #$00                           ;849FCC;      ;
        STA.B [$72],Y                        ;849FCE;000072;

    .EventScriptBank84_Branch_849FD0:
        %Set8bit(!M)                             ;849FD0;      ;
        %Set16bit(!X)                             ;849FD2;      ;
        LDY.W #$0002                         ;849FD4;      ;
        LDA.B [$CC],Y                        ;849FD7;0000CC;
        CMP.B #$00                           ;849FD9;      ;
        BEQ .EventScriptBank84_Branch_849FE9                      ;849FDB;849FE9;
        CMP.B #$01                           ;849FDD;      ;
        BEQ .EventScriptBank84_Branch_84A000                      ;849FDF;84A000;
        CMP.B #$02                           ;849FE1;      ;
        BEQ .EventScriptBank84_Branch_84A017                      ;849FE3;84A017;
        CMP.B #$03                           ;849FE5;      ;
        BEQ .EventScriptBank84_Branch_84A02E                      ;849FE7;84A02E;

    .EventScriptBank84_Branch_849FE9:
        %Set16bit(!M)                             ;849FE9;      ;
        LDA.W #$0000                         ;849FEB;      ;
        %Set8bit(!M)                             ;849FEE;      ;
        %Set16bit(!X)                             ;849FF0;      ;
        LDY.W #$003F                         ;849FF2;      ;
        LDA.B [$CC],Y                        ;849FF5;0000CC;
        LDX.W #$0000                         ;849FF7;      ;
        LDY.W #$000C                         ;849FFA;      ;
        JMP.W .EventScriptBank84_Branch_84A0B5                    ;849FFD;84A0B5;

    .EventScriptBank84_Branch_84A000:
        %Set16bit(!M)                             ;84A000;      ;
        LDA.W #$0000                         ;84A002;      ;
        %Set8bit(!M)                             ;84A005;      ;
        %Set16bit(!X)                             ;84A007;      ;
        LDY.W #$003F                         ;84A009;      ;
        LDA.B [$CC],Y                        ;84A00C;0000CC;
        LDX.W #$0000                         ;84A00E;      ;
        LDY.W #$000D                         ;84A011;      ;
        JMP.W .EventScriptBank84_Branch_84A0B5                    ;84A014;84A0B5;

    .EventScriptBank84_Branch_84A017:
        %Set16bit(!M)                             ;84A017;      ;
        LDA.W #$0000                         ;84A019;      ;
        %Set8bit(!M)                             ;84A01C;      ;
        %Set16bit(!X)                             ;84A01E;      ;
        LDY.W #$003F                         ;84A020;      ;
        LDA.B [$CC],Y                        ;84A023;0000CC;
        LDX.W #$0000                         ;84A025;      ;
        LDY.W #$000E                         ;84A028;      ;
        JMP.W .EventScriptBank84_Branch_84A0B5                    ;84A02B;84A0B5;

    .EventScriptBank84_Branch_84A02E:
        %Set16bit(!M)                             ;84A02E;      ;
        LDA.W #$0000                         ;84A030;      ;
        %Set8bit(!M)                             ;84A033;      ;
        %Set16bit(!X)                             ;84A035;      ;
        LDY.W #$003F                         ;84A037;      ;
        LDA.B [$CC],Y                        ;84A03A;0000CC;
        LDX.W #$0000                         ;84A03C;      ;
        LDY.W #$000F                         ;84A03F;      ;
        BRA .EventScriptBank84_Branch_84A0B5                      ;84A042;84A0B5;

    .EventScriptBank84_Branch_84A044:
        %Set8bit(!M)                             ;84A044;      ;
        %Set16bit(!X)                             ;84A046;      ;
        LDY.W #$0002                         ;84A048;      ;
        LDA.B [$CC],Y                        ;84A04B;0000CC;
        CMP.B #$00                           ;84A04D;      ;
        BEQ .EventScriptBank84_Branch_84A05D                      ;84A04F;84A05D;
        CMP.B #$01                           ;84A051;      ;
        BEQ .EventScriptBank84_Branch_84A073                      ;84A053;84A073;
        CMP.B #$02                           ;84A055;      ;
        BEQ .EventScriptBank84_Branch_84A089                      ;84A057;84A089;
        CMP.B #$03                           ;84A059;      ;
        BEQ .EventScriptBank84_Branch_84A09F                      ;84A05B;84A09F;

    .EventScriptBank84_Branch_84A05D:
        %Set16bit(!M)                             ;84A05D;      ;
        LDA.W #$0000                         ;84A05F;      ;
        %Set8bit(!M)                             ;84A062;      ;
        %Set16bit(!X)                             ;84A064;      ;
        LDY.W #$003F                         ;84A066;      ;
        LDA.B [$CC],Y                        ;84A069;0000CC;
        LDX.W #$0000                         ;84A06B;      ;
        LDY.W #$0082                         ;84A06E;      ;
        BRA .EventScriptBank84_Branch_84A0B5                      ;84A071;84A0B5;

    .EventScriptBank84_Branch_84A073:
        %Set16bit(!M)                             ;84A073;      ;
        LDA.W #$0000                         ;84A075;      ;
        %Set8bit(!M)                             ;84A078;      ;
        %Set16bit(!X)                             ;84A07A;      ;
        LDY.W #$003F                         ;84A07C;      ;
        LDA.B [$CC],Y                        ;84A07F;0000CC;
        LDX.W #$0000                         ;84A081;      ;
        LDY.W #$0083                         ;84A084;      ;
        BRA .EventScriptBank84_Branch_84A0B5                      ;84A087;84A0B5;

    .EventScriptBank84_Branch_84A089:
        %Set16bit(!M)                             ;84A089;      ;
        LDA.W #$0000                         ;84A08B;      ;
        %Set8bit(!M)                             ;84A08E;      ;
        %Set16bit(!X)                             ;84A090;      ;
        LDY.W #$003F                         ;84A092;      ;
        LDA.B [$CC],Y                        ;84A095;0000CC;
        LDX.W #$0000                         ;84A097;      ;
        LDY.W #$0084                         ;84A09A;      ;
        BRA .EventScriptBank84_Branch_84A0B5                      ;84A09D;84A0B5;

    .EventScriptBank84_Branch_84A09F:
        %Set16bit(!M)                             ;84A09F;      ;
        LDA.W #$0000                         ;84A0A1;      ;
        %Set8bit(!M)                             ;84A0A4;      ;
        %Set16bit(!X)                             ;84A0A6;      ;
        LDY.W #$003F                         ;84A0A8;      ;
        LDA.B [$CC],Y                        ;84A0AB;0000CC;
        LDX.W #$0000                         ;84A0AD;      ;
        LDY.W #$0085                         ;84A0B0;      ;
        BRA .EventScriptBank84_Branch_84A0B5                      ;84A0B3;84A0B5;

    .EventScriptBank84_Branch_84A0B5: JSL.L EventScript_LoadScriptPointerShort                    ;84A0B5;84803F;

    .EventScriptBank84_Branch_84A0B9:
        %Set8bit(!M)                             ;84A0B9;      ;
        LDY.W #$0000                         ;84A0BB;      ;
        LDA.B [$72],Y                        ;84A0BE;000072;
        AND.B #$08                           ;84A0C0;      ;
        BEQ .EventScriptBank84_Branch_84A0C7                      ;84A0C2;84A0C7;
        JMP.W .EventScriptBank84_Branch_84A2B6                    ;84A0C4;84A2B6;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A0C7:
        LDA.B [$72],Y                        ;84A0C7;000072;
        AND.B #$04                           ;84A0C9;      ;
        BEQ .EventScriptBank84_Branch_84A0D0                      ;84A0CB;84A0D0;
        JMP.W .EventScriptBank84_Branch_84A1C9                    ;84A0CD;84A1C9;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A0D0:
        LDA.B [$72],Y                        ;84A0D0;000072;
        AND.B #$02                           ;84A0D2;      ;
        BEQ .EventScriptBank84_Branch_84A0D9                      ;84A0D4;84A0D9;
        JMP.W .EventScriptBank84_Branch_84A0DC                    ;84A0D6;84A0DC;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A0D9:
        JMP.W .EventScriptBank84_Branch_84A46E                    ;84A0D9;84A46E;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A0DC:
        %Set8bit(!M)                             ;84A0DC;      ;
        %Set16bit(!X)                             ;84A0DE;      ;
        LDY.W #$003F                         ;84A0E0;      ;
        LDA.B [$CC],Y                        ;84A0E3;0000CC;
        SEC                                  ;84A0E5;      ;
        SBC.B #$18                           ;84A0E6;      ;
        XBA                                  ;84A0E8;      ;
        LDA.B #$00                           ;84A0E9;      ;
        XBA                                  ;84A0EB;      ;
        %Set16bit(!M)                             ;84A0EC;      ;
        ASL A                                ;84A0EE;      ;
        TAX                                  ;84A0EF;      ;
        LDA.W $0953,X                        ;84A0F0;000953;
        CMP.W #$0100                         ;84A0F3;      ;
        BEQ .EventScriptBank84_Branch_84A0FF                      ;84A0F6;84A0FF;
        INC A                                ;84A0F8;      ;
        STA.W $0953,X                        ;84A0F9;000953;
        JMP.W .EventScriptBank84_Branch_84A46E                    ;84A0FC;84A46E;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A0FF:
        %Set16bit(!MX)                             ;84A0FF;      ;
        STZ.W $0953,X                        ;84A101;000953;
        %Set8bit(!M)                             ;84A104;      ;
        LDA.B $DE                            ;84A106;0000DE;
        CMP.B #$40                           ;84A108;      ;
        BCC .EventScriptBank84_Branch_84A11D                      ;84A10A;84A11D;
        CMP.B #$80                           ;84A10C;      ;
        BCS .EventScriptBank84_Branch_84A113                      ;84A10E;84A113;
        JMP.W .EventScriptBank84_Branch_84A148                    ;84A110;84A148;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A113:
        CMP.B #$C0                           ;84A113;      ;
        BCS .EventScriptBank84_Branch_84A11A                      ;84A115;84A11A;
        JMP.W .EventScriptBank84_Branch_84A173                    ;84A117;84A173;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A11A:
        JMP.W .EventScriptBank84_Branch_84A19E                    ;84A11A;84A19E;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A11D:
        %Set16bit(!MX)                             ;84A11D;      ;
        %Set8bit(!M)                             ;84A11F;      ;
        %Set16bit(!X)                             ;84A121;      ;
        LDY.W #$0001                         ;84A123;      ;
        LDA.B [$72],Y                        ;84A126;000072;
        ORA.B #$08                           ;84A128;      ;
        STA.B [$72],Y                        ;84A12A;000072;
        %Set8bit(!M)                             ;84A12C;      ;
        %Set16bit(!X)                             ;84A12E;      ;
        LDY.W #$003F                         ;84A130;      ;
        LDA.B [$CC],Y                        ;84A133;0000CC;
        XBA                                  ;84A135;      ;
        LDA.B #$00                           ;84A136;      ;
        XBA                                  ;84A138;      ;
        %Set16bit(!M)                             ;84A139;      ;
        LDX.W #$0000                         ;84A13B;      ;
        LDY.W #$0078                         ;84A13E;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84A141;84803F;
        JMP.W .EventScriptBank84_Branch_84A46E                    ;84A145;84A46E;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A148:
        %Set16bit(!MX)                             ;84A148;      ;
        %Set8bit(!M)                             ;84A14A;      ;
        %Set16bit(!X)                             ;84A14C;      ;
        LDY.W #$0001                         ;84A14E;      ;
        LDA.B [$72],Y                        ;84A151;000072;
        AND.B #!OBJ_Offset_Y                          ;84A153;      ;
        STA.B [$72],Y                        ;84A155;000072;
        %Set8bit(!M)                             ;84A157;      ;
        %Set16bit(!X)                             ;84A159;      ;
        LDY.W #$003F                         ;84A15B;      ;
        LDA.B [$CC],Y                        ;84A15E;0000CC;
        XBA                                  ;84A160;      ;
        LDA.B #$00                           ;84A161;      ;
        XBA                                  ;84A163;      ;
        %Set16bit(!M)                             ;84A164;      ;
        LDX.W #$0000                         ;84A166;      ;
        LDY.W #$0079                         ;84A169;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84A16C;84803F;
        JMP.W .EventScriptBank84_Branch_84A46E                    ;84A170;84A46E;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A173:
        %Set16bit(!MX)                             ;84A173;      ;
        %Set8bit(!M)                             ;84A175;      ;
        %Set16bit(!X)                             ;84A177;      ;
        LDY.W #$0001                         ;84A179;      ;
        LDA.B [$72],Y                        ;84A17C;000072;
        AND.B #!OBJ_Offset_Y                          ;84A17E;      ;
        STA.B [$72],Y                        ;84A180;000072;
        %Set8bit(!M)                             ;84A182;      ;
        %Set16bit(!X)                             ;84A184;      ;
        LDY.W #$003F                         ;84A186;      ;
        LDA.B [$CC],Y                        ;84A189;0000CC;
        XBA                                  ;84A18B;      ;
        LDA.B #$00                           ;84A18C;      ;
        XBA                                  ;84A18E;      ;
        %Set16bit(!M)                             ;84A18F;      ;
        LDX.W #$0000                         ;84A191;      ;
        LDY.W #$007A                         ;84A194;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84A197;84803F;
        JMP.W .EventScriptBank84_Branch_84A46E                    ;84A19B;84A46E;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A19E:
        %Set16bit(!MX)                             ;84A19E;      ;
        %Set8bit(!M)                             ;84A1A0;      ;
        %Set16bit(!X)                             ;84A1A2;      ;
        LDY.W #$0001                         ;84A1A4;      ;
        LDA.B [$72],Y                        ;84A1A7;000072;
        AND.B #!OBJ_Offset_Y                          ;84A1A9;      ;
        STA.B [$72],Y                        ;84A1AB;000072;
        %Set8bit(!M)                             ;84A1AD;      ;
        %Set16bit(!X)                             ;84A1AF;      ;
        LDY.W #$003F                         ;84A1B1;      ;
        LDA.B [$CC],Y                        ;84A1B4;0000CC;
        XBA                                  ;84A1B6;      ;
        LDA.B #$00                           ;84A1B7;      ;
        XBA                                  ;84A1B9;      ;
        %Set16bit(!M)                             ;84A1BA;      ;
        LDX.W #$0000                         ;84A1BC;      ;
        LDY.W #$007B                         ;84A1BF;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84A1C2;84803F;
        JMP.W .EventScriptBank84_Branch_84A46E                    ;84A1C6;84A46E;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A1C9:
        %Set8bit(!M)                             ;84A1C9;      ;
        %Set16bit(!X)                             ;84A1CB;      ;
        LDY.W #$003F                         ;84A1CD;      ;
        LDA.B [$CC],Y                        ;84A1D0;0000CC;
        SEC                                  ;84A1D2;      ;
        SBC.B #$18                           ;84A1D3;      ;
        XBA                                  ;84A1D5;      ;
        LDA.B #$00                           ;84A1D6;      ;
        XBA                                  ;84A1D8;      ;
        %Set16bit(!M)                             ;84A1D9;      ;
        ASL A                                ;84A1DB;      ;
        TAX                                  ;84A1DC;      ;
        LDA.W $0953,X                        ;84A1DD;000953;
        CMP.W #$0100                         ;84A1E0;      ;
        BEQ .EventScriptBank84_Branch_84A1EC                      ;84A1E3;84A1EC;
        INC A                                ;84A1E5;      ;
        STA.W $0953,X                        ;84A1E6;000953;
        JMP.W .EventScriptBank84_Branch_84A46E                    ;84A1E9;84A46E;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A1EC:
        %Set16bit(!MX)                             ;84A1EC;      ;
        STZ.W $0953,X                        ;84A1EE;000953;
        %Set8bit(!M)                             ;84A1F1;      ;
        LDA.B $DE                            ;84A1F3;0000DE;
        CMP.B #$40                           ;84A1F5;      ;
        BCC .EventScriptBank84_Branch_84A20A                      ;84A1F7;84A20A;
        CMP.B #$80                           ;84A1F9;      ;
        BCS .EventScriptBank84_Branch_84A200                      ;84A1FB;84A200;
        JMP.W .EventScriptBank84_Branch_84A235                    ;84A1FD;84A235;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A200:
        CMP.B #$C0                           ;84A200;      ;
        BCS .EventScriptBank84_Branch_84A207                      ;84A202;84A207;
        JMP.W .EventScriptBank84_Branch_84A260                    ;84A204;84A260;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A207: JMP.W .EventScriptBank84_Branch_84A28B                    ;84A207;84A28B;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A20A:
        %Set16bit(!MX)                             ;84A20A;      ;
        %Set8bit(!M)                             ;84A20C;      ;
        %Set16bit(!X)                             ;84A20E;      ;
        LDY.W #$0001                         ;84A210;      ;
        LDA.B [$72],Y                        ;84A213;000072;
        ORA.B #$08                           ;84A215;      ;
        STA.B [$72],Y                        ;84A217;000072;
        %Set8bit(!M)                             ;84A219;      ;
        %Set16bit(!X)                             ;84A21B;      ;
        LDY.W #$003F                         ;84A21D;      ;
        LDA.B [$CC],Y                        ;84A220;0000CC;
        XBA                                  ;84A222;      ;
        LDA.B #$00                           ;84A223;      ;
        XBA                                  ;84A225;      ;
        %Set16bit(!M)                             ;84A226;      ;
        LDX.W #$0000                         ;84A228;      ;
        LDY.W #$0074                         ;84A22B;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84A22E;84803F;
        JMP.W .EventScriptBank84_Branch_84A46E                    ;84A232;84A46E;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A235:
        %Set16bit(!MX)                             ;84A235;      ;
        %Set8bit(!M)                             ;84A237;      ;
        %Set16bit(!X)                             ;84A239;      ;
        LDY.W #$0001                         ;84A23B;      ;
        LDA.B [$72],Y                        ;84A23E;000072;
        AND.B #!OBJ_Offset_Y                          ;84A240;      ;
        STA.B [$72],Y                        ;84A242;000072;
        %Set8bit(!M)                             ;84A244;      ;
        %Set16bit(!X)                             ;84A246;      ;
        LDY.W #$003F                         ;84A248;      ;
        LDA.B [$CC],Y                        ;84A24B;0000CC;
        XBA                                  ;84A24D;      ;
        LDA.B #$00                           ;84A24E;      ;
        XBA                                  ;84A250;      ;
        %Set16bit(!M)                             ;84A251;      ;
        LDX.W #$0000                         ;84A253;      ;
        LDY.W #$0076                         ;84A256;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84A259;84803F;
        JMP.W .EventScriptBank84_Branch_84A46E                    ;84A25D;84A46E;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A260:
        %Set16bit(!MX)                             ;84A260;      ;
        %Set8bit(!M)                             ;84A262;      ;
        %Set16bit(!X)                             ;84A264;      ;
        LDY.W #$0001                         ;84A266;      ;
        LDA.B [$72],Y                        ;84A269;000072;
        AND.B #!OBJ_Offset_Y                          ;84A26B;      ;
        STA.B [$72],Y                        ;84A26D;000072;
        %Set8bit(!M)                             ;84A26F;      ;
        %Set16bit(!X)                             ;84A271;      ;
        LDY.W #$003F                         ;84A273;      ;
        LDA.B [$CC],Y                        ;84A276;0000CC;
        XBA                                  ;84A278;      ;
        LDA.B #$00                           ;84A279;      ;
        XBA                                  ;84A27B;      ;
        %Set16bit(!M)                             ;84A27C;      ;
        LDX.W #$0000                         ;84A27E;      ;
        LDY.W #$0077                         ;84A281;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84A284;84803F;
        JMP.W .EventScriptBank84_Branch_84A46E                    ;84A288;84A46E;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A28B:
        %Set16bit(!MX)                             ;84A28B;      ;
        %Set8bit(!M)                             ;84A28D;      ;
        %Set16bit(!X)                             ;84A28F;      ;
        LDY.W #$0001                         ;84A291;      ;
        LDA.B [$72],Y                        ;84A294;000072;
        AND.B #!OBJ_Offset_Y                          ;84A296;      ;
        STA.B [$72],Y                        ;84A298;000072;
        %Set8bit(!M)                             ;84A29A;      ;
        %Set16bit(!X)                             ;84A29C;      ;
        LDY.W #$003F                         ;84A29E;      ;
        LDA.B [$CC],Y                        ;84A2A1;0000CC;
        XBA                                  ;84A2A3;      ;
        LDA.B #$00                           ;84A2A4;      ;
        XBA                                  ;84A2A6;      ;
        %Set16bit(!M)                             ;84A2A7;      ;
        LDX.W #$0000                         ;84A2A9;      ;
        LDY.W #$0075                         ;84A2AC;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84A2AF;84803F;
        JMP.W .EventScriptBank84_Branch_84A46E                    ;84A2B3;84A46E;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A2B6:
        %Set8bit(!M)                             ;84A2B6;      ;
        %Set16bit(!X)                             ;84A2B8;      ;
        LDY.W #$003F                         ;84A2BA;      ;
        LDA.B [$CC],Y                        ;84A2BD;0000CC;
        SEC                                  ;84A2BF;      ;
        SBC.B #$18                           ;84A2C0;      ;
        XBA                                  ;84A2C2;      ;
        LDA.B #$00                           ;84A2C3;      ;
        XBA                                  ;84A2C5;      ;
        %Set16bit(!M)                             ;84A2C6;      ;
        ASL A                                ;84A2C8;      ;
        TAX                                  ;84A2C9;      ;
        LDA.W $0953,X                        ;84A2CA;000953;
        CMP.W #$0100                         ;84A2CD;      ;
        BEQ .EventScriptBank84_Branch_84A2D9                      ;84A2D0;84A2D9;
        INC A                                ;84A2D2;      ;
        STA.W $0953,X                        ;84A2D3;000953;
        JMP.W .EventScriptBank84_Branch_84A46E                    ;84A2D6;84A46E;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A2D9:
        %Set16bit(!MX)                             ;84A2D9;      ;
        STZ.W $0953,X                        ;84A2DB;000953;
        %Set8bit(!M)                             ;84A2DE;      ;
        LDY.W #$0000                         ;84A2E0;      ;
        LDA.B [$72],Y                        ;84A2E3;000072;
        AND.B #$40                           ;84A2E5;      ;
        BEQ .EventScriptBank84_Branch_84A2EC                      ;84A2E7;84A2EC;
        JMP.W .EventScriptBank84_Branch_84A46E                    ;84A2E9;84A46E;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A2EC:
        %Set16bit(!MX)                             ;84A2EC;      ;
        %Set8bit(!M)                             ;84A2EE;      ;
        LDA.B $DE                            ;84A2F0;0000DE;
        CMP.B #$33                           ;84A2F2;      ;
        BCC .EventScriptBank84_Branch_84A30B                      ;84A2F4;84A30B;
        CMP.B #$66                           ;84A2F6;      ;
        BCC .EventScriptBank84_Branch_84A352                      ;84A2F8;84A352;
        CMP.B #$99                           ;84A2FA;      ;
        BCS .EventScriptBank84_Branch_84A301                      ;84A2FC;84A301;
        JMP.W .EventScriptBank84_Branch_84A399                    ;84A2FE;84A399;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A301:
        CMP.B #$CC                           ;84A301;      ;
        BCS .EventScriptBank84_Branch_84A308                      ;84A303;84A308;
        JMP.W .EventScriptBank84_Branch_84A3E0                    ;84A305;84A3E0;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A308:
        JMP.W .EventScriptBank84_Branch_84A427                    ;84A308;84A427;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A30B:
        %Set16bit(!MX)                             ;84A30B;      ;
        %Set8bit(!M)                             ;84A30D;      ;
        %Set16bit(!X)                             ;84A30F;      ;
        LDY.W #$0001                         ;84A311;      ;
        LDA.B [$72],Y                        ;84A314;000072;
        ORA.B #$08                           ;84A316;      ;
        STA.B [$72],Y                        ;84A318;000072;
        %Set8bit(!M)                             ;84A31A;      ;
        LDY.W #$0000                         ;84A31C;      ;
        LDA.B [$72],Y                        ;84A31F;000072;
        AND.B #$20                           ;84A321;      ;
        BNE .EventScriptBank84_Branch_84A335                      ;84A323;84A335;
        LDA.B [$72],Y                        ;84A325;000072;
        AND.B #$10                           ;84A327;      ;
        BNE .EventScriptBank84_Branch_84A330                      ;84A329;84A330;
        LDX.W #$005E                         ;84A32B;      ;
        BRA .EventScriptBank84_Branch_84A338                      ;84A32E;84A338;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A330:
        LDX.W #$0070                         ;84A330;      ;
        BRA .EventScriptBank84_Branch_84A338                      ;84A333;84A338;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A335: LDX.W #$006C                         ;84A335;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A338:
        %Set8bit(!M)                             ;84A338;      ;
        %Set16bit(!X)                             ;84A33A;      ;
        LDY.W #$003F                         ;84A33C;      ;
        LDA.B [$CC],Y                        ;84A33F;0000CC;
        XBA                                  ;84A341;      ;
        LDA.B #$00                           ;84A342;      ;
        XBA                                  ;84A344;      ;
        %Set16bit(!M)                             ;84A345;      ;
        TXY                                  ;84A347;      ;
        LDX.W #$0000                         ;84A348;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84A34B;84803F;
        JMP.W .EventScriptBank84_Branch_84A46E                    ;84A34F;84A46E;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A352:
        %Set16bit(!MX)                             ;84A352;      ;
        %Set8bit(!M)                             ;84A354;      ;
        %Set16bit(!X)                             ;84A356;      ;
        LDY.W #$0001                         ;84A358;      ;
        LDA.B [$72],Y                        ;84A35B;000072;
        AND.B #!OBJ_Offset_Y                          ;84A35D;      ;
        STA.B [$72],Y                        ;84A35F;000072;
        %Set8bit(!M)                             ;84A361;      ;
        LDY.W #$0000                         ;84A363;      ;
        LDA.B [$72],Y                        ;84A366;000072;
        AND.B #$20                           ;84A368;      ;
        BNE .EventScriptBank84_Branch_84A37C                      ;84A36A;84A37C;
        LDA.B [$72],Y                        ;84A36C;000072;
        AND.B #$10                           ;84A36E;      ;
        BNE .EventScriptBank84_Branch_84A377                      ;84A370;84A377;
        LDX.W #$0051                         ;84A372;      ;
        BRA .EventScriptBank84_Branch_84A37F                      ;84A375;84A37F;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A377:
        LDX.W #$0071                         ;84A377;      ;
        BRA .EventScriptBank84_Branch_84A37F                      ;84A37A;84A37F;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A37C: LDX.W #$006D                         ;84A37C;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A37F:
        %Set8bit(!M)                             ;84A37F;      ;
        %Set16bit(!X)                             ;84A381;      ;
        LDY.W #$003F                         ;84A383;      ;
        LDA.B [$CC],Y                        ;84A386;0000CC;
        XBA                                  ;84A388;      ;
        LDA.B #$00                           ;84A389;      ;
        XBA                                  ;84A38B;      ;
        %Set16bit(!M)                             ;84A38C;      ;
        TXY                                  ;84A38E;      ;
        LDX.W #$0000                         ;84A38F;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84A392;84803F;
        JMP.W .EventScriptBank84_Branch_84A46E                    ;84A396;84A46E;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A399:
        %Set16bit(!MX)                             ;84A399;      ;
        %Set8bit(!M)                             ;84A39B;      ;
        %Set16bit(!X)                             ;84A39D;      ;
        LDY.W #$0001                         ;84A39F;      ;
        LDA.B [$72],Y                        ;84A3A2;000072;
        AND.B #!OBJ_Offset_Y                          ;84A3A4;      ;
        STA.B [$72],Y                        ;84A3A6;000072;
        %Set8bit(!M)                             ;84A3A8;      ;
        LDY.W #$0000                         ;84A3AA;      ;
        LDA.B [$72],Y                        ;84A3AD;000072;
        AND.B #$20                           ;84A3AF;      ;
        BNE .EventScriptBank84_Branch_84A3C3                      ;84A3B1;84A3C3;
        LDA.B [$72],Y                        ;84A3B3;000072;
        AND.B #$10                           ;84A3B5;      ;
        BNE .EventScriptBank84_Branch_84A3BE                      ;84A3B7;84A3BE;
        LDX.W #$0053                         ;84A3B9;      ;
        BRA .EventScriptBank84_Branch_84A3C6                      ;84A3BC;84A3C6;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A3BE:
        LDX.W #$0072                         ;84A3BE;      ;
        BRA .EventScriptBank84_Branch_84A3C6                      ;84A3C1;84A3C6;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A3C3: LDX.W #$006E                         ;84A3C3;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A3C6:
        %Set8bit(!M)                             ;84A3C6;      ;
        %Set16bit(!X)                             ;84A3C8;      ;
        LDY.W #$003F                         ;84A3CA;      ;
        LDA.B [$CC],Y                        ;84A3CD;0000CC;
        XBA                                  ;84A3CF;      ;
        LDA.B #$00                           ;84A3D0;      ;
        XBA                                  ;84A3D2;      ;
        %Set16bit(!M)                             ;84A3D3;      ;
        TXY                                  ;84A3D5;      ;
        LDX.W #$0000                         ;84A3D6;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84A3D9;84803F;
        JMP.W .EventScriptBank84_Branch_84A46E                    ;84A3DD;84A46E;
                                        ;      ;      ;
                                        ;      ;      ;
    .EventScriptBank84_Branch_84A3E0:
        %Set16bit(!MX)                             ;84A3E0;      ;
        %Set8bit(!M)                             ;84A3E2;      ;
        %Set16bit(!X)                             ;84A3E4;      ;
        LDY.W #$0001                         ;84A3E6;      ;
        LDA.B [$72],Y                        ;84A3E9;000072;
        AND.B #!OBJ_Offset_Y                          ;84A3EB;      ;
        STA.B [$72],Y                        ;84A3ED;000072;
        %Set8bit(!M)                             ;84A3EF;      ;
        LDY.W #$0000                         ;84A3F1;      ;
        LDA.B [$72],Y                        ;84A3F4;000072;
        AND.B #$20                           ;84A3F6;      ;
        BNE .EventScriptBank84_Branch_84A40A                      ;84A3F8;84A40A;
        LDA.B [$72],Y                        ;84A3FA;000072;
        AND.B #$10                           ;84A3FC;      ;
        BNE .EventScriptBank84_Branch_84A405                      ;84A3FE;84A405;
        LDX.W #$0054                         ;84A400;      ;
        BRA .EventScriptBank84_Branch_84A40D                      ;84A403;84A40D;

    .EventScriptBank84_Branch_84A405:
        LDX.W #$0073                         ;84A405;      ;
        BRA .EventScriptBank84_Branch_84A40D                      ;84A408;84A40D;

    .EventScriptBank84_Branch_84A40A: LDX.W #$006F                         ;84A40A;      ;

    .EventScriptBank84_Branch_84A40D:
        %Set8bit(!M)                             ;84A40D;      ;
        %Set16bit(!X)                             ;84A40F;      ;
        LDY.W #$003F                         ;84A411;      ;
        LDA.B [$CC],Y                        ;84A414;0000CC;
        XBA                                  ;84A416;      ;
        LDA.B #$00                           ;84A417;      ;
        XBA                                  ;84A419;      ;
        %Set16bit(!M)                             ;84A41A;      ;
        TXY                                  ;84A41C;      ;
        LDX.W #$0000                         ;84A41D;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84A420;84803F;
        JMP.W .EventScriptBank84_Branch_84A46E                    ;84A424;84A46E;

    .EventScriptBank84_Branch_84A427:
        %Set16bit(!MX)                             ;84A427;      ;
        %Set8bit(!M)                             ;84A429;      ;
        %Set16bit(!X)                             ;84A42B;      ;
        LDY.W #$0001                         ;84A42D;      ;
        LDA.B [$72],Y                        ;84A430;000072;
        AND.B #!OBJ_Offset_Y                          ;84A432;      ;
        STA.B [$72],Y                        ;84A434;000072;
        %Set8bit(!M)                             ;84A436;      ;
        LDY.W #$0000                         ;84A438;      ;
        LDA.B [$72],Y                        ;84A43B;000072;
        AND.B #$20                           ;84A43D;      ;
        BNE .EventScriptBank84_Branch_84A451                      ;84A43F;84A451;
        LDA.B [$72],Y                        ;84A441;000072;
        AND.B #$10                           ;84A443;      ;
        BNE .EventScriptBank84_Branch_84A44C                      ;84A445;84A44C;
        LDX.W #$0055                         ;84A447;      ;
        BRA .EventScriptBank84_Branch_84A454                      ;84A44A;84A454;

    .EventScriptBank84_Branch_84A44C:
        LDX.W #$0071                         ;84A44C;      ;
        BRA .EventScriptBank84_Branch_84A454                      ;84A44F;84A454;

    .EventScriptBank84_Branch_84A451: LDX.W #$006D                         ;84A451;      ;

    .EventScriptBank84_Branch_84A454:
        %Set8bit(!M)                             ;84A454;      ;
        %Set16bit(!X)                             ;84A456;      ;
        LDY.W #$003F                         ;84A458;      ;
        LDA.B [$CC],Y                        ;84A45B;0000CC;
        XBA                                  ;84A45D;      ;
        LDA.B #$00                           ;84A45E;      ;
        XBA                                  ;84A460;      ;
        %Set16bit(!M)                             ;84A461;      ;
        TXY                                  ;84A463;      ;
        LDX.W #$0000                         ;84A464;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84A467;84803F;
        JMP.W .EventScriptBank84_Branch_84A46E                    ;84A46B;84A46E;

    .EventScriptBank84_Branch_84A46E:
        %Set16bit(!MX)                             ;84A46E;      ;
        LDA.L $7F1F5A                        ;84A470;7F1F5A;
        AND.W #$0010                         ;84A474;      ;
        BEQ .EventScriptBank84_Branch_84A47C                      ;84A477;84A47C;
        JMP.W .EventScriptBank84_Branch_84A740                    ;84A479;84A740;

    .EventScriptBank84_Branch_84A47C:
        %Set8bit(!M)                             ;84A47C;      ;
        %Set16bit(!X)                             ;84A47E;      ;
        LDY.W #$000C                         ;84A480;      ;
        LDA.B [$CC],Y                        ;84A483;0000CC;
        BEQ .EventScriptBank84_Branch_84A48A                      ;84A485;84A48A;
        JMP.W .EventScriptBank84_Branch_84A607                    ;84A487;84A607;

    .EventScriptBank84_Branch_84A48A:
        %Set16bit(!MX)                             ;84A48A;      ;
        LDY.W #$0010                         ;84A48C;      ;
        LDA.B [$CC],Y                        ;84A48F;0000CC;
        CLC                                  ;84A491;      ;
        ADC.W #$0001                         ;84A492;      ;
        STA.B [$CC],Y                        ;84A495;0000CC;
        RTS                                  ;84A497;      ;

    .EventScriptBank84_Branch_84A498:
        %Set16bit(!MX)                             ;84A498;      ;
        LDA.L $7F1F5A                        ;84A49A;7F1F5A;
        AND.W #$0004                         ;84A49E;      ;
        BNE .EventScriptBank84_Branch_84A4A6                      ;84A4A1;84A4A6;
        JMP.W .EventScriptBank84_Branch_849B45                    ;84A4A3;849B45;

    .EventScriptBank84_Branch_84A4A6:
        LDA.L $7F1F5A                        ;84A4A6;7F1F5A;
        AND.W #$FFFB                         ;84A4AA;      ;
        STA.L $7F1F5A                        ;84A4AD;7F1F5A;
        %Set16bit(!M)                             ;84A4B1;      ;
        LDA.W #$01F4                         ;84A4B3;      ;
        STA.L $7F1F15                        ;84A4B6;7F1F15;
        %Set8bit(!M)                             ;84A4BA;      ;
        LDA.B #$00                           ;84A4BC;      ;
        STA.L $7F1F17                        ;84A4BE;7F1F17;
        %Set8bit(!M)                             ;84A4C2;      ;
        LDY.W #$0004                         ;84A4C4;      ;
        LDA.B [$72],Y                        ;84A4C7;000072;
        CMP.B #$60                           ;84A4C9;      ;
        BCC .EventScriptBank84_Branch_84A4F5                      ;84A4CB;84A4F5;
        CMP.B #$C0                           ;84A4CD;      ;
        BCC .EventScriptBank84_Branch_84A4E4                      ;84A4CF;84A4E4;
        %Set16bit(!M)                             ;84A4D1;      ;
        LDA.W #$03E8                         ;84A4D3;      ;
        STA.L $7F1F15                        ;84A4D6;7F1F15;
        %Set8bit(!M)                             ;84A4DA;      ;
        LDA.B #$00                           ;84A4DC;      ;
        STA.L $7F1F17                        ;84A4DE;7F1F17;
        BRA .EventScriptBank84_Branch_84A4F5                      ;84A4E2;84A4F5;

    .EventScriptBank84_Branch_84A4E4:
        %Set16bit(!M)                             ;84A4E4;      ;
        LDA.W #$0320                         ;84A4E6;      ;
        STA.L $7F1F15                        ;84A4E9;7F1F15;
        %Set8bit(!M)                             ;84A4ED;      ;
        LDA.B #$00                           ;84A4EF;      ;
        STA.L $7F1F17                        ;84A4F1;7F1F17;

    .EventScriptBank84_Branch_84A4F5:
        %Set8bit(!M)                             ;84A4F5;      ;
        %Set16bit(!X)                             ;84A4F7;      ;
        LDY.W #$003F                         ;84A4F9;      ;
        LDA.B [$CC],Y                        ;84A4FC;0000CC;
        STA.W $09A0                          ;84A4FE;0009A0;
        %Set8bit(!M)                             ;84A501;      ;
        LDA.B #$43                           ;84A503;      ;
        STA.W $096E                          ;84A505;00096E;
        STZ.W $096F                          ;84A508;00096F;
        STZ.W $0970                          ;84A50B;000970;
        %Set16bit(!MX)                             ;84A50E;      ;
        LDA.B !game_state                            ;84A510;0000D2;
        ORA.W #$0040                         ;84A512;      ;
        STA.B !game_state                            ;84A515;0000D2;
        %Set16bit(!MX)                             ;84A517;      ;
        LDA.W #$0000                         ;84A519;      ;
        STA.B !player_action                            ;84A51C;0000D4;
        %Set8bit(!M)                             ;84A51E;      ;
        %Set16bit(!X)                             ;84A520;      ;
        LDY.W #$000E                         ;84A522;      ;
        LDA.B #$00                           ;84A525;      ;
        STA.B [$CC],Y                        ;84A527;0000CC;
        %Set8bit(!M)                             ;84A529;      ;
        %Set16bit(!X)                             ;84A52B;      ;
        LDY.W #$0001                         ;84A52D;      ;
        LDA.B [$CC],Y                        ;84A530;0000CC;
        AND.B #$57                           ;84A532;      ;
        %Set8bit(!M)                             ;84A534;      ;
        %Set16bit(!X)                             ;84A536;      ;
        LDY.W #$0001                         ;84A538;      ;
        STA.B [$CC],Y                        ;84A53B;0000CC;
        JMP.W .EventScriptBank84_Branch_84A46E                    ;84A53D;84A46E;

    .EventScriptBank84_Branch_84A540:
        %Set8bit(!M)                             ;84A540;      ;
        %Set16bit(!X)                             ;84A542;      ;
        LDY.W #$0000                         ;84A544;      ;
        LDA.B #$00                           ;84A547;      ;
        STA.B [$CC],Y                        ;84A549;0000CC;
        %Set8bit(!M)                             ;84A54B;      ;
        %Set16bit(!X)                             ;84A54D;      ;
        LDY.W #$0001                         ;84A54F;      ;
        LDA.B [$CC],Y                        ;84A552;0000CC;
        ORA.B #$40                           ;84A554;      ;
        %Set8bit(!M)                             ;84A556;      ;
        %Set16bit(!X)                             ;84A558;      ;
        LDY.W #$0001                         ;84A55A;      ;
        STA.B [$CC],Y                        ;84A55D;0000CC;
        %Set16bit(!MX)                             ;84A55F;      ;
        LDA.W #$0000                         ;84A561;      ;
        %Set8bit(!M)                             ;84A564;      ;
        %Set16bit(!X)                             ;84A566;      ;
        LDY.W #$003F                         ;84A568;      ;
        LDA.B [$CC],Y                        ;84A56B;0000CC;
        SEC                                  ;84A56D;      ;
        SBC.B #$18                           ;84A56E;      ;
        %Set16bit(!M)                             ;84A570;      ;
        ASL A                                ;84A572;      ;
        ASL A                                ;84A573;      ;
        TAX                                  ;84A574;      ;
        %Set8bit(!M)                             ;84A575;      ;
        LDY.W #$0002                         ;84A577;      ;
        LDA.B #$27                           ;84A57A;      ;
        STA.B [$72],Y                        ;84A57C;000072;
        %Set16bit(!M)                             ;84A57E;      ;
        LDY.W #$0008                         ;84A580;      ;
        LDA.L Cow_BarnSpawnPositionTable,X           ;84A583;83CA44;
        STA.B [$72],Y                        ;84A587;000072;
        LDY.W #$000A                         ;84A589;      ;
        LDA.L Cow_BarnSpawnPositionTable,X           ;84A58C;83CA44;
        STA.B [$72],Y                        ;84A590;000072;
        JMP.W .EventScriptBank84_Branch_84A46E                    ;84A592;84A46E;

    .EventScriptBank84_Branch_84A595:
        %Set8bit(!M)                             ;84A595;      ;
        %Set16bit(!X)                             ;84A597;      ;
        LDY.W #$0000                         ;84A599;      ;
        LDA.B #$00                           ;84A59C;      ;
        STA.B [$CC],Y                        ;84A59E;0000CC;
        %Set8bit(!M)                             ;84A5A0;      ;
        %Set16bit(!X)                             ;84A5A2;      ;
        LDY.W #$0001                         ;84A5A4;      ;
        LDA.B [$CC],Y                        ;84A5A7;0000CC;
        ORA.B #$40                           ;84A5A9;      ;
        %Set8bit(!M)                             ;84A5AB;      ;
        %Set16bit(!X)                             ;84A5AD;      ;
        LDY.W #$0001                         ;84A5AF;      ;
        STA.B [$CC],Y                        ;84A5B2;0000CC;
        %Set8bit(!M)                             ;84A5B4;      ;
        LDY.W #$0002                         ;84A5B6;      ;
        LDA.L !season                        ;84A5B9;7F1F19;
        STA.B [$72],Y                        ;84A5BD;000072;
        %Set16bit(!M)                             ;84A5BF;      ;
        LDY.W #$0008                         ;84A5C1;      ;
        LDA.W #$0148                         ;84A5C4;      ;
        STA.B [$72],Y                        ;84A5C7;000072;
        LDY.W #$000A                         ;84A5C9;      ;
        LDA.W #$0178                         ;84A5CC;      ;
        STA.B [$72],Y                        ;84A5CF;000072;
        JMP.W .EventScriptBank84_Branch_84A46E                    ;84A5D1;84A46E;

        ;;;;;;;; $72 comes pre packed with the cow's pointer. A is ammount to change
    .AddCowHappiness:
        %Set16bit(!MX)
        STA.B $7E
        LDA.W #$0000
        %Set8bit(!M)
        LDY.W #$0004                         ;Happiness
        LDA.B [$72],Y                        ;cow pointer loaded
        %Set16bit(!M)
        STA.B $80
        LDA.B $80
        CLC
        ADC.B $7E
        BMI .negative
        CMP.W #256
        BCS .over
        %Set8bit(!M)
        STA.B [$72],Y
        BRA .return

    .negative:
        %Set8bit(!M)
        LDA.B #$00
        STA.B [$72],Y
        BRA .return

    .over:
        %Set8bit(!M)
        LDA.B #255
        STA.B [$72],Y

    .return: RTL

    .EventScriptBank84_Branch_84A607:
        %Set8bit(!M)                             ;84A607;      ;
        %Set16bit(!X)                             ;84A609;      ;
        LDY.W #$0001                         ;84A60B;      ;
        LDA.B [$72],Y                        ;84A60E;000072;
        AND.B #$08                           ;84A610;      ;
        BEQ .EventScriptBank84_Branch_84A617                      ;84A612;84A617;
        JMP.W .EventScriptBank84_Branch_84A70E                    ;84A614;84A70E;

    .EventScriptBank84_Branch_84A617:
        LDY.W #$0001                         ;84A617;      ;
        LDA.B [$72],Y                        ;84A61A;000072;
        ORA.B #$08                           ;84A61C;      ;
        STA.B [$72],Y                        ;84A61E;000072;
        %Set8bit(!M)                             ;84A620;      ;
        %Set16bit(!X)                             ;84A622;      ;
        LDY.W #$003F                         ;84A624;      ;
        LDA.B [$CC],Y                        ;84A627;0000CC;
        SEC                                  ;84A629;      ;
        SBC.B #$18                           ;84A62A;      ;
        XBA                                  ;84A62C;      ;
        LDA.B #$00                           ;84A62D;      ;
        XBA                                  ;84A62F;      ;
        %Set16bit(!M)                             ;84A630;      ;
        ASL A                                ;84A632;      ;
        TAX                                  ;84A633;      ;
        STZ.W $0953,X                        ;84A634;000953;
        %Set8bit(!M)                             ;84A637;      ;
        LDY.W #$0000                         ;84A639;      ;
        LDA.B [$72],Y                        ;84A63C;000072;
        AND.B #$08                           ;84A63E;      ;
        BEQ .EventScriptBank84_Branch_84A645                      ;84A640;84A645;
        JMP.W .EventScriptBank84_Branch_84A6BD                    ;84A642;84A6BD;

    .EventScriptBank84_Branch_84A645:
        LDA.B [$72],Y                        ;84A645;000072;
        AND.B #$04                           ;84A647;      ;
        BEQ .EventScriptBank84_Branch_84A64E                      ;84A649;84A64E;
        JMP.W .EventScriptBank84_Branch_84A68C                    ;84A64B;84A68C;

    .EventScriptBank84_Branch_84A64E:
        LDA.B [$72],Y                        ;84A64E;000072;
        AND.B #$02                           ;84A650;      ;
        BEQ .EventScriptBank84_Branch_84A657                      ;84A652;84A657;
        JMP.W .EventScriptBank84_Branch_84A65A                    ;84A654;84A65A;

    .EventScriptBank84_Branch_84A657: JMP.W .EventScriptBank84_Branch_84A70E                    ;84A657;84A70E;

    .EventScriptBank84_Branch_84A65A:
        %Set8bit(!M)                             ;84A65A;      ;
        %Set16bit(!X)                             ;84A65C;      ;
        LDY.W #$0001                         ;84A65E;      ;
        LDA.B [$CC],Y                        ;84A661;0000CC;
        ORA.B #$28                           ;84A663;      ;
        %Set8bit(!M)                             ;84A665;      ;
        %Set16bit(!X)                             ;84A667;      ;
        LDY.W #$0001                         ;84A669;      ;
        STA.B [$CC],Y                        ;84A66C;0000CC;
        %Set16bit(!MX)                             ;84A66E;      ;
        %Set8bit(!M)                             ;84A670;      ;
        %Set16bit(!X)                             ;84A672;      ;
        LDY.W #$003F                         ;84A674;      ;
        LDA.B [$CC],Y                        ;84A677;0000CC;
        XBA                                  ;84A679;      ;
        LDA.B #$00                           ;84A67A;      ;
        XBA                                  ;84A67C;      ;
        %Set16bit(!M)                             ;84A67D;      ;
        LDX.W #$0000                         ;84A67F;      ;
        LDY.W #$0078                         ;84A682;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84A685;84803F;
        JMP.W .EventScriptBank84_Branch_84A70E                    ;84A689;84A70E;

    .EventScriptBank84_Branch_84A68C:
        %Set8bit(!M)                             ;84A68C;      ;
        %Set16bit(!X)                             ;84A68E;      ;
        LDY.W #$0001                         ;84A690;      ;
        LDA.B [$CC],Y                        ;84A693;0000CC;
        ORA.B #$28                           ;84A695;      ;
        %Set8bit(!M)                             ;84A697;      ;
        %Set16bit(!X)                             ;84A699;      ;
        LDY.W #$0001                         ;84A69B;      ;
        STA.B [$CC],Y                        ;84A69E;0000CC;
        %Set16bit(!MX)                             ;84A6A0;      ;
        %Set8bit(!M)                             ;84A6A2;      ;
        %Set16bit(!X)                             ;84A6A4;      ;
        LDY.W #$003F                         ;84A6A6;      ;
        LDA.B [$CC],Y                        ;84A6A9;0000CC;
        XBA                                  ;84A6AB;      ;
        LDA.B #$00                           ;84A6AC;      ;
        XBA                                  ;84A6AE;      ;
        %Set16bit(!M)                             ;84A6AF;      ;
        LDX.W #$0000                         ;84A6B1;      ;
        LDY.W #$0074                         ;84A6B4;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84A6B7;84803F;
        BRA .EventScriptBank84_Branch_84A70E                      ;84A6BB;84A70E;

    .EventScriptBank84_Branch_84A6BD:
        %Set8bit(!M)                             ;84A6BD;      ;
        LDY.W #$0000                         ;84A6BF;      ;
        LDA.B [$72],Y                        ;84A6C2;000072;
        AND.B #$40                           ;84A6C4;      ;
        BNE .EventScriptBank84_Branch_84A70E                      ;84A6C6;84A70E;
        LDA.B [$72],Y                        ;84A6C8;000072;
        AND.B #$20                           ;84A6CA;      ;
        BNE .EventScriptBank84_Branch_84A6DE                      ;84A6CC;84A6DE;
        LDA.B [$72],Y                        ;84A6CE;000072;
        AND.B #$10                           ;84A6D0;      ;
        BNE .EventScriptBank84_Branch_84A6D9                      ;84A6D2;84A6D9;
        LDX.W #$005E                         ;84A6D4;      ;
        BRA .EventScriptBank84_Branch_84A6E1                      ;84A6D7;84A6E1;

    .EventScriptBank84_Branch_84A6D9:
        LDX.W #$0070                         ;84A6D9;      ;
        BRA .EventScriptBank84_Branch_84A6E1                      ;84A6DC;84A6E1;

    .EventScriptBank84_Branch_84A6DE: LDX.W #$006C                         ;84A6DE;      ;

    .EventScriptBank84_Branch_84A6E1:
        %Set8bit(!M)                             ;84A6E1;      ;
        %Set16bit(!X)                             ;84A6E3;      ;
        LDY.W #$0001                         ;84A6E5;      ;
        LDA.B [$CC],Y                        ;84A6E8;0000CC;
        ORA.B #$28                           ;84A6EA;      ;
        %Set8bit(!M)                             ;84A6EC;      ;
        %Set16bit(!X)                             ;84A6EE;      ;
        LDY.W #$0001                         ;84A6F0;      ;
        STA.B [$CC],Y                        ;84A6F3;0000CC;
        %Set16bit(!MX)                             ;84A6F5;      ;
        %Set8bit(!M)                             ;84A6F7;      ;
        %Set16bit(!X)                             ;84A6F9;      ;
        LDY.W #$003F                         ;84A6FB;      ;
        LDA.B [$CC],Y                        ;84A6FE;0000CC;
        XBA                                  ;84A700;      ;
        LDA.B #$00                           ;84A701;      ;
        XBA                                  ;84A703;      ;
        %Set16bit(!M)                             ;84A704;      ;
        TXY                                  ;84A706;      ;
        LDX.W #$0000                         ;84A707;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84A70A;84803F;

    .EventScriptBank84_Branch_84A70E:
        %Set16bit(!MX)                             ;84A70E;      ;
        %Set16bit(!MX)                             ;84A710;      ;
        LDA.B !player_direction                            ;84A712;0000DA;
        CMP.W #$0000                         ;84A714;      ;
        BNE .EventScriptBank84_Branch_84A71C                      ;84A717;84A71C;
        JMP.W .EventScriptBank84_Branch_84A8D7                    ;84A719;84A8D7;

    .EventScriptBank84_Branch_84A71C:
        %Set16bit(!MX)                             ;84A71C;      ;
        LDA.B !player_direction                            ;84A71E;0000DA;
        CMP.W #$0001                         ;84A720;      ;
        BNE .EventScriptBank84_Branch_84A728                      ;84A723;84A728;
        JMP.W .EventScriptBank84_Branch_84A8E5                    ;84A725;84A8E5;

    .EventScriptBank84_Branch_84A728:
        %Set16bit(!MX)                             ;84A728;      ;
        LDA.B !player_direction                            ;84A72A;0000DA;
        CMP.W #$0002                         ;84A72C;      ;
        BNE .EventScriptBank84_Branch_84A734                      ;84A72F;84A734;
        JMP.W .EventScriptBank84_Branch_84A8F3                    ;84A731;84A8F3;

    .EventScriptBank84_Branch_84A734:
        %Set16bit(!MX)                             ;84A734;      ;
        LDA.B !player_direction                            ;84A736;0000DA;
        CMP.W #$0003                         ;84A738;      ;
        BNE .EventScriptBank84_Branch_84A740                      ;84A73B;84A740;
        JMP.W .EventScriptBank84_Branch_84A901                    ;84A73D;84A901;

    .EventScriptBank84_Branch_84A740:
        %Set8bit(!M)                             ;84A740;      ;
        %Set16bit(!X)                             ;84A742;      ;
        LDY.W #$0001                         ;84A744;      ;
        LDA.B [$72],Y                        ;84A747;000072;
        AND.B #$08                           ;84A749;      ;
        BEQ .EventScriptBank84_Branch_84A750                      ;84A74B;84A750;
        JMP.W .EventScriptBank84_Branch_84A84A                    ;84A74D;84A84A;

    .EventScriptBank84_Branch_84A750:
        LDY.W #$0001                         ;84A750;      ;
        LDA.B [$72],Y                        ;84A753;000072;
        ORA.B #$08                           ;84A755;      ;
        STA.B [$72],Y                        ;84A757;000072;
        %Set8bit(!M)                             ;84A759;      ;
        %Set16bit(!X)                             ;84A75B;      ;
        LDY.W #$003F                         ;84A75D;      ;
        LDA.B [$CC],Y                        ;84A760;0000CC;
        SEC                                  ;84A762;      ;
        SBC.B #$18                           ;84A763;      ;
        XBA                                  ;84A765;      ;
        LDA.B #$00                           ;84A766;      ;
        XBA                                  ;84A768;      ;
        %Set16bit(!M)                             ;84A769;      ;
        ASL A                                ;84A76B;      ;
        TAX                                  ;84A76C;      ;
        STZ.W $0953,X                        ;84A76D;000953;
        %Set8bit(!M)                             ;84A770;      ;
        LDY.W #$0000                         ;84A772;      ;
        LDA.B [$72],Y                        ;84A775;000072;
        AND.B #$08                           ;84A777;      ;
        BEQ .EventScriptBank84_Branch_84A77E                      ;84A779;84A77E;
        JMP.W .EventScriptBank84_Branch_84A7F6                    ;84A77B;84A7F6;

    .EventScriptBank84_Branch_84A77E:
        LDA.B [$72],Y                        ;84A77E;000072;
        AND.B #$04                           ;84A780;      ;
        BEQ .EventScriptBank84_Branch_84A787                      ;84A782;84A787;
        JMP.W .EventScriptBank84_Branch_84A7C5                    ;84A784;84A7C5;

    .EventScriptBank84_Branch_84A787:
        LDA.B [$72],Y                        ;84A787;000072;
        AND.B #$02                           ;84A789;      ;
        BEQ .EventScriptBank84_Branch_84A790                      ;84A78B;84A790;
        JMP.W .EventScriptBank84_Branch_84A793                    ;84A78D;84A793;

    .EventScriptBank84_Branch_84A790: JMP.W .EventScriptBank84_Branch_84A84A                    ;84A790;84A84A;

    .EventScriptBank84_Branch_84A793:
        %Set8bit(!M)                             ;84A793;      ;
        %Set16bit(!X)                             ;84A795;      ;
        LDY.W #$0001                         ;84A797;      ;
        LDA.B [$CC],Y                        ;84A79A;0000CC;
        ORA.B #$28                           ;84A79C;      ;
        %Set8bit(!M)                             ;84A79E;      ;
        %Set16bit(!X)                             ;84A7A0;      ;
        LDY.W #$0001                         ;84A7A2;      ;
        STA.B [$CC],Y                        ;84A7A5;0000CC;
        %Set16bit(!MX)                             ;84A7A7;      ;
        %Set8bit(!M)                             ;84A7A9;      ;
        %Set16bit(!X)                             ;84A7AB;      ;
        LDY.W #$003F                         ;84A7AD;      ;
        LDA.B [$CC],Y                        ;84A7B0;0000CC;
        XBA                                  ;84A7B2;      ;
        LDA.B #$00                           ;84A7B3;      ;
        XBA                                  ;84A7B5;      ;
        %Set16bit(!M)                             ;84A7B6;      ;
        LDX.W #$0000                         ;84A7B8;      ;
        LDY.W #$0078                         ;84A7BB;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84A7BE;84803F;
        JMP.W .EventScriptBank84_Branch_84A84A                    ;84A7C2;84A84A;

    .EventScriptBank84_Branch_84A7C5:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        ORA.B #$28
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        STA.B [$CC],Y
        %Set16bit(!MX)
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        LDA.B [$CC],Y
        XBA
        LDA.B #$00
        XBA
        %Set16bit(!M)
        LDX.W #$0000
        LDY.W #$0074
        JSL.L EventScript_LoadScriptPointerShort
        BRA .EventScriptBank84_Branch_84A84A

    .EventScriptBank84_Branch_84A7F6:
        %Set8bit(!M)
        LDY.W #$0000
        LDA.B [$72],Y
        AND.B #$40
        BEQ .EventScriptBank84_Branch_84A804
        JMP.W .EventScriptBank84_Branch_84A84A

    .EventScriptBank84_Branch_84A804:
        LDA.B [$72],Y
        AND.B #$20
        BNE .EventScriptBank84_Branch_84A81A
        LDA.B [$72],Y
        AND.B #$10
        BNE .EventScriptBank84_Branch_84A815
        LDX.W #$005E
        BRA .EventScriptBank84_Branch_84A81D

    .EventScriptBank84_Branch_84A815:
        LDX.W #$0070
        BRA .EventScriptBank84_Branch_84A81D

    .EventScriptBank84_Branch_84A81A: LDX.W #$006C

    .EventScriptBank84_Branch_84A81D:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        ORA.B #$28
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        STA.B [$CC],Y
        %Set16bit(!MX)
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$003F
        LDA.B [$CC],Y
        XBA
        LDA.B #$00
        XBA
        %Set16bit(!M)
        TXY
        LDX.W #$0000
        JSL.L EventScript_LoadScriptPointerShort

    .EventScriptBank84_Branch_84A84A:
        %Set16bit(!MX)
        STZ.B $82
        STZ.B $84
        %Set16bit(!MX)
        LDY.W #$001A
        LDA.B [$CC],Y
        SEC
        SBC.B !player_pos_X
        STA.B $7E
        BMI .EventScriptBank84_Branch_84A860
        BRA .EventScriptBank84_Branch_84A86D

    .EventScriptBank84_Branch_84A860:
        %Set16bit(!M)
        EOR.W #$FFFF
        INC A
        STA.B $7E
        LDA.W #$0001
        STA.B $82

    .EventScriptBank84_Branch_84A86D:
        %Set16bit(!MX)
        LDY.W #$001C
        LDA.B [$CC],Y
        SEC
        SBC.B !player_pos_Y
        STA.B $80
        BMI .EventScriptBank84_Branch_84A87D
        BRA .EventScriptBank84_Branch_84A88A

    .EventScriptBank84_Branch_84A87D:
        %Set16bit(!M)
        EOR.W #$FFFF
        INC A
        STA.B $80
        LDA.W #$0001
        STA.B $84

    .EventScriptBank84_Branch_84A88A:
        %Set8bit(!M)
        LDA.B #$20
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0008
        STA.B [$CC],Y
        %Set16bit(!M)
        LDA.B $80
        CMP.B $7E
        BCS .EventScriptBank84_Branch_84A8B2
        %Set8bit(!M)
        LDY.W #$0000
        LDA.B [$72],Y
        AND.B #$10
        BNE .EventScriptBank84_Branch_84A8C7
        %Set16bit(!M)
        LDA.B $82
        BEQ .EventScriptBank84_Branch_84A901
        BRA .EventScriptBank84_Branch_84A8F3

    .EventScriptBank84_Branch_84A8B2:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0000
        LDA.B [$72],Y
        AND.B #$10
        BNE .EventScriptBank84_Branch_84A8CF
        %Set16bit(!M)
        LDA.B $84
        BEQ .EventScriptBank84_Branch_84A8E5
        BRA .EventScriptBank84_Branch_84A8D7

    .EventScriptBank84_Branch_84A8C7:
        %Set16bit(!M)
        LDA.B $82
        BEQ .EventScriptBank84_Branch_84A8F3
        BRA .EventScriptBank84_Branch_84A901

    .EventScriptBank84_Branch_84A8CF:
        %Set16bit(!M)
        LDA.B $84
        BEQ .EventScriptBank84_Branch_84A8D7
        BRA .EventScriptBank84_Branch_84A8E5

    .EventScriptBank84_Branch_84A8D7:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000F
        LDA.B #$01
        STA.B [$CC],Y
        JMP.W .EventScriptBank84_Branch_84A48A

    .EventScriptBank84_Branch_84A8E5:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000F
        LDA.B #$02
        STA.B [$CC],Y
        JMP.W .EventScriptBank84_Branch_84A48A

    .EventScriptBank84_Branch_84A8F3:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000F
        LDA.B #$04
        STA.B [$CC],Y
        JMP.W .EventScriptBank84_Branch_84A48A

    .EventScriptBank84_Branch_84A901:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000F
        LDA.B #$08
        STA.B [$CC],Y
        JMP.W .EventScriptBank84_Branch_84A48A

;;;;;;;;
EventCmd_32_StoreValue:
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $72
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.B $74
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B [$72]
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_33_PickupMoleRelated: ;84A94C
        %Set16bit(!MX)                             ;      ;
        %Set16bit(!MX)                             ;84A94E;      ;
        LDA.B $C9                            ;84A950;0000C9;
        CLC                                  ;84A952;      ;
        ADC.W #$0001                         ;84A953;      ;
        STA.B $C9                            ;84A956;0000C9;
        %Set8bit(!M)                             ;84A958;      ;
        %Set16bit(!X)                             ;84A95A;      ;
        LDY.W #$000C                         ;84A95C;      ;
        LDA.B [$CC],Y                        ;84A95F;0000CC;
        CMP.B #$00                           ;84A961;      ;
        BNE .EventScriptBank84_Branch_84A968                      ;84A963;84A968;
        JMP.W .EventScriptBank84_Branch_84AA1E                    ;84A965;84AA1E;

    .EventScriptBank84_Branch_84A968:
        %Set16bit(!MX)                             ;84A968;      ;
        LDA.B !player_action                            ;84A96A;0000D4;
        CMP.W #$000A                         ;84A96C;      ;
        BNE .EventScriptBank84_Branch_84A974                      ;84A96F;84A974;
        JMP.W .EventScriptBank84_Branch_84AA1E                    ;84A971;84AA1E;

    .EventScriptBank84_Branch_84A974:
        %Set16bit(!MX)                             ;84A974;      ;
        LDA.B !player_action                            ;84A976;0000D4;
        CMP.W #$000C                         ;84A978;      ;
        BNE .EventScriptBank84_Branch_84A980                      ;84A97B;84A980;
        JMP.W .EventScriptBank84_Branch_84AA1E                    ;84A97D;84AA1E;

    .EventScriptBank84_Branch_84A980:
        %Set16bit(!MX)                             ;84A980;      ;
        LDA.B !player_action                            ;84A982;0000D4;
        CMP.W #$000D                         ;84A984;      ;
        BNE .EventScriptBank84_Branch_84A98C                      ;84A987;84A98C;
        JMP.W .EventScriptBank84_Branch_84AA1E                    ;84A989;84AA1E;

    .EventScriptBank84_Branch_84A98C:
        %Set16bit(!MX)                             ;84A98C;      ;
        LDA.B !player_action                            ;84A98E;0000D4;
        CMP.W #$001B                         ;84A990;      ;
        BNE .EventScriptBank84_Branch_84A998                      ;84A993;84A998;
        JMP.W .EventScriptBank84_Branch_84AA1E                    ;84A995;84AA1E;

    .EventScriptBank84_Branch_84A998:
        %Set16bit(!M)                             ;84A998;      ;
        LDA.B !game_state                            ;84A99A;0000D2;
        AND.W #$0004                         ;84A99C;      ;
        BNE .EventScriptBank84_Branch_84AA1E                      ;84A99F;84AA1E;
        LDA.L $7F1F60                        ;84A9A1;7F1F60;
        AND.W #$0006                         ;84A9A5;      ;
        BNE .EventScriptBank84_Branch_84AA1E                      ;84A9A8;84AA1E;
        %Set16bit(!M)                             ;84A9AA;      ;
        LDA.W !Joy1_New_Input                          ;84A9AC;000128;
        BIT.W #$0080                         ;84A9AF;      ;
        BNE .EventScriptBank84_Branch_84A9B7                      ;84A9B2;84A9B7;
        JMP.W .EventScriptBank84_Branch_84AA1E                    ;84A9B4;84AA1E;

    .EventScriptBank84_Branch_84A9B7:
        %Set16bit(!MX)                             ;84A9B7;      ;
        LDA.B !game_state                            ;84A9B9;0000D2;
        AND.W #$0800                         ;84A9BB;      ;
        BEQ .EventScriptBank84_Branch_84A9C3                      ;84A9BE;84A9C3;
        JMP.W .EventScriptBank84_Branch_84AA1E                    ;84A9C0;84AA1E;

    .EventScriptBank84_Branch_84A9C3:
        LDA.B !player_action                            ;84A9C3;0000D4;
        CMP.W #$0017                         ;84A9C5;      ;
        BNE .EventScriptBank84_Branch_84A9CD                      ;84A9C8;84A9CD;
        JMP.W .EventScriptBank84_Branch_84AA1E                    ;84A9CA;84AA1E;

    .EventScriptBank84_Branch_84A9CD:
        %Set8bit(!M)                             ;84A9CD;      ;
        LDA.W !item_on_hand                          ;84A9CF;00091D;
        BEQ .EventScriptBank84_Branch_84A9D7                      ;84A9D2;84A9D7;
        JMP.W .EventScriptBank84_Branch_84AA1E                    ;84A9D4;84AA1E;

    .EventScriptBank84_Branch_84A9D7:
        %Set8bit(!M)                             ;84A9D7;      ;
        %Set16bit(!X)                             ;84A9D9;      ;
        LDY.W #$003F                         ;84A9DB;      ;
        LDA.B [$CC],Y                        ;84A9DE;0000CC;
        STA.W $0920                          ;84A9E0;000920;
        %Set8bit(!M)                             ;84A9E3;      ;
        %Set16bit(!X)                             ;84A9E5;      ;
        LDY.W #$0000                         ;84A9E7;      ;
        LDA.B #$00                           ;84A9EA;      ;
        STA.B [$CC],Y                        ;84A9EC;0000CC;
        %Set8bit(!M)                             ;84A9EE;      ;
        %Set16bit(!X)                             ;84A9F0;      ;
        LDY.W #$0001                         ;84A9F2;      ;
        LDA.B [$CC],Y                        ;84A9F5;0000CC;
        ORA.B #$40                           ;84A9F7;      ;
        %Set8bit(!M)                             ;84A9F9;      ;
        %Set16bit(!X)                             ;84A9FB;      ;
        LDY.W #$0001                         ;84A9FD;      ;
        STA.B [$CC],Y                        ;84AA00;0000CC;
        %Set16bit(!MX)                             ;84AA02;      ;
        LDY.W #$0010                         ;84AA04;      ;
        LDA.B [$CC],Y                        ;84AA07;0000CC;
        CLC                                  ;84AA09;      ;
        ADC.W #$0001                         ;84AA0A;      ;
        STA.B [$CC],Y                        ;84AA0D;0000CC;
        %Set8bit(!M)                             ;84AA0F;      ;
        LDA.B #$29                           ;84AA11;      ;
        STA.W !item_on_hand                          ;84AA13;00091D;
        %Set16bit(!MX)                             ;84AA16;      ;
        LDA.W #$0004                         ;84AA18;      ;
        STA.B !player_action                            ;84AA1B;0000D4;

        RTS                                  ;84AA1D;      ;

    .EventScriptBank84_Branch_84AA1E:
        %Set8bit(!M)                             ;84AA1E;      ;
        LDA.W $093A                          ;84AA20;00093A;
        CMP.B #$B4                           ;84AA23;      ;
        BEQ .EventScriptBank84_Branch_84AA2E                      ;84AA25;84AA2E;
        INC A                                ;84AA27;      ;
        STA.W $093A                          ;84AA28;00093A;
        JMP.W .EventScriptBank84_Branch_84AA4F                    ;84AA2B;84AA4F;

    .EventScriptBank84_Branch_84AA2E:
        %Set8bit(!M)                             ;84AA2E;      ;
        STZ.W $093A                          ;84AA30;00093A;
        %Set16bit(!MX)                             ;84AA33;      ;
        %Set8bit(!M)                             ;84AA35;      ;
        LDA.B $DE                            ;84AA37;0000DE;
        AND.B #$80                           ;84AA39;      ;
        BNE .EventScriptBank84_Branch_84AA40                      ;84AA3B;84AA40;
        JMP.W .EventScriptBank84_Branch_84AA4F                    ;84AA3D;84AA4F;

    .EventScriptBank84_Branch_84AA40:
        %Set16bit(!MX)                             ;84AA40;      ;
        LDA.W #$0011                         ;84AA42;      ;
        LDX.W #$0000                         ;84AA45;      ;
        LDY.W #$0081                         ;84AA48;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84AA4B;84803F;

    .EventScriptBank84_Branch_84AA4F:
        %Set16bit(!MX)                             ;84AA4F;      ;
        LDY.W #$0010                         ;84AA51;      ;
        LDA.B [$CC],Y                        ;84AA54;0000CC;
        CLC                                  ;84AA56;      ;
        ADC.W #$0001                         ;84AA57;      ;
        STA.B [$CC],Y                        ;84AA5A;0000CC;

        RTS                                  ;84AA5C;      ;

;;;;;;;;
EventCmd_34_FishingRelated: ;84AA5D
        %Set16bit(!MX)                             ;      ;
        %Set16bit(!MX)                             ;84AA5F;      ;
        LDA.B $C9                            ;84AA61;0000C9;
        CLC                                  ;84AA63;      ;
        ADC.W #$0001                         ;84AA64;      ;
        STA.B $C9                            ;84AA67;0000C9;
        %Set8bit(!M)                             ;84AA69;      ;
        %Set16bit(!X)                             ;84AA6B;      ;
        LDY.W #$000C                         ;84AA6D;      ;
        LDA.B [$CC],Y                        ;84AA70;0000CC;
        CMP.B #$00                           ;84AA72;      ;
        BNE .EventScriptBank84_Branch_84AA79                      ;84AA74;84AA79;
        JMP.W .EventScriptBank84_Branch_84AB19                    ;84AA76;84AB19;

    .EventScriptBank84_Branch_84AA79:
        %Set16bit(!MX)                             ;84AA79;      ;
        LDA.B !player_action                            ;84AA7B;0000D4;
        CMP.W #$000A                         ;84AA7D;      ;
        BNE .EventScriptBank84_Branch_84AA85                      ;84AA80;84AA85;
        JMP.W .EventScriptBank84_Branch_84AB19                    ;84AA82;84AB19;

    .EventScriptBank84_Branch_84AA85:
        %Set16bit(!MX)                             ;84AA85;      ;
        LDA.B !player_action                            ;84AA87;0000D4;
        CMP.W #$000C                         ;84AA89;      ;
        BNE .EventScriptBank84_Branch_84AA91                      ;84AA8C;84AA91;
        JMP.W .EventScriptBank84_Branch_84AB19                    ;84AA8E;84AB19;

    .EventScriptBank84_Branch_84AA91:
        %Set16bit(!MX)                             ;84AA91;      ;
        LDA.B !player_action                            ;84AA93;0000D4;
        CMP.W #$000D                         ;84AA95;      ;
        BNE .EventScriptBank84_Branch_84AA9D                      ;84AA98;84AA9D;
        JMP.W .EventScriptBank84_Branch_84AB19                    ;84AA9A;84AB19;

    .EventScriptBank84_Branch_84AA9D:
        %Set16bit(!MX)                             ;84AA9D;      ;
        LDA.B !player_action                            ;84AA9F;0000D4;
        CMP.W #$001B                         ;84AAA1;      ;
        BNE .EventScriptBank84_Branch_84AAA9                      ;84AAA4;84AAA9;
        JMP.W .EventScriptBank84_Branch_84AB19                    ;84AAA6;84AB19;

    .EventScriptBank84_Branch_84AAA9:
        %Set16bit(!M)                             ;84AAA9;      ;
        LDA.B !game_state                            ;84AAAB;0000D2;
        AND.W #$0004                         ;84AAAD;      ;
        BNE .EventScriptBank84_Branch_84AB19                      ;84AAB0;84AB19;
        LDA.L $7F1F60                        ;84AAB2;7F1F60;
        AND.W #$0006                         ;84AAB6;      ;
        BNE .EventScriptBank84_Branch_84AB19                      ;84AAB9;84AB19;
        %Set16bit(!M)                             ;84AABB;      ;
        LDA.W !Joy1_New_Input                          ;84AABD;000128;
        BIT.W #$0080                         ;84AAC0;      ;
        BNE .EventScriptBank84_Branch_84AAC8                      ;84AAC3;84AAC8;
        JMP.W .EventScriptBank84_Branch_84AB19                    ;84AAC5;84AB19;

    .EventScriptBank84_Branch_84AAC8:
        %Set8bit(!M)                             ;84AAC8;      ;
        LDA.W !item_on_hand                          ;84AACA;00091D;
        BEQ .EventScriptBank84_Branch_84AAD2                      ;84AACD;84AAD2;
        JMP.W .EventScriptBank84_Branch_84AB19                    ;84AACF;84AB19;

    .EventScriptBank84_Branch_84AAD2:
        %Set8bit(!M)                             ;84AAD2;      ;
        %Set16bit(!X)                             ;84AAD4;      ;
        LDY.W #$003F                         ;84AAD6;      ;
        LDA.B [$CC],Y                        ;84AAD9;0000CC;
        STA.W $0920                          ;84AADB;000920;
        %Set8bit(!M)                             ;84AADE;      ;
        %Set16bit(!X)                             ;84AAE0;      ;
        LDY.W #$0000                         ;84AAE2;      ;
        LDA.B #$00                           ;84AAE5;      ;
        STA.B [$CC],Y                        ;84AAE7;0000CC;
        %Set8bit(!M)                             ;84AAE9;      ;
        %Set16bit(!X)                             ;84AAEB;      ;
        LDY.W #$0001                         ;84AAED;      ;
        LDA.B [$CC],Y                        ;84AAF0;0000CC;
        ORA.B #$40                           ;84AAF2;      ;
        %Set8bit(!M)                             ;84AAF4;      ;
        %Set16bit(!X)                             ;84AAF6;      ;
        LDY.W #$0001                         ;84AAF8;      ;
        STA.B [$CC],Y                        ;84AAFB;0000CC;
        %Set16bit(!MX)                             ;84AAFD;      ;
        LDY.W #$0010                         ;84AAFF;      ;
        LDA.B [$CC],Y                        ;84AB02;0000CC;
        CLC                                  ;84AB04;      ;
        ADC.W #$0001                         ;84AB05;      ;
        STA.B [$CC],Y                        ;84AB08;0000CC;
        %Set8bit(!M)                             ;84AB0A;      ;
        LDA.B #$07                           ;84AB0C;      ;
        STA.W !item_on_hand                          ;84AB0E;00091D;
        %Set16bit(!MX)                             ;84AB11;      ;
        LDA.W #$0004                         ;84AB13;      ;
        STA.B !player_action                            ;84AB16;0000D4;

        RTS                                  ;84AB18;      ;

    .EventScriptBank84_Branch_84AB19:
        %Set16bit(!MX)                             ;84AB19;      ;
        LDY.W #$0010                         ;84AB1B;      ;
        LDA.B [$CC],Y                        ;84AB1E;0000CC;
        CLC                                  ;84AB20;      ;
        ADC.W #$0001                         ;84AB21;      ;
        STA.B [$CC],Y                        ;84AB24;0000CC;

        RTS                                  ;84AB26;      ;

;;;;;;;;
EventCmd_35_PlayerPositionCheck: ;84AB27
        %Set16bit(!MX)                             ;      ;
        %Set16bit(!MX)                             ;84AB29;      ;
        LDA.B $C9                            ;84AB2B;0000C9;
        CLC                                  ;84AB2D;      ;
        ADC.W #$0001                         ;84AB2E;      ;
        STA.B $C9                            ;84AB31;0000C9;
        %Set16bit(!M)                             ;84AB33;      ;
        LDA.L $7F1F5C                        ;84AB35;7F1F5C;
        AND.W #$FFEF                         ;84AB39;      ;
        STA.L $7F1F5C                        ;84AB3C;7F1F5C;
        %Set8bit(!M)                             ;84AB40;      ;
        LDA.L $7F1F32                        ;84AB42;7F1F32;
        CMP.B #$15                           ;84AB46;      ;
        BEQ .EventScriptBank84_Branch_84AB73                      ;84AB48;84AB73;
        %Set8bit(!M)                             ;84AB4A;      ;
        LDA.W $0939                          ;84AB4C;000939;
        CMP.B #$78                           ;84AB4F;      ;
        BEQ .EventScriptBank84_Branch_84AB5A                      ;84AB51;84AB5A;
        INC A                                ;84AB53;      ;
        STA.W $0939                          ;84AB54;000939;
        JMP.W .EventScriptBank84_Branch_84AD88                    ;84AB57;84AD88;

    .EventScriptBank84_Branch_84AB5A:
        %Set8bit(!M)                             ;84AB5A;      ;
        %Set16bit(!X)                             ;84AB5C;      ;
        STZ.W $0939                          ;84AB5E;000939;
        %Set16bit(!M)                             ;84AB61;      ;
        LDA.W #$0017                         ;84AB63;      ;
        LDX.W #$0000                         ;84AB66;      ;
        LDY.W #$0080                         ;84AB69;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84AB6C;84803F;
        JMP.W .EventScriptBank84_Branch_84AD88                    ;84AB70;84AD88;

    .EventScriptBank84_Branch_84AB73:
        %Set16bit(!M)                             ;84AB73;      ;
        LDA.L $7F1F5C                        ;84AB75;7F1F5C;
        AND.W #$0040                         ;84AB79;      ;
        BNE .EventScriptBank84_Branch_84AB81                      ;84AB7C;84AB81;
        JMP.W .EventScriptBank84_Branch_84ABDF                    ;84AB7E;84ABDF;

    .EventScriptBank84_Branch_84AB81:
        %Set8bit(!M)                             ;84AB81;      ;
        %Set16bit(!X)                             ;84AB83;      ;
        LDY.W #$0002                         ;84AB85;      ;
        LDA.B [$CC],Y                        ;84AB88;0000CC;
        CMP.B #$00                           ;84AB8A;      ;
        BEQ .EventScriptBank84_Branch_84AB9A                      ;84AB8C;84AB9A;
        CMP.B #$01                           ;84AB8E;      ;
        BEQ .EventScriptBank84_Branch_84ABA7                      ;84AB90;84ABA7;
        CMP.B #$02                           ;84AB92;      ;
        BEQ .EventScriptBank84_Branch_84ABB4                      ;84AB94;84ABB4;
        CMP.B #$03                           ;84AB96;      ;
        BEQ .EventScriptBank84_Branch_84ABC1                      ;84AB98;84ABC1;

    .EventScriptBank84_Branch_84AB9A:
        %Set16bit(!M)                             ;84AB9A;      ;
        LDA.W #$0017                         ;84AB9C;      ;
        LDX.W #$0000                         ;84AB9F;      ;
        LDY.W #$0028                         ;84ABA2;      ;
        BRA .EventScriptBank84_Branch_84ABCE                      ;84ABA5;84ABCE;

    .EventScriptBank84_Branch_84ABA7:
        %Set16bit(!M)                             ;84ABA7;      ;
        LDA.W #$0017                         ;84ABA9;      ;
        LDX.W #$0000                         ;84ABAC;      ;
        LDY.W #$0029                         ;84ABAF;      ;
        BRA .EventScriptBank84_Branch_84ABCE                      ;84ABB2;84ABCE;

    .EventScriptBank84_Branch_84ABB4:
        %Set16bit(!M)                             ;84ABB4;      ;
        LDA.W #$0017                         ;84ABB6;      ;
        LDX.W #$0000                         ;84ABB9;      ;
        LDY.W #$002A                         ;84ABBC;      ;
        BRA .EventScriptBank84_Branch_84ABCE                      ;84ABBF;84ABCE;

    .EventScriptBank84_Branch_84ABC1:
        %Set16bit(!M)                             ;84ABC1;      ;
        LDA.W #$0017                         ;84ABC3;      ;
        LDX.W #$0000                         ;84ABC6;      ;
        LDY.W #$002B                         ;84ABC9;      ;
        BRA .EventScriptBank84_Branch_84ABCE                      ;84ABCC;84ABCE;

    .EventScriptBank84_Branch_84ABCE:
        JSL.L EventScript_LoadScriptPointerShort                    ;84ABCE;84803F;
        %Set16bit(!MX)                             ;84ABD2;      ;
        LDA.L $7F1F5C                        ;84ABD4;7F1F5C;
        AND.W #$FFBF                         ;84ABD8;      ;
        STA.L $7F1F5C                        ;84ABDB;7F1F5C;

    .EventScriptBank84_Branch_84ABDF:
        %Set16bit(!MX)                             ;84ABDF;      ;
        LDA.L $7F1F5C                        ;84ABE1;7F1F5C;
        AND.W #$0800                         ;84ABE5;      ;
        BEQ .EventScriptBank84_Branch_84ABED                      ;84ABE8;84ABED;
        JMP.W .EventScriptBank84_Branch_84ACEE                    ;84ABEA;84ACEE;

    .EventScriptBank84_Branch_84ABED:
        LDA.L $7F1F5C                        ;84ABED;7F1F5C;
        AND.W #$0020                         ;84ABF1;      ;
        BEQ .EventScriptBank84_Branch_84ABF9                      ;84ABF4;84ABF9;
        JMP.W .EventScriptBank84_Branch_84ADA4                    ;84ABF6;84ADA4;

    .EventScriptBank84_Branch_84ABF9:
        %Set8bit(!M)                             ;84ABF9;      ;
        %Set16bit(!X)                             ;84ABFB;      ;
        LDY.W #$000C                         ;84ABFD;      ;
        LDA.B [$CC],Y                        ;84AC00;0000CC;
        CMP.B #$00                           ;84AC02;      ;
        BNE .EventScriptBank84_Branch_84AC09                      ;84AC04;84AC09;
        JMP.W .EventScriptBank84_Branch_84ACEE                    ;84AC06;84ACEE;

    .EventScriptBank84_Branch_84AC09:
        %Set16bit(!MX)                             ;84AC09;      ;
        LDA.B !player_action                            ;84AC0B;0000D4;
        CMP.W #$000A                         ;84AC0D;      ;
        BNE .EventScriptBank84_Branch_84AC15                      ;84AC10;84AC15;
        JMP.W .EventScriptBank84_Branch_84ACEE                    ;84AC12;84ACEE;

    .EventScriptBank84_Branch_84AC15:
        %Set16bit(!MX)                             ;84AC15;      ;
        LDA.B !player_action                            ;84AC17;0000D4;
        CMP.W #$000C                         ;84AC19;      ;
        BNE .EventScriptBank84_Branch_84AC21                      ;84AC1C;84AC21;
        JMP.W .EventScriptBank84_Branch_84ACEE                    ;84AC1E;84ACEE;

    .EventScriptBank84_Branch_84AC21:
        %Set16bit(!MX)                             ;84AC21;      ;
        LDA.B !player_action                            ;84AC23;0000D4;
        CMP.W #$000D                         ;84AC25;      ;
        BNE .EventScriptBank84_Branch_84AC2D                      ;84AC28;84AC2D;
        JMP.W .EventScriptBank84_Branch_84ACEE                    ;84AC2A;84ACEE;

    .EventScriptBank84_Branch_84AC2D:
        %Set16bit(!MX)                             ;84AC2D;      ;
        LDA.B !player_action                            ;84AC2F;0000D4;
        CMP.W #$001B                         ;84AC31;      ;
        BNE .EventScriptBank84_Branch_84AC39                      ;84AC34;84AC39;
        JMP.W .EventScriptBank84_Branch_84ACEE                    ;84AC36;84ACEE;

    .EventScriptBank84_Branch_84AC39:
        %Set16bit(!M)                             ;84AC39;      ;
        LDA.B !game_state                            ;84AC3B;0000D2;
        AND.W #$0004                         ;84AC3D;      ;
        BEQ .EventScriptBank84_Branch_84AC45                      ;84AC40;84AC45;
        JMP.W .EventScriptBank84_Branch_84ACEE                    ;84AC42;84ACEE;

    .EventScriptBank84_Branch_84AC45:
        LDA.L $7F1F60                        ;84AC45;7F1F60;
        AND.W #$0006                         ;84AC49;      ;
        BEQ .EventScriptBank84_Branch_84AC51                      ;84AC4C;84AC51;
        JMP.W .EventScriptBank84_Branch_84ACEE                    ;84AC4E;84ACEE;

    .EventScriptBank84_Branch_84AC51:
        %Set16bit(!M)                             ;84AC51;      ;
        LDA.L $7F1F5C                        ;84AC53;7F1F5C;
        ORA.W #$0010                         ;84AC57;      ;
        STA.L $7F1F5C                        ;84AC5A;7F1F5C;
        %Set16bit(!M)                             ;84AC5E;      ;
        LDA.W !Joy1_New_Input                          ;84AC60;000128;
        BIT.W #$0080                         ;84AC63;      ;
        BNE .EventScriptBank84_Branch_84AC6B                      ;84AC66;84AC6B;
        JMP.W .EventScriptBank84_Branch_84ACEE                    ;84AC68;84ACEE;

    .EventScriptBank84_Branch_84AC6B:
        %Set16bit(!MX)                             ;84AC6B;      ;
        LDA.W #$000D                         ;84AC6D;      ;
        STA.B $E3                            ;84AC70;0000E3;
        LDA.B !player_pos_X                           ;84AC72;0000D6;
        STA.B $DF                            ;84AC74;0000DF;
        LDA.B !player_pos_Y                            ;84AC76;0000D8;
        STA.B $E1                            ;84AC78;0000E1;
        STZ.B $E5                            ;84AC7A;0000E5;
        STZ.B $E7                            ;84AC7C;0000E7;
        LDA.W $0913                          ;84AC7E;000913;
        JSL.L Collision_CheckObjectOverlapAtDirection                          ;84AC81;83AF37;
        %Set16bit(!MX)                             ;84AC85;      ;
        BEQ .EventScriptBank84_Branch_84AC8C                      ;84AC87;84AC8C;
        JMP.W .EventScriptBank84_Branch_84ACEE                    ;84AC89;84ACEE;

    .EventScriptBank84_Branch_84AC8C:
        LDA.B $E9                            ;84AC8C;0000E9;
        SEC                                  ;84AC8E;      ;
        SBC.W #$00C0                         ;84AC8F;      ;
        CMP.W #$0010                         ;84AC92;      ;
        BCS .EventScriptBank84_Branch_84AC9A                      ;84AC95;84AC9A;
        JMP.W .EventScriptBank84_Branch_84ACEE                    ;84AC97;84ACEE;

    .EventScriptBank84_Branch_84AC9A:
        LDA.B $EB                            ;84AC9A;0000EB;
        SEC                                  ;84AC9C;      ;
        SBC.W #$00C0                         ;84AC9D;      ;
        CMP.W #$0010                         ;84ACA0;      ;
        BCS .EventScriptBank84_Branch_84ACA8                      ;84ACA3;84ACA8;
        JMP.W .EventScriptBank84_Branch_84ACEE                    ;84ACA5;84ACEE;

    .EventScriptBank84_Branch_84ACA8:
        %Set16bit(!M)                             ;84ACA8;      ;
        LDA.W #$0020                         ;84ACAA;      ;
        STA.B $E3                            ;84ACAD;0000E3;
        LDA.W $0913                          ;84ACAF;000913;
        JSL.L Collision_CheckMapTileAtDirection                          ;84ACB2;83AD91;
        %Set16bit(!MX)                             ;84ACB6;      ;
        CMP.W #$0000                         ;84ACB8;      ;
        BEQ .EventScriptBank84_Branch_84ACC0                      ;84ACBB;84ACC0;
        JMP.W .EventScriptBank84_Branch_84ACEE                    ;84ACBD;84ACEE;

    .EventScriptBank84_Branch_84ACC0:
        %Set16bit(!MX)                             ;84ACC0;      ;
        LDA.B !game_state                            ;84ACC2;0000D2;
        AND.W #$0002                         ;84ACC4;      ;
        BEQ .EventScriptBank84_Branch_84ACCC                      ;84ACC7;84ACCC;
        JMP.W .EventScriptBank84_Branch_84AD88                    ;84ACC9;84AD88;

    .EventScriptBank84_Branch_84ACCC:
        %Set16bit(!MX)                             ;84ACCC;      ;
        LDA.B !game_state                            ;84ACCE;0000D2;
        AND.W #$0800                         ;84ACD0;      ;
        BEQ .EventScriptBank84_Branch_84ACD8                      ;84ACD3;84ACD8;
        JMP.W .EventScriptBank84_Branch_84AD88                    ;84ACD5;84AD88;

    .EventScriptBank84_Branch_84ACD8:
        %Set16bit(!MX)                             ;84ACD8;      ;
        LDA.B !player_action                            ;84ACDA;0000D4;
        CMP.W #$0004                         ;84ACDC;      ;
        BNE .EventScriptBank84_Branch_84ACE4                      ;84ACDF;84ACE4;
        JMP.W .EventScriptBank84_Branch_84AD88                    ;84ACE1;84AD88;

    .EventScriptBank84_Branch_84ACE4:
        %Set16bit(!MX)                             ;84ACE4;      ;
        LDA.W #$0017                         ;84ACE6;      ;
        STA.B !player_action                            ;84ACE9;0000D4;
        JMP.W .EventScriptBank84_Branch_84AD88                    ;84ACEB;84AD88;

    .EventScriptBank84_Branch_84ACEE:
        %Set16bit(!MX)                             ;84ACEE;      ;
        LDA.L $7F1F5C                        ;84ACF0;7F1F5C;
        AND.W #$F7FF                         ;84ACF4;      ;
        STA.L $7F1F5C                        ;84ACF7;7F1F5C;
        %Set8bit(!M)                             ;84ACFB;      ;
        LDA.W $0939                          ;84ACFD;000939;
        CMP.B #$78                           ;84AD00;      ;
        BEQ .EventScriptBank84_Branch_84AD0B                      ;84AD02;84AD0B;
        INC A                                ;84AD04;      ;
        STA.W $0939                          ;84AD05;000939;
        JMP.W .EventScriptBank84_Branch_84AD88                    ;84AD08;84AD88;

    .EventScriptBank84_Branch_84AD0B:
        %Set8bit(!M)                             ;84AD0B;      ;
        STZ.W $0939                          ;84AD0D;000939;
        %Set8bit(!M)                             ;84AD10;      ;
        LDA.B $DE                            ;84AD12;0000DE;
        CMP.B #$24                           ;84AD14;      ;
        BCC .EventScriptBank84_Branch_84AD2E                      ;84AD16;84AD2E;
        CMP.B #$48                           ;84AD18;      ;
        BCC .EventScriptBank84_Branch_84AD2E                      ;84AD1A;84AD2E;
        CMP.B #$6C                           ;84AD1C;      ;
        BCC .EventScriptBank84_Branch_84AD40                      ;84AD1E;84AD40;
        CMP.B #$90                           ;84AD20;      ;
        BCC .EventScriptBank84_Branch_84AD52                      ;84AD22;84AD52;
        CMP.B #$B4                           ;84AD24;      ;
        BCC .EventScriptBank84_Branch_84AD64                      ;84AD26;84AD64;
        CMP.B #$D8                           ;84AD28;      ;
        BCC .EventScriptBank84_Branch_84AD64                      ;84AD2A;84AD64;
        BRA .EventScriptBank84_Branch_84AD76                      ;84AD2C;84AD76;

    .EventScriptBank84_Branch_84AD2E:
        %Set16bit(!MX)                             ;84AD2E;      ;
        LDA.W #$0017                         ;84AD30;      ;
        LDX.W #$0000                         ;84AD33;      ;
        LDY.W #$004B                         ;84AD36;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84AD39;84803F;
        JMP.W .EventScriptBank84_Branch_84AD88                    ;84AD3D;84AD88;

    .EventScriptBank84_Branch_84AD40:
        %Set16bit(!MX)                             ;84AD40;      ;
        LDA.W #$0017                         ;84AD42;      ;
        LDX.W #$0000                         ;84AD45;      ;
        LDY.W #$004D                         ;84AD48;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84AD4B;84803F;
        JMP.W .EventScriptBank84_Branch_84AD88                    ;84AD4F;84AD88;

    .EventScriptBank84_Branch_84AD52:
        %Set16bit(!MX)                             ;84AD52;      ;
        LDA.W #$0017                         ;84AD54;      ;
        LDX.W #$0000                         ;84AD57;      ;
        LDY.W #$004E                         ;84AD5A;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84AD5D;84803F;
        JMP.W .EventScriptBank84_Branch_84AD88                    ;84AD61;84AD88;

    .EventScriptBank84_Branch_84AD64:
        %Set16bit(!MX)                             ;84AD64;      ;
        LDA.W #$0017                         ;84AD66;      ;
        LDX.W #$0000                         ;84AD69;      ;
        LDY.W #$004F                         ;84AD6C;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84AD6F;84803F;
        JMP.W .EventScriptBank84_Branch_84AD88                    ;84AD73;84AD88;

    .EventScriptBank84_Branch_84AD76:
        %Set16bit(!MX)                             ;84AD76;      ;
        LDA.W #$0017                         ;84AD78;      ;
        LDX.W #$0000                         ;84AD7B;      ;
        LDY.W #$0050                         ;84AD7E;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84AD81;84803F;
        JMP.W .EventScriptBank84_Branch_84AD88                    ;84AD85;84AD88;

    .EventScriptBank84_Branch_84AD88:
        %Set16bit(!MX)                             ;84AD88;      ;
        LDA.L $7F1F5C                        ;84AD8A;7F1F5C;
        AND.W #$0400                         ;84AD8E;      ;
        BEQ .EventScriptBank84_Branch_84AD96                      ;84AD91;84AD96;
        JMP.W .EventScriptBank84_Branch_84ADF2                    ;84AD93;84ADF2;

    .EventScriptBank84_Branch_84AD96:
        %Set16bit(!MX)                             ;84AD96;      ;
        LDY.W #$0010                         ;84AD98;      ;
        LDA.B [$CC],Y                        ;84AD9B;0000CC;
        CLC                                  ;84AD9D;      ;
        ADC.W #$0001                         ;84AD9E;      ;
        STA.B [$CC],Y                        ;84ADA1;0000CC;

        RTS                                  ;84ADA3;      ;

    .EventScriptBank84_Branch_84ADA4:
        %Set16bit(!MX)                             ;84ADA4;      ;
        LDA.B !game_state                            ;84ADA6;0000D2;
        ORA.W #$0010                         ;84ADA8;      ;
        STA.B !game_state                            ;84ADAB;0000D2;
        %Set16bit(!M)                             ;84ADAD;      ;
        LDA.L $7F1F5C                        ;84ADAF;7F1F5C;
        AND.W #$FFDF                         ;84ADB3;      ;
        STA.L $7F1F5C                        ;84ADB6;7F1F5C;
        %Set8bit(!M)                             ;84ADBA;      ;
        %Set16bit(!X)                             ;84ADBC;      ;
        LDY.W #$0000                         ;84ADBE;      ;
        LDA.B #$00                           ;84ADC1;      ;
        STA.B [$CC],Y                        ;84ADC3;0000CC;
        %Set8bit(!M)                             ;84ADC5;      ;
        %Set16bit(!X)                             ;84ADC7;      ;
        LDY.W #$0001                         ;84ADC9;      ;
        LDA.B [$CC],Y                        ;84ADCC;0000CC;
        ORA.B #$40                           ;84ADCE;      ;
        %Set8bit(!M)                             ;84ADD0;      ;
        %Set16bit(!X)                             ;84ADD2;      ;
        LDY.W #$0001                         ;84ADD4;      ;
        STA.B [$CC],Y                        ;84ADD7;0000CC;
        %Set8bit(!M)                             ;84ADD9;      ;
        %Set16bit(!X)                             ;84ADDB;      ;
        LDY.W #$000C                         ;84ADDD;      ;
        LDA.B #$00                           ;84ADE0;      ;
        STA.B [$CC],Y                        ;84ADE2;0000CC;
        %Set16bit(!MX)                             ;84ADE4;      ;
        LDY.W #$0010                         ;84ADE6;      ;
        LDA.B [$CC],Y                        ;84ADE9;0000CC;
        CLC                                  ;84ADEB;      ;
        ADC.W #$0001                         ;84ADEC;      ;
        STA.B [$CC],Y                        ;84ADEF;0000CC;

        RTS                                  ;84ADF1;      ;

    .EventScriptBank84_Branch_84ADF2:
        %Set8bit(!M)                             ;84ADF2;      ;
        %Set16bit(!X)                             ;84ADF4;      ;
        LDA.L $7F1F32                        ;84ADF6;7F1F32;
        CMP.B #$15                           ;84ADFA;      ;
        BEQ .EventScriptBank84_Branch_84AE01                      ;84ADFC;84AE01;
        JMP.W .EventScriptBank84_Branch_84AE35                    ;84ADFE;84AE35;

    .EventScriptBank84_Branch_84AE01:
        STZ.W $0939                          ;84AE01;000939;
        %Set8bit(!M)                             ;84AE04;      ;
        %Set16bit(!X)                             ;84AE06;      ;
        LDY.W #$0001                         ;84AE08;      ;
        LDA.B [$CC],Y                        ;84AE0B;0000CC;
        ORA.B #$28                           ;84AE0D;      ;
        %Set8bit(!M)                             ;84AE0F;      ;
        %Set16bit(!X)                             ;84AE11;      ;
        LDY.W #$0001                         ;84AE13;      ;
        STA.B [$CC],Y                        ;84AE16;0000CC;
        %Set16bit(!MX)                             ;84AE18;      ;
        %Set8bit(!M)                             ;84AE1A;      ;
        %Set16bit(!X)                             ;84AE1C;      ;
        LDY.W #$003F                         ;84AE1E;      ;
        LDA.B [$CC],Y                        ;84AE21;0000CC;
        XBA                                  ;84AE23;      ;
        LDA.B #$00                           ;84AE24;      ;
        XBA                                  ;84AE26;      ;
        %Set16bit(!M)                             ;84AE27;      ;
        LDX.W #$0000                         ;84AE29;      ;
        LDY.W #$004C                         ;84AE2C;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84AE2F;84803F;
        BRA .EventScriptBank84_Branch_84AE69                      ;84AE33;84AE69;

    .EventScriptBank84_Branch_84AE35:
        STZ.W $0939                          ;84AE35;000939;
        %Set8bit(!M)                             ;84AE38;      ;
        %Set16bit(!X)                             ;84AE3A;      ;
        LDY.W #$0001                         ;84AE3C;      ;
        LDA.B [$CC],Y                        ;84AE3F;0000CC;
        ORA.B #$28                           ;84AE41;      ;
        %Set8bit(!M)                             ;84AE43;      ;
        %Set16bit(!X)                             ;84AE45;      ;
        LDY.W #$0001                         ;84AE47;      ;
        STA.B [$CC],Y                        ;84AE4A;0000CC;
        %Set16bit(!MX)                             ;84AE4C;      ;
        %Set8bit(!M)                             ;84AE4E;      ;
        %Set16bit(!X)                             ;84AE50;      ;
        LDY.W #$003F                         ;84AE52;      ;
        LDA.B [$CC],Y                        ;84AE55;0000CC;
        XBA                                  ;84AE57;      ;
        LDA.B #$00                           ;84AE58;      ;
        XBA                                  ;84AE5A;      ;
        %Set16bit(!M)                             ;84AE5B;      ;
        LDX.W #$0000                         ;84AE5D;      ;
        LDY.W #$004A                         ;84AE60;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84AE63;84803F;
        BRA .EventScriptBank84_Branch_84AE69                      ;84AE67;84AE69;

    .EventScriptBank84_Branch_84AE69:
        %Set16bit(!MX)                             ;84AE69;      ;
        STZ.B $82                            ;84AE6B;000082;
        STZ.B $84                            ;84AE6D;000084;
        %Set16bit(!MX)                             ;84AE6F;      ;
        LDY.W #$001A                         ;84AE71;      ;
        LDA.B [$CC],Y                        ;84AE74;0000CC;
        SEC                                  ;84AE76;      ;
        SBC.B !player_pos_X                           ;84AE77;0000D6;
        STA.B $7E                            ;84AE79;00007E;
        BMI .EventScriptBank84_Branch_84AE7F                      ;84AE7B;84AE7F;
        BRA .EventScriptBank84_Branch_84AE8C                      ;84AE7D;84AE8C;

    .EventScriptBank84_Branch_84AE7F:
        %Set16bit(!M)                             ;84AE7F;      ;
        EOR.W #$FFFF                         ;84AE81;      ;
        INC A                                ;84AE84;      ;
        STA.B $7E                            ;84AE85;00007E;
        LDA.W #$0001                         ;84AE87;      ;
        STA.B $82                            ;84AE8A;000082;

    .EventScriptBank84_Branch_84AE8C:
        %Set16bit(!MX)                             ;84AE8C;      ;
        LDY.W #$001C                         ;84AE8E;      ;
        LDA.B [$CC],Y                        ;84AE91;0000CC;
        SEC                                  ;84AE93;      ;
        SBC.B !player_pos_Y                            ;84AE94;0000D8;
        STA.B $80                            ;84AE96;000080;
        BMI .EventScriptBank84_Branch_84AE9C                      ;84AE98;84AE9C;
        BRA .EventScriptBank84_Branch_84AEA9                      ;84AE9A;84AEA9;

    .EventScriptBank84_Branch_84AE9C:
        %Set16bit(!M)                             ;84AE9C;      ;
        EOR.W #$FFFF                         ;84AE9E;      ;
        INC A                                ;84AEA1;      ;
        STA.B $80                            ;84AEA2;000080;
        LDA.W #$0001                         ;84AEA4;      ;
        STA.B $84                            ;84AEA7;000084;

    .EventScriptBank84_Branch_84AEA9:
        %Set8bit(!M)                             ;84AEA9;      ;
        LDA.B #$20                           ;84AEAB;      ;
        %Set8bit(!M)                             ;84AEAD;      ;
        %Set16bit(!X)                             ;84AEAF;      ;
        LDY.W #$0008                         ;84AEB1;      ;
        STA.B [$CC],Y                        ;84AEB4;0000CC;
        %Set16bit(!M)                             ;84AEB6;      ;
        LDA.B $80                            ;84AEB8;000080;
        CMP.B $7E                            ;84AEBA;00007E;
        BCS .EventScriptBank84_Branch_84AEC6                      ;84AEBC;84AEC6;
        %Set16bit(!M)                             ;84AEBE;      ;
        LDA.B $82                            ;84AEC0;000082;
        BEQ .EventScriptBank84_Branch_84AEF8                      ;84AEC2;84AEF8;
        BRA .EventScriptBank84_Branch_84AEEA                      ;84AEC4;84AEEA;

    .EventScriptBank84_Branch_84AEC6:
        %Set16bit(!M)                             ;84AEC6;      ;
        LDA.B $84                            ;84AEC8;000084;
        BEQ .EventScriptBank84_Branch_84AEDC                      ;84AECA;84AEDC;
        BRA .EventScriptBank84_Branch_84AECE                      ;84AECC;84AECE;

    .EventScriptBank84_Branch_84AECE:
        %Set8bit(!M)                             ;84AECE;      ;
        %Set16bit(!X)                             ;84AED0;      ;
        LDY.W #$000F                         ;84AED2;      ;
        LDA.B #$01                           ;84AED5;      ;
        STA.B [$CC],Y                        ;84AED7;0000CC;
        JMP.W .EventScriptBank84_Branch_84AD96                    ;84AED9;84AD96;

    .EventScriptBank84_Branch_84AEDC:
        %Set8bit(!M)                             ;84AEDC;      ;
        %Set16bit(!X)                             ;84AEDE;      ;
        LDY.W #$000F                         ;84AEE0;      ;
        LDA.B #$02                           ;84AEE3;      ;
        STA.B [$CC],Y                        ;84AEE5;0000CC;
        JMP.W .EventScriptBank84_Branch_84AD96                    ;84AEE7;84AD96;

    .EventScriptBank84_Branch_84AEEA:
        %Set8bit(!M)                             ;84AEEA;      ;
        %Set16bit(!X)                             ;84AEEC;      ;
        LDY.W #$000F                         ;84AEEE;      ;
        LDA.B #$04                           ;84AEF1;      ;
        STA.B [$CC],Y                        ;84AEF3;0000CC;
        JMP.W .EventScriptBank84_Branch_84AD96                    ;84AEF5;84AD96;

    .EventScriptBank84_Branch_84AEF8:
        %Set8bit(!M)                             ;84AEF8;      ;
        %Set16bit(!X)                             ;84AEFA;      ;
        LDY.W #$000F                         ;84AEFC;      ;
        LDA.B #$08                           ;84AEFF;      ;
        STA.B [$CC],Y                        ;84AF01;0000CC;
        JMP.W .EventScriptBank84_Branch_84AD96                    ;84AF03;84AD96;

;;;;;;;;
EventCmd_36_DogRelated: ;84AF06
        %Set16bit(!MX)                             ;      ;
        %Set16bit(!MX)                             ;84AF08;      ;
        LDA.B $C9                            ;84AF0A;0000C9;
        CLC                                  ;84AF0C;      ;
        ADC.W #$0001                         ;84AF0D;      ;
        STA.B $C9                            ;84AF10;0000C9;
        %Set16bit(!MX)                             ;84AF12;      ;
        LDY.W #$001A                         ;84AF14;      ;
        LDA.B [$CC],Y                        ;84AF17;0000CC;
        STA.L !dog_pos_X                        ;84AF19;7F1F2C;
        %Set16bit(!MX)                             ;84AF1D;      ;
        LDY.W #$001C                         ;84AF1F;      ;
        LDA.B [$CC],Y                        ;84AF22;0000CC;
        STA.L !dog_pos_Y                        ;84AF24;7F1F2E;
        %Set8bit(!M)                             ;84AF28;      ;
        %Set16bit(!X)                             ;84AF2A;      ;
        LDY.W #$000C                         ;84AF2C;      ;
        LDA.B [$CC],Y                        ;84AF2F;0000CC;
        CMP.B #$00                           ;84AF31;      ;
        BNE .EventScriptBank84_Branch_84AF38                      ;84AF33;84AF38;
        JMP.W .EventScriptBank84_Branch_84AFF4                    ;84AF35;84AFF4;

    .EventScriptBank84_Branch_84AF38:
        %Set16bit(!MX)                             ;84AF38;      ;
        LDA.B !player_action                            ;84AF3A;0000D4;
        CMP.W #$000A                         ;84AF3C;      ;
        BNE .EventScriptBank84_Branch_84AF44                      ;84AF3F;84AF44;
        JMP.W .EventScriptBank84_Branch_84AFF4                    ;84AF41;84AFF4;

    .EventScriptBank84_Branch_84AF44:
        %Set16bit(!MX)                             ;84AF44;      ;
        LDA.B !player_action                            ;84AF46;0000D4;
        CMP.W #$000C                         ;84AF48;      ;
        BNE .EventScriptBank84_Branch_84AF50                      ;84AF4B;84AF50;
        JMP.W .EventScriptBank84_Branch_84AFF4                    ;84AF4D;84AFF4;

    .EventScriptBank84_Branch_84AF50:
        %Set16bit(!MX)                             ;84AF50;      ;
        LDA.B !player_action                            ;84AF52;0000D4;
        CMP.W #$000D                         ;84AF54;      ;
        BNE .EventScriptBank84_Branch_84AF5C                      ;84AF57;84AF5C;
        JMP.W .EventScriptBank84_Branch_84AFF4                    ;84AF59;84AFF4;

    .EventScriptBank84_Branch_84AF5C:
        %Set16bit(!MX)                             ;84AF5C;      ;
        LDA.B !player_action                            ;84AF5E;0000D4;
        CMP.W #$001B                         ;84AF60;      ;
        BNE .EventScriptBank84_Branch_84AF68                      ;84AF63;84AF68;
        JMP.W .EventScriptBank84_Branch_84AFF4                    ;84AF65;84AFF4;

    .EventScriptBank84_Branch_84AF68:
        %Set16bit(!M)                             ;84AF68;      ;
        LDA.B !game_state                            ;84AF6A;0000D2;
        AND.W #$0004                         ;84AF6C;      ;
        BEQ .EventScriptBank84_Branch_84AF74                      ;84AF6F;84AF74;
        JMP.W .EventScriptBank84_Branch_84AFF4                    ;84AF71;84AFF4;

    .EventScriptBank84_Branch_84AF74:
        LDA.L $7F1F60                        ;84AF74;7F1F60;
        AND.W #$0006                         ;84AF78;      ;
        BNE .EventScriptBank84_Branch_84AFF4                      ;84AF7B;84AFF4;
        %Set16bit(!M)                             ;84AF7D;      ;
        LDA.W !Joy1_New_Input                          ;84AF7F;000128;
        BIT.W #$0080                         ;84AF82;      ;
        BNE .EventScriptBank84_Branch_84AF8A                      ;84AF85;84AF8A;
        JMP.W .EventScriptBank84_Branch_84AFF4                    ;84AF87;84AFF4;

    .EventScriptBank84_Branch_84AF8A:
        %Set8bit(!M)                             ;84AF8A;      ;
        LDA.W !item_on_hand                          ;84AF8C;00091D;
        BEQ .EventScriptBank84_Branch_84AF94                      ;84AF8F;84AF94;
        JMP.W .EventScriptBank84_Branch_84AFF4                    ;84AF91;84AFF4;

    .EventScriptBank84_Branch_84AF94:
        %Set16bit(!MX)                             ;84AF94;      ;
        LDA.B !game_state                            ;84AF96;0000D2;
        AND.W #$0800                         ;84AF98;      ;
        BEQ .EventScriptBank84_Branch_84AFA0                      ;84AF9B;84AFA0;
        JMP.W .EventScriptBank84_Branch_84AFF4                    ;84AF9D;84AFF4;

    .EventScriptBank84_Branch_84AFA0:
        LDA.B !game_state                            ;84AFA0;0000D2;
        AND.W #$0010                         ;84AFA2;      ;
        BEQ .EventScriptBank84_Branch_84AFAA                      ;84AFA5;84AFAA;
        JMP.W .EventScriptBank84_Branch_84AFF4                    ;84AFA7;84AFF4;

    .EventScriptBank84_Branch_84AFAA:
        LDA.B !player_action                            ;84AFAA;0000D4;
        CMP.W #$0017                         ;84AFAC;      ;
        BNE .EventScriptBank84_Branch_84AFB4                      ;84AFAF;84AFB4;
        JMP.W .EventScriptBank84_Branch_84AFF4                    ;84AFB1;84AFF4;

    .EventScriptBank84_Branch_84AFB4:
        LDA.B !player_action                            ;84AFB4;0000D4;
        CMP.W #$0004                         ;84AFB6;      ;
        BNE .EventScriptBank84_Branch_84AFBE                      ;84AFB9;84AFBE;
        JMP.W .EventScriptBank84_Branch_84AFF4                    ;84AFBB;84AFF4;

    .EventScriptBank84_Branch_84AFBE:
        %Set8bit(!M)                             ;84AFBE;      ;
        %Set16bit(!X)                             ;84AFC0;      ;
        LDY.W #$0000                         ;84AFC2;      ;
        LDA.B #$00                           ;84AFC5;      ;
        STA.B [$CC],Y                        ;84AFC7;0000CC;
        %Set8bit(!M)                             ;84AFC9;      ;
        %Set16bit(!X)                             ;84AFCB;      ;
        LDY.W #$0001                         ;84AFCD;      ;
        LDA.B [$CC],Y                        ;84AFD0;0000CC;
        ORA.B #$40                           ;84AFD2;      ;
        %Set8bit(!M)                             ;84AFD4;      ;
        %Set16bit(!X)                             ;84AFD6;      ;
        LDY.W #$0001                         ;84AFD8;      ;
        STA.B [$CC],Y                        ;84AFDB;0000CC;
        %Set16bit(!MX)                             ;84AFDD;      ;
        LDA.B !game_state                            ;84AFDF;0000D2;
        ORA.W #$0800                         ;84AFE1;      ;
        STA.B !game_state                            ;84AFE4;0000D2;
        %Set16bit(!MX)                             ;84AFE6;      ;
        LDA.L !dog_hugs                        ;84AFE8;7F1F52;
        INC A                                ;84AFEC;      ;
        STA.L !dog_hugs                        ;84AFED;7F1F52;
        JMP.W .EventScriptBank84_Branch_84B25C                    ;84AFF1;84B25C;

    .EventScriptBank84_Branch_84AFF4:
        %Set8bit(!M)                             ;84AFF4;      ;
        LDA.W $0938                          ;84AFF6;000938;
        CMP.B #$78                           ;84AFF9;      ;
        BEQ .EventScriptBank84_Branch_84B004                      ;84AFFB;84B004;
        INC A                                ;84AFFD;      ;
        STA.W $0938                          ;84AFFE;000938;
        JMP.W .EventScriptBank84_Branch_84B25C                    ;84B001;84B25C;

    .EventScriptBank84_Branch_84B004:
        %Set8bit(!M)                             ;84B004;      ;
        STZ.W $0938                          ;84B006;000938;
        %Set16bit(!MX)                             ;84B009;      ;
        LDA.L $7F1F58                        ;84B00B;7F1F58;
        AND.W #$0001                         ;84B00F;      ;
        BNE .EventScriptBank84_Branch_84B047                      ;84B012;84B047;
        LDA.L $7F1F58                        ;84B014;7F1F58;
        AND.W #$0002                         ;84B018;      ;
        BEQ .EventScriptBank84_Branch_84B020                      ;84B01B;84B020;
        JMP.W .EventScriptBank84_Branch_84B0FE                    ;84B01D;84B0FE;

    .EventScriptBank84_Branch_84B020:
        LDA.L $7F1F58                        ;84B020;7F1F58;
        AND.W #$0004                         ;84B024;      ;
        BEQ .EventScriptBank84_Branch_84B02C                      ;84B027;84B02C;
        JMP.W .EventScriptBank84_Branch_84B17F                    ;84B029;84B17F;

    .EventScriptBank84_Branch_84B02C:
        LDA.L $7F1F58                        ;84B02C;7F1F58;
        AND.W #$0008                         ;84B030;      ;
        BEQ .EventScriptBank84_Branch_84B038                      ;84B033;84B038;
        JMP.W .EventScriptBank84_Branch_84B1EA                    ;84B035;84B1EA;

    .EventScriptBank84_Branch_84B038:
        LDA.L $7F1F58                        ;84B038;7F1F58;
        AND.W #$0010                         ;84B03C;      ;
        BEQ .EventScriptBank84_Branch_84B044                      ;84B03F;84B044;
        JMP.W .EventScriptBank84_Branch_84B22D                    ;84B041;84B22D;

    .EventScriptBank84_Branch_84B044:
        JMP.W .EventScriptBank84_Branch_84B25C                    ;84B044;84B25C;

    .EventScriptBank84_Branch_84B047:
        %Set16bit(!MX)                             ;84B047;      ;
        %Set8bit(!M)                             ;84B049;      ;
        LDA.B $DE                            ;84B04B;0000DE;
        CMP.B #$40                           ;84B04D;      ;
        BCC .EventScriptBank84_Branch_84B05C                      ;84B04F;84B05C;
        CMP.B #$80                           ;84B051;      ;
        BCC .EventScriptBank84_Branch_84B07E                      ;84B053;84B07E;
        CMP.B #$C0                           ;84B055;      ;
        BCC .EventScriptBank84_Branch_84B07E                      ;84B057;84B07E;
        JMP.W .EventScriptBank84_Branch_84B25C                    ;84B059;84B25C;

    .EventScriptBank84_Branch_84B05C:
        %Set16bit(!MX)                             ;84B05C;      ;
        LDA.W #$0016                         ;84B05E;      ;
        LDX.W #$0000                         ;84B061;      ;
        LDY.W #$003D                         ;84B064;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84B067;84803F;
        %Set16bit(!MX)                             ;84B06B;      ;
        LDA.L $7F1F58                        ;84B06D;7F1F58;
        AND.W #$FFFE                         ;84B071;      ;
        ORA.W #$0002                         ;84B074;      ;
        STA.L $7F1F58                        ;84B077;7F1F58;
        JMP.W .EventScriptBank84_Branch_84B25C                    ;84B07B;84B25C;

    .EventScriptBank84_Branch_84B07E:
        %Set16bit(!MX)                             ;84B07E;      ;
        %Set8bit(!M)                             ;84B080;      ;
        LDA.B $DE                            ;84B082;0000DE;
        CMP.B #$33                           ;84B084;      ;
        BCC .EventScriptBank84_Branch_84B0A9                      ;84B086;84B0A9;
        CMP.B #$66                           ;84B088;      ;
        BCC .EventScriptBank84_Branch_84B0BA                      ;84B08A;84B0BA;
        CMP.B #$99                           ;84B08C;      ;
        BCC .EventScriptBank84_Branch_84B0CB                      ;84B08E;84B0CB;
        CMP.B #$CC                           ;84B090;      ;
        BCC .EventScriptBank84_Branch_84B0DC                      ;84B092;84B0DC;
        BRA .EventScriptBank84_Branch_84B0ED                      ;84B094;84B0ED;

    .EventScriptBank84_Branch_84B096:
        %Set16bit(!MX)                             ;84B096;      ;
        LDA.L $7F1F58                        ;84B098;7F1F58;
        AND.W #$FFFE                         ;84B09C;      ;
        ORA.W #$0010                         ;84B09F;      ;
        STA.L $7F1F58                        ;84B0A2;7F1F58;
        JMP.W .EventScriptBank84_Branch_84B25C                    ;84B0A6;84B25C;

    .EventScriptBank84_Branch_84B0A9:
        %Set16bit(!MX)                             ;84B0A9;      ;
        LDA.W #$0016                         ;84B0AB;      ;
        LDX.W #$0000                         ;84B0AE;      ;
        LDY.W #$003E                         ;84B0B1;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84B0B4;84803F;
        BRA .EventScriptBank84_Branch_84B096                      ;84B0B8;84B096;

    .EventScriptBank84_Branch_84B0BA:
        %Set16bit(!MX)                             ;84B0BA;      ;
        LDA.W #$0016                         ;84B0BC;      ;
        LDX.W #$0000                         ;84B0BF;      ;
        LDY.W #$0040                         ;84B0C2;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84B0C5;84803F;
        BRA .EventScriptBank84_Branch_84B096                      ;84B0C9;84B096;

    .EventScriptBank84_Branch_84B0CB:
        %Set16bit(!MX)                             ;84B0CB;      ;
        LDA.W #$0016                         ;84B0CD;      ;
        LDX.W #$0000                         ;84B0D0;      ;
        LDY.W #$0040                         ;84B0D3;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84B0D6;84803F;
        BRA .EventScriptBank84_Branch_84B096                      ;84B0DA;84B096;

    .EventScriptBank84_Branch_84B0DC:
        %Set16bit(!MX)                             ;84B0DC;      ;
        LDA.W #$0016                         ;84B0DE;      ;
        LDX.W #$0000                         ;84B0E1;      ;
        LDY.W #$0047                         ;84B0E4;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84B0E7;84803F;
        BRA .EventScriptBank84_Branch_84B096                      ;84B0EB;84B096;

    .EventScriptBank84_Branch_84B0ED:
        %Set16bit(!MX)                             ;84B0ED;      ;
        LDA.W #$0016                         ;84B0EF;      ;
        LDX.W #$0000                         ;84B0F2;      ;
        LDY.W #$0048                         ;84B0F5;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84B0F8;84803F;
        BRA .EventScriptBank84_Branch_84B096                      ;84B0FC;84B096;

    .EventScriptBank84_Branch_84B0FE:
        %Set16bit(!MX)                             ;84B0FE;      ;
        %Set8bit(!M)                             ;84B100;      ;
        LDA.B $DE                            ;84B102;0000DE;
        CMP.B #$2A                           ;84B104;      ;
        BCC .EventScriptBank84_Branch_84B117                      ;84B106;84B117;
        CMP.B #$54                           ;84B108;      ;
        BCC .EventScriptBank84_Branch_84B139                      ;84B10A;84B139;
        CMP.B #$7E                           ;84B10C;      ;
        BCC .EventScriptBank84_Branch_84B15B                      ;84B10E;84B15B;
        CMP.B #$A8                           ;84B110;      ;
        BCC .EventScriptBank84_Branch_84B16D                      ;84B112;84B16D;
        JMP.W .EventScriptBank84_Branch_84B25C                    ;84B114;84B25C;

    .EventScriptBank84_Branch_84B117:
        %Set16bit(!MX)                             ;84B117;      ;
        LDA.W #$0016                         ;84B119;      ;
        LDX.W #$0000                         ;84B11C;      ;
        LDY.W #$003C                         ;84B11F;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84B122;84803F;
        %Set16bit(!MX)                             ;84B126;      ;
        LDA.L $7F1F58                        ;84B128;7F1F58;
        AND.W #$FFFD                         ;84B12C;      ;
        ORA.W #$0001                         ;84B12F;      ;
        STA.L $7F1F58                        ;84B132;7F1F58;
        JMP.W .EventScriptBank84_Branch_84B25C                    ;84B136;84B25C;

    .EventScriptBank84_Branch_84B139:
        %Set16bit(!MX)                             ;84B139;      ;
        LDA.W #$0016                         ;84B13B;      ;
        LDX.W #$0000                         ;84B13E;      ;
        LDY.W #$0041                         ;84B141;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84B144;84803F;
        %Set16bit(!MX)                             ;84B148;      ;
        LDA.L $7F1F58                        ;84B14A;7F1F58;
        AND.W #$FFFD                         ;84B14E;      ;
        ORA.W #$0004                         ;84B151;      ;
        STA.L $7F1F58                        ;84B154;7F1F58;
        JMP.W .EventScriptBank84_Branch_84B25C                    ;84B158;84B25C;

    .EventScriptBank84_Branch_84B15B:
        %Set16bit(!MX)                             ;84B15B;      ;
        LDA.W #$0016                         ;84B15D;      ;
        LDX.W #$0000                         ;84B160;      ;
        LDY.W #$0049                         ;84B163;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84B166;84803F;
        JMP.W .EventScriptBank84_Branch_84B25C                    ;84B16A;84B25C;

    .EventScriptBank84_Branch_84B16D:
        %Set16bit(!MX)                             ;84B16D;      ;
        LDA.W #$0016                         ;84B16F;      ;
        LDX.W #$0000                         ;84B172;      ;
        LDY.W #$0044                         ;84B175;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84B178;84803F;
        JMP.W .EventScriptBank84_Branch_84B25C                    ;84B17C;84B25C;

    .EventScriptBank84_Branch_84B17F:
        %Set16bit(!MX)                             ;84B17F;      ;
        %Set8bit(!M)                             ;84B181;      ;
        LDA.B $DE                            ;84B183;0000DE;
        CMP.B #$2A                           ;84B185;      ;
        BCC .EventScriptBank84_Branch_84B194                      ;84B187;84B194;
        CMP.B #$54                           ;84B189;      ;
        BCC .EventScriptBank84_Branch_84B1B6                      ;84B18B;84B1B6;
        CMP.B #$7E                           ;84B18D;      ;
        BCC .EventScriptBank84_Branch_84B1D8                      ;84B18F;84B1D8;
        JMP.W .EventScriptBank84_Branch_84B25C                    ;84B191;84B25C;

    .EventScriptBank84_Branch_84B194:
        %Set16bit(!MX)                             ;84B194;      ;
        LDA.W #$0016                         ;84B196;      ;
        LDX.W #$0000                         ;84B199;      ;
        LDY.W #$003D                         ;84B19C;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84B19F;84803F;
        %Set16bit(!MX)                             ;84B1A3;      ;
        LDA.L $7F1F58                        ;84B1A5;7F1F58;
        AND.W #$FFFB                         ;84B1A9;      ;
        ORA.W #$0002                         ;84B1AC;      ;
        STA.L $7F1F58                        ;84B1AF;7F1F58;
        JMP.W .EventScriptBank84_Branch_84B25C                    ;84B1B3;84B25C;

    .EventScriptBank84_Branch_84B1B6:
        %Set16bit(!MX)                             ;84B1B6;      ;
        LDA.W #$0016                         ;84B1B8;      ;
        LDX.W #$0000                         ;84B1BB;      ;
        LDY.W #$0045                         ;84B1BE;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84B1C1;84803F;
        %Set16bit(!MX)                             ;84B1C5;      ;
        LDA.L $7F1F58                        ;84B1C7;7F1F58;
        AND.W #$FFFB                         ;84B1CB;      ;
        ORA.W #$0008                         ;84B1CE;      ;
        STA.L $7F1F58                        ;84B1D1;7F1F58;
        JMP.W .EventScriptBank84_Branch_84B25C                    ;84B1D5;84B25C;

    .EventScriptBank84_Branch_84B1D8:
        %Set16bit(!MX)                             ;84B1D8;      ;
        LDA.W #$0016                         ;84B1DA;      ;
        LDX.W #$0000                         ;84B1DD;      ;
        LDY.W #$0043                         ;84B1E0;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84B1E3;84803F;
        JMP.W .EventScriptBank84_Branch_84B25C                    ;84B1E7;84B25C;

    .EventScriptBank84_Branch_84B1EA:
        %Set16bit(!MX)                             ;84B1EA;      ;
        %Set8bit(!M)                             ;84B1EC;      ;
        LDA.B $DE                            ;84B1EE;0000DE;
        CMP.B #$2A                           ;84B1F0;      ;
        BCC .EventScriptBank84_Branch_84B1FB                      ;84B1F2;84B1FB;
        CMP.B #$54                           ;84B1F4;      ;
        BCC .EventScriptBank84_Branch_84B21C                      ;84B1F6;84B21C;
        JMP.W .EventScriptBank84_Branch_84B25C                    ;84B1F8;84B25C;

    .EventScriptBank84_Branch_84B1FB:
        %Set16bit(!MX)                             ;84B1FB;      ;
        LDA.W #$0016                         ;84B1FD;      ;
        LDX.W #$0000                         ;84B200;      ;
        LDY.W #$0041                         ;84B203;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84B206;84803F;
        %Set16bit(!MX)                             ;84B20A;      ;
        LDA.L $7F1F58                        ;84B20C;7F1F58;
        AND.W #$FFF7                         ;84B210;      ;
        ORA.W #$0004                         ;84B213;      ;
        STA.L $7F1F58                        ;84B216;7F1F58;
        BRA .EventScriptBank84_Branch_84B25C                      ;84B21A;84B25C;

    .EventScriptBank84_Branch_84B21C:
        %Set16bit(!MX)                             ;84B21C;      ;
        LDA.W #$0016                         ;84B21E;      ;
        LDX.W #$0000                         ;84B221;      ;
        LDY.W #$0046                         ;84B224;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84B227;84803F;
        BRA .EventScriptBank84_Branch_84B25C                      ;84B22B;84B25C;

    .EventScriptBank84_Branch_84B22D:
        %Set16bit(!MX)                             ;84B22D;      ;
        %Set8bit(!M)                             ;84B22F;      ;
        LDA.B $DE                            ;84B231;0000DE;
        CMP.B #$40                           ;84B233;      ;
        BCC .EventScriptBank84_Branch_84B23A                      ;84B235;84B23A;
        JMP.W .EventScriptBank84_Branch_84B25C                    ;84B237;84B25C;

    .EventScriptBank84_Branch_84B23A:
        %Set16bit(!MX)                             ;84B23A;      ;
        LDA.W #$0016                         ;84B23C;      ;
        LDX.W #$0000                         ;84B23F;      ;
        LDY.W #$003C                         ;84B242;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84B245;84803F;
        %Set16bit(!MX)                             ;84B249;      ;
        LDA.L $7F1F58                        ;84B24B;7F1F58;
        AND.W #$FFEF                         ;84B24F;      ;
        ORA.W #$0001                         ;84B252;      ;
        STA.L $7F1F58                        ;84B255;7F1F58;
        JMP.W .EventScriptBank84_Branch_84B25C                    ;84B259;84B25C;

    .EventScriptBank84_Branch_84B25C:
        %Set16bit(!MX)                             ;84B25C;      ;
        LDA.L $7F1F60                        ;84B25E;7F1F60;
        AND.W #$0010                         ;84B262;      ;
        BEQ .EventScriptBank84_Branch_84B26A                      ;84B265;84B26A;
        JMP.W .EventScriptBank84_Branch_84B278                    ;84B267;84B278;

    .EventScriptBank84_Branch_84B26A:
        %Set16bit(!MX)                             ;84B26A;      ;
        LDY.W #$0010                         ;84B26C;      ;
        LDA.B [$CC],Y                        ;84B26F;0000CC;
        CLC                                  ;84B271;      ;
        ADC.W #$0001                         ;84B272;      ;
        STA.B [$CC],Y                        ;84B275;0000CC;

        RTS                                  ;84B277;      ;

    .EventScriptBank84_Branch_84B278:
        %Set8bit(!M)                             ;84B278;      ;
        %Set16bit(!X)                             ;84B27A;      ;
        STZ.W $0938                          ;84B27C;000938;
        %Set8bit(!M)                             ;84B27F;      ;
        %Set16bit(!X)                             ;84B281;      ;
        LDY.W #$0001                         ;84B283;      ;
        LDA.B [$CC],Y                        ;84B286;0000CC;
        ORA.B #$28                           ;84B288;      ;
        %Set8bit(!M)                             ;84B28A;      ;
        %Set16bit(!X)                             ;84B28C;      ;
        LDY.W #$0001                         ;84B28E;      ;
        STA.B [$CC],Y                        ;84B291;0000CC;
        %Set16bit(!MX)                             ;84B293;      ;
        %Set8bit(!M)                             ;84B295;      ;
        %Set16bit(!X)                             ;84B297;      ;
        LDY.W #$003F                         ;84B299;      ;
        LDA.B [$CC],Y                        ;84B29C;0000CC;
        XBA                                  ;84B29E;      ;
        LDA.B #$00                           ;84B29F;      ;
        XBA                                  ;84B2A1;      ;
        %Set16bit(!M)                             ;84B2A2;      ;
        LDX.W #$0000                         ;84B2A4;      ;
        LDY.W #$003F                         ;84B2A7;      ;
        JSL.L EventScript_LoadScriptPointerShort                    ;84B2AA;84803F;
        %Set16bit(!MX)                             ;84B2AE;      ;
        STZ.B $82                            ;84B2B0;000082;
        STZ.B $84                            ;84B2B2;000084;
        %Set16bit(!MX)                             ;84B2B4;      ;
        LDY.W #$001A                         ;84B2B6;      ;
        LDA.B [$CC],Y                        ;84B2B9;0000CC;
        SEC                                  ;84B2BB;      ;
        SBC.B !player_pos_X                           ;84B2BC;0000D6;
        STA.B $7E                            ;84B2BE;00007E;
        BMI .EventScriptBank84_Branch_84B2C4                      ;84B2C0;84B2C4;
        BRA .EventScriptBank84_Branch_84B2D1                      ;84B2C2;84B2D1;

    .EventScriptBank84_Branch_84B2C4:
        %Set16bit(!M)                             ;84B2C4;      ;
        EOR.W #$FFFF                         ;84B2C6;      ;
        INC A                                ;84B2C9;      ;
        STA.B $7E                            ;84B2CA;00007E;
        LDA.W #$0001                         ;84B2CC;      ;
        STA.B $82                            ;84B2CF;000082;

    .EventScriptBank84_Branch_84B2D1:
        %Set16bit(!MX)                             ;84B2D1;      ;
        LDY.W #$001C                         ;84B2D3;      ;
        LDA.B [$CC],Y                        ;84B2D6;0000CC;
        SEC                                  ;84B2D8;      ;
        SBC.B !player_pos_Y                            ;84B2D9;0000D8;
        STA.B $80                            ;84B2DB;000080;
        BMI .EventScriptBank84_Branch_84B2E1                      ;84B2DD;84B2E1;
        BRA .EventScriptBank84_Branch_84B2EE                      ;84B2DF;84B2EE;

    .EventScriptBank84_Branch_84B2E1:
        %Set16bit(!M)                             ;84B2E1;      ;
        EOR.W #$FFFF                         ;84B2E3;      ;
        INC A                                ;84B2E6;      ;
        STA.B $80                            ;84B2E7;000080;
        LDA.W #$0001                         ;84B2E9;      ;
        STA.B $84                            ;84B2EC;000084;

    .EventScriptBank84_Branch_84B2EE:
        %Set8bit(!M)                             ;84B2EE;      ;
        LDA.B #$20                           ;84B2F0;      ;
        %Set8bit(!M)                             ;84B2F2;      ;
        %Set16bit(!X)                             ;84B2F4;      ;
        LDY.W #$0008                         ;84B2F6;      ;
        STA.B [$CC],Y                        ;84B2F9;0000CC;
        %Set16bit(!M)                             ;84B2FB;      ;
        LDA.B $80                            ;84B2FD;000080;
        CMP.B $7E                            ;84B2FF;00007E;
        BCS .EventScriptBank84_Branch_84B30B                      ;84B301;84B30B;
        %Set16bit(!M)                             ;84B303;      ;
        LDA.B $82                            ;84B305;000082;
        BEQ .EventScriptBank84_Branch_84B33D                      ;84B307;84B33D;
        BRA .EventScriptBank84_Branch_84B32F                      ;84B309;84B32F;

    .EventScriptBank84_Branch_84B30B:
        %Set16bit(!M)                             ;84B30B;      ;
        LDA.B $84                            ;84B30D;000084;
        BEQ .EventScriptBank84_Branch_84B321                      ;84B30F;84B321;
        BRA .EventScriptBank84_Branch_84B313                      ;84B311;84B313;

    .EventScriptBank84_Branch_84B313:
        %Set8bit(!M)                             ;84B313;      ;
        %Set16bit(!X)                             ;84B315;      ;
        LDY.W #$000F                         ;84B317;      ;
        LDA.B #$01                           ;84B31A;      ;
        STA.B [$CC],Y                        ;84B31C;0000CC;
        JMP.W .EventScriptBank84_Branch_84B26A                    ;84B31E;84B26A;

    .EventScriptBank84_Branch_84B321:
        %Set8bit(!M)                             ;84B321;      ;
        %Set16bit(!X)                             ;84B323;      ;
        LDY.W #$000F                         ;84B325;      ;
        LDA.B #$02                           ;84B328;      ;
        STA.B [$CC],Y                        ;84B32A;0000CC;
        JMP.W .EventScriptBank84_Branch_84B26A                    ;84B32C;84B26A;

    .EventScriptBank84_Branch_84B32F:
        %Set8bit(!M)                             ;84B32F;      ;
        %Set16bit(!X)                             ;84B331;      ;
        LDY.W #$000F                         ;84B333;      ;
        LDA.B #$04                           ;84B336;      ;
        STA.B [$CC],Y                        ;84B338;0000CC;
        JMP.W .EventScriptBank84_Branch_84B26A                    ;84B33A;84B26A;

    .EventScriptBank84_Branch_84B33D:
        %Set8bit(!M)                             ;84B33D;      ;
        %Set16bit(!X)                             ;84B33F;      ;
        LDY.W #$000F                         ;84B341;      ;
        LDA.B #$08                           ;84B344;      ;
        STA.B [$CC],Y                        ;84B346;0000CC;
        JMP.W .EventScriptBank84_Branch_84B26A                    ;84B348;84B26A;

;;;;;;;;
EventCmd_37_ClearAttachedObjectSlot: ;84B34B
        ; Pass 48: advances the event stream, reads attached GameOBJ slot offset at +$12,
        ; and clears/releases that object via GameOBJ_ClearSlotAndReleaseComponents.
        %Set16bit(!MX)                             ;      ;
        %Set16bit(!MX)                             ;84B34D;      ;
        LDA.B $C9                            ;84B34F;0000C9;
        CLC                                  ;84B351;      ;
        ADC.W #$0001                         ;84B352;      ;
        STA.B $C9                            ;84B355;0000C9;
        %Set16bit(!MX)                             ;84B357;      ;
        LDY.W #$0012                         ;84B359;      ;
        LDA.B [$CC],Y                        ;84B35C;0000CC;
        STA.B $A5                            ;84B35E;0000A5;
        JSL.L GameOBJ_ClearSlotAndReleaseComponents                    ;84B360;8581A2;

        RTS                                  ;84B364;      ;

;;;;;;;;
EventCmd_38_WaitForFieldMenuGateFlag: ;84B365
        ; Pass 48: waits until $7F1F5A bit $8000 is set. If set, script advances;
        ; otherwise the slot-local wait/progress counter at +$10 is incremented.
        %Set16bit(!MX)                             ;      ;
        LDA.L $7F1F5A                        ;84B367;7F1F5A;
        AND.W #$8000                         ;84B36B;      ;
        BEQ .EventScriptBank84_Branch_84B37B                      ;84B36E;84B37B;
        %Set16bit(!MX)                             ;84B370;      ;
        LDA.B $C9                            ;84B372;0000C9;
        CLC                                  ;84B374;      ;
        ADC.W #$0001                         ;84B375;      ;
        STA.B $C9                            ;84B378;0000C9;

        RTS                                  ;84B37A;      ;

    .EventScriptBank84_Branch_84B37B:
        %Set16bit(!MX)                             ;84B37B;      ;
        LDY.W #$0010                         ;84B37D;      ;
        LDA.B [$CC],Y                        ;84B380;0000CC;
        CLC                                  ;84B382;      ;
        ADC.W #$0001                         ;84B383;      ;
        STA.B [$CC],Y                        ;84B386;0000CC;

        RTS                                  ;84B388;      ;

;;;;;;;;
EventCmd_39_SetSlotState12: ;84B389
        %Set16bit(!MX)                             ;      ;
        %Set16bit(!MX)                             ;84B38B;      ;
        LDA.B !game_state                            ;84B38D;0000D2;
        AND.W #$1000                         ;84B38F;      ;
        BEQ .EventScriptBank84_Branch_84B397                      ;84B392;84B397;
        JMP.W .EventScriptBank84_Branch_84B3E8                    ;84B394;84B3E8;

    .EventScriptBank84_Branch_84B397:
        %Set16bit(!MX)                             ;84B397;      ;
        LDA.B $C9                            ;84B399;0000C9;
        CLC                                  ;84B39B;      ;
        ADC.W #$0001                         ;84B39C;      ;
        STA.B $C9                            ;84B39F;0000C9;
        %Set8bit(!M)                             ;84B3A1;      ;
        LDA.B #$00                           ;84B3A3;      ;
        XBA                                  ;84B3A5;      ;
        LDA.B [$C9]                          ;84B3A6;0000C9;
        %Set16bit(!M)                             ;84B3A8;      ;
        ASL A                                ;84B3AA;      ;
        TAX                                  ;84B3AB;      ;
        LDA.L EventCmd_PlayerStateBitMaskTable,X                ;84B3AC;84B4D2;
        ORA.W $08FD                          ;84B3B0;0008FD;
        STA.W $08FD                          ;84B3B3;0008FD;
        %Set16bit(!MX)                             ;84B3B6;      ;
        LDA.B $C9                            ;84B3B8;0000C9;
        CLC                                  ;84B3BA;      ;
        ADC.W #$0001                         ;84B3BB;      ;
        STA.B $C9                            ;84B3BE;0000C9;
        %Set16bit(!M)                             ;84B3C0;      ;
        LDA.B [$C9]                          ;84B3C2;0000C9;
        STA.W $08FF                          ;84B3C4;0008FF;
        %Set16bit(!MX)                             ;84B3C7;      ;
        LDA.B $C9                            ;84B3C9;0000C9;
        SEC                                  ;84B3CB;      ;
        SBC.W #$0002                         ;84B3CC;      ;
        STA.B $C9                            ;84B3CF;0000C9;
        %Set16bit(!MX)                             ;84B3D1;      ;
        LDY.W #$0010                         ;84B3D3;      ;
        LDA.B [$CC],Y                        ;84B3D6;0000CC;
        CLC                                  ;84B3D8;      ;
        ADC.W #$0001                         ;84B3D9;      ;
        STA.B [$CC],Y                        ;84B3DC;0000CC;
        %Set16bit(!MX)                             ;84B3DE;      ;
        LDA.B !game_state                            ;84B3E0;0000D2;
        ORA.W #$1000                         ;84B3E2;      ;
        STA.B !game_state                            ;84B3E5;0000D2;

        RTS                                  ;84B3E7;      ;

    .EventScriptBank84_Branch_84B3E8:
        %Set16bit(!M)                             ;84B3E8;      ;
        LDA.W $08FF                          ;84B3EA;0008FF;
        BEQ .EventScriptBank84_Branch_84B401                      ;84B3ED;84B401;
        DEC A                                ;84B3EF;      ;
        STA.W $08FF                          ;84B3F0;0008FF;
        %Set16bit(!MX)                             ;84B3F3;      ;
        LDY.W #$0010                         ;84B3F5;      ;
        LDA.B [$CC],Y                        ;84B3F8;0000CC;
        CLC                                  ;84B3FA;      ;
        ADC.W #$0001                         ;84B3FB;      ;
        STA.B [$CC],Y                        ;84B3FE;0000CC;

        RTS                                  ;84B400;      ;

    .EventScriptBank84_Branch_84B401:
        %Set16bit(!M)                             ;84B401;      ;
        STZ.W $08FD                          ;84B403;0008FD;
        STZ.W $08FF                          ;84B406;0008FF;
        %Set16bit(!MX)                             ;84B409;      ;
        LDA.W #$1000                         ;84B40B;      ;
        EOR.W #$FFFF                         ;84B40E;      ;
        AND.B !game_state                            ;84B411;0000D2;
        STA.B !game_state                            ;84B413;0000D2;
        %Set16bit(!MX)                             ;84B415;      ;
        LDA.W #$0000                         ;84B417;      ;
        STA.B !player_action                            ;84B41A;0000D4;
        %Set16bit(!MX)                             ;84B41C;      ;
        LDA.B $C9                            ;84B41E;0000C9;
        CLC                                  ;84B420;      ;
        ADC.W #$0004                         ;84B421;      ;
        STA.B $C9                            ;84B424;0000C9;

        RTS                                  ;84B426;      ;

;;;;;;;;
EventCmd_3A_SetSlotState13: ;84B427
        %Set16bit(!MX)                             ;      ;
        %Set16bit(!MX)                             ;84B429;      ;
        LDA.B !game_state                            ;84B42B;0000D2;
        AND.W #$1000                         ;84B42D;      ;
        BEQ .EventScriptBank84_Branch_84B435                      ;84B430;84B435;
        JMP.W .EventScriptBank84_Branch_84B493                    ;84B432;84B493;

    .EventScriptBank84_Branch_84B435:
        %Set16bit(!MX)                             ;84B435;      ;
        LDA.B $C9                            ;84B437;0000C9;
        CLC                                  ;84B439;      ;
        ADC.W #$0001                         ;84B43A;      ;
        STA.B $C9                            ;84B43D;0000C9;
        %Set8bit(!M)                             ;84B43F;      ;
        LDA.B #$00                           ;84B441;      ;
        XBA                                  ;84B443;      ;
        LDA.B [$C9]                          ;84B444;0000C9;
        %Set16bit(!M)                             ;84B446;      ;
        ASL A                                ;84B448;      ;
        TAX                                  ;84B449;      ;
        LDA.L EventCmd_PlayerStateBitMaskTable,X                ;84B44A;84B4D2;
        ORA.W $08FD                          ;84B44E;0008FD;
        STA.W $08FD                          ;84B451;0008FD;
        LDX.W #$0008                         ;84B454;      ;
        LDA.L EventCmd_PlayerStateBitMaskTable,X                ;84B457;84B4D2;
        ORA.W $08FD                          ;84B45B;0008FD;
        STA.W $08FD                          ;84B45E;0008FD;
        %Set16bit(!MX)                             ;84B461;      ;
        LDA.B $C9                            ;84B463;0000C9;
        CLC                                  ;84B465;      ;
        ADC.W #$0001                         ;84B466;      ;
        STA.B $C9                            ;84B469;0000C9;
        %Set16bit(!M)                             ;84B46B;      ;
        LDA.B [$C9]                          ;84B46D;0000C9;
        STA.W $08FF                          ;84B46F;0008FF;
        %Set16bit(!MX)                             ;84B472;      ;
        LDA.B $C9                            ;84B474;0000C9;
        SEC                                  ;84B476;      ;
        SBC.W #$0002                         ;84B477;      ;
        STA.B $C9                            ;84B47A;0000C9;
        %Set16bit(!MX)                             ;84B47C;      ;
        LDY.W #$0010                         ;84B47E;      ;
        LDA.B [$CC],Y                        ;84B481;0000CC;
        CLC                                  ;84B483;      ;
        ADC.W #$0001                         ;84B484;      ;
        STA.B [$CC],Y                        ;84B487;0000CC;
        %Set16bit(!MX)                             ;84B489;      ;
        LDA.B !game_state                            ;84B48B;0000D2;
        ORA.W #$1000                         ;84B48D;      ;
        STA.B !game_state                            ;84B490;0000D2;

        RTS                                  ;84B492;      ;

    .EventScriptBank84_Branch_84B493:
        %Set16bit(!M)                             ;84B493;      ;
        LDA.W $08FF                          ;84B495;0008FF;
        BEQ .EventScriptBank84_Branch_84B4AC                      ;84B498;84B4AC;
        DEC A                                ;84B49A;      ;
        STA.W $08FF                          ;84B49B;0008FF;
        %Set16bit(!MX)                             ;84B49E;      ;
        LDY.W #$0010                         ;84B4A0;      ;
        LDA.B [$CC],Y                        ;84B4A3;0000CC;
        CLC                                  ;84B4A5;      ;
        ADC.W #$0001                         ;84B4A6;      ;
        STA.B [$CC],Y                        ;84B4A9;0000CC;

        RTS                                  ;84B4AB;      ;

    .EventScriptBank84_Branch_84B4AC:
        %Set16bit(!M)                             ;84B4AC;      ;
        STZ.W $08FD                          ;84B4AE;0008FD;
        STZ.W $08FF                          ;84B4B1;0008FF;
        %Set16bit(!MX)                             ;84B4B4;      ;
        LDA.W #$1000                         ;84B4B6;      ;
        EOR.W #$FFFF                         ;84B4B9;      ;
        AND.B !game_state                            ;84B4BC;0000D2;
        STA.B !game_state                            ;84B4BE;0000D2;
        %Set16bit(!MX)                             ;84B4C0;      ;
        LDA.W #$0000                         ;84B4C2;      ;
        STA.B !player_action                            ;84B4C5;0000D4;
        %Set16bit(!MX)                             ;84B4C7;      ;
        LDA.B $C9                            ;84B4C9;0000C9;
        CLC                                  ;84B4CB;      ;
        ADC.W #$0004                         ;84B4CC;      ;
        STA.B $C9                            ;84B4CF;0000C9;

        RTS                                  ;84B4D1;      ;

EventCmd_PlayerStateBitMaskTable: ;84B4D2
        dw $0400,$0800,$0100,$0200,$8000,$30C2

;;;;;;;;
EventCmd_3B_ChangeItemOnHand: ;84B4DE
        %Set16bit(!MX)                             ;      ;
        LDA.B $C9                            ;84B4E0;0000C9;
        CLC                                  ;84B4E2;      ;
        ADC.W #$0001                         ;84B4E3;      ;
        STA.B $C9                            ;84B4E6;0000C9;
        %Set8bit(!M)                             ;84B4E8;      ;
        LDA.B [$C9]                          ;84B4EA;0000C9;
        STA.W !item_on_hand                          ;84B4EC;00091D;
        %Set16bit(!MX)                             ;84B4EF;      ;
        LDA.B $C9                            ;84B4F1;0000C9;
        CLC                                  ;84B4F3;      ;
        ADC.W #$0001                         ;84B4F4;      ;
        STA.B $C9                            ;84B4F7;0000C9;
        %Set16bit(!MX)                             ;84B4F9;      ;
        LDA.B !game_state                            ;84B4FB;0000D2;
        ORA.W #$0002                         ;84B4FD;      ;
        STA.B !game_state                            ;84B500;0000D2;

        RTS                                  ;84B502;      ;

;;;;;;;;
EventCmd_3C_TransitionToHouse: ;84B503
        %Set16bit(!MX)                             ;      ;
        %Set16bit(!MX)                             ;84B505;      ;
        LDA.B $C9                            ;84B507;0000C9;
        CLC                                  ;84B509;      ;
        ADC.W #$0001                         ;84B50A;      ;
        STA.B $C9                            ;84B50D;0000C9;
        %Set8bit(!M)                             ;84B50F;      ;
        LDA.B #$15                           ;84B511;      ;
        STA.W !transition_dest                          ;84B513;00098B;
        %Set16bit(!MX)                             ;84B516;      ;
        LDA.W $0196                          ;84B518;000196;
        ORA.W #$4000                         ;84B51B;      ;
        STA.W $0196                          ;84B51E;000196;
        LDA.L $7F1F60                        ;84B521;7F1F60;
        ORA.W #$0020                         ;84B525;      ;
        STA.L $7F1F60                        ;84B528;7F1F60;

        RTS                                  ;84B52C;      ;

;;;;;;;;
EventCmd_3D_TransitionToArea: ;84B52D
        %Set16bit(!MX)                             ;      ;
        %Set16bit(!MX)                             ;84B52F;      ;
        LDA.B $C9                            ;84B531;0000C9;
        CLC                                  ;84B533;      ;
        ADC.W #$0001                         ;84B534;      ;
        STA.B $C9                            ;84B537;0000C9;
        %Set8bit(!M)                             ;84B539;      ;
        LDA.B [$C9]                          ;84B53B;0000C9;
        STA.W !transition_dest                          ;84B53D;00098B;
        %Set16bit(!MX)                             ;84B540;      ;
        LDA.B $C9                            ;84B542;0000C9;
        CLC                                  ;84B544;      ;
        ADC.W #$0001                         ;84B545;      ;
        STA.B $C9                            ;84B548;0000C9;
        %Set16bit(!MX)                             ;84B54A;      ;
        LDA.W $0196                          ;84B54C;000196;
        ORA.W #$4000                         ;84B54F;      ;
        STA.W $0196                          ;84B552;000196;

        RTS                                  ;84B555;      ;

;;;;;;;;
EventCmd_3E_SetItemOnHand: ;84B556
        %Set16bit(!MX)                             ;      ;
        %Set16bit(!MX)                             ;84B558;      ;
        LDA.B $C9                            ;84B55A;0000C9;
        CLC                                  ;84B55C;      ;
        ADC.W #$0001                         ;84B55D;      ;
        STA.B $C9                            ;84B560;0000C9;
        %Set8bit(!M)                             ;84B562;      ;
        LDA.B [$C9]                          ;84B564;0000C9;
        STA.W !item_on_hand                          ;84B566;00091D;
        %Set16bit(!MX)                             ;84B569;      ;
        LDA.B $C9                            ;84B56B;0000C9;
        CLC                                  ;84B56D;      ;
        ADC.W #$0001                         ;84B56E;      ;
        STA.B $C9                            ;84B571;0000C9;
        %Set16bit(!MX)                             ;84B573;      ;
        LDA.W #$0004                         ;84B575;      ;
        STA.B !player_action                            ;84B578;0000D4;

        RTS                                  ;84B57A;      ;

;;;;;;;;
EventCmd_3F_DropItemAnimation: ;84B57B
        %Set16bit(!MX)                             ;      ;
        %Set16bit(!MX)                             ;84B57D;      ;
        LDA.B $C9                            ;84B57F;0000C9;
        CLC                                  ;84B581;      ;
        ADC.W #$0001                         ;84B582;      ;
        STA.B $C9                            ;84B585;0000C9;
        %Set16bit(!MX)                             ;84B587;      ;
        LDA.W #$0005                         ;84B589;      ;
        STA.B !player_action                            ;84B58C;0000D4;

        RTS                                  ;84B58E;      ;

;;;;;;;;
EventCmd_40_SetFlag5CState: ;84B58F
        %Set16bit(!MX)                             ;      ;
        %Set16bit(!MX)                             ;84B591;      ;
        LDA.B $C9                            ;84B593;0000C9;
        CLC                                  ;84B595;      ;
        ADC.W #$0001                         ;84B596;      ;
        STA.B $C9                            ;84B599;0000C9;
        %Set16bit(!M)                             ;84B59B;      ;
        LDA.L $7F1F5C                        ;84B59D;7F1F5C;
        ORA.W #$0008                         ;84B5A1;      ;
        STA.L $7F1F5C                        ;84B5A4;7F1F5C;

        RTS                                  ;84B5A8;      ;

;;;;;;;;
EventCmd_41_SetSlotState14: ;84B5A9
        %Set16bit(!MX)                             ;84B5A9;      ;
        %Set16bit(!MX)                             ;84B5AB;      ;
        LDA.B $C9                            ;84B5AD;0000C9;
        CLC                                  ;84B5AF;      ;
        ADC.W #$0001                         ;84B5B0;      ;
        STA.B $C9                            ;84B5B3;0000C9;
        %Set16bit(!M)                             ;84B5B5;      ;
        LDA.B [$C9]                          ;84B5B7;0000C9;
        STA.B $72                            ;84B5B9;000072;
        %Set16bit(!MX)                             ;84B5BB;      ;
        LDA.B $C9                            ;84B5BD;0000C9;
        CLC                                  ;84B5BF;      ;
        ADC.W #$0002                         ;84B5C0;      ;
        STA.B $C9                            ;84B5C3;0000C9;
        %Set8bit(!M)                             ;84B5C5;      ;
        LDA.B [$C9]                          ;84B5C7;0000C9;
        STA.B $74                            ;84B5C9;000074;
        %Set16bit(!MX)                             ;84B5CB;      ;
        LDA.B $C9                            ;84B5CD;0000C9;
        CLC                                  ;84B5CF;      ;
        ADC.W #$0001                         ;84B5D0;      ;
        STA.B $C9                            ;84B5D3;0000C9;
        %Set16bit(!M)                             ;84B5D5;      ;
        LDA.B [$C9]                          ;84B5D7;0000C9;
        STA.B $7E                            ;84B5D9;00007E;
        %Set16bit(!MX)                             ;84B5DB;      ;
        LDA.B $C9                            ;84B5DD;0000C9;
        CLC                                  ;84B5DF;      ;
        ADC.W #$0002                         ;84B5E0;      ;
        STA.B $C9                            ;84B5E3;0000C9;
        LDA.B [$72]                          ;84B5E5;000072;
        CLC                                  ;84B5E7;      ;
        ADC.B $7E                            ;84B5E8;00007E;
        STA.B [$72]                          ;84B5EA;000072;
        BMI .EventScriptBank84_Branch_84B5FA                      ;84B5EC;84B5FA;
        CMP.W #$03E7                         ;84B5EE;      ;
        BCC .EventScriptBank84_Branch_84B601                      ;84B5F1;84B601;
        LDA.W #$03E7                         ;84B5F3;      ;
        STA.B [$72]                          ;84B5F6;000072;
        BRA .EventScriptBank84_Branch_84B601                      ;84B5F8;84B601;

    .EventScriptBank84_Branch_84B5FA:
        %Set16bit(!MX)                             ;84B5FA;      ;
        LDA.W #$0000                         ;84B5FC;      ;
        STA.B [$72]                          ;84B5FF;000072;

    .EventScriptBank84_Branch_84B601: RTS                                  ;84B601;      ;

;;;;;;;;
EventCmd_42_ChangeMoney: ;84B602
        %Set16bit(!MX)                             ;      ;
        %Set16bit(!MX)                             ;84B604;      ;
        LDA.B $C9                            ;84B606;0000C9;
        CLC                                  ;84B608;      ;
        ADC.W #$0001                         ;84B609;      ;
        STA.B $C9                            ;84B60C;0000C9;
        %Set16bit(!M)                             ;84B60E;      ;
        LDA.B [$C9]                          ;84B610;0000C9;
        STA.B $72                            ;84B612;000072;
        %Set16bit(!MX)                             ;84B614;      ;
        LDA.B $C9                            ;84B616;0000C9;
        CLC                                  ;84B618;      ;
        ADC.W #$0002                         ;84B619;      ;
        STA.B $C9                            ;84B61C;0000C9;
        %Set8bit(!M)                             ;84B61E;      ;
        LDA.B [$C9]                          ;84B620;0000C9;
        STA.B $74                            ;84B622;000074;
        %Set16bit(!MX)                             ;84B624;      ;
        LDA.B $C9                            ;84B626;0000C9;
        CLC                                  ;84B628;      ;
        ADC.W #$0001                         ;84B629;      ;
        STA.B $C9                            ;84B62C;0000C9;
        %Set16bit(!M)                             ;84B62E;      ;
        LDA.B [$C9]                          ;84B630;0000C9;
        STA.B $72                            ;84B632;000072;
        %Set16bit(!MX)                             ;84B634;      ;
        LDA.B $C9                            ;84B636;0000C9;
        CLC                                  ;84B638;      ;
        ADC.W #$0002                         ;84B639;      ;
        STA.B $C9                            ;84B63C;0000C9;
        %Set8bit(!M)                             ;84B63E;      ;
        LDA.B [$C9]                          ;84B640;0000C9;
        STA.B $74                            ;84B642;000074;
        %Set16bit(!MX)                             ;84B644;      ;
        LDA.B $C9                            ;84B646;0000C9;
        CLC                                  ;84B648;      ;
        ADC.W #$0001                         ;84B649;      ;
        STA.B $C9                            ;84B64C;0000C9;
        JSL.L AddMoney                       ;84B64E;83B1C9;
        %Set16bit(!M)                             ;84B652;      ;
        BEQ .EventScriptBank84_Branch_84B665                      ;84B654;84B665;
        LDA.W #$0000                         ;84B656;      ;
        STA.L !moneyL                        ;84B659;7F1F04;
        %Set8bit(!M)                             ;84B65D;      ;
        LDA.B #$00                           ;84B65F;      ;
        STA.L !moneyH                        ;84B661;7F1F06;

    .EventScriptBank84_Branch_84B665: RTS                                  ;84B665;      ;

;;;;;;;;
EventCmd_43_JumpIfWordValueEquals: ;84B666
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $72
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.B $74
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $7E
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$72]
        CMP.B $7E
        BNE .EventScriptBank84_Branch_84B6B1
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $C9

        RTS

    .EventScriptBank84_Branch_84B6B1:
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_44_JumpIfLongValueEquals: ;84B6BC
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $72
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.B $74
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $7E
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.B $80
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$72]
        CMP.B $7E
        BNE .EventScriptBank84_Branch_84B722
        %Set8bit(!M)
        LDY.W #$0002
        LDA.B [$72],Y
        CMP.B $80
        BNE .EventScriptBank84_Branch_84B722
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $C9

        RTS

    .EventScriptBank84_Branch_84B722:
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_45_JumpIfWordValueBetween: ;84B72D
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $72
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.B $74
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $7E
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        INC A
        STA.B $80
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$72]
        CMP.B $7E
        BCC .EventScriptBank84_Branch_84B78F
        LDA.B [$72]
        CMP.B $80
        BCS .EventScriptBank84_Branch_84B78F
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $C9

        RTS

    .EventScriptBank84_Branch_84B78F:
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_46_JumpIfLongValueBetween: ;84B79A
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9

        %Set16bit(!M)                        ;load pointer
        LDA.B [$C9]
        STA.B $72
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.B $74
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9

        %Set16bit(!M)                        ;load long value 1
        LDA.B [$C9]
        STA.B $7E
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.B $80
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9

        %Set16bit(!M)                        ;load long value 2
        LDA.B [$C9]
        STA.B $82
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.B $84
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9

        %Set16bit(!M)                        ;increase value 2 by 1
        LDA.B $82
        CLC
        ADC.W #$0001
        STA.B $82
        %Set8bit(!M)
        LDA.B $84
        ADC.B #$00
        STA.B $84

        %Set16bit(!M)
        LDA.B [$72]
        CMP.B $7E
        %Set8bit(!M)
        LDY.W #$0002
        LDA.B [$72],Y
        SBC.B $80
        BCC .EventScriptBank84_Branch_84B841
        %Set16bit(!M)
        LDA.B [$72]
        CMP.B $82
        %Set8bit(!M)
        LDY.W #$0002
        LDA.B [$72],Y
        SBC.B $84
        BCS .EventScriptBank84_Branch_84B841
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $C9

        RTS

    .EventScriptBank84_Branch_84B841:
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9

        RTS


;;;;;;;;
EventCmd_47_SetByteValue: ;84B84C
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $72
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.B $74
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.B [$72]
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_48_SetLongValue: ;84B889
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $72
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        STA.B $74
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B [$72]
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        LDY.W #$0002
        STA.B [$72],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_49_SetSlotState15: ;84B8D9
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        LDA.B [$C9]
        %Set16bit(!MX)
        LDY.W #$0033
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        %Set16bit(!M)
        LDA.B !player_direction
        %Set8bit(!M)
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0002
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        ORA.B #$03
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$0033
        LDA.B [$CC],Y
        STA.B $72
        %Set8bit(!M)
        LDA.B #$B3
        STA.B $74
        JSL.L EventScript_LoadAttachedObjectVisualState
        %Set16bit(!MX)
        LDY.W #$0010
        LDA.B [$CC],Y
        CLC
        ADC.W #$0001
        STA.B [$CC],Y

        RTS

;;;;;;;;
EventCmd_4A_GiveHeldItem08OnAButton: ;84B93C
        ; Pass 48: guarded A-button pickup/give-item command. When player is allowed
        ; to interact and hands are empty, sets !item_on_hand=$08 and player_action=$0004.
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000C
        LDA.B [$CC],Y
        CMP.B #$00
        BNE .EventScriptBank84_Branch_84B958
        JMP.W .EventScriptBank84_Branch_84BA02

    .EventScriptBank84_Branch_84B958:
        %Set16bit(!MX)
        LDA.B !player_action
        CMP.W #$000A
        BNE .EventScriptBank84_Branch_84B964
        JMP.W .EventScriptBank84_Branch_84BA02

    .EventScriptBank84_Branch_84B964:
        %Set16bit(!MX)
        LDA.B !player_action
        CMP.W #$000C
        BNE .EventScriptBank84_Branch_84B970
        JMP.W .EventScriptBank84_Branch_84BA02

    .EventScriptBank84_Branch_84B970:
        %Set16bit(!MX)
        LDA.B !player_action
        CMP.W #$000D
        BNE .EventScriptBank84_Branch_84B97C
        JMP.W .EventScriptBank84_Branch_84BA02

    .EventScriptBank84_Branch_84B97C:
        %Set16bit(!MX)
        LDA.B !player_action
        CMP.W #$001B
        BNE .EventScriptBank84_Branch_84B988
        JMP.W .EventScriptBank84_Branch_84BA02

    .EventScriptBank84_Branch_84B988:
        %Set16bit(!M)
        LDA.B !game_state
        AND.W #$0004
        BNE .EventScriptBank84_Branch_84BA02
        LDA.L $7F1F60
        AND.W #$0006
        BNE .EventScriptBank84_Branch_84BA02
        %Set16bit(!M)
        LDA.W !Joy1_New_Input
        BIT.W #$0080
        BNE .EventScriptBank84_Branch_84B9A7
        JMP.W .EventScriptBank84_Branch_84BA02

    .EventScriptBank84_Branch_84B9A7:
        %Set16bit(!MX)
        LDA.B !game_state
        AND.W #$0800
        BEQ .EventScriptBank84_Branch_84B9B3
        JMP.W .EventScriptBank84_Branch_84BA02

    .EventScriptBank84_Branch_84B9B3:
        LDA.B !player_action
        CMP.W #$0017
        BNE .EventScriptBank84_Branch_84B9BD
        JMP.W .EventScriptBank84_Branch_84BA02

    .EventScriptBank84_Branch_84B9BD:
        %Set8bit(!M)
        LDA.W !item_on_hand
        BEQ .EventScriptBank84_Branch_84B9C7
        JMP.W .EventScriptBank84_Branch_84BA02

    .EventScriptBank84_Branch_84B9C7:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0000
        LDA.B #$00
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        ORA.B #$40
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$0010
        LDA.B [$CC],Y
        CLC
        ADC.W #$0001
        STA.B [$CC],Y
        %Set8bit(!M)
        LDA.B #$08
        STA.W !item_on_hand
        %Set16bit(!MX)
        LDA.W #$0004
        STA.B !player_action

        RTS

    .EventScriptBank84_Branch_84BA02:
        %Set16bit(!MX)
        LDY.W #$0010
        LDA.B [$CC],Y
        CLC
        ADC.W #$0001
        STA.B [$CC],Y

        RTS

;;;;;;;;
EventCmd_4B_EditTileOnMap: ;
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.B [$C9]
        PHA
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.B [$C9]
        PHA
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        LDA.B [$C9]
        PHA
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9
        PLY
        PLX
        %Set8bit(!M)
        PLA
        JSL.L EditTileonMap

        RTS

;;;;;;;;
EventCmd_4C_SetSlotState16: ;
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0000
        LDA.B [$CC],Y
        ORA.B #$02
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0000
        STA.B [$CC],Y

        RTS

;;;;;;;;
EventCmd_4D_SetSlotState17: ;84BA72
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000C
        LDA.B [$CC],Y
        CMP.B #$00
        BNE .EventScriptBank84_Branch_84BA8E
        JMP.W .EventScriptBank84_Branch_84BB26

    .EventScriptBank84_Branch_84BA8E:
        %Set16bit(!MX)
        LDA.B !player_action
        CMP.W #$000A
        BNE .EventScriptBank84_Branch_84BA9A
        JMP.W .EventScriptBank84_Branch_84BB26

    .EventScriptBank84_Branch_84BA9A:
        %Set16bit(!M)
        LDA.L $7F1F5E
        AND.W #$0040
        BNE .EventScriptBank84_Branch_84BAA8
        JMP.W .EventScriptBank84_Branch_84BB26

    .EventScriptBank84_Branch_84BAA8:
        %Set16bit(!M)
        LDA.B [$C9]
        STA.B $C9
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0007
        LDA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0008
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0003
        LDA.B #$00
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0004
        LDA.B #$00
        STA.B [$CC],Y
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$000C
        LDA.B #$00
        STA.B [$CC],Y
        %Set16bit(!M)
        LDA.B !player_direction
        EOR.W #$0001
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0002
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$0033
        LDA.B [$CC],Y
        STA.B $72
        %Set8bit(!M)
        LDA.B #$B3
        STA.B $74
        JSL.L EventScript_LoadAttachedObjectVisualState
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$CC],Y
        ORA.B #$14
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        STA.B [$CC],Y
        %Set16bit(!MX)
        LDY.W #$0010
        LDA.B [$CC],Y
        CLC
        ADC.W #$0001
        STA.B [$CC],Y

        RTS

    .EventScriptBank84_Branch_84BB26:
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0002
        STA.B $C9

        RTS

;;;;;;;;
EventCmd_4E_ResetFlag5CState: ;
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.L $7F1F5C
        AND.W #$FFF7
        STA.L $7F1F5C

        RTS

;;;;;;;;
EventCmd_4F_SetFlag60State: ;84BB4B
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set16bit(!M)
        LDA.L $7F1F60
        ORA.W #$8000
        STA.L $7F1F60

        RTS

;;;;;;;;
;;;;;;;; PASS24_INVENTORY_MENU_CORE: returns selected/backup tools into persistent shed bitfields.
; This clears !tool_selected and !tool_backpack after OR-ing the corresponding
; ownership mask back into !shed_items_row_N. It is used by event/menu flows
; that need to put active tools back into the stored inventory representation.
InventoryTool_ReturnHeldToolsToShedBitfields: ;84BB65
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.W !tool_selected
        BEQ .EventScriptBank84_Branch_84BB9E
        %Set16bit(!M)
        ASL A
        ASL A
        ASL A
        CLC
        ADC.W #$0006
        TAX
        %Set8bit(!M)
        LDA.L InventoryTool_BitfieldSlotAndPickupTileTable,X
        PHA
        INX
        LDA.L InventoryTool_BitfieldSlotAndPickupTileTable,X
        STA.B $92
        PLA
        XBA
        LDA.B #$00
        XBA
        %Set16bit(!M)
        TAX
        %Set8bit(!M)
        LDA.L !shed_items_row_1,X
        ORA.B $92
        STA.L !shed_items_row_1,X
        STZ.W !tool_selected

    .EventScriptBank84_Branch_84BB9E:
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$00
        XBA
        LDA.W !tool_backpack
        BEQ .EventScriptBank84_Branch_84BBD9
        %Set16bit(!M)
        ASL A
        ASL A
        ASL A
        CLC
        ADC.W #$0006
        TAX
        %Set8bit(!M)
        LDA.L InventoryTool_BitfieldSlotAndPickupTileTable,X
        PHA
        INX
        LDA.L InventoryTool_BitfieldSlotAndPickupTileTable,X
        STA.B $92
        PLA
        XBA
        LDA.B #$00
        XBA
        %Set16bit(!M)
        TAX
        %Set8bit(!M)
        LDA.L !shed_items_row_1,X
        ORA.B $92
        STA.L !shed_items_row_1,X
        STZ.W !tool_backpack

    .EventScriptBank84_Branch_84BBD9: RTS

;;;;;;;;
EventCmd_50_ChickenRelated2: ;84BBDA
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDA.B $C9
        CLC
        ADC.W #$0001
        STA.B $C9
        %Set8bit(!M)
        LDA.W !item_on_hand
        BEQ .EventScriptBank84_Branch_84BC5C
        CMP.B #$25
        BEQ .EventScriptBank84_Branch_84BC06
        CMP.B #$26
        BEQ .EventScriptBank84_Branch_84BC06
        STZ.W !item_on_hand
        %Set16bit(!MX)
        LDA.W #$0000
        CLC
        ADC.B !player_direction
        STA.W $0901
        JMP.W .EventScriptBank84_Branch_84BC9B

    .EventScriptBank84_Branch_84BC06:
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$00
        XBA
        LDA.W $0920
        SEC
        SBC.B #$24
        %Set16bit(!M)
        PHA
        JSL.L GetChickenPointer
        %Set8bit(!M)
        LDY.W #$0001
        LDA.B #$28
        STA.B [$72],Y
        LDY.W #$0000
        LDA.B [$72],Y
        AND.B #$DF
        STA.B [$72],Y
        %Set16bit(!M)
        PLA
        ASL A
        ASL A
        TAX
        LDY.W #$0004
        LDA.L $83CA10,X
        CLC
        ADC.W #$0010
        STA.B [$72],Y
        INX
        INX
        LDY.W #$0006
        LDA.L $83CA10,X
        STA.B [$72],Y
        %Set8bit(!M)
        STZ.W !item_on_hand
        %Set16bit(!MX)
        LDA.W #$0000
        CLC
        ADC.B !player_direction
        STA.W $0901
        BRA .EventScriptBank84_Branch_84BC9B

    .EventScriptBank84_Branch_84BC5C:
        %Set16bit(!MX)
        LDA.B !game_state
        AND.W #$0800
        BNE .EventScriptBank84_Branch_84BC68
        JMP.W .EventScriptBank84_Branch_84BC9B

    .EventScriptBank84_Branch_84BC68:
        %Set16bit(!MX)
        LDA.W #$0800
        EOR.W #$FFFF
        AND.B !game_state
        STA.B !game_state
        %Set8bit(!M)
        LDA.L !season
        STA.L !dog_map
        %Set16bit(!MX)
        LDA.W #$0078
        STA.L !dog_pos_X
        LDA.W #$01A8
        STA.L !dog_pos_Y
        %Set16bit(!MX)
        LDA.W #$0000
        CLC
        ADC.B !player_direction
        STA.W $0901
        BRA .EventScriptBank84_Branch_84BC9B

    .EventScriptBank84_Branch_84BC9B: RTS

;;;;;;;;
EventCmd_51_UseChickenDogOrHeldItemContext: ;84BC9C
                       %Set16bit(!MX)                             ;84BC9C;      ;
                       %Set16bit(!MX)                             ;84BC9E;      ;
                       LDA.B $C9                            ;84BCA0;0000C9;
                       CLC                                  ;84BCA2;      ;
                       ADC.W #$0001                         ;84BCA3;      ;
                       STA.B $C9                            ;84BCA6;0000C9;
                       %Set8bit(!M)                             ;84BCA8;      ;
                       LDA.W !item_on_hand                          ;84BCAA;00091D;
                       BEQ EventScriptBank84_Branch_84BD0F                      ;84BCAD;84BD0F;
                       CMP.B #$25                           ;84BCAF;      ;
                       BEQ EventScriptBank84_Branch_84BCC4                      ;84BCB1;84BCC4;
                       CMP.B #$26                           ;84BCB3;      ;
                       BEQ EventScriptBank84_Branch_84BCC4                      ;84BCB5;84BCC4;
                       CMP.B #$29                           ;84BCB7;      ;
                       BEQ EventScriptBank84_Branch_84BCBE                      ;84BCB9;84BCBE;
                       JMP.W EventScriptBank84_Branch_84BD43                    ;84BCBB;84BD43;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BCBE: STZ.W !item_on_hand                          ;84BCBE;00091D;
                       JMP.W EventScriptBank84_Branch_84BD43                    ;84BCC1;84BD43;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BCC4: %Set8bit(!M)                             ;84BCC4;      ;
                       %Set16bit(!X)                             ;84BCC6;      ;
                       LDA.B #$00                           ;84BCC8;      ;
                       XBA                                  ;84BCCA;      ;
                       LDA.W $0920                          ;84BCCB;000920;
                       SEC                                  ;84BCCE;      ;
                       SBC.B #$24                           ;84BCCF;      ;
                       %Set16bit(!M)                             ;84BCD1;      ;
                       PHA                                  ;84BCD3;      ;
                       JSL.L GetChickenPointer          ;84BCD4;83C995;
                       %Set8bit(!M)                             ;84BCD8;      ;
                       LDY.W #$0001                         ;84BCDA;      ;
                       LDA.B #$28                           ;84BCDD;      ;
                       STA.B [$72],Y                        ;84BCDF;000072;
                       LDY.W #$0000                         ;84BCE1;      ;
                       LDA.B [$72],Y                        ;84BCE4;000072;
                       AND.B #$DF                           ;84BCE6;      ;
                       STA.B [$72],Y                        ;84BCE8;000072;
                       %Set16bit(!M)                             ;84BCEA;      ;
                       PLA                                  ;84BCEC;      ;
                       ASL A                                ;84BCED;      ;
                       ASL A                                ;84BCEE;      ;
                       TAX                                  ;84BCEF;      ;
                       LDY.W #$0004                         ;84BCF0;      ;
                       LDA.L $83CA10,X                      ;84BCF3;83CA10;
                       CLC                                  ;84BCF7;      ;
                       ADC.W #$0010                         ;84BCF8;      ;
                       STA.B [$72],Y                        ;84BCFB;000072;
                       INX                                  ;84BCFD;      ;
                       INX                                  ;84BCFE;      ;
                       LDY.W #$0006                         ;84BCFF;      ;
                       LDA.L $83CA10,X                      ;84BD02;83CA10;
                       STA.B [$72],Y                        ;84BD06;000072;
                       %Set8bit(!M)                             ;84BD08;      ;
                       STZ.W !item_on_hand                          ;84BD0A;00091D;
                       BRA EventScriptBank84_Branch_84BD43                      ;84BD0D;84BD43;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BD0F: %Set16bit(!MX)                             ;84BD0F;      ;
                       LDA.B !game_state                            ;84BD11;0000D2;
                       AND.W #$0800                         ;84BD13;      ;
                       BNE EventScriptBank84_Branch_84BD1B                      ;84BD16;84BD1B;
                       JMP.W EventScriptBank84_Branch_84BD43                    ;84BD18;84BD43;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BD1B: %Set16bit(!MX)                             ;84BD1B;      ;
                       LDA.W #$0800                         ;84BD1D;      ;
                       EOR.W #$FFFF                         ;84BD20;      ;
                       AND.B !game_state                            ;84BD23;0000D2;
                       STA.B !game_state                            ;84BD25;0000D2;
                       %Set8bit(!M)                             ;84BD27;      ;
                       LDA.L !season                        ;84BD29;7F1F19;
                       STA.L !dog_map                        ;84BD2D;7F1F30;
                       %Set16bit(!MX)                             ;84BD31;      ;
                       LDA.W #$0078                         ;84BD33;      ;
                       STA.L !dog_pos_X                        ;84BD36;7F1F2C;
                       LDA.W #$01A8                         ;84BD3A;      ;
                       STA.L !dog_pos_Y                        ;84BD3D;7F1F2E;
                       BRA EventScriptBank84_Branch_84BD43                      ;84BD41;84BD43;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BD43: RTS                                  ;84BD43;      ;
                                                            ;      ;      ;
EventCmd_52_WaitForAButtonSetInteractionFlag02: ;84BD44
                       %Set16bit(!MX)                             ;84BD44;      ;
                       %Set16bit(!MX)                             ;84BD46;      ;
                       LDA.B $C9                            ;84BD48;0000C9;
                       CLC                                  ;84BD4A;      ;
                       ADC.W #$0001                         ;84BD4B;      ;
                       STA.B $C9                            ;84BD4E;0000C9;
                       %Set8bit(!M)                             ;84BD50;      ;
                       %Set16bit(!X)                             ;84BD52;      ;
                       LDY.W #$000C                         ;84BD54;      ;
                       LDA.B [$CC],Y                        ;84BD57;0000CC;
                       CMP.B #$00                           ;84BD59;      ;
                       BNE EventScriptBank84_Branch_84BD60                      ;84BD5B;84BD60;
                       JMP.W EventScriptBank84_Branch_84BDFF                    ;84BD5D;84BDFF;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BD60: %Set16bit(!MX)                             ;84BD60;      ;
                       LDA.B !player_action                            ;84BD62;0000D4;
                       CMP.W #$000A                         ;84BD64;      ;
                       BNE EventScriptBank84_Branch_84BD6C                      ;84BD67;84BD6C;
                       JMP.W EventScriptBank84_Branch_84BDFF                    ;84BD69;84BDFF;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BD6C: %Set16bit(!MX)                             ;84BD6C;      ;
                       LDA.B !player_action                            ;84BD6E;0000D4;
                       CMP.W #$000C                         ;84BD70;      ;
                       BNE EventScriptBank84_Branch_84BD78                      ;84BD73;84BD78;
                       JMP.W EventScriptBank84_Branch_84BDFF                    ;84BD75;84BDFF;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BD78: %Set16bit(!MX)                             ;84BD78;      ;
                       LDA.B !player_action                            ;84BD7A;0000D4;
                       CMP.W #$000D                         ;84BD7C;      ;
                       BNE EventScriptBank84_Branch_84BD84                      ;84BD7F;84BD84;
                       JMP.W EventScriptBank84_Branch_84BDFF                    ;84BD81;84BDFF;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BD84: %Set16bit(!MX)                             ;84BD84;      ;
                       LDA.B !player_action                            ;84BD86;0000D4;
                       CMP.W #$001B                         ;84BD88;      ;
                       BNE EventScriptBank84_Branch_84BD90                      ;84BD8B;84BD90;
                       JMP.W EventScriptBank84_Branch_84BDFF                    ;84BD8D;84BDFF;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BD90: %Set16bit(!M)                             ;84BD90;      ;
                       LDA.B !game_state                            ;84BD92;0000D2;
                       AND.W #$0004                         ;84BD94;      ;
                       BNE EventScriptBank84_Branch_84BDFF                      ;84BD97;84BDFF;
                       LDA.L $7F1F60                        ;84BD99;7F1F60;
                       AND.W #$0006                         ;84BD9D;      ;
                       BNE EventScriptBank84_Branch_84BDFF                      ;84BDA0;84BDFF;
                       %Set16bit(!M)                             ;84BDA2;      ;
                       LDA.W !Joy1_New_Input                          ;84BDA4;000128;
                       BIT.W #$0080                         ;84BDA7;      ;
                       BNE EventScriptBank84_Branch_84BDAF                      ;84BDAA;84BDAF;
                       JMP.W EventScriptBank84_Branch_84BDFF                    ;84BDAC;84BDFF;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BDAF: %Set16bit(!MX)                             ;84BDAF;      ;
                       LDA.B !game_state                            ;84BDB1;0000D2;
                       AND.W #$0800                         ;84BDB3;      ;
                       BEQ EventScriptBank84_Branch_84BDBB                      ;84BDB6;84BDBB;
                       JMP.W EventScriptBank84_Branch_84BDFF                    ;84BDB8;84BDFF;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BDBB: %Set8bit(!M)                             ;84BDBB;      ;
                       LDA.W !item_on_hand                          ;84BDBD;00091D;
                       BEQ EventScriptBank84_Branch_84BDC5                      ;84BDC0;84BDC5;
                       JMP.W EventScriptBank84_Branch_84BDFF                    ;84BDC2;84BDFF;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BDC5: %Set8bit(!M)                             ;84BDC5;      ;
                       %Set16bit(!X)                             ;84BDC7;      ;
                       LDY.W #$0000                         ;84BDC9;      ;
                       LDA.B #$00                           ;84BDCC;      ;
                       STA.B [$CC],Y                        ;84BDCE;0000CC;
                       %Set8bit(!M)                             ;84BDD0;      ;
                       %Set16bit(!X)                             ;84BDD2;      ;
                       LDY.W #$0001                         ;84BDD4;      ;
                       LDA.B [$CC],Y                        ;84BDD7;0000CC;
                       ORA.B #$40                           ;84BDD9;      ;
                       %Set8bit(!M)                             ;84BDDB;      ;
                       %Set16bit(!X)                             ;84BDDD;      ;
                       LDY.W #$0001                         ;84BDDF;      ;
                       STA.B [$CC],Y                        ;84BDE2;0000CC;
                       %Set16bit(!MX)                             ;84BDE4;      ;
                       LDY.W #$0010                         ;84BDE6;      ;
                       LDA.B [$CC],Y                        ;84BDE9;0000CC;
                       CLC                                  ;84BDEB;      ;
                       ADC.W #$0001                         ;84BDEC;      ;
                       STA.B [$CC],Y                        ;84BDEF;0000CC;
                       %Set16bit(!MX)                             ;84BDF1;      ;
                       LDA.L $7F1F60                        ;84BDF3;7F1F60;
                       ORA.W #$0002                         ;84BDF7;      ;
                       STA.L $7F1F60                        ;84BDFA;7F1F60;
                       RTS                                  ;84BDFE;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BDFF: %Set16bit(!MX)                             ;84BDFF;      ;
                       LDY.W #$0010                         ;84BE01;      ;
                       LDA.B [$CC],Y                        ;84BE04;0000CC;
                       CLC                                  ;84BE06;      ;
                       ADC.W #$0001                         ;84BE07;      ;
                       STA.B [$CC],Y                        ;84BE0A;0000CC;
                       RTS                                  ;84BE0C;      ;
                                                            ;      ;      ;
EventCmd_53_WaitForAButtonSetInteractionFlag04: ;84BE0D
                       %Set16bit(!MX)                             ;84BE0D;      ;
                       %Set16bit(!MX)                             ;84BE0F;      ;
                       LDA.B $C9                            ;84BE11;0000C9;
                       CLC                                  ;84BE13;      ;
                       ADC.W #$0001                         ;84BE14;      ;
                       STA.B $C9                            ;84BE17;0000C9;
                       %Set8bit(!M)                             ;84BE19;      ;
                       %Set16bit(!X)                             ;84BE1B;      ;
                       LDY.W #$000C                         ;84BE1D;      ;
                       LDA.B [$CC],Y                        ;84BE20;0000CC;
                       CMP.B #$00                           ;84BE22;      ;
                       BNE EventScriptBank84_Branch_84BE29                      ;84BE24;84BE29;
                       JMP.W EventScriptBank84_Branch_84BEC8                    ;84BE26;84BEC8;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BE29: %Set16bit(!MX)                             ;84BE29;      ;
                       LDA.B !player_action                            ;84BE2B;0000D4;
                       CMP.W #$000A                         ;84BE2D;      ;
                       BNE EventScriptBank84_Branch_84BE35                      ;84BE30;84BE35;
                       JMP.W EventScriptBank84_Branch_84BEC8                    ;84BE32;84BEC8;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BE35: %Set16bit(!MX)                             ;84BE35;      ;
                       LDA.B !player_action                            ;84BE37;0000D4;
                       CMP.W #$000C                         ;84BE39;      ;
                       BNE EventScriptBank84_Branch_84BE41                      ;84BE3C;84BE41;
                       JMP.W EventScriptBank84_Branch_84BEC8                    ;84BE3E;84BEC8;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BE41: %Set16bit(!MX)                             ;84BE41;      ;
                       LDA.B !player_action                            ;84BE43;0000D4;
                       CMP.W #$000D                         ;84BE45;      ;
                       BNE EventScriptBank84_Branch_84BE4D                      ;84BE48;84BE4D;
                       JMP.W EventScriptBank84_Branch_84BEC8                    ;84BE4A;84BEC8;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BE4D: %Set16bit(!MX)                             ;84BE4D;      ;
                       LDA.B !player_action                            ;84BE4F;0000D4;
                       CMP.W #$001B                         ;84BE51;      ;
                       BNE EventScriptBank84_Branch_84BE59                      ;84BE54;84BE59;
                       JMP.W EventScriptBank84_Branch_84BEC8                    ;84BE56;84BEC8;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BE59: %Set16bit(!M)                             ;84BE59;      ;
                       LDA.B !game_state                            ;84BE5B;0000D2;
                       AND.W #$0004                         ;84BE5D;      ;
                       BNE EventScriptBank84_Branch_84BEC8                      ;84BE60;84BEC8;
                       LDA.L $7F1F60                        ;84BE62;7F1F60;
                       AND.W #$0006                         ;84BE66;      ;
                       BNE EventScriptBank84_Branch_84BEC8                      ;84BE69;84BEC8;
                       %Set16bit(!M)                             ;84BE6B;      ;
                       LDA.W !Joy1_New_Input                          ;84BE6D;000128;
                       BIT.W #$0080                         ;84BE70;      ;
                       BNE EventScriptBank84_Branch_84BE78                      ;84BE73;84BE78;
                       JMP.W EventScriptBank84_Branch_84BEC8                    ;84BE75;84BEC8;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BE78: %Set16bit(!MX)                             ;84BE78;      ;
                       LDA.B !game_state                            ;84BE7A;0000D2;
                       AND.W #$0800                         ;84BE7C;      ;
                       BEQ EventScriptBank84_Branch_84BE84                      ;84BE7F;84BE84;
                       JMP.W EventScriptBank84_Branch_84BEC8                    ;84BE81;84BEC8;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BE84: %Set8bit(!M)                             ;84BE84;      ;
                       LDA.W !item_on_hand                          ;84BE86;00091D;
                       BEQ EventScriptBank84_Branch_84BE8E                      ;84BE89;84BE8E;
                       JMP.W EventScriptBank84_Branch_84BEC8                    ;84BE8B;84BEC8;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BE8E: %Set8bit(!M)                             ;84BE8E;      ;
                       %Set16bit(!X)                             ;84BE90;      ;
                       LDY.W #$0000                         ;84BE92;      ;
                       LDA.B #$00                           ;84BE95;      ;
                       STA.B [$CC],Y                        ;84BE97;0000CC;
                       %Set8bit(!M)                             ;84BE99;      ;
                       %Set16bit(!X)                             ;84BE9B;      ;
                       LDY.W #$0001                         ;84BE9D;      ;
                       LDA.B [$CC],Y                        ;84BEA0;0000CC;
                       ORA.B #$40                           ;84BEA2;      ;
                       %Set8bit(!M)                             ;84BEA4;      ;
                       %Set16bit(!X)                             ;84BEA6;      ;
                       LDY.W #$0001                         ;84BEA8;      ;
                       STA.B [$CC],Y                        ;84BEAB;0000CC;
                       %Set16bit(!MX)                             ;84BEAD;      ;
                       LDY.W #$0010                         ;84BEAF;      ;
                       LDA.B [$CC],Y                        ;84BEB2;0000CC;
                       CLC                                  ;84BEB4;      ;
                       ADC.W #$0001                         ;84BEB5;      ;
                       STA.B [$CC],Y                        ;84BEB8;0000CC;
                       %Set16bit(!MX)                             ;84BEBA;      ;
                       LDA.L $7F1F60                        ;84BEBC;7F1F60;
                       ORA.W #$0004                         ;84BEC0;      ;
                       STA.L $7F1F60                        ;84BEC3;7F1F60;
                       RTS                                  ;84BEC7;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BEC8: %Set16bit(!MX)                             ;84BEC8;      ;
                       LDY.W #$0010                         ;84BECA;      ;
                       LDA.B [$CC],Y                        ;84BECD;0000CC;
                       CLC                                  ;84BECF;      ;
                       ADC.W #$0001                         ;84BED0;      ;
                       STA.B [$CC],Y                        ;84BED3;0000CC;
                       RTS                                  ;84BED5;      ;
                                                            ;      ;      ;
EventCmd_54_StartTextBoxAndAdvanceSlot: ;84BED6
                       %Set16bit(!MX)                             ;84BED6;      ;
                       %Set16bit(!MX)                             ;84BED8;      ;
                       LDA.B $C9                            ;84BEDA;0000C9;
                       CLC                                  ;84BEDC;      ;
                       ADC.W #$0001                         ;84BEDD;      ;
                       STA.B $C9                            ;84BEE0;0000C9;
                       %Set16bit(!M)                             ;84BEE2;      ;
                       LDA.B [$C9]                          ;84BEE4;0000C9;
                       TAX                                  ;84BEE6;      ;
                       %Set16bit(!MX)                             ;84BEE7;      ;
                       LDA.B $C9                            ;84BEE9;0000C9;
                       CLC                                  ;84BEEB;      ;
                       ADC.W #$0002                         ;84BEEC;      ;
                       STA.B $C9                            ;84BEEF;0000C9;
                       %Set8bit(!M)                             ;84BEF1;      ;
                       LDA.B [$C9]                          ;84BEF3;0000C9;
                       STA.W $0191                          ;84BEF5;000191;
                       %Set16bit(!M)                             ;84BEF8;      ;
                       STZ.W $09B1                          ;84BEFA;0009B1;
                       %Set8bit(!M)                             ;84BEFD;      ;
                       LDA.B #$06                           ;84BEFF;      ;
                       STA.W !inputstate                          ;84BF01;00019A;
                       JSL.L TextBox_StartByTextId                    ;84BF04;83935F;
                       %Set16bit(!MX)                             ;84BF08;      ;
                       LDA.B $C9                            ;84BF0A;0000C9;
                       CLC                                  ;84BF0C;      ;
                       ADC.W #$0001                         ;84BF0D;      ;
                       STA.B $C9                            ;84BF10;0000C9;
                       %Set16bit(!MX)                             ;84BF12;      ;
                       LDY.W #$0010                         ;84BF14;      ;
                       LDA.B [$CC],Y                        ;84BF17;0000CC;
                       CLC                                  ;84BF19;      ;
                       ADC.W #$0001                         ;84BF1A;      ;
                       STA.B [$CC],Y                        ;84BF1D;0000CC;
                       RTS                                  ;84BF1F;      ;
                                                            ;      ;      ;
EventCmd_55_JumpIfIndirectBitClear: ;84BF20
                       %Set16bit(!MX)                             ;84BF20;      ;
                       %Set16bit(!MX)                             ;84BF22;      ;
                       LDA.B $C9                            ;84BF24;0000C9;
                       CLC                                  ;84BF26;      ;
                       ADC.W #$0001                         ;84BF27;      ;
                       STA.B $C9                            ;84BF2A;0000C9;
                       %Set16bit(!M)                             ;84BF2C;      ;
                       LDA.B [$C9]                          ;84BF2E;0000C9;
                       STA.B $72                            ;84BF30;000072;
                       %Set16bit(!MX)                             ;84BF32;      ;
                       LDA.B $C9                            ;84BF34;0000C9;
                       CLC                                  ;84BF36;      ;
                       ADC.W #$0002                         ;84BF37;      ;
                       STA.B $C9                            ;84BF3A;0000C9;
                       %Set8bit(!M)                             ;84BF3C;      ;
                       LDA.B [$C9]                          ;84BF3E;0000C9;
                       STA.B $74                            ;84BF40;000074;
                       %Set16bit(!MX)                             ;84BF42;      ;
                       LDA.B $C9                            ;84BF44;0000C9;
                       CLC                                  ;84BF46;      ;
                       ADC.W #$0001                         ;84BF47;      ;
                       STA.B $C9                            ;84BF4A;0000C9;
                       %Set8bit(!M)                             ;84BF4C;      ;
                       LDA.B #$00                           ;84BF4E;      ;
                       XBA                                  ;84BF50;      ;
                       LDA.B [$C9]                          ;84BF51;0000C9;
                       %Set16bit(!M)                             ;84BF53;      ;
                       ASL A                                ;84BF55;      ;
                       TAX                                  ;84BF56;      ;
                       LDA.L EventCmd_GenericBitMaskTable16,X                ;84BF57;84C014;
                       STA.B $7E                            ;84BF5B;00007E;
                       %Set16bit(!MX)                             ;84BF5D;      ;
                       LDA.B $C9                            ;84BF5F;0000C9;
                       CLC                                  ;84BF61;      ;
                       ADC.W #$0001                         ;84BF62;      ;
                       STA.B $C9                            ;84BF65;0000C9;
                       %Set16bit(!M)                             ;84BF67;      ;
                       LDA.B [$72]                          ;84BF69;000072;
                       AND.B $7E                            ;84BF6B;00007E;
                       BNE EventScriptBank84_Branch_84BF76                      ;84BF6D;84BF76;
                       %Set16bit(!M)                             ;84BF6F;      ;
                       LDA.B [$C9]                          ;84BF71;0000C9;
                       STA.B $C9                            ;84BF73;0000C9;
                       RTS                                  ;84BF75;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BF76: %Set16bit(!MX)                             ;84BF76;      ;
                       LDA.B $C9                            ;84BF78;0000C9;
                       CLC                                  ;84BF7A;      ;
                       ADC.W #$0002                         ;84BF7B;      ;
                       STA.B $C9                            ;84BF7E;0000C9;
                       RTS                                  ;84BF80;      ;
                                                            ;      ;      ;
EventCmd_56_StartSelectedToolAction: ;84BF81
                       %Set16bit(!MX)                             ;84BF81;      ;
                       %Set16bit(!MX)                             ;84BF83;      ;
                       LDA.B $C9                            ;84BF85;0000C9;
                       CLC                                  ;84BF87;      ;
                       ADC.W #$0001                         ;84BF88;      ;
                       STA.B $C9                            ;84BF8B;0000C9;
                       %Set8bit(!M)                             ;84BF8D;      ;
                       LDA.W !tool_selected                          ;84BF8F;000921;
                       BEQ EventScriptBank84_Branch_84BF9F                      ;84BF92;84BF9F;
                       %Set16bit(!MX)                             ;84BF94;      ;
                       LDA.W #$000A                         ;84BF96;      ;
                       STA.B !player_action                            ;84BF99;0000D4;
                       JSL.L ToolAction_StartAnimationOrNoStamina                    ;84BF9B;8290A8;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84BF9F: RTS                                  ;84BF9F;      ;
                                                            ;      ;      ;
EventCmd_57_ApplyStaminaDelta: ;84BFA0
                       %Set16bit(!MX)                             ;84BFA0;      ;
                       %Set16bit(!MX)                             ;84BFA2;      ;
                       LDA.B $C9                            ;84BFA4;0000C9;
                       CLC                                  ;84BFA6;      ;
                       ADC.W #$0001                         ;84BFA7;      ;
                       STA.B $C9                            ;84BFAA;0000C9;
                       %Set8bit(!M)                             ;84BFAC;      ;
                       LDA.B [$C9]                          ;84BFAE;0000C9;
                       JSL.L Stamina_ApplyDeltaAndFatigueState                    ;84BFB0;81D061;
                       %Set16bit(!MX)                             ;84BFB4;      ;
                       LDA.B $C9                            ;84BFB6;0000C9;
                       CLC                                  ;84BFB8;      ;
                       ADC.W #$0001                         ;84BFB9;      ;
                       STA.B $C9                            ;84BFBC;0000C9;
                       RTS                                  ;84BFBE;      ;
                                                            ;      ;      ;
EventCmd_58_EditTileAndSetRuntimeFlag: ;84BFBF
                       %Set16bit(!MX)                             ;84BFBF;      ;
                       %Set16bit(!MX)                             ;84BFC1;      ;
                       LDA.B $C9                            ;84BFC3;0000C9;
                       CLC                                  ;84BFC5;      ;
                       ADC.W #$0001                         ;84BFC6;      ;
                       STA.B $C9                            ;84BFC9;0000C9;
                       %Set8bit(!M)                             ;84BFCB;      ;
                       LDA.B [$C9]                          ;84BFCD;0000C9;
                       PHA                                  ;84BFCF;      ;
                       %Set16bit(!MX)                             ;84BFD0;      ;
                       LDA.B $C9                            ;84BFD2;0000C9;
                       CLC                                  ;84BFD4;      ;
                       ADC.W #$0001                         ;84BFD5;      ;
                       STA.B $C9                            ;84BFD8;0000C9;
                       %Set16bit(!M)                             ;84BFDA;      ;
                       LDA.B [$C9]                          ;84BFDC;0000C9;
                       PHA                                  ;84BFDE;      ;
                       %Set16bit(!MX)                             ;84BFDF;      ;
                       LDA.B $C9                            ;84BFE1;0000C9;
                       CLC                                  ;84BFE3;      ;
                       ADC.W #$0002                         ;84BFE4;      ;
                       STA.B $C9                            ;84BFE7;0000C9;
                       LDA.B [$C9]                          ;84BFE9;0000C9;
                       PHA                                  ;84BFEB;      ;
                       %Set16bit(!MX)                             ;84BFEC;      ;
                       LDA.B $C9                            ;84BFEE;0000C9;
                       CLC                                  ;84BFF0;      ;
                       ADC.W #$0002                         ;84BFF1;      ;
                       STA.B $C9                            ;84BFF4;0000C9;
                       PLY                                  ;84BFF6;      ;
                       PLX                                  ;84BFF7;      ;
                       %Set8bit(!M)                             ;84BFF8;      ;
                       PLA                                  ;84BFFA;      ;
                       JSL.L EditTileonMapandsets0181                    ;84BFFB;82B049;
                       RTS                                  ;84BFFF;      ;
                                                            ;      ;      ;
EventCmd_59_SetPlayerAction1C: ;84C000
                       %Set16bit(!MX)                             ;84C000;      ;
                       %Set16bit(!MX)                             ;84C002;      ;
                       LDA.B $C9                            ;84C004;0000C9;
                       CLC                                  ;84C006;      ;
                       ADC.W #$0001                         ;84C007;      ;
                       STA.B $C9                            ;84C00A;0000C9;
                       %Set16bit(!MX)                             ;84C00C;      ;
                       LDA.W #$001C                         ;84C00E;      ;
                       STA.B !player_action                            ;84C011;0000D4;
                       RTS                                  ;84C013;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
        EventCmd_GenericBitMaskTable16: dw $0001,$0002,$0004,$0008,$0010,$0020,$0040,$0080;84C014;      ;
                       dw $0100,$0200,$0400,$0800,$1000,$2000,$4000,$8000;84C024;      ;

;;;;;;
; PASS23_INPUT_MENU_CORE: central controller/input dispatcher.
; !inputstate selects normal movement, immobilized state, menu state, name-entry state,
; prompt cursor state and other modal handlers. This is the root of most player/menu input.
Input_DispatchByState: ;84C034
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.W !inputstate
        CMP.B #$01
        BNE +
        JMP.W PlayerInput_NormalMovementCore

      + CMP.B #$02
        BNE +
        JMP.W PromptCursorInput_DispatchModalAndGridModes                 ;No movement

      + CMP.B #$03
        BNE +
        JMP.W PromptCursorInput_GridCursorMode

      + CMP.B #$04
        BNE +
        JMP.W MenuInput_DispatchByMenuMode                     ;Menus

      + CMP.B #$05
        BNE +
        JMP.W NameEntryInput_Dispatch                 ;NameInput

      + CMP.B #$06
        BNE .return
        JMP.W EventScriptBank84_Branch_84CED2

    .return RTL

;;;;;;; PASS23_INPUT_MENU_CORE: name-entry modal controls.
; Handles D-pad cursor movement plus A/B for append/delete/confirm while naming player, animals, etc.
NameEntryInput_Dispatch: ;84C066
       %Set16bit(!MX)
       LDA.W !Joy1_Autorepeat
       BIT.W !key_Down
       BEQ +
       JMP.W NameEntryInput_MoveDown

     + LDA.W !Joy1_Autorepeat
       BIT.W !key_Up
       BEQ +
       JMP.W NameEntryInput_MoveUp

     + LDA.W !Joy1_Autorepeat
       BIT.W !key_Left
       BEQ +
       JMP.W NameEntryInput_MoveLeft

     + LDA.W !Joy1_Autorepeat
       BIT.W !key_Right
       BEQ +
       JMP.W NameEntryInput_MoveRight

     + LDA.W !Joy1_New_Input
       BIT.W !key_B
       BEQ +
       JMP.W NameEntryInput_BackspaceOrCancel

     + LDA.W !Joy1_New_Input
       BIT.W !key_A
       BEQ +
       JMP.W NameEntryInput_AcceptOrAppendChar

     + RTL

;;;;;;;;
; PASS47_NAME_ENTRY_CORE: B deletes the previous glyph; if empty, only plays error/cancel SFX.
NameEntryInput_BackspaceOrCancel: ;84C0AB
        %Set8bit(!M)
        LDA.W !name_entry_index
        BEQ .playsound                       ;If there is no character
        CMP.B #$04
        BEQ .removeChar                      ;if theres letter to be deleted?
        %Set16bit(!M)
        LDA.W #$00A8
        JSL.L NameEntryUI_DrawGlyphIntoCurrentSlot

    .removeChar:
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.W !name_entry_index
        DEC A
        %Set16bit(!M)
        TAX
        %Set8bit(!M)
        LDA.B !CHAR_EMPTY
        STA.W !temp_name_1,X
        %Set8bit(!M)
        LDA.W !name_entry_index
        DEC A
        STA.W !name_entry_index

    .playsound:
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$02
        STA.W $0114
        LDA.B #$06
        STA.W $0115
        JSL.L AudioSFX_PlayQueuedEffectDefaultVolume
        RTL

;;;;;;;; Param in A, probably what character was pushed
; PASS47_NAME_ENTRY_CORE: A reads the current grid action.
; Action 1/2/3 switches page, action 4 confirms name, otherwise glyph is appended.
NameEntryInput_AcceptOrAppendChar: ;84C0EE
        %Set16bit(!M)
        LDA.W #$0005
        JSL.L NameEntryGrid_ReadCurrentEntryField               ;get what was hit.

        %Set16bit(!M)
        CMP.W #$0001
        BEQ NameEntryInput_SelectUppercasePage                      ;a special case
        CMP.W #$0002
        BEQ NameEntryInput_SelectLowercasePage                      ;a special case
        CMP.W #$0003
        BNE +
        JMP.W NameEntryInput_SelectSymbolPage                    ;a default case

      + CMP.W #$0004
        BNE +                                ;a special case
        JMP.W NameEntryInput_ConfirmCompletedName

      + %Set8bit(!M)                         ;Add next character
        LDA.W !name_entry_index
        CMP.B #$04
        BEQ .playsound                       ;No more space
        %Set16bit(!M)
        LDA.W #$0004
        JSL.L NameEntryGrid_ReadCurrentEntryField
        %Set8bit(!M)
        PHA
        LDA.B #$00
        XBA
        LDA.W !name_entry_index
        %Set16bit(!M)
        TAX
        %Set8bit(!M)
        PLA
        STA.W !temp_name_1,X                 ;set next character
        JSL.L NameEntryUI_DrawGlyphIntoCurrentSlot
        %Set8bit(!M)
        LDA.W !name_entry_index
        INC A
        STA.W !name_entry_index

    .playsound:
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$01
        STA.W $0114
        LDA.B #$06
        STA.W $0115
        JSL.L AudioSFX_PlayQueuedEffectDefaultVolume
        RTL

          ; PASS47_NAME_ENTRY_CORE: switch keyboard to page 0 / uppercase-like glyph set.
NameEntryInput_SelectUppercasePage: %Set8bit(!M)                             ;84C157;      ;
                       LDA.B #$00                           ;84C159;      ;
                       STA.W $0993                          ;84C15B;000993;
                       %Set16bit(!M)                             ;84C15E;      ;
                       STZ.W !BG1_Map_Offset_X                          ;84C160;00013C;
                       STZ.W !BG1_Map_Offset_Y                          ;84C163;00013E;
                       %Set16bit(!M)                             ;84C166;      ;
                       STZ.W !menu_pos                          ;84C168;000991;
                       %Set8bit(!M)                             ;84C16B;      ;
                       %Set16bit(!X)                             ;84C16D;      ;
                       LDA.B #$01                           ;84C16F;      ;
                       STA.W $0114                          ;84C171;000114;
                       LDA.B #$06                           ;84C174;      ;
                       STA.W $0115                          ;84C176;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C179;838332;
                       RTL                                  ;84C17D;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          ; PASS47_NAME_ENTRY_CORE: switch keyboard to page 1 / lowercase-like glyph set.
NameEntryInput_SelectLowercasePage: %Set8bit(!M)                             ;84C17E;      ;
                       LDA.B #$01                           ;84C180;      ;
                       STA.W $0993                          ;84C182;000993;
                       %Set16bit(!M)                             ;84C185;      ;
                       LDA.W #$0100                         ;84C187;      ;
                       STA.W !BG1_Map_Offset_X                          ;84C18A;00013C;
                       STZ.W !BG1_Map_Offset_Y                          ;84C18D;00013E;
                       %Set16bit(!M)                             ;84C190;      ;
                       STZ.W !menu_pos                          ;84C192;000991;
                       %Set8bit(!M)                             ;84C195;      ;
                       %Set16bit(!X)                             ;84C197;      ;
                       LDA.B #$01                           ;84C199;      ;
                       STA.W $0114                          ;84C19B;000114;
                       LDA.B #$06                           ;84C19E;      ;
                       STA.W $0115                          ;84C1A0;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C1A3;838332;
                       RTL                                  ;84C1A7;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          ; PASS47_NAME_ENTRY_CORE: switch keyboard to page 2 / symbol-control glyph set.
NameEntryInput_SelectSymbolPage: %Set8bit(!M)                             ;84C1A8;      ;
                       LDA.B #$02                           ;84C1AA;      ;
                       STA.W $0993                          ;84C1AC;000993;
                       %Set16bit(!M)                             ;84C1AF;      ;
                       STZ.W !BG1_Map_Offset_X                          ;84C1B1;00013C;
                       LDA.W #$0100                         ;84C1B4;      ;
                       STA.W !BG1_Map_Offset_Y                          ;84C1B7;00013E;
                       %Set16bit(!M)                             ;84C1BA;      ;
                       STZ.W !menu_pos                          ;84C1BC;000991;
                       %Set8bit(!M)                             ;84C1BF;      ;
                       %Set16bit(!X)                             ;84C1C1;      ;
                       LDA.B #$01                           ;84C1C3;      ;
                       STA.W $0114                          ;84C1C5;000114;
                       LDA.B #$06                           ;84C1C8;      ;
                       STA.W $0115                          ;84C1CA;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C1CD;838332;
                       RTL                                  ;84C1D1;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          ; PASS47_NAME_ENTRY_CORE: finish naming only when at least one glyph was entered.
NameEntryInput_ConfirmCompletedName: %Set8bit(!M)                             ;84C1D2;      ;
                       LDA.W !name_entry_index                          ;84C1D4;000994;
                       BEQ NameEntryInput_RejectEmptyNameConfirm                      ;84C1D7;84C1F1;
                       LDA.B #$03                           ;84C1D9;      ;
                       STA.W $0993                          ;84C1DB;000993;
                       %Set8bit(!M)                             ;84C1DE;      ;
                       %Set16bit(!X)                             ;84C1E0;      ;
                       LDA.B #$01                           ;84C1E2;      ;
                       STA.W $0114                          ;84C1E4;000114;
                       LDA.B #$06                           ;84C1E7;      ;
                       STA.W $0115                          ;84C1E9;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C1EC;838332;
                       RTL                                  ;84C1F0;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          NameEntryInput_RejectEmptyNameConfirm: %Set8bit(!M)                             ;84C1F1;      ;
                       %Set16bit(!X)                             ;84C1F3;      ;
                       LDA.B #$02                           ;84C1F5;      ;
                       STA.W $0114                          ;84C1F7;000114;
                       LDA.B #$06                           ;84C1FA;      ;
                       STA.W $0115                          ;84C1FC;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C1FF;838332;
                       RTL                                  ;84C203;      ;

;;;;;;;;
; PASS47_NAME_ENTRY_CORE: D-pad navigation uses neighbor indices from NameEntryGrid_PageDataTable.
NameEntryInput_MoveDown: ;84C204
        %Set16bit(!M)
        LDA.W #$0000
        JSL.L NameEntryGrid_ReadCurrentEntryField

        %Set16bit(!M)
        STA.W !menu_pos

        %Set8bit(!M)                         ;Sound, ew
        %Set16bit(!X)
        LDA.B #$03
        STA.W $0114
        LDA.B #$06
        STA.W $0115
        JSL.L AudioSFX_PlayQueuedEffectDefaultVolume

        RTL

;;;;;;;;
NameEntryInput_MoveUp: ;84C225
        %Set16bit(!M)
        LDA.W #$0001
        JSL.L NameEntryGrid_ReadCurrentEntryField

        %Set16bit(!M)
        STA.W !menu_pos

        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$03
        STA.W $0114
        LDA.B #$06
        STA.W $0115
        JSL.L AudioSFX_PlayQueuedEffectDefaultVolume

        RTL

;;;;;;;;
NameEntryInput_MoveLeft: ;84C246
        %Set16bit(!M)
        LDA.W #$0002
        JSL.L NameEntryGrid_ReadCurrentEntryField

        %Set16bit(!M)
        STA.W !menu_pos

        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$03
        STA.W $0114
        LDA.B #$06
        STA.W $0115
        JSL.L AudioSFX_PlayQueuedEffectDefaultVolume

        RTL

;;;;;;;;
NameEntryInput_MoveRight: ;84C267
        %Set16bit(!M)
        LDA.W #$0003
        JSL.L NameEntryGrid_ReadCurrentEntryField

        %Set16bit(!M)
        STA.W !menu_pos

        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$03
        STA.W $0114
        LDA.B #$06
        STA.W $0115
        JSL.L AudioSFX_PlayQueuedEffectDefaultVolume

        RTL

;;;;;;;;
; PASS23_INPUT_MENU_CORE: generic menu-mode input dispatcher.
; $95 acts as a menu/input submode. This routine routes save/load slot selection,
; confirmation choices, three-choice prompts and cursor-prompt grids.
MenuInput_DispatchByMenuMode: ;84C288
        %Set8bit(!M)
        LDA.B $95
        CMP.B #$01
        BNE .EventScriptBank84_Branch_84C293
        JMP.W MenuInput_MainFieldMenuMode

    .EventScriptBank84_Branch_84C293:
        CMP.B #$02
        BNE .EventScriptBank84_Branch_84C29A
        JMP.W MenuInput_StartButtonCloseOrAdvanceMode

    .EventScriptBank84_Branch_84C29A:
        CMP.B #$03
        BNE .EventScriptBank84_Branch_84C2A1
        JMP.W MenuInput_StartButtonCloseOrAdvanceMode

    .EventScriptBank84_Branch_84C2A1:
        CMP.B #$05
        BNE .EventScriptBank84_Branch_84C2A8
        JMP.W MenuInput_ThreeChoicePromptMode

    .EventScriptBank84_Branch_84C2A8:
        CMP.B #$07
        BEQ MenuInput_SaveSlotSelectMode
        CMP.B #$08
        BNE .EventScriptBank84_Branch_84C2B3
        JMP.W MenuInput_LoadSlotSelectMode

    .EventScriptBank84_Branch_84C2B3: RTL

;;;;;;;;
MenuInput_MainFieldMenuMode:
        %Set16bit(!MX)
        LDA.B !player_action
        CMP.W #$0003
        BEQ .EventScriptBank84_Branch_84C2C1
        JSL.L PlayerInput_DispatchBufferedFieldButtons

    .EventScriptBank84_Branch_84C2C1:
        %Set16bit(!MX)
        LDA.L $7F1F5A
        AND.W #$8000                         ;field/status menu is available
        BEQ .EventScriptBank84_Branch_84C2D7
        LDA.W !Joy1_New_Input
        BIT.W #$1000
        BEQ .EventScriptBank84_Branch_84C2D7
        JMP.W MenuInput_OpenSecondaryMenuFromStart

    .EventScriptBank84_Branch_84C2D7: RTL

;;;;;;;;
MenuInput_OpenSecondaryMenuFromStart:
        %Set8bit(!M)
        LDA.B #$09
        STA.B $95                            ;secondary field/status menu pending
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$03
        STA.W $0114
        LDA.B #$06
        STA.W $0115
        JSL.L AudioSFX_PlayQueuedEffectDefaultVolume
        %Set16bit(!M)
        LDA.L $7F1F5C
        ORA.W #$0004                         ;request field/status menu open/update
        STA.L $7F1F5C

        RTL

;;;;;;;;
MenuInput_SaveSlotSelectMode:
        %Set16bit(!MX)
        LDA.W !Joy1_New_Input
        BIT.W #$0400
        BEQ .EventScriptBank84_Branch_84C30B
        JMP.W MenuInput_ToggleSaveSlotCursor

    .EventScriptBank84_Branch_84C30B:
        LDA.W !Joy1_New_Input
        BIT.W #$0800
        BEQ .EventScriptBank84_Branch_84C316
        JMP.W MenuInput_ToggleSaveSlotCursor

    .EventScriptBank84_Branch_84C316:
        LDA.W !Joy1_New_Input
        BIT.W #$8000
        BEQ .EventScriptBank84_Branch_84C321
        JMP.W MenuInput_SelectConfirmYes

    .EventScriptBank84_Branch_84C321:
        LDA.W !Joy1_New_Input
        BIT.W #$0080
        BEQ .EventScriptBank84_Branch_84C32C
        JMP.W MenuInput_SelectConfirmNo

    .EventScriptBank84_Branch_84C32C: RTL


;;;;;;;;
          MenuInput_ToggleSaveSlotCursor: %Set8bit(!M)                             ;84C32D;      ;
                       LDA.W $098E                          ;84C32F;00098E;
                       EOR.B #$01                           ;84C332;      ;
                       STA.W $098E                          ;84C334;00098E;
                       LDA.B #$01                           ;84C337;      ;
                       STA.B $97                            ;84C339;000097;
                       %Set8bit(!M)                             ;84C33B;      ;
                       %Set16bit(!X)                             ;84C33D;      ;
                       LDA.B #$03                           ;84C33F;      ;
                       STA.W $0114                          ;84C341;000114;
                       LDA.B #$06                           ;84C344;      ;
                       STA.W $0115                          ;84C346;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C349;838332;
                       RTL                                  ;84C34D;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          MenuInput_SelectConfirmYes: %Set8bit(!M)                             ;84C34E;      ;
                       LDA.B #$01                           ;84C350;      ;
                       STA.B $94                            ;84C352;000094;
                       %Set8bit(!M)                             ;84C354;      ;
                       %Set16bit(!X)                             ;84C356;      ;
                       LDA.B #$03                           ;84C358;      ;
                       STA.W $0114                          ;84C35A;000114;
                       LDA.B #$06                           ;84C35D;      ;
                       STA.W $0115                          ;84C35F;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C362;838332;
                       RTL                                  ;84C366;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          MenuInput_SelectConfirmNo: %Set8bit(!M)                             ;84C367;      ;
                       LDA.B #$02                           ;84C369;      ;
                       STA.B $94                            ;84C36B;000094;
                       %Set8bit(!M)                             ;84C36D;      ;
                       %Set16bit(!X)                             ;84C36F;      ;
                       LDA.B #$01                           ;84C371;      ;
                       STA.W $0114                          ;84C373;000114;
                       LDA.B #$06                           ;84C376;      ;
                       STA.W $0115                          ;84C378;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C37B;838332;
                       RTL                                  ;84C37F;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          MenuInput_LoadSlotSelectMode: %Set16bit(!MX)                             ;84C380;      ;
                       LDA.W !Joy1_New_Input                          ;84C382;000128;
                       BIT.W #$0400                         ;84C385;      ;
                       BEQ EventScriptBank84_Branch_84C38D                      ;84C388;84C38D;
                       JMP.W MenuInput_ToggleLoadSlotCursor                    ;84C38A;84C3AF;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C38D: LDA.W !Joy1_New_Input                          ;84C38D;000128;
                       BIT.W #$0800                         ;84C390;      ;
                       BEQ EventScriptBank84_Branch_84C398                      ;84C393;84C398;
                       JMP.W MenuInput_ToggleLoadSlotCursor                    ;84C395;84C3AF;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C398: LDA.W !Joy1_New_Input                          ;84C398;000128;
                       BIT.W #$8000                         ;84C39B;      ;
                       BEQ EventScriptBank84_Branch_84C3A3                      ;84C39E;84C3A3;
                       JMP.W MenuInput_LoadSelectConfirmYes                    ;84C3A0;84C3D0;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C3A3: LDA.W !Joy1_New_Input                          ;84C3A3;000128;
                       BIT.W #$0080                         ;84C3A6;      ;
                       BEQ EventScriptBank84_Branch_84C3AE                      ;84C3A9;84C3AE;
                       JMP.W MenuInput_LoadSelectConfirmNoOrLoadSummary                    ;84C3AB;84C3E9;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C3AE: RTL                                  ;84C3AE;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          MenuInput_ToggleLoadSlotCursor: %Set8bit(!M)                             ;84C3AF;      ;
                       LDA.W $098E                          ;84C3B1;00098E;
                       EOR.B #$01                           ;84C3B4;      ;
                       STA.W $098E                          ;84C3B6;00098E;
                       LDA.B #$01                           ;84C3B9;      ;
                       STA.B $97                            ;84C3BB;000097;
                       %Set8bit(!M)                             ;84C3BD;      ;
                       %Set16bit(!X)                             ;84C3BF;      ;
                       LDA.B #$03                           ;84C3C1;      ;
                       STA.W $0114                          ;84C3C3;000114;
                       LDA.B #$06                           ;84C3C6;      ;
                       STA.W $0115                          ;84C3C8;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C3CB;838332;
                       RTL                                  ;84C3CF;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          MenuInput_LoadSelectConfirmYes: %Set8bit(!M)                             ;84C3D0;      ;
                       LDA.B #$01                           ;84C3D2;      ;
                       STA.B $94                            ;84C3D4;000094;
                       %Set8bit(!M)                             ;84C3D6;      ;
                       %Set16bit(!X)                             ;84C3D8;      ;
                       LDA.B #$03                           ;84C3DA;      ;
                       STA.W $0114                          ;84C3DC;000114;
                       LDA.B #$06                           ;84C3DF;      ;
                       STA.W $0115                          ;84C3E1;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C3E4;838332;
                       RTL                                  ;84C3E8;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          MenuInput_LoadSelectConfirmNoOrLoadSummary: %Set8bit(!M)                             ;84C3E9;      ;
                       LDA.B #$00                           ;84C3EB;      ;
                       XBA                                  ;84C3ED;      ;
                       LDA.W $098E                          ;84C3EE;00098E;
                       JSL.L SaveSystem_LoadSlotSummary                      ;84C3F1;83BA45;
                       %Set16bit(!MX)                             ;84C3F5;      ;
                       CPX.W #$0000                         ;84C3F7;      ;
                       BEQ EventScriptBank84_Branch_84C415                      ;84C3FA;84C415;
                       %Set8bit(!M)                             ;84C3FC;      ;
                       LDA.B #$02                           ;84C3FE;      ;
                       STA.B $94                            ;84C400;000094;
                       %Set8bit(!M)                             ;84C402;      ;
                       %Set16bit(!X)                             ;84C404;      ;
                       LDA.B #$01                           ;84C406;      ;
                       STA.W $0114                          ;84C408;000114;
                       LDA.B #$06                           ;84C40B;      ;
                       STA.W $0115                          ;84C40D;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C410;838332;
                       RTL                                  ;84C414;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C415: %Set8bit(!M)                             ;84C415;      ;
                       %Set16bit(!X)                             ;84C417;      ;
                       LDA.B #$02                           ;84C419;      ;
                       STA.W $0114                          ;84C41B;000114;
                       LDA.B #$06                           ;84C41E;      ;
                       STA.W $0115                          ;84C420;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C423;838332;
                       RTL                                  ;84C427;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          MenuInput_StartButtonCloseOrAdvanceMode: %Set16bit(!MX)                             ;84C428;      ;
                       LDA.L $7F1F5A                        ;84C42A;7F1F5A;
                       AND.W #$8000                         ;84C42E;      ;
                       BEQ EventScriptBank84_Branch_84C43E                      ;84C431;84C43E;
                       LDA.W !Joy1_New_Input                          ;84C433;000128;
                       BIT.W #$1000                         ;84C436;      ;
                       BEQ EventScriptBank84_Branch_84C43E                      ;84C439;84C43E;
                       JMP.W MenuInput_SwitchToMode06FromStart                    ;84C43B;84C43F;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C43E: RTL                                  ;84C43E;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          MenuInput_SwitchToMode06FromStart: %Set8bit(!M)                             ;84C43F;      ;
                       LDA.B #$06                           ;84C441;      ;
                       STA.B $95                            ;84C443;000095;
                       %Set8bit(!M)                             ;84C445;      ;
                       %Set16bit(!X)                             ;84C447;      ;
                       LDA.B #$03                           ;84C449;      ;
                       STA.W $0114                          ;84C44B;000114;
                       LDA.B #$06                           ;84C44E;      ;
                       STA.W $0115                          ;84C450;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C453;838332;
                       RTL                                  ;84C457;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          MenuInput_ThreeChoicePromptMode: %Set16bit(!MX)                             ;84C458;      ;
                       LDA.W !Joy1_New_Input                          ;84C45A;000128;
                       BIT.W #$0400                         ;84C45D;      ;
                       BEQ EventScriptBank84_Branch_84C465                      ;84C460;84C465;
                       JMP.W MenuInput_ThreeChoiceMoveDown                    ;84C462;84C47C;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C465: LDA.W !Joy1_New_Input                          ;84C465;000128;
                       BIT.W #$0800                         ;84C468;      ;
                       BEQ EventScriptBank84_Branch_84C470                      ;84C46B;84C470;
                       JMP.W MenuInput_ThreeChoiceMoveUp                    ;84C46D;84C4C4;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C470: LDA.W !Joy1_New_Input                          ;84C470;000128;
                       BIT.W #$0080                         ;84C473;      ;
                       BEQ EventScriptBank84_Branch_84C47B                      ;84C476;84C47B;
                       JMP.W MenuInput_ThreeChoiceAccept                    ;84C478;84C50C;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C47B: RTL                                  ;84C47B;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          MenuInput_ThreeChoiceMoveDown: %Set16bit(!M)                             ;84C47C;      ;
                       STZ.B $90                            ;84C47E;000090;
                       %Set8bit(!M)                             ;84C480;      ;
                       LDA.W $098D                          ;84C482;00098D;
                       CMP.B #$02                           ;84C485;      ;
                       BEQ EventScriptBank84_Branch_84C4A4                      ;84C487;84C4A4;
                       INC A                                ;84C489;      ;
                       STA.W $098D                          ;84C48A;00098D;
                       LDA.B #$01                           ;84C48D;      ;
                       STA.B $97                            ;84C48F;000097;
                       %Set8bit(!M)                             ;84C491;      ;
                       %Set16bit(!X)                             ;84C493;      ;
                       LDA.B #$03                           ;84C495;      ;
                       STA.W $0114                          ;84C497;000114;
                       LDA.B #$06                           ;84C49A;      ;
                       STA.W $0115                          ;84C49C;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C49F;838332;
                       RTL                                  ;84C4A3;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C4A4: %Set16bit(!M)                             ;84C4A4;      ;
                       STZ.B $90                            ;84C4A6;000090;
                       %Set8bit(!M)                             ;84C4A8;      ;
                       STZ.W $098D                          ;84C4AA;00098D;
                       LDA.B #$01                           ;84C4AD;      ;
                       STA.B $97                            ;84C4AF;000097;
                       %Set8bit(!M)                             ;84C4B1;      ;
                       %Set16bit(!X)                             ;84C4B3;      ;
                       LDA.B #$03                           ;84C4B5;      ;
                       STA.W $0114                          ;84C4B7;000114;
                       LDA.B #$06                           ;84C4BA;      ;
                       STA.W $0115                          ;84C4BC;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C4BF;838332;
                       RTL                                  ;84C4C3;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          MenuInput_ThreeChoiceMoveUp: %Set16bit(!M)                             ;84C4C4;      ;
                       STZ.B $90                            ;84C4C6;000090;
                       %Set8bit(!M)                             ;84C4C8;      ;
                       LDA.W $098D                          ;84C4CA;00098D;
                       BEQ EventScriptBank84_Branch_84C4EA                      ;84C4CD;84C4EA;
                       DEC A                                ;84C4CF;      ;
                       STA.W $098D                          ;84C4D0;00098D;
                       LDA.B #$01                           ;84C4D3;      ;
                       STA.B $97                            ;84C4D5;000097;
                       %Set8bit(!M)                             ;84C4D7;      ;
                       %Set16bit(!X)                             ;84C4D9;      ;
                       LDA.B #$03                           ;84C4DB;      ;
                       STA.W $0114                          ;84C4DD;000114;
                       LDA.B #$06                           ;84C4E0;      ;
                       STA.W $0115                          ;84C4E2;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C4E5;838332;
                       RTL                                  ;84C4E9;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C4EA: %Set16bit(!M)                             ;84C4EA;      ;
                       STZ.B $90                            ;84C4EC;000090;
                       %Set8bit(!M)                             ;84C4EE;      ;
                       LDA.B #$02                           ;84C4F0;      ;
                       STA.W $098D                          ;84C4F2;00098D;
                       LDA.B #$01                           ;84C4F5;      ;
                       STA.B $97                            ;84C4F7;000097;
                       %Set8bit(!M)                             ;84C4F9;      ;
                       %Set16bit(!X)                             ;84C4FB;      ;
                       LDA.B #$03                           ;84C4FD;      ;
                       STA.W $0114                          ;84C4FF;000114;
                       LDA.B #$06                           ;84C502;      ;
                       STA.W $0115                          ;84C504;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C507;838332;
                       RTL                                  ;84C50B;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          MenuInput_ThreeChoiceAccept: %Set8bit(!M)                             ;84C50C;      ;
                       LDA.W $098D                          ;84C50E;00098D;
                       BEQ EventScriptBank84_Branch_84C51D                      ;84C511;84C51D;
                       CMP.B #$01                           ;84C513;      ;
                       BEQ EventScriptBank84_Branch_84C525                      ;84C515;84C525;
                       LDA.B #$0A                           ;84C517;      ;
                       STA.B $95                            ;84C519;000095;
                       BRA EventScriptBank84_Branch_84C52D                      ;84C51B;84C52D;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C51D: %Set8bit(!M)                             ;84C51D;      ;
                       LDA.B #$08                           ;84C51F;      ;
                       STA.B $95                            ;84C521;000095;
                       BRA EventScriptBank84_Branch_84C52D                      ;84C523;84C52D;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C525: %Set8bit(!M)                             ;84C525;      ;
                       LDA.B #$07                           ;84C527;      ;
                       STA.B $95                            ;84C529;000095;
                       BRA EventScriptBank84_Branch_84C52D                      ;84C52B;84C52D;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C52D: %Set8bit(!M)                             ;84C52D;      ;
                       %Set16bit(!X)                             ;84C52F;      ;
                       LDA.B #$01                           ;84C531;      ;
                       STA.W $0114                          ;84C533;000114;
                       LDA.B #$06                           ;84C536;      ;
                       STA.W $0115                          ;84C538;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C53B;838332;
                       RTL                                  ;84C53F;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          PromptCursorInput_GridCursorMode: %Set16bit(!MX)                             ;84C540;      ;
                       LDA.W !Joy1_Autorepeat                          ;84C542;00012C;
                       BIT.W #$0400                         ;84C545;      ;
                       BEQ EventScriptBank84_Branch_84C54D                      ;84C548;84C54D;
                       JMP.W PromptCursorInput_MoveDown                    ;84C54A;84C5D1;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C54D: LDA.W !Joy1_Autorepeat                          ;84C54D;00012C;
                       BIT.W #$0800                         ;84C550;      ;
                       BEQ EventScriptBank84_Branch_84C558                      ;84C553;84C558;
                       JMP.W PromptCursorInput_MoveUp                    ;84C555;84C612;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C558: LDA.W !Joy1_Autorepeat                          ;84C558;00012C;
                       BIT.W #$0100                         ;84C55B;      ;
                       BEQ EventScriptBank84_Branch_84C563                      ;84C55E;84C563;
                       JMP.W PromptCursorInput_MoveRightColumn                    ;84C560;84C651;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C563: LDA.W !Joy1_Autorepeat                          ;84C563;00012C;
                       BIT.W #$0200                         ;84C566;      ;
                       BEQ EventScriptBank84_Branch_84C56E                      ;84C569;84C56E;
                       JMP.W PromptCursorInput_MoveLeftColumn                    ;84C56B;84C684;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C56E: LDA.W !Joy1_New_Input                          ;84C56E;000128;
                       BIT.W #$0080                         ;84C571;      ;
                       BEQ EventScriptBank84_Branch_84C579                      ;84C574;84C579;
                       JMP.W PromptCursorInput_AcceptSelectionOrStartText                    ;84C576;84C57A;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C579: RTL                                  ;84C579;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          PromptCursorInput_AcceptSelectionOrStartText: %Set8bit(!M)                             ;84C57A;      ;
                       %Set16bit(!X)                             ;84C57C;      ;
                       LDA.B #$01                           ;84C57E;      ;
                       STA.W $0114                          ;84C580;000114;
                       LDA.B #$06                           ;84C583;      ;
                       STA.W $0115                          ;84C585;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C588;838332;
                       %Set8bit(!M)                             ;84C58C;      ;
                       STZ.W $019B                          ;84C58E;00019B;
                       %Set8bit(!M)                             ;84C591;      ;
                       LDA.B #$02                           ;84C593;      ;
                       STA.W !inputstate                          ;84C595;00019A;
                       LDA.B #$00                           ;84C598;      ;
                       XBA                                  ;84C59A;      ;
                       LDA.W $018A                          ;84C59B;00018A;
                       CMP.B #$0B                           ;84C59E;      ;
                       BCC EventScriptBank84_Branch_84C5B4                      ;84C5A0;84C5B4;
                       %Set8bit(!M)                             ;84C5A2;      ;
                       LDA.B #$01                           ;84C5A4;      ;
                       STA.W !inputstate                          ;84C5A6;00019A;
                       %Set16bit(!M)                             ;84C5A9;      ;
                       LDA.W #$0001                         ;84C5AB;      ;
                       JSL.L TextBox_QueuePromptCursorTileDMA                    ;84C5AE;8394D7;
                       BRA EventScriptBank84_Branch_84C5C8                      ;84C5B2;84C5C8;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C5B4: %Set16bit(!M)                             ;84C5B4;      ;
                       ASL A                                ;84C5B6;      ;
                       TAX                                  ;84C5B7;      ;
                       LDA.L TextBox_PromptAcceptSelectionTextIdTable,X                 ;84C5B8;839467;
                       TAX                                  ;84C5BC;      ;
                       %Set8bit(!M)                             ;84C5BD;      ;
                       LDA.B #$00                           ;84C5BF;      ;
                       STA.W $0191                          ;84C5C1;000191;
                       JSL.L TextBox_StartByTextId                    ;84C5C4;83935F;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C5C8: %Set16bit(!M)                             ;84C5C8;      ;
                       LDA.W #$0100                         ;84C5CA;      ;
                       STA.W !BG2_Map_Offset_Y                          ;84C5CD;000142;
                       RTL                                  ;84C5D0;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          PromptCursorInput_MoveDown: %Set8bit(!M)                             ;84C5D1;      ;
                       %Set16bit(!X)                             ;84C5D3;      ;
                       LDA.B #$03                           ;84C5D5;      ;
                       STA.W $0114                          ;84C5D7;000114;
                       LDA.B #$06                           ;84C5DA;      ;
                       STA.W $0115                          ;84C5DC;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C5DF;838332;
                       %Set8bit(!M)                             ;84C5E3;      ;
                       LDA.W $018A                          ;84C5E5;00018A;
                       CMP.B #$0B                           ;84C5E8;      ;
                       BCS EventScriptBank84_Branch_84C611                      ;84C5EA;84C611;
                       %Set16bit(!M)                             ;84C5EC;      ;
                       LDA.W #$0001                         ;84C5EE;      ;
                       JSL.L TextBox_QueuePromptCursorTileDMA                    ;84C5F1;8394D7;
                       %Set8bit(!M)                             ;84C5F5;      ;
                       LDA.W $018A                          ;84C5F7;00018A;
                       CMP.B #$0A                           ;84C5FA;      ;
                       BNE EventScriptBank84_Branch_84C605                      ;84C5FC;84C605;
                       LDA.B #$00                           ;84C5FE;      ;
                       STA.W $018A                          ;84C600;00018A;
                       BRA EventScriptBank84_Branch_84C611                      ;84C603;84C611;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C605: %Set8bit(!M)                             ;84C605;      ;
                       LDA.W $018A                          ;84C607;00018A;
                       INC A                                ;84C60A;      ;
                       STA.W $018A                          ;84C60B;00018A;
                       STZ.W $018B                          ;84C60E;00018B;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C611: RTL                                  ;84C611;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          PromptCursorInput_MoveUp: %Set8bit(!M)                             ;84C612;      ;
                       %Set16bit(!X)                             ;84C614;      ;
                       LDA.B #$03                           ;84C616;      ;
                       STA.W $0114                          ;84C618;000114;
                       LDA.B #$06                           ;84C61B;      ;
                       STA.W $0115                          ;84C61D;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C620;838332;
                       %Set8bit(!M)                             ;84C624;      ;
                       LDA.W $018A                          ;84C626;00018A;
                       CMP.B #$0B                           ;84C629;      ;
                       BCS EventScriptBank84_Branch_84C650                      ;84C62B;84C650;
                       %Set16bit(!M)                             ;84C62D;      ;
                       LDA.W #$0001                         ;84C62F;      ;
                       JSL.L TextBox_QueuePromptCursorTileDMA                    ;84C632;8394D7;
                       %Set8bit(!M)                             ;84C636;      ;
                       LDA.W $018A                          ;84C638;00018A;
                       BNE EventScriptBank84_Branch_84C644                      ;84C63B;84C644;
                       LDA.B #$0A                           ;84C63D;      ;
                       STA.W $018A                          ;84C63F;00018A;
                       BRA EventScriptBank84_Branch_84C650                      ;84C642;84C650;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C644: %Set8bit(!M)                             ;84C644;      ;
                       LDA.W $018A                          ;84C646;00018A;
                       DEC A                                ;84C649;      ;
                       STA.W $018A                          ;84C64A;00018A;
                       STZ.W $018B                          ;84C64D;00018B;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C650: RTL                                  ;84C650;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          PromptCursorInput_MoveRightColumn: %Set8bit(!M)                             ;84C651;      ;
                       %Set16bit(!X)                             ;84C653;      ;
                       LDA.B #$03                           ;84C655;      ;
                       STA.W $0114                          ;84C657;000114;
                       LDA.B #$06                           ;84C65A;      ;
                       STA.W $0115                          ;84C65C;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C65F;838332;
                       %Set8bit(!M)                             ;84C663;      ;
                       LDA.W $018A                          ;84C665;00018A;
                       CMP.B #$0B                           ;84C668;      ;
                       BCS EventScriptBank84_Branch_84C683                      ;84C66A;84C683;
                       %Set16bit(!M)                             ;84C66C;      ;
                       LDA.W #$0001                         ;84C66E;      ;
                       JSL.L TextBox_QueuePromptCursorTileDMA                    ;84C671;8394D7;
                       %Set8bit(!M)                             ;84C675;      ;
                       LDA.W $018A                          ;84C677;00018A;
                       CLC                                  ;84C67A;      ;
                       ADC.B #$0B                           ;84C67B;      ;
                       STA.W $018A                          ;84C67D;00018A;
                       STZ.W $018B                          ;84C680;00018B;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C683: RTL                                  ;84C683;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          PromptCursorInput_MoveLeftColumn: %Set8bit(!M)                             ;84C684;      ;
                       %Set16bit(!X)                             ;84C686;      ;
                       LDA.B #$03                           ;84C688;      ;
                       STA.W $0114                          ;84C68A;000114;
                       LDA.B #$06                           ;84C68D;      ;
                       STA.W $0115                          ;84C68F;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84C692;838332;
                       %Set8bit(!M)                             ;84C696;      ;
                       LDA.W $018A                          ;84C698;00018A;
                       CMP.B #$0B                           ;84C69B;      ;
                       BCC EventScriptBank84_Branch_84C6B6                      ;84C69D;84C6B6;
                       %Set16bit(!M)                             ;84C69F;      ;
                       LDA.W #$0001                         ;84C6A1;      ;
                       JSL.L TextBox_QueuePromptCursorTileDMA                    ;84C6A4;8394D7;
                       %Set8bit(!M)                             ;84C6A8;      ;
                       LDA.W $018A                          ;84C6AA;00018A;
                       SEC                                  ;84C6AD;      ;
                       SBC.B #$0B                           ;84C6AE;      ;
                       STA.W $018A                          ;84C6B0;00018A;
                       STZ.W $018B                          ;84C6B3;00018B;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C6B6: RTL                                  ;84C6B6;      ;

;;;;;; PASS27_PLAYER_MOVEMENT_COLLISION_CORE: normal field movement/interact input.
; This is the core field-control dispatcher for the player while the game is in the
; normal movement input state. It gates interaction by game_state/player_action,
; starts directional walking, and dispatches A/B/Y/L/R/X/Select to interaction,
; run/jump, tool/fishing, whistle, and auxiliary action handlers.
PlayerInput_NormalMovementCore:
      %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$00C4                           ;flags that indicate it cant interact
      BEQ +
      JMP.W PlayerInput_Return

    + LDA.B !player_action
      CMP.W #$0003                           ;Jump
      BNE +
      JMP.W PlayerInput_Return

    + LDA.L $7F1F5C
      AND.W #$0020                           ;TODO
      BEQ +
      JMP.W PlayerInput_Return

    + %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$1000                           ;TODO
      BEQ +
      JMP.W PlayerInput_DispatchBufferedFieldButtons

    + %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$4000                           ;TODO
      BNE +
      JMP.W PlayerInput_Return

    + %Set16bit(!MX)
      LDA.B !player_action
      CMP.W #$0011                           ;Fishing
      BNE +
      JMP.W PlayerActionToolUse

    + CMP.W #$0012                           ;Fishing with bite
      BNE +
      JMP.W PlayerActionToolUse

    + %Set8bit(!M)
      LDX.B !player_action
      LDA.L PlayerAction_InteractionLockTable,X
      BEQ +
      JMP.W PlayerInput_Return

    + %Set16bit(!MX)
      LDA.W !Joy1_Current
      BIT.W !key_Down
      BEQ +
      JMP.W PlayerMove_StartDown

    + LDA.W !Joy1_Current
      BIT.W !key_Up
      BEQ +
      JMP.W PlayerMove_StartUp

    + LDA.W !Joy1_Current
      BIT.W !key_Left
      BEQ +
      JMP.W PlayerMove_StartLeft

    + LDA.W !Joy1_Current
      BIT.W !key_Right
      BEQ PlayerInput_ProcessActionButtons
      JMP.W PlayerMove_StartRight

;;;;;;
PlayerInput_ProcessActionButtons:
      %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$1000                           ;TODO
      BEQ +
      JMP.W EventScriptBank84_Branch_84C804

    + %Set16bit(!MX)
      LDA.B !player_action
      CMP.W #$000F                           ;prepared to cast
      BNE +
      JMP.W PlayerActionToolUse

    + %Set16bit(!M)
      LDA.W !Joy1_New_Input
      BIT.W !key_A
      BEQ +
      JMP.W PlayerInput_A_InteractOrDrop

    + %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$0020
      BEQ +
      JMP.W PlayerInput_Return

    + %Set16bit(!M)
      LDA.W !Joy1_Current
      BIT.W !key_B
      BEQ +
      JMP.W PlayerInput_B_RunOrJump

    + LDA.W !Joy1_New_Input
      BIT.W !key_Select
      BEQ +
      JMP.W PlayerInput_Select_Action0C

    + LDA.W !Joy1_New_Input
      BIT.W !key_X
      BEQ +
      JMP.W PlayerInput_X_Action1C

    + LDA.W !Joy1_New_Input
      BIT.W !key_R
      BEQ +
      JMP.W PlayerInput_R_WhistleHorse

    + LDA.W !Joy1_New_Input
      BIT.W !key_L
      BEQ PlayerActionToolUse
      JMP.W PlayerInput_L_WhistleDog

  PlayerActionToolUse:
      LDA.W !Joy1_New_Input
      BIT.W !key_Y
      BEQ PlayerInput_Return
      JMP.W PlayerInput_Y_ToolOrFishing

PlayerInput_Return: RTL

;1 walk, 2 run, 3 jump, 4 item on hand, 9 idle, b tired?, c show item start, 10 casting, 11 fishing, 12 fishing with bite, 13 reeling, 14 drunk, 15 drinking
;Inverse 1 = CANT'T move or interact
PlayerAction_InteractionLockTable: db $00,$00,$00,$00,$01,$01,$00,$00,$01,$00,$01,$01,$01,$01,$00,$00;84C7B6;      ;
                         db $01,$00,$00,$01,$01,$01,$01,$01,$01,$00,$01,$01,$01,$00,$00,$00;84C7C6;      ;
                                                            ;      ;      ;
; PASS39_FIELD_STATUS_MENU_GATE:
; Dispatches buffered field buttons from $08FD through the same movement/action
; handlers used by live input. The Start/status gate uses this before opening
; the secondary field menu so movement/action state remains consistent.
PlayerInput_DispatchBufferedFieldButtons: %Set16bit(!MX)                             ;84C7D6;      ;
                       LDA.W $08FD                          ;84C7D8;0008FD;
                       BIT.W #$0400                         ;84C7DB;      ;
                       BEQ EventScriptBank84_Branch_84C7E3                      ;84C7DE;84C7E3;
                       JMP.W PlayerMove_StartDown                    ;84C7E0;84C935;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C7E3: LDA.W $08FD                          ;84C7E3;0008FD;
                       BIT.W #$0800                         ;84C7E6;      ;
                       BEQ EventScriptBank84_Branch_84C7EE                      ;84C7E9;84C7EE;
                       JMP.W PlayerMove_StartUp                    ;84C7EB;84C96F;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C7EE: LDA.W $08FD                          ;84C7EE;0008FD;
                       BIT.W #$0100                         ;84C7F1;      ;
                       BEQ EventScriptBank84_Branch_84C7F9                      ;84C7F4;84C7F9;
                       JMP.W PlayerMove_StartLeft                    ;84C7F6;84C9A9;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C7F9: LDA.W $08FD                          ;84C7F9;0008FD;
                       BIT.W #$0200                         ;84C7FC;      ;
                       BEQ EventScriptBank84_Branch_84C804                      ;84C7FF;84C804;
                       JMP.W PlayerMove_StartRight                    ;84C801;84C9E3;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C804: LDA.W $08FD                          ;84C804;0008FD;
                       BIT.W #$0080                         ;84C807;      ;
                       BEQ EventScriptBank84_Branch_84C80F                      ;84C80A;84C80F;
                       JMP.W PlayerInput_A_InteractOrDrop                    ;84C80C;84CAA5;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C80F: LDA.W $08FD                          ;84C80F;0008FD;
                       BIT.W #$8000                         ;84C812;      ;
                       BEQ EventScriptBank84_Branch_84C81A                      ;84C815;84C81A;
                       JMP.W PlayerInput_B_RunOrJump                    ;84C817;84CA1D;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C81A: LDA.W $08FD                          ;84C81A;0008FD;
                       BIT.W #$2000                         ;84C81D;      ;
                       BEQ EventScriptBank84_Branch_84C825                      ;84C820;84C825;
                       JMP.W PlayerInput_Select_Action0C                    ;84C822;84CE7A;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C825: LDA.W $08FD                          ;84C825;0008FD;
                       BIT.W #$0040                         ;84C828;      ;
                       BEQ EventScriptBank84_Branch_84C830                      ;84C82B;84C830;
                       JMP.W PlayerInput_X_Action1C                    ;84C82D;84CEA6;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C830: LDA.W $08FD                          ;84C830;0008FD;
                       BIT.W #$0010                         ;84C833;      ;
                       BEQ EventScriptBank84_Branch_84C83B                      ;84C836;84C83B;
                       JMP.W PlayerInput_R_WhistleHorse                    ;84C838;84CE0C;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C83B: LDA.W $08FD                          ;84C83B;0008FD;
                       BIT.W #$0020                         ;84C83E;      ;
                       BEQ EventScriptBank84_Branch_84C846                      ;84C841;84C846;
                       JMP.W PlayerInput_L_WhistleDog                    ;84C843;84CE43;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C846: LDA.W $08FD                          ;84C846;0008FD;
                       BIT.W #$4000                         ;84C849;      ;
                       BEQ EventScriptBank84_Branch_84C851                      ;84C84C;84C851;
                       JMP.W PlayerInput_Y_ToolOrFishing                    ;84C84E;84CD77;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C851: RTL                                  ;84C851;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;84C852;      ;
                       LDA.W !Joy1_New_Unpressed                         ;84C854;00012A;
                       BIT.W #$0080                         ;84C857;      ;
                       BEQ EventScriptBank84_Branch_84C85F                      ;84C85A;84C85F;
                       JMP.W EventScriptBank84_Branch_84C92B                    ;84C85C;84C92B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C85F: LDA.W !Joy1_Current                          ;84C85F;000124;
                       BIT.W #$0400                         ;84C862;      ;
                       BNE EventScriptBank84_Branch_84C88A                      ;84C865;84C88A;
                       LDA.W !Joy1_Current                          ;84C867;000124;
                       BIT.W #$0800                         ;84C86A;      ;
                       BNE EventScriptBank84_Branch_84C8AD                      ;84C86D;84C8AD;
                       LDA.W !Joy1_Current                          ;84C86F;000124;
                       BIT.W #$0100                         ;84C872;      ;
                       BNE EventScriptBank84_Branch_84C8D0                      ;84C875;84C8D0;
                       LDA.W !Joy1_Current                          ;84C877;000124;
                       BIT.W #$0200                         ;84C87A;      ;
                       BEQ EventScriptBank84_Branch_84C882                      ;84C87D;84C882;
                       JMP.W EventScriptBank84_Branch_84C8F3                    ;84C87F;84C8F3;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C882: %Set16bit(!MX)                             ;84C882;      ;
                       LDA.W #$0000                         ;84C884;      ;
                       STA.B !player_action                            ;84C887;0000D4;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C889: RTL                                  ;84C889;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C88A: %Set16bit(!MX)                             ;84C88A;      ;
                       LDA.W $0911                          ;84C88C;000911;
                       CMP.W #$0000                         ;84C88F;      ;
                       BNE EventScriptBank84_Branch_84C897                      ;84C892;84C897;
                       JMP.W EventScriptBank84_Branch_84C917                    ;84C894;84C917;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C897: %Set16bit(!MX)                             ;84C897;      ;
                       LDA.W $0911                          ;84C899;000911;
                       CMP.W #$0001                         ;84C89C;      ;
                       BNE EventScriptBank84_Branch_84C8A4                      ;84C89F;84C8A4;
                       JMP.W EventScriptBank84_Branch_84C921                    ;84C8A1;84C921;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C8A4: %Set16bit(!MX)                             ;84C8A4;      ;
                       LDA.W #$0000                         ;84C8A6;      ;
                       STA.B !player_action                            ;84C8A9;0000D4;
                       BRA EventScriptBank84_Branch_84C889                      ;84C8AB;84C889;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C8AD: %Set16bit(!MX)                             ;84C8AD;      ;
                       LDA.W $0911                          ;84C8AF;000911;
                       CMP.W #$0001                         ;84C8B2;      ;
                       BNE EventScriptBank84_Branch_84C8BA                      ;84C8B5;84C8BA;
                       JMP.W EventScriptBank84_Branch_84C917                    ;84C8B7;84C917;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C8BA: %Set16bit(!MX)                             ;84C8BA;      ;
                       LDA.W $0911                          ;84C8BC;000911;
                       CMP.W #$0000                         ;84C8BF;      ;
                       BNE EventScriptBank84_Branch_84C8C7                      ;84C8C2;84C8C7;
                       JMP.W EventScriptBank84_Branch_84C921                    ;84C8C4;84C921;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C8C7: %Set16bit(!MX)                             ;84C8C7;      ;
                       LDA.W #$0000                         ;84C8C9;      ;
                       STA.B !player_action                            ;84C8CC;0000D4;
                       BRA EventScriptBank84_Branch_84C889                      ;84C8CE;84C889;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C8D0: %Set16bit(!MX)                             ;84C8D0;      ;
                       LDA.W $0911                          ;84C8D2;000911;
                       CMP.W #$0002                         ;84C8D5;      ;
                       BNE EventScriptBank84_Branch_84C8DD                      ;84C8D8;84C8DD;
                       JMP.W EventScriptBank84_Branch_84C917                    ;84C8DA;84C917;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C8DD: %Set16bit(!MX)                             ;84C8DD;      ;
                       LDA.W $0911                          ;84C8DF;000911;
                       CMP.W #$0003                         ;84C8E2;      ;
                       BNE EventScriptBank84_Branch_84C8EA                      ;84C8E5;84C8EA;
                       JMP.W EventScriptBank84_Branch_84C921                    ;84C8E7;84C921;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C8EA: %Set16bit(!MX)                             ;84C8EA;      ;
                       LDA.W #$0000                         ;84C8EC;      ;
                       STA.B !player_action                            ;84C8EF;0000D4;
                       BRA EventScriptBank84_Branch_84C889                      ;84C8F1;84C889;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C8F3: %Set16bit(!MX)                             ;84C8F3;      ;
                       LDA.W $0911                          ;84C8F5;000911;
                       CMP.W #$0003                         ;84C8F8;      ;
                       BNE EventScriptBank84_Branch_84C900                      ;84C8FB;84C900;
                       JMP.W EventScriptBank84_Branch_84C917                    ;84C8FD;84C917;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C900: %Set16bit(!MX)                             ;84C900;      ;
                       LDA.W $0911                          ;84C902;000911;
                       CMP.W #$0002                         ;84C905;      ;
                       BNE EventScriptBank84_Branch_84C90D                      ;84C908;84C90D;
                       JMP.W EventScriptBank84_Branch_84C921                    ;84C90A;84C921;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C90D: %Set16bit(!MX)                             ;84C90D;      ;
                       LDA.W #$0000                         ;84C90F;      ;
                       STA.B !player_action                            ;84C912;0000D4;
                       JMP.W EventScriptBank84_Branch_84C889                    ;84C914;84C889;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C917: %Set16bit(!MX)                             ;84C917;      ;
                       LDA.W #$0007                         ;84C919;      ;
                       STA.B !player_action                            ;84C91C;0000D4;
                       JMP.W EventScriptBank84_Branch_84C889                    ;84C91E;84C889;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C921: %Set16bit(!MX)                             ;84C921;      ;
                       LDA.W #$0006                         ;84C923;      ;
                       STA.B !player_action                            ;84C926;0000D4;
                       JMP.W EventScriptBank84_Branch_84C889                    ;84C928;84C889;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84C92B: %Set16bit(!MX)                             ;84C92B;      ;
                       LDA.W #$0000                         ;84C92D;      ;
                       STA.B !player_action                            ;84C930;0000D4;
                       JMP.W EventScriptBank84_Branch_84C889                    ;84C932;84C889;

;;;;;;
PlayerMove_StartDown: ;84C935
      %Set16bit(!MX)
      LDA.W #$0001                           ;Walking
      STA.B !player_action
      %Set16bit(!MX)
      LDA.W #$0000
      STA.B !player_direction
      %Set16bit(!MX)
      LDA.W #$0000
      STA.W $0911                            ;TODO
      JMP.W PlayerInput_ProcessActionButtons

      %Set16bit(!MX)
      LDA.W $0911
      CMP.W #$0001
      BNE .return
      JMP.W .reversecommand

  .return JMP.W PlayerInput_Return

  .reversecommand:
      %Set16bit(!MX)
      LDA.W #$0001
      STA.B !player_action
      %Set16bit(!MX)
      LDA.W #$0001
      STA.B !player_direction
      JMP.W PlayerInput_Return

;;;;;;
PlayerMove_StartUp:
      %Set16bit(!MX)
      LDA.W #$0001
      STA.B !player_action
      %Set16bit(!MX)
      LDA.W #$0001                         ;84C978;      ;
      STA.B !player_direction                            ;84C97B;0000DA;
      %Set16bit(!MX)                             ;84C97D;      ;
      LDA.W #$0001                         ;84C97F;      ;
      STA.W $0911                          ;84C982;000911;
      JMP.W PlayerInput_ProcessActionButtons                    ;84C985;84C740;
                                  ;      ;      ;
      %Set16bit(!MX)                             ;84C988;      ;
      LDA.W $0911                          ;84C98A;000911;
      CMP.W #$0000                         ;84C98D;      ;
      BNE EventScriptBank84_Branch_84C995                      ;84C990;84C995;
      JMP.W EventScriptBank84_Branch_84C998                    ;84C992;84C998;
                                  ;      ;      ;
                                  ;      ;      ;
      EventScriptBank84_Branch_84C995: JMP.W PlayerInput_ProcessActionButtons                    ;84C995;84C740;
                                  ;      ;      ;
                                  ;      ;      ;
      EventScriptBank84_Branch_84C998: %Set16bit(!MX)                             ;84C998;      ;
      LDA.W #$0001                         ;84C99A;      ;
      STA.B !player_action                            ;84C99D;0000D4;
      %Set16bit(!MX)                             ;84C99F;      ;
      LDA.W #$0000                         ;84C9A1;      ;
      STA.B !player_direction                            ;84C9A4;0000DA;
      JMP.W PlayerInput_Return                    ;84C9A6;84C7B5;
                                  ;      ;      ;
                                  ;      ;      ;
      PlayerMove_StartLeft: %Set16bit(!MX)                             ;84C9A9;      ;
      LDA.W #$0001                         ;84C9AB;      ;
      STA.B !player_action                            ;84C9AE;0000D4;
      %Set16bit(!MX)                             ;84C9B0;      ;
      LDA.W #$0002                         ;84C9B2;      ;
      STA.B !player_direction                            ;84C9B5;0000DA;
      %Set16bit(!MX)                             ;84C9B7;      ;
      LDA.W #$0002                         ;84C9B9;      ;
      STA.W $0911                          ;84C9BC;000911;
      JMP.W PlayerInput_ProcessActionButtons                    ;84C9BF;84C740;
                                  ;      ;      ;
      %Set16bit(!MX)                             ;84C9C2;      ;
      LDA.W $0911                          ;84C9C4;000911;
      CMP.W #$0003                         ;84C9C7;      ;
      BNE EventScriptBank84_Branch_84C9CF                      ;84C9CA;84C9CF;
      JMP.W EventScriptBank84_Branch_84C9D2                    ;84C9CC;84C9D2;
                                  ;      ;      ;
                                  ;      ;      ;
      EventScriptBank84_Branch_84C9CF: JMP.W PlayerInput_ProcessActionButtons                    ;84C9CF;84C740;
                                  ;      ;      ;
                                  ;      ;      ;
      EventScriptBank84_Branch_84C9D2: %Set16bit(!MX)                             ;84C9D2;      ;
      LDA.W #$0001                         ;84C9D4;      ;
      STA.B !player_action                            ;84C9D7;0000D4;
      %Set16bit(!MX)                             ;84C9D9;      ;
      LDA.W #$0003                         ;84C9DB;      ;
      STA.B !player_direction                            ;84C9DE;0000DA;
      JMP.W PlayerInput_Return                    ;84C9E0;84C7B5;
                                  ;      ;      ;
                                  ;      ;      ;
      PlayerMove_StartRight: %Set16bit(!MX)                             ;84C9E3;      ;
      LDA.W #$0001                         ;84C9E5;      ;
      STA.B !player_action                            ;84C9E8;0000D4;
      %Set16bit(!MX)                             ;84C9EA;      ;
      LDA.W #$0003                         ;84C9EC;      ;
      STA.B !player_direction                            ;84C9EF;0000DA;
      %Set16bit(!MX)                             ;84C9F1;      ;
      LDA.W #$0003                         ;84C9F3;      ;
      STA.W $0911                          ;84C9F6;000911;
      JMP.W PlayerInput_ProcessActionButtons                    ;84C9F9;84C740;
                                  ;      ;      ;
      %Set16bit(!MX)                             ;84C9FC;      ;
      LDA.W $0911                          ;84C9FE;000911;
      CMP.W #$0002                         ;84CA01;      ;
      BNE EventScriptBank84_Branch_84CA09                      ;84CA04;84CA09;
      JMP.W EventScriptBank84_Branch_84CA0C                    ;84CA06;84CA0C;
                                  ;      ;      ;
                                  ;      ;      ;
      EventScriptBank84_Branch_84CA09: JMP.W PlayerInput_ProcessActionButtons                    ;84CA09;84C740;
                                  ;      ;      ;
                                  ;      ;      ;
      EventScriptBank84_Branch_84CA0C: %Set16bit(!MX)                             ;84CA0C;      ;
      LDA.W #$0001                         ;84CA0E;      ;
      STA.B !player_action                            ;84CA11;0000D4;
      %Set16bit(!MX)                             ;84CA13;      ;
      LDA.W #$0002                         ;84CA15;      ;
      STA.B !player_direction                            ;84CA18;0000DA;
      JMP.W PlayerInput_Return                    ;84CA1A;84C7B5;

;;;;;;
PlayerInput_B_RunOrJump:
      %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$0800                         ;Playing an animation
      BEQ +                      ;84CA24;84CA29;
      JMP.W .running                    ;84CA26;84CA9D;

    + LDA.W #$0000                         ;84CA29;      ;
      LDX.W #$0007                         ;84CA2C;      ;
      LDY.W #$0007                         ;84CA2F;      ;
      JSL.L PlayerTarget_CalculateTileInFront                    ;84CA32;81D14E;
      %Set16bit(!MX)                             ;84CA36;      ;
      LDX.W !tile_in_front_X                          ;84CA38;000985;
      LDY.W !tile_in_front_Y                          ;84CA3B;000987;
      LDA.W #$0002                         ;84CA3E;      ;
      JSL.L TileProperty_CheckToolUseAllowed                          ;84CA41;82AC61;
      %Set8bit(!M)                             ;84CA45;      ;
      AND.B #$60                           ;84CA47;      ;
      BEQ .running                      ;84CA49;84CA9D;
      AND.B #$20                           ;84CA4B;      ;
      BNE ++                      ;84CA4D;84CA5F;
      %Set16bit(!MX)                             ;84CA4F;      ;
      LDA.B !game_state                            ;84CA51;0000D2;
      ORA.W #$0200                         ;84CA53;      ;
      STA.B !game_state                            ;84CA56;0000D2;
      %Set16bit(!M)                             ;84CA58;      ;
      LDA.W #$0021                         ;84CA5A;      ;
      BRA +                      ;84CA5D;84CA66;
                                          ;      ;      ;
                                          ;      ;      ;
   ++ %Set16bit(!M)                             ;84CA5F;      ;
      LDA.W #$001C                         ;84CA61;      ;
      BRA +                      ;84CA64;84CA66;
                                          ;      ;      ;
                                          ;      ;      ;
    + %Set16bit(!MX)                             ;84CA66;      ;
      STA.B $E3                            ;84CA68;0000E3;
      LDA.B !player_pos_X                           ;84CA6A;0000D6;
      STA.B $DF                            ;84CA6C;0000DF;
      LDA.B !player_pos_Y                            ;84CA6E;0000D8;
      STA.B $E1                            ;84CA70;0000E1;
      STZ.B $E5                            ;84CA72;0000E5;
      STZ.B $E7                            ;84CA74;0000E7;
      LDA.B !player_direction                            ;84CA76;0000DA;
      JSL.L Collision_CheckObjectOverlapAtDirection                          ;84CA78;83AF37;
      %Set16bit(!MX)                             ;84CA7C;      ;
      BNE .running                      ;84CA7E;84CA9D;
      %Set16bit(!M)                             ;84CA80;      ;
      LDA.W #$0020                         ;84CA82;      ;
      STA.B $E3                            ;84CA85;0000E3;
      LDA.B !player_direction                            ;84CA87;0000DA;
      JSL.L Collision_CheckMapTileAtDirection                          ;84CA89;83AD91;
      %Set16bit(!MX)                             ;84CA8D;      ;
      CMP.W #$0000                         ;84CA8F;      ;
      BNE .running                      ;84CA92;84CA9D;
      %Set16bit(!MX)                             ;84CA94;      ;
      LDA.W #$0003                         ;84CA96;      ;
      STA.B !player_action                            ;84CA99;0000D4;
      BRA .return                      ;84CA9B;84CAA4;

  .running:
      %Set16bit(!MX)
      LDA.W #$0002                           ;Running
      STA.B !player_action

  .return: RTL                                  ;84CAA4;      ;

;;;;;;
PlayerInput_A_InteractOrDrop:
      %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$0800                           ;Playing an animation
      BEQ +
      JMP.W PlayerInput_A_PickupDogOrGroundObject

    + LDA.B !game_state
      AND.W #$0010                           ;Carring item or dog
      BEQ +
      JMP.W PlayerInput_A_TryThrowHeldObjectByDirection                      ;TODO

    + LDA.L $7F1F60
      AND.W #$0006                           ;TODO
      BEQ +
      JMP.W PlayerInput_A_SpecialInteractOnGround                      ;TODO

    + %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$0002                           ;TODO
      BEQ +
      JMP.W PlayerInput_A_DropHeldItemAction                      ;TODO

    + %Set16bit(!M)
      LDA.W #$0000
      LDX.W #$0007
      LDY.W #$0007
      JSL.L PlayerTarget_CalculateTileInFront
      %Set16bit(!MX)
      LDX.W !tile_in_front_X
      LDY.W !tile_in_front_Y
      LDA.W #$0002
      JSL.L TileProperty_CheckToolUseAllowed
      JSL.L PlayerInteraction_DispatchFacingTileAction

      RTL

;;;;;;
  PlayerInput_A_DropHeldItemAction: ;84CAF6
      %Set16bit(!MX)
      LDA.W #$0005                           ;Drop Item
      STA.B !player_action
      RTL

  PlayerInput_A_SpecialInteractOnGround: ;84CAFE
      %Set16bit(!MX)                             ;      ;
      LDA.W #$0000                         ;84CB00;      ;
      LDX.W #$0007                         ;84CB03;      ;
      LDY.W #$0007                         ;84CB06;      ;
      JSL.L PlayerTarget_CalculateTileInFront                    ;84CB09;81D14E;
      %Set16bit(!MX)                             ;84CB0D;      ;
      LDX.W !tile_in_front_X                          ;84CB0F;000985;
      LDY.W !tile_in_front_Y                          ;84CB12;000987;
      LDA.W #$0000                         ;84CB15;      ;
      JSL.L TileProperty_CheckToolUseAllowed                          ;84CB18;82AC61;
      %Set16bit(!MX)                             ;84CB1C;      ;
      CPX.W #$00F5                         ;84CB1E;      ;
      BNE .return                      ;84CB21;84CB2A;
      %Set16bit(!MX)                             ;84CB23;      ;
      LDA.W #$001A                         ;84CB25;      ;
      STA.B !player_action                            ;84CB28;0000D4;
                                        ;      ;      ;
  .return: RTL                                  ;84CB2A;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          PlayerInput_A_PickupDogOrGroundObject: %Set16bit(!MX)                             ;84CB2B;      ;
                       LDA.B !player_pos_X                           ;84CB2D;0000D6;
                       STA.B $DF                            ;84CB2F;0000DF;
                       LDA.B !player_pos_Y                            ;84CB31;0000D8;
                       STA.B $E1                            ;84CB33;0000E1;
                       STZ.B $E5                            ;84CB35;0000E5;
                       STZ.B $E7                            ;84CB37;0000E7;
                       LDA.W #$0010                         ;84CB39;      ;
                       STA.B $E3                            ;84CB3C;0000E3;
                       LDA.B !player_direction                            ;84CB3E;0000DA;
                       JSL.L Collision_CheckMapTileAtDirection                          ;84CB40;83AD91;
                       %Set16bit(!MX)                             ;84CB44;      ;
                       CMP.W #$0000                         ;84CB46;      ;
                       BEQ EventScriptBank84_Branch_84CB4E                      ;84CB49;84CB4E;
                       JMP.W EventScriptBank84_Branch_84CC1B                    ;84CB4B;84CC1B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CB4E: %Set16bit(!M)                             ;84CB4E;      ;
                       LDA.W #$0000                         ;84CB50;      ;
                       LDX.W #$0007                         ;84CB53;      ;
                       LDY.W #$0007                         ;84CB56;      ;
                       JSL.L PlayerTarget_CalculateTileInFront                    ;84CB59;81D14E;
                       %Set16bit(!M)                             ;84CB5D;      ;
                       LDA.W #$0002                         ;84CB5F;      ;
                       LDX.W !tile_in_front_X                          ;84CB62;000985;
                       LDY.W !tile_in_front_Y                          ;84CB65;000987;
                       JSL.L TileProperty_CheckToolUseAllowed                          ;84CB68;82AC61;
                       %Set8bit(!M)                             ;84CB6C;      ;
                       AND.B #$1F                           ;84CB6E;      ;
                       BEQ EventScriptBank84_Branch_84CB75                      ;84CB70;84CB75;
                       JMP.W EventScriptBank84_Branch_84CC1B                    ;84CB72;84CC1B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CB75: CPX.W #$00FF                         ;84CB75;      ;
                       BNE EventScriptBank84_Branch_84CB7D                      ;84CB78;84CB7D;
                       JMP.W EventScriptBank84_Branch_84CC1B                    ;84CB7A;84CC1B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CB7D: %Set16bit(!M)                             ;84CB7D;      ;
                       LDA.W #$0001                         ;84CB7F;      ;
                       LDX.W #$000A                         ;84CB82;      ;
                       LDY.W #$000A                         ;84CB85;      ;
                       JSL.L PlayerTarget_CalculateTileInFront                    ;84CB88;81D14E;
                       %Set16bit(!M)                             ;84CB8C;      ;
                       LDA.W #$0002                         ;84CB8E;      ;
                       LDX.W !tile_in_front_X                          ;84CB91;000985;
                       LDY.W !tile_in_front_Y                          ;84CB94;000987;
                       JSL.L TileProperty_CheckToolUseAllowed                          ;84CB97;82AC61;
                       %Set8bit(!M)                             ;84CB9B;      ;
                       AND.B #$1F                           ;84CB9D;      ;
                       BEQ EventScriptBank84_Branch_84CBA4                      ;84CB9F;84CBA4;
                       JMP.W EventScriptBank84_Branch_84CC1B                    ;84CBA1;84CC1B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CBA4: CPX.W #$00FF                         ;84CBA4;      ;
                       BNE EventScriptBank84_Branch_84CBAC                      ;84CBA7;84CBAC;
                       JMP.W EventScriptBank84_Branch_84CC1B                    ;84CBA9;84CC1B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CBAC: %Set16bit(!M)                             ;84CBAC;      ;
                       LDA.W #$0001                         ;84CBAE;      ;
                       LDX.W #$0000                         ;84CBB1;      ;
                       LDY.W #$0000                         ;84CBB4;      ;
                       JSL.L PlayerTarget_CalculateTileInFront                    ;84CBB7;81D14E;
                       %Set16bit(!M)                             ;84CBBB;      ;
                       LDA.W #$0002                         ;84CBBD;      ;
                       LDX.W !tile_in_front_X                          ;84CBC0;000985;
                       LDY.W !tile_in_front_Y                          ;84CBC3;000987;
                       JSL.L TileProperty_CheckToolUseAllowed                          ;84CBC6;82AC61;
                       %Set8bit(!M)                             ;84CBCA;      ;
                       AND.B #$1F                           ;84CBCC;      ;
                       BEQ EventScriptBank84_Branch_84CBD3                      ;84CBCE;84CBD3;
                       JMP.W EventScriptBank84_Branch_84CC1B                    ;84CBD0;84CC1B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CBD3: CPX.W #$00E1                         ;84CBD3;      ;
                       BNE EventScriptBank84_Branch_84CBDB                      ;84CBD6;84CBDB;
                       JMP.W EventScriptBank84_Branch_84CC1B                    ;84CBD8;84CC1B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CBDB: CPX.W #$00FF                         ;84CBDB;      ;
                       BNE EventScriptBank84_Branch_84CBE3                      ;84CBDE;84CBE3;
                       JMP.W EventScriptBank84_Branch_84CC1B                    ;84CBE0;84CC1B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CBE3: CPX.W #$00C0                         ;84CBE3;      ;
                       BCC EventScriptBank84_Branch_84CBEF                      ;84CBE6;84CBEF;
                       CPX.W #$00D0                         ;84CBE8;      ;
                       BCS EventScriptBank84_Branch_84CBEF                      ;84CBEB;84CBEF;
                       BRA EventScriptBank84_Branch_84CC1B                      ;84CBED;84CC1B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CBEF: %Set16bit(!MX)                             ;84CBEF;      ;
                       LDA.W !tile_in_front_X                          ;84CBF1;000985;
                       STA.L !dog_pos_X                        ;84CBF4;7F1F2C;
                       LDA.W !tile_in_front_Y                          ;84CBF8;000987;
                       STA.L !dog_pos_Y                        ;84CBFB;7F1F2E;
                       %Set8bit(!M)                             ;84CBFF;      ;
                       LDA.B !tilemap_to_load                            ;84CC01;000022;
                       STA.L !dog_map                        ;84CC03;7F1F30;
                       %Set16bit(!MX)                             ;84CC07;      ;
                       LDA.W #$0016                         ;84CC09;      ;
                       STA.B !player_action                            ;84CC0C;0000D4;
                       %Set16bit(!MX)                             ;84CC0E;      ;
                       LDA.W #$0800                         ;84CC10;      ;
                       EOR.W #$FFFF                         ;84CC13;      ;
                       AND.B !game_state                            ;84CC16;0000D2;
                       STA.B !game_state                            ;84CC18;0000D2;
                       RTL                                  ;84CC1A;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CC1B: RTL                                  ;84CC1B;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          PlayerInput_A_TryThrowHeldObjectByDirection: %Set16bit(!MX)                             ;84CC1C;      ;
                       LDA.B !player_direction                            ;84CC1E;0000DA;
                       CMP.W #$0000                         ;84CC20;      ;
                       BNE EventScriptBank84_Branch_84CC28                      ;84CC23;84CC28;
                       JMP.W EventScriptBank84_Branch_84CC40                    ;84CC25;84CC40;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CC28: CMP.W #$0001                         ;84CC28;      ;
                       BNE EventScriptBank84_Branch_84CC30                      ;84CC2B;84CC30;
                       JMP.W EventScriptBank84_Branch_84CC6F                    ;84CC2D;84CC6F;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CC30: CMP.W #$0002                         ;84CC30;      ;
                       BNE EventScriptBank84_Branch_84CC38                      ;84CC33;84CC38;
                       JMP.W EventScriptBank84_Branch_84CC98                    ;84CC35;84CC98;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CC38: CMP.W #$0003                         ;84CC38;      ;
                       BNE EventScriptBank84_Branch_84CC40                      ;84CC3B;84CC40;
                       JMP.W EventScriptBank84_Branch_84CCC0                    ;84CC3D;84CCC0;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CC40: %Set16bit(!MX)                             ;84CC40;      ;
                       LDA.W #$0002                         ;84CC42;      ;
                       STA.W $0911                          ;84CC45;000911;
                       JSL.L PlayerCollision_CheckAheadForObjectOrBlockedTile                    ;84CC48;84CD16;
                       %Set16bit(!MX)                             ;84CC4C;      ;
                       BNE EventScriptBank84_Branch_84CC53                      ;84CC4E;84CC53;
                       JMP.W PlayerCollision_StartBlockedCarryObjectReaction                    ;84CC50;84CCE8;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CC53: LDA.W #$0003                         ;84CC53;      ;
                       STA.W $0911                          ;84CC56;000911;
                       JSL.L PlayerCollision_CheckAheadForObjectOrBlockedTile                    ;84CC59;84CD16;
                       %Set16bit(!MX)                             ;84CC5D;      ;
                       BNE EventScriptBank84_Branch_84CC64                      ;84CC5F;84CC64;
                       JMP.W PlayerCollision_StartBlockedCarryObjectReaction                    ;84CC61;84CCE8;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CC64: LDA.W #$0000                         ;84CC64;      ;
                       STA.B !player_direction                            ;84CC67;0000DA;
                       STA.W $0911                          ;84CC69;000911;
                       JMP.W PlayerCollision_ReturnFromCarryCheck                    ;84CC6C;84CD15;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CC6F: %Set16bit(!MX)                             ;84CC6F;      ;
                       LDA.W #$0003                         ;84CC71;      ;
                       STA.W $0911                          ;84CC74;000911;
                       JSL.L PlayerCollision_CheckAheadForObjectOrBlockedTile                    ;84CC77;84CD16;
                       %Set16bit(!MX)                             ;84CC7B;      ;
                       BEQ PlayerCollision_StartBlockedCarryObjectReaction                      ;84CC7D;84CCE8;
                       LDA.W #$0002                         ;84CC7F;      ;
                       STA.W $0911                          ;84CC82;000911;
                       JSL.L PlayerCollision_CheckAheadForObjectOrBlockedTile                    ;84CC85;84CD16;
                       %Set16bit(!MX)                             ;84CC89;      ;
                       BEQ PlayerCollision_StartBlockedCarryObjectReaction                      ;84CC8B;84CCE8;
                       LDA.W #$0001                         ;84CC8D;      ;
                       STA.B !player_direction                            ;84CC90;0000DA;
                       STA.W $0911                          ;84CC92;000911;
                       JMP.W PlayerCollision_ReturnFromCarryCheck                    ;84CC95;84CD15;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CC98: %Set16bit(!MX)                             ;84CC98;      ;
                       LDA.W #$0000                         ;84CC9A;      ;
                       STA.W $0911                          ;84CC9D;000911;
                       JSL.L PlayerCollision_CheckAheadForObjectOrBlockedTile                    ;84CCA0;84CD16;
                       %Set16bit(!MX)                             ;84CCA4;      ;
                       BEQ PlayerCollision_StartBlockedCarryObjectReaction                      ;84CCA6;84CCE8;
                       LDA.W #$0001                         ;84CCA8;      ;
                       STA.W $0911                          ;84CCAB;000911;
                       JSL.L PlayerCollision_CheckAheadForObjectOrBlockedTile                    ;84CCAE;84CD16;
                       %Set16bit(!MX)                             ;84CCB2;      ;
                       BEQ PlayerCollision_StartBlockedCarryObjectReaction                      ;84CCB4;84CCE8;
                       LDA.W #$0002                         ;84CCB6;      ;
                       STA.B !player_direction                            ;84CCB9;0000DA;
                       STA.W $0911                          ;84CCBB;000911;
                       BRA PlayerCollision_ReturnFromCarryCheck                      ;84CCBE;84CD15;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CCC0: %Set16bit(!MX)                             ;84CCC0;      ;
                       LDA.W #$0000                         ;84CCC2;      ;
                       STA.W $0911                          ;84CCC5;000911;
                       JSL.L PlayerCollision_CheckAheadForObjectOrBlockedTile                    ;84CCC8;84CD16;
                       %Set16bit(!MX)                             ;84CCCC;      ;
                       BEQ PlayerCollision_StartBlockedCarryObjectReaction                      ;84CCCE;84CCE8;
                       LDA.W #$0001                         ;84CCD0;      ;
                       STA.W $0911                          ;84CCD3;000911;
                       JSL.L PlayerCollision_CheckAheadForObjectOrBlockedTile                    ;84CCD6;84CD16;
                       %Set16bit(!MX)                             ;84CCDA;      ;
                       BEQ PlayerCollision_StartBlockedCarryObjectReaction                      ;84CCDC;84CCE8;
                       LDA.W #$0003                         ;84CCDE;      ;
                       STA.B !player_direction                            ;84CCE1;0000DA;
                       STA.W $0911                          ;84CCE3;000911;
                       BRA PlayerCollision_ReturnFromCarryCheck                      ;84CCE6;84CD15;
                                                            ;      ;      ;
                                                            ;      ;      ;
          PlayerCollision_StartBlockedCarryObjectReaction: %Set16bit(!MX)                             ;84CCE8;      ;
                       LDA.W #$0018                         ;84CCEA;      ;
                       STA.B !player_action                            ;84CCED;0000D4;
                       %Set16bit(!MX)                             ;84CCEF;      ;
                       LDA.B !player_pos_X                           ;84CCF1;0000D6;
                       STA.W !tile_in_front_X                          ;84CCF3;000985;
                       LDA.B !player_pos_Y                            ;84CCF6;0000D8;
                       STA.W !tile_in_front_Y                          ;84CCF8;000987;
                       LDA.W #$0017                         ;84CCFB;      ;
                       LDX.W #$0000                         ;84CCFE;      ;
                       LDY.W #$0014                         ;84CD01;      ;
                       JSL.L EventScript_LoadScriptPointerForFacingTile                    ;84CD04;8480F8;
                       %Set16bit(!M)                             ;84CD08;      ;
                       STZ.W $0878                          ;84CD0A;000878;
                       STZ.W $087A                          ;84CD0D;00087A;
                       %Set8bit(!M)                             ;84CD10;      ;
                       STZ.W $0939                          ;84CD12;000939;
                                                            ;      ;      ;
          PlayerCollision_ReturnFromCarryCheck: RTL                                  ;84CD15;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          ; PASS27_PLAYER_MOVEMENT_COLLISION_CORE:
; Checks whether the carried/held-object throw direction is free.
; Return A=0 when the path is usable, A=1 when blocked by object/tile bounds.
PlayerCollision_CheckAheadForObjectOrBlockedTile: %Set16bit(!MX)                             ;84CD16;      ;
                       LDA.W #$0010                         ;84CD18;      ;
                       STA.B $E3                            ;84CD1B;0000E3;
                       LDA.B !player_pos_X                           ;84CD1D;0000D6;
                       STA.B $DF                            ;84CD1F;0000DF;
                       LDA.B !player_pos_Y                            ;84CD21;0000D8;
                       STA.B $E1                            ;84CD23;0000E1;
                       STZ.B $E5                            ;84CD25;0000E5;
                       STZ.B $E7                            ;84CD27;0000E7;
                       LDA.W $0911                          ;84CD29;000911;
                       JSL.L Collision_CheckObjectOverlapAtDirection                          ;84CD2C;83AF37;
                       %Set16bit(!MX)                             ;84CD30;      ;
                       BEQ EventScriptBank84_Branch_84CD37                      ;84CD32;84CD37;
                       JMP.W EventScriptBank84_Branch_84CD71                    ;84CD34;84CD71;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CD37: LDA.B $E9                            ;84CD37;0000E9;
                       SEC                                  ;84CD39;      ;
                       SBC.W #$00C0                         ;84CD3A;      ;
                       CMP.W #$0010                         ;84CD3D;      ;
                       BCS EventScriptBank84_Branch_84CD45                      ;84CD40;84CD45;
                       JMP.W EventScriptBank84_Branch_84CD71                    ;84CD42;84CD71;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CD45: LDA.B $EB                            ;84CD45;0000EB;
                       SEC                                  ;84CD47;      ;
                       SBC.W #$00C0                         ;84CD48;      ;
                       CMP.W #$0010                         ;84CD4B;      ;
                       BCS EventScriptBank84_Branch_84CD53                      ;84CD4E;84CD53;
                       JMP.W EventScriptBank84_Branch_84CD71                    ;84CD50;84CD71;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CD53: %Set16bit(!M)                             ;84CD53;      ;
                       LDA.W #$0010                         ;84CD55;      ;
                       STA.B $E3                            ;84CD58;0000E3;
                       LDA.W $0911                          ;84CD5A;000911;
                       JSL.L Collision_CheckMapTileAtDirection                          ;84CD5D;83AD91;
                       %Set16bit(!MX)                             ;84CD61;      ;
                       CMP.W #$0000                         ;84CD63;      ;
                       BEQ EventScriptBank84_Branch_84CD6B                      ;84CD66;84CD6B;
                       JMP.W EventScriptBank84_Branch_84CD71                    ;84CD68;84CD71;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CD6B: %Set16bit(!MX)                             ;84CD6B;      ;
                       LDA.W #$0000                         ;84CD6D;      ;
                       RTL                                  ;84CD70;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CD71: %Set16bit(!MX)                             ;84CD71;      ;
                       LDA.W #$0001                         ;84CD73;      ;
                       RTL                                  ;84CD76;      ;


PlayerInput_Y_ToolOrFishing: ;84CD77
      %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$0002                           ;Not holding Items
      BEQ +
      JMP.W .return

    + %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$0010                           ;FLAGD2
      BEQ +
      JMP.W .return

    + %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$0800                           ;FLAGD2
      BEQ +
      JMP.W .return

    + %Set16bit(!MX)
      LDA.B !player_action
      CMP.W #$000F                           ;about to cast
      BNE +
      JMP.W FishingInput_CastLine

    + %Set16bit(!MX)
      LDA.B !player_action
      CMP.W #$0011                           ;Fishing
      BNE +
      JMP.W FishingInput_ReelEmptyLine

    + %Set16bit(!MX)
      LDA.B !player_action
      CMP.W #$0012
      BNE +
      JMP.W FishingInput_ReelCatch

    + %Set16bit(!M)
      LDA.L $7F1F60
      AND.W #$8000                           ;TODO
      BNE .return

      %Set8bit(!M)
      LDA.W !tool_selected
      BEQ .return

      %Set16bit(!MX)
      LDA.W #$000A                           ;Using Tool
      STA.B !player_action
      JSL.L ToolAction_StartAnimationOrNoStamina

  .return: RTL

FishingInput_CastLine:
      %Set16bit(!MX)
      LDA.W #$0010                           ;casting
      STA.B !player_action
      RTL

FishingInput_ReelEmptyLine:
      %Set16bit(!MX)
      LDA.W #$000F                           ;about to cast
      STA.B !player_action
      RTL

FishingInput_ReelCatch: ;84CDED
      %Set16bit(!MX)
      LDA.W #$0013                           ;Reeling
      STA.B !player_action
      %Set8bit(!M)
      LDA.B #$03
      JSL.L RNG_GetRange0ToAExclusiveStyle                    ;get a number 0-1
      %Set8bit(!M)
      XBA
      LDA.B #$00
      XBA
      %Set16bit(!M)
      CLC
      ADC.W #$008B
      STA.W $0901
      RTL

;;;;;;
PlayerInput_R_WhistleHorse: ;84CE0C
      %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$0002                           ;Not holding Items
      BEQ +
      JMP.W .return

    + %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$0010                           ;TODO
      BEQ +
      JMP.W .return

    + %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$0800                           ;TODO
      BEQ +
      JMP.W .return

    + %Set16bit(!MX)
      LDA.L $7F1F68
      AND.W #$0100                           ;Horse Owned
      BEQ .return

      %Set16bit(!MX)
      LDA.W #$000D                           ;Horse Whistled
      STA.B !player_action

  .return: RTL

;;;;;;
PlayerInput_L_WhistleDog: ;84CE43
      %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$0002                           ;Not holding Items
      BEQ +
      JMP.W .return

    + %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$0010                           ;TODO
      BEQ +
      JMP.W .return

    + %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$0800                           ;TODO
      BEQ +
      JMP.W .return

    + %Set16bit(!MX)
      LDA.L $7F1F68
      AND.W #$0080                           ;Dog owned
      BEQ .return

      %Set16bit(!MX)
      LDA.W #$001B                           ;Dog Whistled
      STA.B !player_action

  .return: RTL

;;;;;;
PlayerInput_Select_Action0C:
      %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$0002                           ;Not holding Items
      BEQ +
      JMP.W .return

    + %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$0010                           ;TODO
      BEQ +
      JMP.W .return

    + %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$0800                           ;TODO
      BEQ +
      JMP.W .return

    + %Set16bit(!MX)
      LDA.W #$000C
      STA.B !player_action

      .return: RTL

;;;;;;
PlayerInput_X_Action1C:
      %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$0002
      BEQ .notholdingitem
      JMP.W .return

  .notholdingitem:
      %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$0010                           ;TODO
      BEQ +
      JMP.W .return

    + %Set16bit(!MX)
      LDA.B !game_state
      AND.W #$0800                           ;TODO
      BEQ +
      JMP.W .return

    + %Set16bit(!MX)
      LDA.W #$001C
      STA.B !player_action

  .return: RTL


          EventScriptBank84_Branch_84CED2: %Set8bit(!M)                             ;84CED2;      ;
                       %Set16bit(!X)                             ;84CED4;      ;
                       LDA.W $019B                          ;84CED6;00019B;
                       AND.B #$04                           ;84CED9;      ;
                       BEQ EventScriptBank84_Branch_84CF04                      ;84CEDB;84CF04;
                       %Set16bit(!MX)                             ;84CEDD;      ;
                       LDA.W $09B1                          ;84CEDF;0009B1;
                       INC A                                ;84CEE2;      ;
                       STA.W $09B1                          ;84CEE3;0009B1;
                       CMP.W #$0078                         ;84CEE6;      ;
                       BNE EventScriptBank84_Branch_84CF04                      ;84CEE9;84CF04;
                       STZ.W $09B1                          ;84CEEB;0009B1;
                       JSL.L TextBox_CloseAndRestoreScrollAndTime                    ;84CEEE;8393F9;
                       %Set8bit(!M)                             ;84CEF2;      ;
                       LDA.B #$01                           ;84CEF4;      ;
                       STA.W !inputstate                          ;84CEF6;00019A;
                       %Set16bit(!M)                             ;84CEF9;      ;
                       LDA.W !Joy1_New_Input                          ;84CEFB;000128;
                       AND.W #$FF7F                         ;84CEFE;      ;
                       STA.W !Joy1_New_Input                          ;84CF01;000128;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CF04: RTL                                  ;84CF04;      ;

;;;;;;;;

;;;;;;;; PASS37_PROMPT_CURSOR_GRID_UI_CORE_100:
;;;;;;;; Handles modal prompt input after textbox/dialog systems have taken over
;;;;;;;; control. The low bits in $019B choose modes such as confirm-only, close
;;;;;;;; text, page advance/restore font, or grid cursor selection. Grid cursor
;;;;;;;; state lives mainly in $018E/$018F, queues cursor glyph DMA through
;;;;;;;; TextBox_QueueGlyphDMA, plays cursor/confirm SFX, and returns to normal
;;;;;;;; field input when the prompt closes.
PromptCursorInput_DispatchModalAndGridModes:
        %Set8bit(!M)                             ;84CF05;      ;
        %Set16bit(!X)                             ;84CF07;      ;
        LDA.W $019B                          ;84CF09;00019B;
        AND.B #$02                           ;84CF0C;      ;
        BNE PromptCursorInput_WaitForConfirmOnly                      ;84CF0E;84CF2D;
        LDA.W $019B                          ;84CF10;00019B;
        AND.B #$04                           ;84CF13;      ;
        BNE PromptCursorInput_CloseTextAndReturnToField                      ;84CF15;84CF40;
        LDA.W $019B                          ;84CF17;00019B;
        AND.B #$08                           ;84CF1A;      ;
        BNE PromptCursorInput_AdvancePageAndRestoreFont                      ;84CF1C;84CF62;
        LDA.W $019B                          ;84CF1E;00019B;
        AND.B #$10                           ;84CF21;      ;
        BNE PromptGridInput_DispatchDirectionalAndConfirm                      ;84CF23;84CF95;
        LDA.W $019B                          ;84CF25;00019B;
        AND.B #$20                           ;84CF28;      ;
        BNE PromptCursorInput_CloseTextAndReturnToField                      ;84CF2A;84CF40;
        RTL                                  ;84CF2C;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          PromptCursorInput_WaitForConfirmOnly: %Set16bit(!MX)                             ;84CF2D;      ;
                       LDA.W !Joy1_Current                          ;84CF2F;000124;
                       BIT.W #$0080                         ;84CF32;      ;
                       BNE EventScriptBank84_Branch_84CF38                      ;84CF35;84CF38;
                       RTL                                  ;84CF37;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CF38: %Set8bit(!M)                             ;84CF38;      ;
                       LDA.B #$04                           ;84CF3A;      ;
                       STA.W $0189                          ;84CF3C;000189;
                       RTL                                  ;84CF3F;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          PromptCursorInput_CloseTextAndReturnToField: %Set16bit(!MX)                             ;84CF40;      ;
                       LDA.W !Joy1_New_Input                          ;84CF42;000128;
                       BIT.W #$0080                         ;84CF45;      ;
                       BNE EventScriptBank84_Branch_84CF4B                      ;84CF48;84CF4B;
                       RTL                                  ;84CF4A;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CF4B: JSL.L TextBox_CloseAndRestoreScrollAndTime                    ;84CF4B;8393F9;
                       %Set8bit(!M)                             ;84CF4F;      ;
                       LDA.B #$01                           ;84CF51;      ;
                       STA.W !inputstate                          ;84CF53;00019A;
                       %Set16bit(!M)                             ;84CF56;      ;
                       LDA.W !Joy1_New_Input                          ;84CF58;000128;
                       AND.W #$FF7F                         ;84CF5B;      ;
                       STA.W !Joy1_New_Input                          ;84CF5E;000128;
                       RTL                                  ;84CF61;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          PromptCursorInput_AdvancePageAndRestoreFont: %Set16bit(!MX)                             ;84CF62;      ;
                       LDA.W !Joy1_New_Input                          ;84CF64;000128;
                       BIT.W #$0080                         ;84CF67;      ;
                       BNE EventScriptBank84_Branch_84CF6D                      ;84CF6A;84CF6D;
                       RTL                                  ;84CF6C;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CF6D: JSL.L TextBox_RestoreDialogueFontDMAAfterClose                    ;84CF6D;83932D;
                       %Set16bit(!M)                             ;84CF71;      ;
                       LDA.W $0187                          ;84CF73;000187;
                       INC A                                ;84CF76;      ;
                       STA.W $0187                          ;84CF77;000187;
                       LDA.W #$5000                         ;84CF7A;      ;
                       CLC                                  ;84CF7D;      ;
                       ADC.W #$0010                         ;84CF7E;      ;
                       STA.W $0185                          ;84CF81;000185;
                       %Set8bit(!M)                             ;84CF84;      ;
                       STZ.W $018B                          ;84CF86;00018B;
                       LDA.W $019B                          ;84CF89;00019B;
                       AND.B #!OBJ_Offset_Y                          ;84CF8C;      ;
                       STA.W $019B                          ;84CF8E;00019B;
                       STZ.W $0189                          ;84CF91;000189;
                       RTL                                  ;84CF94;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          PromptGridInput_DispatchDirectionalAndConfirm: %Set16bit(!MX)                             ;84CF95;      ;
                       LDA.W !Joy1_New_Input                          ;84CF97;000128;
                       BIT.W #$0400                         ;84CF9A;      ;
                       BNE PromptGridInput_MoveDown                      ;84CF9D;84CFEA;
                       LDA.W !Joy1_New_Input                          ;84CF9F;000128;
                       BIT.W #$0800                         ;84CFA2;      ;
                       BEQ EventScriptBank84_Branch_84CFAA                      ;84CFA5;84CFAA;
                       JMP.W PromptGridInput_MoveUp                    ;84CFA7;84D03A;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CFAA: LDA.W !Joy1_New_Input                          ;84CFAA;000128;
                       BIT.W #$0100                         ;84CFAD;      ;
                       BEQ EventScriptBank84_Branch_84CFB5                      ;84CFB0;84CFB5;
                       JMP.W PromptGridInput_MoveRight                    ;84CFB2;84D08E;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CFB5: LDA.W !Joy1_New_Input                          ;84CFB5;000128;
                       BIT.W #$0200                         ;84CFB8;      ;
                       BEQ EventScriptBank84_Branch_84CFC0                      ;84CFBB;84CFC0;
                       JMP.W PromptGridInput_MoveLeft                    ;84CFBD;84D0F4;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CFC0: LDA.W !Joy1_New_Input                          ;84CFC0;000128;
                       BIT.W #$0080                         ;84CFC3;      ;
                       BEQ EventScriptBank84_Branch_84CFCB                      ;84CFC6;84CFCB;
                       JMP.W PromptGridInput_ConfirmAndClose                    ;84CFC8;84CFCC;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84CFCB: RTL                                  ;84CFCB;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          PromptGridInput_ConfirmAndClose: %Set8bit(!M)                             ;84CFCC;      ;
                       %Set16bit(!X)                             ;84CFCE;      ;
                       LDA.B #$01                           ;84CFD0;      ;
                       STA.W $0114                          ;84CFD2;000114;
                       LDA.B #$06                           ;84CFD5;      ;
                       STA.W $0115                          ;84CFD7;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84CFDA;838332;
                       JSL.L TextBox_CloseAndRestoreScrollAndTime                    ;84CFDE;8393F9;
                       %Set8bit(!M)                             ;84CFE2;      ;
                       LDA.B #$01                           ;84CFE4;      ;
                       STA.W !inputstate                          ;84CFE6;00019A;
                       RTL                                  ;84CFE9;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          PromptGridInput_MoveDown: %Set8bit(!M)                             ;84CFEA;      ;
                       %Set16bit(!X)                             ;84CFEC;      ;
                       LDA.B #$03                           ;84CFEE;      ;
                       STA.W $0114                          ;84CFF0;000114;
                       LDA.B #$06                           ;84CFF3;      ;
                       STA.W $0115                          ;84CFF5;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84CFF8;838332;
                       %Set16bit(!MX)                             ;84CFFC;      ;
                       LDX.W #$0001                         ;84CFFE;      ;
                       LDA.W #$00B1                         ;84D001;      ;
                       JSL.L TextBox_QueueGlyphDMA                    ;84D004;839823;
                       %Set8bit(!M)                             ;84D008;      ;
                       LDA.W $018F                          ;84D00A;00018F;
                       CMP.B #$03                           ;84D00D;      ;
                       BCC EventScriptBank84_Branch_84D01C                      ;84D00F;84D01C;
                       CMP.W $018E                          ;84D011;00018E;
                       BEQ EventScriptBank84_Branch_84D030                      ;84D014;84D030;
                       INC A                                ;84D016;      ;
                       STA.W $018F                          ;84D017;00018F;
                       BRA PromptGridInput_ClearRepeatLatchReturn_A                      ;84D01A;84D036;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84D01C: CMP.W $018E                          ;84D01C;00018E;
                       BEQ EventScriptBank84_Branch_84D02B                      ;84D01F;84D02B;
                       CMP.B #$02                           ;84D021;      ;
                       BEQ EventScriptBank84_Branch_84D02B                      ;84D023;84D02B;
                       INC A                                ;84D025;      ;
                       STA.W $018F                          ;84D026;00018F;
                       BRA PromptGridInput_ClearRepeatLatchReturn_A                      ;84D029;84D036;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84D02B: STZ.W $018F                          ;84D02B;00018F;
                       BRA PromptGridInput_ClearRepeatLatchReturn_A                      ;84D02E;84D036;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84D030: DEC A                                ;84D030;      ;
                       STA.W $018F                          ;84D031;00018F;
                       BRA PromptGridInput_ClearRepeatLatchReturn_A                      ;84D034;84D036;
                                                            ;      ;      ;
                                                            ;      ;      ;
          PromptGridInput_ClearRepeatLatchReturn_A: STZ.W $018B                          ;84D036;00018B;
                       RTL                                  ;84D039;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          PromptGridInput_MoveUp: %Set8bit(!M)                             ;84D03A;      ;
                       %Set16bit(!X)                             ;84D03C;      ;
                       LDA.B #$03                           ;84D03E;      ;
                       STA.W $0114                          ;84D040;000114;
                       LDA.B #$06                           ;84D043;      ;
                       STA.W $0115                          ;84D045;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84D048;838332;
                       %Set16bit(!MX)                             ;84D04C;      ;
                       LDX.W #$0001                         ;84D04E;      ;
                       LDA.W #$00B1                         ;84D051;      ;
                       JSL.L TextBox_QueueGlyphDMA                    ;84D054;839823;
                       %Set8bit(!M)                             ;84D058;      ;
                       LDA.W $018F                          ;84D05A;00018F;
                       BEQ EventScriptBank84_Branch_84D069                      ;84D05D;84D069;
                       CMP.B #$03                           ;84D05F;      ;
                       BEQ EventScriptBank84_Branch_84D07C                      ;84D061;84D07C;
                       DEC A                                ;84D063;      ;
                       STA.W $018F                          ;84D064;00018F;
                       BRA PromptGridInput_ClearRepeatLatchReturn_A                      ;84D067;84D036;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84D069: LDA.W $018E                          ;84D069;00018E;
                       CMP.B #$03                           ;84D06C;      ;
                       BCC EventScriptBank84_Branch_84D077                      ;84D06E;84D077;
                       LDA.B #$02                           ;84D070;      ;
                       STA.W $018F                          ;84D072;00018F;
                       BRA PromptGridInput_ClearRepeatLatchReturn_B                      ;84D075;84D08A;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84D077: STA.W $018F                          ;84D077;00018F;
                       BRA PromptGridInput_ClearRepeatLatchReturn_B                      ;84D07A;84D08A;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84D07C: LDA.W $018E                          ;84D07C;00018E;
                       CMP.B #$03                           ;84D07F;      ;
                       BEQ PromptGridInput_ClearRepeatLatchReturn_B                      ;84D081;84D08A;
                       LDA.W $018F                          ;84D083;00018F;
                       INC A                                ;84D086;      ;
                       STA.W $018F                          ;84D087;00018F;
                                                            ;      ;      ;
          PromptGridInput_ClearRepeatLatchReturn_B: STZ.W $018B                          ;84D08A;00018B;
                       RTL                                  ;84D08D;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          PromptGridInput_MoveRight: %Set8bit(!M)                             ;84D08E;      ;
                       %Set16bit(!X)                             ;84D090;      ;
                       LDA.B #$03                           ;84D092;      ;
                       STA.W $0114                          ;84D094;000114;
                       LDA.B #$06                           ;84D097;      ;
                       STA.W $0115                          ;84D099;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84D09C;838332;
                       %Set8bit(!M)                             ;84D0A0;      ;
                       LDA.W $018E                          ;84D0A2;00018E;
                       CMP.B #$03                           ;84D0A5;      ;
                       BCC PromptGridInput_ClearRepeatLatchReturn_C                      ;84D0A7;84D0F0;
                       LDA.W $018F                          ;84D0A9;00018F;
                       CMP.B #$02                           ;84D0AC;      ;
                       BEQ PromptGridInput_ClearRepeatLatchReturn_C                      ;84D0AE;84D0F0;
                       %Set16bit(!MX)                             ;84D0B0;      ;
                       LDX.W #$0001                         ;84D0B2;      ;
                       LDA.W #$00B1                         ;84D0B5;      ;
                       JSL.L TextBox_QueueGlyphDMA                    ;84D0B8;839823;
                       %Set8bit(!M)                             ;84D0BC;      ;
                       LDA.W $018F                          ;84D0BE;00018F;
                       CMP.B #$02                           ;84D0C1;      ;
                       BCC EventScriptBank84_Branch_84D0CD                      ;84D0C3;84D0CD;
                       SEC                                  ;84D0C5;      ;
                       SBC.B #$03                           ;84D0C6;      ;
                       STA.W $018F                          ;84D0C8;00018F;
                       BRA PromptGridInput_ClearRepeatLatchReturn_C                      ;84D0CB;84D0F0;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84D0CD: %Set8bit(!M)                             ;84D0CD;      ;
                       LDA.W $018F                          ;84D0CF;00018F;
                       CMP.B #$01                           ;84D0D2;      ;
                       BEQ EventScriptBank84_Branch_84D0DE                      ;84D0D4;84D0DE;
                       CLC                                  ;84D0D6;      ;
                       ADC.B #$03                           ;84D0D7;      ;
                       STA.W $018F                          ;84D0D9;00018F;
                       BRA PromptGridInput_ClearRepeatLatchReturn_C                      ;84D0DC;84D0F0;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84D0DE: %Set8bit(!M)                             ;84D0DE;      ;
                       LDA.W $018E                          ;84D0E0;00018E;
                       CMP.B #$03                           ;84D0E3;      ;
                       BEQ PromptGridInput_ClearRepeatLatchReturn_C                      ;84D0E5;84D0F0;
                       LDA.W $018F                          ;84D0E7;00018F;
                       CLC                                  ;84D0EA;      ;
                       ADC.B #$03                           ;84D0EB;      ;
                       STA.W $018F                          ;84D0ED;00018F;
                                                            ;      ;      ;
          PromptGridInput_ClearRepeatLatchReturn_C: STZ.W $018B                          ;84D0F0;00018B;
                       RTL                                  ;84D0F3;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          PromptGridInput_MoveLeft: %Set8bit(!M)                             ;84D0F4;      ;
                       %Set16bit(!X)                             ;84D0F6;      ;
                       LDA.B #$03                           ;84D0F8;      ;
                       STA.W $0114                          ;84D0FA;000114;
                       LDA.B #$06                           ;84D0FD;      ;
                       STA.W $0115                          ;84D0FF;000115;
                       JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;84D102;838332;
                       %Set8bit(!M)                             ;84D106;      ;
                       LDA.W $018E                          ;84D108;00018E;
                       CMP.B #$03                           ;84D10B;      ;
                       BCC PromptGridInput_ClearRepeatLatchReturn_D                      ;84D10D;84D156;
                       LDA.W $018F                          ;84D10F;00018F;
                       CMP.B #$02                           ;84D112;      ;
                       BEQ PromptGridInput_ClearRepeatLatchReturn_D                      ;84D114;84D156;
                       %Set16bit(!MX)                             ;84D116;      ;
                       LDX.W #$0001                         ;84D118;      ;
                       LDA.W #$00B1                         ;84D11B;      ;
                       JSL.L TextBox_QueueGlyphDMA                    ;84D11E;839823;
                       %Set8bit(!M)                             ;84D122;      ;
                       LDA.W $018F                          ;84D124;00018F;
                       CMP.B #$02                           ;84D127;      ;
                       BCC EventScriptBank84_Branch_84D133                      ;84D129;84D133;
                       SEC                                  ;84D12B;      ;
                       SBC.B #$03                           ;84D12C;      ;
                       STA.W $018F                          ;84D12E;00018F;
                       BRA PromptGridInput_ClearRepeatLatchReturn_D                      ;84D131;84D156;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84D133: %Set8bit(!M)                             ;84D133;      ;
                       LDA.W $018F                          ;84D135;00018F;
                       CMP.B #$01                           ;84D138;      ;
                       BEQ EventScriptBank84_Branch_84D144                      ;84D13A;84D144;
                       CLC                                  ;84D13C;      ;
                       ADC.B #$03                           ;84D13D;      ;
                       STA.W $018F                          ;84D13F;00018F;
                       BRA PromptGridInput_ClearRepeatLatchReturn_D                      ;84D142;84D156;
                                                            ;      ;      ;
                                                            ;      ;      ;
          EventScriptBank84_Branch_84D144: %Set8bit(!M)                             ;84D144;      ;
                       LDA.W $018E                          ;84D146;00018E;
                       CMP.B #$03                           ;84D149;      ;
                       BEQ PromptGridInput_ClearRepeatLatchReturn_D                      ;84D14B;84D156;
                       LDA.W $018F                          ;84D14D;00018F;
                       CLC                                  ;84D150;      ;
                       ADC.B #$03                           ;84D151;      ;
                       STA.W $018F                          ;84D153;00018F;
                                                            ;      ;      ;
          PromptGridInput_ClearRepeatLatchReturn_D: STZ.W $018B                          ;84D156;00018B;
                       RTL                                  ;84D159;      ;
                                                            ;      ;      ;
