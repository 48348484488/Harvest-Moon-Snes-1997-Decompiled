# Family / Romance Core 100% - Pass 20

Esta pass fecha o escopo **Family / Romance Core**: casamento, coracoes das garotas, selecao da garota mais amada, gravidez da esposa e crescimento dos filhos.

O objetivo foi documentar o nucleo persistente e diario desse sistema sem alterar comportamento da ROM.

## Estruturas principais de RAM/SRAM

| Simbolo | Endereco | Tamanho | Funcao |
|---|---:|---:|---|
| `!hearts_maria` | `$7F1F1F` | 16b | coracoes/afeicao da Maria |
| `!hearts_ann` | `$7F1F21` | 16b | coracoes/afeicao da Ann |
| `!hearts_nina` | `$7F1F23` | 16b | coracoes/afeicao da Nina |
| `!hearts_ellen` | `$7F1F25` | 16b | coracoes/afeicao da Ellen |
| `!hearts_eve` | `$7F1F27` | 16b | coracoes/afeicao da Eve |
| `!wife_pregnancy` | `$7F1F3B` | 16b | contador de gravidez/progresso familiar |
| `!kid1_age` | `$7F1F37` | 16b | idade/progresso do primeiro filho |
| `!kid2_age` | `$7F1F39` | 16b | idade/progresso do segundo filho |
| `!marriage_flags` | `$7F1F66` | 16b | bitfield de esposa/casamento |
| `!family_event_flags` | `$7F1F6C` | 16b | flags de evento/marco familiar |
| `!child_flags` | `$7F1F6E` | 16b | flags de existencia/nascimento dos filhos |

## Bits observados de casamento

`!marriage_flags` usa um bit para identificar qual esposa esta ativa.

| Bit | Valor | Esposa |
|---|---:|---|
| 0 | `$0001` | Maria |
| 1 | `$0002` | Ann |
| 2 | `$0004` | Nina |
| 3 | `$0008` | Ellen |
| 4 | `$0010` | Eve |

A rotina diaria trata essas esposas de forma equivalente; ela primeiro testa se algum desses bits esta ativo e, se nenhum estiver, sai sem atualizar gravidez/filhos.

## Limiares de coracao para filhos

A rotina `Family_DailyPregnancyAndChildGrowth` usa a esposa atual e compara o valor de coracoes com limiares diferentes para primeiro e segundo filho.

| Filho | Decimal | Hex | Observacao |
|---|---:|---:|---|
| Primeiro filho | `450` | `$01C2` | esposa precisa estar acima/igual a este valor |
| Segundo filho | `650` | `$028A` | usado quando ja existe primeiro filho |

Na source original havia uma comparacao de Maria escrita como decimal `450`, enquanto as outras aparecem em hex `$01C2`; sao o mesmo valor.

## Requisitos para gravidez/filho

O pipeline observado e:

1. Verifica se existe esposa em `!marriage_flags`.
2. Incrementa `!wife_pregnancy` diariamente.
3. Seleciona a esposa ativa.
4. Testa coracoes da esposa.
5. Testa se `!wife_pregnancy >= 20`.
6. Testa se a casa tem upgrade suficiente (`!player_house_and_event_flags` bit `$0080`).
7. Seta flag de primeiro ou segundo filho em `!child_flags`.
8. Depois avanca idade dos filhos existentes.

## Crescimento dos filhos

| Campo | Regra observada |
|---|---|
| `!kid1_age` | incrementa diariamente se o primeiro filho existe |
| `!kid2_age` | incrementa diariamente se o segundo filho existe |
| nascimento/evento | em `age == 60`, seta flag de nascimento/evento e adiciona felicidade |
| crescimento para outra fase | depois de `age - 60`, a cada `120` dias marca milestone de idade |

A rotina usa divisao por `120` para disparar marcos periodicos de crescimento depois do nascimento.

## Rotina de garota mais amada

`Romance_UpdateMostLovedGirlNameBuffer` compara os cinco valores de coracao e escreve o nome da garota com maior valor em:

| Buffer | Endereco |
|---|---:|
| `!most_hearts_girl_name_1` | `$08A1` |
| `!most_hearts_girl_name_2` | `$08A3` |
| `!most_hearts_girl_name_3` | `$08A5` |
| `!most_hearts_girl_name_4` | `$08A7` |
| `!most_hearts_girl_name_5` | `$08A9` |

Esse buffer e usado por dialogos/telas que precisam referenciar a garota com maior afeicao.

## Observacao sobre bug/peculiaridade

A logica de selecao no final da rotina tem um fallback para Maria quando o indice nao casa com os casos esperados. Isso foi mantido intacto para preservar comportamento byte-perfect.

## O que esta fechado neste escopo

- local dos coracoes das cinco garotas;
- bitfield de casamento;
- contador de gravidez;
- criterios de primeiro/segundo filho;
- idade dos filhos;
- buffer do nome da garota mais amada;
- rotina diaria de esposa/filhos;
- fluxo central do sistema familiar.

## O que ainda nao faz parte deste escopo

- scripts completos de cada evento romantico;
- dialogos especificos de cada NPC;
- condicoes de mapa/cutscene externas;
- rotinas completas de casamento/cerimonia;
- todos os efeitos de presentes no relacionamento.

Essas partes pertencem ao escopo maior de **NPC/Event Scripts**, que ainda precisa de passes proprias.
