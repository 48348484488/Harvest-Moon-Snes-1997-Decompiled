# Pseudocodigo - Pass 51 Remaining UNK Prefix Cleanup

## MapTilePatchRuntime_ClearAllSlots

```text
ptr = $7E:B4E6
for slot in 0..9:
    slot[0] = 0
    ptr += 0x10
```

## LoadMap + TileProperty_MapPointerTable

```text
area_id = tilemap_to_load
map_source = MapPointerTable[area_id]
tile_property_source = TileProperty_MapPointerTable[area_id]

$72-$74 = map_source
$0D-$0F = tile_property_source

current_map_array = copy_0x1000_bytes(map_source)
```

## MapTilePatchRuntime_UpdateActiveSlots

```text
ptr = $7E:B4E6
for slot in 0..9:
    if slot.active bit is clear:
        continue

    load slot fields into scratch registers
    load attached GameOBJ state

    if attached object reports delete/release state:
        release object/components
        optionally clear current slot active flag
        continue

    dispatch slot behavior through MapTilePatchRuntime_BehaviorJumpTable
    write updated slot fields back to WRAM
    update/reinitialize attached GameOBJ as needed
```
