# Pass 37 - Prompt / Cursor / Grid UI Core 100%

Esta pass fecha o nucleo de UI usado por prompts modais, escolhas de dialogo e selecoes em grade.

## Escopo fechado

**Prompt / Cursor / Grid UI Core 100%**

O escopo cobre a camada que entra em acao quando o jogo nao esta em movimento normal, mas tambem ainda nao esta em um menu grande separado. Ela fica entre:

- `Input_DispatchByState`;
- `TextBox_UpdateRendererAndControlCodes`;
- `TextBox_CloseAndRestoreScrollAndTime`;
- `TextBox_QueueGlyphDMA`;
- `AudioSFX_PlayQueuedEffectDefaultVolume`;
- flags/estado em `$019B`;
- cursor/posicao em `$018E/$018F`;
- retorno para `!inputstate = 1` quando o prompt fecha.

## Rotinas principais

| Label novo | Endereco | Funcao |
|---|---:|---|
| `PromptCursorInput_DispatchModalAndGridModes` | `$84CF05` | Dispatcher dos modos modais de prompt/cursor. |
| `PromptCursorInput_WaitForConfirmOnly` | `$84CF2D` | Espera confirmacao simples. |
| `PromptCursorInput_CloseTextAndReturnToField` | `$84CF40` | Fecha textbox e volta ao controle de campo. |
| `PromptCursorInput_AdvancePageAndRestoreFont` | `$84CF62` | Avanca pagina/restaura fonte de dialogo. |
| `PromptGridInput_DispatchDirectionalAndConfirm` | `$84CF95` | Dispatcher de cursor em grade. |
| `PromptGridInput_ConfirmAndClose` | `$84CFCC` | Confirma a selecao e fecha o prompt. |
| `PromptGridInput_MoveDown` | `$84CFEA` | Move cursor para baixo. |
| `PromptGridInput_MoveUp` | `$84D03A` | Move cursor para cima. |
| `PromptGridInput_MoveRight` | `$84D08E` | Move cursor para direita. |
| `PromptGridInput_MoveLeft` | `$84D0F4` | Move cursor para esquerda. |

## Variaveis principais

| Campo | Uso observado |
|---|---|
| `$019B` | bitfield de modo/controle do prompt. |
| `$0189` | resultado/estado de confirmacao. |
| `$018B` | latch/repeat visual do cursor; zerado apos movimento. |
| `$018E` | limite/forma da grade ou quantidade de opcoes. |
| `$018F` | indice atual do cursor/opcao. |
| `$0185` | posicao VRAM usada por cursor/glyph. |
| `!inputstate` | volta para campo normal quando o prompt fecha. |

## Fluxo resumido

1. `Input_DispatchByState` detecta que o jogador esta em modo imovel/modal.
2. O dispatcher le bits de `$019B` para escolher o subtipo de prompt.
3. Em modo confirm-only, espera A.
4. Em modo close-text, fecha textbox e devolve controle ao campo.
5. Em modo page-advance, restaura font/DMA e reposiciona cursor VRAM.
6. Em modo grid, usa D-pad para alterar `$018F`.
7. Cada movimento toca SFX e redesenha o glyph de cursor via `TextBox_QueueGlyphDMA`.
8. A confirmacao final fecha o prompt e restaura `!inputstate`.

## Importancia pratica

Esse nucleo e importante para mexer em:

- escolhas sim/nao;
- escolhas de 3 opcoes;
- seletores em grade;
- prompts de compra/venda;
- prompts de nome;
- dialogos com cursor;
- menus pequenos que usam textbox como base.

## Status

Escopo fechado em 100% para o nucleo de input/render do cursor modal. O conteudo especifico de cada menu maior continua em seus proprios sistemas.
