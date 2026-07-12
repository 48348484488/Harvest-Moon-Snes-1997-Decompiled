# EventScriptGroup_05 symbolic export

- Group id: `$05`
- Group table address: `$B3CC71`
- Pointer entries: `16`
- Unique targets: `2`

This file is generated for decompilation handoff. It keeps dialog as text ids only.

## Entry 00 -> `$B3CC91`

- Commands decoded: `93`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B3CC91 ChangeGameState2()
01 $B3CC92 StartNestedScriptSlot(slot=$01, target=$B3CCDB)
02 $B3CC96 StartNestedScriptSlot(slot=$02, target=$B3CD7C)
03 $B3CC9A StartNestedScriptSlot(slot=$03, target=$B3CDB6)
04 $B3CC9E StartNestedScriptSlot(slot=$04, target=$B3CE2C)
05 $B3CCA2 StartNestedScriptSlot(slot=$05, target=$B3CE8C)
06 $B3CCA6 StartNestedScriptSlot(slot=$06, target=$B3CF69)
07 $B3CCAA StartNestedScriptSlot(slot=$07, target=$B3D04A)
08 $B3CCAE StartNestedScriptSlot(slot=$08, target=$B3D10A)
09 $B3CCB2 Jump(target=$B3CCBB)
10 $B3CCB5 WaitOrSetCCCounter(value=$0001)
11 $B3CCB8 Jump(target=$B3CCB5)
12 $B3CCBB JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B3CCC6)
13 $B3CCC2 StartNestedScriptSlot(slot=$09, target=$B3D1B0)
14 $B3CCC6 JumpIfFlagSet(mem=$7F1F66, bit=$04, target=$B3CCD8)
15 $B3CCCD JumpIfFlagSet(mem=$7F1F6C, bit=$04, target=$B3CCD8)
16 $B3CCD4 StartNestedScriptSlot(slot=$0A, target=$B3D213)
17 $B3CCD8 Jump(target=$B3CCB5)
18 $B3CCDB SpawnOrMoveCCObject(x=$0028, y=$0198, visual=$82DC, mode=$00)
19 $B3CCE3 SetCCObjectAndJump(target=$B3CCEE)
20 $B3CCE6 SetCCObjectParam4(a=$0B, ptr=$F5CD, d=$CC)
21 $B3CCEB Jump(target=$B3CCE3)
22 $B3CCEE StartTextBox(text_id=$01C9, mode=$00)
23 $B3CCF2 Jump(target=$B3CCE3)
24 $B3CCF5 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3CD04)
25 $B3CCFD StartTextBox(text_id=$03BC, mode=$00)
26 $B3CD01 Jump(target=$B3CCE3)
27 $B3CD04 StartTextBox(text_id=$03BB, mode=$00)
28 $B3CD08 Jump(target=$B3CCE3)
29 $B3CD0B JumpIfFlagSet(mem=$7F1F6C, bit=$04, target=$B3CD71)
30 $B3CD12 JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B3CD4E)
31 $B3CD19 JumpIfFlagSet(mem=$7F1F66, bit=$04, target=$B3CD43)
32 $B3CD20 GetRNG(value=$02)
33 $B3CD22 JumpIfEqualsRNG(value=$00, target=$B3CD2D)
34 $B3CD26 JumpIfEqualsRNG(value=$01, target=$B3CD38)
35 $B3CD2A Jump(target=$B3CCE3)
36 $B3CD2D StartTextBox(text_id=$0069, mode=$00)
37 $B3CD31 SetCCObjectParam(param=$0285, value=$00)
38 $B3CD35 Jump(target=$B3CCE3)
39 $B3CD38 StartTextBox(text_id=$03DD, mode=$00)
40 $B3CD3C SetCCObjectParam(param=$0285, value=$00)
41 $B3CD40 Jump(target=$B3CCE3)
42 $B3CD43 StartTextBox(text_id=$03DE, mode=$00)
43 $B3CD47 SetCCObjectParam(param=$0285, value=$00)
44 $B3CD4B Jump(target=$B3CCE3)
45 $B3CD4E JumpIfEqualsByte(mem=$7F1F1B, value=$1E, target=$B3CD60)
46 $B3CD55 StartTextBox(text_id=$0069, mode=$00)
47 $B3CD59 SetCCObjectParam(param=$0285, value=$00)
48 $B3CD5D Jump(target=$B3CCE3)
49 $B3CD60 StartTextBox(text_id=$03F6, mode=$00)
50 $B3CD64 SetCCObjectParam(param=$0285, value=$00)
51 $B3CD68 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$05, e=$00)
52 $B3CD6E Jump(target=$B3CCE3)
53 $B3CD71 StartTextBox(text_id=$01FB, mode=$00)
54 $B3CD75 SetCCObjectParam(param=$0285, value=$00)
55 $B3CD79 Jump(target=$B3CCE3)
56 $B3CD7C SpawnOrMoveCCObject(x=$0060, y=$0170, visual=$8348, mode=$00)
57 $B3CD84 SetCCObjectParam4(a=$93, ptr=$8CCD, d=$CD)
58 $B3CD89 Jump(target=$B3CD84)
59 $B3CD8C StartTextBox(text_id=$03BC, mode=$00)
60 $B3CD90 Jump(target=$B3CD84)
61 $B3CD93 JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B3CDA1)
62 $B3CD9A StartTextBox(text_id=$0056, mode=$00)
63 $B3CD9E Jump(target=$B3CD84)
64 $B3CDA1 JumpIfEqualsByte(mem=$7F1F1B, value=$1E, target=$B3CDAF)
65 $B3CDA8 StartTextBox(text_id=$0056, mode=$00)
66 $B3CDAC Jump(target=$B3CD84)
67 $B3CDAF StartTextBox(text_id=$03FD, mode=$00)
68 $B3CDB3 Jump(target=$B3CD84)
69 $B3CDB6 JumpIfEqualsByte(mem=$7F1F19, value=$02, target=$B3CE2B)
70 $B3CDBD JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B3CE2B)
71 $B3CDC4 SpawnOrMoveCCObject(x=$00B4, y=$01A0, visual=$827C, mode=$01)
72 $B3CDCC SetCCObjectParam4(a=$F2, ptr=$D4CD, d=$CD)
73 $B3CDD1 Jump(target=$B3CDCC)
74 $B3CDD4 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3CDE7)
75 $B3CDDC StartTextBox(text_id=$0200, mode=$00)
76 $B3CDE0 SetCCObjectParam(param=$026B, value=$00)
77 $B3CDE4 Jump(target=$B3CDCC)
78 $B3CDE7 StartTextBox(text_id=$03B8, mode=$00)
79 $B3CDEB SetCCObjectParam(param=$026B, value=$00)
... truncated after 80 commands; use CSV/index for full count.
```

## Entry 01 -> `$B3D447`

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$67`
- Pointer duplicate count: `15`

```text
00 $B3D447 UnknownOpcode_$67()
```

## Entry 02 -> `$B3D447` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$67`
- Pointer duplicate count: `15`

```text
00 $B3D447 UnknownOpcode_$67()
```

## Entry 03 -> `$B3D447` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$67`
- Pointer duplicate count: `15`

```text
00 $B3D447 UnknownOpcode_$67()
```

## Entry 04 -> `$B3D447` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$67`
- Pointer duplicate count: `15`

```text
00 $B3D447 UnknownOpcode_$67()
```

## Entry 05 -> `$B3D447` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$67`
- Pointer duplicate count: `15`

```text
00 $B3D447 UnknownOpcode_$67()
```

## Entry 06 -> `$B3D447` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$67`
- Pointer duplicate count: `15`

```text
00 $B3D447 UnknownOpcode_$67()
```

## Entry 07 -> `$B3D447` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$67`
- Pointer duplicate count: `15`

```text
00 $B3D447 UnknownOpcode_$67()
```

## Entry 08 -> `$B3D447` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$67`
- Pointer duplicate count: `15`

```text
00 $B3D447 UnknownOpcode_$67()
```

## Entry 09 -> `$B3D447` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$67`
- Pointer duplicate count: `15`

```text
00 $B3D447 UnknownOpcode_$67()
```

## Entry 10 -> `$B3D447` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$67`
- Pointer duplicate count: `15`

```text
00 $B3D447 UnknownOpcode_$67()
```

## Entry 11 -> `$B3D447` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$67`
- Pointer duplicate count: `15`

```text
00 $B3D447 UnknownOpcode_$67()
```

## Entry 12 -> `$B3D447` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$67`
- Pointer duplicate count: `15`

```text
00 $B3D447 UnknownOpcode_$67()
```

## Entry 13 -> `$B3D447` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$67`
- Pointer duplicate count: `15`

```text
00 $B3D447 UnknownOpcode_$67()
```

## Entry 14 -> `$B3D447` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$67`
- Pointer duplicate count: `15`

```text
00 $B3D447 UnknownOpcode_$67()
```

## Entry 15 -> `$B3D447` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$67`
- Pointer duplicate count: `15`

```text
00 $B3D447 UnknownOpcode_$67()
```

