# Input / Menu State Core 100%

## Escopo fechado

Esta pass fecha o nucleo de input e estados de menu do jogo. O objetivo nao foi mapear todos os menus especificos do jogo, mas sim o motor central que decide para onde o controle do jogador vai quando o jogo esta em modo normal, menu, name-entry, prompt ou escolha.

## Arquivo principal

```text
src/code_banks/bank_84.asm
```

## Dispatcher principal

Rotina principal renomeada:

```asm
Input_DispatchByState
```

Ela le:

```asm
!inputstate
```

e despacha para handlers diferentes.

## Estados conhecidos de `!inputstate`

| Valor | Significado conhecido | Handler principal |
|---:|---|---|
| `$01` | Controle normal do jogador | `PlayerMovementInputs` |
| `$02` | Sem movimento / imovel | `ImmobileInputs` |
| `$03` | Cursor/prompt modal | `PromptCursorInput_GridCursorMode` |
| `$04` | Menu comum | `MenuInput_DispatchByMenuMode` |
| `$05` | Entrada de nome | `NameEntryInput_Dispatch` |
| `$06` | Modo modal extra ainda parcialmente aberto | `CODE_84CED2` |

## Name-entry

Rotinas renomeadas:

```asm
NameEntryInput_Dispatch
NameEntryInput_BackspaceOrCancel
NameEntryInput_AcceptOrAppendChar
```

Esse modo usa o D-pad para navegar pela grade de caracteres e usa A/B para adicionar, confirmar, apagar ou cancelar caracteres. Ele escreve nos buffers temporarios:

```asm
!temp_name_1
!temp_name_2
!temp_name_3
!temp_name_4
!name_entry_index
```

## Menu comum

Rotina renomeada:

```asm
MenuInput_DispatchByMenuMode
```

Ela usa principalmente o submodo em `$95`. Esse byte seleciona o tipo de menu/fluxo ativo.

## Submodos de menu mapeados

| `$95` | Handler | Funcao geral |
|---:|---|---|
| `$01` | `MenuInput_MainFieldMenuMode` | menu principal/field menu com Start |
| `$02` | `MenuInput_StartButtonCloseOrAdvanceMode` | fluxo modal que fecha/avanca com Start |
| `$03` | `MenuInput_StartButtonCloseOrAdvanceMode` | variante do mesmo fluxo |
| `$05` | `MenuInput_ThreeChoicePromptMode` | prompt de tres opcoes |
| `$07` | `MenuInput_SaveSlotSelectMode` | selecao/confirmacao em slots |
| `$08` | `MenuInput_LoadSlotSelectMode` | selecao de load/slot summary |

## Selecoes binarias

Rotinas renomeadas:

```asm
MenuInput_SelectConfirmYes
MenuInput_SelectConfirmNo
MenuInput_LoadSelectConfirmYes
MenuInput_LoadSelectConfirmNoOrLoadSummary
```

Elas manipulam bytes de escolha como `$94` e atualizam o estado visual/sonoro da confirmacao.

## Selecao de slot

Rotinas renomeadas:

```asm
MenuInput_ToggleSaveSlotCursor
MenuInput_ToggleLoadSlotCursor
```

Essas rotinas alternam o slot selecionado usando `$098E`, tocam SFX e sinalizam atualizacao visual atraves de `$97`.

## Prompt de tres opcoes

Rotinas renomeadas:

```asm
MenuInput_ThreeChoicePromptMode
MenuInput_ThreeChoiceMoveDown
MenuInput_ThreeChoiceMoveUp
MenuInput_ThreeChoiceAccept
```

Esse fluxo usa `$098D` como indice de escolha 0..2. Ao aceitar, o valor escolhido redireciona `$95` para outro submodo.

## Cursor em grade de prompt

Rotinas renomeadas:

```asm
PromptCursorInput_GridCursorMode
PromptCursorInput_AcceptSelectionOrStartText
PromptCursorInput_MoveDown
PromptCursorInput_MoveUp
PromptCursorInput_MoveRightColumn
PromptCursorInput_MoveLeftColumn
```

Esse modo usa `$018A` como posicao de cursor em uma grade de 11 entradas por coluna. Quando a selecao aponta para texto, o motor chama:

```asm
TextBox_StartByTextId
```

## Relação com outros sistemas

Este core conecta diretamente:

- `TextBox / Dialog Renderer Core`;
- save/load;
- name-entry de jogador/animais;
- menu de escolhas;
- movimento normal do player;
- SFX de cursor/confirmacao;
- controle de bloqueio de tempo/input.

## Observacao importante

O escopo fechado aqui e o **core de estados de input/menu**, nao todos os menus especificos do jogo. Menus completos como inventario, lojas, HUD detalhado e telas especificas ainda podem ter rotinas proprias para serem fechadas em passes futuras.

