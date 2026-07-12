# Pseudocode - Clock / Calendar / Day Cycle

```c
void Clock_UpdateAndDispatchHourlyEvents(void) {
    if (time_running & 0x02) {
        DayCycle_NightResetAdvanceDate();
        return;
    }

    if ((time_running & 0x01) == 0) {
        return;
    }

    if (flags_7F1F5A & 0x0400) {
        ShippingScene_ShowDailyEarningsDialogue();
        return;
    }

    seconds++;
    if (seconds == 60) {
        seconds = 0;
        minutes++;

        if (minutes == 15) {
            minutes = 0;

            if (hour != 18) {
                hour++;
                DayCycle_HaveLunchAtNoon();
                ShippingScene_StartAt5PM();

                if (hour == 18) {
                    TriggerEveningAudioAndState();
                }
            }
        }
    }

    UpdateTimeOfDayPaletteIfNeeded();
}

void DayCycle_NightResetAdvanceDate(void) {
    weekday++;
    if (weekday == 7) weekday = 0;

    day++;
    if (day == 31) {
        season++;
        if (season == 4) {
            year++;
            ApplyYearEndFarmDamage();
            season = 0;
        }
        day = 1;
    }

    FadeOutAndPrepareMorningTransition();
    Weather_ApplyCurrentDayFlags();
    ApplyStormOrFestivalSideFlags();

    hour = 6;
    minutes = 0;
    seconds = 0;

    Calendar_LoadDateNameBuffers();
    NightlyFarmTilesCheck();
    Weather_ApplyFarmDamageForCurrentFlags();
    Livestock_DailyStatusAndFeedingUpdate();
    Weather_RollTomorrow();
    FindMostLovedName();
    WifePregnanacyandChilds();

    ResetPlayerForMorning();
    current_stamina = max_stamina;
    AddMoney(shipping_money);
    ClearShippingMoney();

    if (time_running & 0x04) {
        SaveSystem_SaveSlot(selected_slot);
    }

    TransitionToHouseWakeupPosition();
    DayCycle_HaveLunchAtNoon(); // harmless because wake hour is 6
}
```
