# Pseudocodigo - Livestock Core

## Rotina diaria geral

```text
Livestock_DailyStatusAndFeedingUpdate():
    for cow_index in 0..11:
        cow = GetCowPointer(cow_index)
        if not cow.exists:
            continue

        if cow.is_baby_on_farm:
            try_eat_mature_grass_if_outside()
            continue

        if cow.is_in_barn:
            fed = fed_cows_flags has stall_bit_for(cow_index_or_pregnant_slot)
        else:
            fed = try_eat_mature_grass_if_outside()

        if not fed:
            cow.happiness -= penalty
            maybe_make_cow_sick()
        else:
            maybe_apply_weather_or_stress_cranky_state()

    clear_daily_cow_feed_related_flags()

    for cow_index in 0..11:
        cow = GetCowPointer(cow_index)
        if not cow.exists:
            continue

        clear_daily_interaction_bits(cow)

        if cow.is_newborn_or_baby:
            advance_baby_age()
            if age_reaches_threshold:
                become_child_or_adult_state()
            continue

        if cow.is_cranky:
            decrement_cranky_timer()
            if timer == 0:
                clear_cranky()
            continue

        if cow.is_sick:
            decrement_sick_timer()
            if fatal_condition_and_bad_day:
                remove_cow()
                set_cow_funeral_flag()
            continue

        if cow.has_pending_pregnancy_request:
            set_pregnant()
            clear_pending_request()
            continue

        if cow.is_pregnant:
            decrement_pregnancy_timer()
            if timer_expired and cow_in_barn:
                set_birth_event_flag()
                mark_cow_birth_ready()
                seed_baby_cow_happiness_from_mother()

    if not skip_chicken_update_flag:
        for chicken_index in 0..12:
            chicken = GetChickenPointer(chicken_index)
            if not chicken.exists:
                continue

            if chicken.invalid_or_dead_state:
                remove_chicken()
                player_happiness -= 30
                continue

            if chicken.is_egg_or_incubating:
                advance_incubation()
                if incubation_finished:
                    become_chick()
                continue

            if chicken.is_chick:
                advance_growth_timer()
                if timer_reaches_7:
                    become_adult_hen()

    clear_daily_egg_flags()

    for chicken_index in 0..12:
        chicken = GetChickenPointer(chicken_index)
        if chicken.exists and chicken.is_adult:
            if chicken.is_temporarily_blocked:
                decrement_block_timer()
            elif chicken.ready_to_lay_egg:
                daily_egg_flags |= egg_bitmask[chicken_index]
                set_global_egg_available_flag()
```

## Spawn visual

```text
Livestock_SpawnVisibleAnimalObjects():
    for each chicken slot:
        if slot exists and not hidden/dead:
            if slot map range matches current tilemap:
                create visible chicken object

    for each cow slot:
        if slot exists and not hidden/dead:
            if slot map range matches current tilemap:
                create visible cow object

    also creates dog/horse object when their saved state says they should appear on the current map
```
