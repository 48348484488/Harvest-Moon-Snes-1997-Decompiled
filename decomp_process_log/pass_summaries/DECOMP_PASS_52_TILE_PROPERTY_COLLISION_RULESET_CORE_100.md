# DECOMP PASS 52 - Tile Property / Collision Ruleset Core 100%

A Pass 52 fechou o nucleo de rulesets de propriedades de tile/colisao.

Principais pontos:

- `TileProperty_RulesetPointerTable` consolidada como tabela paralela de propriedade por mapa.
- 7 rulesets principais de tile-property renomeados.
- Mascara de direcao e mascara de estacao documentadas.
- `CheckToolSuccess` renomeado para `ToolAction_DispatchTileEffectByHeldTool`.
- Relação com `LoadMap`, ferramentas, crops, colisao e interacao documentada.
- Build continua byte-perfect.
