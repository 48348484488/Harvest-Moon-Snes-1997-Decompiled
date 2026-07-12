# EventScriptGroup_03 symbolic export

- Group id: `$03`
- Group table address: `$B3BA39`
- Pointer entries: `16`
- Unique targets: `4`

This file is generated for decompilation handoff. It keeps dialog as text ids only.

## Entry 00 -> `$B3BA59`

- Commands decoded: `23`
- Stop reason: `unknown_opcode_$DB`
- Pointer duplicate count: `1`

```text
00 $B3BA59 ChangeGameState2()
01 $B3BA5A StartNestedScriptSlot(slot=$01, target=$B3BB19)
02 $B3BA5E StartNestedScriptSlot(slot=$02, target=$B3BBBB)
03 $B3BA62 StartNestedScriptSlot(slot=$03, target=$B3BC06)
04 $B3BA66 StartNestedScriptSlot(slot=$04, target=$B3BC51)
05 $B3BA6A StartNestedScriptSlot(slot=$05, target=$B3BCB9)
06 $B3BA6E JumpIfFlagSet(mem=$7F1F6C, bit=$06, target=$B3BAB8)
07 $B3BA75 JumpIfFlagSet(mem=$7F1F64, bit=$06, target=$B3BA7F)
08 $B3BA7C Jump(target=$B3BAB8)
09 $B3BA7F JumpIfBetweenValue(mem=$7F1F1F, low=$00FA, high=$03E7, target=$B3BAB4)
10 $B3BA89 JumpIfBetweenValue(mem=$7F1F21, low=$00FA, high=$03E7, target=$B3BAB4)
11 $B3BA93 JumpIfBetweenValue(mem=$7F1F23, low=$00FA, high=$03E7, target=$B3BAB4)
12 $B3BA9D JumpIfBetweenValue(mem=$7F1F25, low=$00FA, high=$03E7, target=$B3BAB4)
13 $B3BAA7 JumpIfBetweenValue(mem=$7F1F27, low=$00FA, high=$03E7, target=$B3BAB4)
14 $B3BAB1 Jump(target=$B3BAB8)
15 $B3BAB4 StartNestedScriptSlot(slot=$06, target=$B3BAC5)
16 $B3BAB8 WaitOrSetCCCounter(value=$0001)
17 $B3BABB Jump(target=$B3BAB8)
18 $B3BABE JumpIfFlagSet(mem=$7F1F66, bit=$04, target=$B3C1FD)
19 $B3BAC5 JumpIfBetweenByte(mem=$7F1F1C, low=$11, high=$12, target=$B3BB18)
20 $B3BACD SpawnOrMoveCCObject(x=$0238, y=$0168, visual=$8AA4, mode=$00)
21 $B3BAD5 SetCCObjectParam2D()
22 $B3BAD6 UnknownOpcode_$DB()
```

## Entry 01 -> `$B3BD2D`

- Commands decoded: `128`
- Stop reason: `max_commands`
- Pointer duplicate count: `1`

```text
00 $B3BD2D ChangeGameState2()
01 $B3BD2E StartNestedScriptSlot(slot=$01, target=$B3BD7A)
02 $B3BD32 StartNestedScriptSlot(slot=$02, target=$B3BDBF)
03 $B3BD36 StartNestedScriptSlot(slot=$03, target=$B3BE18)
04 $B3BD3A StartNestedScriptSlot(slot=$04, target=$B3BE71)
05 $B3BD3E StartNestedScriptSlot(slot=$05, target=$B3BECA)
06 $B3BD42 StartNestedScriptSlot(slot=$06, target=$B3BF01)
07 $B3BD46 Jump(target=$B3BD4F)
08 $B3BD49 WaitOrSetCCCounter(value=$0001)
09 $B3BD4C Jump(target=$B3BD49)
10 $B3BD4F JumpIfFlagSet(mem=$7F1F66, bit=$00, target=$B3BD61)
11 $B3BD56 JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3BD61)
12 $B3BD5D StartNestedScriptSlot(slot=$09, target=$B3BF5A)
13 $B3BD61 JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B3BD6C)
14 $B3BD68 StartNestedScriptSlot(slot=$0A, target=$B3C03A)
15 $B3BD6C JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B3BD77)
16 $B3BD73 StartNestedScriptSlot(slot=$0B, target=$B3C127)
17 $B3BD77 Jump(target=$B3BD49)
18 $B3BD7A SpawnOrMoveCCObject(x=$0080, y=$0090, visual=$8354, mode=$00)
19 $B3BD82 SetCCObjectAndJump(target=$B3BD8D)
20 $B3BD85 SetCCObjectParam4(a=$AA, ptr=$94BD, d=$BD)
21 $B3BD8A Jump(target=$B3BD82)
22 $B3BD8D StartTextBox(text_id=$01E0, mode=$00)
23 $B3BD91 Jump(target=$B3BE20)
24 $B3BD94 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3BDA3)
25 $B3BD9C StartTextBox(text_id=$0200, mode=$00)
26 $B3BDA0 Jump(target=$B3BD82)
27 $B3BDA3 StartTextBox(text_id=$03B0, mode=$00)
28 $B3BDA7 Jump(target=$B3BD82)
29 $B3BDAA JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3BDB8)
30 $B3BDB1 StartTextBox(text_id=$0059, mode=$00)
31 $B3BDB5 Jump(target=$B3BD82)
32 $B3BDB8 StartTextBox(text_id=$01CF, mode=$00)
33 $B3BDBC Jump(target=$B3BD82)
34 $B3BDBF SpawnOrMoveCCObject(x=$0058, y=$0118, visual=$8300, mode=$01)
35 $B3BDC7 SetCCObjectAndJump(target=$B3BDD2)
36 $B3BDCA SetCCObjectParam4(a=$FB, ptr=$DDBD, d=$BD)
37 $B3BDCF Jump(target=$B3BDC7)
38 $B3BDD2 StartTextBox(text_id=$01C9, mode=$00)
39 $B3BDD6 SetCCObjectParam(param=$0291, value=$00)
40 $B3BDDA Jump(target=$B3BDC7)
41 $B3BDDD JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3BDF0)
42 $B3BDE5 StartTextBox(text_id=$0200, mode=$00)
43 $B3BDE9 SetCCObjectParam(param=$0291, value=$00)
44 $B3BDED Jump(target=$B3BDC7)
45 $B3BDF0 StartTextBox(text_id=$03B8, mode=$00)
46 $B3BDF4 SetCCObjectParam(param=$0291, value=$00)
47 $B3BDF8 Jump(target=$B3BDC7)
48 $B3BDFB JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3BE0D)
49 $B3BE02 StartTextBox(text_id=$0037, mode=$00)
50 $B3BE06 SetCCObjectParam(param=$0291, value=$00)
51 $B3BE0A Jump(target=$B3BDC7)
52 $B3BE0D StartTextBox(text_id=$01CD, mode=$00)
53 $B3BE11 SetCCObjectParam(param=$0291, value=$00)
54 $B3BE15 Jump(target=$B3BDC7)
55 $B3BE18 SpawnOrMoveCCObject(x=$0038, y=$0118, visual=$83D8, mode=$01)
56 $B3BE20 SetCCObjectAndJump(target=$B3BE2B)
57 $B3BE23 SetCCObjectParam4(a=$54, ptr=$36BE, d=$BE)
58 $B3BE28 Jump(target=$B3BE20)
59 $B3BE2B StartTextBox(text_id=$01C6, mode=$00)
60 $B3BE2F SetCCObjectParam(param=$02C6, value=$00)
61 $B3BE33 Jump(target=$B3BE20)
62 $B3BE36 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3BE49)
63 $B3BE3E StartTextBox(text_id=$0200, mode=$00)
64 $B3BE42 SetCCObjectParam(param=$02C6, value=$00)
65 $B3BE46 Jump(target=$B3BE20)
66 $B3BE49 StartTextBox(text_id=$03B9, mode=$00)
67 $B3BE4D SetCCObjectParam(param=$02C6, value=$00)
68 $B3BE51 Jump(target=$B3BE20)
69 $B3BE54 JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3BE66)
70 $B3BE5B StartTextBox(text_id=$003C, mode=$00)
71 $B3BE5F SetCCObjectParam(param=$02C6, value=$00)
72 $B3BE63 Jump(target=$B3BE20)
73 $B3BE66 StartTextBox(text_id=$01CE, mode=$00)
74 $B3BE6A SetCCObjectParam(param=$02C6, value=$00)
75 $B3BE6E Jump(target=$B3BE20)
76 $B3BE71 SpawnOrMoveCCObject(x=$00A8, y=$0118, visual=$8318, mode=$01)
77 $B3BE79 SetCCObjectAndJump(target=$B3BE84)
78 $B3BE7C SetCCObjectParam4(a=$AD, ptr=$8FBE, d=$BE)
79 $B3BE81 Jump(target=$B3BE79)
... truncated after 80 commands; use CSV/index for full count.
```

## Entry 02 -> `$B3C1E4`

- Commands decoded: `30`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B3C1E4 ChangeGameState2()
01 $B3C1E5 StartNestedScriptSlot(slot=$01, target=$B3C482)
02 $B3C1E9 JumpIfFlagSet(mem=$7F1F6C, bit=$04, target=$B3C1FD)
03 $B3C1F0 StartNestedScriptSlot(slot=$02, target=$B3C224)
04 $B3C1F4 Jump(target=$B3C1FD)
05 $B3C1F7 WaitOrSetCCCounter(value=$0001)
06 $B3C1FA Jump(target=$B3C1F7)
07 $B3C1FD JumpIfFlagSet(mem=$7F1F66, bit=$04, target=$B3C20F)
08 $B3C204 JumpIfFlagSet(mem=$7F1F6C, bit=$04, target=$B3C20F)
09 $B3C20B StartNestedScriptSlot(slot=$03, target=$B3C273)
10 $B3C20F JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B3C221)
11 $B3C216 JumpIfFlagSet(mem=$7F1F6C, bit=$00, target=$B3C221)
12 $B3C21D StartNestedScriptSlot(slot=$04, target=$B3C2DF)
13 $B3C221 Jump(target=$B3C1F7)
14 $B3C224 JumpIfBetweenByte(mem=$7F1F1C, low=$11, high=$12, target=$B3C26B)
15 $B3C22C SpawnOrMoveCCObject(x=$0068, y=$0038, visual=$82D0, mode=$00)
16 $B3C234 SetCCObjectAndJump(target=$B3C23F)
17 $B3C237 SetCCObjectParam4(a=$5C, ptr=$46C2, d=$C2)
18 $B3C23C Jump(target=$B3C234)
19 $B3C23F StartTextBox(text_id=$01C9, mode=$00)
20 $B3C243 Jump(target=$B3C234)
21 $B3C246 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3C255)
22 $B3C24E StartTextBox(text_id=$03BC, mode=$00)
23 $B3C252 Jump(target=$B3C234)
24 $B3C255 StartTextBox(text_id=$0049, mode=$00)
25 $B3C259 Jump(target=$B3C234)
26 $B3C25C JumpIfBetweenByte(mem=$7F1F1C, low=$11, high=$12, target=$B3C26C)
27 $B3C264 StartTextBox(text_id=$007D, mode=$00)
28 $B3C268 Jump(target=$B3C234)
29 $B3C26B StopOrDisableCCSlot()
```

## Entry 03 -> `$B3C507`

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$C6`
- Pointer duplicate count: `13`

```text
00 $B3C507 ResetFlagD(mem=$C6AEC5, bit=$FE)
01 $B3C50C UnknownOpcode_$C6()
```

## Entry 04 -> `$B3C507` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$C6`
- Pointer duplicate count: `13`

```text
00 $B3C507 ResetFlagD(mem=$C6AEC5, bit=$FE)
01 $B3C50C UnknownOpcode_$C6()
```

## Entry 05 -> `$B3C507` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$C6`
- Pointer duplicate count: `13`

```text
00 $B3C507 ResetFlagD(mem=$C6AEC5, bit=$FE)
01 $B3C50C UnknownOpcode_$C6()
```

## Entry 06 -> `$B3C507` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$C6`
- Pointer duplicate count: `13`

```text
00 $B3C507 ResetFlagD(mem=$C6AEC5, bit=$FE)
01 $B3C50C UnknownOpcode_$C6()
```

## Entry 07 -> `$B3C507` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$C6`
- Pointer duplicate count: `13`

```text
00 $B3C507 ResetFlagD(mem=$C6AEC5, bit=$FE)
01 $B3C50C UnknownOpcode_$C6()
```

## Entry 08 -> `$B3C507` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$C6`
- Pointer duplicate count: `13`

```text
00 $B3C507 ResetFlagD(mem=$C6AEC5, bit=$FE)
01 $B3C50C UnknownOpcode_$C6()
```

## Entry 09 -> `$B3C507` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$C6`
- Pointer duplicate count: `13`

```text
00 $B3C507 ResetFlagD(mem=$C6AEC5, bit=$FE)
01 $B3C50C UnknownOpcode_$C6()
```

## Entry 10 -> `$B3C507` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$C6`
- Pointer duplicate count: `13`

```text
00 $B3C507 ResetFlagD(mem=$C6AEC5, bit=$FE)
01 $B3C50C UnknownOpcode_$C6()
```

## Entry 11 -> `$B3C507` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$C6`
- Pointer duplicate count: `13`

```text
00 $B3C507 ResetFlagD(mem=$C6AEC5, bit=$FE)
01 $B3C50C UnknownOpcode_$C6()
```

## Entry 12 -> `$B3C507` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$C6`
- Pointer duplicate count: `13`

```text
00 $B3C507 ResetFlagD(mem=$C6AEC5, bit=$FE)
01 $B3C50C UnknownOpcode_$C6()
```

## Entry 13 -> `$B3C507` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$C6`
- Pointer duplicate count: `13`

```text
00 $B3C507 ResetFlagD(mem=$C6AEC5, bit=$FE)
01 $B3C50C UnknownOpcode_$C6()
```

## Entry 14 -> `$B3C507` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$C6`
- Pointer duplicate count: `13`

```text
00 $B3C507 ResetFlagD(mem=$C6AEC5, bit=$FE)
01 $B3C50C UnknownOpcode_$C6()
```

## Entry 15 -> `$B3C507` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$C6`
- Pointer duplicate count: `13`

```text
00 $B3C507 ResetFlagD(mem=$C6AEC5, bit=$FE)
01 $B3C50C UnknownOpcode_$C6()
```

