# Pass 90 - EventScript Final Confirmation Queue

This pass does not change ROM bytes. It converts Pass 89 final-name candidates into a precise confirmation queue.

## Summary

| metric | entries | percent |
|---|---|---|
| total_eventscript_entries | 1288 | 100.000 |
| entries_closed_by_direct_text_or_anchor | 68 | 5.280 |
| entries_pending_exact_final_name | 1220 | 94.720 |
| confirmation_units_total | 163 | 100.000 |
| confirmation_units_closed | 49 | 30.061 |
| confirmation_units_pending | 114 | 69.939 |
| pending_entries_collapsed_to_pending_units | 1220->114 | 9.344 |

## Confirmation buckets

| metric | entries | percent |
|---|---|---|
| bucket:structural_lane_needs_exact_owner_or_scene | 952 | 73.913 |
| bucket:domain_specific_needs_exact_scene_name | 268 | 20.807 |
| bucket:confirmed_direct_anchor | 68 | 5.280 |

## Review lanes

| review_scope | entries | percent_of_total |
|---|---|---|
| resolve_exact_family_romance_npc_branch | 911 | 70.730 |
| review_against_map_npc_sprite_schedule_table | 268 | 20.807 |
| no_manual_review_required_unless_renaming_style_changes | 68 | 5.280 |
| cross_with_gobj_final_sprite_table | 41 | 3.183 |

## Top pending confirmation units

| pass90_confirmation_unit_key | entries | dominant_owner_type | review_scope | recommended_next_action | priority |
|---|---|---|---|---|---|
| structural::StewCookingPotDialogueAlias::AudioCue | 29 | family_romance_general | resolve_exact_family_romance_npc_branch | resolve exact npc by nested text branch or event flag | 1 |
| structural::AudioCueMusicSequenceTable_B::AudioCue | 16 | family_romance_general | resolve_exact_family_romance_npc_branch | resolve exact npc by nested text branch or event flag | 1 |
| structural::CCObjectParam2DSetupCluster::ObjectParamSetup | 16 | family_romance_general | resolve_exact_family_romance_npc_branch | resolve exact npc by nested text branch or event flag | 1 |
| structural::CCObjectParam3SetupCluster::ObjectParamSetup | 16 | family_romance_general | resolve_exact_family_romance_npc_branch | resolve exact npc by nested text branch or event flag | 1 |
| structural::EventCore3TableDrivenSceneRouter::ScriptControlEntry | 16 | family_romance_general | resolve_exact_family_romance_npc_branch | verify_eve_specific_branch_by_text_or_schedule_table | 1 |
| structural::GameStateTransitionBranchCluster::TransitionFlow | 16 | family_romance_general | resolve_exact_family_romance_npc_branch | resolve exact npc by nested text branch or event flag | 1 |
| structural::JumpIf018FStateRouter::StateGateRouter | 16 | family_romance_general | resolve_exact_family_romance_npc_branch | resolve exact npc by nested text branch or event flag | 1 |
| structural::MapTransitionDestinationRouter::TransitionFlow | 16 | family_romance_general | resolve_exact_family_romance_npc_branch | resolve exact npc by nested text branch or event flag | 1 |
| structural::MolePickupEventCluster::ScriptControlEntry | 16 | family_romance_general | resolve_exact_family_romance_npc_branch | verify_eve_specific_branch_by_text_or_schedule_table | 1 |
| structural::ParentsVisitCameraMotionCutsceneSetup::MotionOrVelocityUpdate | 16 | family_romance_general | resolve_exact_family_romance_npc_branch | resolve exact npc by nested text branch or event flag | 1 |
| structural::StateGateFlagRouter_E7AF::StateGateRouter | 16 | family_romance_general | resolve_exact_family_romance_npc_branch | resolve exact npc by nested text branch or event flag | 1 |
| structural::TableDrivenEventScript_5FCluster_A::ScriptControlEntry | 16 | family_romance_general | resolve_exact_family_romance_npc_branch | verify_eve_specific_branch_by_text_or_schedule_table | 1 |
| structural::TableDrivenEventScript_9ACluster::ScriptControlEntry | 16 | family_romance_general | resolve_exact_family_romance_npc_branch | verify_eve_specific_branch_by_text_or_schedule_table | 1 |
| structural::TableDrivenEventScript_B5Cluster::ScriptControlEntry | 16 | family_romance_general | resolve_exact_family_romance_npc_branch | verify_eve_specific_branch_by_text_or_schedule_table | 1 |
| structural::TableDrivenEventScript_C0Cluster::ScriptControlEntry | 16 | family_romance_general | resolve_exact_family_romance_npc_branch | verify_eve_specific_branch_by_text_or_schedule_table | 1 |
| structural::TableDrivenEventScript_D3Cluster::ScriptControlEntry | 16 | family_romance_general | resolve_exact_family_romance_npc_branch | verify_eve_specific_branch_by_text_or_schedule_table | 1 |
| structural::TableDrivenEventScript_F2Cluster_A::ScriptControlEntry | 16 | family_romance_general | resolve_exact_family_romance_npc_branch | verify_eve_specific_branch_by_text_or_schedule_table | 1 |
| structural::TableDrivenEventScript_F3Cluster::ScriptControlEntry | 16 | family_romance_general | resolve_exact_family_romance_npc_branch | verify_eve_specific_branch_by_text_or_schedule_table | 1 |
| structural::TableDrivenEventScript_F8Cluster::ScriptControlEntry | 16 | family_romance_general | resolve_exact_family_romance_npc_branch | verify_eve_specific_branch_by_text_or_schedule_table | 1 |
| structural::TableDrivenEventScript_Opcode88Cluster::ScriptControlEntry | 16 | family_romance_general | resolve_exact_family_romance_npc_branch | verify_eve_specific_branch_by_text_or_schedule_table | 1 |
| structural::TableDrivenTransitionScript_D8Cluster_B::TransitionFlow | 16 | family_romance_general | resolve_exact_family_romance_npc_branch | resolve exact npc by nested text branch or event flag | 1 |
| structural::ToolStopOrWaitInteractionCluster::ScriptControlEntry | 16 | family_romance_general | resolve_exact_family_romance_npc_branch | resolve exact npc by nested text branch or event flag | 1 |
| structural::CrossBankStatePointerRouter_B::FlagUpdate | 15 | family_romance_general | resolve_exact_family_romance_npc_branch | resolve exact npc by nested text branch or event flag | 1 |
| structural::CutsceneObjectTransitionSetup::ObjectParamSetup | 15 | family_romance_general | resolve_exact_family_romance_npc_branch | resolve exact npc by nested text branch or event flag | 1 |
| structural::EveFamilyRomanceDialogueSet::ScriptControlEntry | 15 | family_romance_general | resolve_exact_family_romance_npc_branch | verify_eve_specific_branch_by_text_or_schedule_table | 1 |
| structural::EventCore2TableDrivenSceneRouter::ScriptControlEntry | 15 | family_romance_general | resolve_exact_family_romance_npc_branch | verify_eve_specific_branch_by_text_or_schedule_table | 1 |
| structural::ObjectAnimalHouseUpgradeDialogHub::ObjectParamSetup | 15 | object_visual_setup | cross_with_gobj_final_sprite_table | cross_with_gobj_final_sprite_table | 1 |
| structural::RanchToolManualAndWorkResultDialogue::MotionOrVelocityUpdate | 15 | family_romance_general | resolve_exact_family_romance_npc_branch | resolve exact npc by nested text branch or event flag | 1 |
| structural::StateGateFlagRouter_C6F1::StateGateRouter | 15 | family_romance_general | resolve_exact_family_romance_npc_branch | resolve exact npc by nested text branch or event flag | 1 |
| structural::TableDrivenEventScript_5CCluster::ScriptControlEntry | 15 | family_romance_general | resolve_exact_family_romance_npc_branch | verify_eve_specific_branch_by_text_or_schedule_table | 1 |
