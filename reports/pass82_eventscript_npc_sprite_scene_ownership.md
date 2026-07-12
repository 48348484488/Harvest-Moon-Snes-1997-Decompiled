# Pass 82 - EventScript NPC/Sprite/Scene Ownership Xref

Pass 82 classifies every decoded EventScript entry into a broad human ownership domain and scene role. This is a semantic metadata pass: it does not change executable bytes.

| Metric | Value |
|---|---:|
| EventScript entries classified | 1288/1288 |
| Ownership classification coverage | 100.000% |
| Direct-dialog anchored entries | 75 |
| Unique direct text IDs referenced | 361 |
| Entries with visual/object pointer refs | 176 |
| Unique visual/object pointer refs | 263 |
| Sprite/GOBJ catalog rows available for xref | 1104 |

## Owner domains

| Item | Entradas | Percentual |
|---|---:|---:|
| `npc_family_romance` | 1025 | 79.581% |
| `animal_livestock_general` | 188 | 14.596% |
| `animal_chicken_or_poultry` | 38 | 2.950% |
| `animal_cow_livestock` | 29 | 2.252% |
| `animal_dog_pet` | 8 | 0.621% |

## Scene roles

| Item | Entradas | Percentual |
|---|---:|---:|
| `script_control_or_table_entry` | 617 | 47.904% |
| `visual_object_setup_or_spawn` | 124 | 9.627% |
| `audio_sfx_trigger` | 92 | 7.143% |
| `object_parameter_setup` | 83 | 6.444% |
| `dialogue_textbox_flow` | 75 | 5.823% |
| `state_gate_branch_router` | 65 | 5.047% |
| `transition_map_flow` | 63 | 4.891% |
| `flag_value_update` | 63 | 4.891% |
| `motion_velocity_update` | 59 | 4.581% |
| `text_or_prompt_flow` | 47 | 3.649% |

## Confidence tiers

| Item | Entradas | Percentual |
|---|---:|---:|
| `medium_high_structural` | 1151 | 89.363% |
| `high_text_anchored` | 75 | 5.823% |
| `high_visual_or_entity_anchored` | 62 | 4.814% |

## Interpretation

- Entries with direct text remain the strongest anchors for NPC/dialogue/family/festival naming.
- Entries with `SetCCObjectVisual`, `SpawnOrMoveCCObject`, `SetCCObjectParam*`, `CowRelated`, `ChickenRelated`, or `DogRelated` now have explicit visual/entity ownership buckets.
- Remaining non-dialogue entries are no longer unclassified; they are categorized as table flow, state/flag router, motion, parameter setup, object visual setup, transition, or menu/farm/livestock flow.
- This pass does not claim exact NPC names for every structural alias. It closes broad ownership coverage so the next pass can refine individual NPC/person names and exact scene titles.
