; Pass 04 text edit preview
; This file is generated for manual review. It is NOT automatically included by src/main.asm.
; Copy validated blocks into the matching bank file only after reviewing size/pointer constraints.

; index $00B | B6:B688A4 | Text_00B_Diary_WorkHardAgainTomorrow
; original budget: 38 words / 76 bytes
Text_00B_Diary_WorkHardAgainTomorrow:
                       dw $002F,$000E,$0014,$00B1,$0013,$0011,$0000,$0001
                       dw $0000,$000B,$0007,$0000,$0011,$00B1,$0003,$0014
                       dw $0011,$000E,$00B1,$0000,$000C,$0000,$000D,$0007
                       dw $0000,$0036,$FFFF
; optional padding to preserve exact block size
                       dw $00B1,$00B1,$00B1,$00B1,$00B1,$00B1,$00B1,$00B1
                       dw $00B1,$00B1,$00B1

; index $00D | B6:B68972 | Text_00D_Diary_GoodNight
; original budget: 12 words / 24 bytes
Text_00D_Diary_GoodNight:
                       dw $001B,$000E,$0000,$00B1,$000D,$000E,$0008,$0013
                       dw $0004,$0036,$FFFF
; optional padding to preserve exact block size
                       dw $00B1

; index $02D | B6:B69DF4 | Text_Shop_Closed
; original budget: 15 words / 30 bytes
Text_Shop_Closed:
                       dw $001F,$0004,$0002,$0007,$0000,$0003,$000E,$0036
                       dw $FFFF
; optional padding to preserve exact block size
                       dw $00B1,$00B1,$00B1,$00B1,$00B1,$00B1
