# DECOMP PASS 89 - EventScript Final Name Candidate Layer

Goal: continue the human/semantic decompilation after Pass 88 by assigning a stable final-name candidate to every EventScript entry.

## Closed in this pass

- 1288/1288 EventScript entries received `pass89_final_name_candidate`.
- 1288/1288 EventScript entries received candidate status, confidence level, and manual prototype key.
- Pass 88 broad/manual review problem is now grouped into prototype keys instead of isolated raw entries.
- Rebuild remains byte-perfect against the clean USA ROM.
- Final package remains NO-ROM.

## Main outputs

- `reports/pass89_eventscript_final_name_candidates.csv`
- `reports/pass89_final_name_candidate_summary.csv`
- `reports/pass89_manual_prototype_queue.csv`
- `reports/pass89_group_final_name_candidate_summary.csv`
- `reports/pass89_owner_final_candidate_summary.csv`
- `reports/pass89_eventscript_final_name_candidate_layer.md`

## Important interpretation

This pass does not claim every name is confirmed final canon. It creates a deterministic candidate layer:

- high: direct text/owner anchor
- medium: domain inferred candidate
- medium_low: structural lane candidate that still needs final manual confirmation

The next pass should reduce the medium_low prototype queue by validating exact NPC/festival/cutscene/object names.
