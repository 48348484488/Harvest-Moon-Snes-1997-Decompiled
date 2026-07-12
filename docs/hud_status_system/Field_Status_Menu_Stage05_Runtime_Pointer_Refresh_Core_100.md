# Pass 43 - Field Status/Menu Stage05 Runtime Pointer Refresh Core 100%

Escopo fechado: mapear o estagio `$95 = $05`, que mantem o menu/status ativo apos a instalacao inicial de Pointer42 e reconstrui os ponteiros quando `$97` solicita refresh visual.

Esta pass continua a Pass 42. A Pass 42 instala a matriz inicial; esta pass fecha a atualizacao dinamica da mesma matriz enquanto o dispatcher permanece no stage `$05`.

## Rotinas

| Item | Local | Funcao |
|---|---:|---|
| `IntroScreen_MenuStage05RuntimePointerRefresh` | `$82DD8C` | Handler do stage `$95 = $05`. |
| `IntroScreen_MenuStage05CheckRefreshFlag` | `$82DD9D` | Incrementa `$94` e testa `$97`. |
| `IntroScreen_MenuStage05RefreshRequested` | `$82DDA9` | Limpa `$97` e escolhe variante por `$098D`. |
| `IntroScreen_MenuStage05RefreshVariant00` | `$82DDBE` | Atualiza slots 6/7/8 quando `$098D` nao e 1 nem 2. |
| `IntroScreen_MenuStage05RefreshVariant01` | `$82DE13` | Atualiza slots 6/7/8 quando `$098D == 1`. |
| `IntroScreen_MenuStage05RefreshVariant02` | `$82DE68` | Atualiza slots 6/7/8 quando `$098D == 2`. |
| `IntroScreen_MenuStage05AdvanceFrame` | `$82DEBD` | Incrementa `$90` e retorna ao dispatcher. |

## Relacao com input

`$97` e usado como flag de refresh visual por handlers de menu em bank 84. No fluxo de tres opcoes, `MenuInput_ThreeChoiceMoveDown` e `MenuInput_ThreeChoiceMoveUp` atualizam `$098D` e setam `$97 = 1`; o stage `$05` consome essa flag e reinstala os slots Pointer42 correspondentes.

## Matriz de refresh

Quando `$97 == 0`, nenhum Pointer42 e reinstalado; o stage apenas incrementa `$90` e retorna ao dispatcher.

Quando `$97 != 0`, `$97` e limpo e a matriz abaixo e aplicada:

Variante 00 (`$098D != 1` e `$098D != 2`):

| Slot X | Ponteiro | A | Y |
|---:|---:|---:|---:|
| `$06` | `$82:F2C9` | `$0D` | `$07` |
| `$07` | `$82:F2DA` | `$0F` | `$07` |
| `$08` | `$82:F2DA` | `$09` | `$02` |

Variante 01 (`$098D == 1`):

| Slot X | Ponteiro | A | Y |
|---:|---:|---:|---:|
| `$06` | `$82:F2DA` | `$0D` | `$07` |
| `$07` | `$82:F2C9` | `$0F` | `$07` |
| `$08` | `$82:F2DA` | `$09` | `$02` |

Variante 02 (`$098D == 2`):

| Slot X | Ponteiro | A | Y |
|---:|---:|---:|---:|
| `$06` | `$82:F2DA` | `$0D` | `$07` |
| `$07` | `$82:F2DA` | `$0F` | `$07` |
| `$08` | `$82:F2C9` | `$09` | `$02` |

## Fluxo

1. Stage `$05` anima `!BG2_Map_Offset_X` em frames alternados.
2. `$94` incrementa a cada tick do stage.
3. Se `$97 == 0`, o stage nao mexe nos ponteiros.
4. Se `$97 != 0`, `$97` e limpo.
5. `$098D` seleciona a variante 00/01/02.
6. Slots Pointer42 `$06-$08` sao reinstalados.
7. `$90` incrementa e o dispatcher continua em `IntroScreen_democheck`.

## Limites do escopo

Fechado nesta pass:

- papel de `$97` como pedido de refresh;
- refresh runtime dos slots Pointer42 `$06-$08`;
- matriz de variantes por `$098D`;
- contador `$90` no final do stage.

Nao fechado nesta pass:

- interpretacao interna dos scripts `$82F2C9/$82F2DA`;
- todos os handlers de input que podem setar `$97` fora do fluxo de tres opcoes;
- condicao de saida/accept completa dos estados seguintes.
