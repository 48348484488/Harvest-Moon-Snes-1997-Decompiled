# Pseudocodigo - GameOBJ / Sprite Object Core

```c
int GameOBJ_AllocateAndInitNewSlot(sprite_id, x, y, flip_flags) {
    bank = (sprite_id >= 0x0262) ? 0x87 : 0x86;

    slot = find_free_gobj_slot_or_next_slot();
    if (slot == NONE) {
        return 0xFFFF;
    }

    slot.initialized = 0x7777;
    slot.sprite_id = sprite_id;
    slot.flip = flip_flags;
    slot.x = x;
    slot.y = y;

    anim_ptr = lookup_animation_pointer(bank, sprite_id);
    slot.anim_start = anim_ptr;
    slot.anim_next = anim_ptr + 3;
    slot.component_table = read16(anim_ptr + 0);
    slot.frame_delay = read8(anim_ptr + 2);

    GameOBJ_LoadComponentListAndAcquireVRAM(slot);
    return 0;
}

void GameOBJ_LoadComponentListAndAcquireVRAM(slot) {
    component_count = read8(slot.component_table);
    slot.component_total = component_count;

    for each component in component_table {
        component_id = component.id;
        slot.components.append(component_id);
        SpriteComponent_AcquireVRAMSlot(component_id);
    }
}

void GameOBJ_ClearSlotAndReleaseComponents(slot) {
    for component_id in slot.components {
        if (component_id != 0xFF) {
            SpriteComponent_ReleaseVRAMSlot(component_id);
        }
    }

    slot.initialized = 0;
}

void GameOBJ_UpdateAnimationFrames() {
    for each active GameOBJ slot {
        if (slot.frame_delay == 0) {
            GameOBJ_ReleaseComponentVRAMSlots(slot);
            load_next_animation_frame(slot);
            GameOBJ_LoadComponentListAndAcquireVRAM(slot);
        } else if (slot.frame_delay != 0xFE) {
            slot.frame_delay--;
        }
    }
}
```
