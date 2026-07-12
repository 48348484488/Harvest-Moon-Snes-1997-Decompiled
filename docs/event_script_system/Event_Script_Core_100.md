# Event Script / Scenario Core 100%

Esta pass fecha o núcleo do interpretador de eventos/cenas do jogo.

O sistema de evento usa uma pequena linguagem própria dentro da ROM. Os scripts ficam principalmente nos bancos de dados `B3`, `B4` e `B5`, enquanto o interpretador principal fica no banco `84`.

## Estrutura geral

O jogo mantém várias estruturas de execução de evento, chamadas aqui de **EventScript slots**. Cada slot ocupa um bloco de estado em RAM e guarda:

- se o slot está ativo;
- flags internas do slot;
- contador/wait timer;
- ponteiro atual do script;
- banco do script;
- posição/estado de objeto associado;
- variáveis temporárias usadas por comando;
- ponteiro para GameOBJ quando a cena precisa de objeto visual.

O loop principal percorre todos os slots ativos e executa comandos até encontrar espera, fim, mudança de estado ou transição.

## Fluxo principal

1. `EventScript_UpdateAllActiveSlots` percorre todos os slots ativos.
2. Para cada slot, carrega o ponteiro atual do script em `$C9/$CB`.
3. `EventScript_ExecuteNextOpcode` lê o opcode no script.
4. O opcode é multiplicado por 2 e usado na tabela `EventInstructionPointers`.
5. O handler executa e avança o ponteiro do script.
6. O ponteiro atualizado volta para o slot.
7. Se o comando configurar wait timer, texto, fade, objeto ou transição, o slot pausa até a próxima condição.

## Classes de comandos já fechadas no core

| Classe | Exemplos | Função |
|---|---|---|
| Tempo | `01`, `02`, `03` | liga/desliga tempo e força hora |
| Player | `05`, `07`, `35` | posição, direção e checks do player |
| Transição | `06`, `3C`, `3D` | muda destino de área/mapa |
| Fade/tela | `0A`, `0F` | fade in/out de cena |
| Controle de script | `09`, `10`, `12`, `13` | cria slot, encerra slot, pula, espera |
| Condicionais | `14`, `15`, `16`, `18`, `43`, `44`, `45`, `46` | jumps por flag, valor ou RNG |
| Flags/valores | `23`, `26`, `32`, `47`, `48` | altera flags e memória persistente/runtime |
| Texto | `1C`, `1D`, `21` | inicia textbox e comandos ligados a diálogo |
| Audio | `00`, `0E`, `2C` | dispara comandos de áudio/BGM/SFX |
| Mapa | `29`, `4B` | scroll de mapa e edição de tile |
| Item/dinheiro | `3B`, `3E`, `3F`, `42` | item na mão, drop animation e dinheiro |
| Animais | `30`, `31`, `36`, `50` | galinha, vaca e cachorro |

## Bancos envolvidos

| Banco | Papel |
|---|---|
| `84` | interpretador de eventos e handlers de opcode |
| `B3` | scripts/eventos/cenas |
| `B4` | scripts/eventos/cenas |
| `B5` | scripts/eventos/cenas |
| `83` | textbox/audio/save usados por eventos |
| `80-82` | mapa, player, clima, rotina diária chamada indiretamente |

## Renomeações principais

```text
ClearsofAllCCStructs -> EventScript_ClearAllSlots
SUB_848020 -> EventScript_ClearSlotAndAttachedObject
UNK_LoadCCDataShort -> EventScript_LoadScriptPointerShort
UNK_LoadCCDataLong -> EventScript_LoadScriptPointerLong
SUB_8480F8 -> EventScript_LoadScriptPointerForFacingTile
IterateCCStructures -> EventScript_UpdateAllActiveSlots
EventInstructionInterpreter -> EventScript_ExecuteNextOpcode
SUB_848286 -> EventScript_UpdateAttachedObjectState
```

Comandos centrais também receberam nomes no padrão `EventCmd_XX_Descricao`, por exemplo:

```text
Event_TimeRunning -> EventCmd_01_EnableTimeFlow
Event_TimeStopped -> EventCmd_02_StopTimeFlow
Event_SetPlayerPosition -> EventCmd_05_SetPlayerPosition
Event_SetTransitionDest -> EventCmd_06_SetTransitionDestination
Event_NewCCStructure -> EventCmd_09_StartNestedScriptSlot
Event_JumptoInstruction -> EventCmd_12_Jump
Event_JumpifFlagSet -> EventCmd_14_JumpIfFlagSet
Event_StartTextBox -> EventCmd_1C_StartTextBox
Event_SetFlag -> EventCmd_23_SetFlag
Event_ResetFlag -> EventCmd_26_ResetFlag
Event_EditTileonMap -> EventCmd_4B_EditTileOnMap
```

## O que significa 100% neste escopo

100% aqui significa que o **núcleo do interpretador** está documentado: criação de slot, loop, leitura de opcode, dispatch, avanço de ponteiro, jumps, waits, texto, flags, transições, áudio, itens e comandos principais.

Isso não significa que todos os scripts individuais dos bancos `B3-B5` já estejam nomeados cena por cena. Essa parte fica para outra meta, provavelmente **Event Script Content Catalog 100%** ou **NPC/Event Content Core 100%**.
