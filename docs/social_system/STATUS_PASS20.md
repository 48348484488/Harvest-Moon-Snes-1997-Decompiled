# STATUS PASS 20 - Family / Romance Core

Escopo fechado: **Family / Romance Core 100%**.

## Rotinas centrais

| Rotina | Funcao |
|---|---|
| `Family_DailyPregnancyAndChildGrowth` | atualizacao diaria de gravidez e crescimento dos filhos |
| `Romance_UpdateMostLovedGirlNameBuffer` | encontra a garota com maior coracao e escreve o nome em buffer temporario |

## Renomeacoes principais

| Antes | Depois |
|---|---|
| `WifePregnanacyandChilds` | `Family_DailyPregnancyAndChildGrowth` |
| `FindMostLovedName` | `Romance_UpdateMostLovedGirlNameBuffer` |
| `$7F1F64` | `!player_house_and_event_flags` |
| `$7F1F66` | `!marriage_flags` |
| `$7F1F6C` | `!family_event_flags` |
| `$7F1F6E` | `!child_flags` |

## Validacao

A build foi revalidada depois das renomeacoes e continua byte-perfect.
