# Safe farm/crop edit plan

The farm system is sensitive because it touches persistent save data, map tiles, weather, animal feed checks and field tools. The safest edit order is:

## Phase A - constants only

Create constants for existing tile IDs and weather flags, then replace magic numbers in small groups.

Examples:

```asm
!FARM_TILE_FENCE_INTACT = $05
!FARM_TILE_FENCE_BROKEN = $06
!FARM_TILE_GRASS_MATURE_MIN = $76
!FARM_TILE_OUT_OF_BOUNDS_MIN = $A0
```

This should keep the ROM byte-perfect.

## Phase B - tables only

Make editable tables for:

- rain chance;
- snow chance;
- hurricane chance;
- damage probability table;
- display climate table.

Changing values here is safer than changing code flow, but it will intentionally change the output ROM.

## Phase C - one gameplay patch at a time

Only after constants and tables are mapped, test small isolated patches:

- less hurricane damage;
- more/less rain;
- faster/slower crop drying;
- fence durability changes;
- grass growth tweaks.

Each patch should be separate and reversible.
