# Text Editing Toolchain - Pass 04

This pass adds a safer workflow for editing Harvest Moon SNES text without immediately touching the ASM banks by hand.

## Goal

The previous passes mapped and renamed the text labels. This pass turns that work into an editable pipeline:

1. export all mapped text entries to CSV/JSON;
2. edit only the `edited_text` column;
3. validate whether the edit fits the original byte budget;
4. generate ASM preview blocks for manual insertion;
5. keep the USA rebuild byte-perfect when no actual ASM text edits are applied.

## Main files

- `reports/decomp_pass04/text/text_edit_template.csv`
- `reports/decomp_pass04/text/text_edit_template.json`
- `reports/decomp_pass04/text/text_editor_helper.html`
- `reports/decomp_pass04/text/text_edit_validation.md`
- `reports/decomp_pass04/text/text_control_code_usage.md`
- `examples/pass04_example_text_edits.csv`
- `examples/pass04_example_text_edit_preview.asm`

## Workflow

Open:

```text
reports/decomp_pass04/text/text_edit_template.csv
```

Do not change the identifier columns. Copy a text from `markup_text` into `edited_text`, change it, then run:

```bash
python3 tools/text_edit_validator.py --repo .
```

Only entries with status `OK_FITS` are safe for same-slot replacement.

## Control markup

The editor supports normal characters plus explicit control markup.

Examples:

```text
Hello<LINE>World<END>
Yes No<CHOICE_OR_WAIT>c
Price: <CTRL_FFFC>G
<$00B7>
```

Known control names include:

- `<LINE>` / `<BR>` / newline
- `<SPACE>`
- `<END>`
- `<CHOICE_OR_WAIT>`
- `<CTRL_B2>`, `<CTRL_B3>`, `<CTRL_B4>`, `<CTRL_B5>`
- `<CTRL_FFFC>`, `<CTRL_FFFD>`, `<CTRL_FFFE>`, `<CTRL_FFFF>`
- raw hexadecimal word form: `<$1234>`

## Important limitation

This is still a conservative editor pipeline. It validates replacement text that fits inside the original allocation. If an edit is longer than the original text block, that needs repointing/free-space work. Do not force long text into a short block.
