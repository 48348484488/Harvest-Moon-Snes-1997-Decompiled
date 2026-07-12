# Pseudocodigo - Held Item / Pickup Object Interaction Core

```text
HeldItemObject_DispatchPickupSaleAndPlacementStates():
    switch runtime_substate_0976:
        case 0:
            HandlePickupPromptSaleOrPlacement()
        case 2:
            wait/continue sale or placement flow
        case 3:
            finalize carried object flow
        case outros:
            return

HeldItemObject_HandlePickupPromptSaleOrPlacement():
    if prompt/input still active:
        return

    if object has sell price:
        result = AddMoney(price)
        if result != 0:
            show money-full/failure text
            runtime_substate_0976 = failure_state
        else:
            show sale success text
            runtime_substate_0976 = success_state
        return

    if object should be placed on map:
        PlayerTarget_CalculateTileInFront()
        MapTilePatch_ApplyObjectAndRefreshVRAM(tile_object, target_x, target_y)
        clear carried object and runtime slot
        return

    clear carried object and runtime slot

InventoryTool_PickupToolFromMapObject():
    if tool_backpack is empty:
        tool_backpack = tool_selected

    tool_selected = item_object_id - tool_pickup_base
    clear corresponding tool-shed bitfield
    player_action = idle
    clear blocked/carry state bit
    release attached GameOBJ
    clear item_on_hand
    play pickup/tool sound
```
