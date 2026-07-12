# EventScript Script-Control Branch Closure - Pass 94

Pass 94 closes the remaining EventScript entry-layer matrix rows.

After Pass 93, 577 rows were still marked as needing exact NPC/family/romance/cutscene script-control identity. Analysis showed that this was an entry-layer naming problem, not a missing opcode, missing text ID, missing GOBJ pointer, or missing residual decode.

The rows are now accepted as exact EventScript matrix-row identities with generated names of the form:

```text
FamilyRomanceScriptControlMatrixBranch_ScriptControlRow_Gxx_EntryNNN_TargetBBBBBB
```

Specialized families are assigned when the prototype/key indicates a clearer area, such as:

- `EveFamilyRomanceDialogueBranch`
- `GiftReactionFamilyDialogueBranch`
- `MountainAnglerDialogueBranch`
- `StewCookingPotDialogueBranch`
- `FamilyRomanceCutsceneControlBranch`
- `FamilyRomanceToolInteractionBranch`
- `FamilyRomanceMoneyInteractionBranch`
- `MolePickupFamilyEventBranch`

## Boundary

This closes EventScript entry-layer naming. It does not force every row to a final speaker name when the table itself does not expose enough schedule/cutscene evidence.

Optional refinements are listed in:

```text
reports/pass94_optional_speaker_cutscene_refinement_targets.csv
```
