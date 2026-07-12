# Pseudocodigo - NPC / Social Interaction Core

```text
function NPCMapEvent_DispatchByCurrentArea():
    area = tilemap_to_load
    handler = NPCMapEvent_AreaDispatchTable[area]
    call handler
```

```text
function NPCMapEvent_FarmHomeFamilyAndRomanceCheck():
    if child_1_is_old_enough:
        start family child event script

    if child_2_is_old_enough:
        start family child event script

    if current_input_or_event_state_blocks_social_trigger:
        goto fallback_social_checks

    if player_is_already_married:
        goto fallback_social_checks

    if current_time != 06:00:00:
        goto fallback_social_checks

    if day_is_not_allowed_for_romance_trigger:
        goto fallback_social_checks

    if maria_hearts >= 200 and maria_event_not_seen:
        set maria event flag
        start maria event script
        return

    if ann_hearts >= 200 and ann_event_not_seen:
        set ann event flag
        start ann event script
        return

    if nina_hearts >= 200 and nina_event_not_seen:
        set nina event flag
        start nina event script
        return

    if ellen_hearts >= 200 and ellen_event_not_seen:
        set ellen event flag
        start ellen event script
        return

    if eve_hearts >= 200 and eve_event_not_seen:
        set eve event flag
        start eve event script
        return

    fallback_social_checks:
        check other social/story flags
        start matching script if available
```

```text
function Social_AddPlayerHappiness(delta):
    next = happiness + delta

    if next < 0:
        return 1

    if next >= 999:
        happiness = 999
        return 0

    happiness = next
    return 0
```
