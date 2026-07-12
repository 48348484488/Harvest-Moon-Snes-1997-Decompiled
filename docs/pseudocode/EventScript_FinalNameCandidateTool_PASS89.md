# Pseudocode - Pass 89 Final Name Candidate Tool

```text
for each EventScript entry from pass88_eventscript_owner_precision_tiers.csv:
    if precision tier is exact_text_anchored_owner:
        candidate = owner + scene_role + entry_index
        status = confirmed_text_or_direct_anchor_candidate
        confidence = high
    else if precision tier is domain_specific_owner_inferred:
        candidate = refined_owner_lane + scene_role + entry_index
        status = domain_inferred_final_candidate
        confidence = medium
    else:
        candidate = structural_lane_base + scene_role + entry_index
        status = structural_lane_final_candidate
        confidence = medium_low

    write candidate row
    group by prototype key for future manual confirmation
```
