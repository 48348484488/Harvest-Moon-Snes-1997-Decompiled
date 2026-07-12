# Map / Tileset Renderer Core 100%

Esta pass fecha o nucleo de renderizacao de mapas/tilemaps/tilesets do Harvest Moon SNES.

## Escopo fechado

Esta documentacao cobre o caminho central entre:

```text
ID de area em !tilemap_to_load
-> header de area
-> presets graficos
-> tilemaps comprimidos
-> character maps / tilesets
-> WRAM temporaria $7E2000
-> DMA para VRAM
-> camera/clamps
-> streaming de tiles durante scroll
-> overlays da fazenda/clima/festival
```

O objetivo nao foi redesenhar mapas nem inserir graficos novos. O objetivo foi fechar o nucleo que carrega e atualiza os graficos de mapa sem alterar nenhum byte da ROM recompilada.

## Rotinas principais

| Rotina | Funcao |
|---|---|
| `MapLoad_LoadAreaByIdAndApplyOverlays` | entrada principal do carregamento de area |
| `MapLoad_DecompressAreaGraphicsAndSetCamera` | le header, decompressa tilemaps/tilesets, aplica camera e overlays |
| `MapLoad_ReadAreaHeaderByte` | le byte especifico do header da area atual |
| `MapLoad_AreaGraphicsPointerTable` | tabela principal de ponteiros de areas/mapas |
| `ManageGraphicPresets` | aplica preset grafico da area |
| `Palette_LoadTimeOfDayForCurrentMap` | aplica paleta conforme mapa/hora/dia |
| `DecompressTileMap` | rotina de decompressao de tilemap/character map |
| `MapLoad_QueueVRAMChunkWithOffset` | prepara DMA de chunk de tiles para VRAM |
| `MapRenderer_StreamRowsForVerticalScrollDown` | atualiza linhas de tiles durante scroll vertical para baixo |
| `MapRenderer_StreamRowsForVerticalScrollUp` | atualiza linhas de tiles durante scroll vertical para cima |
| `MapRenderer_StreamColumnsForHorizontalScrollRight` | atualiza colunas de tiles durante scroll horizontal para direita |
| `MapRenderer_StreamColumnsForHorizontalScrollLeft` | atualiza colunas de tiles durante scroll horizontal para esquerda |
| `Camera_UpdatePlayerCenteredOffsets` | recalcula offsets de camera centrados no player |
| `Camera_UpdateHorizontalBGOffsetRight` | atualiza BG horizontal em um sentido |
| `Camera_UpdateVerticalBGOffsetDown` | atualiza BG vertical em um sentido |
| `Camera_UpdateVerticalBGOffsetUp` | atualiza BG vertical no sentido oposto |
| `FarmMap_ApplyPersistentFarmTileOverlay` | aplica o estado salvo da fazenda sobre o mapa base |

## Estrutura do header de area

A area atual e escolhida por `!tilemap_to_load`. O valor e usado como indice em `MapLoad_AreaGraphicsPointerTable`.

O header da area contem, em ordem geral:

```text
preset grafico
flags/paleta/estado visual
modo/tipo de mapa
quantidade de tilemaps
quantidade de character maps
definicoes de camera/clamp
lista de tilemaps: destino VRAM + ponteiro comprimido + banco
lista de character maps: destino/base + ponteiro comprimido + banco
```

Mapas especiais/splash screens usam caminhos reduzidos e pulam parte dos campos normais.

## Fluxo do carregamento de mapa

1. `!tilemap_to_load` define a area.
2. A tabela `MapLoad_AreaGraphicsPointerTable` retorna o ponteiro do header.
3. O preset grafico e aplicado.
4. As flags visuais sao atualizadas.
5. O loader le a quantidade de tilemaps e character maps.
6. Cada tilemap comprimido e decompresso em `$7E2000`.
7. O resultado e enviado para VRAM por DMA.
8. Cada character map/tileset e decompresso ou copiado para WRAM.
9. O renderer divide o material em chunks e envia para VRAM.
10. A camera e reposicionada conforme destino da transicao.
11. Se for mapa da fazenda, o overlay persistente da fazenda e aplicado.
12. Se houver script de entrada de mapa, ele pode ser chamado.

## Streaming durante scroll

O SNES nao redesenha o mapa inteiro a cada pixel de movimento. O jogo mantem um buffer e atualiza apenas as linhas/colunas novas que entram na tela.

O fluxo de scroll usa:

```text
!OBJ_Offset_X / !OBJ_Offset_Y
!BG_subpixel_offset_X / !BG_subpixel_offset_Y
!BG1_Map_Offset_X / !BG1_Map_Offset_Y
clamps do mapa
rotinas de streaming de linhas/colunas
DMA programado
```

Quando o deslocamento subpixel acumula 8 pixels, uma nova faixa de tiles e carregada para VRAM.

## Relacao com outras passes

| Sistema | Relacao |
|---|---|
| Pass 26 Map Loading | esta pass fecha a parte renderer/tile streaming que complementa o loader |
| Pass 27 Player Movement | movimento do player provoca scroll/camera |
| Pass 17 Crop Growth | estado persistente da fazenda altera tiles |
| Pass 19 Festival/Weather | clima/festival pode alterar overlays/visuais |
| Pass 21 GameOBJ | objetos/sprites sao renderizados sobre os mapas |
| Pass 28 Audio | mapa tambem influencia BGM, mas audio ficou em pass separada |

## O que esta 100% neste escopo

Considero este escopo fechado porque o caminho central de renderizacao de mapa esta documentado:

```text
header -> decompressao -> WRAM -> DMA -> VRAM -> camera -> streaming por scroll
```

Ainda podem existir detalhes especificos de cada mapa individual, tileset especifico, ou compressao grafica com nomes mais bonitos, mas o nucleo operacional esta fechado.
