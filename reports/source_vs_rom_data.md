# Source ASM vs ROM data check

Gerado em: 2026-07-04T08:21:42

Este relatorio compara apenas diretivas literais `db`, `dw` e `dl` contra o ROM. Ele nao substitui uma montagem com `asar`.

## Resumo

- ROM usado: `Harvest Moon (USA).sfc`
- MD5 do ROM analisado: `c9bf36a816b6d54aed79d43a6c45111a`
- Diretivas literais analisadas: `123042`
- Bytes de dados comparados: `1920853`
- Bytes que batem: `1920162`
- Bytes diferentes: `633`
- Compatibilidade dos dados literais: `99.9640%`
- Diretivas puladas por expressao/label: `1928`
- Bytes nao mapeados por ORG/LoROM: `3923`

## Por banco

| Banco | Bytes | Match | Diferentes | Linhas | Linhas com diff |
|---:|---:|---:|---:|---:|---:|
| `80` | 6669 | 6669 | 0 | 441 | 0 |
| `81` | 7910 | 7910 | 0 | 502 | 0 |
| `82` | 10598 | 10265 | 277 | 672 | 19 |
| `83` | 2548 | 2548 | 0 | 505 | 0 |
| `84` | 326 | 64 | 260 | 23 | 19 |
| `85` | 176 | 80 | 96 | 11 | 6 |
| `86` | 32768 | 32768 | 0 | 2048 | 0 |
| `87` | 32768 | 32768 | 0 | 2049 | 0 |
| `88` | 32768 | 32768 | 0 | 2048 | 0 |
| `89` | 32768 | 32768 | 0 | 2048 | 0 |
| `8A` | 32768 | 32768 | 0 | 2048 | 0 |
| `8B` | 32768 | 32768 | 0 | 2048 | 0 |
| `8C` | 32768 | 32768 | 0 | 2048 | 0 |
| `8D` | 32768 | 32768 | 0 | 2048 | 0 |
| `8E` | 32768 | 32768 | 0 | 2048 | 0 |
| `8F` | 32768 | 32768 | 0 | 2048 | 0 |
| `90` | 32768 | 32768 | 0 | 2048 | 0 |
| `91` | 32768 | 32768 | 0 | 2048 | 0 |
| `92` | 32768 | 32768 | 0 | 2048 | 0 |
| `93` | 32768 | 32768 | 0 | 2048 | 0 |
| `94` | 32768 | 32768 | 0 | 2048 | 0 |
| `95` | 32768 | 32768 | 0 | 2048 | 0 |
| `96` | 32768 | 32768 | 0 | 2048 | 0 |
| `97` | 32768 | 32768 | 0 | 2048 | 0 |
| `98` | 32768 | 32768 | 0 | 2048 | 0 |
| `99` | 32768 | 32768 | 0 | 2048 | 0 |
| `9A` | 32768 | 32768 | 0 | 2048 | 0 |
| `9B` | 32768 | 32768 | 0 | 2048 | 0 |
| `9C` | 32768 | 32768 | 0 | 2048 | 0 |
| `9D` | 32768 | 32768 | 0 | 2048 | 0 |
| `9E` | 32768 | 32768 | 0 | 2048 | 0 |
| `9F` | 30698 | 30698 | 0 | 1920 | 0 |
| `A0` | 32768 | 32768 | 0 | 2048 | 0 |
| `A1` | 32768 | 32768 | 0 | 2048 | 0 |
| `A2` | 32768 | 32768 | 0 | 2048 | 0 |
| `A3` | 32768 | 32768 | 0 | 2048 | 0 |
| `A4` | 32768 | 32768 | 0 | 2048 | 0 |
| `A5` | 32768 | 32768 | 0 | 2049 | 0 |
| `A6` | 32768 | 32768 | 0 | 2048 | 0 |
| `A7` | 32768 | 32768 | 0 | 2048 | 0 |
| `A8` | 32768 | 32768 | 0 | 2048 | 0 |
| `A9` | 27136 | 27136 | 0 | 1696 | 0 |
| `AA` | 32768 | 32768 | 0 | 2048 | 0 |
| `AB` | 32768 | 32768 | 0 | 2048 | 0 |
| `AC` | 32768 | 32768 | 0 | 2048 | 0 |
| `AD` | 32768 | 32768 | 0 | 2049 | 0 |
| `AE` | 32768 | 32768 | 0 | 2049 | 0 |
| `AF` | 32768 | 32768 | 0 | 2048 | 0 |
| `B0` | 32768 | 32768 | 0 | 2048 | 0 |
| `B1` | 32768 | 32768 | 0 | 2048 | 0 |
| `B2` | 32768 | 32768 | 0 | 2048 | 0 |
| `B3` | 32552 | 32552 | 0 | 2040 | 0 |
| `B4` | 32768 | 32768 | 0 | 2070 | 0 |
| `B5` | 32768 | 32768 | 0 | 2051 | 0 |
| `B6` | 32768 | 32768 | 0 | 2139 | 0 |
| `B7` | 32768 | 32768 | 0 | 2138 | 0 |
| `B8` | 32768 | 32768 | 0 | 2156 | 0 |
| `B9` | 32768 | 32768 | 0 | 2137 | 0 |
| `BA` | 32768 | 32768 | 0 | 2157 | 0 |
| `BB` | 32768 | 32768 | 0 | 2093 | 0 |
| `BC` | 32768 | 32768 | 0 | 2048 | 0 |
| `BD` | 32768 | 32768 | 0 | 2048 | 0 |
| `BE` | 32768 | 32768 | 0 | 2048 | 0 |
| `BF` | 32768 | 32768 | 0 | 2048 | 0 |

## Primeiras diferencas

| Arquivo | Linha | SNES | PC | src | rom | diff bytes na linha |
|---|---:|---:|---:|---:|---:|---:|
| `src/code_banks/bank_82.asm` | 344 | `828209` | `010209` | `60` | `C2` | 4 |
| `src/code_banks/bank_82.asm` | 345 | `82820D` | `01020D` | `40` | `01` | 3 |
| `src/code_banks/bank_82.asm` | 346 | `828211` | `010211` | `08` | `D0` | 4 |
| `src/code_banks/bank_82.asm` | 347 | `828215` | `010215` | `08` | `01` | 3 |
| `src/code_banks/bank_82.asm` | 348 | `828219` | `010219` | `00` | `D0` | 4 |
| `src/code_banks/bank_82.asm` | 1352 | `828C09` | `010C09` | `04` | `C2` | 11 |
| `src/code_banks/bank_82.asm` | 1786 | `828EC6` | `010EC6` | `00` | `C2` | 16 |
| `src/code_banks/bank_82.asm` | 1913 | `8290A8` | `0110A8` | `00` | `E2` | 16 |
| `src/code_banks/bank_82.asm` | 1921 | `82931E` | `01131E` | `01` | `C2` | 15 |
| `src/code_banks/bank_82.asm` | 1922 | `82932E` | `01132E` | `00` | `03` | 10 |
| `src/code_banks/bank_82.asm` | 3759 | `82B173` | `013173` | `00` | `60` | 27 |
| `src/code_banks/bank_82.asm` | 3760 | `82B18E` | `01318E` | `00` | `A7` | 27 |
| `src/code_banks/bank_82.asm` | 3761 | `82B1A9` | `0131A9` | `00` | `A7` | 27 |
| `src/code_banks/bank_82.asm` | 3762 | `82B1C4` | `0131C4` | `00` | `A7` | 27 |
| `src/code_banks/bank_82.asm` | 3763 | `82B1DF` | `0131DF` | `00` | `A7` | 27 |
| `src/code_banks/bank_82.asm` | 3764 | `82B1FA` | `0131FA` | `FF` | `A7` | 16 |
| `src/code_banks/bank_82.asm` | 3765 | `82B215` | `013215` | `00` | `A7` | 19 |
| `src/code_banks/bank_82.asm` | 3766 | `82B233` | `013233` | `00` | `FF` | 16 |
| `src/code_banks/bank_82.asm` | 3767 | `82B24B` | `01324B` | `FF` | `A7` | 5 |
| `src/code_banks/bank_84.asm` | 2817 | `848000` | `020000` | `BB` | `C2` | 16 |
| `src/code_banks/bank_84.asm` | 2818 | `848010` | `020010` | `E7` | `00` | 16 |
| `src/code_banks/bank_84.asm` | 2819 | `848020` | `020020` | `E2` | `C2` | 16 |
| `src/code_banks/bank_84.asm` | 2820 | `848030` | `020030` | `90` | `CC` | 16 |
| `src/code_banks/bank_84.asm` | 2821 | `848040` | `020040` | `9D` | `30` | 16 |
| `src/code_banks/bank_84.asm` | 2822 | `848050` | `020050` | `C9` | `94` | 16 |
| `src/code_banks/bank_84.asm` | 2823 | `848060` | `020060` | `57` | `A5` | 16 |
| `src/code_banks/bank_84.asm` | 2824 | `848070` | `020070` | `65` | `75` | 16 |
| `src/code_banks/bank_84.asm` | 2825 | `848080` | `020080` | `8F` | `97` | 16 |
| `src/code_banks/bank_84.asm` | 2826 | `848090` | `020090` | `89` | `CC` | 16 |
| `src/code_banks/bank_84.asm` | 2827 | `8480A0` | `0200A0` | `DA` | `86` | 16 |
| `src/code_banks/bank_84.asm` | 2828 | `8480B0` | `0200B0` | `BF` | `20` | 3 |
| `src/code_banks/bank_84.asm` | 2928 | `8480B4` | `0200B4` | `00` | `84` | 3 |
| `src/code_banks/bank_84.asm` | 2929 | `8480B7` | `0200B7` | `00` | `C2` | 3 |
| `src/code_banks/bank_84.asm` | 2932 | `8480BA` | `0200BA` | `01` | `7E` | 16 |
| `src/code_banks/bank_84.asm` | 2933 | `8480CA` | `0200CA` | `00` | `85` | 15 |
| `src/code_banks/bank_84.asm` | 2936 | `8480DA` | `0200DA` | `FE` | `CC` | 16 |
| `src/code_banks/bank_84.asm` | 2937 | `8480EA` | `0200EA` | `FF` | `88` | 16 |
| `src/code_banks/bank_84.asm` | 7240 | `8480FA` | `0200FA` | `00` | `48` | 12 |
| `src/code_banks/bank_85.asm` | 1375 | `858647` | `028647` | `01` | `C2` | 16 |
| `src/code_banks/bank_85.asm` | 1379 | `858657` | `028657` | `00` | `7E` | 16 |
| `src/code_banks/bank_85.asm` | 1380 | `858667` | `028667` | `20` | `7E` | 16 |
| `src/code_banks/bank_85.asm` | 1381 | `858677` | `028677` | `40` | `7E` | 16 |
| `src/code_banks/bank_85.asm` | 1382 | `858687` | `028687` | `60` | `7E` | 16 |
| `src/code_banks/bank_85.asm` | 1383 | `858697` | `028697` | `80` | `7E` | 16 |

CSV completo: `reports/source_vs_rom_data_mismatches.csv`

Interpretacao: se o ROM for uma traducao BR, muitas diferencas em bancos de texto/dados sao esperadas. Para validar a recompilacao original, use o ROM USA com o MD5 indicado no README.
