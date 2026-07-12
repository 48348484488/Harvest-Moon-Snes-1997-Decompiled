# Pseudocodigo - Shop / Buying / Selling Core

## Compra simples

```text
quando jogador interage com item/NPC de loja:
    bloquear controle normal do jogador
    abrir dialogo de compra
    esperar resposta do input/menu

    se jogador cancelar:
        fechar dialogo
        restaurar controle
        sair

    se jogador confirmar:
        calcular custo
        se dinheiro insuficiente:
            mostrar texto de dinheiro insuficiente
            restaurar controle
            sair

        debitar dinheiro com AddMoney(valor_negativo)
        entregar item:
            se item carregavel:
                !item_on_hand = item_id
            se ferramenta/semente/feed persistente:
                marcar bit correspondente em !shed_items_row_N
            se animal:
                criar/atualizar slot de vaca/galinha ou preparar entrega

        mostrar texto final
        restaurar controle
```

## Venda direta

```text
quando jogador oferece item para comprador/loja:
    item = !item_on_hand
    registro = HeldItem_ShopSellDialogAndPriceTable[item]

    se item nao aceito:
        mostrar dialogo de recusa
        sair

    mostrar dialogo de oferta/preco
    esperar confirmacao

    se aceito:
        AddMoney(valor_positivo)
        limpar !item_on_hand
        mostrar dialogo de agradecimento
    senao:
        manter item na mao
```

## Animal shop

```text
animal_shop_state = $096F

state 0:
    carregar cena/dialogo inicial
    avancar para state 1

state 1:
    aguardar timer/input
    abrir prompt de compra/venda

state 2:
    esperar dialogo fechar
    validar dinheiro, espaco e estado do animal

state 3+:
    aplicar resultado:
        comprar vaca
        comprar galinha
        vender vaca
        recusar venda/compra
        agendar entrega
    restaurar controle normal
```

## Display de prateleira

```text
para cada item visual de loja:
    ler registro em ShopDisplay_ItemTilePlacementTable
    checar bitfield/condicao
    se item deve aparecer:
        escrever tile no interior/mapa
    senao:
        manter/esconder tile
```
