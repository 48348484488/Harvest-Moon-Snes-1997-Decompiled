# DECOMP PASS 87 - EventScript Character / Scene Owner Xref

Objetivo: adicionar uma camada de dono/cena/personagem por entrada EventScript usando as evidencias ja criadas nas passes 78-86.

Esta pass nao altera bytes da ROM. Ela gera relatorios e documentacao para reduzir o que ainda estava como semantica humana fina: NPC/personagem, familia, festival, animais, objeto visual e cena.

## Resultado medido

| Metrica | Resultado |
|---|---:|
| Entradas EventScript classificadas com owner/cena/personagem | **1288/1288 = 100.000%** |
| Linhas de dialogo direto analisadas | **959** |
| Entradas com dialogo direto | **75** |
| Entradas com bachelorette exata por texto direto | **25** |
| EventCmd oficiais | **90/90 = 100% mantido** |
| Residuos reais EventScript | **0 = 100% mantido** |
| Rebuild byte-perfect | **100% mantido** |
| Pacote NO-ROM | **100% mantido** |

## Distribuicao por tipo de owner

| Tipo | Entradas | Percentual |
|---|---:|---:|
| `family_romance_general` | 936 | 72.671% |
| `animal_livestock` | 181 | 14.053% |
| `farm_crop_weather` | 33 | 2.562% |
| `festival_event` | 31 | 2.407% |
| `shipping_or_status` | 31 | 2.407% |
| `bachelorette_exact` | 25 | 1.941% |
| `object_visual_setup` | 16 | 1.242% |
| `family_child` | 9 | 0.699% |
| `wife_family` | 8 | 0.621% |
| `weather_farm_warning` | 5 | 0.388% |
| `sign_manual_bookshelf` | 5 | 0.388% |
| `carpenter_house_upgrade` | 3 | 0.233% |
| `church_priest` | 3 | 0.233% |
| `romance_marriage_item` | 1 | 0.078% |
| `romance_general` | 1 | 0.078% |

## Confianca da classificacao

| Confianca | Entradas | Percentual |
|---|---:|---:|
| `group_semantic_inferred` | 952 | 73.913% |
| `domain_inferred` | 268 | 20.807% |
| `direct_named_text` | 25 | 1.941% |
| `direct_named_family_text` | 9 | 0.699% |
| `direct_family_role_text` | 8 | 0.621% |
| `direct_animal_text` | 7 | 0.543% |
| `direct_weather_text` | 5 | 0.388% |
| `direct_static_text` | 5 | 0.388% |
| `direct_service_text` | 3 | 0.233% |
| `direct_location_or_role_text` | 3 | 0.233% |
| `direct_romance_item_text` | 1 | 0.078% |
| `direct_category_text` | 1 | 0.078% |
| `direct_event_text` | 1 | 0.078% |

## Bachelorettes com ancoragem direta por texto

| Personagem | Entradas | Grupos principais |
|---|---:|---|
| Ann | 3 | `$01:1 $04:1 $07:1` |
| Ellen | 5 | `$01:2 $07:2 $04:1` |
| Eve | 1 | `$05:1` |
| Maria | 13 | `$01:3 $04:3 $07:3 $02:2 $03:1 $46:1` |
| Nina | 3 | `$01:1 $02:1 $04:1` |

## Arquivos principais

- `reports/pass87_eventscript_character_scene_owner_xref.csv`
- `reports/pass87_character_scene_owner_type_summary.csv`
- `reports/pass87_character_scene_owner_summary.csv`
- `reports/pass87_character_scene_confidence_summary.csv`
- `reports/pass87_character_scene_group_summary.csv`
- `reports/pass87_bachelorette_exact_text_xref.csv`
- `reports/pass87_remaining_character_scene_manual_targets.csv`
- `tools/event_script_character_scene_owner_xref_pass87.py`

## Interpretacao

A Pass 87 fecha a camada de classificacao geral de personagem/cena para todas as entradas EventScript. Ainda nao significa que cada entrada tem nome final de NPC com 100% de certeza; significa que cada entrada agora tem um owner bucket rastreavel, evidencia e nivel de confianca para orientar as proximas passes.
