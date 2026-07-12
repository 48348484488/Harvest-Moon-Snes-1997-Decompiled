# Bank 81 Dispatch Alias Tables - Pass 62

Pass 62 removes the last `DATA8_` aliases referenced by `bank_81.asm`.

## Map entry tile-patch table

`MapEntryTilePatch_AreaDispatchTable` is indexed by `!tilemap_to_load`. Known areas already had semantic names. The remaining entries `28` through `5F` are now explicitly named as dispatch aliases:

```text
MapEntryTilePatch_DispatchArea28 .. MapEntryTilePatch_DispatchArea5F
```

These names are intentionally conservative. They mark the entries as map-entry tile-patch handlers without pretending to know every final map/room name yet.

## Player action table

`PlayerActionPointerTable` dispatches routines based on `!player_action` / `$096E`. The last low-bank aliases that were still named `DATA8_` are now contextual player-action dispatch entries.

Key directly inferred entries:

```text
PlayerAction_PickupMapObjectItem74
PlayerAction_PickupMapObjectItem75
PlayerAction_ShopOrNpcPurchaseDialogEntry2E
PlayerAction_ShopOrNpcPurchaseDialogEntry2F
```

Remaining entries are named by dispatch index until their full gameplay meaning is proven.
