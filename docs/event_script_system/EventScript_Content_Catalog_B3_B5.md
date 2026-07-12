# Event Script Content Catalog B3-B5

Catalogo gerado a partir da ROM local apenas para metadados de engenharia reversa. Nao inclui ROM nem conteudo textual/script bruto.

- MD5 da ROM usada na validacao: `c9bf36a816b6d54aed79d43a6c45111a`
- Tabela mestre: `$B38000`
- Grupos catalogados: `72` (`$00-$47`)
- Entradas de ponteiro de subscript/event entry: `1288`
- Destinos unicos aproximados: `439`
- Distribuicao por banco: $B3=15, $B4=52, $B5=5

## Como ler

Cada grupo aponta para uma tabela local de ponteiros de 16 bits. O banco efetivo vem do proprio grupo (`B3`, `B4` ou `B5`). `repeated_entries` indica slots que reutilizam o mesmo destino, comum em grupos com variantes/direcoes vazias. `entry_first_byte_histogram` e apenas uma assinatura tecnica do primeiro byte nos destinos unicos, nao uma traducao completa dos comandos.

## Tabela de grupos

| Grupo | Label | Tabela | Banco | Ponteiros | Destinos unicos | Repetidos | Primeiro alvo | Ultimo alvo | Assinatura primeiro byte |
|---:|---|---:|---:|---:|---:|---:|---:|---:|---|
| `$00` | `EventScriptGroup_00` | `$B38BB8` | `$B3` | 136 | 135 | 1 | `$B38CC8` | `$B39313` | `$2F:52 $1B:35 $2B:22 $1A:21 $49:2 $13:2 $09:1` |
| `$01` | `EventScriptGroup_01` | `$B39359` | `$B3` | 16 | 12 | 4 | `$B39379` | `$B3AE03` | `$11:11 $23:1` |
| `$02` | `EventScriptGroup_02` | `$B3AE03` | `$B3` | 16 | 6 | 10 | `$B3AE23` | `$B3BA39` | `$11:5 $59:1` |
| `$03` | `EventScriptGroup_03` | `$B3BA39` | `$B3` | 16 | 4 | 12 | `$B3BA59` | `$B3C507` | `$11:3 $27:1` |
| `$04` | `EventScriptGroup_04` | `$B3C507` | `$B3` | 16 | 9 | 7 | `$B3C527` | `$B3CC71` | `$11:6 $09:2 $91:1` |
| `$05` | `EventScriptGroup_05` | `$B3CC71` | `$B3` | 16 | 2 | 14 | `$B3CC91` | `$B3D447` | `$11:1 $67:1` |
| `$06` | `EventScriptGroup_06` | `$B3D447` | `$B3` | 16 | 8 | 8 | `$B3D467` | `$B3D9F7` | `$11:7 $17:1` |
| `$07` | `EventScriptGroup_07` | `$B3D9F7` | `$B3` | 16 | 9 | 7 | `$B3DA17` | `$B3E0BF` | `$11:8 $DF:1` |
| `$08` | `EventScriptGroup_08` | `$B3E0BF` | `$B3` | 16 | 9 | 7 | `$B3E0DF` | `$B3E603` | `$11:8 $23:1` |
| `$09` | `EventScriptGroup_09` | `$B3E603` | `$B3` | 16 | 2 | 14 | `$B3E623` | `$B3E83B` | `$40:1 $5B:1` |
| `$0A` | `EventScriptGroup_0A` | `$B3E83B` | `$B3` | 16 | 7 | 9 | `$B3E85B` | `$B3E9DA` | `$4F:4 $02:2 $FA:1` |
| `$0B` | `EventScriptGroup_0B` | `$B3E9DA` | `$B3` | 16 | 13 | 3 | `$B3E9FA` | `$B3EF5A` | `$09:9 $02:2 $07:1 $7A:1` |
| `$0C` | `EventScriptGroup_0C` | `$B3EF5A` | `$B3` | 16 | 3 | 13 | `$B3EF7A` | `$B3F068` | `$50:2 $88:1` |
| `$0D` | `EventScriptGroup_0D` | `$B3F068` | `$B3` | 16 | 3 | 13 | `$B3F088` | `$B3F0E6` | `$50:2 $06:1` |
| `$0E` | `EventScriptGroup_0E` | `$B3F0E6` | `$B3` | 16 | 3 | 13 | `$B3F106` | `$B3FFA4` | `$4F:2 $00:1` |
| `$0F` | `EventScriptGroup_0F` | `$B48000` | `$B4` | 16 | 7 | 9 | `$B48020` | `$B487B8` | `$4F:6 $D8:1` |
| `$10` | `EventScriptGroup_10` | `$B487B8` | `$B4` | 16 | 2 | 14 | `$B487D8` | `$B48818` | `$08:1 $38:1` |
| `$11` | `EventScriptGroup_11` | `$B48818` | `$B4` | 16 | 2 | 14 | `$B48838` | `$B488A0` | `$50:1 $C0:1` |
| `$12` | `EventScriptGroup_12` | `$B488A0` | `$B4` | 16 | 2 | 14 | `$B488C0` | `$B4892A` | `$50:1 $4A:1` |
| `$13` | `EventScriptGroup_13` | `$B4892A` | `$B4` | 16 | 2 | 14 | `$B4894A` | `$B489D2` | `$50:1 $F2:1` |
| `$14` | `EventScriptGroup_14` | `$B489D2` | `$B4` | 16 | 6 | 10 | `$B489F2` | `$B48C25` | `$4F:4 $50:1 $45:1` |
| `$15` | `EventScriptGroup_15` | `$B48C25` | `$B4` | 16 | 2 | 14 | `$B48C45` | `$B48D38` | `$05:1 $58:1` |
| `$16` | `EventScriptGroup_16` | `$B48D38` | `$B4` | 16 | 2 | 14 | `$B48D58` | `$B48E05` | `$50:1 $25:1` |
| `$17` | `EventScriptGroup_17` | `$B48E05` | `$B4` | 16 | 2 | 14 | `$B48E25` | `$B48EC5` | `$00:1 $E5:1` |
| `$18` | `EventScriptGroup_18` | `$B48EC5` | `$B4` | 16 | 2 | 14 | `$B48EE5` | `$B48F95` | `$09:1 $B5:1` |
| `$19` | `EventScriptGroup_19` | `$B48F95` | `$B4` | 16 | 3 | 13 | `$B48FB5` | `$B490D3` | `$50:2 $F3:1` |
| `$1A` | `EventScriptGroup_1A` | `$B490D3` | `$B4` | 16 | 3 | 13 | `$B490F3` | `$B491B3` | `$50:2 $D3:1` |
| `$1B` | `EventScriptGroup_1B` | `$B491B3` | `$B4` | 16 | 3 | 13 | `$B491D3` | `$B492D2` | `$50:1 $00:1 $F2:1` |
| `$1C` | `EventScriptGroup_1C` | `$B492D2` | `$B4` | 16 | 4 | 12 | `$B492F2` | `$B4943C` | `$50:2 $00:1 $5C:1` |
| `$1D` | `EventScriptGroup_1D` | `$B4943C` | `$B4` | 16 | 5 | 11 | `$B4945C` | `$B4967A` | `$50:3 $09:1 $9A:1` |
| `$1E` | `EventScriptGroup_1E` | `$B4967A` | `$B4` | 16 | 2 | 14 | `$B4969A` | `$B49A3F` | `$50:1 $5F:1` |
| `$1F` | `EventScriptGroup_1F` | `$B49A3F` | `$B4` | 16 | 4 | 12 | `$B49A5F` | `$B49E31` | `$50:3 $51:1` |
| `$20` | `EventScriptGroup_20` | `$B49E31` | `$B4` | 16 | 2 | 14 | `$B49E51` | `$B49F13` | `$50:1 $33:1` |
| `$21` | `EventScriptGroup_21` | `$B49F13` | `$B4` | 16 | 2 | 14 | `$B49F33` | `$B49FD8` | `$09:1 $F8:1` |
| `$22` | `EventScriptGroup_22` | `$B49FD8` | `$B4` | 16 | 14 | 2 | `$B49FF8` | `$B4A37F` | `$50:13 $9F:1` |
| `$23` | `EventScriptGroup_23` | `$B4A37F` | `$B4` | 16 | 2 | 14 | `$B4A39F` | `$B4A455` | `$09:1 $75:1` |
| `$24` | `EventScriptGroup_24` | `$B4A455` | `$B4` | 16 | 5 | 11 | `$B4A475` | `$B4A5B5` | `$08:4 $D5:1` |
| `$25` | `EventScriptGroup_25` | `$B4A5B5` | `$B4` | 16 | 2 | 14 | `$B4A5D5` | `$B4A60D` | `$02:1 $2D:1` |
| `$26` | `EventScriptGroup_26` | `$B4A60D` | `$B4` | 16 | 3 | 13 | `$B4A62D` | `$B4B65E` | `$4F:2 $7E:1` |
| `$27` | `EventScriptGroup_27` | `$B4B65E` | `$B4` | 16 | 5 | 11 | `$B4B67E` | `$B4BACB` | `$4F:4 $EB:1` |
| `$28` | `EventScriptGroup_28` | `$B4BACB` | `$B4` | 16 | 5 | 11 | `$B4BAEB` | `$B4C427` | `$4F:4 $47:1` |
| `$29` | `EventScriptGroup_29` | `$B4C427` | `$B4` | 16 | 2 | 14 | `$B4C447` | `$B4C4B8` | `$09:1 $D8:1` |
| `$2A` | `EventScriptGroup_2A` | `$B4C4B8` | `$B4` | 16 | 2 | 14 | `$B4C4D8` | `$B4C504` | `$1A:1 $24:1` |
| `$2B` | `EventScriptGroup_2B` | `$B4C504` | `$B4` | 16 | 2 | 14 | `$B4C524` | `$B4C548` | `$1A:1 $68:1` |
| `$2C` | `EventScriptGroup_2C` | `$B4C548` | `$B4` | 16 | 2 | 14 | `$B4C568` | `$B4C584` | `$1A:1 $A4:1` |
| `$2D` | `EventScriptGroup_2D` | `$B4C584` | `$B4` | 16 | 2 | 14 | `$B4C5A4` | `$B4C5F4` | `$07:1 $14:1` |
| `$2E` | `EventScriptGroup_2E` | `$B4C5F4` | `$B4` | 16 | 2 | 14 | `$B4C614` | `$B4C6F1` | `$00:1 $11:1` |
| `$2F` | `EventScriptGroup_2F` | `$B4C6F1` | `$B4` | 16 | 2 | 14 | `$B4C711` | `$B4C7C3` | `$00:1 $E3:1` |
| `$30` | `EventScriptGroup_30` | `$B4C7C3` | `$B4` | 16 | 2 | 14 | `$B4C7E3` | `$B4C9F9` | `$00:1 $19:1` |
| `$31` | `EventScriptGroup_31` | `$B4C9F9` | `$B4` | 16 | 2 | 14 | `$B4CA19` | `$B4CB3F` | `$00:1 $5F:1` |
| `$32` | `EventScriptGroup_32` | `$B4CB3F` | `$B4` | 16 | 2 | 14 | `$B4CB5F` | `$B4CD56` | `$00:1 $76:1` |
| `$33` | `EventScriptGroup_33` | `$B4CD56` | `$B4` | 16 | 2 | 14 | `$B4CD76` | `$B4CECA` | `$00:1 $EA:1` |
| `$34` | `EventScriptGroup_34` | `$B4CECA` | `$B4` | 16 | 2 | 14 | `$B4CEEA` | `$B4D011` | `$47:1 $31:1` |
| `$35` | `EventScriptGroup_35` | `$B4D011` | `$B4` | 16 | 2 | 14 | `$B4D031` | `$B4D160` | `$47:1 $80:1` |
| `$36` | `EventScriptGroup_36` | `$B4D160` | `$B4` | 16 | 2 | 14 | `$B4D180` | `$B4D2CC` | `$00:1 $EC:1` |
| `$37` | `EventScriptGroup_37` | `$B4D2CC` | `$B4` | 16 | 2 | 14 | `$B4D2EC` | `$B4D447` | `$47:1 $67:1` |
| `$38` | `EventScriptGroup_38` | `$B4D447` | `$B4` | 16 | 2 | 14 | `$B4D467` | `$B4D531` | `$00:1 $51:1` |
| `$39` | `EventScriptGroup_39` | `$B4D531` | `$B4` | 16 | 2 | 14 | `$B4D551` | `$B4D772` | `$00:1 $92:1` |
| `$3A` | `EventScriptGroup_3A` | `$B4D772` | `$B4` | 16 | 3 | 13 | `$B4D792` | `$B4DA22` | `$00:2 $42:1` |
| `$3B` | `EventScriptGroup_3B` | `$B4DA22` | `$B4` | 16 | 3 | 13 | `$B4DA42` | `$B4DCCD` | `$00:2 $ED:1` |
| `$3C` | `EventScriptGroup_3C` | `$B4DCCD` | `$B4` | 16 | 3 | 13 | `$B4DCED` | `$B4DF94` | `$00:2 $B4:1` |
| `$3D` | `EventScriptGroup_3D` | `$B4DF94` | `$B4` | 16 | 3 | 13 | `$B4DFB4` | `$B4E200` | `$00:2 $20:1` |
| `$3E` | `EventScriptGroup_3E` | `$B4E200` | `$B4` | 16 | 2 | 14 | `$B4E220` | `$B4E3FF` | `$00:1 $1F:1` |
| `$3F` | `EventScriptGroup_3F` | `$B4E3FF` | `$B4` | 16 | 2 | 14 | `$B4E41F` | `$B4E5F4` | `$00:1 $14:1` |
| `$40` | `EventScriptGroup_40` | `$B4E5F4` | `$B4` | 16 | 2 | 14 | `$B4E614` | `$B4E7AF` | `$00:1 $CF:1` |
| `$41` | `EventScriptGroup_41` | `$B4E7AF` | `$B4` | 16 | 2 | 14 | `$B4E7CF` | `$B4E989` | `$47:1 $A9:1` |
| `$42` | `EventScriptGroup_42` | `$B4E989` | `$B4` | 16 | 3 | 13 | `$B4E9A9` | `$B4ECB4` | `$00:3` |
| `$43` | `EventScriptGroup_43` | `$B58000` | `$B5` | 16 | 6 | 10 | `$B58020` | `$B597D1` | `$14:5 $F1:1` |
| `$44` | `EventScriptGroup_44` | `$B597D1` | `$B5` | 16 | 6 | 10 | `$B597F1` | `$B5A1E5` | `$14:4 $15:1 $05:1` |
| `$45` | `EventScriptGroup_45` | `$B5A1E5` | `$B5` | 16 | 7 | 9 | `$B5A205` | `$B5A703` | `$45:4 $14:2 $23:1` |
| `$46` | `EventScriptGroup_46` | `$B5A703` | `$B5` | 16 | 14 | 2 | `$B5A723` | `$B5AC6E` | `$00:13 $AE:1` |
| `$47` | `EventScriptGroup_47` | `$B5AC6E` | `$B5` | 32 | 31 | 1 | `$B5ACAE` | `$B5CB69` | `$23:20 $58:7 $47:3 $10:1` |
