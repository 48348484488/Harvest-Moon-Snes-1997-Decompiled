# Handoff - After Pass 89

## Current state

- Build/rebuild is still 100% byte-perfect.
- EventCmd official table is 100% audited.
- EventScript real residuals are 0.
- Every EventScript group has a semantic name.
- Every EventScript entry has an alias, owner lane, and final-name candidate.

## Next best pass

Pass 90 should reduce the `medium_low` structural lane candidates by validating prototype groups against NPC/festival/cutscene/object tables.

Primary file:

```text
reports/pass89_manual_prototype_queue.csv
```

Recommended target:

- prioritize highest-entry prototype keys first
- verify exact NPC/festival/cutscene/object names
- promote validated rows from `medium_low` to `medium` or `high`
