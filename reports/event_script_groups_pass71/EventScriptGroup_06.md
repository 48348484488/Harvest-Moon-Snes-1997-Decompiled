# EventScriptGroup_06 symbolic export

- Group id: `$06`
- Group table address: `$B3D447`
- Pointer entries: `16`
- Unique targets: `8`

This file is generated for decompilation handoff. It keeps dialog as text ids only.

## Entry 00 -> `$B3D467`

- Commands decoded: `67`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3D467 ChangeGameState2()
01 $B3D468 StartNestedScriptSlot(slot=$01, target=$B3D48E)
02 $B3D46C StartNestedScriptSlot(slot=$02, target=$B3D4D0)
03 $B3D470 Jump(target=$B3D479)
04 $B3D473 WaitOrSetCCCounter(value=$0001)
05 $B3D476 Jump(target=$B3D473)
06 $B3D479 JumpIfFlagSet(mem=$7F1F66, bit=$00, target=$B3D48B)
07 $B3D480 JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3D48B)
08 $B3D487 StartNestedScriptSlot(slot=$03, target=$B3D50B)
09 $B3D48B Jump(target=$B3D473)
10 $B3D48E SpawnOrMoveCCObject(x=$00A8, y=$0078, visual=$830C, mode=$00)
11 $B3D496 SetCCObjectBoxOrAnim(a=$1820, b=$0C01, c=$83, d=$10)
12 $B3D49D SetCCObjectParam4(a=$BB, ptr=$A5D4, d=$D4)
13 $B3D4A2 Jump(target=$B3D49D)
14 $B3D4A5 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3D4B4)
15 $B3D4AD StartTextBox(text_id=$0200, mode=$00)
16 $B3D4B1 Jump(target=$B3D49D)
17 $B3D4B4 StartTextBox(text_id=$03B8, mode=$00)
18 $B3D4B8 Jump(target=$B3D49D)
19 $B3D4BB JumpIfFlagSet(mem=$7F1F64, bit=$05, target=$B3D4C9)
20 $B3D4C2 StartTextBox(text_id=$0153, mode=$00)
21 $B3D4C6 Jump(target=$B3D49D)
22 $B3D4C9 StartTextBox(text_id=$0400, mode=$00)
23 $B3D4CD Jump(target=$B3D49D)
24 $B3D4D0 SpawnOrMoveCCObject(x=$0188, y=$00A0, visual=$83D8, mode=$00)
25 $B3D4D8 SetCCObjectParam4(a=$F6, ptr=$E0D4, d=$D4)
26 $B3D4DD Jump(target=$B3D4D8)
27 $B3D4E0 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3D4EF)
28 $B3D4E8 StartTextBox(text_id=$0200, mode=$00)
29 $B3D4EC Jump(target=$B3D4D8)
30 $B3D4EF StartTextBox(text_id=$03B9, mode=$00)
31 $B3D4F3 Jump(target=$B3D4D8)
32 $B3D4F6 JumpIfFlagSet(mem=$7F1F64, bit=$05, target=$B3D504)
33 $B3D4FD StartTextBox(text_id=$0154, mode=$00)
34 $B3D501 Jump(target=$B3D4D8)
35 $B3D504 StartTextBox(text_id=$0401, mode=$00)
36 $B3D508 Jump(target=$B3D4D8)
37 $B3D50B SpawnOrMoveCCObject(x=$0048, y=$0198, visual=$8174, mode=$00)
38 $B3D513 SetCCObjectAndJump(target=$B3D51E)
39 $B3D516 SetCCObjectParam4(a=$36, ptr=$4BD5, d=$D5)
40 $B3D51B Jump(target=$B3D513)
41 $B3D51E JumpIfBetweenValue(mem=$7F1F1F, low=$0000, high=$00F9, target=$B3D52F)
42 $B3D528 StartTextBox(text_id=$043D, mode=$00)
43 $B3D52C Jump(target=$B3D513)
44 $B3D52F StartTextBox(text_id=$0174, mode=$00)
45 $B3D533 Jump(target=$B3D513)
46 $B3D536 JumpIfFlagSet(mem=$7F1F64, bit=$05, target=$B3D544)
47 $B3D53D StartTextBox(text_id=$0155, mode=$00)
48 $B3D541 Jump(target=$B3D513)
49 $B3D544 StartTextBox(text_id=$0161, mode=$00)
50 $B3D548 Jump(target=$B3D513)
51 $B3D54B JumpIfEqualsByte(mem=$80091E, value=$02, target=$B3D576)
52 $B3D552 JumpIfBetweenByte(mem=$80091E, low=$03, high=$05, target=$B3D590)
53 $B3D55A JumpIfEqualsByte(mem=$80091E, value=$56, target=$B3D590)
54 $B3D561 JumpIfEqualsByte(mem=$80091E, value=$19, target=$B3D583)
55 $B3D568 JumpIfEqualsByte(mem=$80091E, value=$49, target=$B3D583)
56 $B3D56F StartTextBox(text_id=$0200, mode=$00)
57 $B3D573 Jump(target=$B3D513)
58 $B3D576 StartTextBox(text_id=$03B0, mode=$00)
59 $B3D57A SetCCObjectParam8(a=$1F, b=$1F, c=$7F, d=$F8, e=$FF)
60 $B3D580 Jump(target=$B3D513)
61 $B3D583 StartTextBox(text_id=$0212, mode=$00)
62 $B3D587 SetCCObjectParam8(a=$1F, b=$1F, c=$7F, d=$04, e=$00)
63 $B3D58D Jump(target=$B3D513)
64 $B3D590 StartTextBox(text_id=$03B5, mode=$00)
65 $B3D594 SetCCObjectParam8(a=$1F, b=$1F, c=$7F, d=$03, e=$00)
66 $B3D59A Jump(target=$B3D513)
```

## Entry 01 -> `$B3D59D`

- Commands decoded: `17`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3D59D ChangeGameState2()
01 $B3D59E StartNestedScriptSlot(slot=$01, target=$B3D5A8)
02 $B3D5A2 WaitOrSetCCCounter(value=$0001)
03 $B3D5A5 Jump(target=$B3D5A2)
04 $B3D5A8 SpawnOrMoveCCObject(x=$0068, y=$00E8, visual=$8354, mode=$00)
05 $B3D5B0 SetCCObjectParam4(a=$CE, ptr=$B8D5, d=$D5)
06 $B3D5B5 Jump(target=$B3D5B0)
07 $B3D5B8 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3D5C7)
08 $B3D5C0 StartTextBox(text_id=$0200, mode=$00)
09 $B3D5C4 Jump(target=$B3D5B0)
10 $B3D5C7 StartTextBox(text_id=$03B0, mode=$00)
11 $B3D5CB Jump(target=$B3D5B0)
12 $B3D5CE JumpIfFlagSet(mem=$7F1F64, bit=$05, target=$B3D5DC)
13 $B3D5D5 StartTextBox(text_id=$015A, mode=$00)
14 $B3D5D9 Jump(target=$B3D5B0)
15 $B3D5DC StartTextBox(text_id=$016F, mode=$00)
16 $B3D5E0 Jump(target=$B3D5B0)
```

## Entry 02 -> `$B3D5E3`

- Commands decoded: `52`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3D5E3 ChangeGameState2()
01 $B3D5E4 StartNestedScriptSlot(slot=$01, target=$B3D606)
02 $B3D5E8 Jump(target=$B3D5F1)
03 $B3D5EB WaitOrSetCCCounter(value=$0001)
04 $B3D5EE Jump(target=$B3D5EB)
05 $B3D5F1 JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B3D603)
06 $B3D5F8 JumpIfFlagSet(mem=$7F1F6C, bit=$00, target=$B3D603)
07 $B3D5FF StartNestedScriptSlot(slot=$02, target=$B3D641)
08 $B3D603 Jump(target=$B3D5EB)
09 $B3D606 SpawnOrMoveCCObject(x=$0028, y=$0168, visual=$83FC, mode=$02)
10 $B3D60E SetCCObjectParam4(a=$2C, ptr=$16D6, d=$D6)
11 $B3D613 Jump(target=$B3D60E)
12 $B3D616 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3D625)
13 $B3D61E StartTextBox(text_id=$0200, mode=$00)
14 $B3D622 Jump(target=$B3D60E)
15 $B3D625 StartTextBox(text_id=$03B9, mode=$00)
16 $B3D629 Jump(target=$B3D60E)
17 $B3D62C JumpIfFlagSet(mem=$7F1F64, bit=$05, target=$B3D63A)
18 $B3D633 StartTextBox(text_id=$0158, mode=$00)
19 $B3D637 Jump(target=$B3D60E)
20 $B3D63A StartTextBox(text_id=$016B, mode=$00)
21 $B3D63E Jump(target=$B3D60E)
22 $B3D641 SpawnOrMoveCCObject(x=$0078, y=$0088, visual=$81D4, mode=$00)
23 $B3D649 Jump(target=$B3D64C)
24 $B3D64C SetCCObjectAndJump(target=$B3D657)
25 $B3D64F SetCCObjectParam4(a=$BA, ptr=$6FD6, d=$D6)
26 $B3D654 Jump(target=$B3D64C)
27 $B3D657 JumpIfBetweenValue(mem=$7F1F23, low=$0000, high=$00F9, target=$B3D668)
28 $B3D661 StartTextBox(text_id=$043F, mode=$00)
29 $B3D665 Jump(target=$B3D64C)
30 $B3D668 StartTextBox(text_id=$0178, mode=$00)
31 $B3D66C Jump(target=$B3D64C)
32 $B3D66F JumpIfBetweenByte(mem=$80091E, low=$01, high=$04, target=$B3D693)
33 $B3D677 JumpIfEqualsByte(mem=$80091E, value=$05, target=$B3D6A0)
34 $B3D67E JumpIfEqualsByte(mem=$80091E, value=$06, target=$B3D6A0)
35 $B3D685 JumpIfEqualsByte(mem=$80091E, value=$19, target=$B3D6AD)
36 $B3D68C StartTextBox(text_id=$0200, mode=$00)
37 $B3D690 Jump(target=$B3D64C)
38 $B3D693 StartTextBox(text_id=$03B2, mode=$00)
39 $B3D697 SetCCObjectParam8(a=$23, b=$1F, c=$7F, d=$FB, e=$FF)
40 $B3D69D Jump(target=$B3D64C)
41 $B3D6A0 StartTextBox(text_id=$0212, mode=$00)
42 $B3D6A4 SetCCObjectParam8(a=$23, b=$1F, c=$7F, d=$08, e=$00)
43 $B3D6AA Jump(target=$B3D64C)
44 $B3D6AD StartTextBox(text_id=$03B1, mode=$00)
45 $B3D6B1 SetCCObjectParam8(a=$23, b=$1F, c=$7F, d=$F8, e=$FF)
46 $B3D6B7 Jump(target=$B3D64C)
47 $B3D6BA JumpIfFlagSet(mem=$7F1F64, bit=$05, target=$B3D6C8)
48 $B3D6C1 StartTextBox(text_id=$0159, mode=$00)
49 $B3D6C5 Jump(target=$B3D64C)
50 $B3D6C8 StartTextBox(text_id=$0163, mode=$00)
51 $B3D6CC Jump(target=$B3D64C)
```

## Entry 03 -> `$B3D6CF`

- Commands decoded: `54`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3D6CF ChangeGameState2()
01 $B3D6D0 StartNestedScriptSlot(slot=$01, target=$B3D6EB)
02 $B3D6D4 Jump(target=$B3D6DD)
03 $B3D6D7 WaitOrSetCCCounter(value=$0001)
04 $B3D6DA Jump(target=$B3D6D7)
05 $B3D6DD JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B3D6E8)
06 $B3D6E4 StartNestedScriptSlot(slot=$02, target=$B3D726)
07 $B3D6E8 Jump(target=$B3D6D7)
08 $B3D6EB SpawnOrMoveCCObject(x=$0028, y=$0168, visual=$8318, mode=$00)
09 $B3D6F3 SetCCObjectParam4(a=$11, ptr=$FBD7, d=$D6)
10 $B3D6F8 Jump(target=$B3D6F3)
11 $B3D6FB JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3D70A)
12 $B3D703 StartTextBox(text_id=$0200, mode=$00)
13 $B3D707 Jump(target=$B3D6F3)
14 $B3D70A StartTextBox(text_id=$0049, mode=$00)
15 $B3D70E Jump(target=$B3D6F3)
16 $B3D711 JumpIfFlagSet(mem=$7F1F64, bit=$05, target=$B3D71F)
17 $B3D718 StartTextBox(text_id=$0156, mode=$00)
18 $B3D71C Jump(target=$B3D6F3)
19 $B3D71F StartTextBox(text_id=$016F, mode=$00)
20 $B3D723 Jump(target=$B3D6F3)
21 $B3D726 SpawnOrMoveCCObject(x=$00C8, y=$0098, visual=$8198, mode=$00)
22 $B3D72E SetCCObjectBoxOrAnim(a=$1820, b=$A401, c=$81, d=$10)
23 $B3D735 Jump(target=$B3D738)
24 $B3D738 SetCCObjectAndJump(target=$B3D743)
25 $B3D73B SetCCObjectParam4(a=$B4, ptr=$5BD7, d=$D7)
26 $B3D740 Jump(target=$B3D738)
27 $B3D743 JumpIfBetweenValue(mem=$7F1F25, low=$0000, high=$00F9, target=$B3D754)
28 $B3D74D StartTextBox(text_id=$043E, mode=$00)
29 $B3D751 Jump(target=$B3D738)
30 $B3D754 StartTextBox(text_id=$0176, mode=$00)
31 $B3D758 Jump(target=$B3D738)
32 $B3D75B JumpIfEqualsByte(mem=$80091E, value=$01, target=$B3D79A)
33 $B3D762 JumpIfEqualsByte(mem=$80091E, value=$02, target=$B3D78D)
34 $B3D769 JumpIfBetweenByte(mem=$80091E, low=$03, high=$07, target=$B3D79A)
35 $B3D771 JumpIfEqualsByte(mem=$80091E, value=$06, target=$B3D79A)
36 $B3D778 JumpIfEqualsByte(mem=$80091E, value=$19, target=$B3D7A7)
37 $B3D77F JumpIfEqualsByte(mem=$80091E, value=$49, target=$B3D7A7)
38 $B3D786 StartTextBox(text_id=$0200, mode=$00)
39 $B3D78A Jump(target=$B3D738)
40 $B3D78D StartTextBox(text_id=$03B4, mode=$00)
41 $B3D791 SetCCObjectParam8(a=$21, b=$1F, c=$7F, d=$F8, e=$FF)
42 $B3D797 Jump(target=$B3D738)
43 $B3D79A StartTextBox(text_id=$03B2, mode=$00)
44 $B3D79E SetCCObjectParam8(a=$21, b=$1F, c=$7F, d=$05, e=$00)
45 $B3D7A4 Jump(target=$B3D738)
46 $B3D7A7 StartTextBox(text_id=$0212, mode=$00)
47 $B3D7AB SetCCObjectParam8(a=$21, b=$1F, c=$7F, d=$02, e=$00)
48 $B3D7B1 Jump(target=$B3D738)
49 $B3D7B4 JumpIfFlagSet(mem=$7F1F64, bit=$05, target=$B3D7C2)
50 $B3D7BB StartTextBox(text_id=$0157, mode=$00)
51 $B3D7BF Jump(target=$B3D738)
52 $B3D7C2 StartTextBox(text_id=$0162, mode=$00)
53 $B3D7C6 Jump(target=$B3D738)
```

## Entry 04 -> `$B3D7C9`

- Commands decoded: `69`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3D7C9 ChangeGameState2()
01 $B3D7CA StartNestedScriptSlot(slot=$01, target=$B3D805)
02 $B3D7CE JumpIfFlagSet(mem=$7F1F6C, bit=$02, target=$B3D7E9)
03 $B3D7D5 JumpIfFlagSet(mem=$7F1F6C, bit=$03, target=$B3D7E9)
04 $B3D7DC StartNestedScriptSlot(slot=$03, target=$B3D7F7)
05 $B3D7E0 Jump(target=$B3D7E9)
06 $B3D7E3 WaitOrSetCCCounter(value=$0001)
07 $B3D7E6 Jump(target=$B3D7E3)
08 $B3D7E9 JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B3D7F4)
09 $B3D7F0 StartNestedScriptSlot(slot=$02, target=$B3D85E)
10 $B3D7F4 Jump(target=$B3D7E3)
11 $B3D7F7 SpawnOrMoveCCObject(x=$0087, y=$0097, visual=$8558, mode=$00)
12 $B3D7FF WaitOrSetCCCounter(value=$0001)
13 $B3D802 Jump(target=$B3D7FF)
14 $B3D805 SpawnOrMoveCCObject(x=$0028, y=$0198, visual=$8330, mode=$02)
15 $B3D80D SetCCObjectParam4(a=$2B, ptr=$15D8, d=$D8)
16 $B3D812 Jump(target=$B3D80D)
17 $B3D815 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3D824)
18 $B3D81D StartTextBox(text_id=$0200, mode=$00)
19 $B3D821 Jump(target=$B3D80D)
20 $B3D824 StartTextBox(text_id=$03BB, mode=$00)
21 $B3D828 Jump(target=$B3D80D)
22 $B3D82B JumpIfFlagSet(mem=$7F1F64, bit=$05, target=$B3D839)
23 $B3D832 StartTextBox(text_id=$015E, mode=$00)
24 $B3D836 Jump(target=$B3D80D)
25 $B3D839 StartTextBox(text_id=$0402, mode=$00)
26 $B3D83D Jump(target=$B3D80D)
27 $B3D840 SpawnOrMoveCCObject(x=$0098, y=$0158, visual=$8348, mode=$00)
28 $B3D848 SetCCObjectParam4(a=$57, ptr=$50D8, d=$D8)
29 $B3D84D Jump(target=$B3D848)
30 $B3D850 StartTextBox(text_id=$03BC, mode=$00)
31 $B3D854 Jump(target=$B3D848)
32 $B3D857 StartTextBox(text_id=$0051, mode=$00)
33 $B3D85B Jump(target=$B3D848)
34 $B3D85E SpawnOrMoveCCObject(x=$0058, y=$01B8, visual=$81EC, mode=$00)
35 $B3D866 SetCCObjectAndJump(target=$B3D871)
36 $B3D869 SetCCObjectParam4(a=$F9, ptr=$89D8, d=$D8)
37 $B3D86E Jump(target=$B3D866)
38 $B3D871 JumpIfBetweenValue(mem=$7F1F25, low=$0000, high=$00F9, target=$B3D882)
39 $B3D87B StartTextBox(text_id=$0440, mode=$00)
40 $B3D87F Jump(target=$B3D866)
41 $B3D882 StartTextBox(text_id=$017A, mode=$00)
42 $B3D886 Jump(target=$B3D866)
43 $B3D889 JumpIfBetweenByte(mem=$80091E, low=$01, high=$05, target=$B3D8C5)
44 $B3D891 JumpIfEqualsByte(mem=$80091E, value=$07, target=$B3D8C5)
45 $B3D898 JumpIfEqualsByte(mem=$80091E, value=$19, target=$B3D8DF)
46 $B3D89F JumpIfEqualsByte(mem=$80091E, value=$49, target=$B3D8DF)
47 $B3D8A6 JumpIfBetweenByte(mem=$80091E, low=$10, high=$13, target=$B3D8C5)
48 $B3D8AE JumpIfBetweenByte(mem=$80091E, low=$14, high=$17, target=$B3D8D2)
49 $B3D8B6 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3D8EC)
50 $B3D8BE StartTextBox(text_id=$0200, mode=$00)
51 $B3D8C2 Jump(target=$B3D866)
52 $B3D8C5 StartTextBox(text_id=$03B2, mode=$00)
53 $B3D8C9 SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$06, e=$00)
54 $B3D8CF Jump(target=$B3D866)
55 $B3D8D2 StartTextBox(text_id=$03B3, mode=$00)
56 $B3D8D6 SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$08, e=$00)
57 $B3D8DC Jump(target=$B3D866)
58 $B3D8DF StartTextBox(text_id=$0212, mode=$00)
59 $B3D8E3 SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$05, e=$00)
60 $B3D8E9 Jump(target=$B3D866)
61 $B3D8EC StartTextBox(text_id=$01DA, mode=$00)
62 $B3D8F0 SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$FE, e=$FF)
63 $B3D8F6 Jump(target=$B3D866)
64 $B3D8F9 JumpIfFlagSet(mem=$7F1F64, bit=$05, target=$B3D907)
65 $B3D900 StartTextBox(text_id=$0158, mode=$00)
66 $B3D904 Jump(target=$B3D866)
67 $B3D907 StartTextBox(text_id=$0164, mode=$00)
68 $B3D90B Jump(target=$B3D866)
```

## Entry 05 -> `$B3D90E`

- Commands decoded: `33`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B3D90E ChangeGameState2()
01 $B3D90F StartNestedScriptSlot(slot=$01, target=$B3D91D)
02 $B3D913 StartNestedScriptSlot(slot=$02, target=$B3D958)
03 $B3D917 WaitOrSetCCCounter(value=$0001)
04 $B3D91A Jump(target=$B3D917)
05 $B3D91D SpawnOrMoveCCObject(x=$0088, y=$0050, visual=$82E8, mode=$00)
06 $B3D925 SetCCObjectParam4(a=$43, ptr=$2DD9, d=$D9)
07 $B3D92A Jump(target=$B3D925)
08 $B3D92D JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3D93C)
09 $B3D935 StartTextBox(text_id=$0200, mode=$00)
10 $B3D939 Jump(target=$B3D925)
11 $B3D93C StartTextBox(text_id=$03BB, mode=$00)
12 $B3D940 Jump(target=$B3D925)
13 $B3D943 JumpIfFlagSet(mem=$7F1F64, bit=$05, target=$B3D951)
14 $B3D94A StartTextBox(text_id=$015E, mode=$00)
15 $B3D94E Jump(target=$B3D925)
16 $B3D951 StartTextBox(text_id=$0168, mode=$00)
17 $B3D955 Jump(target=$B3D925)
18 $B3D958 JumpIfFlagSet(mem=$7F1F6A, bit=$0A, target=$B3D99A)
19 $B3D95F SpawnOrMoveCCObject(x=$0038, y=$0098, visual=$8390, mode=$00)
20 $B3D967 SetCCObjectParam4(a=$85, ptr=$6FD9, d=$D9)
21 $B3D96C Jump(target=$B3D967)
22 $B3D96F JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3D97E)
23 $B3D977 StartTextBox(text_id=$0200, mode=$00)
24 $B3D97B Jump(target=$B3D967)
25 $B3D97E StartTextBox(text_id=$03BA, mode=$00)
26 $B3D982 Jump(target=$B3D967)
27 $B3D985 JumpIfFlagSet(mem=$7F1F64, bit=$05, target=$B3D993)
28 $B3D98C StartTextBox(text_id=$0154, mode=$00)
29 $B3D990 Jump(target=$B3D967)
30 $B3D993 StartTextBox(text_id=$0403, mode=$00)
31 $B3D997 Jump(target=$B3D967)
32 $B3D99A StopOrDisableCCSlot()
```

## Entry 06 -> `$B3D99B`

- Commands decoded: `23`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3D99B ChangeGameState2()
01 $B3D99C StartNestedScriptSlot(slot=$01, target=$B3D9A6)
02 $B3D9A0 WaitOrSetCCCounter(value=$0001)
03 $B3D9A3 Jump(target=$B3D9A0)
04 $B3D9A6 SpawnOrMoveCCObject(x=$00E8, y=$009C, visual=$8378, mode=$03)
05 $B3D9AE SetCCObjectParam4(a=$CC, ptr=$B6D9, d=$D9)
06 $B3D9B3 Jump(target=$B3D9AE)
07 $B3D9B6 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3D9C5)
08 $B3D9BE StartTextBox(text_id=$0200, mode=$00)
09 $B3D9C2 Jump(target=$B3D9AE)
10 $B3D9C5 StartTextBox(text_id=$03BB, mode=$00)
11 $B3D9C9 Jump(target=$B3D9AE)
12 $B3D9CC JumpIfFlagSet(mem=$7F1F64, bit=$05, target=$B3D9F0)
13 $B3D9D3 StartTextBoxCopy(text_id=$015B, mode=$00)
14 $B3D9D7 JumpIf018F(value=$00, target=$B3D9E2)
15 $B3D9DB JumpIf018F(value=$01, target=$B3D9E9)
16 $B3D9DF Jump(target=$B3D9AE)
17 $B3D9E2 StartTextBox(text_id=$015C, mode=$00)
18 $B3D9E6 Jump(target=$B3D9AE)
19 $B3D9E9 StartTextBox(text_id=$015D, mode=$00)
20 $B3D9ED Jump(target=$B3D9AE)
21 $B3D9F0 StartTextBox(text_id=$016C, mode=$00)
22 $B3D9F4 Jump(target=$B3D9AE)
```

## Entry 07 -> `$B3D9F7`

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$72`
- Pointer duplicate count: `9`

```text
00 $B3D9F7 GetRNG(value=$DA)
01 $B3D9F9 UnknownOpcode_$72()
```

## Entry 08 -> `$B3D9F7` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$72`
- Pointer duplicate count: `9`

```text
00 $B3D9F7 GetRNG(value=$DA)
01 $B3D9F9 UnknownOpcode_$72()
```

## Entry 09 -> `$B3D9F7` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$72`
- Pointer duplicate count: `9`

```text
00 $B3D9F7 GetRNG(value=$DA)
01 $B3D9F9 UnknownOpcode_$72()
```

## Entry 10 -> `$B3D9F7` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$72`
- Pointer duplicate count: `9`

```text
00 $B3D9F7 GetRNG(value=$DA)
01 $B3D9F9 UnknownOpcode_$72()
```

## Entry 11 -> `$B3D9F7` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$72`
- Pointer duplicate count: `9`

```text
00 $B3D9F7 GetRNG(value=$DA)
01 $B3D9F9 UnknownOpcode_$72()
```

## Entry 12 -> `$B3D9F7` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$72`
- Pointer duplicate count: `9`

```text
00 $B3D9F7 GetRNG(value=$DA)
01 $B3D9F9 UnknownOpcode_$72()
```

## Entry 13 -> `$B3D9F7` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$72`
- Pointer duplicate count: `9`

```text
00 $B3D9F7 GetRNG(value=$DA)
01 $B3D9F9 UnknownOpcode_$72()
```

## Entry 14 -> `$B3D9F7` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$72`
- Pointer duplicate count: `9`

```text
00 $B3D9F7 GetRNG(value=$DA)
01 $B3D9F9 UnknownOpcode_$72()
```

## Entry 15 -> `$B3D9F7` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$72`
- Pointer duplicate count: `9`

```text
00 $B3D9F7 GetRNG(value=$DA)
01 $B3D9F9 UnknownOpcode_$72()
```

