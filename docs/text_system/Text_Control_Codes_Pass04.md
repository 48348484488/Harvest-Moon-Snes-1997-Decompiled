# Text Control Codes - Pass 04 Notes

This pass created a control-code usage report from banks `B6-BB`.

The most common non-letter words are:

- `$00B1` / `SPACE`: visible text spacing and padding.
- `$FFFF` / `END`: end of text entry.
- `$00A2` / `LINE`: line/page break marker in extracted text.
- `$FFFE` / `CHOICE_OR_WAIT`: appears in choice/wait style dialogs.
- `$FFFC` and `$FFFD`: variable/control insertions, often used with money, names, animals, counters, or runtime values.
- `$00B2-$00B5`: small control/value markers; exact runtime meaning still needs more trace analysis.

See:

```text
reports/decomp_pass04/text/text_control_code_usage.md
reports/decomp_pass04/text/text_control_code_usage.csv
```

Do not replace unknown control words unless you have tested the dialog in-game.
