# DECOMP PASS 49 - TextBox DMA Upload Helpers Core 100%

Esta pass fecha os auxiliares de DMA do sistema de textbox/dialogo, renomeando as ultimas duas rotinas globais `UNK_SetDMA*` do banco 83.

## Resultado

- `UNK_SetDMA1` identificado como helper de DMA de glyph do textbox.
- `UNK_SetDMA2` identificado como helper de DMA do prompt/cursor piscante.
- `DATA8_83947D` identificado como tabela de destino VRAM do prompt/cursor.
- Build recompilada byte-perfect.

## Arquivos de referencia

- `docs/textbox_dialog_system/TextBox_DMA_Upload_Helpers_Core_100.md`
- `docs/pseudocode/TextBox_DMA_Upload_Helpers_Core.md`
- `VALIDACAO_BUILD_PASS49.md`
