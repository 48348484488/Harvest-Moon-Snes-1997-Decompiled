# Pass 66 - ToolUsed CODE cleanup

Closed the remaining generic CODE labels in `bank_82_toolused_subrutines.asm` by replacing local branch labels with ToolUsed handler-scoped names.

Also renamed the shared visual/effect object allocation routine used by tool-use handlers:

- `CODE_81A500` -> `MapTilePatchRuntime_AllocateVisualEffectObjectSlot`

Local branch labels renamed: 75

This pass is label-only/comment-only and does not alter assembled bytes.
