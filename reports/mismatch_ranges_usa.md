# Faixas de diferenca ASM vs ROM

Gerado em: 2026-07-04T08:21:52

Max gap para juntar faixas: `0x40` bytes.

Total de faixas: `8`

| Banco | Inicio | Fim | Tamanho aprox. | Linhas com diff | Arquivos |
|---:|---:|---:|---:|---:|---|
| `82` | `828209` | `82821C` | 20 | 5 | `src/code_banks/bank_82.asm` |
| `82` | `828C09` | `828C14` | 12 | 1 | `src/code_banks/bank_82.asm` |
| `82` | `828EC6` | `828ED5` | 16 | 1 | `src/code_banks/bank_82.asm` |
| `82` | `8290A8` | `8290B7` | 16 | 1 | `src/code_banks/bank_82.asm` |
| `82` | `82931E` | `829337` | 26 | 2 | `src/code_banks/bank_82.asm` |
| `82` | `82B173` | `82B265` | 243 | 9 | `src/code_banks/bank_82.asm` |
| `84` | `848000` | `848105` | 262 | 19 | `src/code_banks/bank_84.asm` |
| `85` | `858647` | `8586A6` | 96 | 6 | `src/code_banks/bank_85.asm` |

Essas faixas ajudam a localizar onde a ROM analisada diverge das diretivas literais do source. Observacao: esta comparacao nao substitui montagem com Asar, pois ela nao calcula o tamanho das instrucoes Assembly.
