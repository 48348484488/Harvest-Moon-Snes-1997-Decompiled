# Pass 40 - Field Status/Menu Handoff Core 100%

Escopo fechado em 100%:

- documentado o consumo de `$7F1F5C & $0004` nos loops de campo em bank 82;
- renomeado `CODE_82D9B3` para `IntroScreen_FieldMenuRequestReentry`;
- renomeado `CODE_82DAF5` para `IntroScreen_FieldStatusMenuStage09`;
- identificado `$95 = $09` como estagio do dispatcher compartilhado de menu/intro;
- separado controle de fluxo comprovado do layout grafico ainda pendente;
- mantido comportamento byte-perfect.

Proxima meta recomendada: mapear o layout visual/tabelas do menu/status, especialmente tilemaps `$5B/$5C` e estagios seguintes do dispatcher.
