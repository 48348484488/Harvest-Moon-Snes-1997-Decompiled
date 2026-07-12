# Pseudocódigo — Tool Actions Core

## Entrada principal

```text
ToolAction_StartAnimationOrNoStamina():
    if game_state has NO_STAMINA_FLAG:
        set message/action for exhaustion
        player_action = exhausted_action
        return

    ToolAction_PrecalculateTargetTileAndSound()
    counter_tool_sound = 0
    index = tool_selected * 2
    call ToolAction_AnimationJumpTable[index]
```

## Execução do efeito

```text
ToolAction_ExecuteSelectedToolEffect():
    index = tool_selected * 2
    call ToolAction_EffectJumpTable[index]
    set generic used-tool flag
```

## Check single tile

```text
ToolAction_CheckTargetTileSingle():
    CalculateTileinFront(distance=1, offsetX=0, offsetY=0)
    return CheckToolSuccess(tile_in_front_X, tile_in_front_Y)
```

## Check line

```text
ToolAction_CheckTargetTileLine(step):
    step = step + 1
    CalculateTileinFront(distance=step, offsetX=0, offsetY=0)
    return CheckToolSuccess(tile_in_front_X, tile_in_front_Y)
```

## Check square

```text
ToolAction_CheckTargetTileSquare(step):
    offset = ToolSuccessSquareOffsetsTable[step]
    CalculateTileFromPlayerOffset(offset.x, offset.y)
    return CheckToolSuccess(tile_in_front_X, tile_in_front_Y)
```

## Sementes 3x3

```text
UseSeeds(seed_type):
    if current square tile can accept seed:
        if correct season for seed_type:
            place crop tile
        else:
            place failed/dry seed tile

    step_counter++
    if step_counter == 9:
        step_counter = 0
        seed_count--
        if seed_count == 0:
            tool_selected = 0
        player_action = 0
        stamina += -1
```

## Ração de animal

```text
UseAnimalFeed(kind):
    if kind == chicken and current_map == coop:
        if target tile is feeder slot:
            set bit in fed_chicks_flags
            fed_chicks_N++
            change feeder tile to filled
        else:
            spawn miss/fail effect
        feed_chicks_N--

    if kind == cow and current_map == barn:
        if target tile is feeder slot:
            set bit in fed_cows_flags
            fed_cows_N++
            change feeder tile to filled
        else:
            spawn miss/fail effect
        feed_cow_N--

    if feed count is zero:
        tool_selected = 0

    stamina += -2
    player_action = 0
```
