# Pseudocodigo - rotina diaria de livestock

Baseado em `Livestock_DailyStatusAndFeedingUpdate` em `bank_83.asm`.

```c
void Livestock_DailyStatusAndFeedingUpdate() {
    if (!special_livestock_skip_flag) {
        for cow_slot in 0..11 {
            cow = GetCowPointer(cow_slot);
            if (!cow.exists) continue;

            if (cow.is_baby_or_birth_state) continue;

            if (cow.is_child_or_adult_state) {
                if (cow.map == BARN) {
                    if (cow.is_pregnant) {
                        fed = fed_cows_flags & CowFeedFlags[PREGNANT_SPECIAL_SLOT];
                    } else {
                        fed = fed_cows_flags & CowFeedFlags[cow_slot];
                    }
                    if (!fed) Cow_UnfedPenaltyAndSicknessCheck(cow);
                    else Cow_FedPath(cow);
                } else {
                    if (cow.map_is_farm_or_outdoor && farm_has_mature_grass && weather_safe) {
                        Cow_FedPath(cow);
                    } else {
                        Cow_UnfedPenaltyAndSicknessCheck(cow);
                    }
                }
            }
        }
    }

    for cow_slot in 0..11 {
        cow = GetCowPointer(cow_slot);
        if (!cow.exists) continue;

        cow.daily_flags &= 0xF8;

        if (cow.is_baby_birth_state) {
            cow.timer++;
            if (cow.timer == 14) cow.becomes_child_or_adult_birth_state();
            continue;
        }

        if (cow.is_child) {
            cow.age++;
            if (cow.age == 21) cow.becomes_child_stage();
            continue;
        }

        if (cow.is_cranky) {
            cow.cranky_timer--;
            if (cow.cranky_timer == 0) cow.clear_cranky();
            continue;
        }

        if (cow.is_sick) {
            cow.sick_timer--;
            if (cow.sick_timer <= 0) cow.dies_and_sets_funeral_flag();
            continue;
        }

        if (cow.pregnancy_triggered) {
            cow.set_pregnant();
            cow.clear_pregnancy_trigger();
        }

        if (cow.is_pregnant) {
            cow.pregnancy_timer--;
            if (cow.pregnancy_timer == 0 && cow.map == BARN) {
                set_cow_birth_pending_flag();
                cow.clear_pregnant();
                prepare_baby_happiness_from_mother_happiness();
            }
        }
    }

    if (!special_livestock_skip_flag) {
        for chicken_slot in 0..12 {
            chicken = GetChickenPointer(chicken_slot);
            if (!chicken.exists) continue;

            if (chicken.status_has_invalid/no_active_bits) {
                remove_chicken_and_penalize_player();
                continue;
            }

            if (chicken.is_adult) {
                if (chicken.map == COOP) {
                    if (fed_chicks_N > 0) fed_chicks_N--;
                    else chicken.set_cranky_or_unfed();
                } else if (chicken.map_outdoor && farm_has_mature_grass && weather_safe) {
                    chicken_fed_or_safe();
                } else {
                    chicken.set_cranky_or_unfed();
                }
            }
        }
    }

    for chicken_slot in 0..12 {
        chicken = GetChickenPointer(chicken_slot);
        if (!chicken.exists) continue;

        if (chicken.is_hatching_egg) {
            chicken.timer++;
            if (timer == 3 && chicks_N < 12) hatch_to_chick();
        } else if (chicken.is_chick) {
            chicken.age++;
            if (age == 7) chick_becomes_adult();
        }

        if (chicken.is_adult && chicken.was_fed_in_coop) {
            mark_egg_available_for_slot(chicken_slot);
        }

        if (chicken.is_cranky) {
            chicken.cranky_timer--;
            if (timer == 0) chicken.clear_cranky();
        }
    }
}
```

Observacao: alguns nomes ainda sao inferidos. A build byte-perfect garante que as renomeacoes/documentacao nao alteram comportamento.
