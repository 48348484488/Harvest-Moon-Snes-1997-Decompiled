# EventScriptGroup_43 symbolic export

- Group id: `$43`
- Group table address: `$B58000`
- Pointer entries: `16`
- Unique targets: `6`

This file is generated for decompilation handoff. It keeps dialog as text ids only.

## Entry 00 -> `$B58020`

- Commands decoded: `22`
- Stop reason: `unknown_opcode_$CD`
- Pointer duplicate count: `1`

```text
00 $B58020 JumpIfFlagSet(mem=$800196, bit=$01, target=$B58036)
01 $B58027 JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B58036)
02 $B5802E JumpIfBetweenByte(mem=$7F1F1C, low=$0B, high=$0E, target=$B584D4)
03 $B58036 JumpIfEqualsByte(mem=$7F1F1C, value=$12, target=$B5805A)
04 $B5803D JumpIfFlagSet(mem=$7F1F64, bit=$07, target=$B5804F)
05 $B58044 SpawnOrMoveCCObject(x=$0058, y=$0068, visual=$845C, mode=$00)
06 $B5804C Jump(target=$B58087)
07 $B5804F SpawnOrMoveCCObject(x=$0148, y=$0078, visual=$845C, mode=$00)
08 $B58057 Jump(target=$B58087)
09 $B5805A SetCCObjectParam8(a=$1F, b=$1F, c=$7F, d=$FE, e=$FF)
10 $B58060 JumpIfFlagSet(mem=$7F1F64, bit=$07, target=$B58077)
11 $B58067 SpawnOrMoveCCObject(x=$0029, y=$0053, visual=$8468, mode=$00)
12 $B5806F SetFlag(mem=$7F1F5E, bit=$0C)
13 $B58074 Jump(target=$B58096)
14 $B58077 SpawnOrMoveCCObject(x=$0119, y=$0063, visual=$8468, mode=$00)
15 $B5807F SetFlag(mem=$7F1F5E, bit=$0C)
16 $B58084 Jump(target=$B58096)
17 $B58087 JumpIfFlagSet(mem=$7F1F5E, bit=$0B, target=$B584A0)
18 $B5808E SetCCObjectParam4(a=$69, ptr=$9C81, d=$80)
19 $B58093 Jump(target=$B58087)
20 $B58096 SetCCObjectParam2D()
21 $B58097 UnknownOpcode_$CD()
```

## Entry 01 -> `$B584DA`

- Commands decoded: `22`
- Stop reason: `unknown_opcode_$83`
- Pointer duplicate count: `1`

```text
00 $B584DA JumpIfFlagSet(mem=$800196, bit=$01, target=$B584F0)
01 $B584E1 JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B584F0)
02 $B584E8 JumpIfBetweenByte(mem=$7F1F1C, low=$0B, high=$0E, target=$B5898A)
03 $B584F0 JumpIfEqualsByte(mem=$7F1F1C, value=$12, target=$B58514)
04 $B584F7 JumpIfFlagSet(mem=$7F1F64, bit=$07, target=$B58509)
05 $B584FE SpawnOrMoveCCObject(x=$0058, y=$0068, visual=$845C, mode=$00)
06 $B58506 Jump(target=$B58541)
07 $B58509 SpawnOrMoveCCObject(x=$0148, y=$0078, visual=$845C, mode=$00)
08 $B58511 Jump(target=$B58541)
09 $B58514 SetCCObjectParam8(a=$21, b=$1F, c=$7F, d=$FE, e=$FF)
10 $B5851A JumpIfFlagSet(mem=$7F1F64, bit=$07, target=$B58531)
11 $B58521 SpawnOrMoveCCObject(x=$0029, y=$0053, visual=$8468, mode=$00)
12 $B58529 SetFlag(mem=$7F1F5E, bit=$0C)
13 $B5852E Jump(target=$B58550)
14 $B58531 SpawnOrMoveCCObject(x=$0119, y=$0063, visual=$8468, mode=$00)
15 $B58539 SetFlag(mem=$7F1F5E, bit=$0C)
16 $B5853E Jump(target=$B58550)
17 $B58541 JumpIfFlagSet(mem=$7F1F5E, bit=$0B, target=$B58956)
18 $B58548 SetCCObjectParam4(a=$1C, ptr=$5686, d=$85)
19 $B5854D Jump(target=$B58541)
20 $B58550 SetCCObjectParam2D()
21 $B58551 UnknownOpcode_$83()
```

## Entry 02 -> `$B58990`

- Commands decoded: `26`
- Stop reason: `unknown_opcode_$68`
- Pointer duplicate count: `1`

```text
00 $B58990 JumpIfFlagSet(mem=$800196, bit=$01, target=$B589A6)
01 $B58997 JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B589A6)
02 $B5899E JumpIfBetweenByte(mem=$7F1F1C, low=$0B, high=$0E, target=$B58E48)
03 $B589A6 JumpIfEqualsByte(mem=$7F1F1C, value=$12, target=$B589CA)
04 $B589AD JumpIfFlagSet(mem=$7F1F64, bit=$07, target=$B589BF)
05 $B589B4 SpawnOrMoveCCObject(x=$0058, y=$0068, visual=$845C, mode=$00)
06 $B589BC Jump(target=$B589F7)
07 $B589BF SpawnOrMoveCCObject(x=$0148, y=$0078, visual=$845C, mode=$00)
08 $B589C7 Jump(target=$B589F7)
09 $B589CA SetCCObjectParam8(a=$23, b=$1F, c=$7F, d=$FE, e=$FF)
10 $B589D0 JumpIfFlagSet(mem=$7F1F64, bit=$07, target=$B589E7)
11 $B589D7 SpawnOrMoveCCObject(x=$0029, y=$0053, visual=$8468, mode=$00)
12 $B589DF SetFlag(mem=$7F1F5E, bit=$0C)
13 $B589E4 Jump(target=$B58A06)
14 $B589E7 SpawnOrMoveCCObject(x=$0119, y=$0063, visual=$8468, mode=$00)
15 $B589EF SetFlag(mem=$7F1F5E, bit=$0C)
16 $B589F4 Jump(target=$B58A06)
17 $B589F7 JumpIfFlagSet(mem=$7F1F5E, bit=$0B, target=$B58E14)
18 $B589FE SetCCObjectParam4(a=$D2, ptr=$0C8A, d=$8A)
19 $B58A03 Jump(target=$B589F7)
20 $B58A06 SetCCObjectParam2D()
21 $B58A07 SetCCObjectParam8(a=$8E, b=$12, c=$06, d=$8A, e=$16)
22 $B58A0D SetCCObjectParam2(value=$8009)
23 $B58A10 EnableTimeFlow()
24 $B58A11 NoOp()
25 $B58A12 UnknownOpcode_$68()
```

## Entry 03 -> `$B58E4E`

- Commands decoded: `81`
- Stop reason: `unknown_opcode_$55`
- Pointer duplicate count: `1`

```text
00 $B58E4E JumpIfFlagSet(mem=$800196, bit=$01, target=$B58E64)
01 $B58E55 JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B58E64)
02 $B58E5C JumpIfBetweenByte(mem=$7F1F1C, low=$0B, high=$0E, target=$B5930D)
03 $B58E64 JumpIfEqualsByte(mem=$7F1F1C, value=$12, target=$B58E88)
04 $B58E6B JumpIfFlagSet(mem=$7F1F64, bit=$07, target=$B58E7D)
05 $B58E72 SpawnOrMoveCCObject(x=$0058, y=$0068, visual=$845C, mode=$00)
06 $B58E7A Jump(target=$B58EB5)
07 $B58E7D SpawnOrMoveCCObject(x=$0148, y=$0078, visual=$845C, mode=$00)
08 $B58E85 Jump(target=$B58EB5)
09 $B58E88 SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$FE, e=$FF)
10 $B58E8E JumpIfFlagSet(mem=$7F1F64, bit=$07, target=$B58EA5)
11 $B58E95 SpawnOrMoveCCObject(x=$0029, y=$0053, visual=$8468, mode=$00)
12 $B58E9D SetFlag(mem=$7F1F5E, bit=$0C)
13 $B58EA2 Jump(target=$B58EC4)
14 $B58EA5 SpawnOrMoveCCObject(x=$0119, y=$0063, visual=$8468, mode=$00)
15 $B58EAD SetFlag(mem=$7F1F5E, bit=$0C)
16 $B58EB2 Jump(target=$B58EC4)
17 $B58EB5 JumpIfFlagSet(mem=$7F1F5E, bit=$0B, target=$B592D9)
18 $B58EBC SetCCObjectParam4(a=$9F, ptr=$CA8F, d=$8E)
19 $B58EC1 Jump(target=$B58EB5)
20 $B58EC4 SetCCObjectParam2D()
21 $B58EC5 SetTransitionDestination(index=$93)
22 $B58EC7 Jump(target=$B58EC4)
23 $B58ECA JumpIfEqualsByte(mem=$80091E, value=$02, target=$B58F0D)
24 $B58ED1 JumpIfBetweenByte(mem=$80091E, low=$01, high=$07, target=$B58F1A)
25 $B58ED9 JumpIfEqualsByte(mem=$80091E, value=$19, target=$B58F2E)
26 $B58EE0 JumpIfEqualsByte(mem=$80091E, value=$49, target=$B58F2E)
27 $B58EE7 JumpIfEqualsByte(mem=$80091E, value=$06, target=$B58F5C)
28 $B58EEE JumpIfBetweenByte(mem=$80091E, low=$10, high=$13, target=$B58F1A)
29 $B58EF6 JumpIfBetweenByte(mem=$80091E, low=$14, high=$17, target=$B58F42)
30 $B58EFE JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B58F4F)
31 $B58F06 StartTextBox(text_id=$0200, mode=$00)
32 $B58F0A Jump(target=$B58EB5)
33 $B58F0D StartTextBox(text_id=$01D9, mode=$00)
34 $B58F11 SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$F8, e=$FF)
35 $B58F17 Jump(target=$B58EB5)
36 $B58F1A JumpIfFlagSet(mem=$7F1F6C, bit=$07, target=$B58F78)
37 $B58F21 StartTextBox(text_id=$03B2, mode=$00)
38 $B58F25 SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$06, e=$00)
39 $B58F2B Jump(target=$B58EB5)
40 $B58F2E JumpIfFlagSet(mem=$7F1F6C, bit=$07, target=$B58F78)
41 $B58F35 StartTextBox(text_id=$0212, mode=$00)
42 $B58F39 SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$06, e=$00)
43 $B58F3F Jump(target=$B58EB5)
44 $B58F42 StartTextBox(text_id=$03B3, mode=$00)
45 $B58F46 SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$04, e=$00)
46 $B58F4C Jump(target=$B58EB5)
47 $B58F4F StartTextBox(text_id=$03BA, mode=$00)
48 $B58F53 SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$FC, e=$FF)
49 $B58F59 Jump(target=$B58EB5)
50 $B58F5C JumpIfFlagSet(mem=$7F1F6C, bit=$07, target=$B58F78)
51 $B58F63 JumpIfFlagSet(mem=$7F1F6C, bit=$08, target=$B58F85)
52 $B58F6A JumpIfFlagSet(mem=$7F1F6C, bit=$09, target=$B58F92)
53 $B58F71 StartTextBox(text_id=$0212, mode=$00)
54 $B58F75 Jump(target=$B58EB5)
55 $B58F78 StartTextBox(text_id=$01BD, mode=$00)
56 $B58F7C SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$1E, e=$00)
57 $B58F82 Jump(target=$B58EB5)
58 $B58F85 StartTextBox(text_id=$041D, mode=$00)
59 $B58F89 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$1E, e=$00)
60 $B58F8F Jump(target=$B58EB5)
61 $B58F92 StartTextBox(text_id=$041E, mode=$00)
62 $B58F96 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$1E, e=$00)
63 $B58F9C Jump(target=$B58EB5)
64 $B58F9F JumpIfBetweenByte(mem=$7F1F1C, low=$0F, high=$12, target=$B5929F)
65 $B58FA7 JumpIfEqualsValue(mem=$7F1F3B, value=$0001, target=$B590CB)
66 $B58FAF JumpIfFlagSet(mem=$7F1F64, bit=$04, target=$B590D2)
67 $B58FB6 JumpIfEqualsByte(mem=$80098C, value=$03, target=$B590D9)
68 $B58FBD JumpIfFlagSet(mem=$800196, bit=$04, target=$B590E0)
69 $B58FC4 JumpIfFlagSet(mem=$7F1F64, bit=$05, target=$B590D2)
70 $B58FCB JumpIfEqualsValue(mem=$7F1F37, value=$0001, target=$B590F5)
71 $B58FD3 JumpIfEqualsValue(mem=$7F1F39, value=$0001, target=$B590F5)
72 $B58FDB JumpIfBetweenValue(mem=$7F1F37, low=$0002, high=$0013, target=$B590FC)
73 $B58FE5 JumpIfBetweenValue(mem=$7F1F39, low=$0002, high=$0013, target=$B590FC)
74 $B58FEF JumpIfBetweenValue(mem=$7F1F37, low=$0014, high=$0027, target=$B59110)
75 $B58FF9 JumpIfBetweenValue(mem=$7F1F39, low=$0014, high=$0027, target=$B59110)
76 $B59003 JumpIfBetweenValue(mem=$7F1F37, low=$0028, high=$003B, target=$B59124)
77 $B5900D JumpIfBetweenValue(mem=$7F1F39, low=$0028, high=$003B, target=$B59124)
78 $B59017 JumpIfEqualsValue(mem=$7F1F37, value=$005A, target=$B59138)
79 $B5901F JumpIfEqualsValue(mem=$7F1F39, value=$005A, target=$B59138)
... truncated after 80 commands; use CSV/index for full count.
```

## Entry 04 -> `$B59313`

- Commands decoded: `22`
- Stop reason: `unknown_opcode_$C4`
- Pointer duplicate count: `1`

```text
00 $B59313 JumpIfFlagSet(mem=$800196, bit=$01, target=$B59329)
01 $B5931A JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B59329)
02 $B59321 JumpIfBetweenByte(mem=$7F1F1C, low=$0B, high=$0E, target=$B597CB)
03 $B59329 JumpIfEqualsByte(mem=$7F1F1C, value=$12, target=$B5934D)
04 $B59330 JumpIfFlagSet(mem=$7F1F64, bit=$07, target=$B59342)
05 $B59337 SpawnOrMoveCCObject(x=$0058, y=$0068, visual=$845C, mode=$00)
06 $B5933F Jump(target=$B5937A)
07 $B59342 SpawnOrMoveCCObject(x=$0148, y=$0078, visual=$845C, mode=$00)
08 $B5934A Jump(target=$B5937A)
09 $B5934D SetCCObjectParam8(a=$27, b=$1F, c=$7F, d=$FE, e=$FF)
10 $B59353 JumpIfFlagSet(mem=$7F1F64, bit=$07, target=$B5936A)
11 $B5935A SpawnOrMoveCCObject(x=$0029, y=$0053, visual=$8468, mode=$00)
12 $B59362 SetFlag(mem=$7F1F5E, bit=$0C)
13 $B59367 Jump(target=$B59389)
14 $B5936A SpawnOrMoveCCObject(x=$0119, y=$0063, visual=$8468, mode=$00)
15 $B59372 SetFlag(mem=$7F1F5E, bit=$0C)
16 $B59377 Jump(target=$B59389)
17 $B5937A JumpIfFlagSet(mem=$7F1F5E, bit=$0B, target=$B59797)
18 $B59381 SetCCObjectParam4(a=$5C, ptr=$8F94, d=$93)
19 $B59386 Jump(target=$B5937A)
20 $B59389 SetCCObjectParam2D()
21 $B5938A UnknownOpcode_$C4()
```

## Entry 05 -> `$B597D1`

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$F1`
- Pointer duplicate count: `11`

```text
00 $B597D1 UnknownOpcode_$F1()
```

## Entry 06 -> `$B597D1` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$F1`
- Pointer duplicate count: `11`

```text
00 $B597D1 UnknownOpcode_$F1()
```

## Entry 07 -> `$B597D1` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$F1`
- Pointer duplicate count: `11`

```text
00 $B597D1 UnknownOpcode_$F1()
```

## Entry 08 -> `$B597D1` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$F1`
- Pointer duplicate count: `11`

```text
00 $B597D1 UnknownOpcode_$F1()
```

## Entry 09 -> `$B597D1` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$F1`
- Pointer duplicate count: `11`

```text
00 $B597D1 UnknownOpcode_$F1()
```

## Entry 10 -> `$B597D1` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$F1`
- Pointer duplicate count: `11`

```text
00 $B597D1 UnknownOpcode_$F1()
```

## Entry 11 -> `$B597D1` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$F1`
- Pointer duplicate count: `11`

```text
00 $B597D1 UnknownOpcode_$F1()
```

## Entry 12 -> `$B597D1` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$F1`
- Pointer duplicate count: `11`

```text
00 $B597D1 UnknownOpcode_$F1()
```

## Entry 13 -> `$B597D1` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$F1`
- Pointer duplicate count: `11`

```text
00 $B597D1 UnknownOpcode_$F1()
```

## Entry 14 -> `$B597D1` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$F1`
- Pointer duplicate count: `11`

```text
00 $B597D1 UnknownOpcode_$F1()
```

## Entry 15 -> `$B597D1` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$F1`
- Pointer duplicate count: `11`

```text
00 $B597D1 UnknownOpcode_$F1()
```

