# Tool Actions Core 100% — Pass 16

Esta documentação cobre o núcleo fechado de ações de ferramentas/itens usados pelo jogador. O escopo foi tratado como 100% porque o fluxo central de seleção -> animação -> efeito -> custo/estado foi mapeado e os principais handlers foram nomeados/documentados.

## Arquivos principais

- `src/code_banks/bank_82.asm`
- `src/code_banks/bank_82_toolanimation_subrutines.asm`
- `src/code_banks/bank_82_toolused_subrutines.asm`
- `src/code_banks/bank_82.asm`, tabelas `ToolAction_AnimationJumpTable` e `ToolAction_EffectJumpTable`

## Fluxo central

1. O jogador seleciona uma ferramenta/item em `!tool_selected`.
2. `ToolAction_StartAnimationOrNoStamina` verifica se o jogador está sem stamina.
3. Se ainda pode agir, `ToolAction_PrecalculateTargetTileAndSound` calcula o tile à frente e chama `CheckToolSuccess`.
4. A animação é escolhida em `ToolAction_AnimationJumpTable`.
5. No frame de efeito, `ToolAction_ExecuteSelectedToolEffect` chama o handler real pela `ToolAction_EffectJumpTable`.
6. O handler altera tile, estado, inventário, flags, alimento, dinheiro, madeira, água, ou evento especial.
7. Quase todos finalizam limpando `!player_action` e aplicando custo via `Stamina_ApplyDeltaAndFatigueState`.

## Labels centrais renomeados nesta pass

| Label antigo | Label novo | Função |
|---|---|---|
| `UNK_ToolUsed` | `ToolAction_StartAnimationOrNoStamina` | Entrada da ação/animação da ferramenta |
| `SUB_829260` | `ToolAction_ExecuteSelectedToolEffect` | Despacha o efeito real da ferramenta |
| `SUB_82927D` | `ToolAction_PrecalculateTargetTileAndSound` | Calcula tile alvo e som/resultado |
| `PreCheckToolSuccess` | `ToolAction_CheckTargetTileSingle` | Verifica um tile à frente |
| `PreCheckToolSuccessLine` | `ToolAction_CheckTargetTileLine` | Verifica padrão em linha |
| `PreCheckToolSuccessSquare` | `ToolAction_CheckTargetTileSquare` | Verifica padrão 3x3 |
| `Tool_Noise_Table` | `ToolAction_UseSoundTable` | Tabela de som/ruído da ferramenta |
| `Tool_Animation_Table` | `ToolAction_AnimationJumpTable` | Tabela de handlers de animação |
| `Tool_Used_Table` | `ToolAction_EffectJumpTable` | Tabela de handlers de efeito |
| `Cow_Feed_Flags` | `AnimalFeed_StallBitmaskTable` | Bitmask de posições de cocho/comedouro |

## IDs principais de `!tool_selected`

| ID | Handler de efeito | Interpretação |
|---:|---|---|
| `$00` | `ToolUsedNoAction` | Nenhuma ação |
| `$01` | `ToolUsedSickle` | Foice normal |
| `$02` | `ToolUsedHoe` | Enxada normal |
| `$03` | `ToolUsedHammer` | Martelo normal |
| `$04` | `ToolUsedAxe` | Machado normal |
| `$05` | `ToolUsedCornSeeds` | Sementes de milho |
| `$06` | `ToolUsedTomatoSeeds` | Sementes de tomate |
| `$07` | `ToolUsedPotatoSeeds` | Sementes de batata |
| `$08` | `ToolUsedTurnipSeeds` | Sementes de nabo |
| `$09` | `ToolUsedCowMedicine` | Remédio de vaca |
| `$0A` | `ToolUsedMiraclePotion` | Miracle potion |
| `$0B` | `ToolUsedBell` | Sino |
| `$0C` | `ToolUsedGrassSeeds` | Semente de grama |
| `$0D` | `ToolUsedPaint` | Tinta |
| `$0E` | `ToolUsedMilker` | Ordenhador |
| `$0F` | `ToolUsedBrush` | Escova |
| `$10` | `ToolUsedWateringCan` | Regador |
| `$11` | `ToolUsedGoldSickle` | Foice dourada |
| `$12` | `ToolUsedGoldHoe` | Enxada dourada |
| `$13` | `ToolUsedGoldHammer` | Martelo dourado |
| `$14` | `ToolUsedGoldAxe` | Machado dourado |
| `$15` | `ToolUsedSprinkler` | Sprinkler |
| `$16` | `ToolUsedMagicBeans` | Magic beans |
| `$17` | `ToolUsedGemSeed` | Gem seed |
| `$18` | `ToolUsedBlueFeather` | Blue feather |
| `$19` | `ToolUsedChickenFeed` | Ração de galinha |
| `$1A` | `ToolUsedCowFeed` | Ração de vaca |
| `$1B` | `ToolUsedUNK` | Handler ainda residual |

## Padrões de área

- `ToolAction_CheckTargetTileSingle`: um tile à frente. Usado por foice/enxada/martelo/machado normal, regador, paint, ferramentas de animal e versões douradas pontuais.
- `ToolAction_CheckTargetTileLine`: padrão em linha progressivo. Usado pela enxada dourada.
- `ToolAction_CheckTargetTileSquare`: padrão 3x3 progressivo. Usado por sementes, foice dourada e sprinkler.

A tabela `ToolSuccessSquareOffsetsTable` contém os offsets usados no padrão 3x3. O contador temporário `$096B` avança cada subpasso da ferramenta.

## Custos de stamina confirmados

| Ferramenta/Ação | Delta | Observação |
|---|---:|---|
| Foice, enxada, martelo, machado normais | `#$FE` / -2 | aplicado ao finalizar ação |
| Brush | `#$FF` / -1 | uso simples |
| Regador | `#$FE` / -2 | mesmo se água/tile falhar após a ação |
| Sementes comuns | `#$FF` / -1 | aplicado após completar 9 posições |
| Foice dourada | `#$F8` / -8 | após completar 9 posições |
| Enxada dourada | `#$F8` / -8 | após completar 6 posições |
| Martelo dourado | `#$FC` / -4 | ação direta |
| Machado dourado | `#$F8` / -8 | ação direta |
| Sprinkler | `#$F8` / -8 | após completar 9 posições |
| Ração galinha/vaca | `#$FE` / -2 | após uso |

## Ações especiais observadas

- Foice no verão pode disparar evento de sapo se flags permitirem.
- Enxada pode disparar mole, dinheiro, money bag e power berry dependendo de flags/RNG.
- Martelo tem checagem especial de estátua/fork em certos mapas.
- Machado tem evento do machado dourado em mapa/faixa específica e flags.
- Magic beans e gem seed dependem de mapa e horário antes de acionar evento.
- Blue feather marca flag de proposta/casamento.

## Estado final do escopo

O núcleo de ações das ferramentas está documentado e com labels centrais humanos. Ainda existem detalhes finos de eventos especiais e propriedades de tiles que pertencem a outros sistemas, mas o fluxo principal de ferramentas está fechado neste escopo.
