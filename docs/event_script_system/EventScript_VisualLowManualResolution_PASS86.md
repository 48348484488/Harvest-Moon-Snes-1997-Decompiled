# EventScript Visual Low/Manual Resolution - Pass 86

Pass 86 resolves the 24 low-confidence visual/GOBJ references left by Pass 85.

## Results

| Metric | Value |
|---|---:|
| Low/manual references before | 24 |
| Low/manual references after | 0 |
| Reclassified references | 24 |
| Visual entries with refined names | 176 |

The important distinction is that these references are not final GOBJ IDs. They are contextual pointers/anchors used by EventScript CC object commands.

See:

- `reports/pass86_visual_low_manual_resolution.csv`
- `reports/pass86_visual_manual_resolution_closure.md`
- `reports/pass86_eventscript_visual_named_xref_refined.csv`
