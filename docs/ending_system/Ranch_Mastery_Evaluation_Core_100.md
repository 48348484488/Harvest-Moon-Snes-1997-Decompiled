# Ranch Mastery / Ending Evaluation Core 100%

Esta pass fecha o nucleo de avaliacao final da fazenda, tambem chamado aqui de **Ranch Mastery**.

## Escopo fechado

Este escopo cobre a rotina que calcula `!ranch_mastery` e chama o script/evento de resultado final.

A rotina principal agora esta nomeada como:

```asm
RanchEval_CalculateMasteryAndStartEnding ; $83:F26D
```

Ela e chamada quando o dispatcher social/evento chega ao caso de fim/avaliacao, antes de iniciar o script final correspondente.

## Variaveis principais

| Variavel | Uso |
|---|---|
| `!ranch_mastery` | acumulador final da pontuacao/avaliacao da fazenda |
| `!ranch_development` | desenvolvimento fisico da fazenda; entra como metade no score |
| `!moneyL/!moneyH` | carteira do jogador; contribui ate limite interno |
| `!cow_N` | numero de vacas; cada vaca soma pontos |
| `!chicks_N` | numero de galinhas/pintinhos; soma pontos |
| `!max_stamina` | upgrades de stamina maxima |
| `!hearts_maria` | afeicao de Maria |
| `!hearts_ann` | afeicao de Ann |
| `!hearts_nina` | afeicao de Nina |
| `!hearts_ellen` | afeicao de Ellen |
| `!hearts_eve` | afeicao de Eve |
| `!shipped_tomatoes` | tomates enviados |
| `!shipped_corn` | milho enviado |
| `!shipped_potatoes` | batatas enviadas |
| `!shipped_turnips` | nabos enviados |
| `!happiness` | felicidade global do jogador |
| `!player_house_and_event_flags` | upgrades da casa e flags permanentes |
| `!marriage_flags` | casamento/esposa |
| `!child_flags` | filhos e alguns itens/flags familiares |
| `!family_event_flags` | flags especiais familiares/eventos |

## Componentes da pontuacao

A rotina soma componentes de varias areas do jogo:

| Grupo | Contribuicao identificada |
|---|---|
| Dinheiro | `money >> 7`, limitado a 78 pontos |
| Vacas | `cow_N * 3` |
| Galinhas/pintinhos | `chicks_N * 3` |
| Stamina maxima | `(max_stamina - 100) / 2` |
| Coracoes das garotas | cada valor usa deslocamento `>> 4` apos mascara original |
| Crops enviados | tomates, milho, batatas e nabos usam deslocamento `>> 4` |
| Felicidade global | `happiness >> 5` |
| Upgrade da casa 1 | +16 se flag ativa |
| Upgrade maximo da casa | +16 se flag ativa |
| Primeiro filho | +16 se flag ativa |
| Segundo filho | +16 se flag ativa |
| Casamento | +32 se qualquer flag de esposa estiver ativa |
| Relogio comprado | +22 se flag ativa |
| Turtle shell | +21 se flag ativa |
| Desenvolvimento da fazenda | `ranch_development / 2` |
| Felicidade das vacas | loop nos 12 slots; cada vaca existente soma felicidade/8, com limite 25 |

No fim, a pontuacao e limitada a `999`.

## Bugs/comportamentos preservados

A source original ja marcava varios calculos como `BUG`. Esta pass **nao corrige** esses bugs; apenas documenta e preserva o comportamento original.

Pontos importantes:

- algumas leituras usam `AND #$01FF` antes de dividir, em vez de comparar/limitar corretamente;
- isso afeta coracoes e crops enviados;
- a rotina ainda recompila byte-perfect, entao qualquer bug original foi preservado de proposito.

## Fluxo de alto nivel

1. Zera `!ranch_mastery`.
2. Soma contribuicao do dinheiro.
3. Soma animais.
4. Soma stamina maxima.
5. Soma afeicao das cinco garotas.
6. Soma crops enviados.
7. Soma felicidade global.
8. Soma upgrades, casamento, filhos e itens/eventos familiares.
9. Soma metade do desenvolvimento da fazenda.
10. Percorre ate 12 vacas e soma felicidade individual.
11. Limita score em `999`.
12. Carrega o script de resultado final via `EventScript_LoadScriptPointerLong`.
13. Marca flag/evento de resultado.

## Relacao com outros sistemas ja fechados

Este core conecta varias passes anteriores:

- `Save/SRAM`: todos os dados avaliados sao persistentes.
- `Shipping/Money`: dinheiro e crops enviados influenciam o score.
- `Livestock`: vacas, galinhas e felicidade de vacas entram na pontuacao.
- `Family/Romance`: casamento, filhos e coracoes entram na pontuacao.
- `Crop Growth/Farm`: desenvolvimento da fazenda e produtos enviados entram no score.
- `Event Script`: a avaliacao termina chamando um script de evento.

## Estado

Escopo fechado em 100% para o nucleo de calculo e disparo do resultado. Conteudo individual do script final e textos associados ainda pertencem aos escopos de eventos/textos individuais.
