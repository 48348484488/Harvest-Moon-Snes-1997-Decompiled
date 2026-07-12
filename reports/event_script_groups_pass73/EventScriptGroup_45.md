# EventScriptGroup_45 symbolic export

- Group id: `$45`
- Group table address: `$B5A1E5`
- Pointer entries: `16`
- Unique targets: `7`

This file is generated for decompilation handoff. It keeps dialog as text ids only.

## Entry 00 -> `$B5A205`

- Commands decoded: `52`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B5A205 JumpIfFlagSet(mem=$800196, bit=$01, target=$B5A21B)
01 $B5A20C JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B5A21B)
02 $B5A213 JumpIfBetweenByte(mem=$7F1F1C, low=$0B, high=$0E, target=$B5A406)
03 $B5A21B JumpIfBetweenValue(mem=$7F1F37, low=$0000, high=$0059, target=$B5A2F1)
04 $B5A225 JumpIfBetweenByte(mem=$7F1F1C, low=$0F, high=$12, target=$B5A2B4)
05 $B5A22D JumpIfBetweenValue(mem=$7F1F37, low=$0078, high=$03E7, target=$B5A2BF)
06 $B5A237 SpawnOrMoveCCObject(x=$0158, y=$0098, visual=$84A4, mode=$00)
07 $B5A23F SetCCObjectBoxOrAnim(a=$1010, b=$A401, c=$84, d=$04)
08 $B5A246 SetCCObjectParam4(a=$99, ptr=$54A2, d=$A2)
09 $B5A24B Jump(target=$B5A246)
10 $B5A24E WaitOrSetCCCounter(value=$0001)
11 $B5A251 Jump(target=$B5A24E)
12 $B5A254 JumpIfEqualsByte(mem=$80091E, value=$06, target=$B5A26A)
13 $B5A25B JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B5A292)
14 $B5A263 StartTextBox(text_id=$01C2, mode=$00)
15 $B5A267 Jump(target=$B5A246)
16 $B5A26A JumpIfFlagSet(mem=$7F1F6C, bit=$08, target=$B5A278)
17 $B5A271 StartTextBox(text_id=$01C2, mode=$00)
18 $B5A275 Jump(target=$B5A246)
19 $B5A278 StartTextBox(text_id=$041D, mode=$00)
20 $B5A27C SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$0A, e=$00)
21 $B5A282 Jump(target=$B5A246)
22 $B5A285 StartTextBox(text_id=$041E, mode=$00)
23 $B5A289 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$0A, e=$00)
24 $B5A28F Jump(target=$B5A246)
25 $B5A292 StartTextBox(text_id=$01D9, mode=$00)
26 $B5A296 Jump(target=$B5A246)
27 $B5A299 GetRNG(value=$02)
28 $B5A29B JumpIfEqualsRNG(value=$00, target=$B5A2A6)
29 $B5A29F JumpIfEqualsRNG(value=$01, target=$B5A2AD)
30 $B5A2A3 Jump(target=$B5A246)
31 $B5A2A6 StartTextBox(text_id=$01C0, mode=$00)
32 $B5A2AA Jump(target=$B5A246)
33 $B5A2AD StartTextBox(text_id=$01C2, mode=$00)
34 $B5A2B1 Jump(target=$B5A246)
35 $B5A2B4 SpawnOrMoveCCObject(x=$0178, y=$0058, visual=$8648, mode=$00)
36 $B5A2BC Jump(target=$B5A24E)
37 $B5A2BF SpawnOrMoveCCObject(x=$0158, y=$0098, visual=$84BC, mode=$00)
38 $B5A2C7 SetCCObjectBoxOrAnim(a=$1010, b=$BC01, c=$84, d=$04)
39 $B5A2CE SetCCObjectParam4(a=$D6, ptr=$54A2, d=$A2)
40 $B5A2D3 Jump(target=$B5A2CE)
41 $B5A2D6 GetRNG(value=$02)
42 $B5A2D8 JumpIfEqualsRNG(value=$00, target=$B5A2E3)
43 $B5A2DC JumpIfEqualsRNG(value=$01, target=$B5A2EA)
44 $B5A2E0 Jump(target=$B5A2CE)
45 $B5A2E3 StartTextBox(text_id=$01C1, mode=$00)
46 $B5A2E7 Jump(target=$B5A2CE)
47 $B5A2EA StartTextBox(text_id=$01C2, mode=$00)
48 $B5A2EE Jump(target=$B5A2CE)
49 $B5A2F1 SpawnOrMoveCCObject(x=$0186, y=$0098, visual=$8654, mode=$00)
50 $B5A2F9 WaitForAButtonSetInteractionFlag02()
51 $B5A2FA Jump(target=$B5A2F9)
```

## Entry 01 -> `$B5A2FD`

- Commands decoded: `13`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B5A2FD JumpIfBetweenValue(mem=$7F1F37, low=$0000, high=$0059, target=$B5A406)
01 $B5A307 JumpIfFlagSet(mem=$7F1F66, bit=$00, target=$B5A32D)
02 $B5A30E JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B5A330)
03 $B5A315 JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B5A333)
04 $B5A31C JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B5A336)
05 $B5A323 JumpIfFlagSet(mem=$7F1F66, bit=$04, target=$B5A339)
06 $B5A32A Jump(target=$B5A33C)
07 $B5A32D Jump(target=$B5A33D)
08 $B5A330 Jump(target=$B5A33C)
09 $B5A333 Jump(target=$B5A380)
10 $B5A336 Jump(target=$B5A3C3)
11 $B5A339 Jump(target=$B5A33C)
12 $B5A33C StopOrDisableCCSlot()
```

## Entry 02 -> `$B5A407`

- Commands decoded: `8`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B5A407 JumpIfBetweenValue(mem=$7F1F37, low=$0000, high=$0059, target=$B5A440)
01 $B5A411 JumpIfFlagSet(mem=$7F1F66, bit=$00, target=$B5A437)
02 $B5A418 JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B5A438)
03 $B5A41F JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B5A43B)
04 $B5A426 JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B5A43C)
05 $B5A42D JumpIfFlagSet(mem=$7F1F66, bit=$04, target=$B5A43D)
06 $B5A434 Jump(target=$B5A440)
07 $B5A437 StopOrDisableCCSlot()
```

## Entry 03 -> `$B5A484`

- Commands decoded: `52`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B5A484 JumpIfFlagSet(mem=$800196, bit=$01, target=$B5A49A)
01 $B5A48B JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B5A49A)
02 $B5A492 JumpIfBetweenByte(mem=$7F1F1C, low=$0B, high=$0E, target=$B5A685)
03 $B5A49A JumpIfBetweenValue(mem=$7F1F39, low=$0000, high=$0059, target=$B5A570)
04 $B5A4A4 JumpIfBetweenByte(mem=$7F1F1C, low=$0F, high=$12, target=$B5A533)
05 $B5A4AC JumpIfBetweenValue(mem=$7F1F39, low=$0078, high=$03E7, target=$B5A53E)
06 $B5A4B6 SpawnOrMoveCCObject(x=$0168, y=$0088, visual=$8498, mode=$02)
07 $B5A4BE SetCCObjectBoxOrAnim(a=$1010, b=$A401, c=$84, d=$04)
08 $B5A4C5 SetCCObjectParam4(a=$18, ptr=$D3A5, d=$A4)
09 $B5A4CA Jump(target=$B5A4C5)
10 $B5A4CD WaitOrSetCCCounter(value=$0001)
11 $B5A4D0 Jump(target=$B5A4CD)
12 $B5A4D3 JumpIfEqualsByte(mem=$80091E, value=$06, target=$B5A4E9)
13 $B5A4DA JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B5A511)
14 $B5A4E2 StartTextBox(text_id=$01C2, mode=$00)
15 $B5A4E6 Jump(target=$B5A4C5)
16 $B5A4E9 JumpIfFlagSet(mem=$7F1F6C, bit=$08, target=$B5A4F7)
17 $B5A4F0 StartTextBox(text_id=$01C2, mode=$00)
18 $B5A4F4 Jump(target=$B5A4C5)
19 $B5A4F7 StartTextBox(text_id=$041D, mode=$00)
20 $B5A4FB SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$0A, e=$00)
21 $B5A501 Jump(target=$B5A4C5)
22 $B5A504 StartTextBox(text_id=$041E, mode=$00)
23 $B5A508 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$0A, e=$00)
24 $B5A50E Jump(target=$B5A4C5)
25 $B5A511 StartTextBox(text_id=$01D9, mode=$00)
26 $B5A515 Jump(target=$B5A4C5)
27 $B5A518 GetRNG(value=$02)
28 $B5A51A JumpIfEqualsRNG(value=$00, target=$B5A525)
29 $B5A51E JumpIfEqualsRNG(value=$01, target=$B5A52C)
30 $B5A522 Jump(target=$B5A4C5)
31 $B5A525 StartTextBox(text_id=$01C0, mode=$00)
32 $B5A529 Jump(target=$B5A4C5)
33 $B5A52C StartTextBox(text_id=$01C2, mode=$00)
34 $B5A530 Jump(target=$B5A4C5)
35 $B5A533 SpawnOrMoveCCObject(x=$0188, y=$0058, visual=$8648, mode=$00)
36 $B5A53B Jump(target=$B5A4CD)
37 $B5A53E SpawnOrMoveCCObject(x=$0168, y=$0088, visual=$84B0, mode=$00)
38 $B5A546 SetCCObjectBoxOrAnim(a=$0C10, b=$BC01, c=$84, d=$04)
39 $B5A54D SetCCObjectParam4(a=$55, ptr=$D3A5, d=$A4)
40 $B5A552 Jump(target=$B5A54D)
41 $B5A555 GetRNG(value=$02)
42 $B5A557 JumpIfEqualsRNG(value=$00, target=$B5A562)
43 $B5A55B JumpIfEqualsRNG(value=$01, target=$B5A569)
44 $B5A55F Jump(target=$B5A54D)
45 $B5A562 StartTextBox(text_id=$01C1, mode=$00)
46 $B5A566 Jump(target=$B5A54D)
47 $B5A569 StartTextBox(text_id=$01C2, mode=$00)
48 $B5A56D Jump(target=$B5A54D)
49 $B5A570 SpawnOrMoveCCObject(x=$0186, y=$0098, visual=$8654, mode=$00)
50 $B5A578 WaitForAButtonSetInteractionFlag04()
51 $B5A579 Jump(target=$B5A578)
```

## Entry 04 -> `$B5A57C`

- Commands decoded: `13`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B5A57C JumpIfBetweenValue(mem=$7F1F39, low=$0000, high=$0059, target=$B5A685)
01 $B5A586 JumpIfFlagSet(mem=$7F1F66, bit=$00, target=$B5A5AC)
02 $B5A58D JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B5A5AF)
03 $B5A594 JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B5A5B2)
04 $B5A59B JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B5A5B5)
05 $B5A5A2 JumpIfFlagSet(mem=$7F1F66, bit=$04, target=$B5A5B8)
06 $B5A5A9 Jump(target=$B5A5BB)
07 $B5A5AC Jump(target=$B5A5BC)
08 $B5A5AF Jump(target=$B5A5BB)
09 $B5A5B2 Jump(target=$B5A5FF)
10 $B5A5B5 Jump(target=$B5A642)
11 $B5A5B8 Jump(target=$B5A5BB)
12 $B5A5BB StopOrDisableCCSlot()
```

## Entry 05 -> `$B5A686`

- Commands decoded: `8`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B5A686 JumpIfBetweenValue(mem=$7F1F39, low=$0000, high=$0059, target=$B5A6BF)
01 $B5A690 JumpIfFlagSet(mem=$7F1F66, bit=$00, target=$B5A6B6)
02 $B5A697 JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B5A6B7)
03 $B5A69E JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B5A6BA)
04 $B5A6A5 JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B5A6BB)
05 $B5A6AC JumpIfFlagSet(mem=$7F1F66, bit=$04, target=$B5A6BC)
06 $B5A6B3 Jump(target=$B5A6BF)
07 $B5A6B6 StopOrDisableCCSlot()
```

## Entry 06 -> `$B5A703`

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$A7`
- Pointer duplicate count: `10`

```text
00 $B5A703 SetFlag(mem=$A73DA7, bit=$57)
01 $B5A708 UnknownOpcode_$A7()
```

## Entry 07 -> `$B5A703` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$A7`
- Pointer duplicate count: `10`

```text
00 $B5A703 SetFlag(mem=$A73DA7, bit=$57)
01 $B5A708 UnknownOpcode_$A7()
```

## Entry 08 -> `$B5A703` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$A7`
- Pointer duplicate count: `10`

```text
00 $B5A703 SetFlag(mem=$A73DA7, bit=$57)
01 $B5A708 UnknownOpcode_$A7()
```

## Entry 09 -> `$B5A703` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$A7`
- Pointer duplicate count: `10`

```text
00 $B5A703 SetFlag(mem=$A73DA7, bit=$57)
01 $B5A708 UnknownOpcode_$A7()
```

## Entry 10 -> `$B5A703` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$A7`
- Pointer duplicate count: `10`

```text
00 $B5A703 SetFlag(mem=$A73DA7, bit=$57)
01 $B5A708 UnknownOpcode_$A7()
```

## Entry 11 -> `$B5A703` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$A7`
- Pointer duplicate count: `10`

```text
00 $B5A703 SetFlag(mem=$A73DA7, bit=$57)
01 $B5A708 UnknownOpcode_$A7()
```

## Entry 12 -> `$B5A703` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$A7`
- Pointer duplicate count: `10`

```text
00 $B5A703 SetFlag(mem=$A73DA7, bit=$57)
01 $B5A708 UnknownOpcode_$A7()
```

## Entry 13 -> `$B5A703` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$A7`
- Pointer duplicate count: `10`

```text
00 $B5A703 SetFlag(mem=$A73DA7, bit=$57)
01 $B5A708 UnknownOpcode_$A7()
```

## Entry 14 -> `$B5A703` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$A7`
- Pointer duplicate count: `10`

```text
00 $B5A703 SetFlag(mem=$A73DA7, bit=$57)
01 $B5A708 UnknownOpcode_$A7()
```

## Entry 15 -> `$B5A703` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$A7`
- Pointer duplicate count: `10`

```text
00 $B5A703 SetFlag(mem=$A73DA7, bit=$57)
01 $B5A708 UnknownOpcode_$A7()
```

