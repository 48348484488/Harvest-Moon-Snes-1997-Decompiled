# How To Edit Text Safely

## Edicao mais segura

O jeito mais seguro e alterar um texto mantendo o mesmo bloco e o mesmo tamanho maximo.

Exemplo:

```asm
Text_Forecast_Spring_Sunny:
        dw $0021,$0004,$000B,$000B,$000E,...,$FFFF
```

Regras:

- mantenha `$FFFF` no fim;
- nao invada o proximo label;
- mantenha a quantidade de bytes igual ou menor quando nao for atualizar ponteiros;
- use `$00B1` para espaco/padding;
- use `$00A2` quando precisar de quebra visual;
- recompile sempre depois.

## Gerar preview de `dw`

Para texto simples sem acentos:

```bash
python tools/make_text_patch_preview.py --label Text_Test --text "Ola mundo."
```

Saida esperada:

```asm
Text_Test:
                       dw $0028,$000B,$0000,$00B1,$000C,$0014,$000D,$0003
                       dw $000E,$0036,$FFFF
```

## Texto com acentos

O codec ja conhece varios acentos da ROM BR, mas o gerador de patch ainda e conservador. Para edicoes com acentos, o melhor caminho atual e usar a tabela em:

```text
docs/text_system/Text_Codec_Table.md
```

Exemplo manual:

```text
á = $0043
é = $0044
ã = $004D
ç = $0057
```

## Encontrar um texto

Use:

```text
reports/decomp_pass02/text/text_entries_usa_source.csv
```

ou:

```text
reports/decomp_pass02/text/text_compare_usa_source_vs_br_rom.csv
```

Campos importantes:

```text
bank
label
snes_addr
pc_offset
usa_text
br_text
```

## Descobrir onde o texto e referenciado

Use:

```text
reports/decomp_pass02/text/text_label_xrefs.md
```

A maioria dos textos esta referenciada em:

```text
src/code_banks/bank_83.asm
Text_Pointer_Table
```

## Quando o texto novo for maior

Se o texto novo nao couber no espaco original, existem duas opcoes:

1. encurtar/reformatar;
2. mover o texto para uma area livre e atualizar o `dl` na `Text_Pointer_Table`.

A segunda opcao exige cuidado porque muda ponteiros e pode afetar checksum/organizacao dos bancos.
