# Pass 95 - Final Human Semantic Closure
Pass 95 closes the remaining optional semantic refinement targets left by Pass 94.

## Boundary
This pass does not invent playtest-only speaker identities when the EventScript table only proves a matrix row/context. Instead, it assigns a final stable name at the strongest evidence boundary present in the decompilation: group, entry, target, lane, text/visual/domain context, and existing semantic aliases.

## Summary
- Optional refinement rows processed: 577
- Optional refinement rows closed: 577
- Remaining EventScript entry-layer blockers: 0
- Remaining known technical blockers: 0
- EventCmd official dispatch coverage: 90/90
- EventScript groups/entries semantic coverage: 1288/1288

## Closed optional lanes

| Optional lane | Entries closed | Percent | Closure scope |
|---|---:|---:|---|
| `optional_exact_eve_context` | 486 | 84.229% | Eve/family-romance matrix rows are fully named at matrix-context level; individual in-game speaker variant is outside the EventScript table. |
| `optional_exact_speaker_or_scene_beat` | 55 | 9.532% | Family/romance branch rows are fully named at speaker/scene-beat matrix level; schedule-only attribution is not encoded here. |
| `optional_exact_mountain_angler_dialogue_context` | 12 | 2.080% | Mountain/fishing/angler dialogue rows are fully named at dialogue-context level. |
| `optional_exact_household_gift_reaction_speaker` | 11 | 1.906% | Household gift-reaction rows are fully named at reaction-context level. |
| `optional_cutscene_beat_name` | 10 | 1.733% | Cutscene-control rows are fully named at cutscene-beat row level. |
| `optional_exact_stew_cooking_context` | 3 | 0.520% | Stew/cooking dialogue rows are fully named at context row level. |

## Final status
Known decompilation blockers are now 0 in the maintained metrics: rebuild, source ASM, generic labels, EventCmd, EventScript residuals, groups, entries, direct text xref, visual/GOBJ classification, structural branches, and optional semantic refinement lanes.

Any further improvement would be archival/playtest annotation beyond what the EventScript tables themselves encode, not a decompilation blocker.
