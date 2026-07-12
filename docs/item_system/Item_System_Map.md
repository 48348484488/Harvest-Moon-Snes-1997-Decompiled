# Item system map - Decomp Pass 07

This pass maps the held-item layer around `!item_on_hand` (`$091D`) and the shed/tool layer around `!tool_selected`, `!tool_backpack` and `!shed_items_row_1..4`.

## Important RAM symbols

| Symbol | Address | Meaning |
|---|---:|---|
| `!item_on_hand` | `$091D` | Current carried/held item. This includes crops, eggs, mountain items, feed and other carryable objects. |
| `!old_item_on_hand` | `$091E` | Backup of held item used by action transitions. |
| `!tool_selected` | `$0921` | Equipped tool/item slot. This is not always identical to `!item_on_hand`. |
| `!tool_backpack` | `$0923` | Backpack/secondary tool slot. |
| `!watering_can_water` | `$0926` | Water amount. |
| `!seeds_grass_N` | `$0927` | Grass seed bag count. |
| `!seeds_corn_N` | `$0928` | Corn seed bag count. |
| `!seeds_tomato_N` | `$0929` | Tomato seed bag count. |
| `!seeds_potato_N` | `$092A` | Potato seed bag count. |
| `!seeds_turnip_N` | `$092B` | Turnip seed bag count. |
| `!feed_cow_N` | `$092C` | Cow feed count. |
| `!feed_chicks_N` | `$092D` | Chicken feed count. |
| `!shipping_moneyL/H` | `$7F1F07/$7F1F09` | Money pending from same-day shipping. |
| `!shed_items_row_1..4` | `$7F1F00-$7F1F03` | Bitfields for owned shed tools/stock. |

## Renamed code/data symbols

Pass 07 renamed generic labels to make the held item path readable while keeping the build byte-perfect.

| New symbol | Old symbol | Role |
|---|---|---|
| `HeldItem_UseOrInteract_Main` | `SUB_818000` | Main held-item dispatcher. |
| `HeldItem_LoadAnimationFrameData` | `SUB_8180B7` | Loads animation/object metadata for the current held item. |
| `HeldItem_ActionJumpTable` | `DATA8_8197C0` | Indirect JSR table indexed by `!item_on_hand*2`. |
| `HeldItem_AnimationDataPtrTable` | `DATA8_8196AF` | 24-bit metadata pointer table indexed by `!item_on_hand*3`. |
| `HeldItem_ShippingPriceTable` | `Items_Price_Table` | Normal shipping-bin table, two bytes per item. |
| `HeldItem_ShopSellDialogAndPriceTable` | `DATA8_81A094` | Direct-sale dialog/price table, three bytes per item. |
| `HeldItem_TileInteractionTypeTable` | `DATA8_81A2AD` | Tile/object interaction type lookup. |
| `HeldItem_UseSoundFlagTable` | `DATA8_81A308` | Sound-trigger lookup for item use. |
| `HeldItem_DropTargetCoordinateTable` | `DATA8_81A363` | Scripted drop coordinate table. |
| `HeldItem_DroppedOnShippingBin` | `Dropedonsaleplace` | Shipping-bin drop handler. |
| `HeldItem_DroppedOnSpecialPlace` | `Droped_on_special_place` | Fallback/special drop handler. |

## Table layout

The observed item table range is `$00-$5A`, 91 entries.

| Table | SNES address | Entry size | Index | Notes |
|---|---:|---:|---|---|
| `HeldItem_AnimationDataPtrTable` | `$8196AF` | 3 bytes | `item_id*3` | 24-bit pointers to per-item metadata. |
| `HeldItem_ActionJumpTable` | `$8197C0` | 2 bytes | `item_id*2` | Local bank-81 routine pointer used by `JSR.W (table,X)`. |
| `HeldItem_ShippingPriceTable` | `$819FDE` | 2 bytes | `item_id*2` | Low byte: placement/action value. High byte: normal shipping value. |
| `HeldItem_ShopSellDialogAndPriceTable` | `$81A094` | 3 bytes | `item_id*3` | Word: text/dialog id. Byte: direct sale value. |
| `HeldItem_TileInteractionTypeTable` | `$81A2AD` | 1 byte | `item_id` | Used before tile/object interaction routine. |
| `HeldItem_UseSoundFlagTable` | `$81A308` | 1 byte | `item_id` | Non-zero triggers a use sound. |

## Important distinction: `tool_selected` vs `item_on_hand`

The tool list in `ram.asm` uses IDs like `01=sickle`, `02=hoe`, etc. However, `item_on_hand` also uses IDs such as `$14` for egg. Therefore, the two systems overlap but should not be treated as one universal enum yet.

Practical rule for future work:

- Use `tool_selected/tool_backpack` when analyzing equipped tools and shed ownership.
- Use `item_on_hand` when analyzing carrying, dropping, shipping, eating, selling, or placing an item.
- Only merge the ID names when a routine proves they mean the same object in that context.

## Useful generated files

| File | Purpose |
|---|---|
| `reports/decomp_pass07/items/held_item_catalog.csv` | Main machine-readable item table. |
| `reports/decomp_pass07/items/held_item_catalog.md` | Human-readable item catalog with sell/dialog links. |
| `reports/decomp_pass07/items/held_item_catalog_viewer.html` | Searchable item catalog viewer. |
| `reports/decomp_pass07/items/tool_shed_bitfields.csv` | Shed bitfield table. |
| `docs/item_system/Tool_Shed_Bitfields.md` | Explanation of shed item flags. |
| `tools/item_system_catalog.py` | Regenerates the item catalog from the ROM/source. |
