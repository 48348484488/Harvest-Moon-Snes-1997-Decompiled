# Pseudocodigo - Ranch Mastery / Ending Evaluation Core

```c
void RanchEval_CalculateMasteryAndStartEnding(void) {
    ranch_mastery = 0;

    // dinheiro: limitado a 78 pontos
    score = moneyL >> 7;
    if (score >= 78) score = 78;
    ranch_mastery = score;

    ranch_mastery += cow_N * 3;
    ranch_mastery += chicks_N * 3;
    ranch_mastery += (max_stamina - 100) >> 1;

    // Comportamento bugado/original preservado:
    // mascara 0x01FF e divide por 16 para coracoes/crops.
    ranch_mastery += (hearts_maria & 0x01FF) >> 4;
    ranch_mastery += (hearts_ann   & 0x01FF) >> 4;
    ranch_mastery += (hearts_nina  & 0x01FF) >> 4;
    ranch_mastery += (hearts_ellen & 0x01FF) >> 4;
    ranch_mastery += (hearts_eve   & 0x01FF) >> 4;

    ranch_mastery += (shipped_tomatoes & 0x01FF) >> 4;
    ranch_mastery += (shipped_corn     & 0x01FF) >> 4;
    ranch_mastery += (shipped_potatoes & 0x01FF) >> 4;
    ranch_mastery += (shipped_turnips  & 0x01FF) >> 4;

    ranch_mastery += happiness >> 5;

    if (player_house_and_event_flags & 0x0080) ranch_mastery += 16;
    if (player_house_and_event_flags & 0x0040) ranch_mastery += 16;
    if (child_flags & 0x0008) ranch_mastery += 16;
    if (child_flags & 0x0004) ranch_mastery += 16;
    if (marriage_flags & 0x001F) ranch_mastery += 32;
    if (child_flags & 0x4000) ranch_mastery += 22;
    if (family_event_flags & 0x1000) ranch_mastery += 21;

    ranch_mastery += ranch_development >> 1;

    for (int cow_slot = 0; cow_slot < 12; cow_slot++) {
        Cow *cow = GetCowPointer(cow_slot);
        if (cow->status & 0x01) {
            int cow_points = cow->happiness >> 3;
            if (cow_points >= 25) cow_points = 25;
            ranch_mastery += cow_points;
        }
    }

    if (ranch_mastery >= 999) ranch_mastery = 999;

    EventScript_LoadScriptPointerLong(0x0000, 0x0046, 0x000C);
    some_result_state = 0x25;
    event_flags_7F1F5E |= 0x8000;
}
```
