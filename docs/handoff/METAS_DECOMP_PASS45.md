# Metas de continuidade apos Pass 45

Pass 45 fechou a auditoria das familias Pointer42 do bank 80: dispatcher, tabela por tilemap/hora, gate sazonal, 51 instaladores e bloco bruto de scripts.

| Ordem | Meta | Criterio de 100% |
|---:|---|---|
| 46 | Bank 80 Pointer42 Script Data Decode | Quebrar `PaletteAnim_Bank80Pointer42ScriptData` em scripts nomeados quando houver ganho real, mantendo build byte-perfect. |
| 47 | Naming Screen / Character Entry UI Core | Fechar layout visual e tabelas da tela de nome, alem do input ja mapeado. |
| 48 | Remaining Event Command Unknowns | Renomear/documentar comandos `EventCmd_*_Unknown*` com evidencia por parametros e scripts. |
| 49 | Text/Dialog Content Classification | Classificar dialogos restantes por NPC, loja, evento, tutorial e sistema. |
| 50 | Final Unknown Labels Audit | Revisar `TODO`, `UNK_`, `DATA8_`, `DATA16_`, `CODE_` e `SUB_` restantes. |
| 51 | Final Decomp Cleanup | Consolidar docs, progresso e pacote final sem ROM comercial. |

Regra para cada meta: fechar evidencia, documentar limites, rodar auditoria e confirmar rebuild byte-perfect.
