# Pseudocodigo - Inventory / Tool Menu Core

## Devolver ferramentas ao tool shed

```text
function ReturnHeldToolsToShedBitfields():
    if tool_selected != 0:
        row, mask = InventoryTool_BitfieldSlotAndPickupTileTable[tool_selected]
        shed_items_row[row] |= mask
        tool_selected = 0

    if tool_backpack != 0:
        row, mask = InventoryTool_BitfieldSlotAndPickupTileTable[tool_backpack]
        shed_items_row[row] |= mask
        tool_backpack = 0
```

## Redesenhar tool shed

```text
function ReplaceTilesToolshed():
    for slot in 1..24:
        ShopDisplay_DrawConditionalItemTile(
            item_slot = slot,
            display_group = tool_shed,
            rule = owned_or_visible
        )

    if special_flag_7F1F68_2000 is set:
        draw additional object/tile in shed
```

## Desenho condicional de item em loja/interior

```text
function ShopDisplay_DrawConditionalItemTile(item_index, group, rule):
    record = ShopDisplay_ItemTilePlacementTable[item_index]
    owned = shed_items_row[record.bitfield_row] & record.bitfield_mask

    if rule == show_when_not_owned and owned:
        return

    if rule == show_when_owned and not owned:
        return

    draw tile/object at record.position
```

## Item carregado na mao

```text
function SetItemOnHand(item_id):
    item_on_hand = item_id
    player_action = carrying_item_action

function ClearItemOnHand():
    item_on_hand = 0
```
