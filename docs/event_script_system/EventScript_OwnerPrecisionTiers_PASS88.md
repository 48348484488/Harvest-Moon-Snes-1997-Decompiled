# EventScript Owner Precision Tiers - Pass 88

Pass 88 adds a precision layer over the Pass87 owner/scene classification.

The new tiers are:

- `exact_text_anchored_owner`: entry has direct text/name evidence.
- `domain_specific_owner_inferred`: entry has a specific domain owner such as cow/chicken/weather/festival/shipping.
- `structural_owner_lane`: entry still needs final exact naming, but now belongs to a deterministic lane instead of a broad bucket.

The important output for the next pass is:

```text
reports/pass88_remaining_final_name_targets.csv
```

That file is the worklist for final NPC/cutscene/festival/object naming.
