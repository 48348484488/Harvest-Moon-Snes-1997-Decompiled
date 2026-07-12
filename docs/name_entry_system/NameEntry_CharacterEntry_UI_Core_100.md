# Pass 47 - Naming Screen / Character Entry UI Core 100%

Esta pass fecha o escopo **Naming Screen / Character Entry UI Core**.

O objetivo foi transformar a tela de entrada de nome de um conjunto de labels genericos em um sistema nomeado e documentado, cobrindo carregamento visual, cursor, grades de caracteres, entrada A/B, paginas de caracteres e commit final para player/animais/filhos.

## Arquivos principais

```text
src/code_banks/bank_82.asm
src/code_banks/bank_84.asm
docs/name_entry_system/NameEntry_CharacterEntry_UI_Core_100.md
docs/pseudocode/NameEntry_CharacterEntry_UI_Core.md
```

## Resultado fechado

| Item | Resultado |
|---|---:|
| Cena de name-entry carregada | 100% |
| Input state usado | `!inputstate = $05` |
| Tilemap da cena | `$5F` |
| Tamanho do nome temporario | 4 glyphs |
| Paginas de grade mapeadas | 3 |
| Entradas de grade mapeadas | 204 |
| Destinos de commit identificados | 7 |
| Build apos renomeacoes | byte-perfect |

## Fluxo principal

A rotina central agora esta nomeada como:

```asm
NameEntryScene_LoadAndRun
```

Ela faz:

1. seleciona o tilemap `$5F`;
2. troca BGM/fade/force blank;
3. limpa VRAM e dados temporarios de sprite;
4. configura `!inputstate = $05`;
5. carrega preset grafico e tilemap da tela;
6. faz DMA dos graficos/fontes usados pela tela de nome;
7. cria um GameOBJ para o cursor;
8. limpa os 4 slots visiveis do nome com glyph vazio `$00A8`;
9. inicializa `!temp_name_1..4` com `!CHAR_EMPTY` / `$B1`;
10. entra no loop NMI + `Input_DispatchByState`;
11. ao confirmar, despacha para o setter correto de nome.

## Destinos de commit

A variavel `$099F` escolhe o destino final do nome temporario:

| `$099F` | Destino |
|---:|---|
| `$00` | `SetPlayerName` |
| `$01` | `SetCowNameBought` |
| `$02` | `SetCowNameBorn` |
| `$03` | `SetDogName` |
| `$04` | `SetHorseName` |
| `$05` | `SetKid1Name` |
| `$06` | `SetKid2Name` |

## Estrutura da grade

A tabela principal agora esta nomeada como:

```asm
NameEntryGrid_PageDataTable
```

Cada entrada possui 8 bytes:

| Offset | Campo | Uso |
|---:|---|---|
| `+0` | X | posicao visual do cursor |
| `+1` | Y | posicao visual do cursor |
| `+2` | neighbor 0 | indice de destino por D-pad |
| `+3` | neighbor 1 | indice de destino por D-pad |
| `+4` | neighbor 2 | indice de destino por D-pad |
| `+5` | neighbor 3 | indice de destino por D-pad |
| `+6` | glyph/tile | glyph inserido quando a acao e normal |
| `+7` | action/control | `0` append normal; `1/2/3` troca pagina; `4` confirma |

Bases das paginas:

| Pagina | Base SNES | Entradas | Observacao |
|---:|---:|---:|---|
| 0 | `$82:EBF8` | 71 | pagina inicial de letras |
| 1 | `$82:EE30` | 84 | segunda pagina de letras |
| 2 | `$82:F0D0` | 49 | simbolos/controles |

Total: **204 entradas**.

## Controle de paginas

`$0993` e o seletor da pagina de grade:

| `$0993` | Pagina |
|---:|---|
| `$00` | pagina 0 |
| `$01` | pagina 1 |
| `$02` | pagina 2 |
| `$03` | nome confirmado / sair do loop |

As rotinas fechadas nesta pass:

```asm
NameEntryInput_SelectUppercasePage
NameEntryInput_SelectLowercasePage
NameEntryInput_SelectSymbolPage
NameEntryInput_ConfirmCompletedName
NameEntryInput_RejectEmptyNameConfirm
```

## Slots visiveis do nome

Os quatro slots sao desenhados/limpos por:

```asm
NameEntryUI_DrawNameSlotFrameDMA
NameEntryUI_ClearAllNameSlotGlyphs
NameEntryUI_DrawGlyphIntoCurrentSlot
```

Tabela de VRAM dos glyphs:

```asm
NameEntryUI_NameSlotGlyphVRAMPositionTable: dw $5010,$5020,$5030,$5040
```

## Renomeacoes principais

| Antes | Depois |
|---|---|
| `Unk_NamesInput` | `NameEntryScene_LoadAndRun` |
| `SUB_82EAB4` | `NameEntryUI_DrawNameSlotFrameDMA` |
| `SUB_82EA80` | `NameEntryUI_ClearAllNameSlotGlyphs` |
| `Unk_OutOfMenu` | `NameEntryUI_DrawGlyphIntoCurrentSlot` |
| `SUB_82EB57` | `NameEntryCursor_UpdateSpritePositionFromGrid` |
| `NameCursorPharse` | `NameEntryGrid_ReadCurrentEntryField` |
| `NameGridPositions` | `NameEntryGrid_PageDataTable` |
| `DATA16_82EB49` | `NameEntryUI_NameSlotFrameSourceOffset` |
| `DATA16_82EB4B` | `NameEntryUI_NameSlotFrameVRAMBase` |
| `DATA16_82EB4D` | `NameEntryUI_NameSlotGlyphVRAMPositionTable` |
| `DATA16_82EB55` | `NameEntryUI_NameSlotCount` |
| `NameMenuKeyDown` | `NameEntryInput_MoveDown` |
| `NameMenuKeyUp` | `NameEntryInput_MoveUp` |
| `NameMenuKeyLeft` | `NameEntryInput_MoveLeft` |
| `NameMenuKeyRight` | `NameEntryInput_MoveRight` |
| `CODE_84C157` | `NameEntryInput_SelectUppercasePage` |
| `CODE_84C17E` | `NameEntryInput_SelectLowercasePage` |
| `CODE_84C1A8` | `NameEntryInput_SelectSymbolPage` |
| `CODE_84C1D2` | `NameEntryInput_ConfirmCompletedName` |
| `CODE_84C1F1` | `NameEntryInput_RejectEmptyNameConfirm` |

## Limites desta pass

Fechado em 100%:

- fluxo visual da tela de nome;
- input A/B/D-pad da tela de nome;
- paginas de caracteres;
- tabela de grade e campos;
- slot visual de 4 glyphs;
- commit final para os 7 destinos conhecidos;
- rebuild byte-perfect.

Nao incluido aqui:

- dar nome semantico para cada glyph individual da fonte;
- criar editor visual da tela de nome;
- alterar limite de 4 caracteres.

Esses pontos podem virar metas futuras se forem necessarios.
