# Pseudocode - Tile Property / Collision Ruleset Core

```c
void LoadMap() {
    uint8 area = tilemap_to_load;

    if (area < 4) {
        map_ptr = &farm_persistent_map;
        table_index = 0;
    } else {
        table_index = area * 3;
        map_ptr = MapPointerTable[area];
    }

    tile_property_ptr = TileProperty_RulesetPointerTable[area];
    current_tile_property_ruleset = tile_property_ptr; // $0D-$0F

    copy_0x1000_bytes(map_ptr, current_map_array);
}

uint16 TileProperty_CheckToolUseAllowed(uint16 tool_rule_param) {
    if (global_field_menu_or_blocking_flag_is_set()) {
        return 0;
    }

    uint8 tile_id = GetTileContent(target_pixel_or_tile);
    uint16 property_offset = tile_id * 4 + 3;

    uint16 direction_mask = TileProperty_DirectionMaskTable[player_direction];
    uint16 property = current_tile_property_ruleset[property_offset];

    if ((property & direction_mask) == 0) {
        return 0;
    }

    uint16 season_mask = TileProperty_SeasonMaskTable[season];

    if ((property & season_mask) == 0) {
        return 0;
    }

    return dispatch_tool_effect_for_tile(tool_rule_param, tile_id);
}
```

## Mascara de direcao

```text
$01 = direcao 0
$02 = direcao 1
$04 = direcao 2
$08 = direcao 3
```

## Mascara de estacao

```text
$10 = Spring
$20 = Summer
$40 = Fall
$80 = Winter
```
