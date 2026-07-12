# Pass 44 - Field Status/Menu Pointer42 Palette Scripts Core 100%

Escopo fechado em 100%:

- decodificado o formato Pointer42: `dw color`, `db delay`, `$FFFF` fim, `$FFFE` jump 24-bit;
- renomeado `UNK_SetPointer42` para `PaletteAnim_SetPointer42Slot`;
- renomeado `UNK_BigLoop` para `PaletteAnim_UpdatePointer42Slots`;
- renomeadas as rotinas de limpeza Pointer42;
- separado `SaveLoadMenu_YearOrdinalGlyphTable` dos scripts de paleta em `$82F2A4+`;
- nomeados e documentados os scripts `FieldStatusMenu_PaletteAnim_*`;
- mantido comportamento byte-perfect.

Proxima meta recomendada: auditar `bank_80_pointersubrutines.asm`, que agora tem muitas chamadas a `PaletteAnim_SetPointer42Slot` e varios scripts Pointer42 ainda sem familia semantica.
