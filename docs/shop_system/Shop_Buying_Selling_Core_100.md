# Shop / Buying / Selling Core 100%

Esta pass fecha o escopo central de lojas, compra e venda direta.

O objetivo nao foi alterar precos nem adicionar loja nova. O objetivo foi documentar e marcar no source o nucleo que liga:

- input/menu state;
- TextBox/dialogos de confirmacao;
- dinheiro do jogador;
- `AddMoney`, incluindo debito por compra e credito por venda;
- `!item_on_hand`, item recebido/comprado;
- bitfields persistentes do tool shed;
- lojas visuais/interiores;
- animal shop, flower shop, general store e vendedor/eventos especiais.

## Variaveis principais

| Simbolo/endereco | Uso |
|---|---|
| `!item_on_hand` | Item recebido, comprado, vendido ou carregado na mao. |
| `!moneyL` / `!moneyH` | Carteira principal do jogador, usada para checar/efetivar compra. |
| `!shipping_moneyL` / `!shipping_moneyH` | Total diario de shipping; dialogo de 5PM usa essa base. |
| `!shed_items_row_1` ate `!shed_items_row_4` | Bitfields que registram ferramentas/sementes/feed possuidos. |
| `$096F` | Estado interno de varios fluxos de loja/evento: introducao, espera de input, confirmacao, entrega/saida. |
| `$0970` | Timer auxiliar usado em cenas de compra/entrega/animação. |
| `$099F` | Resultado/opcao selecionada em algumas janelas de escolha. |
| `$09A0` | Indice contextual usado em fluxos ligados a animais/loja. |

## Rotinas e tabelas principais

| Label | Funcao |
|---|---|
| `HeldItem_ShopSellDialogAndPriceTable` | Tabela de 3 bytes por item para venda direta: texto/dialogo + valor. |
| `HeldItem_ShippingPriceTable` | Tabela de valores do shipping/bin. Compartilha parte da logica economica. |
| `ShopDisplay_DrawConditionalItemTile` | Desenha/esconde item de prateleira conforme flags de posse/disponibilidade. |
| `ShopDisplay_ItemTilePlacementTable` | Tabela de posicao e metadata visual para itens em lojas/interiores. |
| `ReplaceTilesFlowerShop` | Atualiza tiles/itens visiveis da flower shop. |
| `ReplaceTilesGeneralStore` | Atualiza tiles/itens visiveis da general store. |
| `ReplaceTilesAnimalShop` | Atualiza tiles/itens visiveis da animal shop. |
| `AddMoney` | Rotina comum de alterar dinheiro. Compra usa delta negativo; venda usa delta positivo. |

## Fluxos fechados

### Compra simples

1. O jogador interage com o item/NPC da loja.
2. O jogo entra em modo de menu/dialogo (`!inputstate = 2`).
3. Um texto pergunta se o jogador quer comprar.
4. O input/menu confirma ou cancela.
5. Se confirmar, o jogo checa dinheiro e flags de disponibilidade.
6. Se tiver dinheiro/condicao, chama `AddMoney` com valor negativo ou atualiza flags/itens.
7. O item entra em `!item_on_hand` ou no bitfield persistente adequado.
8. O dialogo final e exibido.

### Venda direta

1. O item carregado em `!item_on_hand` identifica o fluxo.
2. A tabela `HeldItem_ShopSellDialogAndPriceTable` fornece texto e valor.
3. O comprador/loja mostra o dialogo correto.
4. Se aceito, o dinheiro e adicionado via `AddMoney`.
5. O item e limpo da mao ou o estado volta ao normal.

### Animal shop

O nucleo de animal shop cobre:

- compra de vaca;
- compra de galinha;
- venda de vaca;
- dialogos de impossibilidade, como falta de dinheiro, condicoes do animal ou falta de espaco;
- ligacao com arrays de vacas/galinhas ja documentados nas passes anteriores;
- entrega futura/estado intermediario usando `$096F` e `$0970`.

### Display de prateleiras

O display visual da loja nao e a compra em si, mas e parte do nucleo de loja:

- verifica flags/bitfields;
- decide se um item aparece ou some;
- escreve o tile certo no mapa/interior;
- permite que compras anteriores removam ou mudem itens exibidos.

## Textos ligados ao core

Alguns IDs importantes ja catalogados no sistema de textos:

| ID | Uso provável |
|---:|---|
| `$0305` | pergunta ligada a compra/venda de vaca. |
| `$0307` | custo de vaca. |
| `$030A` | custo de galinha. |
| `$030C` | vaca colocada no curral/pen. |
| `$030D` | venda recusada por condicao da vaca. |
| `$030E` | venda de animal/valor. |
| `$031A` | dialogo de shipping total do dia. |
| `$031B` | dialogo quando nao ha shipping no dia. |
| `$0331` | prompt generico de compra com valor. |
| `$033B` | item/medicine shop relacionado a miracle potion. |

## O que este 100% significa

Este escopo esta fechado para o nucleo de compra/venda:

- fluxo de compra identificado;
- fluxo de venda direta identificado;
- tabela de venda direta documentada;
- conexao com `AddMoney` documentada;
- conexao com `!item_on_hand` documentada;
- conexao com bitfields de loja/tool shed documentada;
- animal shop integrado ao sistema de dinheiro/animais documentado;
- display condicional de itens de loja documentado;
- source recompila byte-perfect apos a documentacao/comentarios.

Ainda nao significa 100% de todos os dialogos de todos os NPCs, nem 100% de todas as lojas especiais/event scripts. Isso fica para escopos de NPC/event script e map/event loading.
