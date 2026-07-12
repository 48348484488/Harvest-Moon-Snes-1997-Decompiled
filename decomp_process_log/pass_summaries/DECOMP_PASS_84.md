# DECOMP PASS 84 - EventScript Visual Pointer/GOBJ Resolution

Objetivo: continuar a camada humana depois da Pass 83, cruzando referencias visuais/GOBJ dos EventScripts com catalogo GOBJ/sprite, aliases de EventScript e indice de endereco do source.

## Fechado nesta pass

| Area | Resultado |
|---|---:|
| Entradas EventScript visuais verificadas | 176/176 = 100.000% |
| Referencias visual/objeto classificadas | 263/263 = 100.000% |
| Referencias com GOBJ ID exato | 69 |
| Referencias com anim sequence low-word exato | 10 |
| Referencias runtime/WRAM | 1 |
| Referencias high-confidence por catalogo/runtime | 80/263 = 30.418% |
| Familias visuais por entrada | 176/176 = 100.000% |
| EventCmd oficiais | 90/90 = 100.000% mantido |
| Residuos reais EventScript | 0/0 = 100.000% mantido |
| Rebuild byte-perfect | 100.000% mantido |
| Pacote NO-ROM | 100.000% mantido |

## Distribuicao das referencias visuais

| Classe | Referencias unicas | Percentual |
|---|---:|---:|
| source_address_line_match | 139 | 52.852% |
| exact_gobj_id | 69 | 26.236% |
| unresolved_asset_table_or_immediate | 24 | 9.125% |
| visual_param_or_non_gobj_id | 20 | 7.605% |
| exact_gobj_animation_sequence_lowword | 10 | 3.802% |
| runtime_cc_state_or_wram_pointer | 1 | 0.380% |

## Familias visuais por entrada

| Familia | Entradas | Percentual |
|---|---:|---:|
| general_livestock | 92 | 52.273% |
| cow_livestock | 55 | 31.250% |
| dog_pet | 12 | 6.818% |
| npc_family_or_romance | 12 | 6.818% |
| chicken_poultry | 5 | 2.841% |

## Arquivos principais

- `tools/event_script_visual_pointer_resolution_pass84.py`
- `reports/pass84_visual_pointer_resolution.csv`
- `reports/pass84_eventscript_visual_entry_resolved_xref.csv`
- `reports/pass84_visual_pointer_resolution_summary.csv`
- `reports/pass84_visual_family_domain_summary.csv`
- `reports/pass84_visual_group_resolution_summary.csv`
- `reports/pass84_eventscript_visual_pointer_resolution.md`
- `docs/event_script_system/EventScript_VisualPointerResolution_PASS84.md`
- `docs/pseudocode/EventScript_VisualPointerResolutionTool_PASS84.md`
- `docs/event_script_system/STATUS_PASS84.md`
- `docs/handoff/METAS_DECOMP_PASS84.md`

## Nota de precisao

Esta pass nao renomeia bytes nem afirma que todo sprite ja tem nome final de personagem. Ela fecha a camada de resolucao cruzada: quais refs batem com GOBJ ID, quais batem com sequencia de animacao, quais sao parametros/tabelas e quais ainda exigem decode manual de tabela visual.
