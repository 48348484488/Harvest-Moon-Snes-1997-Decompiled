# Player Movement / Collision / Interaction Core 100%

Esta pass fecha o nucleo de movimento normal do jogador em campo. O objetivo nao foi alterar comportamento, mas transformar os labels genericos em nomes mais claros e documentar o fluxo principal.

## Arquivos principais

```text
src/code_banks/bank_84.asm  -> input normal, movimento, A/B/Y/L/R/X/Select
src/code_banks/bank_83.asm  -> helpers de colisao com objetos/tile
src/code_banks/bank_82.asm  -> interacao com tile em frente
src/code_banks/bank_81.asm  -> calculo do tile em frente
```

## Variaveis centrais

| Variavel | Papel |
|---|---|
| `!inputstate` | seleciona modo de input global |
| `!game_state` | flags que bloqueiam/permitem controle, item na mao, animacoes etc. |
| `!player_action` | acao/animacao atual do player |
| `!player_direction` | direcao atual: 0 baixo, 1 cima, 2 esquerda, 3 direita |
| `!player_pos_X` | posicao X do player |
| `!player_pos_Y` | posicao Y do player |
| `!tile_in_front_X` | coordenada calculada do tile/area em frente |
| `!tile_in_front_Y` | coordenada calculada do tile/area em frente |
| `!tool_selected` | ferramenta atualmente selecionada |
| `!item_on_hand` | item carregado/segurado |

## Fluxo principal

1. `Input_DispatchByState` chama `PlayerInput_NormalMovementCore` quando o jogo esta no modo normal de controle.
2. `PlayerInput_NormalMovementCore` verifica flags que impedem movimento/interacao.
3. Se uma direcao esta pressionada, chama uma das rotinas `PlayerMove_StartDown/Up/Left/Right`.
4. A rotina direcional grava `!player_action = 1` e ajusta `!player_direction`.
5. Se nenhuma direcao importante tomou controle, `PlayerInput_ProcessActionButtons` despacha A/B/Y/L/R/X/Select.
6. Acoes de interacao calculam o tile em frente com `PlayerTarget_CalculateTileInFront`.
7. As rotinas de colisao/interacao verificam tile, objeto ativo ou item carregado antes de mudar o estado do jogador.

## Botoes principais

| Botao | Rotina | Resultado principal |
|---|---|---|
| D-Pad | `PlayerMove_StartDown/Up/Left/Right` | inicia movimento e direcao |
| A | `PlayerInput_A_InteractOrDrop` | interage, pega, solta ou posiciona item |
| B | `PlayerInput_B_RunOrJump` | correr ou pular quando permitido |
| Y | `PlayerInput_Y_ToolOrFishing` | usa ferramenta ou controla pesca |
| R | `PlayerInput_R_WhistleHorse` | assobia cavalo se possuir |
| L | `PlayerInput_L_WhistleDog` | assobia cachorro se possuir |
| Select | `PlayerInput_Select_Action0C` | acao auxiliar/menu conforme estado |
| X | `PlayerInput_X_Action1C` | acao auxiliar conforme estado |

## Colisao

Foram nomeados tres pontos importantes:

```asm
Collision_CheckMapTileAtDirection
Collision_CheckObjectOverlapAtDirection
Collision_ReadTileAttributeAtPixel
```

A logica usa a posicao base do player em scratch RAM e calcula uma projecao conforme a direcao. A checagem evita colocar/arremessar objeto em tile invalido ou em cima de objeto ativo.

## Interacao com objeto carregado

Quando o player esta carregando algo, o botao A passa por:

```asm
PlayerInput_A_TryThrowHeldObjectByDirection
PlayerCollision_CheckAheadForObjectOrBlockedTile
PlayerCollision_StartBlockedCarryObjectReaction
```

Se o espaco esta livre, a rotina ajusta direcao/acao; se esta bloqueado, inicia uma reacao/animacao de bloqueio.

## Pesca/ferramenta

O botao Y concentra ferramenta e pesca:

```asm
PlayerInput_Y_ToolOrFishing
FishingInput_CastLine
FishingInput_ReelEmptyLine
FishingInput_ReelCatch
ToolAction_StartAnimationOrNoStamina
```

Isso liga o sistema de movimento ao core de ferramentas fechado na Pass 16 e ao sistema de stamina fechado na Pass 15.

## Status do escopo

Este escopo esta fechado como **100%** porque o caminho principal de controle normal, direcao, botoes de acao, target tile e colisao essencial foi mapeado/documentado. Ainda podem existir subdetalhes de animacao ou eventos especiais, mas o nucleo funcional de movimento/interacao esta coberto.
