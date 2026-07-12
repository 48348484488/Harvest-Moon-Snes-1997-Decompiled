# Crop Growth Core 100 - Pass 17

Esta pass fecha o escopo **Crop Growth Core**: o nucleo da evolucao diaria dos tiles da fazenda, incluindo crops, solo molhado/seco, grama, chuva, dano climatico, limpeza de inverno e calculo de desenvolvimento da fazenda.

Importante: este escopo nao significa que todos os graficos, menus de sementes, textos de lojas e eventos relacionados a crops estejam 100% explicados. Significa que o **ciclo central de tile/crop na fazenda** foi mapeado e documentado.

## Rotinas principais

| Rotina | Endereco | Funcao |
|---|---:|---|
| `FarmTiles_NightlyGrowthDryingAndCleanup` | `$82A811` | Nucleo diario: seca/molha tiles, cresce crops/grama, gera lixo aleatorio e trata cerca quebrada. |
| `FarmTiles_ApplyClimateDamage` | `$82A713` | Aplica dano de clima em cerca, grama, solo arado e crops. |
| `FarmTiles_WinterMonthlyCleanup` | `$82A6A2` | Limpeza mensal/de inverno aplicada no mapa da fazenda. |
| `FarmGrass_MarkFirstMatureGrassPatch` | `$82A9A0` | Procura grama madura e marca uma unidade para uso em logica de feed/grama. |
| `Farm_CalculateRanchDevelopmentScore` | `$82AA0C` | Conta tiles produtivos/desenvolvidos e atualiza `!ranch_development`. |
| `TileProperty_CheckToolUseAllowed` | `$82AC61` | Le propriedades do tile e mascara por direcao para decidir se ferramenta/semente pode agir. |
| `CheckToolSuccess` | `$82AA71` | Validador de ferramenta selecionada contra o tile alvo. |

## RAM e estado persistente

| Simbolo | Endereco | Uso |
|---|---:|---|
| `!farm_map_array` | `$7EA4E6` | Mapa persistente da fazenda, 4096 bytes. Cada byte e um tile/estado. |
| `!season` | `$7F1F19` | Estacao atual. Winter bloqueia crescimento normal. |
| `!day` | `$7F1F1B` | Dia da estacao; usado tambem para lixo aleatorio. |
| `!planted_grass` | `$7F1F29` | Contador/estado associado a grama plantada. |
| `$092E` | `$7E092E` | Contador temporario usado no fluxo de grama madura/feed. |
| `!ranch_development` | `$7F1F56` | Pontuacao calculada de desenvolvimento da fazenda. |
| `$0196` | `$7E0196` | Flags de clima; bit `$0002` indica chuva/neve/molhamento ativo no fluxo da fazenda. |

## IDs de tile confirmados/documentados

As constantes foram adicionadas em `src/constants/constants.asm` para documentar os valores sem alterar bytes da ROM.

| Tile | Constante | Significado inferido |
|---:|---|---|
| `$00` | `!FARM_TILE_UNUSED_00` | vazio/sentinela ignorado |
| `$01` | `!FARM_TILE_EMPTY_01` | vazio possível, usado para lixo aleatorio |
| `$02` | `!FARM_TILE_EMPTY_02` | vazio/base do campo |
| `$03` | `!FARM_TILE_RANDOM_TRASH` | lixo/erva/obstaculo aleatorio gerado no campo |
| `$04` | `!FARM_TILE_STONE` | pedra/obstaculo |
| `$05` | `!FARM_TILE_FENCE` | cerca normal |
| `$06` | `!FARM_TILE_BROKEN_FENCE` | cerca quebrada |
| `$07` | `!FARM_TILE_TILLED_SOIL` | solo arado seco |
| `$08` | `!FARM_TILE_WATERED_SOIL` | solo arado molhado |
| `$1D` | `!FARM_TILE_GRASS_SEED` | tile inicial de grama/semente de grama |
| `$1E` | `!FARM_TILE_CROP_BASE_DRY` | base inicial de crop seco |
| `$1F` | `!FARM_TILE_CROP_BASE_WATERED` | base inicial de crop molhado |
| `$20+` | `!FARM_TILE_CROP_RANGE_START` | range geral de crops |
| `$39` | `!FARM_TILE_TOMATO_READY_WATERED` | tomate adulto molhado |
| `$53` | `!FARM_TILE_CORN_READY_WATERED` | milho adulto molhado |
| `$61` | `!FARM_TILE_POTATO_READY_WATERED` | batata adulta molhada |
| `$6F` | `!FARM_TILE_TURNIP_READY_WATERED` | nabo adulto molhado |
| `$70+` | `!FARM_TILE_GRASS_RANGE_START` | range geral de grama |
| `$76-$79` | `!FARM_TILE_GRASS_MATURE_START/END` | grama madura usada pelo sistema de feed/grama |
| `$7A` | `!FARM_TILE_GRASS_MARKED_FOR_FEED` | grama marcada/convertida por rotina de grama madura/inverno |
| `$7C` | `!FARM_TILE_GRASS_STAGE_2_SPECIAL` | estagio especial de grama tratado separadamente |
| `$A0+` | `!FARM_TILE_OUT_OF_BOUNDS_START` | classe/sentinela ignorada como fora do range normal |

## Regras centrais do ciclo diario

1. A rotina percorre a fazenda como uma grade de `0x400 x 0x400` em passos de `0x10`, convertendo coordenadas em indice com `GetTileIndex`.
2. Tiles vazios ou fora do range normal sao ignorados.
3. Solo/crop molhado pode continuar molhado ou crescer dependendo do clima.
4. Se nao estiver chovendo, tiles molhados secam via decremento do ID.
5. Se estiver chovendo, tiles secos podem ser molhados via incremento do ID.
6. Crops adultos molhados especificos (`$39`, `$53`, `$61`, `$6F`) sao tratados como adultos e voltam ao estado seco correspondente se nao chover.
7. Grama tem tratamento separado e nao segue exatamente a mesma logica dos crops comuns.
8. No inverno, o crescimento normal e bloqueado; no primeiro dia de inverno entra a limpeza mensal/de inverno.
9. Random trash pode aparecer em certos vazios a cada 4 dias fora do fall/winter, usando RNG.
10. Cerca quebrada pode acionar flags relacionadas a dano/reparo.

## Ligacao com outras passes

| Sistema | Ligacao |
|---|---|
| Pass 13 - Clock/Calendar | Chama o pipeline diario que dispara o ciclo de tiles. |
| Pass 09 - Farm/Weather | Define clima e dano climatico que afeta crops. |
| Pass 16 - Tool Actions | Ferramentas e sementes criam/alteram os tiles que esta pass faz crescer. |
| Pass 11 - Save/SRAM | `!farm_map_array` e salvo/carregado no slot de save. |
| Pass 10 - Livestock | Grama madura influencia feed/uso da area da fazenda. |

## Estado do escopo

| Item | Estado |
|---|---:|
| Loop diario dos tiles da fazenda | 100% no escopo core |
| Estados secos/molhados de solo/crops | 100% no escopo core |
| Dano climatico aplicado a tiles | 100% no escopo core |
| Limpeza de inverno/mensal | 100% no escopo core |
| Desenvolvimento da fazenda por tiles | 100% no escopo core |
| Todos os eventos/menus/textos de crops | fora deste escopo |
| Graficos finais de cada crop | parcial, ligado a tiles/assets |

## Observacao de seguranca

As mudancas desta pass sao renomeacoes, comentarios e constantes simbolicas. O comportamento do jogo nao foi alterado. A build foi validada byte-a-byte contra a ROM USA original.
