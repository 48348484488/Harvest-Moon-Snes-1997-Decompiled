# Farm / crop / weather system map - Pass 09

This pass maps the safest and most useful part of the farm simulation: weather IDs, weather flags, daily tile updates, climate damage, grass handling and field-tool success checks.

## Main memory areas

| Symbol/address | Meaning |
|---|---|
| `!farm_map_array = $7EA4E6` | Persistent farm tile map, 4096 bytes. |
| `!weather_tomorrow = $098C` | Weather ID chosen for the next day. |
| `$0196` | Runtime weather/climate flag word used by farm/weather routines. |
| `!season = $7F1F19` | Season ID: Spring/Summer/Fall/Winter. |
| `!day = $7F1F1B` | Day of season. |
| `!planted_grass = $7F1F29` | Count/field tracking for planted grass. |
| `$092E` | Temporary counter used by mature-grass/cow feeding grass checks. |
| `!ranch_development = $7F1F56` | Score calculated from used farm tiles. |

## Core routines renamed/confirmed

| Routine | Address | Role |
|---|---:|---|
| `Weather_LoadDisplayClimateFromTomorrow` | `$8281C0` | Converts `!weather_tomorrow` into display/state byte `$0990`, with storm flag overrides. |
| `Weather_TomorrowToDisplayClimateTable` | `$8281FD` | Weather ID -> display climate table. |
| `SetWeatherFlags` | `$828C09` | Converts tomorrow weather into active weather flags at `$0196`. |
| `WeatherTomorrow` | `$828CF9` | Calculates tomorrow's weather using season/day/festival rules and RNG chance tables. |
| `ClimateFarmDamagePrep` | `$828209` | Selects damage probability profile based on active climate flags. |
| `FarmTiles_ApplyClimateDamage` | `$82A713` | Iterates farm tiles and damages fences, grass and crops. |
| `FarmTiles_NightlyGrowthDryingAndCleanup` | `$82A811` | Daily tile lifecycle: rain, drying, growth, trash, fence checks. |
| `FarmTiles_WinterMonthlyCleanup` | `$82A6A2` | Winter/monthly cleanup path for farm crops/grass. |
| `FarmGrass_MarkFirstMatureGrassPatch` | `$82A9A0` | Searches mature grass tiles `$76-$79`, marks one as `$7A`, increments `$092E`. |
| `Farm_CalculateRanchDevelopmentScore` | `$82AA0C` | Counts farm tiles that contribute to ranch development score. |
| `CheckToolSuccess` | `$82AA71` | Gatekeeper for whether selected tool can affect the front tile. |
| `ToolSuccessSquareOffsetsTable` | `$8292FA` | Offset list used for multi-square/gold tool success checks. |

## Weather generation summary

`WeatherTomorrow` first checks hard-coded festival overrides, then special first-year events, then random hurricane/rain/snow checks. The chance tables are small 4-entry arrays by season.

Important observed IDs:

| ID | Meaning |
|---:|---|
| `$00` | Sunny/default |
| `$01` | Rain |
| `$02` | Snow |
| `$03` | Hurricane |
| `$04` | Fair/special clear event |
| `$05` | Thunder/special storm event |
| `$06-$0B` | Festival climates |

## Farm tile lifecycle summary

The field map is not just visual. Farm tile IDs encode state. Examples observed in this pass:

| Tile | Meaning inferred |
|---:|---|
| `$05` | intact fence |
| `$06` | broken fence |
| `$07/$08` | tilled/watered vs unwatered soil state |
| `$1D` | planted grass base/stage-zero grass |
| `$1E/$1F` | crop/soil water-state pair |
| `$20+` | crop family range |
| `$70+` | grass family range |
| `$76-$79` | mature grass range used by cow feeding checks |
| `$7A` | grass tile marked/converted by winter/mature-grass logic |
| `$A0+` | skipped as out-of-bounds/sentinel class |

## Safe modification notes

The current pass only renamed labels and generated reports. It did not change any data bytes or logic. The build was verified byte-perfect after renames.

The next safe modification path would be:

1. Create named constants for farm tile IDs without changing values.
2. Replace magic constants like `#$05`, `#$06`, `#$70`, `#$A0` with constants.
3. Rebuild and compare byte-perfect after each small group.
4. Only after that, test changing one harmless value such as a weather chance table entry in a patch branch.


## Pass 17 update - Crop Growth Core

A Pass 17 fechou o escopo `Crop Growth Core 100%`. Foram adicionadas constantes simbolicas para os principais IDs de tile da fazenda em `src/constants/constants.asm` e comentarios diretos nas rotinas centrais de `bank_82.asm`.

Documentacao nova:

```text
docs/crop_growth_system/Crop_Growth_Core_100.md
docs/pseudocode/Crop_Growth_Daily_Lifecycle.md
```

As alteracoes continuam byte-perfect: apenas nomes, comentarios e constantes foram adicionados, sem mudanca de comportamento.
