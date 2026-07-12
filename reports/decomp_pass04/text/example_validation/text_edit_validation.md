# Pass 04 - text edit validation

Input CSV: `examples/pass04_example_text_edits.csv`

## Summary

- Entries scanned: **1177**
- Edited entries: **3**
- OK and fitting: **3**
- Too long: **0**
- Encoding errors: **0**
- Unchanged/blank: **1174**

## Output

- `reports/decomp_pass04/text/example_validation/text_edit_validation.csv`
- `examples/pass04_example_text_edit_preview.asm`

A text edit is safe only when it is `OK_FITS`. Long text usually needs repointing/free-space work, not just replacement.