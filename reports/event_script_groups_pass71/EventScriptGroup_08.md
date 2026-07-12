# EventScriptGroup_08 symbolic export

- Group id: `$08`
- Group table address: `$B3E0BF`
- Pointer entries: `16`
- Unique targets: `9`

This file is generated for decompilation handoff. It keeps dialog as text ids only.

## Entry 00 -> `$B3E0DF`

- Commands decoded: `50`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3E0DF ChangeGameState2()
01 $B3E0E0 StartNestedScriptSlot(slot=$01, target=$B3E102)
02 $B3E0E4 Jump(target=$B3E0ED)
03 $B3E0E7 WaitOrSetCCCounter(value=$0001)
04 $B3E0EA Jump(target=$B3E0E7)
05 $B3E0ED JumpIfFlagSet(mem=$7F1F66, bit=$00, target=$B3E0FF)
06 $B3E0F4 JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3E0FF)
07 $B3E0FB StartNestedScriptSlot(slot=$02, target=$B3E12F)
08 $B3E0FF Jump(target=$B3E0E7)
09 $B3E102 SpawnOrMoveCCObject(x=$0188, y=$00A0, visual=$83F0, mode=$00)
10 $B3E10A SetCCObjectParam4(a=$28, ptr=$12E1, d=$E1)
11 $B3E10F Jump(target=$B3E10A)
12 $B3E112 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3E121)
13 $B3E11A StartTextBox(text_id=$0200, mode=$00)
14 $B3E11E Jump(target=$B3E10A)
15 $B3E121 StartTextBox(text_id=$03B9, mode=$00)
16 $B3E125 Jump(target=$B3E10A)
17 $B3E128 StartTextBox(text_id=$0401, mode=$00)
18 $B3E12C Jump(target=$B3E10A)
19 $B3E12F SpawnOrMoveCCObject(x=$0048, y=$0198, visual=$8168, mode=$00)
20 $B3E137 SetCCObjectAndJump(target=$B3E142)
21 $B3E13A SetCCObjectParam4(a=$5A, ptr=$61E1, d=$E1)
22 $B3E13F Jump(target=$B3E137)
23 $B3E142 JumpIfBetweenValue(mem=$7F1F1F, low=$0000, high=$00F9, target=$B3E153)
24 $B3E14C StartTextBox(text_id=$043D, mode=$00)
25 $B3E150 Jump(target=$B3E137)
26 $B3E153 StartTextBox(text_id=$0174, mode=$00)
27 $B3E157 Jump(target=$B3E137)
28 $B3E15A StartTextBox(text_id=$016B, mode=$00)
29 $B3E15E Jump(target=$B3E137)
30 $B3E161 JumpIfBetweenByte(mem=$80091E, low=$01, high=$05, target=$B3E1AF)
31 $B3E169 JumpIfBetweenByte(mem=$80091E, low=$10, high=$17, target=$B3E1AF)
32 $B3E171 JumpIfEqualsByte(mem=$80091E, value=$06, target=$B3E1A2)
33 $B3E178 JumpIfEqualsByte(mem=$80091E, value=$19, target=$B3E195)
34 $B3E17F JumpIfEqualsByte(mem=$80091E, value=$49, target=$B3E195)
35 $B3E186 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3E1BC)
36 $B3E18E StartTextBox(text_id=$0200, mode=$00)
37 $B3E192 Jump(target=$B3E137)
38 $B3E195 StartTextBox(text_id=$0212, mode=$00)
39 $B3E199 SetCCObjectParam8(a=$1F, b=$1F, c=$7F, d=$04, e=$00)
40 $B3E19F Jump(target=$B3E137)
41 $B3E1A2 StartTextBox(text_id=$03B5, mode=$00)
42 $B3E1A6 SetCCObjectParam8(a=$1F, b=$1F, c=$7F, d=$03, e=$00)
43 $B3E1AC Jump(target=$B3E137)
44 $B3E1AF StartTextBox(text_id=$03B2, mode=$00)
45 $B3E1B3 SetCCObjectParam8(a=$1F, b=$1F, c=$7F, d=$05, e=$00)
46 $B3E1B9 Jump(target=$B3E137)
47 $B3E1BC StartTextBox(text_id=$01DA, mode=$00)
48 $B3E1C0 SetCCObjectParam8(a=$1F, b=$1F, c=$7F, d=$FE, e=$FF)
49 $B3E1C6 Jump(target=$B3E137)
```

## Entry 01 -> `$B3E1C9`

- Commands decoded: `25`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3E1C9 ChangeGameState2()
01 $B3E1CA StartNestedScriptSlot(slot=$01, target=$B3E1D8)
02 $B3E1CE StartNestedScriptSlot(slot=$02, target=$B3E205)
03 $B3E1D2 WaitOrSetCCCounter(value=$0001)
04 $B3E1D5 Jump(target=$B3E1D2)
05 $B3E1D8 SpawnOrMoveCCObject(x=$0068, y=$00E8, visual=$8354, mode=$02)
06 $B3E1E0 SetCCObjectParam4(a=$FE, ptr=$E8E1, d=$E1)
07 $B3E1E5 Jump(target=$B3E1E0)
08 $B3E1E8 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3E1F7)
09 $B3E1F0 StartTextBox(text_id=$0200, mode=$00)
10 $B3E1F4 Jump(target=$B3E1E0)
11 $B3E1F7 StartTextBox(text_id=$03B0, mode=$00)
12 $B3E1FB Jump(target=$B3E1E0)
13 $B3E1FE StartTextBox(text_id=$0411, mode=$00)
14 $B3E202 Jump(target=$B3E1E0)
15 $B3E205 SpawnOrMoveCCObject(x=$0078, y=$00E8, visual=$8300, mode=$03)
16 $B3E20D SetCCObjectParam4(a=$2B, ptr=$15E2, d=$E2)
17 $B3E212 Jump(target=$B3E20D)
18 $B3E215 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3E224)
19 $B3E21D StartTextBox(text_id=$0200, mode=$00)
20 $B3E221 Jump(target=$B3E20D)
21 $B3E224 StartTextBox(text_id=$03B8, mode=$00)
22 $B3E228 Jump(target=$B3E20D)
23 $B3E22B StartTextBox(text_id=$016D, mode=$00)
24 $B3E22F Jump(target=$B3E20D)
```

## Entry 02 -> `$B3E232`

- Commands decoded: `51`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3E232 ChangeGameState2()
01 $B3E233 StartNestedScriptSlot(slot=$01, target=$B3E255)
02 $B3E237 Jump(target=$B3E240)
03 $B3E23A WaitOrSetCCCounter(value=$0001)
04 $B3E23D Jump(target=$B3E23A)
05 $B3E240 JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B3E252)
06 $B3E247 JumpIfFlagSet(mem=$7F1F6C, bit=$00, target=$B3E252)
07 $B3E24E StartNestedScriptSlot(slot=$02, target=$B3E282)
08 $B3E252 Jump(target=$B3E23A)
09 $B3E255 SpawnOrMoveCCObject(x=$0028, y=$0168, visual=$83FC, mode=$02)
10 $B3E25D SetCCObjectParam4(a=$7B, ptr=$65E2, d=$E2)
11 $B3E262 Jump(target=$B3E25D)
12 $B3E265 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3E274)
13 $B3E26D StartTextBox(text_id=$0200, mode=$00)
14 $B3E271 Jump(target=$B3E25D)
15 $B3E274 StartTextBox(text_id=$03B9, mode=$00)
16 $B3E278 Jump(target=$B3E25D)
17 $B3E27B StartTextBox(text_id=$016B, mode=$00)
18 $B3E27F Jump(target=$B3E25D)
19 $B3E282 SpawnOrMoveCCObject(x=$0058, y=$00B0, visual=$81C8, mode=$00)
20 $B3E28A Jump(target=$B3E28D)
21 $B3E28D SetCCObjectAndJump(target=$B3E298)
22 $B3E290 SetCCObjectParam4(a=$18, ptr=$B0E3, d=$E2)
23 $B3E295 Jump(target=$B3E28D)
24 $B3E298 JumpIfBetweenValue(mem=$7F1F23, low=$0000, high=$00F9, target=$B3E2A9)
25 $B3E2A2 StartTextBox(text_id=$043F, mode=$00)
26 $B3E2A6 Jump(target=$B3E28D)
27 $B3E2A9 StartTextBox(text_id=$0178, mode=$00)
28 $B3E2AD Jump(target=$B3E28D)
29 $B3E2B0 JumpIfEqualsByte(mem=$80091E, value=$05, target=$B3E2F1)
30 $B3E2B7 JumpIfEqualsByte(mem=$80091E, value=$06, target=$B3E2F1)
31 $B3E2BE JumpIfBetweenByte(mem=$80091E, low=$01, high=$07, target=$B3E2E4)
32 $B3E2C6 JumpIfBetweenByte(mem=$80091E, low=$10, high=$17, target=$B3E2E4)
33 $B3E2CE JumpIfEqualsByte(mem=$80091E, value=$19, target=$B3E2FE)
34 $B3E2D5 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3E30B)
35 $B3E2DD StartTextBox(text_id=$0200, mode=$00)
36 $B3E2E1 Jump(target=$B3E28D)
37 $B3E2E4 StartTextBox(text_id=$03B2, mode=$00)
38 $B3E2E8 SetCCObjectParam8(a=$23, b=$1F, c=$7F, d=$02, e=$00)
39 $B3E2EE Jump(target=$B3E28D)
40 $B3E2F1 StartTextBox(text_id=$0212, mode=$00)
41 $B3E2F5 SetCCObjectParam8(a=$23, b=$1F, c=$7F, d=$08, e=$00)
42 $B3E2FB Jump(target=$B3E28D)
43 $B3E2FE StartTextBox(text_id=$03B1, mode=$00)
44 $B3E302 SetCCObjectParam8(a=$23, b=$1F, c=$7F, d=$F8, e=$FF)
45 $B3E308 Jump(target=$B3E28D)
46 $B3E30B StartTextBox(text_id=$03BA, mode=$00)
47 $B3E30F SetCCObjectParam8(a=$23, b=$1F, c=$7F, d=$FE, e=$FF)
48 $B3E315 Jump(target=$B3E28D)
49 $B3E318 StartTextBox(text_id=$0163, mode=$00)
50 $B3E31C Jump(target=$B3E28D)
```

## Entry 03 -> `$B3E31F`

- Commands decoded: `52`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3E31F ChangeGameState2()
01 $B3E320 StartNestedScriptSlot(slot=$01, target=$B3E33B)
02 $B3E324 Jump(target=$B3E32D)
03 $B3E327 WaitOrSetCCCounter(value=$0001)
04 $B3E32A Jump(target=$B3E327)
05 $B3E32D JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B3E338)
06 $B3E334 StartNestedScriptSlot(slot=$02, target=$B3E368)
07 $B3E338 Jump(target=$B3E327)
08 $B3E33B SpawnOrMoveCCObject(x=$0028, y=$0168, visual=$8318, mode=$02)
09 $B3E343 SetCCObjectParam4(a=$61, ptr=$4BE3, d=$E3)
10 $B3E348 Jump(target=$B3E343)
11 $B3E34B JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3E35A)
12 $B3E353 StartTextBox(text_id=$0200, mode=$00)
13 $B3E357 Jump(target=$B3E343)
14 $B3E35A StartTextBox(text_id=$0049, mode=$00)
15 $B3E35E Jump(target=$B3E343)
16 $B3E361 StartTextBox(text_id=$016F, mode=$00)
17 $B3E365 Jump(target=$B3E343)
18 $B3E368 SpawnOrMoveCCObject(x=$00D8, y=$00A8, visual=$8198, mode=$00)
19 $B3E370 SetCCObjectBoxOrAnim(a=$1820, b=$A401, c=$81, d=$10)
20 $B3E377 Jump(target=$B3E37A)
21 $B3E37A SetCCObjectAndJump(target=$B3E385)
22 $B3E37D SetCCObjectParam4(a=$0C, ptr=$9DE4, d=$E3)
23 $B3E382 Jump(target=$B3E37A)
24 $B3E385 JumpIfBetweenValue(mem=$7F1F25, low=$0000, high=$00F9, target=$B3E396)
25 $B3E38F StartTextBox(text_id=$043E, mode=$00)
26 $B3E393 Jump(target=$B3E37A)
27 $B3E396 StartTextBox(text_id=$0176, mode=$00)
28 $B3E39A Jump(target=$B3E37A)
29 $B3E39D JumpIfEqualsByte(mem=$80091E, value=$02, target=$B3E3D8)
30 $B3E3A4 JumpIfBetweenByte(mem=$80091E, low=$01, high=$07, target=$B3E3E5)
31 $B3E3AC JumpIfBetweenByte(mem=$80091E, low=$10, high=$17, target=$B3E3E5)
32 $B3E3B4 JumpIfEqualsByte(mem=$80091E, value=$06, target=$B3E3E5)
33 $B3E3BB JumpIfEqualsByte(mem=$80091E, value=$19, target=$B3E3F2)
34 $B3E3C2 JumpIfEqualsByte(mem=$80091E, value=$49, target=$B3E3F2)
35 $B3E3C9 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3E3FF)
36 $B3E3D1 StartTextBox(text_id=$0200, mode=$00)
37 $B3E3D5 Jump(target=$B3E37A)
38 $B3E3D8 StartTextBox(text_id=$03B4, mode=$00)
39 $B3E3DC SetCCObjectParam8(a=$21, b=$1F, c=$7F, d=$F8, e=$FF)
40 $B3E3E2 Jump(target=$B3E37A)
41 $B3E3E5 StartTextBox(text_id=$03B2, mode=$00)
42 $B3E3E9 SetCCObjectParam8(a=$21, b=$1F, c=$7F, d=$06, e=$00)
43 $B3E3EF Jump(target=$B3E37A)
44 $B3E3F2 StartTextBox(text_id=$0212, mode=$00)
45 $B3E3F6 SetCCObjectParam8(a=$21, b=$1F, c=$7F, d=$02, e=$00)
46 $B3E3FC Jump(target=$B3E37A)
47 $B3E3FF StartTextBox(text_id=$03B4, mode=$00)
48 $B3E403 SetCCObjectParam8(a=$21, b=$1F, c=$7F, d=$FE, e=$FF)
49 $B3E409 Jump(target=$B3E37A)
50 $B3E40C StartTextBox(text_id=$0169, mode=$00)
51 $B3E410 Jump(target=$B3E37A)
```

## Entry 04 -> `$B3E413`

- Commands decoded: `50`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3E413 ChangeGameState2()
01 $B3E414 StartNestedScriptSlot(slot=$01, target=$B3E453)
02 $B3E418 StartNestedScriptSlot(slot=$02, target=$B3E483)
03 $B3E41C JumpIfFlagSet(mem=$7F1F6C, bit=$02, target=$B3E437)
04 $B3E423 JumpIfFlagSet(mem=$7F1F6C, bit=$03, target=$B3E437)
05 $B3E42A StartNestedScriptSlot(slot=$04, target=$B3E445)
06 $B3E42E Jump(target=$B3E437)
07 $B3E431 WaitOrSetCCCounter(value=$0001)
08 $B3E434 Jump(target=$B3E431)
09 $B3E437 JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B3E442)
10 $B3E43E StartNestedScriptSlot(slot=$03, target=$B3E4A5)
11 $B3E442 Jump(target=$B3E431)
12 $B3E445 SpawnOrMoveCCObject(x=$0087, y=$0097, visual=$8558, mode=$00)
13 $B3E44D WaitOrSetCCCounter(value=$0001)
14 $B3E450 Jump(target=$B3E44D)
15 $B3E453 SpawnOrMoveCCObject(x=$0028, y=$0198, visual=$8330, mode=$02)
16 $B3E45B Jump(target=$B3E45E)
17 $B3E45E SetCCObjectParam4(a=$7C, ptr=$66E4, d=$E4)
18 $B3E463 Jump(target=$B3E45E)
19 $B3E466 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3E475)
20 $B3E46E StartTextBox(text_id=$0200, mode=$00)
21 $B3E472 Jump(target=$B3E45E)
22 $B3E475 StartTextBox(text_id=$03BB, mode=$00)
23 $B3E479 Jump(target=$B3E45E)
24 $B3E47C StartTextBox(text_id=$0402, mode=$00)
25 $B3E480 Jump(target=$B3E45E)
26 $B3E483 SpawnOrMoveCCObject(x=$0088, y=$0158, visual=$8348, mode=$00)
27 $B3E48B SetCCObjectParam4(a=$9A, ptr=$93E4, d=$E4)
28 $B3E490 Jump(target=$B3E48B)
29 $B3E493 StartTextBox(text_id=$03BC, mode=$00)
30 $B3E497 Jump(target=$B3E48B)
31 $B3E49A StartTextBox(text_id=$03C9, mode=$02)
32 $B3E49E StartTextBox(text_id=$0412, mode=$01)
33 $B3E4A2 Jump(target=$B3E48B)
34 $B3E4A5 SpawnOrMoveCCObject(x=$0058, y=$01B8, visual=$81E0, mode=$00)
35 $B3E4AD SetCCObjectAndJump(target=$B3E4B8)
36 $B3E4B0 SetCCObjectParam4(a=$E6, ptr=$D0E4, d=$E4)
37 $B3E4B5 Jump(target=$B3E4AD)
38 $B3E4B8 JumpIfBetweenValue(mem=$7F1F25, low=$0000, high=$00F9, target=$B3E4C9)
39 $B3E4C2 StartTextBox(text_id=$0440, mode=$00)
40 $B3E4C6 Jump(target=$B3E4AD)
41 $B3E4C9 StartTextBox(text_id=$017A, mode=$00)
42 $B3E4CD Jump(target=$B3E4AD)
43 $B3E4D0 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3E4DF)
44 $B3E4D8 StartTextBox(text_id=$0200, mode=$00)
45 $B3E4DC Jump(target=$B3E4AD)
46 $B3E4DF StartTextBox(text_id=$03B0, mode=$00)
47 $B3E4E3 Jump(target=$B3E4AD)
48 $B3E4E6 StartTextBox(text_id=$0165, mode=$00)
49 $B3E4EA Jump(target=$B3E4AD)
```

## Entry 05 -> `$B3E4ED`

- Commands decoded: `28`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B3E4ED ChangeGameState2()
01 $B3E4EE StartNestedScriptSlot(slot=$01, target=$B3E4FE)
02 $B3E4F2 StartNestedScriptSlot(slot=$02, target=$B3E52B)
03 $B3E4F6 ScreenFadeIn(param=$01)
04 $B3E4F8 WaitOrSetCCCounter(value=$0001)
05 $B3E4FB Jump(target=$B3E4F8)
06 $B3E4FE SpawnOrMoveCCObject(x=$0088, y=$0050, visual=$82E8, mode=$00)
07 $B3E506 SetCCObjectParam4(a=$24, ptr=$0EE5, d=$E5)
08 $B3E50B Jump(target=$B3E506)
09 $B3E50E JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3E51D)
10 $B3E516 StartTextBox(text_id=$0200, mode=$00)
11 $B3E51A Jump(target=$B3E506)
12 $B3E51D StartTextBox(text_id=$03BB, mode=$00)
13 $B3E521 Jump(target=$B3E506)
14 $B3E524 StartTextBox(text_id=$0168, mode=$00)
15 $B3E528 Jump(target=$B3E506)
16 $B3E52B JumpIfFlagSet(mem=$7F1F6A, bit=$0A, target=$B3E55F)
17 $B3E532 SpawnOrMoveCCObject(x=$0038, y=$0098, visual=$8390, mode=$00)
18 $B3E53A SetCCObjectParam4(a=$58, ptr=$42E5, d=$E5)
19 $B3E53F Jump(target=$B3E53A)
20 $B3E542 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3E551)
21 $B3E54A StartTextBox(text_id=$0200, mode=$00)
22 $B3E54E Jump(target=$B3E53A)
23 $B3E551 StartTextBox(text_id=$03BA, mode=$00)
24 $B3E555 Jump(target=$B3E53A)
25 $B3E558 StartTextBox(text_id=$0413, mode=$00)
26 $B3E55C Jump(target=$B3E53A)
27 $B3E55F StopOrDisableCCSlot()
```

## Entry 06 -> `$B3E560`

- Commands decoded: `15`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3E560 ChangeGameState2()
01 $B3E561 StartNestedScriptSlot(slot=$01, target=$B3E56D)
02 $B3E565 ScreenFadeIn(param=$01)
03 $B3E567 WaitOrSetCCCounter(value=$0001)
04 $B3E56A Jump(target=$B3E567)
05 $B3E56D SpawnOrMoveCCObject(x=$00E8, y=$009C, visual=$836C, mode=$03)
06 $B3E575 SetCCObjectParam4(a=$93, ptr=$7DE5, d=$E5)
07 $B3E57A Jump(target=$B3E575)
08 $B3E57D JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3E58C)
09 $B3E585 StartTextBox(text_id=$0200, mode=$00)
10 $B3E589 Jump(target=$B3E575)
11 $B3E58C StartTextBox(text_id=$03BB, mode=$00)
12 $B3E590 Jump(target=$B3E575)
13 $B3E593 StartTextBox(text_id=$016C, mode=$00)
14 $B3E597 Jump(target=$B3E575)
```

## Entry 07 -> `$B3E59A`

- Commands decoded: `25`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3E59A ChangeGameState2()
01 $B3E59B StartNestedScriptSlot(slot=$01, target=$B3E5D6)
02 $B3E59F StartNestedScriptSlot(slot=$02, target=$B3E5A9)
03 $B3E5A3 WaitOrSetCCCounter(value=$0001)
04 $B3E5A6 Jump(target=$B3E5A3)
05 $B3E5A9 SpawnOrMoveCCObject(x=$0058, y=$00B8, visual=$8234, mode=$00)
06 $B3E5B1 SetCCObjectParam4(a=$CF, ptr=$B9E5, d=$E5)
07 $B3E5B6 Jump(target=$B3E5B1)
08 $B3E5B9 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3E5C8)
09 $B3E5C1 StartTextBox(text_id=$03BC, mode=$00)
10 $B3E5C5 Jump(target=$B3E5B1)
11 $B3E5C8 StartTextBox(text_id=$03BB, mode=$00)
12 $B3E5CC Jump(target=$B3E5B1)
13 $B3E5CF StartTextBox(text_id=$0414, mode=$00)
14 $B3E5D3 Jump(target=$B3E5B1)
15 $B3E5D6 SpawnOrMoveCCObject(x=$0098, y=$0088, visual=$8234, mode=$00)
16 $B3E5DE SetCCObjectParam4(a=$FC, ptr=$E6E5, d=$E5)
17 $B3E5E3 Jump(target=$B3E5DE)
18 $B3E5E6 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3E5F5)
19 $B3E5EE StartTextBox(text_id=$03BC, mode=$00)
20 $B3E5F2 Jump(target=$B3E5DE)
21 $B3E5F5 StartTextBox(text_id=$03BB, mode=$00)
22 $B3E5F9 Jump(target=$B3E5DE)
23 $B3E5FC StartTextBox(text_id=$0415, mode=$00)
24 $B3E600 Jump(target=$B3E5DE)
```

## Entry 08 -> `$B3E603`

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$E8`
- Pointer duplicate count: `8`

```text
00 $B3E603 SetFlag(mem=$E83BE6, bit=$3B)
01 $B3E608 UnknownOpcode_$E8()
```

## Entry 09 -> `$B3E603` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$E8`
- Pointer duplicate count: `8`

```text
00 $B3E603 SetFlag(mem=$E83BE6, bit=$3B)
01 $B3E608 UnknownOpcode_$E8()
```

## Entry 10 -> `$B3E603` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$E8`
- Pointer duplicate count: `8`

```text
00 $B3E603 SetFlag(mem=$E83BE6, bit=$3B)
01 $B3E608 UnknownOpcode_$E8()
```

## Entry 11 -> `$B3E603` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$E8`
- Pointer duplicate count: `8`

```text
00 $B3E603 SetFlag(mem=$E83BE6, bit=$3B)
01 $B3E608 UnknownOpcode_$E8()
```

## Entry 12 -> `$B3E603` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$E8`
- Pointer duplicate count: `8`

```text
00 $B3E603 SetFlag(mem=$E83BE6, bit=$3B)
01 $B3E608 UnknownOpcode_$E8()
```

## Entry 13 -> `$B3E603` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$E8`
- Pointer duplicate count: `8`

```text
00 $B3E603 SetFlag(mem=$E83BE6, bit=$3B)
01 $B3E608 UnknownOpcode_$E8()
```

## Entry 14 -> `$B3E603` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$E8`
- Pointer duplicate count: `8`

```text
00 $B3E603 SetFlag(mem=$E83BE6, bit=$3B)
01 $B3E608 UnknownOpcode_$E8()
```

## Entry 15 -> `$B3E603` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$E8`
- Pointer duplicate count: `8`

```text
00 $B3E603 SetFlag(mem=$E83BE6, bit=$3B)
01 $B3E608 UnknownOpcode_$E8()
```

