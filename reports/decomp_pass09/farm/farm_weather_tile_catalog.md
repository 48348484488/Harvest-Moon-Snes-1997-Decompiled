# Pass 09 - Farm / crops / weather catalog

This report summarizes the safe static reverse-engineering pass for the farm tile lifecycle, weather flags and field-tool success gates. No game behavior was intentionally changed.

## Main routines

- `Weather_LoadDisplayClimateFromTomorrow` at `82:81C0`: Maps !weather_tomorrow and storm flags into display/state byte $0990 using Weather_TomorrowToDisplayClimateTable.
- `SetWeatherFlags` at `82:8C09`: Converts !weather_tomorrow into runtime weather flags at $0196 and some event flags.
- `WeatherTomorrow` at `82:8CF9`: Calculates tomorrow weather from season/day/festival rules and chance tables.
- `ClimateFarmDamagePrep` at `82:8209`: Reads weather flags and loads damage probabilities before calling ClimateFarmDamageCheck.
- `ClimateFarmDamageCheck` at `82:A713`: Iterates farm map $7EA4E6 in 16x16 logical steps and damages fences/grass/crops by RNG.
- `NightlyFarmTilesCheck` at `82:A811`: Nightly farm tile lifecycle: rain/winter growth/drying/trash/broken-fence checks.
- `MonthlyFarmTilesCheck` at `82:A6A2`: Winter/monthly cleanup path: crops/grass ranges are reset to winter-safe tiles.
- `FarmGrass_MarkFirstMatureGrassPatch` at `82:A9A0`: Searches for first mature grass tile $76-$79, converts it to $7A and updates $092E.
- `CalculateFarmDevelopment` at `82:AA0C`: Counts farm-map tiles contributing to ranch development score.
- `CheckToolSuccess` at `82:AA71`: Central field-tool success gate using !tool_selected and tile-property masks.

## Weather IDs observed

| ID | Meaning | Notes |
|---:|---|---|
| $00 | Sunny / clear default | SetWeatherFlags: usually no bit except special summer sunny path |
| $01 | Rain | Sets weather flag $0002 when not winter; treated as snow in winter |
| $02 | Snow | Sets rain flag in spring, snow flag otherwise |
| $03 | Hurricane | Sets weather flag $0010 |
| $04 | Fair / special clear | Sets flag $0200 plus event flags |
| $05 | Thunder / storm special | Sets flag $0100 plus event flags |
| $06 | Flower Festival climate | Festival override: Spring day 22 |
| $07 | Harvest Festival climate | Festival override: Fall day 11 |
| $08 | Thanksgiving climate | Festival override: Winter day 9 |
| $09 | Star Night climate | Festival override: Winter day 23 |
| $0A | New Year climate | Festival override: Winter day 30 |
| $0B | Egg Festival climate | Festival override: Fall day 19 |

## Chance tables

| Table | Spring | Summer | Fall | Winter | Notes |
|---|---:|---:|---:|---:|---|
| Hurricane_Chance_Table | $00 | $1E | $00 | $00 | Chance denominator by season; nonzero means RNGReturn0toA must return 0. Turtle shell doubles value before RNG call. |
| Rain_Chance_Table | $06 | $0A | $0A | $00 | Normal rain chance by season. |
| Snow_Chance_Table | $00 | $00 | $00 | $03 | Normal snow chance by season. |
| Thunder_Chance_Table | $00 | $1E | $00 | $00 | First-year thunder special chance by season; summer day 29 forced route. |
| Snowstorm_Chance_Table | $00 | $00 | $00 | $08 | First-year winter special fair/snowstorm branch chance. |

## Climate damage table

| Climate | Fence RNG A | Grass RNG A | Crop/Tilled RNG A | Unused |
|---|---:|---:|---:|---:|
| Rain | $60 | $00 | $00 | $00 |
| Snow | $40 | $00 | $00 | $00 |
| Hurricane | $08 | $10 | $04 | $00 |
| Special storm? | $08 | $00 | $04 | $00 |
| New Year? | $00 | $40 | $20 | $00 |

## Farm tile IDs observed

| Tile | Inferred meaning | Evidence |
|---:|---|---|
| $00 | empty / invalid for nightly loop | NightlyFarmTilesCheck skips if zero before random trash logic; exact semantic still needs runtime confirmation. |
| $01 | empty low value | Tiles below $03 can receive random trash outside fall/winter every 4 days. |
| $02 | empty/cleared ground target | Climate damage converts damaged grass/soil/crops to $02. |
| $03 | random trash/weed candidate | Nightly random trash uses $03. |
| $05 | fence intact | Climate damage may convert to $06. |
| $06 | fence broken | Nightly has 1/8 branch that sets repair/event flags. |
| $07 | tilled/watered soil state A | Monthly winter reset can convert crops to $07; rain branch can increment. |
| $08 | tilled/unwatered soil state A | Nightly non-rain branch decrements to previous state. |
| $1D | grass stage zero / planted grass base | Climate damage checks it separately; monthly winter excludes before $1D. |
| $1E | crop/soil watered state | Nightly rain branch can increment. |
| $1F | crop/soil unwatered state | Nightly non-rain branch decrements. |
| $20 | crop family lower bound | Nightly crop-growth logic starts around $20. |
| $39 | watered fully-grown tomato | Special no-rain unwater branch. |
| $53 | watered fully-grown corn | Special no-rain unwater branch. |
| $61 | watered fully-grown potato | Special no-rain unwater branch. |
| $6F | watered fully-grown turnip | Special no-rain unwater branch. |
| $70 | grass family lower bound | Grass tiles branch in climate damage and nightly logic. |
| $73 | grass second-stage converted target | Nightly maps $7C to $73. |
| $76 | mature grass range start | FarmGrass_MarkFirstMatureGrassPatch searches $76-$79. |
| $79 | mature grass / fully grown grass marker | Climate damage decrements $092E then checks grass damage. |
| $7A | marked mature/cut grass target | Monthly winter and grass-mark routine write $7A. |
| $7C | grass second stage special | Nightly maps to $73. |
| $A0 | out-of-bounds sentinel threshold | Farm tile routines skip values >= $A0. |

## Tool success masks

| Tool group | Mask | Notes |
|---|---:|---|
| sickle / gold sickle | $01 | requires tile-property bit 0 |
| hoe / gold hoe | $02 | requires tile-property bit 1 |
| hammer / gold hammer | $04 | requires tile-property bit 2 |
| axe / gold axe | $08 | requires tile-property bit 3 |
| watering can |  | farm accepts watering; non-farm can fill from water tile properties $00F0/$00F4 |
| sprinkler |  | routes to sprinkler-specific multi-tile logic |
| crop/grass seeds |  | routes to seedused branch; actual planting routines are separate |
| paint |  | paint-specific branch |