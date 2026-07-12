# Pass 41 - Field Status/Menu Visual Bootstrap Core 100%

Escopo fechado em 100%:

- documentado o bootstrap visual acionado por `IntroScreen_FieldStatusMenuStage09`;
- renomeado `CODE_82DB8E` para `IntroScreen_MenuStage06FadeOutToBootstrap`;
- renomeado `CODE_82DBB2` para `IntroScreen_MenuVisualBootstrapAndFadeIn`;
- identificado tilemap `$5B`, destino `$5C`, paleta `$006D` e DMA `$A9:D800/$0200`;
- documentado o avanco para o estagio `$95 = $04`;
- mantido comportamento byte-perfect.

Proxima meta recomendada: mapear o estagio `$95 = $04`, onde o codigo comeca a montar ponteiros/tabelas de layout apos o fade-in.
