ORG $838000

;;;;;;;; Does some weird things multypling some variables LOWBYTE and HIBYTE and suming the results with another variable????
;;;;;;;; Param in A. Only called from Audio functions
Audio_IndexStrideMultiply: ;838000
        PHP
        %Set16bit(!MX)
        STA.W $011C
        STZ.W $011E
        STZ.W $0120
        STZ.W $0122
        %Set8bit(!M)
        STA.W !multiplicand
        LDA.B $7E
        STA.W !multiplier
        JSR.W Math_MultiplyUnsigned8x8
        %Set16bit(!M)
        STA.W $011E
        LDA.W $011C
        AND.W #$FF00
        BEQ .sr1
        %Set8bit(!M)
        XBA
        STA.W !multiplicand
        JSR.W Math_MultiplyUnsigned8x8
        %Set16bit(!M)
        AND.W #$00FF
        XBA
        STA.W $0120

    .sr1:
        LDA.B $7E
        AND.W #$FF00
        BEQ .sr2
        %Set8bit(!M)
        XBA
        STA.W !multiplier
        LDA.W $011C
        STA.W !multiplicand
        JSR.W Math_MultiplyUnsigned8x8
        %Set16bit(!M)
        AND.W #$00FF
        XBA
        STA.W $0122

    .sr2:
        LDA.W $011E
        CLC
        ADC.W $0120
        CLC
        ADC.W $0122
        PLP
        RTL

;;;;;;;; PASS35_MATH_RNG_CORE: hardware unsigned multiplication helper.
;;;;;;;; Inputs: !multiplicand/$011A and !multiplier/$011B. Output: 16-bit product in A via RDMPYL/RDMPYH.
Math_MultiplyUnsigned8x8: ;838067
        %Set8bit(!M)
        LDA.W !multiplicand
        STA.L !WRMPYA24
        LDA.W !multiplier
        STA.L !WRMPYB24
        %Set16bit(!M)
        NOP
        NOP
        NOP
        NOP
        LDA.L !RDMPYL24                      ;Result
        RTS

;;;;;;;; PASS35_MATH_RNG_CORE: unsigned division helper.
;;;;;;;; Inputs: !dividend/$7E and !divisor/$80. Output: quotient in A, remainder in !dision_rest/$7E.
;;;;;;;; Uses SNES hardware division for small divisors and a manual fallback for large divisors.
Math_DivideUnsigned16By16: ;838082
        %Set16bit(!MX)
        LDY.W #$0000
        LDA.B !divisor
        CMP.W #$00FF
        BCS .bigDivisor                      ;if divisor is bigger than 255
        LDA.B !dividend
        STA.L !WRDIVL24
        %Set8bit(!M)
        LDA.B !divisor
        STA.L !WRDIVB24
        %Set16bit(!M)
        NOP
        NOP
        NOP
        TYA
        LSR A
        LDA.L !RDMPYL24                      ;Rest
        STA.B !dision_rest
        LDA.L !RDDIVL24                      ;Result

    .return:
        RTL

    .bigDivisor:                             ;manual divide using substraction
        PHY
        LDY.W #$0010
        LDA.W #$0000
        STA.B !scratch82

    .loop:
        ASL.B !scratch82
        ASL.B !dividend
        ROL A
        CMP.B !divisor
        BCC .skip
        SBC.B !divisor
        INC.B !scratch82

    .skip:
        DEY
        BNE .loop

        STA.B !dision_rest                   ;Rest
        PLA
        LSR A
        LDA.B !scratch82                     ;Result
        JMP.W .return


;;;;;;;; PASS35_MATH_RNG_CORE: signed division helper, apparently unused by normal gameplay.
;;;;;;;; Inputs mirror the unsigned helper: dividend $7E, divisor $80. Output: signed quotient in A, remainder in $7E.
Math_DivideSigned16By16: ;8380D0
        %Set16bit(!MX)
        LDY.W #$0000
        LDA.B $7E
        BPL .negdividend
        EOR.W #$FFFF
        INC A
        STA.B $7E
        INY

    .negdividend:
        LDA.B $80
        BPL .negdivisor
        EOR.W #$FFFF
        INC A
        STA.B $80
        INY

    .negdivisor:
        CMP.W #$00FF
        BCS .bigDivisor
        LDA.B $7E
        STA.L !WRDIVL24
        %Set8bit(!M)
        LDA.B $80
        STA.L !WRDIVB24
        %Set16bit(!M)
        NOP
        NOP
        NOP
        TYA
        LSR A
        LDA.L !RDMPYL24
        STA.B $7E
        LDA.L !RDDIVL24

    .loop:
        BCC +
        EOR.W #$FFFF
        INC A
      + RTL

    .bigDivisor:
        PHY
        LDY.W #$0010
        LDA.W #$0000
        STA.B $82

    .subloop:
        ASL.B $82
        ASL.B $7E
        ROL A
        CMP.B $80
        BCC +
        SBC.B $80
        INC.B $82

      + DEY
        BNE .subloop
        STA.B $7E
        PLA
        LSR A
        LDA.B $82
        JMP.W .loop

;;;;;;;; PASS35_MATH_RNG_CORE: central pseudo-random generator.
;;;;;;;; Uses three RNG state bytes: !RNG_mem_1, !RNG_mem_2, !RNG_mem_3.
;;;;;;;; Returns an 8-bit random-ish value in A, zero-extended to 16-bit.
RNG_GetNextByte: ;838138
        %Set8bit(!M)
        LDA.W !RNG_mem_2
        EOR.W !RNG_mem_1
        AND.B #$02
        CLC

        BEQ +
        SEC

      + ROR.W !RNG_mem_2
        ROR.W !RNG_mem_1
        ROR.W !RNG_mem_3
        CLC
        LDA.W !RNG_mem_2
        ADC.B #$47
        ROR A
        ROR A
        EOR.W !RNG_mem_1
        ADC.W !RNG_mem_3
        STA.W !RNG_mem_1
        %Set16bit(!M)
        AND.W #$00FF
        RTL


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TextBoxDMA_QueueGlyphPatternPair
;
; Queues the two programmed DMA transfers used for a rendered textbox glyph.
; Input:
;   A = glyph/source row selector used to derive source offset
;   X = target VRAM tile position/cursor
;   $72-$74 = source graphics pointer resolved by TextBox_GetGlyphGraphicsPointer
; Effect:
;   schedules two $80-byte DMA chunks through channels 6 and 7 to VRAM.
;   This preserves the original two-part glyph/tile upload layout.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TextBoxDMA_QueueGlyphPatternPair: ;838166
        %Set16bit(!MX)
        ASL A
        ASL A
        ASL A
        ASL A
        STA.B $7E
        %Set8bit(!M)
        LDA.B #$06
        STA.B !ProgDMA_Channel_Index
        LDA.B !BBADX_DMA_VRAMPORT
        STA.B !ProgDMA_Destination_Memory
        %Set16bit(!M)
        LDA.W #$0010
        CLC
        ADC.B $7E
        TAY
        %Set16bit(!M)
        LDA.W #$0080
        PHX
        JSL.L AddProgrammedDMA
        %Set8bit(!M)
        LDA.B #$07
        STA.B !ProgDMA_Channel_Index
        LDA.B !BBADX_DMA_VRAMPORT
        STA.B !ProgDMA_Destination_Memory
        %Set16bit(!MX)
        PLX
        TXA
        CLC
        ADC.W #$0080
        TAX
        LDA.W #$0010
        CLC
        ADC.B $7E
        TAY
        LDA.B $72
        CLC
        ADC.W #$0100
        STA.B $72
        %Set16bit(!M)
        LDA.W #$0080
        JSL.L AddProgrammedDMA
        RTL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TextBoxDMA_QueuePromptCursorPatternPair
;
; Queues the two programmed DMA transfers for the blinking prompt/cursor tile.
; Used by TextBox_QueuePromptCursorTileDMA after selecting the cursor graphics
; pointer and destination from the current prompt row/table.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TextBoxDMA_QueuePromptCursorPatternPair: ;8381B7
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$06
        STA.B !ProgDMA_Channel_Index
        LDA.B !BBADX_DMA_VRAMPORT
        STA.B !ProgDMA_Destination_Memory
        LDY.W #$0004
        %Set16bit(!M)
        LDA.W #$0080
        PHX
        JSL.L AddProgrammedDMA
        %Set8bit(!M)
        LDA.B #$07
        STA.B !ProgDMA_Channel_Index
        LDA.B !BBADX_DMA_VRAMPORT
        STA.B !ProgDMA_Destination_Memory
        %Set16bit(!MX)
        PLX
        TXA
        CLC
        ADC.W #$0020
        TAX
        LDY.W #$0004
        %Set16bit(!M)
        LDA.B $72
        CLC
        ADC.W #$0004
        STA.B $72
        LDA.W #$0080
        JSL.L AddProgrammedDMA
        RTL

;;;;;;;; This is a decompression function, I think that its a cut part of a bigger
;;;;;;;; algorith, as some parts are cut, some data is skipped, might be wrong.
;;;;;;;; better explained in notes
;;;;;;;; Params $72: Compressed info pointer, $75: Destination pointer
DecompressTileMap: ;8381F8
        !datapointer = $72
        !destpointer = $75
        !controlbits = $80
        !currentbit = $82
        !remainingdata = $7E
        !7Findex = $84
        !offset = $86
        !copyN = $88

        PHP
        %Set16bit(!MX)
        LDA.W #$0000
        TAX
        .clearmemory
            STA.L $7F0000,X
            INX
            INX
            CPX.W #$0800
            BCC .clearmemory

        %Set16bit(!M)
        LDA.B [!datapointer]
        STA.B !remainingdata                 ;loads total size of data to copy
        INC.B !datapointer
        INC.B !datapointer
        INC.B !datapointer                   ;skips two bytes? they seem to be always 0?
        INC.B !datapointer

        STZ.B !controlbits
        STZ.B !currentbit
        LDA.W #$07DE                         ;2014
        STA.B !7Findex
        LDA.B !remainingdata
        BNE .getNextAction                   ;useless branch

        .getNextAction
            DEC.B !currentbit                ;first time, it will result negative
            BPL .copySingleByte
            %Set16bit(!M)
            LDA.B [!datapointer]             ;read next Control bit
            INC.B !datapointer
            AND.W #$00FF
            STA.B !controlbits
            LDA.W #$0007                     ;max ammount of control bits
            STA.B !currentbit

        .copySingleByte:
            LSR.B !controlbits               ;Sets the next control bit on the Carry flag
            BCC .specialCase                 ;if its 0, its a special copy

            %Set16bit(!M)                    ;if its 1, just copy a single byte, src to dst
            LDA.B [!datapointer]
            INC.B !datapointer
            AND.W #$00FF
            %Set8bit(!M)
            STA.B [!destpointer]
            %Set16bit(!MX)
            INC.B !destpointer
            DEC.B !remainingdata
            BEQ .return                      ;Finished copying
            LDX.B !7Findex
            %Set8bit(!M)
            STA.L $7F0000,X                  ;Writes a copy on the temp place?
            %Set16bit(!MX)
            TXA
            INC A
            AND.W #$07FF                     ;2047, max size?
            STA.B !7Findex
            BRA .getNextAction

        .specialCase:
            %Set16bit(!M)
            LDA.B [!datapointer]
            INC.B !datapointer
            AND.W #$00FF
            STA.B !offset
            %Set16bit(!M)
            LDA.B [!datapointer]
            INC.B !datapointer
            AND.W #$00FF
            TAX
            AND.W #$001F                     ;separate last 5 bits
            INC A
            INC A
            INC A
            STA.B !copyN                     ;last 5 bits + 3
            TXA
            AND.W #$00E0                     ;first 3 bits
            ASL A
            ASL A
            ASL A
            ORA.B !offset                    ;used as high byte, it give us a max of
            STA.B !offset                    ;2047, the max size.

            .repeatSpecialCopy:
                LDX.B !offset
                LDA.L $7F0000,X
                AND.W #$00FF
                %Set8bit(!M)
                STA.B [!destpointer]
                %Set16bit(!MX)
                INC.B !destpointer
                DEC.B !remainingdata
                BEQ .return
                LDX.B !7Findex
                %Set8bit(!M)
                STA.L $7F0000,X
                %Set16bit(!MX)
                TXA
                INC A
                AND.W #$07FF
                STA.B !7Findex
                LDA.B !offset
                INC A
                AND.W #$07FF
                STA.B !offset
                DEC.B !copyN
                BNE .repeatSpecialCopy

        JMP.W .getNextAction

    .return:
        LDA.B !remainingdata
        PLP
        RTL


;;;;;;;;
AudioBGM_ForceTrackForTransitionWithDelay: ;8382C6
        %Set8bit(!M)
        %Set16bit(!X)
        PHA
        JSL.L AudioBGM_FadeOutPreviousTrackIfChanged
        %Set8bit(!M)
        PLA
        STA.W $0110
        JSL.L AudioBGM_StartCurrentTrackAndQueueSamples
        JSL.L AudioBGM_FadeInCurrentTrackIfChanged
        %Set8bit(!M)
        LDA.W $0110
        STA.W $0117
        %Set16bit(!MX)
        LDA.W #$00B4
        JSL.L NMI_WaitForFrames
        %Set8bit(!M)
        LDA.W !transition_dest
        STA.B !tilemap_to_load
        JSL.L AudioBGM_SelectTrackForAreaSeasonTime
        JSL.L AudioBGM_FadeOutPreviousTrackFast
        RTL

;;;;;;;;
AudioSFX_PlayEffectIdWithDuration: ;8382FE
        %Set8bit(!M)
        %Set16bit(!X)
        STA.W $0114
        PHY
        %Set16bit(!M)
        TXA
        %Set8bit(!M)
        STA.W $0115
        LDA.B #$00
        XBA
        LDA.W $0118
        %Set16bit(!M)
        TAX
        %Set8bit(!M)
        LDA.L AudioBGM_AreaProfileIndexTable,X
        INC A
        STA.W $0103
        JSL.L AudioSFX_PrepareEffectSampleGroup
        JSL.L AudioSFX_PlayQueuedEffectDefaultVolume
        %Set16bit(!MX)
        PLY
        TYA
        JSL.L NMI_WaitForFrames
        RTL

;;;;;;;;
AudioSFX_PlayQueuedEffectDefaultVolume: ;838332
        %Set8bit(!M)
        LDA.B #$0A
        STA.W $0116
        JSL.L AudioSPC_SendCommand0A_PlayEffectParams
        RTL

;;;;;;;;
AudioSFX_PrepareEffectSampleGroup: ;83833E
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.W $0103
        %Set16bit(!M)
        TAX
        %Set8bit(!M)
        LDA.W $0104,X
        BEQ +
        %Set16bit(!M)
        TXA
        INC A
        %Set8bit(!M)
        JSL.L AudioSPC_SendCommand04_StopSequenceSlot
        JSL.L NMI_WaitForNextFrame

      + %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.W $0114
        %Set16bit(!M)
        TAX
        %Set8bit(!M)
        LDA.L AudioSFX_SampleGroupByEffectId,X
        BEQ .return
        JSL.L AudioSFX_UploadEffectSampleGroup

    .return: RTL

;;;;;;;; Seems to be unused
UNUSED2: ;838376
        %Set8bit(!M)
        LDA.W $0103
        INC A
        STA.W $0103
        RTL

;;;;;;;;
AudioBGM_FadeInCurrentTrackIfChanged: ;838380
        %Set8bit(!M)
        LDA.W $0110
        BEQ .skip
        CMP.W $0117
        BEQ .skip
        CMP.B #$FF
        BEQ .skip
        LDA.B #$01
        STA.W $0111
        LDA.B #$40
        STA.W $0113
        JSL.L AudioSPC_SendCommand08_FadeInCurrentTrack

    .skip:
        %Set8bit(!M)
        STZ.W $0119
        RTL

;;;;;;;;
AudioBGM_StartCurrentTrackAndQueueSamples: ;8383A4
        %Set8bit(!M)
        LDA.W $0110
        CMP.W $0117
        BEQ .skip
        LDA.B #$00
        JSL.L AudioSPC_SendCommand04_StopSequenceSlot
        %Set8bit(!M)
        LDA.W $0110
        BEQ .skip
        CMP.B #$FF
        BEQ .skip
        JSL.L AudioBGM_UploadCurrentTrackData
        JSL.L AudioBGM_UploadCurrentTrackStream
        BRA .skip

        %Set8bit(!M)
        LDA.B #$00
        STA.W $0110

    .skip:
        %Set8bit(!M)
        LDA.B #$06
        STA.W $0115
        LDA.B #$03
        STA.W $0114
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.W $0110
        STA.W $0118
        CMP.B #$FF
        BNE .skip2
        LDA.B #$00
        STA.W $0118

    .skip2:
        %Set16bit(!M)
        TAX
        %Set8bit(!M)
        LDA.L AudioBGM_AreaProfileIndexTable,X
        STA.W $0103
        JSL.L AudioSFX_PrepareEffectSampleGroup

        RTL

;;;;;;;;
AudioBGM_FadeOutPreviousTrackFast: ;838401
        %Set8bit(!M)
        LDA.W $0110
        CMP.W $0117
        BEQ $13
        LDA.W $0117
        BEQ $F0
        LDA.B #$01
        STA.W $0112
        LDA.B #$40
        STA.W $0113
        JSL.L AudioSPC_SendCommand09_FadeOutPreviousTrack

        RTL

;;;;;;;;
AudioBGM_FadeOutPreviousTrackIfChanged: ;83841F
        %Set8bit(!M)
        LDA.W $0110
        CMP.W $0117
        BEQ .skip
        LDA.W $0117
        BEQ .skip
        LDA.B #$01
        STA.W $0112
        LDA.B #$10
        STA.W $0113
        JSL.L AudioSPC_SendCommand09_FadeOutPreviousTrack

    .skip: RTL

;;;;;;;;
AudioSPC_UploadDriverBootstrap: ;83843D
        PHP
        %Set16bit(!MX)
        %Set16bit(!MX)
        LDY.W #$0000
        LDA.W #$BBAA

    .loop1:
        CMP.W !APUIO0
        BNE .loop1
        %Set8bit(!M)
        %Set8bit(!M)
        LDA.B #$CC
        PHA
        %Set16bit(!M)
        %Set16bit(!M)
        LDA.W #$0FD6
        TAX
        %Set8bit(!M)
        LDA.B #$00
        STA.W !APUIO2
        LDA.B #$05
        STA.W !APUIO3
        %Set8bit(!M)
        CPX.W #$0001
        LDA.B #$00
        ROL A
        STA.W !APUIO1
        ADC.B #$7F
        PLA
        STA.W !APUIO0

    .loop2:
        CMP.W !APUIO0
        BNE .loop2

    .loop9:
        LDA.B [$0A],Y
        INY
        XBA
        LDA.B #$00
        BRA .sub1

    .loop4:
        XBA
        LDA.B [$0A],Y
        INY
        XBA

    .loop3:
        CMP.W !APUIO0
        BNE .loop3
        INC A

    .sub1:
        %Set16bit(!M)
        STA.W !APUIO0
        %Set8bit(!M)
        DEX
        BNE .loop4

    .loop5:
        CMP.W !APUIO0
        BNE .loop5

    .loop6:
        ADC.B #$03
        BEQ .loop6
        PHA
        %Set16bit(!M)
        %Set16bit(!M)
        LDA.W #$0000
        TAX
        %Set8bit(!M)
        LDA.B #$00
        STA.W !APUIO2
        LDA.B #$05
        STA.W !APUIO3
        %Set8bit(!M)
        CPX.W #$0001
        LDA.B #$00
        ROL A
        STA.W !APUIO1
        ADC.B #$7F
        PLA
        STA.W !APUIO0

    .loop8:
        CMP.W !APUIO0
    .loop7:
        BNE .loop8
        BVS .loop9
        PLP
        RTL

;;;;;;;;
AudioSPC_UploadSecondDriverBlock: ;8384D3
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$01
        STA.B $92
        JSR.W AudioSPC_SendCommandAndWaitAck

    .loop1:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop1
        LDA.B #$01
        CMP.W !APUIO3
        BNE .loop1
        %Set16bit(!M)
        LDA.W #$03F2
        STA.B $7E
        LDA.W #$0003
        STA.B $80
        JSL.L Math_DivideUnsigned16By16
        STA.B $80
        LDA.B $7E
        BEQ .skip
        INC.B $80

    .skip:
        LDA.B $80
        %Set8bit(!M)
        STA.W !APUIO0
        XBA
        STA.W !APUIO1
        STZ.W !APUIO2
        LDA.B #$02
        STA.W !APUIO3

    .loop2:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop2
        LDA.W !APUIO3
        CMP.B #$04
        BNE .loop2
        %Set8bit(!M)
        STZ.W !APUIO3
        LDY.W #$0000
        %Set16bit(!M)
        LDA.W #$D120
        STA.B $0A
        %Set8bit(!M)
        LDA.B #$B2
        STA.B $0C
        %Set16bit(!M)
        LDA.B $80
        TAX

    .loop3:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop3
        LDA.B #$01
        CMP.W !APUIO3
        BNE .loop3
        LDA.B [$0A],Y
        STA.W !APUIO0
        INY
        LDA.B [$0A],Y
        STA.W !APUIO1
        INY
        LDA.B [$0A],Y
        STA.W !APUIO2
        INY
        DEX
        LDA.B #$02
        STA.W !APUIO3

    .loop4:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop4
        LDA.B #$00
        CMP.W !APUIO3
        BNE .loop4
        STZ.W !APUIO3
        CPX.W #$0000
        BNE .loop3
        RTL

;;;;;;;;
AudioSPC_UploadInitialMusicTables: ;838598
        %Set8bit(!M)
        %Set16bit(!X)
        LDX.W #$0000

    .mainloop:
        LDA.L AudioInit_DefaultBGMUploadList,X
        STA.B $94
        BNE .sr1
        INX
        CPX.W #$000A
        BNE .mainloop
        JMP.W $878B

    .sr1:
        %Set8bit(!M)
        LDA.B #$02
        STA.B $92
        JSR.W AudioSPC_SendCommandAndWaitAck

    .loop2:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop2
        LDA.B #$01
        CMP.W !APUIO3
        BNE .loop2
        PHX
        LDA.B #$00
        XBA
        LDA.B $94
        %Set16bit(!M)
        STA.B $7E
        LDA.W #$000A
        JSL.L Audio_IndexStrideMultiply
        TAX
        %Set8bit(!M)
        LDA.B $94
        STA.W !APUIO0
        %Set16bit(!M)
        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        %Set8bit(!M)
        STA.W !APUIO1
        XBA
        STA.W !APUIO2
        LDA.B #$02
        STA.W !APUIO3
        INX
        INX

    .loop3:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop3
        LDA.W !APUIO3
        CMP.B #$04
        BEQ .skip
        BRA .loop3

    .skip:
        STZ.W !APUIO3

      - %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE -

      - LDA.B #$01
        CMP.W !APUIO3
        BNE -

        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        STA.W !APUIO0
        INX
        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        STA.W !APUIO1
        INX
        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        STA.W !APUIO2
        LDA.B #$02
        STA.W !APUIO3
        INX

    .loop4:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop4
        LDA.W !APUIO3
        CMP.B #$04
        BEQ +
        BRA .loop4

      + STZ.W !APUIO3

      - %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE -

      - LDA.B #$01
        CMP.W !APUIO3
        BNE -

        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        STA.W !APUIO0
        INX
        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        STA.W !APUIO1
        STZ.W !APUIO2
        LDA.B #$02
        STA.W !APUIO3
        INX

    .loop5:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop5
        LDA.W !APUIO3
        CMP.B #$04
        BEQ +
        BRA .loop5

      + STZ.W !APUIO3

      - %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE -

      - LDA.B #$01
        CMP.W !APUIO3
        BNE -

        %Set16bit(!M)
        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        STA.B $0A
        INX
        INX
        %Set8bit(!M)
        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        STA.B $0C
        LDA.B #$00
        XBA
        LDA.B $94
        ASL A
        %Set16bit(!M)
        TAX
        LDA.L AudioSFX_SampleTransferSizeTable,X
        STA.B $7E
        LDA.W #$0003
        STA.B $80
        JSL.L Math_DivideUnsigned16By16
        STA.B $80
        LDA.B $7E
        BEQ +
        INC.B $80

      + LDA.B $80
        TAX
        %Set8bit(!M)
        STA.W !APUIO0
        XBA
        STA.W !APUIO1
        STZ.W !APUIO2
        LDA.B #$02
        STA.W !APUIO3
        LDY.W #$0000

    .loop6:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop6
        LDA.W !APUIO3
        CMP.B #$04
        BEQ +
        BRA .loop6

      + STZ.W !APUIO3

      - %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE -

      - LDA.B #$01
        CMP.W !APUIO3
        BNE -

    .loop7:
        LDA.B [$0A],Y
        STA.W !APUIO0
        INY
        LDA.B [$0A],Y
        STA.W !APUIO1
        INY
        LDA.B [$0A],Y
        STA.W !APUIO2
        INY
        DEX
        LDA.B #$02
        STA.W !APUIO3

    .loop8:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop8
        LDA.B #$00
        CMP.W !APUIO3
        BNE .loop8
        STZ.W !APUIO3

      - %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE -

      - LDA.B #$01
        CMP.W !APUIO3
        BNE -
        CPX.W #$0000
        BNE .loop7
        PLX
        INX
        CPX.W #$000A
        BEQ +
        JMP.W .mainloop

      + RTL

;;;;;;;;
AudioBGM_UploadCurrentTrackStream: ;83878C
        %Set8bit(!M)
        %Set16bit(!X)
        LDX.W #$0000
        STZ.W $0103
        STZ.W $010F

      - STZ.W $0104,X
        INX
        CPX.W #$000B
        BNE -

        LDY.W #$0000
        LDA.B #$00
        XBA
        LDA.W $0110
        %Set16bit(!M)
        STA.B $7E
        LDA.W #$000E
        JSL.L Audio_IndexStrideMultiply
        TAX
        INX
        INX
        INX
        CLC
        ADC.W #$000E
        STA.B $84

    .mainloop:
        %Set8bit(!M)
        LDA.L AudioBGM_UploadDescriptorTable,X
        STA.B $94
        BNE .skip1
        %Set16bit(!M)
        INX
        CPX.B $84
        BNE .mainloop
        %Set8bit(!M)
        LDA.B #$06
        STA.B $94
        DEX
        BRA .skip2

    .skip1:
        %Set8bit(!M)
        LDA.B $94
        STA.W $0104,Y
        INC.W $0103
        INC.W $010F

    .skip2:
        %Set8bit(!M)
        LDA.B #$03
        STA.B $92
        JSR.W AudioSPC_SendCommandAndWaitAck

    .loop1:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop1
        LDA.B #$01
        CMP.W !APUIO3
        BNE .loop1
        PHX
        PHY
        LDA.B #$00
        XBA
        LDA.B $94
        %Set16bit(!M)
        STA.B $7E
        LDA.W #$000A
        JSL.L Audio_IndexStrideMultiply
        TAX
        %Set8bit(!M)
        LDA.B $94
        STA.W !APUIO0
        %Set16bit(!M)
        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        %Set8bit(!M)
        STA.W !APUIO1
        XBA
        STA.W !APUIO2
        LDA.B #$02
        STA.W !APUIO3
        INX
        INX

    .loop2:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop2
        LDA.W !APUIO3
        CMP.B #$04
        BEQ +
        BRA .loop2

      + STZ.W !APUIO3

      - %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE -

      - LDA.B #$01
        CMP.W !APUIO3
        BNE -

        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        STA.W !APUIO0
        INX
        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        STA.W !APUIO1
        INX
        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        STA.W !APUIO2
        LDA.B #$02
        STA.W !APUIO3
        INX

    .loop3:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop3
        LDA.W !APUIO3
        CMP.B #$04
        BEQ +
        BRA .loop3

      + STZ.W !APUIO3

      - %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE -

      - LDA.B #$01
        CMP.W !APUIO3
        BNE -

        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        STA.W !APUIO0
        INX
        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        STA.W !APUIO1
        STZ.W !APUIO2
        LDA.B #$02
        STA.W !APUIO3
        INX

    .loop4:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop4
        LDA.W !APUIO3
        CMP.B #$04
        BEQ +
        BRA .loop4

      + STZ.W !APUIO3

      - %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE -

      - LDA.B #$01
        CMP.W !APUIO3
        BNE -

        %Set16bit(!M)
        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        STA.B $0A
        INX
        INX
        %Set8bit(!M)
        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        STA.B $0C
        LDA.B #$00
        XBA
        LDA.B $94
        ASL A
        %Set16bit(!M)
        TAX
        LDA.L AudioSFX_SampleTransferSizeTable,X
        STA.B $7E
        LDA.W #$0003
        STA.B $80
        JSL.L Math_DivideUnsigned16By16
        STA.B $80
        LDA.B $7E
        BEQ +
        INC.B $80

      + LDA.B $80
        TAX
        %Set8bit(!M)
        STA.W !APUIO0
        XBA
        STA.W !APUIO1
        STZ.W !APUIO2
        LDA.B #$02
        STA.W !APUIO3
        LDY.W #$0000

    .loop5:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop5
        LDA.W !APUIO3
        CMP.B #$04
        BEQ +
        BRA .loop5

      + STZ.W !APUIO3

      - %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE -

      - LDA.B #$01
        CMP.W !APUIO3
        BNE -

    .subloop:
        LDA.B [$0A],Y
        STA.W !APUIO0
        INY
        LDA.B [$0A],Y
        STA.W !APUIO1
        INY
        LDA.B [$0A],Y
        STA.W !APUIO2
        INY
        DEX
        LDA.B #$02
        STA.W !APUIO3

    .loop6:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop6
        LDA.B #$00
        CMP.W !APUIO3
        BNE .loop6
        STZ.W !APUIO3

      - %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE -

      - LDA.B #$01
        CMP.W !APUIO3
        BNE -

        CPX.W #$0000
        BNE .subloop
        %Set16bit(!M)
        PLY
        PLX
        INX
        INY
        CPX.B $84
        BEQ .return
        JMP.W .mainloop

    .return: RTL

;;;;;;;;
AudioSPC_SendCommand04_StopSequenceSlot: ;8389C7
        %Set8bit(!M)
        PHA
        STA.B $94

      - LDA.B $94
        BNE +
        JSR.W AudioSPC_WaitReadyAndReadStatusFlags
        BNE -

      + %Set16bit(!X)
        LDA.B #$04
        STA.B $92
        JSR.W AudioSPC_SendCommandAndWaitAck

        .loop1:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop1
        LDA.B #$01
        CMP.W !APUIO3
        BNE .loop1
        LDA.B $94
        STA.W !APUIO0
        STZ.W !APUIO1
        STZ.W !APUIO2
        LDA.B #$02
        STA.W !APUIO3

      - LDA.W !APUIO3
        CMP.B #$08
        BEQ +
        BRA -

      + STZ.W !APUIO3
        %Set8bit(!M)
        LDA.B #$00
        XBA
        PLA
        %Set16bit(!M)
        TAX
        %Set8bit(!M)

      - LDA.B #$00
        STA.W $0104,X
        INX
        CPX.W #$000B
        BNE -
        RTL

;;;;;;;;
AudioBGM_UploadCurrentTrackData:  ;838A26
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$05
        STA.B $92
        JSR.W AudioSPC_SendCommandAndWaitAck

    .loop1:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop1
        LDA.B #$01
        CMP.W !APUIO3
        BNE .loop1
        LDA.B #$00
        XBA
        LDA.W $0110
        ASL A
        %Set16bit(!M)
        TAX
        LDA.L AudioBGM_TransferSizeTable,X
        STA.B $7E
        LDA.W #$0003
        STA.B $80
        JSL.L Math_DivideUnsigned16By16
        STA.B $80
        LDA.B $7E
        BEQ +
        INC.B $80

      + LDA.B $80
        %Set8bit(!M)
        STA.W !APUIO0
        XBA
        STA.W !APUIO1
        STZ.W !APUIO2
        LDA.B #$02
        STA.W !APUIO3

      - LDA.W !APUIO3
        CMP.B #$04
        BEQ +
        BRA -

      + LDY.W #$0000
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.W $0110
        %Set16bit(!M)
        STA.B $7E
        LDA.W #$000E
        JSL.L Audio_IndexStrideMultiply
        TAX
        LDA.L AudioBGM_UploadDescriptorTable,X
        STA.B $0A
        INX
        INX
        %Set8bit(!M)
        LDA.L AudioBGM_UploadDescriptorTable,X
        STA.B $0C
        %Set16bit(!M)
        LDA.B $80
        TAX

    .loop2:
        %Set8bit(!M)
        STZ.W !APUIO3

    .loop3:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop3
        LDA.B #$01
        CMP.W !APUIO3
        BNE .loop3
        LDA.B [$0A],Y
        STA.W !APUIO0
        INY
        LDA.B [$0A],Y
        STA.W !APUIO1
        INY
        LDA.B [$0A],Y
        STA.W !APUIO2
        INY
        DEX
        LDA.B #$02
        STA.W !APUIO3

    .loop4:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop4
        LDA.B #$00
        CMP.W !APUIO3
        BNE .loop4
        STZ.W !APUIO3
        CPX.W #$0000
        BNE .loop2
        RTL

;;;;;;;;
AudioSFX_UploadEffectSampleGroup: ;838AFF
        %Set8bit(!M)
        %Set16bit(!X)
        LDX.W #$0000
        LDA.B #$03
        STA.B $92
        JSR.W AudioSPC_SendCommandAndWaitAck

    .loop1:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop1
        LDA.B #$01
        CMP.W !APUIO3
        BNE .loop1
        LDA.B #$00
        XBA
        LDA.W $0114
        TAX
        LDA.L AudioSFX_SampleGroupByEffectId,X
        STA.B $94
        LDA.W $0103
        TAX
        LDA.B $94
        STA.W $0104,X
        INC.W $0103
        LDA.B #$00
        XBA
        LDA.B $94
        %Set16bit(!M)
        STA.B $7E
        LDA.W #$000A
        JSL.L Audio_IndexStrideMultiply
        TAX
        %Set8bit(!M)
        LDA.B $94
        STA.W !APUIO0
        %Set16bit(!M)
        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        %Set8bit(!M)
        STA.W !APUIO1
        XBA
        STA.W !APUIO2
        LDA.B #$02
        STA.W !APUIO3
        INX
        INX

    .loop2:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop2
        LDA.W !APUIO3
        CMP.B #$04
        BEQ +
        BRA .loop2

      + STZ.W !APUIO3

      - %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE -

      - LDA.B #$01
        CMP.W !APUIO3
        BNE -

        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        STA.W !APUIO0
        INX
        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        STA.W !APUIO1
        INX
        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        STA.W !APUIO2
        LDA.B #$02
        STA.W !APUIO3
        INX

    .loop3:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop3
        LDA.W !APUIO3
        CMP.B #$04
        BEQ +
        BRA .loop3

      + STZ.W !APUIO3

      - %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE -

      - LDA.B #$01
        CMP.W !APUIO3
        BNE -

        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        STA.W !APUIO0
        INX
        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        STA.W !APUIO1
        STZ.W !APUIO2
        LDA.B #$02
        STA.W !APUIO3
        INX

    .loop4:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop4
        LDA.W !APUIO3
        CMP.B #$04
        BEQ +
        BRA .loop4

      + STZ.W !APUIO3

      - %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE -

      - LDA.B #$01
        CMP.W !APUIO3
        BNE -

        %Set16bit(!M)
        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        STA.B $0A
        INX
        INX
        %Set8bit(!M)
        LDA.L AudioSFX_SampleUploadDescriptorTable,X
        STA.B $0C
        LDA.B #$00
        XBA
        LDA.B $94
        ASL A
        %Set16bit(!M)
        TAX
        LDA.L AudioSFX_SampleTransferSizeTable,X
        STA.B $7E
        LDA.W #$0003
        STA.B $80
        JSL.L Math_DivideUnsigned16By16
        STA.B $80
        LDA.B $7E
        BEQ +
        INC.B $80

      + LDA.B $80
        TAX
        %Set8bit(!M)
        STA.W !APUIO0
        XBA
        STA.W !APUIO1
        STZ.W !APUIO2
        LDA.B #$02
        STA.W !APUIO3
        LDY.W #$0000

    .loop5:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop5
        LDA.W !APUIO3
        CMP.B #$04
        BEQ +
        BRA .loop5

      + STZ.W !APUIO3

      - %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE -

      - LDA.B #$01
        CMP.W !APUIO3
        BNE -

    .loop6:
        %Set8bit(!M)
        LDA.B [$0A],Y
        STA.W !APUIO0
        INY
        LDA.B [$0A],Y
        STA.W !APUIO1
        INY
        LDA.B [$0A],Y
        STA.W !APUIO2
        INY
        DEX
        LDA.B #$02
        STA.W !APUIO3

        .loop7: %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop7
        LDA.B #$00
        CMP.W !APUIO3
        BNE .loop7
        STZ.W !APUIO3

      - %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE -

      - LDA.B #$01
        CMP.W !APUIO3
        BNE -

        CPX.W #$0000
        BNE .loop6
        STZ.W !APUIO3
        RTL

;;;;;;;;
AudioSPC_SendCommand07_SimpleParam: ;838CF3
        %Set8bit(!M)
        %Set16bit(!X)
        STA.B $94
        LDA.B #$07
        STA.B $92

      - LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE -

      - LDA.B #$01
        CMP.W !APUIO3
        BNE -

        LDA.B $92
        STA.W !APUIO0
        STZ.W !APUIO1
        STZ.W !APUIO2
        LDA.B #$02
        STA.W !APUIO3

      - %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE -
        LDA.B #$04
        CMP.W !APUIO3
        BNE -
        STZ.W !APUIO3
        RTL

;;;;;;;
AudioSPC_SendCommand08_FadeInCurrentTrack: ;838D38
        JSR.W AudioSPC_WaitReadyAndReadStatusFlags
        BNE AudioSPC_SendCommand08_FadeInCurrentTrack
        %Set8bit(!M)
        LDA.B #$08
        STA.B $92
        JSR.W AudioSPC_SendCommandAndWaitAck

    .loop1:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop1
        LDA.B #$01
        CMP.W !APUIO3
        BNE .loop1
        LDA.W $0111
        STA.W !APUIO0
        LDA.W $0113
        STA.W !APUIO1
        STZ.W !APUIO2
        LDA.B #$02
        STA.W !APUIO3

    .loop2:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop2
        LDA.W !APUIO3
        CMP.B #$08
        BEQ .return
        BRA .loop2

    .return:
        STZ.W !APUIO3
        RTL

;;;;;;;;
AudioSPC_SendCommand09_FadeOutPreviousTrack: ;838D8B
        %Set8bit(!M)
        JSR.W AudioSPC_WaitReadyAndReadStatusFlags
        BEQ $4C
        %Set8bit(!M)
        LDA.B #$09
        STA.B $92
        JSR.W AudioSPC_SendCommandAndWaitAck

    .loop1:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop1
        LDA.B #$01
        CMP.W !APUIO3
        BNE .loop1
        LDA.W $0112
        STA.W !APUIO0
        LDA.W $0113
        STA.W !APUIO1
        STZ.W !APUIO2
        LDA.B #$02
        STA.W !APUIO3

    .loop2:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop2
        LDA.W !APUIO3
        CMP.B #$08
        BEQ .return
        BRA .loop2

    .return:
        STZ.W !APUIO3
        RTL

;;;;;;;;
AudioSPC_SendCommand0A_PlayEffectParams: ;838DDF
        JSR.W AudioSPC_WaitReadyAndCheckBusyBit10
        BNE .return
        %Set8bit(!M)
        LDA.B #$0A
        STA.B $92
        JSR.W AudioSPC_SendCommandAndWaitAck

    .loop:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop
        LDA.B #$01
        CMP.W !APUIO3
        BNE .loop
        LDA.W $0114
        STA.W !APUIO0
        LDA.W $0115
        STA.W !APUIO1
        LDA.W $0116
        STA.W !APUIO2
        LDA.B #$02
        STA.W !APUIO3

    .loop2:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop2
        LDA.W !APUIO3
        CMP.B #$08
        BNE .loop2
        STZ.W !APUIO3

    .return: RTL

;;;;;;;;
AudioSPC_SendCommand0B_SetGlobalParam: ;838E32
        %Set8bit(!M)
        STA.B $94
        %Set16bit(!X)
        LDA.B #$0B
        STA.B $92
        JSR.W AudioSPC_SendCommandAndWaitAck

    .loop1:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop1
        LDA.B #$01
        CMP.W !APUIO3
        BNE .loop1
        LDA.B $94
        STA.W !APUIO0
        STZ.W !APUIO1
        STZ.W !APUIO2
        LDA.B #$02
        STA.W !APUIO3

    .loop2:
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop2
        LDA.W !APUIO3
        CMP.B #$08
        BEQ .skip
        BRA .loop2

    .skip:
        STZ.W !APUIO3
        RTL

;;;;;;;;
AudioSPC_SendCommand0C_StopOrReset: ;838E7F
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$0C
        STA.B $92
        JSR.W AudioSPC_SendCommandAndWaitAck
        RTL

;;;;;;;;
AudioSPC_SendCommandAndWaitAck: ;838E8B
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE AudioSPC_SendCommandAndWaitAck

    .loop1:
        LDA.B #$01
        CMP.W !APUIO3
        BNE .loop1

        LDA.B $92
        STA.W !APUIO0
        STZ.W !APUIO1
        STZ.W !APUIO2
        LDA.B #$02
        STA.W !APUIO3

    .loop2:
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE .loop2

    .loop3:
        LDA.W !APUIO3
        CMP.B #$04
        BEQ .return
        BRA .loop3

    .return:
        STZ.W !APUIO3
        RTS

;;;;;;;;
AudioSPC_WaitReadyAndReadStatusFlags: ;838EC9
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE AudioSPC_WaitReadyAndReadStatusFlags
        LDA.B #$01
        CMP.W !APUIO3
        BNE AudioSPC_WaitReadyAndReadStatusFlags
        LDA.W !APUIO0
        AND.B #$11
        RTS

;;;;;;;;
AudioSPC_WaitReadyAndCheckBusyBit10: ;838EE4
        %Set8bit(!M)
        LDA.W !APUIO3
        STA.B $93
        LDA.W !APUIO3
        CMP.B $93
        BNE AudioSPC_WaitReadyAndCheckBusyBit10
        LDA.B #$01
        CMP.W !APUIO3
        BNE AudioSPC_WaitReadyAndCheckBusyBit10
        LDA.W !APUIO0
        AND.B #$10
        RTS

;;;;;;;;
AudioSFX_SampleTransferSizeTable: dw $10C0,$10C0,$2EE0,$0BB0,$0780,$0D10,$0040,$1F30;838EFF
                  dw $1950,$1300,$02D0,$1B80,$0340,$0670,$0DA0,$1240
                  dw $0FA0,$07D0,$1B40,$1F30,$06B0,$1940,$0730,$03E0
                  dw $1380,$04E0,$0C80,$0F90,$0E50,$3E70,$0F90,$0BB0
                  dw $0BB0,$0BB0,$0BB0,$07C0,$1380,$0340,$07C0,$1F30

AudioBGM_TransferSizeTable: dw $02EC,$02EC,$0272,$03AB,$02B6,$0443,$0399,$02AD;838F4F
                  dw $01F6,$0260,$019A,$018E,$01D1,$0293,$023D,$02F2
                  dw $0435,$0113,$04B7,$007A,$0080,$00DB,$011E,$00B0
                  dw $005C,$00BC

AudioBGM_UploadDescriptorTable: db $D6,$8F,$AD,$07,$03,$01,$0C,$05,$26,$24,$00,$00,$00,$00,$D6,$8F;838F83
                  db $AD,$07,$03,$01,$0C,$00,$00,$00,$00,$00,$00,$00,$4A,$B4,$AD,$01
                  db $05,$00,$00,$00,$00,$00,$00,$00,$00,$00,$FD,$9F,$AD,$03,$07,$01
                  db $16,$05,$00,$00,$00,$00,$00,$00,$C2,$92,$AD,$03,$07,$01,$00,$00
                  db $00,$00,$00,$00,$00,$00,$A7,$9A,$AD,$05,$01,$07,$00,$00,$00,$00
                  db $00,$00,$00,$00,$0E,$AC,$AD,$03,$07,$01,$00,$00,$00,$00,$00,$00
                  db $00,$00,$A7,$AF,$AD,$01,$04,$0C,$08,$00,$00,$00,$00,$00,$00,$00
                  db $54,$B2,$AD,$01,$07,$16,$00,$00,$00,$00,$00,$00,$00,$00,$AE,$A9
                  db $AD,$02,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$06,$BE,$AD,$05
                  db $07,$00,$00,$00,$00,$00,$00,$00,$00,$00,$A0,$BF,$AD,$05,$01,$07
                  db $00,$00,$00,$00,$00,$00,$00,$00,$A8,$A3,$AD,$05,$07,$01,$00,$00
                  db $00,$00,$00,$00,$00,$00,$BC,$B6,$AD,$05,$01,$08,$00,$00,$00,$00
                  db $00,$00,$00,$00,$6A,$98,$AD,$05,$00,$00,$00,$00,$00,$00,$00,$00
                  db $00,$00,$78,$95,$AD,$05,$0B,$01,$08,$00,$00,$00,$00,$00,$00,$00
                  db $79,$A5,$AD,$05,$01,$0C,$00,$00,$00,$00,$00,$00,$00,$00,$EA,$9E
                  db $AD,$05,$03,$07,$00,$00,$00,$00,$00,$00,$00,$00,$4F,$B9,$AD,$04
                  db $03,$07,$0B,$00,$00,$00,$00,$00,$00,$00,$2E,$C1,$AD,$0D,$00,$00
                  db $00,$00,$00,$00,$00,$00,$00,$00,$A8,$C1,$AD,$0D,$00,$00,$00,$00
                  db $00,$00,$00,$00,$00,$00,$28,$C2,$AD,$15,$0D,$18,$00,$00,$00,$00
                  db $00,$00,$00,$00,$03,$C3,$AD,$10,$00,$00,$00,$00,$00,$00,$00,$00
                  db $00,$00,$21,$C4,$AD,$1D,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
                  db $D1,$C4,$AD,$1D,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$2D,$C5
                  db $AD,$13,$15,$00,$00,$00,$00,$00,$00,$00,$00,$00

AudioSFX_SampleUploadDescriptorTable: db $B0,$01,$FF,$E0,$B8,$05,$20,$E9,$C5,$AD,$B0,$01,$FF,$E0,$B8,$05;8390EF
                  db $20,$E9,$C5,$AD,$76,$02,$FF,$E0,$B8,$06,$B0,$00,$80,$AE,$DF,$05
                  db $FF,$E3,$B8,$01,$E0,$A9,$D6,$AD,$3E,$07,$FF,$EF,$B8,$05,$F0,$59
                  db $E2,$AD,$F2,$07,$FF,$EB,$B8,$03,$E0,$D9,$E9,$AD,$1B,$00,$FF,$E0
                  db $B8,$04,$00,$E9,$F6,$AD,$0C,$06,$FF,$E0,$B8,$05,$A0,$E0,$AE,$AE
                  db $50,$19,$FF,$E0,$B8,$05,$A0,$10,$CE,$AE,$D8,$12,$86,$EB,$B8,$04
                  db $00,$00,$80,$AF,$A3,$02,$FF,$EE,$B8,$03,$F0,$60,$E7,$AE,$B6,$0D
                  db $FF,$E0,$B8,$03,$50,$00,$93,$AF,$01,$02,$FF,$E9,$B8,$01,$E0,$30
                  db $EA,$AE,$1B,$00,$FF,$E0,$B8,$01,$30,$29,$F7,$AD,$9B,$0D,$FF,$E0
                  db $B8,$07,$A0,$70,$ED,$AE,$1B,$00,$FF,$E0,$B8,$00,$D0,$80,$AE,$AF
                  db $D1,$04,$FF,$E0,$B8,$00,$B0,$C0,$C0,$AF,$1B,$00,$FF,$E0,$B8,$00
                  db $50,$60,$D0,$AF,$3F,$1B,$FF,$E0,$B8,$03,$C0,$30,$D8,$AF,$02,$25
                  db $FF,$E0,$B8,$07,$A0,$00,$80,$B0,$1B,$00,$FF,$E0,$B8,$00,$90,$70
                  db $F3,$AF,$3E,$19,$FF,$E9,$B8,$01,$E0,$30,$9F,$B0,$2C,$07,$FF,$E0
                  db $B8,$07,$A0,$70,$B8,$B0,$D5,$03,$FF,$E0,$B8,$04,$20,$A0,$BF,$B0
                  db $71,$13,$FF,$E0,$B8,$05,$20,$80,$C3,$B0,$DA,$04,$FF,$E0,$B8,$07
                  db $A0,$20,$FA,$AF,$72,$0C,$FF,$E0,$B8,$07,$A0,$00,$D7,$B0,$8A,$0F
                  db $FF,$E0,$B8,$01,$50,$80,$E3,$B0,$46,$0E,$FF,$E0,$B8,$07,$A0,$00
                  db $80,$B1,$67,$3E,$FF,$E0,$B8,$05,$40,$50,$8E,$B1,$8A,$0F,$FF,$E0
                  db $B8,$01,$C0,$C0,$CC,$B1,$A3,$0B,$FF,$E0,$B8,$01,$10,$50,$DC,$B1
                  db $A3,$0B,$FF,$E0,$B8,$00,$B0,$00,$E8,$B1,$A3,$0B,$FF,$E0,$B8,$02
                  db $90,$B0,$F3,$B1,$12,$00,$FF,$E0,$B8,$00,$20,$80,$93,$B2,$BC,$07
                  db $FF,$E0,$B8,$01,$10,$30,$9F,$B2,$71,$13,$FF,$E0,$B8,$01,$A0,$00
                  db $80,$B2,$01,$02,$FF,$E9,$B8,$01,$E0,$F0,$A6,$B2,$BC,$07,$FF,$E0
                  db $B8,$01,$00,$30,$AA,$B2,$26,$1F,$FF,$E0,$B8,$01,$E0,$F0,$B1,$B2

AudioSFX_SampleGroupByEffectId: db $00,$00,$00,$05,$00,$00,$00,$00,$00,$00,$00,$00,$0D,$13,$1D,$26;83927F
                  db $00,$00,$00,$00,$10,$23,$23,$00,$00,$24,$0D,$00,$25,$1E,$1E,$27
                  db $21,$14,$0E,$14,$14,$1C,$1F,$14,$11,$0F,$12,$10,$11,$11,$11,$07
                  db $26,$06

AudioInit_DefaultBGMUploadList: db $17,$18,$19,$1A,$15,$06,$0A,$00,$00,$00;8392B1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TextBox_LoadDialogueFrameAndFontGraphics
;
; Loads/decompresses the dialogue box frame/tilemap and transfers the dialogue
; font/graphics into VRAM. This is the visual bootstrap for normal text boxes.
; It uses the generic decompression and programmed DMA helpers.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TextBox_LoadDialogueFrameAndFontGraphics: ;8392BB
        %Set16bit(!MX)
        %Set16bit(!M)
        LDA.W #$CB05
        STA.B $72
        LDA.W #$2000
        STA.B $75
        %Set8bit(!M)
        LDA.B #$A5
        STA.B $74
        LDA.B #$7E
        STA.B $77
        JSL.L DecompressTileMap
        %Set8bit(!M)
        LDA.B #$00
        STA.B !ProgDMA_Channel_Index
        LDA.B #$18
        STA.B !ProgDMA_Destination_Memory
        %Set16bit(!MX)
        LDY.W #$0400
        LDX.W #$7800
        LDA.W #$2000
        STA.B $72
        %Set8bit(!M)
        LDA.B #$7E
        STA.B $74
        %Set16bit(!M)
        LDA.W #$0080
        JSL.L AddProgrammedDMA
        JSL.L StartLastPreparedDMA

        %Set8bit(!M)
        LDA.B #$00
        STA.B !ProgDMA_Channel_Index
        LDA.B #$18
        STA.B !ProgDMA_Destination_Memory
        %Set16bit(!MX)
        LDA.W #$5000
        TAX
        LDY.W #$1000
        LDA.W #$BBA3
        STA.B $72
        %Set8bit(!M)
        LDA.B #$9C
        STA.B $74
        %Set16bit(!M)
        LDA.W #$0080
        JSL.L AddProgrammedDMA
        JSL.L StartLastPreparedDMA

        RTL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TextBox_RestoreDialogueFontDMAAfterClose
;
; Requeues the dialogue font/tiles after a text box closes. The routine also
; removes a programmed DMA channel used by the box while active.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TextBox_RestoreDialogueFontDMAAfterClose: ;83932D
        %Set8bit(!M)
        LDA.B #$06
        STA.B !ProgDMA_Channel_Index
        LDA.B #$18
        STA.B !ProgDMA_Destination_Memory
        %Set16bit(!MX)
        LDA.W #$5000
        TAX
        LDY.W #$0C00
        LDA.W #$BBA3
        STA.B $72
        %Set8bit(!M)
        LDA.B #$9C
        STA.B $74
        %Set16bit(!M)
        LDA.W #$0080
        JSL.L AddProgrammedDMA
        %Set8bit(!M)
        LDA.B #$07
        STA.B !ProgDMA_Channel_Index
        JSL.L RemoveProgrammedDMA

        RTL

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TextBox_StartByTextId
;
; Starts a text box from a text id passed in X. The routine resolves the entry in
; Text_Pointer_Table, stores the text pointer in scratch RAM, initializes cursor
; state at $0183-$019B, scrolls BG3 to reveal the text window, pauses time, and
; marks the active textbox flag.
;
; Input:
;   X = text id / index into Text_Pointer_Table
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TextBox_StartByTextId: ;83935F
        %Set16bit(!MX)
        STX.W $0183
        LDA.W #$5000
        CLC
        ADC.W #$0010
        STA.W $0185
        STZ.W $0187
        %Set8bit(!M)
        LDA.W $019B
        ORA.B #$01
        STA.W $019B
        STZ.W $0189
        STZ.W $018B
        STZ.W $018C
        STZ.W $018E
        STZ.W $018F
        STZ.W $0190
        %Set16bit(!M)
        LDA.W $0183
        ASL A
        CLC
        ADC.W $0183
        TAX
        LDA.L Text_Pointer_Table,X
        STA.B $01
        INX
        INX
        %Set8bit(!M)
        LDA.L Text_Pointer_Table,X
        STA.B $03
        %Set8bit(!M)
        LDA.W $0191
        BNE .Bank83_NpcSpriteLogicBranch_8393C5
        LDA.B #$01
        STA.W $0191
        %Set16bit(!M)
        LDA.W $090D
        CMP.W #$0081
        BCS .Bank83_NpcSpriteLogicBranch_8393C5
        %Set8bit(!M)
        LDA.B #$02
        STA.W $0191

    .Bank83_NpcSpriteLogicBranch_8393C5:
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.W $0191
        DEC A
        %Set16bit(!MX)
        ASL A
        ASL A
        ASL A
        ASL A
        ASL A
        ASL A
        ASL A
        STA.B $7E
        LDA.W !BG3_Map_Offset_Y
        SEC
        SBC.W #$0100
        SEC
        SBC.B $7E
        STA.W !BG3_Map_Offset_Y
        %Set8bit(!M)
        STZ.W !time_running
        %Set16bit(!M)
        LDA.L $7F1F5A
        ORA.W #$4000                         ;FLAG5A
        STA.L $7F1F5A

        RTL


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TextBox_CloseAndRestoreScrollAndTime
;
; Closes the current text box, restores BG3 scroll, reloads dialogue graphics,
; and resumes time when the caller allows it.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          TextBox_CloseAndRestoreScrollAndTime: %Set8bit(!M)                             ;8393F9;      ;
                       %Set16bit(!X)                             ;8393FB;      ;
                       STZ.W $019B                          ;8393FD;00019B;
                       %Set8bit(!M)                             ;839400;      ;
                       LDA.B #$00                           ;839402;      ;
                       XBA                                  ;839404;      ;
                       LDA.W $0191                          ;839405;000191;
                       DEC A                                ;839408;      ;
                       %Set16bit(!M)                             ;839409;      ;
                       ASL A                                ;83940B;      ;
                       ASL A                                ;83940C;      ;
                       ASL A                                ;83940D;      ;
                       ASL A                                ;83940E;      ;
                       ASL A                                ;83940F;      ;
                       ASL A                                ;839410;      ;
                       ASL A                                ;839411;      ;
                       STA.B $7E                            ;839412;00007E;
                       LDA.W !BG3_Map_Offset_Y                          ;839414;000146;
                       CLC                                  ;839417;      ;
                       ADC.W #$0100                         ;839418;      ;
                       CLC                                  ;83941B;      ;
                       ADC.B $7E                            ;83941C;00007E;
                       STA.W !BG3_Map_Offset_Y                          ;83941E;000146;
                       JSL.L TextBox_RestoreDialogueFontDMAAfterClose                    ;839421;83932D;
                       %Set16bit(!M)                             ;839425;      ;
                       LDA.W $0196                          ;839427;000196;
                       AND.W #$0020                         ;83942A;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_839439                      ;83942D;839439;
                       %Set8bit(!M)                             ;83942F;      ;
                       LDA.W !time_running                          ;839431;000973;
                       ORA.B #$01                           ;839434;      ;
                       STA.W !time_running                          ;839436;000973;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_839439: %Set16bit(!M)                             ;839439;      ;
                       LDA.L $7F1F5A                        ;83943B;7F1F5A;
                       AND.W #$BFFF                         ;FLAG5A
                       STA.L $7F1F5A                        ;839442;7F1F5A;
                       RTL                                  ;839446;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TextBox_UpdatePromptCursorLong
;
; Long-call wrapper for the blinking prompt/cursor animation.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          TextBox_UpdatePromptCursorLong: %Set16bit(!MX)                             ;839447;      ;
                       JSR.W TextBox_UpdatePromptCursor                    ;839449;839495;
                       RTL                                  ;83944C;      ;
                                                            ;      ;      ;
                       db $10,$50,$70,$51,$50,$53,$70,$50,$50,$52,$A0,$21,$A1,$21,$B0,$21;83944D;      ;
                       db $B1,$21,$A2,$21,$A3,$21,$B2,$21,$B3,$21;83945D;      ;
                                                            ;      ;      ;
         TextBox_PromptAcceptSelectionTextIdTable: db $0F,$00,$10,$00,$11,$00,$12,$00,$13,$00,$14,$00,$15,$00,$16,$00;839467;      ;
                       db $17,$00,$18,$00,$19,$00           ;839477;      ;
                                                            ;      ;      ;
         TextBox_PromptCursorVRAMDestinationTable: db $88,$70,$C8,$70,$08,$71,$48,$71,$88,$71,$C8,$71,$08,$72,$48,$72;83947D;      ;
                       db $88,$72,$C8,$72,$08,$73,$90,$70   ;83948D;      ;
                                                            ;      ;      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TextBox_UpdatePromptCursor
;
; Handles blinking cursor/prompt timing. The high bit in $018B selects which
; prompt glyph/tile is queued. The low bits behave like a small frame counter.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          TextBox_UpdatePromptCursor: %Set16bit(!MX)                             ;839495;      ;
                       STA.B $7E                            ;839497;00007E;
                       LDA.W $018B                          ;839499;00018B;
                       AND.W #$007F                         ;83949C;      ;
                       CMP.W #$0014                         ;83949F;      ;
                       BNE Bank83_NpcSpriteLogicBranch_8394B0                      ;8394A2;8394B0;
                       %Set8bit(!M)                             ;8394A4;      ;
                       LDA.W $018B                          ;8394A6;00018B;
                       AND.B #$80                           ;8394A9;      ;
                       EOR.B #$80                           ;8394AB;      ;
                       STA.W $018B                          ;8394AD;00018B;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_8394B0: %Set8bit(!M)                             ;8394B0;      ;
                       LDA.W $018B                          ;8394B2;00018B;
                       AND.B #$80                           ;8394B5;      ;
                       BNE Bank83_NpcSpriteLogicBranch_8394C4                      ;8394B7;8394C4;
                       %Set16bit(!M)                             ;8394B9;      ;
                       LDA.W #$0000                         ;8394BB;      ;
                       JSL.L TextBox_QueuePromptCursorTileDMA                    ;8394BE;8394D7;
                       BRA Bank83_NpcSpriteLogicBranch_8394CD                      ;8394C2;8394CD;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_8394C4: %Set16bit(!M)                             ;8394C4;      ;
                       LDA.W #$0001                         ;8394C6;      ;
                       JSL.L TextBox_QueuePromptCursorTileDMA                    ;8394C9;8394D7;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_8394CD: %Set8bit(!M)                             ;8394CD;      ;
                       LDA.W $018B                          ;8394CF;00018B;
                       INC A                                ;8394D2;      ;
                       STA.W $018B                          ;8394D3;00018B;
                       RTS                                  ;8394D6;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TextBox_QueuePromptCursorTileDMA
;
; Queues the tile graphics used by the blinking prompt/cursor into the correct
; text box VRAM location.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
          TextBox_QueuePromptCursorTileDMA: %Set16bit(!MX)                             ;8394D7;      ;
                       PHA                                  ;8394D9;      ;
                       %Set8bit(!M)                             ;8394DA;      ;
                       %Set16bit(!X)                             ;8394DC;      ;
                       LDA.B #$00                           ;8394DE;      ;
                       XBA                                  ;8394E0;      ;
                       LDA.W $018A                          ;8394E1;00018A;
                       CMP.B #$0B                           ;8394E4;      ;
                       BCC Bank83_NpcSpriteLogicBranch_8394EA                      ;8394E6;8394EA;
                       LDA.B #$0B                           ;8394E8;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_8394EA: %Set16bit(!M)                             ;8394EA;      ;
                       ASL A                                ;8394EC;      ;
                       TAX                                  ;8394ED;      ;
                       LDA.L TextBox_PromptCursorVRAMDestinationTable,X                 ;8394EE;83947D;
                       TAX                                  ;8394F2;      ;
                       %Set16bit(!M)                             ;8394F3;      ;
                       PLA                                  ;8394F5;      ;
                       CMP.W #$0001                         ;8394F6;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83950A                      ;8394F9;83950A;
                       %Set16bit(!M)                             ;8394FB;      ;
                       LDA.W #$9457                         ;8394FD;      ;
                       STA.B $72                            ;839500;000072;
                       %Set8bit(!M)                             ;839502;      ;
                       LDA.B #$83                           ;839504;      ;
                       STA.B $74                            ;839506;000074;
                       BRA Bank83_NpcSpriteLogicBranch_839517                      ;839508;839517;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83950A: %Set16bit(!M)                             ;83950A;      ;
                       LDA.W #$945F                         ;83950C;      ;
                       STA.B $72                            ;83950F;000072;
                       %Set8bit(!M)                             ;839511;      ;
                       LDA.B #$83                           ;839513;      ;
                       STA.B $74                            ;839515;000074;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_839517: JSL.L TextBoxDMA_QueuePromptCursorPatternPair                    ;839517;8381B7;
                       RTL                                  ;83951B;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TextBox_UpdateRendererAndControlCodes
;
; Main per-frame text renderer. Reads 16-bit text tokens through the pointer in
; $01/$03, handles control codes, queues glyph DMA, advances VRAM position, and
; sets state flags for wait/end/choice behavior.
;
; Important control codes observed in this routine:
;   $00A2 = move/special prompt glyph path
;   $00B1 = line/spacing token path
;   $FFFC = numeric variable insertion
;   $FFFD = name/string insertion
;   $FFFE = choice/prompt setup
;   $FFFF = end/wait flag
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TextBox_UpdateRendererAndControlCodes: ;83951C
        %Set8bit(!M)                             ;      ;
        %Set16bit(!X)                             ;83951E;      ;
        LDA.W $019B                          ;839520;00019B;
        AND.B #$20                           ;839523;      ;
        BEQ .Bank83_NpcSpriteLogicBranch_83952A                      ;839525;83952A;
        JMP.W TextBox_UpdatePromptCursorLong                    ;839527;839447;

    .Bank83_NpcSpriteLogicBranch_83952A:
        LDA.W $019B                          ;83952A;00019B;
        AND.B #$01                           ;83952D;      ;
        BNE .Bank83_NpcSpriteLogicBranch_839534                      ;83952F;839534;
        JMP.W .return                        ;839531;8395F0;

    .Bank83_NpcSpriteLogicBranch_839534:
        %Set8bit(!M)                             ;839534;      ;
        LDA.W $019B                          ;839536;00019B;
        AND.B #$FD                           ;839539;      ;
        STA.W $019B                          ;83953B;00019B;
        %Set16bit(!M)                             ;83953E;      ;
        LDA.W $0187                          ;839540;000187;
        ASL A                                ;839543;      ;
        TAY                                  ;839544;      ;
        LDA.B [$01],Y                        ;839545;000001;
        CMP.W #$00A2                         ;839547;      ;
        BNE .Bank83_NpcSpriteLogicBranch_83954F                      ;83954A;83954F;
        JMP.W .Bank83_NpcSpriteLogicBranch_8395F1                    ;83954C;8395F1;

    .Bank83_NpcSpriteLogicBranch_83954F:
        CMP.W #$00B1                         ;83954F;      ;
        BNE .Bank83_NpcSpriteLogicBranch_839557                      ;839552;839557;
        JMP.W .Bank83_NpcSpriteLogicBranch_83960D                    ;839554;83960D;

    .Bank83_NpcSpriteLogicBranch_839557:
        CMP.W #$FFFC                         ;839557;      ;
        BNE .Bank83_NpcSpriteLogicBranch_83955F                      ;83955A;83955F;
        JMP.W .Bank83_NpcSpriteLogicBranch_839621                    ;83955C;839621;

    .Bank83_NpcSpriteLogicBranch_83955F:
        CMP.W #$FFFE                         ;83955F;      ;
        BNE .Bank83_NpcSpriteLogicBranch_839567                      ;839562;839567;
        JMP.W .Bank83_NpcSpriteLogicBranch_839719                    ;839564;839719;

    .Bank83_NpcSpriteLogicBranch_839567:
        CMP.W #$FFFF                         ;839567;      ;
        BNE .Bank83_NpcSpriteLogicBranch_83956F                      ;83956A;83956F;
        JMP.W .Bank83_NpcSpriteLogicBranch_839752                    ;83956C;839752;

    .Bank83_NpcSpriteLogicBranch_83956F:
        %Set8bit(!M)                             ;83956F;      ;
        LDA.W $0189                          ;839571;000189;
        CMP.B #$04                           ;839574;      ;
        BNE .Bank83_NpcSpriteLogicBranch_8395E7                      ;839576;8395E7;
        STZ.W $0189                          ;839578;000189;
        %Set16bit(!M)                             ;83957B;      ;
        LDA.B [$01],Y                        ;83957D;000001;
        CMP.W #$FFFD                         ;83957F;      ;
        BNE .Bank83_NpcSpriteLogicBranch_839587                      ;839582;839587;
        JMP.W .Bank83_NpcSpriteLogicBranch_8396A1                    ;839584;8396A1;

    .Bank83_NpcSpriteLogicBranch_839587:
        %Set16bit(!MX)                             ;839587;      ;
        LDA.B [$01],Y                        ;839589;000001;
        %Set8bit(!X)                             ;83958B;      ;
        LDX.B #$01                           ;83958D;      ;
        CMP.W #$00BC                         ;83958F;      ;
        BCC .Bank83_NpcSpriteLogicBranch_83959D                      ;839592;83959D;
        CMP.W #$00C6                         ;839594;      ;
        BCS .Bank83_NpcSpriteLogicBranch_83959D                      ;839597;83959D;
        LDX.B #$00                           ;839599;      ;
        BRA .Bank83_NpcSpriteLogicBranch_8395A4                      ;83959B;8395A4;

    .Bank83_NpcSpriteLogicBranch_83959D:
        CMP.W #$0270                         ;83959D;      ;
        BNE .Bank83_NpcSpriteLogicBranch_8395A4                      ;8395A0;8395A4;
        LDX.B #$00                           ;8395A2;      ;

    .Bank83_NpcSpriteLogicBranch_8395A4:
        STX.W $0190                          ;8395A4;000190;
        JSL.L TextBox_QueueGlyphDMA                    ;8395A7;839823;
        %Set8bit(!M)                             ;8395AB;      ;
        %Set16bit(!X)                             ;8395AD;      ;
        LDA.B #$03                           ;8395AF;      ;
        STA.W $0114                          ;8395B1;000114;
        LDA.B #$06                           ;8395B4;      ;
        STA.W $0115                          ;8395B6;000115;
        JSL.L AudioSFX_PlayQueuedEffectDefaultVolume                    ;8395B9;838332;
        %Set8bit(!M)                             ;8395BD;      ;
        LDA.W $019B                          ;8395BF;00019B;
        ORA.B #$02                           ;8395C2;      ;
        STA.W $019B                          ;8395C4;00019B;
        %Set16bit(!MX)                             ;8395C7;      ;

    .Bank83_NpcSpriteLogicBranch_8395C9:
        %Set8bit(!M)                             ;8395C9;      ;
        LDA.W $018C                          ;8395CB;00018C;
        BNE .Bank83_NpcSpriteLogicBranch_8395D9                      ;8395CE;8395D9;
        %Set16bit(!M)                             ;8395D0;      ;
        LDA.W $0187                          ;8395D2;000187;
        INC A                                ;8395D5;      ;
        STA.W $0187                          ;8395D6;000187;

    .Bank83_NpcSpriteLogicBranch_8395D9:
        %Set8bit(!M)                             ;8395D9;      ;
        LDA.B #$00                           ;8395DB;      ;
        XBA                                  ;8395DD;      ;
        LDA.W $0190                          ;8395DE;000190;
        %Set16bit(!MX)                             ;8395E1;      ;
        TAX                                  ;8395E3;      ;
        JSR.W TextBox_AdvanceVRAMCursor                    ;8395E4;839838;

    .Bank83_NpcSpriteLogicBranch_8395E7:
        %Set8bit(!M)                             ;8395E7;      ;
        LDA.W $0189                          ;8395E9;000189;
        INC A                                ;8395EC;      ;
        STA.W $0189                          ;8395ED;000189;

    .return: RTL                                  ;8395F0;      ;END_BCCCC

    .Bank83_NpcSpriteLogicBranch_8395F1:
        %Set8bit(!M)                             ;8395F1;      ;
        LDA.W $019B                          ;8395F3;00019B;
        ORA.B #$08                           ;8395F6;      ;
        STA.W $019B                          ;8395F8;00019B;
        %Set16bit(!M)                             ;8395FB;      ;
        LDA.W #$5528                         ;8395FD;      ;
        STA.W $0185                          ;839600;000185;
        %Set16bit(!M)                             ;839603;      ;
        LDA.W #$00A2                         ;839605;      ;
        JSR.W TextBox_DrawBlinkingPromptGlyph                    ;839608;83975F;
        BRA $E3                                 ;      ;      ;

    .Bank83_NpcSpriteLogicBranch_83960D:
        %Set16bit(!M)                             ;83960D;      ;
        LDA.W $0187                          ;83960F;000187;
        INC A                                ;839612;      ;
        STA.W $0187                          ;839613;000187;
        %Set16bit(!MX)                             ;839616;      ;
        LDX.W #$0001                         ;839618;      ;
        JSR.W TextBox_AdvanceVRAMCursor                    ;83961B;839838;
        JMP.W .Bank83_NpcSpriteLogicBranch_839534                    ;83961E;839534;

    .Bank83_NpcSpriteLogicBranch_839621:
        %Set8bit(!M)                             ;839621;      ;
        LDA.W $018C                          ;839623;00018C;
        BNE .Bank83_NpcSpriteLogicBranch_83967A                      ;839626;83967A;
        %Set16bit(!M)                             ;839628;      ;
        LDA.W $0187                          ;83962A;000187;
        ASL A                                ;83962D;      ;
        TAY                                  ;83962E;      ;
        INY                                  ;83962F;      ;
        INY                                  ;839630;      ;
        %Set8bit(!M)                             ;839631;      ;
        LDA.B [$01],Y                        ;839633;000001;
        STA.W $018C                          ;839635;00018C;
        %Set16bit(!M)                             ;839638;      ;
        INY                                  ;83963A;      ;
        INY                                  ;83963B;      ;
        LDA.B [$01],Y                        ;83963C;000001;
        DEC A                                ;83963E;      ;
        ASL A                                ;83963F;      ;
        ASL A                                ;839640;      ;
        TAX                                  ;839641;      ;
        LDA.L TextBox_NumberVariablePointerTable,X                 ;839642;8398EE;
        STA.B $72                            ;839646;000072;
        INX                                  ;839648;      ;
        INX                                  ;839649;      ;
        %Set8bit(!M)                             ;83964A;      ;
        LDA.L TextBox_NumberVariablePointerTable,X                 ;83964C;8398EE;
        STA.B $74                            ;839650;000074;
        STZ.W $0192                          ;839652;000192;
        STZ.W $0193                          ;839655;000193;
        STZ.W $0194                          ;839658;000194;
        LDA.W $019B                          ;83965B;00019B;
        AND.B #$7F                           ;83965E;      ;
        STA.W $019B                          ;839660;00019B;
        INX                                  ;839663;      ;
        LDA.L TextBox_NumberVariablePointerTable,X                 ;839664;8398EE;
        LDY.W #$0000                         ;839668;      ;
        LDX.W #$0000                         ;83966B;      ;

    .Bank83_NpcSpriteLogicBranch_83966E:
            PHA                                  ;83966E;      ;
            LDA.B [$72],Y                        ;83966F;000072;
            STA.W $0192,X                        ;839671;000192;
            INY                                  ;839674;      ;
            INX                                  ;839675;      ;
            PLA                                  ;839676;      ;
            DEC A                                ;839677;      ;
            BNE .Bank83_NpcSpriteLogicBranch_83966E                      ;839678;83966E;

    .Bank83_NpcSpriteLogicBranch_83967A:
        %Set8bit(!M)                             ;83967A;      ;
        LDA.W $018C                          ;83967C;00018C;
        DEC A                                ;83967F;      ;
        STA.W $018C                          ;839680;00018C;
        JSL.L TextBox_RenderNumberToken                    ;839683;8397A6;
        %Set8bit(!M)                             ;839687;      ;
        STZ.W $0190                          ;839689;000190;
        %Set8bit(!M)                             ;83968C;      ;
        STZ.W $0189                          ;83968E;000189;
        LDA.W $018C                          ;839691;00018C;
        BNE .Bank83_NpcSpriteLogicBranch_83969E                      ;839694;83969E;
        LDA.W $0187                          ;839696;000187;
        INC A                                ;839699;      ;
        INC A                                ;83969A;      ;
        STA.W $0187                          ;83969B;000187;

    .Bank83_NpcSpriteLogicBranch_83969E:
        JMP.W .Bank83_NpcSpriteLogicBranch_8395C9                    ;83969E;8395C9;

    .Bank83_NpcSpriteLogicBranch_8396A1:
        %Set8bit(!M)                             ;8396A1;      ;
        LDA.W $018C                          ;8396A3;00018C;
        BNE .Bank83_NpcSpriteLogicBranch_8396BC                      ;8396A6;8396BC;
        %Set16bit(!M)                             ;8396A8;      ;
        LDA.W $0187                          ;8396AA;000187;
        ASL A                                ;8396AD;      ;
        TAY                                  ;8396AE;      ;
        INY                                  ;8396AF;      ;
        INY                                  ;8396B0;      ;
        %Set8bit(!M)                             ;8396B1;      ;
        LDA.B [$01],Y                        ;8396B3;000001;
        STA.W $018C                          ;8396B5;00018C;
        DEC A                                ;8396B8;      ;
        STA.W $018D                          ;8396B9;00018D;

    .Bank83_NpcSpriteLogicBranch_8396BC:
        %Set16bit(!M)                             ;8396BC;      ;
        LDA.W $0187                          ;8396BE;000187;
        ASL A                                ;8396C1;      ;
        CLC                                  ;8396C2;      ;
        ADC.W #$0004                         ;8396C3;      ;
        TAY                                  ;8396C6;      ;
        LDA.B [$01],Y                        ;8396C7;000001;
        DEC A                                ;8396C9;      ;
        ASL A                                ;8396CA;      ;
        ASL A                                ;8396CB;      ;
        TAX                                  ;8396CC;      ;
        LDA.L TextBox_NameVariablePointerTable,X                 ;8396CD;839AAE;
        STA.B $72                            ;8396D1;000072;
        INX                                  ;8396D3;      ;
        INX                                  ;8396D4;      ;
        %Set8bit(!M)                             ;8396D5;      ;
        LDA.L TextBox_NameVariablePointerTable,X                 ;8396D7;839AAE;
        STA.B $74                            ;8396DB;000074;
        %Set8bit(!M)                             ;8396DD;      ;
        LDA.W $018C                          ;8396DF;00018C;
        DEC A                                ;8396E2;      ;
        STA.W $018C                          ;8396E3;00018C;
        LDA.B #$00                           ;8396E6;      ;
        XBA                                  ;8396E8;      ;
        LDA.W $018D                          ;8396E9;00018D;
        SEC                                  ;8396EC;      ;
        SBC.W $018C                          ;8396ED;00018C;
        %Set16bit(!MX)                             ;8396F0;      ;
        ASL A                                ;8396F2;      ;
        TAY                                  ;8396F3;      ;
        LDA.B [$72],Y                        ;8396F4;000072;
        LDX.W #$0001                         ;8396F6;      ;
        JSL.L TextBox_QueueGlyphDMA                    ;8396F9;839823;
        %Set8bit(!M)                             ;8396FD;      ;
        LDA.B #$01                           ;8396FF;      ;
        STA.W $0190                          ;839701;000190;
        %Set8bit(!M)                             ;839704;      ;
        STZ.W $0189                          ;839706;000189;
        LDA.W $018C                          ;839709;00018C;
        BNE .Bank83_NpcSpriteLogicBranch_839716                      ;83970C;839716;
        LDA.W $0187                          ;83970E;000187;
        INC A                                ;839711;      ;
        INC A                                ;839712;      ;
        STA.W $0187                          ;839713;000187;

    .Bank83_NpcSpriteLogicBranch_839716:
        JMP.W .Bank83_NpcSpriteLogicBranch_8395C9                    ;839716;8395C9;

    .Bank83_NpcSpriteLogicBranch_839719:
        %Set8bit(!M)                             ;839719;      ;
        LDA.W $019B                          ;83971B;00019B;
        ORA.B #$10                           ;83971E;      ;
        STA.W $019B                          ;839720;00019B;
        %Set16bit(!M)                             ;839723;      ;
        LDA.W $0187                          ;839725;000187;
        ASL A                                ;839728;      ;
        TAY                                  ;839729;      ;
        INY                                  ;83972A;      ;
        INY                                  ;83972B;      ;
        %Set8bit(!M)                             ;83972C;      ;
        LDA.B [$01],Y                        ;83972E;000001;
        DEC A                                ;839730;      ;
        STA.W $018E                          ;839731;00018E;
        %Set8bit(!M)                             ;839734;      ;
        LDA.B #$00                           ;839736;      ;
        XBA                                  ;839738;      ;
        LDA.W $018F                          ;839739;00018F;
        ASL A                                ;83973C;      ;
        TAX                                  ;83973D;      ;
        %Set16bit(!M)                             ;83973E;      ;
        LDA.L TextBox_ChoiceCursorVRAMAddressTable,X                 ;839740;8398CC;
        STA.W $0185                          ;839744;000185;
        %Set16bit(!M)                             ;839747;      ;
        LDA.W #$0275                         ;839749;      ;
        JSR.W TextBox_DrawBlinkingPromptGlyph                    ;83974C;83975F;
        JMP.W .return                        ;83974F;8395F0;

    .Bank83_NpcSpriteLogicBranch_839752:
        %Set8bit(!M)                             ;839752;      ;
        LDA.W $019B                          ;839754;00019B;
        ORA.B #$04                           ;839757;      ;
        STA.W $019B                          ;839759;00019B;
        JMP.W .return                        ;83975C;8395F0;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TextBox_DrawBlinkingPromptGlyph
;
; Draws/queues a blinking prompt glyph. It alternates between the requested
; token and $00B1 based on the $018B blink counter.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TextBox_DrawBlinkingPromptGlyph: ;83975F
        %Set16bit(!M)                             ;      ;
        STA.B $7E                            ;839761;00007E;
        LDA.W $018B                          ;839763;00018B;
        AND.W #$007F                         ;839766;      ;
        CMP.W #$0014                         ;839769;      ;
        BNE .Bank83_NpcSpriteLogicBranch_83977A                      ;83976C;83977A;
        %Set8bit(!M)                             ;83976E;      ;
        LDA.W $018B                          ;839770;00018B;
        AND.B #$80                           ;839773;      ;
        EOR.B #$80                           ;839775;      ;
        STA.W $018B                          ;839777;00018B;

    .Bank83_NpcSpriteLogicBranch_83977A:
        %Set8bit(!M)                             ;83977A;      ;
        LDA.W $018B                          ;83977C;00018B;
        AND.B #$80                           ;83977F;      ;
        BNE .Bank83_NpcSpriteLogicBranch_839790                      ;839781;839790;
        %Set16bit(!MX)                             ;839783;      ;
        LDX.W #$0001                         ;839785;      ;
        LDA.B $7E                            ;839788;00007E;
        JSL.L TextBox_QueueGlyphDMA                    ;83978A;839823;
        BRA .Bank83_NpcSpriteLogicBranch_83979C                      ;83978E;83979C;

    .Bank83_NpcSpriteLogicBranch_839790:
        %Set16bit(!MX)                             ;839790;      ;
        LDX.W #$0001                         ;839792;      ;
        LDA.W #$00B1                         ;839795;      ;
        JSL.L TextBox_QueueGlyphDMA                    ;839798;839823;

    .Bank83_NpcSpriteLogicBranch_83979C:
        %Set8bit(!M)                             ;83979C;      ;
        LDA.W $018B                          ;83979E;00018B;
        INC A                                ;8397A1;      ;
        STA.W $018B                          ;8397A2;00018B;

        RTS                                  ;8397A5;      ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TextBox_RenderNumberToken
;
; Converts an inserted numeric variable to visible decimal glyphs using the
; place-value table below. Used by the $FFFC control code path.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TextBox_RenderNumberToken: ;8397A6
        %Set8bit(!M)                             ;      ;
        %Set16bit(!X)                             ;8397A8;      ;
        LDA.B #$00                           ;8397AA;      ;
        XBA                                  ;8397AC;      ;
        LDA.W $018C                          ;8397AD;00018C;
        ASL A                                ;8397B0;      ;
        CLC                                  ;8397B1;      ;
        ADC.W $018C                          ;8397B2;00018C;
        %Set16bit(!M)                             ;8397B5;      ;
        TAX                                  ;8397B7;      ;
        LDA.L TextBox_NumberPlaceValueTable,X                 ;8397B8;8398D6;
        STA.B $7E                            ;8397BC;00007E;
        INX                                  ;8397BE;      ;
        INX                                  ;8397BF;      ;
        %Set8bit(!M)                             ;8397C0;      ;
        LDA.L TextBox_NumberPlaceValueTable,X                 ;8397C2;8398D6;
        STA.B $80                            ;8397C6;000080;
        LDX.W #$0000                         ;8397C8;      ;

    .Bank83_NpcSpriteLogicBranch_8397CB:
            %Set16bit(!M)                             ;8397CB;      ;
            LDA.W $0192                          ;8397CD;000192;
            SEC                                  ;8397D0;      ;
            SBC.B $7E                            ;8397D1;00007E;
            STA.W $0192                          ;8397D3;000192;
            %Set8bit(!M)                             ;8397D6;      ;
            LDA.W $0194                          ;8397D8;000194;
            SBC.B $80                            ;8397DB;000080;
            STA.W $0194                          ;8397DD;000194;
            BMI .Bank83_NpcSpriteLogicBranch_8397E5                      ;8397E0;8397E5;
            INX                                  ;8397E2;      ;
            BRA .Bank83_NpcSpriteLogicBranch_8397CB                      ;8397E3;8397CB;

    .Bank83_NpcSpriteLogicBranch_8397E5:
        %Set16bit(!M)                             ;8397E5;      ;
        LDA.W $0192                          ;8397E7;000192;
        CLC                                  ;8397EA;      ;
        ADC.B $7E                            ;8397EB;00007E;
        STA.W $0192                          ;8397ED;000192;
        %Set8bit(!M)                             ;8397F0;      ;
        LDA.W $0194                          ;8397F2;000194;
        ADC.B $80                            ;8397F5;000080;
        STA.W $0194                          ;8397F7;000194;
        %Set8bit(!M)                             ;8397FA;      ;
        LDA.W $019B                          ;8397FC;00019B;
        AND.B #$80                           ;8397FF;      ;
        BNE .Bank83_NpcSpriteLogicBranch_839810                      ;839801;839810;
        CPX.W #$0000                         ;839803;      ;
        BEQ .return                      ;839806;839822;
        LDA.W $019B                          ;839808;00019B;
        ORA.B #$80                           ;83980B;      ;
        STA.W $019B                          ;83980D;00019B;

    .Bank83_NpcSpriteLogicBranch_839810:
        %Set16bit(!MX)                             ;839810;      ;
        TXA                                  ;839812;      ;
        STA.B $7E                            ;839813;00007E;
        LDA.W #$00BC                         ;839815;      ;
        CLC                                  ;839818;      ;
        ADC.B $7E                            ;839819;00007E;
        LDX.W #$0000                         ;83981B;      ;
        JSL.L TextBox_QueueGlyphDMA                    ;83981E;839823;

    .return: RTL                                  ;839822;      ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TextBox_QueueGlyphDMA
;
; Resolves a glyph graphics pointer and queues a DMA upload for one rendered
; glyph into the current text VRAM cursor position.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TextBox_QueueGlyphDMA: ;839823
        %Set16bit(!MX)                             ;      ;
        LDX.W #$0000                         ;839825;      ;
        PHX                                  ;839828;      ;
        JSR.W TextBox_GetGlyphGraphicsPointer                    ;839829;839862;
        %Set16bit(!MX)                             ;83982C;      ;
        PLX                                  ;83982E;      ;
        TXA                                  ;83982F;      ;
        LDX.W $0185                          ;839830;000185;
        JSL.L TextBoxDMA_QueueGlyphPatternPair                ;839833;838166;

        RTL                                  ;839837;      ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TextBox_AdvanceVRAMCursor
;
; Advances the text VRAM cursor after writing a glyph. Handles wrapping over the
; $80 boundary used by the dialogue tilemap layout.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TextBox_AdvanceVRAMCursor: ;839838
        %Set16bit(!MX)                             ;      ;
        LDX.W #$0000                         ;83983A;      ;
        TXA                                  ;83983D;      ;
        ASL A                                ;83983E;      ;
        ASL A                                ;83983F;      ;
        ASL A                                ;839840;      ;
        ADC.W #$0008                         ;839841;      ;
        STA.B $80                            ;839844;000080;
        LDA.W $0185                          ;839846;000185;
        CLC                                  ;839849;      ;
        ADC.B $80                            ;83984A;000080;
        STA.W $0185                          ;83984C;000185;
        AND.W #$00FF                         ;83984F;      ;
        CMP.W #$0080                         ;839852;      ;
        BNE .return                      ;839855;839861;
        LDA.W $0185                          ;839857;000185;
        CLC                                  ;83985A;      ;
        ADC.W #$0080                         ;83985B;      ;
        STA.W $0185                          ;83985E;000185;

    .return: RTS                                  ;839861;      ;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TextBox_GetGlyphGraphicsPointer
;
; Converts a glyph/token id into a graphics source pointer. It selects a bank
; table entry, then computes the tile offset inside that graphics block.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
TextBox_GetGlyphGraphicsPointer: ;839862
        %Set16bit(!MX)                             ;      ;
        STA.B $7E                            ;839864;00007E;
        LSR A                                ;839866;      ;
        LSR A                                ;839867;      ;
        LSR A                                ;839868;      ;
        LSR A                                ;839869;      ;
        LSR A                                ;83986A;      ;
        LSR A                                ;83986B;      ;
        STA.B $80                            ;83986C;000080;
        ASL A                                ;83986E;      ;
        CLC                                  ;83986F;      ;
        ADC.B $80                            ;839870;000080;
        TAX                                  ;839872;      ;
        LDA.L TextBox_GlyphGraphicsBankPointerTable,X                 ;839873;8398AE;
        STA.B $72                            ;839877;000072;
        INX                                  ;839879;      ;
        INX                                  ;83987A;      ;
        %Set8bit(!M)                             ;83987B;      ;
        LDA.L TextBox_GlyphGraphicsBankPointerTable,X                 ;83987D;8398AE;
        STA.B $74                            ;839881;000074;
        %Set16bit(!M)                             ;839883;      ;
        LDA.B $7E                            ;839885;00007E;
        AND.W #$003F                         ;839887;      ;
        LSR A                                ;83988A;      ;
        LSR A                                ;83988B;      ;
        LSR A                                ;83988C;      ;
        ASL A                                ;83988D;      ;
        ASL A                                ;83988E;      ;
        ASL A                                ;83988F;      ;
        ASL A                                ;839890;      ;
        ASL A                                ;839891;      ;
        ASL A                                ;839892;      ;
        ASL A                                ;839893;      ;
        ASL A                                ;839894;      ;
        ASL A                                ;839895;      ;
        STA.B $80                            ;839896;000080;
        LDA.B $7E                            ;839898;00007E;
        AND.W #$0007                         ;83989A;      ;
        ASL A                                ;83989D;      ;
        ASL A                                ;83989E;      ;
        ASL A                                ;83989F;      ;
        ASL A                                ;8398A0;      ;
        ASL A                                ;8398A1;      ;
        STA.B $7E                            ;8398A2;00007E;
        LDA.B $72                            ;8398A4;000072;
        CLC                                  ;8398A6;      ;
        ADC.B $7E                            ;8398A7;00007E;
        ADC.B $80                            ;8398A9;000080;
        STA.B $72                            ;8398AB;000072;

        RTS                                  ;8398AD;      ;


; TextBox_GlyphGraphicsBankPointerTable
; Pointers to the glyph graphics blocks used by the text renderer.
         TextBox_GlyphGraphicsBankPointerTable: db $43,$98,$94,$43,$A8,$94,$43,$B8,$94,$43,$C8,$94,$43,$D8,$94,$43;8398AE;      ;
                       db $E8,$94,$00,$80,$95,$00,$90,$95,$00,$A0,$95,$00,$B0,$95;8398BE;      ;
                                                            ;      ;      ;
; TextBox_ChoiceCursorVRAMAddressTable
; VRAM cursor destinations used by choice/prompt rendering.
         TextBox_ChoiceCursorVRAMAddressTable: db $10,$50,$70,$51,$50,$53,$08,$51,$68,$52;8398CC;      ;
                                                            ;      ;      ;
; TextBox_NumberPlaceValueTable
; Decimal place values used by TextBox_RenderNumberToken.
         TextBox_NumberPlaceValueTable: db $01,$00,$00,$0A,$00,$00,$64,$00,$00,$E8,$03,$00,$10,$27,$00,$A0;8398D6;      ;
                       db $86,$01,$40,$42,$0F,$80,$96,$98   ;8398E6;      ;


; TextBox_NumberVariablePointerTable
; Entries are long pointer + byte length. $FFFC text control codes select from
; this table to insert numeric values such as money, date/time, feed, wood, etc.
TextBox_NumberVariablePointerTable: ;8398EE
        dl $7F1F04                           ;8398EE;7F1F04;
        db $03                               ;8398F1;      ;
        dl $7F1F0A                           ;8398F2;7F1F0A;
        db $01                               ;8398F5;      ;
        dl $7F1F0B                           ;8398F6;7F1F0B;
        db $01                               ;8398F9;      ;
        dl $7F1F0E                           ;8398FA;7F1F0E;
        db $02                               ;8398FD;      ;
        dl $7F1F0C                           ;8398FE;7F1F0C;
        db $02                               ;839901;      ;
        dl $7F1F10                           ;839902;7F1F10;
        db $02                               ;839905;      ;
        dl $7F1F12                           ;839906;7F1F12;
        db $01                               ;839909;      ;
        dl $7F1F04                           ;83990A;7F1F04;
        db $03                               ;83990D;      ;
        dl $7F1F04                           ;83990E;7F1F04;
        db $03                               ;839911;      ;
        dl $7F1F04                           ;839912;7F1F04;
        db $03                               ;839915;      ;
        dl $7F1F1B                           ;839916;7F1F1B;
        db $01                               ;839919;      ;
        dl $7F1F1B                           ;83991A;7F1F1B;
        db $01                               ;83991D;      ;
        dl $7F1F1B                           ;83991E;7F1F1B;
        db $01                               ;839921;      ;
        dl $7F1F04                           ;839922;7F1F04;
        db $03                               ;839925;      ;
        dl $7F1F04                           ;839926;7F1F04;
        db $03                               ;839929;      ;
        dl $7F1F04                           ;83992A;7F1F04;
        db $03                               ;83992D;      ;
        dl $7F1F04                           ;83992E;7F1F04;
        db $03                               ;839931;      ;
        dl $7F1F04                           ;839932;7F1F04;
        db $03                               ;839935;      ;
        dl $7F1F04                           ;839936;7F1F04;
        db $03                               ;839939;      ;
        dl $7F1F04                           ;83993A;7F1F04;
        db $03                               ;83993D;      ;
        dl $7F1F04                           ;83993E;7F1F04;
        db $03                               ;839941;      ;
        dl $7F1F04                           ;839942;7F1F04;
        db $03                               ;839945;      ;
        dl $7F1F04                           ;839946;7F1F04;
        db $03                               ;839949;      ;
        dl $7F1F04                           ;83994A;7F1F04;
        db $03                               ;83994D;      ;
        dl $7F1F04                           ;83994E;7F1F04;
        db $03                               ;839951;      ;
        dl $7F1F15                           ;839952;7F1F15;
        db $03                               ;839955;      ;
        dl $7F1F04                           ;839956;7F1F04;
        db $03                               ;839959;      ;
        dl $7F1F04                           ;83995A;7F1F04;
        db $03                               ;83995D;      ;
        dl $7F1F04                           ;83995E;7F1F04;
        db $03                               ;839961;      ;
        dl $7F1F07                           ;839962;7F1F07;
        db $03                               ;839965;      ;
        dl $7F1F04                           ;839966;7F1F04;
        db $03                               ;839969;      ;
        dl $7F1F04                           ;83996A;7F1F04;
        db $03                               ;83996D;      ;
        dl $7F1F04                           ;83996E;7F1F04;
        db $03                               ;839971;      ;
        dl $7F1F04                           ;839972;7F1F04;
        db $03                               ;839975;      ;
        dl $7F1F04                           ;839976;7F1F04;
        db $03                               ;839979;      ;
        dl $7F1F04                           ;83997A;7F1F04;
        db $03                               ;83997D;      ;
        dl $7F1F04                           ;83997E;7F1F04;
        db $03                               ;839981;      ;
        dl $7F1F04                           ;839982;7F1F04;
        db $03                               ;839985;      ;
        dl $7F1F04                           ;839986;7F1F04;
        db $03                               ;839989;      ;
        dl $7F1F04                           ;83998A;7F1F04;
        db $03                               ;83998D;      ;
        dl $7F1F04                           ;83998E;7F1F04;
        db $03                               ;839991;      ;
        dl $7F1F04                           ;839992;7F1F04;
        db $03                               ;839995;      ;
        dl $7F1F04                           ;839996;7F1F04;
        db $03                               ;839999;      ;
        dl $7F1F04                           ;83999A;7F1F04;
        db $03                               ;83999D;      ;
        dl $7F1F04                           ;83999E;7F1F04;
        db $03                               ;8399A1;      ;
        dl $7F1F04                           ;8399A2;7F1F04;
        db $03                               ;8399A5;      ;
        dl $7F1F04                           ;8399A6;7F1F04;
        db $03                               ;8399A9;      ;
        dl $7F1F04                           ;8399AA;7F1F04;
        db $03                               ;8399AD;      ;
        dl $7F1F04                           ;8399AE;7F1F04;
        db $03                               ;8399B1;      ;
        dl $7F1F04                           ;8399B2;7F1F04;
        db $03                               ;8399B5;      ;
        dl $7F1F04                           ;8399B6;7F1F04;
        db $03                               ;8399B9;      ;
        dl $7F1F04                           ;8399BA;7F1F04;
        db $03                               ;8399BD;      ;
        dl $7F1F04                           ;8399BE;7F1F04;
        db $03                               ;8399C1;      ;
        dl $7F1F04                           ;8399C2;7F1F04;
        db $03                               ;8399C5;      ;
        dl $7F1F04                           ;8399C6;7F1F04;
        db $03                               ;8399C9;      ;
        dl $7F1F04                           ;8399CA;7F1F04;
        db $03                               ;8399CD;      ;
        dl $7F1F04                           ;8399CE;7F1F04;
        db $03                               ;8399D1;      ;
        dl $7F1F04                           ;8399D2;7F1F04;
        db $03                               ;8399D5;      ;
        dl $7F1F04                           ;8399D6;7F1F04;
        db $03                               ;8399D9;      ;
        dl $7F1F04                           ;8399DA;7F1F04;
        db $03                               ;8399DD;      ;
        dl $7F1F1B                           ;8399DE;7F1F1B;
        db $01                               ;8399E1;      ;
        dl $7F1F04                           ;8399E2;7F1F04;
        db $03                               ;8399E5;      ;
        dl $7F1F0A                           ;8399E6;7F1F0A;
        db $01                               ;8399E9;      ;
        dl $7F1F0B                           ;8399EA;7F1F0B;
        db $01                               ;8399ED;      ;
        dl $800917                           ;8399EE;800917;
        db $01                               ;8399F1;      ;
        dl $8009B5                           ;8399F2;8009B5;
        db $01                               ;8399F5;      ;
        dl $7F1F1F                           ;8399F6;7F1F1F;
        db $02                               ;8399F9;      ;
        dl $7F1F21                           ;8399FA;7F1F21;
        db $02                               ;8399FD;      ;
        dl $7F1F23                           ;8399FE;7F1F23;
        db $02                               ;839A01;      ;
        dl $7F1F25                           ;839A02;7F1F25;
        db $02                               ;839A05;      ;
        dl $7F1F27                           ;839A06;7F1F27;
        db $02                               ;839A09;      ;
        dl $7F1F4C                           ;839A0A;7F1F4C;
        db $02                               ;839A0D;      ;
        dl $7F1F4A                           ;839A0E;7F1F4A;
        db $02                               ;839A11;      ;
        dl $7F1F50                           ;839A12;7F1F50;
        db $02                               ;839A15;      ;
        dl $7F1F4E                           ;839A16;7F1F4E;
        db $02                               ;839A19;      ;
        dl $7F1F33                           ;839A1A;7F1F33;
        db $02                               ;839A1D;      ;
        dl $7F1F1B                           ;839A1E;7F1F1B;
        db $01                               ;839A21;      ;
        dl $7F1F04                           ;839A22;7F1F04;
        db $03                               ;839A25;      ;
        dl $7F1F1B                           ;839A26;7F1F1B;
        db $01                               ;839A29;      ;
        dl $7F1F04                           ;839A2A;7F1F04;
        db $03                               ;839A2D;      ;
        dl $7F1F1B                           ;839A2E;7F1F1B;
        db $01                               ;839A31;      ;
        dl $7F1F04                           ;839A32;7F1F04;
        db $03                               ;839A35;      ;
        dl $7F1F1B                           ;839A36;7F1F1B;
        db $01                               ;839A39;      ;
        dl $7F1F04                           ;839A3A;7F1F04;
        db $03                               ;839A3D;      ;
        dl $7F1F1B                           ;839A3E;7F1F1B;
        db $01                               ;839A41;      ;
        dl $7F1F04                           ;839A42;7F1F04;
        db $03                               ;839A45;      ;
        dl $7F1F1B                           ;839A46;7F1F1B;
        db $01                               ;839A49;      ;
        dl $7F1F04                           ;839A4A;7F1F04;
        db $03                               ;839A4D;      ;
        dl $7F1F1B                           ;839A4E;7F1F1B;
        db $01                               ;839A51;      ;
        dl $7F1F04                           ;839A52;7F1F04;
        db $03                               ;839A55;      ;
        dl $7F1F1B                           ;839A56;7F1F1B;
        db $01                               ;839A59;      ;
        dl $7F1F04                           ;839A5A;7F1F04;
        db $03                               ;839A5D;      ;
        dl $7F1F1B                           ;839A5E;7F1F1B;
        db $01                               ;839A61;      ;
        dl $7F1F04                           ;839A62;7F1F04;
        db $03                               ;839A65;      ;
        dl $7F1F1B                           ;839A66;7F1F1B;
        db $01                               ;839A69;      ;
        dl $7F1F04                           ;839A6A;7F1F04;
        db $03                               ;839A6D;      ;
        dl $7F1F1B                           ;839A6E;7F1F1B;
        db $01                               ;839A71;      ;
        dl $7F1F04                           ;839A72;7F1F04;
        db $03                               ;839A75;      ;
        dl $7F1F1B                           ;839A76;7F1F1B;
        db $01                               ;839A79;      ;
        dl $7F1F04                           ;839A7A;7F1F04;
        db $03                               ;839A7D;      ;
        dl $7F1F1B                           ;839A7E;7F1F1B;
        db $01                               ;839A81;      ;
        dl $7F1F04                           ;839A82;7F1F04;
        db $03                               ;839A85;      ;
        dl $7F1F1B                           ;839A86;7F1F1B;
        db $01                               ;839A89;      ;
        dl $7F1F04                           ;839A8A;7F1F04;
        db $03                               ;839A8D;      ;
        dl $7F1F1B                           ;839A8E;7F1F1B;
        db $01                               ;839A91;      ;
        dl $7F1F04                           ;839A92;7F1F04;
        db $03                               ;839A95;      ;
        dl $7F1F54                           ;839A96;7F1F54;
        db $02                               ;839A99;      ;
        dl $7F1F54                           ;839A9A;7F1F54;
        db $02                               ;839A9D;      ;
        dl $7F1F54                           ;839A9E;7F1F54;
        db $02                               ;839AA1;      ;
        dl $7F1F54                           ;839AA2;7F1F54;
        db $02                               ;839AA5;      ;
        dl $7F1F54                           ;839AA6;7F1F54;
        db $02                               ;839AA9;      ;
        dl $7F1F56                           ;839AAA;7F1F56;
        db $02                               ;839AAD;      ;

; TextBox_NameVariablePointerTable
; Entries are long pointer + byte length. $FFFD text control codes select from
; this table to insert names such as player/cow/dog/horse/children and buffers.
TextBox_NameVariablePointerTable: ;839AAE
        dl $8008DD                           ;839AAE;8008DD;
        db $08                               ;839AB1;      ;
        dl $8008E5                           ;839AB2;8008E5;
        db $08                               ;839AB5;      ;
        dl $800889                           ;839AB6;800889;
        db $08                               ;839AB9;      ;
        dl $800889                           ;839ABA;800889;
        db $08                               ;839ABD;      ;
        dl $800889                           ;839ABE;800889;
        db $08                               ;839AC1;      ;
        dl $800889                           ;839AC2;800889;
        db $08                               ;839AC5;      ;
        dl $8008D5                           ;839AC6;8008D5;
        db $08                               ;839AC9;      ;
        dl $8008DD                           ;839ACA;8008DD;
        db $08                               ;839ACD;      ;
        dl $8008D5                           ;839ACE;8008D5;
        db $08                               ;839AD1;      ;
        dl $8008D5                           ;839AD2;8008D5;
        db $08                               ;839AD5;      ;
        dl $8008DD                           ;839AD6;8008DD;
        db $08                               ;839AD9;      ;
        dl $8008BF                           ;839ADA;8008BF;
        db $12                               ;839ADD;      ;
        dl $8008D1                           ;839ADE;8008D1;
        db $04                               ;839AE1;      ;
        dl $8008B3                           ;839AE2;8008B3;
        db $0C                               ;839AE5;      ;
        dl $8008E5                           ;839AE6;8008E5;
        db $08                               ;839AE9;      ;
        dl $8008BF                           ;839AEA;8008BF;
        db $12                               ;839AED;      ;
        dl $8008D1                           ;839AEE;8008D1;
        db $04                               ;839AF1;      ;
        dl $8008B3                           ;839AF2;8008B3;
        db $0C                               ;839AF5;      ;
        dl $8008BF                           ;839AF6;8008BF;
        db $12                               ;839AF9;      ;
        dl $8008D1                           ;839AFA;8008D1;
        db $04                               ;839AFD;      ;
        dl $8008B3                           ;839AFE;8008B3;
        db $0C                               ;839B01;      ;
        dl $8008A1                           ;839B02;8008A1;
        db $0A                               ;839B05;      ;
        dl $8008DD                           ;839B06;8008DD;
        db $08                               ;839B09;      ;
        dl $8008D5                           ;839B0A;8008D5;
        db $08                               ;839B0D;      ;
        dl $8008D1                           ;839B0E;8008D1;
        db $04                               ;839B11;      ;
        dl $8008B3                           ;839B12;8008B3;
        db $0C                               ;839B15;      ;
        dl $800889                           ;839B16;800889;
        db $08                               ;839B19;      ;
        dl $8008D5                           ;839B1A;8008D5;
        db $08                               ;839B1D;      ;
        dl $8008D5                           ;839B1E;8008D5;
        db $08                               ;839B21;      ;
        dl $8008ED                           ;839B22;8008ED;
        db $08                               ;839B25;      ;
        dl $8008F5                           ;839B26;8008F5;
        db $08                               ;839B29;      ;
        dl $8008DD                           ;839B2A;8008DD;
        db $08                               ;839B2D;      ;
        dl $8008DD                           ;839B2E;8008DD;
        db $08                               ;839B31;      ;
        dl $8008E5                           ;839B32;8008E5;
        db $08                               ;839B35;      ;
        dl $8008E5                           ;839B36;8008E5;
        db $08                               ;839B39;      ;
        dl $800889                           ;839B3A;800889;
        db $08                               ;839B3D;      ;
        dl $8008BF                           ;839B3E;8008BF;
        db $12                               ;839B41;      ;
        dl $8008D1                           ;839B42;8008D1;
        db $04                               ;839B45;      ;
        dl $8008B3                           ;839B46;8008B3;
        db $0C                               ;839B49;      ;
        dl $8008BF                           ;839B4A;8008BF;
        db $12                               ;839B4D;      ;
        dl $8008D1                           ;839B4E;8008D1;
        db $04                               ;839B51;      ;
        dl $8008B3                           ;839B52;8008B3;
        db $0C                               ;839B55;      ;
        dl $8008BF                           ;839B56;8008BF;
        db $12                               ;839B59;      ;
        dl $8008D1                           ;839B5A;8008D1;
        db $04                               ;839B5D;      ;
        dl $8008B3                           ;839B5E;8008B3;
        db $0C                               ;839B61;      ;
        dl $8008BF                           ;839B62;8008BF;
        db $12                               ;839B65;      ;
        dl $8008D1                           ;839B66;8008D1;
        db $04                               ;839B69;      ;
        dl $8008B3                           ;839B6A;8008B3;
        db $0C                               ;839B6D;      ;
        dl $8008BF                           ;839B6E;8008BF;
        db $12                               ;839B71;      ;
        dl $8008D1                           ;839B72;8008D1;
        db $04                               ;839B75;      ;
        dl $8008B3                           ;839B76;8008B3;
        db $0C                               ;839B79;      ;
        dl $8008BF                           ;839B7A;8008BF;
        db $12                               ;839B7D;      ;
        dl $8008D1                           ;839B7E;8008D1;
        db $04                               ;839B81;      ;
        dl $8008B3                           ;839B82;8008B3;
        db $0C                               ;839B85;      ;
        dl $8008BF                           ;839B86;8008BF;
        db $12                               ;839B89;      ;
        dl $8008D1                           ;839B8A;8008D1;
        db $04                               ;839B8D;      ;
        dl $8008B3                           ;839B8E;8008B3;
        db $0C                               ;839B91;      ;
        dl $8008BF                           ;839B92;8008BF;
        db $12                               ;839B95;      ;
        dl $8008D1                           ;839B96;8008D1;
        db $04                               ;839B99;      ;
        dl $8008B3                           ;839B9A;8008B3;
        db $0C                               ;839B9D;      ;
        dl $8008BF                           ;839B9E;8008BF;
        db $12                               ;839BA1;      ;
        dl $8008D1                           ;839BA2;8008D1;
        db $04                               ;839BA5;      ;
        dl $8008B3                           ;839BA6;8008B3;
        db $0C                               ;839BA9;      ;
        dl $8008BF                           ;839BAA;8008BF;
        db $12                               ;839BAD;      ;
        dl $8008D1                           ;839BAE;8008D1;
        db $04                               ;839BB1;      ;
        dl $8008B3                           ;839BB2;8008B3;
        db $0C                               ;839BB5;      ;
        dl $8008BF                           ;839BB6;8008BF;
        db $12                               ;839BB9;      ;
        dl $8008D1                           ;839BBA;8008D1;
        db $04                               ;839BBD;      ;
        dl $8008B3                           ;839BBE;8008B3;
        db $0C                               ;839BC1;      ;
        dl $8008BF                           ;839BC2;8008BF;
        db $12                               ;839BC5;      ;
        dl $8008D1                           ;839BC6;8008D1;
        db $04                               ;839BC9;      ;
        dl $8008B3                           ;839BCA;8008B3;
        db $0C                               ;839BCD;      ;
        dl $8008BF                           ;839BCE;8008BF;
        db $12                               ;839BD1;      ;
        dl $8008D1                           ;839BD2;8008D1;
        db $04                               ;839BD5;      ;
        dl $8008B3                           ;839BD6;8008B3;
        db $0C                               ;839BD9;      ;
        dl $8008BF                           ;839BDA;8008BF;
        db $12                               ;839BDD;      ;
        dl $8008D1                           ;839BDE;8008D1;
        db $04                               ;839BE1;      ;
        dl $8008B3                           ;839BE2;8008B3;
        db $0C                               ;839BE5;      ;
        dl $8008BF                           ;839BE6;8008BF;
        db $12                               ;839BE9;      ;
        dl $8008D1                           ;839BEA;8008D1;
        db $04                               ;839BED;      ;
        dl $8008B3                           ;839BEE;8008B3;
        db $0C                               ;839BF1;      ;
        dl $8008D5                           ;839BF2;8008D5;
        db $08                               ;839BF5;      ;

Text_Pointer_Table: ;839BF6
        dl Text_Forecast_Spring_Sunny        ;B68000;00
        dl Text_Forecast_Summer_Sunny        ;B680D8;01
        dl Text_Forecast_Fall_Sunny          ;B6816C;02
        dl Text_Forecast_Winter_Sunny        ;B6821E;03
        dl Text_Forecast_Spring_Rain         ;B682BE;04
        dl Text_Forecast_Summer_Rain         ;B683B0;05
        dl Text_Forecast_Fall_Rain           ;B6849A;06
        dl Text_Forecast_Winter_Snow         ;B68542;07
        dl Text_Forecast_Summer_Hurricane    ;B685D6;08
        dl Text_LogBook                      ;B6870C;09
        dl Text_Diary                        ;B68802;0A
        dl Text_00B_Diary_WorkHardAgainTomorrow                     ;B688A4;0B----
        dl Text_Diary2                       ;B688F0;0C
        dl Text_00D_Diary_GoodNight                     ;B68972;0D----
        dl Text_Sign_House_Expansion         ;B6898A;0E
        dl Text_Manual_Sickle                ;B68A46;0F
        dl Text_Manual_Hoe                   ;B68B5E;10
        dl Text_Manual_Axe                   ;B68C68;11
        dl Text_Manual_Hammer                ;B68D6E;12
        dl Text_Manual_Can                   ;B68EC6;13
        dl Text_Manual_Milker                ;B69006;14
        dl Text_Manual_Brush                 ;B69078;15
        dl Text_Manual_Bell                  ;B69172;16
        dl Text_Manual_CropSeeds             ;B69248;17
        dl Text_Manual_GrassSeeds            ;B693A8;18
        dl Text_Manual_Paint                 ;B6953E;19
        dl Text_01A_Festival_TellMeWorkingNewYears                     ;B695A4;1A
        dl Text_Sign_Wood                    ;B69638;1B
        dl Text_Sign_Fodder                  ;B696E2;1C
        dl Text_01D_Weather_NailedDownThedoorPrepareHurricane                     ;B6978C;1D
        dl Text_Sign_Fork                    ;B69812;1E
        dl Text_Sign_Mountain_Top            ;B69860;1F
        dl Text_Sign_Hotspring               ;B69878;20
        dl Text_Sign_Cave                    ;B698A0;21
        dl Text_Sign_Workmans                ;B698DA;22
        dl Text_Bachellorete_Diary           ;B69982;23
        dl Text_Mayor_House_Bookcase1        ;B699F2;24
        dl Text_Mayor_House_Bookcase2        ;B69A70;25
        dl Text_Mayor_House_Bookcase3        ;B69ADC;26
        dl Text_Flowershop_Rooms_Bookcase    ;B69B46;27
        dl Text_Bar_Bookcase                 ;B69BA4;28
        dl Text_Restaurant_Bookcase          ;B69C10;29
        dl Text_GeneralStore_Rooms_Bookcase  ;B69C6E;2A
        dl Text_WitchHouse_Bookcase          ;B69CDC;2B
        dl Text_Carpenters_Bookcase          ;B69D94;2C
        dl Text_Shop_Closed                  ;B69DF4;2D
        dl Text_Bar_Closed                   ;B69E12;2E
        dl Text_Cow_Talk                     ;B69E36;2F
        dl Text_Cow_Talk_Cranky              ;B69E96;30
        dl Text_Cow_Talk_Sick                ;B69EBA;31
        dl Text_Cow_Talk_Pregnant            ;B69F52;32
        dl Text_Elf_Cave_Door_Closed         ;B69FA6;33----
        dl Text_034_Dialog_OpenSomethingsStuck                     ;B69FE0;34
        dl Text_035_Dialog_HowsGoingWorkTooHard                     ;B6A03E;35
        dl Text_036_Animal_AskFloristFlowersAskLivestock                     ;B6A0CE;36
        dl Text_037_Church_HangAroundListenPriest                     ;B6A1C8;37
        dl Text_038_Dialog_OffTodayKeepUpAll                     ;B6A22C;38
        dl Text_039_Weather_PeopleTownTalkDifferentlyAccording                     ;B6A2C0;39
        dl Text_03A_Animal_EverybodyHasDifferentIdeasHappiness                     ;B6A364;3a
        dl Text_03B_Sign_WorkingHardHaveChatFriends                     ;B6A4FC;3b
        dl Text_03C_Church_ChurchDedicatedGodCropsSuggest                     ;B6A604;3c
        dl Text_03D_Dialog_LikeTakingMyTimeReading                     ;B6A6B2;3d
        dl Text_03E_Sign_HaveHeardWaterImpSomeone                     ;B6A748;3e
        dl Text_03F_Dialog_ThinkBadThingsIfDiscovered                     ;B6A7EC;3f
        dl Text_040_Romance_WonderIfDaughterAnncanGet                     ;B6A99A;40
        dl Text_041_Animal_HowsWorkGoingSomeWild                     ;B6AA16;41
        dl Text_042_Church_BelieveGodExistsBelieve                     ;B6AAC0;42
        dl Text_043_Dialog_StrangeAlwaysNowNothingAll                     ;B6AB2E;43
        dl Text_044_Dialog_TakingWalkTooImportantGet                     ;B6ABF0;44
        dl Text_045_Romance_HelpMyselfWorryingAboutAnn                     ;B6AD1E;45
        dl Text_046_Shop_AlwaysLookFineBagSeed                     ;B6AE86;46
        dl Text_047_Dialog_GrassGrowsAutumnYoudontHave                     ;B6AF4C;47
        dl Text_048_Romance_MayEveryoneGiveKindnessEveryone                     ;B6AFDA;48
        dl Text_049_Dialog_Entry                     ;B6B03C;49
        dl Text_04A_Sign_ShopClosedSaturdaysBathingInthe                     ;B6B046;4a
        dl Text_04B_Weather_KindDarkRainyDaysFeels                     ;B6B0DC;4b
        dl Text_04C_Dialog_CoincidenceHavingMealToday                     ;B6B1DE;4c
        dl Text_04D_Dialog_EasyWorkSteadilyButWorthwhile                     ;B6B24A;4d
        dl Text_04E_Church_HopeBusinessBetterBetterGod                     ;B6B2D2;4e
        dl Text_04F_Diary_GoodBatheSunEatWork                     ;B6B3A8;4f
        dl Text_050_Animal_EatSomethingTiredCakesBest                     ;B6B470;50
        dl Text_051_Dialog_HowdyYoungBoysWhatsUp                     ;B6B512;51
        dl Text_052_Animal_HicWorkingLikeDogOnly                     ;B6B55C;52
        dl Text_053_Dialog_MyRoutineTakeWalkSundays                     ;B6B5CE;53
        dl Text_054_Weather_StartedRainingNowGeeWas                     ;B6B650;54
        dl Text_055_Weather_SayingMatterIfRainsWork                     ;B6B726;55
        dl Text_056_Dialog_UlpSooooGreatShesOut                     ;B6B7CC;56
        dl Text_057_Church_CalmInsideChurchManyPeople                     ;B6B866;57
        dl Text_058_Animal_FeltTimeWentSlowlyWas                     ;B6B932;58
        dl Text_059_Animal_HaveSympathyPeopleKindPeople                     ;B6BA38;59
        dl Text_05A_Dialog_NecessarilyRightWrongDailyIncidents                     ;B6BB48;5a
        dl Text_05B_Weather_KnowConsumeYourstaminaRainyDay                     ;B6BC00;5b
        dl Text_05C_Animal_ToughTakeCareCowsTake                     ;B6BCA6;5c
        dl Text_05D_Animal_HensLayEggsPutCage                     ;B6BDEC;5d
        dl Text_05E_Weather_YoungBoyPutLivestockInside                     ;B6BF10;5e
        dl Text_05F_Animal_KnowCowsGiveMoreMilk                     ;B6BFBE;5f
        dl Text_060_Dialog_RedoLifeMightHaveSecond                     ;B6C120;60
        dl Text_061_Church_AskingIfGotoChurchGod                     ;B6C1DA;61
        dl Text_062_Romance_TheresUsefulBookOverAbout                     ;B6C2C2;62
        dl Text_063_Sign_AlsoMidwifeKnowMayorsDaughter                     ;B6C358;63
        dl Text_064_Dialog_GrownUpsAlwaysMakeRule                     ;B6C456;64
        dl Text_065_Romance_HmmmLoveMariasSisterCantbe                     ;B6C550;65
        dl Text_066_Sign_GatherManyThingsIntheMountain                     ;B6C5C8;66
        dl Text_067_Dialog_GotDate                     ;B6C6C6;67
        dl Text_068_Romance_YoudBetterReadBookWritten                     ;B6C720;68
        dl Text_069_Dialog_YeahWelcomeMakeYourselfatHome                     ;B6C81E;69
        dl Text_06A_Shop_ThingsGirlsLikeFlowersSweets                     ;B6C868;6a
        dl Text_06B_Romance_LoveMariaWishMyBride                     ;B6C932;6b
        dl Text_06C_Church_AlwaysPrayGrownUpVery                     ;B6C9B2;6c
        dl Text_06D_Dialog_DateDateWalkAll                     ;B6CA1C;6d
        dl Text_06E_Shipping_PutCropsShippingBoxCollect                     ;B6CA96;6e
        dl Text_06F_Animal_UseToolLoseStaminaBut                     ;B6CB22;6f
        dl Text_070_Dialog_DrinkAfterWorkBest                     ;B6CBCE;70
        dl Text_071_Shipping_ThingsShipFlowersAnimalsPerishables                     ;B6CC1A;71
        dl Text_072_Shipping_EvenIfPutShippingGoods                     ;B6CD04;72
        dl Text_073_Shipping_CollectShippingGoodsEvenShed                     ;B6CDD0;73
        dl Text_074_Weather_ShallWatchWeatherForecastYoud                     ;B6CE5A;74
        dl Text_075_Church_MuchEasierLiveIfWas                     ;B6CF4A;75
        dl Text_076_Diary_AnythingHappenLivesCaseYoud                     ;B6CFE6;76
        dl Text_077_Romance_KnowMoneyImportantButMost                     ;B6D07C;77
        dl Text_078_Shipping_WanderingPeddlerButOftenSell                     ;B6D144;78
        dl Text_079_Weather_FencesEasyBreakAfterRain                     ;B6D27A;79
        dl Text_07A_Sign_LiveMountainsHuntingAnimalsEve                     ;B6D358;7a
        dl Text_07B_Mountain_HaveHeardPowerBerryEat                     ;B6D44E;7b
        dl Text_07C_Weather_RainsMustKeepoffTopMountain                     ;B6D4F8;7c
        dl Text_07D_Mountain_SomeMushroomsPoisonousCareful                     ;B6D59A;7d
        dl Text_07E_Mountain_WantFishC                     ;B6D604;7e
        dl Text_07F_Manual_UseMyFishingRodUse                     ;B6D678;7f
        dl Text_080_Shipping_PrettyGoodTastesGoodSells                     ;B6D6D6;80
        dl Text_081_Dialog_VisitUsAgain                     ;B6D75E;81
        dl Text_082_Dialog_FineDayToday                     ;B6D77E;82
        dl Text_083_Romance_HotEveryDayButDoing                     ;B6D7B8;83
        dl Text_084_Romance_SomehowLoveAutumnScenery                     ;B6D816;84
        dl Text_085_Dialog_HopeItllSpringSoon                     ;B6D860;85
        dl Text_086_Church_BelieveGodC                     ;B6D896;86
        dl Text_087_Church_UnusualTheseDaysComeChurch                     ;B6D906;87
        dl Text_088_Church_WhetherGodExistsMoreBelief                     ;B6D99A;88
        dl Text_089_Dialog_TakeCareYourselfnotWornDown                     ;B6DA34;89
        dl Text_08A_Romance_ExcuseMeLoveKidsLove                     ;B6DABE;8a
        dl Text_08B_Romance_LoveKidsTooMyDream                     ;B6DB56;8b
        dl Text_08C_Dialog_Oh                     ;B6DBDC;8c
        dl Text_08D_Dialog_PrettyColdTakeCareYourself                     ;B6DBEA;8d
        dl Text_08E_Church_HaveComeListenPriestC                     ;B6DC76;8e
        dl Text_08F_Dialog_Devout                     ;B6DD0E;8f
        dl Text_090_Animal_ThenPray                     ;B6DD2E;90
        dl Text_091_Weather_WelcomeRainHaveaLotRain                     ;B6DD7E;91
        dl Text_092_Dialog_UumComeOvertoRanchSome                     ;B6DDFE;92
        dl Text_093_Dialog_LonelyLivingBigPlaceLittle                     ;B6DE70;93
        dl Text_094_Dialog_UumIfNothingGGood                     ;B6DF20;94
        dl Text_095_Dialog_SeeSorryMeanAskAnything                     ;B6DF84;95
        dl Text_096_Dialog_GoingMakeGreatToolsLike                     ;B6E008;96
        dl Text_097_Sign_ItllShowcasedShopOneThese                     ;B6E066;97
        dl Text_098_Dialog_TrustMe                     ;B6E150;98
        dl Text_099_Dialog_TrustMe                     ;B6E164;99
        dl Text_09A_Dialog_SeemsLittleDifferentPlanHad                     ;B6E19C;9a
        dl Text_09B_Romance_ActingLikeGirlAllBad                     ;B6E220;9b
        dl Text_09C_Dialog_Outspoken                     ;B6E2AE;9c
        dl Text_09D_Romance_MyDadAlwaysTellsMe                     ;B6E2DC;9d
        dl Text_09E_Dialog_KnowButFeelsGoodSpring                     ;B6E39A;9e
        dl Text_09F_Romance_LoveSummerThoughHot                     ;B6E460;9f
        dl Text_0A0_Dialog_ConstantEffortImportantKnowSaysuccess                     ;B6E4A2;a0
        dl Text_0A1_Animal_LooksColdOutsideTurnsWhite                     ;B6E54A;a1
        dl Text_0A2_Dialog_HoHumBoringC                     ;B6E5DA;a2
        dl Text_0A3_Diary_HumSleepyHoHum                     ;B6E678;a3
        dl Text_0A4_Dialog_GeeSerious                     ;B6E6C4;a4
        dl Text_0A5_Manual_FeelRelaxedOutsideHaventOutfor                     ;B6E6F4;a5
        dl Text_0A6_Dialog_IdeaComesOutUnderThisheat                     ;B6E77E;a6
        dl Text_0A7_Dialog_LetsBestShall                     ;B6E7C2;a7
        dl Text_0A8_Weather_MountainCoveredWithsnowNow                     ;B6E7FC;a8
        dl Text_0A9_Weather_HateRainFeelsDepressingLike                     ;B6E84E;a9
        dl Text_0AA_Romance_MyDadTellsMeGet                     ;B6E8CC;aa
        dl Text_0AB_Animal_LookAutomaticPuddingMakerPut                     ;B6EA14;ab
        dl Text_0AC_Dialog_SmellsWonderful                     ;B6EB9E;ac
        dl Text_0AD_Dialog_SayMuchQuickerTomakePudding                     ;B6EBDE;ad
        dl Text_0AE_Animal_LoveSpringAllFlowersStart                     ;B6ECA2;ae
        dl Text_0AF_Town_LikeFlowersC                     ;B6ED0A;af
        dl Text_0B0_Romance_YeahNinaLovesToo                     ;B6ED94;b0
        dl Text_0B1_Dialog_Ugh                     ;B6EDC8;b1
        dl Text_0B2_Shipping_AutumnWinterOffSeasonUs                     ;B6EDD6;b2
        dl Text_0B3_Romance_BelieveFlowerWhichBloomsWinter                     ;B6EE78;b3
        dl Text_0B4_Dialog_MustBeautiful                     ;B6EF5A;b4
        dl Text_0B5_Sign_LetMeTellCodeForthe                     ;B6EF86;b5
        dl Text_0B6_Romance_GuessHappyIfGaveFlowerto                     ;B6F02A;b6
        dl Text_0B7_Sign_MountainsSeasonBeautifulManyFruits                     ;B6F0C6;b7
        dl Text_0B8_Dialog_DesertedWinterButExperienceJoysof                     ;B6F16E;b8
        dl Text_0B9_Sign_HerbInnerPartCaveWorks                     ;B6F212;b9
        dl Text_0BA_Sign_FlowerSoldShopRaise                     ;B6F2CC;ba
        dl Text_0BB_Shipping_CollectingFallenLeavestoMakeManure                     ;B6F332;bb
        dl Text_0BC_Weather_PlantsAliveUnderSnowWonderful                     ;B6F3B4;bc
        dl Text_0BD_Dialog_HumanAnimalsPlantsAllAlive                     ;B6F462;bd
        dl Text_0BE_Dialog_Great                     ;B6F4B8;be
        dl Text_0BF_Festival_KnowBusyWorkingButTry                     ;B6F4CC;bf
        dl Text_0C0_Weather_KindLikeRainyDaysLeaves                     ;B6F558;c0
        dl Text_0C1_Animal_FlowersEdibleUsedMedicinalPurposes                     ;B6F5D6;c1
        dl Text_0C2_Dialog_HeardWasSecretGardenRanch                     ;B6F72E;c2
        dl Text_0C3_Dialog_WowHardlyWait                     ;B6F84E;c3
        dl Text_0C4_Dialog_MeanForget                     ;B6F87C;c4
        dl Text_0C5_Dialog_AlwaysLookFine                     ;B6F8CA;c5
        dl Text_0C6_Dialog_HaveLittleBirdNameP                     ;B6F904;c6
        dl Text_0C7_Romance_LikeSweetsLoveC                     ;B6F98E;c7
        dl Text_0C8_Dialog_GoodMakingSweetsHopeCook                     ;B6FA10;c8
        dl Text_0C9_Dialog_Sorry                     ;B6FAAE;c9
        dl Text_0CA_Romance_StillnessWinterMakesMeCalm                     ;B6FAC4;ca
        dl Text_0CB_Romance_LikeAnimalsLoveLikeC                     ;B6FB4A;cb
        dl Text_0CC_Romance_LoveAnimalsToo                     ;B6FBDC;cc
        dl Text_0CD_Town_LyingAnimalsTakePeopleWho                     ;B6FC0E;cd
        dl Text_0CE_Animal_EiBarkWildDogswhenCome                     ;B6FC94;ce
        dl Text_0CF_Dialog_HardLookAfterAnimalsAlways                     ;B6FD32;cf
        dl Text_0D0_Romance_AlwaysRunningAroundLookFine                     ;B6FE84;d0
        dl Text_0D1_Dialog_HopeMyDadStaysHealthy                     ;B6FF34;d1
        dl Text_0D2_Dialog_MyUncleLikedMakeFriends                     ;B78000;d2
        dl Text_0D3_Dialog_GladExcuseHimBeingMeddlesome                     ;B780AE;d3
        dl Text_0D4_Dialog_HesStrictButBasicallyGood                     ;B78184;d4
        dl Text_0D5_Dialog_TooSoakedMightCatchCold                     ;B781D6;d5
        dl Text_0D6_Dialog_ComeDadLetsGoHomenow                     ;B78282;d6
        dl Text_0D7_Dialog_OtherwiseMomGetMad                     ;B782C4;d7
        dl Text_0D8_Animal_TasteMyNewCakeBaked                     ;B78322;d8
        dl Text_0D9_Dialog_BakedNewCakeHaveBite                     ;B7837C;d9
        dl Text_0DA_Sign_GoodCheesecakeThinkGoodEnough                     ;B78422;da
        dl Text_0DB_Romance_LookPrettyBusyHopeEverythings                     ;B784DE;db
        dl Text_0DC_Dialog_CoincidenceMeetC                     ;B78562;dc
        dl Text_0DD_Dialog_TeeHee                     ;B785FA;dd
        dl Text_0DE_Shop_WowCoincidenceWereWaitingMe                     ;B78610;de
        dl Text_0DF_Sign_CameShopSorryButToo                     ;B786E2;df
        dl Text_0E0_Weather_CameRainGlad                     ;B7877A;e0
        dl Text_0E1_Dialog_GrandPaStrict                     ;B787CC;e1
        dl Text_0E2_Dialog_PrettyDaringShallWashBack                     ;B787FE;e2
        dl Text_0E3_Dialog_Kidding                     ;B788D2;e3
        dl Text_0E4_Dialog_HeeHee                     ;B78900;e4
        dl Text_0E5_Dialog_LookFineToday                     ;B78930;e5
        dl Text_0E6_Dialog_MyHomeMadeFruitJuice                     ;B78962;e6
        dl Text_0E7_Dialog_TeeHeeKissIfDrink                     ;B78A1E;e7
        dl Text_0E8_Shop_BarAhaWantSeeMe                     ;B78A7C;e8
        dl Text_0E9_Dialog_GetCoolNight                     ;B78AFC;e9
        dl Text_0EA_Dialog_ThanksLotToday                     ;B78B42;ea
        dl Text_0EB_Dialog_LikeAlone                     ;B78B72;eb
        dl Text_0EC_Sign_SometimesGoMountainsGatherSome                     ;B78BA6;ec
        dl Text_0ED_Animal_WasntColdOutsideColdBetter                     ;B78C28;ed
        dl Text_0EE_Dialog_SawRanchOtherDayNoticeme                     ;B78CEA;ee
        dl Text_0EF_Dialog_StandAloneinHugePlaceFeel                     ;B78D94;ef
        dl Text_0F0_Weather_MuchBetterHaveSomeoneAround                     ;B78E84;f0
        dl Text_0F1_Dialog_SureLiveAloneButitsLike                     ;B78FE8;f1
        dl Text_0F2_Dialog_OneWhoSupposedWorkRanch                     ;B7908A;f2
        dl Text_0F3_Shipping_MrEjChargeShippingCome                     ;B79138;f3
        dl Text_0F4_Dialog_ManagingTheranchAloneSeparatelyParents                     ;B792E6;f4
        dl Text_0F5_Town_MayorTownPleasureMeetSome                     ;B7946E;f5
        dl Text_0F6_Animal_GrandfatherHelpedMeThoseDays                     ;B795F8;f6
        dl Text_0F7_Church_HardButGiveUpYeah                     ;B7973C;f7
        dl Text_0F8_Romance_CuteGirlLonghair                     ;B7982E;f8
        dl Text_0F9_Romance_HaventSeenBeforeComeRanch                     ;B79872;f9
        dl Text_0FA_Dialog_MayHardFirstButGive                     ;B7991C;fa
        dl Text_0FB_Town_HeardSomethingHeardFaintSound                     ;B79972;fb
        dl Text_0FC_Dialog_HeHello                     ;B79AAA;fc
        dl Text_0FD_Sign_PriestChurchAskQuestionsPeople                     ;B79AC0;fd
        dl Text_0FE_Dialog_YoullHavePlentyChallengesBut                     ;B79C02;fe
        dl Text_0FF_Town_YearOverTodayWasYear                     ;B79CC2;ff
        dl Text_100_Sign_ShippingBoxLivestockAfterTalking                     ;B79E1E;100
        dl Text_101_Manual_ToolsShedPenPickUp                     ;B79EDE;101
        dl Text_102_Dialog_UnfortunatelyTheresNothingSaleBut                     ;B79FBA;102
        dl Text_103_Romance_HehOwnerRanchAnnNice                     ;B7A098;103
        dl Text_104_Diary_StaminaDecreasesUseToolsEat                     ;B7A12C;104
        dl Text_105_Manual_WentRanchIfGoingRaise                     ;B7A1D6;105
        dl Text_106_Manual_VegetableSeedsSoonComeAgain                     ;B7A370;106
        dl Text_107_Romance_NinaTheseCropsMustSowed                     ;B7A3DA;107
        dl Text_108_Dialog_HavePlowGroundMakeField                     ;B7A4FC;108
        dl Text_109_Romance_WelcomeYoudBetterEatEveryday                     ;B7A57A;109
        dl Text_10A_Dialog_MustHardKnowButtryBest                     ;B7A5FA;10a
        dl Text_10B_Dialog_PuffHicHaveSeenBefore                     ;B7A650;10b
        dl Text_10C_Animal_SonHaveHaveMeadowBuy                     ;B7A698;10c
        dl Text_10D_Animal_FirstMustHavePlentyGrass                     ;B7A878;10d
        dl Text_10E_Manual_HowdyPutThoseCowsPen                     ;B7A960;10e
        dl Text_10F_Shipping_WanderingPeddlerHaveAnythingSell                     ;B7AA7E;10f
        dl Text_110_Romance_GirlsTownAllCuteGood                     ;B7ABB4;110
        dl Text_111_Animal_HohohoMisterKnowBeginFirst                     ;B7AC52;111
        dl Text_112_Animal_OverextendYourselfTiredGoBed                     ;B7AE14;112
        dl Text_113_Weather_MrsFortuneTellersWordsAlways                     ;B7AF62;113
        dl Text_114_Romance_EllenNiceMeeting                     ;B7B016;114
        dl Text_115_Dialog_HeirRanchWonderIfManage                     ;B7B068;115
        dl Text_116_Sign_BarClosedTodayUsuallyOpen                     ;B7B148;116
        dl Text_117_Dialog_GoingBackRanchYetC                     ;B7B1E4;117
        dl Text_118_Weather_ThenGiveLiftTraineeShipping                     ;B7B276;118
        dl Text_119_Animal_LetMeKnowGoHome                     ;B7B376;119
        dl Text_11A_Dialog_SuggestListenVillagersLittleMore                     ;B7B3BA;11a
        dl Text_11B_Romance_YouveComeHauntedRanchTee                     ;B7B42C;11b
        dl Text_11C_Dialog_BestThingRecoverFatigueRelax                     ;B7B508;11c
        dl Text_11D_Dialog_WelcomeMakeYourselfHome                     ;B7B574;11d
        dl Text_11E_Shop_EveDrawingCardBarPretty                     ;B7B5B8;11e
        dl Text_11F_Dialog_StillFine                     ;B7B67E;11f
        dl Text_120_Romance_GoodEveningFanEvesKnow                     ;B7B6A8;120
        dl Text_121_Romance_EveWorksNightSupposeKinda                     ;B7B700;121
        dl Text_122_Sign_EveLostParentsHergrandfatherWho                     ;B7B7F8;122
        dl Text_123_Romance_MayMissHimTooBut                     ;B7B936;123
        dl Text_124_Dialog_KoroWait                     ;B7B9CA;124
        dl Text_125_Animal_PuffPuffRunSuddenlyMr                     ;B7B9E2;125
        dl Text_126_Dialog_ThankVeryMuchHaveNew                     ;B7BBD2;126
        dl Text_127_Dialog_NewcomerRancherSomethingYoungBoy                     ;B7BC90;127
        dl Text_128_Animal_CarpentersComeUsWantEnlarge                     ;B7BD58;128
        dl Text_129_Sign_ExtensionHouseCallUsHave                     ;B7BDF0;129
        dl Text_12A_Dialog_NowExtensionCampaignIfEnlargeyour                     ;B7BEF8;12a
        dl Text_12B_Mountain_AnglerLivePerfectFreedomBetter                     ;B7C000;12b
        dl Text_12C_Mountain_PrepareFishingRodNextTime                     ;B7C14C;12c
        dl Text_12D_Dialog_WhatsUpHowsWorkGoing                     ;B7C1AA;12d
        dl Text_12E_Sign_GatherMaterialsChoppingLogsMountain                     ;B7C1FA;12e
        dl Text_12F_Dialog_AlsoUseMaterialsFenceAlways                     ;B7C27E;12f
        dl Text_130_Dialog_WantEnlargeHouseC                     ;B7C316;130
        dl Text_131_Dialog_RanchTomorrow                     ;B7C39E;131
        dl Text_132_Animal_LetMeKnowWheneverWant                     ;B7C3EA;132
        dl Text_133_Dialog_LikeLivingSuperDeluxeGreat                     ;B7C440;133
        dl Text_134_Dialog_CostsGEnlargeHouseTake                     ;B7C4E0;134
        dl Text_135_Dialog_AlrightStartOffTomorrow                     ;B7C5D0;135
        dl Text_136_Dialog_CallMeAgainAnyTime                     ;B7C61C;136
        dl Text_137_Sign_MyGodTheresEnoughMaterials                     ;B7C660;137
        dl Text_138_Manual_ChopStumpsAxeMakeMaterials                     ;B7C88E;138
        dl Text_139_Dialog_HeeHeeLookForward                     ;B7C952;139
        dl Text_13A_Dialog_BuildTerrificOneLookForward                     ;B7C98C;13a
        dl Text_13B_Dialog_CostsGEnlargeHouseTake                     ;B7C9EC;13b
        dl Text_13C_Dialog_Have                     ;B7CADC;13c
        dl Text_13D_Romance_LookExcellentHouseCalledSuper                     ;B7CB28;13d
        dl Text_13E_Romance_WhatsHappenedEveTonight                     ;B7CBB0;13e
        dl Text_13F_Shipping_NinasMotherCollapsedFromfeverSell                     ;B7CBFA;13f
        dl Text_140_Romance_FinishedLookSuperDeluxeGreat                     ;B7CCA6;140
        dl Text_141_Dialog_SayHeardRareSeedGrows                     ;B7CD82;141
        dl Text_142_Sign_WasScaredEarthquakeMorningCome                     ;B7CE7C;142
        dl Text_143_Romance_LikeNina                     ;B7CF62;143
        dl Text_144_Dialog_TodayLastDayYearSeems                     ;B7CF94;144
        dl Text_145_Dialog_ScheduledDateHasAlreadyPassed                     ;B7D074;145
        dl Text_146_Animal_LongWinterFinallyOverAnimals                     ;B7D11E;146
        dl Text_147_Dialog_YeahFeltDizzy                     ;B7D1D0;147
        dl Text_148_Animal_WanderingHawkerTodayHaveVery                     ;B7D21A;148
        dl Text_149_Animal_WanderingHawkerTodayHaveVery                     ;B7D3E0;149
        dl Text_14A_Animal_ThenCowNowMineHawker                     ;B7D5BA;14a
        dl Text_14B_Sign_CowMineNowPutSeed                     ;B7D63C;14b
        dl Text_14C_Dialog_HardheartedCustomerWanderingHawkerHawker                     ;B7D76A;14c
        dl Text_14D_Shop_PeddlerWindSeedTreeGrows                     ;B7D836;14d
        dl Text_14E_Dialog_NowPlantedMisterLookForward                     ;B7DA28;14e
        dl Text_14F_Dialog_SureGuaranteeRegretRestLife                     ;B7DAA6;14f
        dl Text_150_Weather_ToughWeatherGloomy                     ;B7DB4C;150
        dl Text_151_Dialog_BusyBusy                     ;B7DBAA;151
        dl Text_152_Dialog_WayBackConnectedWorldBelow                     ;B7DBCA;152
        dl Text_153_Dialog_GoodLordWhatsHappeningPlace                     ;B7DC48;153
        dl Text_154_Weather_SayHurricaneComingTomorrow                     ;B7DCCA;154
        dl Text_155_Dialog_WindBlowingHarderMakesMe                     ;B7DD2E;155
        dl Text_156_Weather_SkyLooksThreateningProbablyHave                     ;B7DD9A;156
        dl Text_157_Weather_KnowButGetExcitedSomething                     ;B7DE40;157
        dl Text_158_Weather_WindBlowingHarderNowLike                     ;B7DEEA;158
        dl Text_159_Weather_RainButHurricaneBecauseBlows                     ;B7DF72;159
        dl Text_15A_Weather_YoudBetterPrayGodDamage                     ;B7DFFE;15a
        dl Text_15B_Weather_SonHurricaneGettingNearHave                     ;B7E0A0;15b
        dl Text_15C_Romance_KnowEvenIfYoung                     ;B7E194;15c
        dl Text_15D_Dialog_IdiotDoingGoHomePut                     ;B7E1EA;15d
        dl Text_15E_Weather_HangingAroundKnowHurricaneComing                     ;B7E296;15e
        dl Text_15F_Animal_HavePutLivestockPenLets                     ;B7E330;15f
        dl Text_160_Dialog_ImpossibleGoOutToday                     ;B7E3D6;160
        dl Text_161_Weather_ThankGodWasOnlySlight                     ;B7E41C;161
        dl Text_162_Weather_ThinkPreciousWeatherCockWas                     ;B7E4A2;162
        dl Text_163_Romance_GladEverybodyFine                     ;B7E514;163
        dl Text_164_Dialog_RanchAlright                     ;B7E54C;164
        dl Text_165_Dialog_WasAwfulOursAlright                     ;B7E57A;165
        dl Text_166_Dialog_LetsLookAroundRanchTrouble                     ;B7E5CA;166
        dl Text_167_Dialog_EarthquakeLastNightRegisteredRichter                     ;B7E660;167
        dl Text_168_Dialog_YoudBetterInspect                     ;B7E714;168
        dl Text_169_Dialog_EarthquakeNotice                     ;B7E762;169
        dl Text_16A_Sign_WonderMyGrandpaDoingLot                     ;B7E7C2;16a
        dl Text_16B_Dialog_WasSurprisedRanchAlright                     ;B7E8C0;16b
        dl Text_16C_Weather_CowsSimpleKeepOutGround                     ;B7E916;16c
        dl Text_16D_Romance_SeemsChangesEverywhereCausedEarthquake                     ;B7E9E0;16d
        dl Text_16E_Dialog_BigRockOutCollapsedEarthquake                     ;B7EACC;16e
        dl Text_16F_Dialog_WasPrettySurprised                     ;B7EB62;16f
        dl Text_170_Dialog_ListenGoThroughRock                     ;B7EBB0;170
        dl Text_171_Dialog_MightAbleGoEndRanch                     ;B7EC0C;171
        dl Text_172_Animal_HaveSeenMoleScaresCows                     ;B7ECC8;172
        dl Text_173_Dialog_Happy                     ;B7ED9C;173
        dl Text_174_Dialog_HaventThoughtAboutitYet                     ;B7EDB8;174
        dl Text_175_Dialog_SureMe                     ;B7EE04;175
        dl Text_176_Dialog_YoureKidding                     ;B7EE2E;176
        dl Text_177_Dialog_YesYou                     ;B7EE52;177
        dl Text_178_Dialog_AfraidTooEarly                     ;B7EE66;178
        dl Text_179_Dialog_WhatYes                     ;B7EEA0;179
        dl Text_17A_Dialog_AllTooSuddenKnow                     ;B7EEC2;17a
        dl Text_17B_Dialog_TitterAlrightSay                     ;B7EF2C;17b
        dl Text_17C_Dialog_StillTooEarly                     ;B7EF64;17c
        dl Text_17D_Dialog_GoodMorningDaDarlingHappy                     ;B7EF9C;17d
        dl Text_17E_Dialog_JmClCnGo                     ;B7F01C;17e
        dl Text_17F_Dialog_TooLate                     ;B7F044;17f
        dl Text_180_Dialog_ThankTroubleDarling                     ;B7F06A;180
        dl Text_181_Diary_WorkHardTodayToo                     ;B7F0B4;181
        dl Text_182_Dialog_GotMyBestTodayalso                     ;B7F0EC;182
        dl Text_183_Diary_WorkHardGiveHouseGood                     ;B7F130;183
        dl Text_184_Dialog_StrangeSameSkyButWind                     ;B7F190;184
        dl Text_185_Dialog_TryMyBestMakeSomething                     ;B7F220;185
        dl Text_186_Dialog_TakeCareThoseToolsToo                     ;B7F29A;186
        dl Text_187_Animal_AutoMilkingYogurtMakerSpecial                     ;B7F354;187
        dl Text_188_Dialog_TimeGoesQuicklyFeelLike                     ;B7F416;188
        dl Text_189_Weather_WeatherBeautifulLetsGoPicnic                     ;B7F4A2;189
        dl Text_18A_Dialog_LaLaLaLaLa                     ;B7F538;18a
        dl Text_18B_Sign_MysteriousFlowerMountainSomedayDreaming                     ;B7F5C6;18b
        dl Text_18C_Dialog_GoodMorningSweetheartWasSparrow                     ;B7F684;18c
        dl Text_18D_Romance_WantCookDeliciousMealsEvery                     ;B7F778;18d
        dl Text_18E_Dialog_EpMayDescendedOfaThoroughbred                     ;B7F7E2;18e
        dl Text_18F_Dialog_SpringWonderful                     ;B7F8C2;18f
        dl Text_190_Dialog_GraduallyGettingUsedLivingLonely                     ;B7F8F4;190
        dl Text_191_Sign_ManyKindsAnimalsMountainGive                     ;B7F9C2;191
        dl Text_192_Romance_CookEvening                     ;B7FA70;192
        dl Text_193_Dialog_HoneyWork                     ;B7FABA;193
        dl Text_194_Dialog_SundaysRanch                     ;B7FAEC;194
        dl Text_195_Dialog_WarmSuchComfortableSunday                     ;B7FB32;195
        dl Text_196_Dialog_WorkDayLike                     ;B7FB92;196
        dl Text_197_Weather_RainingHardOutsideMightCatch                     ;B7FBD6;197
        dl Text_198_Weather_SnowHardlyWaitforSpring                     ;B7FC52;198
        dl Text_199_Dialog_QuietLikeTimeStops                     ;B7FCA2;199
        dl Text_19A_Dialog_GoingBackMyParentsHome                     ;B7FCF2;19a
        dl Text_19B_Dialog_CamePickMeUpSorry                     ;B7FD48;19b
        dl Text_19C_Dialog_AngryAnyMoreOnlyLittle                     ;B7FD9A;19c
        dl Text_19D_Dialog_WaaaMissed                     ;B7FDF4;19d
        dl Text_19E_Dialog_BackHonestWasSorry                     ;B7FE1A;19e
        dl Text_19F_Dialog_KnowGetMadatBecauseyouAlways                     ;B7FE7C;19f
        dl Text_1A0_Dialog_DarlingShallPaintHouseBeautiful                     ;B7FF22;1a0
        dl Text_1A1_Dialog_HasBecomePrettyHouse                     ;B7FFA0;1a1
        dl Text_1A2_Dialog_UummmmSayUmmGuessPregnant                     ;B88000;1a2
        dl Text_1A3_Dialog_ItllBornSomeTimeLater                     ;B8809C;1a3
        dl Text_1A4_Dialog_ThinkNameFortheBaby                     ;B880E2;1a4
        dl Text_1A5_Dialog_FeelMyBodyBecomingLittle                     ;B8812E;1a5
        dl Text_1A6_Romance_WonderIfBoyorGirl                     ;B88186;1a6
        dl Text_1A7_Dialog_KnowWalkAroundMuch                     ;B881D4;1a7
        dl Text_1A8_Dialog_FeelStrangeGoingHaveBaby                     ;B8821E;1a8
        dl Text_1A9_Dialog_GetOutMyWayGet                     ;B8828C;1a9
        dl Text_1AA_Dialog_HoneyWorryGoWorkC                     ;B882C4;1aa
        dl Text_1AB_Dialog_Alright                     ;B88374;1ab
        dl Text_1AC_Dialog_MeThank                     ;B88396;1ac
        dl Text_1AD_Dialog_UughUugh                     ;B883CE;1ad
        dl Text_1AE_Church_MyGodBabyComing                     ;B883EA;1ae
        dl Text_1AF_Dialog_FalteringFaltering                     ;B88432;1af
        dl Text_1B0_Dialog_TakeEasy                     ;B8845C;1b0
        dl Text_1B1_Dialog_WalkingAbout                     ;B88478;1b1
        dl Text_1B2_Dialog_GuessGotOldEnoughAble                     ;B884A8;1b2
        dl Text_1B3_Dialog_WaahWaah                     ;B8853C;1b3
        dl Text_1B4_Dialog_HoHoHoVeryHealthy                     ;B88556;1b4
        dl Text_1B5_Dialog_Great                     ;B885B2;1b5
        dl Text_1B6_Dialog_PhewHaventNervousYears                     ;B885C0;1b6
        dl Text_1B7_Romance_LooksLikeNinaButHas                     ;B8861E;1b7
        dl Text_1B8_Animal_RemindsMeNinaWasBorn                     ;B8869C;1b8
        dl Text_1B9_Animal_RemindsMeEveWasBorn                     ;B886E8;1b9
        dl Text_1BA_Dialog_DarlingNameHim                     ;B88734;1ba
        dl Text_1BB_Dialog_ThankHoneyHappy                     ;B88768;1bb
        dl Text_1BC_Dialog_JqCmCrGsBaby                     ;B887AE;1bc
        dl Text_1BD_Romance_PresentGladRememberedAnniversary                     ;B88800;1bd
        dl Text_1BE_Dialog_LaLaLa                     ;B8888A;1be
        dl Text_1BF_Romance_JtCnCuGvGot                     ;B8889C;1bf
        dl Text_1C0_Dialog_Dah                     ;B888F4;1c0
        dl Text_1C1_Dialog_DaDa                     ;B88902;1c1
        dl Text_1C2_Dialog_BooBoo                     ;B88914;1c2
        dl Text_1C3_Shop_BlueFeatherHappinessHappinessDifferent                     ;B8892A;1c3
        dl Text_1C4_Church_GodBless                     ;B88AC4;1c4
        dl Text_1C5_Dialog_ConsiderManyTimesBecauseBig                     ;B88AE2;1c5
        dl Text_1C6_Romance_SillyMarried                     ;B88B7A;1c6
        dl Text_1C7_Dialog_WhoPlayingJokeYoungMan                     ;B88BB2;1c7
        dl Text_1C8_Dialog_Come                     ;B88C06;1c8
        dl Text_1C9_Dialog_GivingWrongPerson                     ;B88C2E;1c9
        dl Text_1CA_Romance_HaveGiveGirlLoveGirl                     ;B88C82;1ca
        dl Text_1CB_Dialog_WowBlueFeatherShowMe                     ;B88D22;1cb
        dl Text_1CC_Animal_GoodMorningExcuseMeBothering                     ;B88D78;1cc
        dl Text_1CD_Romance_MariaDadWasWrongCome                     ;B88F60;1cd
        dl Text_1CE_Romance_UsuallyQuietGirlButReason                     ;B88FE8;1ce
        dl Text_1CF_Romance_SeemsMariaFatherArguedOver                     ;B890FE;1cf
        dl Text_1D0_Sign_ThinkMariaWentUpThemountain                     ;B89166;1d0
        dl Text_1D1_Mountain_MariaGoWenttoExactlyNortheast                     ;B8920A;1d1
        dl Text_1D2_Church_RushAboutPrayingWhile                     ;B892A6;1d2
        dl Text_1D3_Romance_GirlHaventSeenAny                     ;B89308;1d3
        dl Text_1D4_Romance_WantTodayLookingGirl                     ;B89354;1d4
        dl Text_1D5_Dialog_UummNKnowSureKnow                     ;B893D4;1d5
        dl Text_1D6_Dialog_SorryGoingHomeThank                     ;B89486;1d6
        dl Text_1D7_Dialog_WhatsGoing                     ;B894DC;1d7
        dl Text_1D8_Romance_HoHoHoMariaBack                     ;B8951E;1d8
        dl Text_1D9_Dialog_Rude                     ;B89620;1d9
        dl Text_1DA_Dialog_LikeSmellMuch                     ;B89634;1da
        dl Text_1DB_Weather_HaveSeenMyWeatherCock                     ;B89678;1db
        dl Text_1DC_Weather_MadeWeatherCockFormyWife                     ;B8983E;1dc
        dl Text_1DD_Weather_DirectionWhichWeatherCockWent                     ;B89938;1dd
        dl Text_1DE_Dialog_FindAha                     ;B89A38;1de
        dl Text_1DF_Dialog_CameBackHomeSuchAhurry                     ;B89A6E;1df
        dl Text_1E0_Animal_TraditionAreaCalledBlueFeather                     ;B89B24;1e0
        dl Text_1E1_Dialog_HangingMyMemoryButPrecious                     ;B89C2E;1e1
        dl Text_1E2_Town_NiceYoungPeopleWantCheerful                     ;B89CCC;1e2
        dl Text_1E3_Sign_NinaHasntBackSinceWent                     ;B89D76;1e3
        dl Text_1E4_Dialog_DadOutTakingCareMother                     ;B89E2A;1e4
        dl Text_1E5_Town_HerbGrassTinyLittleWhite                     ;B89E80;1e5
        dl Text_1E6_Romance_MmmmGirlFellDownDark                     ;B89F04;1e6
        dl Text_1E7_Dialog_ThankGoodMomBetter                     ;B89FBE;1e7
        dl Text_1E8_Dialog_MoveAnyMore                     ;B8A020;1e8
        dl Text_1E9_Romance_HehHehNinaAlwaysWants                     ;B8A064;1e9
        dl Text_1EA_Dialog_HaveDoneTimeAllPretty                     ;B8A12E;1ea
        dl Text_1EB_Dialog_MyPChanGoneIf                     ;B8A1AC;1eb
        dl Text_1EC_Dialog_RecentlyCuteCustomerCame                     ;B8A234;1ec
        dl Text_1ED_Romance_EllensBirdFlewAwayPretty                     ;B8A282;1ed
        dl Text_1EE_Dialog_Aha                     ;B8A2EC;1ee
        dl Text_1EF_Sign_WhichDirectionBluebirdGoThink                     ;B8A2FA;1ef
        dl Text_1F0_Romance_EllenDependsLookAfter                     ;B8A3B8;1f0
        dl Text_1F1_Romance_SorryNowWasAlwaysCheered                     ;B8A448;1f1
        dl Text_1F2_Dialog_ThankLookingMybird                     ;B8A5DA;1f2
        dl Text_1F3_Dialog_RecentlyNothing                     ;B8A61E;1f3
        dl Text_1F4_Dialog_VeryBusy                     ;B8A66C;1f4
        dl Text_1F5_Sign_GoodGodOldHunterLocked                     ;B8A69C;1f5
        dl Text_1F6_Dialog_HelpMyGrandpa                     ;B8A6FC;1f6
        dl Text_1F7_Diary_WeveGotSaveHimAs                     ;B8A72C;1f7
        dl Text_1F8_Sign_GoForwardBecauseInsideCave                     ;B8A788;1f8
        dl Text_1F9_Dialog_GladMadeHesPromisingYoung                     ;B8A80E;1f9
        dl Text_1FA_Manual_HaveGotHammerHammer                     ;B8A870;1fa
        dl Text_1FB_Sign_WhoEveSayGrandfatherWas                     ;B8A8BA;1fb
        dl Text_1FC_Romance_GroanOuchPhewTooOld                     ;B8A986;1fc
        dl Text_1FD_Dialog_GrandpaGladToseeAlright                     ;B8AA4E;1fd
        dl Text_1FE_Dialog_HaveGottenOutMyself                     ;B8AABA;1fe
        dl Text_1FF_Town_GrandpaScaredMeDeathUnreasonable                     ;B8AB14;1ff
        dl Text_200_Dialog_Thank                     ;B8ABE8;200
        dl Text_201_Festival_FlowerFestivalTomorrowWholeTown                     ;B8ABFE;201
        dl Text_202_Festival_FlowerFestivalOnceUponTime                     ;B8AD42;202
        dl Text_203_Shipping_SellingWonderfulThingsFestivalTomorrow                     ;B8AF26;203
        dl Text_204_Dialog_GivingPresentYear                     ;B8AFD6;204
        dl Text_205_Manual_GodHasTaughtUsHeart                     ;B8B034;205
        dl Text_206_Festival_FlowerFestivalTomorrowAlsoCelebrate                     ;B8B0F2;206
        dl Text_207_Festival_FlowerFestivalTomorrowGoodRelax                     ;B8B18A;207
        dl Text_208_Festival_FlowerFestivalTomorrowLoveBest                     ;B8B21C;208
        dl Text_209_Shop_BuyAllUnusualStuffFestival                     ;B8B2B8;209
        dl Text_20A_Festival_HehLoveFestivalsLookingForward                     ;B8B31E;20a
        dl Text_20B_Festival_OneHasGoFestivalBut                     ;B8B384;20b
        dl Text_20C_Shipping_SellingBottlesSomeWonderfulPerfume                     ;B8B408;20c
        dl Text_20D_Town_MadeRoseFlowersSmellsSweet                     ;B8B4CA;20d
        dl Text_20E_Shop_MadeLilacFlowersFragranceMild                     ;B8B63C;20e
        dl Text_20F_Shop_MadeVioletFlowersFragranceMakes                     ;B8B7C0;20f
        dl Text_210_Dialog_ThankVeryMuchCarefulDrop                     ;B8B92E;210
        dl Text_211_Dialog_SeeLittleDisappointed                     ;B8B9C4;211
        dl Text_212_Dialog_WowThanksLotMmmmSmells                     ;B8BA18;212
        dl Text_213_Dialog_MisterHaveEnoughMoney                     ;B8BA70;213
        dl Text_214_Weather_HaveVeryRareProductTime                     ;B8BACE;214
        dl Text_215_Sign_DeliverShedUseWinterMountain                     ;B8BCDC;215
        dl Text_216_Dialog_BitDisappointedGuaranteeHaveNext                     ;B8BD76;216
        dl Text_217_Manual_FragranceMakesPeopleFeelCalm                     ;B8BE10;217
        dl Text_218_Animal_ComesDownBuy                     ;B8BE6C;218
        dl Text_219_Animal_FeelCalmSeeFlowersMean                     ;B8BEC4;219
        dl Text_21A_Shop_WantBuyBottlePerfumeMy                     ;B8BF24;21a
        dl Text_21B_Romance_FragranceSoapBestGirls                     ;B8BF8A;21b
        dl Text_21C_Church_SayStatueGoddessLand                     ;B8BFEA;21c
        dl Text_21D_Sign_GoddessLandLivesThemountainVery                     ;B8C04C;21d
        dl Text_21E_Church_SayGoddessOflandLivesSmall                     ;B8C136;21e
        dl Text_21F_Romance_ThinkCarefullyAboutGirlsTastes                     ;B8C1B6;21f
        dl Text_220_Animal_MyHeartWarmsUpJoys                     ;B8C238;220
        dl Text_221_Romance_FlowersSoftenPeoplesMindsMay                     ;B8C2EC;221
        dl Text_222_Church_FlowersOneMostWonderfulGifts                     ;B8C37E;222
        dl Text_223_Festival_LetsDanceLaterDarling                     ;B8C3EA;223
        dl Text_224_Romance_DadWandersLikeEveryYear                     ;B8C422;224
        dl Text_225_Town_LetSeeHaveCharacterFit                     ;B8C466;225
        dl Text_226_Romance_ProbablyLikesTypeGirlWho                     ;B8C4E8;226
        dl Text_227_Dialog_SureButMightBeneatWork                     ;B8C56A;227
        dl Text_228_Town_FlowersCoverWholeTownHappy                     ;B8C5F6;228
        dl Text_229_Dialog_SayHappyComeVeGot                     ;B8C67C;229
        dl Text_22A_Romance_HeavenSupposeBloomingFlowersEverywhere                     ;B8C700;22a
        dl Text_22B_Festival_DanceMuchBetterNow                     ;B8C7D2;22b
        dl Text_22C_Dialog_TooMuchPerfumeMakesMe                     ;B8C814;22c
        dl Text_22D_Church_BelieveStoryGoddessMadeFlowers                     ;B8C860;22d
        dl Text_22E_Festival_WonderIfMenVeryinterestedKind                     ;B8C914;22e
        dl Text_22F_Festival_GoodMerryFestivalSometimes                     ;B8C998;22f
        dl Text_230_Manual_HehHehGetRelaxedSmell                     ;B8C9F8;230
        dl Text_231_Church_GodsGotLittleSenseHumor                     ;B8CA66;231
        dl Text_232_Town_SayMuchPrettierThanFlowers                     ;B8CB52;232
        dl Text_233_Romance_ForgiveIfPickUpAnother                     ;B8CBFA;233
        dl Text_234_Festival_StartDancingNowIfHavent                     ;B8CC66;234
        dl Text_235_Dialog_NowPickUpPartner                     ;B8CD94;235
        dl Text_236_Dialog_IfHaveSomeMoreHurry                     ;B8CDC8;236
        dl Text_237_Festival_NowComesYearsHarvestFestival                     ;B8CE14;237
        dl Text_238_Festival_HarvestFestivalTomorrow                     ;B8CFBA;238
        dl Text_239_Festival_HaveDecidedTakeFestivalWantto                     ;B8D006;239
        dl Text_23A_Dialog_WhatsGoodWonderIfherbsSpices                     ;B8D0D8;23a
        dl Text_23B_Dialog_TakeSomethingVeryDeliciousTomorrow                     ;B8D14A;23b
        dl Text_23C_Festival_HarvestFestivalTomorrowLoveSinging                     ;B8D1E2;23c
        dl Text_23D_Festival_HaveHarvestFestivalTomorrowRight                     ;B8D280;23d
        dl Text_23E_Festival_HarvestFestivalCelebratingYearsHarvest                     ;B8D32C;23e
        dl Text_23F_Dialog_BringFoodsEatGreatHarvest                     ;B8D3AE;23f
        dl Text_240_Animal_HarvestFestivalTomorrowStopWork                     ;B8D41E;240
        dl Text_241_Dialog_WelcomePutBroughtStewNow                     ;B8D5E6;241
        dl Text_242_Dialog_BringAnythingAlright                     ;B8D650;242
        dl Text_243_Dialog_NowWaitUntilDone                     ;B8D6AE;243
        dl Text_244_Dialog_StewEatGratitude                     ;B8D6E2;244
        dl Text_245_Town_MineWasFlowersWasFairly                     ;B8D748;245
        dl Text_246_Romance_WasDeliciousKnowHaveWife                     ;B8D79A;246
        dl Text_247_Animal_CuttingGrassCutAutumnTry                     ;B8D8DE;247
        dl Text_248_Animal_HappyOnlyIfTasteEat                     ;B8DA26;248
        dl Text_249_Dialog_Stuffed                     ;B8DAA4;249
        dl Text_24A_Shop_GoodDayTodaySomeFamous                     ;B8DABE;24a
        dl Text_24B_Shop_GoodDayTodaySomeRice                     ;B8DC20;24b
        dl Text_24C_Dialog_ThankCarefulTogetAddicted                     ;B8DDD6;24c
        dl Text_24D_Dialog_SayOneBiteMakesHappy                     ;B8DE2A;24d
        dl Text_24E_Manual_BringAnythingYearSuchHard                     ;B8DE94;24e
        dl Text_24F_Dialog_FruitsSouthernCountryTasteGood                     ;B8DF36;24f
        dl Text_250_Festival_DanceVeryYet                     ;B8DFEE;250
        dl Text_251_Dialog_DancingStartPrettySoon                     ;B8E028;251
        dl Text_252_Church_EvenIfBelieveIngodGood                     ;B8E06C;252
        dl Text_253_Church_EvenIfBelieveIngodGood                     ;B8E14E;253
        dl Text_254_Church_GoddessLandExistsSure                     ;B8E1D2;254
        dl Text_255_Dialog_ThoughtTime                     ;B8E22C;255
        dl Text_256_Dialog_EatWantC                     ;B8E27E;256
        dl Text_257_Dialog_ThankNice                     ;B8E308;257
        dl Text_258_Dialog_Waaa                     ;B8E340;258
        dl Text_259_Dialog_MadePumpkinPieWantTry                     ;B8E34C;259
        dl Text_25A_Dialog_YearsPumpkinsSweet                     ;B8E3F8;25a
        dl Text_25B_Dialog_YeahPumpkinPieHasReceived                     ;B8E456;25b
        dl Text_25C_Manual_GiveSpecialSouvenirClockFree                     ;B8E4C8;25c
        dl Text_25D_Dialog_ThinkImportantThankLandSun                     ;B8E594;25d
        dl Text_25E_Dialog_TaraahAutoHarvestingMachineSwitch                     ;B8E648;25e
        dl Text_25F_Dialog_SorryFailed                     ;B8E708;25f
        dl Text_260_Dialog_Afraid                     ;B8E724;260
        dl Text_261_Dialog_Right                     ;B8E754;261
        dl Text_262_Dialog_TasteGoodHuhCalledFruit                     ;B8E784;262
        dl Text_263_Dialog_PickUpFirstThingMorning                     ;B8E8A2;263
        dl Text_264_Dialog_SpecialMeatPieImadeWant                     ;B8E922;264
        dl Text_265_Romance_MakeEverythingEatSeemDelicious                     ;B8E9C0;265
        dl Text_266_Dialog_AlrightPrettyGoodThough                     ;B8EA52;266
        dl Text_267_Mountain_BerryJuiceMadeLastYear                     ;B8EA9C;267
        dl Text_268_Dialog_IfThinkManDrinkUp                     ;B8EB94;268
        dl Text_269_Dialog_GoodThough                     ;B8EBE0;269
        dl Text_26A_Romance_OofSorryFeelGoodHave                     ;B8EC16;26a
        dl Text_26B_Dialog_TaraaaImprovedAutoHarvestingMachine                     ;B8ED30;26b
        dl Text_26C_Dialog_Weird                     ;B8EDEA;26c
        dl Text_26D_Dialog_HaHaHaHaHa                     ;B8EDFE;26d
        dl Text_26E_Festival_StarNightFestivaltomorrowCoupleofPlaces                     ;B8EE96;26e
        dl Text_26F_Dialog_WildGrapeJuiceSweetGood                     ;B8EF96;26f
        dl Text_270_Dialog_CheersGiftsEarth                     ;B8F052;270
        dl Text_271_Dialog_VerySociable                     ;B8F098;271
        dl Text_272_Animal_FlowerFestivalTomorrowStopWork                     ;B8F0E8;272
        dl Text_273_Weather_InformationEventHaveAnnualeggFestival                     ;B8F2FA;273
        dl Text_274_Animal_EggFestivalTomorrowStopWork                     ;B8F436;274
        dl Text_275_Dialog_KidneyPieProudTryC                     ;B8F61C;275
        dl Text_276_Dialog_VeryNourishingThough                     ;B8F6D6;276
        dl Text_277_Mountain_YearOldBerryJuiceSmells                     ;B8F71E;277
        dl Text_278_Dialog_MyGrandpasFavoriteJuice                     ;B8F7F0;278
        dl Text_279_Dialog_DrinkMyJuice                     ;B8F836;279
        dl Text_27A_Romance_MayAbleHavePleasantMoments                     ;B8F87E;27a
        dl Text_27B_Romance_UltraSpecialAutoHarvestingMachine                     ;B8F8EC;27b
        dl Text_27C_Dialog_WhetherLikeItor                     ;B8FA4E;27c
        dl Text_27D_Dialog_FreshIngredientsAffectionNecessaryMake                     ;B8FA96;27d
        dl Text_27E_Dialog_TastyRiceBallsDumplingsTry                     ;B8FB34;27e
        dl Text_27F_Dialog_Congratulations                     ;B8FBF2;27f
        dl Text_280_Dialog_GoingHaveBabyprettySoon                     ;B8FC14;280
        dl Text_281_Romance_HoHoLookBabyCute                     ;B8FC66;281
        dl Text_282_Dialog_HaveMyPartnerYoudBetter                     ;B8FCCC;282
        dl Text_283_Festival_WantDanceSomeoneElse                     ;B8FD46;283
        dl Text_284_Festival_YoungManDanceYoungGirl                     ;B8FD9A;284
        dl Text_285_Dialog_BringMeMoreJuice                     ;B8FDF8;285
        dl Text_286_Dialog_WasDelicious                     ;B8FE22;286
        dl Text_287_Festival_WantDanceSomeoneElse                     ;B8FE46;287
        dl Text_288_Festival_YeahWantDanceMaria                     ;B8FEAA;288
        dl Text_289_Festival_NewYearsFestivaltomorrowSayThelast                     ;B8FEF0;289
        dl Text_28A_Festival_DanceButMeansMoreBecause                     ;B98000;28a
        dl Text_28B_Festival_WhoGoingAskDanceGoing                     ;B980A4;28b
        dl Text_28C_Romance_NeverCancelChooseCarefullyRegret                     ;B98138;28c
        dl Text_28D_Festival_ThanksgivingFestivalTomorrowNiceSmell                     ;B981C4;28d
        dl Text_28E_Festival_ThanksgivingFestivalTomorrowAllHusbands                     ;B982C8;28e
        dl Text_28F_Romance_BecauseGirlsGiveCakesPeople                     ;B9846C;28f
        dl Text_290_Diary_GoingBedNowGoodNight                     ;B9852A;290
        dl Text_291_Dialog_HehHehVeryDeliciousWant                     ;B9857A;291
        dl Text_292_Festival_ThanksgivingFestivalTodayDarlingThank                     ;B98654;292
        dl Text_293_Dialog_WorkNow                     ;B98732;293
        dl Text_294_Dialog_Fidgety                     ;B9877A;294
        dl Text_295_Dialog_ThumpThumpThump                     ;B98790;295
        dl Text_296_Animal_EllenGoodCookAndtakesGood                     ;B987BA;296
        dl Text_297_Romance_LoveMyWifesCakeBut                     ;B988AC;297
        dl Text_298_Dialog_ScorchedCakeAgain                     ;B9892E;298
        dl Text_299_Dialog_WhatShouldIDo                     ;B98964;299
        dl Text_29A_Romance_AnnsHandMadeCakeExplode                     ;B98988;29a
        dl Text_29B_Romance_GetCakeMariaEveryYear                     ;B989EE;29b
        dl Text_29C_Romance_YeahGotCakeMaria                     ;B98A3E;29c
        dl Text_29D_Animal_AbleBakePerfectlyDeliciousCake                     ;B98A84;29d
        dl Text_29E_Dialog_HopeLike                     ;B98B22;29e
        dl Text_29F_Romance_UummThankWorkingEveryDay                     ;B98B7E;29f
        dl Text_2A0_Dialog_Hello                     ;B98BCC;2a0
        dl Text_2A1_Dialog_GiveNotsureIfTastesGood                     ;B98BDA;2a1
        dl Text_2A2_Dialog_WantMedicineCase                     ;B98C54;2a2
        dl Text_2A3_Dialog_MyDadRudeLookedatMy                     ;B98C98;2a3
        dl Text_2A4_Dialog_SpecialHerbCake                     ;B98D1E;2a4
        dl Text_2A5_Dialog_LookVeryGoodButDelicious                     ;B98D6C;2a5
        dl Text_2A6_Dialog_MyMomWanderingAroundBaked                     ;B98DD4;2a6
        dl Text_2A7_Animal_UsedPlentyMilkEggs                     ;B98E78;2a7
        dl Text_2A8_Dialog_HaveConfidenceMakingSweets                     ;B98EBC;2a8
        dl Text_2A9_Dialog_ProbablyThinkMonkeySomethingRight                     ;B98F04;2a9
        dl Text_2AA_Dialog_CakeFulledBerries                     ;B98FCA;2aa
        dl Text_2AB_Dialog_HopeLike                     ;B99014;2ab
        dl Text_2AC_Festival_NowStarNightFestivalTomorrow                     ;B9903C;2ac
        dl Text_2AD_Animal_StarNightFestivalSupposedPray                     ;B99148;2ad
        dl Text_2AE_Dialog_LookSkyItllBeautifulTomorrow                     ;B99248;2ae
        dl Text_2AF_Church_GoingPlayOrganChurch                     ;B992C6;2af
        dl Text_2B0_Dialog_TomorrowHehHehGoingWonderful                     ;B99316;2b0
        dl Text_2B1_Dialog_SayGoingNearestplaceStars                     ;B9937A;2b1
        dl Text_2B2_Church_PrayPublicSquareRomantic                     ;B993DA;2b2
        dl Text_2B3_Dialog_LetsHaveBallTomorrowWaiting                     ;B9943C;2b3
        dl Text_2B4_Festival_StarNightFestivaltomorrowGoingPlace                     ;B9949E;2b4
        dl Text_2B5_Festival_StarNightFestivaltomorrowGoingPlace                     ;B99534;2b5
        dl Text_2B6_Sign_StarNightFestivaltodayGoPublic                     ;B99602;2b6
        dl Text_2B7_Church_LadiesGentlemenLetsPrayStars                     ;B996EA;2b7
        dl Text_2B8_Animal_LightStarsSeeingNowMillions                     ;B99756;2b8
        dl Text_2B9_Dialog_MayMyBusinessGetBetter                     ;B9983A;2b9
        dl Text_2BA_Dialog_WantMeReadHoroscopeSure                     ;B99882;2ba
        dl Text_2BB_Romance_GirlWhoGetsAlongWellwith                     ;B99920;2bb
        dl Text_2BC_Dialog_WantKnow                     ;B9999A;2bc
        dl Text_2BD_Animal_CloseMyEyesFeellikeFloating                     ;B999DE;2bd
        dl Text_2BE_Church_PrayEverybodysGoodHealthSecret                     ;B99A64;2be
        dl Text_2BF_Romance_StarsShinningAllTimeSeethem                     ;B99B06;2bf
        dl Text_2C0_Church_SometimesWorkEvenifMuchLove                     ;B99CA4;2c0
        dl Text_2C1_Diary_FeelSleepyNow                     ;B99D8E;2c1
        dl Text_2C2_Dialog_Zzzzzzz                     ;B99DBA;2c2
        dl Text_2C3_Dialog_ThinkHaveGoodDreamTonight                     ;B99DD4;2c3
        dl Text_2C4_Romance_GoodEveningUmmWishweAlso                     ;B99E2A;2c4
        dl Text_2C5_Dialog_LetsSingSongEnjoyYourselves                     ;B99ECA;2c5
        dl Text_2C6_Dialog_NowSingSomething                     ;B99F26;2c6
        dl Text_2C7_Dialog_HappenedTonightCoincidentHappensToo                     ;B99F56;2c7
        dl Text_2C8_Romance_AhGoodEveningNinaAlways                     ;B9A020;2c8
        dl Text_2C9_Dialog_CheersBeautifulSkyinNight                     ;B9A0D4;2c9
        dl Text_2CA_Dialog_HavingFunCheersFateStar                     ;B9A128;2ca
        dl Text_2CB_Romance_SeeSeeShootingStarEvery                     ;B9A1C8;2cb
        dl Text_2CC_Romance_MakeWishNinaWishedTitter                     ;B9A2C2;2cc
        dl Text_2CD_Dialog_TakeHotSpringBathWatching                     ;B9A350;2cd
        dl Text_2CE_Church_MayEverybodyLiveHappilyNow                     ;B9A406;2ce
        dl Text_2CF_Church_HavePrayedAlreadyAlsoImportant                     ;B9A470;2cf
        dl Text_2D0_Dialog_MayEarthGiveUsGifts                     ;B9A538;2d0
        dl Text_2D1_Dialog_YearTell                     ;B9A58E;2d1
        dl Text_2D2_Dialog_MayMyBusinessGoThisyear                     ;B9A5D4;2d2
        dl Text_2D3_Town_AlrightTellingFortuneC                     ;B9A620;2d3
        dl Text_2D4_Dialog_PickUpAnyCardLike                     ;B9A6AC;2d4
        dl Text_2D5_Romance_ExcellentLuckGreatHarvestEverything                     ;B9A764;2d5
        dl Text_2D6_Dialog_LuckFairHarvestPersonWaiting                     ;B9A800;2d6
        dl Text_2D7_Town_MisfortuneNothingTurnOutGood                     ;B9A88E;2d7
        dl Text_2D8_Romance_SeeBetterDevelopMywayMyself                     ;B9A8FE;2d8
        dl Text_2D9_Dialog_WhmmmGoingGoodYear                     ;B9A954;2d9
        dl Text_2DA_Dialog_MayYearGoodYearfor                     ;B9A9A2;2da
        dl Text_2DB_Dialog_SeeFirstSunriseBeginningYear                     ;B9A9EC;2db
        dl Text_2DC_Dialog_Best                     ;B9AA70;2dc
        dl Text_2DD_Animal_NowAnnualEggSearchinggameAutumn                     ;B9AA96;2dd
        dl Text_2DE_Dialog_GoFirstOne                     ;B9AC36;2de
        dl Text_2DF_Dialog_ComeHurryUpTimeRunning                     ;B9AC7A;2df
        dl Text_2E0_Dialog_BeatenThoseYoungKids                     ;B9ACD2;2e0
        dl Text_2E1_Dialog_PrizeJuice                     ;B9AD22;2e1
        dl Text_2E2_Dialog_SayWinnerGettheGreatPrize                     ;B9AD4A;2e2
        dl Text_2E3_Dialog_LittleKidsNeedHandicap                     ;B9ADA4;2e3
        dl Text_2E4_Dialog_AlrightTryWinYear                     ;B9ADDA;2e4
        dl Text_2E5_Town_HearPrizeSeedRareFlower                     ;B9AE28;2e5
        dl Text_2E6_Dialog_IfExWereFindVery                     ;B9AE88;2e6
        dl Text_2E7_Dialog_SameColorGetPointNext                     ;B9AEEA;2e7
        dl Text_2E8_Romance_GameOverAnnouncingWinnerEverybody                     ;B9AF6E;2e8
        dl Text_2E9_Dialog_BingoCorrectNextOne                     ;B9B016;2e9
        dl Text_2EA_Animal_WinnerYearsEggFestivalMr                     ;B9B072;2ea
        dl Text_2EB_Sign_YearsPrizeFodderOneWhole                     ;B9B0F4;2eb
        dl Text_2EC_Dialog_CongratulationsDeliverPrizeHome                     ;B9B1A2;2ec
        dl Text_2ED_Romance_NowEverybodyLetsBestYear                     ;B9B21E;2ed
        dl Text_2EE_Dialog_HumiliatingYoungMen                     ;B9B27E;2ee
        dl Text_2EF_Dialog_PhewLikeUsually                     ;B9B2CC;2ef
        dl Text_2F0_Dialog_HicHaveCome                     ;B9B32A;2f0
        dl Text_2F1_Dialog_PuffPuff                     ;B9B36E;2f1
        dl Text_2F2_Dialog_PuffPuffSpeakMe                     ;B9B384;2f2
        dl Text_2F3_Town_SeedFlowerWhoSaid                     ;B9B3DC;2f3
        dl Text_2F4_Dialog_PhewGoodHealthyBodyExercise                     ;B9B442;2f4
        dl Text_2F5_Festival_NewYearsFestivalLetsGo                     ;B9B4C8;2f5
        dl Text_2F6_Manual_SeedGrassThisgrassGrowsWithout                     ;B9B534;2f6
        dl Text_2F7_Dialog_ThankDeliverShed                     ;B9B66E;2f7
        dl Text_2F8_Dialog_ThankVeryMuch                     ;B9B6C2;2f8
        dl Text_2F9_Dialog_AhHaveEnoughMoney                     ;B9B6EC;2f9
        dl Text_2FA_Dialog_ThankComeVisitMeAgain                     ;B9B740;2fa
        dl Text_2FB_Manual_BuyingCowThenGiveBell                     ;B9B786;2fb
        dl Text_2FC_Shop_SpecialPaintHouseOnlyG                     ;B9B924;2fc
        dl Text_2FD_Dialog_ThankDeliverShed                     ;B9BA58;2fd
        dl Text_2FE_Dialog_GoodStuffThough                     ;B9BAAC;2fe
        dl Text_2FF_Dialog_HaveEnoughMoney                     ;B9BADC;2ff
        dl Text_300_Animal_HorseHasBecomeBigMade                     ;B9BB30;300
        dl Text_301_Animal_MedicineCowsSickHealsOnly                     ;B9BCA0;301
        dl Text_302_Dialog_DeliverShed                     ;B9BE94;302
        dl Text_303_Dialog_Aha                     ;B9BED8;303
        dl Text_304_Diary_HaveEnoughMoneyComeBack                     ;B9BEE2;304
        dl Text_305_Animal_WantTodayBuyCowSell                     ;B9BF8C;305
        dl Text_306_Animal_NeedHaveMoreGrassRaise                     ;B9C056;306
        dl Text_307_Animal_CowCostsGBuyingOne                     ;B9C0B6;307
        dl Text_308_Dialog_DeliverPen                     ;B9C1A2;308
        dl Text_309_Animal_IfWantSellCowsAgain                     ;B9C1DC;309
        dl Text_30A_Animal_ChickenCostsGButWant                     ;B9C256;30a
        dl Text_30B_Dialog_ComePickUpLaterLet                     ;B9C33E;30b
        dl Text_30C_Animal_PutCowPenTakeGood                     ;B9C3EA;30c
        dl Text_30D_Animal_EvenThinkSellingCowCondition                     ;B9C4D2;30d
        dl Text_30E_Shipping_CostsEaGWanttoSell                     ;B9C57E;30e
        dl Text_30F_Dialog_TakeMe                     ;B9C65A;30f
        dl Text_310_Dialog_AcceptUntilItsgrownMore                     ;B9C68E;310
        dl Text_311_Dialog_OutsideTakeWithyouItllEat                     ;B9C6DE;311
        dl Text_312_Manual_MilkerMilkUsingTowardCow                     ;B9C7E4;312
        dl Text_313_Dialog_SorryButAccept                     ;B9C8FA;313
        dl Text_314_Manual_BrushCowsBecomeHappyBrush                     ;B9C93E;314
        dl Text_315_Animal_FatherHeavenHelpPreciousCow                     ;B9CAB4;315
        dl Text_316_Animal_IdiotTellTakeCareCows                     ;B9CB24;316
        dl Text_317_Dialog_GreatCalfWasBornName                     ;B9CC3C;317
        dl Text_318_Dialog_CalfAlrightName                     ;B9CC90;318
        dl Text_319_Dialog_Name                     ;B9CCE4;319
        dl Text_31A_Shipping_AllShippingtodayCostsGIntotal                     ;B9CD1E;31a
        dl Text_31B_Shipping_ShippingTodayBye                     ;B9CDDC;31b
        dl Text_31C_Sign_BusinessHoursWeekdayPmWeekend                     ;B9CE24;31c
        dl Text_31D_Dialog_ThrowThingsSpring                     ;B9CEC8;31d
        dl Text_31E_Manual_GoddessSpringExpectMeCome                     ;B9CF10;31e
        dl Text_31F_Church_LyingYoursThisoneGodKnows                     ;B9D08C;31f
        dl Text_320_Manual_FoundHonestPersonGivingThisgold                     ;B9D11E;320
        dl Text_321_Manual_ExcuseMeButBorrowHammer                     ;B9D292;321
        dl Text_322_Animal_ThankPutMorePowerReturn                     ;B9D326;322
        dl Text_323_Dialog_AskAnyMore                     ;B9D38E;323
        dl Text_324_Animal_PlowFieldBeforeSpringBut                     ;B9D3D2;324
        dl Text_325_Dialog_HasRanchBecomeLively                     ;B9D4A0;325
        dl Text_326_Dialog_GoOut                     ;B9D502;326
        dl Text_327_Manual_RanchUseSickleTheshedHows                     ;B9D536;327
        dl Text_328_Dialog_WowMadeHappyMakeBetter                     ;B9D614;328
        dl Text_329_Dialog_UseMadeAllMyEnergy                     ;B9D6AC;329
        dl Text_32A_Dialog_ByeBye                     ;B9D72C;32a
        dl Text_32B_Dialog_GiGiveMeSomethingEat                     ;B9D73E;32b
        dl Text_32C_Mountain_MushroomIfPossibleWantaMushroom                     ;B9D780;32c
        dl Text_32D_Dialog_PhewAliveNowThankVery                     ;B9D7D8;32d
        dl Text_32E_Mountain_PoisonousMushroomKillKnow                     ;B9D908;32e
        dl Text_32F_Mountain_MashMushroomWantNothingBut                     ;B9D976;32f
        dl Text_330_Dialog_StopRabbitMineDoingLet                     ;B9D9DE;330
        dl Text_331_Shop_IfBuyGWantPay                     ;B9DAB4;331
        dl Text_332_Dialog_LiveLikeBye                     ;B9DBAE;332
        dl Text_333_Romance_SeeKindWantMoneyBut                     ;B9DBDC;333
        dl Text_334_Dialog_HandRabbitLiveLikeBye                     ;B9DCCC;334
        dl Text_335_Mountain_SpiritWaterImpGaveMy                     ;B9DD46;335
        dl Text_336_Dialog_AhFirstHumanLongHad                     ;B9DE38;336
        dl Text_337_Diary_NowTakeSellExpensivePrice                     ;B9DF78;337
        dl Text_338_Dialog_GoHomeAsSoonAs                     ;B9E038;338
        dl Text_339_Romance_ThankLettingBloomOneHas                     ;B9E072;339
        dl Text_33A_Church_BothFlowerAndiDisappearSoon                     ;B9E178;33a
        dl Text_33B_Shop_MiraclePotionGoodLuckMedicine                     ;B9E238;33b
        dl Text_33C_Manual_TomatoSeedEconomicalBecauseEven                     ;B9E408;33c
        dl Text_33D_Animal_PotatoSeedHarvestLeavesBecome                     ;B9E598;33d
        dl Text_33E_Shipping_TurnipSeedTakeLongHarvest                     ;B9E6D2;33e
        dl Text_33F_Manual_CornSeedTakestheLongestTime                     ;B9E868;33f
        dl Text_340_Shipping_FlowerBloomsOneDayBut                     ;B9EA40;340
        dl Text_341_Sign_FeedCowsFeedingsPerBag                     ;B9EBAA;341
        dl Text_342_Sign_FeedChickensFeedingsPerBag                     ;B9ED36;342
        dl Text_343_Manual_SprinklerWaterVeryQuicklyCheap                     ;B9EEF8;343
        dl Text_344_Manual_SuperSickleInventedIfTrade                     ;B9F09A;344
        dl Text_345_Manual_SuperHoeVeryPowerfulIf                     ;B9F1EC;345
        dl Text_346_Manual_SuperHammerKnockBigRock                     ;B9F338;346
        dl Text_347_Manual_SuperAxeChopLogOne                     ;B9F4C8;347
        dl Text_348_Shop_CakeGoodPresentRecoveryStamina                     ;B9F62C;348
        dl Text_349_Dialog_ThankPerishableSoeatWhileStill                     ;B9F75A;349
        dl Text_34A_Dialog_KnowGood                     ;B9F7CA;34a
        dl Text_34B_Animal_PlaceHatchEggsPlaceEggs                     ;B9F822;34b
        dl Text_34C_Animal_ShippingBoxEggs                     ;B9F88A;34c
        dl Text_34D_Animal_ShippingBoxMilk                     ;B9F8BA;34d
        dl Text_34E_Animal_GetCowsGiveBirth                     ;B9F8EA;34e
        dl Text_34F_Sign_TakeOutSpoutFodderCut                     ;B9F952;34f
        dl Text_350_Animal_MilkBuyingGdoAgreeMoney                     ;B9F9C4;350
        dl Text_351_Animal_MilkBuyingGbutMoneyHv                     ;B9FAA6;351
        dl Text_352_Animal_MilkBuyingGbutMoneyHw                     ;B9FB88;352
        dl Text_353_Shop_CornBuyingGButMoney                     ;B9FC6A;353
        dl Text_354_Shop_RipenedTomatoBuyingGBut                     ;B9FD5E;354
        dl Text_355_Shop_PotatoBuyingGButMoney                     ;B9FE82;355
        dl Text_356_Shop_TurnipGoodShapeBuyingG                     ;BA8000;356
        dl Text_357_Animal_FreshEggBuyingGBut                     ;BA8112;357
        dl Text_358_Mountain_MushroomAboutGMoneyH                     ;BA8218;358
        dl Text_359_Animal_PoisonousMushroomMedicineCompoundedAbout                     ;BA82EE;359
        dl Text_35A_Dialog_GoodHerbAboutGMoney                     ;BA8446;35a
        dl Text_35B_Mountain_AhBerryWildGrapeSmells                     ;BA8546;35b
        dl Text_35C_Dialog_BoyTropicalFruitAboutG                     ;BA866A;35c
        dl Text_35D_Shop_AhRareThingAberryFullmoon                     ;BA8782;35d
        dl Text_35E_Shop_VeryFreshFishBuyingG                     ;BA88D2;35e
        dl Text_35F_Diary_Sleeping                     ;BA89E4;35f
        dl Text_360_Animal_GoodLordGoldenEggNever                     ;BA89F8;360
        dl Text_361_Festival_DarlingGoingFestival                     ;BA8B92;361
        dl Text_362_Festival_GoodFestivalLikeChange                     ;BA8BE6;362
        dl Text_363_Festival_KnowBusyButLetsGo                     ;BA8C66;363
        dl Text_364_Dialog_TraditionHundredsYearsAgoSeem                     ;BA8CD2;364
        dl Text_365_Romance_HaveHadTooMuchBeverage                     ;BA8D54;365
        dl Text_366_Mountain_MushroomEatEatC                     ;BA8DE6;366
        dl Text_367_Dialog_LooksLittleDangerousEatEat                     ;BA8E4A;367
        dl Text_368_Mountain_BerryWildGrapeEatEat                     ;BA8EE8;368
        dl Text_369_Dialog_SomethingSmellsStrongEatEat                     ;BA8F7E;369
        dl Text_36A_Dialog_SmellsSweetNiceEatEat                     ;BA9014;36a
        dl Text_36B_Dialog_CakeEatEatC                     ;BA9098;36b
        dl Text_36C_Mountain_FishEatEatC                     ;BA90F2;36c
        dl Text_36D_Mountain_GotBerryPowerTree                     ;BA914E;36d
        dl Text_36E_Dialog_MainTapGasOff                     ;BA9192;36e
        dl Text_36F_Dialog_Burning                     ;BA91CA;36f
        dl Text_370_Dialog_SniffSniffGoodSmell                     ;BA91E6;370
        dl Text_371_Dialog_FlierWanttoReadC                     ;BA9218;371
        dl Text_372_Sign_RecoveryStaminaSpaMountains                     ;BA92AA;372
        dl Text_373_Sign_VacationAutumnMushroomgatheringMountainsCovered                     ;BA9314;373
        dl Text_374_Animal_ThWinterMonthThanksgivingThanksgiving                     ;BA941E;374
        dl Text_375_Festival_RdSpringMonthFlowerFestival                     ;BA9528;375
        dl Text_376_Dialog_MyHomeMadePickledVegetables                     ;BA95C0;376
        dl Text_377_Mountain_EvesHomeMadeBerryjuice                     ;BA963C;377
        dl Text_378_Dialog_SuchRestlessGuy                     ;BA9682;378
        dl Text_379_Romance_EverythingAllRight                     ;BA96BC;379
        dl Text_37A_Church_ComeChurchLeastOnceYear                     ;BA96EE;37a
        dl Text_37B_Town_LooksLikeArtificialFlower                     ;BA9752;37b
        dl Text_37C_Animal_LooksLikeOrnamentChickenBut                     ;BA979A;37c
        dl Text_37D_Dialog_Looking                     ;BA982C;37d
        dl Text_37E_Dialog_AhPhotoMyWife                     ;BA9860;37e
        dl Text_37F_Dialog_TouchWithoutPermission                     ;BA98A4;37f
        dl Text_380_Dialog_MyGrandchildsPiggybank                     ;BA98F4;380
        dl Text_381_Romance_EveBroughtJuiceSayingDrink                     ;BA9938;381
        dl Text_382_Dialog_WhatsWritten                     ;BA99C4;382
        dl Text_383_Dialog_TooHeavyPickUpLooks                     ;BA99F0;383
        dl Text_384_Animal_PrizeEggFestivalCharmProtect                     ;BA9A5A;384
        dl Text_385_Dialog_VeryOldOrgan                     ;BA9B0E;385
        dl Text_386_Church_NowLetsPray                     ;BA9B3C;386
        dl Text_387_Dialog_QualitySulfurSpringBenefitsRheumatism                     ;BA9B66;387
        dl Text_388_Dialog_Nothing                     ;BA9C00;388
        dl Text_389_Dialog_ConfirmOriginFire                     ;BA9C24;389
        dl Text_38A_Church_CCzGamonthEbRests                     ;BA9C5C;38a
        dl Text_38B_Dialog_OldLadiesGetColdEasily                     ;BA9D1A;38b
        dl Text_38C_Sign_NoticeSlipperyDangerousRoadTemporarily                     ;BA9DB6;38c
        dl Text_38D_Dialog_NotThis                     ;BA9E5A;38d
        dl Text_38E_Dialog_HeardSomething                     ;BA9E6E;38e
        dl Text_38F_Animal_WinnerYearsEggFestivalLivestock                     ;BA9E9C;38f
        dl Text_390_Animal_BeepTimeUpNextEgg                     ;BA9F38;390
        dl Text_391_Dialog_LateWedBetterGoHome                     ;BA9F70;391
        dl Text_392_Dialog_BetterGoHomeNow                     ;BA9FBC;392
        dl Text_393_Sign_MountainTopMysteriousPlaceRecommend                     ;BA9FE4;393
        dl Text_394_Animal_SaidHappyFlowerBloomsEat                     ;BAA0DC;394
        dl Text_395_Dialog_WorkingHardKnowFoodLazy                     ;BAA1B0;395
        dl Text_396_Dialog_AhWorkingTooHardIsnot                     ;BAA240;396
        dl Text_397_Dialog_DayLikeTodayGoodTothink                     ;BAA2C4;397
        dl Text_398_Dialog_DieWithoutMoneyMoneyNecessary                     ;BAA438;398
        dl Text_399_Weather_WeatherMakesMeFeelDepressed                     ;BAA4CC;399
        dl Text_39A_Dialog_WarmUpBodyCatchCold                     ;BAA56E;39a
        dl Text_39B_Dialog_ColdOutsideHaveFireplaceInthe                     ;BAA5CE;39b
        dl Text_39C_Sign_WinterMakeSomeFlowersDecorate                     ;BAA676;39c
        dl Text_39D_Weather_HardShovelSnowButitFeels                     ;BAA74C;39d
        dl Text_39E_Weather_LikeColdnessOfwinterButLike                     ;BAA7F2;39e
        dl Text_39F_Dialog_SayGiftWorkman                     ;BAA968;39f
        dl Text_3A0_Animal_BusyWinterGatherMaterialsThen                     ;BAA9B2;3a0
        dl Text_3A1_Dialog_Welcome                     ;BAAA52;3a1
        dl Text_3A2_Shipping_ShippingBoxPickUpEvening                     ;BAAA64;3a2
        dl Text_3A3_Animal_AhChickenFeather                     ;BAAB0A;3a3
        dl Text_3A4_Dialog_SecretGardenEntryAllowed                     ;BAAB56;3a4
        dl Text_3A5_Animal_EventsYearStSpringMonth                     ;BAABA0;3a5
        dl Text_3A6_Dialog_Entry                     ;BAAE0C;3a6
        dl Text_3A7_Dialog_Entry                     ;BAAE12;3a7
        dl Text_3A8_Dialog_Entry                     ;BAAE1A;3a8
        dl Text_3A9_Dialog_Entry                     ;BAAE24;3a9
        dl Text_3AA_Dialog_Entry                     ;BAAE30;3aa
        dl Text_3AB_Dialog_Entry                     ;BAAE3E;3ab
        dl Text_3AC_Dialog_Entry                     ;BAAE4E;3ac
        dl Text_3AD_Dialog_Entry                     ;BAAE60;3ad
        dl Text_3AE_Dialog_Entry                     ;BAAE74;3ae
        dl Text_3AF_Dialog_Entry                     ;BAAE8A;3af
        dl Text_3B0_Dialog_ThThank                     ;BAAEA2;3b0
        dl Text_3B1_Dialog_PickUpHerbsWithoutThinking                     ;BAAECA;3b1
        dl Text_3B2_Dialog_ThankLooksDelicious                     ;BAAF3A;3b2
        dl Text_3B3_Dialog_ThankNowBakeCake                     ;BAAF88;3b3
        dl Text_3B4_Dialog_PlayingNastyTrickMe                     ;BAAFDC;3b4
        dl Text_3B5_Dialog_GladGivingMeNeatPresent                     ;BAB02E;3b5
        dl Text_3B6_Shop_TakeCareIfBuyLot                     ;BAB0B4;3b6
        dl Text_3B7_Animal_BeingCrowdedMakesLivestockStressed                     ;BAB15E;3b7
        dl Text_3B8_Dialog_Want                     ;BAB200;3b8
        dl Text_3B9_Dialog_Trouble                     ;BAB222;3b9
        dl Text_3BA_Dialog_WhatIsThis                     ;BAB250;3ba
        dl Text_3BB_Dialog_TakeKindofStuff                     ;BAB26C;3bb
        dl Text_3BC_Dialog_GiveMe                     ;BAB2B8;3bc
        dl Text_3BD_Shipping_PutThingsWantSellTable                     ;BAB2F0;3bd
        dl Text_3BE_Weather_GettingColderWhenitRainsWinter                     ;BAB344;3be
        dl Text_3BF_Romance_AhMrEcWantMaria                     ;BAB40A;3bf
        dl Text_3C0_Romance_MariaDoingLetMeKnow                     ;BAB4AC;3c0
        dl Text_3C1_Romance_MariaOftenTalksaboutLately                     ;BAB52E;3c1
        dl Text_3C2_Animal_AfterAllGirlHappiestwhenSomeone                     ;BAB58A;3c2
        dl Text_3C3_Romance_MrComeOftenbutWantHave                     ;BAB63A;3c3
        dl Text_3C4_Romance_HowsAnnDoingWorkingAs                     ;BAB706;3c4
        dl Text_3C5_Romance_NinaLikesSweetsSuchAs                     ;BAB7B8;3c5
        dl Text_3C6_Mountain_HoHoHoHowsNina                     ;BAB86A;3c6
        dl Text_3C7_Romance_IfWantWifeChooseGirl                     ;BAB90E;3c7
        dl Text_3C8_Romance_LookLittleHeavierYoutEllen                     ;BAB9CE;3c8
        dl Text_3C9_Romance_LotThingsHappenWhileAlive                     ;BABAE8;3c9
        dl Text_3CA_Dialog_CarryJokestoFar                     ;BABBE0;3ca
        dl Text_3CB_Animal_ThinkPeopleWhoCheatWho                     ;BABC28;3cb
        dl Text_3CC_Romance_MostImportantThingLifeProbably                     ;BABD56;3cc
        dl Text_3CD_Romance_HaveHeardBlueFeatherGrandma                     ;BABE00;3cd
        dl Text_3CE_Dialog_FemalePsychologyComplicated                     ;BABED4;3ce
        dl Text_3CF_Manual_PrettyHardMoveCowsAs                     ;BABF26;3cf
        dl Text_3D0_Animal_DealingLivestocktodayBecomeSickOutside                     ;BAC05A;3d0
        dl Text_3D1_Sign_SeeSunsetTopMountainFeel                     ;BAC130;3d1
        dl Text_3D2_Romance_EveKindGirlComesOften                     ;BAC204;3d2
        dl Text_3D3_Romance_HowsEveDoingSeeGood                     ;BAC2E2;3d3
        dl Text_3D4_Town_SisterPinkScoldIfPicked                     ;BAC372;3d4
        dl Text_3D5_Romance_BigHouseNecessaryIfWant                     ;BAC40A;3d5
        dl Text_3D6_Dialog_GatherLogsWinterToo                     ;BAC474;3d6
        dl Text_3D7_Dialog_HowdyHaveJuicePartyHome                     ;BAC4C4;3d7
        dl Text_3D8_Animal_GotMarriedWorkHarderBad                     ;BAC54A;3d8
        dl Text_3D9_Dialog_HappyMan                     ;BAC62A;3d9
        dl Text_3DA_Romance_MarriedCuteWifeHuhIf                     ;BAC64A;3da
        dl Text_3DB_Sign_HaveSeenRareBerrythatGrows                     ;BAC702;3db
        dl Text_3DC_Animal_FestivalEndsSoyouMustGo                     ;BAC786;3dc
        dl Text_3DD_Romance_CustomersDifferentMonthlySomePeople                     ;BAC84C;3dd
        dl Text_3DE_Romance_HowsEveDoingBusinessHas                     ;BAC8DE;3de
        dl Text_3DF_Town_AdultsCryBecauseNothingCry                     ;BAC982;3df
        dl Text_3E0_Romance_BoringBecauseMariasGone                     ;BACA62;3e0
        dl Text_3E1_Romance_HardestThingControlisLoveBetween                     ;BACAA6;3e1
        dl Text_3E2_Dialog_MarriageWonderfulBravelyAskMarry                     ;BACB24;3e2
        dl Text_3E3_Dialog_YoudBetterGoHomeYourwife                     ;BACBA8;3e3
        dl Text_3E4_Dialog_MakeWifeCryGoHome                     ;BACBEC;3e4
        dl Text_3E5_Romance_TellOnlyDadSecretlyWhich                     ;BACC46;3e5
        dl Text_3E6_Church_AhaMariaShesChurchSaturdays                     ;BACD7E;3e6
        dl Text_3E7_Festival_AnnGoesAloneSpaStar                     ;BACE88;3e7
        dl Text_3E8_Sign_NinaGoesPickingHerbsSaturdays                     ;BACFA8;3e8
        dl Text_3E9_Dialog_FaceBecomingBetterLooking                     ;BAD0A4;3e9
        dl Text_3EA_Dialog_YoudBetterListenOldPreacher                     ;BAD0FC;3ea
        dl Text_3EB_Dialog_ChildrenRelyMeasProblem                     ;BAD150;3eb
        dl Text_3EC_Dialog_YearComingClose                     ;BAD1B0;3ec
        dl Text_3ED_Dialog_HappyLiveHealthWholeYear                     ;BAD1F6;3ed
        dl Text_3EE_Dialog_PickTargetFornextYear                     ;BAD25E;3ee
        dl Text_3EF_Manual_SpringFinallyReturningSellSeeds                     ;BAD2AC;3ef
        dl Text_3F0_Dialog_SpringNewYearAreaSt                     ;BAD344;3f0
        dl Text_3F1_Dialog_HopeGoodYearBothUs                     ;BAD3D4;3f1
        dl Text_3F2_Animal_PrizeEggFestivalDifferentEvery                     ;BAD436;3f2
        dl Text_3F3_Animal_EggFestivalHeldPublicSquare                     ;BAD4F6;3f3
        dl Text_3F4_Animal_WinAgainEggFestivalTomorrow                     ;BAD57A;3f4
        dl Text_3F5_Romance_MyAnnualEventBeginningYear                     ;BAD5D8;3f5
        dl Text_3F6_Dialog_WasGoodYearTryBest                     ;BAD67C;3f6
        dl Text_3F7_Mountain_FishermanBackSoonWarmPlace                     ;BAD700;3f7
        dl Text_3F8_Romance_YearClosingSoonWishBecome                     ;BAD772;3f8
        dl Text_3F9_Romance_YearEndingDevelopCompleteGreat                     ;BAD844;3f9
        dl Text_3FA_Weather_SmellDirtGettingStrongerAs                     ;BAD8E6;3fa
        dl Text_3FB_Weather_SnowGaveUsHardTime                     ;BAD984;3fb
        dl Text_3FC_Dialog_NowTonightLastNightYear                     ;BAD9F2;3fc
        dl Text_3FD_Weather_LastJuiceDrinkSeeingSnow                     ;BADA8E;3fd
        dl Text_3FE_Sign_BetterGoHomeRestNow                     ;BADB66;3fe
        dl Text_3FF_Romance_ThankVeryMuchEverythingYear                     ;BADC24;3ff
        dl Text_400_Dialog_AhMrEdFieldAndmeadow                     ;BADCC8;400
        dl Text_401_Dialog_ImportantHumanOvercomeDifficulties                     ;BADD22;401
        dl Text_402_Dialog_SuchHardTimeHadBut                     ;BADD8E;402
        dl Text_403_Dialog_VitalityImportantMenWorkOutside                     ;BADE08;403
        dl Text_404_Sign_ShopOpenCome                     ;BADE6A;404
        dl Text_405_Church_EverybodyComeChurchPrayTomorrow                     ;BADEBC;405
        dl Text_406_Sign_FirstFortuneTellingMountainTop                     ;BADF26;406
        dl Text_407_Animal_WinterGoodTimeFriendsLivestock                     ;BADFB2;407
        dl Text_408_Sign_TheresLotThingEatMountains                     ;BAE04C;408
        dl Text_409_Sign_NeedLotsWoodWinterChop                     ;BAE12A;409
        dl Text_40A_Animal_UmmGetOutCloseyouEyes                     ;BAE1C0;40a
        dl Text_40B_Town_ManyPeopleComeWonder                     ;BAE280;40b
        dl Text_40C_Dialog_VeryLittleLightAboveReaches                     ;BAE2D4;40c
        dl Text_40D_Romance_NinasDreamLiveSurroundedFlowers                     ;BAE39A;40d
        dl Text_40E_Romance_FlowersLoveThemallLikeWeeds                     ;BAE400;40e
        dl Text_40F_Church_LoveChurchBecauseSeemsWash                     ;BAE4B6;40f
        dl Text_410_Dialog_BestWork                     ;BAE51C;410
        dl Text_411_Dialog_AllRightFeelEaseKnowing                     ;BAE552;411
        dl Text_412_Dialog_SurpriseUsSayingSomethingDecent                     ;BAE636;412
        dl Text_413_Dialog_WasTerrifiedWasMyFirst                     ;BAE6B6;413
        dl Text_414_Dialog_SeeRockUpCollapsed                     ;BAE712;414
        dl Text_415_Sign_HeardMysteriousSpringMountainRemember                     ;BAE76C;415
        dl Text_416_Dialog_LikeWinterBecauseFeelsKind                     ;BAE83E;416
        dl Text_417_Weather_BecauseHurricaneTheresLeakRoof                     ;BAE8A8;417
        dl Text_418_Animal_UumWantEgg                     ;BAE948;418
        dl Text_419_Dialog_SobAskAnyMoreIdiot                     ;BAE96E;419
        dl Text_41A_Diary_ThankMoneySavedBye                     ;BAE9C8;41a
        dl Text_41B_Animal_WantEggWantOneEgg                     ;BAEA28;41b
        dl Text_41C_Dialog_Stable                     ;BAEA88;41c
        dl Text_41D_Dialog_CelebrationEesBirthdayYearNow                     ;BAEA9A;41d
        dl Text_41E_Dialog_WowCakeEfsBirthday                     ;BAEB3A;41e
        dl Text_41F_Dialog_WarmEnoughNowAniceDay                     ;BAEBA2;41f
        dl Text_420_Weather_VariousDisastersHappeninSummerBetter                     ;BAEBEE;420
        dl Text_421_Dialog_AutumnSkyHigh                     ;BAECAA;421
        dl Text_422_Dialog_HopeAbleCookBetterStep                     ;BAECEE;422
        dl Text_423_Weather_WishHadHadTrainedLittle                     ;BAED90;423
        dl Text_424_Manual_SpringSpringLetsPlantSeeds                     ;BAEDF2;424
        dl Text_425_Dialog_MorningNiceBrightToday                     ;BAEE50;425
        dl Text_426_Animal_HearWildDogsSometimesCome                     ;BAEEA4;426
        dl Text_427_Weather_RainsHavePutEgInside                     ;BAEF56;427
        dl Text_428_Dialog_DarlingTakeEhEiWalk                     ;BAEFC2;428
        dl Text_429_Dialog_WantRideEj                     ;BAF05A;429
        dl Text_42A_Mountain_AhThingsLikeTemparaturePlace                     ;BAF088;42a
        dl Text_42B_Animal_OneWildGrapeJuiceBayberry                     ;BAF13A;42b
        dl Text_42C_Dialog_OneMadeSpringDrinkSoon                     ;BAF27A;42c
        dl Text_42D_Dialog_PlayMachinesTimeBeingGoing                     ;BAF2F6;42d
        dl Text_42E_Weather_SnowsLotThoseFencesOften                     ;BAF39C;42e
        dl Text_42F_Dialog_HopeSpringComeSoon                     ;BAF406;42f
        dl Text_430_Town_BusyWorkingIwantGatherPeople                     ;BAF44A;430
        dl Text_431_Sign_SaySoundBurningWoodSmell                     ;BAF4DC;431
        dl Text_432_Dialog_AllGrassGroundGoneLooks                     ;BAF598;432
        dl Text_433_Church_HitMyMindButAs                     ;BAF608;433
        dl Text_434_Animal_ThoseStarsStillShinewhenBecome                     ;BAF7C4;434
        dl Text_435_Romance_GoodEveningIfIfInterested                     ;BAF832;435
        dl Text_436_Romance_MayEverybodyHappyMayFine                     ;BAF8E6;436
        dl Text_437_Dialog_GladNowLetsHaveToast                     ;BAF9EE;437
        dl Text_438_Dialog_HoneyahLateHavingWonderfulTime                     ;BAFADE;438
        dl Text_439_Romance_HeyiLookForwardShootingStar                     ;BAFB7C;439
        dl Text_43A_Dialog_NextYearYearAfterMay                     ;BAFC68;43a
        dl Text_43B_Dialog_SayOftenSeesomeoneLateNight                     ;BAFD24;43b
        dl Text_43C_Dialog_HmmmFeelsGoodBestSpot                     ;BAFE96;43c
        dl Text_43D_Weather_ThankButAnsweryouRightNow                     ;BAFF06;43d
        dl Text_43E_Weather_SoundsGoodButNowiSunny                     ;BB8000;43e
        dl Text_43F_Weather_UummmAnswerNowIfSunny                     ;BB812A;43f
        dl Text_440_Weather_AhSorryButAnswerYouright                     ;BB8260;440
        dl Text_441_Weather_HuhGotTalkMyGrandpa                     ;BB83AC;441
        dl Text_442_Dialog_MooS                     ;BB8548;442
        dl Text_443_Dialog_MadeOverallCute                     ;BB8570;443
        dl Text_444_Dialog_MoneyHG                     ;BB85C6;444
        dl Text_445_Animal_CowCChickenC                     ;BB85E0;445
        dl Text_446_Dialog_StaminaD                     ;BB8634;446
        dl Text_447_Animal_CowsBestAffectionRateEk                     ;BB864E;447
        dl Text_448_Romance_MariasLoveD                     ;BB8698;448
        dl Text_449_Romance_AnnsLoveD                     ;BB86BC;449
        dl Text_44A_Romance_NinasLoveD                     ;BB86E0;44a
        dl Text_44B_Romance_EllensLoveD                     ;BB8704;44b
        dl Text_44C_Romance_EvesLoveD                     ;BB8728;44c
        dl Text_44D_Shipping_AmountShippedTomatoesD                     ;BB874C;44d
        dl Text_44E_Shipping_AmountShippedCornD                     ;BB878E;44e
        dl Text_44F_Shipping_AmountShippedPotatoesD                     ;BB87D0;44f
        dl Text_450_Shipping_AmountShippedTurnipsD                     ;BB8812;450
        dl Text_451_Sign_WoodHouse                     ;BB8854;451
        dl Text_452_Sign_SuperWoodHouse                     ;BB886C;452
        dl Text_453_Sign_SuperDeluxeGreatWoodHouse                     ;BB8890;453
        dl Text_454_Dialog_HappinessRateD                     ;BB88E0;454
        dl Text_455_Dialog_FloristsCropsNoteTomatoCorn                     ;BB8908;455
        dl Text_456_Manual_TomatoCornSeedsMustPlanted                     ;BB89B6;456
        dl Text_457_Manual_TurnipPotatoSeedsMustbePlanted                     ;BB8BF6;457
        dl Text_458_Manual_GrassSeedsMustPlantedSpring                     ;BB8DD0;458
        dl Text_459_Animal_LivestockNoteCowChickenMilk                     ;BB8F0E;459
        dl Text_45A_Weather_CowsSaleYoungOnesMilk                     ;BB8FB2;45a
        dl Text_45B_Manual_EquipMilkerPointYButton                     ;BB9280;45b
        dl Text_45C_Weather_CowsEatGrownGrassGrass                     ;BB9454;45c
        dl Text_45D_Weather_ChickensLayOneEggDay                     ;BB95BA;45d
        dl Text_45E_Animal_EggsBecomeChicksDayswhenIncubate                     ;BB978C;45e
        dl Text_45F_Diary_LessonsLovePresentConversationFestival                     ;BB9932;45f
        dl Text_460_Romance_MostPortableThingsPresentsEvery                     ;BB99DC;460
        dl Text_461_Romance_ImportantTalkGirlLoveAs                     ;BB9AFE;461
        dl Text_462_Festival_FestivalsBestOpportunityGirlsSometimes                     ;BB9B82;462
        dl Text_463_Diary_GirlsImpressionYoucanFoundDiary                     ;BB9D32;463
        dl Text_464_Animal_ItemMarriageProposalBlueFeather                     ;BB9E42;464
        dl Text_465_Animal_SeeEllenShesBehindPen                     ;BB9FA4;465
        dl Text_466_Sign_EveHmmGoBarAsmany                     ;BBA138;466
        dl Text_467_Romance_SweetheartStayHappyForever                     ;BBA2C0;467
        dl Text_468_Dialog_DarlingLikeBabyAbout                     ;BBA30A;468
        dl Text_469_Dialog_HoneyWorkTooHardWant                     ;BBA370;469
        dl Text_46A_Dialog_JlCCmGnMoney                     ;BBA3F2;46a
        dl Text_46B_Dialog_JoCCpGqOclock                     ;BBA436;46b
        dl Text_46C_Dialog_JrCCsGtOclock                     ;BBA514;46c
        dl Text_46D_Dialog_JuCCvGwOclock                     ;BBA590;46d
        dl Text_46E_Dialog_JxCCyGzOclock                     ;BBA60C;46e
        dl Text_46F_Dialog_JCCGOclock                     ;BBA688;46f
        dl Text_470_Dialog_JCCGOclock                     ;BBA704;470
        dl Text_471_Dialog_JCCGOclock                     ;BBA79A;471
        dl Text_472_Dialog_JCCGOclock                     ;BBA832;472
        dl Text_473_Dialog_JCCGOclock                     ;BBA8AE;473
        dl Text_474_Shipping_JCCGOclock                     ;BBA92A;474
        dl Text_475_Shipping_JCCGOclock                     ;BBA9DE;475
        dl Text_476_Dialog_JCCGOclock                     ;BBAA86;476
        dl Text_477_Dialog_JCCGOclock                     ;BBAB1A;477
        dl Text_478_Dialog_JCCGOclock                     ;BBAC02;478
        dl Text_479_Animal_MrGotNoticeFatherThismorning                     ;BBACEC;479
        dl Text_47A_Dialog_ParentsComingTomorrowLastSurprised                     ;BBAE80;47a
        dl Text_47B_Weather_StillNeedTrainedMore                     ;BBAF44;47b
        dl Text_47C_Weather_KindDisappointingWeatherGoodonSunday                     ;BBAFAE;47c
        dl Text_47D_Sign_HoneyShopClosedBecauseSaturday                     ;BBB034;47d
        dl Text_47E_Manual_EquipAxeUseFrontSpring                     ;BBB0A6;47e
        dl Text_47F_Sign_DoingMakingGreatThingNow                     ;BBB14E;47f
        dl Text_480_Dialog_DarlingHoldChildSometimes                     ;BBB248;480
        dl Text_481_Dialog_LookCrawlingNow                     ;BBB2A2;481
        dl Text_482_Dialog_ChildGrowsPrettyQuicklyLittle                     ;BBB2D6;482
        dl Text_483_Dialog_RanchMasterRateDStill                     ;BBB384;483
        dl Text_484_Dialog_VeryActiveHavePutEye                     ;BBB3EE;484
        dl Text_485_Dialog_DarlingTakeCareYourself                     ;BBB46A;485
        dl Text_486_Dialog_HeardAwfulSoundMorningAll                     ;BBB4B6;486
        dl Text_487_Shipping_SaidWereSupposedSellWerent                     ;BBB5A4;487
        dl Text_488_Dialog_RanchMasterRateDTry                     ;BBB640;488
        dl Text_489_Dialog_RanchMasterRateDCome                     ;BBB692;489
        dl Text_48A_Dialog_RanchMasterRateDGreat                     ;BBB700;48a
        dl Text_48B_Dialog_RanchMasterRateDCongratulations                     ;BBB78E;48b
        dl Text_48C_Romance_RanchDevelopingRateD                     ;BBB832;48c
        dl Text_48D_Dialog_PChanDoingWonderIf                     ;BBB86A;48d
        dl Text_48E_Dialog_MoneyOnlyThingLifeLook                     ;BBB8D8;48e
        dl Text_48F_Animal_StrangeLookingOrnamentofChickenLooks                     ;BBB958;48f
        dl Text_490_Town_BeautifulFlower                     ;BBB9FE;490
        dl Text_491_Dialog_EatLotTodayMeanAnything                     ;BBBA30;491
        dl Text_492_Romance_HasNinaMadeSomethingLikea                     ;BBBAB4;492
        dl Text_493_Dialog_DarlingForgetPaintDoor                     ;BBBB44;493
        dl Text_494_Romance_MariaSeemsDoingBroughtMe                     ;BBBBA2;494
        dl Text_495_Dialog_GettingAlongWifeArgue                     ;BBBC44;495
        dl Text_496_Dialog_GotCakeFloristsWifeGlad                     ;BBBCBC;496
        dl Text_497_Dialog_MyGoodnessNothingLikeKnow                     ;BBBD54;497


;;;;;;;; Presets all the variables
NewGameSetup: ;83A9BE
        %Set8bit(!M)
        %Set16bit(!X)
        LDA.B #$00
        STA.L !year
        LDA.B #$00
        STA.L !season
        LDA.B #$01
        STA.L !weekday
        LDA.B #$01
        STA.L !day
        LDA.B #$01
        STA.W !seeds_grass_N
        STZ.W !seeds_corn_N
        STZ.W !seeds_tomato_N
        STZ.W !seeds_potato_N
        STZ.W !seeds_turnip_N
        STZ.W !feed_cow_N
        STZ.W !feed_chicks_N
        LDA.B #$00
        STA.L !cow_N
        LDA.B #$00
        STA.L !chicks_N
        STZ.W !weather_tomorrow
        LDA.B #100
        STA.W !max_stamina
        STZ.W !tool_selected
        STZ.W !watering_can_water
        LDA.B #$00
        STA.L $7F1F12
        LDA.B #$00
        STA.L $7F1F2B
        LDA.B #$00
        STA.L !dog_map
        LDA.B #$00
        STA.L $7F1F31
        LDA.B #$00
        STA.L $7F1F32
        LDA.B #$00
        STA.L !development_rate
        LDA.B #$00
        STA.L !power_berry_N
        LDA.B #$00
        STA.W $09A3
        LDA.B #$00
        STA.W $0937
        STZ.W !tool_backpack
        %Set16bit(!M)
        LDA.W #$0000
        STA.L !stored_wood
        LDA.W #$0000
        STA.L !stored_grass
        STZ.W $0196
        LDA.W #$0000
        STA.L !planted_grass
        LDA.W #$0000
        ; PASS20_SAVE_SOCIAL_INIT: initializes/saves social heart values.
STA.L !hearts_maria
        LDA.W #$0000
        STA.L !hearts_ann
        LDA.W #$0000
        STA.L !hearts_nina
        LDA.W #$0000
        STA.L !hearts_ellen
        LDA.W #$0000
        STA.L !hearts_eve
        LDA.W #$0000
        STA.L !player_house_and_event_flags
        LDA.W #$0000
        STA.L !marriage_flags
        LDA.W #$0000
        STA.L $7F1F68
        LDA.W #$0000
        STA.L $7F1F6A
        LDA.W #$0000
        STA.L !dog_pos_X
        LDA.W #$0000
        STA.L !dog_pos_Y
        LDA.W #$0000
        STA.L !happiness
        LDA.W #$0000
        STA.L $7F1F45
        LDA.W #$0000
        STA.L !family_event_flags
        LDA.W #$0000
        STA.L !child_flags
        LDA.W #$0000
        STA.L $7F1F70
        LDA.W #$0000
        STA.L $7F1F72
        LDA.W #$0000
        STA.L !wife_pregnancy
        LDA.W #$0000
        STA.L !kid1_age
        LDA.W #$0000
        STA.L !kid2_age
        LDA.W #$0000
        STA.L !shipped_corn
        LDA.W #$0000
        STA.L !shipped_tomatoes
        LDA.W #$0000
        STA.L !shipped_turnips
        LDA.W #$0000
        STA.L !shipped_potatoes
        LDA.W #$0000
        STA.L !dog_hugs
        %Set16bit(!M)
        LDA.W #30                            ;Money is stored in x10
        STA.L !moneyL
        %Set8bit(!M)
        LDA.B #$00
        STA.L !moneyH
        %Set8bit(!M)
        LDA.B #$B1
        STA.W !player_name_sort_1
        LDA.B #$B1
        STA.W !player_name_sort_2
        LDA.B #$B1
        STA.W !player_name_sort_3
        LDA.B #$B1
        STA.W !player_name_sort_4
        %Set8bit(!M)
        LDA.B #$0F                           ;all the basic tools
        STA.L !shed_items_row_1
        LDA.B #$88                           ;watering can & grass seeds bags
        STA.L !shed_items_row_2
        LDA.B #$00
        STA.L !shed_items_row_3
        LDA.B #$00
        STA.L !shed_items_row_4
        %Set8bit(!M)                         ;I belive this part sets the child/animal name spaces blank
        LDA.B #$B1
        STA.W !dog_name_short_1
        LDA.B #$B1
        STA.W !dog_name_short_2
        LDA.B #$B1
        STA.W !dog_name_short_3
        LDA.B #$B1
        STA.W !dog_name_short_4
        %Set8bit(!M)
        LDA.B #$B1
        STA.W !horse_name_short_1
        LDA.B #$B1
        STA.W !horse_name_short_2
        LDA.B #$B1
        STA.W !horse_name_short_3
        LDA.B #$B1
        STA.W !horse_name_short_4
        %Set8bit(!M)
        LDA.B #$B1
        STA.W !horse_name_short_1
        LDA.B #$B1
        STA.W !horse_name_short_2
        LDA.B #$B1
        STA.W !horse_name_short_3
        LDA.B #$B1
        STA.W !horse_name_short_4
        %Set8bit(!M)
        LDA.B #$B1
        STA.L !kid1_name_sort_1
        LDA.B #$B1
        STA.L !kid1_name_sort_2
        LDA.B #$B1
        STA.L !kid1_name_sort_3
        LDA.B #$B1
        STA.L !kid1_name_sort_4
        %Set8bit(!M)
        LDA.B #$B1
        STA.L !kid2_name_sort_1
        LDA.B #$B1
        STA.L !kid2_name_sort_2
        LDA.B #$B1
        STA.L !kid2_name_sort_3
        LDA.B #$B1
        STA.L !kid2_name_sort_4
        %Set16bit(!M)
        LDA.W #$00B1
        STA.W !player_name_long_1
        STA.W !player_name_long_2
        STA.W !player_name_long_3
        STA.W !player_name_long_4
        STA.W !dog_name_long_1
        STA.W !dog_name_long_2
        STA.W !dog_name_long_3
        STA.W !dog_name_long_4
        STA.W !horse_name_long_1
        STA.W !horse_name_long_2
        STA.W !horse_name_long_3
        STA.W !horse_name_long_4

        JSL.L LoadDefaultFarmMap
        RTL

;;;;;;;; TODO Sets a TON of things, lots of Vars to check
DayCycle_FirstMorningResetAfterLoad: ;83ABF0
        %Set16bit(!MX)
        STZ.W $0183
        STZ.W $0185
        STZ.W $0187
        %Set8bit(!M)
        STZ.W $019B
        STZ.W !inputstate
        STZ.B !ProgDMA_Channel_Flag_to_Copy
        %Set16bit(!M)
        STZ.B $04
        %Set8bit(!M)
        STZ.B $06
        %Set16bit(!M)
        STZ.B $42
        STZ.B $45
        STZ.B $48
        %Set8bit(!M)
        STZ.B $44
        STZ.B $47
        STZ.B $4A
        %Set16bit(!M)
        LDA.W #$0000
        STA.L !shipping_moneyL
        %Set8bit(!M)
        LDA.B #$00
        STA.L !shipping_moneyH
        JSL.L Calendar_LoadDateNameBuffers        ;TODO
        %Set8bit(!M)
        STZ.W $096D
        %Set16bit(!M)
        STZ.B !game_state
        STZ.B $E9
        STZ.B $EB
        STZ.W $0878
        STZ.W $087A
        STZ.W !time_running
        %Set16bit(!M)
        STZ.B $CF
        %Set8bit(!M)
        STZ.B $D1
        STZ.W $098A
        STZ.W $0972
        %Set16bit(!M)
        STZ.B !player_pos_X
        STZ.B !player_pos_Y
        STZ.W $0907
        STZ.W $0909
        %Set8bit(!M)
        STZ.W $0919
        %Set16bit(!M)
        STZ.W $0991
        %Set8bit(!M)
        STZ.W $0993
        STZ.W !name_entry_index
        STZ.W $018B
        %Set8bit(!M)
        LDA.B #$06
        STA.L !hour
        LDA.B #$00
        STA.L !minutes
        LDA.B #$00
        STA.L !seconds
        %Set16bit(!M)
        LDA.W #$0000
        STA.L $7F1F5A
        LDA.W #$0000
        STA.L $7F1F5C
        LDA.W #$0000
        STA.L $7F1F5E
        LDA.W #$0000
        STA.L $7F1F60
        LDA.W #$0000
        STA.L $7F1F62
        LDA.W #$0000
        STA.L $7F1F74
        LDA.W #$0000
        STA.L $7F1F76
        LDA.W #$0000
        STA.L $7F1F78
        LDA.W #$0000
        STA.L $7F1F7A
        %Set16bit(!M)
        %Set16bit(!MX)
        LDA.B !game_state
        ORA.W #$0001
        STA.B !game_state
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_action
        %Set16bit(!MX)
        LDA.W #$0000
        STA.B !player_direction
        %Set16bit(!MX)
        LDA.W #$0000
        STA.W $0911
        %Set16bit(!MX)
        LDA.W #$0000
        STA.W $0901
        %Set16bit(!M)
        STZ.W $0915
        %Set8bit(!M)
        LDA.W !max_stamina
        STA.W !current_stamina
        %Set8bit(!M)
        STZ.W !run_step_sound
        STZ.W !counter_tool_sound
        %Set8bit(!M)
        STZ.W !idle_animation_timer
        %Set8bit(!M)
        STZ.W $0990
        %Set8bit(!M)
        STZ.W !item_on_hand
        STZ.W !old_item_on_hand
        STZ.W $091F
        STZ.W $0920
        STZ.W $096B
        %Set8bit(!M)
        STZ.W $098F
        %Set8bit(!M)
        STZ.W !exhaustion_level
        STZ.W !tool_used_sound
        %Set8bit(!M)
        STZ.W $0110                          ;audio
        STZ.W $0114                          ;audio
        STZ.W $0117                          ;audio
        STZ.W $0118                          ;audio
        STZ.W $0117                          ;audio
        %Set8bit(!M)
        STZ.W !fed_cows_N
        STZ.W !fed_chicks_N
        %Set16bit(!M)
        STZ.W !fed_cows_flags
        STZ.W !fed_chicks_flags
        %Set16bit(!M)
        STZ.W $084A
        STZ.B $DC
        %Set8bit(!M)
        STZ.W !transition_dest
        %Set16bit(!M)
        STZ.W !map_scrolling_X_speed
        STZ.W !map_scrolling_Y_speed
        %Set8bit(!M)
        STZ.W !map_scrolling_timer
        %Set16bit(!MX)
        LDA.W #250
        STA.L !wood_need_for_upgrade
        LDA.L !player_house_and_event_flags
        AND.W #$0040                         ;house upgraded 1 once flags
        BEQ +
        LDA.W #500
        STA.L !wood_need_for_upgrade
      + %Set8bit(!M)
        STZ.B !NMI_Status
        STZ.W $0148
        JSL.L NMI_WaitForNextFrame
        RTL

                                                            ;      ;      ;
                Collision_CheckMapTileAtDirection: %Set16bit(!MX)                             ;83AD91;      ;
                       TAX                                  ;83AD93;      ;
                       LDA.L $7F1F60                        ;83AD94;7F1F60;
                       AND.W #$4000                         ;83AD98;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83ADA0                      ;83AD9B;83ADA0;
                       JMP.W Bank83_NpcSpriteLogicBranch_83AEA2                    ;83AD9D;83AEA2;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ADA0: TXA                                  ;83ADA0;      ;
                       ASL A                                ;83ADA1;      ;
                       TAX                                  ;83ADA2;      ;
                       JMP.W (Bank83_NpcSpriteLogicBranch_83ADA6,X)                ;83ADA3;83ADA6;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ADA6: LDX.W $C4AD                          ;This is weird, loads part of an instruction as data
                       LDA.W $ADDB                          ;Maybe the programmer was feeling smart? X:22 A:A5
                       SBC.B ($AD),Y                        ;83ADAC;0000AD;
                       LDA.B $DF                            ;83ADAE;0000DF;
                       CLC                                  ;83ADB0;      ;
                       ADC.W #$000C                         ;83ADB1;      ;
                       STA.B $80                            ;83ADB4;000080;
                       LDA.B $E1                            ;83ADB6;0000E1;
                       CLC                                  ;83ADB8;      ;
                       ADC.B $E7                            ;83ADB9;0000E7;
                       ADC.B $E3                            ;83ADBB;0000E3;
                       ADC.W #$000C                         ;83ADBD;      ;
                       STA.B $82                            ;83ADC0;000082;
                       BRA .skip                            ;83ADC2;83AE08;
                                                            ;      ;      ;
                       LDA.B $DF                            ;83ADC4;0000DF;
                       CLC                                  ;83ADC6;      ;
                       ADC.W #$000C                         ;83ADC7;      ;
                       STA.B $80                            ;83ADCA;000080;
                       LDA.B $E1                            ;83ADCC;0000E1;
                       SEC                                  ;83ADCE;      ;
                       SBC.B $E7                            ;83ADCF;0000E7;
                       SBC.B $E3                            ;83ADD1;0000E3;
                       CLC                                  ;83ADD3;      ;
                       ADC.W #$000C                         ;83ADD4;      ;
                       STA.B $82                            ;83ADD7;000082;
                       BRA .skip                            ;83ADD9;83AE08;
                                                            ;      ;      ;
                       LDA.B $DF                            ;83ADDB;0000DF;
                       CLC                                  ;83ADDD;      ;
                       ADC.B $E5                            ;83ADDE;0000E5;
                       ADC.B $E3                            ;83ADE0;0000E3;
                       ADC.W #$000C                         ;83ADE2;      ;
                       STA.B $80                            ;83ADE5;000080;
                       LDA.B $E1                            ;83ADE7;0000E1;
                       CLC                                  ;83ADE9;      ;
                       ADC.W #$000C                         ;83ADEA;      ;
                       STA.B $82                            ;83ADED;000082;
                       BRA .skip                            ;83ADEF;83AE08;
                                                            ;      ;      ;
                       LDA.B $DF                            ;83ADF1;0000DF;
                       SEC                                  ;83ADF3;      ;
                       SBC.B $E5                            ;83ADF4;0000E5;
                       SBC.B $E3                            ;83ADF6;0000E3;
                       CLC                                  ;83ADF8;      ;
                       ADC.W #$000C                         ;83ADF9;      ;
                       STA.B $80                            ;83ADFC;000080;
                       LDA.B $E1                            ;83ADFE;0000E1;
                       CLC                                  ;83AE00;      ;
                       ADC.W #$000C                         ;83AE01;      ;
                       STA.B $82                            ;83AE04;000082;
                       BRA .skip                            ;83AE06;83AE08;
                                                            ;      ;      ;
                                                            ;      ;      ;
                .skip: %Set16bit(!MX)                             ;83AE08;      ;
                       LDA.B $CC                            ;83AE0A;0000CC;
                       PHA                                  ;83AE0C;      ;
                       %Set8bit(!M)                             ;83AE0D;      ;
                       LDA.B $CE                            ;83AE0F;0000CE;
                       PHA                                  ;83AE11;      ;
                       %Set16bit(!M)                             ;83AE12;      ;
                       LDA.W #$B586                         ;83AE14;      ;
                       STA.B $CC                            ;83AE17;0000CC;
                       %Set8bit(!M)                             ;83AE19;      ;
                       LDA.B #$7E                           ;83AE1B;      ;
                       STA.B $CE                            ;83AE1D;0000CE;
                       %Set16bit(!M)                             ;83AE1F;      ;
                       STZ.B $8C                            ;83AE21;00008C;
                       LDX.W #$0000                         ;83AE23;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83AE26: %Set8bit(!M)                             ;83AE26;      ;
                       %Set16bit(!X)                             ;83AE28;      ;
                       LDY.W #$000C                         ;83AE2A;      ;
                       LDA.B #$00                           ;83AE2D;      ;
                       STA.B [$CC],Y                        ;83AE2F;0000CC;
                       %Set8bit(!M)                             ;83AE31;      ;
                       %Set16bit(!X)                             ;83AE33;      ;
                       LDY.W #$0000                         ;83AE35;      ;
                       LDA.B [$CC],Y                        ;83AE38;0000CC;
                       BNE Bank83_NpcSpriteLogicBranch_83AE3F                      ;83AE3A;83AE3F;
                       JMP.W Bank83_NpcSpriteLogicBranch_83AE81                    ;83AE3C;83AE81;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83AE3F: %Set16bit(!M)                             ;83AE3F;      ;
                       LDA.B $80                            ;83AE41;000080;
                       SEC                                  ;83AE43;      ;
                       LDY.W #$001A                         ;83AE44;      ;
                       SBC.B [$CC],Y                        ;83AE47;0000CC;
                       CMP.W #$0019                         ;83AE49;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83AE81                      ;83AE4C;83AE81;
                       LDA.B $82                            ;83AE4E;000082;
                       SEC                                  ;83AE50;      ;
                       LDY.W #$001C                         ;83AE51;      ;
                       SBC.B [$CC],Y                        ;83AE54;0000CC;
                       CMP.W #$0019                         ;83AE56;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83AE81                      ;83AE59;83AE81;
                       LDA.B $8C                            ;83AE5B;00008C;
                       BNE Bank83_NpcSpriteLogicBranch_83AE81                      ;83AE5D;83AE81;
                       %Set8bit(!M)                             ;83AE5F;      ;
                       %Set16bit(!X)                             ;83AE61;      ;
                       LDY.W #$000C                         ;83AE63;      ;
                       LDA.B #$01                           ;83AE66;      ;
                       STA.B [$CC],Y                        ;83AE68;0000CC;
                       %Set8bit(!M)                             ;83AE6A;      ;
                       %Set16bit(!X)                             ;83AE6C;      ;
                       LDY.W #$0000                         ;83AE6E;      ;
                       LDA.B [$CC],Y                        ;83AE71;0000CC;
                       AND.B #$02                           ;83AE73;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83AE7A                      ;83AE75;83AE7A;
                       JMP.W Bank83_NpcSpriteLogicBranch_83AE81                    ;83AE77;83AE81;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83AE7A: %Set16bit(!M)                             ;83AE7A;      ;
                       LDA.W #$0001                         ;83AE7C;      ;
                       STA.B $8C                            ;83AE7F;00008C;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83AE81: %Set16bit(!M)                             ;83AE81;      ;
                       LDA.B $CC                            ;83AE83;0000CC;
                       CLC                                  ;83AE85;      ;
                       ADC.W #$0040                         ;83AE86;      ;
                       STA.B $CC                            ;83AE89;0000CC;
                       INX                                  ;83AE8B;      ;
                       CPX.W #$0031                         ;83AE8C;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83AE94                      ;83AE8F;83AE94;
                       JMP.W Bank83_NpcSpriteLogicBranch_83AE26                    ;83AE91;83AE26;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83AE94: LDA.B $8C                            ;83AE94;00008C;
                       BNE Bank83_NpcSpriteLogicBranch_83AEAD                      ;83AE96;83AEAD;
                       %Set8bit(!M)                             ;83AE98;      ;
                       PLA                                  ;83AE9A;      ;
                       STA.B $CE                            ;83AE9B;0000CE;
                       %Set16bit(!M)                             ;83AE9D;      ;
                       PLA                                  ;83AE9F;      ;
                       STA.B $CC                            ;83AEA0;0000CC;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83AEA2: %Set16bit(!MX)                             ;83AEA2;      ;
                       LDX.B $E5                            ;83AEA4;0000E5;
                       LDY.B $E7                            ;83AEA6;0000E7;
                       LDA.W #$0000                         ;83AEA8;      ;
                       BRA Bank83_NpcSpriteLogicBranch_83AEC2                      ;83AEAB;83AEC2;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83AEAD: %Set8bit(!M)                             ;83AEAD;      ;
                       PLA                                  ;83AEAF;      ;
                       STA.B $CE                            ;83AEB0;0000CE;
                       %Set16bit(!M)                             ;83AEB2;      ;
                       PLA                                  ;83AEB4;      ;
                       STA.B $CC                            ;83AEB5;0000CC;
                       %Set16bit(!M)                             ;83AEB7;      ;
                       LDX.W #$0000                         ;83AEB9;      ;
                       LDY.W #$0000                         ;83AEBC;      ;
                       LDA.W #$0001                         ;83AEBF;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83AEC2: RTL                                  ;83AEC2;      ;CCCCC
                                                            ;      ;      ;
                                                            ;      ;      ;
                CDDDD: %Set16bit(!MX)                             ;83AEC3;      ;
                       ASL A                                ;83AEC5;      ;
                       TAX                                  ;83AEC6;      ;
                       JMP.W (Bank83_NpcSpriteLogicBranch_83AECA,X)                ;83AEC7;83AECA;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83AECA: CMP.B ($AE)                          ;83AECA;0000AE;
                       CMP.L UNREACH_AEECAE,X               ;83AECC;AEECAE;
                       SBC.W $A5AE,Y              ;83AED0;00A5AE;
                       CMP.L UNREACH_A58085,X               ;83AED3;A58085;
                       SBC.B ($18,X)                        ;83AED7;000018;
                       ADC.B $E7                            ;83AED9;0000E7;
                       STA.B $82                            ;83AEDB;000082;
                       BRA Bank83_NpcSpriteLogicBranch_83AF06                      ;83AEDD;83AF06;
                                                            ;      ;      ;
                       LDA.B $DF                            ;83AEDF;0000DF;
                       STA.B $80                            ;83AEE1;000080;
                       LDA.B $E1                            ;83AEE3;0000E1;
                       SEC                                  ;83AEE5;      ;
                       SBC.B $E7                            ;83AEE6;0000E7;
                       STA.B $82                            ;83AEE8;000082;
                       BRA Bank83_NpcSpriteLogicBranch_83AF06                      ;83AEEA;83AF06;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83AEEC: LDA.B $DF                            ;83AEEC;0000DF;
                       CLC                                  ;83AEEE;      ;
                       ADC.B $E5                            ;83AEEF;0000E5;
                       STA.B $80                            ;83AEF1;000080;
                       LDA.B $E1                            ;83AEF3;0000E1;
                       STA.B $82                            ;83AEF5;000082;
                       BRA Bank83_NpcSpriteLogicBranch_83AF06                      ;83AEF7;83AF06;
                                                            ;      ;      ;
                       LDA.B $DF                            ;83AEF9;0000DF;
                       SEC                                  ;83AEFB;      ;
                       SBC.B $E5                            ;83AEFC;0000E5;
                       STA.B $80                            ;83AEFE;000080;
                       LDA.B $E1                            ;83AF00;0000E1;
                       STA.B $82                            ;83AF02;000082;
                       BRA Bank83_NpcSpriteLogicBranch_83AF06                      ;83AF04;83AF06;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83AF06: LDA.B $80                            ;83AF06;000080;
                       SEC                                  ;83AF08;      ;
                       SBC.B !player_pos_X                           ;83AF09;0000D6;
                       CLC                                  ;83AF0B;      ;
                       ADC.W #$000C                         ;83AF0C;      ;
                       CMP.W #$0019                         ;83AF0F;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83AF2D                      ;83AF12;83AF2D;
                       LDA.B $82                            ;83AF14;000082;
                       SEC                                  ;83AF16;      ;
                       SBC.B !player_pos_Y                            ;83AF17;0000D8;
                       CLC                                  ;83AF19;      ;
                       ADC.W #$000C                         ;83AF1A;      ;
                       CMP.W #$0019                         ;83AF1D;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83AF2D                      ;83AF20;83AF2D;
                       LDA.W #$0001                         ;83AF22;      ;
                       LDX.W #$0000                         ;83AF25;      ;
                       LDY.W #$0000                         ;83AF28;      ;
                       BRA $09                          ;83AF2B;83AF36;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83AF2D: %Set16bit(!MX)                             ;83AF2D;      ;
                       LDA.W #$0000                         ;83AF2F;      ;
                       LDX.B $E5                            ;83AF32;0000E5;
                       LDY.B $E7                            ;83AF34;0000E7;
                                                            ;      ;      ;
               RTL                                  ;83AF36;      ;END_CDDDD
                                                            ;      ;      ;
                                                            ;      ;      ;
                Collision_CheckObjectOverlapAtDirection: %Set16bit(!MX)                             ;83AF37;      ;
                       ASL A                                ;83AF39;      ;
                       TAX                                  ;83AF3A;      ;
                       JMP.W (Bank83_NpcSpriteLogicBranch_83AF3E,X)                ;83AF3B;83AF3E;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83AF3E: LSR.B $AF                            ;83AF3E;0000AF;
                       LDX.W $16AF                          ;83AF40;0016AF;
                       BCS Bank83_NpcSpriteLogicBranch_83AFC1                      ;83AF43;83AFC1;
                       BCS Bank83_NpcSpriteLogicBranch_83AEEC                      ;83AF45;83AEEC;
                       CMP.L $06E938,X                      ;random 0 in $86E938
                       BRK #$AA                             ;83AF4B;      ;
                       LDA.B $E1                            ;83AF4D;0000E1;
                       CLC                                  ;83AF4F;      ;
                       ADC.B $E7                            ;83AF50;0000E7;
                       ADC.W #$0006                         ;83AF52;      ;
                       ADC.B $E3                            ;83AF55;0000E3;
                       PHA                                  ;83AF57;      ;
                       TAY                                  ;83AF58;      ;
                       LDA.W #$0000                         ;83AF59;      ;
                       JSR.W Collision_ReadTileAttributeAtPixel                          ;83AF5C;83B0F6;
                       %Set16bit(!M)                             ;83AF5F;      ;
                       PLY                                  ;83AF61;      ;
                       PHA                                  ;83AF62;      ;
                       LDA.B $90                            ;83AF63;000090;
                       PHA                                  ;83AF65;      ;
                       LDA.B $DF                            ;83AF66;0000DF;
                       CLC                                  ;83AF68;      ;
                       ADC.W #$0006                         ;83AF69;      ;
                       TAX                                  ;83AF6C;      ;
                       LDA.W #$0001                         ;83AF6D;      ;
                       JSR.W Collision_ReadTileAttributeAtPixel                          ;83AF70;83B0F6;
                       %Set16bit(!M)                             ;83AF73;      ;
                       STA.B $7E                            ;83AF75;00007E;
                       PLY                                  ;83AF77;      ;
                       PLA                                  ;83AF78;      ;
                       ASL A                                ;83AF79;      ;
                       ORA.B $7E                            ;83AF7A;00007E;
                       STA.B $7E                            ;83AF7C;00007E;
                       BNE Bank83_NpcSpriteLogicBranch_83AF88                      ;83AF7E;83AF88;
                       STZ.B $7E                            ;83AF80;00007E;
                       LDY.W #$0000                         ;83AF82;      ;
                       JMP.W Bank83_NpcSpriteLogicBranch_83B0E1                    ;83AF85;83B0E1;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83AF88: %Set16bit(!MX)                             ;83AF88;      ;
                       CMP.W #$0003                         ;83AF8A;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83AFA2                      ;83AF8D;83AFA2;
                       CMP.W #$0002                         ;83AF8F;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83AFA2                      ;83AF92;83AFA2;
                       STY.B $90                            ;83AF94;000090;
                       LDA.B $88                            ;83AF96;000088;
                       SEC                                  ;83AF98;      ;
                       SBC.B $8C                            ;83AF99;00008C;
                       SBC.B $90                            ;83AF9B;000090;
                       INC A                                ;83AF9D;      ;
                       TAY                                  ;83AF9E;      ;
                       JMP.W Bank83_NpcSpriteLogicBranch_83B0E1                    ;83AF9F;83B0E1;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83AFA2: LDA.B $88                            ;83AFA2;000088;
                       SEC                                  ;83AFA4;      ;
                       SBC.B $8C                            ;83AFA5;00008C;
                       SBC.B $90                            ;83AFA7;000090;
                       INC A                                ;83AFA9;      ;
                       TAY                                  ;83AFAA;      ;
                       JMP.W Bank83_NpcSpriteLogicBranch_83B0E1                    ;83AFAB;83B0E1;
                                                            ;      ;      ;
                       LDA.B $DF                            ;83AFAE;0000DF;
                       SEC                                  ;83AFB0;      ;
                       SBC.W #$0006                         ;83AFB1;      ;
                       TAX                                  ;83AFB4;      ;
                       LDA.B $E1                            ;83AFB5;0000E1;
                       SEC                                  ;83AFB7;      ;
                       SBC.B $E7                            ;83AFB8;0000E7;
                       SBC.W #$0006                         ;83AFBA;      ;
                       SBC.B $E3                            ;83AFBD;0000E3;
                       PHA                                  ;83AFBF;      ;
                       TAY                                  ;83AFC0;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83AFC1: LDA.W #$0000                         ;83AFC1;      ;
                       JSR.W Collision_ReadTileAttributeAtPixel                          ;83AFC4;83B0F6;
                       %Set16bit(!M)                             ;83AFC7;      ;
                       PLY                                  ;83AFC9;      ;
                       PHA                                  ;83AFCA;      ;
                       LDA.B $8E                            ;83AFCB;00008E;
                       PHA                                  ;83AFCD;      ;
                       LDA.B $DF                            ;83AFCE;0000DF;
                       CLC                                  ;83AFD0;      ;
                       ADC.W #$0006                         ;83AFD1;      ;
                       TAX                                  ;83AFD4;      ;
                       LDA.W #$0001                         ;83AFD5;      ;
                       JSR.W Collision_ReadTileAttributeAtPixel                          ;83AFD8;83B0F6;
                       %Set16bit(!M)                             ;83AFDB;      ;
                       STA.B $7E                            ;83AFDD;00007E;
                       PLY                                  ;83AFDF;      ;
                       PLA                                  ;83AFE0;      ;
                       ASL A                                ;83AFE1;      ;
                       ORA.B $7E                            ;83AFE2;00007E;
                       STA.B $7E                            ;83AFE4;00007E;
                       BNE Bank83_NpcSpriteLogicBranch_83AFF0                      ;83AFE6;83AFF0;
                       STZ.B $7E                            ;83AFE8;00007E;
                       LDY.W #$0000                         ;83AFEA;      ;
                       JMP.W Bank83_NpcSpriteLogicBranch_83B0E1                    ;83AFED;83B0E1;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83AFF0: %Set16bit(!MX)                             ;83AFF0;      ;
                       CMP.W #$0003                         ;83AFF2;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83B00A                      ;83AFF5;83B00A;
                       CMP.W #$0002                         ;83AFF7;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83B00A                      ;83AFFA;83B00A;
                       STY.B $8E                            ;83AFFC;00008E;
                       LDA.B $8C                            ;83AFFE;00008C;
                       CLC                                  ;83B000;      ;
                       ADC.B $8E                            ;83B001;00008E;
                       SEC                                  ;83B003;      ;
                       SBC.B $88                            ;83B004;000088;
                       TAY                                  ;83B006;      ;
                       JMP.W Bank83_NpcSpriteLogicBranch_83B0E1                    ;83B007;83B0E1;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83B00A: LDA.B $8C                            ;83B00A;00008C;
                       CLC                                  ;83B00C;      ;
                       ADC.B $8E                            ;83B00D;00008E;
                       SEC                                  ;83B00F;      ;
                       SBC.B $88                            ;83B010;000088;
                       TAY                                  ;83B012;      ;
                       JMP.W Bank83_NpcSpriteLogicBranch_83B0E1                    ;83B013;83B0E1;
                                                            ;      ;      ;
                       LDA.B $DF                            ;83B016;0000DF;
                       CLC                                  ;83B018;      ;
                       ADC.B $E5                            ;83B019;0000E5;
                       ADC.W #$0006                         ;83B01B;      ;
                       ADC.B $E3                            ;83B01E;0000E3;
                       PHA                                  ;83B020;      ;
                       TAX                                  ;83B021;      ;
                       LDA.B $E1                            ;83B022;0000E1;
                       SEC                                  ;83B024;      ;
                       SBC.W #$0006                         ;83B025;      ;
                       TAY                                  ;83B028;      ;
                       LDA.W #$0000                         ;83B029;      ;
                       JSR.W Collision_ReadTileAttributeAtPixel                          ;83B02C;83B0F6;
                       %Set16bit(!M)                             ;83B02F;      ;
                       PLX                                  ;83B031;      ;
                       PHA                                  ;83B032;      ;
                       LDA.B $90                            ;83B033;000090;
                       PHA                                  ;83B035;      ;
                       LDA.B $E1                            ;83B036;0000E1;
                       CLC                                  ;83B038;      ;
                       ADC.W #$0006                         ;83B039;      ;
                       TAY                                  ;83B03C;      ;
                       LDA.W #$0001                         ;83B03D;      ;
                       JSR.W Collision_ReadTileAttributeAtPixel                          ;83B040;83B0F6;
                       %Set16bit(!M)                             ;83B043;      ;
                       STA.B $7E                            ;83B045;00007E;
                       PLX                                  ;83B047;      ;
                       PLA                                  ;83B048;      ;
                       ASL A                                ;83B049;      ;
                       ORA.B $7E                            ;83B04A;00007E;
                       STA.B $7E                            ;83B04C;00007E;
                       BNE Bank83_NpcSpriteLogicBranch_83B058                      ;83B04E;83B058;
                       STZ.B $7E                            ;83B050;00007E;
                       LDX.W #$0000                         ;83B052;      ;
                       JMP.W Bank83_NpcSpriteLogicBranch_83B0E1                    ;83B055;83B0E1;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83B058: %Set16bit(!MX)                             ;83B058;      ;
                       CMP.W #$0003                         ;83B05A;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83B071                      ;83B05D;83B071;
                       CMP.W #$0002                         ;83B05F;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83B071                      ;83B062;83B071;
                       STX.B $90                            ;83B064;000090;
                       LDA.B $86                            ;83B066;000086;
                       SEC                                  ;83B068;      ;
                       SBC.B $8A                            ;83B069;00008A;
                       SBC.B $90                            ;83B06B;000090;
                       INC A                                ;83B06D;      ;
                       TAX                                  ;83B06E;      ;
                       BRA Bank83_NpcSpriteLogicBranch_83B0E1                      ;83B06F;83B0E1;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83B071: LDA.B $86                            ;83B071;000086;
                       SEC                                  ;83B073;      ;
                       SBC.B $8A                            ;83B074;00008A;
                       SBC.B $90                            ;83B076;000090;
                       INC A                                ;83B078;      ;
                       TAX                                  ;83B079;      ;
                       BRA Bank83_NpcSpriteLogicBranch_83B0E1                      ;83B07A;83B0E1;
                                                            ;      ;      ;
                       LDA.B $DF                            ;83B07C;0000DF;
                       SEC                                  ;83B07E;      ;
                       SBC.B $E5                            ;83B07F;0000E5;
                       SBC.W #$0006                         ;83B081;      ;
                       SBC.B $E3                            ;83B084;0000E3;
                       PHA                                  ;83B086;      ;
                       TAX                                  ;83B087;      ;
                       LDA.B $E1                            ;83B088;0000E1;
                       SEC                                  ;83B08A;      ;
                       SBC.W #$0006                         ;83B08B;      ;
                       TAY                                  ;83B08E;      ;
                       LDA.W #$0000                         ;83B08F;      ;
                       JSR.W Collision_ReadTileAttributeAtPixel                          ;83B092;83B0F6;
                       %Set16bit(!M)                             ;83B095;      ;
                       PLX                                  ;83B097;      ;
                       PHA                                  ;83B098;      ;
                       LDA.B $8E                            ;83B099;00008E;
                       PHA                                  ;83B09B;      ;
                       LDA.B $E1                            ;83B09C;0000E1;
                       CLC                                  ;83B09E;      ;
                       ADC.W #$0006                         ;83B09F;      ;
                       TAY                                  ;83B0A2;      ;
                       LDA.W #$0001                         ;83B0A3;      ;
                       JSR.W Collision_ReadTileAttributeAtPixel                          ;83B0A6;83B0F6;
                       %Set16bit(!M)                             ;83B0A9;      ;
                       STA.B $7E                            ;83B0AB;00007E;
                       PLX                                  ;83B0AD;      ;
                       PLA                                  ;83B0AE;      ;
                       ASL A                                ;83B0AF;      ;
                       ORA.B $7E                            ;83B0B0;00007E;
                       STA.B $7E                            ;83B0B2;00007E;
                       BNE Bank83_NpcSpriteLogicBranch_83B0BD                      ;83B0B4;83B0BD;
                       STZ.B $7E                            ;83B0B6;00007E;
                       LDX.W #$0000                         ;83B0B8;      ;
                       BRA Bank83_NpcSpriteLogicBranch_83B0E1                      ;83B0BB;83B0E1;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83B0BD: %Set16bit(!MX)                             ;83B0BD;      ;
                       CMP.W #$0003                         ;83B0BF;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83B0D6                      ;83B0C2;83B0D6;
                       CMP.W #$0002                         ;83B0C4;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83B0D6                      ;83B0C7;83B0D6;
                       STX.B $8E                            ;83B0C9;00008E;
                       LDA.B $8A                            ;83B0CB;00008A;
                       CLC                                  ;83B0CD;      ;
                       ADC.B $8E                            ;83B0CE;00008E;
                       SEC                                  ;83B0D0;      ;
                       SBC.B $86                            ;83B0D1;000086;
                       TAX                                  ;83B0D3;      ;
                       BRA Bank83_NpcSpriteLogicBranch_83B0E1                      ;83B0D4;83B0E1;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83B0D6: LDA.B $8A                            ;83B0D6;00008A;
                       CLC                                  ;83B0D8;      ;
                       ADC.B $8E                            ;83B0D9;00008E;
                       SEC                                  ;83B0DB;      ;
                       SBC.B $86                            ;83B0DC;000086;
                       TAX                                  ;83B0DE;      ;
                       BRA Bank83_NpcSpriteLogicBranch_83B0E1                      ;83B0DF;83B0E1;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83B0E1: %Set16bit(!M)                             ;83B0E1;      ;
                       LDA.B $7E                            ;83B0E3;00007E;
                       RTL                                  ;83B0E5;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83B0E6;      ;
                       LDA.W #$0000                         ;83B0E8;      ;
                       STA.B $EB                            ;83B0EB;0000EB;
                       STA.B $E9                            ;83B0ED;0000E9;
                       LDX.W #$0000                         ;83B0EF;      ;
                       LDA.W #$0000                         ;83B0F2;      ;
                       RTL                                  ;83B0F5;      ;END_Collision_CheckObjectOverlapAtDirection
                                                            ;      ;      ;
                                                            ;      ;      ;
                Collision_ReadTileAttributeAtPixel: %Set16bit(!MX)                             ;83B0F6;      ;
                       PHA                                  ;83B0F8;      ;
                       STX.B $86                            ;83B0F9;000086;
                       STY.B $88                            ;83B0FB;000088;
                       TXA                                  ;83B0FD;      ;
                       AND.W #$FFF0                         ;83B0FE;      ;
                       STA.B $8A                            ;83B101;00008A;
                       TYA                                  ;83B103;      ;
                       AND.W #$FFF0                         ;83B104;      ;
                       STA.B $8C                            ;83B107;00008C;
                       LDA.W #$0010                         ;83B109;      ;
                       STA.B $8E                            ;83B10C;00008E;
                       LDA.W #$0000                         ;83B10E;      ;
                       STA.B $90                            ;83B111;000090;
                       LDA.W #$0002                         ;83B113;      ;
                       JSL.L TileProperty_CheckToolUseAllowed                          ;83B116;82AC61;
                       %Set8bit(!M)                             ;83B11A;      ;
                       %Set16bit(!X)                             ;83B11C;      ;
                       STA.B $92                            ;83B11E;000092;
                       %Set16bit(!M)                             ;83B120;      ;
                       PLA                                  ;83B122;      ;
                       CMP.W #$0001                         ;83B123;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83B12C                      ;83B126;83B12C;
                       STX.B $E9                            ;83B128;0000E9;
                       BRA Bank83_NpcSpriteLogicBranch_83B12E                      ;83B12A;83B12E;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83B12C: STX.B $EB                            ;83B12C;0000EB;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83B12E: %Set8bit(!M)                             ;83B12E;      ;
                       LDA.B $92                            ;83B130;000092;
                       AND.B #$01                           ;83B132;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83B139                      ;83B134;83B139;
                       JMP.W Bank83_NpcSpriteLogicBranch_83B1BA                    ;83B136;83B1BA;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83B139: LDA.B $92                            ;83B139;000092;
                       AND.B #$02                           ;83B13B;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83B16A                      ;83B13D;83B16A;
                       LDA.B $92                            ;83B13F;000092;
                       AND.B #$04                           ;83B141;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83B17E                      ;83B143;83B17E;
                       LDA.B $92                            ;83B145;000092;
                       AND.B #$08                           ;83B147;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83B192                      ;83B149;83B192;
                       LDA.B $92                            ;83B14B;000092;
                       AND.B #$10                           ;83B14D;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83B1A6                      ;83B14F;83B1A6;
                       %Set16bit(!MX)                             ;83B151;      ;
                       LDA.B !game_state                            ;83B153;0000D2;
                       AND.W #$0010                         ;83B155;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83B15D                      ;83B158;83B15D;
                       JMP.W Bank83_NpcSpriteLogicBranch_83B1C1                    ;83B15A;83B1C1;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83B15D: CPX.W #$00C0                         ;83B15D;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83B1C1                      ;83B160;83B1C1;
                       CPX.W #$00D0                         ;83B162;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83B1C1                      ;83B165;83B1C1;
                       JMP.W Bank83_NpcSpriteLogicBranch_83B1BA                    ;83B167;83B1BA;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83B16A: %Set16bit(!MX)                             ;83B16A;      ;
                       LDA.B $E7                            ;83B16C;0000E7;
                       BNE Bank83_NpcSpriteLogicBranch_83B175                      ;83B16E;83B175;
                       LDA.W #$0008                         ;83B170;      ;
                       STA.B $8E                            ;83B173;00008E;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83B175: LDA.B $86                            ;83B175;000086;
                       AND.W #$0008                         ;83B177;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83B1C1                      ;83B17A;83B1C1;
                       BRA Bank83_NpcSpriteLogicBranch_83B1BA                      ;83B17C;83B1BA;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83B17E: %Set16bit(!MX)                             ;83B17E;      ;
                       LDA.B $E7                            ;83B180;0000E7;
                       BNE Bank83_NpcSpriteLogicBranch_83B189                      ;83B182;83B189;
                       LDA.W #$0008                         ;83B184;      ;
                       STA.B $90                            ;83B187;000090;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83B189: LDA.B $86                            ;83B189;000086;
                       AND.W #$0008                         ;83B18B;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83B1C1                      ;83B18E;83B1C1;
                       BRA Bank83_NpcSpriteLogicBranch_83B1BA                      ;83B190;83B1BA;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83B192: %Set16bit(!MX)                             ;83B192;      ;
                       LDA.B $E5                            ;83B194;0000E5;
                       BNE Bank83_NpcSpriteLogicBranch_83B19D                      ;83B196;83B19D;
                       LDA.W #$0008                         ;83B198;      ;
                       STA.B $8E                            ;83B19B;00008E;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83B19D: LDA.B $88                            ;83B19D;000088;
                       AND.W #$0008                         ;83B19F;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83B1C1                      ;83B1A2;83B1C1;
                       BRA Bank83_NpcSpriteLogicBranch_83B1BA                      ;83B1A4;83B1BA;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83B1A6: %Set16bit(!MX)                             ;83B1A6;      ;
                       LDA.B $E5                            ;83B1A8;0000E5;
                       BNE Bank83_NpcSpriteLogicBranch_83B1B1                      ;83B1AA;83B1B1;
                       LDA.W #$0008                         ;83B1AC;      ;
                       STA.B $90                            ;83B1AF;000090;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83B1B1: LDA.B $88                            ;83B1B1;000088;
                       AND.W #$0008                         ;83B1B3;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83B1C1                      ;83B1B6;83B1C1;
                       BRA Bank83_NpcSpriteLogicBranch_83B1BA                      ;83B1B8;83B1BA;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83B1BA: %Set16bit(!MX)                             ;83B1BA;      ;
                       LDA.W #$0001                         ;83B1BC;      ;
                       BRA Bank83_NpcSpriteLogicBranch_83B1C8                      ;83B1BF;83B1C8;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83B1C1: %Set16bit(!MX)                             ;83B1C1;      ;
                       LDA.W #$0000                         ;83B1C3;      ;
                       BRA Bank83_NpcSpriteLogicBranch_83B1C8                      ;83B1C6;83B1C8;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83B1C8: RTS                                  ;83B1C8;      ;END_Collision_ReadTileAttributeAtPixel

; PASS14_MONEY_CORE: signed 24-bit wallet arithmetic helper.
; Inputs:
;   $72-$73 = low 16 bits of signed amount
;   $74     = high 8 bits of signed amount
; Behavior:
;   money = money + amount
;   negative result -> fail, wallet unchanged, A = 1
;   result > 999999 internal/display cap -> clamp to $0F423F, A = 0
;   valid result -> store new wallet value, A = 0
; Note: visible money display has a fake trailing zero in the UI conventions,
; but the cap check here treats $0F423F as 999999 internal units.
;;;;;;;; Money is actually stored divided by 10 basically
;;;;;;;; Param $72: Ammount low 16b, $74 Ammount low 8b
;;;;;;;; Returns A = 0: ok, 1: fails(result negative)
AddMoney: ;83B1C9
        !changeL = $72
        !changeH = $74
        !tempL = $75
        !tempH = $77

        %Set16bit(!MX)
        LDA.L !moneyL
        CLC
        ADC.B !changeL
        STA.B !tempL
        %Set8bit(!M)
        LDA.L !moneyH
        ADC.B !changeH
        STA.B !tempH
        BMI .negative
        %Set16bit(!M)
        LDA.B !tempL
        CMP.W #$423F
        %Set8bit(!M)
        LDA.B !tempH
        SBC.B #$0F                           ;0F423F = 999999
        BCS .max
        %Set16bit(!M)
        LDA.B !tempL
        STA.L !moneyL
        %Set8bit(!M)
        LDA.B !tempH
        STA.L !moneyH
        %Set16bit(!M)
        LDA.W #$0000
        BRA .return

    .negative:
        %Set16bit(!M)
        LDA.W #$0001
        BRA .return

    .max:
        %Set16bit(!M)
        LDA.W #$423F
        STA.L !moneyL
        %Set8bit(!M)
        LDA.B #$0F                           ;0F423F = 999999
        STA.L !moneyH
        %Set16bit(!M)
        LDA.W #$0000

    .return: RTL

;;;;;;;; Param $7E: Ammount
;;;;;;;; Returns A = 0: ok, 1: fails(result negative)
AddWood: ;83B224
        !change = $7E

        %Set16bit(!MX)
        STA.B !change
        LDA.L !stored_wood
        CLC
        ADC.B !change
        BMI .negative
        CMP.W #999
        BCS .max
        STA.L !stored_wood
        LDA.W #$0000
        BRA .return

    .negative:
        %Set16bit(!M)
        LDA.W #$0001
        BRA .return

    .max:
        %Set16bit(!M)
        LDA.W #999
        STA.L !stored_wood
        LDA.W #$0000

    .return: RTL

;;;;;;;; Param $7E: Ammount
;;;;;;;; Returns A = 0: ok, 1: fails(result negative)
AddGrass: ;83B253
        !change = $7E

        %Set16bit(!MX)
        STA.B !change
        LDA.L !stored_grass
        CLC
        ADC.B !change
        BMI .negative
        CMP.W #999
        BCS .max
        STA.L !stored_grass
        LDA.W #$0000
        BRA .return

    .negative:
        %Set16bit(!M)
        LDA.W #$0001
        BRA .return

    .max:
        %Set16bit(!M)
        LDA.W #999
        STA.L !stored_grass
        LDA.W #$0000

        .return: RTL

;;;;;;;; Params: $7E:amount to add (can be negative)
;;;;;;;; Returns: A = 0 Worked, 1 Fails (would en with negative happiness)
;;;;;;;; PASS30_NPC_SOCIAL_CORE: central ranch/global happiness clamp routine used by NPC/social/animal/event rewards.
Social_AddPlayerHappiness: ;83B282
        !change = $7E

        %Set16bit(!MX)
        STA.B !change
        LDA.L !happiness
        CLC
        ADC.B !change
        BMI .IfNegative
        CMP.W #999
        BCS .aboveMax
        STA.L !happiness
        LDA.W #$0000
        BRA .return

    .IfNegative:
        %Set16bit(!M)
        LDA.W #$0001
        BRA .return

    .aboveMax:
        %Set16bit(!M)
        LDA.W #999
        STA.L !happiness
        LDA.W #$0000

    .return:
        RTL

;;;;;;;; Load game Mem slot in A
;;;;;;;; Param: A: Save Slot
; -----------------------------------------------------------------------------
; PASS12 SAVE SYSTEM NOTE
; Full save-slot loader. Restores a $1000-byte SRAM slot from bank $70 into
; active game RAM. Slot 1 base is $70:0000, slot 2 base is $70:1000.
; See docs/save_system/Save_System_Map.md and Save_Slot_Layout_100.md.
; -----------------------------------------------------------------------------
SaveSystem_LoadFullSlot: ;83B2B1
        !savelocation = $72
        !savelocationBank = $74

        %Set16bit(!MX)                       ;sets location depeding on Slot
        PHA
        LDA.W #$0000
        STA.B !savelocation
        %Set8bit(!M)
        LDA.B #$70
        STA.B !savelocationBank
        %Set16bit(!M)
        PLA
        CMP.W #$0000
        BEQ .start
        LDA.W #$1000
        STA.B !savelocation
        %Set8bit(!M)
        LDA.B #$70
        STA.B !savelocationBank

    .start:
        %Set8bit(!M)
        LDY.W #$0000
        LDA.B [!savelocation],Y
        STA.L !year
        LDY.W #$0001
        LDA.B [!savelocation],Y
        STA.L !season
        LDY.W #$0002
        LDA.B [!savelocation],Y
        STA.L !weekday
        LDY.W #$0003
        LDA.B [!savelocation],Y
        STA.L !day
        LDY.W #$0004
        LDA.B [!savelocation],Y
        STA.W !seeds_grass_N
        LDY.W #$0005
        LDA.B [!savelocation],Y
        STA.W !seeds_corn_N
        LDY.W #$0006
        LDA.B [!savelocation],Y
        STA.W !seeds_tomato_N
        LDY.W #$0007
        LDA.B [!savelocation],Y
        STA.W !seeds_potato_N
        LDY.W #$0008
        LDA.B [!savelocation],Y
        STA.W !seeds_turnip_N
        LDY.W #$0009
        LDA.B [!savelocation],Y
        STA.W !feed_cow_N
        LDY.W #$000A
        LDA.B [!savelocation],Y
        STA.W !feed_chicks_N
        LDY.W #$000B
        LDA.B [!savelocation],Y
        STA.L !cow_N
        LDY.W #$000C
        LDA.B [!savelocation],Y
        STA.L !chicks_N
        LDY.W #$000D
        LDA.B [!savelocation],Y
        STA.W !weather_tomorrow
        LDY.W #$000E
        LDA.B [!savelocation],Y
        STA.W !max_stamina
        LDY.W #$000F
        LDA.B [!savelocation],Y
        STA.W !tool_selected
        LDY.W #$0010
        LDA.B [!savelocation],Y
        STA.W !watering_can_water
        LDY.W #$0011
        LDA.B [!savelocation],Y
        STA.L $7F1F12
        LDY.W #$0012
        LDA.B [!savelocation],Y
        STA.L $7F1F2B
        LDY.W #$0013
        LDA.B [!savelocation],Y
        STA.L !dog_map
        LDY.W #$0014
        LDA.B [!savelocation],Y
        STA.L $7F1F31
        LDY.W #$0015
        LDA.B [!savelocation],Y
        STA.L $7F1F32
        LDY.W #$0016
        LDA.B [!savelocation],Y
        STA.L !development_rate
        LDY.W #$0017
        LDA.B [!savelocation],Y
        STA.L !power_berry_N
        LDY.W #$0018
        LDA.B [!savelocation],Y
        STA.W $09A3
        LDY.W #$0019
        LDA.B [!savelocation],Y
        STA.W $0937
        LDY.W #$001A
        LDA.B [!savelocation],Y
        STA.W !tool_backpack
        %Set16bit(!M)
        LDY.W #$0040
        LDA.B [!savelocation],Y
        STA.L !stored_wood
        LDY.W #$0042
        LDA.B [!savelocation],Y
        STA.L !stored_grass
        LDY.W #$0044
        LDA.B [!savelocation],Y
        STA.W $0196
        LDY.W #$0046
        LDA.B [!savelocation],Y
        STA.L !planted_grass
        LDY.W #$0048
        LDA.B [!savelocation],Y
        STA.L !hearts_maria
        LDY.W #$004A
        LDA.B [!savelocation],Y
        STA.L !hearts_ann
        LDY.W #$004C
        LDA.B [!savelocation],Y
        STA.L !hearts_nina
        LDY.W #$004E
        LDA.B [!savelocation],Y
        STA.L !hearts_ellen
        LDY.W #$0050
        LDA.B [!savelocation],Y
        STA.L !hearts_eve
        LDY.W #$0060
        LDA.B [!savelocation],Y
        STA.L !player_house_and_event_flags
        LDY.W #$0062
        LDA.B [!savelocation],Y
        STA.L !marriage_flags
        LDY.W #$0064
        LDA.B [!savelocation],Y
        STA.L $7F1F68
        LDY.W #$0066
        LDA.B [!savelocation],Y
        STA.L $7F1F6A
        LDY.W #$0068
        LDA.B [!savelocation],Y
        STA.L !dog_pos_X
        LDY.W #$006A
        LDA.B [!savelocation],Y
        STA.L !dog_pos_Y
        LDY.W #$006C
        LDA.B [!savelocation],Y
        STA.L !happiness
        LDY.W #$006E
        LDA.B [!savelocation],Y
        STA.L $7F1F45
        LDY.W #$0070
        LDA.B [!savelocation],Y
        STA.L !family_event_flags
        LDY.W #$0072
        LDA.B [!savelocation],Y
        STA.L !child_flags
        LDY.W #$0074
        LDA.B [!savelocation],Y
        STA.L $7F1F70
        LDY.W #$0076
        LDA.B [!savelocation],Y
        STA.L $7F1F72
        LDY.W #$0078
        LDA.B [!savelocation],Y
        STA.L !wife_pregnancy
        LDY.W #$007A
        LDA.B [!savelocation],Y
        STA.L !kid1_age
        LDY.W #$007C
        LDA.B [!savelocation],Y
        STA.L !kid2_age
        LDY.W #$0031
        LDA.B [!savelocation],Y
        STA.L !shipped_corn
        LDY.W #$0033
        LDA.B [!savelocation],Y
        STA.L !shipped_tomatoes
        LDY.W #$0035
        LDA.B [!savelocation],Y
        STA.L !shipped_turnips
        LDY.W #$0037
        LDA.B [!savelocation],Y
        STA.L !shipped_potatoes
        LDY.W #$007E
        LDA.B [!savelocation],Y
        STA.L !dog_hugs
        %Set16bit(!M)
        LDY.W #$0039
        LDA.B [!savelocation],Y
        STA.L !moneyL
        %Set8bit(!M)
        LDY.W #$003B
        LDA.B [!savelocation],Y
        STA.L !moneyH
        %Set8bit(!M)

        LDA.B #$00                           ;Player Name
        XBA
        LDY.W #$0080
        LDA.B [!savelocation],Y
        STA.W !player_name_sort_1
        %Set16bit(!M)
        STA.W !player_name_long_1
        %Set8bit(!M)
        LDY.W #$0081
        LDA.B [!savelocation],Y
        STA.W !player_name_sort_2
        %Set16bit(!M)
        STA.W !player_name_long_2
        %Set8bit(!M)
        LDY.W #$0082
        LDA.B [!savelocation],Y
        STA.W !player_name_sort_3
        %Set16bit(!M)
        STA.W !player_name_long_3
        %Set8bit(!M)
        LDY.W #$0083
        LDA.B [!savelocation],Y
        STA.W !player_name_sort_4
        %Set16bit(!M)
        STA.W !player_name_long_4

        %Set8bit(!M)
        LDY.W #$0084
        LDA.B [!savelocation],Y
        STA.L !shed_items_row_1
        LDY.W #$0085
        LDA.B [!savelocation],Y
        STA.L !shed_items_row_2
        LDY.W #$0086
        LDA.B [!savelocation],Y
        STA.L !shed_items_row_3
        LDY.W #$0087
        LDA.B [!savelocation],Y
        STA.L !shed_items_row_4

        %Set8bit(!M)                         ;name of Dog
        LDA.B #$00
        XBA
        LDY.W #$0088
        LDA.B [!savelocation],Y
        STA.W !dog_name_short_1
        %Set16bit(!M)
        STA.W !dog_name_long_1
        %Set8bit(!M)
        LDY.W #$0089
        LDA.B [!savelocation],Y
        STA.W !dog_name_short_2
        %Set16bit(!M)
        STA.W !dog_name_long_2
        %Set8bit(!M)
        LDY.W #$008A
        LDA.B [!savelocation],Y
        STA.W !dog_name_short_3
        %Set16bit(!M)
        STA.W !dog_name_long_3
        %Set8bit(!M)
        LDY.W #$008B
        LDA.B [!savelocation],Y
        STA.W !dog_name_short_4
        %Set16bit(!M)
        STA.W !dog_name_long_4

        %Set8bit(!M)                         ;name of Horse
        LDA.B #$00
        XBA
        LDY.W #$008C
        LDA.B [!savelocation],Y
        STA.W !horse_name_short_1
        %Set16bit(!M)
        STA.W !horse_name_long_1
        %Set8bit(!M)
        LDY.W #$008D
        LDA.B [!savelocation],Y
        STA.W !horse_name_short_2
        %Set16bit(!M)
        STA.W !horse_name_long_2
        %Set8bit(!M)
        LDY.W #$008E
        LDA.B [!savelocation],Y
        STA.W !horse_name_short_3
        %Set16bit(!M)
        STA.W !horse_name_long_3
        %Set8bit(!M)
        LDY.W #$008F
        LDA.B [!savelocation],Y
        STA.W !horse_name_short_4
        %Set16bit(!M)
        STA.W !horse_name_long_4

        %Set8bit(!M)                         ;name of Kid 1
        LDA.B #$00
        XBA
        LDY.W #$0090
        LDA.B [!savelocation],Y
        STA.L !kid1_name_sort_1
        %Set16bit(!M)
        STA.W !kid1_name_long_1
        %Set8bit(!M)
        LDY.W #$0091
        LDA.B [!savelocation],Y
        STA.L !kid1_name_sort_2
        %Set16bit(!M)
        STA.W !kid1_name_long_2
        %Set8bit(!M)
        LDY.W #$0092
        LDA.B [!savelocation],Y
        STA.L !kid1_name_sort_3
        %Set16bit(!M)
        STA.W !kid1_name_long_3
        %Set8bit(!M)
        LDY.W #$0093
        LDA.B [!savelocation],Y
        STA.L !kid1_name_sort_4
        %Set16bit(!M)
        STA.W !kid1_name_long_4

        %Set8bit(!M)                         ;name of Kid 2?
        LDA.B #$00
        XBA
        LDY.W #$0094
        LDA.B [!savelocation],Y
        STA.L !kid2_name_sort_1
        %Set16bit(!M)
        STA.W !kid2_name_long_1
        %Set8bit(!M)
        LDY.W #$0095
        LDA.B [!savelocation],Y
        STA.L !kid2_name_sort_2
        %Set16bit(!M)
        STA.W !kid2_name_long_2
        %Set8bit(!M)
        LDY.W #$0096
        LDA.B [!savelocation],Y
        STA.L !kid2_name_sort_3
        %Set16bit(!M)
        STA.W !kid2_name_long_3
        %Set8bit(!M)
        LDY.W #$0097
        LDA.B [!savelocation],Y
        STA.L !kid2_name_sort_4
        %Set16bit(!M)
        STA.W !kid2_name_long_4

        %Set8bit(!M)
        LDY.W #$0098
        LDX.W #$0000
    .chickens:
        LDA.B [!savelocation],Y
        STA.L !chicken_array,X
        INY
        INX
        CPX.W #$0068
        BNE .chickens
        %Set8bit(!M)

        LDY.W #$0100
        LDX.W #$0000
    .cows:
        LDA.B [!savelocation],Y
        STA.L !cow_array,X
        INY
        INX
        CPX.W #$00C0
        BNE .cows

        %Set16bit(!M)                        ;save slot selected
        LDA.B !savelocation
        STA.B $75
        %Set8bit(!M)
        LDA.B !savelocationBank
        STA.B $77

        JSL.L LoadDefaultFarmMap

        %Set8bit(!M)                         ;copy farm data
        LDY.W #$01C0
        LDX.W #$00C0
    .farmData:
        LDA.B [$75],Y
        STA.L !farm_map_array,X
        INY
        INX
        CPX.W #$0F00
        BNE .farmData
        RTL

;;;;;;;; Save game Mem slot in A
;;;;;;;; Param: A: Save Slot
; -----------------------------------------------------------------------------
; PASS12 SAVE SYSTEM NOTE
; Full save-slot writer. Serializes date, inventory/feed, money, hearts, names,
; livestock arrays and farm tile state into the selected SRAM slot.
; Checksum is stored at slot offsets $002F-$0030; FARM signature at $003C-$003F.
; -----------------------------------------------------------------------------
SaveSystem_SaveSlot: ;83B68E
        !savelocation = $72
        !savelocationBank = $74
        !crcsum = $7E

        %Set16bit(!MX)
        PHA
        LDA.W #$0000
        STA.B !savelocation
        %Set8bit(!M)
        LDA.B #$70
        STA.B !savelocationBank
        %Set16bit(!M)
        PLA
        PHA
        CMP.W #$0000
        BEQ .start
        LDA.W #$1000
        STA.B !savelocation
        %Set8bit(!M)
        LDA.B #$70
        STA.B !savelocationBank

    .start:
        %Set8bit(!M)
        LDY.W #$0000
        LDA.L !year
        STA.B [!savelocation],Y
        LDY.W #$0001
        LDA.L !season
        STA.B [!savelocation],Y
        LDY.W #$0002
        LDA.L !weekday
        STA.B [!savelocation],Y
        LDY.W #$0003
        LDA.L !day
        STA.B [!savelocation],Y
        LDY.W #$0004
        LDA.W !seeds_grass_N
        STA.B [!savelocation],Y
        LDY.W #$0005
        LDA.W !seeds_corn_N
        STA.B [!savelocation],Y
        LDY.W #$0006
        LDA.W !seeds_tomato_N
        STA.B [!savelocation],Y
        LDY.W #$0007
        LDA.W !seeds_potato_N
        STA.B [!savelocation],Y
        LDY.W #$0008
        LDA.W !seeds_turnip_N
        STA.B [!savelocation],Y
        LDY.W #$0009
        LDA.W !feed_cow_N
        STA.B [!savelocation],Y
        LDY.W #$000A
        LDA.W !feed_chicks_N
        STA.B [!savelocation],Y
        LDY.W #$000B
        LDA.L !cow_N
        STA.B [!savelocation],Y
        LDY.W #$000C
        LDA.L !chicks_N
        STA.B [!savelocation],Y
        LDY.W #$000D
        LDA.W !weather_tomorrow
        STA.B [!savelocation],Y
        LDY.W #$000E
        LDA.W !max_stamina
        STA.B [!savelocation],Y
        LDY.W #$000F
        LDA.W !tool_selected
        STA.B [!savelocation],Y
        LDY.W #$0010
        LDA.W !watering_can_water
        STA.B [!savelocation],Y
        LDY.W #$0011
        LDA.L $7F1F12
        STA.B [!savelocation],Y
        LDY.W #$0012
        LDA.L $7F1F2B
        STA.B [!savelocation],Y
        LDY.W #$0013
        LDA.L !dog_map
        STA.B [!savelocation],Y
        LDY.W #$0014
        LDA.L $7F1F31
        STA.B [!savelocation],Y
        LDY.W #$0015
        LDA.L $7F1F32
        STA.B [!savelocation],Y
        LDY.W #$0016
        LDA.L !development_rate
        STA.B [!savelocation],Y
        LDY.W #$0017
        LDA.L !power_berry_N
        STA.B [!savelocation],Y
        LDY.W #$0018
        LDA.W $09A3
        STA.B [!savelocation],Y
        LDY.W #$0019
        LDA.W $0937
        STA.B [!savelocation],Y
        LDY.W #$001A
        LDA.W !tool_backpack
        STA.B [!savelocation],Y
        %Set16bit(!M)
        LDY.W #$0040
        LDA.L !stored_wood
        STA.B [!savelocation],Y
        LDY.W #$0042
        LDA.L !stored_grass
        STA.B [!savelocation],Y
        LDY.W #$0044
        LDA.W $0196
        STA.B [!savelocation],Y
        LDY.W #$0046
        LDA.L !planted_grass
        STA.B [!savelocation],Y
        LDY.W #$0048
        LDA.L !hearts_maria
        STA.B [!savelocation],Y
        LDY.W #$004A
        LDA.L !hearts_ann
        STA.B [!savelocation],Y
        LDY.W #$004C
        LDA.L !hearts_nina
        STA.B [!savelocation],Y
        LDY.W #$004E
        LDA.L !hearts_ellen
        STA.B [!savelocation],Y
        LDY.W #$0050
        LDA.L !hearts_eve
        STA.B [!savelocation],Y
        LDY.W #$0060
        LDA.L !player_house_and_event_flags
        STA.B [!savelocation],Y
        LDY.W #$0062
        LDA.L !marriage_flags
        STA.B [!savelocation],Y
        LDY.W #$0064
        LDA.L $7F1F68
        STA.B [!savelocation],Y
        LDY.W #$0066
        LDA.L $7F1F6A
        STA.B [!savelocation],Y
        LDY.W #$0068
        LDA.L !dog_pos_X
        STA.B [!savelocation],Y
        LDY.W #$006A
        LDA.L !dog_pos_Y
        STA.B [!savelocation],Y
        LDY.W #$006C
        LDA.L !happiness
        STA.B [!savelocation],Y
        LDY.W #$006E
        LDA.L $7F1F45
        STA.B [!savelocation],Y
        LDY.W #$0070
        LDA.L !family_event_flags
        STA.B [!savelocation],Y
        LDY.W #$0072
        LDA.L !child_flags
        STA.B [!savelocation],Y
        LDY.W #$0074
        LDA.L $7F1F70
        STA.B [!savelocation],Y
        LDY.W #$0076
        LDA.L $7F1F72
        STA.B [!savelocation],Y
        LDY.W #$0078
        LDA.L !wife_pregnancy
        STA.B [!savelocation],Y
        LDY.W #$007A
        LDA.L !kid1_age
        STA.B [!savelocation],Y
        LDY.W #$007C
        LDA.L !kid2_age
        STA.B [!savelocation],Y
        LDY.W #$0031
        LDA.L !shipped_corn
        STA.B [!savelocation],Y
        LDY.W #$0033
        LDA.L !shipped_tomatoes
        STA.B [!savelocation],Y
        LDY.W #$0035
        LDA.L !shipped_turnips
        STA.B [!savelocation],Y
        LDY.W #$0037
        LDA.L !shipped_potatoes
        STA.B [!savelocation],Y
        LDY.W #$007E
        LDA.L !dog_hugs
        STA.B [!savelocation],Y
        %Set16bit(!M)
        LDY.W #$0039
        LDA.L !moneyL
        STA.B [!savelocation],Y
        %Set8bit(!M)
        LDY.W #$003B
        LDA.L !moneyH
        STA.B [!savelocation],Y

        %Set8bit(!M)
        LDY.W #$0080
        LDA.W !player_name_sort_1
        STA.B [!savelocation],Y
        LDY.W #$0081
        LDA.W !player_name_sort_2
        STA.B [!savelocation],Y
        LDY.W #$0082
        LDA.W !player_name_sort_3
        STA.B [!savelocation],Y
        LDY.W #$0083
        LDA.W !player_name_sort_4
        STA.B [!savelocation],Y

        %Set8bit(!M)
        LDY.W #$0084
        LDA.L !shed_items_row_1
        STA.B [!savelocation],Y
        LDY.W #$0085
        LDA.L !shed_items_row_2
        STA.B [!savelocation],Y
        LDY.W #$0086
        LDA.L !shed_items_row_3
        STA.B [!savelocation],Y
        LDY.W #$0087
        LDA.L !shed_items_row_4
        STA.B [!savelocation],Y

        %Set8bit(!M)                         ;Dog Name
        LDY.W #$0088
        LDA.W !dog_name_short_1
        STA.B [!savelocation],Y
        LDY.W #$0089
        LDA.W !dog_name_short_2
        STA.B [!savelocation],Y
        LDY.W #$008A
        LDA.W !dog_name_short_3
        STA.B [!savelocation],Y
        LDY.W #$008B
        LDA.W !dog_name_short_4
        STA.B [!savelocation],Y

        %Set8bit(!M)                         ;Horse Name
        LDY.W #$008C
        LDA.W !horse_name_short_1
        STA.B [!savelocation],Y
        LDY.W #$008D
        LDA.W !horse_name_short_2
        STA.B [!savelocation],Y
        LDY.W #$008E
        LDA.W !horse_name_short_3
        STA.B [!savelocation],Y
        LDY.W #$008F
        LDA.W !horse_name_short_4
        STA.B [!savelocation],Y

        %Set8bit(!M)                         ;Name of Kid 1
        LDY.W #$0090
        LDA.L !kid1_name_sort_1
        STA.B [!savelocation],Y
        LDY.W #$0091
        LDA.L !kid1_name_sort_2
        STA.B [!savelocation],Y
        LDY.W #$0092
        LDA.L !kid1_name_sort_3
        STA.B [!savelocation],Y
        LDY.W #$0093
        LDA.L !kid1_name_sort_4
        STA.B [!savelocation],Y

        %Set8bit(!M)                         ;Name of Kid 2
        LDY.W #$0094
        LDA.L !kid2_name_sort_1
        STA.B [!savelocation],Y
        LDY.W #$0095
        LDA.L !kid2_name_sort_2
        STA.B [!savelocation],Y
        LDY.W #$0096
        LDA.L !kid2_name_sort_3
        STA.B [!savelocation],Y
        LDY.W #$0097
        LDA.L !kid2_name_sort_4
        STA.B [!savelocation],Y

        %Set8bit(!M)                         ;Chikens
        LDY.W #$0098
        LDX.W #$0000
      - LDA.L !chicken_array,X
        STA.B [!savelocation],Y
        INY
        INX
        CPX.W #$0068
        BNE -

        %Set8bit(!M)                         ;Cows
        LDY.W #$0100
        LDX.W #$0000
      - LDA.L !cow_array,X
        STA.B [!savelocation],Y
        INY
        INX
        CPX.W #$00C0
        BNE -

        %Set8bit(!M)                         ;Farm Data
        LDY.W #$01C0
        LDX.W #$00C0
      - LDA.L !farm_map_array,X
        STA.B [!savelocation],Y
        INY
        INX
        CPX.W #$0F00
        BNE -

        %Set8bit(!M)                         ;crc sum
        LDY.W #$002E
        LDA.B #$00
        STA.B [!savelocation],Y
        %Set16bit(!MX)
        LDY.W #$002F
        LDA.W #$0000
        STA.B [!savelocation],Y
        LDY.W #$0000
        STZ.B !crcsum

      - LDA.B [!savelocation],Y
        CLC
        ADC.B !crcsum
        STA.B !crcsum
        INY
        INY
        CPY.W #$1000
        BNE -

        %Set16bit(!MX)
        LDY.W #$002F
        LDA.B !crcsum
        STA.B [!savelocation],Y
        %Set16bit(!M)
        PLA
        STA.B !crcsum
        LDA.W #$0000
        STA.B !savelocation
        %Set8bit(!M)
        LDA.B #$70
        STA.B !savelocationBank
        %Set16bit(!M)
        LDY.W #$002E
        LDA.B !crcsum
        BEQ .slot1
        %Set8bit(!M)
        LDA.B #$00
        STA.B [!savelocation],Y
        BRA .slot2

    .slot1
        %Set8bit(!M)
        LDA.B #$01
        STA.B [!savelocation],Y

    .slot2
        %Set16bit(!M)
        LDA.W #$1000
        STA.B !savelocation
        %Set8bit(!M)
        LDA.B #$70
        STA.B !savelocationBank
        %Set16bit(!M)
        LDY.W #$002E
        LDA.B !crcsum
        BEQ +
        %Set8bit(!M)
        LDA.B #$01
        STA.B [!savelocation],Y
        BRA $06

      + %Set8bit(!M)
        LDA.B #$00
        STA.B [!savelocation],Y

        RTL


;;;;;;;; Loads minimun info about the game slot
;;;;;;;; Param: A: Save Slot
; -----------------------------------------------------------------------------
; PASS12 SAVE SYSTEM NOTE
; Lightweight summary loader for menus. Reads only date/name style fields from
; a save slot instead of restoring the full active game state.
; -----------------------------------------------------------------------------
SaveSystem_LoadSlotSummary: ;83BA45
        !savelocation = $72
        !savelocationBank = $74

        %Set16bit(!MX)
        PHA
        LDA.W #$0000
        STA.B !savelocation
        %Set8bit(!M)
        LDA.B #$70
        STA.B !savelocationBank
        %Set16bit(!M)
        PLA
        CMP.W #$0000
        BEQ .start
        LDA.W #$1000
        STA.B !savelocation
        %Set8bit(!M)
        LDA.B #$70
        STA.B !savelocationBank

    .start:
        %Set8bit(!M)
        %Set16bit(!X)
        LDX.W #$0000
        LDY.W #$0000
        LDA.B [!savelocation],Y
        STA.L !year
        LDY.W #$0001
        LDA.B [!savelocation],Y
        STA.L !season
        LDY.W #$0003
        LDA.B [!savelocation],Y
        STA.L !day
        BEQ .return

        LDY.W #$003C                         ;Farm Check
        LDA.B [!savelocation],Y
        CMP.B !ASCII_F
        BNE .return
        LDY.W #$003D
        LDA.B [!savelocation],Y
        CMP.B !ASCII_A
        BNE .return
        LDY.W #$003E
        LDA.B [!savelocation],Y
        CMP.B !ASCII_R
        BNE .return
        LDY.W #$003F
        LDA.B [!savelocation],Y
        CMP.B !ASCII_M
        BNE .return

        %Set8bit(!M)
        LDY.W #$0080
        LDA.B [!savelocation],Y
        STA.W !player_name_sort_1
        LDY.W #$0081
        LDA.B [!savelocation],Y
        STA.W !player_name_sort_2
        LDY.W #$0082
        LDA.B [!savelocation],Y
        STA.W !player_name_sort_3
        LDY.W #$0083
        LDA.B [!savelocation],Y
        STA.W !player_name_sort_4
        LDX.W #$0001

    .return: RTL

;;;;;;;; Saves has between 3C-3F the ascii word FARM as a rudimentary check
;;;;;;;; Theres also a CRC check stored on 2F
;;;;;;;; Each saves is 4k, but seems that only 2k are actually used per save
; -----------------------------------------------------------------------------
; PASS12 SAVE SYSTEM NOTE
; SRAM integrity/checksum routine. Validates the FARM signature and checksum;
; invalid save data is repaired/cleared before use.
; -----------------------------------------------------------------------------
SaveSystem_CheckSRAMIntegrity: ;83BAD4
        !fails = $82
        !pointer = $72
        !pointerBank = $74
        !save_crc = $7E
        !crc_sum = $80

        %Set8bit(!M)
        %Set16bit(!X)
        STZ.W $098E
        %Set16bit(!M)
        LDA.L $7F1F60                        ;Flag $0800 indicates at least one save slot
        AND.W #$F7FF                         ;has been reset. Flag cleared here
        STA.L $7F1F60
        STZ.B !fails                        ;assume memory is fine
        LDA.W #$0000                         ;Starts with save 1
        STA.B !pointer
        %Set8bit(!M)
        LDA.B #$70
        STA.B !pointerBank                   ;Sets pointer to the beguining of the first save slot

    ;FARM check slot 1
        LDY.W #$003C
        LDA.B [!pointer],Y
        CMP.B !ASCII_F
        BNE .integrityFailed
        LDY.W #$003D
        LDA.B [!pointer],Y
        CMP.B !ASCII_A
        BNE .integrityFailed
        LDY.W #$003E
        LDA.B [!pointer],Y
        CMP.B !ASCII_R
        BNE .integrityFailed
        LDY.W #$003F
        LDA.B [!pointer],Y
        CMP.B !ASCII_M
        BNE .integrityFailed

        ;TODO: Unknown value, modifing it doesnt seem to do anything, always one
        %Set8bit(!M)
        LDY.W #$002E
        LDA.B [!pointer],Y
        STA.B $92
        LDA.B #$00
        STA.B [!pointer],Y                   ;Its set to 0 for the CRC

    ;CRC Sum Loop
        %Set16bit(!MX)
        LDY.W #$002F                         ;Stores the save's CRC
        LDA.B [!pointer],Y
        STA.B !save_crc
        LDA.W #$0000                         ;Zeroes values to not alter CRC sum
        STA.B [!pointer],Y
        LDY.W #$0000
        STZ.B !crc_sum

      - LDA.B [!pointer],Y
        CLC
        ADC.B !crc_sum
        STA.B !crc_sum
        INY
        INY
        CPY.W #$1000
        BNE -

        %Set16bit(!MX)
        LDA.B !save_crc
        CMP.B !crc_sum                       ;Checks if old CRC matches
        BNE .integrityFailed
        LDY.W #$002F
        LDA.B !save_crc
        STA.B [!pointer],Y                   ;Restores the save CRC

        %Set8bit(!M)
        LDY.W #$002E
        LDA.B $92
        STA.B [!pointer],Y                    ;Restores unknown value

        BRA .check1Passed

        ;delets the whole memory block, and restores the FARM check
    .integrityFailed:
        %Set16bit(!MX)
        LDY.W #$0000
        LDA.W #$0000

      - STA.B [!pointer],Y                        ;Clears Memory
        INY
        INY
        CPY.W #$0800
        BNE -

        %Set8bit(!M)                             ;Restores FARM check
        LDY.W #$003C
        LDA.B !ASCII_F
        STA.B [!pointer],Y
        LDY.W #$003D
        LDA.B !ASCII_A
        STA.B [!pointer],Y
        LDY.W #$003E
        LDA.B !ASCII_R
        STA.B [!pointer],Y
        LDY.W #$003F
        LDA.B !ASCII_M
        STA.B [!pointer],Y
        %Set16bit(!M)
        LDA.W #$0001
        STA.B !fails

        ;Repeats everything Slot 1 did with 2
    .check1Passed:
        %Set16bit(!MX)
        LDA.W #$1000                         ;Sets pointer to Slot 2
        STA.B !pointer
        %Set8bit(!M)
        LDA.B #$70
        STA.B !pointerBank

    ;FARM check slot 1
        LDY.W #$003C
        LDA.B [!pointer],Y
        CMP.B !ASCII_F
        BNE .integrityFailed2
        LDY.W #$003D
        LDA.B [!pointer],Y
        CMP.B !ASCII_A
        BNE .integrityFailed2
        LDY.W #$003E
        LDA.B [!pointer],Y
        CMP.B !ASCII_R
        BNE .integrityFailed2
        LDY.W #$003F
        LDA.B [!pointer],Y
        CMP.B !ASCII_M
        BNE .integrityFailed2

        ;TODO: Unknown value
        %Set8bit(!M)
        LDY.W #$002E
        LDA.B [!pointer],Y
        STA.B $92
        LDA.B #$00
        STA.B [!pointer],Y

    ;CRC Sum Loop
        %Set16bit(!MX)
        LDY.W #$002F
        LDA.B [!pointer],Y
        STA.B !save_crc
        LDA.W #$0000
        STA.B [!pointer],Y
        LDY.W #$0000
        STZ.B !crc_sum

      - LDA.B [!pointer],Y
        CLC
        ADC.B !crc_sum
        STA.B !crc_sum
        INY
        INY
        CPY.W #$1000
        BNE -

        %Set16bit(!MX)
        LDA.B !save_crc
        CMP.B !crc_sum
        BNE .integrityFailed2
        LDY.W #$002F
        LDA.B !save_crc
        STA.B [!pointer],Y

        %Set8bit(!M)
        LDY.W #$002E
        LDA.B $92
        STA.B [!pointer],Y
        CMP.B #$01                           ;Compares if the value is 1???
        BNE .check2Passed
        LDA.B #$01
        STA.W $098E                          ;??? TODO
        BRA .check2Passed

        ;deletes the whole memory block, and restores the FARM check
    .integrityFailed2:
        %Set16bit(!MX)
        LDY.W #$0000
        LDA.W #$0000

      - STA.B [!pointer],Y
        INY
        INY
        CPY.W #$0800
        BNE -

        %Set8bit(!M)                             ;Restores FARM check
        LDY.W #$003C
        LDA.B !ASCII_F
        STA.B [!pointer],Y
        LDY.W #$003D
        LDA.B !ASCII_A
        STA.B [!pointer],Y
        LDY.W #$003E
        LDA.B !ASCII_R
        STA.B [!pointer],Y
        LDY.W #$003F
        LDA.B !ASCII_M
        STA.B [!pointer],Y
        %Set16bit(!M)
        LDA.B !fails
        BEQ .check2Passed
        LDA.L $7F1F60
        ORA.W #$0800                         ;If at least one save fails, it sets flag $0800
        STA.L $7F1F60

    .check2Passed:
        RTL


;;; PASS18 LIVESTOCK CORE 100%
;;; Daily livestock update dispatcher.
;;; Scope documented in docs/livestock_system/Livestock_Core_100.md.
;;; This routine walks cow slots first, then chicken slots, and performs the
;;; daily persistent updates: feeding result, sickness/cranky transitions,
;;; pregnancy/birth timers, chick growth, egg flags, and livestock event flags.
;;; Comments only: no binary output change.
Livestock_DailyStatusAndFeedingUpdate: ;83BC5A
        %Set16bit(!MX)
        LDA.L $7F1F60
        AND.W #$0001                         ;TODO
        BEQ +
        JMP.W .altcowfeed

      + LDX.W #$0000

    .cowloop:
        %Set16bit(!MX)
        PHX
        PHX
        TXA
        JSL.L GetCowPointer
        %Set8bit(!M)
        %Set16bit(!X)
        PLX
        LDY.W #$0000
        LDA.B [$72],Y                        ;Status
        AND.B #$01                           ;Exists
        BNE .cowexists
        JMP.W .skipcow

    .cowexists:
        %Set8bit(!M)
        LDY.W #$0000
        LDA.B [$72],Y                        ;Status
        AND.B #$02                           ;Baby
        BEQ .isbaby
        JMP.W .skipcow

    .isbaby:
        LDY.W #$0000
        LDA.B [$72],Y                        ;Status
        AND.B #$04                           ;Child
        BEQ .ischild
        JMP.W .babyonfarm

    .ischild:
        LDY.W #$0002
        LDA.B [$72],Y                        ;Map
        CMP.B #$27                           ;Barn
        BNE .notinbarn
        LDY.W #$0000
        LDA.B [$72],Y                        ;Status
        AND.B #$40                           ;Pregnant
        BNE .ispregnant
        %Set16bit(!M)
        TXA
        ASL A
        TAX
        LDA.L AnimalFeed_StallBitmaskTable,X
        AND.W !fed_cows_flags
        BEQ .cowunfed
        JMP.W .cowfed

    .ispregnant:
        %Set16bit(!MX)
        LDX.W #$0018                         ;Special pregnant cow slot
        LDA.L AnimalFeed_StallBitmaskTable,X
        AND.W !fed_cows_flags
        BEQ .cowunfed
        JMP.W .cowfed

    .notinbarn:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0002
        LDA.B [$72],Y                        ;Map
        CMP.B #$04                           ;Farm
        BCS .cowunfed
        JSL.L FarmGrass_MarkFirstMatureGrassPatch                          ;TODO
        %Set16bit(!M)
        LDA.W $092E
        BEQ .cowunfed
        %Set16bit(!M)
        LDA.W $0196
        AND.W #$0002
        BNE .cowunfed
        LDA.W $0196
        AND.W #$0008
        BNE .Bank83_NpcSpriteLogicBranch_83BD20
        LDA.W $0196
        AND.W #$0010
        BNE .Bank83_NpcSpriteLogicBranch_83BD30
        LDA.W $0196
        AND.W #$0200
        BNE .Bank83_NpcSpriteLogicBranch_83BD40
        JMP.W .cowfed

    .cowunfed:
        %Set16bit(!M)
        LDA.W #$FFF8
        JSL.L EventCmd_31_CowRelated_AddCowHappiness
        %Set16bit(!MX)
        LDY.W #$0004
        BRA .cowgetsick

    .Bank83_NpcSpriteLogicBranch_83BD20:
        %Set16bit(!M)
        LDA.W #$FFF0
        JSL.L EventCmd_31_CowRelated_AddCowHappiness
        %Set16bit(!MX)
        LDY.W #$0002
        BRA .cowgetsick

    .Bank83_NpcSpriteLogicBranch_83BD30:
        %Set16bit(!M)
        LDA.W #$FFE8
        JSL.L EventCmd_31_CowRelated_AddCowHappiness
        %Set16bit(!MX)
        LDY.W #$0002
        BRA .cowgetsick

    .Bank83_NpcSpriteLogicBranch_83BD40:
        %Set16bit(!M)                             ;83BD40;      ;
        LDA.W #$FFF8                         ;83BD42;      ;
        JSL.L EventCmd_31_CowRelated_AddCowHappiness                    ;83BD45;84A5D4;
        %Set16bit(!MX)                             ;83BD49;      ;
        LDY.W #$0008                         ;83BD4B;      ;
        BRA .cowgetsick                      ;83BD4E;83BD50;

    .cowgetsick: ;param in Y
        %Set16bit(!MX)
        TYA
        JSL.L RNG_GetRange0ToAExclusiveStyle
        BNE .cowfed
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0000
        LDA.B [$72],Y                        ;status
        AND.B #$40                           ;pregnant
        BNE .cowfed
        LDY.W #$0001
        LDA.B [$72],Y                        ;TODO, milked today?
        AND.B #$80
        BNE .cowfed
        LDY.W #$0000
        LDA.B [$72],Y                        ;Status
        AND.B #$20                           ;sick
        BNE .cowfed
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0000
        LDA.B [$72],Y                        ;Status
        ORA.B #$20
        STA.B [$72],Y                        ;sets Sick
        LDY.W #$0003
        LDA.B #$07
        STA.B [$72],Y                        ;Pregnancy set to 7???
        %Set16bit(!M)
        LDA.W #$FFF4
        JSL.L EventCmd_31_CowRelated_AddCowHappiness
        %Set16bit(!MX)
        LDA.W #$FFE2
        JSL.L Social_AddPlayerHappiness

    .cowfed:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0005
        LDA.B [$72],Y                        ;TODO
        CMP.B #$0A
        BEQ .cowgetscranky
        %Set16bit(!M)
        LDA.L $7F1F5A                        ;TODO
        AND.W #$1000                         ;FLAG5A
        BEQ .Bank83_NpcSpriteLogicBranch_83BDD6
        %Set8bit(!M)
        LDY.W #$0002
        LDA.B [$72],Y                        ;Map
        CMP.B #$27                           ;Barn
        BEQ .skipcow
        %Set8bit(!M)
        LDA.B #$10
        JSL.L RNG_GetRange0ToAExclusiveStyle
        BNE .Bank83_NpcSpriteLogicBranch_83BDD6
        %Set16bit(!M)
        LDA.W #$FFF8
        JSL.L EventCmd_31_CowRelated_AddCowHappiness
        BRA .cowgetscranky

    .Bank83_NpcSpriteLogicBranch_83BDD6:
        %Set16bit(!M)
        LDA.W $0196                          ;Todo
        AND.W #$0400
        BEQ .skipcow
        %Set8bit(!M)
        LDY.W #$0002
        LDA.B [$72],Y                        ;Gets back to barn?
        CMP.B #$27
        BEQ .skipcow

    .cowgetscranky:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0000
        LDA.B [$72],Y                        ;Status
        AND.B #$40                           ;Pregnant
        BNE .skipcow
        LDY.W #$0001
        LDA.B [$72],Y                        ;TODO
        AND.B #$80
        BNE .skipcow
        LDY.W #$0000
        LDA.B [$72],Y                        ;Status
        AND.B #$20                           ;Sick
        BNE .skipcow
        %Set8bit(!M)
        LDY.W #$0000
        LDA.B [$72],Y                        ;Status
        ORA.B #$10                           ;set Cranky
        STA.B [$72],Y
        LDY.W #$0003
        LDA.B #$03                           ;Farm Winter
        STA.B [$72],Y                        ;Map
        LDY.W #$0005                         ;TODO
        LDA.B #$00
        STA.B [$72],Y
        %Set16bit(!M)
        LDA.W #$FFE2
        JSL.L EventCmd_31_CowRelated_AddCowHappiness
        BRA .skipcow

    .babyonfarm:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0002
        LDA.B [$72],Y                        ;Map
        CMP.B #$04                           ;Farm
        BCS .skipcow
        JSL.L FarmGrass_MarkFirstMatureGrassPatch

    .skipcow:
        %Set16bit(!MX)
        PLX
        INX
        CPX.W #$000C
        BEQ .altcowfeed
        JMP.W .cowloop

    .altcowfeed:
        %Set16bit(!MX)
        LDA.L !child_flags
        AND.W #$EFBF                         ;TODO
        STA.L !child_flags
        LDX.W #$0000

    .cowloop2:
        %Set16bit(!MX)
        PHX
        PHX
        TXA
        JSL.L GetCowPointer
        %Set8bit(!M)
        %Set16bit(!X)
        PLX
        LDY.W #$0000
        LDA.B [$72],Y                        ;Status
        AND.B #$01                           ;Exists
        BNE .cowexists2
        JMP.W .skipcow2

    .cowexists2:
        LDY.W #$0004
        LDA.B [$72],Y                        ;Happines BUG?
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$72],Y                        ;TODO
        AND.B #$F8
        STA.B [$72],Y
        LDY.W #$0000
        LDA.B [$72],Y                        ;Status
        AND.B #$02
        BEQ .isbaby2
        LDY.W #$0003
        LDA.B [$72],Y                        ;Pregnancy
        INC A                                ;+1
        STA.B [$72],Y
        CMP.B #14
        BEQ .cowborn
        JMP.W .skipcow2

    .cowborn:
        LDA.B #$00
        STA.B [$72],Y                        ;Pregnancy
        LDY.W #$0000
        LDA.B [$72],Y                        ;Status
        ORA.B #$04
        AND.B #$FD
        STA.B [$72],Y                        ;Sets as healthy Adult
        JMP.W .skipcow2

    .isbaby2:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0000
        LDA.B [$72],Y                        ;Status
        AND.B #$04
        BEQ .itsadult2
        %Set8bit(!M)
        LDY.W #$0003
        LDA.B [$72],Y                        ;Age
        INC A
        STA.B [$72],Y                        ;+1
        CMP.B #21
        BEQ .growstochild
        JMP.W .skipcow2

    .growstochild:
        LDA.B #$00
        STA.B [$72],Y                        ;Status
        LDY.W #$0000
        LDA.B [$72],Y                        ;Status
        ORA.B #$08
        AND.B #$FB
        STA.B [$72],Y
        LDY.W #$0003
        LDA.B #$00
        STA.B [$72],Y                        ;Sets as healthy Child
        %Set16bit(!M)
        LDA.L !child_flags
        ORA.W #$1000                         ;Sets cow "born" flag
        STA.L !child_flags
        JMP.W .skipcow2

    .itsadult2:
        %Set16bit(!MX)
        LDA.L !child_flags
        ORA.W #$1000
        STA.L !child_flags
        %Set8bit(!M)
        LDY.W #$0000
        LDA.B [$72],Y                        ;Status
        AND.B #$10                           ;Cranky
        BEQ .itsnotcranky2
        LDY.W #$0003                         ;Crankyness
        LDA.B [$72],Y
        DEC A
        STA.B [$72],Y                        ;-1
        BEQ .uncrankyfy2
        JMP.W .skipcow2

    .uncrankyfy2:
        LDY.W #$0000
        LDA.B [$72],Y
        AND.B #$EF
        STA.B [$72],Y
        JMP.W .skipcow2

    .itsnotcranky2:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0000
        LDA.B [$72],Y                        ;Status
        AND.B #$20                           ;Sick
        BEQ .healthycow2
        LDY.W #$0003
        LDA.B [$72],Y
        BEQ .specialcheck
        DEC A                                ;83BF3A;      ;
        STA.B [$72],Y                        ;83BF3B;000072;
        BEQ .specialcheck                      ;83BF3D;83BF42;
        JMP.W .skipcow2                    ;83BF3F;83C01A;
                                                            ;      ;      ;
                                                            ;      ;      ;
    .specialcheck:
        %Set16bit(!MX)
        LDA.W $0196                          ;TODO
        AND.W #$001A
        BEQ .notafestival
        JMP.W .skipcow2

    .notafestival:
        %Set8bit(!M)
        LDA.W !weather_tomorrow
        CMP.B #$06                           ;Its not a festival/special
        BCC .cowdied
        JMP.W .skipcow2

    .cowdied:
        %Set8bit(!M)
        LDY.W #$0000
        LDA.B #$00                           ;No cow
        STA.B [$72],Y                        ;Status
        %Set8bit(!M)
        LDA.L !cow_N
        DEC A                                ;one less cow
        STA.L !cow_N
        %Set16bit(!M)
        LDA.L !child_flags
        ORA.W #$0040                         ;Cow Funeral flag
        STA.L !child_flags
        PLX
        PHX
        TXA
        %Set8bit(!M)
        STA.W $0937                          ;TODO
        JMP.W .skipcow2

    .healthycow2:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0001
        LDA.B [$72],Y                        ;Flags
        AND.B #$80                           ;TODO
        BEQ .specialcheck2
        %Set8bit(!M)
        LDY.W #$0000
        LDA.B [$72],Y                        ;Status
        ORA.B #$40                           ;Sets Pregnant?
        STA.B [$72],Y
        LDY.W #$0001
        LDA.B [$72],Y                        ;TODO
        AND.B #$7F                           ;Unsets 80
        STA.B [$72],Y
        BRA .skipcow2

    .specialcheck2:
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0000
        LDA.B [$72],Y                        ;Status
        AND.B #$40                           ;Pregnant?
        BEQ .skipcow2
        LDY.W #$0003
        LDA.B [$72],Y                        ;Pregnancy
        BEQ .cowbirth2
        DEC A                                ;-1
        STA.B [$72],Y
        LDA.L $7F1F12                        ;TODO
        DEC A
        STA.L $7F1F12
        BNE .skipcow2

    .cowbirth2:
        LDY.W #$0002
        LDA.B [$72],Y                        ;Map
        CMP.B #$27                           ;Barn
        BNE .skipcow2
        %Set16bit(!M)
        LDA.L !player_house_and_event_flags
        ORA.W #$0008                         ;TODO Cow Pregnat?
        STA.L !player_house_and_event_flags
        %Set8bit(!M)
        LDY.W #$0000
        LDA.B [$72],Y                        ;Status
        ORA.B #$80
        AND.B #$BF                           ;Not Pregnant
        STA.B [$72],Y
        %Set8bit(!M)
        LDA.B #20                            ;TODO Starting cow Happiness?
        STA.L $7F1F2B
        LDY.W #$0004
        LDA.B [$72],Y                        ;Happyness
        CMP.B #96
        BCC .nextcow2
        CMP.B #192
        BCC .lesscowhappyness
        %Set8bit(!M)
        LDA.B #100
        STA.L $7F1F2B                        ;TODO Starting cow Happiness?
        BRA .nextcow2

    .lesscowhappyness:
        %Set8bit(!M)
        LDA.B #50
        STA.L $7F1F2B                        ;TODO Starting cow Happiness?
        BRA .nextcow2

    .nextcow2:
        BRA .skipcow2

    .skipcow2:
        %Set16bit(!MX)
        PLX
        INX
        CPX.W #12
        BEQ +
        JMP.W .cowloop2                    ;83C023;83BE5B;

          + %Set16bit(!MX)                             ;83C026;      ;
                       LDA.L $7F1F60                        ;83C028;7F1F60;
                       AND.W #$0001                         ;83C02C;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83C034                      ;83C02F;83C034;
                       JMP.W Bank83_NpcSpriteLogicBranch_83C125                    ;83C031;83C125;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83C034: %Set16bit(!MX)                             ;83C034;      ;
                       LDA.L !child_flags                        ;83C036;7F1F6E;
                       AND.W #$FFDF                         ;83C03A;      ;
                       STA.L !child_flags                        ;83C03D;7F1F6E;
                       LDX.W #$0000                         ;83C041;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83C044: %Set16bit(!MX)                             ;83C044;      ;
                       PHX                                  ;83C046;      ;
                       PHX                                  ;83C047;      ;
                       TXA                                  ;83C048;      ;
                       JSL.L GetChickenPointer          ;83C049;83C995;
                       %Set8bit(!M)                             ;83C04D;      ;
                       %Set16bit(!X)                             ;83C04F;      ;
                       PLX                                  ;83C051;      ;
                       LDY.W #$0000                         ;83C052;      ;
                       LDA.B [$72],Y                        ;83C055;000072;
                       AND.B #$01                           ;83C057;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83C05E                      ;83C059;83C05E;
                       JMP.W Bank83_NpcSpriteLogicBranch_83C119                    ;83C05B;83C119;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83C05E: %Set8bit(!M)                             ;83C05E;      ;
                       LDY.W #$0000                         ;83C060;      ;
                       LDA.B [$72],Y                        ;83C063;000072;
                       AND.B #$0E                           ;83C065;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83C084                      ;83C067;83C084;
                       %Set8bit(!M)                             ;83C069;      ;
                       LDY.W #$0000                         ;83C06B;      ;
                       LDA.B #$00                           ;83C06E;      ;
                       STA.B [$72],Y                        ;83C070;000072;
                       LDA.L !chicks_N                        ;83C072;7F1F0B;
                       DEC A                                ;83C076;      ;
                       STA.L !chicks_N                        ;83C077;7F1F0B;
                       %Set16bit(!MX)                             ;83C07B;      ;
                       LDA.W #$FFE2                         ;83C07D;      ;
                       JSL.L Social_AddPlayerHappiness                   ;83C080;83B282;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83C084: %Set8bit(!M)                             ;83C084;      ;
                       LDY.W #$0000                         ;83C086;      ;
                       LDA.B [$72],Y                        ;83C089;000072;
                       AND.B #$08                           ;83C08B;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83C092                      ;83C08D;83C092;
                       JMP.W Bank83_NpcSpriteLogicBranch_83C119                    ;83C08F;83C119;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83C092: %Set8bit(!M)                             ;83C092;      ;
                       LDY.W #$0001                         ;83C094;      ;
                       LDA.B [$72],Y                        ;83C097;000072;
                       CMP.B #$28                           ;83C099;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83C0AB                      ;83C09B;83C0AB;
                       %Set8bit(!M)                             ;83C09D;      ;
                       LDA.W !fed_chicks_N                          ;83C09F;000931;
                       BEQ Bank83_NpcSpriteLogicBranch_83C0CF                      ;83C0A2;83C0CF;
                       DEC A                                ;83C0A4;      ;
                       STA.W !fed_chicks_N                          ;83C0A5;000931;
                       JMP.W Bank83_NpcSpriteLogicBranch_83C119                    ;83C0A8;83C119;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83C0AB: %Set8bit(!M)                             ;83C0AB;      ;
                       %Set16bit(!X)                             ;83C0AD;      ;
                       LDY.W #$0001                         ;83C0AF;      ;
                       LDA.B [$72],Y                        ;83C0B2;000072;
                       CMP.B #$04                           ;83C0B4;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83C0CF                      ;83C0B6;83C0CF;
                       JSL.L FarmGrass_MarkFirstMatureGrassPatch                          ;83C0B8;82A9A0;
                       %Set16bit(!M)                             ;83C0BC;      ;
                       LDA.W $092E                          ;83C0BE;00092E;
                       BEQ Bank83_NpcSpriteLogicBranch_83C0CF                      ;83C0C1;83C0CF;
                       %Set16bit(!M)                             ;83C0C3;      ;
                       LDA.W $0196                          ;83C0C5;000196;
                       AND.W #$020A                         ;83C0C8;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83C0CF                      ;83C0CB;83C0CF;
                       BRA Bank83_NpcSpriteLogicBranch_83C0E5                      ;83C0CD;83C0E5;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83C0CF: %Set8bit(!M)                             ;83C0CF;      ;
                       %Set16bit(!X)                             ;83C0D1;      ;
                       LDY.W #$0000                         ;83C0D3;      ;
                       LDA.B [$72],Y                        ;83C0D6;000072;
                       ORA.B #$10                           ;83C0D8;      ;
                       STA.B [$72],Y                        ;83C0DA;000072;
                       LDY.W #$0002                         ;83C0DC;      ;
                       LDA.B #$03                           ;83C0DF;      ;
                       STA.B [$72],Y                        ;83C0E1;000072;
                       BRA Bank83_NpcSpriteLogicBranch_83C0E5                      ;83C0E3;83C0E5;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83C0E5: %Set16bit(!MX)                             ;83C0E5;      ;
                       LDA.W $0196                          ;83C0E7;000196;
                       AND.W #$0410                         ;83C0EA;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83C119                      ;83C0ED;83C119;
                       LDA.L !child_flags                        ;83C0EF;7F1F6E;
                       AND.W #$0020                         ;83C0F3;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83C119                      ;83C0F6;83C119;
                       %Set8bit(!M)                             ;83C0F8;      ;
                       LDY.W #$0001                         ;83C0FA;      ;
                       LDA.B [$72],Y                        ;83C0FD;000072;
                       CMP.B #$04                           ;83C0FF;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83C119                      ;83C101;83C119;
                       LDY.W #$0000                         ;83C103;      ;
                       LDA.B #$01                           ;83C106;      ;
                       STA.B [$72],Y                        ;83C108;000072;
                       %Set16bit(!M)                             ;83C10A;      ;
                       LDA.L !child_flags                        ;83C10C;7F1F6E;
                       ORA.W #$0020                         ;83C110;      ;
                       STA.L !child_flags                        ;83C113;7F1F6E;
                       BRA Bank83_NpcSpriteLogicBranch_83C119                      ;83C117;83C119;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83C119: %Set16bit(!MX)                             ;83C119;      ;
                       PLX                                  ;83C11B;      ;
                       INX                                  ;83C11C;      ;
                       CPX.W #$000D                         ;83C11D;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83C125                      ;83C120;83C125;
                       JMP.W Bank83_NpcSpriteLogicBranch_83C044                    ;83C122;83C044;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83C125: %Set16bit(!MX)                             ;83C125;      ;
                       LDX.W #$0000                         ;83C127;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83C12A: %Set16bit(!MX)                             ;83C12A;      ;
                       PHX                                  ;83C12C;      ;
                       PHX                                  ;83C12D;      ;
                       TXA                                  ;83C12E;      ;
                       JSL.L GetChickenPointer          ;83C12F;83C995;
                       %Set8bit(!M)                             ;83C133;      ;
                       %Set16bit(!X)                             ;83C135;      ;
                       PLX                                  ;83C137;      ;
                       LDY.W #$0000                         ;83C138;      ;
                       LDA.B [$72],Y                        ;83C13B;000072;
                       AND.B #$01                           ;83C13D;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83C144                      ;83C13F;83C144;
                       JMP.W Bank83_NpcSpriteLogicBranch_83C1DC                    ;83C141;83C1DC;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83C144: %Set8bit(!M)                             ;83C144;      ;
                       LDY.W #$0000                         ;83C146;      ;
                       LDA.B [$72],Y                        ;83C149;000072;
                       AND.B #$02                           ;83C14B;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83C1AB                      ;83C14D;83C1AB;
                       %Set8bit(!M)                             ;83C14F;      ;
                       %Set16bit(!X)                             ;83C151;      ;
                       LDY.W #$0002                         ;83C153;      ;
                       LDA.B [$72],Y                        ;83C156;000072;
                       CMP.B #$03                           ;83C158;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83C163                      ;83C15A;83C163;
                       INC A                                ;83C15C;      ;
                       STA.B [$72],Y                        ;83C15D;000072;
                       CMP.B #$03                           ;83C15F;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83C1DC                      ;83C161;83C1DC;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83C163: %Set8bit(!M)                             ;83C163;      ;
                       LDA.L !chicks_N                        ;83C165;7F1F0B;
                       CMP.B #$0C                           ;83C169;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83C1DC                      ;83C16B;83C1DC;
                       LDY.W #$0002                         ;83C16D;      ;
                       LDA.B #$00                           ;83C170;      ;
                       STA.B [$72],Y                        ;83C172;000072;
                       LDY.W #$0000                         ;83C174;      ;
                       LDA.B [$72],Y                        ;83C177;000072;
                       ORA.B #$04                           ;83C179;      ;
                       AND.B #$BD                           ;83C17B;      ;
                       STA.B [$72],Y                        ;83C17D;000072;
                       %Set16bit(!M)                             ;83C17F;      ;
                       LDY.W #$0004                         ;83C181;      ;
                       LDA.W #$00D8                         ;83C184;      ;
                       STA.B [$72],Y                        ;83C187;000072;
                       LDY.W #$0006                         ;83C189;      ;
                       LDA.W #$00B8                         ;83C18C;      ;
                       STA.B [$72],Y                        ;83C18F;000072;
                       %Set8bit(!M)                             ;83C191;      ;
                       LDA.L !chicks_N                        ;83C193;7F1F0B;
                       INC A                                ;83C197;      ;
                       STA.L !chicks_N                        ;83C198;7F1F0B;
                       %Set16bit(!MX)                             ;83C19C;      ;
                       LDA.L !child_flags                        ;83C19E;7F1F6E;
                       AND.W #$DFFF                         ;83C1A2;      ;
                       STA.L !child_flags                        ;83C1A5;7F1F6E;
                       BRA Bank83_NpcSpriteLogicBranch_83C1DC                      ;83C1A9;83C1DC;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83C1AB: %Set8bit(!M)                             ;83C1AB;      ;
                       %Set16bit(!X)                             ;83C1AD;      ;
                       LDY.W #$0000                         ;83C1AF;      ;
                       LDA.B [$72],Y                        ;83C1B2;000072;
                       AND.B #$04                           ;83C1B4;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83C1DC                      ;83C1B6;83C1DC;
                       LDY.W #$0002                         ;83C1B8;      ;
                       LDA.B [$72],Y                        ;83C1BB;000072;
                       INC A                                ;83C1BD;      ;
                       STA.B [$72],Y                        ;83C1BE;000072;
                       CMP.B #$07                           ;83C1C0;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83C1DC                      ;83C1C2;83C1DC;
                       LDA.B #$00                           ;83C1C4;      ;
                       STA.B [$72],Y                        ;83C1C6;000072;
                       LDY.W #$0000                         ;83C1C8;      ;
                       LDA.B [$72],Y                        ;83C1CB;000072;
                       ORA.B #$08                           ;83C1CD;      ;
                       AND.B #$FB                           ;83C1CF;      ;
                       STA.B [$72],Y                        ;83C1D1;000072;
                       LDY.W #$0002                         ;83C1D3;      ;
                       LDA.B #$00                           ;83C1D6;      ;
                       STA.B [$72],Y                        ;83C1D8;000072;
                       BRA Bank83_NpcSpriteLogicBranch_83C1DC                      ;83C1DA;83C1DC;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83C1DC: %Set16bit(!MX)                             ;83C1DC;      ;
                       PLX                                  ;83C1DE;      ;
                       INX                                  ;83C1DF;      ;
                       CPX.W #$000D                         ;83C1E0;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83C1E8                      ;83C1E3;83C1E8;
                       JMP.W Bank83_NpcSpriteLogicBranch_83C12A                    ;83C1E5;83C12A;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83C1E8: %Set16bit(!MX)                             ;83C1E8;      ;
                       LDA.W #$0000                         ;83C1EA;      ;
                       STA.L $7F1F45                        ;83C1ED;7F1F45;
                       LDA.L !child_flags                        ;83C1F1;7F1F6E;
                       AND.W #$FBFF                         ;83C1F5;      ;
                       STA.L !child_flags                        ;83C1F8;7F1F6E;
                       LDX.W #$0000                         ;83C1FC;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83C1FF: %Set16bit(!MX)                             ;83C1FF;      ;
                       PHX                                  ;83C201;      ;
                       PHX                                  ;83C202;      ;
                       TXA                                  ;83C203;      ;
                       JSL.L GetChickenPointer          ;83C204;83C995;
                       %Set8bit(!M)                             ;83C208;      ;
                       %Set16bit(!X)                             ;83C20A;      ;
                       PLX                                  ;83C20C;      ;
                       LDY.W #$0000                         ;83C20D;      ;
                       LDA.B [$72],Y                        ;83C210;000072;
                       AND.B #$01                           ;83C212;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83C219                      ;83C214;83C219;
                       JMP.W Bank83_NpcSpriteLogicBranch_83C26F                    ;83C216;83C26F;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83C219: %Set8bit(!M)                             ;83C219;      ;
                       LDY.W #$0000                         ;83C21B;      ;
                       LDA.B [$72],Y                        ;83C21E;000072;
                       AND.B #$08                           ;83C220;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83C26F                      ;83C222;83C26F;
                       LDY.W #$0000                         ;83C224;      ;
                       LDA.B [$72],Y                        ;83C227;000072;
                       AND.B #$10                           ;83C229;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83C258                      ;83C22B;83C258;
                       LDY.W #$0001                         ;83C22D;      ;
                       LDA.B [$72],Y                        ;83C230;000072;
                       CMP.B #$28                           ;83C232;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83C26F                      ;83C234;83C26F;
                       %Set16bit(!MX)                             ;83C236;      ;
                       PLX                                  ;83C238;      ;
                       PHX                                  ;83C239;      ;
                       TXA                                  ;83C23A;      ;
                       ASL A                                ;83C23B;      ;
                       TAX                                  ;83C23C;      ;
                       LDA.L Chicken_EggLaidBitmaskTable,X                 ;83C23D;83CA78;
                       ORA.L $7F1F45                        ;83C241;7F1F45;
                       STA.L $7F1F45                        ;83C245;7F1F45;
                       %Set16bit(!M)                             ;83C249;      ;
                       LDA.L !child_flags                        ;83C24B;7F1F6E;
                       ORA.W #$0400                         ;83C24F;      ;
                       STA.L !child_flags                        ;83C252;7F1F6E;
                       BRA Bank83_NpcSpriteLogicBranch_83C26F                      ;83C256;83C26F;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83C258: %Set8bit(!M)                             ;83C258;      ;
                       %Set16bit(!X)                             ;83C25A;      ;
                       LDY.W #$0002                         ;83C25C;      ;
                       LDA.B [$72],Y                        ;83C25F;000072;
                       DEC A                                ;83C261;      ;
                       STA.B [$72],Y                        ;83C262;000072;
                       BNE Bank83_NpcSpriteLogicBranch_83C26F                      ;83C264;83C26F;
                       LDY.W #$0000                         ;83C266;      ;
                       LDA.B [$72],Y                        ;83C269;000072;
                       AND.B #$EF                           ;83C26B;      ;
                       STA.B [$72],Y                        ;83C26D;000072;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83C26F: %Set16bit(!MX)                             ;83C26F;      ;
                       PLX                                  ;83C271;      ;
                       INX                                  ;83C272;      ;
                       CPX.W #$000D                         ;83C273;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83C27B                      ;83C276;83C27B;
                       JMP.W Bank83_NpcSpriteLogicBranch_83C1FF                    ;83C278;83C1FF;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83C27B: %Set16bit(!MX)                             ;83C27B;      ;
                       LDA.L $7F1F68                        ;83C27D;7F1F68;
                       AND.W #$0100                         ;83C281;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83C295                      ;83C284;83C295;
                       %Set8bit(!M)                             ;83C286;      ;
                       LDA.L $7F1F32                        ;83C288;7F1F32;
                       CMP.B #$15                           ;83C28C;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83C295                      ;83C28E;83C295;
                       INC A                                ;83C290;      ;
                       STA.L $7F1F32                        ;83C291;7F1F32;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83C295: RTL                                  ;83C295;      ;

;;;;;;;;
;;; PASS18 LIVESTOCK CORE 100%
;;; Runtime visible-object spawn for animals.
;;; It reads saved livestock arrays and creates visible GOBJ/object entries for
;;; chickens, cows, dog and horse according to the current map/tilemap.
Livestock_SpawnVisibleAnimalObjects:
        %Set16bit(!MX)
        LDX.W #$0000

    .Bank83_NpcSpriteLogicBranch_83C29B:
            %Set16bit(!MX)
            PHX
            PHX
            TXA
            JSL.L GetChickenPointer
            %Set8bit(!M)
            %Set16bit(!X)
            PLX
            LDY.W #$0000
            LDA.B [$72],Y
            AND.B #$01
            BNE .Bank83_NpcSpriteLogicBranch_83C2B5
            JMP.W .Bank83_NpcSpriteLogicBranch_83C401

        .Bank83_NpcSpriteLogicBranch_83C2B5:
            LDY.W #$0000
            LDA.B [$72],Y
            AND.B #$20
            BEQ .Bank83_NpcSpriteLogicBranch_83C2C1
            JMP.W .Bank83_NpcSpriteLogicBranch_83C401

        .Bank83_NpcSpriteLogicBranch_83C2C1:
            %Set8bit(!M)
            LDY.W #$0001
            LDA.B [$72],Y
            CMP.B #$04
            BCS .Bank83_NpcSpriteLogicBranch_83C2D8
            LDA.B !tilemap_to_load
            CMP.B #$04
            BCC .Bank83_NpcSpriteLogicBranch_83C2D5
            JMP.W .Bank83_NpcSpriteLogicBranch_83C401

        .Bank83_NpcSpriteLogicBranch_83C2D5:
            JMP.W .Bank83_NpcSpriteLogicBranch_83C370

        .Bank83_NpcSpriteLogicBranch_83C2D8:
            %Set8bit(!M)
            LDY.W #$0001
            LDA.B [$72],Y
            CMP.B #$08
            BCS .Bank83_NpcSpriteLogicBranch_83C2F5
            LDA.B !tilemap_to_load
            CMP.B #$04
            BCS .Bank83_NpcSpriteLogicBranch_83C2EC
            JMP.W .Bank83_NpcSpriteLogicBranch_83C401

        .Bank83_NpcSpriteLogicBranch_83C2EC:
            CMP.B #$08
            BCC .Bank83_NpcSpriteLogicBranch_83C2F3
            JMP.W .Bank83_NpcSpriteLogicBranch_83C401

        .Bank83_NpcSpriteLogicBranch_83C2F3:
            BRA .Bank83_NpcSpriteLogicBranch_83C370

        .Bank83_NpcSpriteLogicBranch_83C2F5:
            %Set8bit(!M)
            LDY.W #$0001
            LDA.B [$72],Y
            CMP.B #$10
            BCS .Bank83_NpcSpriteLogicBranch_83C312
            LDA.B !tilemap_to_load
            CMP.B #$0C
            BCS .Bank83_NpcSpriteLogicBranch_83C309
            JMP.W .Bank83_NpcSpriteLogicBranch_83C401

        .Bank83_NpcSpriteLogicBranch_83C309:
            CMP.B #$10
            BCC .Bank83_NpcSpriteLogicBranch_83C310
            JMP.W .Bank83_NpcSpriteLogicBranch_83C401

        .Bank83_NpcSpriteLogicBranch_83C310:
            BRA .Bank83_NpcSpriteLogicBranch_83C370

        .Bank83_NpcSpriteLogicBranch_83C312:
            %Set8bit(!M)
            LDY.W #$0001
            LDA.B [$72],Y
            CMP.B #$14
            BCS .Bank83_NpcSpriteLogicBranch_83C32F
            LDA.B !tilemap_to_load
            CMP.B #$10
            BCS .Bank83_NpcSpriteLogicBranch_83C326
            JMP.W .Bank83_NpcSpriteLogicBranch_83C401

        .Bank83_NpcSpriteLogicBranch_83C326:
            CMP.B #$14
            BCC .Bank83_NpcSpriteLogicBranch_83C32D
            JMP.W .Bank83_NpcSpriteLogicBranch_83C401

        .Bank83_NpcSpriteLogicBranch_83C32D:
            BRA .Bank83_NpcSpriteLogicBranch_83C370

        .Bank83_NpcSpriteLogicBranch_83C32F:
            %Set8bit(!M)
            LDY.W #$0001
            LDA.B [$72],Y
            CMP.B #$18
            BCS .Bank83_NpcSpriteLogicBranch_83C34C
            LDA.B !tilemap_to_load
            CMP.B #$15
            BCS .Bank83_NpcSpriteLogicBranch_83C343
            JMP.W .Bank83_NpcSpriteLogicBranch_83C401

        .Bank83_NpcSpriteLogicBranch_83C343:
            CMP.B #$18
            BCC .Bank83_NpcSpriteLogicBranch_83C34A
            JMP.W .Bank83_NpcSpriteLogicBranch_83C401

        .Bank83_NpcSpriteLogicBranch_83C34A:
            BRA .Bank83_NpcSpriteLogicBranch_83C370

        .Bank83_NpcSpriteLogicBranch_83C34C:
            %Set8bit(!M)
            LDY.W #$0001
            LDA.B [$72],Y
            CMP.B #$31
            BCC .Bank83_NpcSpriteLogicBranch_83C362
            LDA.B !tilemap_to_load
            CMP.B #$31
            BCS .Bank83_NpcSpriteLogicBranch_83C360
            JMP.W .Bank83_NpcSpriteLogicBranch_83C401

        .Bank83_NpcSpriteLogicBranch_83C360:
            BRA .Bank83_NpcSpriteLogicBranch_83C370

        .Bank83_NpcSpriteLogicBranch_83C362:
            %Set8bit(!M)
            LDY.W #$0001
            LDA.B [$72],Y
            CMP.B !tilemap_to_load
            BEQ .Bank83_NpcSpriteLogicBranch_83C370
            JMP.W .Bank83_NpcSpriteLogicBranch_83C401

        .Bank83_NpcSpriteLogicBranch_83C370:
            %Set16bit(!M)
            LDY.W #$0004
            LDA.B [$72],Y
            STA.W !tile_in_front_X
            LDY.W #$0006
            LDA.B [$72],Y
            STA.W !tile_in_front_Y
            %Set8bit(!M)
            LDY.W #$0000
            LDA.B [$72],Y
            AND.B #$02
            BEQ .Bank83_NpcSpriteLogicBranch_83C3AB
            %Set16bit(!M)
            TXA
            CLC
            ADC.W #$0024
            LDX.W #$0000
            LDY.W #$0000
            JSL.L EventScript_LoadScriptPointerForFacingTile
            %Set8bit(!M)
            %Set16bit(!X)
            LDY.W #$0000
            LDA.B #$03
            STA.B [$CC],Y
            BRA .Bank83_NpcSpriteLogicBranch_83C401

        .Bank83_NpcSpriteLogicBranch_83C3AB:
            %Set8bit(!M)
            LDY.W #$0000
            LDA.B [$72],Y
            AND.B #$04
            BEQ .Bank83_NpcSpriteLogicBranch_83C3C9
            %Set16bit(!M)
            TXA
            CLC
            ADC.W #$0024
            LDX.W #$0000
            LDY.W #$0001
            JSL.L EventScript_LoadScriptPointerForFacingTile
            BRA .Bank83_NpcSpriteLogicBranch_83C401

        .Bank83_NpcSpriteLogicBranch_83C3C9:
            %Set8bit(!M)
            LDY.W #$0000
            LDA.B [$72],Y
            AND.B #$08
            BEQ .Bank83_NpcSpriteLogicBranch_83C3F0
            %Set16bit(!M)
            TXA
            CLC
            ADC.W #$0024
            LDX.W #$0000
            LDY.W #$0002
            JSL.L EventScript_LoadScriptPointerForFacingTile
            %Set16bit(!MX)
            PLA
            PHA
            ASL A
            TAX
            STZ.W $093B,X
            BRA .Bank83_NpcSpriteLogicBranch_83C401

        .Bank83_NpcSpriteLogicBranch_83C3F0:
            %Set16bit(!M)
            TXA
            CLC
            ADC.W #$0024
            LDX.W #$0000
            LDY.W #$005F
            JSL.L EventScript_LoadScriptPointerForFacingTile

        .Bank83_NpcSpriteLogicBranch_83C401:
            %Set16bit(!MX)
            PLX
            INX
            CPX.W #$000D
            BEQ .Bank83_NpcSpriteLogicBranch_83C40D
            JMP.W .Bank83_NpcSpriteLogicBranch_83C29B

    .Bank83_NpcSpriteLogicBranch_83C40D:
        LDX.W #$0000

    .Bank83_NpcSpriteLogicBranch_83C410:
            %Set16bit(!MX)
            PHX
            PHX
            TXA
            JSL.L GetCowPointer
            %Set8bit(!M)
            %Set16bit(!X)
            PLX
            LDY.W #$0000
            LDA.B [$72],Y
            AND.B #$01
            BNE .Bank83_NpcSpriteLogicBranch_83C42A
            JMP.W .Bank83_NpcSpriteLogicBranch_83C63D

        .Bank83_NpcSpriteLogicBranch_83C42A:
            %Set8bit(!M)
            LDA.B !tilemap_to_load
            CMP.B #$27
            BNE .Bank83_NpcSpriteLogicBranch_83C46D
            LDY.W #$0002
            LDA.B [$72],Y
            CMP.B #$27
            BEQ .Bank83_NpcSpriteLogicBranch_83C43E
            JMP.W .Bank83_NpcSpriteLogicBranch_83C63D

        .Bank83_NpcSpriteLogicBranch_83C43E:
            PHX
            %Set8bit(!M)
            LDY.W #$0000
            LDA.B [$72],Y
            AND.B #$C0
            BEQ .Bank83_NpcSpriteLogicBranch_83C44D
            LDX.W #$000C

        .Bank83_NpcSpriteLogicBranch_83C44D:
            %Set16bit(!M)
            TXA
            ASL A
            ASL A
            TAX
            LDY.W #$0008
            LDA.L Cow_BarnSpawnPositionTable,X
            STA.W !tile_in_front_X
            INX
            INX
            LDY.W #$000A
            LDA.L Cow_BarnSpawnPositionTable,X
            STA.W !tile_in_front_Y
            PLX
            JMP.W .Bank83_NpcSpriteLogicBranch_83C52E

        .Bank83_NpcSpriteLogicBranch_83C46D:
            %Set8bit(!M)
            LDY.W #$0002
            LDA.B [$72],Y
            CMP.B #$04
            BCS .Bank83_NpcSpriteLogicBranch_83C484
            LDA.B !tilemap_to_load
            CMP.B #$04
            BCC .Bank83_NpcSpriteLogicBranch_83C481
            JMP.W .Bank83_NpcSpriteLogicBranch_83C63D

        .Bank83_NpcSpriteLogicBranch_83C481:
            JMP.W .Bank83_NpcSpriteLogicBranch_83C51C

        .Bank83_NpcSpriteLogicBranch_83C484:
            %Set8bit(!M)
            LDY.W #$0002
            LDA.B [$72],Y
            CMP.B #$08
            BCS .Bank83_NpcSpriteLogicBranch_83C4A1
            LDA.B !tilemap_to_load
            CMP.B #$04
            BCS .Bank83_NpcSpriteLogicBranch_83C498
            JMP.W .Bank83_NpcSpriteLogicBranch_83C63D

        .Bank83_NpcSpriteLogicBranch_83C498:
            CMP.B #$08
            BCC .Bank83_NpcSpriteLogicBranch_83C49F
            JMP.W .Bank83_NpcSpriteLogicBranch_83C63D

        .Bank83_NpcSpriteLogicBranch_83C49F:
            BRA .Bank83_NpcSpriteLogicBranch_83C51C

        .Bank83_NpcSpriteLogicBranch_83C4A1:
            %Set8bit(!M)
            LDY.W #$0002
            LDA.B [$72],Y
            CMP.B #$10
            BCS .Bank83_NpcSpriteLogicBranch_83C4BE
            LDA.B !tilemap_to_load
            CMP.B #$0C
            BCS .Bank83_NpcSpriteLogicBranch_83C4B5
            JMP.W .Bank83_NpcSpriteLogicBranch_83C63D

        .Bank83_NpcSpriteLogicBranch_83C4B5:
            CMP.B #$10
            BCC .Bank83_NpcSpriteLogicBranch_83C4BC
            JMP.W .Bank83_NpcSpriteLogicBranch_83C63D

        .Bank83_NpcSpriteLogicBranch_83C4BC:
            BRA .Bank83_NpcSpriteLogicBranch_83C51C

        .Bank83_NpcSpriteLogicBranch_83C4BE:
            %Set8bit(!M)
            LDY.W #$0002
            LDA.B [$72],Y
            CMP.B #$14
            BCS .Bank83_NpcSpriteLogicBranch_83C4DB
            LDA.B !tilemap_to_load
            CMP.B #$10
            BCS .Bank83_NpcSpriteLogicBranch_83C4D2
            JMP.W .Bank83_NpcSpriteLogicBranch_83C63D

        .Bank83_NpcSpriteLogicBranch_83C4D2:
            CMP.B #$14
            BCC .Bank83_NpcSpriteLogicBranch_83C4D9
            JMP.W .Bank83_NpcSpriteLogicBranch_83C63D

        .Bank83_NpcSpriteLogicBranch_83C4D9:
            BRA .Bank83_NpcSpriteLogicBranch_83C51C

        .Bank83_NpcSpriteLogicBranch_83C4DB:
            %Set8bit(!M)
            LDY.W #$0002
            LDA.B [$72],Y
            CMP.B #$18
            BCS .Bank83_NpcSpriteLogicBranch_83C4F8
            LDA.B !tilemap_to_load
            CMP.B #$15
            BCS .Bank83_NpcSpriteLogicBranch_83C4EF
            JMP.W .Bank83_NpcSpriteLogicBranch_83C63D

        .Bank83_NpcSpriteLogicBranch_83C4EF:
            CMP.B #$18
            BCC .Bank83_NpcSpriteLogicBranch_83C4F6
            JMP.W .Bank83_NpcSpriteLogicBranch_83C63D

        .Bank83_NpcSpriteLogicBranch_83C4F6:
            BRA .Bank83_NpcSpriteLogicBranch_83C51C

        .Bank83_NpcSpriteLogicBranch_83C4F8:
            %Set8bit(!M)
            LDY.W #$0002
            LDA.B [$72],Y
            CMP.B #$31
            BCC .Bank83_NpcSpriteLogicBranch_83C50E
            LDA.B !tilemap_to_load
            CMP.B #$31
            BCS .Bank83_NpcSpriteLogicBranch_83C50C
            JMP.W .Bank83_NpcSpriteLogicBranch_83C63D

        .Bank83_NpcSpriteLogicBranch_83C50C:
            BRA .Bank83_NpcSpriteLogicBranch_83C51C

        .Bank83_NpcSpriteLogicBranch_83C50E:
            %Set8bit(!M)
            LDY.W #$0002
            LDA.B [$72],Y
            CMP.B !tilemap_to_load
            BEQ .Bank83_NpcSpriteLogicBranch_83C51C
            JMP.W .Bank83_NpcSpriteLogicBranch_83C63D

        .Bank83_NpcSpriteLogicBranch_83C51C:
            %Set16bit(!M)
            LDY.W #$0008
            LDA.B [$72],Y
            STA.W !tile_in_front_X
            LDY.W #$000A
            LDA.B [$72],Y
            STA.W !tile_in_front_Y

        .Bank83_NpcSpriteLogicBranch_83C52E:
            %Set8bit(!M)
            LDY.W #$0000
            LDA.B [$72],Y
            AND.B #$02
            BEQ .Bank83_NpcSpriteLogicBranch_83C572
            %Set16bit(!M)
            LDA.W $0196
            AND.W #$0002
            BEQ .Bank83_NpcSpriteLogicBranch_83C553
            %Set8bit(!M)
            LDY.W #$0002
            LDA.B [$72],Y
            CMP.B #$27
            BEQ .Bank83_NpcSpriteLogicBranch_83C553
            LDY.W #$0017
            BRA .Bank83_NpcSpriteLogicBranch_83C558

        .Bank83_NpcSpriteLogicBranch_83C553:
            %Set16bit(!MX)
            LDY.W #$0003

        .Bank83_NpcSpriteLogicBranch_83C558:
            %Set16bit(!M)
            TXA
            CLC
            ADC.W #$0018
            LDX.W #$0000
            JSL.L EventScript_LoadScriptPointerForFacingTile
            %Set16bit(!MX)
            PLA
            PHA
            ASL A
            TAX
            STZ.W $0953,X
            JMP.W .Bank83_NpcSpriteLogicBranch_83C63D

        .Bank83_NpcSpriteLogicBranch_83C572:
            %Set8bit(!M)
            LDY.W #$0000
            LDA.B [$72],Y
            AND.B #$04
            BEQ .Bank83_NpcSpriteLogicBranch_83C5B6
            %Set16bit(!M)
            LDA.W $0196
            AND.W #$0002
            BEQ .Bank83_NpcSpriteLogicBranch_83C597
            %Set8bit(!M)
            LDY.W #$0002
            LDA.B [$72],Y
            CMP.B #$27
            BEQ .Bank83_NpcSpriteLogicBranch_83C597
            LDY.W #$002F
            BRA .Bank83_NpcSpriteLogicBranch_83C59C

        .Bank83_NpcSpriteLogicBranch_83C597:
            %Set16bit(!MX)
            LDY.W #$0004

        .Bank83_NpcSpriteLogicBranch_83C59C:
            %Set16bit(!M)
            TXA
            CLC
            ADC.W #$0018
            LDX.W #$0000
            JSL.L EventScript_LoadScriptPointerForFacingTile
            %Set16bit(!MX)
            PLA
            PHA
            ASL A
            TAX
            STZ.W $0953,X
            JMP.W .Bank83_NpcSpriteLogicBranch_83C63D

        .Bank83_NpcSpriteLogicBranch_83C5B6:
            %Set8bit(!M)
            LDY.W #$0000
            LDA.B [$72],Y
            AND.B #$08
            BEQ .Bank83_NpcSpriteLogicBranch_83C63D
            %Set8bit(!M)
            LDY.W #$0000
            LDA.B [$72],Y
            AND.B #$80
            BNE .Bank83_NpcSpriteLogicBranch_83C616
            %Set8bit(!M)
            LDY.W #$0000
            LDA.B [$72],Y
            AND.B #$40
            BEQ .Bank83_NpcSpriteLogicBranch_83C5DC
            LDY.W #$0008
            BRA .Bank83_NpcSpriteLogicBranch_83C624

        .Bank83_NpcSpriteLogicBranch_83C5DC:
            %Set8bit(!M)
            LDY.W #$0000
            LDA.B [$72],Y
            AND.B #$20
            BEQ .Bank83_NpcSpriteLogicBranch_83C5EC
            LDY.W #$0007
            BRA .Bank83_NpcSpriteLogicBranch_83C624

        .Bank83_NpcSpriteLogicBranch_83C5EC:
            %Set8bit(!M)
            LDY.W #$0000
            LDA.B [$72],Y
            AND.B #$10
            BEQ .Bank83_NpcSpriteLogicBranch_83C5FC
            LDY.W #$0006
            BRA .Bank83_NpcSpriteLogicBranch_83C624

        .Bank83_NpcSpriteLogicBranch_83C5FC:
            %Set16bit(!M)
            LDA.W $0196
            AND.W #$0002
            BEQ .Bank83_NpcSpriteLogicBranch_83C621
            %Set8bit(!M)
            LDY.W #$0002
            LDA.B [$72],Y
            CMP.B #$27
            BEQ .Bank83_NpcSpriteLogicBranch_83C621
            LDY.W #$0009
            BRA .Bank83_NpcSpriteLogicBranch_83C624

        .Bank83_NpcSpriteLogicBranch_83C616:
            %Set8bit(!M)
            LDY.W #$0000
            LDA.B [$72],Y
            AND.B #$7F
            STA.B [$72],Y

        .Bank83_NpcSpriteLogicBranch_83C621:
            LDY.W #$0005

        .Bank83_NpcSpriteLogicBranch_83C624:
            %Set16bit(!M)
            TXA
            CLC
            ADC.W #$0018
            LDX.W #$0000
            JSL.L EventScript_LoadScriptPointerForFacingTile
            %Set16bit(!MX)
            PLA
            PHA
            ASL A
            TAX
            STZ.W $0953,X
            BRA .Bank83_NpcSpriteLogicBranch_83C63D

        .Bank83_NpcSpriteLogicBranch_83C63D:
            %Set16bit(!MX)
            PLX
            INX
            CPX.W #$000C
            BEQ .Bank83_NpcSpriteLogicBranch_83C649
            JMP.W .Bank83_NpcSpriteLogicBranch_83C410

    .Bank83_NpcSpriteLogicBranch_83C649:
        %Set16bit(!MX)
        LDA.L $7F1F68
        AND.W #$0080
        BNE .Bank83_NpcSpriteLogicBranch_83C657
        JMP.W .Bank83_NpcSpriteLogicBranch_83C734

    .Bank83_NpcSpriteLogicBranch_83C657:
        LDA.B !game_state
        AND.W #$0800
        BEQ .Bank83_NpcSpriteLogicBranch_83C661
        JMP.W .Bank83_NpcSpriteLogicBranch_83C734

    .Bank83_NpcSpriteLogicBranch_83C661:
        %Set8bit(!M)
        LDA.L !dog_map
        CMP.B #$04
        BCS .Bank83_NpcSpriteLogicBranch_83C677
        LDA.B !tilemap_to_load
        CMP.B #$04
        BCC .Bank83_NpcSpriteLogicBranch_83C674
        JMP.W .Bank83_NpcSpriteLogicBranch_83C734

    .Bank83_NpcSpriteLogicBranch_83C674:
        JMP.W .Bank83_NpcSpriteLogicBranch_83C709

    .Bank83_NpcSpriteLogicBranch_83C677:
        %Set8bit(!M)
        LDA.L !dog_map
        CMP.B #$08
        BCS .Bank83_NpcSpriteLogicBranch_83C693
        LDA.B !tilemap_to_load
        CMP.B #$04
        BCS .Bank83_NpcSpriteLogicBranch_83C68A
        JMP.W .Bank83_NpcSpriteLogicBranch_83C734

    .Bank83_NpcSpriteLogicBranch_83C68A:
        CMP.B #$08
        BCC .Bank83_NpcSpriteLogicBranch_83C691
        JMP.W .Bank83_NpcSpriteLogicBranch_83C734

    .Bank83_NpcSpriteLogicBranch_83C691:
        BRA .Bank83_NpcSpriteLogicBranch_83C709

    .Bank83_NpcSpriteLogicBranch_83C693:
        %Set8bit(!M)
        LDA.L !dog_map
        CMP.B #$10
        BCS .Bank83_NpcSpriteLogicBranch_83C6AF
        LDA.B !tilemap_to_load
        CMP.B #$0C
        BCS .Bank83_NpcSpriteLogicBranch_83C6A6
        JMP.W .Bank83_NpcSpriteLogicBranch_83C734

    .Bank83_NpcSpriteLogicBranch_83C6A6:
        CMP.B #$10
        BCC .Bank83_NpcSpriteLogicBranch_83C6AD
        JMP.W .Bank83_NpcSpriteLogicBranch_83C734

    .Bank83_NpcSpriteLogicBranch_83C6AD:
        BRA .Bank83_NpcSpriteLogicBranch_83C709

    .Bank83_NpcSpriteLogicBranch_83C6AF:
        %Set8bit(!M)
        LDA.L !dog_map
        CMP.B #$14
        BCS .Bank83_NpcSpriteLogicBranch_83C6CB
        LDA.B !tilemap_to_load
        CMP.B #$10
        BCS .Bank83_NpcSpriteLogicBranch_83C6C2
        JMP.W .Bank83_NpcSpriteLogicBranch_83C734

    .Bank83_NpcSpriteLogicBranch_83C6C2:
        CMP.B #$14
        BCC .Bank83_NpcSpriteLogicBranch_83C6C9
        JMP.W .Bank83_NpcSpriteLogicBranch_83C734

    .Bank83_NpcSpriteLogicBranch_83C6C9:
        BRA .Bank83_NpcSpriteLogicBranch_83C709

    .Bank83_NpcSpriteLogicBranch_83C6CB:
        %Set8bit(!M)
        LDA.L !dog_map
        CMP.B #$18
        BCS .Bank83_NpcSpriteLogicBranch_83C6E7
        LDA.B !tilemap_to_load
        CMP.B #$15
        BCS .Bank83_NpcSpriteLogicBranch_83C6DE
        JMP.W .Bank83_NpcSpriteLogicBranch_83C734

    .Bank83_NpcSpriteLogicBranch_83C6DE:
        CMP.B #$18
        BCC .Bank83_NpcSpriteLogicBranch_83C6E5
        JMP.W .Bank83_NpcSpriteLogicBranch_83C734

    .Bank83_NpcSpriteLogicBranch_83C6E5:
        BRA .Bank83_NpcSpriteLogicBranch_83C709

    .Bank83_NpcSpriteLogicBranch_83C6E7:
        %Set8bit(!M)
        LDA.L !dog_map
        CMP.B #$31
        BCC .Bank83_NpcSpriteLogicBranch_83C6FC
        LDA.B !tilemap_to_load
        CMP.B #$31
        BCS .Bank83_NpcSpriteLogicBranch_83C6FA
        JMP.W .Bank83_NpcSpriteLogicBranch_83C734

    .Bank83_NpcSpriteLogicBranch_83C6FA:
        BRA .Bank83_NpcSpriteLogicBranch_83C709

    .Bank83_NpcSpriteLogicBranch_83C6FC:
        %Set8bit(!M)
        LDA.L !dog_map
        CMP.B !tilemap_to_load
        BEQ .Bank83_NpcSpriteLogicBranch_83C709
        JMP.W .Bank83_NpcSpriteLogicBranch_83C734

    .Bank83_NpcSpriteLogicBranch_83C709:
        %Set16bit(!MX)
        LDA.L !dog_pos_X
        STA.W !tile_in_front_X
        LDA.L !dog_pos_Y
        STA.W !tile_in_front_Y
        LDA.W #$0016
        LDX.W #$0000
        LDY.W #$0011
        JSL.L EventScript_LoadScriptPointerForFacingTile
        %Set16bit(!M)
        LDA.W #$0001
        STA.L $7F1F58
        %Set8bit(!M)
        STZ.W $0938

    .Bank83_NpcSpriteLogicBranch_83C734:
        %Set16bit(!MX)
        LDA.L $7F1F68
        AND.W #$0100
        BNE .Bank83_NpcSpriteLogicBranch_83C742
        JMP.W .Bank83_NpcSpriteLogicBranch_83C806

    .Bank83_NpcSpriteLogicBranch_83C742:
        LDA.B !game_state
        AND.W #$0010
        BEQ .Bank83_NpcSpriteLogicBranch_83C74C
        JMP.W .Bank83_NpcSpriteLogicBranch_83C806

    .Bank83_NpcSpriteLogicBranch_83C74C:
        %Set8bit(!M)
        LDA.L $7F1F31
        CMP.B #$04
        BCS .Bank83_NpcSpriteLogicBranch_83C761
        LDA.B !tilemap_to_load
        CMP.B #$04
        BCC .Bank83_NpcSpriteLogicBranch_83C75F
        JMP.W .Bank83_NpcSpriteLogicBranch_83C806

    .Bank83_NpcSpriteLogicBranch_83C75F:
        BRA .Bank83_NpcSpriteLogicBranch_83C7D7

    .Bank83_NpcSpriteLogicBranch_83C761:
        %Set8bit(!M)
        LDA.L $7F1F31
        CMP.B #$08
        BCS .Bank83_NpcSpriteLogicBranch_83C77D
        LDA.B !tilemap_to_load
        CMP.B #$04
        BCS .Bank83_NpcSpriteLogicBranch_83C774
        JMP.W .Bank83_NpcSpriteLogicBranch_83C806

    .Bank83_NpcSpriteLogicBranch_83C774:
        CMP.B #$08
        BCC .Bank83_NpcSpriteLogicBranch_83C77B
        JMP.W .Bank83_NpcSpriteLogicBranch_83C806

    .Bank83_NpcSpriteLogicBranch_83C77B:
        BRA .Bank83_NpcSpriteLogicBranch_83C7D7

    .Bank83_NpcSpriteLogicBranch_83C77D:
        %Set8bit(!M)
        LDA.L $7F1F31
        CMP.B #$10
        BCS .Bank83_NpcSpriteLogicBranch_83C799
        LDA.B !tilemap_to_load
        CMP.B #$0C
        BCS .Bank83_NpcSpriteLogicBranch_83C790
        JMP.W .Bank83_NpcSpriteLogicBranch_83C806

    .Bank83_NpcSpriteLogicBranch_83C790:
        CMP.B #$10
        BCC .Bank83_NpcSpriteLogicBranch_83C797
        JMP.W .Bank83_NpcSpriteLogicBranch_83C806

    .Bank83_NpcSpriteLogicBranch_83C797:
        BRA .Bank83_NpcSpriteLogicBranch_83C7D7

    .Bank83_NpcSpriteLogicBranch_83C799:
        %Set8bit(!M)
        LDA.L $7F1F31
        CMP.B #$14
        BCS .Bank83_NpcSpriteLogicBranch_83C7B5
        LDA.B !tilemap_to_load
        CMP.B #$10
        BCS .Bank83_NpcSpriteLogicBranch_83C7AC
        JMP.W .Bank83_NpcSpriteLogicBranch_83C806

    .Bank83_NpcSpriteLogicBranch_83C7AC:
        CMP.B #$14
        BCC .Bank83_NpcSpriteLogicBranch_83C7B3
        JMP.W .Bank83_NpcSpriteLogicBranch_83C806

    .Bank83_NpcSpriteLogicBranch_83C7B3:
        BRA .Bank83_NpcSpriteLogicBranch_83C7D7

    .Bank83_NpcSpriteLogicBranch_83C7B5:
        %Set8bit(!M)
        LDA.L $7F1F31
        CMP.B #$31
        BCC .Bank83_NpcSpriteLogicBranch_83C7CA
        LDA.B !tilemap_to_load
        CMP.B #$31
        BCS .Bank83_NpcSpriteLogicBranch_83C7C8
        JMP.W .Bank83_NpcSpriteLogicBranch_83C806

    .Bank83_NpcSpriteLogicBranch_83C7C8:
        BRA .Bank83_NpcSpriteLogicBranch_83C7D7

    .Bank83_NpcSpriteLogicBranch_83C7CA:
        %Set8bit(!M)
        LDA.L $7F1F31
        CMP.B !tilemap_to_load
        BEQ .Bank83_NpcSpriteLogicBranch_83C7D7
        JMP.W .Bank83_NpcSpriteLogicBranch_83C806

    .Bank83_NpcSpriteLogicBranch_83C7D7:
        %Set16bit(!MX)
        LDA.W #$0110
        STA.W !tile_in_front_X
        LDA.W #$0140
        STA.W !tile_in_front_Y
        LDY.W #$0013
        %Set8bit(!M)
        LDA.L $7F1F32
        CMP.B #$15
        BNE .Bank83_NpcSpriteLogicBranch_83C7F5
        LDY.W #$0010

    .Bank83_NpcSpriteLogicBranch_83C7F5:
        %Set16bit(!MX)
        LDA.W #$0017
        LDX.W #$0000
        JSL.L EventScript_LoadScriptPointerForFacingTile
        %Set8bit(!M)
        STZ.W $0939

    .Bank83_NpcSpriteLogicBranch_83C806:
        RTL


;;;;;;;; Param in A = 0: hatched; Return in A, 0 = sucess, 1 = coop full
;;; PASS18: Allocates a free chicken slot and initializes a new chicken/chick/egg state.
AddNewChicken: ;83C807
        !chicken_pointer = $72
        !chicken_source = $7E

        %Set16bit(!MX)
        STA.B !chicken_source
        LDX.W #$0000

    .findSlot
      - %Set16bit(!MX)
        PHX
        TXA
        JSL.L GetChickenPointer
        %Set8bit(!M)
        %Set16bit(!X)
        PLX
        LDY.W #$0000
        LDA.B [!chicken_pointer],Y
        AND.B #$01                           ;exists flag
        BEQ .slotFound
        %Set16bit(!MX)
        INX
        CPX.W #13
        BNE .findSlot

    .slotFound:
        %Set8bit(!M)
        %Set16bit(!X)
        CPX.W #13
        BNE .slotValid
        JMP.W .fail

    .slotValid
        LDY.W #$0000

    .clearSlot
        %Set8bit(!M)
        LDA.B #$00
        STA.B [!chicken_pointer],Y
        INY
        CPY.W #$0008
        BNE .clearSlot

        %Set8bit(!M)
        LDY.W #$0001
        LDA.B #$28
        STA.B [!chicken_pointer],Y
        LDY.W #$0002
        LDA.B #$00
        STA.B [!chicken_pointer],Y
        %Set16bit(!M)
        LDA.B !chicken_source
        CMP.W #$0001
        BEQ .bought
        CMP.W #$0002
        BEQ .hatched
        %Set8bit(!M)
        LDY.W #$0000
        LDA.B #$43
        STA.B [!chicken_pointer],Y
        %Set16bit(!MX)
        LDY.W #$0004
        LDA.W #$00E8
        STA.B [!chicken_pointer],Y           ;Spawn Position X
        LDY.W #$0006
        LDA.W #$00B8
        STA.B [!chicken_pointer],Y           ;Spawn Position Y
        BRA .newChickenSuccess

    .bought:
        %Set8bit(!M)
        LDY.W #$0000
        LDA.B #$09
        STA.B [!chicken_pointer],Y
        BRA .bought_cont

    .hatched:
        %Set8bit(!M)
        LDY.W #$0000
        LDA.B #$09
        STA.B [!chicken_pointer],Y
        LDY.W #$0001
        LDA.L !season
        CLC
        ADC.B #$04
        STA.B [!chicken_pointer],Y
        %Set16bit(!M)
        LDY.W #$0004
        LDA.W #$0238
        STA.B [!chicken_pointer],Y           ;Spawn Position X
        LDY.W #$0006
        LDA.W #$0318
        STA.B [!chicken_pointer],Y           ;Spawn Position Y
        BRA .newChickenSuccess

    .bought_cont:
        %Set16bit(!MX)
        TXA
        ASL A
        ASL A
        TAX
        LDY.W #$0004
        LDA.L Chicken_CoopSpawnPositionTable,X
        STA.B [!chicken_pointer],Y
        INX
        INX
        LDY.W #$0006
        LDA.L Chicken_CoopSpawnPositionTable,X
        STA.B [!chicken_pointer],Y

    .newChickenSuccess:
        %Set16bit(!M)
        LDA.W #$0000
        RTL

    .fail:
        %Set16bit(!MX)
        LDA.W #$0001
        RTL

;;;;;;;;
;;;;;;;;
;;;;;;;; Param in A, 0:Bought, 1:Born; Return in A, 0:sucess, 1:barn full
;;; PASS18: Allocates a free cow slot and initializes bought/born cow state.
AddNewCow: ;83C8DC
        !cow_pointer = $72
        !cow_source = $7E

        %Set16bit(!MX)
        STA.B !cow_source
        LDX.W #$0000

;check for an empty slot
      - %Set16bit(!MX)
        PHX
        TXA
        JSL.L GetCowPointer
        %Set8bit(!M)
        %Set16bit(!X)
        PLX
        LDY.W #$0000
        LDA.B [!cow_pointer],Y
        AND.B #$01                           ;exists flag
        BEQ .slotFound
        %Set16bit(!MX)
        INX
        CPX.W #12
        BNE -

    .slotFound:
        %Set8bit(!M)
        %Set16bit(!X)
        CPX.W #12
        BNE .slotValid
        JMP.W .fail

    .slotValid:
        LDY.W #$0000

    .clearSlot
        LDA.B #$00
        STA.B [!cow_pointer],Y
        INY
        CPY.W #$0010
        BNE .clearSlot

        %Set8bit(!M)
        LDY.W #$0002
        LDA.B #$27
        STA.B [!cow_pointer],Y
        LDY.W #$0003
        LDA.B #$00
        STA.B [!cow_pointer],Y               ;Pregnancy
        LDY.W #$0004
        LDA.B #$00
        STA.B [!cow_pointer],Y               ;Happiness
        LDY.W #$0005
        LDA.B #$00
        STA.B [!cow_pointer],Y
        %Set8bit(!M)
        LDY.W #$0001
        LDA.B #$00
        STA.B [!cow_pointer],Y
        %Set8bit(!M)
        LDY.W #$0000
        LDA.B #$05                           ;Child Cow, exists
        STA.B [!cow_pointer],Y               ;Cow Status
        %Set16bit(!M)

        LDA.B !cow_source
        BEQ .bought

        %Set8bit(!M)
        LDY.W #$0000
        LDA.B #$03                           ;Baby Cow
        STA.B [!cow_pointer],Y               ;Cow Status
        %Set8bit(!M)
        LDY.W #$0004
        LDA.L $7F1F2B                        ;
        STA.B [!cow_pointer],Y               ;Happiness
        %Set16bit(!MX)
        LDA.W #70
        JSL.L Social_AddPlayerHappiness
        %Set16bit(!MX)

    .bought:
        %Set16bit(!MX)
        TXA
        ASL A
        ASL A
        TAX
        LDY.W #$0008
        LDA.L Cow_BarnSpawnPositionTable,X
        STA.B [!cow_pointer],Y               ;Barn Position X
        INX
        INX
        LDY.W #$000A
        LDA.L Cow_BarnSpawnPositionTable,X
        STA.B [!cow_pointer],Y               ;Barn Position Y

        %Set16bit(!M)
        LDA.W #$0000
        RTL                                  ;Success

        .fail:
        %Set16bit(!MX)
        LDA.W #$0001
        RTL

;;;;;;;; Simple function, returns a pointer to the ram address that holds the data for
;;;;;;;; a chicken slot in A. Each chiken slot is size 8 bits
;;;;;;;; Params: A = Inxed, Return: $72 = long pointer
;;; PASS18: X = chicken index, returns pointer to that 8-byte chicken slot in $72.
GetChickenPointer: ;83C995
        %Set16bit(!MX)
        ASL A
        ASL A
        ASL A
        CLC
        ADC.W #$C286                         ;pointer to chicken data
        STA.B $72
        %Set8bit(!M)
        LDA.B #$7E
        STA.B $74
        RTL

;;;;;;;; Simple function, returns a pointer to the ram address that holds the data for
;;;;;;;; a cow slot in A. Each cow slots is size 16 bits
;;;;;;;; Params: A = Inxed, Return: $72 = long pointer
;;; PASS18: X = cow index, returns pointer to that 16-byte cow slot in $72.
GetCowPointer: ;83C9A7
        %Set16bit(!MX)
        ASL A
        ASL A
        ASL A
        ASL A
        CLC
        ADC.W #$C1C6                         ;pointer to cow data
        STA.B $72
        %Set8bit(!M)
        LDA.B #$7E
        STA.B $74
        RTL


;;;;;;;; this bunch of code seems to be unused, they just look to see
;;;;;;;; if the barn or coop are filled, code very... "beta"
UnusedBarnCoopCheck: ;83C9BA
        LDX.W #$0000                         ;83C9BA;      ;
        LDY.W #$0000                         ;83C9BD;      ;

    .coopcheck: ;83C9C0
        %Set16bit(!MX)
        PHY
        PHX
        TXA
        JSL.L GetChickenPointer
        %Set8bit(!M)
        %Set16bit(!X)
        PLX
        LDY.W #$0000
        LDA.B [$72],Y
        PLY
        AND.B #$01
        BEQ .skip1
        INY

    .skip1:
        %Set16bit(!MX)
        INX
        CPX.W #$000D
        BNE .coopcheck
        %Set16bit(!M)
        TYA
        RTL

        LDX.W #$0000
        LDY.W #$0000

    .barncheck:
        %Set16bit(!MX)
        PHY
        PHX
        TXA
        JSL.L GetCowPointer
        %Set8bit(!M)
        %Set16bit(!X)
        PLX
        LDY.W #$0000
        LDA.B [$72],Y
        PLY
        AND.B #$01
        BEQ .skip2
        INY

    .skip2:
        %Set16bit(!MX)
        INX
        CPX.W #$000C
        BNE .barncheck
        %Set16bit(!M)
        TYA
        RTL


;;; PASS18: Coop spawn position pairs used when creating visible chicken objects.
Chicken_CoopSpawnPositionTable: dw $0018,$0048,$0038,$0058,$0048,$0098,$0058,$0078;83CA10;      ;
                       dw $0068,$00A8,$0078,$0088,$0088,$0058,$0098,$0098;83CA20;      ;
                       dw $00A8,$0078,$00B8,$00A8,$00C8,$0068,$00D8,$0088;83CA30;      ;
                       dw $0028,$00A8                       ;83CA40;      ;

;;; PASS18: Barn spawn position pairs used when creating visible cow objects.
   Cow_BarnSpawnPositionTable: dw $00A8,$0116,$00A8,$00F6,$00A8,$00D6,$00A8,$0096;83CA44;      ;
                       dw $00A8,$0076,$00A8,$0056,$0038,$0116,$0038,$00F6;83CA54;      ;
                       dw $0038,$00D6,$0038,$0096,$0038,$0076,$0038,$0056;83CA64;      ;
                       db $D8,$00,$58,$01                   ;83CA74;      ;
;;; PASS18: Per-chicken bitmask written to daily egg flags when an adult hen lays an egg.
         Chicken_EggLaidBitmaskTable: db $01,$00,$02,$00,$04,$00,$08,$00,$10,$00,$20,$00,$40,$00,$80,$00;83CA78;      ;
                       db $00,$01,$00,$02,$00,$04,$00,$08,$00,$10,$00,$20,$00,$40,$00,$80;83CA88;      ;
                                                            ;      ;      ;
  ;;;;;;;; PASS30_NPC_SOCIAL_CORE: dispatches area-specific NPC/social/event checks using !tilemap_to_load.
NPCMapEvent_DispatchByCurrentArea: %Set8bit(!M)                             ;83CA98;      ;Param $22
                       %Set16bit(!X)                             ;83CA9A;      ;
                       LDA.B #$00                           ;83CA9C;      ;
                       XBA                                  ;83CA9E;      ;
                       LDA.B !tilemap_to_load                            ;83CA9F;000022;
                       %Set16bit(!M)                             ;83CAA1;      ;
                       ASL A                                ;83CAA3;      ;
                       TAX                                  ;83CAA4;      ;
                       JSR.W (NPCMapEvent_AreaDispatchTable,X)    ;83CAA5;83CAA9;
                       RTL                                  ;83CAA8;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
;;; PASS30: per-area dispatch table for NPC/social/event checks run after map/event updates.
NPCMapEvent_AreaDispatchTable: dw $CB69,$CB69,$CB69,$CB69,$D2E0,$D2E0,$D2E0,$D2E0;83CAA9;      ;
                       dw $E5DF,$E5F1,$E603,$E6B2,$E407,$E407,$E407,$E407;83CAB9;      ;
                       dw $DC4A,$DC4A,$DC4A,$DC4A,$E661,$DED3,$DED3,$DED3;83CAC9;      ;
                       dw $D4D7,$D4D7,$D5E7,$D613,$D74E,$D818,$DB8F,$DC1E;83CAD9;      ;
                       dw $D955,$DA1F,$D844,$D929,$DAED,$DA4B,$E6C4,$DE9B;83CAE9;      ;
                       dw $E5B4,$E4CB,$DE64,$DD95,$E5A2,$E5CD,$E5CD,$E5CD;83CAF9;      ;
                       dw $E5CD,$E586,$E586,$E586,$E586,$E586,$E586,$E586;83CB09;      ;
                       dw $E586,$E632,$E690,$E74C,$E76D,$EBA6,$E74C,$E74C;83CB19;      ;
                       dw $E74C,$E74C,$E74C,$E74C,$E74C,$E74C,$E74C,$E74C;83CB29;      ;
                       dw $E74C,$E74C,$E74C,$EBA6,$E74C,$E74C,$E74C,$E74C;83CB39;      ;
                       dw $E74C,$E74C,$E74C,$E74C,$E74C,$E74C,$E74C,$E74C;83CB49;      ;
                       dw $E74C,$E74C,$E74C,$E74C,$E74C,$E74C,$E74C,$E74C;83CB59;      ;
                                                            ;      ;      ;
      ;;;;;;;; PASS30_NPC_SOCIAL_CORE: checks family/romance/social event triggers for the current area.
NPCMapEvent_FarmHomeFamilyAndRomanceCheck: %Set16bit(!MX)                             ;83CB69;      ;
                       LDA.L !child_flags                        ;83CB6B;7F1F6E;
                       AND.W #$0002                         ;83CB6F;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CBC4                      ;83CB72;83CBC4;
                       LDA.L !marriage_flags                        ;83CB74;7F1F66;
                       AND.W #$0001                         ;83CB78;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CB91                      ;83CB7B;83CB91;
                       LDA.L !marriage_flags                        ;83CB7D;7F1F66;
                       AND.W #$0004                         ;83CB81;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CBA2                      ;83CB84;83CBA2;
                       LDA.L !marriage_flags                        ;83CB86;7F1F66;
                       AND.W #$0008                         ;83CB8A;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CBB3                      ;83CB8D;83CBB3;
                       BRA Bank83_NpcSpriteLogicBranch_83CBC4                      ;83CB8F;83CBC4;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CB91: %Set16bit(!MX)                             ;83CB91;      ;
                       LDA.W #$0013                         ;83CB93;      ;
                       LDX.W #$0044                         ;83CB96;      ;
                       LDY.W #$0000                         ;83CB99;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83CB9C;848097;
                       BRA Bank83_NpcSpriteLogicBranch_83CBC4                      ;83CBA0;83CBC4;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CBA2: %Set16bit(!MX)                             ;83CBA2;      ;
                       LDA.W #$0013                         ;83CBA4;      ;
                       LDX.W #$0044                         ;83CBA7;      ;
                       LDY.W #$0002                         ;83CBAA;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83CBAD;848097;
                       BRA Bank83_NpcSpriteLogicBranch_83CBC4                      ;83CBB1;83CBC4;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CBB3: %Set16bit(!MX)                             ;83CBB3;      ;
                       LDA.W #$0013                         ;83CBB5;      ;
                       LDX.W #$0044                         ;83CBB8;      ;
                       LDY.W #$0003                         ;83CBBB;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83CBBE;848097;
                       BRA Bank83_NpcSpriteLogicBranch_83CBC4                      ;83CBC2;83CBC4;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CBC4: %Set16bit(!MX)                             ;83CBC4;      ;
                       LDA.L !child_flags                        ;83CBC6;7F1F6E;
                       AND.W #$0004                         ;83CBCA;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83CBE7                      ;83CBCD;83CBE7;
                       LDA.L !kid1_age                        ;83CBCF;7F1F37;
                       CMP.W #$003C                         ;83CBD3;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83CBE7                      ;83CBD6;83CBE7;
                       %Set16bit(!MX)                             ;83CBD8;      ;
                       LDA.W #$0014                         ;83CBDA;      ;
                       LDX.W #$0045                         ;83CBDD;      ;
                       LDY.W #$0001                         ;83CBE0;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83CBE3;848097;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CBE7: %Set16bit(!MX)                             ;83CBE7;      ;
                       LDA.L !child_flags                        ;83CBE9;7F1F6E;
                       AND.W #$0008                         ;83CBED;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83CC0A                      ;83CBF0;83CC0A;
                       LDA.L !kid2_age                        ;83CBF2;7F1F39;
                       CMP.W #$003C                         ;83CBF6;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83CC0A                      ;83CBF9;83CC0A;
                       %Set16bit(!MX)                             ;83CBFB;      ;
                       LDA.W #$0015                         ;83CBFD;      ;
                       LDX.W #$0045                         ;83CC00;      ;
                       LDY.W #$0004                         ;83CC03;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83CC06;848097;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CC0A: %Set16bit(!MX)                             ;83CC0A;      ;
                       LDA.W $0196                          ;83CC0C;000196;
                       AND.W #$001A                         ;83CC0F;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83CC17                      ;83CC12;83CC17;
                       JMP.W Bank83_NpcSpriteLogicBranch_83CE5B                    ;83CC14;83CE5B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CC17: LDA.L !marriage_flags                        ;83CC17;7F1F66;
                       AND.W #$0001                         ;83CC1B;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83CC23                      ;83CC1E;83CC23;
                       JMP.W Bank83_NpcSpriteLogicBranch_83CE5B                    ;83CC20;83CE5B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CC23: LDA.L !marriage_flags                        ;83CC23;7F1F66;
                       AND.W #$0002                         ;83CC27;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83CC2F                      ;83CC2A;83CC2F;
                       JMP.W Bank83_NpcSpriteLogicBranch_83CE5B                    ;83CC2C;83CE5B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CC2F: LDA.L !marriage_flags                        ;83CC2F;7F1F66;
                       AND.W #$0004                         ;83CC33;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83CC3B                      ;83CC36;83CC3B;
                       JMP.W Bank83_NpcSpriteLogicBranch_83CE5B                    ;83CC38;83CE5B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CC3B: LDA.L !marriage_flags                        ;83CC3B;7F1F66;
                       AND.W #$0008                         ;83CC3F;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83CC47                      ;83CC42;83CC47;
                       JMP.W Bank83_NpcSpriteLogicBranch_83CE5B                    ;83CC44;83CE5B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CC47: LDA.L !marriage_flags                        ;83CC47;7F1F66;
                       AND.W #$0010                         ;83CC4B;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83CC53                      ;83CC4E;83CC53;
                       JMP.W Bank83_NpcSpriteLogicBranch_83CE5B                    ;83CC50;83CE5B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CC53: %Set8bit(!M)                             ;83CC53;      ;
                       LDA.L !hour                        ;83CC55;7F1F1C;Hour
                       CMP.B #$06                           ;83CC59;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83CC60                      ;83CC5B;83CC60;
                       JMP.W Bank83_NpcSpriteLogicBranch_83CE5B                    ;83CC5D;83CE5B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CC60: LDA.L !minutes                        ;83CC60;7F1F1D;Minutes
                       BEQ Bank83_NpcSpriteLogicBranch_83CC69                      ;83CC64;83CC69;
                       JMP.W Bank83_NpcSpriteLogicBranch_83CE5B                    ;83CC66;83CE5B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CC69: LDA.L !seconds                        ;83CC69;7F1F1E;
                       BEQ Bank83_NpcSpriteLogicBranch_83CC72                      ;83CC6D;83CC72;
                       JMP.W Bank83_NpcSpriteLogicBranch_83CE5B                    ;83CC6F;83CE5B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CC72: LDA.L !day                        ;83CC72;7F1F1B;Day Number
                       CMP.B #$01                           ;83CC76;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CC7D                      ;83CC78;83CC7D;
                       JMP.W Bank83_NpcSpriteLogicBranch_83CE5B                    ;83CC7A;83CE5B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CC7D: CMP.B #$08                           ;83CC7D;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83CC9A                      ;83CC7F;83CC9A;
                       CMP.B #$0D                           ;83CC81;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83CC88                      ;83CC83;83CC88;
                       JMP.W Bank83_NpcSpriteLogicBranch_83CE5B                    ;83CC85;83CE5B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CC88: CMP.B #$12                           ;83CC88;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83CC9A                      ;83CC8A;83CC9A;
                       CMP.B #$19                           ;83CC8C;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83CC93                      ;83CC8E;83CC93;
                       JMP.W Bank83_NpcSpriteLogicBranch_83CE5B                    ;83CC90;83CE5B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CC93: CMP.B #$1D                           ;83CC93;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83CC9A                      ;83CC95;83CC9A;
                       JMP.W Bank83_NpcSpriteLogicBranch_83CE5B                    ;83CC97;83CE5B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CC9A: %Set16bit(!M)                             ;83CC9A;      ;
                       LDA.L !marriage_flags                        ;83CC9C;7F1F66;
                       AND.W #$0001                         ;83CCA0;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CCE9                      ;83CCA3;83CCE9;
                       LDA.L !marriage_flags                        ;83CCA5;7F1F66;
                       AND.W #$0080                         ;83CCA9;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CCE9                      ;83CCAC;83CCE9;
                       LDA.L $7F1F6A                        ;83CCAE;7F1F6A;
                       AND.W #$2000                         ;83CCB2;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CCE9                      ;83CCB5;83CCE9;
                       LDA.L $7F1F6A                        ;83CCB7;7F1F6A;
                       AND.W #$1000                         ;83CCBB;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CCE9                      ;83CCBE;83CCE9;
                       LDA.L !hearts_maria                        ;83CCC0;7F1F1F;Hearts for Maria
                       CMP.W #$00C8                         ;83CCC4;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83CCE9                      ;83CCC7;83CCE9;
                       LDA.L $7F1F6A                        ;83CCC9;7F1F6A;
                       ORA.W #$1000                         ;83CCCD;      ;
                       STA.L $7F1F6A                        ;83CCD0;7F1F6A;
                       %Set16bit(!MX)                             ;83CCD4;      ;
                       LDA.W #$0000                         ;83CCD6;      ;
                       LDX.W #$0019                         ;83CCD9;      ;
                       LDY.W #$0000                         ;83CCDC;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83CCDF;848097;
                       %Set8bit(!M)                             ;83CCE3;      ;
                       STZ.W $09A3                          ;83CCE5;0009A3;
                       RTS                                  ;83CCE8;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CCE9: %Set16bit(!M)                             ;83CCE9;      ;
                       LDA.L $7F1F6A                        ;83CCEB;7F1F6A;
                       AND.W #$1000                         ;83CCEF;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CD38                      ;83CCF2;83CD38;
                       LDA.L !marriage_flags                        ;83CCF4;7F1F66;
                       AND.W #$0002                         ;83CCF8;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CD38                      ;83CCFB;83CD38;
                       LDA.L $7F1F6A                        ;83CCFD;7F1F6A;
                       AND.W #$8000                         ;83CD01;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CD38                      ;83CD04;83CD38;
                       LDA.L $7F1F6A                        ;83CD06;7F1F6A;
                       AND.W #$4000                         ;83CD0A;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CD38                      ;83CD0D;83CD38;
                       LDA.L !hearts_ann                        ;83CD0F;7F1F21;Hearts for Ann
                       CMP.W #$00C8                         ;83CD13;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83CD38                      ;83CD16;83CD38;
                       LDA.L $7F1F6A                        ;83CD18;7F1F6A;
                       ORA.W #$4000                         ;83CD1C;      ;
                       STA.L $7F1F6A                        ;83CD1F;7F1F6A;
                       %Set16bit(!MX)                             ;83CD23;      ;
                       LDA.W #$0000                         ;83CD25;      ;
                       LDX.W #$001A                         ;83CD28;      ;
                       LDY.W #$0000                         ;83CD2B;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83CD2E;848097;
                       %Set8bit(!M)                             ;83CD32;      ;
                       STZ.W $09A3                          ;83CD34;0009A3;
                       RTS                                  ;83CD37;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CD38: %Set16bit(!M)                             ;83CD38;      ;
                       LDA.L $7F1F6A                        ;83CD3A;7F1F6A;
                       AND.W #$1000                         ;83CD3E;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CD90                      ;83CD41;83CD90;
                       LDA.L $7F1F6A                        ;83CD43;7F1F6A;
                       AND.W #$4000                         ;83CD47;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CD90                      ;83CD4A;83CD90;
                       LDA.L !marriage_flags                        ;83CD4C;7F1F66;
                       AND.W #$0004                         ;83CD50;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CD90                      ;83CD53;83CD90;
                       LDA.L !family_event_flags                        ;83CD55;7F1F6C;
                       AND.W #$0002                         ;83CD59;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CD90                      ;83CD5C;83CD90;
                       LDA.L !family_event_flags                        ;83CD5E;7F1F6C;
                       AND.W #$0001                         ;83CD62;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CD90                      ;83CD65;83CD90;
                       LDA.L !hearts_nina                        ;83CD67;7F1F23;Hearts for Nina
                       CMP.W #$00C8                         ;83CD6B;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83CD90                      ;83CD6E;83CD90;
                       LDA.L !family_event_flags                        ;83CD70;7F1F6C;
                       ORA.W #$0001                         ;83CD74;      ;
                       STA.L !family_event_flags                        ;83CD77;7F1F6C;
                       %Set16bit(!MX)                             ;83CD7B;      ;
                       LDA.W #$0000                         ;83CD7D;      ;
                       LDX.W #$001B                         ;83CD80;      ;
                       LDY.W #$0000                         ;83CD83;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83CD86;848097;
                       %Set8bit(!M)                             ;83CD8A;      ;
                       STZ.W $09A3                          ;83CD8C;0009A3;
                       RTS                                  ;83CD8F;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CD90: %Set16bit(!M)                             ;83CD90;      ;
                       LDA.L $7F1F6A                        ;83CD92;7F1F6A;
                       AND.W #$1000                         ;83CD96;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CDF1                      ;83CD99;83CDF1;
                       LDA.L $7F1F6A                        ;83CD9B;7F1F6A;
                       AND.W #$4000                         ;83CD9F;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CDF1                      ;83CDA2;83CDF1;
                       LDA.L !family_event_flags                        ;83CDA4;7F1F6C;
                       AND.W #$0001                         ;83CDA8;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CDF1                      ;83CDAB;83CDF1;
                       LDA.L !marriage_flags                        ;83CDAD;7F1F66;
                       AND.W #$0008                         ;83CDB1;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CDF1                      ;83CDB4;83CDF1;
                       LDA.L !family_event_flags                        ;83CDB6;7F1F6C;
                       AND.W #$0008                         ;83CDBA;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CDF1                      ;83CDBD;83CDF1;
                       LDA.L !family_event_flags                        ;83CDBF;7F1F6C;
                       AND.W #$0004                         ;83CDC3;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CDF1                      ;83CDC6;83CDF1;
                       LDA.L !hearts_ellen                        ;83CDC8;7F1F25;Hearts for Ellen
                       CMP.W #$00C8                         ;83CDCC;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83CDF1                      ;83CDCF;83CDF1;
                       LDA.L !family_event_flags                        ;83CDD1;7F1F6C;
                       ORA.W #$0004                         ;83CDD5;      ;
                       STA.L !family_event_flags                        ;83CDD8;7F1F6C;
                       %Set16bit(!MX)                             ;83CDDC;      ;
                       LDA.W #$0000                         ;83CDDE;      ;
                       LDX.W #$001C                         ;83CDE1;      ;
                       LDY.W #$0000                         ;83CDE4;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83CDE7;848097;
                       %Set8bit(!M)                             ;83CDEB;      ;
                       STZ.W $09A3                          ;83CDED;0009A3;
                       RTS                                  ;83CDF0;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CDF1: %Set16bit(!M)                             ;83CDF1;      ;
                       LDA.L $7F1F6A                        ;83CDF3;7F1F6A;
                       AND.W #$1000                         ;83CDF7;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CE5B                      ;83CDFA;83CE5B;
                       LDA.L $7F1F6A                        ;83CDFC;7F1F6A;
                       AND.W #$4000                         ;83CE00;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CE5B                      ;83CE03;83CE5B;
                       LDA.L !family_event_flags                        ;83CE05;7F1F6C;
                       AND.W #$0001                         ;83CE09;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CE5B                      ;83CE0C;83CE5B;
                       LDA.L !family_event_flags                        ;83CE0E;7F1F6C;
                       AND.W #$0004                         ;83CE12;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CE5B                      ;83CE15;83CE5B;
                       LDA.L !marriage_flags                        ;83CE17;7F1F66;
                       AND.W #$0010                         ;83CE1B;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CE5B                      ;83CE1E;83CE5B;
                       LDA.L !family_event_flags                        ;83CE20;7F1F6C;
                       AND.W #$0020                         ;83CE24;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CE5B                      ;83CE27;83CE5B;
                       LDA.L !family_event_flags                        ;83CE29;7F1F6C;
                       AND.W #$0010                         ;83CE2D;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CE5B                      ;83CE30;83CE5B;
                       LDA.L !hearts_eve                        ;83CE32;7F1F27;Hearts for Eve
                       CMP.W #$00C8                         ;83CE36;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83CE5B                      ;83CE39;83CE5B;
                       LDA.L !family_event_flags                        ;83CE3B;7F1F6C;
                       ORA.W #$0010                         ;83CE3F;      ;
                       STA.L !family_event_flags                        ;83CE42;7F1F6C;
                       %Set16bit(!MX)                             ;83CE46;      ;
                       LDA.W #$0000                         ;83CE48;      ;
                       LDX.W #$001D                         ;83CE4B;      ;
                       LDY.W #$0000                         ;83CE4E;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83CE51;848097;
                       %Set8bit(!M)                             ;83CE55;      ;
                       STZ.W $09A3                          ;83CE57;0009A3;
                       RTS                                  ;83CE5A;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CE5B: %Set16bit(!MX)                             ;83CE5B;      ;
                       LDA.L $7F1F5A                        ;83CE5D;7F1F5A;
                       AND.W #$0002                         ;FLAG5A
                       BEQ Bank83_NpcSpriteLogicBranch_83CE93                      ;83CE64;83CE93;
                       %Set16bit(!M)                             ;83CE66;      ;
                       LDA.W #$0007                         ;83CE68;      ;
                       LDX.W #$0000                         ;83CE6B;      ;
                       LDY.W #$0020                         ;83CE6E;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83CE71;848097;
                       %Set8bit(!M)                             ;83CE75;      ;
                       LDA.B #$42                           ;83CE77;      ;
                       STA.W $096E                          ;83CE79;00096E;
                       STZ.W $096F                          ;83CE7C;00096F;
                       STZ.W $0970                          ;83CE7F;000970;
                       %Set16bit(!MX)                             ;83CE82;      ;
                       LDA.B !game_state                            ;83CE84;0000D2;
                       ORA.W #$0040                         ;83CE86;      ;
                       STA.B !game_state                            ;83CE89;0000D2;
                       %Set16bit(!MX)                             ;83CE8B;      ;
                       LDA.W #$0000                         ;83CE8D;      ;
                       STA.B !player_action                            ;83CE90;0000D4;
                       RTS                                  ;83CE92;      ;END_NPCMapEvent_FarmHomeFamilyAndRomanceCheck
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CE93: %Set16bit(!MX)                             ;83CE93;      ;
                       LDA.L $7F1F68                        ;83CE95;7F1F68;
                       AND.W #$0001                         ;83CE99;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CEAE                      ;83CE9C;83CEAE;
                       %Set16bit(!MX)                             ;83CE9E;      ;
                       LDA.W #$0000                         ;83CEA0;      ;
                       LDX.W #$000A                         ;83CEA3;      ;
                       LDY.W #$0002                         ;83CEA6;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83CEA9;848097;
                       RTS                                  ;83CEAD;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CEAE: %Set16bit(!MX)                             ;83CEAE;      ;
                       LDA.L $7F1F68                        ;83CEB0;7F1F68;
                       AND.W #$0020                         ;83CEB4;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CEDD                      ;83CEB7;83CEDD;
                       %Set16bit(!MX)                             ;83CEB9;      ;
                       LDA.W #$0000                         ;83CEBB;      ;
                       LDX.W #$000C                         ;83CEBE;      ;
                       LDY.W #$0000                         ;83CEC1;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83CEC4;848097;
                       %Set16bit(!M)                             ;83CEC8;      ;
                       LDA.L $7F1F68                        ;83CECA;7F1F68;
                       ORA.W #$0020                         ;83CECE;      ;
                       STA.L $7F1F68                        ;83CED1;7F1F68;
                       %Set8bit(!M)                             ;83CED5;      ;
                       LDA.B #$03                           ;83CED7;      ;
                       STA.W $099F                          ;83CED9;00099F;
                       RTS                                  ;83CEDC;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CEDD: %Set16bit(!MX)                             ;83CEDD;      ;
                       LDA.L $7F1F68                        ;83CEDF;7F1F68;
                       AND.W #$0080                         ;83CEE3;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CF10                      ;83CEE6;83CF10;
                       %Set16bit(!MX)                             ;83CEE8;      ;
                       LDA.W #$0000                         ;83CEEA;      ;
                       LDX.W #$000C                         ;83CEED;      ;
                       LDY.W #$0001                         ;83CEF0;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83CEF3;848097;
                       %Set16bit(!M)                             ;83CEF7;      ;
                       LDA.W #$0078                         ;83CEF9;      ;
                       STA.L !dog_pos_X                        ;83CEFC;7F1F2C;
                       LDA.W #$01A8                         ;83CF00;      ;
                       STA.L !dog_pos_Y                        ;83CF03;7F1F2E;
                       %Set8bit(!M)                             ;83CF07;      ;
                       LDA.B #$00                           ;83CF09;      ;
                       STA.L !dog_map                        ;83CF0B;7F1F30;
                       RTS                                  ;83CF0F;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CF10: %Set8bit(!M)                             ;83CF10;      ;
                       %Set16bit(!X)                             ;83CF12;      ;
                       LDA.W !weather_tomorrow                          ;83CF14;00098C;
                       CMP.B #$06                           ;83CF17;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83CF42                      ;83CF19;83CF42;
                       LDA.L !hour                        ;83CF1B;7F1F1C;
                       CMP.B #$06                           ;83CF1F;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CF42                      ;83CF21;83CF42;
                       LDA.L !minutes                        ;83CF23;7F1F1D;
                       BNE Bank83_NpcSpriteLogicBranch_83CF42                      ;83CF27;83CF42;
                       LDA.L !seconds                        ;83CF29;7F1F1E;
                       BEQ Bank83_NpcSpriteLogicBranch_83CF32                      ;83CF2D;83CF32;
                       JMP.W Bank83_NpcSpriteLogicBranch_83CFF8                    ;83CF2F;83CFF8;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CF32: %Set16bit(!MX)                             ;83CF32;      ;
                       LDA.W #$0006                         ;83CF34;      ;
                       LDX.W #$0024                         ;83CF37;      ;
                       LDY.W #$0000                         ;83CF3A;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83CF3D;848097;
                       RTS                                  ;83CF41;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CF42: %Set16bit(!MX)                             ;83CF42;      ;
                       LDA.L $7F1F70                        ;83CF44;7F1F70;
                       AND.W #$0002                         ;83CF48;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83CF73                      ;83CF4B;83CF73;
                       %Set8bit(!M)                             ;83CF4D;      ;
                       LDA.L !hour                        ;83CF4F;7F1F1C;
                       CMP.B #$06                           ;83CF53;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CF73                      ;83CF55;83CF73;
                       LDA.L !minutes                        ;83CF57;7F1F1D;
                       BNE Bank83_NpcSpriteLogicBranch_83CF73                      ;83CF5B;83CF73;
                       LDA.L !seconds                        ;83CF5D;7F1F1E;
                       BNE Bank83_NpcSpriteLogicBranch_83CF73                      ;83CF61;83CF73;
                       %Set16bit(!MX)                             ;83CF63;      ;
                       LDA.W #$0006                         ;83CF65;      ;
                       LDX.W #$0024                         ;83CF68;      ;
                       LDY.W #$0002                         ;83CF6B;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83CF6E;848097;
                       RTS                                  ;83CF72;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CF73: %Set16bit(!MX)                             ;83CF73;      ;
                       LDA.L !player_house_and_event_flags                        ;83CF75;7F1F64;
                       AND.W #$0010                         ;83CF79;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83CFA4                      ;83CF7C;83CFA4;
                       %Set8bit(!M)                             ;83CF7E;      ;
                       LDA.L !hour                        ;83CF80;7F1F1C;
                       CMP.B #$06                           ;83CF84;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CFA4                      ;83CF86;83CFA4;
                       LDA.L !minutes                        ;83CF88;7F1F1D;
                       BNE Bank83_NpcSpriteLogicBranch_83CFA4                      ;83CF8C;83CFA4;
                       LDA.L !seconds                        ;83CF8E;7F1F1E;
                       BNE Bank83_NpcSpriteLogicBranch_83CFA4                      ;83CF92;83CFA4;
                       %Set16bit(!MX)                             ;83CF94;      ;
                       LDA.W #$0006                         ;83CF96;      ;
                       LDX.W #$0024                         ;83CF99;      ;
                       LDY.W #$0003                         ;83CF9C;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83CF9F;848097;
                       RTS                                  ;83CFA3;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CFA4: %Set16bit(!MX)                             ;83CFA4;      ;
                       LDA.L $7F1F70                        ;83CFA6;7F1F70;
                       AND.W #$0001                         ;83CFAA;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CFF8                      ;83CFAD;83CFF8;
                       %Set8bit(!M)                             ;83CFAF;      ;
                       LDA.L !year                        ;83CFB1;7F1F18;
                       BNE Bank83_NpcSpriteLogicBranch_83CFF8                      ;83CFB5;83CFF8;
                       LDA.L !season                        ;83CFB7;7F1F19;
                       CMP.B #$01                           ;83CFBB;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CFF8                      ;83CFBD;83CFF8;
                       LDA.L !day                        ;83CFBF;7F1F1B;
                       CMP.B #$14                           ;83CFC3;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83CFF8                      ;83CFC5;83CFF8;
                       LDA.L !hour                        ;83CFC7;7F1F1C;
                       CMP.B #$06                           ;83CFCB;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83CFF8                      ;83CFCD;83CFF8;
                       LDA.L !minutes                        ;83CFCF;7F1F1D;
                       BNE Bank83_NpcSpriteLogicBranch_83CFF8                      ;83CFD3;83CFF8;
                       LDA.L !seconds                        ;83CFD5;7F1F1E;
                       BNE Bank83_NpcSpriteLogicBranch_83CFF8                      ;83CFD9;83CFF8;
                       %Set16bit(!M)                             ;83CFDB;      ;
                       LDA.L $7F1F70                        ;83CFDD;7F1F70;
                       ORA.W #$0001                         ;83CFE1;      ;
                       STA.L $7F1F70                        ;83CFE4;7F1F70;
                       %Set16bit(!MX)                             ;83CFE8;      ;
                       LDA.W #$000B                         ;83CFEA;      ;
                       LDX.W #$0024                         ;83CFED;      ;
                       LDY.W #$0001                         ;83CFF0;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83CFF3;848097;
                       RTS                                  ;83CFF7;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83CFF8: %Set16bit(!MX)                             ;83CFF8;      ;
                       LDA.L !marriage_flags                        ;83CFFA;7F1F66;
                       AND.W #$0040                         ;83CFFE;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D03D                      ;83D001;83D03D;
                       %Set16bit(!M)                             ;83D003;      ;
                       LDA.W #$0009                         ;83D005;      ;
                       LDX.W #$0000                         ;83D008;      ;
                       LDY.W #$002C                         ;83D00B;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D00E;848097;
                       %Set8bit(!M)                             ;83D012;      ;
                       LDA.B #$47                           ;83D014;      ;
                       STA.W $096E                          ;83D016;00096E;
                       STZ.W $096F                          ;83D019;00096F;
                       STZ.W $0970                          ;83D01C;000970;
                       %Set16bit(!MX)                             ;83D01F;      ;
                       LDA.B !game_state                            ;83D021;0000D2;
                       ORA.W #$0040                         ;83D023;      ;
                       STA.B !game_state                            ;83D026;0000D2;
                       %Set16bit(!MX)                             ;83D028;      ;
                       LDA.W #$0000                         ;83D02A;      ;
                       STA.B !player_action                            ;83D02D;0000D4;
                       %Set16bit(!M)                             ;83D02F;      ;
                       LDA.L !marriage_flags                        ;83D031;7F1F66;
                       AND.W #$FFBF                         ;83D035;      ;
                       STA.L !marriage_flags                        ;83D038;7F1F66;
                       RTS                                  ;83D03C;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D03D: %Set16bit(!MX)                             ;83D03D;      ;
                       LDA.L !marriage_flags                        ;83D03F;7F1F66;
                       AND.W #$0080                         ;83D043;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D060                      ;83D046;83D060;
                       %Set8bit(!M)                             ;83D048;      ;
                       LDA.L !development_rate                        ;83D04A;7F1F35;
                       BEQ Bank83_NpcSpriteLogicBranch_83D060                      ;83D04E;83D060;
                       %Set16bit(!MX)                             ;83D050;      ;
                       LDA.W #$0000                         ;83D052;      ;
                       LDX.W #$0000                         ;83D055;      ;
                       LDY.W #$002E                         ;83D058;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D05B;848097;
                       RTS                                  ;83D05F;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D060: %Set16bit(!MX)                             ;83D060;      ;
                       LDA.L !marriage_flags                        ;83D062;7F1F66;
                       AND.W #$0100                         ;83D066;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D0B2                      ;83D069;83D0B2;
                       LDA.L !marriage_flags                        ;83D06B;7F1F66;
                       AND.W #$FEFF                         ;83D06F;      ;
                       STA.L !marriage_flags                        ;83D072;7F1F66;
                       %Set16bit(!MX)                             ;83D076;      ;
                       LDA.W #$0009                         ;83D078;      ;
                       LDX.W #$0000                         ;83D07B;      ;
                       LDY.W #$0036                         ;83D07E;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D081;848097;
                       %Set16bit(!MX)                             ;83D085;      ;
                       LDA.W #$000A                         ;83D087;      ;
                       LDX.W #$0000                         ;83D08A;      ;
                       LDY.W #$0037                         ;83D08D;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D090;848097;
                       %Set8bit(!M)                             ;83D094;      ;
                       LDA.B #$48                           ;83D096;      ;
                       STA.W $096E                          ;83D098;00096E;
                       STZ.W $096F                          ;83D09B;00096F;
                       STZ.W $0970                          ;83D09E;000970;
                       %Set16bit(!MX)                             ;83D0A1;      ;
                       LDA.B !game_state                            ;83D0A3;0000D2;
                       ORA.W #$0040                         ;83D0A5;      ;
                       STA.B !game_state                            ;83D0A8;0000D2;
                       %Set16bit(!MX)                             ;83D0AA;      ;
                       LDA.W #$0000                         ;83D0AC;      ;
                       STA.B !player_action                            ;83D0AF;0000D4;
                       RTS                                  ;83D0B1;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D0B2: %Set16bit(!MX)                             ;83D0B2;      ;
                       LDA.L !player_house_and_event_flags                        ;83D0B4;7F1F64;
                       AND.W #$0100                         ;83D0B8;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D0FF                      ;83D0BB;83D0FF;
                       %Set8bit(!M)                             ;83D0BD;      ;
                       LDA.L $7F1F32                        ;83D0BF;7F1F32;
                       CMP.B #$15                           ;83D0C3;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D0FF                      ;83D0C5;83D0FF;
                       %Set16bit(!MX)                             ;83D0C7;      ;
                       LDA.L !player_house_and_event_flags                        ;83D0C9;7F1F64;
                       ORA.W #$0100                         ;83D0CD;      ;
                       STA.L !player_house_and_event_flags                        ;83D0D0;7F1F64;
                       LDA.W #$000B                         ;83D0D4;      ;
                       LDX.W #$0000                         ;83D0D7;      ;
                       LDY.W #$001D                         ;83D0DA;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D0DD;848097;
                       %Set8bit(!M)                             ;83D0E1;      ;
                       LDA.B #$49                           ;83D0E3;      ;
                       STA.W $096E                          ;83D0E5;00096E;
                       STZ.W $096F                          ;83D0E8;00096F;
                       STZ.W $0970                          ;83D0EB;000970;
                       %Set16bit(!MX)                             ;83D0EE;      ;
                       LDA.B !game_state                            ;83D0F0;0000D2;
                       ORA.W #$0040                         ;83D0F2;      ;
                       STA.B !game_state                            ;83D0F5;0000D2;
                       %Set16bit(!MX)                             ;83D0F7;      ;
                       LDA.W #$0000                         ;83D0F9;      ;
                       STA.B !player_action                            ;83D0FC;0000D4;
                       RTS                                  ;83D0FE;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D0FF: %Set8bit(!M)                             ;83D0FF;      ;
                       %Set16bit(!X)                             ;83D101;      ;
                       LDA.L !year                        ;83D103;7F1F18;
                       BEQ Bank83_NpcSpriteLogicBranch_83D163                      ;83D107;83D163;
                       LDA.L !hour                        ;83D109;7F1F1C;
                       CMP.W #$D006                         ;83D10D;      ;
                       EOR.B ($AF)                          ;83D110;0000AF;
                       ORA.W $7F1F,X                        ;83D112;007F1F;
                       BNE Bank83_NpcSpriteLogicBranch_83D163                      ;83D115;83D163;
                       LDA.L !seconds                        ;83D117;7F1F1E;
                       BNE Bank83_NpcSpriteLogicBranch_83D163                      ;83D11B;83D163;
                       %Set16bit(!M)                             ;83D11D;      ;
                       LDA.W $0196                          ;83D11F;000196;
                       AND.W #$001A                         ;83D122;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D163                      ;83D125;83D163;
                       %Set16bit(!M)                             ;83D127;      ;
                       LDA.L !moneyL                        ;83D129;7F1F04;
                       CLC                                  ;83D12D;      ;
                       ADC.W #$F448                         ;83D12E;      ;
                       %Set8bit(!M)                             ;83D131;      ;
                       LDA.L !moneyH                        ;83D133;7F1F06;
                       ADC.B #$FF                           ;83D137;      ;
                       BMI Bank83_NpcSpriteLogicBranch_83D163                      ;83D139;83D163;
                       %Set16bit(!MX)                             ;83D13B;      ;
                       LDA.L $7F1F68                        ;83D13D;7F1F68;
                       AND.W #$0400                         ;83D141;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D163                      ;83D144;83D163;
                       %Set16bit(!MX)                             ;83D146;      ;
                       LDA.W #$0000                         ;83D148;      ;
                       LDX.W #$0013                         ;83D14B;      ;
                       LDY.W #$0000                         ;83D14E;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D151;848097;
                       %Set16bit(!M)                             ;83D155;      ;
                       LDA.L $7F1F68                        ;83D157;7F1F68;
                       ORA.W #$0400                         ;83D15B;      ;
                       STA.L $7F1F68                        ;83D15E;7F1F68;
                       RTS                                  ;83D162;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D163: %Set8bit(!M)                             ;83D163;      ;
                       %Set16bit(!X)                             ;83D165;      ;
                       LDA.L !year                        ;83D167;7F1F18;
                       BNE Bank83_NpcSpriteLogicBranch_83D175                      ;83D16B;83D175;
                       LDA.L !season                        ;83D16D;7F1F19;
                       CMP.B #$03                           ;83D171;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D1CE                      ;83D173;83D1CE;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D175: %Set8bit(!M)                             ;83D175;      ;
                       LDA.L !hour                        ;83D177;7F1F1C;
                       CMP.B #$06                           ;83D17B;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D1CE                      ;83D17D;83D1CE;
                       LDA.L !minutes                        ;83D17F;7F1F1D;
                       BNE Bank83_NpcSpriteLogicBranch_83D1CE                      ;83D183;83D1CE;
                       LDA.L !seconds                        ;83D185;7F1F1E;
                       BNE Bank83_NpcSpriteLogicBranch_83D1CE                      ;83D189;83D1CE;
                       LDA.L !weekday                        ;83D18B;7F1F1A;
                       CMP.B #$06                           ;83D18F;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D1CE                      ;83D191;83D1CE;
                       %Set16bit(!M)                             ;83D193;      ;
                       LDA.W $0196                          ;83D195;000196;
                       AND.W #$001A                         ;83D198;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D1CE                      ;83D19B;83D1CE;
                       %Set16bit(!MX)                             ;83D19D;      ;
                       LDA.L !player_house_and_event_flags                        ;83D19F;7F1F64;
                       AND.W #$00C0                         ;83D1A3;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D1CE                      ;83D1A6;83D1CE;
                       %Set16bit(!MX)                             ;83D1A8;      ;
                       LDA.L $7F1F68                        ;83D1AA;7F1F68;
                       AND.W #$4000                         ;83D1AE;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D1CE                      ;83D1B1;83D1CE;
                       LDA.L $7F1F68                        ;83D1B3;7F1F68;
                       ORA.W #$4000                         ;83D1B7;      ;
                       STA.L $7F1F68                        ;83D1BA;7F1F68;
                       %Set16bit(!MX)                             ;83D1BE;      ;
                       LDA.W #$0000                         ;83D1C0;      ;
                       LDX.W #$0016                         ;83D1C3;      ;
                       LDY.W #$0000                         ;83D1C6;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D1C9;848097;
                       RTS                                  ;83D1CD;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D1CE: %Set8bit(!M)                             ;83D1CE;      ;
                       %Set16bit(!X)                             ;83D1D0;      ;
                       LDA.L !season                        ;83D1D2;7F1F19;
                       CMP.B #$02                           ;83D1D6;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D23E                      ;83D1D8;83D23E;
                       LDA.L !day                        ;83D1DA;7F1F1B;
                       CMP.B #$01                           ;83D1DE;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D23E                      ;83D1E0;83D23E;
                       CMP.B #$08                           ;83D1E2;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83D1F8                      ;83D1E4;83D1F8;
                       CMP.B #$0D                           ;83D1E6;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83D23E                      ;83D1E8;83D23E;
                       CMP.B #$12                           ;83D1EA;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83D1F8                      ;83D1EC;83D1F8;
                       CMP.B #$19                           ;83D1EE;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83D23E                      ;83D1F0;83D23E;
                       CMP.B #$1D                           ;83D1F2;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83D1F8                      ;83D1F4;83D1F8;
                       BRA Bank83_NpcSpriteLogicBranch_83D23E                      ;83D1F6;83D23E;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D1F8: %Set16bit(!M)                             ;83D1F8;      ;
                       LDA.W $0196                          ;83D1FA;000196;
                       AND.W #$001A                         ;83D1FD;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D23E                      ;83D200;83D23E;
                       %Set16bit(!MX)                             ;83D202;      ;
                       LDA.L !player_house_and_event_flags                        ;83D204;7F1F64;
                       AND.W #$00C0                         ;83D208;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D23E                      ;83D20B;83D23E;
                       %Set16bit(!MX)                             ;83D20D;      ;
                       LDA.L $7F1F68                        ;83D20F;7F1F68;
                       AND.W #$2000                         ;83D213;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D23E                      ;83D216;83D23E;
                       %Set16bit(!MX)                             ;83D218;      ;
                       LDA.L $7F1F6A                        ;83D21A;7F1F6A;
                       AND.W #$0100                         ;83D21E;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D23E                      ;83D221;83D23E;
                       LDA.L $7F1F6A                        ;83D223;7F1F6A;
                       ORA.W #$0080                         ;83D227;      ;
                       STA.L $7F1F6A                        ;83D22A;7F1F6A;
                       %Set16bit(!MX)                             ;83D22E;      ;
                       LDA.W #$0000                         ;83D230;      ;
                       LDX.W #$0018                         ;83D233;      ;
                       LDY.W #$0000                         ;83D236;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D239;848097;
                       RTS                                  ;83D23D;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D23E: %Set16bit(!MX)                             ;83D23E;      ;
                       LDA.L $7F1F6A                        ;83D240;7F1F6A;
                       AND.W #$0800                         ;83D244;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D29E                      ;83D247;83D29E;
                       LDA.L $7F1F6A                        ;83D249;7F1F6A;
                       AND.W #$0400                         ;83D24D;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D28E                      ;83D250;83D28E;
                       LDA.W $0196                          ;83D252;000196;
                       AND.W #$001E                         ;83D255;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D29E                      ;83D258;83D29E;
                       LDA.L !child_flags                        ;83D25A;7F1F6E;
                       AND.W #$0400                         ;83D25E;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D29E                      ;83D261;83D29E;
                       %Set8bit(!M)                             ;83D263;      ;
                       LDA.L !chicks_N                        ;83D265;7F1F0B;
                       CMP.B #$06                           ;83D269;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83D29E                      ;83D26B;83D29E;
                       LDA.L !hour                        ;83D26D;7F1F1C;
                       CMP.B #$06                           ;83D271;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D29E                      ;83D273;83D29E;
                       LDA.L !minutes                        ;83D275;7F1F1D;
                       BNE Bank83_NpcSpriteLogicBranch_83D29E                      ;83D279;83D29E;
                       LDA.L !seconds                        ;83D27B;7F1F1E;
                       BNE Bank83_NpcSpriteLogicBranch_83D29E                      ;83D27F;83D29E;
                       %Set16bit(!M)                             ;83D281;      ;
                       LDA.L $7F1F6A                        ;83D283;7F1F6A;
                       ORA.W #$0400                         ;83D287;      ;
                       STA.L $7F1F6A                        ;83D28A;7F1F6A;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D28E: %Set16bit(!MX)                             ;83D28E;      ;
                       LDA.W #$0000                         ;83D290;      ;
                       LDX.W #$0029                         ;83D293;      ;
                       LDY.W #$0000                         ;83D296;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D299;848097;
                       RTS                                  ;83D29D;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D29E: %Set16bit(!MX)                             ;83D29E;      ;
                       LDA.W $0196                          ;83D2A0;000196;
                       AND.W #$001A                         ;83D2A3;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D2DF                      ;83D2A6;83D2DF;
                       %Set8bit(!M)                             ;83D2A8;      ;
                       LDA.L !hour                        ;83D2AA;7F1F1C;
                       CMP.B #$06                           ;83D2AE;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D2DF                      ;83D2B0;83D2DF;
                       LDA.L !minutes                        ;83D2B2;7F1F1D;
                       BNE Bank83_NpcSpriteLogicBranch_83D2DF                      ;83D2B6;83D2DF;
                       LDA.L !seconds                        ;83D2B8;7F1F1E;
                       BNE Bank83_NpcSpriteLogicBranch_83D2DF                      ;83D2BC;83D2DF;
                       LDA.B #$08                           ;83D2BE;      ;
                       JSL.L RNG_GetRange0ToAExclusiveStyle                  ;83D2C0;8089F9;
                       BNE Bank83_NpcSpriteLogicBranch_83D2DF                      ;83D2C4;83D2DF;
                       %Set16bit(!MX)                             ;83D2C6;      ;
                       LDA.W #$0000                         ;83D2C8;      ;
                       LDX.W #$0023                         ;83D2CB;      ;
                       LDY.W #$0000                         ;83D2CE;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D2D1;848097;
                       %Set16bit(!MX)                             ;83D2D5;      ;
                       LDA.W #$0002                         ;83D2D7;      ;
                       JSL.L Social_AddPlayerHappiness                   ;83D2DA;83B282;
                       RTS                                  ;83D2DE;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D2DF: RTS                                  ;83D2DF;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83D2E0;      ;
                       LDA.L $7F1F60                        ;83D2E2;7F1F60;
                       AND.W #$0400                         ;83D2E6;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D304                      ;83D2E9;83D304;
                       LDA.L $7F1F60                        ;83D2EB;7F1F60;
                       AND.W #$FBFF                         ;83D2EF;      ;
                       STA.B $60                            ;83D2F2;000060;
                       %Set16bit(!MX)                             ;83D2F4;      ;
                       LDA.W #$0000                         ;83D2F6;      ;
                       LDX.W #$0014                         ;83D2F9;      ;
                       LDY.W #$0003                         ;83D2FC;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D2FF;848097;
                       RTS                                  ;83D303;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D304: %Set8bit(!M)                             ;83D304;      ;
                       %Set16bit(!X)                             ;83D306;      ;
                       LDA.L !season                        ;83D308;7F1F19;
                       CMP.B #$02                           ;83D30C;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D313                      ;83D30E;83D313;
                       JMP.W Bank83_NpcSpriteLogicBranch_83D3B8                    ;83D310;83D3B8;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D313: LDA.L !day                        ;83D313;7F1F1B;
                       CMP.B #$14                           ;83D317;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D31E                      ;83D319;83D31E;
                       JMP.W Bank83_NpcSpriteLogicBranch_83D3B8                    ;83D31B;83D3B8;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D31E: LDA.L !hour                        ;83D31E;7F1F1C;
                       CMP.B #$0F                           ;83D322;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83D329                      ;83D324;83D329;
                       JMP.W Bank83_NpcSpriteLogicBranch_83D3B8                    ;83D326;83D3B8;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D329: %Set16bit(!MX)                             ;83D329;      ;
                       LDA.W #$0015                         ;83D32B;      ;
                       LDX.W #$0000                         ;83D32E;      ;
                       LDY.W #$007E                         ;83D331;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D334;848097;
                       %Set16bit(!M)                             ;83D338;      ;
                       STZ.B $7E                            ;83D33A;00007E;
                       %Set8bit(!M)                             ;83D33C;      ;
                       LDA.B #$00                           ;83D33E;      ;
                       STA.W $09A4                          ;83D340;0009A4;
                       LDA.B #$01                           ;83D343;      ;
                       STA.W $09A5                          ;83D345;0009A5;
                       LDA.B #$02                           ;83D348;      ;
                       STA.W $09A6                          ;83D34A;0009A6;
                       LDA.B #$03                           ;83D34D;      ;
                       STA.W $09A7                          ;83D34F;0009A7;
                       LDA.B #$04                           ;83D352;      ;
                       STA.W $09A8                          ;83D354;0009A8;
                       LDA.B #$05                           ;83D357;      ;
                       STA.W $09A9                          ;83D359;0009A9;
                       LDA.B #$00                           ;83D35C;      ;
                       STA.W $09AA                          ;83D35E;0009AA;
                       LDA.B #$00                           ;83D361;      ;
                       STA.W $09AB                          ;83D363;0009AB;
                       LDY.W #$0000                         ;83D366;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D369: %Set8bit(!M)                             ;83D369;      ;
                       %Set16bit(!X)                             ;83D36B;      ;
                       PHY                                  ;83D36D;      ;
                       TYX                                  ;83D36E;      ;
                       STY.B $84                            ;83D36F;000084;
                       LDA.W $09A4,X                        ;83D371;0009A4;
                       STA.B $95                            ;83D374;000095;
                       %Set8bit(!M)                             ;83D376;      ;
                       LDA.B #$08                           ;83D378;      ;
                       JSL.L RNG_GetRange0ToAExclusiveStyle                  ;83D37A;8089F9;
                       %Set8bit(!M)                             ;83D37E;      ;
                       %Set16bit(!X)                             ;83D380;      ;
                       XBA                                  ;83D382;      ;
                       LDA.B #$00                           ;83D383;      ;
                       XBA                                  ;83D385;      ;
                       %Set16bit(!M)                             ;83D386;      ;
                       TAX                                  ;83D388;      ;
                       STX.B $86                            ;83D389;000086;
                       %Set8bit(!M)                             ;83D38B;      ;
                       LDA.W $09A4,X                        ;83D38D;0009A4;
                       LDX.B $84                            ;83D390;000084;
                       STA.W $09A4,X                        ;83D392;0009A4;
                       LDA.B $95                            ;83D395;000095;
                       LDX.B $86                            ;83D397;000086;
                       STA.W $09A4,X                        ;83D399;0009A4;
                       PLY                                  ;83D39C;      ;
                       INY                                  ;83D39D;      ;
                       CPY.W #$0007                         ;83D39E;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D369                      ;83D3A1;83D369;
                       %Set8bit(!M)                             ;83D3A3;      ;
                       STZ.W $09A2                          ;83D3A5;0009A2;
                       %Set16bit(!MX)                             ;83D3A8;      ;
                       LDA.W #$0000                         ;83D3AA;      ;
                       LDX.W #$0028                         ;83D3AD;      ;
                       LDY.W #$0002                         ;83D3B0;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D3B3;848097;
                       RTS                                  ;83D3B7;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D3B8: %Set8bit(!M)                             ;83D3B8;      ;
                       %Set16bit(!X)                             ;83D3BA;      ;
                       LDA.L !season                        ;83D3BC;7F1F19;
                       BNE Bank83_NpcSpriteLogicBranch_83D3E2                      ;83D3C0;83D3E2;
                       LDA.L !day                        ;83D3C2;7F1F1B;
                       CMP.B #$17                           ;83D3C6;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D3E2                      ;83D3C8;83D3E2;
                       LDA.L !hour                        ;83D3CA;7F1F1C;
                       CMP.B #$0F                           ;83D3CE;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83D3E2                      ;83D3D0;83D3E2;
                       %Set16bit(!MX)                             ;83D3D2;      ;
                       LDA.W #$0000                         ;83D3D4;      ;
                       LDX.W #$000E                         ;83D3D7;      ;
                       LDY.W #$0000                         ;83D3DA;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D3DD;848097;
                       RTS                                  ;83D3E1;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D3E2: %Set8bit(!M)                             ;83D3E2;      ;
                       %Set16bit(!X)                             ;83D3E4;      ;
                       LDA.L !season                        ;83D3E6;7F1F19;
                       CMP.B #$02                           ;83D3EA;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D40E                      ;83D3EC;83D40E;
                       LDA.L !day                        ;83D3EE;7F1F1B;
                       CMP.B #$0C                           ;83D3F2;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D40E                      ;83D3F4;83D40E;
                       LDA.L !hour                        ;83D3F6;7F1F1C;
                       CMP.B #$0F                           ;83D3FA;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83D40E                      ;83D3FC;83D40E;
                       %Set16bit(!MX)                             ;83D3FE;      ;
                       LDA.W #$0000                         ;83D400;      ;
                       LDX.W #$0026                         ;83D403;      ;
                       LDY.W #$0000                         ;83D406;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D409;848097;
                       RTS                                  ;83D40D;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D40E: %Set8bit(!M)                             ;83D40E;      ;
                       %Set16bit(!X)                             ;83D410;      ;
                       LDA.L !season                        ;83D412;7F1F19;
                       CMP.B #$03                           ;83D416;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D43A                      ;83D418;83D43A;
                       LDA.L !day                        ;83D41A;7F1F1B;
                       CMP.B #$0A                           ;83D41E;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D43A                      ;83D420;83D43A;
                       LDA.L !hour                        ;83D422;7F1F1C;
                       CMP.B #$11                           ;83D426;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83D43A                      ;83D428;83D43A;
                       %Set16bit(!MX)                             ;83D42A;      ;
                       LDA.W #$0000                         ;83D42C;      ;
                       LDX.W #$0027                         ;83D42F;      ;
                       LDY.W #$0000                         ;83D432;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D435;848097;
                       RTS                                  ;83D439;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D43A: %Set16bit(!MX)                             ;83D43A;      ;
                       LDA.L $7F1F6A                        ;83D43C;7F1F6A;
                       AND.W #$4000                         ;83D440;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D452                      ;83D443;83D452;
                       LDA.W #$0015                         ;83D445;      ;
                       LDX.W #$0000                         ;83D448;      ;
                       LDY.W #$007E                         ;83D44B;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D44E;848097;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D452: %Set16bit(!MX)                             ;83D452;      ;
                       LDA.L $7F1F68                        ;83D454;7F1F68;
                       AND.W #$0001                         ;83D458;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D46D                      ;83D45B;83D46D;
                       %Set16bit(!MX)                             ;83D45D;      ;
                       LDA.W #$0000                         ;83D45F;      ;
                       LDX.W #$000B                         ;83D462;      ;
                       LDY.W #$0000                         ;83D465;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D468;848097;
                       RTS                                  ;83D46C;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D46D: %Set16bit(!M)                             ;83D46D;      ;
                       LDA.W $0196                          ;83D46F;000196;
                       AND.W #$0008                         ;83D472;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D4B6                      ;83D475;83D4B6;
                       %Set8bit(!M)                             ;83D477;      ;
                       LDA.W !weather_tomorrow                          ;83D479;00098C;
                       CMP.B #$03                           ;83D47C;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D4B6                      ;83D47E;83D4B6;
                       %Set16bit(!MX)                             ;83D480;      ;
                       LDA.L !player_house_and_event_flags                        ;83D482;7F1F64;
                       AND.W #$0020                         ;83D486;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D4B6                      ;83D489;83D4B6;
                       LDA.W $0196                          ;83D48B;000196;
                       AND.W #$0200                         ;83D48E;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D4B6                      ;83D491;83D4B6;
                       LDA.W $0196                          ;83D493;000196;
                       AND.W #$0002                         ;83D496;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D4B6                      ;83D499;83D4B6;
                       %Set8bit(!M)                             ;83D49B;      ;
                       LDA.L !weekday                        ;83D49D;7F1F1A;
                       BEQ Bank83_NpcSpriteLogicBranch_83D4B7                      ;83D4A1;83D4B7;
                       CMP.B #$06                           ;83D4A3;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D4C7                      ;83D4A5;83D4C7;
                       %Set16bit(!MX)                             ;83D4A7;      ;
                       LDA.W #$0000                         ;83D4A9;      ;
                       LDX.W #$0001                         ;83D4AC;      ;
                       LDY.W #$0000                         ;83D4AF;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D4B2;848097;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D4B6: RTS                                  ;83D4B6;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D4B7: %Set16bit(!MX)                             ;83D4B7;      ;
                       LDA.W #$0000                         ;83D4B9;      ;
                       LDX.W #$0003                         ;83D4BC;      ;
                       LDY.W #$0000                         ;83D4BF;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D4C2;848097;
                       RTS                                  ;83D4C6;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D4C7: %Set16bit(!MX)                             ;83D4C7;      ;
                       LDA.W #$0000                         ;83D4C9;      ;
                       LDX.W #$0002                         ;83D4CC;      ;
                       LDY.W #$0000                         ;83D4CF;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D4D2;848097;
                       RTS                                  ;83D4D6;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83D4D7;      ;
                       LDA.L !marriage_flags                        ;83D4D9;7F1F66;
                       AND.W #$0001                         ;83D4DD;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D4E4                      ;83D4E0;83D4E4;
                       BRA Bank83_NpcSpriteLogicBranch_83D4FF                      ;83D4E2;83D4FF;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D4E4: %Set16bit(!MX)                             ;83D4E4;      ;
                       LDA.L !child_flags                        ;83D4E6;7F1F6E;
                       AND.W #$0002                         ;83D4EA;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D4FF                      ;83D4ED;83D4FF;
                       %Set16bit(!MX)                             ;83D4EF;      ;
                       LDA.W #$0000                         ;83D4F1;      ;
                       LDX.W #$0022                         ;83D4F4;      ;
                       LDY.W #$0003                         ;83D4F7;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D4FA;848097;
                       RTS                                  ;83D4FE;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D4FF: %Set8bit(!M)                             ;83D4FF;      ;
                       %Set16bit(!X)                             ;83D501;      ;
                       LDA.L !season                        ;83D503;7F1F19;
                       CMP.B #$03                           ;83D507;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D52B                      ;83D509;83D52B;
                       LDA.L !day                        ;83D50B;7F1F1B;
                       CMP.B #$0A                           ;83D50F;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D52B                      ;83D511;83D52B;
                       LDA.L !hour                        ;83D513;7F1F1C;
                       CMP.B #$11                           ;83D517;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83D52B                      ;83D519;83D52B;
                       %Set16bit(!MX)                             ;83D51B;      ;
                       LDA.W #$0000                         ;83D51D;      ;
                       LDX.W #$0027                         ;83D520;      ;
                       LDY.W #$0003                         ;83D523;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D526;848097;
                       RTS                                  ;83D52A;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D52B: %Set16bit(!MX)                             ;83D52B;      ;
                       LDA.L $7F1F68                        ;83D52D;7F1F68;
                       AND.W #$0001                         ;83D531;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D546                      ;83D534;83D546;
                       %Set16bit(!MX)                             ;83D536;      ;
                       LDA.W #$0000                         ;83D538;      ;
                       LDX.W #$000B                         ;83D53B;      ;
                       LDY.W #$0001                         ;83D53E;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D541;848097;
                       RTS                                  ;83D545;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D546: %Set16bit(!M)                             ;83D546;      ;
                       LDA.W $0196                          ;83D548;000196;
                       AND.W #$0008                         ;83D54B;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D5B7                      ;83D54E;83D5B7;
                       %Set8bit(!M)                             ;83D550;      ;
                       %Set16bit(!X)                             ;83D552;      ;
                       LDA.W !weather_tomorrow                          ;83D554;00098C;
                       CMP.B #$06                           ;83D557;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83D587                      ;83D559;83D587;
                       LDA.W !weather_tomorrow                          ;83D55B;00098C;
                       CMP.B #$03                           ;83D55E;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D5C7                      ;83D560;83D5C7;
                       %Set16bit(!MX)                             ;83D562;      ;
                       LDA.L !player_house_and_event_flags                        ;83D564;7F1F64;
                       AND.W #$0020                         ;83D568;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D5C7                      ;83D56B;83D5C7;
                       LDA.W $0196                          ;83D56D;000196;
                       AND.W #$0200                         ;83D570;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D5D7                      ;83D573;83D5D7;
                       LDA.W $0196                          ;83D575;000196;
                       AND.W #$0002                         ;83D578;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D5A7                      ;83D57B;83D5A7;
                       %Set8bit(!M)                             ;83D57D;      ;
                       LDA.L !weekday                        ;83D57F;7F1F1A;
                       CMP.B #$06                           ;83D583;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D597                      ;83D585;83D597;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D587: %Set16bit(!MX)                             ;83D587;      ;
                       LDA.W #$0000                         ;83D589;      ;
                       LDX.W #$0001                         ;83D58C;      ;
                       LDY.W #$0001                         ;83D58F;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D592;848097;
                       RTS                                  ;83D596;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D597: %Set16bit(!MX)                             ;83D597;      ;
                       LDA.W #$0000                         ;83D599;      ;
                       LDX.W #$0002                         ;83D59C;      ;
                       LDY.W #$0001                         ;83D59F;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D5A2;848097;
                       RTS                                  ;83D5A6;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D5A7: %Set16bit(!MX)                             ;83D5A7;      ;
                       LDA.W #$0000                         ;83D5A9;      ;
                       LDX.W #$0004                         ;83D5AC;      ;
                       LDY.W #$0000                         ;83D5AF;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D5B2;848097;
                       RTS                                  ;83D5B6;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D5B7: %Set16bit(!MX)                             ;83D5B7;      ;
                       LDA.W #$0000                         ;83D5B9;      ;
                       LDX.W #$0007                         ;83D5BC;      ;
                       LDY.W #$0000                         ;83D5BF;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D5C2;848097;
                       RTS                                  ;83D5C6;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D5C7: %Set16bit(!MX)                             ;83D5C7;      ;
                       LDA.W #$0000                         ;83D5C9;      ;
                       LDX.W #$0006                         ;83D5CC;      ;
                       LDY.W #$0000                         ;83D5CF;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D5D2;848097;
                       RTS                                  ;83D5D6;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D5D7: %Set16bit(!MX)                             ;83D5D7;      ;
                       LDA.W #$0000                         ;83D5D9;      ;
                       LDX.W #$0008                         ;83D5DC;      ;
                       LDY.W #$0000                         ;83D5DF;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D5E2;848097;
                       RTS                                  ;83D5E6;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83D5E7;      ;
                       LDA.L !marriage_flags                        ;83D5E9;7F1F66;
                       AND.W #$0001                         ;83D5ED;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D5F5                      ;83D5F0;83D5F5;
                       JMP.W Bank83_NpcSpriteLogicBranch_83D4FF                    ;83D5F2;83D4FF;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D5F5: %Set16bit(!MX)                             ;83D5F5;      ;
                       LDA.L !child_flags                        ;83D5F7;7F1F6E;
                       AND.W #$0002                         ;83D5FB;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D603                      ;83D5FE;83D603;
                       JMP.W Bank83_NpcSpriteLogicBranch_83D4FF                    ;83D600;83D4FF;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D603: %Set16bit(!MX)                             ;83D603;      ;
                       LDA.W #$0000                         ;83D605;      ;
                       LDX.W #$0022                         ;83D608;      ;
                       LDY.W #$0004                         ;83D60B;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D60E;848097;
                       RTS                                  ;83D612;      ;
                                                            ;      ;      ;
                       %Set8bit(!M)                             ;83D613;      ;
                       %Set16bit(!X)                             ;83D615;      ;
                       LDA.L !season                        ;83D617;7F1F19;
                       CMP.B #$03                           ;83D61B;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D63F                      ;83D61D;83D63F;
                       LDA.L !day                        ;83D61F;7F1F1B;
                       CMP.B #$0A                           ;83D623;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D63F                      ;83D625;83D63F;
                       LDA.L !hour                        ;83D627;7F1F1C;
                       CMP.B #$11                           ;83D62B;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83D63F                      ;83D62D;83D63F;
                       %Set16bit(!MX)                             ;83D62F;      ;
                       LDA.W #$0000                         ;83D631;      ;
                       LDX.W #$0027                         ;83D634;      ;
                       LDY.W #$0002                         ;83D637;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D63A;848097;
                       RTS                                  ;83D63E;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D63F: %Set8bit(!M)                             ;83D63F;      ;
                       %Set16bit(!X)                             ;83D641;      ;
                       LDA.L !season                        ;83D643;7F1F19;
                       CMP.B #$03                           ;83D647;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D66E                      ;83D649;83D66E;
                       LDA.L !day                        ;83D64B;7F1F1B;
                       CMP.B #$18                           ;83D64F;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D66E                      ;83D651;83D66E;
                       %Set16bit(!M)                             ;83D653;      ;
                       LDA.L $7F1F74                        ;83D655;7F1F74;
                       AND.W #$0002                         ;83D659;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D66E                      ;83D65C;83D66E;
                       %Set16bit(!MX)                             ;83D65E;      ;
                       LDA.W #$0000                         ;83D660;      ;
                       LDX.W #$000F                         ;83D663;      ;
                       LDY.W #$0002                         ;83D666;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D669;848097;
                       RTS                                  ;83D66D;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D66E: %Set16bit(!MX)                             ;83D66E;      ;
                       LDA.L $7F1F68                        ;83D670;7F1F68;
                       AND.W #$0001                         ;83D674;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D689                      ;83D677;83D689;
                       %Set16bit(!MX)                             ;83D679;      ;
                       LDA.W #$0000                         ;83D67B;      ;
                       LDX.W #$000B                         ;83D67E;      ;
                       LDY.W #$000C                         ;83D681;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D684;848097;
                       RTS                                  ;83D688;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D689: %Set16bit(!M)                             ;83D689;      ;
                       LDA.W $0196                          ;83D68B;000196;
                       AND.W #$0008                         ;83D68E;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D696                      ;83D691;83D696;
                       JMP.W Bank83_NpcSpriteLogicBranch_83D71E                    ;83D693;83D71E;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D696: %Set8bit(!M)                             ;83D696;      ;
                       %Set16bit(!X)                             ;83D698;      ;
                       LDA.W !weather_tomorrow                          ;83D69A;00098C;
                       CMP.B #$06                           ;83D69D;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83D6DE                      ;83D69F;83D6DE;
                       LDA.W !weather_tomorrow                          ;83D6A1;00098C;
                       CMP.B #$03                           ;83D6A4;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D6AB                      ;83D6A6;83D6AB;
                       JMP.W Bank83_NpcSpriteLogicBranch_83D72E                    ;83D6A8;83D72E;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D6AB: %Set16bit(!MX)                             ;83D6AB;      ;
                       LDA.L !player_house_and_event_flags                        ;83D6AD;7F1F64;
                       AND.W #$0020                         ;83D6B1;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D72E                      ;83D6B4;83D72E;
                       LDA.W $0196                          ;83D6B6;000196;
                       AND.W #$0200                         ;83D6B9;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D6C1                      ;83D6BC;83D6C1;
                       JMP.W Bank83_NpcSpriteLogicBranch_83D73E                    ;83D6BE;83D73E;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D6C1: LDA.L $7F1F68                        ;83D6C1;7F1F68;
                       AND.W #$0001                         ;83D6C5;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D6ED                      ;83D6C8;83D6ED;
                       LDA.W $0196                          ;83D6CA;000196;
                       AND.W #$0002                         ;83D6CD;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D70E                      ;83D6D0;83D70E;
                       %Set8bit(!M)                             ;83D6D2;      ;
                       LDA.L !weekday                        ;83D6D4;7F1F1A;
                       BEQ Bank83_NpcSpriteLogicBranch_83D6EE                      ;83D6D8;83D6EE;
                       CMP.B #$06                           ;83D6DA;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D6FE                      ;83D6DC;83D6FE;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D6DE: %Set16bit(!MX)                             ;83D6DE;      ;
                       LDA.W #$0000                         ;83D6E0;      ;
                       LDX.W #$0001                         ;83D6E3;      ;
                       LDY.W #$0002                         ;83D6E6;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D6E9;848097;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D6ED: RTS                                  ;83D6ED;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D6EE: %Set16bit(!MX)                             ;83D6EE;      ;
                       LDA.W #$0000                         ;83D6F0;      ;
                       LDX.W #$0003                         ;83D6F3;      ;
                       LDY.W #$0001                         ;83D6F6;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D6F9;848097;
                       RTS                                  ;83D6FD;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D6FE: %Set16bit(!MX)                             ;83D6FE;      ;
                       LDA.W #$0000                         ;83D700;      ;
                       LDX.W #$0002                         ;83D703;      ;
                       LDY.W #$0002                         ;83D706;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D709;848097;
                       RTS                                  ;83D70D;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D70E: %Set16bit(!MX)                             ;83D70E;      ;
                       LDA.W #$0000                         ;83D710;      ;
                       LDX.W #$0004                         ;83D713;      ;
                       LDY.W #$0001                         ;83D716;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D719;848097;
                       RTS                                  ;83D71D;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D71E: %Set16bit(!MX)                             ;83D71E;      ;
                       LDA.W #$0000                         ;83D720;      ;
                       LDX.W #$0007                         ;83D723;      ;
                       LDY.W #$0001                         ;83D726;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D729;848097;
                       RTS                                  ;83D72D;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D72E: %Set16bit(!MX)                             ;83D72E;      ;
                       LDA.W #$0000                         ;83D730;      ;
                       LDX.W #$0006                         ;83D733;      ;
                       LDY.W #$0001                         ;83D736;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D739;848097;
                       RTS                                  ;83D73D;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D73E: %Set16bit(!MX)                             ;83D73E;      ;
                       LDA.W #$0000                         ;83D740;      ;
                       LDX.W #$0008                         ;83D743;      ;
                       LDY.W #$0001                         ;83D746;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D749;848097;
                       RTS                                  ;83D74D;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83D74E;      ;
                       LDA.L !marriage_flags                        ;83D750;7F1F66;
                       AND.W #$0004                         ;83D754;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D75B                      ;83D757;83D75B;
                       BRA Bank83_NpcSpriteLogicBranch_83D776                      ;83D759;83D776;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D75B: %Set16bit(!MX)                             ;83D75B;      ;
                       LDA.L !child_flags                        ;83D75D;7F1F6E;
                       AND.W #$0002                         ;83D761;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D776                      ;83D764;83D776;
                       %Set16bit(!MX)                             ;83D766;      ;
                       LDA.W #$0000                         ;83D768;      ;
                       LDX.W #$0022                         ;83D76B;      ;
                       LDY.W #$0007                         ;83D76E;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D771;848097;
                       RTS                                  ;83D775;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D776: %Set16bit(!MX)                             ;83D776;      ;
                       LDA.L $7F1F68                        ;83D778;7F1F68;
                       AND.W #$0001                         ;83D77C;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D791                      ;83D77F;83D791;
                       %Set16bit(!MX)                             ;83D781;      ;
                       LDA.W #$0000                         ;83D783;      ;
                       LDX.W #$000B                         ;83D786;      ;
                       LDY.W #$0003                         ;83D789;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D78C;848097;
                       RTS                                  ;83D790;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D791: %Set16bit(!M)                             ;83D791;      ;
                       LDA.W $0196                          ;83D793;000196;
                       AND.W #$0008                         ;83D796;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D7E8                      ;83D799;83D7E8;
                       %Set8bit(!M)                             ;83D79B;      ;
                       %Set16bit(!X)                             ;83D79D;      ;
                       LDA.W !weather_tomorrow                          ;83D79F;00098C;
                       CMP.B #$06                           ;83D7A2;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83D7C8                      ;83D7A4;83D7C8;
                       LDA.W !weather_tomorrow                          ;83D7A6;00098C;
                       CMP.B #$03                           ;83D7A9;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D7F8                      ;83D7AB;83D7F8;
                       %Set16bit(!MX)                             ;83D7AD;      ;
                       LDA.L !player_house_and_event_flags                        ;83D7AF;7F1F64;
                       AND.W #$0020                         ;83D7B3;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D7F8                      ;83D7B6;83D7F8;
                       LDA.W $0196                          ;83D7B8;000196;
                       AND.W #$0200                         ;83D7BB;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D808                      ;83D7BE;83D808;
                       LDA.W $0196                          ;83D7C0;000196;
                       AND.W #$0002                         ;83D7C3;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D7D8                      ;83D7C6;83D7D8;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D7C8: %Set16bit(!MX)                             ;83D7C8;      ;
                       LDA.W #$0000                         ;83D7CA;      ;
                       LDX.W #$0001                         ;83D7CD;      ;
                       LDY.W #$0003                         ;83D7D0;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D7D3;848097;
                       RTS                                  ;83D7D7;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D7D8: %Set16bit(!MX)                             ;83D7D8;      ;
                       LDA.W #$0000                         ;83D7DA;      ;
                       LDX.W #$0004                         ;83D7DD;      ;
                       LDY.W #$0002                         ;83D7E0;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D7E3;848097;
                       RTS                                  ;83D7E7;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D7E8: %Set16bit(!MX)                             ;83D7E8;      ;
                       LDA.W #$0000                         ;83D7EA;      ;
                       LDX.W #$0007                         ;83D7ED;      ;
                       LDY.W #$0002                         ;83D7F0;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D7F3;848097;
                       RTS                                  ;83D7F7;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D7F8: %Set16bit(!MX)                             ;83D7F8;      ;
                       LDA.W #$0000                         ;83D7FA;      ;
                       LDX.W #$0006                         ;83D7FD;      ;
                       LDY.W #$0002                         ;83D800;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D803;848097;
                       RTS                                  ;83D807;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D808: %Set16bit(!MX)                             ;83D808;      ;
                       LDA.W #$0000                         ;83D80A;      ;
                       LDX.W #$0008                         ;83D80D;      ;
                       LDY.W #$0002                         ;83D810;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D813;848097;
                       RTS                                  ;83D817;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83D818;      ;
                       LDA.L !marriage_flags                        ;83D81A;7F1F66;
                       AND.W #$0004                         ;83D81E;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D826                      ;83D821;83D826;
                       JMP.W Bank83_NpcSpriteLogicBranch_83D776                    ;83D823;83D776;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D826: %Set16bit(!MX)                             ;83D826;      ;
                       LDA.L !child_flags                        ;83D828;7F1F6E;
                       AND.W #$0002                         ;83D82C;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D834                      ;83D82F;83D834;
                       JMP.W Bank83_NpcSpriteLogicBranch_83D776                    ;83D831;83D776;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D834: %Set16bit(!MX)                             ;83D834;      ;
                       LDA.W #$0000                         ;83D836;      ;
                       LDX.W #$0022                         ;83D839;      ;
                       LDY.W #$0008                         ;83D83C;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D83F;848097;
                       RTS                                  ;83D843;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83D844;      ;
                       LDA.L !marriage_flags                        ;83D846;7F1F66;
                       AND.W #$0002                         ;83D84A;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D851                      ;83D84D;83D851;
                       BRA Bank83_NpcSpriteLogicBranch_83D86C                      ;83D84F;83D86C;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D851: %Set16bit(!MX)                             ;83D851;      ;
                       LDA.L !child_flags                        ;83D853;7F1F6E;
                       AND.W #$0002                         ;83D857;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D86C                      ;83D85A;83D86C;
                       %Set16bit(!MX)                             ;83D85C;      ;
                       LDA.W #$0000                         ;83D85E;      ;
                       LDX.W #$0022                         ;83D861;      ;
                       LDY.W #$0005                         ;83D864;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D867;848097;
                       RTS                                  ;83D86B;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D86C: %Set16bit(!MX)                             ;83D86C;      ;
                       LDA.L $7F1F5E                        ;83D86E;7F1F5E;
                       AND.W #$0010                         ;83D872;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D887                      ;83D875;83D887;
                       %Set16bit(!MX)                             ;83D877;      ;
                       LDA.W #$0000                         ;83D879;      ;
                       LDX.W #$001A                         ;83D87C;      ;
                       LDY.W #$0001                         ;83D87F;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D882;848097;
                       RTS                                  ;83D886;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D887: %Set16bit(!MX)                             ;83D887;      ;
                       LDA.L $7F1F68                        ;83D889;7F1F68;
                       AND.W #$0001                         ;83D88D;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D8A2                      ;83D890;83D8A2;
                       %Set16bit(!MX)                             ;83D892;      ;
                       LDA.W #$0000                         ;83D894;      ;
                       LDX.W #$000B                         ;83D897;      ;
                       LDY.W #$0002                         ;83D89A;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D89D;848097;
                       RTS                                  ;83D8A1;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D8A2: %Set16bit(!M)                             ;83D8A2;      ;
                       LDA.W $0196                          ;83D8A4;000196;
                       AND.W #$0008                         ;83D8A7;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D8F9                      ;83D8AA;83D8F9;
                       %Set8bit(!M)                             ;83D8AC;      ;
                       %Set16bit(!X)                             ;83D8AE;      ;
                       LDA.W !weather_tomorrow                          ;83D8B0;00098C;
                       CMP.B #$06                           ;83D8B3;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83D8D9                      ;83D8B5;83D8D9;
                       LDA.W !weather_tomorrow                          ;83D8B7;00098C;
                       CMP.B #$03                           ;83D8BA;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D909                      ;83D8BC;83D909;
                       %Set16bit(!MX)                             ;83D8BE;      ;
                       LDA.L !player_house_and_event_flags                        ;83D8C0;7F1F64;
                       AND.W #$0020                         ;83D8C4;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D909                      ;83D8C7;83D909;
                       LDA.W $0196                          ;83D8C9;000196;
                       AND.W #$0200                         ;83D8CC;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D919                      ;83D8CF;83D919;
                       LDA.W $0196                          ;83D8D1;000196;
                       AND.W #$0002                         ;83D8D4;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D8E9                      ;83D8D7;83D8E9;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D8D9: %Set16bit(!MX)                             ;83D8D9;      ;
                       LDA.W #$0000                         ;83D8DB;      ;
                       LDX.W #$0001                         ;83D8DE;      ;
                       LDY.W #$0004                         ;83D8E1;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D8E4;848097;
                       RTS                                  ;83D8E8;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D8E9: %Set16bit(!MX)                             ;83D8E9;      ;
                       LDA.W #$0000                         ;83D8EB;      ;
                       LDX.W #$0004                         ;83D8EE;      ;
                       LDY.W #$0003                         ;83D8F1;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D8F4;848097;
                       RTS                                  ;83D8F8;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D8F9: %Set16bit(!MX)                             ;83D8F9;      ;
                       LDA.W #$0000                         ;83D8FB;      ;
                       LDX.W #$0007                         ;83D8FE;      ;
                       LDY.W #$0003                         ;83D901;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D904;848097;
                       RTS                                  ;83D908;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D909: %Set16bit(!MX)                             ;83D909;      ;
                       LDA.W #$0000                         ;83D90B;      ;
                       LDX.W #$0006                         ;83D90E;      ;
                       LDY.W #$0003                         ;83D911;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D914;848097;
                       RTS                                  ;83D918;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D919: %Set16bit(!MX)                             ;83D919;      ;
                       LDA.W #$0000                         ;83D91B;      ;
                       LDX.W #$0008                         ;83D91E;      ;
                       LDY.W #$0003                         ;83D921;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D924;848097;
                       RTS                                  ;83D928;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83D929;      ;
                       LDA.L !marriage_flags                        ;83D92B;7F1F66;
                       AND.W #$0002                         ;83D92F;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D937                      ;83D932;83D937;
                       JMP.W Bank83_NpcSpriteLogicBranch_83D86C                    ;83D934;83D86C;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D937: %Set16bit(!MX)                             ;83D937;      ;
                       LDA.L !child_flags                        ;83D939;7F1F6E;
                       AND.W #$0002                         ;83D93D;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D945                      ;83D940;83D945;
                       JMP.W Bank83_NpcSpriteLogicBranch_83D86C                    ;83D942;83D86C;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D945: %Set16bit(!MX)                             ;83D945;      ;
                       LDA.W #$0000                         ;83D947;      ;
                       LDX.W #$0022                         ;83D94A;      ;
                       LDY.W #$0006                         ;83D94D;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D950;848097;
                       RTS                                  ;83D954;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83D955;      ;
                       LDA.L !marriage_flags                        ;83D957;7F1F66;
                       AND.W #$0008                         ;83D95B;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D962                      ;83D95E;83D962;
                       BRA Bank83_NpcSpriteLogicBranch_83D97D                      ;83D960;83D97D;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D962: %Set16bit(!MX)                             ;83D962;      ;
                       LDA.L !child_flags                        ;83D964;7F1F6E;
                       AND.W #$0002                         ;83D968;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D97D                      ;83D96B;83D97D;
                       %Set16bit(!MX)                             ;83D96D;      ;
                       LDA.W #$0000                         ;83D96F;      ;
                       LDX.W #$0022                         ;83D972;      ;
                       LDY.W #$0009                         ;83D975;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D978;848097;
                       RTS                                  ;83D97C;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D97D: %Set16bit(!MX)                             ;83D97D;      ;
                       LDA.L $7F1F68                        ;83D97F;7F1F68;
                       AND.W #$0001                         ;83D983;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D998                      ;83D986;83D998;
                       %Set16bit(!MX)                             ;83D988;      ;
                       LDA.W #$0000                         ;83D98A;      ;
                       LDX.W #$000B                         ;83D98D;      ;
                       LDY.W #$0004                         ;83D990;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D993;848097;
                       RTS                                  ;83D997;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D998: %Set16bit(!M)                             ;83D998;      ;
                       LDA.W $0196                          ;83D99A;000196;
                       AND.W #$0008                         ;83D99D;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D9EF                      ;83D9A0;83D9EF;
                       %Set8bit(!M)                             ;83D9A2;      ;
                       %Set16bit(!X)                             ;83D9A4;      ;
                       LDA.W !weather_tomorrow                          ;83D9A6;00098C;
                       CMP.B #$06                           ;83D9A9;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83D9CF                      ;83D9AB;83D9CF;
                       LDA.W !weather_tomorrow                          ;83D9AD;00098C;
                       CMP.B #$03                           ;83D9B0;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83D9FF                      ;83D9B2;83D9FF;
                       %Set16bit(!MX)                             ;83D9B4;      ;
                       LDA.L !player_house_and_event_flags                        ;83D9B6;7F1F64;
                       AND.W #$0020                         ;83D9BA;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D9FF                      ;83D9BD;83D9FF;
                       LDA.W $0196                          ;83D9BF;000196;
                       AND.W #$0200                         ;83D9C2;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DA0F                      ;83D9C5;83DA0F;
                       LDA.W $0196                          ;83D9C7;000196;
                       AND.W #$0002                         ;83D9CA;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83D9DF                      ;83D9CD;83D9DF;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D9CF: %Set16bit(!MX)                             ;83D9CF;      ;
                       LDA.W #$0000                         ;83D9D1;      ;
                       LDX.W #$0001                         ;83D9D4;      ;
                       LDY.W #$0005                         ;83D9D7;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D9DA;848097;
                       RTS                                  ;83D9DE;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D9DF: %Set16bit(!MX)                             ;83D9DF;      ;
                       LDA.W #$0000                         ;83D9E1;      ;
                       LDX.W #$0004                         ;83D9E4;      ;
                       LDY.W #$0004                         ;83D9E7;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D9EA;848097;
                       RTS                                  ;83D9EE;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D9EF: %Set16bit(!MX)                             ;83D9EF;      ;
                       LDA.W #$0000                         ;83D9F1;      ;
                       LDX.W #$0007                         ;83D9F4;      ;
                       LDY.W #$0004                         ;83D9F7;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83D9FA;848097;
                       RTS                                  ;83D9FE;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83D9FF: %Set16bit(!MX)                             ;83D9FF;      ;
                       LDA.W #$0000                         ;83DA01;      ;
                       LDX.W #$0006                         ;83DA04;      ;
                       LDY.W #$0004                         ;83DA07;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DA0A;848097;
                       RTS                                  ;83DA0E;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DA0F: %Set16bit(!MX)                             ;83DA0F;      ;
                       LDA.W #$0000                         ;83DA11;      ;
                       LDX.W #$0008                         ;83DA14;      ;
                       LDY.W #$0004                         ;83DA17;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DA1A;848097;
                       RTS                                  ;83DA1E;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83DA1F;      ;
                       LDA.L !marriage_flags                        ;83DA21;7F1F66;
                       AND.W #$0008                         ;83DA25;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DA2D                      ;83DA28;83DA2D;
                       JMP.W Bank83_NpcSpriteLogicBranch_83D97D                    ;83DA2A;83D97D;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DA2D: %Set16bit(!MX)                             ;83DA2D;      ;
                       LDA.L !child_flags                        ;83DA2F;7F1F6E;
                       AND.W #$0002                         ;83DA33;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DA3B                      ;83DA36;83DA3B;
                       JMP.W Bank83_NpcSpriteLogicBranch_83D97D                    ;83DA38;83D97D;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DA3B: %Set16bit(!MX)                             ;83DA3B;      ;
                       LDA.W #$0000                         ;83DA3D;      ;
                       LDX.W #$0022                         ;83DA40;      ;
                       LDY.W #$000A                         ;83DA43;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DA46;848097;
                       RTS                                  ;83DA4A;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83DA4B;      ;
                       LDA.L $7F1F68                        ;83DA4D;7F1F68;
                       AND.W #$0001                         ;83DA51;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DA66                      ;83DA54;83DA66;
                       %Set16bit(!MX)                             ;83DA56;      ;
                       LDA.W #$0000                         ;83DA58;      ;
                       LDX.W #$000B                         ;83DA5B;      ;
                       LDY.W #$0005                         ;83DA5E;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DA61;848097;
                       RTS                                  ;83DA65;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DA66: %Set16bit(!M)                             ;83DA66;      ;
                       LDA.W $0196                          ;83DA68;000196;
                       AND.W #$0008                         ;83DA6B;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DABD                      ;83DA6E;83DABD;
                       %Set8bit(!M)                             ;83DA70;      ;
                       %Set16bit(!X)                             ;83DA72;      ;
                       LDA.W !weather_tomorrow                          ;83DA74;00098C;
                       CMP.B #$06                           ;83DA77;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83DA9D                      ;83DA79;83DA9D;
                       LDA.W !weather_tomorrow                          ;83DA7B;00098C;
                       CMP.B #$03                           ;83DA7E;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83DACD                      ;83DA80;83DACD;
                       %Set16bit(!MX)                             ;83DA82;      ;
                       LDA.L !player_house_and_event_flags                        ;83DA84;7F1F64;
                       AND.W #$0020                         ;83DA88;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DACD                      ;83DA8B;83DACD;
                       LDA.W $0196                          ;83DA8D;000196;
                       AND.W #$0200                         ;83DA90;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DADD                      ;83DA93;83DADD;
                       LDA.W $0196                          ;83DA95;000196;
                       AND.W #$0002                         ;83DA98;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DAAD                      ;83DA9B;83DAAD;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DA9D: %Set16bit(!MX)                             ;83DA9D;      ;
                       LDA.W #$0000                         ;83DA9F;      ;
                       LDX.W #$0001                         ;83DAA2;      ;
                       LDY.W #$0006                         ;83DAA5;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DAA8;848097;
                       RTS                                  ;83DAAC;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DAAD: %Set16bit(!MX)                             ;83DAAD;      ;
                       LDA.W #$0000                         ;83DAAF;      ;
                       LDX.W #$0004                         ;83DAB2;      ;
                       LDY.W #$0005                         ;83DAB5;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DAB8;848097;
                       RTS                                  ;83DABC;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DABD: %Set16bit(!MX)                             ;83DABD;      ;
                       LDA.W #$0000                         ;83DABF;      ;
                       LDX.W #$0007                         ;83DAC2;      ;
                       LDY.W #$0005                         ;83DAC5;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DAC8;848097;
                       RTS                                  ;83DACC;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DACD: %Set16bit(!MX)                             ;83DACD;      ;
                       LDA.W #$0000                         ;83DACF;      ;
                       LDX.W #$0006                         ;83DAD2;      ;
                       LDY.W #$0005                         ;83DAD5;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DAD8;848097;
                       RTS                                  ;83DADC;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DADD: %Set16bit(!MX)                             ;83DADD;      ;
                       LDA.W #$0000                         ;83DADF;      ;
                       LDX.W #$0008                         ;83DAE2;      ;
                       LDY.W #$0005                         ;83DAE5;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DAE8;848097;
                       RTS                                  ;83DAEC;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83DAED;      ;
                       LDA.L $7F1F68                        ;83DAEF;7F1F68;
                       AND.W #$0001                         ;83DAF3;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DB08                      ;83DAF6;83DB08;
                       %Set16bit(!MX)                             ;83DAF8;      ;
                       LDA.W #$0000                         ;83DAFA;      ;
                       LDX.W #$000B                         ;83DAFD;      ;
                       LDY.W #$0006                         ;83DB00;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DB03;848097;
                       RTS                                  ;83DB07;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DB08: %Set16bit(!M)                             ;83DB08;      ;
                       LDA.W $0196                          ;83DB0A;000196;
                       AND.W #$0008                         ;83DB0D;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DB5F                      ;83DB10;83DB5F;
                       %Set8bit(!M)                             ;83DB12;      ;
                       %Set16bit(!X)                             ;83DB14;      ;
                       LDA.W !weather_tomorrow                          ;83DB16;00098C;
                       CMP.B #$06                           ;83DB19;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83DB3F                      ;83DB1B;83DB3F;
                       LDA.W !weather_tomorrow                          ;83DB1D;00098C;
                       CMP.B #$03                           ;83DB20;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83DB6F                      ;83DB22;83DB6F;
                       %Set16bit(!MX)                             ;83DB24;      ;
                       LDA.L !player_house_and_event_flags                        ;83DB26;7F1F64;
                       AND.W #$0020                         ;83DB2A;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DB6F                      ;83DB2D;83DB6F;
                       LDA.W $0196                          ;83DB2F;000196;
                       AND.W #$0200                         ;83DB32;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DB7F                      ;83DB35;83DB7F;
                       LDA.W $0196                          ;83DB37;000196;
                       AND.W #$0002                         ;83DB3A;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DB4F                      ;83DB3D;83DB4F;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DB3F: %Set16bit(!MX)                             ;83DB3F;      ;
                       LDA.W #$0000                         ;83DB41;      ;
                       LDX.W #$0001                         ;83DB44;      ;
                       LDY.W #$0007                         ;83DB47;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DB4A;848097;
                       RTS                                  ;83DB4E;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DB4F: %Set16bit(!MX)                             ;83DB4F;      ;
                       LDA.W #$0000                         ;83DB51;      ;
                       LDX.W #$0004                         ;83DB54;      ;
                       LDY.W #$0006                         ;83DB57;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DB5A;848097;
                       RTS                                  ;83DB5E;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DB5F: %Set16bit(!MX)                             ;83DB5F;      ;
                       LDA.W #$0000                         ;83DB61;      ;
                       LDX.W #$0007                         ;83DB64;      ;
                       LDY.W #$0006                         ;83DB67;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DB6A;848097;
                       RTS                                  ;83DB6E;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DB6F: %Set16bit(!MX)                             ;83DB6F;      ;
                       LDA.W #$0000                         ;83DB71;      ;
                       LDX.W #$0006                         ;83DB74;      ;
                       LDY.W #$0006                         ;83DB77;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DB7A;848097;
                       RTS                                  ;83DB7E;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DB7F: %Set16bit(!MX)                             ;83DB7F;      ;
                       LDA.W #$0000                         ;83DB81;      ;
                       LDX.W #$0008                         ;83DB84;      ;
                       LDY.W #$0006                         ;83DB87;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DB8A;848097;
                       RTS                                  ;83DB8E;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83DB8F;      ;
                       LDA.L !marriage_flags                        ;83DB91;7F1F66;
                       AND.W #$0010                         ;83DB95;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DB9C                      ;83DB98;83DB9C;
                       BRA Bank83_NpcSpriteLogicBranch_83DBB7                      ;83DB9A;83DBB7;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DB9C: %Set16bit(!MX)                             ;83DB9C;      ;
                       LDA.L !child_flags                        ;83DB9E;7F1F6E;
                       AND.W #$0002                         ;83DBA2;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83DBB7                      ;83DBA5;83DBB7;
                       %Set16bit(!MX)                             ;83DBA7;      ;
                       LDA.W #$0000                         ;83DBA9;      ;
                       LDX.W #$0022                         ;83DBAC;      ;
                       LDY.W #$000B                         ;83DBAF;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DBB2;848097;
                       RTS                                  ;83DBB6;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DBB7: %Set8bit(!M)                             ;83DBB7;      ;
                       %Set16bit(!X)                             ;83DBB9;      ;
                       LDA.L !season                        ;83DBBB;7F1F19;
                       CMP.B #$03                           ;83DBBF;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DBE6                      ;83DBC1;83DBE6;
                       LDA.L !day                        ;83DBC3;7F1F1B;
                       CMP.B #$18                           ;83DBC7;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DBE6                      ;83DBC9;83DBE6;
                       %Set16bit(!M)                             ;83DBCB;      ;
                       LDA.L $7F1F74                        ;83DBCD;7F1F74;
                       AND.W #$0004                         ;83DBD1;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83DBE6                      ;83DBD4;83DBE6;
                       %Set16bit(!MX)                             ;83DBD6;      ;
                       LDA.W #$0000                         ;83DBD8;      ;
                       LDX.W #$000F                         ;83DBDB;      ;
                       LDY.W #$0003                         ;83DBDE;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DBE1;848097;
                       RTS                                  ;83DBE5;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DBE6: %Set16bit(!MX)                             ;83DBE6;      ;
                       LDA.L $7F1F68                        ;83DBE8;7F1F68;
                       AND.W #$0002                         ;83DBEC;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DC0E                      ;83DBEF;83DC0E;
                       %Set16bit(!MX)                             ;83DBF1;      ;
                       LDA.W #$0000                         ;83DBF3;      ;
                       LDX.W #$000B                         ;83DBF6;      ;
                       LDY.W #$0007                         ;83DBF9;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DBFC;848097;
                       %Set16bit(!MX)                             ;83DC00;      ;
                       LDA.L $7F1F68                        ;83DC02;7F1F68;
                       ORA.W #$0002                         ;83DC06;      ;
                       STA.L $7F1F68                        ;83DC09;7F1F68;
                       RTS                                  ;83DC0D;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DC0E: %Set16bit(!MX)                             ;83DC0E;      ;
                       LDA.W #$0000                         ;83DC10;      ;
                       LDX.W #$0005                         ;83DC13;      ;
                       LDY.W #$0000                         ;83DC16;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DC19;848097;
                       RTS                                  ;83DC1D;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83DC1E;      ;
                       LDA.L !marriage_flags                        ;83DC20;7F1F66;
                       AND.W #$0010                         ;83DC24;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DC2C                      ;83DC27;83DC2C;
                       JMP.W Bank83_NpcSpriteLogicBranch_83DBB7                    ;83DC29;83DBB7;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DC2C: %Set16bit(!MX)                             ;83DC2C;      ;
                       LDA.L !child_flags                        ;83DC2E;7F1F6E;
                       AND.W #$0002                         ;83DC32;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DC3A                      ;83DC35;83DC3A;
                       JMP.W Bank83_NpcSpriteLogicBranch_83DBB7                    ;83DC37;83DBB7;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DC3A: %Set16bit(!MX)                             ;83DC3A;      ;
                       LDA.W #$0000                         ;83DC3C;      ;
                       LDX.W #$0022                         ;83DC3F;      ;
                       LDY.W #$000C                         ;83DC42;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DC45;848097;
                       RTS                                  ;83DC49;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83DC4A;      ;
                       LDA.L $7F1F68                        ;83DC4C;7F1F68;
                       AND.W #$0004                         ;83DC50;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DC72                      ;83DC53;83DC72;
                       %Set16bit(!MX)                             ;83DC55;      ;
                       LDA.W #$0000                         ;83DC57;      ;
                       LDX.W #$000B                         ;83DC5A;      ;
                       LDY.W #$0009                         ;83DC5D;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DC60;848097;
                       %Set16bit(!M)                             ;83DC64;      ;
                       LDA.L $7F1F68                        ;83DC66;7F1F68;
                       ORA.W #$0004                         ;83DC6A;      ;
                       STA.L $7F1F68                        ;83DC6D;7F1F68;
                       RTS                                  ;83DC71;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DC72: %Set16bit(!MX)                             ;83DC72;      ;
                       LDA.L $7F1F5E                        ;83DC74;7F1F5E;
                       AND.W #$0020                         ;83DC78;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83DC8D                      ;83DC7B;83DC8D;
                       %Set16bit(!MX)                             ;83DC7D;      ;
                       LDA.W #$0000                         ;83DC7F;      ;
                       LDX.W #$001D                         ;83DC82;      ;
                       LDY.W #$0003                         ;83DC85;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DC88;848097;
                       RTS                                  ;83DC8C;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DC8D: %Set16bit(!MX)                             ;83DC8D;      ;
                       LDA.L !family_event_flags                        ;83DC8F;7F1F6C;
                       AND.W #$0010                         ;83DC93;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83DCA8                      ;83DC96;83DCA8;
                       %Set16bit(!MX)                             ;83DC98;      ;
                       LDA.W #$0000                         ;83DC9A;      ;
                       LDX.W #$001D                         ;83DC9D;      ;
                       LDY.W #$0001                         ;83DCA0;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DCA3;848097;
                       RTS                                  ;83DCA7;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DCA8: %Set16bit(!MX)                             ;83DCA8;      ;
                       LDA.L !family_event_flags                        ;83DCAA;7F1F6C;
                       AND.W #$0004                         ;83DCAE;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83DCDF                      ;83DCB1;83DCDF;
                       LDA.L $7F1F5E                        ;83DCB3;7F1F5E;
                       AND.W #$0008                         ;83DCB7;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DCCD                      ;83DCBA;83DCCD;
                       %Set16bit(!MX)                             ;83DCBC;      ;
                       LDA.W #$0009                         ;83DCBE;      ;
                       LDX.W #$001C                         ;83DCC1;      ;
                       LDY.W #$0001                         ;83DCC4;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DCC7;848097;
                       BRA Bank83_NpcSpriteLogicBranch_83DD3F                      ;83DCCB;83DD3F;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DCCD: %Set16bit(!MX)                             ;83DCCD;      ;
                       LDA.W #$0009                         ;83DCCF;      ;
                       LDX.W #$001C                         ;83DCD2;      ;
                       LDY.W #$0002                         ;83DCD5;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DCD8;848097;
                       JMP.W Bank83_NpcSpriteLogicBranch_83DD74                    ;83DCDC;83DD74;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DCDF: %Set8bit(!M)                             ;83DCDF;      ;
                       %Set16bit(!X)                             ;83DCE1;      ;
                       LDA.L !year                        ;83DCE3;7F1F18;
                       BEQ Bank83_NpcSpriteLogicBranch_83DD3F                      ;83DCE7;83DD3F;
                       LDA.L !season                        ;83DCE9;7F1F19;
                       CMP.B #$02                           ;83DCED;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83DD3F                      ;83DCEF;83DD3F;
                       LDA.L !day                        ;83DCF1;7F1F1B;
                       CMP.B #$01                           ;83DCF5;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83DD3F                      ;83DCF7;83DD3F;
                       CMP.B #$08                           ;83DCF9;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83DD0F                      ;83DCFB;83DD0F;
                       CMP.B #$0D                           ;83DCFD;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83DD3F                      ;83DCFF;83DD3F;
                       CMP.B #$12                           ;83DD01;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83DD0F                      ;83DD03;83DD0F;
                       CMP.B #$19                           ;83DD05;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83DD3F                      ;83DD07;83DD3F;
                       CMP.B #$1D                           ;83DD09;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83DD0F                      ;83DD0B;83DD0F;
                       BRA Bank83_NpcSpriteLogicBranch_83DD3F                      ;83DD0D;83DD3F;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DD0F: %Set16bit(!M)                             ;83DD0F;      ;
                       LDA.W $0196                          ;83DD11;000196;
                       AND.W #$001A                         ;83DD14;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DD3F                      ;83DD17;83DD3F;
                       LDA.L $7F1F6A                        ;83DD19;7F1F6A;
                       AND.W #$0200                         ;83DD1D;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DD3F                      ;83DD20;83DD3F;
                       %Set8bit(!M)                             ;83DD22;      ;
                       LDA.L !weekday                        ;83DD24;7F1F1A;
                       BEQ Bank83_NpcSpriteLogicBranch_83DD3F                      ;83DD28;83DD3F;
                       CMP.B #$06                           ;83DD2A;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83DD3F                      ;83DD2C;83DD3F;
                       %Set16bit(!MX)                             ;83DD2E;      ;
                       LDA.W #$0009                         ;83DD30;      ;
                       LDX.W #$0021                         ;83DD33;      ;
                       LDY.W #$0000                         ;83DD36;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DD39;848097;
                       BRA Bank83_NpcSpriteLogicBranch_83DD3F                      ;83DD3D;83DD3F;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DD3F: %Set16bit(!MX)                             ;83DD3F;      ;
                       LDA.W $0196                          ;83DD41;000196;
                       AND.W #$0008                         ;83DD44;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DD74                      ;83DD47;83DD74;
                       LDA.W $0196                          ;83DD49;000196;
                       AND.W #$0200                         ;83DD4C;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DD74                      ;83DD4F;83DD74;
                       LDA.W $0196                          ;83DD51;000196;
                       AND.W #$0002                         ;83DD54;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DD74                      ;83DD57;83DD74;
                       %Set8bit(!M)                             ;83DD59;      ;
                       LDA.L !weekday                        ;83DD5B;7F1F1A;
                       BEQ Bank83_NpcSpriteLogicBranch_83DD75                      ;83DD5F;83DD75;
                       CMP.B #$06                           ;83DD61;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83DD85                      ;83DD63;83DD85;
                       %Set16bit(!MX)                             ;83DD65;      ;
                       LDA.W #$0000                         ;83DD67;      ;
                       LDX.W #$0001                         ;83DD6A;      ;
                       LDY.W #$0008                         ;83DD6D;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DD70;848097;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DD74: RTS                                  ;83DD74;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DD75: %Set16bit(!MX)                             ;83DD75;      ;
                       LDA.W #$0000                         ;83DD77;      ;
                       LDX.W #$0003                         ;83DD7A;      ;
                       LDY.W #$0002                         ;83DD7D;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DD80;848097;
                       RTS                                  ;83DD84;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DD85: %Set16bit(!MX)                             ;83DD85;      ;
                       LDA.W #$0000                         ;83DD87;      ;
                       LDX.W #$0002                         ;83DD8A;      ;
                       LDY.W #$0003                         ;83DD8D;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DD90;848097;
                       RTS                                  ;83DD94;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83DD95;      ;
                       LDA.L $7F1F6A                        ;83DD97;7F1F6A;
                       AND.W #$2000                         ;83DD9B;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DDB9                      ;83DD9E;83DDB9;
                       LDA.L $7F1F6A                        ;83DDA0;7F1F6A;
                       AND.W #$1000                         ;83DDA4;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83DDB9                      ;83DDA7;83DDB9;
                       %Set16bit(!MX)                             ;83DDA9;      ;
                       LDA.W #$0000                         ;83DDAB;      ;
                       LDX.W #$0019                         ;83DDAE;      ;
                       LDY.W #$0001                         ;83DDB1;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DDB4;848097;
                       RTS                                  ;83DDB8;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DDB9: %Set16bit(!MX)                             ;83DDB9;      ;
                       LDA.L $7F1F68                        ;83DDBB;7F1F68;
                       AND.W #$0008                         ;83DDBF;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DE0A                      ;83DDC2;83DE0A;
                       %Set8bit(!M)                             ;83DDC4;      ;
                       LDA.L !year                        ;83DDC6;7F1F18;
                       BNE Bank83_NpcSpriteLogicBranch_83DDFD                      ;83DDCA;83DDFD;
                       LDA.L !season                        ;83DDCC;7F1F19;
                       CMP.B #$02                           ;83DDD0;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83DDFD                      ;83DDD2;83DDFD;
                       CMP.B #$00                           ;83DDD4;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83DDE0                      ;83DDD6;83DDE0;
                       LDA.L !day                        ;83DDD8;7F1F1B;
                       CMP.B #$1A                           ;83DDDC;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83DDFD                      ;83DDDE;83DDFD;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DDE0: %Set16bit(!MX)                             ;83DDE0;      ;
                       LDA.W #$0000                         ;83DDE2;      ;
                       LDX.W #$000B                         ;83DDE5;      ;
                       LDY.W #$000A                         ;83DDE8;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DDEB;848097;
                       %Set16bit(!M)                             ;83DDEF;      ;
                       LDA.L $7F1F68                        ;83DDF1;7F1F68;
                       ORA.W #$0008                         ;83DDF5;      ;
                       STA.L $7F1F68                        ;83DDF8;7F1F68;
                       RTS                                  ;83DDFC;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DDFD: %Set16bit(!M)                             ;83DDFD;      ;
                       LDA.L $7F1F68                        ;83DDFF;7F1F68;
                       ORA.W #$0008                         ;83DE03;      ;
                       STA.L $7F1F68                        ;83DE06;7F1F68;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DE0A: %Set16bit(!MX)                             ;83DE0A;      ;
                       LDA.W $0196                          ;83DE0C;000196;
                       AND.W #$0008                         ;83DE0F;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DE44                      ;83DE12;83DE44;
                       LDA.W $0196                          ;83DE14;000196;
                       AND.W #$0200                         ;83DE17;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DE54                      ;83DE1A;83DE54;
                       LDA.W $0196                          ;83DE1C;000196;
                       AND.W #$0002                         ;83DE1F;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DE34                      ;83DE22;83DE34;
                       %Set16bit(!MX)                             ;83DE24;      ;
                       LDA.W #$0000                         ;83DE26;      ;
                       LDX.W #$0001                         ;83DE29;      ;
                       LDY.W #$0009                         ;83DE2C;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DE2F;848097;
                       RTS                                  ;83DE33;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DE34: %Set16bit(!MX)                             ;83DE34;      ;
                       LDA.W #$0000                         ;83DE36;      ;
                       LDX.W #$0004                         ;83DE39;      ;
                       LDY.W #$0007                         ;83DE3C;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DE3F;848097;
                       RTS                                  ;83DE43;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DE44: %Set16bit(!MX)                             ;83DE44;      ;
                       LDA.W #$0000                         ;83DE46;      ;
                       LDX.W #$0007                         ;83DE49;      ;
                       LDY.W #$0007                         ;83DE4C;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DE4F;848097;
                       RTS                                  ;83DE53;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DE54: %Set16bit(!MX)                             ;83DE54;      ;
                       LDA.W #$0000                         ;83DE56;      ;
                       LDX.W #$0008                         ;83DE59;      ;
                       LDY.W #$0007                         ;83DE5C;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DE5F;848097;
                       RTS                                  ;83DE63;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83DE64;      ;
                       LDA.L $7F1F68                        ;83DE66;7F1F68;
                       AND.W #$2000                         ;83DE6A;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DE7F                      ;83DE6D;83DE7F;
                       %Set16bit(!MX)                             ;83DE6F;      ;
                       LDA.W #$0000                         ;83DE71;      ;
                       LDX.W #$0015                         ;83DE74;      ;
                       LDY.W #$0000                         ;83DE77;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DE7A;848097;
                       RTS                                  ;83DE7E;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DE7F: %Set16bit(!MX)                             ;83DE7F;      ;
                       LDA.L !player_house_and_event_flags                        ;83DE81;7F1F64;
                       AND.W #$0002                         ;83DE85;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83DE9A                      ;83DE88;83DE9A;
                       %Set16bit(!MX)                             ;83DE8A;      ;
                       LDA.W #$0000                         ;83DE8C;      ;
                       LDX.W #$0001                         ;83DE8F;      ;
                       LDY.W #$000A                         ;83DE92;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DE95;848097;
                       RTS                                  ;83DE99;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DE9A: RTS                                  ;83DE9A;      ;
                                                            ;      ;      ;
                       %Set16bit(!M)                             ;83DE9B;      ;
                       LDA.L !player_house_and_event_flags                        ;83DE9D;7F1F64;
                       AND.W #$0008                         ;83DEA1;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83DED2                      ;83DEA4;83DED2;
                       %Set16bit(!M)                             ;83DEA6;      ;
                       LDA.W #$0015                         ;83DEA8;      ;
                       LDX.W #$0000                         ;83DEAB;      ;
                       LDY.W #$0025                         ;83DEAE;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83DEB1;848097;
                       %Set8bit(!M)                             ;83DEB5;      ;
                       LDA.B #$45                           ;83DEB7;      ;
                       STA.W $096E                          ;83DEB9;00096E;
                       STZ.W $096F                          ;83DEBC;00096F;
                       STZ.W $0970                          ;83DEBF;000970;
                       %Set16bit(!MX)                             ;83DEC2;      ;
                       LDA.B !game_state                            ;83DEC4;0000D2;
                       ORA.W #$0040                         ;83DEC6;      ;
                       STA.B !game_state                            ;83DEC9;0000D2;
                       %Set16bit(!MX)                             ;83DECB;      ;
                       LDA.W #$0000                         ;83DECD;      ;
                       STA.B !player_action                            ;83DED0;0000D4;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DED2: RTS                                  ;83DED2;      ;
                                                            ;      ;      ;
                       %Set8bit(!M)                             ;83DED3;      ;
                       %Set16bit(!X)                             ;83DED5;      ;
                       LDA.L !year                        ;83DED7;7F1F18;
                       CMP.B #$02                           ;83DEDB;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DEF2                      ;83DEDD;83DEF2;
                       LDA.L !season                        ;83DEDF;7F1F19;
                       CMP.B #$01                           ;83DEE3;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DEF2                      ;83DEE5;83DEF2;
                       LDA.L !day                        ;83DEE7;7F1F1B;
                       CMP.B #$1E                           ;83DEEB;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DEF2                      ;83DEED;83DEF2;
                       JMP.W Bank83_NpcSpriteLogicBranch_83F4D8                    ;83DEEF;83F4D8;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DEF2: %Set16bit(!MX)                             ;83DEF2;      ;
                       LDA.L !player_house_and_event_flags                        ;83DEF4;7F1F64;
                       AND.W #$0080                         ;83DEF8;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83DF06                      ;83DEFB;83DF06;
                       %Set8bit(!M)                             ;83DEFD;      ;
                       LDA.B #$17                           ;83DEFF;      ;
                       STA.W !transition_dest                          ;83DF01;00098B;
                       BRA Bank83_NpcSpriteLogicBranch_83DF1A                      ;83DF04;83DF1A;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DF06: %Set16bit(!MX)                             ;83DF06;      ;
                       LDA.L !player_house_and_event_flags                        ;83DF08;7F1F64;
                       AND.W #$0040                         ;83DF0C;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83DF1A                      ;83DF0F;83DF1A;
                       %Set8bit(!M)                             ;83DF11;      ;
                       LDA.B #$16                           ;83DF13;      ;
                       STA.W !transition_dest                          ;83DF15;00098B;
                       BRA Bank83_NpcSpriteLogicBranch_83DF1A                      ;83DF18;83DF1A;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DF1A: %Set16bit(!MX)                             ;83DF1A;      ;
                       LDA.L !family_event_flags                        ;83DF1C;7F1F6C;
                       AND.W #$2000                         ;83DF20;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83DF47                      ;83DF23;83DF47;
                       LDA.L !family_event_flags                        ;83DF25;7F1F6C;
                       AND.W #$4000                         ;83DF29;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DF47                      ;83DF2C;83DF47;
                       LDA.W #$009C                         ;83DF2E;      ;
                       STA.W !tile_in_front_X                          ;83DF31;000985;
                       LDA.W #$0090                         ;83DF34;      ;
                       STA.W !tile_in_front_Y                          ;83DF37;000987;
                       LDA.W #$0010                         ;83DF3A;      ;
                       LDX.W #$0000                         ;83DF3D;      ;
                       LDY.W #$001F                         ;83DF40;      ;
                       JSL.L EventScript_LoadScriptPointerForFacingTile                    ;83DF43;8480F8;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DF47: %Set16bit(!MX)                             ;83DF47;      ;
                       LDA.L !child_flags                        ;83DF49;7F1F6E;
                       AND.W #$0080                         ;83DF4D;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83DF55                      ;83DF50;83DF55;
                       JMP.W Bank83_NpcSpriteLogicBranch_83DFF8                    ;83DF52;83DFF8;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DF55: LDA.L !child_flags                        ;83DF55;7F1F6E;
                       AND.W #$FF7F                         ;83DF59;      ;
                       STA.L !child_flags                        ;83DF5C;7F1F6E;
                       %Set8bit(!M)                             ;83DF60;      ;
                       LDA.B #$19                           ;83DF62;      ;
                       JSL.L AudioBGM_ForceTrackForTransitionWithDelay                          ;83DF64;8382C6;
                       %Set8bit(!M)                             ;83DF68;      ;
                       %Set16bit(!X)                             ;83DF6A;      ;
                       LDA.B #$02                           ;83DF6C;      ;
                       LDX.W #$0240                         ;83DF6E;      ;
                       LDY.W #$02C0                         ;83DF71;      ;
                       JSL.L EditTileonMapandsets0181                    ;83DF74;82B049;
                       %Set8bit(!M)                             ;83DF78;      ;
                       %Set16bit(!X)                             ;83DF7A;      ;
                       LDA.B #$02                           ;83DF7C;      ;
                       LDX.W #$0250                         ;83DF7E;      ;
                       LDY.W #$02C0                         ;83DF81;      ;
                       JSL.L EditTileonMapandsets0181                    ;83DF84;82B049;
                       %Set8bit(!M)                             ;83DF88;      ;
                       %Set16bit(!X)                             ;83DF8A;      ;
                       LDA.B #$02                           ;83DF8C;      ;
                       LDX.W #$0260                         ;83DF8E;      ;
                       LDY.W #$02C0                         ;83DF91;      ;
                       JSL.L EditTileonMapandsets0181                    ;83DF94;82B049;
                       %Set8bit(!M)                             ;83DF98;      ;
                       %Set16bit(!X)                             ;83DF9A;      ;
                       LDA.B #$02                           ;83DF9C;      ;
                       LDX.W #$0240                         ;83DF9E;      ;
                       LDY.W #$02D0                         ;83DFA1;      ;
                       JSL.L EditTileonMapandsets0181                    ;83DFA4;82B049;
                       %Set8bit(!M)                             ;83DFA8;      ;
                       %Set16bit(!X)                             ;83DFAA;      ;
                       LDA.B #$02                           ;83DFAC;      ;
                       LDX.W #$0250                         ;83DFAE;      ;
                       LDY.W #$02D0                         ;83DFB1;      ;
                       JSL.L EditTileonMapandsets0181                    ;83DFB4;82B049;
                       %Set8bit(!M)                             ;83DFB8;      ;
                       %Set16bit(!X)                             ;83DFBA;      ;
                       LDA.B #$02                           ;83DFBC;      ;
                       LDX.W #$0260                         ;83DFBE;      ;
                       LDY.W #$02D0                         ;83DFC1;      ;
                       JSL.L EditTileonMapandsets0181                    ;83DFC4;82B049;
                       %Set8bit(!M)                             ;83DFC8;      ;
                       %Set16bit(!X)                             ;83DFCA;      ;
                       LDA.B #$02                           ;83DFCC;      ;
                       LDX.W #$0240                         ;83DFCE;      ;
                       LDY.W #$02E0                         ;83DFD1;      ;
                       JSL.L EditTileonMapandsets0181                    ;83DFD4;82B049;
                       %Set8bit(!M)                             ;83DFD8;      ;
                       %Set16bit(!X)                             ;83DFDA;      ;
                       LDA.B #$02                           ;83DFDC;      ;
                       LDX.W #$0250                         ;83DFDE;      ;
                       LDY.W #$02E0                         ;83DFE1;      ;
                       JSL.L EditTileonMapandsets0181                    ;83DFE4;82B049;
                       %Set8bit(!M)                             ;83DFE8;      ;
                       %Set16bit(!X)                             ;83DFEA;      ;
                       LDA.B #$02                           ;83DFEC;      ;
                       LDX.W #$0260                         ;83DFEE;      ;
                       LDY.W #$02E0                         ;83DFF1;      ;
                       JSL.L EditTileonMapandsets0181                    ;83DFF4;82B049;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83DFF8: %Set16bit(!MX)                             ;83DFF8;      ;
                       LDA.L !child_flags                        ;83DFFA;7F1F6E;
                       AND.W #$0100                         ;83DFFE;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83E016                      ;83E001;83E016;
                       LDA.L !child_flags                        ;83E003;7F1F6E;
                       AND.W #$FEFF                         ;83E007;      ;
                       STA.L !child_flags                        ;83E00A;7F1F6E;
                       %Set8bit(!M)                             ;83E00E;      ;
                       LDA.B #$15                           ;83E010;      ;
                       JSL.L AudioBGM_ForceTrackForTransitionWithDelay                          ;83E012;8382C6;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E016: %Set16bit(!MX)                             ;83E016;      ;
                       LDA.L !child_flags                        ;83E018;7F1F6E;
                       AND.W #$0200                         ;83E01C;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83E04C                      ;83E01F;83E04C;
                       LDA.L !child_flags                        ;83E021;7F1F6E;
                       AND.W #$FDFF                         ;83E025;      ;
                       STA.L !child_flags                        ;83E028;7F1F6E;
                       %Set8bit(!M)                             ;83E02C;      ;
                       %Set16bit(!X)                             ;83E02E;      ;
                       LDA.B #$22                           ;83E030;      ;
                       LDX.W #$0007                         ;83E032;      ;
                       LDY.W #$0014                         ;83E035;      ;
                       JSL.L AudioSFX_PlayEffectIdWithDuration                          ;83E038;8382FE;
                       %Set8bit(!M)                             ;83E03C;      ;
                       %Set16bit(!X)                             ;83E03E;      ;
                       LDA.B #$22                           ;83E040;      ;
                       LDX.W #$0007                         ;83E042;      ;
                       LDY.W #$001E                         ;83E045;      ;
                       JSL.L AudioSFX_PlayEffectIdWithDuration                          ;83E048;8382FE;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E04C: %Set16bit(!MX)                             ;83E04C;      ;
                       LDA.L !child_flags                        ;83E04E;7F1F6E;
                       AND.W #$0020                         ;83E052;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83E074                      ;83E055;83E074;
                       %Set8bit(!M)                             ;83E057;      ;
                       %Set16bit(!X)                             ;83E059;      ;
                       LDA.B #$20                           ;83E05B;      ;
                       LDX.W #$0007                         ;83E05D;      ;
                       LDY.W #$003C                         ;83E060;      ;
                       JSL.L AudioSFX_PlayEffectIdWithDuration                          ;83E063;8382FE;
                       %Set16bit(!MX)                             ;83E067;      ;
                       LDA.L !child_flags                        ;83E069;7F1F6E;
                       AND.W #$FFDF                         ;83E06D;      ;
                       STA.L !child_flags                        ;83E070;7F1F6E;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E074: %Set16bit(!MX)                             ;83E074;      ;
                       LDA.L !child_flags                        ;83E076;7F1F6E;
                       AND.W #$0010                         ;83E07A;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83E0DB                      ;83E07D;83E0DB;
                       LDA.L $7F1F5E                        ;83E07F;7F1F5E;
                       AND.W #$4000                         ;83E083;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E0CB                      ;83E086;83E0CB;
                       LDA.L $7F1F5E                        ;83E088;7F1F5E;
                       AND.W #$2000                         ;83E08C;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E0A1                      ;83E08F;83E0A1;
                       %Set16bit(!MX)                             ;83E091;      ;
                       LDA.W #$0000                         ;83E093;      ;
                       LDX.W #$001F                         ;83E096;      ;
                       LDY.W #$0000                         ;83E099;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E09C;848097;
                       RTS                                  ;83E0A0;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E0A1: %Set16bit(!MX)                             ;83E0A1;      ;
                       LDA.W #$0000                         ;83E0A3;      ;
                       LDX.W #$001F                         ;83E0A6;      ;
                       LDY.W #$0001                         ;83E0A9;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E0AC;848097;
                       %Set16bit(!M)                             ;83E0B0;      ;
                       LDA.L !kid1_age                        ;83E0B2;7F1F37;
                       CMP.W #$003C                         ;83E0B6;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E0C3                      ;83E0B9;83E0C3;
                       %Set8bit(!M)                             ;83E0BB;      ;
                       LDA.B #$05                           ;83E0BD;      ;
                       STA.W $099F                          ;83E0BF;00099F;
                       RTS                                  ;83E0C2;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E0C3: %Set8bit(!M)                             ;83E0C3;      ;
                       LDA.B #$06                           ;83E0C5;      ;
                       STA.W $099F                          ;83E0C7;00099F;
                       RTS                                  ;83E0CA;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E0CB: %Set16bit(!MX)                             ;83E0CB;      ;
                       LDA.W #$0000                         ;83E0CD;      ;
                       LDX.W #$001F                         ;83E0D0;      ;
                       LDY.W #$0002                         ;83E0D3;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E0D6;848097;
                       RTS                                  ;83E0DA;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E0DB: %Set16bit(!MX)                             ;83E0DB;      ;
                       LDA.L !child_flags                        ;83E0DD;7F1F6E;
                       AND.W #$0040                         ;83E0E1;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83E144                      ;83E0E4;83E144;
                       %Set16bit(!MX)                             ;83E0E6;      ;
                       LDA.L !child_flags                        ;83E0E8;7F1F6E;
                       AND.W #$FFBF                         ;83E0EC;      ;
                       STA.L !child_flags                        ;83E0EF;7F1F6E;
                       %Set8bit(!M)                             ;83E0F3;      ;
                       LDA.B #$00                           ;83E0F5;      ;
                       XBA                                  ;83E0F7;      ;
                       LDA.W $0937                          ;83E0F8;000937;
                       %Set16bit(!M)                             ;83E0FB;      ;
                       JSL.L GetCowPointer                ;83E0FD;83C9A7;
                       %Set8bit(!M)                             ;83E101;      ;
                       %Set16bit(!X)                             ;83E103;      ;
                       LDA.B #$00                           ;83E105;      ;
                       XBA                                  ;83E107;      ;
                       LDY.W #$000C                         ;83E108;      ;
                       LDA.B [$72],Y                        ;83E10B;000072;
                       %Set16bit(!M)                             ;83E10D;      ;
                       STA.W $0889                          ;83E10F;000889;
                       %Set8bit(!M)                             ;83E112;      ;
                       LDY.W #$000D                         ;83E114;      ;
                       LDA.B [$72],Y                        ;83E117;000072;
                       %Set16bit(!M)                             ;83E119;      ;
                       STA.W $088B                          ;83E11B;00088B;
                       %Set8bit(!M)                             ;83E11E;      ;
                       LDY.W #$000E                         ;83E120;      ;
                       LDA.B [$72],Y                        ;83E123;000072;
                       %Set16bit(!M)                             ;83E125;      ;
                       STA.W $088D                          ;83E127;00088D;
                       %Set8bit(!M)                             ;83E12A;      ;
                       LDY.W #$000F                         ;83E12C;      ;
                       LDA.B [$72],Y                        ;83E12F;000072;
                       STA.W $088F                          ;83E131;00088F;
                       %Set16bit(!MX)                             ;83E134;      ;
                       LDA.W #$0000                         ;83E136;      ;
                       LDX.W #$0020                         ;83E139;      ;
                       LDY.W #$0000                         ;83E13C;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E13F;848097;
                       RTS                                  ;83E143;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E144: %Set16bit(!MX)                             ;83E144;      ;
                       LDA.L !marriage_flags                        ;83E146;7F1F66;
                       AND.W #$0001                         ;83E14A;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E176                      ;83E14D;83E176;
                       LDA.L !marriage_flags                        ;83E14F;7F1F66;
                       AND.W #$0002                         ;83E153;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E186                      ;83E156;83E186;
                       LDA.L !marriage_flags                        ;83E158;7F1F66;
                       AND.W #$0004                         ;83E15C;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E193                      ;83E15F;83E193;
                       LDA.L !marriage_flags                        ;83E161;7F1F66;
                       AND.W #$0008                         ;83E165;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E1A0                      ;83E168;83E1A0;
                       LDA.L !marriage_flags                        ;83E16A;7F1F66;
                       AND.W #$0010                         ;83E16E;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E1AD                      ;83E171;83E1AD;
                       JMP.W Bank83_NpcSpriteLogicBranch_83E2C6                    ;83E173;83E2C6;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E176: %Set16bit(!MX)                             ;83E176;      ;
                       LDA.L !hearts_maria                        ;83E178;7F1F1F;
                       CMP.W #$00C8                         ;83E17C;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83E184                      ;83E17F;83E184;
                       JMP.W Bank83_NpcSpriteLogicBranch_83E210                    ;83E181;83E210;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E184: BRA Bank83_NpcSpriteLogicBranch_83E1BA                      ;83E184;83E1BA;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E186: %Set16bit(!MX)                             ;83E186;      ;
                       LDA.L !hearts_ann                        ;83E188;7F1F21;
                       CMP.W #$00C8                         ;83E18C;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83E210                      ;83E18F;83E210;
                       BRA Bank83_NpcSpriteLogicBranch_83E1BA                      ;83E191;83E1BA;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E193: %Set16bit(!MX)                             ;83E193;      ;
                       LDA.L !hearts_nina                        ;83E195;7F1F23;
                       CMP.W #$00C8                         ;83E199;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83E210                      ;83E19C;83E210;
                       BRA Bank83_NpcSpriteLogicBranch_83E1BA                      ;83E19E;83E1BA;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E1A0: %Set16bit(!MX)                             ;83E1A0;      ;
                       LDA.L !hearts_ellen                        ;83E1A2;7F1F25;
                       CMP.W #$00C8                         ;83E1A6;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83E210                      ;83E1A9;83E210;
                       BRA Bank83_NpcSpriteLogicBranch_83E1BA                      ;83E1AB;83E1BA;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E1AD: %Set16bit(!MX)                             ;83E1AD;      ;
                       LDA.L !hearts_eve                        ;83E1AF;7F1F27;
                       CMP.W #$00C8                         ;83E1B3;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83E210                      ;83E1B6;83E210;
                       BRA Bank83_NpcSpriteLogicBranch_83E1BA                      ;83E1B8;83E1BA;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E1BA: %Set8bit(!M)                             ;83E1BA;      ;
                       %Set16bit(!X)                             ;83E1BC;      ;
                       LDA.L !hour                        ;83E1BE;7F1F1C;
                       CMP.B #$06                           ;83E1C2;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E210                      ;83E1C4;83E210;
                       LDA.L !minutes                        ;83E1C6;7F1F1D;
                       BNE Bank83_NpcSpriteLogicBranch_83E210                      ;83E1CA;83E210;
                       LDA.L !seconds                        ;83E1CC;7F1F1E;
                       BNE Bank83_NpcSpriteLogicBranch_83E210                      ;83E1D0;83E210;
                       %Set16bit(!M)                             ;83E1D2;      ;
                       LDA.L !child_flags                        ;83E1D4;7F1F6E;
                       AND.W #$000C                         ;83E1D8;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E210                      ;83E1DB;83E210;
                       LDA.L !child_flags                        ;83E1DD;7F1F6E;
                       AND.W #$0001                         ;83E1E1;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E210                      ;83E1E4;83E210;
                       %Set16bit(!MX)                             ;83E1E6;      ;
                       LDA.W #$0000                         ;83E1E8;      ;
                       LDX.W #$0022                         ;83E1EB;      ;
                       LDY.W #$0000                         ;83E1EE;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E1F1;848097;
                       %Set16bit(!MX)                             ;83E1F5;      ;
                       LDA.L !child_flags                        ;83E1F7;7F1F6E;
                       ORA.W #$0003                         ;83E1FB;      ;
                       STA.L !child_flags                        ;83E1FE;7F1F6E;
                       LDA.L $7F1F5E                        ;83E202;7F1F5E;
                       ORA.W #$1000                         ;83E206;      ;
                       STA.L $7F1F5E                        ;83E209;7F1F5E;
                       JMP.W Bank83_NpcSpriteLogicBranch_83E2C6                    ;83E20D;83E2C6;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E210: %Set16bit(!MX)                             ;83E210;      ;
                       LDA.L $7F1F5E                        ;83E212;7F1F5E;
                       AND.W #$EFFF                         ;83E216;      ;
                       STA.L $7F1F5E                        ;83E219;7F1F5E;
                       LDA.L !child_flags                        ;83E21D;7F1F6E;
                       AND.W #$0002                         ;83E221;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E262                      ;83E224;83E262;
                       LDA.L !marriage_flags                        ;83E226;7F1F66;
                       AND.W #$0001                         ;83E22A;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E271                      ;83E22D;83E271;
                       LDA.L !marriage_flags                        ;83E22F;7F1F66;
                       AND.W #$0002                         ;83E233;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83E23B                      ;83E236;83E23B;
                       JMP.W Bank83_NpcSpriteLogicBranch_83E282                    ;83E238;83E282;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E23B: LDA.L !marriage_flags                        ;83E23B;7F1F66;
                       AND.W #$0004                         ;83E23F;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83E247                      ;83E242;83E247;
                       JMP.W Bank83_NpcSpriteLogicBranch_83E293                    ;83E244;83E293;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E247: LDA.L !marriage_flags                        ;83E247;7F1F66;
                       AND.W #$0008                         ;83E24B;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83E253                      ;83E24E;83E253;
                       JMP.W Bank83_NpcSpriteLogicBranch_83E2A4                    ;83E250;83E2A4;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E253: LDA.L !marriage_flags                        ;83E253;7F1F66;
                       AND.W #$0010                         ;83E257;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83E25F                      ;83E25A;83E25F;
                       JMP.W Bank83_NpcSpriteLogicBranch_83E2B5                    ;83E25C;83E2B5;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E25F: JMP.W Bank83_NpcSpriteLogicBranch_83E2C6                    ;83E25F;83E2C6;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E262: %Set16bit(!MX)                             ;83E262;      ;
                       LDA.L $7F1F5E                        ;83E264;7F1F5E;
                       ORA.W #$1000                         ;83E268;      ;
                       STA.L $7F1F5E                        ;83E26B;7F1F5E;
                       BRA Bank83_NpcSpriteLogicBranch_83E2C6                      ;83E26F;83E2C6;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E271: %Set16bit(!MX)                             ;83E271;      ;
                       LDA.W #$0013                         ;83E273;      ;
                       LDX.W #$0043                         ;83E276;      ;
                       LDY.W #$0000                         ;83E279;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E27C;848097;
                       BRA Bank83_NpcSpriteLogicBranch_83E2C6                      ;83E280;83E2C6;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E282: %Set16bit(!MX)                             ;83E282;      ;
                       LDA.W #$0013                         ;83E284;      ;
                       LDX.W #$0043                         ;83E287;      ;
                       LDY.W #$0001                         ;83E28A;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E28D;848097;
                       BRA Bank83_NpcSpriteLogicBranch_83E2C6                      ;83E291;83E2C6;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E293: %Set16bit(!MX)                             ;83E293;      ;
                       LDA.W #$0013                         ;83E295;      ;
                       LDX.W #$0043                         ;83E298;      ;
                       LDY.W #$0002                         ;83E29B;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E29E;848097;
                       BRA Bank83_NpcSpriteLogicBranch_83E2C6                      ;83E2A2;83E2C6;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E2A4: %Set16bit(!MX)                             ;83E2A4;      ;
                       LDA.W #$0013                         ;83E2A6;      ;
                       LDX.W #$0043                         ;83E2A9;      ;
                       LDY.W #$0003                         ;83E2AC;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E2AF;848097;
                       BRA Bank83_NpcSpriteLogicBranch_83E2C6                      ;83E2B3;83E2C6;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E2B5: %Set16bit(!MX)                             ;83E2B5;      ;
                       LDA.W #$0013                         ;83E2B7;      ;
                       LDX.W #$0043                         ;83E2BA;      ;
                       LDY.W #$0004                         ;83E2BD;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E2C0;848097;
                       BRA Bank83_NpcSpriteLogicBranch_83E2C6                      ;83E2C4;83E2C6;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E2C6: %Set16bit(!MX)                             ;83E2C6;      ;
                       LDA.L !child_flags                        ;83E2C8;7F1F6E;
                       AND.W #$0004                         ;83E2CC;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83E2E9                      ;83E2CF;83E2E9;
                       LDA.L !kid1_age                        ;83E2D1;7F1F37;
                       CMP.W #$003C                         ;83E2D5;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83E2E9                      ;83E2D8;83E2E9;
                       %Set16bit(!MX)                             ;83E2DA;      ;
                       LDA.W #$0014                         ;83E2DC;      ;
                       LDX.W #$0045                         ;83E2DF;      ;
                       LDY.W #$0000                         ;83E2E2;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E2E5;848097;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E2E9: %Set16bit(!MX)                             ;83E2E9;      ;
                       LDA.L !child_flags                        ;83E2EB;7F1F6E;
                       AND.W #$0008                         ;83E2EF;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83E30C                      ;83E2F2;83E30C;
                       LDA.L !kid2_age                        ;83E2F4;7F1F39;
                       CMP.W #$003C                         ;83E2F8;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83E30C                      ;83E2FB;83E30C;
                       %Set16bit(!MX)                             ;83E2FD;      ;
                       LDA.W #$0015                         ;83E2FF;      ;
                       LDX.W #$0045                         ;83E302;      ;
                       LDY.W #$0003                         ;83E305;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E308;848097;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E30C: %Set16bit(!MX)                             ;83E30C;      ;
                       LDA.L $7F1F60                        ;83E30E;7F1F60;
                       AND.W #$0020                         ;83E312;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E330                      ;83E315;83E330;
                       LDA.L $7F1F68                        ;83E317;7F1F68;
                       AND.W #$0001                         ;83E31B;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E340                      ;83E31E;83E340;
                       %Set16bit(!MX)                             ;83E320;      ;
                       LDA.W #$0000                         ;83E322;      ;
                       LDX.W #$000A                         ;83E325;      ;
                       LDY.W #$0000                         ;83E328;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E32B;848097;
                       RTS                                  ;83E32F;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E330: %Set16bit(!MX)                             ;83E330;      ;
                       LDA.W #$0000                         ;83E332;      ;
                       LDX.W #$000A                         ;83E335;      ;
                       LDY.W #$0003                         ;83E338;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E33B;848097;
                       RTS                                  ;83E33F;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E340: %Set8bit(!M)                             ;83E340;      ;
                       %Set16bit(!X)                             ;83E342;      ;
                       LDA.L !year                        ;83E344;7F1F18;
                       CMP.B #$01                           ;83E348;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E380                      ;83E34A;83E380;
                       LDA.L !season                        ;83E34C;7F1F19;
                       CMP.B #$01                           ;83E350;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E380                      ;83E352;83E380;
                       LDA.L !day                        ;83E354;7F1F1B;
                       CMP.B #$01                           ;83E358;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E380                      ;83E35A;83E380;
                       LDA.L !hour                        ;83E35C;7F1F1C;
                       CMP.B #$06                           ;83E360;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E380                      ;83E362;83E380;
                       LDA.L !minutes                        ;83E364;7F1F1D;
                       BNE Bank83_NpcSpriteLogicBranch_83E380                      ;83E368;83E380;
                       LDA.L !seconds                        ;83E36A;7F1F1E;
                       BNE Bank83_NpcSpriteLogicBranch_83E380                      ;83E36E;83E380;
                       %Set16bit(!MX)                             ;83E370;      ;
                       LDA.W #$0000                         ;83E372;      ;
                       LDX.W #$000A                         ;83E375;      ;
                       LDY.W #$0004                         ;83E378;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E37B;848097;
                       RTS                                  ;83E37F;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E380: %Set8bit(!M)                             ;83E380;      ;
                       %Set16bit(!X)                             ;83E382;      ;
                       LDA.L !year                        ;83E384;7F1F18;
                       CMP.B #$02                           ;83E388;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E3C0                      ;83E38A;83E3C0;
                       LDA.L !season                        ;83E38C;7F1F19;
                       CMP.B #$01                           ;83E390;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E3C0                      ;83E392;83E3C0;
                       LDA.L !day                        ;83E394;7F1F1B;
                       CMP.B #$1D                           ;83E398;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E3C0                      ;83E39A;83E3C0;
                       LDA.L !hour                        ;83E39C;7F1F1C;
                       CMP.B #$06                           ;83E3A0;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E3C0                      ;83E3A2;83E3C0;
                       LDA.L !minutes                        ;83E3A4;7F1F1D;
                       BNE Bank83_NpcSpriteLogicBranch_83E3C0                      ;83E3A8;83E3C0;
                       LDA.L !seconds                        ;83E3AA;7F1F1E;
                       BNE Bank83_NpcSpriteLogicBranch_83E3C0                      ;83E3AE;83E3C0;
                       %Set16bit(!MX)                             ;83E3B0;      ;
                       LDA.W #$0000                         ;83E3B2;      ;
                       LDX.W #$000A                         ;83E3B5;      ;
                       LDY.W #$0005                         ;83E3B8;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E3BB;848097;
                       RTS                                  ;83E3BF;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E3C0: %Set8bit(!M)                             ;83E3C0;      ;
                       %Set16bit(!X)                             ;83E3C2;      ;
                       LDA.L !season                        ;83E3C4;7F1F19;
                       BNE Bank83_NpcSpriteLogicBranch_83E3E2                      ;83E3C8;83E3E2;
                       LDA.L !day                        ;83E3CA;7F1F1B;
                       CMP.B #$01                           ;83E3CE;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E3E2                      ;83E3D0;83E3E2;
                       %Set16bit(!MX)                             ;83E3D2;      ;
                       LDA.W #$0000                         ;83E3D4;      ;
                       LDX.W #$0028                         ;83E3D7;      ;
                       LDY.W #$0000                         ;83E3DA;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E3DD;848097;
                       RTS                                  ;83E3E1;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E3E2: %Set8bit(!M)                             ;83E3E2;      ;
                       %Set16bit(!X)                             ;83E3E4;      ;
                       LDA.L !season                        ;83E3E6;7F1F19;
                       CMP.B #$03                           ;83E3EA;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E406                      ;83E3EC;83E406;
                       LDA.L !day                        ;83E3EE;7F1F1B;
                       CMP.B #$18                           ;83E3F2;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E406                      ;83E3F4;83E406;
                       %Set16bit(!MX)                             ;83E3F6;      ;
                       LDA.W #$0000                         ;83E3F8;      ;
                       LDX.W #$000F                         ;83E3FB;      ;
                       LDY.W #$0000                         ;83E3FE;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E401;848097;
                       RTS                                  ;83E405;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E406: RTS                                  ;83E406;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83E407;      ;
                       LDA.L $7F1F5C                        ;83E409;7F1F5C;
                       AND.W #$FF7F                         ;83E40D;      ;
                       STA.L $7F1F5C                        ;83E410;7F1F5C;
                       %Set16bit(!MX)                             ;83E414;      ;
                       LDA.W #$0015                         ;83E416;      ;
                       LDX.W #$0000                         ;83E419;      ;
                       LDY.W #$0015                         ;83E41C;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E41F;848097;
                       %Set16bit(!M)                             ;83E423;      ;
                       LDA.L $7F1F68                        ;83E425;7F1F68;
                       AND.W #$0001                         ;83E429;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E464                      ;83E42C;83E464;
                       LDA.L $7F1F68                        ;83E42E;7F1F68;
                       AND.W #$0010                         ;83E432;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E454                      ;83E435;83E454;
                       %Set16bit(!MX)                             ;83E437;      ;
                       LDA.W #$0000                         ;83E439;      ;
                       LDX.W #$000A                         ;83E43C;      ;
                       LDY.W #$0001                         ;83E43F;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E442;848097;
                       %Set16bit(!M)                             ;83E446;      ;
                       LDA.L $7F1F68                        ;83E448;7F1F68;
                       ORA.W #$0010                         ;83E44C;      ;
                       STA.L $7F1F68                        ;83E44F;7F1F68;
                       RTS                                  ;83E453;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E454: %Set16bit(!MX)                             ;83E454;      ;
                       LDA.W #$0000                         ;83E456;      ;
                       LDX.W #$000B                         ;83E459;      ;
                       LDY.W #$000B                         ;83E45C;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E45F;848097;
                       RTS                                  ;83E463;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E464: %Set8bit(!M)                             ;83E464;      ;
                       %Set16bit(!X)                             ;83E466;      ;
                       LDA.L !year                        ;83E468;7F1F18;
                       BNE Bank83_NpcSpriteLogicBranch_83E478                      ;83E46C;83E478;
                       %Set8bit(!M)                             ;83E46E;      ;
                       LDA.L !season                        ;83E470;7F1F19;
                       CMP.B #$03                           ;83E474;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E4CA                      ;83E476;83E4CA;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E478: %Set16bit(!M)                             ;83E478;      ;
                       LDA.L $7F1F68                        ;83E47A;7F1F68;
                       AND.W #$0040                         ;83E47E;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E4A7                      ;83E481;83E4A7;
                       %Set16bit(!MX)                             ;83E483;      ;
                       LDA.W #$0000                         ;83E485;      ;
                       LDX.W #$000D                         ;83E488;      ;
                       LDY.W #$0000                         ;83E48B;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E48E;848097;
                       %Set16bit(!M)                             ;83E492;      ;
                       LDA.L $7F1F68                        ;83E494;7F1F68;
                       ORA.W #$0040                         ;83E498;      ;
                       STA.L $7F1F68                        ;83E49B;7F1F68;
                       %Set8bit(!M)                             ;83E49F;      ;
                       LDA.B #$04                           ;83E4A1;      ;
                       STA.W $099F                          ;83E4A3;00099F;
                       RTS                                  ;83E4A6;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E4A7: %Set16bit(!MX)                             ;83E4A7;      ;
                       LDA.L $7F1F68                        ;83E4A9;7F1F68;
                       AND.W #$0100                         ;83E4AD;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E4CA                      ;83E4B0;83E4CA;
                       %Set16bit(!MX)                             ;83E4B2;      ;
                       LDA.W #$0000                         ;83E4B4;      ;
                       LDX.W #$000D                         ;83E4B7;      ;
                       LDY.W #$0001                         ;83E4BA;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E4BD;848097;
                       %Set8bit(!M)                             ;83E4C1;      ;
                       LDA.B #$00                           ;83E4C3;      ;
                       STA.L $7F1F31                        ;83E4C5;7F1F31;
                       RTS                                  ;83E4C9;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E4CA: RTS                                  ;83E4CA;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83E4CB;      ;
                       LDA.L $7F1F6A                        ;83E4CD;7F1F6A;
                       AND.W #$0040                         ;83E4D1;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E4EF                      ;83E4D4;83E4EF;
                       LDA.W #$00E0                         ;83E4D6;      ;
                       STA.W !tile_in_front_X                          ;83E4D9;000985;
                       LDA.W #$0180                         ;83E4DC;      ;
                       STA.W !tile_in_front_Y                          ;83E4DF;000987;
                       LDA.W #$0010                         ;83E4E2;      ;
                       LDX.W #$0000                         ;83E4E5;      ;
                       LDY.W #$001F                         ;83E4E8;      ;
                       JSL.L EventScript_LoadScriptPointerForFacingTile                    ;83E4EB;8480F8;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E4EF: %Set16bit(!MX)                             ;83E4EF;      ;
                       LDA.B !player_pos_Y                            ;83E4F1;0000D8;
                       CMP.W #$0200                         ;83E4F3;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83E535                      ;83E4F6;83E535;
                       %Set16bit(!MX)                             ;83E4F8;      ;
                       LDA.B !game_state                            ;83E4FA;0000D2;
                       AND.W #$0800                         ;83E4FC;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E504                      ;83E4FF;83E504;
                       JMP.W Bank83_NpcSpriteLogicBranch_83E535                    ;83E501;83E535;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E504: %Set16bit(!MX)                             ;83E504;      ;
                       LDA.W #$0800                         ;83E506;      ;
                       EOR.W #$FFFF                         ;83E509;      ;
                       AND.B !game_state                            ;83E50C;0000D2;
                       STA.B !game_state                            ;83E50E;0000D2;
                       %Set8bit(!M)                             ;83E510;      ;
                       LDA.L !season                        ;83E512;7F1F19;
                       STA.L !dog_map                        ;83E516;7F1F30;
                       %Set16bit(!MX)                             ;83E51A;      ;
                       LDA.W #$0078                         ;83E51C;      ;
                       STA.L !dog_pos_X                        ;83E51F;7F1F2C;
                       LDA.W #$01A8                         ;83E523;      ;
                       STA.L !dog_pos_Y                        ;83E526;7F1F2E;
                       %Set16bit(!MX)                             ;83E52A;      ;
                       LDA.W #$0000                         ;83E52C;      ;
                       CLC                                  ;83E52F;      ;
                       ADC.B !player_direction                            ;83E530;0000DA;
                       STA.W $0901                          ;83E532;000901;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E535: %Set16bit(!MX)                             ;83E535;      ;
                       LDA.L !family_event_flags                        ;83E537;7F1F6C;
                       AND.W #$0010                         ;83E53B;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83E550                      ;83E53E;83E550;
                       %Set16bit(!MX)                             ;83E540;      ;
                       LDA.W #$0000                         ;83E542;      ;
                       LDX.W #$001D                         ;83E545;      ;
                       LDY.W #$0002                         ;83E548;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E54B;848097;
                       RTS                                  ;83E54F;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E550: %Set16bit(!MX)                             ;83E550;      ;
                       LDA.L !family_event_flags                        ;83E552;7F1F6C;
                       AND.W #$0001                         ;83E556;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83E56B                      ;83E559;83E56B;
                       %Set16bit(!MX)                             ;83E55B;      ;
                       LDA.W #$0000                         ;83E55D;      ;
                       LDX.W #$001B                         ;83E560;      ;
                       LDY.W #$0001                         ;83E563;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E566;848097;
                       RTS                                  ;83E56A;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E56B: %Set8bit(!M)                             ;83E56B;      ;
                       LDA.L !weekday                        ;83E56D;7F1F1A;
                       CMP.B #$06                           ;83E571;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E585                      ;83E573;83E585;
                       %Set16bit(!MX)                             ;83E575;      ;
                       LDA.W #$0000                         ;83E577;      ;
                       LDX.W #$0002                         ;83E57A;      ;
                       LDY.W #$0004                         ;83E57D;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E580;848097;
                       RTS                                  ;83E584;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E585: RTS                                  ;83E585;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83E586;      ;
                       LDA.L $7F1F68                        ;83E588;7F1F68;
                       AND.W #$0200                         ;83E58C;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83E5A1                      ;83E58F;83E5A1;
                       %Set16bit(!MX)                             ;83E591;      ;
                       LDA.W #$0000                         ;83E593;      ;
                       LDX.W #$0014                         ;83E596;      ;
                       LDY.W #$0001                         ;83E599;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E59C;848097;
                       RTS                                  ;83E5A0;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E5A1: RTS                                  ;83E5A1;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83E5A2;      ;
                       %Set16bit(!MX)                             ;83E5A4;      ;
                       LDA.W #$0000                         ;83E5A6;      ;
                       LDX.W #$0014                         ;83E5A9;      ;
                       LDY.W #$0002                         ;83E5AC;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E5AF;848097;
                       RTS                                  ;83E5B3;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83E5B4;      ;
                       LDA.L $7F1F6A                        ;83E5B6;7F1F6A;
                       AND.W #$4000                         ;83E5BA;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83E5CC                      ;83E5BD;83E5CC;
                       LDA.W #$0015                         ;83E5BF;      ;
                       LDX.W #$0000                         ;83E5C2;      ;
                       LDY.W #$007F                         ;83E5C5;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E5C8;848097;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E5CC: RTS                                  ;83E5CC;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83E5CD;      ;
                       %Set16bit(!MX)                             ;83E5CF;      ;
                       LDA.W #$0000                         ;83E5D1;      ;
                       LDX.W #$001E                         ;83E5D4;      ;
                       LDY.W #$0000                         ;83E5D7;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E5DA;848097;
                       RTS                                  ;83E5DE;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83E5DF;      ;
                       %Set16bit(!MX)                             ;83E5E1;      ;
                       LDA.W #$0000                         ;83E5E3;      ;
                       LDX.W #$000E                         ;83E5E6;      ;
                       LDY.W #$0001                         ;83E5E9;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E5EC;848097;
                       RTS                                  ;83E5F0;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83E5F1;      ;
                       %Set16bit(!MX)                             ;83E5F3;      ;
                       LDA.W #$0000                         ;83E5F5;      ;
                       LDX.W #$0026                         ;83E5F8;      ;
                       LDY.W #$0001                         ;83E5FB;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E5FE;848097;
                       RTS                                  ;83E602;      ;
                                                            ;      ;      ;
                       %Set8bit(!M)                             ;83E603;      ;
                       %Set16bit(!X)                             ;83E605;      ;
                       LDA.L !season                        ;83E607;7F1F19;
                       CMP.B #$03                           ;83E60B;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E631                      ;83E60D;83E631;
                       LDA.L !day                        ;83E60F;7F1F1B;
                       CMP.B #$18                           ;83E613;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E631                      ;83E615;83E631;
                       %Set16bit(!M)                             ;83E617;      ;
                       LDA.L $7F1F74                        ;83E619;7F1F74;
                       AND.W #$0001                         ;83E61D;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83E631                      ;83E620;83E631;
                       %Set16bit(!MX)                             ;83E622;      ;
                       LDA.W #$0000                         ;83E624;      ;
                       LDX.W #$000F                         ;83E627;      ;
                       LDY.W #$0001                         ;83E62A;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E62D;848097;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E631: RTS                                  ;83E631;      ;
                                                            ;      ;      ;
                       %Set8bit(!M)                             ;83E632;      ;
                       %Set16bit(!X)                             ;83E634;      ;
                       LDA.L !season                        ;83E636;7F1F19;
                       CMP.B #$03                           ;83E63A;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E660                      ;83E63C;83E660;
                       LDA.L !day                        ;83E63E;7F1F1B;
                       CMP.B #$18                           ;83E642;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E660                      ;83E644;83E660;
                       %Set16bit(!M)                             ;83E646;      ;
                       LDA.L $7F1F74                        ;83E648;7F1F74;
                       AND.W #$0008                         ;83E64C;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83E660                      ;83E64F;83E660;
                       %Set16bit(!MX)                             ;83E651;      ;
                       LDA.W #$0000                         ;83E653;      ;
                       LDX.W #$000F                         ;83E656;      ;
                       LDY.W #$0004                         ;83E659;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E65C;848097;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E660: RTS                                  ;83E660;      ;
                                                            ;      ;      ;
                       %Set8bit(!M)                             ;83E661;      ;
                       %Set16bit(!X)                             ;83E663;      ;
                       LDA.L !season                        ;83E665;7F1F19;
                       CMP.B #$03                           ;83E669;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E68F                      ;83E66B;83E68F;
                       LDA.L !day                        ;83E66D;7F1F1B;
                       CMP.B #$18                           ;83E671;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E68F                      ;83E673;83E68F;
                       %Set16bit(!M)                             ;83E675;      ;
                       LDA.L $7F1F74                        ;83E677;7F1F74;
                       AND.W #$0010                         ;83E67B;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83E68F                      ;83E67E;83E68F;
                       %Set16bit(!MX)                             ;83E680;      ;
                       LDA.W #$0000                         ;83E682;      ;
                       LDX.W #$000F                         ;83E685;      ;
                       LDY.W #$0005                         ;83E688;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E68B;848097;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E68F: RTS                                  ;83E68F;      ;
                                                            ;      ;      ;
                       %Set8bit(!M)                             ;83E690;      ;
                       %Set16bit(!X)                             ;83E692;      ;
                       LDA.L !season                        ;83E694;7F1F19;
                       BNE Bank83_NpcSpriteLogicBranch_83E6B1                      ;83E698;83E6B1;
                       LDA.L !day                        ;83E69A;7F1F1B;
                       CMP.B #$01                           ;83E69E;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E6B1                      ;83E6A0;83E6B1;
                       %Set16bit(!MX)                             ;83E6A2;      ;
                       LDA.W #$0000                         ;83E6A4;      ;
                       LDX.W #$0028                         ;83E6A7;      ;
                       LDY.W #$0001                         ;83E6AA;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E6AD;848097;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E6B1: RTS                                  ;83E6B1;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83E6B2;      ;
                       %Set16bit(!MX)                             ;83E6B4;      ;
                       LDA.W #$0000                         ;83E6B6;      ;
                       LDX.W #$0028                         ;83E6B9;      ;
                       LDY.W #$0003                         ;83E6BC;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E6BF;848097;
                       RTS                                  ;83E6C3;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83E6C4;      ;
                       LDA.L !child_flags                        ;83E6C6;7F1F6E;
                       AND.W #$0002                         ;83E6CA;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E705                      ;83E6CD;83E705;
                       LDA.L !marriage_flags                        ;83E6CF;7F1F66;
                       AND.W #$0002                         ;83E6D3;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E6E3                      ;83E6D6;83E6E3;
                       LDA.L !marriage_flags                        ;83E6D8;7F1F66;
                       AND.W #$0010                         ;83E6DC;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83E6F4                      ;83E6DF;83E6F4;
                       BRA Bank83_NpcSpriteLogicBranch_83E705                      ;83E6E1;83E705;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E6E3: %Set16bit(!MX)                             ;83E6E3;      ;
                       LDA.W #$0013                         ;83E6E5;      ;
                       LDX.W #$0044                         ;83E6E8;      ;
                       LDY.W #$0001                         ;83E6EB;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E6EE;848097;
                       BRA Bank83_NpcSpriteLogicBranch_83E705                      ;83E6F2;83E705;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E6F4: %Set16bit(!MX)                             ;83E6F4;      ;
                       LDA.W #$0013                         ;83E6F6;      ;
                       LDX.W #$0044                         ;83E6F9;      ;
                       LDY.W #$0004                         ;83E6FC;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E6FF;848097;
                       BRA Bank83_NpcSpriteLogicBranch_83E705                      ;83E703;83E705;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E705: %Set16bit(!MX)                             ;83E705;      ;
                       LDA.L !child_flags                        ;83E707;7F1F6E;
                       AND.W #$0004                         ;83E70B;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83E728                      ;83E70E;83E728;
                       LDA.L !kid1_age                        ;83E710;7F1F37;
                       CMP.W #$003C                         ;83E714;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83E728                      ;83E717;83E728;
                       %Set16bit(!MX)                             ;83E719;      ;
                       LDA.W #$0014                         ;83E71B;      ;
                       LDX.W #$0045                         ;83E71E;      ;
                       LDY.W #$0002                         ;83E721;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E724;848097;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E728: %Set16bit(!MX)                             ;83E728;      ;
                       LDA.L !child_flags                        ;83E72A;7F1F6E;
                       AND.W #$0008                         ;83E72E;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83E74B                      ;83E731;83E74B;
                       LDA.L !kid2_age                        ;83E733;7F1F39;
                       CMP.W #$003C                         ;83E737;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83E74B                      ;83E73A;83E74B;
                       %Set16bit(!MX)                             ;83E73C;      ;
                       LDA.W #$0015                         ;83E73E;      ;
                       LDX.W #$0045                         ;83E741;      ;
                       LDY.W #$0005                         ;83E744;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E747;848097;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83E74B: RTS                                  ;83E74B;      ;
                                                            ;      ;      ;
                       RTS                                  ;83E74C;      ;
                                                            ;      ;      ;
                       db $01,$00,$02,$00,$04,$00,$08,$00,$10,$00,$20,$00,$40,$00,$80,$00;83E74D;      ;
                       db $00,$01,$00,$02,$00,$04,$00,$08,$00,$10,$00,$20,$00,$40,$00,$80;83E75D;      ;
                       db $E2,$20,$C2,$10,$E2,$20,$A9,$07,$8F,$1C,$1F,$7F,$A9,$00,$8F,$1D;83E76D;      ;
                       db $1F,$7F,$A9,$00,$8F,$1E,$1F,$7F,$C2,$20,$9C,$15,$09,$64,$D2,$64;83E77D;      ;
                       db $D4,$E2,$20,$AD,$17,$09,$8D,$18,$09,$9C,$25,$09,$C2,$30,$A5,$D2;83E78D;      ;
                       db $09,$01,$00,$85,$D2,$C2,$30,$A9,$00,$00,$85,$D4,$C2,$30,$A9,$00;83E79D;      ;
                       db $00,$85,$DA,$C2,$30,$A9,$00,$00,$8D,$11,$09,$C2,$30,$A9,$00,$00;83E7AD;      ;
                       db $8D,$01,$09,$E2,$20,$9C,$73,$09,$E2,$20,$9C,$1D,$09,$C2,$30,$A9;83E7BD;      ;
                       db $02,$00,$49,$FF,$FF,$25,$D2,$85,$D2,$E2,$20,$AF,$49,$1F,$7F,$D0;83E7CD;      ;
                       db $03,$4C,$AD,$E8,$C9,$01,$D0,$03,$4C,$C5,$E8,$C9,$02,$D0,$03,$4C;83E7DD;      ;
                       db $DD,$E8,$C9,$03,$D0,$03,$4C,$F5,$E8,$C9,$04,$D0,$03,$4C,$0D,$E9;83E7ED;      ;
                       db $C9,$05,$D0,$03,$4C,$25,$E9,$C9,$06,$D0,$03,$4C,$3D,$E9,$C9,$07;83E7FD;      ;
                       db $D0,$03,$4C,$55,$E9,$C9,$08,$D0,$03,$4C,$8D,$E9,$C9,$09,$D0,$03;83E80D;      ;
                       db $4C,$A5,$E9,$C9,$0A,$D0,$03,$4C,$BD,$E9,$C9,$0B,$D0,$03,$4C,$D5;83E81D;      ;
                       db $E9,$C9,$0C,$D0,$03,$4C,$ED,$E9,$C9,$0D,$D0,$03,$4C,$05,$EA,$C9;83E82D;      ;
                       db $0E,$D0,$03,$4C,$3D,$EA,$C9,$0F,$D0,$03,$4C,$55,$EA,$C9,$10,$D0;83E83D;      ;
                       db $03,$4C,$6D,$EA,$C9,$11,$D0,$03,$4C,$85,$EA,$C9,$12,$D0,$03,$4C;83E84D;      ;
                       db $9D,$EA,$C9,$13,$D0,$03,$4C,$B5,$EA,$C9,$14,$D0,$03,$4C,$CD,$EA;83E85D;      ;
                       db $C9,$15,$D0,$03,$4C,$E5,$EA,$C9,$16,$D0,$03,$4C,$FD,$EA,$C9,$17;83E86D;      ;
                       db $D0,$03,$4C,$15,$EB,$C9,$18,$D0,$03,$4C,$2D,$EB,$C9,$19,$D0,$03;83E87D;      ;
                       db $4C,$45,$EB,$C9,$1A,$D0,$03,$4C,$5D,$EB,$C9,$1B,$D0,$03,$4C,$75;83E88D;      ;
                                                            ;      ;      ;
                       db $EB,$C9,$1C,$D0,$03,$4C,$8D,$EB,$C9,$1D,$D0,$03,$4C,$A5,$EB,$60;83E89D;      ;
                       %Set16bit(!MX)                             ;83E8AD;      ;
                       LDA.W #$0000                         ;83E8AF;      ;
                       LDX.W #$0047                         ;83E8B2;      ;
                       LDY.W #$0001                         ;83E8B5;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E8B8;848097;
                       %Set8bit(!M)                             ;83E8BC;      ;
                       LDA.B #$01                           ;83E8BE;      ;
                       STA.L $7F1F49                        ;83E8C0;7F1F49;
                       RTS                                  ;83E8C4;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83E8C5;      ;
                       LDA.W #$0000                         ;83E8C7;      ;
                       LDX.W #$0047                         ;83E8CA;      ;
                       LDY.W #$0002                         ;83E8CD;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E8D0;848097;
                       %Set8bit(!M)                             ;83E8D4;      ;
                       LDA.B #$02                           ;83E8D6;      ;
                       STA.L $7F1F49                        ;83E8D8;7F1F49;
                       RTS                                  ;83E8DC;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83E8DD;      ;
                       LDA.W #$0000                         ;83E8DF;      ;
                       LDX.W #$0047                         ;83E8E2;      ;
                       LDY.W #$0003                         ;83E8E5;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E8E8;848097;
                       %Set8bit(!M)                             ;83E8EC;      ;
                       LDA.B #$03                           ;83E8EE;      ;
                       STA.L $7F1F49                        ;83E8F0;7F1F49;
                       RTS                                  ;83E8F4;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83E8F5;      ;
                       LDA.W #$0000                         ;83E8F7;      ;
                       LDX.W #$0047                         ;83E8FA;      ;
                       LDY.W #$0004                         ;83E8FD;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E900;848097;
                       %Set8bit(!M)                             ;83E904;      ;
                       LDA.B #$04                           ;83E906;      ;
                       STA.L $7F1F49                        ;83E908;7F1F49;
                       RTS                                  ;83E90C;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83E90D;      ;
                       LDA.W #$0000                         ;83E90F;      ;
                       LDX.W #$0047                         ;83E912;      ;
                       LDY.W #$0005                         ;83E915;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E918;848097;
                       %Set8bit(!M)                             ;83E91C;      ;
                       LDA.B #$05                           ;83E91E;      ;
                       STA.L $7F1F49                        ;83E920;7F1F49;
                       RTS                                  ;83E924;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83E925;      ;
                       LDA.W #$0000                         ;83E927;      ;
                       LDX.W #$0047                         ;83E92A;      ;
                       LDY.W #$0006                         ;83E92D;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E930;848097;
                       %Set8bit(!M)                             ;83E934;      ;
                       LDA.B #$06                           ;83E936;      ;
                       STA.L $7F1F49                        ;83E938;7F1F49;
                       RTS                                  ;83E93C;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83E93D;      ;
                       LDA.W #$0000                         ;83E93F;      ;
                       LDX.W #$0047                         ;83E942;      ;
                       LDY.W #$0007                         ;83E945;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E948;848097;
                       %Set8bit(!M)                             ;83E94C;      ;
                       LDA.B #$07                           ;83E94E;      ;
                       STA.L $7F1F49                        ;83E950;7F1F49;
                       RTS                                  ;83E954;      ;
                                                            ;      ;      ;
                       %Set8bit(!M)                             ;83E955;      ;
                       LDA.B #$3D                           ;83E957;      ;
                       STA.L !shed_items_row_1                        ;83E959;7F1F00;
                       LDA.B #$00                           ;83E95D;      ;
                       STA.L !shed_items_row_2                        ;83E95F;7F1F01;
                       LDA.B #$12                           ;83E963;      ;
                       STA.L !shed_items_row_3                        ;83E965;7F1F02;
                       LDA.B #$00                           ;83E969;      ;
                       STA.L !shed_items_row_4                        ;83E96B;7F1F03;
                       STZ.W !tool_selected                          ;83E96F;000921;
                       STZ.W !tool_backpack                          ;83E972;000923;
                       %Set16bit(!MX)                             ;83E975;      ;
                       LDA.W #$0000                         ;83E977;      ;
                       LDX.W #$0047                         ;83E97A;      ;
                       LDY.W #$0008                         ;83E97D;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E980;848097;
                       %Set8bit(!M)                             ;83E984;      ;
                       LDA.B #$08                           ;83E986;      ;
                       STA.L $7F1F49                        ;83E988;7F1F49;
                       RTS                                  ;83E98C;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83E98D;      ;
                       LDA.W #$0000                         ;83E98F;      ;
                       LDX.W #$0047                         ;83E992;      ;
                       LDY.W #$0009                         ;83E995;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E998;848097;
                       %Set8bit(!M)                             ;83E99C;      ;
                       LDA.B #$09                           ;83E99E;      ;
                       STA.L $7F1F49                        ;83E9A0;7F1F49;
                       RTS                                  ;83E9A4;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83E9A5;      ;
                       LDA.W #$0000                         ;83E9A7;      ;
                       LDX.W #$0047                         ;83E9AA;      ;
                       LDY.W #$000A                         ;83E9AD;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E9B0;848097;
                       %Set8bit(!M)                             ;83E9B4;      ;
                       LDA.B #$0A                           ;83E9B6;      ;
                       STA.L $7F1F49                        ;83E9B8;7F1F49;
                       RTS                                  ;83E9BC;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83E9BD;      ;
                       LDA.W #$0000                         ;83E9BF;      ;
                       LDX.W #$0047                         ;83E9C2;      ;
                       LDY.W #$000B                         ;83E9C5;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E9C8;848097;
                       %Set8bit(!M)                             ;83E9CC;      ;
                       LDA.B #$0B                           ;83E9CE;      ;
                       STA.L $7F1F49                        ;83E9D0;7F1F49;
                       RTS                                  ;83E9D4;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83E9D5;      ;
                       LDA.W #$0000                         ;83E9D7;      ;
                       LDX.W #$0047                         ;83E9DA;      ;
                       LDY.W #$000C                         ;83E9DD;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E9E0;848097;
                       %Set8bit(!M)                             ;83E9E4;      ;
                       LDA.B #$0C                           ;83E9E6;      ;
                       STA.L $7F1F49                        ;83E9E8;7F1F49;
                       RTS                                  ;83E9EC;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83E9ED;      ;
                       LDA.W #$0000                         ;83E9EF;      ;
                       LDX.W #$0047                         ;83E9F2;      ;
                       LDY.W #$000D                         ;83E9F5;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83E9F8;848097;
                       %Set8bit(!M)                             ;83E9FC;      ;
                       LDA.B #$0D                           ;83E9FE;      ;
                       STA.L $7F1F49                        ;83EA00;7F1F49;
                       RTS                                  ;83EA04;      ;
                                                            ;      ;      ;
                       %Set8bit(!M)                             ;83EA05;      ;
                       LDA.B #$0D                           ;83EA07;      ;
                       STA.L !shed_items_row_1                        ;83EA09;7F1F00;
                       LDA.B #$64                           ;83EA0D;      ;
                       STA.L !shed_items_row_2                        ;83EA0F;7F1F01;
                       LDA.B #$12                           ;83EA13;      ;
                       STA.L !shed_items_row_3                        ;83EA15;7F1F02;
                       LDA.B #$00                           ;83EA19;      ;
                       STA.L !shed_items_row_4                        ;83EA1B;7F1F03;
                       STZ.W !tool_selected                          ;83EA1F;000921;
                       STZ.W !tool_backpack                          ;83EA22;000923;
                       %Set16bit(!MX)                             ;83EA25;      ;
                       LDA.W #$0000                         ;83EA27;      ;
                       LDX.W #$0047                         ;83EA2A;      ;
                       LDY.W #$000E                         ;83EA2D;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EA30;848097;
                       %Set8bit(!M)                             ;83EA34;      ;
                       LDA.B #$0E                           ;83EA36;      ;
                       STA.L $7F1F49                        ;83EA38;7F1F49;
                       RTS                                  ;83EA3C;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83EA3D;      ;
                       LDA.W #$0000                         ;83EA3F;      ;
                       LDX.W #$0047                         ;83EA42;      ;
                       LDY.W #$000F                         ;83EA45;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EA48;848097;
                       %Set8bit(!M)                             ;83EA4C;      ;
                       LDA.B #$0F                           ;83EA4E;      ;
                       STA.L $7F1F49                        ;83EA50;7F1F49;
                       RTS                                  ;83EA54;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83EA55;      ;
                       LDA.W #$0000                         ;83EA57;      ;
                       LDX.W #$0047                         ;83EA5A;      ;
                       LDY.W #$0010                         ;83EA5D;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EA60;848097;
                       %Set8bit(!M)                             ;83EA64;      ;
                       LDA.B #$10                           ;83EA66;      ;
                       STA.L $7F1F49                        ;83EA68;7F1F49;
                       RTS                                  ;83EA6C;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83EA6D;      ;
                       LDA.W #$0000                         ;83EA6F;      ;
                       LDX.W #$0047                         ;83EA72;      ;
                       LDY.W #$0011                         ;83EA75;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EA78;848097;
                       %Set8bit(!M)                             ;83EA7C;      ;
                       LDA.B #$11                           ;83EA7E;      ;
                       STA.L $7F1F49                        ;83EA80;7F1F49;
                       RTS                                  ;83EA84;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83EA85;      ;
                       LDA.W #$0000                         ;83EA87;      ;
                       LDX.W #$0047                         ;83EA8A;      ;
                       LDY.W #$0012                         ;83EA8D;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EA90;848097;
                       %Set8bit(!M)                             ;83EA94;      ;
                       LDA.B #$12                           ;83EA96;      ;
                       STA.L $7F1F49                        ;83EA98;7F1F49;
                       RTS                                  ;83EA9C;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83EA9D;      ;
                       LDA.W #$0000                         ;83EA9F;      ;
                       LDX.W #$0047                         ;83EAA2;      ;
                       LDY.W #$0013                         ;83EAA5;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EAA8;848097;
                       %Set8bit(!M)                             ;83EAAC;      ;
                       LDA.B #$13                           ;83EAAE;      ;
                       STA.L $7F1F49                        ;83EAB0;7F1F49;
                       RTS                                  ;83EAB4;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83EAB5;      ;
                       LDA.W #$0000                         ;83EAB7;      ;
                       LDX.W #$0047                         ;83EABA;      ;
                       LDY.W #$0014                         ;83EABD;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EAC0;848097;
                       %Set8bit(!M)                             ;83EAC4;      ;
                       LDA.B #$14                           ;83EAC6;      ;
                       STA.L $7F1F49                        ;83EAC8;7F1F49;
                       RTS                                  ;83EACC;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83EACD;      ;
                       LDA.W #$0000                         ;83EACF;      ;
                       LDX.W #$0047                         ;83EAD2;      ;
                       LDY.W #$0015                         ;83EAD5;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EAD8;848097;
                       %Set8bit(!M)                             ;83EADC;      ;
                       LDA.B #$15                           ;83EADE;      ;
                       STA.L $7F1F49                        ;83EAE0;7F1F49;
                       RTS                                  ;83EAE4;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83EAE5;      ;
                       LDA.W #$0000                         ;83EAE7;      ;
                       LDX.W #$0047                         ;83EAEA;      ;
                       LDY.W #$0016                         ;83EAED;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EAF0;848097;
                       %Set8bit(!M)                             ;83EAF4;      ;
                       LDA.B #$16                           ;83EAF6;      ;
                       STA.L $7F1F49                        ;83EAF8;7F1F49;
                       RTS                                  ;83EAFC;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83EAFD;      ;
                       LDA.W #$0000                         ;83EAFF;      ;
                       LDX.W #$0047                         ;83EB02;      ;
                       LDY.W #$0017                         ;83EB05;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EB08;848097;
                       %Set8bit(!M)                             ;83EB0C;      ;
                       LDA.B #$17                           ;83EB0E;      ;
                       STA.L $7F1F49                        ;83EB10;7F1F49;
                       RTS                                  ;83EB14;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83EB15;      ;
                       LDA.W #$0000                         ;83EB17;      ;
                       LDX.W #$0047                         ;83EB1A;      ;
                       LDY.W #$0018                         ;83EB1D;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EB20;848097;
                       %Set8bit(!M)                             ;83EB24;      ;
                       LDA.B #$18                           ;83EB26;      ;
                       STA.L $7F1F49                        ;83EB28;7F1F49;
                       RTS                                  ;83EB2C;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83EB2D;      ;
                       LDA.W #$0000                         ;83EB2F;      ;
                       LDX.W #$0047                         ;83EB32;      ;
                       LDY.W #$0019                         ;83EB35;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EB38;848097;
                       %Set8bit(!M)                             ;83EB3C;      ;
                       LDA.B #$19                           ;83EB3E;      ;
                       STA.L $7F1F49                        ;83EB40;7F1F49;
                       RTS                                  ;83EB44;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83EB45;      ;
                       LDA.W #$0000                         ;83EB47;      ;
                       LDX.W #$0047                         ;83EB4A;      ;
                       LDY.W #$001A                         ;83EB4D;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EB50;848097;
                       %Set8bit(!M)                             ;83EB54;      ;
                       LDA.B #$1A                           ;83EB56;      ;
                       STA.L $7F1F49                        ;83EB58;7F1F49;
                       RTS                                  ;83EB5C;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83EB5D;      ;
                       LDA.W #$0000                         ;83EB5F;      ;
                       LDX.W #$0047                         ;83EB62;      ;
                       LDY.W #$001B                         ;83EB65;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EB68;848097;
                       %Set8bit(!M)                             ;83EB6C;      ;
                       LDA.B #$1B                           ;83EB6E;      ;
                       STA.L $7F1F49                        ;83EB70;7F1F49;
                       RTS                                  ;83EB74;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83EB75;      ;
                       LDA.W #$0000                         ;83EB77;      ;
                       LDX.W #$0047                         ;83EB7A;      ;
                       LDY.W #$001C                         ;83EB7D;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EB80;848097;
                       %Set8bit(!M)                             ;83EB84;      ;
                       LDA.B #$1C                           ;83EB86;      ;
                       STA.L $7F1F49                        ;83EB88;7F1F49;
                       RTS                                  ;83EB8C;      ;
                                                            ;      ;      ;
                       %Set16bit(!MX)                             ;83EB8D;      ;
                       LDA.W #$0000                         ;83EB8F;      ;
                       LDX.W #$0047                         ;83EB92;      ;
                       LDY.W #$001D                         ;83EB95;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EB98;848097;
                       %Set8bit(!M)                             ;83EB9C;      ;
                       LDA.B #$1D                           ;83EB9E;      ;
                       STA.L $7F1F49                        ;83EBA0;7F1F49;
                       RTS                                  ;83EBA4;      ;
                                                            ;      ;      ;
                       RTS                                  ;83EBA5;      ;
                                                            ;      ;      ;
                       %Set8bit(!M)                             ;83EBA6;      ;
                       %Set16bit(!X)                             ;83EBA8;      ;
                       %Set8bit(!M)                             ;83EBAA;      ;
                       LDA.B #$06                           ;83EBAC;      ;
                       STA.L !hour                        ;83EBAE;7F1F1C;
                       LDA.B #$00                           ;83EBB2;      ;
                       STA.L !minutes                        ;83EBB4;7F1F1D;
                       LDA.B #$00                           ;83EBB8;      ;
                       STA.L !seconds                        ;83EBBA;7F1F1E;
                       %Set16bit(!M)                             ;83EBBE;      ;
                       STZ.W $0915                          ;83EBC0;000915;
                       STZ.B !game_state                            ;83EBC3;0000D2;
                       STZ.B !player_action                            ;83EBC5;0000D4;
                       %Set8bit(!M)                             ;83EBC7;      ;
                       LDA.W !max_stamina                          ;83EBC9;000917;
                       STA.W !current_stamina                          ;83EBCC;000918;
                       STZ.W !idle_animation_timer                          ;83EBCF;000925;
                       %Set16bit(!MX)                             ;83EBD2;      ;
                       LDA.B !game_state                            ;83EBD4;0000D2;
                       ORA.W #$0001                         ;83EBD6;      ;
                       STA.B !game_state                            ;83EBD9;0000D2;
                       %Set16bit(!MX)                             ;83EBDB;      ;
                       LDA.W #$0000                         ;83EBDD;      ;
                       STA.B !player_action                            ;83EBE0;0000D4;
                       %Set16bit(!MX)                             ;83EBE2;      ;
                       LDA.W #$0000                         ;83EBE4;      ;
                       STA.B !player_direction                            ;83EBE7;0000DA;
                       %Set16bit(!MX)                             ;83EBE9;      ;
                       LDA.W #$0000                         ;83EBEB;      ;
                       STA.W $0911                          ;83EBEE;000911;
                       %Set16bit(!MX)                             ;83EBF1;      ;
                       LDA.W #$0000                         ;83EBF3;      ;
                       STA.W $0901                          ;83EBF6;000901;
                       %Set8bit(!M)                             ;83EBF9;      ;
                       STZ.W !time_running                          ;83EBFB;000973;
                       %Set8bit(!M)                             ;83EBFE;      ;
                       STZ.W !item_on_hand                          ;83EC00;00091D;
                       %Set16bit(!MX)                             ;83EC03;      ;
                       LDA.W #$0002                         ;83EC05;      ;
                       EOR.W #$FFFF                         ;83EC08;      ;
                       AND.B !game_state                            ;83EC0B;0000D2;
                       STA.B !game_state                            ;83EC0D;0000D2;
                       %Set8bit(!M)                             ;83EC0F;      ;
                       LDA.L $7F1F47                        ;83EC11;7F1F47;
                       BNE Bank83_NpcSpriteLogicBranch_83EC1A                      ;83EC15;83EC1A;
                       JMP.W Bank83_NpcSpriteLogicBranch_83ED1E                    ;83EC17;83ED1E;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EC1A: CMP.B #$01                           ;83EC1A;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83EC21                      ;83EC1C;83EC21;
                       JMP.W Bank83_NpcSpriteLogicBranch_83ED5A                    ;83EC1E;83ED5A;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EC21: CMP.B #$02                           ;83EC21;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83EC28                      ;83EC23;83EC28;
                       JMP.W Bank83_NpcSpriteLogicBranch_83ED8B                    ;83EC25;83ED8B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EC28: CMP.B #$03                           ;83EC28;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83EC2F                      ;83EC2A;83EC2F;
                       JMP.W Bank83_NpcSpriteLogicBranch_83EDB1                    ;83EC2C;83EDB1;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EC2F: CMP.B #$04                           ;83EC2F;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83EC36                      ;83EC31;83EC36;
                       JMP.W Bank83_NpcSpriteLogicBranch_83EDD3                    ;83EC33;83EDD3;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EC36: CMP.B #$05                           ;83EC36;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83EC3D                      ;83EC38;83EC3D;
                       JMP.W Bank83_NpcSpriteLogicBranch_83EDF6                    ;83EC3A;83EDF6;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EC3D: CMP.B #$06                           ;83EC3D;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83EC44                      ;83EC3F;83EC44;
                       JMP.W Bank83_NpcSpriteLogicBranch_83EE19                    ;83EC41;83EE19;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EC44: CMP.B #$07                           ;83EC44;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83EC4B                      ;83EC46;83EC4B;
                       JMP.W Bank83_NpcSpriteLogicBranch_83EE3C                    ;83EC48;83EE3C;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EC4B: CMP.B #$08                           ;83EC4B;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83EC52                      ;83EC4D;83EC52;
                       JMP.W Bank83_NpcSpriteLogicBranch_83EE5F                    ;83EC4F;83EE5F;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EC52: CMP.B #$09                           ;83EC52;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83EC59                      ;83EC54;83EC59;
                       JMP.W Bank83_NpcSpriteLogicBranch_83EE82                    ;83EC56;83EE82;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EC59: CMP.B #$0A                           ;83EC59;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83EC60                      ;83EC5B;83EC60;
                       JMP.W Bank83_NpcSpriteLogicBranch_83EEAE                    ;83EC5D;83EEAE;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EC60: CMP.B #$0B                           ;83EC60;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83EC67                      ;83EC62;83EC67;
                       JMP.W Bank83_NpcSpriteLogicBranch_83EEDA                    ;83EC64;83EEDA;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EC67: CMP.B #$0C                           ;83EC67;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83EC6E                      ;83EC69;83EC6E;
                       JMP.W Bank83_NpcSpriteLogicBranch_83EF15                    ;83EC6B;83EF15;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EC6E: CMP.B #$0D                           ;83EC6E;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83EC75                      ;83EC70;83EC75;
                       JMP.W Bank83_NpcSpriteLogicBranch_83EF50                    ;83EC72;83EF50;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EC75: CMP.B #$0E                           ;83EC75;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83EC7C                      ;83EC77;83EC7C;
                       JMP.W Bank83_NpcSpriteLogicBranch_83EF8B                    ;83EC79;83EF8B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EC7C: CMP.B #$0F                           ;83EC7C;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83EC83                      ;83EC7E;83EC83;
                       JMP.W Bank83_NpcSpriteLogicBranch_83EFC6                    ;83EC80;83EFC6;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EC83: CMP.B #$10                           ;83EC83;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83EC8A                      ;83EC85;83EC8A;
                       JMP.W Bank83_NpcSpriteLogicBranch_83EFE9                    ;83EC87;83EFE9;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EC8A: CMP.B #$11                           ;83EC8A;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83EC91                      ;83EC8C;83EC91;
                       JMP.W Bank83_NpcSpriteLogicBranch_83F02F                    ;83EC8E;83F02F;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EC91: CMP.B #$12                           ;83EC91;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83EC98                      ;83EC93;83EC98;
                       JMP.W Bank83_NpcSpriteLogicBranch_83F052                    ;83EC95;83F052;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EC98: CMP.B #$13                           ;83EC98;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83EC9F                      ;83EC9A;83EC9F;
                       JMP.W Bank83_NpcSpriteLogicBranch_83F075                    ;83EC9C;83F075;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EC9F: CMP.B #$14                           ;83EC9F;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83ECA6                      ;83ECA1;83ECA6;
                       JMP.W Bank83_NpcSpriteLogicBranch_83F0E3                    ;83ECA3;83F0E3;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ECA6: CMP.B #$15                           ;83ECA6;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83ECAD                      ;83ECA8;83ECAD;
                       JMP.W Bank83_NpcSpriteLogicBranch_83F14B                    ;83ECAA;83F14B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ECAD: CMP.B #$16                           ;83ECAD;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83ECB4                      ;83ECAF;83ECB4;
                       JMP.W Bank83_NpcSpriteLogicBranch_83F163                    ;83ECB1;83F163;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ECB4: CMP.B #$17                           ;83ECB4;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83ECBB                      ;83ECB6;83ECBB;
                       JMP.W Bank83_NpcSpriteLogicBranch_83F17B                    ;83ECB8;83F17B;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ECBB: CMP.B #$18                           ;83ECBB;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83ECC2                      ;83ECBD;83ECC2;
                       JMP.W Bank83_NpcSpriteLogicBranch_83F193                    ;83ECBF;83F193;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ECC2: CMP.B #$19                           ;83ECC2;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83ECC9                      ;83ECC4;83ECC9;
                       JMP.W Bank83_NpcSpriteLogicBranch_83F1AB                    ;83ECC6;83F1AB;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ECC9: CMP.B #$1A                           ;83ECC9;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83ECD0                      ;83ECCB;83ECD0;
                       JMP.W Bank83_NpcSpriteLogicBranch_83F1C3                    ;83ECCD;83F1C3;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ECD0: CMP.B #$1B                           ;83ECD0;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83ECD7                      ;83ECD2;83ECD7;
                       JMP.W Bank83_NpcSpriteLogicBranch_83F1DB                    ;83ECD4;83F1DB;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ECD7: CMP.B #$1C                           ;83ECD7;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83ECDE                      ;83ECD9;83ECDE;
                       JMP.W Bank83_NpcSpriteLogicBranch_83F200                    ;83ECDB;83F200;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ECDE: CMP.B #$1D                           ;83ECDE;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83ECE5                      ;83ECE0;83ECE5;
                       JMP.W Bank83_NpcSpriteLogicBranch_83F218                    ;83ECE2;83F218;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ECE5: CMP.B #$1E                           ;83ECE5;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83ECEC                      ;83ECE7;83ECEC;
                       JMP.W Bank83_NpcSpriteLogicBranch_83F230                    ;83ECE9;83F230;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ECEC: CMP.B #$1F                           ;83ECEC;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83ECF3                      ;83ECEE;83ECF3;
                       JMP.W Bank83_NpcSpriteLogicBranch_83F248                    ;83ECF0;83F248;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ECF3: CMP.B #$20                           ;83ECF3;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83ECFA                      ;83ECF5;83ECFA;
                       JMP.W RanchEval_CalculateMasteryAndStartEnding ;83ECF7;83F26D;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ECFA: CMP.B #$21                           ;83ECFA;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83ED01                      ;83ECFC;83ED01;
                       JMP.W Bank83_NpcSpriteLogicBranch_83EEFD                    ;83ECFE;83EEFD;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ED01: CMP.B #$22                           ;83ED01;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83ED08                      ;83ED03;83ED08;
                       JMP.W Bank83_NpcSpriteLogicBranch_83EF38                    ;83ED05;83EF38;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ED08: CMP.B #$23                           ;83ED08;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83ED0F                      ;83ED0A;83ED0F;
                       JMP.W Bank83_NpcSpriteLogicBranch_83EF73                    ;83ED0C;83EF73;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ED0F: CMP.B #$24                           ;83ED0F;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83ED16                      ;83ED11;83ED16;
                       JMP.W Bank83_NpcSpriteLogicBranch_83EFAE                    ;83ED13;83EFAE;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ED16: CMP.B #$25                           ;83ED16;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83ED1D                      ;83ED18;83ED1D;
                       JMP.W Bank83_NpcSpriteLogicBranch_83F4D7                    ;83ED1A;83F4D7;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ED1D: RTS                                  ;83ED1D;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ED1E: %Set16bit(!MX)                             ;83ED1E;      ;
                       LDA.L !marriage_flags                        ;83ED20;7F1F66;
                       AND.W #$001F                         ;83ED24;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83ED5A                      ;83ED27;83ED5A;
                       LDA.L !happiness                        ;83ED29;7F1F33;
                       CMP.W #$0064                         ;83ED2D;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83ED5A                      ;83ED30;83ED5A;
                       %Set8bit(!M)                             ;83ED32;      ;
                       LDA.L !cow_N                        ;83ED34;7F1F0A;
                       BNE Bank83_NpcSpriteLogicBranch_83ED5A                      ;83ED38;83ED5A;
                       %Set8bit(!M)                             ;83ED3A;      ;
                       LDA.L !chicks_N                        ;83ED3C;7F1F0B;
                       BNE Bank83_NpcSpriteLogicBranch_83ED5A                      ;83ED40;83ED5A;
                       %Set16bit(!MX)                             ;83ED42;      ;
                       LDA.W #$0000                         ;83ED44;      ;
                       LDX.W #$002F                         ;83ED47;      ;
                       LDY.W #$0000                         ;83ED4A;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83ED4D;848097;
                       %Set8bit(!M)                             ;83ED51;      ;
                       LDA.B #$14                           ;83ED53;      ;
                       STA.L $7F1F47                        ;83ED55;7F1F47;
                       RTS                                  ;83ED59;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ED5A: %Set16bit(!M)                             ;83ED5A;      ;
                       LDA.L $7F1F5E                        ;83ED5C;7F1F5E;
                       ORA.W #$8000                         ;83ED60;      ;
                       STA.L $7F1F5E                        ;83ED63;7F1F5E;
                       %Set8bit(!M)                             ;83ED67;      ;
                       %Set16bit(!X)                             ;83ED69;      ;
                       LDA.L !cow_N                        ;83ED6B;7F1F0A;
                       CMP.B #$07                           ;83ED6F;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83ED8B                      ;83ED71;83ED8B;
                       %Set16bit(!MX)                             ;83ED73;      ;
                       LDA.W #$0000                         ;83ED75;      ;
                       LDX.W #$0030                         ;83ED78;      ;
                       LDY.W #$0000                         ;83ED7B;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83ED7E;848097;
                       %Set8bit(!M)                             ;83ED82;      ;
                       LDA.B #$02                           ;83ED84;      ;
                       STA.L $7F1F47                        ;83ED86;7F1F47;
                       RTS                                  ;83ED8A;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83ED8B: %Set8bit(!M)                             ;83ED8B;      ;
                       %Set16bit(!X)                             ;83ED8D;      ;
                       LDA.L !cow_N                        ;83ED8F;7F1F0A;
                       BEQ Bank83_NpcSpriteLogicBranch_83EDB1                      ;83ED93;83EDB1;
                       CMP.B #$07                           ;83ED95;      ;
                       BCS Bank83_NpcSpriteLogicBranch_83EDB1                      ;83ED97;83EDB1;
                       %Set16bit(!MX)                             ;83ED99;      ;
                       LDA.W #$0000                         ;83ED9B;      ;
                       LDX.W #$0031                         ;83ED9E;      ;
                       LDY.W #$0000                         ;83EDA1;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EDA4;848097;
                       %Set8bit(!M)                             ;83EDA8;      ;
                       LDA.B #$03                           ;83EDAA;      ;
                       STA.L $7F1F47                        ;83EDAC;7F1F47;
                       RTS                                  ;83EDB0;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EDB1: %Set8bit(!M)                             ;83EDB1;      ;
                       %Set16bit(!X)                             ;83EDB3;      ;
                       LDA.L !chicks_N                        ;83EDB5;7F1F0B;
                       BEQ Bank83_NpcSpriteLogicBranch_83EDD3                      ;83EDB9;83EDD3;
                       %Set16bit(!MX)                             ;83EDBB;      ;
                       LDA.W #$0000                         ;83EDBD;      ;
                       LDX.W #$0032                         ;83EDC0;      ;
                       LDY.W #$0000                         ;83EDC3;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EDC6;848097;
                       %Set8bit(!M)                             ;83EDCA;      ;
                       LDA.B #$04                           ;83EDCC;      ;
                       STA.L $7F1F47                        ;83EDCE;7F1F47;
                       RTS                                  ;83EDD2;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EDD3: %Set8bit(!M)                             ;83EDD3;      ;
                       %Set16bit(!X)                             ;83EDD5;      ;
                       LDA.W $09B5                          ;83EDD7;0009B5;
                       CMP.B #$C0                           ;83EDDA;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83EDF6                      ;83EDDC;83EDF6;
                       %Set16bit(!MX)                             ;83EDDE;      ;
                       LDA.W #$0000                         ;83EDE0;      ;
                       LDX.W #$0033                         ;83EDE3;      ;
                       LDY.W #$0000                         ;83EDE6;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EDE9;848097;
                       %Set8bit(!M)                             ;83EDED;      ;
                       LDA.B #$05                           ;83EDEF;      ;
                       STA.L $7F1F47                        ;83EDF1;7F1F47;
                       RTS                                  ;83EDF5;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EDF6: %Set16bit(!MX)                             ;83EDF6;      ;
                       LDA.L !shipped_corn                        ;83EDF8;7F1F4A;
                       CMP.W #$00C8                         ;83EDFC;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83EE19                      ;83EDFF;83EE19;
                       %Set16bit(!MX)                             ;83EE01;      ;
                       LDA.W #$0000                         ;83EE03;      ;
                       LDX.W #$0034                         ;83EE06;      ;
                       LDY.W #$0000                         ;83EE09;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EE0C;848097;
                       %Set8bit(!M)                             ;83EE10;      ;
                       LDA.B #$06                           ;83EE12;      ;
                       STA.L $7F1F47                        ;83EE14;7F1F47;
                       RTS                                  ;83EE18;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EE19: %Set16bit(!MX)                             ;83EE19;      ;
                       LDA.L !shipped_tomatoes                        ;83EE1B;7F1F4C;
                       CMP.W #$00C8                         ;83EE1F;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83EE3C                      ;83EE22;83EE3C;
                       %Set16bit(!MX)                             ;83EE24;      ;
                       LDA.W #$0000                         ;83EE26;      ;
                       LDX.W #$0035                         ;83EE29;      ;
                       LDY.W #$0000                         ;83EE2C;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EE2F;848097;
                       %Set8bit(!M)                             ;83EE33;      ;
                       LDA.B #$07                           ;83EE35;      ;
                       STA.L $7F1F47                        ;83EE37;7F1F47;
                       RTS                                  ;83EE3B;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EE3C: %Set16bit(!MX)                             ;83EE3C;      ;
                       LDA.L !shipped_turnips                        ;83EE3E;7F1F4E;
                       CMP.W #$00C8                         ;83EE42;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83EE5F                      ;83EE45;83EE5F;
                       %Set16bit(!MX)                             ;83EE47;      ;
                       LDA.W #$0000                         ;83EE49;      ;
                       LDX.W #$0037                         ;83EE4C;      ;
                       LDY.W #$0000                         ;83EE4F;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EE52;848097;
                       %Set8bit(!M)                             ;83EE56;      ;
                       LDA.B #$08                           ;83EE58;      ;
                       STA.L $7F1F47                        ;83EE5A;7F1F47;
                       RTS                                  ;83EE5E;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EE5F: %Set16bit(!MX)                             ;83EE5F;      ;
                       LDA.L !shipped_potatoes                        ;83EE61;7F1F50;
                       CMP.W #$00C8                         ;83EE65;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83EE82                      ;83EE68;83EE82;
                       %Set16bit(!MX)                             ;83EE6A;      ;
                       LDA.W #$0000                         ;83EE6C;      ;
                       LDX.W #$0036                         ;83EE6F;      ;
                       LDY.W #$0000                         ;83EE72;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EE75;848097;
                       %Set8bit(!M)                             ;83EE79;      ;
                       LDA.B #$09                           ;83EE7B;      ;
                       STA.L $7F1F47                        ;83EE7D;7F1F47;
                       RTS                                  ;83EE81;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EE82: %Set16bit(!MX)                             ;83EE82;      ;
                       LDA.L !marriage_flags                        ;83EE84;7F1F66;
                       AND.W #$001F                         ;83EE88;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83EEAE                      ;83EE8B;83EEAE;
                       LDA.L !happiness                        ;83EE8D;7F1F33;
                       CMP.W #$0064                         ;83EE91;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83EEAE                      ;83EE94;83EEAE;
                       %Set16bit(!MX)                             ;83EE96;      ;
                       LDA.W #$0000                         ;83EE98;      ;
                       LDX.W #$0038                         ;83EE9B;      ;
                       LDY.W #$0000                         ;83EE9E;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EEA1;848097;
                       %Set8bit(!M)                             ;83EEA5;      ;
                       LDA.B #$0A                           ;83EEA7;      ;
                       STA.L $7F1F47                        ;83EEA9;7F1F47;
                       RTS                                  ;83EEAD;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EEAE: %Set16bit(!MX)                             ;83EEAE;      ;
                       LDA.L !marriage_flags                        ;83EEB0;7F1F66;
                       AND.W #$001F                         ;83EEB4;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83EEDA                      ;83EEB7;83EEDA;
                       LDA.L !happiness                        ;83EEB9;7F1F33;
                       CMP.W #$0320                         ;83EEBD;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83EEDA                      ;83EEC0;83EEDA;
                       %Set16bit(!MX)                             ;83EEC2;      ;
                       LDA.W #$0000                         ;83EEC4;      ;
                       LDX.W #$0039                         ;83EEC7;      ;
                       LDY.W #$0000                         ;83EECA;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EECD;848097;
                       %Set8bit(!M)                             ;83EED1;      ;
                       LDA.B #$0B                           ;83EED3;      ;
                       STA.L $7F1F47                        ;83EED5;7F1F47;
                       RTS                                  ;83EED9;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EEDA: %Set16bit(!MX)                             ;83EEDA;      ;
                       LDA.L !marriage_flags                        ;83EEDC;7F1F66;
                       AND.W #$0001                         ;83EEE0;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83EF15                      ;83EEE3;83EF15;
                       %Set16bit(!MX)                             ;83EEE5;      ;
                       LDA.W #$0000                         ;83EEE7;      ;
                       LDX.W #$003A                         ;83EEEA;      ;
                       LDY.W #$0000                         ;83EEED;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EEF0;848097;
                       %Set8bit(!M)                             ;83EEF4;      ;
                       LDA.B #$21                           ;83EEF6;      ;
                       STA.L $7F1F47                        ;83EEF8;7F1F47;
                       RTS                                  ;83EEFC;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EEFD: %Set16bit(!MX)                             ;83EEFD;      ;
                       LDA.W #$0000                         ;83EEFF;      ;
                       LDX.W #$003A                         ;83EF02;      ;
                       LDY.W #$0001                         ;83EF05;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EF08;848097;
                       %Set8bit(!M)                             ;83EF0C;      ;
                       LDA.B #$0C                           ;83EF0E;      ;
                       STA.L $7F1F47                        ;83EF10;7F1F47;
                       RTS                                  ;83EF14;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EF15: %Set16bit(!MX)                             ;83EF15;      ;
                       LDA.L !marriage_flags                        ;83EF17;7F1F66;
                       AND.W #$0002                         ;83EF1B;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83EF50                      ;83EF1E;83EF50;
                       %Set16bit(!MX)                             ;83EF20;      ;
                       LDA.W #$0000                         ;83EF22;      ;
                       LDX.W #$003B                         ;83EF25;      ;
                       LDY.W #$0000                         ;83EF28;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EF2B;848097;
                       %Set8bit(!M)                             ;83EF2F;      ;
                       LDA.B #$22                           ;83EF31;      ;
                       STA.L $7F1F47                        ;83EF33;7F1F47;
                       RTS                                  ;83EF37;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EF38: %Set16bit(!MX)                             ;83EF38;      ;
                       LDA.W #$0000                         ;83EF3A;      ;
                       LDX.W #$003B                         ;83EF3D;      ;
                       LDY.W #$0001                         ;83EF40;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EF43;848097;
                       %Set8bit(!M)                             ;83EF47;      ;
                       LDA.B #$0D                           ;83EF49;      ;
                       STA.L $7F1F47                        ;83EF4B;7F1F47;
                       RTS                                  ;83EF4F;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EF50: %Set16bit(!MX)                             ;83EF50;      ;
                       LDA.L !marriage_flags                        ;83EF52;7F1F66;
                       AND.W #$0004                         ;83EF56;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83EF8B                      ;83EF59;83EF8B;
                       %Set16bit(!MX)                             ;83EF5B;      ;
                       LDA.W #$0000                         ;83EF5D;      ;
                       LDX.W #$003C                         ;83EF60;      ;
                       LDY.W #$0000                         ;83EF63;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EF66;848097;
                       %Set8bit(!M)                             ;83EF6A;      ;
                       LDA.B #$23                           ;83EF6C;      ;
                       STA.L $7F1F47                        ;83EF6E;7F1F47;
                       RTS                                  ;83EF72;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EF73: %Set16bit(!MX)                             ;83EF73;      ;
                       LDA.W #$0000                         ;83EF75;      ;
                       LDX.W #$003C                         ;83EF78;      ;
                       LDY.W #$0001                         ;83EF7B;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EF7E;848097;
                       %Set8bit(!M)                             ;83EF82;      ;
                       LDA.B #$0E                           ;83EF84;      ;
                       STA.L $7F1F47                        ;83EF86;7F1F47;
                       RTS                                  ;83EF8A;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EF8B: %Set16bit(!MX)                             ;83EF8B;      ;
                       LDA.L !marriage_flags                        ;83EF8D;7F1F66;
                       AND.W #$0008                         ;83EF91;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83EFC6                      ;83EF94;83EFC6;
                       %Set16bit(!MX)                             ;83EF96;      ;
                       LDA.W #$0000                         ;83EF98;      ;
                       LDX.W #$003D                         ;83EF9B;      ;
                       LDY.W #$0000                         ;83EF9E;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EFA1;848097;
                       %Set8bit(!M)                             ;83EFA5;      ;
                       LDA.B #$24                           ;83EFA7;      ;
                       STA.L $7F1F47                        ;83EFA9;7F1F47;
                       RTS                                  ;83EFAD;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EFAE: %Set16bit(!MX)                             ;83EFAE;      ;
                       LDA.W #$0000                         ;83EFB0;      ;
                       LDX.W #$003D                         ;83EFB3;      ;
                       LDY.W #$0001                         ;83EFB6;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EFB9;848097;
                       %Set8bit(!M)                             ;83EFBD;      ;
                       LDA.B #$0F                           ;83EFBF;      ;
                       STA.L $7F1F47                        ;83EFC1;7F1F47;
                       RTS                                  ;83EFC5;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EFC6: %Set16bit(!MX)                             ;83EFC6;      ;
                       LDA.L !marriage_flags                        ;83EFC8;7F1F66;
                       AND.W #$0010                         ;83EFCC;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83EFE9                      ;83EFCF;83EFE9;
                       %Set16bit(!MX)                             ;83EFD1;      ;
                       LDA.W #$0000                         ;83EFD3;      ;
                       LDX.W #$003E                         ;83EFD6;      ;
                       LDY.W #$0000                         ;83EFD9;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83EFDC;848097;
                       %Set8bit(!M)                             ;83EFE0;      ;
                       LDA.B #$10                           ;83EFE2;      ;
                       STA.L $7F1F47                        ;83EFE4;7F1F47;
                       RTS                                  ;83EFE8;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83EFE9: %Set16bit(!MX)                             ;83EFE9;      ;
                       LDA.L !marriage_flags                        ;83EFEB;7F1F66;
                       AND.W #$001F                         ;83EFEF;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83F02F                      ;83EFF2;83F02F;
                       LDA.L !happiness                        ;83EFF4;7F1F33;
                       CMP.W #$00C8                         ;83EFF8;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83F02F                      ;83EFFB;83F02F;
                       LDA.L !hearts_maria                        ;83EFFD;7F1F1F;
                       CLC                                  ;83F001;      ;
                       ADC.L !hearts_ann                        ;83F002;7F1F21;
                       ADC.L !hearts_nina                        ;83F006;7F1F23;
                       ADC.L !hearts_ellen                        ;83F00A;7F1F25;
                       ADC.L !hearts_eve                        ;83F00E;7F1F27;
                       CMP.W #$05DC                         ;83F012;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83F02F                      ;83F015;83F02F;
                       %Set16bit(!MX)                             ;83F017;      ;
                       LDA.W #$0000                         ;83F019;      ;
                       LDX.W #$003F                         ;83F01C;      ;
                       LDY.W #$0000                         ;83F01F;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83F022;848097;
                       %Set8bit(!M)                             ;83F026;      ;
                       LDA.B #$11                           ;83F028;      ;
                       STA.L $7F1F47                        ;83F02A;7F1F47;
                       RTS                                  ;83F02E;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83F02F: %Set16bit(!MX)                             ;83F02F;      ;
                       LDA.L !child_flags                        ;83F031;7F1F6E;
                       AND.W #$000C                         ;83F035;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83F052                      ;83F038;83F052;
                       %Set16bit(!MX)                             ;83F03A;      ;
                       LDA.W #$0000                         ;83F03C;      ;
                       LDX.W #$0040                         ;83F03F;      ;
                       LDY.W #$0000                         ;83F042;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83F045;848097;
                       %Set8bit(!M)                             ;83F049;      ;
                       LDA.B #$12                           ;83F04B;      ;
                       STA.L $7F1F47                        ;83F04D;7F1F47;
                       RTS                                  ;83F051;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83F052: %Set16bit(!MX)                             ;83F052;      ;
                       LDA.L !child_flags                        ;83F054;7F1F6E;
                       AND.W #$0008                         ;83F058;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83F075                      ;83F05B;83F075;
                       %Set16bit(!MX)                             ;83F05D;      ;
                       LDA.W #$0000                         ;83F05F;      ;
                       LDX.W #$0041                         ;83F062;      ;
                       LDY.W #$0000                         ;83F065;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83F068;848097;
                       %Set8bit(!M)                             ;83F06C;      ;
                       LDA.B #$13                           ;83F06E;      ;
                       STA.L $7F1F47                        ;83F070;7F1F47;
                       RTS                                  ;83F074;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83F075: %Set16bit(!MX)                             ;83F075;      ;
                       LDA.L !child_flags                        ;83F077;7F1F6E;
                       AND.W #$0008                         ;83F07B;      ;
                       BEQ Bank83_NpcSpriteLogicBranch_83F0E3                      ;83F07E;83F0E3;
                       LDA.L !happiness                        ;83F080;7F1F33;
                       CMP.W #$0384                         ;83F084;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83F0E3                      ;83F087;83F0E3;
                       %Set8bit(!M)                             ;83F089;      ;
                       LDA.L !cow_N                        ;83F08B;7F1F0A;
                       BEQ Bank83_NpcSpriteLogicBranch_83F0E3                      ;83F08F;83F0E3;
                       LDA.L !chicks_N                        ;83F091;7F1F0B;
                       BEQ Bank83_NpcSpriteLogicBranch_83F0E3                      ;83F095;83F0E3;
                       LDA.L !power_berry_N                        ;83F097;7F1F36;
                       CMP.B #$0A                           ;83F09B;      ;
                       BNE Bank83_NpcSpriteLogicBranch_83F0E3                      ;83F09D;83F0E3;
                       %Set16bit(!M)                             ;83F09F;      ;
                       LDA.L !moneyL                        ;83F0A1;7F1F04;
                       CLC                                  ;83F0A5;      ;
                       ADC.W #$FC18                         ;83F0A6;      ;
                       %Set8bit(!M)                             ;83F0A9;      ;
                       LDA.L !moneyH                        ;83F0AB;7F1F06;
                       ADC.B #$FF                           ;83F0AF;      ;
                       BMI Bank83_NpcSpriteLogicBranch_83F0E3                      ;83F0B1;83F0E3;
                       %Set16bit(!M)                             ;83F0B3;      ;
                       LDA.L !dog_hugs                        ;83F0B5;7F1F52;
                       CMP.W #$0064                         ;83F0B9;      ;
                       BCC Bank83_NpcSpriteLogicBranch_83F0E3                      ;83F0BC;83F0E3;
                       %Set16bit(!MX)                             ;83F0BE;      ;
                       LDA.W #$0000                         ;83F0C0;      ;
                       LDX.W #$0042                         ;83F0C3;      ;
                       LDY.W #$0000                         ;83F0C6;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83F0C9;848097;
                       %Set8bit(!M)                             ;83F0CD;      ;
                       LDA.B #$14                           ;83F0CF;      ;
                       STA.L $7F1F47                        ;83F0D1;7F1F47;
                       %Set16bit(!M)                             ;83F0D5;      ;
                       LDA.L $7F1F5E                        ;83F0D7;7F1F5E;
                       AND.W #$7FFF                         ;83F0DB;      ;
                       STA.L $7F1F5E                        ;83F0DE;7F1F5E;
                       RTS                                  ;83F0E2;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83F0E3: %Set16bit(!MX)                             ;83F0E3;      ;
                       LDA.L !hearts_maria                        ;83F0E5;7F1F1F;
                       STA.W $09B3                          ;83F0E9;0009B3;
                       CMP.L !hearts_ann                        ;83F0EC;7F1F21;
                       BCS Bank83_NpcSpriteLogicBranch_83F0F9                      ;83F0F0;83F0F9;
                       LDA.L !hearts_ann                        ;83F0F2;7F1F21;
                       STA.W $09B3                          ;83F0F6;0009B3;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83F0F9: %Set16bit(!MX)                             ;83F0F9;      ;
                       CMP.L !hearts_nina                        ;83F0FB;7F1F23;
                       BCS Bank83_NpcSpriteLogicBranch_83F108                      ;83F0FF;83F108;
                       LDA.L !hearts_nina                        ;83F101;7F1F23;
                       STA.W $09B3                          ;83F105;0009B3;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83F108: %Set16bit(!MX)                             ;83F108;      ;
                       CMP.L !hearts_ellen                        ;83F10A;7F1F25;
                       BCS Bank83_NpcSpriteLogicBranch_83F117                      ;83F10E;83F117;
                       LDA.L !hearts_ellen                        ;83F110;7F1F25;
                       STA.W $09B3                          ;83F114;0009B3;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83F117: %Set16bit(!MX)                             ;83F117;      ;
                       CMP.L !hearts_eve                        ;83F119;7F1F27;
                       BCS Bank83_NpcSpriteLogicBranch_83F126                      ;83F11D;83F126;
                       LDA.L !hearts_eve                        ;83F11F;7F1F27;
                       STA.W $09B3                          ;83F123;0009B3;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83F126: %Set16bit(!MX)                             ;83F126;      ;
                       LDA.W #$0000                         ;83F128;      ;
                       LDX.W #$0046                         ;83F12B;      ;
                       LDY.W #$0000                         ;83F12E;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83F131;848097;
                       %Set8bit(!M)                             ;83F135;      ;
                       LDA.B #$15                           ;83F137;      ;
                       STA.L $7F1F47                        ;83F139;7F1F47;
                       %Set16bit(!M)                             ;83F13D;      ;
                       LDA.L $7F1F5E                        ;83F13F;7F1F5E;
                       ORA.W #$8000                         ;83F143;      ;
                       STA.L $7F1F5E                        ;83F146;7F1F5E;
                       RTS                                  ;83F14A;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83F14B: %Set16bit(!MX)                             ;83F14B;      ;
                       LDA.W #$0000                         ;83F14D;      ;
                       LDX.W #$0046                         ;83F150;      ;
                       LDY.W #$0001                         ;83F153;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83F156;848097;
                       %Set8bit(!M)                             ;83F15A;      ;
                       LDA.B #$16                           ;83F15C;      ;
                       STA.L $7F1F47                        ;83F15E;7F1F47;
                       RTS                                  ;83F162;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83F163: %Set16bit(!MX)                             ;83F163;      ;
                       LDA.W #$0000                         ;83F165;      ;
                       LDX.W #$0046                         ;83F168;      ;
                       LDY.W #$0002                         ;83F16B;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83F16E;848097;
                       %Set8bit(!M)                             ;83F172;      ;
                       LDA.B #$17                           ;83F174;      ;
                       STA.L $7F1F47                        ;83F176;7F1F47;
                       RTS                                  ;83F17A;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83F17B: %Set16bit(!MX)                             ;83F17B;      ;
                       LDA.W #$0000                         ;83F17D;      ;
                       LDX.W #$0046                         ;83F180;      ;
                       LDY.W #$0003                         ;83F183;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83F186;848097;
                       %Set8bit(!M)                             ;83F18A;      ;
                       LDA.B #$18                           ;83F18C;      ;
                       STA.L $7F1F47                        ;83F18E;7F1F47;
                       RTS                                  ;83F192;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83F193: %Set16bit(!MX)                             ;83F193;      ;
                       LDA.W #$0000                         ;83F195;      ;
                       LDX.W #$0046                         ;83F198;      ;
                       LDY.W #$0004                         ;83F19B;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83F19E;848097;
                       %Set8bit(!M)                             ;83F1A2;      ;
                       LDA.B #$19                           ;83F1A4;      ;
                       STA.L $7F1F47                        ;83F1A6;7F1F47;
                       RTS                                  ;83F1AA;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83F1AB: %Set16bit(!MX)                             ;83F1AB;      ;
                       LDA.W #$0000                         ;83F1AD;      ;
                       LDX.W #$0046                         ;83F1B0;      ;
                       LDY.W #$0005                         ;83F1B3;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83F1B6;848097;
                       %Set8bit(!M)                             ;83F1BA;      ;
                       LDA.B #$1A                           ;83F1BC;      ;
                       STA.L $7F1F47                        ;83F1BE;7F1F47;
                       RTS                                  ;83F1C2;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83F1C3: %Set16bit(!MX)                             ;83F1C3;      ;
                       LDA.W #$0000                         ;83F1C5;      ;
                       LDX.W #$0046                         ;83F1C8;      ;
                       LDY.W #$0006                         ;83F1CB;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83F1CE;848097;
                       %Set8bit(!M)                             ;83F1D2;      ;
                       LDA.B #$1B                           ;83F1D4;      ;
                       STA.L $7F1F47                        ;83F1D6;7F1F47;
                       RTS                                  ;83F1DA;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83F1DB: %Set16bit(!MX)                             ;83F1DB;      ;
                       LDA.W #$0000                         ;83F1DD;      ;
                       LDX.W #$0046                         ;83F1E0;      ;
                       LDY.W #$0007                         ;83F1E3;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83F1E6;848097;
                       %Set8bit(!M)                             ;83F1EA;      ;
                       LDA.B #$20                           ;83F1EC;      ;
                       STA.L $7F1F47                        ;83F1EE;7F1F47;
                       %Set16bit(!M)                             ;83F1F2;      ;
                       LDA.L $7F1F5E                        ;83F1F4;7F1F5E;
                       AND.W #$7FFF                         ;83F1F8;      ;
                       STA.L $7F1F5E                        ;83F1FB;7F1F5E;
                       RTS                                  ;83F1FF;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83F200: %Set16bit(!MX)                             ;83F200;      ;
                       LDA.W #$0000                         ;83F202;      ;
                       LDX.W #$0046                         ;83F205;      ;
                       LDY.W #$0008                         ;83F208;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83F20B;848097;
                       %Set8bit(!M)                             ;83F20F;      ;
                       LDA.B #$1D                           ;83F211;      ;
                       STA.L $7F1F47                        ;83F213;7F1F47;
                       RTS                                  ;83F217;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83F218: %Set16bit(!MX)                             ;83F218;      ;
                       LDA.W #$0000                         ;83F21A;      ;
                       LDX.W #$0046                         ;83F21D;      ;
                       LDY.W #$0009                         ;83F220;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83F223;848097;
                       %Set8bit(!M)                             ;83F227;      ;
                       LDA.B #$1E                           ;83F229;      ;
                       STA.L $7F1F47                        ;83F22B;7F1F47;
                       RTS                                  ;83F22F;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83F230: %Set16bit(!MX)                             ;83F230;      ;
                       LDA.W #$0000                         ;83F232;      ;
                       LDX.W #$0046                         ;83F235;      ;
                       LDY.W #$000A                         ;83F238;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83F23B;848097;
                       %Set8bit(!M)                             ;83F23F;      ;
                       LDA.B #$1F                           ;83F241;      ;
                       STA.L $7F1F47                        ;83F243;7F1F47;
                       RTS                                  ;83F247;      ;
                                                            ;      ;      ;
                                                            ;      ;      ;
          Bank83_NpcSpriteLogicBranch_83F248: %Set16bit(!MX)                             ;83F248;      ;
                       LDA.W #$0000                         ;83F24A;      ;
                       LDX.W #$0046                         ;83F24D;      ;
                       LDY.W #$000B                         ;83F250;      ;
                       JSL.L EventScript_LoadScriptPointerLong                            ;83F253;848097;
                       %Set8bit(!M)                             ;83F257;      ;
                       LDA.B #$20                           ;83F259;      ;
                       STA.L $7F1F47                        ;83F25B;7F1F47;
                       %Set16bit(!M)                             ;83F25F;      ;
                       LDA.L $7F1F5E                        ;83F261;7F1F5E;
                       AND.W #$7FFF                         ;83F265;      ;
                       STA.L $7F1F5E                        ;83F268;7F1F5E;
                       RTS                                  ;83F26C;      ;


;;;;;;;; PASS36_RANCH_EVAL_CORE: final ranch mastery / ending score calculator.
;;;;;;;; Computes !ranch_mastery from money, animals, stamina upgrades, romance,
;;;;;;;; shipped crops, happiness, house/family/event flags, ranch development
;;;;;;;; and cow happiness, then starts the ending/result event script.
;;;;;;;; The original bug-prone scoring behavior is preserved byte-perfect.
RanchEval_CalculateMasteryAndStartEnding:
        %Set16bit(!M)
        LDA.W #$0000
        STA.L !ranch_mastery
        LDA.L !moneyL
        LSR A
        LSR A
        LSR A
        LSR A
        LSR A
        LSR A
        LSR A
        CMP.W #78                            ;aka > 99840G
        BCC +
        LDA.W #78

      + STA.L !ranch_mastery
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.L !cow_N
        ASL A
        CLC
        ADC.L !cow_N                         ;Number of cows * 3
        %Set16bit(!M)
        ADC.L !ranch_mastery
        STA.L !ranch_mastery
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.L !chicks_N
        ASL A
        CLC
        ADC.L !chicks_N                      ;chinks * 3 too
        %Set16bit(!M)
        ADC.L !ranch_mastery
        STA.L !ranch_mastery
        %Set8bit(!M)
        LDA.B #$00
        XBA
        LDA.W !max_stamina
        SEC
        SBC.B #$64                           ;Max stamina - 100, it starts at 100
        LSR A
        %Set16bit(!M)
        CLC
        ADC.L !ranch_mastery
        STA.L !ranch_mastery
        %Set16bit(!M)
        LDA.L !hearts_maria                  ;BUG
        AND.W #$01FF                         ;replace with CMP
        ;BIM +
        ;STA #31
        ;BRA ++
        LSR A                                ;add a + in this line
        LSR A
        LSR A
        LSR A
        CLC                                  ;add ++ here
        ADC.L !ranch_mastery
        STA.L !ranch_mastery
        %Set16bit(!M)
        LDA.L !hearts_ann                    ;BUG
        AND.W #$01FF
        LSR A
        LSR A
        LSR A
        LSR A
        CLC
        ADC.L !ranch_mastery
        STA.L !ranch_mastery
        %Set16bit(!M)
        LDA.L !hearts_nina                   ;BUG
        AND.W #$01FF
        LSR A
        LSR A
        LSR A
        LSR A
        CLC
        ADC.L !ranch_mastery
        STA.L !ranch_mastery
        %Set16bit(!M)
        LDA.L !hearts_ellen                  ;BUG
        AND.W #$01FF
        LSR A
        LSR A
        LSR A
        LSR A
        CLC
        ADC.L !ranch_mastery
        STA.L !ranch_mastery
        %Set16bit(!M)
        LDA.L !hearts_eve                    ;BUG
        AND.W #$01FF
        LSR A
        LSR A
        LSR A
        LSR A
        CLC
        ADC.L !ranch_mastery
        STA.L !ranch_mastery
        %Set16bit(!M)
        LDA.L !shipped_tomatoes              ;Bug
        AND.W #$01FF
        LSR A
        LSR A
        LSR A
        LSR A
        CLC
        ADC.L !ranch_mastery
        STA.L !ranch_mastery
        %Set16bit(!M)
        LDA.L !shipped_corn                  ;Bug
        AND.W #$01FF
        LSR A
        LSR A
        LSR A
        LSR A
        CLC
        ADC.L !ranch_mastery
        STA.L !ranch_mastery
        %Set16bit(!M)
        LDA.L !shipped_potatoes              ;Bug
        AND.W #$01FF
        LSR A
        LSR A
        LSR A
        LSR A
        CLC
        ADC.L !ranch_mastery
        STA.L !ranch_mastery
        %Set16bit(!M)
        LDA.L !shipped_turnips               ;Bug
        AND.W #$01FF
        LSR A
        LSR A
        LSR A
        LSR A
        CLC
        ADC.L !ranch_mastery
        STA.L !ranch_mastery
        %Set16bit(!M)
        LDA.L !happiness
        LSR A
        LSR A
        LSR A
        LSR A
        LSR A
        CLC
        ADC.L !ranch_mastery
        STA.L !ranch_mastery
        %Set16bit(!M)
        LDA.L !player_house_and_event_flags
        AND.W #$0080                         ;House Upgrade Max
        BEQ +
        LDA.L !ranch_mastery
        CLC
        ADC.W #16
        STA.L !ranch_mastery

      + %Set16bit(!M)
        LDA.L !player_house_and_event_flags
        AND.W #$0040                         ;House First Upgrade
        BEQ +
        LDA.L !ranch_mastery
        CLC
        ADC.W #16
        STA.L !ranch_mastery

      + %Set16bit(!M)
        LDA.L !child_flags
        AND.W #$0008                         ;Child 1
        BEQ +
        LDA.L !ranch_mastery
        CLC
        ADC.W #16
        STA.L !ranch_mastery

      + %Set16bit(!M)
        LDA.L !child_flags
        AND.W #$0004                         ;Child 2
        BEQ +
        LDA.L !ranch_mastery
        CLC
        ADC.W #16
        STA.L !ranch_mastery

      + %Set16bit(!M)
        LDA.L !marriage_flags
        AND.W #$001F
        BEQ +
        LDA.L !ranch_mastery
        CLC
        ADC.W #32
        STA.L !ranch_mastery

      + %Set16bit(!M)
        LDA.L !child_flags
        AND.W #$4000                         ;Clock Owned
        BEQ +
        LDA.L !ranch_mastery
        CLC
        ADC.W #22
        STA.L !ranch_mastery

      + %Set16bit(!M)
        LDA.L !family_event_flags
        AND.W #$1000                         ;Turtle Shell
        BEQ +
        LDA.L !ranch_mastery
        CLC
        ADC.W #21
        STA.L !ranch_mastery

      + %Set16bit(!M)
        LDA.L !ranch_development
        LSR A
        CLC
        ADC.L !ranch_mastery
        STA.L !ranch_mastery

        %Set16bit(!M)
        LDX.W #$0000

      - %Set16bit(!MX)                       ;Cow Happiness Loop
        PHX
        TXA
        JSL.L GetCowPointer
        %Set8bit(!M)
        %Set16bit(!X)
        LDY.W #$0000
        LDA.B [$72],Y
        AND.B #$01                           ;cow exists
        BEQ ++
        LDY.W #$0004                         ;cow happiness var
        LDA.B #$00
        XBA
        LDA.B [$72],Y
        LSR A
        LSR A
        LSR A
        CMP.B #$19                           ;at least half max happyness
        BCC +
        LDA.B #25

      + %Set16bit(!M)
        CLC
        ADC.L !ranch_mastery
        STA.L !ranch_mastery

     ++ %Set16bit(!MX)
        PLX
        INX
        CPX.W #12
        BNE -

        %Set16bit(!M)
        LDA.L !ranch_mastery
        CMP.W #999
        BCC +
        LDA.W #999
        STA.L !ranch_mastery

      + %Set16bit(!MX)                       ;TODO
        LDA.W #$0000
        LDX.W #$0046
        LDY.W #$000C
        JSL.L EventScript_LoadScriptPointerLong
        %Set8bit(!M)
        LDA.B #$25
        STA.L $7F1F47
        %Set16bit(!M)
        LDA.L $7F1F5E
        ORA.W #$8000
        STA.L $7F1F5E

        RTS

;;;;;;;; empty
Bank83_NpcSpriteLogicBranch_83F4D7: RTS

;;;;;;;;
Bank83_NpcSpriteLogicBranch_83F4D8:
        %Set16bit(!MX)
        LDA.W #$0000
        LDX.W #$002E                         ;56
        LDY.W #$0000
        JSL.L EventScript_LoadScriptPointerLong                            ;TODO
        %Set16bit(!MX)
        STZ.W $0196
        LDA.L $7F1F5E
        ORA.W #$0002                         ;FLAG5E
        STA.L $7F1F5E
        %Set8bit(!M)
        LDA.B #$00
        STA.L $7F1F47
        %Set8bit(!M)
        %Set16bit(!X)
        STZ.W $09B5
        %Set16bit(!M)
        LDA.W #$00B1
        STA.W $0889
        STA.W $088B
        STA.W $088D
        STA.W $088F
        LDX.W #$0000

    .cowloop:
        %Set16bit(!MX)                             ;83F51A;      ;
        PHX                                  ;83F51C;      ;
        TXA                                  ;83F51D;      ;
        JSL.L GetCowPointer                ;83F51E;83C9A7;
        %Set8bit(!M)                             ;83F522;      ;
        %Set16bit(!X)                             ;83F524;      ;
        LDY.W #$0000                         ;83F526;      ;
        LDA.B [$72],Y                        ;83F529;000072;
        AND.B #$01                           ;83F52B;      ;
        BEQ .Bank83_NpcSpriteLogicBranch_83F573                      ;83F52D;83F573;
        LDY.W #$0004                         ;83F52F;      ;
        LDA.B [$72],Y                        ;83F532;000072;
        CMP.W $09B5                          ;83F534;0009B5;
        BCS .Bank83_NpcSpriteLogicBranch_83F53B                      ;83F537;83F53B;
        BRA .Bank83_NpcSpriteLogicBranch_83F573                      ;83F539;83F573;
                                            ;      ;      ;
                                            ;      ;      ;
    .Bank83_NpcSpriteLogicBranch_83F53B:
        %Set8bit(!M)                             ;83F53B;      ;
        STA.W $09B5                          ;83F53D;0009B5;
        %Set8bit(!M)                             ;83F540;      ;
        LDA.B #$00                           ;83F542;      ;
        XBA                                  ;83F544;      ;
        LDY.W #$000C                         ;83F545;      ;
        LDA.B [$72],Y                        ;83F548;000072;
        %Set16bit(!M)                             ;83F54A;      ;
        STA.W $0889                          ;83F54C;000889;
        %Set8bit(!M)                             ;83F54F;      ;
        LDY.W #$000D                         ;83F551;      ;
        LDA.B [$72],Y                        ;83F554;000072;
        %Set16bit(!M)                             ;83F556;      ;
        STA.W $088B                          ;83F558;00088B;
        %Set8bit(!M)                             ;83F55B;      ;
        LDY.W #$000E                         ;83F55D;      ;
        LDA.B [$72],Y                        ;83F560;000072;
        %Set16bit(!M)                             ;83F562;      ;
        STA.W $088D                          ;83F564;00088D;
        %Set8bit(!M)                             ;83F567;      ;
        LDY.W #$000F                         ;83F569;      ;
        LDA.B [$72],Y                        ;83F56C;000072;
        %Set16bit(!M)                             ;83F56E;      ;
        STA.W $088F                          ;83F570;00088F;

    .Bank83_NpcSpriteLogicBranch_83F573:
        %Set16bit(!MX)                             ;83F573;      ;
        PLX                                  ;83F575;      ;
        INX                                  ;83F576;      ;
        CPX.W #$000C                         ;83F577;      ;
        BNE .cowloop                      ;83F57A;83F51A;
        JSL.L Farm_CalculateRanchDevelopmentScore                          ;83F57C;82AA0C;
        %Set16bit(!MX)                             ;83F580;      ;
        LDA.L !ranch_development                        ;83F582;7F1F56;
        STA.B $7E                            ;83F586;00007E;
        LDA.W #$000A                         ;83F588;      ;
        JSL.L Audio_IndexStrideMultiply                   ;83F58B;838000;
        %Set16bit(!MX)                             ;83F58F;      ;
        STA.B $7E                            ;83F591;00007E;
        LDA.W #$0127                         ;83F593;      ;
        STA.B $80                            ;83F596;000080;
        JSL.L Math_DivideUnsigned16By16               ;83F598;838082;
        %Set16bit(!MX)                             ;83F59C;      ;
        STA.L !ranch_development                        ;83F59E;7F1F56;
        CMP.W #$0064                         ;83F5A2;      ;
        BCC .Bank83_NpcSpriteLogicBranch_83F5AE                      ;83F5A5;83F5AE;
        LDA.W #$0064                         ;83F5A7;      ;
        STA.L !ranch_development                        ;83F5AA;7F1F56;
                                            ;      ;      ;
        .Bank83_NpcSpriteLogicBranch_83F5AE: RTS                                  ;83F5AE;      ;
