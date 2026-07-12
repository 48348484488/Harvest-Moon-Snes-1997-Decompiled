# Pass 11 - Save Slot Layout / SRAM
Catalogo conservador do layout de slot salvo observado em `SaveSystem_LoadFullSlot`, `SaveSystem_SaveSlot`, `SaveSystem_LoadSlotSummary` e `SaveSystem_CheckSRAMIntegrity`.
## Descobertas principais
- SRAM usado pelos slots: banco `$70`.
- Slot 1 base: `$70:0000`.
- Slot 2 base: `$70:1000`.
- Cada slot e iterado como `$1000` bytes durante o checksum.
- Em falha de integridade, a rotina limpa `$0800` bytes e restaura a assinatura `FARM`.
- Marcador de validade: ASCII `FARM` em `$003C-$003F`.
- Checksum fica em `$002F-$0030`; `$002E` tambem e zerado temporariamente no calculo.

## Blocos do slot

| Range | Size | Name | Notes |
|---:|---:|---|---|
| `$0000-$001A` | `27` | Scalar 8-bit early fields | Date, seed/feed counts, selected tool, stamina and misc flags. |
| `$002E` | `1` | Active/latest-slot marker byte | Temporarily zeroed for checksum; values 0/1 are used by slot-state flow. |
| `$002F-$0030` | `2` | Save checksum | 16-bit additive checksum over $0000-$0FFF with $002E and $002F-$0030 zeroed first. |
| `$0031,$0033,$0035,$0037` | `7` | Shipped crop counters | Stored at separated odd offsets. |
| `$0039-$003B` | `3` | Money | 24-bit money value split into !moneyL and !moneyH. |
| `$003C-$003F` | `4` | FARM signature | ASCII F,A,R,M. Used as a basic slot validity marker. |
| `$0040-$007E` | `63` | 16-bit counters/hearts/family/dog state | Wood/grass, crop totals, bachelorette hearts, persistent flags, dog position, happiness, pregnancy/kids. |
| `$0080-$0083` | `4` | Player name | Four character bytes. |
| `$0084-$0087` | `4` | Tool shed bitfields | Rows of stored tools/seeds/items; see pass07 report. |
| `$0088-$008B` | `4` | Dog name | Four character bytes. |
| `$008C-$008F` | `4` | Horse name | Four character bytes. |
| `$0090-$0093` | `4` | Kid 1 name | Four character bytes. |
| `$0094-$0097` | `4` | Kid 2 name | Four character bytes. |
| `$0098-$00FF` | `104` | Chicken array | 13 chickens x 8 bytes = 104 bytes. |
| `$0100-$01BF` | `192` | Cow array | 12 cows x 16 bytes = 192 bytes. |
| `$01C0-$0FFF` | `3648` | Farm map/tile state block | Copied from !farm_map_array index $00C0-$0EFF into SRAM $01C0-$0FFF. |

## Offset direto

| Offset | Save source | Load target | Summary load | Notes |
|---:|---|---|---|---|
| `$0000` | `!year` | `!year` | `!year` | 8-bit year counter |
| `$0001` | `!season` | `!season` | `!season` | 8-bit season |
| `$0002` | `!weekday` | `!weekday` | `` | 8-bit weekday |
| `$0003` | `!day` | `!day` | `!day` | 8-bit day of season |
| `$0004` | `!seeds_grass_N` | `!seeds_grass_N` | `` | grass seed count |
| `$0005` | `!seeds_corn_N` | `!seeds_corn_N` | `` | corn seed count |
| `$0006` | `!seeds_tomato_N` | `!seeds_tomato_N` | `` | tomato seed count |
| `$0007` | `!seeds_potato_N` | `!seeds_potato_N` | `` | potato seed count |
| `$0008` | `!seeds_turnip_N` | `!seeds_turnip_N` | `` | turnip seed count |
| `$0009` | `!feed_cow_N` | `!feed_cow_N` | `` | cow feed count |
| `$000A` | `!feed_chicks_N` | `!feed_chicks_N` | `` | chicken feed count |
| `$000B` | `!cow_N` | `!cow_N` | `` | cow count |
| `$000C` | `!chicks_N` | `!chicks_N` | `` | chicken count |
| `$000D` | `!weather_tomorrow` | `!weather_tomorrow` | `` | tomorrow weather |
| `$000E` | `!max_stamina` | `!max_stamina` | `` | max stamina |
| `$000F` | `!tool_selected` | `!tool_selected` | `` | selected tool |
| `$0010` | `!watering_can_water` | `!watering_can_water` | `` | watering can water |
| `$0011` | `$7F1F12` | `$7F1F12` | `` | unknown persistent byte |
| `$0012` | `$7F1F2B` | `$7F1F2B` | `` | unknown persistent byte |
| `$0013` | `!dog_map` | `!dog_map` | `` | dog map/location id |
| `$0014` | `$7F1F31` | `$7F1F31` | `` | unknown persistent byte |
| `$0015` | `$7F1F32` | `$7F1F32` | `` | unknown persistent byte |
| `$0016` | `!development_rate` | `!development_rate` | `` | farm development rate |
| `$0017` | `!power_berry_N` | `!power_berry_N` | `` | power berry count |
| `$0018` | `$09A3` | `$09A3` | `` | unknown WRAM value |
| `$0019` | `$0937` | `$0937` | `` | unknown WRAM value |
| `$001A` | `!tool_backpack` | `!tool_backpack` | `` | backpack tool |
| `$002E` | `slot marker / checksum scratch` | `` | `` | temporarily zeroed during checksum; also slot-state marker |
| `$002F` | `checksum low/high` | `` | `` | 16-bit additive checksum starts here |
| `$0031` | `!shipped_corn` | `!shipped_corn` | `` | corn shipped count |
| `$0033` | `!shipped_tomatoes` | `!shipped_tomatoes` | `` | tomatoes shipped count |
| `$0035` | `!shipped_turnips` | `!shipped_turnips` | `` | turnips shipped count |
| `$0037` | `!shipped_potatoes` | `!shipped_potatoes` | `` | potatoes shipped count |
| `$0039` | `!moneyL` | `!moneyL` | `` | money low 16 bits |
| `$003B` | `!moneyH` | `!moneyH` | `` | money high byte |
| `$003C` | `ASCII FARM` | `ASCII FARM` | `FARM check` | valid slot signature bytes $46,$41,$52,$4D |
| `$0040` | `!stored_wood` | `!stored_wood` | `` | stored wood |
| `$0042` | `!stored_grass` | `!stored_grass` | `` | stored grass/fodder |
| `$0044` | `$0196` | `$0196` | `` | unknown 16-bit value |
| `$0046` | `!planted_grass` | `!planted_grass` | `` | planted grass count |
| `$0048` | `!hearts_maria` | `!hearts_maria` | `` | Maria affection |
| `$004A` | `!hearts_ann` | `!hearts_ann` | `` | Ann affection |
| `$004C` | `!hearts_nina` | `!hearts_nina` | `` | Nina affection |
| `$004E` | `!hearts_ellen` | `!hearts_ellen` | `` | Ellen affection |
| `$0050` | `!hearts_eve` | `!hearts_eve` | `` | Eve affection |
| `$0060` | `$7F1F64` | `$7F1F64` | `` | unknown persistent word |
| `$0062` | `$7F1F66` | `$7F1F66` | `` | unknown persistent word |
| `$0064` | `$7F1F68` | `$7F1F68` | `` | unknown persistent word |
| `$0066` | `$7F1F6A` | `$7F1F6A` | `` | unknown persistent word |
| `$0068` | `!dog_pos_X` | `!dog_pos_X` | `` | dog X position |
| `$006A` | `!dog_pos_Y` | `!dog_pos_Y` | `` | dog Y position |
| `$006C` | `!happiness` | `!happiness` | `` | player/farm happiness |
| `$006E` | `$7F1F45` | `$7F1F45` | `` | unknown persistent word |
| `$0070` | `$7F1F6C` | `$7F1F6C` | `` | unknown persistent word |
| `$0072` | `$7F1F6E` | `$7F1F6E` | `` | unknown persistent word |
| `$0074` | `$7F1F70` | `$7F1F70` | `` | unknown persistent word |
| `$0076` | `$7F1F72` | `$7F1F72` | `` | unknown persistent word |
| `$0078` | `!wife_pregnancy` | `!wife_pregnancy` | `` | wife pregnancy state |
| `$007A` | `!kid1_age` | `!kid1_age` | `` | kid 1 age |
| `$007C` | `!kid2_age` | `!kid2_age` | `` | kid 2 age |
| `$007E` | `!dog_hugs` | `!dog_hugs` | `` | dog hug counter |
| `$0080` | `!player_name_sort_1` | `!player_name_sort_1` | `!player_name_sort_1` | player_name character 1 |
| `$0081` | `!player_name_sort_2` | `!player_name_sort_2` | `!player_name_sort_2` | player_name character 2 |
| `$0082` | `!player_name_sort_3` | `!player_name_sort_3` | `!player_name_sort_3` | player_name character 3 |
| `$0083` | `!player_name_sort_4` | `!player_name_sort_4` | `!player_name_sort_4` | player_name character 4 |
| `$0084` | `!shed_items_row_1` | `!shed_items_row_1` | `` | tool shed bitfield row |
| `$0085` | `!shed_items_row_2` | `!shed_items_row_2` | `` | tool shed bitfield row |
| `$0086` | `!shed_items_row_3` | `!shed_items_row_3` | `` | tool shed bitfield row |
| `$0087` | `!shed_items_row_4` | `!shed_items_row_4` | `` | tool shed bitfield row |
| `$0088` | `!dog_name_short_1` | `!dog_name_short_1` | `` | dog_name character 1 |
| `$0089` | `!dog_name_short_2` | `!dog_name_short_2` | `` | dog_name character 2 |
| `$008A` | `!dog_name_short_3` | `!dog_name_short_3` | `` | dog_name character 3 |
| `$008B` | `!dog_name_short_4` | `!dog_name_short_4` | `` | dog_name character 4 |
| `$008C` | `!horse_name_short_1` | `!horse_name_short_1` | `` | horse_name character 1 |
| `$008D` | `!horse_name_short_2` | `!horse_name_short_2` | `` | horse_name character 2 |
| `$008E` | `!horse_name_short_3` | `!horse_name_short_3` | `` | horse_name character 3 |
| `$008F` | `!horse_name_short_4` | `!horse_name_short_4` | `` | horse_name character 4 |
| `$0090` | `!kid1_name_sort_1` | `!kid1_name_sort_1` | `` | kid1_name character 1 |
| `$0091` | `!kid1_name_sort_2` | `!kid1_name_sort_2` | `` | kid1_name character 2 |
| `$0092` | `!kid1_name_sort_3` | `!kid1_name_sort_3` | `` | kid1_name character 3 |
| `$0093` | `!kid1_name_sort_4` | `!kid1_name_sort_4` | `` | kid1_name character 4 |
| `$0094` | `!kid2_name_sort_1` | `!kid2_name_sort_1` | `` | kid2_name character 1 |
| `$0095` | `!kid2_name_sort_2` | `!kid2_name_sort_2` | `` | kid2_name character 2 |
| `$0096` | `!kid2_name_sort_3` | `!kid2_name_sort_3` | `` | kid2_name character 3 |
| `$0097` | `!kid2_name_sort_4` | `!kid2_name_sort_4` | `` | kid2_name character 4 |
| `$0098` | `!chicken_array` | `!chicken_array` | `` | block copy: 13 chickens x 8 bytes = 104 bytes |
| `$0100` | `!cow_array` | `!cow_array` | `` | block copy: 12 cows x 16 bytes = 192 bytes |
| `$01C0` | `!farm_map_array[$00C0-$0EFF]` | `!farm_map_array[$00C0-$0EFF]` | `` | block copy: farm map/tile state to end of slot |
