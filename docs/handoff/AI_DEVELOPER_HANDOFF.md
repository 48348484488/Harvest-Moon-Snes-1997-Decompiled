# AI / Developer Handoff v1.0

## Hard rules

- Do not add ROM files to the repository or ZIP.
- Do not commit generated `.sfc`, `.smc`, `.fig`, `.swc`, or `.rom` files.
- Do not rename labels randomly. Preserve existing semantic labels unless improving them with evidence.
- Do not change table lengths or bank layout without a rebuild validation.
- When modifying code, run a build and record the result.

## Current ground truth

- EventCmd official dispatch is covered 90/90.
- EventScript groups are named 72/72.
- EventScript entries are aliased 1288/1288.
- Residual EventScript markers are closed.
- Generic label families are zeroed in source.
- Pass 97 is a packaging/release pass, not a new reverse-engineering pass.

## Best future tasks

1. Create editors for text/EventScript using the generated CSV reports.
2. Build a safe patching workflow that produces IPS/BPS patches instead of distributing ROMs.
3. Improve comments and pseudocode for user-facing modding.
4. Add regression scripts that verify no ROM files are packaged.
