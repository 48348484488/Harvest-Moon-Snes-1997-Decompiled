# Text Label Naming - Pass 03

A Pass 03 renomeou labels genericos de texto usando um padrao estavel:

```text
Text_<INDICE_HEX>_<CATEGORIA>_<RESUMO>
```

Exemplo:

```text
DATA16_B688A4 -> Text_00B_Diary_WorkHardAgainTomorrow
```

## Por que incluir o indice?

O indice vem da `Text_Pointer_Table`. Isso e importante porque o jogo normalmente escolhe um texto pelo indice, nao pelo endereco bruto.

Exemplo:

```asm
Text_Pointer_Table: ;839BF6
    dl Text_00B_Diary_WorkHardAgainTomorrow ;B688A4;0B----
```

O prefixo `00B` permite saber rapidamente que esse texto e a entrada `$0B` da tabela.

## Por que incluir categoria?

A categoria e heuristica, nao definitiva. Ela ajuda a navegar rapidamente:

- `Weather`
- `Diary`
- `Manual`
- `Sign`
- `Animal`
- `Shipping`
- `Shop`
- `Festival`
- `Church`
- `Mountain`
- `Romance`
- `Town`
- `Dialog`

A categoria pode ser ajustada manualmente futuramente quando o contexto exato de NPC/evento for descoberto.

## Segurança da renomeacao

A renomeacao troca apenas simbolos/labels no ASM. Os bytes `dw` dos textos nao foram alterados.

Por isso o build continua gerando a ROM USA identica byte-a-byte.

## Arquivos de referencia

```text
reports/decomp_pass03/text/text_label_rename_map.csv
reports/decomp_pass03/text/text_pointer_catalog.csv
reports/decomp_pass03/text/text_catalog_viewer.html
patches/pass03_text_label_renames.diff
```
