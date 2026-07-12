# Pseudocode - daily farm tile lifecycle

This is a conservative pseudocode reconstruction from `NightlyFarmTilesCheck`, `ClimateFarmDamageCheck`, `MonthlyFarmTilesCheck` and related routines.

```c
for each logical farm tile in farm_map_array {
    tile = farm_map_array[index];

    if (tile == 0) continue;
    if (tile >= 0xA0) continue;

    if (tile < 0x03) {
        // Outside fall/winter, every fourth day may spawn trash/weed with RNG.
        maybe_spawn_random_trash(tile);
        continue;
    }

    if (tile == 0x06) {
        // Broken fence can trigger repair/event flags with 1/8 branch.
        maybe_set_broken_fence_flags();
        continue;
    }

    if (is_watered_soil_or_watered_crop(tile)) {
        if (weather_flags & RAIN_FLAG) {
            water_or_advance_tile(index);
        }
        continue;
    }

    if (is_unwatered_soil_or_crop(tile)) {
        if (!(weather_flags & RAIN_FLAG)) {
            farm_map_array[index]--;
        }
        continue;
    }

    if (tile >= 0x70) {
        handle_grass_tile(index, tile);
        continue;
    }

    if (tile >= 0x20) {
        handle_crop_growth_or_drying(index, tile, season, weather_flags);
        continue;
    }
}

if (season == WINTER && day == 1) {
    MonthlyFarmTilesCheck();
}
```

## Climate damage simplified

```c
if (rain)      damage = DamageProbabilityTable[Rain];
if (snow)      damage = DamageProbabilityTable[Snow];
if (hurricane) damage = DamageProbabilityTable[Hurricane];

for each farm tile {
    if (tile == intact_fence && rng_hit(damage.fence)) {
        tile = broken_fence;
    }

    if (tile is grass && rng_hit(damage.grass)) {
        tile = cleared_ground;
        planted_grass--;
    }

    if (tile is tilled/crop && rng_hit(damage.crop)) {
        tile = cleared_ground;
    }
}
```

## Tool success simplified

```c
switch (tool_selected) {
    case SICKLE:
    case GOLD_SICKLE:
        return tile_property & 0x01;
    case HOE:
    case GOLD_HOE:
        return tile_property & 0x02;
    case HAMMER:
    case GOLD_HAMMER:
        return tile_property & 0x04;
    case AXE:
    case GOLD_AXE:
        return tile_property & 0x08;
    case WATERING_CAN:
        return farm_tile_or_water_source_check();
    case SPRINKLER:
        return sprinkler_check();
    case SEEDS:
        return seed_check();
    case PAINT:
        return paint_check();
    default:
        return failure;
}
```
