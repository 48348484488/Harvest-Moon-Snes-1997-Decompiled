# DECOMP PASS 64 - Bank 84 EventScript CODE Branch Closure

Objetivo: fechar 100% dos labels genericos `CODE_` dentro do `bank_84.asm`, que concentra o nucleo de EventScript/EventCmd.

## Resultado

| Medida | Antes | Depois | Status |
|---|---:|---:|---|
| `CODE_` genericos em `project_buildable/src/code_banks/bank_84.asm` | 590 | 0 | 100% fechado |
| `CODE_` genericos em `source_decompilada/src/code_banks/bank_84.asm` | 590 | 0 | 100% fechado |
| `CODE_` genericos totais em `project_buildable/src` | 2322 | 1732 | reducao de 590 |
| `DATA8_` genericos | 0 | 0 | mantido fechado |
| `DATA16_` genericos | 0 | 0 | mantido fechado |
| `SUB_` genericos | 0 | 0 | mantido fechado |
| `UNK_` genericos | 0 | 0 | mantido fechado |

## Renomeacao aplicada

Os labels locais/aliases `CODE_xxxxxx` no Bank 84 foram convertidos para nomes mecanicos seguros:

```asm
CODE_84817D -> EventScriptBank84_Branch_84817D
CODE_848184 -> EventScriptBank84_Branch_848184
...
```

Essa pass e principalmente uma limpeza estrutural segura. Ela nao altera bytes, nao reponta dados e nao muda logica. A nomenclatura ainda pode ser refinada semanticamente em passes futuras, mas o cluster generico `CODE_` do Bank 84 ficou 100% zerado.

## Validacao

```text
MD5 original: c9bf36a816b6d54aed79d43a6c45111a
MD5 rebuild:  c9bf36a816b6d54aed79d43a6c45111a
Resultado: OK, rebuild identico byte-a-byte.
```

## Arquivos principais

- `src/code_banks/bank_84.asm`
- `reports/pass64_bank84_code_branch_cleanup.md`
- `reports/pass64_bank84_code_branch_cleanup.csv`
- `docs/event_script_system/STATUS_PASS64.md`
- `docs/handoff/METAS_DECOMP_PASS64.md`
