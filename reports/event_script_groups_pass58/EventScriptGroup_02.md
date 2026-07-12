# EventScriptGroup_02 symbolic export

- Group id: `$02`
- Group table address: `$B3AE03`
- Pointer entries: `16`
- Unique targets: `6`

This file is generated for decompilation handoff. It keeps dialog as text ids only.

## Entry 00 -> `$B3AE23`

- Commands decoded: `35`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B3AE23 ChangeGameState2()
01 $B3AE24 JumpIfEqualsByte(mem=$7F1F19, value=$02, target=$B3AE36)
02 $B3AE2B StartNestedScriptSlot(slot=$01, target=$B3AECD)
03 $B3AE2F StartNestedScriptSlot(slot=$02, target=$B3AF5A)
04 $B3AE33 Jump(target=$B3AE3E)
05 $B3AE36 StartNestedScriptSlot(slot=$01, target=$B3AE6C)
06 $B3AE3A StartNestedScriptSlot(slot=$02, target=$B3AF0F)
07 $B3AE3E StartNestedScriptSlot(slot=$03, target=$B3AF9C)
08 $B3AE42 StartNestedScriptSlot(slot=$04, target=$B3B008)
09 $B3AE46 StartNestedScriptSlot(slot=$05, target=$B3B07F)
10 $B3AE4A Jump(target=$B3AE53)
11 $B3AE4D WaitOrSetCCCounter(value=$0001)
12 $B3AE50 Jump(target=$B3AE4D)
13 $B3AE53 JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B3AE5E)
14 $B3AE5A StartNestedScriptSlot(slot=$06, target=$B3B0EF)
15 $B3AE5E JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B3AE69)
16 $B3AE65 StartNestedScriptSlot(slot=$07, target=$B3B2B9)
17 $B3AE69 Jump(target=$B3AE4D)
18 $B3AE6C JumpIfBetweenByte(mem=$7F1F1C, low=$11, high=$12, target=$B3AEBE)
19 $B3AE74 SpawnOrMoveCCObject(x=$0128, y=$01B8, visual=$8318, mode=$00)
20 $B3AE7C SetCCObjectBoxOrAnim(a=$1020, b=$2401, c=$83, d=$10)
21 $B3AE83 SetCCObjectAndJump(target=$B3AE8E)
22 $B3AE86 SetCCObjectParam4(a=$AB, ptr=$95AE, d=$AE)
23 $B3AE8B Jump(target=$B3AE83)
24 $B3AE8E StartTextBox(text_id=$01CA, mode=$00)
25 $B3AE92 Jump(target=$B3AE83)
26 $B3AE95 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3AEA4)
27 $B3AE9D StartTextBox(text_id=$0200, mode=$00)
28 $B3AEA1 Jump(target=$B3AE83)
29 $B3AEA4 StartTextBox(text_id=$0049, mode=$00)
30 $B3AEA8 Jump(target=$B3AE83)
31 $B3AEAB JumpIfBetweenByte(mem=$7F1F1C, low=$07, high=$10, target=$B3AEBF)
32 $B3AEB3 JumpIfBetweenByte(mem=$7F1F1C, low=$11, high=$12, target=$B3AEC6)
33 $B3AEBB Jump(target=$B3AE83)
34 $B3AEBE StopOrDisableCCSlot()
```

## Entry 01 -> `$B3B44A`

- Commands decoded: `37`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3B44A ChangeGameState2()
01 $B3B44B StartNestedScriptSlot(slot=$01, target=$B3B459)
02 $B3B44F StartNestedScriptSlot(slot=$02, target=$B3B49E)
03 $B3B453 WaitOrSetCCCounter(value=$0001)
04 $B3B456 Jump(target=$B3B453)
05 $B3B459 SpawnOrMoveCCObject(x=$00A8, y=$0078, visual=$8300, mode=$00)
06 $B3B461 SetCCObjectAndJump(target=$B3B46C)
07 $B3B464 SetCCObjectParam4(a=$89, ptr=$73B4, d=$B4)
08 $B3B469 Jump(target=$B3B461)
09 $B3B46C StartTextBox(text_id=$01C9, mode=$00)
10 $B3B470 Jump(target=$B3B461)
11 $B3B473 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3B482)
12 $B3B47B StartTextBox(text_id=$0200, mode=$00)
13 $B3B47F Jump(target=$B3B461)
14 $B3B482 StartTextBox(text_id=$03B8, mode=$00)
15 $B3B486 Jump(target=$B3B461)
16 $B3B489 JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3B497)
17 $B3B490 StartTextBox(text_id=$0038, mode=$00)
18 $B3B494 Jump(target=$B3B461)
19 $B3B497 StartTextBox(text_id=$01CD, mode=$00)
20 $B3B49B Jump(target=$B3B461)
21 $B3B49E SpawnOrMoveCCObject(x=$0188, y=$00A0, visual=$83F0, mode=$00)
22 $B3B4A6 SetCCObjectAndJump(target=$B3B4B1)
23 $B3B4A9 SetCCObjectParam4(a=$CE, ptr=$B8B4, d=$B4)
24 $B3B4AE Jump(target=$B3B4A6)
25 $B3B4B1 StartTextBox(text_id=$01C6, mode=$00)
26 $B3B4B5 Jump(target=$B3B4A6)
27 $B3B4B8 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3B4C7)
28 $B3B4C0 StartTextBox(text_id=$0200, mode=$00)
29 $B3B4C4 Jump(target=$B3B4A6)
30 $B3B4C7 StartTextBox(text_id=$03B9, mode=$00)
31 $B3B4CB Jump(target=$B3B4A6)
32 $B3B4CE JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3B4DC)
33 $B3B4D5 StartTextBox(text_id=$003D, mode=$00)
34 $B3B4D9 Jump(target=$B3B4A6)
35 $B3B4DC StartTextBox(text_id=$01CE, mode=$00)
36 $B3B4E0 Jump(target=$B3B4A6)
```

## Entry 02 -> `$B3B4E3`

- Commands decoded: `69`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B3B4E3 ChangeGameState2()
01 $B3B4E4 StartNestedScriptSlot(slot=$01, target=$B3B50A)
02 $B3B4E8 StartNestedScriptSlot(slot=$02, target=$B3B54F)
03 $B3B4EC Jump(target=$B3B4F5)
04 $B3B4EF WaitOrSetCCCounter(value=$0001)
05 $B3B4F2 Jump(target=$B3B4EF)
06 $B3B4F5 JumpIfFlagSet(mem=$7F1F66, bit=$00, target=$B3B507)
07 $B3B4FC JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3B507)
08 $B3B503 StartNestedScriptSlot(slot=$03, target=$B3B5CE)
09 $B3B507 Jump(target=$B3B4EF)
10 $B3B50A SpawnOrMoveCCObject(x=$0088, y=$0090, visual=$8354, mode=$00)
11 $B3B512 SetCCObjectAndJump(target=$B3B51D)
12 $B3B515 SetCCObjectParam4(a=$3A, ptr=$24B5, d=$B5)
13 $B3B51A Jump(target=$B3B512)
14 $B3B51D StartTextBox(text_id=$01E0, mode=$00)
15 $B3B521 Jump(target=$B3B4A6)
16 $B3B524 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3B533)
17 $B3B52C StartTextBox(text_id=$0200, mode=$00)
18 $B3B530 Jump(target=$B3B512)
19 $B3B533 StartTextBox(text_id=$03B0, mode=$00)
20 $B3B537 Jump(target=$B3B512)
21 $B3B53A JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3B548)
22 $B3B541 StartTextBox(text_id=$005A, mode=$00)
23 $B3B545 Jump(target=$B3B512)
24 $B3B548 StartTextBox(text_id=$01CF, mode=$00)
25 $B3B54C Jump(target=$B3B512)
26 $B3B54F SpawnOrMoveCCObject(x=$0078, y=$0148, visual=$82E8, mode=$00)
27 $B3B557 SetCCObjectAndJump(target=$B3B562)
28 $B3B55A SetCCObjectParam4(a=$7F, ptr=$69B5, d=$B5)
29 $B3B55F Jump(target=$B3B557)
30 $B3B562 StartTextBox(text_id=$01CA, mode=$00)
31 $B3B566 Jump(target=$B3B557)
32 $B3B569 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3B578)
33 $B3B571 StartTextBox(text_id=$0200, mode=$00)
34 $B3B575 Jump(target=$B3B557)
35 $B3B578 StartTextBox(text_id=$03BB, mode=$00)
36 $B3B57C Jump(target=$B3B557)
37 $B3B57F JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3B5A2)
38 $B3B586 JumpIfFlagSet(mem=$7F1F6A, bit=$0E, target=$B3B5AD)
39 $B3B58D JumpIfFlagSet(mem=$7F1F6C, bit=$00, target=$B3B5B8)
40 $B3B594 JumpIfFlagSet(mem=$7F1F6C, bit=$02, target=$B3B5C3)
41 $B3B59B StartTextBox(text_id=$03EA, mode=$00)
42 $B3B59F Jump(target=$B3B557)
43 $B3B5A2 StartTextBox(text_id=$01D1, mode=$00)
44 $B3B5A6 SetCCObjectParam(param=$0288, value=$00)
45 $B3B5AA Jump(target=$B3B557)
46 $B3B5AD StartTextBox(text_id=$01DD, mode=$00)
47 $B3B5B1 SetCCObjectParam(param=$0288, value=$00)
48 $B3B5B5 Jump(target=$B3B557)
49 $B3B5B8 StartTextBox(text_id=$01E6, mode=$00)
50 $B3B5BC SetCCObjectParam(param=$0288, value=$00)
51 $B3B5C0 Jump(target=$B3B557)
52 $B3B5C3 StartTextBox(text_id=$01EF, mode=$00)
53 $B3B5C7 SetCCObjectParam(param=$0288, value=$00)
54 $B3B5CB Jump(target=$B3B557)
55 $B3B5CE SpawnOrMoveCCObject(x=$0048, y=$0198, visual=$8168, mode=$02)
56 $B3B5D6 SetCCObjectAndJump(target=$B3B5EC)
57 $B3B5D9 SetCCObjectParam4(a=$8F, ptr=$13B6, d=$B6)
58 $B3B5DE Jump(target=$B3B5D6)
59 $B3B5E1 SetCCObjectAndJump(target=$B3B5EC)
60 $B3B5E4 SetCCObjectParam4(a=$DA, ptr=$13B6, d=$B6)
61 $B3B5E9 Jump(target=$B3B5E1)
62 $B3B5EC JumpIfBetweenValue(mem=$7F1F1F, low=$0000, high=$00F9, target=$B3B60C)
63 $B3B5F6 StartTextBox(text_id=$0173, mode=$00)
64 $B3B5FA SetValueByte(mem=$800921, value=$00)
65 $B3B5FF SetFlag(mem=$7F1F66, bit=$00)
66 $B3B604 SetFlag(mem=$7F1F5E, bit=$07)
67 $B3B609 TransitionToMap(value=$2D)
68 $B3B60B StopOrDisableCCSlot()
```

## Entry 03 -> `$B3B6E1`

- Commands decoded: `45`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B3B6E1 ChangeGameState2()
01 $B3B6E2 StartNestedScriptSlot(slot=$01, target=$B3B70F)
02 $B3B6E6 JumpIfFlagSet(mem=$7F1F6C, bit=$04, target=$B3B6FA)
03 $B3B6ED StartNestedScriptSlot(slot=$02, target=$B3B79E)
04 $B3B6F1 Jump(target=$B3B6FA)
05 $B3B6F4 WaitOrSetCCCounter(value=$0001)
06 $B3B6F7 Jump(target=$B3B6F4)
07 $B3B6FA JumpIfFlagSet(mem=$7F1F66, bit=$04, target=$B3B70C)
08 $B3B701 JumpIfFlagSet(mem=$7F1F6C, bit=$04, target=$B3B70C)
09 $B3B708 StartNestedScriptSlot(slot=$03, target=$B3B7DE)
10 $B3B70C Jump(target=$B3B6F4)
11 $B3B70F JumpIfBetweenByte(mem=$7F1F1C, low=$11, high=$12, target=$B3B79D)
12 $B3B717 JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B3B79D)
13 $B3B71E SpawnOrMoveCCObject(x=$0258, y=$0178, visual=$8270, mode=$00)
14 $B3B726 SetCCObjectAndJump(target=$B3B73C)
15 $B3B729 SetCCObjectParam4(a=$59, ptr=$43B7, d=$B7)
16 $B3B72E Jump(target=$B3B726)
17 $B3B731 SetCCObjectAndJump(target=$B3B73C)
18 $B3B734 SetCCObjectParam4(a=$83, ptr=$43B7, d=$B7)
19 $B3B739 Jump(target=$B3B731)
20 $B3B73C StartTextBox(text_id=$01C9, mode=$00)
21 $B3B740 Jump(target=$B3B731)
22 $B3B743 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3B752)
23 $B3B74B StartTextBox(text_id=$0200, mode=$00)
24 $B3B74F Jump(target=$B3B726)
25 $B3B752 StartTextBox(text_id=$03B8, mode=$00)
26 $B3B756 Jump(target=$B3B726)
27 $B3B759 JumpIfBetweenByte(mem=$7F1F1C, low=$11, high=$12, target=$B3B796)
28 $B3B761 StartTextBoxCopy(text_id=$007E, mode=$00)
29 $B3B765 JumpIf018F(value=$00, target=$B3B770)
30 $B3B769 JumpIf018F(value=$01, target=$B3B77C)
31 $B3B76D Jump(target=$B3B726)
32 $B3B770 SetFlag(mem=$7F1F5A, bit=$09)
33 $B3B775 StartTextBox(text_id=$007F, mode=$00)
34 $B3B779 Jump(target=$B3B731)
35 $B3B77C StartTextBox(text_id=$0080, mode=$00)
36 $B3B780 Jump(target=$B3B726)
37 $B3B783 ResetFlagDD(mem=$7F1F5A, bit=$09)
38 $B3B788 StartTextBox(text_id=$0081, mode=$00)
39 $B3B78C Jump(target=$B3B726)
40 $B3B78F StartTextBox(text_id=$0151, mode=$00)
41 $B3B793 Jump(target=$B3B726)
42 $B3B796 StartTextBox(text_id=$0392, mode=$00)
43 $B3B79A Jump(target=$B3B726)
44 $B3B79D StopOrDisableCCSlot()
```

## Entry 04 -> `$B3B8D2`

- Commands decoded: `17`
- Stop reason: `unknown_opcode_$F3`
- Pointer duplicate count: `1`

```text
00 $B3B8D2 ChangeGameState2()
01 $B3B8D3 Jump(target=$B3B8DC)
02 $B3B8D6 WaitOrSetCCCounter(value=$0001)
03 $B3B8D9 Jump(target=$B3B8D6)
04 $B3B8DC JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B3B8EE)
05 $B3B8E3 JumpIfFlagSet(mem=$7F1F6C, bit=$00, target=$B3B8EE)
06 $B3B8EA StartNestedScriptSlot(slot=$01, target=$B3B8F1)
07 $B3B8EE Jump(target=$B3B8D6)
08 $B3B8F1 JumpIfBetweenByte(mem=$7F1F1C, low=$11, high=$12, target=$B3BA38)
09 $B3B8F9 SpawnOrMoveCCObject(x=$0058, y=$01A8, visual=$81D4, mode=$00)
10 $B3B901 SetCCObjectBoxOrAnim(a=$1018, b=$D401, c=$81, d=$10)
11 $B3B908 SetCCObjectAndJump(target=$B3B925)
12 $B3B90B SetCCObjectParam4(a=$C0, ptr=$3DB9, d=$B9)
13 $B3B910 Jump(target=$B3B908)
14 $B3B913 SetCCObjectAndJump(target=$B3B925)
15 $B3B916 SetCCObjectParam2D()
16 $B3B917 UnknownOpcode_$F3()
```

## Entry 05 -> `$B3BA39`

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$59`
- Pointer duplicate count: `11`

```text
00 $B3BA39 UnknownOpcode_$59()
```

## Entry 06 -> `$B3BA39` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$59`
- Pointer duplicate count: `11`

```text
00 $B3BA39 UnknownOpcode_$59()
```

## Entry 07 -> `$B3BA39` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$59`
- Pointer duplicate count: `11`

```text
00 $B3BA39 UnknownOpcode_$59()
```

## Entry 08 -> `$B3BA39` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$59`
- Pointer duplicate count: `11`

```text
00 $B3BA39 UnknownOpcode_$59()
```

## Entry 09 -> `$B3BA39` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$59`
- Pointer duplicate count: `11`

```text
00 $B3BA39 UnknownOpcode_$59()
```

## Entry 10 -> `$B3BA39` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$59`
- Pointer duplicate count: `11`

```text
00 $B3BA39 UnknownOpcode_$59()
```

## Entry 11 -> `$B3BA39` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$59`
- Pointer duplicate count: `11`

```text
00 $B3BA39 UnknownOpcode_$59()
```

## Entry 12 -> `$B3BA39` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$59`
- Pointer duplicate count: `11`

```text
00 $B3BA39 UnknownOpcode_$59()
```

## Entry 13 -> `$B3BA39` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$59`
- Pointer duplicate count: `11`

```text
00 $B3BA39 UnknownOpcode_$59()
```

## Entry 14 -> `$B3BA39` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$59`
- Pointer duplicate count: `11`

```text
00 $B3BA39 UnknownOpcode_$59()
```

## Entry 15 -> `$B3BA39` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$59`
- Pointer duplicate count: `11`

```text
00 $B3BA39 UnknownOpcode_$59()
```

