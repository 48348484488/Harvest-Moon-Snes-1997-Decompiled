# BR Text Diff Analysis

## Resumo

A ROM BR foi comparada contra as entradas de texto do source USA usando os mesmos enderecos LoROM.

Resultado:

```text
Entradas verificadas: 1177
Entradas alteradas:   1153
```

Isso mostra que a traducao BR mexe quase completamente nos bancos `B6-BB`, mas a estrutura geral continua reconhecivel.

## Bancos mais afetados

| Banco | Entradas | Alteradas | Alteradas % |
|---|---:|---:|---:|
| B6 | 210 | 207 | 98.6% |
| B7 | 208 | 208 | 100.0% |
| B8 | 233 | 226 | 97.0% |
| B9 | 204 | 200 | 98.0% |
| BA | 232 | 222 | 95.7% |
| BB | 90 | 90 | 100.0% |

## Arquivos de comparacao

```text
reports/decomp_pass02/text/text_compare_usa_source_vs_br_rom.md
reports/decomp_pass02/text/text_compare_usa_source_vs_br_rom.csv
reports/decomp_pass02/text/text_compare_usa_source_vs_br_rom.json
reports/decomp_pass02/text/changed_text_labels.txt
```

## Exemplo

USA/source em `$B68000`:

```text
Hello: this is the weather  forecast for tomorrow.      It'll be sunny and calm
for the whole day tomorrow.
```

BR ROM no mesmo endereco:

```text
Olá: esta é a previsão do   tempo para amanhã.          Será ensolarado e calmo
amanhã o dia inteiro.
```

## Interpretacao

A traducao BR provavelmente trabalhou dentro das areas existentes de texto, ajustando strings no proprio banco. Como quase todas as entradas continuam legiveis no mesmo endereco, e possivel usar o source USA como mapa para editar/extrair a traducao.

## Riscos

- Algumas strings BR podem ter sido comprimidas visualmente com hifenizacao para caber no mesmo espaco.
- Alguns codigos BR ainda nao foram mapeados.
- Alguns controles parecem representar escolhas, dinheiro, numeros, horario, nomes ou variaveis.
- Mudar tamanho de texto sem atualizar ponteiro pode corromper a proxima entrada.

## Melhor caminho para adaptar a BR ao source

1. Usar `text_compare_usa_source_vs_br_rom.csv` como mapa.
2. Escolher labels importantes.
3. Copiar os `dw` equivalentes da ROM BR ou reencodar texto com o codec.
4. Manter o tamanho igual ou menor que o bloco original.
5. Se precisar expandir, realocar texto e atualizar `Text_Pointer_Table`.
6. Recompilar com Asar.
7. Testar no emulador.
