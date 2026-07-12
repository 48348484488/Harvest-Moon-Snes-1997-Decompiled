# EventScript semantic naming - Pass 79

Pass 79 converts the Pass 78 `EventScript -> Text ID` cross-reference into practical semantic names.

The goal is not to claim every NPC/event owner is final. The goal is to create stable, auditable names for all direct-dialog script entries so the next passes can attach RAM, sprite/GOBJ and NPC evidence.

## Method

1. Read every direct `StartTextBox`-style command from Pass 78.
2. Group rows by EventScript group and entry.
3. Count text categories and inferred roles.
4. Produce group-level semantic names and entry-level proposed aliases.
5. Add safe `P79:` comments to the EventScript master group pointer table.

## Output

- `reports/pass79_eventscript_group_semantic_names.csv`
- `reports/pass79_eventscript_entry_semantic_aliases.csv`
- `reports/pass79_eventscript_semantic_naming.md`
- `reports/pass79_family_romance_festival_semantic_names.md`

## Safety

This pass is byte-neutral. It does not change data directives, only comments and documentation metadata.
