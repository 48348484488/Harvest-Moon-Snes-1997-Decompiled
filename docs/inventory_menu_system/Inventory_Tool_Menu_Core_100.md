# Inventory / Tool Menu Core 100%

Esta pass fecha o escopo central de inventario de ferramentas e itens carregados pelo jogador.

O objetivo nao foi criar item novo nem alterar visual. O objetivo foi documentar a ponte entre:

- `!item_on_hand`, item carregado nas maos;
- `!old_item_on_hand`, backup temporario do item anterior;
- `!tool_selected`, ferramenta ativa selecionada;
- `!tool_backpack`, ferramenta secundaria/backpack;
- `!shed_items_row_1` ate `!shed_items_row_4`, bitfields persistentes do tool shed;
- renderizacao de ferramentas/itens em interiores, lojas e tool shed;
- input/menu state ja fechado na Pass 23.

## Variaveis principais

| Simbolo | Endereco | Uso |
|---|---:|---|
| `!item_on_hand` | `$091D` | ID do item atualmente na mao. Zero significa maos vazias. |
| `!old_item_on_hand` | `$091F` | backup temporario usado quando eventos precisam guardar item anterior. |
| `!tool_selected` | `$0921` | ferramenta principal selecionada. |
| `!tool_backpack` | `$0923` | ferramenta secundaria/backpack. |
| `!shed_items_row_1` | `$7F1F00` | bitfield persistente da primeira fileira/grupo de ferramentas. |
| `!shed_items_row_2` | `$7F1F01` | bitfield persistente da segunda fileira/grupo de ferramentas. |
| `!shed_items_row_3` | `$7F1F02` | bitfield persistente da terceira fileira/grupo de ferramentas/sementes. |
| `!shed_items_row_4` | `$7F1F03` | bitfield persistente da quarta fileira/grupo de ferramentas/feed. |

## Rotinas/tabelas fechadas

| Label | Funcao |
|---|---|
| `InventoryTool_ReturnHeldToolsToShedBitfields` | devolve `!tool_selected` e `!tool_backpack` para os bitfields persistentes do tool shed. |
| `ReplaceTilesToolshed` | redesenha os slots visiveis do tool shed com base nos bitfields persistentes. |
| `ShopDisplay_DrawConditionalItemTile` | desenha um tile/item de loja/interior somente se a condicao de inventario permitir. |
| `ShopDisplay_ItemTilePlacementTable` | tabela de posicao/associacao de itens em prateleiras/interiores. |
| `InventoryTool_BitfieldSlotAndPickupTileTable` | tabela que liga ferramenta a row/mask de bitfield e metadata visual/pickup. |

## Fluxo principal

1. O jogo guarda as ferramentas possuidas em bitfields do tool shed.
2. Quando o jogador seleciona/pega uma ferramenta, `!tool_selected` ou `!tool_backpack` recebe o ID.
3. Quando uma rotina precisa devolver ferramentas ao armazenamento, `InventoryTool_ReturnHeldToolsToShedBitfields` converte o ID em row/mask e atualiza `!shed_items_row_N`.
4. Quando o interior precisa ser redesenhado, `ReplaceTilesToolshed` e rotinas de loja usam as tabelas de display para mostrar ou esconder tiles.
5. O sistema de item carregado usa `!item_on_hand` para objetos consumiveis, produtos, ovos, peixes, crops e itens especiais.

## O que este 100% significa

Este escopo esta fechado para o nucleo de inventario/ferramenta:

- variaveis principais identificadas;
- bitfields persistentes ligados ao tool shed;
- devolucao de ferramenta para armazenamento identificada;
- display condicional de itens/ferramentas identificado;
- tabela de ligacao ferramenta -> bitfield -> tile identificada;
- build validada byte-perfect apos as renomeacoes.

Ainda nao significa 100% de todos os menus do jogo. Menus de loja, compra/venda, HUD completo e janelas especificas ficam para passes separadas.
