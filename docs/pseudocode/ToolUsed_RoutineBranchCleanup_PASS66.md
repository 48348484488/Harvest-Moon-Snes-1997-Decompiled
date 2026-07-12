# ToolUsed routine branch cleanup - Pass 66

The tool-use dispatcher bank contains handlers for sickle, hoe, hammer, axe, seeds, watering can, gold tools, feed placement, blue feather and other held-item actions.

Pass 66 did not reinterpret game logic bytecode. It renamed remaining local `.CODE_xxxxxx` branch anchors inside `bank_82_toolused_subrutines.asm` to names scoped by the owning `ToolUsed*` routine, for example:

```asm
.CODE_8295CA -> .ToolUsedHammer_Branch_8295CA
.CODE_82A473 -> .ToolUsedChickenFeed_Branch_82A473
```

This keeps traceability to the original ROM address while making the source easier to search and maintain.

`MapTilePatchRuntime_AllocateVisualEffectObjectSlot` is the former `CODE_81A500`. It allocates/fills a runtime visual-effect/object slot from scratch RAM fields such as `$0974-$0984`, then calls `GameOBJ_AllocateAndInitNewSlot`. Tool-use routines call it after queuing tile/object visual changes.
