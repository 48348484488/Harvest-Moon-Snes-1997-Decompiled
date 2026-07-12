# Pseudocodigo - TextBox DMA Upload Helpers Core

## TextBoxDMA_QueueGlyphPatternPair

```c
void TextBoxDMA_QueueGlyphPatternPair(uint16 source_selector, uint16 vram_tile_cursor) {
    uint16 source_offset = 0x0010 + (source_selector << 4);

    ProgrammedDMA.channel = 6;
    ProgrammedDMA.dest = VRAM_PORT;
    AddProgrammedDMA(source=$72 + source_offset, dest=vram_tile_cursor, size=0x0080);

    ProgrammedDMA.channel = 7;
    ProgrammedDMA.dest = VRAM_PORT;
    AddProgrammedDMA(source=$72 + 0x0100 + source_offset,
                     dest=vram_tile_cursor + 0x0080,
                     size=0x0080);
}
```

## TextBoxDMA_QueuePromptCursorPatternPair

```c
void TextBoxDMA_QueuePromptCursorPatternPair(uint16 vram_destination) {
    ProgrammedDMA.channel = 6;
    ProgrammedDMA.dest = VRAM_PORT;
    AddProgrammedDMA(source=$72 + 0x0004, dest=vram_destination, size=0x0080);

    ProgrammedDMA.channel = 7;
    ProgrammedDMA.dest = VRAM_PORT;
    AddProgrammedDMA(source=$72 + 0x0008,
                     dest=vram_destination + 0x0020,
                     size=0x0080);
}
```

## Observacao

Os nomes sao especificos ao uso observado no banco 83. As duas rotinas continuam byte-perfect; apenas labels e comentarios foram alterados.
