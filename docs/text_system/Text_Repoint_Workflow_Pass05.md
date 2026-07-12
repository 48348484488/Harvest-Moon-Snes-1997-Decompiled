# Text Repoint Workflow - Pass 05

This workflow is for text edits that are bigger than the original text block.

## Normal short edit

If an edit fits the original budget, use the Pass 04 validator. A fitting edit can replace the original label block.

Status:

```text
INPLACE_OK
```

## Long edit

If an edit is too large, it cannot safely replace the original block in place.

Status:

```text
REPOINT_NEEDED
```

For those edits, Pass 05 generates:

1. a new `Text_Repoint_*` label;
2. a `dw` block containing the encoded text;
3. a replacement `dl` line for `Text_Pointer_Table`.

## Commands

### 1. Create layout report

```bash
python3 tools/text_bank_layout_report.py --repo .
```

Read:

```text
reports/decomp_pass05/text/text_bank_layout.md
```

### 2. Plan edits from the CSV

```bash
python3 tools/text_repoint_planner.py --repo .
```

Read:

```text
reports/decomp_pass05/text/text_repoint_plan.md
```

### 3. Test with the example long edits

```bash
python3 tools/text_repoint_planner.py --repo . \
  --csv examples/pass05_example_text_repoint_edits.csv \
  --outdir reports/decomp_pass05/text/example \
  --asm-out patches/pass05_example_repoint_text_blocks_preview.asm \
  --pointer-out patches/pass05_example_pointer_table_replacements_preview.asm
```

### 4. Allocate long edits into Bank BB tail preview

```bash
python3 tools/text_repoint_allocator.py --repo .
```

Read:

```text
reports/decomp_pass05/text/allocation_example/text_repoint_allocation.md
```

## Bank BB tail

The current text export shows:

```text
$BBBDF8-$BC0000 = 16904 bytes
```

This region is zero-filled in the current source and is the safest identified candidate for text overflow inside the original ROM layout.

## Manual application idea

For a long edit:

1. insert the generated `Text_Repoint_*` block into reviewed overflow space;
2. replace the matching pointer-table entry in `src/code_banks/bank_83.asm`;
3. rebuild;
4. test the dialogue in emulator.

Example pointer-table replacement shape:

```asm
dl Text_Repoint_02D_Shop_Closed
```

## Warning

Do not repoint blindly. A wrong pointer can show garbage text, read into another table, or crash the game. Always test in-game after rebuild.
