# Pass 83 - EventScript Visual/GOBJ Semantic Xref
Esta pass fecha uma camada de classificacao visual/GOBJ sobre as entradas EventScript ja nomeadas nas Passes 80-82.
## Cobertura
| Medida | Valor | Percentual |
|---|---:|---:|
| Entradas EventScript totais verificadas | 1288/1288 | 100.000% |
| Entradas com referencias visual/objeto | 176/1288 | 13.665% do total |
| Entradas visual/objeto classificadas | 176/176 | 100.000% |
| Referencias visual/objeto unicas classificadas | 263/263 | 100.000% |
| Tokens candidatos a ponteiro visual/GOBJ/asset | 204 | 101 unicos |
| Entradas com comando visual/animacao forte | 174/176 | 98.864% |

## Distribuicao por dominio visual
| Dominio visual | Entradas | Referencias unicas |
|---|---:|---:|
| `general_livestock_visual_context` | 128 | 188 |
| `npc_family_event_visual_context` | 22 | 77 |
| `cow_livestock_visual_context` | 14 | 41 |
| `dog_pet_visual_context` | 8 | 32 |
| `chicken_poultry_visual_context` | 4 | 5 |

## Distribuicao por papel visual
| Papel Pass83 | Entradas |
|---|---:|
| `cc_object_visual_pointer_setup` | 174 |
| `cc_object_parameter_state_setup` | 2 |

## Classes de referencias
| Classe de referencia | Referencias unicas |
|---|---:|
| `candidate_visual_gobj_pointer_or_asset_table` | 100 |
| `bank_b3_b5_script_target_or_local_pointer` | 62 |
| `low_immediate_param_or_small_id` | 49 |
| `mid_range_value_or_table_offset` | 40 |
| `high_bank_pointer_or_immediate_word` | 10 |
| `wram_or_runtime_cc_state_ref` | 1 |
| `candidate_bank_asset_or_table_pointer` | 1 |

## Nota de precisao
Esta pass nao afirma que todo token e um sprite final exato. Ela separa, de forma rastreavel, ponteiro candidato, parametro imediato, WRAM/runtime state e alvo local B3-B5. Isso evita confundir argumento visual com ID final de sprite.

## Arquivos gerados
- `reports/pass83_eventscript_visual_gobj_entry_xref.csv`
- `reports/pass83_eventscript_visual_pointer_classification.csv`
- `reports/pass83_eventscript_visual_domain_summary.csv`
- `reports/pass83_eventscript_visual_group_summary.csv`
