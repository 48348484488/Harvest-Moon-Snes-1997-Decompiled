# Relatorio automatico do HM-Decomp

Este relatorio e gerado sem ROM original. Ele mede o estado do codigo Assembly exportado.

## Totais

- Arquivos ASM analisados: 74
- Linhas ASM: 184379
- Marcacoes TODO: 90
- Referencias UNK_: 0
- Referencias DATA8_: 413
- Referencias DATA16_: 15
- Labels SUB_: 8
- Labels CODE_: 1376
- Linhas db/dw/dl: 109678/15620/2248

## Resumo por tipo

| Tipo | Linhas | TODO | UNK | DATA8 | DATA16 | db | dw | dl |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| code | 60474 | 86 | 0 | 123 | 14 | 2101 | 2976 | 1844 |
| constants | 981 | 4 | 0 | 0 | 0 | 12 | 18 | 0 |
| data | 120532 | 0 | 0 | 112 | 1 | 107094 | 11763 | 72 |
| maps | 2062 | 0 | 0 | 0 | 0 | 471 | 863 | 332 |
| misc | 330 | 0 | 0 | 178 | 0 | 0 | 0 | 0 |

## Bancos/arquivos que mais precisam de revisao

| Arquivo | Linhas | TODO | UNK | DATA8 | DATA16 | db | dw | dl |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| `src/code_banks/bank_83.asm` | 13463 | 26 | 0 | 1 | 0 | 284 | 28 | 1370 |
| `src/code_banks/bank_84.asm` | 11132 | 21 | 0 | 25 | 6 | 2 | 109 | 2 |
| `src/code_banks/bank_81.asm` | 12572 | 10 | 0 | 97 | 8 | 366 | 320 | 0 |
| `src/code_banks/bank_82.asm` | 7607 | 9 | 0 | 0 | 0 | 184 | 577 | 113 |
| `src/labels.asm` | 252 | 0 | 0 | 178 | 0 | 0 | 0 | 0 |
| `src/code_banks/bank_80.asm` | 7743 | 8 | 0 | 0 | 0 | 1257 | 1363 | 359 |
| `src/code_banks/bank_82_toolused_subrutines.asm` | 2176 | 6 | 0 | 0 | 0 | 0 | 0 | 0 |
| `src/code_banks/bank_85.asm` | 1821 | 6 | 0 | 0 | 0 | 8 | 3 | 0 |
| `src/constants/ram.asm` | 463 | 3 | 0 | 0 | 0 | 0 | 0 | 0 |
| `src/data_banks/bank_B3.asm` | 2130 | 0 | 0 | 56 | 0 | 2040 | 0 | 72 |
| `src/data_banks/bank_B4.asm` | 2125 | 0 | 0 | 51 | 0 | 2070 | 0 | 0 |
| `src/constants/registers.asm` | 348 | 1 | 0 | 0 | 0 | 0 | 0 | 0 |
| `src/data_banks/bank_B5.asm` | 2059 | 0 | 0 | 5 | 0 | 2051 | 0 | 0 |
| `src/code_banks/bank_80_pointersubrutines.asm` | 3714 | 0 | 0 | 0 | 0 | 0 | 576 | 0 |
| `src/code_banks/bank_82_toolanimation_subrutines.asm` | 246 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| `src/constants/constants.asm` | 134 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| `src/constants/header.asm` | 36 | 0 | 0 | 0 | 0 | 12 | 18 | 0 |
| `src/data_banks/bank_86.asm` | 2053 | 0 | 0 | 0 | 0 | 2048 | 0 | 0 |
| `src/data_banks/bank_87.asm` | 2053 | 0 | 0 | 0 | 0 | 2049 | 0 | 0 |
| `src/data_banks/bank_88.asm` | 2051 | 0 | 0 | 0 | 0 | 2048 | 0 | 0 |
| `src/data_banks/bank_89.asm` | 2051 | 0 | 0 | 0 | 0 | 2048 | 0 | 0 |
| `src/data_banks/bank_8A.asm` | 2051 | 0 | 0 | 0 | 0 | 2048 | 0 | 0 |
| `src/data_banks/bank_8B.asm` | 2051 | 0 | 0 | 0 | 0 | 2048 | 0 | 0 |
| `src/data_banks/bank_8C.asm` | 2051 | 0 | 0 | 0 | 0 | 2048 | 0 | 0 |
| `src/data_banks/bank_8D.asm` | 2051 | 0 | 0 | 0 | 0 | 2048 | 0 | 0 |

## TODOs encontrados

- `src/code_banks/bank_80.asm:1252` `LDA.B $C7                            ;TODO`
- `src/code_banks/bank_80.asm:1388` `;Unknown if all are used, some are repeated.`
- `src/code_banks/bank_80.asm:1450` `STA.L !graphic_preset_unknown`
- `src/code_banks/bank_80.asm:2472` `LDA.B $92                            ;TODO`
- `src/code_banks/bank_80.asm:2874` `;;;;;;;; Wrong name TODO`
- `src/code_banks/bank_80.asm:2913` `LDA.B #$3C                           ;TODO`
- `src/code_banks/bank_80.asm:5312` `CMP.B #$03                           ;TODO`
- `src/code_banks/bank_80.asm:5430` `BNE .skip5                           ;TODO`
- `src/code_banks/bank_80.asm:5439` `LDA.B [$72],Y                    ;TODO`
- `src/code_banks/bank_80.asm:5451` `JSL.L FarmMap_ApplyPersistentFarmTileOverlay                 ;TODO`
- `src/code_banks/bank_81.asm:2611` `JSL.L GameOBJ_ClearSlotAndReleaseComponents                      ;TODO`
- `src/code_banks/bank_81.asm:2626` `JSL.L MapTilePatchScript_StartByIndex                      ;TODO`
- `src/code_banks/bank_81.asm:2642` `JSL.L MapTilePatchScript_StartByIndex                      ;TODO`
- `src/code_banks/bank_81.asm:2645` `STA.W $0976                            ;TODO`
- `src/code_banks/bank_81.asm:2658` `JSL.L MapTilePatchScript_StartByIndex                      ;TODO`
- `src/code_banks/bank_81.asm:2661` `STA.W $0976                            ;TODO`
- `src/code_banks/bank_81.asm:2691` `JSL.L PlayerTarget_CalculateTileInFront                      ;TODO`
- `src/code_banks/bank_81.asm:2696` `JSL.L TileProperty_CheckToolUseAllowed                            ;TODO`
- `src/code_banks/bank_81.asm:2712` `JSL.L EventScript_LoadScriptPointerForFacingTile                      ;TODO`
- `src/code_banks/bank_81.asm:2717` `STA.B [$CC],Y                          ;TODO`
- `src/code_banks/bank_82.asm:79` `JSL.L PaletteAnim_ClearPointer42SlotsFromIndex         ;TODO`
- `src/code_banks/bank_82.asm:80` `JSL.L PaletteAnim_RunMapTimeInstaller           ;TODO`
- `src/code_banks/bank_82.asm:229` `JSL.L TextBox_StartByTextId                      ;TODO`
- `src/code_banks/bank_82.asm:234` `JSL.L EventScript_LoadScriptPointerShort                      ;TODO`
- `src/code_banks/bank_82.asm:443` `JSL.L Weather_ApplyCurrentDayFlags                  ;TODO, something related to normal days`
- `src/code_banks/bank_82.asm:462` `JSL.L $8095F5                          ;TODO`
- `src/code_banks/bank_82.asm:546` `BEQ .CODE_828482                       ;TODO`
- `src/code_banks/bank_82.asm:2227` `STA.W $0181                          ;Map variable TODO`
- `src/code_banks/bank_82.asm:3810` `LDA.W $0181                           ;Map Variable TODO`
- `src/code_banks/bank_82_toolused_subrutines.asm:73` `JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM                    ;TODO spawn object effect?`
- `src/code_banks/bank_82_toolused_subrutines.asm:137` `JSL.L EventScript_LoadScriptPointerForFacingTile                    ;TODO Spawn frog subrutine?`
- `src/code_banks/bank_82_toolused_subrutines.asm:360` `JSL.L MapTilePatch_ApplyObjectAndRefreshVRAM                    ;TODO`
- `src/code_banks/bank_82_toolused_subrutines.asm:444` `JSL.L CODE_81A500                    ;TODO`
- `src/code_banks/bank_82_toolused_subrutines.asm:495` `JSL.L EventScript_LoadScriptPointerShort                    ;TODO`
- `src/code_banks/bank_82_toolused_subrutines.asm:519` `JSL.L EventScript_LoadScriptPointerForFacingTile                    ;TODO`
- `src/code_banks/bank_83.asm:3` `;;;;;;;; Does some weird things multypling some variables LOWBYTE and HIBYTE and suming the results with another variable????`
- `src/code_banks/bank_83.asm:4830` `;;;;;;;; TODO Sets a TON of things, lots of Vars to check`
- `src/code_banks/bank_83.asm:4858` `JSL.L Calendar_LoadDateNameBuffers        ;TODO`
- `src/code_banks/bank_83.asm:6690` `;TODO: Unknown value, modifing it doesnt seem to do anything, always one`
- `src/code_banks/bank_83.asm:6728` `STA.B [!pointer],Y                    ;Restores unknown value`
- `src/code_banks/bank_83.asm:6788` `;TODO: Unknown value`
- `src/code_banks/bank_83.asm:6830` `STA.W $098E                          ;??? TODO`
- `src/code_banks/bank_83.asm:6879` `AND.W #$0001                         ;TODO`
- `src/code_banks/bank_83.asm:6948` `JSL.L FarmGrass_MarkFirstMatureGrassPatch                          ;TODO`
- `src/code_banks/bank_83.asm:7011` `LDA.B [$72],Y                        ;TODO, milked today?`
- `src/code_banks/bank_83.asm:7038` `LDA.B [$72],Y                        ;TODO`
- `src/code_banks/bank_83.asm:7042` `LDA.L $7F1F5A                        ;TODO`
- `src/code_banks/bank_83.asm:7061` `LDA.W $0196                          ;Todo`
- `src/code_banks/bank_83.asm:7078` `LDA.B [$72],Y                        ;TODO`
- `src/code_banks/bank_83.asm:7093` `LDY.W #$0005                         ;TODO`
- `src/code_banks/bank_83.asm:7121` `AND.W #$EFBF                         ;TODO`
- `src/code_banks/bank_83.asm:7146` `LDA.B [$72],Y                        ;TODO`
- `src/code_banks/bank_83.asm:7246` `LDA.W $0196                          ;TODO`
- `src/code_banks/bank_83.asm:7275` `STA.W $0937                          ;TODO`
- `src/code_banks/bank_83.asm:7283` `AND.B #$80                           ;TODO`
- `src/code_banks/bank_83.asm:7291` `LDA.B [$72],Y                        ;TODO`
- `src/code_banks/bank_83.asm:7308` `LDA.L $7F1F12                        ;TODO`
- `src/code_banks/bank_83.asm:7320` `ORA.W #$0008                         ;TODO Cow Pregnat?`
- `src/code_banks/bank_83.asm:7329` `LDA.B #20                            ;TODO Starting cow Happiness?`
- `src/code_banks/bank_83.asm:7339` `STA.L $7F1F2B                        ;TODO Starting cow Happiness?`
- `src/code_banks/bank_83.asm:7345` `STA.L $7F1F2B                        ;TODO Starting cow Happiness?`
- `src/code_banks/bank_83.asm:13351` `+ %Set16bit(!MX)                       ;TODO`
- `src/code_banks/bank_83.asm:13375` `JSL.L EventScript_LoadScriptPointerLong                            ;TODO`
- `src/code_banks/bank_84.asm:216` `CMP.B #$06                           ;TODO`
- `src/code_banks/bank_84.asm:223` `CMP.W #$0003                         ;TODO Jumping?`
- `src/code_banks/bank_84.asm:9733` `AND.W #$0020                           ;TODO`
- `src/code_banks/bank_84.asm:9739` `AND.W #$1000                           ;TODO`
- `src/code_banks/bank_84.asm:9745` `AND.W #$4000                           ;TODO`
- `src/code_banks/bank_84.asm:9790` `AND.W #$1000                           ;TODO`
- `src/code_banks/bank_84.asm:10060` `STA.W $0911                            ;TODO`
- `src/code_banks/bank_84.asm:10250` `JMP.W PlayerInput_A_TryThrowHeldObjectByDirection                      ;TODO`
- `src/code_banks/bank_84.asm:10253` `AND.W #$0006                           ;TODO`
- `src/code_banks/bank_84.asm:10255` `JMP.W PlayerInput_A_SpecialInteractOnGround                      ;TODO`
- `src/code_banks/bank_84.asm:10259` `AND.W #$0002                           ;TODO`
- `src/code_banks/bank_84.asm:10261` `JMP.W PlayerInput_A_DropHeldItemAction                      ;TODO`
- `src/code_banks/bank_84.asm:10631` `AND.W #$8000                           ;TODO`
- `src/code_banks/bank_84.asm:10684` `AND.W #$0010                           ;TODO`
- `src/code_banks/bank_84.asm:10690` `AND.W #$0800                           ;TODO`
- `src/code_banks/bank_84.asm:10715` `AND.W #$0010                           ;TODO`
- `src/code_banks/bank_84.asm:10721` `AND.W #$0800                           ;TODO`
- `src/code_banks/bank_84.asm:10746` `AND.W #$0010                           ;TODO`
- `src/code_banks/bank_84.asm:10752` `AND.W #$0800                           ;TODO`
- `src/code_banks/bank_84.asm:10773` `AND.W #$0010                           ;TODO`
- `src/code_banks/bank_84.asm:10779` `AND.W #$0800                           ;TODO`
- `src/code_banks/bank_85.asm:852` `LDA.B $B2                    ;TODO: WTF is this bit shuffle?`
- `src/code_banks/bank_85.asm:866` `LDA.W !current_graphic_preset   ;TODO pallete relevant?`
- `src/code_banks/bank_85.asm:1424` `;;;;;;;; TODO`
- `src/code_banks/bank_85.asm:1473` `;;;;;;; TODO`
- `src/code_banks/bank_85.asm:1489` `;;;;;;;; This functions sets what is gonna be copied to the WRAM OBJ temp. TODO`
- `src/code_banks/bank_85.asm:1783` `;;;;;;; TODO`
- `src/constants/ram.asm:31` `;w??? ???? - w:walking to transition`
- `src/constants/ram.asm:135` `!graphic_preset_unknown = $8019EA`
- `src/constants/ram.asm:210` `;at the end of TODO, need to find a place for Items`
- `src/constants/ram.asm:216` `!player_action = $D4 ;16b TODO`
- `src/constants/ram.asm:356` `!shed_items_row_4 = $7F1F03 ;b ? TODO`
- `src/constants/registers.asm:3` `;TODO: Add info from https://wiki.superfamicom.org/registers`
- `src/constants/registers.asm:223` `;no latching can occur. Any other effects of this register are unknown. See $4213`
- `src/maps/Maps_Graphics.asm:49` `dw MapUnknown2B                      ;2B`
- `src/maps/Maps_Graphics.asm:50` `dw MapUnknown2C                      ;2C`
- `src/maps/Maps_Graphics.asm:51` `dw MapUnknown2D                      ;2D`
- `src/maps/Maps_Graphics.asm:52` `dw MapUnknown2E                      ;2E`
- `src/maps/Maps_Graphics.asm:53` `dw MapUnknown2F                      ;2F`
- `src/maps/Maps_Graphics.asm:54` `dw MapUnknown30                      ;30 HANGS GAME`
- `src/maps/Maps_Graphics.asm:59` `dw MapUnknown35                      ;35`
- `src/maps/Maps_Graphics.asm:60` `dw MapUnknown36                      ;36`
- `src/maps/Maps_Graphics.asm:61` `dw MapUnknown37                      ;37`
- `src/maps/Maps_Graphics.asm:62` `dw MapUnknown38                      ;38`
- `src/maps/Maps_Graphics.asm:65` `dw MapUnknown3B                      ;3B`
- `src/maps/Maps_Graphics.asm:66` `dw MapUnknown3C                      ;3C Intro Scene`
- `src/maps/Maps_Graphics.asm:67` `dw MapUnknown3D                      ;3D`
- `src/maps/Maps_Graphics.asm:68` `dw MapUnknown3E                      ;3E`
- `src/maps/Maps_Graphics.asm:69` `dw MapUnknown3F                      ;3F`
- `src/maps/Maps_Graphics.asm:70` `dw MapUnknown40                      ;40`
- `src/maps/Maps_Graphics.asm:71` `dw MapUnknown41                      ;41`
- `src/maps/Maps_Graphics.asm:72` `dw MapUnknown42                      ;42`
- `src/maps/Maps_Graphics.asm:73` `dw MapUnknown43                      ;43`
- `src/maps/Maps_Graphics.asm:74` `dw MapUnknown44                      ;44`
- `src/maps/Maps_Graphics.asm:75` `dw MapUnknown45                      ;45`
- `src/maps/Maps_Graphics.asm:76` `dw MapUnknown46                      ;46`
- `src/maps/Maps_Graphics.asm:77` `dw MapUnknown47                      ;47`
- `src/maps/Maps_Graphics.asm:78` `dw MapUnknown48                      ;48`
- `src/maps/Maps_Graphics.asm:79` `dw MapUnknown49                      ;49`
- `src/maps/Maps_Graphics.asm:80` `dw MapUnknown4A                      ;4A`
- `src/maps/Maps_Graphics.asm:81` `dw MapUnknown4B                      ;4B`
- `src/maps/Maps_Graphics.asm:82` `dw MapUnknown4C                      ;4C`
- `src/maps/Maps_Graphics.asm:83` `dw MapUnknown4D                      ;4D`
- `src/maps/Maps_Graphics.asm:84` `dw MapUnknown4E                      ;4E`
- `src/maps/Maps_Graphics.asm:85` `dw MapUnknown4F                      ;4F`
- `src/maps/Maps_Graphics.asm:86` `dw MapUnknown50                      ;50`
- `src/maps/Maps_Graphics.asm:87` `dw MapUnknown51                      ;51`
- `src/maps/Maps_Graphics.asm:88` `dw MapUnknown52                      ;52`
- `src/maps/Maps_Graphics.asm:89` `dw MapUnknown53                      ;53`
- `src/maps/Maps_Graphics.asm:90` `dw MapUnknown54                      ;54`
- `src/maps/Maps_Graphics.asm:91` `dw MapUnknown55                      ;55`
- `src/maps/Maps_Graphics.asm:92` `dw MapUnknown56                      ;56`
- `src/maps/Maps_Graphics.asm:960` `MapUnknown2B: ;80B032`
- `src/maps/Maps_Graphics.asm:978` `MapUnknown2C: ;80B04B`
- `src/maps/Maps_Graphics.asm:996` `MapUnknown2D: ;80B064`
- `src/maps/Maps_Graphics.asm:1018` `MapUnknown2E: ;80B087`
- `src/maps/Maps_Graphics.asm:1040` `MapUnknown2F: ;80B0AA`
- `src/maps/Maps_Graphics.asm:1062` `MapUnknown30: ;80B0CD`
- `src/maps/Maps_Graphics.asm:1172` `MapUnknown35: ;80B17C`
- `src/maps/Maps_Graphics.asm:1194` `MapUnknown36: ;80B19F`
- `src/maps/Maps_Graphics.asm:1216` `MapUnknown37: ;80B1C2`
- `src/maps/Maps_Graphics.asm:1239` `MapUnknown38: ;80B1E5`
- `src/maps/Maps_Graphics.asm:1305` `MapUnknown3B: ;80B24E`
- `src/maps/Maps_Graphics.asm:1327` `MapUnknown3C: ;80B271`
- `src/maps/Maps_Graphics.asm:1345` `MapUnknown3D: ;80B28A`
- `src/maps/Maps_Graphics.asm:1367` `MapUnknown3E: ;80B2AD`
- `src/maps/Maps_Graphics.asm:1389` `MapUnknown3F: ;80B2D0`
- `src/maps/Maps_Graphics.asm:1411` `MapUnknown40: ;80B2F3`
- `src/maps/Maps_Graphics.asm:1433` `MapUnknown41: ;80B2F3`
- `src/maps/Maps_Graphics.asm:1455` `MapUnknown42: ;80B339`
- `src/maps/Maps_Graphics.asm:1477` `MapUnknown43: ;80B35C`
- `src/maps/Maps_Graphics.asm:1499` `MapUnknown44: ;80B37F`
- `src/maps/Maps_Graphics.asm:1521` `MapUnknown45: ;80B3A2`
- `src/maps/Maps_Graphics.asm:1543` `MapUnknown46: ;80B3C5`
- `src/maps/Maps_Graphics.asm:1565` `MapUnknown47: ;80B3E8`
- `src/maps/Maps_Graphics.asm:1587` `MapUnknown48: ;80B40B`
- `src/maps/Maps_Graphics.asm:1609` `MapUnknown49: ;80B42E`
- `src/maps/Maps_Graphics.asm:1631` `MapUnknown4A: ;80B451`
- `src/maps/Maps_Graphics.asm:1653` `MapUnknown4B: ;80B474`
- `src/maps/Maps_Graphics.asm:1677` `MapUnknown4C: ;80B49C`
- `src/maps/Maps_Graphics.asm:1701` `MapUnknown4D: ;80B4C4`
- `src/maps/Maps_Graphics.asm:1725` `MapUnknown4E: ;80B4EC`
- `src/maps/Maps_Graphics.asm:1749` `MapUnknown4F: ;80B514`
- `src/maps/Maps_Graphics.asm:1771` `MapUnknown50: ;80B537`
- `src/maps/Maps_Graphics.asm:1795` `MapUnknown51: ;80B55F`
- `src/maps/Maps_Graphics.asm:1819` `MapUnknown52: ;80B587`
- `src/maps/Maps_Graphics.asm:1843` `MapUnknown53: ;80B5AF`
- `src/maps/Maps_Graphics.asm:1865` `MapUnknown54: ;80B5D2`
- `src/maps/Maps_Graphics.asm:1887` `MapUnknown55: ;80B5F5`
- `src/maps/Maps_Graphics.asm:1909` `MapUnknown56: ;80B618`

## Possiveis referencias nao resolvidas

- `$0196` usado 145x em src/code_banks/bank_80.asm:63, src/code_banks/bank_80.asm:92, src/code_banks/bank_80.asm:94, src/code_banks/bank_80.asm:134, src/code_banks/bank_80.asm:136, src/code_banks/bank_80.asm:176, src/code_banks/bank_80.asm:178, src/code_banks/bank_80.asm:229
- `$0191` usado 109x em src/code_banks/bank_81.asm:487, src/code_banks/bank_81.asm:1275, src/code_banks/bank_81.asm:1378, src/code_banks/bank_81.asm:1434, src/code_banks/bank_81.asm:1567, src/code_banks/bank_81.asm:2010, src/code_banks/bank_81.asm:2047, src/code_banks/bank_81.asm:2085
- `$0901` usado 99x em src/code_banks/bank_80.asm:3252, src/code_banks/bank_80.asm:3260, src/code_banks/bank_81.asm:5585, src/code_banks/bank_81.asm:5611, src/code_banks/bank_81.asm:5653, src/code_banks/bank_81.asm:5678, src/code_banks/bank_81.asm:5711, src/code_banks/bank_81.asm:5740
- `$096F` usado 88x em src/code_banks/bank_81.asm:8115, src/code_banks/bank_81.asm:8211, src/code_banks/bank_81.asm:8303, src/code_banks/bank_81.asm:8502, src/code_banks/bank_81.asm:8541, src/code_banks/bank_81.asm:8630, src/code_banks/bank_81.asm:8719, src/code_banks/bank_81.asm:8767
- `$7F1F5C` usado 86x em src/code_banks/bank_80.asm:2936, src/code_banks/bank_80.asm:2938, src/code_banks/bank_80.asm:2984, src/code_banks/bank_80.asm:3009, src/code_banks/bank_80.asm:3860, src/code_banks/bank_80.asm:3867, src/code_banks/bank_80.asm:3869, src/code_banks/bank_80.asm:3892
- `$0976` usado 77x em src/code_banks/bank_80.asm:3246, src/code_banks/bank_81.asm:13, src/code_banks/bank_81.asm:246, src/code_banks/bank_81.asm:259, src/code_banks/bank_81.asm:272, src/code_banks/bank_81.asm:292, src/code_banks/bank_81.asm:309, src/code_banks/bank_81.asm:326
- `$7F1F60` usado 77x em src/code_banks/bank_80.asm:2891, src/code_banks/bank_80.asm:2895, src/code_banks/bank_80.asm:2909, src/code_banks/bank_80.asm:3363, src/code_banks/bank_81.asm:5621, src/code_banks/bank_81.asm:5639, src/code_banks/bank_81.asm:5641, src/code_banks/bank_81.asm:5880
- `$7F1F5A` usado 76x em src/code_banks/bank_80.asm:179, src/code_banks/bank_80.asm:181, src/code_banks/bank_80.asm:916, src/code_banks/bank_80.asm:918, src/code_banks/bank_80.asm:959, src/code_banks/bank_80.asm:961, src/code_banks/bank_80.asm:3195, src/code_banks/bank_80.asm:3197
- `$7F1F68` usado 72x em src/code_banks/bank_80.asm:41, src/code_banks/bank_81.asm:4389, src/code_banks/bank_81.asm:4626, src/code_banks/bank_81.asm:4729, src/code_banks/bank_81.asm:4887, src/code_banks/bank_81.asm:4986, src/code_banks/bank_81.asm:9117, src/code_banks/bank_82.asm:541
- `$7F1F6A` usado 66x em src/code_banks/bank_81.asm:4789, src/code_banks/bank_81.asm:4807, src/code_banks/bank_81.asm:4825, src/code_banks/bank_81.asm:4843, src/code_banks/bank_81.asm:6904, src/code_banks/bank_81.asm:6906, src/code_banks/bank_82.asm:618, src/code_banks/bank_82.asm:621
- `$7F1F5E` usado 55x em src/code_banks/bank_80.asm:2404, src/code_banks/bank_80.asm:2407, src/code_banks/bank_80.asm:2410, src/code_banks/bank_80.asm:2887, src/code_banks/bank_80.asm:3275, src/code_banks/bank_80.asm:5459, src/code_banks/bank_81.asm:89, src/code_banks/bank_81.asm:91
- `$0114` usado 54x em src/code_banks/bank_81.asm:71, src/code_banks/bank_81.asm:6547, src/code_banks/bank_81.asm:6623, src/code_banks/bank_81.asm:6640, src/code_banks/bank_81.asm:6655, src/code_banks/bank_81.asm:6670, src/code_banks/bank_81.asm:6792, src/code_banks/bank_81.asm:8120
- `$0115` usado 51x em src/code_banks/bank_81.asm:73, src/code_banks/bank_81.asm:6549, src/code_banks/bank_81.asm:6625, src/code_banks/bank_81.asm:6642, src/code_banks/bank_81.asm:6657, src/code_banks/bank_81.asm:6672, src/code_banks/bank_81.asm:6794, src/code_banks/bank_81.asm:8122
- `$018F` usado 50x em src/code_banks/bank_81.asm:1290, src/code_banks/bank_81.asm:1582, src/code_banks/bank_81.asm:2025, src/code_banks/bank_81.asm:8345, src/code_banks/bank_81.asm:8375, src/code_banks/bank_81.asm:8840, src/code_banks/bank_81.asm:8906, src/code_banks/bank_81.asm:9070
- `$0911` usado 50x em src/code_banks/bank_80.asm:3624, src/code_banks/bank_80.asm:3633, src/code_banks/bank_80.asm:3642, src/code_banks/bank_80.asm:3651, src/code_banks/bank_81.asm:5554, src/code_banks/bank_81.asm:5648, src/code_banks/bank_81.asm:5677, src/code_banks/bank_81.asm:5680
- `$7F1F47` usado 39x em src/code_banks/bank_83.asm:12315, src/code_banks/bank_83.asm:12528, src/code_banks/bank_83.asm:12548, src/code_banks/bank_83.asm:12565, src/code_banks/bank_83.asm:12580, src/code_banks/bank_83.asm:12596, src/code_banks/bank_83.asm:12611, src/code_banks/bank_83.asm:12626
- `$0984` usado 38x em src/code_banks/bank_80.asm:3232, src/code_banks/bank_81.asm:15, src/code_banks/bank_81.asm:39, src/code_banks/bank_81.asm:62, src/code_banks/bank_81.asm:84, src/code_banks/bank_81.asm:101, src/code_banks/bank_81.asm:252, src/code_banks/bank_81.asm:265
- `$0974` usado 36x em src/code_banks/bank_80.asm:3242, src/code_banks/bank_81.asm:9, src/code_banks/bank_81.asm:1658, src/code_banks/bank_81.asm:1660, src/code_banks/bank_81.asm:1666, src/code_banks/bank_81.asm:1672, src/code_banks/bank_81.asm:1674, src/code_banks/bank_81.asm:2151
- `$019B` usado 33x em src/code_banks/bank_81.asm:8735, src/code_banks/bank_81.asm:8737, src/code_banks/bank_82.asm:6575, src/code_banks/bank_82.asm:6577, src/code_banks/bank_82.asm:6631, src/code_banks/bank_82.asm:6633, src/code_banks/bank_83.asm:2278, src/code_banks/bank_83.asm:2280
- `$7F1F49` usado 31x em src/code_banks/bank_82.asm:4490, src/code_banks/bank_82.asm:5040, src/code_banks/bank_83.asm:11965, src/code_banks/bank_83.asm:11975, src/code_banks/bank_83.asm:11985, src/code_banks/bank_83.asm:11995, src/code_banks/bank_83.asm:12005, src/code_banks/bank_83.asm:12015
- `$0970` usado 28x em src/code_banks/bank_81.asm:8148, src/code_banks/bank_81.asm:8420, src/code_banks/bank_81.asm:8460, src/code_banks/bank_81.asm:8520, src/code_banks/bank_81.asm:10190, src/code_banks/bank_81.asm:10360, src/code_banks/bank_81.asm:10529, src/code_banks/bank_81.asm:10575
- `$0980` usado 28x em src/code_banks/bank_80.asm:3237, src/code_banks/bank_81.asm:24, src/code_banks/bank_81.asm:1642, src/code_banks/bank_81.asm:1845, src/code_banks/bank_81.asm:2092, src/code_banks/bank_81.asm:2135, src/code_banks/bank_81.asm:2266, src/code_banks/bank_81.asm:2304
- `$0982` usado 28x em src/code_banks/bank_80.asm:3239, src/code_banks/bank_81.asm:28, src/code_banks/bank_81.asm:1646, src/code_banks/bank_81.asm:1849, src/code_banks/bank_81.asm:2094, src/code_banks/bank_81.asm:2139, src/code_banks/bank_81.asm:2268, src/code_banks/bank_81.asm:2306
- `$0110` usado 27x em src/code_banks/bank_80.asm:2833, src/code_banks/bank_80.asm:2850, src/code_banks/bank_80.asm:2856, src/code_banks/bank_80.asm:2862, src/code_banks/bank_80.asm:2871, src/code_banks/bank_80.asm:3289, src/code_banks/bank_82.asm:67, src/code_banks/bank_82.asm:5236
- `$096B` usado 24x em src/code_banks/bank_82_toolused_subrutines.asm:747, src/code_banks/bank_82_toolused_subrutines.asm:770, src/code_banks/bank_82_toolused_subrutines.asm:772, src/code_banks/bank_82_toolused_subrutines.asm:799, src/code_banks/bank_82_toolused_subrutines.asm:822, src/code_banks/bank_82_toolused_subrutines.asm:824, src/code_banks/bank_82_toolused_subrutines.asm:851, src/code_banks/bank_82_toolused_subrutines.asm:873
- `$7F1F58` usado 23x em src/code_banks/bank_81.asm:5731, src/code_banks/bank_83.asm:8351, src/code_banks/bank_84.asm:6625, src/code_banks/bank_84.asm:6628, src/code_banks/bank_84.asm:6634, src/code_banks/bank_84.asm:6640, src/code_banks/bank_84.asm:6646, src/code_banks/bank_84.asm:6673
- `$0915` usado 22x em src/code_banks/bank_81.asm:5589, src/code_banks/bank_81.asm:5614, src/code_banks/bank_81.asm:5660, src/code_banks/bank_81.asm:5688, src/code_banks/bank_81.asm:5714, src/code_banks/bank_81.asm:5743, src/code_banks/bank_81.asm:5758, src/code_banks/bank_81.asm:5780
- `$097A` usado 21x em src/code_banks/bank_81.asm:123, src/code_banks/bank_81.asm:1851, src/code_banks/bank_81.asm:2869, src/code_banks/bank_81.asm:3192, src/code_banks/bank_81.asm:3259, src/code_banks/bank_81.asm:3277, src/code_banks/bank_81.asm:3379, src/code_banks/bank_82_toolused_subrutines.asm:81
- `$800185` usado 21x em src/code_banks/bank_82.asm:6541, src/code_banks/bank_82.asm:6565, src/code_banks/bank_82.asm:6581, src/code_banks/bank_82.asm:6584, src/code_banks/bank_82.asm:6598, src/code_banks/bank_82.asm:6601, src/code_banks/bank_82.asm:6622, src/code_banks/bank_82.asm:6642
- `$9EBB` usado 20x em src/code_banks/bank_80.asm:3691, src/code_banks/bank_80.asm:3698, src/code_banks/bank_80.asm:3704, src/code_banks/bank_80.asm:3712, src/code_banks/bank_80.asm:3762, src/code_banks/bank_80.asm:3770, src/code_banks/bank_80.asm:3778, src/code_banks/bank_80.asm:3786
- `$018A` usado 18x em src/code_banks/bank_83.asm:2459, src/code_banks/bank_84.asm:9577, src/code_banks/bank_84.asm:9613, src/code_banks/bank_84.asm:9620, src/code_banks/bank_84.asm:9624, src/code_banks/bank_84.asm:9629, src/code_banks/bank_84.asm:9631, src/code_banks/bank_84.asm:9645
- `$018B` usado 18x em src/code_banks/bank_82.asm:7146, src/code_banks/bank_82.asm:7151, src/code_banks/bank_82.asm:7154, src/code_banks/bank_82.asm:7158, src/code_banks/bank_82.asm:7173, src/code_banks/bank_82.asm:7175, src/code_banks/bank_83.asm:2416, src/code_banks/bank_83.asm:2421
- `$0975` usado 18x em src/code_banks/bank_80.asm:3244, src/code_banks/bank_81.asm:11, src/code_banks/bank_81.asm:3178, src/code_banks/bank_81.asm:3369, src/code_banks/bank_82_toolused_subrutines.asm:88, src/code_banks/bank_82_toolused_subrutines.asm:112, src/code_banks/bank_82_toolused_subrutines.asm:349, src/code_banks/bank_82_toolused_subrutines.asm:441
- `$0978` usado 18x em src/code_banks/bank_81.asm:440, src/code_banks/bank_81.asm:468, src/code_banks/bank_81.asm:1042, src/code_banks/bank_81.asm:1447, src/code_banks/bank_81.asm:1525, src/code_banks/bank_81.asm:1596, src/code_banks/bank_81.asm:1679, src/code_banks/bank_81.asm:1831
- `$097E` usado 18x em src/code_banks/bank_81.asm:137, src/code_banks/bank_81.asm:3198, src/code_banks/bank_81.asm:3265, src/code_banks/bank_81.asm:3385, src/code_banks/bank_82_toolused_subrutines.asm:83, src/code_banks/bank_82_toolused_subrutines.asm:107, src/code_banks/bank_82_toolused_subrutines.asm:344, src/code_banks/bank_82_toolused_subrutines.asm:436
- `$0117` usado 17x em src/code_banks/bank_80.asm:3290, src/code_banks/bank_82.asm:63, src/code_banks/bank_82.asm:413, src/code_banks/bank_82.asm:5237, src/code_banks/bank_82.asm:5353, src/code_banks/bank_82.asm:5537, src/code_banks/bank_82.asm:5964, src/code_banks/bank_82.asm:6116
- `$018C` usado 17x em src/code_banks/bank_82.asm:6574, src/code_banks/bank_82.asm:6630, src/code_banks/bank_82.asm:6645, src/code_banks/bank_83.asm:2603, src/code_banks/bank_83.asm:2652, src/code_banks/bank_83.asm:2662, src/code_banks/bank_83.asm:2701, src/code_banks/bank_83.asm:2703
- `$7F1F70` usado 16x em src/code_banks/bank_81.asm:11439, src/code_banks/bank_81.asm:11441, src/code_banks/bank_81.asm:11682, src/code_banks/bank_82.asm:431, src/code_banks/bank_82.asm:433, src/code_banks/bank_82.asm:457, src/code_banks/bank_82.asm:459, src/code_banks/bank_82.asm:4485
- `$7F1F74` usado 16x em src/code_banks/bank_81.asm:284, src/code_banks/bank_81.asm:318, src/code_banks/bank_81.asm:352, src/code_banks/bank_81.asm:386, src/code_banks/bank_81.asm:414, src/code_banks/bank_81.asm:456, src/code_banks/bank_81.asm:458, src/code_banks/bank_82.asm:537
- `$0187` usado 15x em src/code_banks/bank_83.asm:2528, src/code_banks/bank_83.asm:2606, src/code_banks/bank_83.asm:2608, src/code_banks/bank_83.asm:2642, src/code_banks/bank_83.asm:2644, src/code_banks/bank_83.asm:2655, src/code_banks/bank_83.asm:2711, src/code_banks/bank_83.asm:2714
- `$08FD` usado 14x em src/code_banks/bank_84.asm:7097, src/code_banks/bank_84.asm:7183, src/code_banks/bank_84.asm:7187, src/code_banks/bank_84.asm:9856, src/code_banks/bank_84.asm:9862, src/code_banks/bank_84.asm:9868, src/code_banks/bank_84.asm:9874, src/code_banks/bank_84.asm:9880
- `$7F1F48` usado 14x em src/code_banks/bank_82.asm:4749, src/code_banks/bank_82.asm:4816, src/code_banks/bank_82.asm:4827, src/code_banks/bank_82.asm:4838, src/code_banks/bank_82.asm:4849, src/code_banks/bank_82.asm:4860, src/code_banks/bank_82.asm:4871, src/code_banks/bank_82.asm:4882
- `$0878` usado 13x em src/code_banks/bank_80.asm:3333, src/code_banks/bank_80.asm:3374, src/code_banks/bank_80.asm:3416, src/code_banks/bank_80.asm:3716, src/code_banks/bank_80.asm:3730, src/code_banks/bank_80.asm:3744, src/code_banks/bank_80.asm:3791, src/code_banks/bank_81.asm:7059
- `$098E` usado 13x em src/code_banks/bank_82.asm:810, src/code_banks/bank_82.asm:6043, src/code_banks/bank_82.asm:6051, src/code_banks/bank_82.asm:6149, src/code_banks/bank_82.asm:6319, src/code_banks/bank_82.asm:6422, src/code_banks/bank_82.asm:6896, src/code_banks/bank_83.asm:6830
- `$09A3` usado 13x em src/code_banks/bank_82.asm:679, src/code_banks/bank_82.asm:681, src/code_banks/bank_82.asm:701, src/code_banks/bank_82.asm:703, src/code_banks/bank_82.asm:723, src/code_banks/bank_82.asm:725, src/code_banks/bank_82.asm:745, src/code_banks/bank_82.asm:747
- `$0181` usado 12x em src/code_banks/bank_80.asm:5308, src/code_banks/bank_80.asm:5483, src/code_banks/bank_81.asm:3852, src/code_banks/bank_81.asm:3861, src/code_banks/bank_82.asm:2151, src/code_banks/bank_82.asm:2227, src/code_banks/bank_82.asm:2375, src/code_banks/bank_82.asm:2602
- `$087A` usado 11x em src/code_banks/bank_80.asm:3344, src/code_banks/bank_80.asm:3723, src/code_banks/bank_80.asm:3737, src/code_banks/bank_80.asm:3751, src/code_banks/bank_80.asm:3798, src/code_banks/bank_81.asm:7057, src/code_banks/bank_81.asm:7145, src/code_banks/bank_81.asm:7233
- `$092E` usado 11x em src/code_banks/bank_82.asm:2309, src/code_banks/bank_82.asm:2311, src/code_banks/bank_82.asm:2633, src/code_banks/bank_82.asm:2635, src/code_banks/bank_82.asm:2641, src/code_banks/bank_82_toolused_subrutines.asm:66, src/code_banks/bank_82_toolused_subrutines.asm:68, src/code_banks/bank_82_toolused_subrutines.asm:1278
- `$096E` usado 11x em src/code_banks/bank_81.asm:7975, src/code_banks/bank_82.asm:3386, src/code_banks/bank_83.asm:9169, src/code_banks/bank_83.asm:9339, src/code_banks/bank_83.asm:9390, src/code_banks/bank_83.asm:9421, src/code_banks/bank_83.asm:11000, src/code_banks/bank_84.asm:2435
- `$7F1F31` usado 10x em src/code_banks/bank_83.asm:4672, src/code_banks/bank_83.asm:5864, src/code_banks/bank_83.asm:6266, src/code_banks/bank_83.asm:8370, src/code_banks/bank_83.asm:8383, src/code_banks/bank_83.asm:8401, src/code_banks/bank_83.asm:8419, src/code_banks/bank_83.asm:8437
- `$018E` usado 9x em src/code_banks/bank_83.asm:2798, src/code_banks/bank_84.asm:10959, src/code_banks/bank_84.asm:10966, src/code_banks/bank_84.asm:11009, src/code_banks/bank_84.asm:11021, src/code_banks/bank_84.asm:11040, src/code_banks/bank_84.asm:11071, src/code_banks/bank_84.asm:11091
- `$098D` usado 9x em src/code_banks/bank_82.asm:5034, src/code_banks/bank_82.asm:5607, src/code_banks/bank_82.asm:5764, src/code_banks/bank_84.asm:9428, src/code_banks/bank_84.asm:9432, src/code_banks/bank_84.asm:9464, src/code_banks/bank_84.asm:9467, src/code_banks/bank_84.asm:9484
- `$0990` usado 9x em src/code_banks/bank_81.asm:8239, src/code_banks/bank_81.asm:8264, src/code_banks/bank_81.asm:8572, src/code_banks/bank_81.asm:8597, src/code_banks/bank_81.asm:8661, src/code_banks/bank_81.asm:8686, src/code_banks/bank_82.asm:253, src/code_banks/bank_82.asm:266
- `$7F1F32` usado 9x em src/code_banks/bank_83.asm:4674, src/code_banks/bank_83.asm:5867, src/code_banks/bank_83.asm:6269, src/code_banks/bank_83.asm:7657, src/code_banks/bank_83.asm:7661, src/code_banks/bank_83.asm:8463, src/code_banks/bank_83.asm:9408, src/code_banks/bank_84.asm:5988
- `$0103` usado 8x em src/code_banks/bank_81.asm:8131, src/code_banks/bank_82.asm:1803, src/code_banks/bank_83.asm:491, src/code_banks/bank_83.asm:513, src/code_banks/bank_83.asm:542, src/code_banks/bank_83.asm:544, src/code_banks/bank_83.asm:609, src/code_banks/bank_83.asm:1588
- `$0185` usado 8x em src/code_banks/bank_83.asm:2275, src/code_banks/bank_83.asm:2634, src/code_banks/bank_83.asm:2807, src/code_banks/bank_83.asm:2970, src/code_banks/bank_83.asm:2973, src/code_banks/bank_83.asm:2977, src/code_banks/bank_83.asm:2980, src/code_banks/bank_84.asm:10889
- `$01AE` usado 8x em src/code_banks/bank_85.asm:253, src/code_banks/bank_85.asm:319, src/code_banks/bank_85.asm:384, src/code_banks/bank_85.asm:462, src/code_banks/bank_85.asm:486, src/code_banks/bank_85.asm:498, src/code_banks/bank_85.asm:511, src/code_banks/bank_85.asm:515
- `$0993` usado 8x em src/code_banks/bank_82.asm:7028, src/code_banks/bank_82.asm:7055, src/code_banks/bank_82.asm:7321, src/code_banks/bank_82.asm:7376, src/code_banks/bank_84.asm:8985, src/code_banks/bank_84.asm:9004, src/code_banks/bank_84.asm:9024, src/code_banks/bank_84.asm:9046
- `$099F` usado 8x em src/code_banks/bank_81.asm:10231, src/code_banks/bank_81.asm:11294, src/code_banks/bank_82.asm:6909, src/code_banks/bank_82.asm:7101, src/code_banks/bank_83.asm:9209, src/code_banks/bank_83.asm:11206, src/code_banks/bank_83.asm:11212, src/code_banks/bank_83.asm:11634
- `$09A0` usado 8x em src/code_banks/bank_81.asm:10312, src/code_banks/bank_81.asm:10376, src/code_banks/bank_81.asm:10497, src/code_banks/bank_81.asm:10504, src/code_banks/bank_81.asm:10596, src/code_banks/bank_81.asm:10685, src/code_banks/bank_81.asm:10692, src/code_banks/bank_84.asm:5125
- `$0192` usado 7x em src/code_banks/bank_82.asm:6569, src/code_banks/bank_82.asm:6625, src/code_banks/bank_83.asm:2692, src/code_banks/bank_83.asm:2892, src/code_banks/bank_83.asm:2895, src/code_banks/bank_83.asm:2906, src/code_banks/bank_83.asm:2909
- `$0920` usado 7x em src/code_banks/bank_81.asm:1872, src/code_banks/bank_81.asm:1907, src/code_banks/bank_84.asm:3522, src/code_banks/bank_84.asm:5800, src/code_banks/bank_84.asm:5935, src/code_banks/bank_84.asm:8284, src/code_banks/bank_84.asm:8379
- `$09A4` usado 7x em src/code_banks/bank_81.asm:11904, src/code_banks/bank_81.asm:11919, src/code_banks/bank_83.asm:9672, src/code_banks/bank_83.asm:9694, src/code_banks/bank_83.asm:9708, src/code_banks/bank_83.asm:9710, src/code_banks/bank_83.asm:9713
- `$7EA320` usado 7x em src/code_banks/bank_85.asm:1462, src/code_banks/bank_85.asm:1464, src/code_banks/bank_85.asm:1482, src/code_banks/bank_85.asm:1485, src/code_banks/bank_85.asm:1550, src/code_banks/bank_85.asm:1582, src/code_banks/bank_85.asm:1795
- `$7F0D00` usado 7x em src/code_banks/bank_80.asm:1968, src/code_banks/bank_80.asm:1989, src/code_banks/bank_80.asm:2020, src/code_banks/bank_80.asm:2080, src/code_banks/bank_80.asm:2185, src/code_banks/bank_80.asm:2219, src/code_banks/bank_80.asm:2254
- `$7F1F2B` usado 7x em src/code_banks/bank_83.asm:4668, src/code_banks/bank_83.asm:5858, src/code_banks/bank_83.asm:6260, src/code_banks/bank_83.asm:7330, src/code_banks/bank_83.asm:7339, src/code_banks/bank_83.asm:7345, src/code_banks/bank_83.asm:8680
- `EventCmd_31_CowRelated_AddCowHappiness` usado 7x em src/code_banks/bank_83.asm:6970, src/code_banks/bank_83.asm:6978, src/code_banks/bank_83.asm:6986, src/code_banks/bank_83.asm:6994, src/code_banks/bank_83.asm:7029, src/code_banks/bank_83.asm:7056, src/code_banks/bank_83.asm:7098
- `$019C` usado 6x em src/code_banks/bank_85.asm:159, src/code_banks/bank_85.asm:285, src/code_banks/bank_85.asm:304, src/code_banks/bank_85.asm:366, src/code_banks/bank_85.asm:428, src/code_banks/bank_85.asm:505
- `$019E` usado 6x em src/code_banks/bank_85.asm:211, src/code_banks/bank_85.asm:224, src/code_banks/bank_85.asm:232, src/code_banks/bank_85.asm:306, src/code_banks/bank_85.asm:368, src/code_banks/bank_85.asm:445
- `$01A6` usado 6x em src/code_banks/bank_85.asm:166, src/code_banks/bank_85.asm:219, src/code_banks/bank_85.asm:314, src/code_banks/bank_85.asm:376, src/code_banks/bank_85.asm:533, src/code_banks/bank_85.asm:550
- `$08FF` usado 6x em src/code_banks/bank_84.asm:7105, src/code_banks/bank_84.asm:7126, src/code_banks/bank_84.asm:7129, src/code_banks/bank_84.asm:7195, src/code_banks/bank_84.asm:7216, src/code_banks/bank_84.asm:7219
- `$0905` usado 6x em src/code_banks/bank_81.asm:7580, src/code_banks/bank_81.asm:7586, src/code_banks/bank_81.asm:7622, src/code_banks/bank_81.asm:7631, src/code_banks/bank_85.asm:548, src/code_banks/bank_85.asm:581
- `$090D` usado 6x em src/code_banks/bank_80.asm:3238, src/code_banks/bank_80.asm:4000, src/code_banks/bank_80.asm:4016, src/code_banks/bank_80.asm:4025, src/code_banks/bank_81.asm:2093, src/code_banks/bank_83.asm:2306
- `$0953` usado 6x em src/code_banks/bank_84.asm:4549, src/code_banks/bank_84.asm:4553, src/code_banks/bank_84.asm:4680, src/code_banks/bank_84.asm:4684, src/code_banks/bank_84.asm:4810, src/code_banks/bank_84.asm:4814
- `$09A1` usado 6x em src/code_banks/bank_81.asm:10950, src/code_banks/bank_81.asm:10957, src/code_banks/bank_81.asm:11049, src/code_banks/bank_81.asm:11138, src/code_banks/bank_81.asm:11145, src/code_banks/bank_84.asm:3686
- `$7F1F12` usado 6x em src/code_banks/bank_83.asm:4666, src/code_banks/bank_83.asm:5855, src/code_banks/bank_83.asm:6257, src/code_banks/bank_83.asm:7308, src/code_banks/bank_83.asm:7310, src/code_banks/bank_84.asm:4227
- `$7F1F15` usado 6x em src/code_banks/bank_81.asm:10480, src/code_banks/bank_81.asm:10933, src/code_banks/bank_84.asm:3678, src/code_banks/bank_84.asm:5093, src/code_banks/bank_84.asm:5106, src/code_banks/bank_84.asm:5115
- `$7F1F17` usado 6x em src/code_banks/bank_81.asm:10483, src/code_banks/bank_81.asm:10936, src/code_banks/bank_84.asm:3681, src/code_banks/bank_84.asm:5096, src/code_banks/bank_84.asm:5109, src/code_banks/bank_84.asm:5118
- `$7F1F45` usado 6x em src/code_banks/bank_81.asm:12285, src/code_banks/bank_83.asm:4718, src/code_banks/bank_83.asm:5934, src/code_banks/bank_83.asm:6336, src/code_banks/bank_83.asm:7582, src/code_banks/bank_83.asm:7624
- `$0022` usado 5x em src/code_banks/bank_80.asm:2492, src/code_banks/bank_80.asm:3656, src/code_banks/bank_81.asm:4010, src/code_banks/bank_81.asm:4017, src/code_banks/bank_81.asm:4024
