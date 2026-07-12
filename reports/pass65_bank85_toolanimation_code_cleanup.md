# Pass 65 - Bank85 + ToolAnimation CODE cleanup
Esta pass fecha um cluster pequeno e seguro de labels `CODE_` locais.

## Escopo
- `src/code_banks/bank_85.asm`: branch labels locais do core GameOBJ/sprite/object.
- `src/code_banks/bank_82_toolanimation_subrutines.asm`: branch labels locais das subrotinas de animacao de ferramenta.

## Renomeacoes
| Arquivo | Antes | Depois |
|---|---|---|
| `src/code_banks/bank_85.asm` | `CODE_8580CC` | `GameOBJ_Bank85_Branch_8580CC` |
| `src/code_banks/bank_85.asm` | `CODE_8580D4` | `GameOBJ_Bank85_Branch_8580D4` |
| `src/code_banks/bank_85.asm` | `CODE_8580FF` | `GameOBJ_Bank85_Branch_8580FF` |
| `src/code_banks/bank_85.asm` | `CODE_858115` | `GameOBJ_Bank85_Branch_858115` |
| `src/code_banks/bank_85.asm` | `CODE_85811D` | `GameOBJ_Bank85_Branch_85811D` |
| `src/code_banks/bank_85.asm` | `CODE_858168` | `GameOBJ_Bank85_Branch_858168` |
| `src/code_banks/bank_85.asm` | `CODE_858177` | `GameOBJ_Bank85_Branch_858177` |
| `src/code_banks/bank_85.asm` | `CODE_8581B8` | `GameOBJ_Bank85_Branch_8581B8` |
| `src/code_banks/bank_85.asm` | `CODE_8581F6` | `GameOBJ_Bank85_Branch_8581F6` |
| `src/code_banks/bank_85.asm` | `CODE_858206` | `GameOBJ_Bank85_Branch_858206` |
| `src/code_banks/bank_85.asm` | `CODE_858209` | `GameOBJ_Bank85_Branch_858209` |
| `src/code_banks/bank_85.asm` | `CODE_8582CD` | `GameOBJ_Bank85_Branch_8582CD` |
| `src/code_banks/bank_85.asm` | `CODE_8582D4` | `GameOBJ_Bank85_Branch_8582D4` |
| `src/code_banks/bank_85.asm` | `CODE_8582E7` | `GameOBJ_Bank85_Branch_8582E7` |
| `src/code_banks/bank_85.asm` | `CODE_8582FB` | `GameOBJ_Bank85_Branch_8582FB` |
| `src/code_banks/bank_85.asm` | `CODE_858303` | `GameOBJ_Bank85_Branch_858303` |
| `src/code_banks/bank_85.asm` | `CODE_85831F` | `GameOBJ_Bank85_Branch_85831F` |
| `src/code_banks/bank_85.asm` | `CODE_85832A` | `GameOBJ_Bank85_Branch_85832A` |
| `src/code_banks/bank_85.asm` | `CODE_858349` | `GameOBJ_Bank85_Branch_858349` |
| `src/code_banks/bank_85.asm` | `CODE_858362` | `GameOBJ_Bank85_Branch_858362` |
| `src/code_banks/bank_85.asm` | `CODE_858371` | `GameOBJ_Bank85_Branch_858371` |
| `src/code_banks/bank_85.asm` | `CODE_858376` | `GameOBJ_Bank85_Branch_858376` |
| `src/code_banks/bank_85.asm` | `CODE_858CF3` | `GameOBJ_Bank85_Branch_858CF3` |
| `src/code_banks/bank_85.asm` | `CODE_858D12` | `GameOBJ_Bank85_Branch_858D12` |
| `src/code_banks/bank_85.asm` | `CODE_858D2F` | `GameOBJ_Bank85_Branch_858D2F` |
| `src/code_banks/bank_85.asm` | `CODE_858D38` | `GameOBJ_Bank85_Branch_858D38` |
| `src/code_banks/bank_85.asm` | `CODE_858D65` | `GameOBJ_Bank85_Branch_858D65` |
| `src/code_banks/bank_85.asm` | `CODE_858E37` | `GameOBJ_Bank85_Branch_858E37` |
| `src/code_banks/bank_85.asm` | `CODE_858E3C` | `GameOBJ_Bank85_Branch_858E3C` |
| `src/code_banks/bank_82_toolanimation_subrutines.asm` | `CODE_8291C8` | `ToolAnimation_Branch_8291C8` |
| `src/code_banks/bank_82_toolanimation_subrutines.asm` | `CODE_8291D5` | `ToolAnimation_Branch_8291D5` |
| `src/code_banks/bank_82_toolanimation_subrutines.asm` | `CODE_8291E7` | `ToolAnimation_Branch_8291E7` |
