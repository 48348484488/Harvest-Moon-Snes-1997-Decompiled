# Pseudocodigo - Player Movement / Collision / Interaction Core

```c
void PlayerInput_NormalMovementCore(void) {
    if (game_state & CONTROL_BLOCK_FLAGS) return;
    if (player_action == ACTION_JUMP) return;
    if (some_event_lock_flags_active()) return;

    if (action_blocks_interaction[player_action]) return;

    if (joy_current & DOWN)  { start_walk(DIR_DOWN);  process_action_buttons(); return; }
    if (joy_current & UP)    { start_walk(DIR_UP);    process_action_buttons(); return; }
    if (joy_current & LEFT)  { start_walk(DIR_LEFT);  process_action_buttons(); return; }
    if (joy_current & RIGHT) { start_walk(DIR_RIGHT); process_action_buttons(); return; }

    process_action_buttons();
}

void process_action_buttons(void) {
    if (player_action == ACTION_READY_TO_CAST) { use_tool_or_fishing(); return; }

    if (joy_new & A) { interact_or_drop(); return; }

    if (!(game_state & ACTION_BUTTON_BLOCK)) {
        if (joy_current & B) { run_or_jump(); return; }
    }

    if (joy_new & SELECT) { action_select(); return; }
    if (joy_new & X)      { action_x(); return; }
    if (joy_new & R)      { whistle_horse(); return; }
    if (joy_new & L)      { whistle_dog(); return; }
    if (joy_new & Y)      { use_tool_or_fishing(); return; }
}

void start_walk(Direction dir) {
    player_action = ACTION_WALK;
    player_direction = dir;
    movement_direction_scratch = dir;
}

void interact_or_drop(void) {
    if (game_state & ANIMATION_LOCK) {
        try_pickup_or_ground_object();
        return;
    }

    if (game_state & CARRYING_ITEM_OR_DOG) {
        try_throw_or_place_held_object();
        return;
    }

    if (special_ground_flags_active()) {
        special_ground_interact();
        return;
    }

    if (holding_item()) {
        player_action = ACTION_DROP_ITEM;
        return;
    }

    calculate_tile_in_front(player_pos, player_direction);
    tile_info = check_tile_properties(tile_in_front);
    dispatch_facing_tile_action(tile_info);
}

bool check_ahead_for_object_or_blocked_tile(Direction dir) {
    projected_box = project_hitbox(player_pos, dir);

    if (object_overlap(projected_box))
        return true;

    if (map_tile_blocked(projected_box))
        return true;

    return false;
}

void use_tool_or_fishing(void) {
    if (blocked_by_item_or_animation_flags()) return;

    if (player_action == ACTION_READY_TO_CAST) {
        player_action = ACTION_CASTING;
        return;
    }

    if (player_action == ACTION_FISHING) {
        player_action = ACTION_READY_TO_CAST;
        return;
    }

    if (player_action == ACTION_FISHING_BITE) {
        player_action = ACTION_REELING;
        rolled_catch_text_or_item();
        return;
    }

    if (tool_selected != 0) {
        player_action = ACTION_USING_TOOL;
        ToolAction_StartAnimationOrNoStamina();
    }
}
```
