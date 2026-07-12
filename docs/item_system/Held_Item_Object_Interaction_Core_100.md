# Pass 53 - Held Item / Pickup Object Interaction Core 100%

Esta pass fecha o escopo **Held Item / Pickup Object Interaction Core**.

O objetivo foi documentar e renomear o nucleo que liga objetos visiveis do mapa, item carregado na mao, venda direta, colocacao no mapa, tool shed e limpeza de GameOBJ/runtime.

## Arquivos principais

```text
src/code_banks/bank_81.asm
src/code_banks/bank_82.asm
```

## Rotinas/tabelas renomeadas

| Nome antigo | Nome novo | Funcao |
|---|---|---|
| `CODE_8187C3` | `InventoryTool_PickupToolFromMapObject` | Remove bitfield do tool shed, transfere ferramenta para `!tool_selected` e limpa objeto visual. |
| `CODE_81883A` | `HeldItemObject_DispatchCarryDropStates_Basic` | Dispatcher de estados para objetos carregaveis simples. |
| `CODE_818855` | `HeldItemObject_DispatchCarryDropStates_Extended` | Dispatcher estendido para objetos com mais estados de venda/colocacao. |
| `CODE_81889A` | `HeldItemObject_DispatchCarryDropStates_Placeable` | Dispatcher de objetos que podem ser posicionados no tile em frente. |
| `CODE_8188BC` | `HeldItemObject_DispatchCarryDropStates_Simple` | Dispatcher simples de pickup/sale/drop. |
| `CODE_8188E5` | `HeldItemObject_DispatchPickupSaleAndPlacementStates` | Dispatcher principal de pickup, venda, colocacao e limpeza do objeto carregado. |
| `CODE_818923` | `HeldItemObject_HandlePickupPromptSaleOrPlacement` | Handler central de prompt, venda direta, falha por dinheiro cheio e patch de tile. |
| `DATA8_81A1A5` | `HeldItemObject_SellDialogPriceTilePatchTable` | Tabela de texto/preco/tile patch para objetos vendiveis ou posicionaveis. |
| `DATA8_82CFB4` | `MapObject_PickupItemIdTable` | Tabela que converte indice de objeto visual em ID de item carregado. |

## Comportamento fechado

O nucleo usa variaveis temporarias de runtime:

| Variavel | Uso observado |
|---|---|
| `$0976` | subestado do objeto carregado/prompt/posicionamento |
| `$0978` | slot GameOBJ ligado ao objeto |
| `$0984` | ID/indice do item ou objeto visual atual |
| `$09AC` | subtipo/slot esperado para alguns objetos posicionaveis |
| `$09AD` | coordenada X de destino de tile patch |
| `$09AF` | coordenada Y de destino de tile patch |

Fluxo principal:

1. O objeto visual ou tile interativo chama um dispatcher de held item.
2. O dispatcher consulta `$0976` para saber se esta em prompt, venda, carregamento, colocacao ou finalizacao.
3. `HeldItemObject_HandlePickupPromptSaleOrPlacement` decide se deve abrir texto, vender, falhar por dinheiro cheio, ou aplicar tile patch.
4. Para venda, usa `HeldItemObject_SellDialogPriceTilePatchTable` e `AddMoney`.
5. Para colocacao, calcula o tile em frente com `PlayerTarget_CalculateTileInFront` e aplica `MapTilePatch_ApplyObjectAndRefreshVRAM`.
6. Para ferramentas retiradas de objetos/galpao, `InventoryTool_PickupToolFromMapObject` limpa o bitfield persistente e transfere o item para a selecao atual.
7. Ao finalizar, limpa `!item_on_hand`, libera GameOBJ e limpa o slot runtime de map tile patch.

## Limite do escopo

Esta pass fecha o **nucleo de interacao com objetos carregaveis/pegaveis**, nao a semantica final de todos os IDs individuais de item. Alguns IDs ainda podem precisar de nomes mais humanos em uma pass futura de catalogo fino.

## Validacao

Build USA revalidada como byte-perfect na Pass 53.
