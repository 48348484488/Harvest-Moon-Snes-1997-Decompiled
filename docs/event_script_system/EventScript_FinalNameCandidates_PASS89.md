# EventScript Final Name Candidates - Pass 89

Pass 89 converts Pass 88 owner precision tiers into stable candidate names for every EventScript entry.

The key output is:

```text
reports/pass89_eventscript_final_name_candidates.csv
```

Useful fields:

- `pass89_final_name_candidate`
- `pass89_candidate_status`
- `pass89_confirmation_level`
- `pass89_manual_confirmation_action`
- `pass89_manual_prototype_key`
- `pass89_final_alias_line`

Confirmation levels:

- `high`: direct text or direct owner anchor.
- `medium`: domain-specific inference.
- `medium_low`: structural lane candidate that still needs final semantic confirmation.
