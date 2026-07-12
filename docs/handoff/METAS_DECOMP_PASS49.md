# Metas de continuidade apos Pass 48

Pass 48 fechou os comandos de evento restantes que ainda tinham nome `Unknown` no interpretador principal.

| Ordem | Meta | Criterio de 100% |
|---:|---|---|
| 49 | Text/Dialog Content Classification | Classificar dialogos restantes por NPC, loja, evento, tutorial e sistema. |
| 50 | Final Unknown Labels Audit | Revisar `TODO`, `UNK_`, `DATA8_`, `DATA16_`, `CODE_` e `SUB_` restantes e separar o que e real decomp vs dado anonimo. |
| 51 | Final Decomp Cleanup | Consolidar docs, progresso e pacote final sem ROM comercial. |

Regra para cada meta: fechar evidencia, documentar limites, rodar auditoria e confirmar rebuild byte-perfect.
