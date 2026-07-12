# EventScript Visual Pointer Resolution Tool - Pass84

Input:
- pass83_eventscript_visual_pointer_classification.csv
- pass83_eventscript_visual_gobj_entry_xref.csv
- pass81_eventscript_all_entry_semantic_aliases.csv
- decomp_pass08/sprites/gobj_sprite_catalog.csv

Process:
1. Match visual refs to exact GOBJ ids.
2. Match pointer-like refs to the low word of GOBJ animation sequence pointers.
3. Match B3-B5 refs to EventScript aliases.
4. Classify remaining refs as runtime state, parameters, source address matches, or unresolved asset/table immediates.

Output:
- pass84_visual_pointer_resolution.csv
- pass84_eventscript_visual_entry_resolved_xref.csv
- pass84_visual_pointer_resolution_summary.csv
