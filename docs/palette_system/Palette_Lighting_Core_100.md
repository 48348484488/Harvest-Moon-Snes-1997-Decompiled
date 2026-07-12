# Palette / Lighting Core 100% - Pass 32

Esta pass fecha o nucleo de paleta/iluminacao do jogo. O objetivo foi documentar como o Harvest Moon SNES escolhe, carrega, transiciona e envia paletas para CGRAM sem alterar nenhum byte funcional da ROM recompilada.

## Arquivos principais

```text
src/code_banks/bank_80.asm
src/data_banks/bank_A8.asm
src/data_banks/bank_A9.asm
src/constants/ram.asm
```

## Conceito geral

O jogo nao desenha a mudanca de horario trocando graficos inteiros. Ele mantem buffers de paleta em WRAM e vai aproximando as cores atuais das cores de destino. Depois agenda DMA para CGRAM.

Buffers principais observados:

| Buffer | Uso conhecido |
|---|---|
| `$7F0900` | paleta ativa preparada para upload/CGRAM |
| `$7F0B00` | buffer alternativo usado durante loads/overrides |
| `$7F0D00` | copia/base usada para comparar e transicionar cores |

Variaveis principais:

| Simbolo | Endereco | Funcao |
|---|---:|---|
| `!palette_change_pointer` | `$04` | ponteiro 24-bit para paleta alvo da transicao |
| `!palette_change_countdow` | `$017A` | contador antes de aplicar proximo step da transicao |
| `!palette_to_load` | `$017B` | paleta atual/ultimo id aplicado |
| `!next_hourly_palette` | `$017C` | proxima paleta pedida pela rotina de horario |

## Rotinas fechadas

| Rotina | Papel |
|---|---|
| `Palette_CGRAM_ClearAll` | limpa a CGRAM via DMA/zeroes |
| `PaletteTransition_BeginTimeOfDayFade` | inicia fade gradual para a paleta alvo |
| `PaletteTransition_StepTimeOfDayFade` | ajusta RGB555 um passo por canal ate atingir a paleta alvo |
| `PaletteTransition_CommitLoadedPaletteIndex` | finaliza transicao e grava `!palette_to_load` |
| `PaletteTransition_ClearPending` | cancela/reset da transicao pendente |
| `Palette_LoadBGHalfToWRAM` | carrega a primeira metade da paleta para buffers WRAM |
| `Palette_LoadOBJHalfToWRAM` | carrega a segunda metade da paleta para buffers WRAM |
| `Palette_LoadTimeOfDayForCurrentMap` | carrega paleta completa para o mapa atual |
| `Palette_LoadCurrentTimeOfDayBGHalf` | escolhe BG palette por mapa/hora e carrega primeira metade |
| `Palette_LoadCurrentAreaSpriteHalf` | escolhe OBJ/sprite palette por mapa/hora/flags |
| `Palette_ApplySeasonWifeAndNightSpriteOverrides` | aplica overrides de cor por estacao/noite/esposa/gravidez |
| `Palette_SetPendingTransitionIfHourChanged` | detecta mudanca de faixa de hora e dispara transicao |

## Tabelas fechadas

| Tabela | Papel |
|---|---|
| `Palette_PointerTable` | tabela 24-bit de ponteiros para paletas nos bancos A8/A9 |
| `Palette_TimeOfDayByMapTable` | matriz de palette ids por mapa e faixa de horario |
| `Palette_OBJHalfByMapDayNightTable` | palette ids para segunda metade/OBJ por mapa e dia/noite |
| `PaletteOverride_SeasonalSpriteColorTriples` | pequenos overrides RGB555 por estacao/mapa |
| `PaletteOverride_WifePregnancyColorTriples` | overrides usados quando esposa/gravidez/filhos afetam visual |

## Faixas de horario usadas

O jogo separa a escolha de paleta por faixas:

| Faixa | Condicao aproximada |
|---|---|
| madrugada/manha inicial | hora `< 7` |
| dia | `7 <= hora < 15` |
| tarde | `15 <= hora < 17` |
| fim de tarde | `17 <= hora < 18` |
| noite | `hora >= 18` |

A noite tem tratamento especial: algumas rotinas passam a copiar/transicionar `$0200` bytes em vez de `$0100`, afetando a paleta completa.

## Transicao RGB555

Cada cor SNES usa RGB555:

```text
bits 0-4   = vermelho
bits 5-9   = verde
bits 10-14 = azul
```

A rotina `PaletteTransition_StepTimeOfDayFade` compara cada canal da cor atual contra a cor alvo. Para cada canal, ela soma ou subtrai 1 ate atingir a cor desejada. Quando houve mudanca, ela agenda DMA para CGRAM.

## Estado do escopo

Este escopo esta fechado como **100%** porque o caminho principal de carregamento, selecao, transicao, bufferizacao, override e upload de paletas esta documentado e com labels humanos. Ainda podem existir detalhes finos sobre o significado artistico de cada palette id, mas o nucleo tecnico de paleta/iluminacao esta coberto.
