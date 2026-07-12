# Pass 58 - Full EventScript symbolic export B3-B5

Conservative full export generated from the clean USA ROM. Dialog text is not exported; only text ids are retained.

- ROM MD5: `c9bf36a816b6d54aed79d43a6c45111a`
- Groups exported: `72`
- Pointer entries decoded: `1288`
- Per-group files: `reports/event_script_groups_pass58/EventScriptGroup_XX.md`

## Semantic buckets

| Bucket | Groups |
|---|---:|
| `unknown_opcode_cluster_needs_manual_decode` | 29 |
| `mixed_event_script` | 24 |
| `conditional_npc_dialogue_matrix` | 8 |
| `state_gate_or_flag_router` | 5 |
| `audio_sfx_or_tablelike_event_stub` | 2 |
| `item_money_shipping_interaction` | 2 |
| `animal_or_object_visual_setup` | 1 |
| `cutscene_object_transition_setup` | 1 |

## High-value groups for manual rename pass

| Rank | Group | Label | Bucket | Confidence | Cmds | Unknown | Top symbols/text | Next action |
|---:|---:|---|---|---|---:|---:|---|---|
| 1 | `$00` | `EventScriptGroup_00` | `animal_or_object_visual_setup` | high | 480 | 24 | SetCCObjectPointer:52 SetCCObjectParam:35 SetCCObjectVisual:22 SpawnOrMoveCCObject:22 SetCCObjectParam9:2 | Map visual pointers to sprite/GOBJ docs and name animal/object slots. |
| 2 | `$30` | `EventScriptGroup_30` | `item_money_shipping_interaction` | high | 257 | 16 | SetAnimation:15 PlayAudioOrMusic:1 | Cross-reference item ids/money deltas with item/shop/shipping docs. |
| 3 | `$3A` | `EventScriptGroup_3A` | `item_money_shipping_interaction` | high | 32 | 16 | ChangeMoney:14 PlayAudioOrMusic:2 | Cross-reference item ids/money deltas with item/shop/shipping docs. |
| 4 | `$42` | `EventScriptGroup_42` | `audio_sfx_or_tablelike_event_stub` | medium | 1796 | 2 | PlayAudioOrMusic:16 | Cross-reference opcode $00 ids with the audio/SFX map and split true script bodies from lookup filler. |
| 5 | `$47` | `EventScriptGroup_47` | `mixed_event_script` | medium | 657 | 30 | SetFlag:20 EditTileAndSetRuntimeFlag:7 SetValueByte:3 StopOrDisableCCSlot:2 | Use text ids, RAM symbols and first opcodes to split into smaller semantic labels. |
| 6 | `$0E` | `EventScriptGroup_0E` | `audio_sfx_or_tablelike_event_stub` | medium | 648 | 0 | PlayAudioOrMusic:14 Set60:2 | Cross-reference opcode $00 ids with the audio/SFX map and split true script bodies from lookup filler. |
| 7 | `$44` | `EventScriptGroup_44` | `conditional_npc_dialogue_matrix` | medium | 523 | 11 | SetPlayerPosition:11 JumpIfFlagSet:4 JumpIfEqualsByte:1 | Resolve text ids into labels and assign NPC/scene names conservatively. |
| 8 | `$04` | `EventScriptGroup_04` | `conditional_npc_dialogue_matrix` | medium | 395 | 8 | UnknownOpcode_91:8 ChangeGameState2:6 StartNestedScriptSlot:2 | Resolve text ids into labels and assign NPC/scene names conservatively. |
| 9 | `$07` | `EventScriptGroup_07` | `conditional_npc_dialogue_matrix` | medium | 389 | 8 | ChangeGameState2:8 UnknownOpcode_DF:8 | Resolve text ids into labels and assign NPC/scene names conservatively. |
| 10 | `$06` | `EventScriptGroup_06` | `conditional_npc_dialogue_matrix` | medium | 333 | 9 | GetRNG:9 ChangeGameState2:7 | Resolve text ids into labels and assign NPC/scene names conservatively. |
| 11 | `$01` | `EventScriptGroup_01` | `mixed_event_script` | medium | 329 | 23 | ChangeGameState2:11 SetFlag:5 | Use text ids, RAM symbols and first opcodes to split into smaller semantic labels. |
| 12 | `$08` | `EventScriptGroup_08` | `conditional_npc_dialogue_matrix` | medium | 312 | 8 | ChangeGameState2:8 SetFlag:8 | Resolve text ids into labels and assign NPC/scene names conservatively. |
| 13 | `$43` | `EventScriptGroup_43` | `state_gate_or_flag_router` | medium | 231 | 15 | UnknownOpcode_F1:11 JumpIfFlagSet:5 | Name the RAM/flag condition and branch destinations before changing labels. |
| 14 | `$02` | `EventScriptGroup_02` | `conditional_npc_dialogue_matrix` | medium | 225 | 12 | SetPlayerAction1C:11 ChangeGameState2:5 | Resolve text ids into labels and assign NPC/scene names conservatively. |
| 15 | `$03` | `EventScriptGroup_03` | `conditional_npc_dialogue_matrix` | medium | 207 | 14 | ResetFlagD:13 ChangeGameState2:3 | Resolve text ids into labels and assign NPC/scene names conservatively. |
| 16 | `$45` | `EventScriptGroup_45` | `state_gate_or_flag_router` | medium | 166 | 10 | SetFlag:10 JumpIfBetweenValue:4 JumpIfFlagSet:2 | Name the RAM/flag condition and branch destinations before changing labels. |
| 17 | `$05` | `EventScriptGroup_05` | `conditional_npc_dialogue_matrix` | medium | 108 | 15 | UnknownOpcode_67:15 ChangeGameState2:1 | Resolve text ids into labels and assign NPC/scene names conservatively. |
| 18 | `$0B` | `EventScriptGroup_0B` | `mixed_event_script` | medium | 91 | 5 | StartNestedScriptSlot:9 UnknownOpcode_7A:3 StopTimeFlow:2 SetPlayerDirection:2 | Use text ids, RAM symbols and first opcodes to split into smaller semantic labels. |
| 19 | `$09` | `EventScriptGroup_09` | `mixed_event_script` | medium | 76 | 16 | UnknownOpcode_5B:15 Set5C:1 | Use text ids, RAM symbols and first opcodes to split into smaller semantic labels. |
| 20 | `$15` | `EventScriptGroup_15` | `mixed_event_script` | medium | 62 | 16 | EditTileAndSetRuntimeFlag:15 SetPlayerPosition:1 | Use text ids, RAM symbols and first opcodes to split into smaller semantic labels. |
| 21 | `$2A` | `EventScriptGroup_2A` | `mixed_event_script` | medium | 56 | 17 | TimeOfDayPalette:15 SpawnOrMoveCCObject:1 | Use text ids, RAM symbols and first opcodes to split into smaller semantic labels. |
| 22 | `$2D` | `EventScriptGroup_2D` | `state_gate_or_flag_router` | medium | 49 | 26 | JumpIfFlagSet:15 SetPlayerDirection:1 | Name the RAM/flag condition and branch destinations before changing labels. |
| 23 | `$14` | `EventScriptGroup_14` | `state_gate_or_flag_router` | medium | 42 | 11 | JumpIfBetweenValue:11 Set60:4 ToolStopOrWait:1 | Name the RAM/flag condition and branch destinations before changing labels. |
| 24 | `$25` | `EventScriptGroup_25` | `cutscene_object_transition_setup` | medium | 40 | 15 | SetCCObjectParam4:15 StopTimeFlow:1 | Trace transition destination and object positions to map/cutscene names. |

## Complete group map

| Group | Bank | Entries | Unique targets | Cmds | Unknown | Bucket | Dominant classes | File |
|---:|---:|---:|---:|---:|---:|---|---|---|
| `$00` | `$B3` | 136 | 135 | 480 | 24 | `animal_or_object_visual_setup` | cc_state_object:204 script_control:201 unknown:24 special_unknown:22 animals:15 conditional:5 | `event_script_groups_pass58/EventScriptGroup_00.md` |
| `$01` | `$B3` | 16 | 12 | 329 | 23 | `mixed_event_script` | script_control:129 conditional:68 cc_state_object:47 dialog_text:36 unknown:23 screen_transition:11 | `event_script_groups_pass58/EventScriptGroup_01.md` |
| `$02` | `$B3` | 16 | 6 | 225 | 12 | `conditional_npc_dialogue_matrix` | script_control:99 dialog_text:36 conditional:31 cc_state_object:25 unknown:12 player_interaction_control:11 | `event_script_groups_pass58/EventScriptGroup_02.md` |
| `$03` | `$B3` | 16 | 4 | 207 | 14 | `conditional_npc_dialogue_matrix` | script_control:78 cc_state_object:35 conditional:32 dialog_text:32 unknown:14 flags_values:13 | `event_script_groups_pass58/EventScriptGroup_03.md` |
| `$04` | `$B3` | 16 | 9 | 395 | 8 | `conditional_npc_dialogue_matrix` | script_control:167 dialog_text:91 conditional:66 cc_state_object:57 unknown:8 screen_transition:6 | `event_script_groups_pass58/EventScriptGroup_04.md` |
| `$05` | `$B3` | 16 | 2 | 108 | 15 | `conditional_npc_dialogue_matrix` | script_control:37 conditional:20 cc_state_object:17 dialog_text:17 unknown:15 screen_transition:1 | `event_script_groups_pass58/EventScriptGroup_05.md` |
| `$06` | `$B3` | 16 | 8 | 333 | 9 | `conditional_npc_dialogue_matrix` | script_control:134 dialog_text:73 conditional:57 cc_state_object:44 time_rng_palette:9 unknown:9 | `event_script_groups_pass58/EventScriptGroup_06.md` |
| `$07` | `$B3` | 16 | 9 | 389 | 8 | `conditional_npc_dialogue_matrix` | script_control:165 dialog_text:89 cc_state_object:66 conditional:53 screen_transition:8 unknown:8 | `event_script_groups_pass58/EventScriptGroup_07.md` |
| `$08` | `$B3` | 16 | 9 | 312 | 8 | `conditional_npc_dialogue_matrix` | script_control:131 dialog_text:65 cc_state_object:46 conditional:44 screen_transition:10 flags_values:8 | `event_script_groups_pass58/EventScriptGroup_08.md` |
| `$09` | `$B3` | 16 | 2 | 76 | 16 | `mixed_event_script` | script_control:22 unknown:16 player_camera_motion:15 cc_state_object:7 time_rng_palette:6 screen_transition:3 | `event_script_groups_pass58/EventScriptGroup_09.md` |
| `$0A` | `$B3` | 16 | 7 | 28 | 10 | `mixed_event_script` | unknown:10 script_control:8 cc_state_object:4 time_rng_palette:2 screen_transition:2 special_unknown:2 | `event_script_groups_pass58/EventScriptGroup_0A.md` |
| `$0B` | `$B3` | 16 | 13 | 91 | 5 | `mixed_event_script` | script_control:55 screen_transition:6 cc_state_object:6 special_unknown:5 unknown:5 time_rng_palette:4 | `event_script_groups_pass58/EventScriptGroup_0B.md` |
| `$0C` | `$B3` | 16 | 3 | 16 | 14 | `unknown_opcode_cluster_needs_manual_decode` | unknown:14 script_control:2 | `event_script_groups_pass58/EventScriptGroup_0C.md` |
| `$0D` | `$B3` | 16 | 3 | 30 | 14 | `mixed_event_script` | screen_transition:14 unknown:14 script_control:2 | `event_script_groups_pass58/EventScriptGroup_0D.md` |
| `$0E` | `$B3` | 16 | 3 | 648 | 0 | `audio_sfx_or_tablelike_event_stub` | audio:644 cc_state_object:2 script_control:2 | `event_script_groups_pass58/EventScriptGroup_0E.md` |
| `$0F` | `$B4` | 16 | 7 | 22 | 10 | `mixed_event_script` | unknown:10 cc_state_object:6 script_control:6 | `event_script_groups_pass58/EventScriptGroup_0F.md` |
| `$10` | `$B4` | 16 | 2 | 35 | 15 | `mixed_event_script` | special_unknown:15 unknown:15 script_control:4 screen_transition:1 | `event_script_groups_pass58/EventScriptGroup_10.md` |
| `$11` | `$B4` | 16 | 2 | 16 | 15 | `unknown_opcode_cluster_needs_manual_decode` | unknown:15 script_control:1 | `event_script_groups_pass58/EventScriptGroup_11.md` |
| `$12` | `$B4` | 16 | 2 | 31 | 15 | `mixed_event_script` | special_unknown:15 unknown:15 script_control:1 | `event_script_groups_pass58/EventScriptGroup_12.md` |
| `$13` | `$B4` | 16 | 2 | 16 | 15 | `unknown_opcode_cluster_needs_manual_decode` | unknown:15 script_control:1 | `event_script_groups_pass58/EventScriptGroup_13.md` |
| `$14` | `$B4` | 16 | 6 | 42 | 11 | `state_gate_or_flag_router` | conditional:11 special_unknown:11 unknown:11 script_control:5 cc_state_object:4 | `event_script_groups_pass58/EventScriptGroup_14.md` |
| `$15` | `$B4` | 16 | 2 | 62 | 16 | `mixed_event_script` | player_camera_motion:17 unknown:16 eventcmd_51_59_extended:15 script_control:5 screen_transition:4 flags_values:2 | `event_script_groups_pass58/EventScriptGroup_15.md` |
| `$16` | `$B4` | 16 | 2 | 31 | 15 | `mixed_event_script` | cc_state_object:15 unknown:15 script_control:1 | `event_script_groups_pass58/EventScriptGroup_16.md` |
| `$17` | `$B4` | 16 | 2 | 17 | 16 | `unknown_opcode_cluster_needs_manual_decode` | unknown:16 audio:1 | `event_script_groups_pass58/EventScriptGroup_17.md` |
| `$18` | `$B4` | 16 | 2 | 18 | 15 | `unknown_opcode_cluster_needs_manual_decode` | unknown:15 script_control:2 special_unknown:1 | `event_script_groups_pass58/EventScriptGroup_18.md` |
| `$19` | `$B4` | 16 | 3 | 16 | 14 | `unknown_opcode_cluster_needs_manual_decode` | unknown:14 script_control:2 | `event_script_groups_pass58/EventScriptGroup_19.md` |
| `$1A` | `$B4` | 16 | 3 | 16 | 14 | `unknown_opcode_cluster_needs_manual_decode` | unknown:14 script_control:2 | `event_script_groups_pass58/EventScriptGroup_1A.md` |
| `$1B` | `$B4` | 16 | 3 | 17 | 15 | `unknown_opcode_cluster_needs_manual_decode` | unknown:15 script_control:1 audio:1 | `event_script_groups_pass58/EventScriptGroup_1B.md` |
| `$1C` | `$B4` | 16 | 4 | 17 | 14 | `unknown_opcode_cluster_needs_manual_decode` | unknown:14 script_control:2 audio:1 | `event_script_groups_pass58/EventScriptGroup_1C.md` |
| `$1D` | `$B4` | 16 | 5 | 21 | 12 | `mixed_event_script` | unknown:12 script_control:8 special_unknown:1 | `event_script_groups_pass58/EventScriptGroup_1D.md` |
| `$1E` | `$B4` | 16 | 2 | 16 | 15 | `unknown_opcode_cluster_needs_manual_decode` | unknown:15 script_control:1 | `event_script_groups_pass58/EventScriptGroup_1E.md` |
| `$1F` | `$B4` | 16 | 4 | 29 | 13 | `mixed_event_script` | eventcmd_51_59_extended:13 unknown:13 script_control:3 | `event_script_groups_pass58/EventScriptGroup_1F.md` |
| `$20` | `$B4` | 16 | 2 | 31 | 15 | `mixed_event_script` | special_unknown:15 unknown:15 script_control:1 | `event_script_groups_pass58/EventScriptGroup_20.md` |
| `$21` | `$B4` | 16 | 2 | 17 | 15 | `unknown_opcode_cluster_needs_manual_decode` | unknown:15 script_control:2 | `event_script_groups_pass58/EventScriptGroup_21.md` |
| `$22` | `$B4` | 16 | 14 | 16 | 3 | `mixed_event_script` | script_control:13 unknown:3 | `event_script_groups_pass58/EventScriptGroup_22.md` |
| `$23` | `$B4` | 16 | 2 | 24 | 15 | `unknown_opcode_cluster_needs_manual_decode` | unknown:15 script_control:4 screen_transition:2 special_unknown:1 audio:1 flags_values:1 | `event_script_groups_pass58/EventScriptGroup_23.md` |
| `$24` | `$B4` | 16 | 5 | 36 | 16 | `mixed_event_script` | unknown:16 cc_state_object:8 screen_transition:4 special_unknown:4 time_rng_palette:4 | `event_script_groups_pass58/EventScriptGroup_24.md` |
| `$25` | `$B4` | 16 | 2 | 40 | 15 | `cutscene_object_transition_setup` | cc_state_object:15 unknown:15 player_camera_motion:2 screen_transition:2 script_control:2 flags_values:2 | `event_script_groups_pass58/EventScriptGroup_25.md` |
| `$26` | `$B4` | 16 | 3 | 21 | 15 | `unknown_opcode_cluster_needs_manual_decode` | unknown:15 cc_state_object:2 eventcmd_51_59_extended:1 flags_values:1 audio:1 script_control:1 | `event_script_groups_pass58/EventScriptGroup_26.md` |
| `$27` | `$B4` | 16 | 5 | 20 | 12 | `unknown_opcode_cluster_needs_manual_decode` | unknown:12 cc_state_object:4 script_control:4 | `event_script_groups_pass58/EventScriptGroup_27.md` |
| `$28` | `$B4` | 16 | 5 | 32 | 12 | `mixed_event_script` | flags_values:12 unknown:12 cc_state_object:4 script_control:4 | `event_script_groups_pass58/EventScriptGroup_28.md` |
| `$29` | `$B4` | 16 | 2 | 18 | 15 | `unknown_opcode_cluster_needs_manual_decode` | unknown:15 script_control:2 special_unknown:1 | `event_script_groups_pass58/EventScriptGroup_29.md` |
| `$2A` | `$B4` | 16 | 2 | 56 | 17 | `mixed_event_script` | unknown:17 time_rng_palette:15 flags_values:15 cc_state_object:5 script_control:3 special_unknown:1 | `event_script_groups_pass58/EventScriptGroup_2A.md` |
| `$2B` | `$B4` | 16 | 2 | 24 | 17 | `unknown_opcode_cluster_needs_manual_decode` | unknown:17 cc_state_object:3 script_control:3 special_unknown:1 | `event_script_groups_pass58/EventScriptGroup_2B.md` |
| `$2C` | `$B4` | 16 | 2 | 22 | 16 | `unknown_opcode_cluster_needs_manual_decode` | unknown:16 cc_state_object:3 script_control:2 special_unknown:1 | `event_script_groups_pass58/EventScriptGroup_2C.md` |
| `$2D` | `$B4` | 16 | 2 | 49 | 26 | `state_gate_or_flag_router` | unknown:26 conditional:15 script_control:4 player_camera_motion:1 screen_transition:1 special_unknown:1 | `event_script_groups_pass58/EventScriptGroup_2D.md` |
| `$2E` | `$B4` | 16 | 2 | 32 | 16 | `mixed_event_script` | unknown:16 screen_transition:15 audio:1 | `event_script_groups_pass58/EventScriptGroup_2E.md` |
| `$2F` | `$B4` | 16 | 2 | 17 | 16 | `unknown_opcode_cluster_needs_manual_decode` | unknown:16 audio:1 | `event_script_groups_pass58/EventScriptGroup_2F.md` |
| `$30` | `$B4` | 16 | 2 | 257 | 16 | `item_money_shipping_interaction` | items_money:210 audio:16 unknown:16 player_camera_motion:15 | `event_script_groups_pass58/EventScriptGroup_30.md` |
| `$31` | `$B4` | 16 | 2 | 17 | 16 | `unknown_opcode_cluster_needs_manual_decode` | unknown:16 audio:1 | `event_script_groups_pass58/EventScriptGroup_31.md` |
| `$32` | `$B4` | 16 | 2 | 17 | 16 | `unknown_opcode_cluster_needs_manual_decode` | unknown:16 audio:1 | `event_script_groups_pass58/EventScriptGroup_32.md` |
| `$33` | `$B4` | 16 | 2 | 17 | 16 | `unknown_opcode_cluster_needs_manual_decode` | unknown:16 audio:1 | `event_script_groups_pass58/EventScriptGroup_33.md` |
| `$34` | `$B4` | 16 | 2 | 34 | 16 | `mixed_event_script` | unknown:16 animals:15 flags_values:2 audio:1 | `event_script_groups_pass58/EventScriptGroup_34.md` |
| `$35` | `$B4` | 16 | 2 | 18 | 16 | `unknown_opcode_cluster_needs_manual_decode` | unknown:16 flags_values:1 audio:1 | `event_script_groups_pass58/EventScriptGroup_35.md` |
| `$36` | `$B4` | 16 | 2 | 17 | 16 | `unknown_opcode_cluster_needs_manual_decode` | unknown:16 audio:1 | `event_script_groups_pass58/EventScriptGroup_36.md` |
| `$37` | `$B4` | 16 | 2 | 19 | 16 | `unknown_opcode_cluster_needs_manual_decode` | unknown:16 flags_values:2 audio:1 | `event_script_groups_pass58/EventScriptGroup_37.md` |
| `$38` | `$B4` | 16 | 2 | 32 | 16 | `mixed_event_script` | unknown:16 eventcmd_51_59_extended:15 audio:1 | `event_script_groups_pass58/EventScriptGroup_38.md` |
| `$39` | `$B4` | 16 | 2 | 17 | 16 | `unknown_opcode_cluster_needs_manual_decode` | unknown:16 audio:1 | `event_script_groups_pass58/EventScriptGroup_39.md` |
| `$3A` | `$B4` | 16 | 3 | 32 | 16 | `item_money_shipping_interaction` | unknown:16 items_money:14 audio:2 | `event_script_groups_pass58/EventScriptGroup_3A.md` |
| `$3B` | `$B4` | 16 | 3 | 18 | 16 | `unknown_opcode_cluster_needs_manual_decode` | unknown:16 audio:2 | `event_script_groups_pass58/EventScriptGroup_3B.md` |
| `$3C` | `$B4` | 16 | 3 | 18 | 16 | `unknown_opcode_cluster_needs_manual_decode` | unknown:16 audio:2 | `event_script_groups_pass58/EventScriptGroup_3C.md` |
| `$3D` | `$B4` | 16 | 3 | 32 | 16 | `mixed_event_script` | unknown:16 script_control:14 audio:2 | `event_script_groups_pass58/EventScriptGroup_3D.md` |
| `$3E` | `$B4` | 16 | 2 | 32 | 16 | `mixed_event_script` | unknown:16 cc_state_object:15 audio:1 | `event_script_groups_pass58/EventScriptGroup_3E.md` |
| `$3F` | `$B4` | 16 | 2 | 32 | 16 | `state_gate_or_flag_router` | unknown:16 conditional:15 audio:1 | `event_script_groups_pass58/EventScriptGroup_3F.md` |
| `$40` | `$B4` | 16 | 2 | 17 | 16 | `unknown_opcode_cluster_needs_manual_decode` | unknown:16 audio:1 | `event_script_groups_pass58/EventScriptGroup_40.md` |
| `$41` | `$B4` | 16 | 2 | 18 | 16 | `unknown_opcode_cluster_needs_manual_decode` | unknown:16 flags_values:1 audio:1 | `event_script_groups_pass58/EventScriptGroup_41.md` |
| `$42` | `$B4` | 16 | 3 | 1796 | 2 | `audio_sfx_or_tablelike_event_stub` | audio:1794 unknown:2 | `event_script_groups_pass58/EventScriptGroup_42.md` |
| `$43` | `$B5` | 16 | 6 | 231 | 15 | `state_gate_or_flag_router` | conditional:82 script_control:48 cc_state_object:45 dialog_text:20 unknown:15 flags_values:10 | `event_script_groups_pass58/EventScriptGroup_43.md` |
| `$44` | `$B5` | 16 | 6 | 523 | 11 | `conditional_npc_dialogue_matrix` | conditional:172 script_control:140 dialog_text:120 cc_state_object:54 time_rng_palette:15 player_camera_motion:11 | `event_script_groups_pass58/EventScriptGroup_44.md` |
| `$45` | `$B5` | 16 | 7 | 166 | 10 | `state_gate_or_flag_router` | script_control:52 conditional:50 cc_state_object:20 dialog_text:18 flags_values:10 unknown:10 | `event_script_groups_pass58/EventScriptGroup_45.md` |
| `$46` | `$B5` | 16 | 14 | 29 | 16 | `mixed_event_script` | unknown:16 audio:13 | `event_script_groups_pass58/EventScriptGroup_46.md` |
| `$47` | `$B5` | 32 | 31 | 657 | 30 | `mixed_event_script` | eventcmd_51_59_extended:545 flags_values:50 audio:30 unknown:30 script_control:2 | `event_script_groups_pass58/EventScriptGroup_47.md` |
