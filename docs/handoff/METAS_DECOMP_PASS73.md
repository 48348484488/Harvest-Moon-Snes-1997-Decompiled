# METAS DECOMP PASS73

Recommended next passes:

1. Inspect groups with many `entry_starts_as_residual_table_or_pointer_row` rows first.
2. Split real EventScript bodies from inline tables in groups `$09`, `$17`, `$24`, `$2F`, `$31-$40`.
3. Inspect `short_script_then_inline_residual_payload` groups such as `$15`, `$2E`, `$34`, `$38`, `$3A`, `$3D-$3F`.
4. Rename high-confidence family/romance groups `$02-$08` after text-id cross-reference.
5. Map `EventScriptGroup_00` residuals against CC/GOBJ visual objects.
