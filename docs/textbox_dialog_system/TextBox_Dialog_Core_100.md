# TextBox / Dialog Renderer Core 100%

Esta pass fecha o escopo central do sistema de caixa de texto/dialogo. O jogo ja tinha os textos catalogados em passes anteriores; aqui o foco foi o **motor que mostra esses textos na tela**.

## O que foi fechado neste escopo

O escopo **TextBox / Dialog Renderer Core** foi considerado 100% para o nucleo porque agora estao nomeadas e documentadas as partes que:

- carregam o frame/tiles da caixa de dialogo;
- carregam a fonte/graficos do texto para VRAM;
- iniciam uma caixa de texto por ID;
- resolvem `Text_Pointer_Table`;
- pausam o tempo enquanto o texto esta aberto;
- atualizam o texto por frame;
- interpretam codigos de controle centrais;
- inserem numeros dinamicos nos dialogos;
- inserem nomes dinamicos nos dialogos;
- fazem DMA de glyph/tile para VRAM;
- avancam o cursor de VRAM do texto;
- fecham a caixa e restauram scroll/tempo.

Isso nao significa que todos os menus do jogo estao 100%. Significa que o nucleo usado para renderizar dialogos comuns esta mapeado.

## Rotinas principais

| Label novo | Label antigo | Funcao |
|---|---|---|
| `TextBox_LoadDialogueFrameAndFontGraphics` | `LoadDialogueBox` | carrega frame/fonte da caixa de dialogo |
| `TextBox_RestoreDialogueFontDMAAfterClose` | `SUB_83932D` | restaura tiles/DMA apos fechar texto |
| `TextBox_StartByTextId` | `StartTextBox` | inicia texto usando ID da tabela principal |
| `TextBox_CloseAndRestoreScrollAndTime` | `CODE_8393F9` | fecha texto, restaura scroll e tempo |
| `TextBox_UpdatePromptCursorLong` | `CODE_839447` | wrapper longo do cursor/prompt |
| `TextBox_UpdatePromptCursor` | `CODE_839495` | anima cursor/prompt piscando |
| `TextBox_QueuePromptCursorTileDMA` | `CODE_8394D7` | envia tile do prompt para VRAM |
| `TextBox_UpdateRendererAndControlCodes` | `ADDDDFFFF` | renderer principal por frame |
| `TextBox_DrawBlinkingPromptGlyph` | `CODE_83975F` | desenha prompt piscando |
| `TextBox_RenderNumberToken` | `CODE_8397A6` | renderiza numeros dinamicos |
| `TextBox_QueueGlyphDMA` | `CODE_839823` | enfileira DMA de um glyph |
| `TextBox_AdvanceVRAMCursor` | `CODE_839838` | avanca posicao de escrita em VRAM |
| `TextBox_GetGlyphGraphicsPointer` | `CODE_839862` | resolve ponteiro grafico do glyph |

## Tabelas principais

| Label | Funcao |
|---|---|
| `Text_Pointer_Table` | tabela principal de textos por ID |
| `TextBox_NumberVariablePointerTable` | variaveis numericas inseridas por texto |
| `TextBox_NameVariablePointerTable` | nomes/strings dinamicas inseridas por texto |
| `TextBox_GlyphGraphicsBankPointerTable` | blocos graficos da fonte/glyphs |
| `TextBox_ChoiceCursorVRAMAddressTable` | destinos VRAM para prompt/escolhas |
| `TextBox_NumberPlaceValueTable` | valores decimais para converter numeros |

## Codigos de controle centrais observados

| Codigo | Papel observado |
|---|---|
| `$00A2` | caminho especial/prompt glyph |
| `$00B1` | token de linha/spacing/prompt alternado |
| `$FFFC` | insere numero dinamico via `TextBox_NumberVariablePointerTable` |
| `$FFFD` | insere nome/string via `TextBox_NameVariablePointerTable` |
| `$FFFE` | configura prompt/escolha |
| `$FFFF` | final/wait/end flag |

## Fluxo central

1. Uma rotina do jogo chama `TextBox_StartByTextId` com o ID em `X`.
2. O ID e convertido em ponteiro long pela `Text_Pointer_Table`.
3. O texto ativo fica apontado por `$01/$03`.
4. O jogo ajusta BG3 para mostrar a caixa.
5. `!time_running` e pausado.
6. A cada frame, `TextBox_UpdateRendererAndControlCodes` le o proximo token.
7. Token comum vira glyph por `TextBox_GetGlyphGraphicsPointer`.
8. O glyph e enviado por DMA por `TextBox_QueueGlyphDMA`.
9. O cursor de VRAM avanca.
10. Se o token for controle, o sistema executa numero/nome/choice/end.
11. Ao fechar, `TextBox_CloseAndRestoreScrollAndTime` restaura scroll, tiles e tempo.

## Relacao com passes anteriores

- Passes de texto/BR mapearam os textos em `B6-BB`.
- Esta pass mapeia o **motor que renderiza esses textos**.
- Isso ajuda a editar dialogos com menos risco, porque agora os ponteiros, variaveis dinamicas e controles principais estao documentados.

## O que ainda falta fora deste escopo

Ainda ficam para passes futuras:

- menus completos de inventario/config/load;
- layout visual de cada menu;
- todas as rotinas de escolha/dialog branch;
- todas as janelas especiais;
- fonte/glyph table totalmente nomeada por caractere;
- relacao completa entre todos os codigos especiais e scripts.
