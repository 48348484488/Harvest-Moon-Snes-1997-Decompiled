# Pass 49 - TextBox DMA Upload Helpers Core 100%

## Escopo fechado

Esta pass fecha o nucleo auxiliar de DMA usado pelo sistema de texto/dialogo para enviar graficos de glyph e cursor/prompt para VRAM.

O escopo foi considerado 100% fechado porque as duas rotinas globais restantes de DMA no banco 83 foram identificadas pelo uso, renomeadas e documentadas:

- `TextBoxDMA_QueueGlyphPatternPair`
- `TextBoxDMA_QueuePromptCursorPatternPair`

Antes elas ainda apareciam como:

- `UNK_SetDMA1`
- `UNK_SetDMA2`

## O que foi decompilado/documentado

- Helper de DMA para glyph renderizado do textbox.
- Helper de DMA para cursor/prompt piscante do textbox.
- Uso dos canais programados 6 e 7.
- Destino VRAM baseado no cursor/tabela do textbox.
- Fonte grafica em `$72-$74`.
- Upload em dois blocos de `$80` bytes.
- Relacao com `TextBox_QueueGlyphDMA`.
- Relacao com `TextBox_QueuePromptCursorTileDMA`.

## Renomeacoes principais

```text
UNK_SetDMA1 -> TextBoxDMA_QueueGlyphPatternPair
UNK_SetDMA2 -> TextBoxDMA_QueuePromptCursorPatternPair
DATA8_83947D -> TextBox_PromptCursorVRAMDestinationTable
```

## Arquivo principal alterado

```text
src/code_banks/bank_83.asm
```

## Validacao

A build foi revalidada com a ROM USA limpa durante o trabalho:

```text
MD5 ROM USA original: c9bf36a816b6d54aed79d43a6c45111a
MD5 rebuild Pass 49:  c9bf36a816b6d54aed79d43a6c45111a
Resultado: OK, identica byte-a-byte
```

A ROM comercial e a ROM recompilada nao foram incluidas no pacote final.
