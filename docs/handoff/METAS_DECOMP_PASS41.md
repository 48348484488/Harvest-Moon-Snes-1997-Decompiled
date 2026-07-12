# Metas de continuidade apos Pass 41

Pass 41 fechou o bootstrap visual do menu/status. O proximo alvo natural e o estagio `$95 = $04`, que roda apos o fade-in e comeca a montar ponteiros/tabelas.

| Ordem | Meta | Criterio de 100% |
|---:|---|---|
| 42 | Field Status Menu Stage `$95 = $04` Pointer/Layout Core | Identificar ponteiros `$82F2A4/$82F2B5/$82F2C9/$82F2DA`, destino dos slots 42 e ramificacao por `$098D`. |
| 43 | Naming Screen / Character Entry UI Core | Fechar layout visual e tabelas da tela de nome, alem do input ja mapeado. |
| 44 | Remaining Event Command Unknowns | Renomear/documentar comandos `EventCmd_*_Unknown*` com evidencia por parametros e scripts. |
| 45 | Bank 80 Pointer Subroutines Audit | Reduzir `UNK_` em `bank_80_pointersubrutines.asm` por familias de dispatcher/tabela. |
| 46 | Text/Dialog Content Classification | Classificar dialogos restantes por NPC, loja, evento, tutorial e sistema. |
| 47 | Map Object / Interior Catalog | Catalogar objetos interativos por mapa/interior e ligar ao evento/handler correspondente. |
| 48 | Sprite Replacement Workflow | Documentar troca segura de sprites existentes com build byte-perfect ou patch separado. |
| 49 | Final Unknown Labels Audit | Revisar `TODO`, `UNK_`, `DATA8_`, `DATA16_`, `CODE_` e `SUB_` restantes. |
| 50 | Final Decomp Cleanup | Consolidar docs, progresso e pacote final sem ROM comercial. |

Regra para cada meta: fechar evidencia, documentar limites, rodar auditoria e confirmar rebuild byte-perfect.
