# Bank 80 Pointer42 Map/Time Installers 100% - Pass 45

Esta pass fecha o escopo de auditoria das familias Pointer42 do bank 80. O objetivo foi classificar o dispatcher, a tabela por mapa/horario e as rotinas que instalam scripts de animacao de paleta nos slots Pointer42.

## Arquivos principais

```text
src/code_banks/bank_80.asm
src/code_banks/bank_80_pointersubrutines.asm
```

## Dispatcher

`PaletteAnim_RunMapTimeInstaller` usa `!tilemap_to_load`, `!hour` e `!season` para escolher uma rotina instaladora em `PaletteAnim_MapTimeInstallerTable`.

Cada tilemap ocupa 6 palavras na tabela:

| Entrada | Uso |
|---:|---|
| 0 | hora `< 7` |
| 1 | `7 <= hora < 15` |
| 2 | `15 <= hora < 17` |
| 3 | `17 <= hora < 18` |
| 4 | hora `>= 18` |
| 5 | controle sazonal; se nao for `$FFFF`, o grupo so roda no outono/inverno |

`$FFFF` significa sem instalador ou sem gate sazonal. `$0001` aparece como flag de gate sazonal no sexto word.

## Dados fechados

| Simbolo | Endereco | Papel |
|---|---:|---|
| `PaletteAnim_MapTimeInstallerTable` | `$80BEEC` | 96 grupos de tilemap, 576 words no total |
| `PaletteAnim_RunMapTimeInstaller` | `$809553` | escolhe o grupo por tilemap/hora e respeita o gate sazonal |
| `PaletteAnim_Bank80Pointer42ScriptData` | `$80DD5B` | scripts Pointer42 brutos usados pelos instaladores |

Formato dos scripts: comando normal `dw color` + `db delay`; comando `$FFFE` seguido de ponteiro 24-bit faz loop/jump.

## Grupos ativos

| Tilemap | <7 | 7-14 | 15-16 | 17 | >=18 | Gate |
|---:|---|---|---|---|---|---|
| `$00` | DD5B_DDB2 | DD5B_DDB2 | DDCF_DE26 | DE43_DE9A | DEB7_DF0E | - |
| `$01` | DD5B_DDB2 | DD5B_DDB2 | DDCF_DE26 | DE43_DE9A | DEB7_DF0E | - |
| `$02` | DF2B_DF82 | DF2B_DF82 | DF9F_DFF6 | E013_E06A | E087_E0DE | - |
| `$04` | - | E2F7_E313 | E321_E33D | E34B_E367 | E375_E522 | - |
| `$05` | - | E39F_E3BB | E3C9_E3E5 | E3F3_E40F | E41D_E566 | - |
| `$06` | - | E447_E463 | E471_E48D | E49B_E4B7 | E4C5_E5AA | - |
| `$07` | - | - | - | - | E5BB_E5EE | - |
| `$08` | - | E2F7_E313 | - | - | - | - |
| `$09` | - | E447_EEEC | - | - | - | - |
| `$0A` | - | E447_E463 | - | - | EDDE_EDFA | - |
| `$0B` | - | E2F7_E313 | - | - | - | - |
| `$10` | - | E5FF_EB5D | E672_EB7F | E6E5_EBA1 | E758_EBC3 | - |
| `$11` | - | E7B4_EBE5 | E827_EC07 | E89A_EC29 | E8F6_EC4B | - |
| `$12` | - | E952_EC6D | E9F3_EC8F | EA94_ECB1 | EAF0_ECD3 | - |
| `$13` | - | ECE4_ECF5 | ED06_ED17 | ED28_ED39 | ED4A_ED5B | - |
| `$14` | - | ECE4_ECF5 | ED06_ED17 | ED28_ED39 | ED4A_ED5B | - |
| `$15` | E172_E193 | E172_E193 | E172_E193 | E172_E193 | E172_E193 | `$0001` |
| `$16` | E172_E193 | E172_E193 | E172_E193 | E172_E193 | E172_E193 | `$0001` |
| `$17` | E172_E193 | E172_E193 | E172_E193 | E172_E193 | E172_E193 | `$0001` |
| `$18` | - | E19E_E1BF | E19E_E1BF | E19E_E1BF | E19E_E1BF | `$0001` |
| `$19` | - | - | - | - | - | `$0001` |
| `$1A` | - | - | - | - | - | `$0001` |
| `$1B` | - | E1CA_E241 | E1CA_E241 | E1CA_E241 | E1CA_E241 | - |
| `$1C` | - | - | - | - | - | `$0001` |
| `$1D` | - | E252_E273 | E252_E273 | E252_E273 | E252_E273 | `$0001` |
| `$1E` | - | - | - | - | - | `$0001` |
| `$1F` | - | E27E_E29F | E27E_E29F | E27E_E29F | E27E_E29F | `$0001` |
| `$20` | - | - | - | - | - | `$0001` |
| `$21` | - | EF06_EF1C | EF06_EF1C | EF06_EF1C | EF06_EF1C | `$0001` |
| `$22` | - | - | - | - | - | `$0001` |
| `$23` | - | E2AA_E2CB | E2AA_E2CB | E2AA_E2CB | E2AA_E2CB | `$0001` |
| `$24` | - | E2D6_E2EC | E2D6_E2EC | E2D6_E2EC | E2D6_E2EC | `$0001` |
| `$25` | - | EE08_EE94 | EE08_EE94 | EE08_EE94 | EE08_EE94 | - |
| `$2A` | E0FB_E161 | E0FB_E161 | E0FB_E161 | E0FB_E161 | E0FB_E161 | - |
| `$2C` | ED9A_EDCD | ED9A_EDCD | ED9A_EDCD | ED9A_EDCD | ED9A_EDCD | - |
| `$31` | - | - | - | - | ED6C_ED83 | - |
| `$32` | - | - | - | - | ED6C_ED83 | - |
| `$33` | - | - | - | - | ED6C_ED83 | - |
| `$34` | - | - | - | - | ED6C_ED83 | - |
| `$39` | - | - | - | - | ED6C_ED83 | - |

## Inventario de instaladores

O nome de cada rotina indica o primeiro e o ultimo script que ela instala no bloco `$80DD5B-$80EF1C`.

| Installer | Slots | Rows | Color indexes |
|---|---:|---|---|
| `PaletteAnim_InstallScriptSet_DD5B_DDB2` | 4 | `$04` | `$09,$0A,$0B,$0C` |
| `PaletteAnim_InstallScriptSet_DDCF_DE26` | 4 | `$04` | `$09,$0A,$0B,$0C` |
| `PaletteAnim_InstallScriptSet_DE43_DE9A` | 4 | `$04` | `$09,$0A,$0B,$0C` |
| `PaletteAnim_InstallScriptSet_DEB7_DF0E` | 4 | `$04` | `$09,$0A,$0B,$0C` |
| `PaletteAnim_InstallScriptSet_DF2B_DF82` | 4 | `$04` | `$09,$0A,$0B,$0C` |
| `PaletteAnim_InstallScriptSet_DF9F_DFF6` | 4 | `$04` | `$09,$0A,$0B,$0C` |
| `PaletteAnim_InstallScriptSet_E013_E06A` | 4 | `$04` | `$09,$0A,$0B,$0C` |
| `PaletteAnim_InstallScriptSet_E087_E0DE` | 4 | `$04` | `$09,$0A,$0B,$0C` |
| `PaletteAnim_InstallScriptSet_E0FB_E161` | 7 | `$02` | `$06,$07,$0B,$0C,$0D,$0E,$0F` |
| `PaletteAnim_InstallScriptSet_E172_E193` | 4 | `$03` | `$02,$0D,$0E,$0F` |
| `PaletteAnim_InstallScriptSet_E19E_E1BF` | 4 | `$01,$02` | `$07,$08,$09,$09` |
| `PaletteAnim_InstallScriptSet_E1CA_E241` | 8 | `$05` | `$01,$04,$07,$08,$09,$0B,$0D,$0E` |
| `PaletteAnim_InstallScriptSet_E252_E273` | 4 | `$01` | `$08,$0B,$0C,$0D` |
| `PaletteAnim_InstallScriptSet_E27E_E29F` | 4 | `$02` | `$07,$08,$0D,$0E` |
| `PaletteAnim_InstallScriptSet_E2AA_E2CB` | 4 | `$01` | `$0A,$0B,$0C,$0D` |
| `PaletteAnim_InstallScriptSet_E2D6_E2EC` | 3 | `$02` | `$0D,$0E,$0F` |
| `PaletteAnim_InstallScriptSet_E2F7_E313` | 3 | `$02` | `$06,$0E,$0F` |
| `PaletteAnim_InstallScriptSet_E321_E33D` | 3 | `$02` | `$06,$0E,$0F` |
| `PaletteAnim_InstallScriptSet_E34B_E367` | 3 | `$02` | `$06,$0E,$0F` |
| `PaletteAnim_InstallScriptSet_E375_E522` | 7 | `$02` | `$06,$0E,$0F,$03,$04,$05,$07` |
| `PaletteAnim_InstallScriptSet_E39F_E3BB` | 3 | `$02` | `$06,$0E,$0F` |
| `PaletteAnim_InstallScriptSet_E3C9_E3E5` | 3 | `$02` | `$06,$0E,$0F` |
| `PaletteAnim_InstallScriptSet_E3F3_E40F` | 3 | `$02` | `$06,$0E,$0F` |
| `PaletteAnim_InstallScriptSet_E41D_E566` | 7 | `$02` | `$06,$0E,$0F,$03,$04,$05,$07` |
| `PaletteAnim_InstallScriptSet_E447_E463` | 3 | `$02` | `$06,$0E,$0F` |
| `PaletteAnim_InstallScriptSet_E471_E48D` | 3 | `$02` | `$06,$0E,$0F` |
| `PaletteAnim_InstallScriptSet_E49B_E4B7` | 3 | `$02` | `$06,$0E,$0F` |
| `PaletteAnim_InstallScriptSet_E4C5_E5AA` | 7 | `$02` | `$06,$0E,$0F,$03,$04,$05,$07` |
| `PaletteAnim_InstallScriptSet_E5BB_E5EE` | 4 | `$02` | `$03,$04,$05,$07` |
| `PaletteAnim_InstallScriptSet_E5FF_EB5D` | 7 | `$03,$04` | `$08,$09,$0A,$0B,$0C,$0A,$0B` |
| `PaletteAnim_InstallScriptSet_E672_EB7F` | 7 | `$03,$04` | `$08,$09,$0A,$0B,$0C,$0A,$0B` |
| `PaletteAnim_InstallScriptSet_E6E5_EBA1` | 7 | `$03,$04` | `$08,$09,$0A,$0B,$0C,$0A,$0B` |
| `PaletteAnim_InstallScriptSet_E758_EBC3` | 6 | `$03,$04` | `$08,$09,$0A,$0B,$0A,$0B` |
| `PaletteAnim_InstallScriptSet_E7B4_EBE5` | 7 | `$03,$04` | `$08,$09,$0A,$0B,$0C,$0A,$0B` |
| `PaletteAnim_InstallScriptSet_E827_EC07` | 7 | `$03,$04` | `$08,$09,$0A,$0B,$0C,$0A,$0B` |
| `PaletteAnim_InstallScriptSet_E89A_EC29` | 6 | `$03,$04` | `$08,$09,$0A,$0B,$0A,$0B` |
| `PaletteAnim_InstallScriptSet_E8F6_EC4B` | 6 | `$03,$04` | `$08,$09,$0A,$0B,$0A,$0B` |
| `PaletteAnim_InstallScriptSet_E952_EC6D` | 9 | `$03,$04` | `$06,$07,$08,$09,$0A,$0B,$0C,$0A,$0B` |
| `PaletteAnim_InstallScriptSet_E9F3_EC8F` | 9 | `$03,$04` | `$06,$07,$08,$09,$0A,$0B,$0C,$0A,$0B` |
| `PaletteAnim_InstallScriptSet_EA94_ECB1` | 6 | `$03,$04` | `$08,$09,$0A,$0B,$0A,$0B` |
| `PaletteAnim_InstallScriptSet_EAF0_ECD3` | 6 | `$03,$04` | `$08,$09,$0A,$0B,$0A,$0B` |
| `PaletteAnim_InstallScriptSet_ECE4_ECF5` | 2 | `$04` | `$0A,$0B` |
| `PaletteAnim_InstallScriptSet_ED06_ED17` | 2 | `$04` | `$0A,$0B` |
| `PaletteAnim_InstallScriptSet_ED28_ED39` | 2 | `$04` | `$0A,$0B` |
| `PaletteAnim_InstallScriptSet_ED4A_ED5B` | 2 | `$04` | `$0A,$0B` |
| `PaletteAnim_InstallScriptSet_ED6C_ED83` | 2 | `$04` | `$03,$05` |
| `PaletteAnim_InstallScriptSet_ED9A_EDCD` | 4 | `$04` | `$0B,$0C,$0D,$0E` |
| `PaletteAnim_InstallScriptSet_EDDE_EDFA` | 3 | `$04` | `$0C,$0D,$0E` |
| `PaletteAnim_InstallScriptSet_EE08_EE94` | 11 | `$01,$03` | `$07,$08,$0D,$0E,$06,$09,$0A,$0B,$0C,$0D,$0E` |
| `PaletteAnim_InstallScriptSet_E447_EEEC` | 8 | `$02,$06` | `$06,$0E,$0F,$0C,$0D,$0F,$05,$0E` |
| `PaletteAnim_InstallScriptSet_EF06_EF1C` | 3 | `$02` | `$07,$0D,$0E` |

## Estado do escopo

Este escopo esta fechado como **100%** porque o dispatcher foi nomeado, a tabela foi classificada por tilemap/hora/estacao, as 51 rotinas instaladoras ganharam nomes humanos e o bloco bruto de scripts foi identificado. A decodificacao linha-a-linha de cada script bruto pode ser uma pass futura menor, mas a familia e o uso de todos os instaladores do bank 80 ja estao mapeados.
