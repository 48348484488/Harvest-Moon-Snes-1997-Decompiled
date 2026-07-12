# Pass 60 - Generic Mirror / DATA8 Cleanup Report

## Fechamentos concretos

| Area | Antes | Depois | Status |
|---|---:|---:|---|
| `source_decompilada/src` sincronizado com `project_buildable/src` | divergente | identico | 100% fechado |
| `DATA8_819FC6` generico | 1 | 0 | 100% fechado |
| Rebuild byte-perfect | 100% | 100% | mantido |

## Label novo

`HeldItem_ToolUseDialogAndStaminaDeltaTable`

A tabela contem registros compactos usados pela rotina de item/ferramenta na mao. Pelo uso no codigo:

- os dois primeiros bytes sao carregados como id de texto/dialogo e enviados para `TextBox_StartByTextId`;
- o terceiro byte e usado como delta de stamina enviado para `Stamina_ApplyDeltaAndFatigueState`.

## Contagens em `project_buildable/src` apos a pass

| Metrica | Valor |
|---|---:|
| `SUB_` unicos | 0 |
| `DATA16_` unicos | 0 |
| `DATA8_` unicos | 207 |
| `CODE_` unicos | 2325 |
| Ocorrencias `TODO` | 89 |

## Proxima prioridade sugerida

1. Reduzir `DATA8_` por tabelas claramente inferiveis em `bank_81.asm` e `bank_83.asm`.
2. Criar nomes reais para grupos `EventScriptGroup_XX` de maior confianca.
3. Atacar `unknown_opcode_cluster_needs_manual_decode` com comparacao por fluxo de RAM/flags.
