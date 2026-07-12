# Pass 87 - EventScript Character / Scene Owner Xref
This pass adds a character/scene owner layer above the Pass 81/82/86 semantic EventScript tables. It does not alter ROM bytes.
## Measured coverage
- EventScript entries classified with a Pass87 owner bucket: **1288/1288 = 100.000%**
- Direct-dialog EventScript rows analyzed: **959**
- Entries with direct dialog evidence: **75**
- Exact bachelorette named-text entry anchors: **25**
- Remaining structural/domain-inferred character-scene targets: **1220**

## Owner type summary

| Owner type | Entries | Percent |
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

## Confidence summary

| Confidence | Entries | Percent |
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

## Exact named bachelorette anchors

| Character | Entries | Groups | Example entries |
|---|---:|---|---|
| Ann | 3 | `$01:1 $04:1 $07:1` | `$01:4@$B3A162 $04:3@$B3C810 $07:3@$B3DCD1` |
| Ellen | 5 | `$01:2 $07:2 $04:1` | `$01:5@$B3A438 $01:7@$B3A727 $04:4@$B3C92A $07:4@$B3DDC7 $07:6@$B3DFCE` |
| Eve | 1 | `$05:1` | `$05:0@$B3CC91` |
| Maria | 13 | `$01:3 $04:3 $07:3 $02:2 $03:1 $46:1` | `$01:1@$B39D05 $01:2@$B39F3E $01:6@$B3A5B1 $02:1@$B3B44A $02:2@$B3B4E3 $03:1@$B3BD2D $04:0@$B3C527 $04:1@$B3C6AE $04:5@$B3CA98 $07:0@$B3DA17` |
| Nina | 3 | `$01:1 $02:1 $04:1` | `$01:3@$B3A086 $02:4@$B3B8D2 $04:2@$B3C6FE` |

## Files
- `reports/pass87_eventscript_character_scene_owner_xref.csv`
- `reports/pass87_character_scene_owner_type_summary.csv`
- `reports/pass87_character_scene_owner_summary.csv`
- `reports/pass87_character_scene_confidence_summary.csv`
- `reports/pass87_character_scene_group_summary.csv`
- `reports/pass87_bachelorette_exact_text_xref.csv`
- `reports/pass87_remaining_character_scene_manual_targets.csv`
