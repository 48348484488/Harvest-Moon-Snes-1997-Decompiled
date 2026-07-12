# Pass 40 - Field Status/Menu Handoff Core 100%

Escopo fechado: mapear o handoff que leva o pedido de menu/status de campo do bit persistente `$7F1F5C & $0004` ate o dispatcher de menu/intro com `$95 = $09`.

Esta pass continua a Pass 39. A Pass 39 fecha onde o Start cria o pedido; esta Pass 40 fecha onde o loop de campo consome o pedido e entrega o controle para o handler do estagio `$09`.

## Evidencia principal

| Item | Local | Funcao |
|---|---:|---|
| `MenuInput_OpenSecondaryMenuFromStart` | `$84C2DA` | Seta `$95 = $09` e `$7F1F5C |= $0004`. |
| `PASS40_FIELD_STATUS_MENU_HANDOFF` | `$82D396` | Loop de campo checa `$7F1F5C & $0004`. |
| `.fieldStatusMenuRequestPending` | `$82D3A6` | Sai do loop, limpa scratch e reentra no dispatcher com `$95 = $09`. |
| `.fieldStatusMenuOrReturnPending` | `$82D731` | Caminho equivalente que tambem aceita `$7F1F60 & $0080`. |
| `IntroScreen_democheck` | `$82D871` | Dispatcher compartilhado de intro/menu. |
| `IntroScreen_FieldMenuRequestReentry` | `$82D9B3` | Se `$95` ja e `$09`, pula a reconstrucao inicial e volta ao dispatcher. |
| `IntroScreen_FieldStatusMenuStage09` | `$82DAF5` | Handler selecionado quando `!intro_stage/$95 == $09`. |

## Fluxo fechado

1. O input de campo abre o pedido com `$95 = $09` e `$7F1F5C |= $0004`.
2. O loop de campo continua atualizando mapa, eventos, texto, input, objetos, OAM e scrolling ate o fim do frame.
3. No fim do frame, o loop testa `$7F1F5C & $0004`.
4. Se o bit esta limpo, o jogo limpa `!NMI_Status` e continua o loop normal.
5. Se o bit esta setado, o loop prepara o retorno, garante `$95 = $09`, zera `$90` e salta para `IntroScreen_democheck`.
6. O dispatcher ve `$95 = $09` e chama `IntroScreen_FieldStatusMenuStage09`.
7. O handler `$09` carrega o caminho grafico compartilhado de menu/tilemap e cai no setup ja existente dos estagios seguintes.

## Limites do escopo

Fechado nesta pass:

- consumo de `$7F1F5C & $0004` nos loops de campo observados;
- ponte `$7F1F5C bit 0004 -> $95 = $09 -> IntroScreen_democheck`;
- handler global do estagio `$95 = $09`;
- ponto de reentrada que evita reconstruir transicao quando `$95` ja e `$09`;
- documentacao de limite entre controle de fluxo e layout visual.

Nao fechado nesta pass:

- significado completo de `$7F1F60 & $0080`;
- layout final do HUD/status;
- tabelas graficas dos tilemaps `$5B/$5C`;
- todos os estagios posteriores do dispatcher de intro/menu.

Esses itens ficam para a meta seguinte de layout/status.
