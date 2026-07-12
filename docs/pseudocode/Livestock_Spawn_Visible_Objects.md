# Pseudocodigo - spawn/render dos objetos de animais

Baseado em `Livestock_SpawnVisibleAnimalObjects`.

```c
void Livestock_SpawnVisibleAnimalObjects() {
    for chicken_slot in 0..12 {
        chicken = GetChickenPointer(chicken_slot);
        if (!chicken.exists) continue;
        if (chicken.has_hidden_flag) continue;
        if (!is_same_map_group(chicken.map, current_map)) continue;

        set_temp_position(chicken.x, chicken.y);

        if (chicken.is_hatching_egg) {
            SpawnGOBJ(slot + 0x24, variant_egg);
        } else if (chicken.is_chick) {
            SpawnGOBJ(slot + 0x24, variant_chick);
        } else if (chicken.is_adult) {
            SpawnGOBJ(slot + 0x24, variant_chicken);
            clear_related_runtime_flag_for_slot();
        } else {
            SpawnGOBJ(slot + 0x24, fallback_variant);
        }
    }

    for cow_slot in 0..11 {
        cow = GetCowPointer(cow_slot);
        if (!cow.exists) continue;
        if (!is_same_map_group(cow.map, current_map)) continue;

        if (current_map == BARN && cow.map == BARN) {
            position = Cow_BarnSpawnPositionTable[cow_slot];
        } else {
            position = cow.x_y_from_slot;
        }

        if (cow.is_baby) spawn baby cow object;
        else if (cow.is_child) spawn child cow object;
        else if (cow.is_adult) {
            choose variant by pregnant/sick/cranky/outside/weather flags;
            spawn adult cow object;
        }
    }

    if (dog_exists && dog_map_matches_current_map && player_not_carrying_dog) {
        spawn dog object;
    }

    if (horse_exists && horse_map_matches_current_map) {
        spawn horse object;
    }
}
```
