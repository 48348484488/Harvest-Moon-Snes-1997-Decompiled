# EventScript Visual/GOBJ Lane Closure Tool - Pass 92

Input: `reports/pass91_eventscript_exact_domain_closure_matrix.csv` and `reports/pass91_final_confirmation_unit_queue_refined.csv`.

Rule: if an entry was still pending after Pass 91 and its remaining review scope is `cross_with_gobj_final_sprite_table`, classify it as `closed_visual_gobj_area`.

Rationale: Passes 83-86 already classified visual/GOBJ references, assigned semantic aliases, and resolved low/manual visual references. Pass 92 converts that resolved visual lane into exact visual-area final names without changing ROM bytes.
