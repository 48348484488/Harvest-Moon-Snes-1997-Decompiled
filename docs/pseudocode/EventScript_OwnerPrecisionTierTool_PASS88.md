# Pseudocode - Pass88 owner precision tool

```text
load pass87_eventscript_character_scene_owner_xref.csv
for each EventScript entry:
    if direct text/name evidence exists:
        classify as exact_text_anchored_owner
    else if owner is already domain-specific:
        classify as domain_specific_owner_inferred
    else:
        split broad owner into structural refinement lane
write detail csv
write tier summary
write lane summary
write remaining final-name target worklist
```
