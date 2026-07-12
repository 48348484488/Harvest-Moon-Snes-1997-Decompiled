# Metas de continuidade apos Pass 47

Pass 47 fechou a tela de entrada de nome / character-entry UI: layout visual, input, paginas de caracteres, tabela de grade e commit para player/animais/filhos.

| Ordem | Meta | Criterio de 100% |
|---:|---|---|
| 48 | Remaining Event Command Unknowns | Renomear/documentar comandos `EventCmd_*Unknown*` com evidencia por parametros, callsites e scripts. |
| 49 | Text/Dialog Content Classification | Classificar dialogos restantes por NPC, loja, evento, tutorial e sistema. |
| 50 | Final Unknown Labels Audit | Revisar `TODO`, `UNK_`, `DATA8_`, `DATA16_`, `CODE_` e `SUB_` restantes e separar o que e real decomp vs dado anonimo. |
| 51 | Final Decomp Cleanup | Consolidar docs, progresso e pacote final sem ROM comercial. |

Regra para cada meta: fechar evidencia, documentar limites, rodar auditoria e confirmar rebuild byte-perfect.
