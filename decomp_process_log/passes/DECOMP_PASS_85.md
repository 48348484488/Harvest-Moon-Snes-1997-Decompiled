# DECOMP PASS 85 - EventScript GOBJ/Sprite Semantic Alias Layer

Objetivo: continuar a camada humana depois da Pass 84, transformando referencias visuais/GOBJ ja classificadas em aliases semanticos por entrada e por referencia, sem alterar bytes da ROM.

## Fechado nesta pass

| Area | Resultado |
|---|---:|
| Referencias visual/GOBJ com alias semantico | 263/263 = 100.000% |
| Entradas EventScript visuais com nome visual primario | 176/176 = 100.000% |
| Referencias high-confidence com nome final catalog/runtime | 80/263 = 30.418% |
| Referencias medium/contextuais preservadas sem falso nome final | 159/263 = 60.456% |
| Referencias low/manual isoladas | 24/263 = 9.125% |
| Entradas com evidencia visual high catalog/runtime | 110/176 = 62.500% |
| EventCmd oficiais | 90/90 = 100.000% mantido |
| Residuos reais EventScript | 0/0 = 100.000% mantido |
| Rebuild byte-perfect | 100.000% mantido |
| Pacote NO-ROM | 100.000% mantido |

## O que mudou

- IDs GOBJ exatos ganharam aliases no formato `GOBJ_<familia>_<id>_FramesX_GfxY`.
- Sequencias de animacao exatas ganharam aliases no formato `AnimSeq_<familia>_<lowword>_<addr>`.
- Referencias runtime/WRAM foram separadas como estado runtime, nao asset estatico.
- Matches por endereco de source e parametros visuais foram preservados como contexto, evitando afirmar nomes finais sem evidencia suficiente.
- Os alvos manuais restantes foram isolados em CSV proprio.

## Arquivos principais

- `tools/event_script_gobj_semantic_alias_pass85.py`
- `reports/pass85_visual_gobj_semantic_aliases.csv`
- `reports/pass85_eventscript_visual_named_xref.csv`
- `reports/pass85_visual_semantic_alias_summary.csv`
- `reports/pass85_visual_family_semantic_alias_summary.csv`
- `reports/pass85_remaining_visual_manual_targets.csv`
- `reports/pass85_eventscript_gobj_semantic_aliasing.md`
- `docs/event_script_system/EventScript_GOBJSemanticAliases_PASS85.md`
- `docs/pseudocode/EventScript_GOBJSemanticAliasTool_PASS85.md`
- `docs/event_script_system/STATUS_PASS85.md`
- `docs/handoff/METAS_DECOMP_PASS85.md`

## Nota de precisao

Esta pass fecha 100% a camada de alias semantico das referencias visuais conhecidas. Ela ainda nao afirma que todos os sprites possuem nome final exato de personagem/objeto; a diferenca agora esta explicitamente separada entre evidencia high, medium e low/manual.
