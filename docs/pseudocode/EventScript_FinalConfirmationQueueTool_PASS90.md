# EventScript Final Confirmation Queue Tool - Pass 90

Input:

```text
reports/pass89_eventscript_final_name_candidates.csv
```

Process:

1. Read every EventScript final-name candidate.
2. Assign a Pass90 confirmation bucket.
3. Assign a closed/pending state.
4. Collapse related pending rows into prototype confirmation units.
5. Emit per-entry, per-unit, per-area and per-lane reports.

Output:

```text
reports/pass90_eventscript_final_confirmation_matrix.csv
reports/pass90_final_confirmation_unit_queue.csv
reports/pass90_final_confirmation_summary.csv
reports/pass90_remaining_exact_name_area_percentages.csv
reports/pass90_confirmation_lane_summary.csv
```

