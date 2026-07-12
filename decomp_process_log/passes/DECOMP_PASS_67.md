# Pass 67 - Bank 82 CODE Branch Cleanup

Data: 2026-07-05

## Objetivo

Fechar 100% dos labels `CODE_` genericos restantes em `bank_82.asm` sem alterar bytes.

## Resultado

| Item | Antes | Depois |
|---|---:|---:|
| `CODE_` unicos em `project_buildable/src/code_banks/bank_82.asm` | 158 | 0 |
| `CODE_` unicos em `source_decompilada/src/code_banks/bank_82.asm` | 158 | 0 |

## Padrao de nomeacao

`CODE_82xxxx` foi convertido para `Bank82_MainLogicBranch_82xxxx`.

Essa pass ainda e conservadora: os labels deixam de ser genericos e passam a indicar banco/cluster funcional, mas nao tenta inventar semantica falsa para cada branch individual.

## Arquivos principais alterados

- `project_buildable/src/code_banks/bank_82.asm`
- `source_decompilada/src/code_banks/bank_82.asm`
- referencias cruzadas em `src/labels.asm`, quando existentes

## Validacao

Ver `VALIDACAO_BUILD_PASS67.md` e `logs/build_pass67.log`.
