# Pass 05 - text repoint plan

This report plans edited text insertion without mutating the source automatically.
It separates safe in-place edits from edits that require pointer redirection/repointing.

## Summary

- Entries scanned: **1177**
- Edited entries: **3**
- In-place safe edits: **1**
- Repoint-needed edits: **2**
- Encoding errors: **0**
- Unchanged/blank entries: **1174**

## Outputs

- Plan CSV: `reports/decomp_pass05/text/example/text_repoint_plan.csv`
- New text block preview ASM: `patches/pass05_example_repoint_text_blocks_preview.asm`
- Pointer-table replacement preview: `patches/pass05_example_pointer_table_replacements_preview.asm`

## Repoint-needed entries with largest growth

| index | bank | label | old words | new words | delta words | category |
|---:|---|---|---:|---:|---:|---|
| $02D | B6 | `Text_Shop_Closed` | 15 | 145 | 130 | Shop |
| $035 | B6 | `Text_035_Dialog_HowsGoingWorkTooHard` | 72 | 136 | 64 | Dialog |

## How to use this safely

1. Fill `edited_text` in the Pass 04 CSV.
2. Run this planner.
3. Apply `INPLACE_OK` entries directly into the original labels only if you want same-location replacement.
4. For `REPOINT_NEEDED`, place the generated `Text_Repoint_*` blocks in reviewed free/expanded space.
5. Replace only the matching `dl Text_...` pointer-table lines with the generated pointer lines.
6. Rebuild and compare. If you are editing the USA base, byte-perfect is expected only before edits; after edits, use emulator testing and checksum repair.

The planner intentionally does not guess free space blindly. Long strings should be inserted into a known text expansion area or into a manually expanded ROM/bank layout.