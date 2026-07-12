# Save Slot Layout 100% - Pass 12

Este arquivo e o mapa consolidado dos offsets diretos do slot SRAM. Ele foi gerado a partir das rotinas `SaveSystem_SaveSlot`, `SaveSystem_LoadFullSlot` e `SaveSystem_LoadSlotSummary`.

## Convencao

- `Save source`: variavel RAM copiada para SRAM ao salvar.
- `Load target`: variavel RAM restaurada ao carregar slot completo.
- `Summary load`: campo usado pelo menu/resumo de save, quando existe.
- Offsets sao relativos ao inicio do slot. Para o slot 2, some `$1000`.

## Offsets diretos conhecidos

| Offset | Dec | Save source | Load target | Summary load | Notas |
|---|---|---|---|---|---|
| $0000 | 0 | !year | !year | !year | - |
| $0001 | 1 | !season | !season | !season | - |
| $0002 | 2 | !weekday | !weekday | - | - |
| $0003 | 3 | !day | !day | !day | - |
| $0004 | 4 | !seeds_grass_N | !seeds_grass_N | - | - |
| $0005 | 5 | !seeds_corn_N | !seeds_corn_N | - | - |
| $0006 | 6 | !seeds_tomato_N | !seeds_tomato_N | - | - |
| $0007 | 7 | !seeds_potato_N | !seeds_potato_N | - | - |
| $0008 | 8 | !seeds_turnip_N | !seeds_turnip_N | - | - |
| $0009 | 9 | !feed_cow_N | !feed_cow_N | - | - |
| $000A | 10 | !feed_chicks_N | !feed_chicks_N | - | - |
| $000B | 11 | !cow_N | !cow_N | - | - |
| $000C | 12 | !chicks_N | !chicks_N | - | - |
| $000D | 13 | !weather_tomorrow | !weather_tomorrow | - | - |
| $000E | 14 | !max_stamina | !max_stamina | - | - |
| $000F | 15 | !tool_selected | !tool_selected | - | - |
| $0010 | 16 | !watering_can_water | !watering_can_water | - | - |
| $0011 | 17 | $7F1F12 | $7F1F12 | - | - |
| $0012 | 18 | $7F1F2B | $7F1F2B | - | - |
| $0013 | 19 | !dog_map | !dog_map | - | - |
| $0014 | 20 | $7F1F31 | $7F1F31 | - | - |
| $0015 | 21 | $7F1F32 | $7F1F32 | - | - |
| $0016 | 22 | !development_rate | !development_rate | - | - |
| $0017 | 23 | !power_berry_N | !power_berry_N | - | - |
| $0018 | 24 | $09A3 | $09A3 | - | - |
| $0019 | 25 | $0937 | $0937 | - | - |
| $001A | 26 | !tool_backpack | !tool_backpack | - | - |
| $002E | 46 | !crcsum | - | - | - |
| $002F | 47 | !crcsum | - | - | - |
| $0031 | 49 | !shipped_corn | !shipped_corn | - | - |
| $0033 | 51 | !shipped_tomatoes | !shipped_tomatoes | - | - |
| $0035 | 53 | !shipped_turnips | !shipped_turnips | - | - |
| $0037 | 55 | !shipped_potatoes | !shipped_potatoes | - | - |
| $0039 | 57 | !moneyL | !moneyL | - | - |
| $003B | 59 | !moneyH | !moneyH | - | - |
| $0040 | 64 | !stored_wood | !stored_wood | - | - |
| $0042 | 66 | !stored_grass | !stored_grass | - | - |
| $0044 | 68 | $0196 | $0196 | - | - |
| $0046 | 70 | !planted_grass | !planted_grass | - | - |
| $0048 | 72 | !hearts_maria | !hearts_maria | - | - |
| $004A | 74 | !hearts_ann | !hearts_ann | - | - |
| $004C | 76 | !hearts_nina | !hearts_nina | - | - |
| $004E | 78 | !hearts_ellen | !hearts_ellen | - | - |
| $0050 | 80 | !hearts_eve | !hearts_eve | - | - |
| $0060 | 96 | $7F1F64 | $7F1F64 | - | - |
| $0062 | 98 | $7F1F66 | $7F1F66 | - | - |
| $0064 | 100 | $7F1F68 | $7F1F68 | - | - |
| $0066 | 102 | $7F1F6A | $7F1F6A | - | - |
| $0068 | 104 | !dog_pos_X | !dog_pos_X | - | - |
| $006A | 106 | !dog_pos_Y | !dog_pos_Y | - | - |
| $006C | 108 | !happiness | !happiness | - | - |
| $006E | 110 | $7F1F45 | $7F1F45 | - | - |
| $0070 | 112 | $7F1F6C | $7F1F6C | - | - |
| $0072 | 114 | $7F1F6E | $7F1F6E | - | - |
| $0074 | 116 | $7F1F70 | $7F1F70 | - | - |
| $0076 | 118 | $7F1F72 | $7F1F72 | - | - |
| $0078 | 120 | !wife_pregnancy | !wife_pregnancy | - | - |
| $007A | 122 | !kid1_age | !kid1_age | - | - |
| $007C | 124 | !kid2_age | !kid2_age | - | - |
| $007E | 126 | !dog_hugs | !dog_hugs | - | - |
| $0080 | 128 | !player_name_sort_1 | !player_name_sort_1 | !player_name_sort_1 | - |
| $0081 | 129 | !player_name_sort_2 | !player_name_sort_2 | !player_name_sort_2 | - |
| $0082 | 130 | !player_name_sort_3 | !player_name_sort_3 | !player_name_sort_3 | - |
| $0083 | 131 | !player_name_sort_4 | !player_name_sort_4 | !player_name_sort_4 | - |
| $0084 | 132 | !shed_items_row_1 | !shed_items_row_1 | - | - |
| $0085 | 133 | !shed_items_row_2 | !shed_items_row_2 | - | - |
| $0086 | 134 | !shed_items_row_3 | !shed_items_row_3 | - | - |
| $0087 | 135 | !shed_items_row_4 | !shed_items_row_4 | - | - |
| $0088 | 136 | !dog_name_short_1 | !dog_name_short_1 | - | - |
| $0089 | 137 | !dog_name_short_2 | !dog_name_short_2 | - | - |
| $008A | 138 | !dog_name_short_3 | !dog_name_short_3 | - | - |
| $008B | 139 | !dog_name_short_4 | !dog_name_short_4 | - | - |
| $008C | 140 | !horse_name_short_1 | !horse_name_short_1 | - | - |
| $008D | 141 | !horse_name_short_2 | !horse_name_short_2 | - | - |
| $008E | 142 | !horse_name_short_3 | !horse_name_short_3 | - | - |
| $008F | 143 | !horse_name_short_4 | !horse_name_short_4 | - | - |
| $0090 | 144 | !kid1_name_sort_1 | !kid1_name_sort_1 | - | - |
| $0091 | 145 | !kid1_name_sort_2 | !kid1_name_sort_2 | - | - |
| $0092 | 146 | !kid1_name_sort_3 | !kid1_name_sort_3 | - | - |
| $0093 | 147 | !kid1_name_sort_4 | !kid1_name_sort_4 | - | - |
| $0094 | 148 | !kid2_name_sort_1 | !kid2_name_sort_1 | - | - |
| $0095 | 149 | !kid2_name_sort_2 | !kid2_name_sort_2 | - | - |
| $0096 | 150 | !kid2_name_sort_3 | !kid2_name_sort_3 | - | - |
| $0097 | 151 | !kid2_name_sort_4 | !kid2_name_sort_4 | - | - |
| $0098 | 152 | !chicken_array | !chicken_array | - | - |
| $0100 | 256 | !cow_array | !cow_array | - | - |
| $01C0 | 448 | !farm_map_array | !farm_map_array | - | - |

## Blocos grandes

- `$0098-$00FF`: `chicken_array`, 13 galinhas x 8 bytes.
- `$0100-$01BF`: `cow_array`, 12 vacas x 16 bytes.
- `$01C0-$0FFF`: `farm_map_array`, bloco persistente da fazenda/campo.

## Status

Este submapa esta **100% consolidado** para o que as rotinas de save/load acessam diretamente. Alguns campos ainda carregam nome bruto, por exemplo `$7F1F64`, porque o significado de gameplay dessa flag ainda nao foi fechado; mesmo assim o offset e o caminho de save/load estao mapeados.
