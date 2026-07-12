# Pseudocodigo - Crop Growth Daily Lifecycle

Este pseudocodigo resume a rotina `FarmTiles_NightlyGrowthDryingAndCleanup` e rotinas auxiliares relacionadas.

```text
function FarmTiles_NightlyGrowthDryingAndCleanup():
    set active_map = farm

    for y from 0 to 0x3FF step 0x10:
        for x from 0 to 0x3FF step 0x10:
            index = GetTileIndex(x, y)
            tile = farm_map_array[index]

            if tile == 0:
                continue

            if tile < 0x03:
                maybe_add_random_trash(index)
                continue

            if tile >= 0xA0:
                continue

            if tile == BROKEN_FENCE:
                maybe_set_broken_fence_flag()
                continue

            if tile == TILLED_SOIL or tile == CROP_BASE_DRY:
                if raining:
                    water_or_advance_tile(index)
                else:
                    continue
                continue

            if tile == WATERED_SOIL or tile == CROP_BASE_WATERED:
                if not raining:
                    dry_tile(index)
                continue

            if tile == GRASS_SEED:
                continue

            if tile in crop_or_grass_range:
                handle_crop_or_grass_growth(index, tile)

    if season == winter and day == 1:
        FarmTiles_WinterMonthlyCleanup()
```

## Crescimento / secagem de crops

```text
function handle_crop_or_grass_growth(index, tile):
    if tile is adult watered crop:
        if not raining:
            dry_tile(index)
        return

    if tile is mature grass special state:
        return or normalize depending on state

    if tile is grass range:
        water_or_grow_grass(index)
        return

    if tile is crop range:
        if tile is watered/even state:
            if raining:
                water_or_advance_tile(index)
            else:
                keep_or_dry_according_to pair state
        else:
            if raining:
                water_or_advance_tile(index)
            else:
                dry_or_keep_crop(index)
```

## Dano climatico

```text
function FarmTiles_ApplyClimateDamage(fence_chance, grass_chance, crop_chance):
    for each farm tile:
        if tile >= OUT_OF_BOUNDS:
            continue

        if tile == FENCE:
            if random_hit(fence_chance):
                tile = BROKEN_FENCE
            continue

        if tile is grass:
            if random_hit(grass_chance):
                tile = EMPTY_FIELD
                decrement planted grass counters when needed
            continue

        if tile is tilled soil or crop:
            if random_hit(crop_chance):
                tile = EMPTY_FIELD
            continue
```

## Limpeza de inverno

```text
function FarmTiles_WinterMonthlyCleanup():
    if season != winter:
        return

    for each farm tile:
        if tile == 0 or tile >= OUT_OF_BOUNDS:
            continue

        if tile >= GRASS_RANGE_START:
            tile = GRASS_MARKED_FOR_FEED_OR_WINTER_STATE
        else if tile >= GRASS_SEED:
            tile = TILLED_SOIL
```

## Desenvolvimento da fazenda

```text
function Farm_CalculateRanchDevelopmentScore():
    ranch_development = 0

    for each farm tile:
        if tile >= OUT_OF_BOUNDS:
            continue

        if tile == FENCE or tile == BROKEN_FENCE or tile >= GRASS_SEED:
            ranch_development += 1
```
