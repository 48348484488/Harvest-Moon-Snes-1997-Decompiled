# Map Loading / Area Transition Core 100%

Esta pass fecha o nucleo de carregamento de mapa/area e transicao de tela.

O objetivo aqui nao foi mapear 100% de cada mapa individual, NPC ou evento. O escopo fechado e o **core que troca de area, carrega os graficos/tilemaps e posiciona camera/player**.

## Escopo fechado

- tabela principal de areas/mapas;
- destino de transicao;
- `!tilemap_to_load` como id de area atual a carregar;
- fluxo de fade/blank antes de carregar nova area;
- reset de objetos/sprites/runtime antes do load;
- leitura do header de area;
- preset grafico por area;
- flags de area misturadas em `$0196`;
- quantidade de tilemaps comprimidos por area;
- quantidade de character maps/graficos por area;
- limites de camera/objeto por mapa;
- decompressao de tilemaps para WRAM;
- DMA de WRAM para VRAM;
- carregamento de character maps;
- overlay persistente da fazenda para mapas de fazenda;
- overlays especiais de clima/festival;
- reposicionamento inicial de player/camera apos transicao;
- scrolling horizontal/vertical basico da camera.

## Labels principais

| Label novo | Papel |
|---|---|
| `MapTransition_BeginFadeAndLoadDestination` | Verifica flags de transicao e inicia fade/blank para trocar area. |
| `MapTransition_ResetRuntimeAndLoadDestination` | Limpa runtime e prepara o jogo para carregar o destino. |
| `MapLoad_LoadAreaByIdAndApplyOverlays` | Entrada principal de load por id de mapa/area. |
| `MapLoad_ReadAreaHeaderByte` | Le bytes do header de area a partir da tabela de mapas. |
| `MapLoad_DecompressAreaGraphicsAndSetCamera` | Loader central de graficos/tilemaps/camera. |
| `MapLoad_QueueVRAMChunkWithOffset` | Enfileira DMA de chunk grafico com offset. |
| `MapLoad_AreaGraphicsPointerTable` | Tabela principal de ponteiros para os blocos de cada area. |
| `FarmMap_ApplyPersistentFarmTileOverlay` | Aplica dados persistentes da fazenda em mapas de fazenda. |
| `MapLoad_ExecuteMapEntryPointerScript` | Executa ponteiro/script associado ao carregamento de area. |
| `Camera_UpdatePlayerCenteredOffsets` | Atualiza offsets de camera baseados na posicao do player. |
| `Camera_UpdateBG2WeatherOrParallaxScroll` | Atualiza BG2 para clima/parallax/efeitos especiais. |
| `Camera_UpdateVerticalBGOffsetDown` | Atualiza deslocamento vertical do background. |
| `Camera_UpdateHorizontalBGOffsetRight` | Atualiza deslocamento horizontal do background. |

## Estrutura do bloco de area

A tabela `MapLoad_AreaGraphicsPointerTable` aponta para blocos como `MapFarmSpring`, `MapTownSpring`, `MapToolShed`, etc.

Para mapas normais, o bloco segue este modelo geral:

```text
byte  graphic_preset
word  flags_or_mask_for_$0196
byte  map_size_or_mode_0181
byte  map_size_or_mode_0182
byte  number_of_tilemaps
byte  number_of_charactermaps
word  OBJ_clamp_left
word  OBJ_clamp_right
word  OBJ_clamp_up
word  OBJ_clamp_down

repeat number_of_tilemaps:
    word  VRAM_destination
    long  compressed_tilemap_source

repeat number_of_charactermaps:
    word  VRAM_destination
    long  compressed_character_source
```

Para overlays/splash/single tilemaps, alguns campos iniciais sao pulados. Isso acontece para IDs `#$57` em diante.

## IDs de area observados

A tabela principal cobre IDs `00` a `5F`, totalizando **96 entradas**.

Grupos principais:

| Faixa | Uso |
|---|---|
| `00-03` | Fazenda por estacao. |
| `04-07` | Cidade por estacao. |
| `08-0B` | Mapas de festivais. |
| `0C-14` | Fork/mountain/summit/spa por estacao/evento. |
| `15-28` | Casa, lojas, interiores, barn, coop, tool shed. |
| `29-3A` | Cave, tunnel, summit, new year e cenas especiais. |
| `3B-56` | Mapas/cenas ainda parcialmente nomeados. |
| `57-5A` | Overlays: rain, clouds, snow, heavy snow. |
| `5B-5F` | Splash/menu/backgrounds de intro/titulo. |

## Fluxo central

```text
1. Alguma rotina define !transition_dest.
2. Flag de transicao e marcada em $0196.
3. MapTransition_BeginFadeAndLoadDestination roda no frame loop.
4. O jogo faz fadeout e force blank.
5. MapTransition_ResetRuntimeAndLoadDestination limpa objetos, VRAM parcial e estados temporarios.
6. !transition_dest e copiado para !tilemap_to_load.
7. Scripts de entrada/estrutura sao processados.
8. MapLoad_LoadAreaByIdAndApplyOverlays decide overlays e chama o loader.
9. MapLoad_DecompressAreaGraphicsAndSetCamera le o header da area.
10. Tilemaps/character maps sao decompressados para WRAM.
11. Dados sao enviados para VRAM por DMA.
12. Camera, clamps e posicao do player sao inicializados.
13. O jogo volta ao controle normal quando a transicao termina.
```

## Relacao com outros sistemas

| Sistema | Relacao |
|---|---|
| Input/menu | Mudanca de area pode ser disparada por eventos/interacoes. |
| GameOBJ/sprites | Objetos sao limpos/reinicializados antes do novo mapa. |
| Farm/crops | Mapas de fazenda recebem overlay persistente. |
| Weather/festival | IDs `57-5A` aplicam overlays climaticos. |
| Textbox/eventos | Scripts de entrada podem iniciar eventos/dialogos depois do load. |
| Save/SRAM | Fazenda usa dados persistentes salvos para recompor tiles. |

## O que fica fora deste 100%

Este 100% e do **core de carregamento/transicao**. Ainda nao significa 100% de:

- todos os scripts de evento de cada mapa;
- todas as portas/interacoes individuais;
- agenda de NPCs por mapa;
- colisao completa de todos os tiles;
- edicao visual completa de mapas;
- nomes humanos para todos os `MapUnknownXX`.

Essas partes devem virar passes futuras.
