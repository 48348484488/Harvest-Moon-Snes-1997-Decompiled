# Metas de continuidade apos Pass 43

Pass 43 fechou o refresh runtime dos ponteiros do menu/status. O proximo alvo deve sair do controle de fluxo e entrar na interpretacao dos dados apontados.

| Ordem | Meta | Criterio de 100% |
|---:|---|---|
| 44 | Decode `$82F2A4/$82F2B5/$82F2C9/$82F2DA` Pointer Scripts | Interpretar comandos/dados apontados pelos slots Pointer42 e nomear os blocos com evidencia. |
| 45 | Naming Screen / Character Entry UI Core | Fechar layout visual e tabelas da tela de nome, alem do input ja mapeado. |
| 46 | Remaining Event Command Unknowns | Renomear/documentar comandos `EventCmd_*_Unknown*` com evidencia por parametros e scripts. |
| 47 | Bank 80 Pointer Subroutines Audit | Reduzir `UNK_` em `bank_80_pointersubrutines.asm` por familias de dispatcher/tabela. |
| 48 | Text/Dialog Content Classification | Classificar dialogos restantes por NPC, loja, evento, tutorial e sistema. |
| 49 | Final Unknown Labels Audit | Revisar `TODO`, `UNK_`, `DATA8_`, `DATA16_`, `CODE_` e `SUB_` restantes. |
| 50 | Final Decomp Cleanup | Consolidar docs, progresso e pacote final sem ROM comercial. |

Regra para cada meta: fechar evidencia, documentar limites, rodar auditoria e confirmar rebuild byte-perfect.
