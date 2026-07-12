# Livestock Core 100% - Pass 18

Esta pass fecha o escopo **Livestock Core**: a parte central do sistema de animais da fazenda.

O objetivo deste escopo nao e documentar todos os dialogos/eventos de animais, mas sim a logica principal que mantem os animais vivos e persistentes no jogo.

## Rotinas principais

| Rotina | Endereco | Funcao |
|---|---:|---|
| `Livestock_DailyStatusAndFeedingUpdate` | `$83BC5A` | rotina diaria central de vacas e galinhas |
| `Livestock_SpawnVisibleAnimalObjects` | `$83C296` | cria objetos visiveis de animais no mapa atual |
| `AddNewChicken` | `$83C807` | cria/insere nova galinha/pintinho/ovo em slot livre |
| `AddNewCow` | `$83C8DC` | cria/insere nova vaca/bezerro em slot livre |
| `GetChickenPointer` | `$83C995` | retorna ponteiro para slot de galinha |
| `GetCowPointer` | `$83C9A7` | retorna ponteiro para slot de vaca |

## Estruturas persistentes

### Vacas

- Array base: `!cow_array = $7EC1C6`
- Slots: `12`
- Tamanho por slot: `16 bytes`
- Ponteiro temporario usado: `$72`

Layout observado:

| Offset | Uso observado |
|---:|---|
| `+0` | status bitfield: existe, bezerro, jovem/adulta, irritada, doente, gravida, pronta para nascimento |
| `+1` | flags/dia/interacao; bit `$80` usado para iniciar gravidez |
| `+2` | mapa/local onde o animal esta |
| `+3` | timer variavel: idade, gravidez, doenca ou irritacao |
| `+4` | felicidade |
| `+5` | contador/estado secundario diario |

### Galinhas

- Array base: `!chicken_array = $7EC286`
- Slots: `13`
- Tamanho por slot: `8 bytes`
- Ponteiro temporario usado: `$72`

Layout observado:

| Offset | Uso observado |
|---:|---|
| `+0` | status bitfield: existe, ovo, pintinho, adulta, incubacao/timer |
| `+1` | local/mapa ou contador de ovo, dependendo do estado |
| `+2` | timer de crescimento/incubacao ou timer temporario |

## Fluxo diario das vacas

A rotina diaria passa por todos os 12 slots de vaca.

1. Ignora slot vazio.
2. Detecta estado do animal: bezerro, jovem/adulto, doente, irritado, gravida.
3. Verifica se a vaca esta no celeiro ou fora.
4. Se estiver no celeiro, usa `AnimalFeed_StallBitmaskTable` contra `!fed_cows_flags`.
5. Se estiver fora, tenta consumir grama madura com `FarmGrass_MarkFirstMatureGrassPatch`.
6. Se nao comer, perde felicidade e pode ficar doente.
7. Se houver flags de clima/evento/estresse, pode ficar irritada.
8. Atualiza timers de:
   - crescimento de bezerro;
   - irritacao;
   - doenca;
   - gravidez;
   - nascimento.
9. Se a vaca morre, reduz `!cow_N` e seta flag de funeral.

## Fluxo diario das galinhas

A rotina diaria passa por todos os 13 slots de galinha.

1. Ignora slot vazio.
2. Atualiza ovos/pintinhos/incubacao.
3. Atualiza crescimento ate virar galinha adulta.
4. Se for adulta e em condicao valida, marca ovo do dia.
5. Usa `Chicken_EggLaidBitmaskTable` para registrar quais galinhas produziram ovo.
6. Atualiza flags globais de ovo/galinha no bloco de flags `$7F1F6E`.

## Tabelas fechadas neste escopo

| Tabela | Uso |
|---|---|
| `Chicken_CoopSpawnPositionTable` | posicoes base para spawn de galinhas no galinheiro |
| `Cow_BarnSpawnPositionTable` | posicoes base para spawn de vacas no celeiro |
| `Chicken_EggLaidBitmaskTable` | bitmask por galinha para ovos diarios |
| `AnimalFeed_StallBitmaskTable` | bitmask de cochos/posicoes de alimentacao |

## O que significa 100% aqui

O escopo **Livestock Core 100%** quer dizer que a logica central de persistencia dos animais esta mapeada:

- arrays de vacas e galinhas;
- ponteiros por slot;
- update diario;
- alimentacao;
- crescimento;
- nascimento;
- doenca/irritacao;
- ovos;
- spawn visual basico.

Ainda ficam fora deste 100%:

- todos os dialogos de NPCs sobre animais;
- todos os eventos especiais de compra/venda/festival;
- animacoes graficas completas;
- UI/menus de loja/celeiro/galinheiro;
- todos os textos de tutorial.

Esses itens pertencem a outros escopos.
