# Pass 50 - Map Entry Tile Patch Core 100%

Esta pass fecha o escopo **Map Entry Tile Patch Core**.

O objetivo foi documentar e renomear o nucleo que aplica patches visuais persistentes nos mapas/interiores quando uma area e carregada. Esse sistema e diferente do loader bruto de mapa: ele roda depois do mapa base e modifica tiles conforme flags de save, upgrades, estoque de lojas, ferramentas guardadas, racao de animais, eventos e estado da fazenda.

## Arquivo principal

```text
src/code_banks/bank_81.asm
```

## Rotina de entrada

```asm
MapLoad_ExecuteMapEntryPointerScript
```

Essa rotina usa `!tilemap_to_load` para indexar uma tabela de ponteiros e executar o script de patches especifico da area atual.

## Tabela principal

```asm
MapEntryTilePatch_AreaDispatchTable
```

A tabela e indexada por ID de area/mapa. Cada entrada aponta para uma rotina local que aplica patches condicionais no mapa atual.

Exemplos de entradas agora nomeadas:

| Area | Rotina |
|---:|---|
| `$00-$03` | `MapEntryTilePatch_FarmOutdoor` |
| `$04-$07` | `MapEntryTilePatch_TownOutdoor` |
| `$08` | `MapEntryTilePatch_FlowerFestival` |
| `$09` | `MapEntryTilePatch_HarvestFestival` |
| `$0A` | `MapEntryTilePatch_EggFestival` |
| `$0C-$0F` | `MapEntryTilePatch_MountainFork*` |
| `$10-$13` | `MapEntryTilePatch_MountainOutdoor` |
| `$15-$17` | `MapEntryTilePatch_PlayerHouseLevel*` |
| `$1C` | `MapEntryTilePatch_FlowerShop` |
| `$22` | `MapEntryTilePatch_GeneralStore` |
| `$24` | `MapEntryTilePatch_AnimalShop` |
| `$26` | `MapEntryTilePatch_ToolShed` |
| `$27` | `MapEntryTilePatch_Barn` |

## Helpers fechados

| Nome antigo | Nome novo | Funcao |
|---|---|---|
| `CODE_81A5E1` | `MapTilePatchScript_StartByIndex` | Inicia um script animado/temporizado de patch por indice. |
| `CODE_81A600` | `MapTilePatchScript_UpdateActive` | Atualiza o script ativo, respeitando delay e comandos `$FFFF/$FFFE`. |
| `CODE_81A688` | `MapTilePatch_ApplyObjectAndRefreshVRAM` | Aplica objeto/tile patch em WRAM e agenda refresh de VRAM. |
| `CODE_81A6C1` | `MapTilePatch_QueueObjectVRAMDMA` | Calcula destino VRAM e agenda DMA do bloco grafico. |
| `SUB_81A7CE` | `MapTilePatch_ApplyObjectAndRefresh` | Wrapper seguro usado pelos scripts de area. |
| `SUB_81A801` | `MapTilePatch_LoadPlacementRecord` | Decodifica entrada da tabela de tile object/placement. |
| `SUB_81A83A` | `MapTilePatch_CopyTileObjectToWRAM` | Copia retangulo de tiles para o buffer WRAM do mapa. |

## Sistemas conectados

Esse nucleo conecta:

- `Map Loading / Area Transition Core`;
- `Map / Tileset Renderer Core`;
- `Video / PPU / NMI / DMA Core`;
- `Inventory / Tool Menu Core`;
- `Shop / Buying / Selling Core`;
- `Livestock Core`;
- `Family / Romance Core`;
- `Save/SRAM` flags persistentes;
- overlays visuais de mapa/interior.

## Exemplos de comportamento

### Fazenda exterior

`MapEntryTilePatch_FarmOutdoor` aplica patches visuais para:

- upgrades de casa;
- power berry flowers;
- pintura/estado visual da casa;
- objeto especial/event flag em `$7F1F68`.

### Lojas

`MapEntryTilePatch_FlowerShop`, `MapEntryTilePatch_GeneralStore` e `MapEntryTilePatch_AnimalShop` mostram ou escondem itens de compra conforme:

- item ja carregado na mao;
- ferramenta selecionada/backpack;
- flags de unlock;
- ano/estacao/dia;
- condicoes de animal shop.

### Tool shed

`MapEntryTilePatch_ToolShed` redesenha os slots visiveis do galpao a partir dos bitfields persistentes do inventario.

### Barn

`MapEntryTilePatch_Barn` redesenha racao e stalls usando `AnimalFeed_StallBitmaskTable` e `!fed_cows_flags`.

## Observacao importante

Esta pass fecha o **nucleo de patches de entrada de mapa**, nao todos os dados individuais anonimos de cada interior. Algumas entradas ainda apontam para stubs `RTS` ou dados historicamente anonimos, mas o dispatcher, helpers, formato e as familias principais foram nomeados/documentados.

