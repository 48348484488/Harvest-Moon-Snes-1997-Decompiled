# DECOMP PASS 65 - Bank85 GameOBJ + ToolAnimation CODE Closure

Objetivo: fechar 100% dos labels genericos `CODE_` em dois clusters pequenos e seguros: o Bank 85, ligado ao core de GameOBJ/sprites/objetos, e `bank_82_toolanimation_subrutines.asm`, ligado a animacao de ferramentas.

## Resultado

| Medida | Antes | Depois | Status |
|---|---:|---:|---|
| `CODE_` genericos em `project_buildable/src/code_banks/bank_85.asm` | 29 | 0 | 100% fechado |
| `CODE_` genericos em `source_decompilada/src/code_banks/bank_85.asm` | 29 | 0 | 100% fechado |
| `CODE_` genericos em `bank_82_toolanimation_subrutines.asm` | 3 | 0 | 100% fechado |
| `CODE_` genericos totais em `project_buildable/src` | 1732 | 1700 | reducao de 32 |
| `DATA8_` genericos | 0 | 0 | mantido fechado |
| `DATA16_` genericos | 0 | 0 | mantido fechado |
| `SUB_` genericos | 0 | 0 | mantido fechado |
| `UNK_` genericos | 0 | 0 | mantido fechado |

## Renomeacao aplicada

Os labels locais/aliases `CODE_xxxxxx` foram convertidos para nomes mecanicos seguros por area:

```asm
CODE_8580CC -> GameOBJ_Bank85_Branch_8580CC
CODE_8580D4 -> GameOBJ_Bank85_Branch_8580D4
CODE_8291C8 -> ToolAnimation_Branch_8291C8
```

Essa pass nao altera bytes, nao muda fluxo e nao reponta dados. A mudanca e estrutural: remove marcadores genericos restantes de dois arquivos pequenos e melhora a leitura do core visual/objeto.

## Validacao

```text
MD5 original: c9bf36a816b6d54aed79d43a6c45111a
MD5 rebuild:  c9bf36a816b6d54aed79d43a6c45111a
Resultado: OK, rebuild identico byte-a-byte.
```

## Arquivos principais

- `src/code_banks/bank_85.asm`
- `src/code_banks/bank_82_toolanimation_subrutines.asm`
- `reports/pass65_bank85_toolanimation_code_cleanup.md`
- `reports/pass65_bank85_toolanimation_code_cleanup.csv`
- `docs/pseudocode/GameOBJ_Bank85_Branch_Cleanup_PASS65.md`
- `docs/event_script_system/STATUS_PASS65.md`
- `docs/handoff/METAS_DECOMP_PASS65.md`
