; Pass 05 allocated pointer-table replacements
; Replace matching lines inside Text_Pointer_Table in src/code_banks/bank_83.asm after inserting blocks.

; index $02D | old Text_Shop_Closed
        dl Text_Repoint_02D_Shop_Closed                       ; $BBBDF8

; index $035 | old Text_035_Dialog_HowsGoingWorkTooHard
        dl Text_Repoint_035_035_Dialog_HowsGoingWorkTooHard   ; $BBBF1A
