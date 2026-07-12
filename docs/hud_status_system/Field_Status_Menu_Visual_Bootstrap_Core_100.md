# Pass 41 - Field Status/Menu Visual Bootstrap Core 100%

Escopo fechado: mapear o bootstrap visual usado quando o pedido de menu/status chega ao estagio `$95 = $09`.

Esta pass nao fecha o layout completo do menu/status. Ela fecha a preparacao grafica inicial comprovada: tilemap, paleta, DMA, force blank, reset de offsets, reload de graficos/audio e fade-in para o proximo estagio do dispatcher.

## Rotinas e recursos

| Item | Local | Funcao |
|---|---:|---|
| `IntroScreen_FieldStatusMenuStage09` | `$82DAF5` | Handler do estagio `$95 = $09`. |
| `IntroScreen_MenuStage06FadeOutToBootstrap` | `$82DB8E` | Caminho alternativo que tambem cai no bootstrap visual comum. |
| `IntroScreen_MenuVisualBootstrapAndFadeIn` | `$82DBB2` | Loader comum que reseta estado visual, carrega tilemap atual, audio e fade-in. |
| Tilemap `$5B` | `$82DB4E` | Tilemap carregado antes do DMA manual. |
| Tilemap `$5C` | `$82DAF7/$82DB88` | Destino do menu/status antes do bootstrap comum. |
| Paleta `$006D` | `$82DB58` | Paleta BG carregada para WRAM/CGRAM path. |
| DMA `$A9:D800`, tamanho `$0200` | `$82DB6D-$82DB82` | Bloco manual enviado via programmed DMA. |
| Proximo estagio `$95 = $04` | `$82DC03` | Estado seguinte apos fade-in. |

## Fluxo visual fechado

1. `IntroScreen_FieldStatusMenuStage09` seleciona tilemap `$5C`.
2. O BGM da area e selecionado e o audio anterior e encerrado pelo caminho rapido.
3. O jogo faz fade-out, force blank e limpa VRAM/CGRAM/pointers/sprites/OBJs/event slots.
4. O handler zera posicoes do player/transicao e carrega tilemap `$5B`.
5. A paleta `$006D` e carregada.
6. Um DMA programado copia `$0200` bytes de `$A9:D800`.
7. O tilemap volta para `$5C`.
8. `IntroScreen_MenuVisualBootstrapAndFadeIn` zera offsets BG1/BG2, posicoes e timer.
9. O tilemap atual e decompresso/carregado, audio e reiniciado se necessario, force blank e removido e o fade-in roda.
10. O dispatcher avanca para `$95 = $04`.

## Limites do escopo

Fechado nesta pass:

- bootstrap visual inicial do estagio `$95 = $09`;
- relacao entre tilemaps `$5B/$5C`, paleta `$006D` e DMA `$A9:D800`;
- loader comum `IntroScreen_MenuVisualBootstrapAndFadeIn`;
- handoff final para `$95 = $04`.

Nao fechado nesta pass:

- interpretacao dos dados graficos em `$A9:D800`;
- ponteiros/tabelas usados no estagio `$95 = $04`;
- layout semantico final de cada opcao/texto do menu/status;
- diferenca completa entre os caminhos `$95 = $06`, `$95 = $09` e outros estados de intro/menu.
