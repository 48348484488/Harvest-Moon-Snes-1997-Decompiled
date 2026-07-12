# Shipping / Money Core 100%

Escopo fechado desta pass: fluxo central de dinheiro da carteira, acumulador diario de shipping e deposito noturno.

## Componentes mapeados

| Componente | Local | Estado |
|---|---|---|
| Carteira principal | `!moneyL` / `!moneyH` (`$7F1F04-$7F1F06`) | mapeado |
| Acumulador diario de shipping | `!shipping_moneyL` / `!shipping_moneyH` (`$7F1F07-$7F1F09`) | mapeado |
| Helper de dinheiro | `AddMoney` em `bank_83.asm` | mapeado |
| Drop no shipping bin | `HeldItem_DroppedOnShippingBin` em `bank_81.asm` | mapeado |
| Tabela de valor de shipping | `HeldItem_ShippingPriceTable` em `bank_81.asm` | mapeado |
| Cena das 5PM | `ShippingScene_StartAt5PM` em `bank_82.asm` | mapeado |
| Dialogo diario de ganhos | `ShippingScene_ShowDailyEarningsDialogue` em `bank_82.asm` | mapeado |
| Deposito noturno | bloco dentro de `DayCycle_NightResetAdvanceDate` em `bank_82.asm` | mapeado |

## Fluxo do shipping

1. O jogador coloca um item na caixa de shipping.
2. A rotina `HeldItem_DroppedOnShippingBin` verifica a propriedade do tile e o item em maos.
3. O valor e lido em `HeldItem_ShippingPriceTable`.
4. Se for antes das 17:00, o valor entra em `!shipping_moneyL/H`.
5. As 17:00, `ShippingScene_StartAt5PM` dispara a cena de coleta se o jogador esta na fazenda.
6. `ShippingScene_ShowDailyEarningsDialogue` escolhe o texto de ganho ou o texto de nada enviado.
7. Na virada da noite, o acumulador de shipping e transferido para a carteira usando `AddMoney`.
8. Depois do deposito, `!shipping_moneyL/H` e zerado para o proximo dia.

## AddMoney

`AddMoney` recebe um delta de 24 bits em `$72-$74`. Ele soma esse valor na carteira principal.

Regras confirmadas:

- resultado negativo: retorna falha e nao aplica;
- acima do limite: trava no maximo `$0F423F`;
- resultado valido: grava em `!moneyL/H`;
- retorno `A = 0`: sucesso;
- retorno `A = 1`: falha por resultado negativo.

## Observacao sobre valores

O jogo usa uma convencao onde parte da exibicao de dinheiro tem zero final falso. Por isso alguns valores internos parecem menores do que o valor visual em G. Essa pass documenta o fluxo central, nao todos os precos de todos os itens do jogo.

## O que ainda nao faz parte deste 100%

Nao inclui 100% de todas as lojas, todos os eventos que ganham/perdem dinheiro, nem todos os dialogos comerciais. O escopo fechado e apenas o nucleo de:

- carteira;
- `AddMoney`;
- shipping bin;
- acumulador diario;
- cena das 5PM;
- deposito noturno.
