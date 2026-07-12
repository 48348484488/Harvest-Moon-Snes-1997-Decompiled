# DECOMP PASS 90 - EventScript Final Confirmation Queue

Goal: continue the post-Pass89 human semantic layer by converting final-name candidates into a precise confirmation queue.

This pass does not modify ROM bytes or executable source behavior. It adds a review matrix that separates:

- direct/text-anchored entries already closed for Pass 90;
- domain-specific entries that only need optional exact scene naming;
- structural-lane entries that still need exact owner/NPC/cutscene/object identification.

## Results

| Metric | Value |
|---|---:|
| EventScript entries processed | 1288/1288 |
| Entries with Pass90 confirmation bucket | 1288/1288 |
| Direct/text-anchored entries closed | 68 |
| Entries pending exact final name | 1220 |
| Confirmation units total | 163 |
| Confirmation units closed | 49 |
| Confirmation units pending | 114 |
| Pending entry rows collapsed into prototype units | 1220 -> 114 |
| EventCmd official dispatch coverage | 90/90 |
| Real EventScript residuals | 0 |
| Generic source labels CODE_/DATA8_/DATA16_/SUB_/UNK_ | 0 |
| Byte-perfect rebuild | OK |

## Interpretation

Pass 90 closes the queue structure, not every exact final human name. The decompilation remains byte-perfect and technically complete. The remaining work is exact semantic confirmation, mainly NPC/family-romance branches, domain-specific livestock/farm/festival cases, and final GOBJ/object names.

