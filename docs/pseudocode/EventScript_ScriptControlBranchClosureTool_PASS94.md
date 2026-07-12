# EventScript Script-Control Branch Closure Tool - Pass 94

Tool:

```text
tools/event_script_script_control_branch_closure_pass94.py
```

Input:

```text
reports/pass93_eventscript_structural_role_closure_matrix.csv
reports/pass93_final_confirmation_unit_queue_refined.csv
```

Output:

```text
reports/pass94_eventscript_script_control_branch_closure_matrix.csv
reports/pass94_closed_script_control_branch_entries.csv
reports/pass94_final_confirmation_unit_queue_closed.csv
reports/pass94_script_control_branch_closure_summary.csv
reports/pass94_remaining_exact_name_area_percentages.csv
reports/pass94_confirmation_lane_summary.csv
reports/pass94_optional_speaker_cutscene_refinement_targets.csv
```

Logic:

1. Read Pass 93 remaining rows.
2. Select rows where `pass93_final_confirmation_state != closed` and the remaining scope is the family/romance script-control branch lane.
3. Generate an exact matrix-row name from group, entry, target, prototype key, and scene role.
4. Close the EventScript entry-layer row.
5. Move exact speaker/cutscene beat naming into an optional refinement lane.
