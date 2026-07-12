# Pseudocodigo - Stamina / Fatigue Core

```c
void Stamina_ApplyDeltaAndFatigueState(int8_t delta) {
    if (flags_7F1F60 & 0x0008) {
        return;
    }

    int new_value = current_stamina + delta;

    if (new_value <= 0) {
        current_stamina = 0;
        game_state |= 0x0008;          // sem stamina
        animation_state_0901 = 0x004D; // fadiga total
        player_action = 0x000B;        // acao de cansaco
        update_fatigue_stage_after_delta(delta);
        return;
    }

    if (new_value >= max_stamina) {
        current_stamina = max_stamina;
        game_state &= ~0x0008;
        update_fatigue_stage_after_delta(delta);
        return;
    }

    current_stamina = new_value;
    game_state &= ~0x0008;
    update_fatigue_stage_after_delta(delta);
}

void update_fatigue_stage_after_delta(int8_t delta) {
    if (delta >= 0) {
        // Recalcula o nivel atual conforme max/2, max/4, max/8...
        fatigue_stage = threshold_stage_for(current_stamina, max_stamina);
        return;
    }

    if (fatigue_stage == 3) {
        return;
    }

    uint8_t threshold = max_stamina >> fatigue_stage;
    if (current_stamina <= threshold) {
        animation_state_0901 = 0x004A + fatigue_stage;
        fatigue_stage++;
        player_action = 0x000B;
    }
}
```

Observacao: os nomes acima representam a logica humana. O codigo real continua em Assembly 65816 dentro de `src/`.
