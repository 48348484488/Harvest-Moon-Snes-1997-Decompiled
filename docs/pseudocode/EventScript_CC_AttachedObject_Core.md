# Pseudocodigo - EventScript CC Slot / Attached Object Core

```c
EventSlot* EventScript_SetCCPointerBySlot(uint16 slot_index) {
    // $CC-$CE = $7E:B586 + slot_index * 0x40
    return (EventSlot*)($7EB586 + slot_index * 0x40);
}
```

```c
void EventScript_UpdateAllActiveSlots() {
    if (input_state == 0x02 || input_state == 0x06 || player_action == 0x0003) {
        clear_transient_event_flags();
        return;
    }

    rng_byte = RNG_GetNextByte();

    for (slot_index = 0; slot_index < 0x31; slot_index++) {
        slot = EventScript_SetCCPointerBySlot(slot_index);

        if (!slot->active) {
            continue;
        }

        if (slot->wait_timer != 0) {
            slot->wait_timer--;
        } else {
            do {
                EventScript_ExecuteNextOpcode(slot);
            } while (slot->active && slot->wait_timer == 0);
        }

        rng_byte += 0x33;

        if (slot->flags & 0x01) {
            EventScript_UpdateAttachedObjectState(slot);
        }
    }

    clear_transient_event_flags();
}
```

```c
void EventScript_UpdateAttachedObjectState(EventSlot* slot) {
    if (!(slot->flags & 0x10)) {
        EventScript_UpdateAttachedObjectMotionPattern(slot);
        EventScript_ApplyAttachedObjectVelocity(slot);
    }

    scratch.gobj_slot = slot->attached_gobj_slot;
    scratch.visual_flags = slot->object_visual_flags;
    scratch.x = slot->object_x;
    scratch.y = slot->object_y;
    scratch.sprite_state = slot->object_sprite_state;

    if (slot->flags & 0x40) {
        GameOBJ_ClearSlotAndReleaseComponents(scratch.gobj_slot);
    } else if (slot->flags & 0x02) {
        slot->attached_gobj_slot = GameOBJ_AllocateAndInitNewSlot(scratch);
    } else if (slot->flags & 0x04) {
        if (slot->object_sprite_state != slot->object_sprite_state_prev) {
            GameOBJ_ReinitializeExistingSlotMetadata(scratch.gobj_slot);
        }
    } else {
        GameOBJ_UpdateExistingSlotTransform(scratch.gobj_slot, scratch.x, scratch.y);
    }

    slot->object_sprite_state_prev = slot->object_sprite_state;
    slot->flags &= 0xE9;
}
```

```c
void EventScript_ApplyAttachedObjectVelocity(EventSlot* slot) {
    if (!(slot->flags & 0x20)) {
        return;
    }

    slot->motion_timer--;
    if (slot->motion_timer != 0) {
        return;
    }

    slot->motion_timer = slot->motion_timer_reload;
    slot->object_x += sign_extend(slot->velocity_x);
    slot->object_y += sign_extend(slot->velocity_y);
}
```

```c
void EventScript_LoadAttachedObjectVisualState(EventSlot* slot, uint24 table_ptr) {
    // table entries are 3 bytes: word sprite_state, byte visual_flags_shifted
    index = slot->object_state_index;
    entry = table_ptr + index * 3;

    slot->object_sprite_state = read_u16(entry + 0);
    slot->object_visual_flags = read_u8(entry + 2) << 6;
}
```

```c
void MapTile_FillRectCurrentMap(uint8 tile, uint16 start_x, uint16 start_y, uint8 width, uint8 height) {
    for (row = 0; row < height; row++) {
        for (col = 0; col < width; col++) {
            map_x = start_x + col * 0x10;
            map_y = start_y + row * 0x10;
            current_map_array[GetTileIndex(map_x, map_y)] = tile;
        }
    }
}
```
