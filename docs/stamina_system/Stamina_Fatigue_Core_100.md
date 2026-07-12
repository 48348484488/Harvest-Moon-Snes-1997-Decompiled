# Stamina / Fatigue Core 100%

Esta pass fecha o escopo central de stamina/fadiga: a rotina principal que soma/subtrai stamina, limita o valor, atualiza flags de cansaco e dispara os estados visuais de fadiga.

## Rotina principal

| Item | Valor |
|---|---|
| Label | `Stamina_ApplyDeltaAndFatigueState` |
| Endereco SNES | `$81:D061` |
| Entrada | `A` em 8-bit, valor assinado |
| Positivo | recupera stamina |
| Negativo | gasta stamina |
| Saida | atualiza RAM/flags/acao do jogador |

## RAM usada

| Label | Endereco | Uso |
|---|---:|---|
| `!max_stamina` | `$0917` | stamina maxima atual |
| `!current_stamina` | `$0918` | stamina atual |
| `!exhaustion_level` | `$096C` | nivel de fadiga/cansaco, normalmente 0..3 |
| `!game_state` bit `$0008` | `$00D2` | flag de sem stamina |
| `!player_action` | `$00D4` | recebe `$000B` ao entrar em fadiga |
| `$0901` | `$0901` | recebe animacao/estado de fadiga `$004D` ou `$004A+stage` |
| `$7F1F60` bit `$0008` | `$7F1F60` | bloqueia/ignora calculo de stamina em contexto especial |

## Regras fechadas

1. Se `$7F1F60 & 0x0008` estiver ativo, a rotina retorna sem alterar stamina.
2. O delta em `A` e tratado como assinado de 8 bits.
3. `current_stamina + delta <= 0` zera stamina, liga `!game_state & 0x0008`, define `$0901 = $004D` e `!player_action = $000B`.
4. `current_stamina + delta >= max_stamina` coloca stamina no maximo e limpa a flag de sem stamina.
5. Valores intermediarios gravam o novo valor em `!current_stamina` e limpam a flag de sem stamina.
6. Ao recuperar stamina, o nivel de fadiga e recalculado pela faixa atual.
7. Ao gastar stamina, uma nova animacao de fadiga ocorre apenas quando cruza o proximo limite de faixa.

## Faixas de fadiga

A rotina calcula faixas dividindo `!max_stamina` repetidamente por 2. O comportamento observado fica assim:

| Faixa aproximada | Resultado |
|---|---|
| acima de metade do maximo | fadiga baixa/normal |
| abaixo de 1/2 | primeira faixa de cansaco |
| abaixo de 1/4 | segunda faixa de cansaco |
| abaixo de 1/8 | terceira faixa de cansaco |
| zero | estado sem stamina / fadiga total |

## Recuperacoes confirmadas

| Origem | Valor | Observacao |
|---|---:|---|
| Almoco ao meio-dia | `+20` | `DayCycle_HaveLunchAtNoon` |
| Recuperacao ao entrar em casa/cena relacionada | `+20` | chamada em `bank_82.asm` |
| Comida/item consumido | tabela `HeldItem_ToolUseDialogAndStaminaDeltaTable` | valor vem do terceiro byte de cada registro |
| Reset noturno | `current_stamina = max_stamina` | feito durante a rotina central de virada de dia |

## Custos de ferramenta confirmados

| Ferramenta/acao | Delta |
|---|---:|
| Sickle | `-2` |
| Hoe | `-2` |
| Hammer | `-2` |
| Axe | `-2` |
| Seeds comuns | `-1` |
| Cow Medicine | `-1` |
| Miracle Potion | `-1` |
| Bell | `-1` |
| Grass Seeds | `-1` |
| Paint | `-2` |
| Brush | `-1` |
| Watering Can | `-2` |
| Gold Sickle | `-8` |
| Gold Hoe | `-8` |
| Gold Hammer | `-4` |
| Gold Axe | `-8` |
| Sprinkler | `-8` |
| Chicken Feed | `-2` |
| Cow Feed | `-2` |

## Pontos seguros para modificar

Para alterar dificuldade sem mudar muita coisa:

- mudar deltas antes das chamadas de `Stamina_ApplyDeltaAndFatigueState`;
- aumentar/diminuir `!max_stamina` inicial;
- alterar recuperacao do almoco de `+20`;
- alterar custos das ferramentas em `bank_82_toolused_subrutines.asm`;
- evitar mexer diretamente nas flags de `!game_state` sem testar, porque elas afetam animacao/controle do jogador.

## Escopo fechado

Esta area esta marcada como 100% no sentido de: rotina central, flags principais, limites, reset diario, chamadas conhecidas e custos principais documentados. Ainda podem existir efeitos secundarios de eventos/itens especificos fora do core, mas o nucleo de stamina/fadiga esta mapeado.
