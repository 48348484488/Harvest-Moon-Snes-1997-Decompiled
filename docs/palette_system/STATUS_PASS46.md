# Status Pass 46 - Bank 80 Pointer42 Script Data Decode Core

Escopo fechado: **Bank 80 Pointer42 Script Data Decode 100%**.

## Incluido

- Decode do bloco `$80:DD5B-$80:EF1B`.
- 241 scripts Pointer42 nomeados como `PaletteAnimScript_XXXX`.
- Comandos transformados em `dw color : db delay`.
- Jumps `$FFFE` transformados em `dl PaletteAnimScript_XXXX` quando o alvo e conhecido.
- Catalogo CSV/JSON/Markdown em `project_buildable/reports/decomp_pass46/pointer42/`.
- Rebuild byte-perfect confirmado.

## Nao incluido

- Nome artistico individual das cores.
- Editor visual de paleta.
- Mapeamento visual pixel-a-pixel de cada slot Pointer42.

## Validacao

```text
MD5 ROM USA original: c9bf36a816b6d54aed79d43a6c45111a
MD5 rebuild Pass 46:  c9bf36a816b6d54aed79d43a6c45111a
Resultado: OK, identica byte-a-byte
```
