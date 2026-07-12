# Pass 05 - allocated text repoint preview

Input CSV: `examples/pass05_example_text_repoint_edits.csv`

- Overflow start: `$BBBDF8`
- Overflow end exclusive: `$BC0000`
- Total overflow bytes: **16904**
- Allocated entries: **2**
- Used bytes: **562**
- Remaining bytes: **16342**
- No-space entries: **0**

## Files

- `patches/pass05_allocated_text_blocks_preview.asm`
- `patches/pass05_allocated_pointer_table_replacements_preview.asm`
- `reports/decomp_pass05/text/allocation_example/text_repoint_allocation.csv`

## Allocation table

| index | old label | new label | addr | bytes | status |
|---:|---|---|---:|---:|---|
| $02D | `Text_Shop_Closed` | `Text_Repoint_02D_Shop_Closed` | `BBBDF8` | 290 | ALLOCATED |
| $035 | `Text_035_Dialog_HowsGoingWorkTooHard` | `Text_Repoint_035_035_Dialog_HowsGoingWorkTooHard` | `BBBF1A` | 272 | ALLOCATED |

This is a preview. Apply it only after reviewing Bank BB tail usage and then rebuild/test in emulator.