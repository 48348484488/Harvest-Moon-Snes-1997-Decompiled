# EventScriptGroup_0B symbolic export

- Group id: `$0B`
- Group table address: `$B3E9DA`
- Pointer entries: `16`
- Unique targets: `13`

This file is generated for decompilation handoff. It keeps dialog as text ids only.

## Entry 00 -> `$B3E9FA`

- Commands decoded: `12`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B3E9FA StopTimeFlow()
01 $B3E9FB SetHour(hour=7)
02 $B3E9FD StartNestedScriptSlot(slot=$01, target=$B3EA1F)
03 $B3EA01 StartNestedScriptSlot(slot=$02, target=$B3EA3B)
04 $B3EA05 StartNestedScriptSlot(slot=$03, target=$B3EA5D)
05 $B3EA09 StartNestedScriptSlot(slot=$04, target=$B3EA79)
06 $B3EA0D StartNestedScriptSlot(slot=$05, target=$B3EA9B)
07 $B3EA11 StartNestedScriptSlot(slot=$06, target=$B3EAC9)
08 $B3EA15 StartNestedScriptSlot(slot=$07, target=$B3EADE)
09 $B3EA19 StartNestedScriptSlot(slot=$08, target=$B3EAF8)
10 $B3EA1D EventCoreUNK2()
11 $B3EA1E StopOrDisableCCSlot()
```

## Entry 01 -> `$B3EB5C`

- Commands decoded: `2`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B3EB5C StartNestedScriptSlot(slot=$01, target=$B3EB61)
01 $B3EB60 StopOrDisableCCSlot()
```

## Entry 02 -> `$B3EB83`

- Commands decoded: `2`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B3EB83 StartNestedScriptSlot(slot=$01, target=$B3EB88)
01 $B3EB87 StopOrDisableCCSlot()
```

## Entry 03 -> `$B3EBB2`

- Commands decoded: `3`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B3EBB2 StartNestedScriptSlot(slot=$01, target=$B3EBBB)
01 $B3EBB6 StartNestedScriptSlot(slot=$02, target=$B3EBE2)
02 $B3EBBA StopOrDisableCCSlot()
```

## Entry 04 -> `$B3EC2D`

- Commands decoded: `4`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B3EC2D StartNestedScriptSlot(slot=$01, target=$B3EC3A)
01 $B3EC31 StartNestedScriptSlot(slot=$02, target=$B3EC67)
02 $B3EC35 StartNestedScriptSlot(slot=$03, target=$B3EC7F)
03 $B3EC39 StopOrDisableCCSlot()
```

## Entry 05 -> `$B3EC8D`

- Commands decoded: `3`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B3EC8D StartNestedScriptSlot(slot=$01, target=$B3EC96)
01 $B3EC91 StartNestedScriptSlot(slot=$02, target=$B3ECC0)
02 $B3EC95 StopOrDisableCCSlot()
```

## Entry 06 -> `$B3ECE2`

- Commands decoded: `2`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B3ECE2 StartNestedScriptSlot(slot=$01, target=$B3ECE7)
01 $B3ECE6 StopOrDisableCCSlot()
```

## Entry 07 -> `$B3ED39`

- Commands decoded: `7`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B3ED39 StartNestedScriptSlot(slot=$01, target=$B3ED52)
01 $B3ED3D StartNestedScriptSlot(slot=$02, target=$B3ED7A)
02 $B3ED41 StartNestedScriptSlot(slot=$03, target=$B3EDF0)
03 $B3ED45 StartNestedScriptSlot(slot=$04, target=$B3ED9C)
04 $B3ED49 StartNestedScriptSlot(slot=$05, target=$B3EDC6)
05 $B3ED4D StartNestedScriptSlot(slot=$06, target=$B3EE05)
06 $B3ED51 StopOrDisableCCSlot()
```

## Entry 08 -> `$B3EE1A`

- Commands decoded: `16`
- Stop reason: `unknown_opcode_$EE`
- Pointer duplicate count: `2`

```text
00 $B3EE1A SetPlayerDirection(dir=$01)
01 $B3EE1C ChangeGameState()
02 $B3EE1D StartNestedScriptSlot(slot=$01, target=$B3EE39)
03 $B3EE21 StartNestedScriptSlot(slot=$02, target=$B3EE64)
04 $B3EE25 StartNestedScriptSlot(slot=$03, target=$B3EE82)
05 $B3EE29 StartNestedScriptSlot(slot=$04, target=$B3EEA7)
06 $B3EE2D StartNestedScriptSlot(slot=$05, target=$B3EECC)
07 $B3EE31 EventCoreUNK2()
08 $B3EE32 ChangeGameState2()
09 $B3EE33 WaitOrSetCCCounter(value=$0001)
10 $B3EE36 Jump(target=$B3EE33)
11 $B3EE39 JumpIfBetweenByte(mem=$7F1F1C, low=$11, high=$12, target=$B3EE63)
12 $B3EE41 SpawnOrMoveCCObject(x=$0258, y=$0178, visual=$8270, mode=$00)
13 $B3EE49 SetCCObjectParam2D()
14 $B3EE4A JumpIfIndirectBitClear(mem=$4912EE, bit=$EE, target=$B35C1F)
15 $B3EE51 UnknownOpcode_$EE()
```

## Entry 09 -> `$B3EE1A` duplicate_target

- Commands decoded: `16`
- Stop reason: `unknown_opcode_$EE`
- Pointer duplicate count: `2`

```text
00 $B3EE1A SetPlayerDirection(dir=$01)
01 $B3EE1C ChangeGameState()
02 $B3EE1D StartNestedScriptSlot(slot=$01, target=$B3EE39)
03 $B3EE21 StartNestedScriptSlot(slot=$02, target=$B3EE64)
04 $B3EE25 StartNestedScriptSlot(slot=$03, target=$B3EE82)
05 $B3EE29 StartNestedScriptSlot(slot=$04, target=$B3EEA7)
06 $B3EE2D StartNestedScriptSlot(slot=$05, target=$B3EECC)
07 $B3EE31 EventCoreUNK2()
08 $B3EE32 ChangeGameState2()
09 $B3EE33 WaitOrSetCCCounter(value=$0001)
10 $B3EE36 Jump(target=$B3EE33)
11 $B3EE39 JumpIfBetweenByte(mem=$7F1F1C, low=$11, high=$12, target=$B3EE63)
12 $B3EE41 SpawnOrMoveCCObject(x=$0258, y=$0178, visual=$8270, mode=$00)
13 $B3EE49 SetCCObjectParam2D()
14 $B3EE4A JumpIfIndirectBitClear(mem=$4912EE, bit=$EE, target=$B35C1F)
15 $B3EE51 UnknownOpcode_$EE()
```

## Entry 10 -> `$B3EEEA`

- Commands decoded: `10`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3EEEA StartNestedScriptSlot(slot=$01, target=$B3EEF5)
01 $B3EEEE EventCoreUNK2()
02 $B3EEEF WaitOrSetCCCounter(value=$0001)
03 $B3EEF2 Jump(target=$B3EEEF)
04 $B3EEF5 SpawnOrMoveCCObject(x=$0098, y=$0088, visual=$8234, mode=$02)
05 $B3EEFD SetCCObjectParam2D()
06 $B3EEFE SetHour(hour=239)
07 $B3EF00 Jump(target=$B3EEFD)
08 $B3EF03 StartTextBox(text_id=$012A, mode=$00)
09 $B3EF07 Jump(target=$B3EEFD)
```

## Entry 11 -> `$B3EF0A`

- Commands decoded: `9`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B3EF0A StopTimeFlow()
01 $B3EF0B SetPlayerPosition(x=$0088, y=$0128)
02 $B3EF10 ChangeGameState()
03 $B3EF11 StartNestedScriptSlot(slot=$01, target=$B3EF1C)
04 $B3EF15 EventCoreUNK2()
05 $B3EF16 Set7AFlag(value=$00)
06 $B3EF18 Compare7AFlag(value=$01)
07 $B3EF1A TransitionToHouse()
08 $B3EF1B StopOrDisableCCSlot()
```

## Entry 12 -> `$B3EF2E`

- Commands decoded: `2`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B3EF2E StartNestedScriptSlot(slot=$01, target=$B3EF33)
01 $B3EF32 StopOrDisableCCSlot()
```

## Entry 13 -> `$B3EF5A`

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$7A`
- Pointer duplicate count: `3`

```text
00 $B3EF5A UnknownOpcode_$7A()
```

## Entry 14 -> `$B3EF5A` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$7A`
- Pointer duplicate count: `3`

```text
00 $B3EF5A UnknownOpcode_$7A()
```

## Entry 15 -> `$B3EF5A` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$7A`
- Pointer duplicate count: `3`

```text
00 $B3EF5A UnknownOpcode_$7A()
```

