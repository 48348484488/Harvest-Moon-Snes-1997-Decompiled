# METAS DECOMP PASS74

Recommended next passes:

1. Attack only the 99 `true_in_group_inline_residual_needs_manual_trace` rows from `reports/pass74_eventscript_boundary_classified_residuals.csv`.
2. Start with groups `$47`, `$46`, `$01`, `$00`, `$24`, and `$43`, because they contain the largest true in-group residual counts.
3. Do not spend time on `cross_group_boundary_artifact` rows; they are now resolved as scanner/boundary artifacts.
4. Build a table-tail recognizer for repeated `$B4` inline residual patterns in groups `$2E-$40`.
5. Cross-reference the remaining true in-group residuals against text IDs, CC/GOBJ object setup, and NPC/event scenes.
