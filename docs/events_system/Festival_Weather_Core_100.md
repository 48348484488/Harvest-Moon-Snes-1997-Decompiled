# Festival / Weather Core 100 - Pass 19

Esta pass fecha o escopo **Festival / Weather Calendar Core**.

O objetivo aqui nao e documentar todos os scripts de eventos do jogo. O escopo fechado e mais especifico: a rotina central que transforma **data + estacao + RNG** em `!weather_tomorrow`, incluindo os dias fixos de festival.

## Rotina central

Arquivo principal:

```text
src/code_banks/bank_82.asm
```

Rotina:

```asm
Weather_RollTomorrow
```

Essa rotina roda no pipeline diario e decide o clima/evento do dia seguinte.

## Ordem real da rotina

A ordem observada e:

1. checa festivais fixos por estacao/dia;
2. se nao for festival, trata casos especiais do primeiro ano;
3. checa thunder/hurricane;
4. checa chuva;
5. checa neve;
6. se nada acontecer, define sol.

## Tabela de festivais fixos mapeados

| Estacao | Dia | ID em `!weather_tomorrow` | Constante | Significado |
|---|---:|---:|---|---|
| Spring | 22 | `$06` | `!WEATHER_FLOWER_FESTIVAL` | Flower Festival |
| Fall | 11 | `$07` | `!WEATHER_HARVEST_FESTIVAL` | Harvest Festival |
| Fall | 19 | `$0B` | `!WEATHER_EGG_FESTIVAL` | Egg Festival |
| Winter | 9 | `$08` | `!WEATHER_THANKSGIVING` | Thanksgiving |
| Winter | 23 | `$09` | `!WEATHER_STARRY_NIGHT` | Starry Night |
| Winter | 30 | `$0A` | `!WEATHER_NEW_YEAR` | New Year / festive mood |

## IDs de clima/evento documentados

| ID | Constante | Uso conhecido |
|---:|---|---|
| `$00` | `!WEATHER_SUNNY` | dia normal ensolarado |
| `$01` | `!WEATHER_RAIN` | chuva |
| `$02` | `!WEATHER_SNOW` | neve |
| `$03` | `!WEATHER_HURRICANE` | furacao/typhoon |
| `$04` | `!WEATHER_FAIR` | fair/special clear weather |
| `$05` | `!WEATHER_THUNDER_CALM` | thunder/calm special climate |
| `$06` | `!WEATHER_FLOWER_FESTIVAL` | Flower Festival |
| `$07` | `!WEATHER_HARVEST_FESTIVAL` | Harvest Festival |
| `$08` | `!WEATHER_THANKSGIVING` | Thanksgiving Festival |
| `$09` | `!WEATHER_STARRY_NIGHT` | Starry Night Festival |
| `$0A` | `!WEATHER_NEW_YEAR` | New Year / festive mood |
| `$0B` | `!WEATHER_EGG_FESTIVAL` | Egg Festival |
| `$0C` | `!WEATHER_HEAVY_SNOW` | snow/heavy snow ID conhecido pelo comentario de RAM |

## Tabelas RNG ligadas ao clima

Na source:

```asm
Hurricane_Chance_Table
Rain_Chance_Table
Snow_Chance_Table
Thunder_Chance_Table
Snowstorm_Chance_Table
```

Cada tabela tem quatro bytes na ordem:

```text
spring, summer, fall, winter
```

A rotina carrega o byte pela estacao e usa `RNGReturn0toA`. Quando o retorno bate no caso esperado, o clima especial e escolhido.

## Constantes adicionadas

Arquivo:

```text
src/constants/constants.asm
```

Foram adicionadas constantes simbolicas para:

- IDs de estacao;
- IDs de clima/festival;
- dias fixos dos festivais.

Isso nao altera os bytes gerados. Apenas substitui numeros magicos por nomes.

## O que ficou 100% neste escopo

- calendario fixo dos festivais listados acima;
- valores escritos em `!weather_tomorrow` para cada festival;
- caminho central de RNG para clima normal;
- constantes simbolicas dos IDs usados pela rotina.

## O que ainda nao esta 100% fora deste escopo

- script interno completo de cada festival;
- NPCs que aparecem em cada festival;
- dialogos condicionais de festival;
- premios e eventos especificos dentro de cada festival;
- mapas/cenas completos de festival.

Essas partes pertencem ao sistema maior de eventos/scripts e ainda devem ser passadas futuras.
