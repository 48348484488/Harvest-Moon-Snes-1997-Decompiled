# Decomp Pass 07 - Held item / inventory catalog

This report maps the held-item system around `!item_on_hand` (`$091D`) and the tables in bank `$81`.
The values are extracted from the clean USA ROM, not guessed from comments only.

## Main findings

- Item ID range covered by the observed tables: `$00-$5A` (91 entries).
- `HeldItem_ActionJumpTable` is an indirect behavior routine table indexed by `!item_on_hand * 2`.
- `HeldItem_AnimationDataPtrTable` is indexed by `!item_on_hand * 3` and provides 24-bit metadata pointers.
- `HeldItem_ShippingPriceTable` is two bytes per item: the low byte is used by placement/tile logic, the high byte is used as normal shipping value.
- `HeldItem_ShopSellDialogAndPriceTable` is three bytes per item: word = text/dialog id, byte = direct-sale value.
- The code checks time before crediting normal shipping: the drop handler rejects same-day value addition after hour `$11`/17 depending on path comments; more behavioral testing is still needed.

## Notable item IDs

| ID | Working name | Action | Ship value | Shop text | Direct value | Sound |
|---:|---|---:|---:|---|---:|---:|
| $00 | None / empty hand |  | 0 | Text_Forecast_Spring_Sunny | 0 | 0 |
| $01 | Mushroom / generic carried item 01 | 8180FE | 15 | Text_358_Mountain_MushroomAboutGMoneyH | 20 | 1 |
| $02 | Poisonous mushroom / generic carried item 02 | 818102 | 20 | Text_359_Animal_PoisonousMushroomMedicineCompoundedAbout | 30 | 1 |
| $03 | Wild grape / generic carried item 03 | 818106 | 15 | Text_35B_Mountain_AhBerryWildGrapeSmells | 20 | 1 |
| $04 | Tropical fruit / generic carried item 04 | 81810A | 20 | Text_35C_Dialog_BoyTropicalFruitAboutG | 30 | 1 |
| $05 | Fullmoon Plant berry / rare mountain item | 81810E | 60 | Text_35D_Shop_AhRareThingAberryFullmoon | 60 | 1 |
| $06 | Unknown carried item 06; shop text 0313 special case | 818112 | 0 | Text_313_Dialog_SorryButAccept | 0 | 0 |
| $07 | Fish | 818116 | 30 | Text_35E_Shop_VeryFreshFishBuyingG | 30 | 0 |
| $08 | Unknown carried item 08 | 81811A | 0 | Text_Forecast_Spring_Sunny | 0 | 1 |
| $09 | Unknown carried item 09 | 81811E | 0 | Text_Forecast_Spring_Sunny | 0 | 1 |
| $0A | Unknown carried item 0A | 818122 | 0 | Text_Forecast_Spring_Sunny | 0 | 1 |
| $0B | Unknown carried item 0B | 81811E | 0 | Text_Forecast_Spring_Sunny | 0 | 1 |
| $0C | Unknown carried item 0C | 81811E | 0 | Text_Forecast_Spring_Sunny | 0 | 1 |
| $0D | Placed/field item candidate 0D | 818126 | 0 | Text_Forecast_Spring_Sunny | 0 | 1 |
| $0E | Placed/field item candidate 0E | 81812A | 0 | Text_Forecast_Spring_Sunny | 0 | 1 |
| $0F | Placed/field item candidate 0F | 81812E | 0 | Text_Forecast_Spring_Sunny | 0 | 1 |
| $10 | Corn | 818132 | 12 | Text_353_Shop_CornBuyingGButMoney | 24 | 1 |
| $11 | Tomato | 81814A | 10 | Text_354_Shop_RipenedTomatoBuyingGBut | 20 | 1 |
| $12 | Potato | 818162 | 8 | Text_355_Shop_PotatoBuyingGButMoney | 16 | 1 |
| $13 | Turnip | 81817A | 6 | Text_356_Shop_TurnipGoodShapeBuyingG | 12 | 1 |
| $14 | Egg | 818192 | 5 | Text_357_Animal_FreshEggBuyingGBut | 10 | 0 |
| $15 | Milk S / milk item candidate | 818196 | 15 | Text_350_Animal_MilkBuyingGdoAgreeMoney | 20 | 0 |
| $16 | Milk M / milk item candidate | 81819A | 25 | Text_351_Animal_MilkBuyingGbutMoneyHv | 30 | 0 |
| $17 | Milk L / milk item candidate | 81819E | 35 | Text_352_Animal_MilkBuyingGbutMoneyHw | 40 | 0 |
| $18 | Good herb / herb item | 8181A2 | 20 | Text_35A_Dialog_GoodHerbAboutGMoney | 20 | 1 |
| $19 | Chicken feed when carried from shed | 8181A6 | 0 | Text_313_Dialog_SorryButAccept | 0 | 1 |
| $1A | Cow feed when carried from shed | 8181AA | 0 | Text_Forecast_Spring_Sunny | 0 | 1 |
| $25 | Special carried item; shop text 0313 special case | 8183BB | 0 | Text_313_Dialog_SorryButAccept | 0 | 0 |
| $26 | Special carried item; shop text 0313 special case | 8183BF | 0 | Text_313_Dialog_SorryButAccept | 0 | 0 |
| $57 | Animal/field generated carried item 57 | 81812E | 0 | Text_Forecast_Spring_Sunny | 0 | 1 |
| $58 | Event/animal carried item 58 | 8187B7 | 0 | Text_Forecast_Spring_Sunny | 0 | 0 |
| $59 | Event/animal carried item 59 | 8187BB | 0 | Text_Forecast_Spring_Sunny | 0 | 0 |
| $5A | Event/animal carried item 5A | 8187BF | 0 | Text_Forecast_Spring_Sunny | 0 | 0 |

## Sell/dialog-linked entries

### Item $01 - Mushroom / generic carried item 01
- Action pointer: `8180FE`
- Normal shipping value raw: `15`
- Direct sell value raw: `20`
- Direct sell text: `358` `Text_358_Mountain_MushroomAboutGMoneyH`
- Text preview: Mushroom. How about <CTRL_B4><CTRL_B2><CTRL_B2>G for it? Yes No Money <CTRL_FFFC>h.<CTRL_B2>G<CHOICE_OR_WAIT>c

### Item $02 - Poisonous mushroom / generic carried item 02
- Action pointer: `818102`
- Normal shipping value raw: `20`
- Direct sell value raw: `30`
- Direct sell text: `359` `Text_359_Animal_PoisonousMushroomMedicineCompoundedAbout`
- Text preview: It's a poisonous mushroom. It can be a medicine when it's compounded well. How about <CTRL_B5><CTRL_B2><CTRL_B2>G for it? Yes No Money <CTRL_FFFC>h?<CTRL_B2>G<CHOICE_OR_WAIT>c

### Item $03 - Wild grape / generic carried item 03
- Action pointer: `818106`
- Normal shipping value raw: `15`
- Direct sell value raw: `20`
- Direct sell text: `35B` `Text_35B_Mountain_AhBerryWildGrapeSmells`
- Text preview: Ah: it's a berry of wild grape. Smells good. How about <CTRL_B4><CTRL_B2><CTRL_B2>G for it? Yes No Money <CTRL_FFFC>h!<CTRL_B2>G<CHOICE_OR_WAIT>c

### Item $04 - Tropical fruit / generic carried item 04
- Action pointer: `81810A`
- Normal shipping value raw: `20`
- Direct sell value raw: `30`
- Direct sell text: `35C` `Text_35C_Dialog_BoyTropicalFruitAboutG`
- Text preview: Oh boy: it's a tropical fruit:isn't it? How about <CTRL_B5><CTRL_B2><CTRL_B2>G for it? Yes No Money <CTRL_FFFC>h:<CTRL_B2>G<CHOICE_OR_WAIT>c

### Item $05 - Fullmoon Plant berry / rare mountain item
- Action pointer: `81810E`
- Normal shipping value raw: `60`
- Direct sell value raw: `60`
- Direct sell text: `35D` `Text_35D_Shop_AhRareThingAberryFullmoon`
- Text preview: Ah:what a rare thing, It's aberry of Fullmoon Plant. I'm buying it for <$00B8><CTRL_B2><CTRL_B2>G but how about it? Yes No Money <CTRL_FFFC>h<$003B><CTRL_B2>G<CHOICE_OR_WAIT>c

### Item $06 - Unknown carried item 06; shop text 0313 special case
- Action pointer: `818112`
- Normal shipping value raw: `0`
- Direct sell value raw: `0`
- Direct sell text: `313` `Text_313_Dialog_SorryButAccept`
- Text preview: Sorry but we can't accept that.

### Item $07 - Fish
- Action pointer: `818116`
- Normal shipping value raw: `30`
- Direct sell value raw: `30`
- Direct sell text: `35E` `Text_35E_Shop_VeryFreshFishBuyingG`
- Text preview: It's a very fresh fish. I'm buying it for <CTRL_B5><CTRL_B2><CTRL_B2>G but how about it? Yes No Money <CTRL_FFFC>h<$003C><CTRL_B2>G<CHOICE_OR_WAIT>c

### Item $10 - Corn
- Action pointer: `818132`
- Normal shipping value raw: `12`
- Direct sell value raw: `24`
- Direct sell text: `353` `Text_353_Shop_CornBuyingGButMoney`
- Text preview: Corn? Well...I'm buying it for <CTRL_B4><$00B6><CTRL_B2>G but is it OK? Yes No Money <CTRL_FFFC>hX<CTRL_B2>G<CHOICE_OR_WAIT>c

### Item $11 - Tomato
- Action pointer: `81814A`
- Normal shipping value raw: `10`
- Direct sell value raw: `20`
- Direct sell text: `354` `Text_354_Shop_RipenedTomatoBuyingGBut`
- Text preview: Yes:it's a well ripened tomato. I'm buying it for <CTRL_B4><CTRL_B2><CTRL_B2>G but is it OK? Yes No Money <CTRL_FFFC>hY<CTRL_B2>G<CHOICE_OR_WAIT>c

### Item $12 - Potato
- Action pointer: `818162`
- Normal shipping value raw: `8`
- Direct sell value raw: `16`
- Direct sell text: `355` `Text_355_Shop_PotatoBuyingGButMoney`
- Text preview: Potato? Well:I'm buying it for <CTRL_B3><$00B8><CTRL_B2>G but is it OK? Yes No Money <CTRL_FFFC>hZ<CTRL_B2>G<CHOICE_OR_WAIT>caaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa

### Item $13 - Turnip
- Action pointer: `81817A`
- Normal shipping value raw: `6`
- Direct sell value raw: `12`
- Direct sell text: `356` `Text_356_Shop_TurnipGoodShapeBuyingG`
- Text preview: Turnip? Good shape:isn't it? I'm buying it for <CTRL_B3><CTRL_B4><CTRL_B2>G but is it OK? Yes No Money <CTRL_FFFC>h'<CTRL_B2>G<CHOICE_OR_WAIT>c

### Item $14 - Egg
- Action pointer: `818192`
- Normal shipping value raw: `5`
- Direct sell value raw: `10`
- Direct sell text: `357` `Text_357_Animal_FreshEggBuyingGBut`
- Text preview: Isn't it a fresh egg? I'm buying it for <CTRL_B3><CTRL_B2><CTRL_B2>G but is itOK? Yes No Money <CTRL_FFFC>h,<CTRL_B2>G<CHOICE_OR_WAIT>c

### Item $15 - Milk S / milk item candidate
- Action pointer: `818196`
- Normal shipping value raw: `15`
- Direct sell value raw: `20`
- Direct sell text: `350` `Text_350_Animal_MilkBuyingGdoAgreeMoney`
- Text preview: Milk? I'm buying it for <CTRL_B4><CTRL_B2><CTRL_B2>GDo you agree? Yes No Money <CTRL_FFFC>hU<CTRL_B2>G<CHOICE_OR_WAIT>c

### Item $16 - Milk M / milk item candidate
- Action pointer: `81819A`
- Normal shipping value raw: `25`
- Direct sell value raw: `30`
- Direct sell text: `351` `Text_351_Animal_MilkBuyingGbutMoneyHv`
- Text preview: Milk? I'm buying it for <CTRL_B5><CTRL_B2><CTRL_B2>Gbut is it OK? Yes No Money <CTRL_FFFC>hV<CTRL_B2>G<CHOICE_OR_WAIT>c

### Item $17 - Milk L / milk item candidate
- Action pointer: `81819E`
- Normal shipping value raw: `35`
- Direct sell value raw: `40`
- Direct sell text: `352` `Text_352_Animal_MilkBuyingGbutMoneyHw`
- Text preview: Milk? I'm buying it for <$00B6><CTRL_B2><CTRL_B2>Gbut is it OK? Yes No Money <CTRL_FFFC>hW<CTRL_B2>G<CHOICE_OR_WAIT>c

### Item $18 - Good herb / herb item
- Action pointer: `8181A2`
- Normal shipping value raw: `20`
- Direct sell value raw: `20`
- Direct sell text: `35A` `Text_35A_Dialog_GoodHerbAboutGMoney`
- Text preview: Oh yes:it's a good herb. Well: how about <CTRL_B4><CTRL_B2><CTRL_B2>G for it? Yes No Money <CTRL_FFFC>h"<CTRL_B2>G<CHOICE_OR_WAIT>c

### Item $19 - Chicken feed when carried from shed
- Action pointer: `8181A6`
- Normal shipping value raw: `0`
- Direct sell value raw: `0`
- Direct sell text: `313` `Text_313_Dialog_SorryButAccept`
- Text preview: Sorry but we can't accept that.

### Item $25 - Special carried item; shop text 0313 special case
- Action pointer: `8183BB`
- Normal shipping value raw: `0`
- Direct sell value raw: `0`
- Direct sell text: `313` `Text_313_Dialog_SorryButAccept`
- Text preview: Sorry but we can't accept that.

### Item $26 - Special carried item; shop text 0313 special case
- Action pointer: `8183BF`
- Normal shipping value raw: `0`
- Direct sell value raw: `0`
- Direct sell text: `313` `Text_313_Dialog_SorryButAccept`
- Text preview: Sorry but we can't accept that.

## Xrefs for renamed item tables

### `HeldItem_UseOrInteract_Main`
main dispatcher for current !item_on_hand.
References found: `2`
- `src/code_banks/bank_81.asm:5: HeldItem_UseOrInteract_Main:`
- `src/code_banks/bank_81.asm:6705: JSL.L HeldItem_UseOrInteract_Main                    ;81C9B3;818000;`

### `HeldItem_LoadAnimationFrameData`
loads graphics/placement metadata for held item.
References found: `19`
- `src/code_banks/bank_80.asm:3202: JSL.L HeldItem_LoadAnimationFrameData`
- `src/code_banks/bank_81.asm:21: JSL.L HeldItem_LoadAnimationFrameData                          ;818022;8180B7;`
- `src/code_banks/bank_81.asm:96: HeldItem_LoadAnimationFrameData:`
- `src/code_banks/bank_81.asm:138: RTL                                  ;8180FD;      ;END_HeldItem_LoadAnimationFrameData`
- `src/code_banks/bank_81.asm:1549: JSL.L HeldItem_LoadAnimationFrameData                          ;818B70;8180B7;`
- `src/code_banks/bank_81.asm:1656: JSL.L HeldItem_LoadAnimationFrameData                          ;818C43;8180B7;`
- `src/code_banks/bank_81.asm:1670: JSL.L HeldItem_LoadAnimationFrameData                          ;818C61;8180B7;`
- `src/code_banks/bank_81.asm:1753: JSL.L HeldItem_LoadAnimationFrameData                          ;818D20;8180B7;`
- `src/code_banks/bank_81.asm:2090: JSL.L HeldItem_LoadAnimationFrameData                          ;818FEF;8180B7;`
- `src/code_banks/bank_81.asm:2108: JSL.L HeldItem_LoadAnimationFrameData                          ;819015;8180B7;`
- `src/code_banks/bank_81.asm:2149: JSL.L HeldItem_LoadAnimationFrameData                          ;819068;8180B7;`
- `src/code_banks/bank_81.asm:2163: JSL.L HeldItem_LoadAnimationFrameData                          ;819086;8180B7;`
- `src/code_banks/bank_81.asm:2270: JSL.L HeldItem_LoadAnimationFrameData                          ;81915D;8180B7;`
- `src/code_banks/bank_81.asm:2290: JSL.L HeldItem_LoadAnimationFrameData                          ;819187;8180B7;`
- `src/code_banks/bank_81.asm:2308: JSL.L HeldItem_LoadAnimationFrameData                          ;8191B5;8180B7;`
- `src/code_banks/bank_81.asm:2375: JSL.L HeldItem_LoadAnimationFrameData                          ;819247;8180B7;`
- `src/code_banks/bank_81.asm:2389: JSL.L HeldItem_LoadAnimationFrameData                          ;819265;8180B7;`
- `src/code_banks/bank_81.asm:2510: JSL.L HeldItem_LoadAnimationFrameData                          ;819362;8180B7;`
- `src/code_banks/bank_81.asm:2877: JSL.L HeldItem_LoadAnimationFrameData                          ;819667;8180B7;`

### `HeldItem_ActionJumpTable`
indirect behavior routine table indexed by item_on_hand.
References found: `2`
- `src/code_banks/bank_81.asm:87: JSR.W (HeldItem_ActionJumpTable,X)               ;8180A6;8197C0;`
- `src/code_banks/bank_81.asm:2933: HeldItem_ActionJumpTable: db $FF,$FF,$FE,$80,$02,$81,$06,$81,$0A,$81,$0E,$81,$12,$81,$16,$81;8197C0;      ;`

### `HeldItem_AnimationDataPtrTable`
24-bit metadata pointer table indexed by item_on_hand.
References found: `4`
- `src/code_banks/bank_81.asm:95: ;;;;;;;; PASS07: loads per-held-item animation/object metadata from HeldItem_AnimationDataPtrTable. Y selects directional/pose sub-entry.`
- `src/code_banks/bank_81.asm:108: LDA.L HeldItem_AnimationDataPtrTable,X                 ;8180CA;8196AF;`
- `src/code_banks/bank_81.asm:113: LDA.L HeldItem_AnimationDataPtrTable,X                 ;8180D4;8196AF;`
- `src/code_banks/bank_81.asm:2913: HeldItem_AnimationDataPtrTable: db $FF,$FF,$FF,$76,$98,$81,$9A,$98,$81,$BE,$98,$81,$E2,$98,$81,$06;8196AF;      ;`

### `HeldItem_ShippingPriceTable`
normal shipping-bin placement/price table.
References found: `6`
- `src/code_banks/bank_81.asm:1826: LDA.L HeldItem_ShippingPriceTable,X                 ;818DC8;819FDE;`
- `src/code_banks/bank_81.asm:2323: LDA.L HeldItem_ShippingPriceTable,X                 ;8191D5;819FDE;`
- `src/code_banks/bank_81.asm:2334: LDA.L HeldItem_ShippingPriceTable,X                 ;8191EB;819FDE;`
- `src/code_banks/bank_81.asm:2577: LDA.L HeldItem_ShippingPriceTable,X`
- `src/code_banks/bank_81.asm:2587: LDA.L HeldItem_ShippingPriceTable,X`
- `src/code_banks/bank_81.asm:3067: HeldItem_ShippingPriceTable:     db $00,$00,$00,$0F,$00,$14,$00,$0F,$00,$14,$00,$3C,$00,$00,$00,$1E;819FDE;      ;`

### `HeldItem_ShopSellDialogAndPriceTable`
direct-sale dialog/price table.
References found: `5`
- `src/code_banks/bank_81.asm:2006: LDA.L HeldItem_ShopSellDialogAndPriceTable,X                 ;818F40;81A094;`
- `src/code_banks/bank_81.asm:2039: LDA.L HeldItem_ShopSellDialogAndPriceTable,X                 ;818F7D;81A094;`
- `src/code_banks/bank_81.asm:2069: LDA.L HeldItem_ShopSellDialogAndPriceTable,X                 ;818FC0;81A094;`
- `src/code_banks/bank_81.asm:2259: LDA.L HeldItem_ShopSellDialogAndPriceTable,X                 ;819143;81A094;`
- `src/code_banks/bank_81.asm:3081: HeldItem_ShopSellDialogAndPriceTable: db $00,$00,$00,$58,$03,$14,$59,$03,$1E,$5B,$03,$14,$5C,$03,$1E,$5D;81A094;      ;`

### `HeldItem_TileInteractionTypeTable`
front-tile interaction lookup.
References found: `2`
- `src/code_banks/bank_81.asm:43: LDA.L HeldItem_TileInteractionTypeTable,X                 ;818056;81A2AD;`
- `src/code_banks/bank_81.asm:3119: HeldItem_TileInteractionTypeTable: db $00,$01,$01,$01,$01,$03,$00,$00,$00,$02,$02,$02,$01,$02,$02,$02;81A2AD;      ;`

### `HeldItem_UseSoundFlagTable`
sound trigger lookup.
References found: `2`
- `src/code_banks/bank_81.asm:66: LDA.L HeldItem_UseSoundFlagTable,X                 ;818081;81A308;`
- `src/code_banks/bank_81.asm:3127: HeldItem_UseSoundFlagTable: db $00,$01,$01,$01,$01,$01,$00,$00,$01,$01,$01,$01,$01,$01,$01,$01;81A308;      ;`

### `HeldItem_DropTargetCoordinateTable`
scripted drop target coordinates.
References found: `5`
- `src/code_banks/bank_81.asm:1844: LDA.L HeldItem_DropTargetCoordinateTable,X                 ;818DF1;81A363;`
- `src/code_banks/bank_81.asm:1848: LDA.L HeldItem_DropTargetCoordinateTable,X                 ;818DFA;81A363;`
- `src/code_banks/bank_81.asm:2856: LDA.L HeldItem_DropTargetCoordinateTable,X                 ;819636;81A363;`
- `src/code_banks/bank_81.asm:2860: LDA.L HeldItem_DropTargetCoordinateTable,X                 ;81963F;81A363;`
- `src/code_banks/bank_81.asm:3135: HeldItem_DropTargetCoordinateTable: dw $0218,$0208,$01A8,$00D2,$02E8,$00F2,$0318,$0252;81A363;      ;`

### `HeldItem_DroppedOnShippingBin`
shipping-bin drop handler.
References found: `2`
- `src/code_banks/bank_81.asm:2562: CODE_8193BD: BRA HeldItem_DroppedOnShippingBin                      ;8193BD;8193BF;`
- `src/code_banks/bank_81.asm:2566: HeldItem_DroppedOnShippingBin:`

### `HeldItem_DroppedOnSpecialPlace`
special-place drop fallback.
References found: `4`
- `src/code_banks/bank_81.asm:2544: CODE_819394: JMP.W HeldItem_DroppedOnSpecialPlace                    ;819394;819497;`
- `src/code_banks/bank_81.asm:2559: JMP.W HeldItem_DroppedOnSpecialPlace                    ;8193BA;819497;`
- `src/code_banks/bank_81.asm:2579: JMP.W HeldItem_DroppedOnSpecialPlace`
- `src/code_banks/bank_81.asm:2666: HeldItem_DroppedOnSpecialPlace:`
