# Safe Modding Guide v1.0

Use this order for safe edits.

## Safe first edits

1. Text/dialog changes.
2. EventScript text references.
3. Simple constants/tables.
4. Visual/GOBJ aliases or documentation-only changes.

## Riskier edits

1. Repointing scripts.
2. Inserting new code across bank boundaries.
3. Changing table sizes.
4. Moving event pointer tables.
5. Editing low-level save/SRAM routines.

## Recommended workflow

1. Make one small change.
2. Build.
3. Compare MD5 if you expect byte-perfect output, or document intentional changes if creating a modded ROM.
4. Keep a changelog.
5. Never package ROM artifacts in the shared ZIP.

## Where to look

| Goal | Start here |
|---|---|
| Event scripts | `reports/pass94_*`, `reports/pass95_*`, `docs/event_script_system/` |
| Text/dialogue | `reports/pass78_*`, text banks in `src/` |
| Visual/GOBJ | `reports/pass83_*` to `reports/pass86_*` |
| NPC/scene ownership | `reports/pass87_*` to `reports/pass95_*` |
| Build validation | `VALIDACAO_BUILD_PASS96.md`, `VALIDACAO_BUILD_PASS97.md` |
