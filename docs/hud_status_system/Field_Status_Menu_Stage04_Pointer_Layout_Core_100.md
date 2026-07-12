# Pass 42 - Field Status/Menu Stage04 Pointer/Layout Core 100%

Escopo fechado: mapear o estagio `$95 = $04` que roda apos o bootstrap visual do menu/status e instala os ponteiros de layout nos slots Pointer42.

Esta pass fecha o controle e a matriz de ponteiros. Ela nao decodifica ainda o conteudo semantico dos scripts/tabelas apontados em `$82F2A4/$82F2B5/$82F2C9/$82F2DA`.

## Rotinas

| Item | Local | Funcao |
|---|---:|---|
| `IntroScreen_MenuStage04PointerLayout` | `$82DC0D` | Estagio `$95 = $04`, espera/anima antes de instalar ponteiros. |
| `IntroScreen_MenuStage04ScrollBg2` | `$82DC19` | Incrementa `!BG2_Map_Offset_X` em frames alternados. |
| `IntroScreen_MenuStage04WaitOrInstallLayout` | `$82DC22` | Espera ate `$94 == $3C`. |
| `IntroScreen_MenuStage04InstallPointerLayout` | `$82DC32` | Limpa Pointer42 e instala slots fixos 4/5. |
| `IntroScreen_MenuStage04LayoutVariant00` | `$82DC81` | Layout quando `$098D` nao e 1 nem 2. |
| `IntroScreen_MenuStage04LayoutVariant01` | `$82DCD6` | Layout quando `$098D == 1`. |
| `IntroScreen_MenuStage04LayoutVariant02` | `$82DD2B` | Layout quando `$098D == 2`. |
| `IntroScreen_MenuStage04AdvanceToStage05` | `$82DD80` | Seta `$95 = $05` e volta ao dispatcher. |

## Pointer42

`PaletteAnim_SetPointer42Slot` recebe:

- `$72/$74`: ponteiro 24-bit a instalar;
- `A`: parametro gravado em `$015A,X`;
- `Y`: parametro gravado em `$016A,X`;
- `X`: slot logico, tambem usado para gravar o ponteiro em `$42 + X*3`.

O stage `$04` sempre chama `PaletteAnim_ClearAllPointer42Slots` antes de registrar seus slots.

## Matriz de ponteiros

Slots sempre instalados:

| Slot X | Ponteiro | A | Y |
|---:|---:|---:|---:|
| `$04` | `$82:F2A4` | `$0A` | `$07` |
| `$05` | `$82:F2B5` | `$0B` | `$07` |

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

1. O bootstrap visual entra no stage `$04` com `$94 = 0`.
2. A cada frame, `$94` conta ate `$3C`.
3. Em frames alternados, `!BG2_Map_Offset_X` e incrementado.
4. Quando `$94 == $3C`, Pointer42 e limpo.
5. Slots 4 e 5 sao instalados sempre.
6. `$098D` escolhe uma das tres variantes para slots 6, 7 e 8.
7. O stage seta `$95 = $05`, zera `$94` e retorna a `IntroScreen_democheck`.

## Limites do escopo

Fechado nesta pass:

- controle temporal do stage `$04`;
- uso de `PaletteAnim_ClearAllPointer42Slots` e `PaletteAnim_SetPointer42Slot`;
- matriz de slots/ponteiros/parametros;
- ramificacao por `$098D`;
- handoff para stage `$05`.

Nao fechado nesta pass:

- decodificacao dos comandos dentro dos dados `$82F2A4/$82F2B5/$82F2C9/$82F2DA`;
- comportamento dinamico do stage `$05`;
- significado visual final de cada slot Pointer42.
