# Metas de continuidade apos Pass 44

Pass 44 fechou o core Pointer42 de animacao de paleta e os scripts usados pelo menu/status.

| Ordem | Meta | Criterio de 100% |
|---:|---|---|
| 45 | Bank 80 Pointer42 Script Families Audit | Classificar grupos de scripts em `bank_80_pointersubrutines.asm`, agora que `PaletteAnim_SetPointer42Slot` e o formato estao conhecidos. |
| 46 | Naming Screen / Character Entry UI Core | Fechar layout visual e tabelas da tela de nome, alem do input ja mapeado. |
| 47 | Remaining Event Command Unknowns | Renomear/documentar comandos `EventCmd_*_Unknown*` com evidencia por parametros e scripts. |
| 48 | Text/Dialog Content Classification | Classificar dialogos restantes por NPC, loja, evento, tutorial e sistema. |
| 49 | Final Unknown Labels Audit | Revisar `TODO`, `UNK_`, `DATA8_`, `DATA16_`, `CODE_` e `SUB_` restantes. |
| 50 | Final Decomp Cleanup | Consolidar docs, progresso e pacote final sem ROM comercial. |

Regra para cada meta: fechar evidencia, documentar limites, rodar auditoria e confirmar rebuild byte-perfect.
