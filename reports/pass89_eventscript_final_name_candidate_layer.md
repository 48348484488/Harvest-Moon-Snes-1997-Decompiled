# Pass 89 - EventScript Final Name Candidate Layer

This pass adds a deterministic final-name candidate layer on top of Pass 88 owner precision tiers.
It does not change ROM bytes or executable source logic.

## Objective metrics

| Metric | Value |
|---|---:|
| EventScript entries processed | 1288 |
| Entries with Pass89 final name candidate | 1288/1288 = 100.000% |
| Confirmed/direct text anchored candidates | 68/1288 = 5.280% |
| Domain inferred final candidates | 268/1288 = 20.807% |
| Structural lane final candidates | 952/1288 = 73.913% |
| Unique manual prototype keys | 129 |

## What changed

Pass 88 reduced the problem to owner precision tiers. Pass 89 gives every EventScript entry a stable
`pass89_final_name_candidate`, a `pass89_candidate_status`, a confirmation level, and a manual prototype key.
This reduces the next manual pass from reviewing isolated raw entries to reviewing grouped scene/NPC/object prototypes.

## Output files

- `reports/pass89_eventscript_final_name_candidates.csv`
- `reports/pass89_final_name_candidate_summary.csv`
- `reports/pass89_manual_prototype_queue.csv`
- `reports/pass89_group_final_name_candidate_summary.csv`
- `reports/pass89_owner_final_candidate_summary.csv`

## Interpretation

- `confirmed_text_or_direct_anchor_candidate`: high confidence from text/dialogue or direct anchor.
- `domain_inferred_final_candidate`: useful candidate from a specific domain such as livestock, weather, festival, shipping.
- `structural_lane_final_candidate`: stable candidate based on group/lane/role; still needs exact NPC/festival/cutscene validation.
