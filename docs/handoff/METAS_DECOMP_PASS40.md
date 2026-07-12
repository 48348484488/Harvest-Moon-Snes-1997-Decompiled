# Metas de continuidade apos Pass 40

Pass 40 fechou o handoff `$7F1F5C & $0004 -> $95 = $09 -> IntroScreen_democheck`. A proxima etapa deve pegar o layout visual do menu/status sem misturar com outros sistemas.

| Ordem | Meta | Criterio de 100% |
|---:|---|---|
| 41 | Field HUD / Status Display Layout | Identificar tilemaps, paletas, DMA e estagios que desenham menu/status depois de `$95 = $09`. |
| 42 | Naming Screen / Character Entry UI Core | Fechar layout visual e tabelas da tela de nome, alem do input ja mapeado. |
| 43 | Remaining Event Command Unknowns | Renomear/documentar comandos `EventCmd_*_Unknown*` com evidencia por parametros e scripts. |
| 44 | Bank 80 Pointer Subroutines Audit | Reduzir `UNK_` em `bank_80_pointersubrutines.asm` por familias de dispatcher/tabela. |
| 45 | Text/Dialog Content Classification | Classificar dialogos restantes por NPC, loja, evento, tutorial e sistema. |
| 46 | Map Object / Interior Catalog | Catalogar objetos interativos por mapa/interior e ligar ao evento/handler correspondente. |
| 47 | Sprite Replacement Workflow | Documentar troca segura de sprites existentes com build byte-perfect ou patch separado. |
| 48 | Final Unknown Labels Audit | Revisar `TODO`, `UNK_`, `DATA8_`, `DATA16_`, `CODE_` e `SUB_` restantes. |
| 49 | Final Decomp Cleanup | Consolidar docs, progresso e pacote final sem ROM comercial. |

Regra para cada meta:

1. Fazer precheck de build quando o escopo tocar codigo amplo.
2. Renomear apenas labels com evidencia forte.
3. Documentar limites do escopo.
4. Rodar `tools/decomp_audit.py`.
5. Rodar build e comparar com a ROM USA limpa.
6. Atualizar `PROGRESSO_DECOMP.md` e criar `STATUS_PASSxx.md`.
