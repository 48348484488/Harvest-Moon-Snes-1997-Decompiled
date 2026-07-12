# Pseudocodigo - Shipping / Money Core

```c
void HeldItem_DroppedOnShippingBin(void) {
    item = item_on_hand;
    value = HeldItem_ShippingPriceTable[item].shipping_value;

    if (value == 0) {
        HeldItem_DroppedOnSpecialPlace();
        return;
    }

    if (hour < 17) {
        shipping_money += value;
        shipping_flags |= SHIPPING_BIN_HAS_ITEMS;
    }

    remove_item_from_hand_and_play_drop_animation();
}

void ShippingScene_StartAt5PM(void) {
    if (hour != 17) return;
    if (tilemap_to_load >= 4) return;

    inputstate = 0;
    shipping_scene_flags |= START_COLLECTION_SCENE;
    load_shipping_collection_cutscene();
}

void ShippingScene_ShowDailyEarningsDialogue(void) {
    if (!(shipping_scene_flags & SHOW_DAILY_DIALOGUE)) return;
    if (game_state & BLOCK_DIALOGUE_FLAG) return;

    inputstate = 2;

    if (shipping_money != 0)
        StartTextBox(TEXT_DAILY_SHIPPING_TOTAL);
    else
        StartTextBox(TEXT_DAILY_SHIPPING_NOTHING);

    shipping_scene_flags &= ~START_COLLECTION_SCENE;
}

uint16_t AddMoney(int24 amount) {
    int24 next = money + amount;

    if (next < 0)
        return 1;

    if (next > 0x0F423F)
        money = 0x0F423F;
    else
        money = next;

    return 0;
}

void NightlyDepositShippingMoney(void) {
    AddMoney(shipping_money);
    shipping_money = 0;
}
```
