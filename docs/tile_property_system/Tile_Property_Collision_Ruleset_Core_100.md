# Tile Property / Collision Ruleset Core 100%

Pass 52 fechou o nucleo de propriedades de tile usado por colisao, interacao e ferramentas de campo.

## Escopo fechado

Este escopo cobre o **core** do sistema, isto e, como o jogo escolhe a tabela de propriedade correta para o mapa atual e como essas propriedades sao lidas para decidir se uma acao pode acontecer em um tile.

Nao significa que todos os 256 IDs de tile tenham recebido nomes humanos perfeitos. Isso fica como camada de catalogacao fina. O core de funcionamento, ponteiros e mascaras esta documentado.

## Fluxo principal

1. `LoadMap` usa `!tilemap_to_load` para escolher o mapa atual.
2. Para mapas da fazenda (`!tilemap_to_load < 4`), o mapa vem do bloco persistente da fazenda.
3. Para outros mapas, `MapPointerTable` fornece o ponteiro para o mapa bruto.
4. Em paralelo, `TileProperty_RulesetPointerTable` fornece o ponteiro para o ruleset de propriedades do mapa.
5. Esse ponteiro e salvo em `$0D-$0F`.
6. Rotinas de ferramenta/interacao chamam `TileProperty_CheckToolUseAllowed`.
7. A rotina calcula o tile alvo, le a propriedade do tile e aplica mascaras de direcao e estacao.

## Symbols principais

| Symbol | Papel |
|---|---|
| `TileProperty_RulesetPointerTable` | Tabela paralela a `MapPointerTable`; seleciona o ruleset de propriedades do mapa atual. |
| `TileProperty_CheckToolUseAllowed` | Checa se a ferramenta/interacao atual e permitida no tile alvo. |
| `TileProperty_DirectionMaskTable` | Mascara direcional baseada em `!player_direction`. |
| `TileProperty_SeasonMaskTable` | Mascara sazonal baseada em `!season`. |
| `ToolAction_DispatchTileEffectByHeldTool` | Dispatcher de efeito da ferramenta que usa as checagens de tile. |

## Rulesets principais

| Ruleset | Endereco SNES | Uso observado |
|---|---:|---|
| `TilePropertyRuleset_00_FarmSeasonalOutdoor` | `$82:B3B4` | Grupo de mapas da fazenda/area sazonal; usado pelos 4 primeiros mapas. |
| `TilePropertyRuleset_01_SparseInterior` | `$82:B7B4` | Ruleset interior/esparso, com poucas permissoes ativas. |
| `TilePropertyRuleset_02_TownOutdoorObjectRows` | `$82:BBB4` | Ruleset com linhas densas de tiles/objetos urbanos. |
| `TilePropertyRuleset_03_GeneralOutdoorInterior` | `$82:BFB4` | Ruleset geral para areas nao-fazenda e interiores simples. |
| `TilePropertyRuleset_04_MountainForestOutdoor` | `$82:C3B4` | Ruleset com varios tiles naturais/caminhos e interacoes externas. |
| `TilePropertyRuleset_05_InteriorSpecialA` | `$82:C7B4` | Ruleset especial A de interiores/areas especificas. |
| `TilePropertyRuleset_06_InteriorSpecialB` | `$82:CBB4` | Ruleset especial B de interiores/areas especificas. |

Os nomes ainda preservam um componente funcional conservador. Eles sao mais seguros do que nomes absolutos por NPC/local, porque varios mapas compartilham o mesmo ruleset.

## Formato da checagem

A rotina usa o tile content como indice e acessa o ruleset por um offset derivado de:

```text
tile_id * 4 + 3
```

Esse byte/word de propriedade e testado contra duas familias de mascara:

```text
direcao: $01, $02, $04, $08
estacao: $10, $20, $40, $80
```

A acao so passa quando a propriedade do tile aceita a direcao atual e a estacao atual.

## Ligacoes com outros sistemas

| Sistema | Relacao |
|---|---|
| Player movement/collision | Usa tile target e atributos de mapa para bloquear/passagem/interacao. |
| Tool Actions Core | Ferramentas chamam o checker antes de aplicar efeito. |
| Crop Growth Core | Tiles de campo/crop usam propriedades para agua, solo e interacao. |
| Map Loading Core | Instala o ruleset correto quando o mapa e carregado. |
| Map Entry Tile Patch Core | Patches visuais podem mudar tile visual, mas o ruleset selecionado continua controlando permissoes. |

## Estado final da Pass 52

- Labels `TileProperty_*` e `TilePropertyRuleset_*` consolidados.
- Tabela de direcao renomeada.
- Tabela de estacao renomeada.
- `CheckToolSuccess` renomeado para `ToolAction_DispatchTileEffectByHeldTool`.
- Build revalidada byte-perfect.

