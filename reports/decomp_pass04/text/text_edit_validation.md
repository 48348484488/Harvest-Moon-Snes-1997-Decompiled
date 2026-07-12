# Pass 04 - text edit validation

Input CSV: `reports/decomp_pass04/text/text_edit_template.csv`

## Summary

- Entries scanned: **1177**
- Edited entries: **0**
- OK and fitting: **0**
- Too long: **0**
- Encoding errors: **0**
- Unchanged/blank: **1177**

## Output

- `reports/decomp_pass04/text/text_edit_validation.csv`
- `patches/pass04_text_edit_preview.asm`

A text edit is safe only when it is `OK_FITS`. Long text usually needs repointing/free-space work, not just replacement.