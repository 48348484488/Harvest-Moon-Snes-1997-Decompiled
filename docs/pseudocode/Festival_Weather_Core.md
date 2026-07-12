# Pseudocodigo - Festival / Weather Core

```c
void Weather_RollTomorrow(void) {
    if (season == SPRING && day == 22) {
        weather_tomorrow = WEATHER_FLOWER_FESTIVAL;
        return;
    }

    if (season == FALL) {
        if (day == 11) {
            weather_tomorrow = WEATHER_HARVEST_FESTIVAL;
            return;
        }
        if (day == 19) {
            weather_tomorrow = WEATHER_EGG_FESTIVAL;
            return;
        }
    }

    if (season == WINTER) {
        if (day == 9) {
            weather_tomorrow = WEATHER_THANKSGIVING;
            return;
        }
        if (day == 23) {
            weather_tomorrow = WEATHER_STARRY_NIGHT;
            return;
        }
        if (day == 30) {
            weather_tomorrow = WEATHER_NEW_YEAR;
            return;
        }

        if (year == 0 && first_year_special_flag_not_set()) {
            if (day == 7 || rng_hits(Snowstorm_Chance_Table[season])) {
                weather_tomorrow = WEATHER_FAIR;
                return;
            }
        }
    }

    if (year == 0 && thunder_special_not_set()) {
        if (day == 29 || rng_hits(Thunder_Chance_Table[season])) {
            weather_tomorrow = WEATHER_THUNDER_CALM;
            return;
        }
    }

    if (day != 30 && rng_hits(Hurricane_Chance_Table[season])) {
        weather_tomorrow = WEATHER_HURRICANE;
        return;
    }

    if (rng_hits(Rain_Chance_Table[season])) {
        weather_tomorrow = WEATHER_RAIN;
        return;
    }

    if (rng_hits(Snow_Chance_Table[season])) {
        weather_tomorrow = WEATHER_SNOW;
        return;
    }

    weather_tomorrow = WEATHER_SUNNY;
}
```
