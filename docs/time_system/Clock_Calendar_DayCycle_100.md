# Clock / Calendar / Day Cycle - Pass 13 100% Closed Scope

This document covers the closed scope completed in Pass 13: the core clock, date rollover and daily reset pipeline. It does **not** claim that every festival script, NPC schedule or event is fully understood. It means the central day-cycle machinery is mapped, named and documented.

## Main routines

| Routine | Address | Role | Status |
|---|---:|---|---|
| `Clock_UpdateAndDispatchHourlyEvents` | `$828000` | Main clock dispatcher called from the game loop | Closed |
| `DayCycle_HaveLunchAtNoon` | `$8280AA` | Noon stamina/lunch event | Closed |
| `ShippingScene_StartAt5PM` | `$828131` | Starts 5PM farm shipping sequence | Closed enough |
| `ShippingScene_ShowDailyEarningsDialogue` | `$828165` | Shows shipping earnings / nothing shipped dialogue | Closed enough |
| `DayCycle_NightResetAdvanceDate` | `$8282AC` | Night reset, date increment, daily subsystems | Closed |
| `Calendar_LoadDateNameBuffers` | `$8289D6` | Loads season/weekday/day suffix text buffers | Closed |
| `Weather_ApplyCurrentDayFlags` | `$828C09` | Applies current-day climate flags from tomorrow-weather byte | Closed |
| `Weather_RollTomorrow` | `$828CF9` | Rolls next-day weather/festival climate | Closed enough |

## Clock behavior

`Clock_UpdateAndDispatchHourlyEvents` is called from `GameLoop` in `bank_80.asm`. Its behavior is:

1. Check `!time_running & $02`. If set, jump to `DayCycle_NightResetAdvanceDate`.
2. Check `!time_running & $01`. If clear, return without advancing visible time.
3. If shipping dialogue flag `$7F1F5A & $0400` is set, route to `ShippingScene_ShowDailyEarningsDialogue`.
4. Increment `!seconds`.
5. Every 60 seconds, increment `!minutes`.
6. Every 15 minutes, increment `!hour`.
7. Stop normal hour advancement at `18` / 6PM.
8. Dispatch hourly side effects: noon lunch, 5PM shipping, 6PM evening audio/transition.
9. Refresh palette-of-day state if the palette changed.

## Time scale

The observed game-time progression is:

```text
60 ticks/seconds -> +1 minute counter
15 minute counters -> +1 hour
Clock upper bound -> 18 / 6PM for normal field progression
Night reset wake time -> 06:00:00
```

The game variable names are historical from the original disassembly; `!seconds` and `!minutes` act as game clock counters, not necessarily real wall-clock seconds/minutes.

## Date rollover

`DayCycle_NightResetAdvanceDate` performs the calendar increment:

```text
weekday = (weekday + 1) mod 7
day += 1
if day == 31:
    day = 1
    season += 1
    if season == 4:
        season = 0
        year += 1
        apply year-end farm damage table
```

So each season has 30 days. Seasons are indexed `0..3`. Weekday is indexed `0..6`.

## Daily reset pipeline

After the date increment, the same routine performs the daily state reset. The order is important:

1. Fade/force blank into nightly transition.
2. Reset target tilemap to a default map id used during wake-up flow.
3. Clear selected event/weather flags.
4. Apply current-day weather flags through `Weather_ApplyCurrentDayFlags`.
5. Apply additional storm/festival flags.
6. Run unknown but likely map/event refresh at `$8095F5`.
7. Reset clock to `06:00:00`.
8. Rebuild date name buffers with `Calendar_LoadDateNameBuffers`.
9. Run `NightlyFarmTilesCheck`.
10. Run `Weather_ApplyFarmDamageForCurrentFlags`.
11. Run `Livestock_DailyStatusAndFeedingUpdate`.
12. Roll tomorrow weather with `Weather_RollTomorrow`.
13. Run `FindMostLovedName`.
14. Run `WifePregnanacyandChilds`.
15. Reset player/action/game state.
16. Restore current stamina to max stamina.
17. Add shipping money to wallet and clear daily shipping money.
18. Handle save flag if requested.
19. Return player to house/chair wake-up position.

## Safe edit notes

Safe values to experiment with after backing up and rebuilding:

| Target | Risk | Notes |
|---|---|---|
| Wake-up hour `#06` | Medium | Other event scripts may assume morning starts at 6. |
| Lunch hour compare `#12` | Medium | Can move lunch event, but animation flags may expect daytime. |
| Shipping hour compare `#17` | Medium | Changes when shipping scene starts. |
| Hour cap `#18` | High | Palette/event scripts may assume 6PM boundary. |
| Season length `#31` compare | Very high | Save/festival/weather systems assume 30-day seasons. |

For safe hacking, prefer changing event rewards, text or prices before changing calendar length.
