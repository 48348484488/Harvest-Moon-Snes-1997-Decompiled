# Pseudocode - held item dispatcher

This is a high-level reading of `HeldItem_UseOrInteract_Main` and related tables. It is not a C conversion yet; it is reverse-engineering documentation.

```c
void HeldItem_UseOrInteract_Main(void) {
    temp_item = item_on_hand;

    // Choose animation/object metadata based on held item and player direction.
    direction_entry = 2 + player_direction;
    HeldItem_LoadAnimationFrameData(direction_entry);

    // Cache player position and calculate tile in front.
    temp_drop_x = player_pos_X;
    temp_drop_y = player_pos_Y + 2;
    CalculateTileInFront(...);

    // Table 1: item-specific tile interaction type.
    interaction_type = HeldItem_TileInteractionTypeTable[temp_item];
    if (interaction_type != 0) {
        tile_value = current_object_metadata[interaction_type * 4];
        CODE_81A688(tile_in_front_x, tile_in_front_y, tile_value);
    }

    // Table 2: sound flag.
    if (HeldItem_UseSoundFlagTable[temp_item] != 0) {
        play_held_item_use_sound();
    }
}
```

## Drop / shipping path

```c
void HeldItem_DroppedOnShippingBin(void) {
    item = temp_item_0984;
    entry = HeldItem_ShippingPriceTable[item];

    if (entry.shipping_value == 0) {
        HeldItem_DroppedOnSpecialPlace();
        return;
    }

    if (hour < 17) {
        shipping_money += entry.shipping_value;
        set_shipping_bin_has_item_flag();
    }

    remove_or_hide_dropped_object();
    item_on_hand = 0;
}
```

## Direct sale / shop-like path

The direct-sale path uses `HeldItem_ShopSellDialogAndPriceTable[item]`:

```c
struct DirectSellEntry {
    uint16 text_id;
    uint8 value;
};
```

Observed entries link mountain/crop/animal items to dialog IDs around `$350-$35E`, for example egg/crop/mushroom sale confirmations.

## Remaining uncertainty

- Some price values are raw internal values; display conversion still needs confirmation.
- Some item IDs have different meanings depending on whether they come from `tool_selected` or `item_on_hand`.
- Several IDs from `$1B-$5A` still need naming from behavior routines and map/event sources.
