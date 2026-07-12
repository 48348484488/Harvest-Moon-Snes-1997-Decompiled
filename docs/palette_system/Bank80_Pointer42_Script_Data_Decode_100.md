# Bank 80 Pointer42 Script Data Decode 100% - Pass 46

Esta pass fecha o escopo **Bank 80 Pointer42 Script Data Decode**.

O Codex ja tinha documentado as familias de instaladores Pointer42 do bank 80, mas o bloco principal de dados ainda estava como um grande `db` bruto em `bank_80.asm`.
Nesta pass, esse bloco foi decompilado para scripts nomeados e comandos explicitos, mantendo o rebuild byte-perfect.

## Arquivos principais

```text
src/code_banks/bank_80.asm
src/code_banks/bank_80_pointersubrutines.asm
docs/palette_system/Bank80_Pointer42_Script_Data_Decode_100.md
docs/pseudocode/Bank80_Pointer42_Script_Data_Decode.md
```

## Resultado do decode

| Item | Resultado |
|---|---:|
| Bloco bruto anterior | `PaletteAnim_Bank80Pointer42ScriptData` |
| Faixa SNES | `$80:DD5B-$80:EF1B` |
| Scripts nomeados | 241 |
| Scripts com self-loop | 240 |
| Scripts com jump para outro script | 1 |
| Cores RGB555 unicas usadas | 359 |
| Rebuild | byte-perfect |

## Formato fechado

Cada script Pointer42 segue o mesmo formato do motor documentado nas passes anteriores:

```asm
PaletteAnimScript_DD5B:
        dw $7F79 : db $10 ; color RGB555, delay
        dw $3A11 : db $10 ; color RGB555, delay
        dw $FFFE : dl PaletteAnimScript_DD5B ; loop/jump
```

Interpretacao:

| Campo | Tamanho | Uso |
|---|---:|---|
| `dw color` | 2 bytes | cor RGB555 gravada no slot Pointer42 |
| `db delay` | 1 byte | atraso ate o proximo step |
| `dw $FFFE` | 2 bytes | comando de jump/loop |
| `dl target` | 3 bytes | ponteiro 24-bit para o proximo script |
| `dw $FFFF` | 2 bytes | fim de script, nao apareceu como final normal neste bloco |

## O que mudou na source

Antes o bloco estava assim:

```asm
PaletteAnim_Bank80Pointer42ScriptData: db $79,$7F,$10,$11,...
```

Agora ele esta assim:

```asm
PaletteAnim_Bank80Pointer42ScriptData:
PaletteAnimScript_DD5B:
        dw $7F79 : db $10
        ...
        dw $FFFE : dl PaletteAnimScript_DD5B
```

Isso melhora muito a leitura da source sem mudar nenhum byte do ROM recompilado.

## Observacao sobre Pass 45 recebida

O pacote enviado pelo usuario continha progresso documentado ate Pass 45 em `PROGRESSO_DECOMP.md` e metas de continuidade em `docs/handoff/METAS_DECOMP_PASS45.md`.
Tambem havia ROM original e ROM rebuild dentro do pacote recebido, ambas com MD5 correto. Essas ROMs foram usadas apenas para validacao local e foram removidas do pacote final entregue nesta pass.

## Limites desta pass

Fechado em 100%:

- separar o bloco bruto em scripts nomeados;
- decodificar comandos `dw color : db delay`;
- substituir jumps 24-bit por labels `dl PaletteAnimScript_XXXX`;
- catalogar todos os scripts usados por instaladores do bank 80;
- manter rebuild byte-perfect.

Nao incluido aqui:

- dar nome artistico individual para cada cor RGB555;
- dizer qual pixel/elemento visual exato cada cor afeta em cada mapa;
- criar editor visual de paleta.

Esses pontos podem virar metas futuras.
