# Metas de continuidade apos Pass 42

Pass 42 fechou o stage `$95 = $04` como instalador inicial dos ponteiros de layout. A proxima etapa deve seguir o fluxo para `$95 = $05`.

| Ordem | Meta | Criterio de 100% |
|---:|---|---|
| 43 | Field Status Menu Stage `$95 = $05` Runtime Pointer Refresh Core | Mapear `$97`, incremento de `$90`, variantes por `$098D` e atualizacao dinamica dos slots Pointer42. |
| 44 | Decode `$82F2A4/$82F2B5/$82F2C9/$82F2DA` Pointer Scripts | Interpretar comandos/dados apontados pelos slots do menu/status. |
| 45 | Naming Screen / Character Entry UI Core | Fechar layout visual e tabelas da tela de nome, alem do input ja mapeado. |
| 46 | Remaining Event Command Unknowns | Renomear/documentar comandos `EventCmd_*_Unknown*` com evidencia por parametros e scripts. |
| 47 | Bank 80 Pointer Subroutines Audit | Reduzir `UNK_` em `bank_80_pointersubrutines.asm` por familias de dispatcher/tabela. |
| 48 | Text/Dialog Content Classification | Classificar dialogos restantes por NPC, loja, evento, tutorial e sistema. |
| 49 | Final Unknown Labels Audit | Revisar `TODO`, `UNK_`, `DATA8_`, `DATA16_`, `CODE_` e `SUB_` restantes. |
| 50 | Final Decomp Cleanup | Consolidar docs, progresso e pacote final sem ROM comercial. |

Regra para cada meta: fechar evidencia, documentar limites, rodar auditoria e confirmar rebuild byte-perfect.
