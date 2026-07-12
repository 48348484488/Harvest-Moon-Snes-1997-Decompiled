# EventScript Cross-Group Boundary Classifier - Pass 74

Purpose: overlay hard EventScriptGroup boundaries on top of the conservative Pass 73 residual scan.

## Algorithm

```text
for each EventScriptGroup in master table:
    hard_start = EventScriptGroup_N
    hard_end   = EventScriptGroup_N+1

for each Pass 73 residual marker:
    if residual_addr >= hard_end:
        classify as cross_group_boundary_artifact
    else if target_addr >= hard_end:
        classify as cross_group_target_alias
    else:
        classify as true_in_group_inline_residual_needs_manual_trace
```

## Result

```text
Pass 73 residual markers: 987
Cross-group artifacts resolved: 888
True in-group inline residuals remaining: 99
Effective known coverage: 98.847%
Effective unresolved in-group residual: 1.153%
```

## Interpretation

A byte above `$59` after the scanner crosses the hard start of the next EventScriptGroup is not a missing EventCmd opcode. It is a boundary artifact from conservative linear scanning or an alias into another group.

Only the 99 true in-group residuals should be treated as the next manual decomp target.
