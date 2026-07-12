# DECOMP PASS 60 - Source Mirror Sync + HeldItem DATA8 Label Closure

Escopo fechado nesta pass:

1. **Source mirror sync 100%**: a arvore `source_decompilada/src` foi sincronizada com `project_buildable/src`.
2. **HeldItem tool-use dialog/stamina table label**: o label generico `DATA8_819FC6` foi substituido por `HeldItem_ToolUseDialogAndStaminaDeltaTable`.
3. **Rebuild byte-perfect mantido**: a ROM reconstruida continua identica byte-a-byte a ROM USA limpa.

## Renomeacao segura

| Antes | Depois | Banco | Uso inferido |
|---|---|---|---|
| `DATA8_819FC6` | `HeldItem_ToolUseDialogAndStaminaDeltaTable` | `bank_81.asm` | tabela de registros de 3 bytes usada pela logica de ferramenta/objeto na mao: word de texto/dialogo + byte de delta de stamina |

## Validacao

```text
MD5 original: c9bf36a816b6d54aed79d43a6c45111a
MD5 rebuild:  c9bf36a816b6d54aed79d43a6c45111a
Resultado: OK, rebuild identico byte-a-byte.
```

## Contagem apos Pass 60 em `project_buildable/src`

| Metrica | Valor |
|---|---:|
| Labels `SUB_` unicos | 0 |
| Labels `DATA16_` unicos | 0 |
| Labels `DATA8_` unicos | 207 |
| Labels `CODE_` unicos | 2325 |
| Ocorrencias `UNK_` | 0 |
| Ocorrencias `TODO` | 89 |

## Observacao

Esta pass nao tenta renomear milhares de `CODE_` de forma automatica, porque isso aumentaria risco de nomes errados. O foco foi fechar um ponto seguro e garantir que a copia limpa (`source_decompilada`) nao fique atras da copia buildavel.
