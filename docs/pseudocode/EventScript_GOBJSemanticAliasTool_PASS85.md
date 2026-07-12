# EventScript GOBJ Semantic Alias Tool - PASS85

Input: Pass84 visual pointer resolution CSVs.

Algorithm:
1. Promote exact GOBJ id matches into semantic aliases using visual family, id, frames, and gfx bank.
2. Promote exact animation-sequence low-word matches into animation aliases.
3. Preserve runtime CC/WRAM refs as runtime state aliases.
4. Demote source-address and param-only refs to contextual aliases, avoiding false final sprite names.
5. Produce per-entry and per-reference reports.
