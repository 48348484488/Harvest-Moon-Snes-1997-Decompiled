# DECOMP PASS 83 - EventScript Visual/GOBJ Semantic Xref

Objetivo: continuar a camada humana depois da Pass 82, classificando referencias visuais/GOBJ/objeto nas entradas EventScript.

## Fechado nesta pass

| Area | Resultado |
|---|---:|
| Entradas EventScript totais verificadas | 1288/1288 = 100.000% |
| Entradas com referencia visual/objeto classificadas | 176/176 = 100.000% |
| Referencias visual/objeto unicas classificadas | 263/263 = 100.000% |
| Tokens candidatos a ponteiro visual/GOBJ/asset | 204 tokens / 101 unicos |
| EventCmd oficiais | 90/90 = 100.000% mantido |
| Residuos reais EventScript | 0/0 = 100.000% mantido |
| Rebuild byte-perfect | 100.000% mantido |
| Pacote NO-ROM | 100.000% mantido |

## Arquivos principais

- `tools/event_script_visual_gobj_xref_pass83.py`
- `reports/pass83_eventscript_visual_gobj_entry_xref.csv`
- `reports/pass83_eventscript_visual_pointer_classification.csv`
- `reports/pass83_eventscript_visual_domain_summary.csv`
- `reports/pass83_eventscript_visual_group_summary.csv`
- `reports/pass83_eventscript_visual_gobj_semantic_xref.md`
- `docs/event_script_system/EventScript_VisualGOBJXref_PASS83.md`
- `docs/pseudocode/EventScript_VisualGOBJXrefTool_PASS83.md`
- `docs/event_script_system/STATUS_PASS83.md`
- `docs/handoff/METAS_DECOMP_PASS83.md`

## Nota de precisao

Esta pass fecha a classificacao visual/GOBJ em nivel de entrada EventScript. Ela nao afirma que todos os ponteiros ja tem nome final de sprite/personagem; ela separa ponteiro candidato, parametro imediato, runtime/WRAM e alvo B3-B5 para permitir nomeacao segura nas proximas passes.
