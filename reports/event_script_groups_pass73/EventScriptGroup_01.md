# EventScriptGroup_01 symbolic export

- Group id: `$01`
- Group table address: `$B39359`
- Pointer entries: `16`
- Unique targets: `12`

This file is generated for decompilation handoff. It keeps dialog as text ids only.

## Entry 00 -> `$B39379`

- Commands decoded: `6`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B39379 ChangeGameState2()
01 $B3937A StartNestedScriptSlot(slot=$01, target=$B393CE)
02 $B3937E StartNestedScriptSlot(slot=$02, target=$B39498)
03 $B39382 StartNestedScriptSlot(slot=$07, target=$B39CE8)
04 $B39386 Jump(target=$B3938A)
05 $B39389 StopOrDisableCCSlot()
```

## Entry 01 -> `$B39D05`

- Commands decoded: `73`
- Stop reason: `unknown_opcode_$CB`
- Pointer duplicate count: `1`

```text
00 $B39D05 ChangeGameState2()
01 $B39D06 StartNestedScriptSlot(slot=$01, target=$B39D14)
02 $B39D0A StartNestedScriptSlot(slot=$02, target=$B39E2A)
03 $B39D0E WaitOrSetCCCounter(value=$0001)
04 $B39D11 Jump(target=$B39D0E)
05 $B39D14 SpawnOrMoveCCObject(x=$00A8, y=$0078, visual=$8300, mode=$00)
06 $B39D1C SetCCObjectBoxOrAnim(a=$1020, b=$0C01, c=$83, d=$14)
07 $B39D23 SetCCObjectAndJump(target=$B39D41)
08 $B39D26 SetCCObjectParam4(a=$5E, ptr=$489D, d=$9D)
09 $B39D2B Jump(target=$B39D23)
10 $B39D2E SetCCObjectAndJump(target=$B39D41)
11 $B39D31 SetCCObjectParam4(a=$BB, ptr=$489D, d=$9D)
12 $B39D36 Jump(target=$B39D2E)
13 $B39D39 SetCCObjectParam4(a=$09, ptr=$489E, d=$9D)
14 $B39D3E Jump(target=$B39D39)
15 $B39D41 StartTextBox(text_id=$01C9, mode=$00)
16 $B39D45 Jump(target=$B39D23)
17 $B39D48 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B39D57)
18 $B39D50 StartTextBox(text_id=$0200, mode=$00)
19 $B39D54 Jump(target=$B39D23)
20 $B39D57 StartTextBox(text_id=$03B8, mode=$00)
21 $B39D5B Jump(target=$B39D23)
22 $B39D5E JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B39E09)
23 $B39D65 JumpIfFlagSet(mem=$7F1F66, bit=$00, target=$B39E10)
24 $B39D6C JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B39D92)
25 $B39D73 JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B39D92)
26 $B39D7A JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B39D92)
27 $B39D81 JumpIfFlagSet(mem=$7F1F66, bit=$04, target=$B39D92)
28 $B39D88 JumpIfBetweenValue(mem=$7F1F1F, low=$00C8, high=$012C, target=$B39E1D)
29 $B39D92 JumpIfEqualsByte(mem=$7F1F19, value=$00, target=$B39DC2)
30 $B39D99 JumpIfEqualsByte(mem=$7F1F19, value=$02, target=$B39DCC)
31 $B39DA0 JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B39DD6)
32 $B39DA7 GetRNG(value=$02)
33 $B39DA9 JumpIfEqualsRNG(value=$00, target=$B39DB4)
34 $B39DAD JumpIfEqualsRNG(value=$01, target=$B39DBB)
35 $B39DB1 Jump(target=$B39D23)
36 $B39DB4 StartTextBox(text_id=$0035, mode=$00)
37 $B39DB8 Jump(target=$B39D23)
38 $B39DBB StartTextBox(text_id=$0036, mode=$00)
39 $B39DBF Jump(target=$B39D2E)
40 $B39DC2 JumpIfEqualsByte(mem=$7F1F1B, value=$16, target=$B39DE7)
41 $B39DC9 Jump(target=$B39DA7)
42 $B39DCC JumpIfEqualsByte(mem=$7F1F1B, value=$0B, target=$B39DEE)
43 $B39DD3 Jump(target=$B39DA7)
44 $B39DD6 JumpIfEqualsByte(mem=$7F1F1B, value=$17, target=$B39DF5)
45 $B39DDD JumpIfEqualsByte(mem=$7F1F1B, value=$1E, target=$B39DFC)
46 $B39DE4 Jump(target=$B39DA7)
47 $B39DE7 StartTextBox(text_id=$020B, mode=$00)
48 $B39DEB Jump(target=$B39D23)
49 $B39DEE StartTextBox(text_id=$023D, mode=$00)
50 $B39DF2 Jump(target=$B39D23)
51 $B39DF5 StartTextBox(text_id=$02AD, mode=$00)
52 $B39DF9 Jump(target=$B39D23)
53 $B39DFC StartTextBox(text_id=$03EC, mode=$00)
54 $B39E00 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$05, e=$00)
55 $B39E06 Jump(target=$B39D23)
56 $B39E09 StartTextBox(text_id=$01CD, mode=$00)
57 $B39E0D Jump(target=$B39D23)
58 $B39E10 GetRNG(value=$02)
59 $B39E12 JumpIfEqualsRNG(value=$00, target=$B39D92)
60 $B39E16 StartTextBox(text_id=$03C0, mode=$00)
61 $B39E1A Jump(target=$B39D23)
62 $B39E1D GetRNG(value=$02)
63 $B39E1F JumpIfEqualsRNG(value=$00, target=$B39D92)
64 $B39E23 StartTextBox(text_id=$03BF, mode=$00)
65 $B39E27 Jump(target=$B39D23)
66 $B39E2A SpawnOrMoveCCObject(x=$0188, y=$00A0, visual=$83D8, mode=$00)
67 $B39E32 SetCCObjectAndJump(target=$B39E51)
68 $B39E35 SetCCObjectParam4(a=$6E, ptr=$589E, d=$9E)
69 $B39E3A Jump(target=$B39E32)
70 $B39E3D SetCCObjectAndJump(target=$B39E51)
71 $B39E40 SetCCObjectParam2D()
72 $B39E41 UnknownOpcode_$CB()
```

## Entry 02 -> `$B39F3E`

- Commands decoded: `79`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B39F3E ChangeGameState2()
01 $B39F3F StartNestedScriptSlot(slot=$01, target=$B39F49)
02 $B39F43 WaitOrSetCCCounter(value=$0001)
03 $B39F46 Jump(target=$B39F43)
04 $B39F49 SpawnOrMoveCCObject(x=$0068, y=$00E8, visual=$8354, mode=$00)
05 $B39F51 SetCCObjectAndJump(target=$B39F7D)
06 $B39F54 SetCCObjectParam4(a=$9A, ptr=$849F, d=$9F)
07 $B39F59 Jump(target=$B39F51)
08 $B39F5C SetCCObjectAndJump(target=$B39F7D)
09 $B39F5F SetCCObjectParam4(a=$9A, ptr=$849F, d=$9F)
10 $B39F64 Jump(target=$B39F5C)
11 $B39F67 SetCCObjectAndJump(target=$B39F7D)
12 $B39F6A SetCCObjectParam4(a=$9A, ptr=$849F, d=$9F)
13 $B39F6F Jump(target=$B39F67)
14 $B39F72 SetCCObjectAndJump(target=$B39F7D)
15 $B39F75 SetCCObjectParam4(a=$74, ptr=$84A0, d=$9F)
16 $B39F7A Jump(target=$B39F72)
17 $B39F7D StartTextBox(text_id=$01E0, mode=$00)
18 $B39F81 Jump(target=$B39F51)
19 $B39F84 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B39F93)
20 $B39F8C StartTextBox(text_id=$0200, mode=$00)
21 $B39F90 Jump(target=$B39F51)
22 $B39F93 StartTextBox(text_id=$03B0, mode=$00)
23 $B39F97 Jump(target=$B39F51)
24 $B39F9A JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3A074)
25 $B39FA1 JumpIfEqualsByte(mem=$7F1F19, value=$00, target=$B3A001)
26 $B39FA8 JumpIfEqualsByte(mem=$7F1F19, value=$02, target=$B3A015)
27 $B39FAF JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B3A045)
28 $B39FB6 JumpIfFlagSet(mem=$7F1F66, bit=$00, target=$B3A07B)
29 $B39FBD JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B3A07B)
30 $B39FC4 JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B3A07B)
31 $B39FCB JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B3A07B)
32 $B39FD2 JumpIfFlagSet(mem=$7F1F66, bit=$04, target=$B3A07B)
33 $B39FD9 GetRNG(value=$04)
34 $B39FDB JumpIfEqualsRNG(value=$00, target=$B39FFA)
35 $B39FDF GetRNG(value=$02)
36 $B39FE1 JumpIfEqualsRNG(value=$00, target=$B39FEC)
37 $B39FE5 JumpIfEqualsRNG(value=$01, target=$B39FF3)
38 $B39FE9 Jump(target=$B39F51)
39 $B39FEC StartTextBox(text_id=$0057, mode=$00)
40 $B39FF0 Jump(target=$B39F51)
41 $B39FF3 StartTextBox(text_id=$0058, mode=$00)
42 $B39FF7 Jump(target=$B39F5C)
43 $B39FFA StartTextBox(text_id=$03CB, mode=$00)
44 $B39FFE Jump(target=$B39F67)
45 $B3A001 JumpIfEqualsByte(mem=$7F1F1B, value=$16, target=$B3A030)
46 $B3A008 GetRNG(value=$02)
47 $B3A00A JumpIfEqualsRNG(value=$00, target=$B39FB6)
48 $B3A00E JumpIfEqualsRNG(value=$01, target=$B39FD9)
49 $B3A012 Jump(target=$B39FD9)
50 $B3A015 JumpIfEqualsByte(mem=$7F1F1B, value=$0B, target=$B3A037)
51 $B3A01C JumpIfEqualsByte(mem=$7F1F1B, value=$13, target=$B3A03E)
52 $B3A023 GetRNG(value=$02)
53 $B3A025 JumpIfEqualsRNG(value=$00, target=$B39FB6)
54 $B3A029 JumpIfEqualsRNG(value=$01, target=$B39FD9)
55 $B3A02D Jump(target=$B39FD9)
56 $B3A030 StartTextBox(text_id=$0205, mode=$00)
57 $B3A034 Jump(target=$B39F51)
58 $B3A037 StartTextBox(text_id=$03DC, mode=$00)
59 $B3A03B Jump(target=$B39F51)
60 $B3A03E StartTextBox(text_id=$03DC, mode=$00)
61 $B3A042 Jump(target=$B39F51)
62 $B3A045 JumpIfEqualsByte(mem=$7F1F1B, value=$17, target=$B3A060)
63 $B3A04C JumpIfEqualsByte(mem=$7F1F1B, value=$1E, target=$B3A067)
64 $B3A053 GetRNG(value=$02)
65 $B3A055 JumpIfEqualsRNG(value=$00, target=$B39FB6)
66 $B3A059 JumpIfEqualsRNG(value=$01, target=$B39FD9)
67 $B3A05D Jump(target=$B39FD9)
68 $B3A060 StartTextBox(text_id=$0405, mode=$00)
69 $B3A064 Jump(target=$B39F51)
70 $B3A067 StartTextBox(text_id=$03F0, mode=$00)
71 $B3A06B SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$05, e=$00)
72 $B3A071 Jump(target=$B39F51)
73 $B3A074 StartTextBox(text_id=$01CF, mode=$00)
74 $B3A078 Jump(target=$B39F67)
75 $B3A07B GetRNG(value=$02)
76 $B3A07D GetRNG(value=$00)
77 $B3A07F StartTextBox(text_id=$03CC, mode=$00)
78 $B3A083 Jump(target=$B39F51)
```

## Entry 03 -> `$B3A086`

- Commands decoded: `51`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3A086 ChangeGameState2()
01 $B3A087 StartNestedScriptSlot(slot=$01, target=$B3A091)
02 $B3A08B WaitOrSetCCCounter(value=$0001)
03 $B3A08E Jump(target=$B3A08B)
04 $B3A091 SpawnOrMoveCCObject(x=$0028, y=$0168, visual=$83FC, mode=$02)
05 $B3A099 SetCCObjectAndJump(target=$B3A0A4)
06 $B3A09C SetCCObjectParam4(a=$C9, ptr=$ABA0, d=$A0)
07 $B3A0A1 Jump(target=$B3A099)
08 $B3A0A4 StartTextBox(text_id=$01C6, mode=$00)
09 $B3A0A8 Jump(target=$B3A099)
10 $B3A0AB JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3A0BE)
11 $B3A0B3 StartTextBox(text_id=$0200, mode=$00)
12 $B3A0B7 SetCCObjectParam(param=$02D0, value=$01)
13 $B3A0BB Jump(target=$B3A099)
14 $B3A0BE StartTextBox(text_id=$03B9, mode=$00)
15 $B3A0C2 SetCCObjectParam(param=$02D0, value=$01)
16 $B3A0C6 Jump(target=$B3A099)
17 $B3A0C9 JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B3A157)
18 $B3A0D0 JumpIfEqualsByte(mem=$7F1F19, value=$00, target=$B3A0EF)
19 $B3A0D7 JumpIfEqualsByte(mem=$7F1F19, value=$01, target=$B3A101)
20 $B3A0DE JumpIfEqualsByte(mem=$7F1F19, value=$02, target=$B3A10C)
21 $B3A0E5 JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B3A122)
22 $B3A0EC Jump(target=$B3A099)
23 $B3A0EF JumpIfEqualsByte(mem=$7F1F1B, value=$16, target=$B3A117)
24 $B3A0F6 StartTextBox(text_id=$0046, mode=$00)
25 $B3A0FA SetCCObjectParam(param=$02D0, value=$01)
26 $B3A0FE Jump(target=$B3A099)
27 $B3A101 StartTextBox(text_id=$0047, mode=$00)
28 $B3A105 SetCCObjectParam(param=$02D0, value=$01)
29 $B3A109 Jump(target=$B3A099)
30 $B3A10C StartTextBox(text_id=$03C5, mode=$00)
31 $B3A110 SetCCObjectParam(param=$02D0, value=$01)
32 $B3A114 Jump(target=$B3A099)
33 $B3A117 StartTextBox(text_id=$0203, mode=$00)
34 $B3A11B SetCCObjectParam(param=$02D0, value=$01)
35 $B3A11F Jump(target=$B3A099)
36 $B3A122 JumpIfEqualsByte(mem=$7F1F1B, value=$17, target=$B3A13B)
37 $B3A129 JumpIfEqualsByte(mem=$7F1F1B, value=$1E, target=$B3A146)
38 $B3A130 StartTextBox(text_id=$0047, mode=$00)
39 $B3A134 SetCCObjectParam(param=$02D0, value=$01)
40 $B3A138 Jump(target=$B3A099)
41 $B3A13B StartTextBox(text_id=$02AE, mode=$00)
42 $B3A13F SetCCObjectParam(param=$02D0, value=$01)
43 $B3A143 Jump(target=$B3A099)
44 $B3A146 StartTextBox(text_id=$03EF, mode=$00)
45 $B3A14A SetCCObjectParam(param=$02D0, value=$01)
46 $B3A14E SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$05, e=$00)
47 $B3A154 Jump(target=$B3A099)
48 $B3A157 StartTextBox(text_id=$03C6, mode=$00)
49 $B3A15B SetCCObjectParam(param=$02D0, value=$01)
50 $B3A15F Jump(target=$B3A099)
```

## Entry 04 -> `$B3A162`

- Commands decoded: `14`
- Stop reason: `unknown_opcode_$62`
- Pointer duplicate count: `1`

```text
00 $B3A162 ChangeGameState2()
01 $B3A163 StartNestedScriptSlot(slot=$01, target=$B3A17E)
02 $B3A167 Jump(target=$B3A170)
03 $B3A16A WaitOrSetCCCounter(value=$0001)
04 $B3A16D Jump(target=$B3A16A)
05 $B3A170 JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B3A17B)
06 $B3A177 StartNestedScriptSlot(slot=$02, target=$B3A26D)
07 $B3A17B Jump(target=$B3A16A)
08 $B3A17E SpawnOrMoveCCObject(x=$0028, y=$0168, visual=$8318, mode=$02)
09 $B3A186 SetCCObjectAndJump(target=$B3A197)
10 $B3A189 SetCCObjectParam4(a=$BC, ptr=$9EA1, d=$A1)
11 $B3A18E Jump(target=$B3A186)
12 $B3A191 SetCCObjectParam2D()
13 $B3A192 UnknownOpcode_$62()
```

## Entry 05 -> `$B3A438`

- Commands decoded: `15`
- Stop reason: `unknown_opcode_$A8`
- Pointer duplicate count: `1`

```text
00 $B3A438 ChangeGameState2()
01 $B3A439 StartNestedScriptSlot(slot=$01, target=$B3A459)
02 $B3A43D StartNestedScriptSlot(slot=$02, target=$B3A538)
03 $B3A441 JumpIfFlagSet(mem=$7F1F6C, bit=$02, target=$B3A453)
04 $B3A448 JumpIfFlagSet(mem=$7F1F6C, bit=$03, target=$B3A453)
05 $B3A44F StartNestedScriptSlot(slot=$03, target=$B3A5A3)
06 $B3A453 WaitOrSetCCCounter(value=$0001)
07 $B3A456 Jump(target=$B3A453)
08 $B3A459 SpawnOrMoveCCObject(x=$0028, y=$0198, visual=$8330, mode=$02)
09 $B3A461 SetCCObjectAndJump(target=$B3A475)
10 $B3A464 SetCCObjectParam4(a=$9A, ptr=$7CA4, d=$A4)
11 $B3A469 Jump(target=$B3A461)
12 $B3A46C SetCCObjectAndJump(target=$B3A475)
13 $B3A46F SetCCObjectParam2D()
14 $B3A470 UnknownOpcode_$A8()
```

## Entry 06 -> `$B3A5B1`

- Commands decoded: `11`
- Stop reason: `unknown_opcode_$5C`
- Pointer duplicate count: `1`

```text
00 $B3A5B1 ChangeGameState2()
01 $B3A5B2 StartNestedScriptSlot(slot=$01, target=$B3A5BC)
02 $B3A5B6 WaitOrSetCCCounter(value=$0001)
03 $B3A5B9 Jump(target=$B3A5B6)
04 $B3A5BC SpawnOrMoveCCObject(x=$0088, y=$0050, visual=$82E8, mode=$00)
05 $B3A5C4 SetCCObjectAndJump(target=$B3A5E1)
06 $B3A5C7 SetCCObjectParam4(a=$0A, ptr=$ECA6, d=$A5)
07 $B3A5CC Jump(target=$B3A5C4)
08 $B3A5CF SetCCObjectAndJump(target=$B3A5E1)
09 $B3A5D2 SetCCObjectParam2D()
10 $B3A5D3 UnknownOpcode_$5C()
```

## Entry 07 -> `$B3A727`

- Commands decoded: `11`
- Stop reason: `unknown_opcode_$A4`
- Pointer duplicate count: `1`

```text
00 $B3A727 ChangeGameState2()
01 $B3A728 StartNestedScriptSlot(slot=$01, target=$B3A732)
02 $B3A72C WaitOrSetCCCounter(value=$0001)
03 $B3A72F Jump(target=$B3A72C)
04 $B3A732 SpawnOrMoveCCObject(x=$00E8, y=$0098, visual=$836C, mode=$03)
05 $B3A73A SetCCObjectAndJump(target=$B3A74E)
06 $B3A73D SetCCObjectParam4(a=$77, ptr=$59A7, d=$A7)
07 $B3A742 Jump(target=$B3A73A)
08 $B3A745 SetCCObjectAndJump(target=$B3A74E)
09 $B3A748 SetCCObjectParam2D()
10 $B3A749 UnknownOpcode_$A4()
```

## Entry 08 -> `$B3A81B`

- Commands decoded: `40`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B3A81B ChangeGameState2()
01 $B3A81C JumpIfFlagSet(mem=$7F1F6A, bit=$09, target=$B3A850)
02 $B3A823 JumpIfEqualsByte(mem=$7F1F18, value=$00, target=$B3A850)
03 $B3A82A JumpIfEqualsByte(mem=$7F1F18, value=$01, target=$B3A850)
04 $B3A831 JumpIfEqualsByte(mem=$7F1F18, value=$03, target=$B3A850)
05 $B3A838 JumpIfEqualsByte(mem=$7F1F19, value=$00, target=$B3A850)
06 $B3A83F JumpIfEqualsByte(mem=$7F1F19, value=$01, target=$B3A850)
07 $B3A846 JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B3A850)
08 $B3A84D Jump(target=$B3A85B)
09 $B3A850 JumpIfFlagSet(mem=$7F1F6C, bit=$04, target=$B3A85B)
10 $B3A857 StartNestedScriptSlot(slot=$02, target=$B3A9FE)
11 $B3A85B StartNestedScriptSlot(slot=$01, target=$B3A96A)
12 $B3A85F StartNestedScriptSlot(slot=$06, target=$B3A93A)
13 $B3A863 StartNestedScriptSlot(slot=$07, target=$B3A892)
14 $B3A867 StartNestedScriptSlot(slot=$08, target=$B3A8E6)
15 $B3A86B JumpIfFlagSet(mem=$7F1F66, bit=$07, target=$B3A88C)
16 $B3A872 JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3A88C)
17 $B3A879 JumpIfFlagSet(mem=$7F1F6C, bit=$02, target=$B3A88C)
18 $B3A880 StartNestedScriptSlot(slot=$03, target=$B3AAA5)
19 $B3A884 StartNestedScriptSlot(slot=$04, target=$B3AB9C)
20 $B3A888 StartNestedScriptSlot(slot=$05, target=$B3AC5B)
21 $B3A88C WaitOrSetCCCounter(value=$0001)
22 $B3A88F Jump(target=$B3A88C)
23 $B3A892 JumpIfBetweenByte(mem=$7F1F1C, low=$11, high=$12, target=$B3A8E5)
24 $B3A89A JumpIfBetweenByte(mem=$7F1F19, low=$01, high=$03, target=$B3A8E5)
25 $B3A8A2 SpawnOrMoveCCObject(x=$0168, y=$01A8, visual=$84EC, mode=$00)
26 $B3A8AA SetCCObjectParam10()
27 $B3A8AB SetCCVelocityOrDelta(a=$01, b=$00, c=$08, d=$01)
28 $B3A8B0 SetCCVelocityOrDelta(a=$00, b=$FF, c=$06, d=$01)
29 $B3A8B5 SetCCVelocityOrDelta(a=$FF, b=$00, c=$08, d=$02)
30 $B3A8BA SetCCVelocityOrDelta(a=$FF, b=$01, c=$04, d=$01)
31 $B3A8BF SetCCVelocityOrDelta(a=$01, b=$00, c=$0C, d=$02)
32 $B3A8C4 SetCCVelocityOrDelta(a=$FF, b=$00, c=$06, d=$01)
33 $B3A8C9 SetCCVelocityOrDelta(a=$00, b=$FF, c=$10, d=$02)
34 $B3A8CE SetCCVelocityOrDelta(a=$FF, b=$01, c=$04, d=$01)
35 $B3A8D3 SetCCVelocityOrDelta(a=$01, b=$01, c=$0C, d=$02)
36 $B3A8D8 SetCCVelocityOrDelta(a=$01, b=$00, c=$08, d=$02)
37 $B3A8DD SetCCVelocityOrDelta(a=$00, b=$FF, c=$06, d=$01)
38 $B3A8E2 Jump(target=$B3A8AB)
39 $B3A8E5 StopOrDisableCCSlot()
```

## Entry 09 -> `$B3AD24`

- Commands decoded: `10`
- Stop reason: `unknown_opcode_$A3`
- Pointer duplicate count: `1`

```text
00 $B3AD24 ChangeGameState2()
01 $B3AD25 StartNestedScriptSlot(slot=$01, target=$B3AD2F)
02 $B3AD29 WaitOrSetCCCounter(value=$0001)
03 $B3AD2C Jump(target=$B3AD29)
04 $B3AD2F SpawnOrMoveCCObject(x=$0098, y=$0088, visual=$8234, mode=$00)
05 $B3AD37 SetCCObjectParam4(a=$65, ptr=$4FAD, d=$AD)
06 $B3AD3C Jump(target=$B3AD37)
07 $B3AD3F SetCCObjectAndJump(target=$B3AD48)
08 $B3AD42 SetCCObjectParam2D()
09 $B3AD43 UnknownOpcode_$A3()
```

## Entry 10 -> `$B3ADB1`

- Commands decoded: `9`
- Stop reason: `unknown_opcode_$D2`
- Pointer duplicate count: `1`

```text
00 $B3ADB1 ChangeGameState2()
01 $B3ADB2 StartNestedScriptSlot(slot=$01, target=$B3ADC4)
02 $B3ADB6 StartNestedScriptSlot(slot=$02, target=$B3ADD9)
03 $B3ADBA StartNestedScriptSlot(slot=$03, target=$B3ADEE)
04 $B3ADBE WaitOrSetCCCounter(value=$0001)
05 $B3ADC1 Jump(target=$B3ADBE)
06 $B3ADC4 SpawnOrMoveCCObject(x=$0068, y=$0178, visual=$84C8, mode=$00)
07 $B3ADCC SetCCObjectParam2D()
08 $B3ADCD UnknownOpcode_$D2()
```

## Entry 11 -> `$B3AE03`

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$B4`
- Pointer duplicate count: `5`

```text
00 $B3AE03 SetFlag(mem=$B44AAE, bit=$E3)
01 $B3AE08 UnknownOpcode_$B4()
```

## Entry 12 -> `$B3AE03` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$B4`
- Pointer duplicate count: `5`

```text
00 $B3AE03 SetFlag(mem=$B44AAE, bit=$E3)
01 $B3AE08 UnknownOpcode_$B4()
```

## Entry 13 -> `$B3AE03` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$B4`
- Pointer duplicate count: `5`

```text
00 $B3AE03 SetFlag(mem=$B44AAE, bit=$E3)
01 $B3AE08 UnknownOpcode_$B4()
```

## Entry 14 -> `$B3AE03` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$B4`
- Pointer duplicate count: `5`

```text
00 $B3AE03 SetFlag(mem=$B44AAE, bit=$E3)
01 $B3AE08 UnknownOpcode_$B4()
```

## Entry 15 -> `$B3AE03` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$B4`
- Pointer duplicate count: `5`

```text
00 $B3AE03 SetFlag(mem=$B44AAE, bit=$E3)
01 $B3AE08 UnknownOpcode_$B4()
```

