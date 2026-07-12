# Save System Map - Pass 12

Escopo fechado desta pass: **documentar 100% do layout de slot de save atualmente conhecido**, incluindo blocos, offsets diretos, assinatura, checksum, arrays de animais e bloco de mapa da fazenda.

Isto nao quer dizer que todos os significados internos de cada flag desconhecida do jogo foram descobertos. Quer dizer que o **formato do slot SRAM usado pelas rotinas de save/load** ficou consolidado e navegavel na source documentada.

## Rotinas principais

| Rotina | Endereco SNES | Funcao |
|---|---:|---|
| `SaveSystem_LoadFullSlot` | `$83:B2B1` | Carrega um slot inteiro da SRAM para a RAM de jogo. |
| `SaveSystem_SaveSlot` | `$83:B68E` | Salva o estado atual da RAM no slot SRAM selecionado. |
| `SaveSystem_LoadSlotSummary` | `$83:BA45` | Carrega dados resumidos de slot para telas/menus de load. |
| `SaveSystem_CheckSRAMIntegrity` | `$83:BAD4` | Verifica assinatura/checksum e repara/zera SRAM invalida. |

## Estrutura geral da SRAM

| Item | Valor |
|---|---:|
| Banco SRAM usado | `$70` |
| Slot 1 | `$70:0000-$70:0FFF` |
| Slot 2 | `$70:1000-$70:1FFF` |
| Tamanho tratado por slot | `$1000` bytes |
| Assinatura de validade | `FARM` em `$003C-$003F` |
| Checksum | `$002F-$0030` |
| Byte de estado/slot | `$002E` |

## Layout por blocos

| Range | Tamanho | Nome | Notas |
|---|---|---|---|
| $0000-$001A | 27 bytes | Scalar 8-bit early fields | Date, seed/feed counts, selected tool, stamina, misc flags. |
| $002E | 1 bytes | Active/latest-slot marker byte | Temporarily zeroed for CRC; values 0/1 are used to flag/select slot state. |
| $002F-$0030 | 2 bytes | Save CRC/checksum | 16-bit additive checksum over $0000-$0FFF with $002E and $002F-$0030 zeroed first. |
| $0031,$0033,$0035,$0037 | 4 bytes | Shipped crop counters | Stored as separated bytes/words at odd offsets. |
| $0039-$003B | 3 bytes | Money | 24-bit money value split into !moneyL and !moneyH. |
| $003C-$003F | 4 bytes | FARM signature | ASCII F,A,R,M. Used as a basic slot validity marker. |
| $0040-$007E | 63 bytes | 16-bit counters, hearts, flags, family/dog state | Wood/grass, crop totals, bachelorette hearts, persistent flags, dog position, happiness, pregnancy/kids. |
| $0080-$0083 | 4 bytes | Player name | Four character bytes. |
| $0084-$0087 | 4 bytes | Tool shed bitfields | Rows of stored tools/seeds/items; see pass07 tool shed report. |
| $0088-$008B | 4 bytes | Dog name | Four character bytes. |
| $008C-$008F | 4 bytes | Horse name | Four character bytes. |
| $0090-$0093 | 4 bytes | Kid 1 name | Four character bytes. |
| $0094-$0097 | 4 bytes | Kid 2 name | Four character bytes. |
| $0098-$00FF | 104 bytes | Chicken array | 13 chickens x 8 bytes = 104 bytes. |
| $0100-$01BF | 192 bytes | Cow array | 12 cows x 16 bytes = 192 bytes. |
| $01C0-$0FFF | 3648 bytes | Farm map/tile state block | Copied from !farm_map_array index $00C0-$0EFF into SRAM $01C0-$0FFF. |

## Resultado da Pass 12

- O diretorio `docs/save_system/` foi preenchido, pois estava vazio na versao limpa da Pass 11.
- O layout direto foi consolidado em Markdown e JSON.
- As rotinas de save receberam comentarios de contexto no source ASM.
- A area **Save/SRAM Slot Layout** fica considerada **100% concluida dentro do escopo conhecido**.

