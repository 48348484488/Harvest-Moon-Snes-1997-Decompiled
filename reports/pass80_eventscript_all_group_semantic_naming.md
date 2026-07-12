# Pass 80 - EventScript all-group semantic naming closure

- Generated: `2026-07-05T02:41:49`
- ROM MD5 target: `c9bf36a816b6d54aed79d43a6c45111a`
- Scope: all 72 EventScript master groups `$00-$47`.

## Closure metrics

| Metric | Value |
|---|---:|
| EventScript master groups named at group level | `72/72` |
| Groups already named in Pass79/direct-dialog pass | `18` |
| Remaining groups newly named in Pass80 | `54` |
| High-confidence group names | `22` |
| Medium-confidence structural names | `50` |
| EventCmd official dispatch audit | `90/90` |
| EventScript effective residuals | `0` |
| Source byte changes | `0` |

## Category summary

| Category | Groups | Percent |
|---|---:|---:|
| `table_driven_scene` | 29 | 40.278% |
| `dialog_anchor` | 18 | 25.000% |
| `state_gate_router` | 6 | 8.333% |
| `tool_interaction` | 5 | 6.944% |
| `audio_sequence` | 2 | 2.778% |
| `held_item_context` | 2 | 2.778% |
| `item_money_shipping` | 2 | 2.778% |
| `object_visual_setup` | 2 | 2.778% |
| `transition_router` | 2 | 2.778% |
| `cutscene_motion` | 1 | 1.389% |
| `cutscene_object_transition` | 1 | 1.389% |
| `item_object_interaction` | 1 | 1.389% |
| `tile_object_payload` | 1 | 1.389% |

## All group names

| Group | Pass80 semantic name | Category | Confidence | Previous status | Evidence |
|---|---|---|---|---|---|
| `$00` | `ObjectAnimalHouseUpgradeDialogHub` | `dialog_anchor` | `high` | `pass79_dialog_named` | bucket=animal_or_object_visual_setup; opcodes=$12:122 $2F:72 $13:59 $1B:52 $1A:26 $2B:22 $0D:19 $2E:18; symbols=season:3 $8000D4:2 $7F1F5A:1; text_ids=4 |
| `$01` | `MixedNpcFestivalRomanceDialogHub` | `dialog_anchor` | `high` | `pass79_dialog_named` | bucket=mixed_event_script; opcodes=$12:74 $1C:36 $15:28 $09:26 $14:21 $4D:17 $2D:14 $18:13; symbols=season:14 marriage_flags:13 day:12 $7F1F6A:4 family_event_flags:4; text_ids=116 |
| `$02` | `FamilyRomanceDialogueMatrix_A` | `dialog_anchor` | `high` | `pass79_dialog_named` | bucket=family_romance_dialogue_matrix; opcodes=$12:60 $1C:35 $09:18 $14:16 $16:12 $4D:11 $59:11 $BA:11; symbols=marriage_flags:6 hour:6 old_item_on_hand_or_event_item_mirror:6 $7F1F6A:6 family_event_flags:5; text_ids=44 |
| `$03` | `MarriageChurchBlueFeatherDialogueMatrix` | `dialog_anchor` | `high` | `pass79_dialog_named` | bucket=family_romance_dialogue_matrix; opcodes=$12:48 $1C:32 $09:19 $1B:19 $14:17 $27:13 $C6:13 $16:10; symbols=marriage_flags:6 $7F1F6A:5 old_item_on_hand_or_event_item_mirror:5 family_event_flags:4 hour:3; text_ids=38 |
| `$04` | `FamilyRomanceWeatherDialogueMatrix_B` | `dialog_anchor` | `high` | `pass79_dialog_named` | bucket=family_romance_dialogue_matrix; opcodes=$12:126 $1C:91 $16:25 $14:19 $41:19 $15:18 $09:17 $1A:16; symbols=old_item_on_hand_or_event_item_mirror:40 $7F1F6A:8 family_event_flags:7 marriage_flags:4 season:3; text_ids=61 |
| `$05` | `EveFamilyRomanceDialogueSet` | `dialog_anchor` | `high` | `pass79_dialog_named` | bucket=family_romance_dialogue_matrix; opcodes=$12:24 $1C:17 $67:15 $09:10 $14:10 $1B:10 $15:6 $1A:3; symbols=marriage_flags:8 season:4 family_event_flags:2 old_item_on_hand_or_event_item_mirror:2 day:2; text_ids=14 |
| `$06` | `EveWeatherLivestockDialogueMatrix` | `dialog_anchor` | `high` | `pass79_dialog_named` | bucket=family_romance_dialogue_matrix; opcodes=$12:105 $1C:72 $14:22 $16:16 $1A:15 $15:15 $09:14 $2D:14; symbols=old_item_on_hand_or_event_item_mirror:31 player_house_and_event_flags:13 marriage_flags:4 family_event_flags:3 $7F1F6A:2; text_ids=48 |
| `$07` | `MountainWeatherRomanceDialogueMatrix` | `dialog_anchor` | `high` | `pass79_dialog_named` | bucket=family_romance_dialogue_matrix; opcodes=$12:123 $1C:89 $15:25 $14:20 $41:20 $09:17 $1A:16 $4D:15; symbols=day:22 $7F1F6A:8 family_event_flags:8 old_item_on_hand_or_event_item_mirror:7 marriage_flags:4; text_ids=68 |
| `$08` | `GeneralNpcWeatherFamilyDialogueMatrix` | `dialog_anchor` | `high` | `pass79_dialog_named` | bucket=family_romance_dialogue_matrix; opcodes=$12:100 $1C:65 $16:21 $09:17 $1A:17 $2D:16 $41:12 $15:10; symbols=old_item_on_hand_or_event_item_mirror:31 marriage_flags:4 family_event_flags:3 $7F1F6A:2 hearts_ellen:2; text_ids=38 |
| `$09` | `ParentsVisitCameraMotionCutsceneSetup` | `cutscene_motion` | `medium` | `unnamed_before_pass80` | bucket=mixed_event_script; opcodes=$5B:15 $13:14 $19:10 $09:8 $02:4 $07:3 $39:3 $40:2; symbols=; text_ids=0 |
| `$0A` | `TableDrivenCutsceneObjectScript_FA` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=mixed_event_script; opcodes=$FA:10 $4F:4 $50:4 $02:2 $08:2 $09:2 $38:2 $10:2; symbols=; text_ids=0 |
| `$0B` | `MountainAnglerFishingSignDialogue` | `dialog_anchor` | `high` | `pass79_dialog_named` | bucket=mixed_event_script; opcodes=$09:37 $10:10 $38:5 $12:5 $08:3 $13:3 $1A:3 $1F:3; symbols=hour:1; text_ids=3 |
| `$0C` | `TableDrivenEventScript_Opcode88Cluster` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$88:14 $50:2; symbols=; text_ids=0 |
| `$0D` | `MapTransitionDestinationRouter` | `transition_router` | `medium` | `unnamed_before_pass80` | bucket=mixed_event_script; opcodes=$06:14 $D4:14 $50:2; symbols=; text_ids=0 |
| `$0E` | `AudioCueMusicSequenceTable_A` | `audio_sequence` | `high` | `unnamed_before_pass80` | bucket=audio_sfx_or_tablelike_event_stub; opcodes=$00:644 $4F:2 $50:2; symbols=; text_ids=0 |
| `$0F` | `TableDrivenTransitionScript_D8Cluster_A` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=mixed_event_script; opcodes=$D8:10 $4F:6 $50:6; symbols=; text_ids=0 |
| `$10` | `EventCore2TableDrivenSceneRouter` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=mixed_event_script; opcodes=$38:15 $88:15 $09:2 $08:1 $13:1 $10:1; symbols=; text_ids=0 |
| `$11` | `TableDrivenEventScript_C0Cluster` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$C0:15 $50:1; symbols=; text_ids=0 |
| `$12` | `EventCore3TableDrivenSceneRouter` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=mixed_event_script; opcodes=$4A:15 $89:15 $50:1; symbols=; text_ids=0 |
| `$13` | `TableDrivenEventScript_F2Cluster_A` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$F2:15 $50:1; symbols=; text_ids=0 |
| `$14` | `StateGateFlagRouter_MiscA` | `state_gate_router` | `medium` | `unnamed_before_pass80` | bucket=state_gate_or_flag_router; opcodes=$45:11 $38:11 $8D:11 $50:5 $4F:4; symbols=$8D388C:1; text_ids=0 |
| `$15` | `RanchToolManualAndWorkResultDialogue` | `dialog_anchor` | `high` | `pass79_dialog_named` | bucket=mixed_event_script; opcodes=$05:16 $58:15 $8E:15 $09:3 $08:2 $11:2 $0C:2 $07:1; symbols=; text_ids=6 |
| `$16` | `CCObjectParam3SetupCluster` | `object_visual_setup` | `medium` | `unnamed_before_pass80` | bucket=mixed_event_script; opcodes=$25:15 $C5:15 $50:1; symbols=; text_ids=0 |
| `$17` | `TableDrivenEventScript_E5Cluster` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$E5:15 $00:1 $B4:1; symbols=; text_ids=0 |
| `$18` | `TableDrivenEventScript_B5Cluster` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$B5:15 $09:1 $38:1 $10:1; symbols=; text_ids=0 |
| `$19` | `TableDrivenEventScript_F3Cluster` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$F3:14 $50:2; symbols=; text_ids=0 |
| `$1A` | `TableDrivenEventScript_D3Cluster` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$D3:14 $50:2; symbols=; text_ids=0 |
| `$1B` | `TableDrivenEventScript_F2Cluster_B` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$F2:14 $50:1 $00:1 $B4:1; symbols=; text_ids=0 |
| `$1C` | `TableDrivenEventScript_5CCluster` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$5C:13 $50:2 $00:1 $B4:1; symbols=; text_ids=0 |
| `$1D` | `TableDrivenEventScript_9ACluster` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=mixed_event_script; opcodes=$9A:12 $09:4 $50:3 $38:1 $10:1; symbols=; text_ids=0 |
| `$1E` | `TableDrivenEventScript_5FCluster_A` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$5F:15 $50:1; symbols=; text_ids=0 |
| `$1F` | `ChickenDogHeldItemContextCluster_A` | `held_item_context` | `medium` | `unnamed_before_pass80` | bucket=mixed_event_script; opcodes=$51:13 $9E:13 $50:3; symbols=; text_ids=0 |
| `$20` | `MolePickupEventCluster` | `item_object_interaction` | `medium` | `unnamed_before_pass80` | bucket=mixed_event_script; opcodes=$33:15 $9F:15 $50:1; symbols=; text_ids=0 |
| `$21` | `TableDrivenEventScript_F8Cluster` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$F8:15 $09:1 $10:1; symbols=; text_ids=0 |
| `$22` | `ToolStopOrWaitInteractionCluster` | `tool_interaction` | `medium` | `unnamed_before_pass80` | bucket=mixed_event_script; opcodes=$50:13 $9F:3; symbols=; text_ids=0 |
| `$23` | `TableDrivenEventScript_75Cluster` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$75:15 $09:3 $08:1 $38:1 $2C:1 $0C:1 $11:1 $10:1; symbols=; text_ids=0 |
| `$24` | `FestivalTomorrowAnnouncementDialogues` | `dialog_anchor` | `high` | `pass79_dialog_named` | bucket=mixed_event_script; opcodes=$D5:12 $08:4 $1A:4 $38:4 $3A:4 $03:4 $5F:2 $7B:1; symbols=; text_ids=9 |
| `$25` | `CutsceneObjectTransitionSetup` | `cutscene_object_transition` | `medium` | `unnamed_before_pass80` | bucket=cutscene_object_transition_setup; opcodes=$2D:15 $B6:15 $02:1 $05:1 $07:1 $08:1 $09:1 $38:1; symbols=; text_ids=0 |
| `$26` | `StewCookingPotEventDialogue` | `dialog_anchor` | `high` | `pass79_dialog_named` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$7E:14 $4F:2 $51:1 $23:1 $00:1 $B4:1 $50:1; symbols=; text_ids=3 |
| `$27` | `TableDrivenEventScript_EBCluster` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$EB:12 $4F:4 $50:4; symbols=; text_ids=0 |
| `$28` | `CrossBankStatePointerRouter_A` | `state_gate_router` | `medium` | `unnamed_before_pass80` | bucket=mixed_event_script; opcodes=$47:12 $C4:12 $4F:4 $50:4; symbols=$C4B8C4:1; text_ids=0 |
| `$29` | `TableDrivenTransitionScript_D8Cluster_B` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$D8:15 $09:1 $38:1 $10:1; symbols=; text_ids=0 |
| `$2A` | `CrossBankStatePointerRouter_B` | `state_gate_router` | `medium` | `unnamed_before_pass80` | bucket=mixed_event_script; opcodes=$24:15 $48:15 $C5:15 $1B:3 $13:2 $0D:2 $1A:1 $37:1; symbols=$C548C5:1; text_ids=0 |
| `$2B` | `TableDrivenEventScript_68Cluster` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$68:15 $13:2 $0D:2 $1A:1 $1B:1 $37:1 $41:1 $10:1; symbols=; text_ids=0 |
| `$2C` | `TableDrivenEventScript_A4Cluster` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$A4:15 $1A:1 $13:1 $1B:1 $0D:1 $37:1 $41:1 $10:1; symbols=; text_ids=0 |
| `$2D` | `StateGateFlagRouter_C6F1` | `state_gate_router` | `medium` | `unnamed_before_pass80` | bucket=state_gate_or_flag_router; opcodes=$14:15 $C6:15 $0D:11 $12:2 $07:1 $09:1 $11:1 $38:1; symbols=$C6F1C6:1; text_ids=0 |
| `$2E` | `GameStateTransitionBranchCluster` | `transition_router` | `medium` | `unnamed_before_pass80` | bucket=mixed_event_script; opcodes=$11:15 $C7:15 $00:1 $B4:1; symbols=; text_ids=0 |
| `$2F` | `TableDrivenEventScript_E3Cluster` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$E3:15 $00:1 $B4:1; symbols=; text_ids=0 |
| `$30` | `ItemMoneyShippingAnimationInteraction` | `item_money_shipping` | `high` | `unnamed_before_pass80` | bucket=item_money_shipping_interaction; opcodes=$3F:210 $00:16 $B4:16 $19:15; symbols=; text_ids=0 |
| `$31` | `TableDrivenEventScript_5FCluster_B` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$5F:15 $00:1 $B4:1; symbols=; text_ids=0 |
| `$32` | `TableDrivenEventScript_76Cluster` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$76:15 $00:1 $B4:1; symbols=; text_ids=0 |
| `$33` | `TableDrivenEventScript_EACluster` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$EA:15 $00:1 $B4:1; symbols=; text_ids=0 |
| `$34` | `ToolSelectedEventToolMirrorRouter_A` | `tool_interaction` | `medium` | `unnamed_before_pass80` | bucket=mixed_event_script; opcodes=$31:15 $D0:15 $47:2 $00:1 $B4:1; symbols=tool_selected_or_event_tool_mirror:1 watering_can_water_or_event_item_counter:1; text_ids=0 |
| `$35` | `ToolSelectedEventToolMirrorRouter_B` | `tool_interaction` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$80:15 $47:1 $00:1 $B4:1; symbols=tool_selected_or_event_tool_mirror:1; text_ids=0 |
| `$36` | `TableDrivenEventScript_ECCluster` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$EC:15 $00:1 $B4:1; symbols=; text_ids=0 |
| `$37` | `ToolSelectedEventToolMirrorRouter_C` | `tool_interaction` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$67:15 $47:2 $00:1 $B4:1; symbols=tool_selected_or_event_tool_mirror:1 watering_can_water_or_event_item_counter:1; text_ids=0 |
| `$38` | `ChickenDogHeldItemContextCluster_B` | `held_item_context` | `medium` | `unnamed_before_pass80` | bucket=mixed_event_script; opcodes=$51:15 $D5:15 $00:1 $B4:1; symbols=; text_ids=0 |
| `$39` | `TableDrivenEventScript_92Cluster` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$92:15 $00:1 $B4:1; symbols=; text_ids=0 |
| `$3A` | `MoneyChangeInteractionCluster` | `item_money_shipping` | `high` | `unnamed_before_pass80` | bucket=item_money_shipping_interaction; opcodes=$42:14 $DC:14 $00:2 $B4:2; symbols=; text_ids=0 |
| `$3B` | `TableDrivenEventScript_EDCluster` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$ED:14 $00:2 $B4:2; symbols=; text_ids=0 |
| `$3C` | `B4InlineTileObjectPayloadCluster` | `tile_object_payload` | `high` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$B4:16 $00:2; symbols=; text_ids=0 |
| `$3D` | `JumpIf018FStateRouter` | `state_gate_router` | `medium` | `unnamed_before_pass80` | bucket=mixed_event_script; opcodes=$20:14 $FF:14 $00:2 $B4:2; symbols=; text_ids=0 |
| `$3E` | `CCObjectParam2DSetupCluster` | `object_visual_setup` | `medium` | `unnamed_before_pass80` | bucket=mixed_event_script; opcodes=$1F:15 $E4:15 $00:1 $B4:1; symbols=; text_ids=0 |
| `$3F` | `StateGateFlagRouter_E7AF` | `state_gate_router` | `medium` | `unnamed_before_pass80` | bucket=state_gate_or_flag_router; opcodes=$14:15 $E7:15 $00:1 $B4:1; symbols=$E7AFE6:1; text_ids=0 |
| `$40` | `TableDrivenEventScript_CFCluster` | `table_driven_scene` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$CF:15 $00:1 $B4:1; symbols=; text_ids=0 |
| `$41` | `ToolSelectedEventToolMirrorRouter_D` | `tool_interaction` | `medium` | `unnamed_before_pass80` | bucket=unknown_opcode_cluster_needs_manual_decode; opcodes=$A9:15 $47:1 $00:1 $B4:1; symbols=tool_selected_or_event_tool_mirror:1; text_ids=0 |
| `$42` | `AudioCueMusicSequenceTable_B` | `audio_sequence` | `high` | `unnamed_before_pass80` | bucket=audio_sfx_or_tablelike_event_stub; opcodes=$00:1794 $B4:2; symbols=; text_ids=0 |
| `$43` | `GiftReactionHouseFamilyDialogRouter` | `dialog_anchor` | `high` | `pass79_dialog_named` | bucket=state_gate_or_flag_router; opcodes=$12:48 $14:28 $15:21 $1A:20 $1C:20 $41:14 $45:14 $F1:11; symbols=$7F1F5E:15 player_house_and_event_flags:12 hour:11 old_item_on_hand_or_event_item_mirror:8 current_graphic_preset_mirror_or_scene_state:6; text_ids=67 |
| `$44` | `NpcGiftFestivalLivestockDialogRouter` | `dialog_anchor` | `high` | `pass79_dialog_named` | bucket=family_romance_dialogue_matrix; opcodes=$12:132 $1C:120 $15:67 $14:45 $41:39 $16:25 $45:20 $17:15; symbols=old_item_on_hand_or_event_item_mirror:38 family_event_flags:25 season:20 current_graphic_preset_mirror_or_scene_state:10 player_house_and_event_flags:10; text_ids=55 |
| `$45` | `FamilyCelebrationBirthdayDialogues` | `dialog_anchor` | `high` | `pass79_dialog_named` | bucket=state_gate_or_flag_router; opcodes=$12:46 $14:24 $1C:18 $23:10 $A7:10 $45:8 $1A:8 $18:8; symbols=marriage_flags:20 hour:4 kid1_age:4 old_item_on_hand_or_event_item_mirror:4 kid2_age:4; text_ids=6 |
| `$46` | `ShippingLivestockStatusDialogues` | `dialog_anchor` | `high` | `pass79_dialog_named` | bucket=mixed_event_script; opcodes=$00:13 $B4:13 $AE:3; symbols=; text_ids=23 |
| `$47` | `StewCookingPotDialogueAlias` | `dialog_anchor` | `medium` | `pass79_dialog_named` | bucket=mixed_event_script; opcodes=$58:545 $23:30 $00:30 $B4:30 $47:20 $10:2; symbols=$7F1F60:23 tool_selected_or_event_tool_mirror:4 tool_backpack_or_event_tool_mirror:2; text_ids=1 |

## Interpretation

Pass 80 closes the group-level semantic naming gap: every EventScript master group now has an auditable name.
For groups without direct dialog, the names are intentionally structural instead of overclaiming a specific NPC/festival owner.
The next layer is entry-level hard ownership: mapping individual entries to NPCs, sprites/GOBJ, cutscenes and exact event names.
