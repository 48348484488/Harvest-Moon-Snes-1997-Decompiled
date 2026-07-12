# Text System Map

## Regiao principal

Os textos principais ficam em:

```text
src/data_banks/bank_B6.asm
src/data_banks/bank_B7.asm
src/data_banks/bank_B8.asm
src/data_banks/bank_B9.asm
src/data_banks/bank_BA.asm
src/data_banks/bank_BB.asm
```

Cada texto geralmente e um bloco `dw` terminado por `$FFFF`.

Exemplo:

```asm
Text_Forecast_Spring_Sunny:
        dw $0021,$0004,$000B,$000B,$000E,$003A,$00B1,$0013
        ...
        dw $FFFF
```

## Tabela principal de ponteiros

A tabela principal que lista os textos fica em:

```text
src/code_banks/bank_83.asm
```

Inicio:

```asm
Text_Pointer_Table: ;839BF6
```

Ela usa ponteiros longos `dl`.

Exemplo:

```asm
        dl Text_Forecast_Spring_Sunny        ;B68000;00
        dl Text_Forecast_Summer_Sunny        ;B680D8;01
        dl Text_Forecast_Fall_Sunny          ;B6816C;02
```

A anotacao final parece indicar o endereco do texto e o indice da entrada.

## Como ler um endereco LoROM

Exemplo: `$B68000`.

Para ROM LoROM sem header copier:

```text
PC offset = ((bank & $7F) * $8000) + (address & $7FFF)
$B68000  -> 0x1B0000
```

Isso foi usado para comparar o source USA com a ROM BR.

## Quantidade de entradas por banco

| Banco | Entradas extraidas |
|---|---:|
| B6 | 210 |
| B7 | 208 |
| B8 | 233 |
| B9 | 204 |
| BA | 232 |
| BB | 90 |
| **Total** | **1177** |

## Referencias encontradas

O relatorio `text_label_xrefs.md` encontrou referencia para **1176 de 1177 labels**. Na pratica, quase todos os labels estao ligados diretamente por `Text_Pointer_Table` em `bank_83.asm`.

Arquivo:

```text
reports/decomp_pass02/text/text_label_xrefs.md
```

## Implicacao pratica

Para editar um texto pequeno e manter o jogo estavel:

1. localize o label em `text_entries_usa_source.csv`;
2. altere o bloco `dw` correspondente no banco `B6-BB`;
3. mantenha o texto dentro do espaco original ou atualize ponteiros;
4. preserve o terminador `$FFFF`;
5. recompile e compare/teste.

Para textos maiores que o espaco original, sera necessario realocar o texto e atualizar a entrada `dl` na `Text_Pointer_Table`.
