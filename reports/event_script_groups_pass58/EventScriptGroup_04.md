# EventScriptGroup_04 symbolic export

- Group id: `$04`
- Group table address: `$B3C507`
- Pointer entries: `16`
- Unique targets: `9`

This file is generated for decompilation handoff. It keeps dialog as text ids only.

## Entry 00 -> `$B3C527`

- Commands decoded: `85`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3C527 ChangeGameState2()
01 $B3C528 StartNestedScriptSlot(slot=$01, target=$B3C54E)
02 $B3C52C StartNestedScriptSlot(slot=$02, target=$B3C5A1)
03 $B3C530 Jump(target=$B3C539)
04 $B3C533 WaitOrSetCCCounter(value=$0001)
05 $B3C536 Jump(target=$B3C533)
06 $B3C539 JumpIfFlagSet(mem=$7F1F66, bit=$00, target=$B3C54B)
07 $B3C540 JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3C54B)
08 $B3C547 StartNestedScriptSlot(slot=$03, target=$B3C600)
09 $B3C54B Jump(target=$B3C533)
10 $B3C54E SpawnOrMoveCCObject(x=$00C8, y=$0078, visual=$8300, mode=$00)
11 $B3C556 SetCCObjectAndJump(target=$B3C561)
12 $B3C559 SetCCObjectParam4(a=$7E, ptr=$68C5, d=$C5)
13 $B3C55E Jump(target=$B3C556)
14 $B3C561 StartTextBox(text_id=$01C9, mode=$00)
15 $B3C565 Jump(target=$B3C556)
16 $B3C568 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3C577)
17 $B3C570 StartTextBox(text_id=$0200, mode=$00)
18 $B3C574 Jump(target=$B3C556)
19 $B3C577 StartTextBox(text_id=$03B8, mode=$00)
20 $B3C57B Jump(target=$B3C556)
21 $B3C57E JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3C59A)
22 $B3C585 JumpIfEqualsByte(mem=$7F1F19, value=$02, target=$B3C593)
23 $B3C58C StartTextBox(text_id=$0039, mode=$00)
24 $B3C590 Jump(target=$B3C556)
25 $B3C593 StartTextBox(text_id=$03BE, mode=$00)
26 $B3C597 Jump(target=$B3C556)
27 $B3C59A StartTextBox(text_id=$01CD, mode=$00)
28 $B3C59E Jump(target=$B3C556)
29 $B3C5A1 SpawnOrMoveCCObject(x=$0188, y=$00A0, visual=$83F0, mode=$00)
30 $B3C5A9 SetCCObjectAndJump(target=$B3C5B4)
31 $B3C5AC SetCCObjectParam4(a=$D1, ptr=$BBC5, d=$C5)
32 $B3C5B1 Jump(target=$B3C5A9)
33 $B3C5B4 StartTextBox(text_id=$01C6, mode=$00)
34 $B3C5B8 Jump(target=$B3C5A9)
35 $B3C5BB JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3C5CA)
36 $B3C5C3 StartTextBox(text_id=$0200, mode=$00)
37 $B3C5C7 Jump(target=$B3C5A9)
38 $B3C5CA StartTextBox(text_id=$03B9, mode=$00)
39 $B3C5CE Jump(target=$B3C5A9)
40 $B3C5D1 JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3C5F9)
41 $B3C5D8 JumpIfBetweenByte(mem=$7F1F19, low=$00, high=$01, target=$B3C5EB)
42 $B3C5E0 JumpIfBetweenByte(mem=$7F1F19, low=$02, high=$03, target=$B3C5F2)
43 $B3C5E8 Jump(target=$B3C5A9)
44 $B3C5EB StartTextBox(text_id=$003E, mode=$00)
45 $B3C5EF Jump(target=$B3C5A9)
46 $B3C5F2 StartTextBox(text_id=$003F, mode=$00)
47 $B3C5F6 Jump(target=$B3C5A9)
48 $B3C5F9 StartTextBox(text_id=$01CE, mode=$00)
49 $B3C5FD Jump(target=$B3C5A9)
50 $B3C600 SpawnOrMoveCCObject(x=$0048, y=$0198, visual=$8168, mode=$00)
51 $B3C608 SetCCObjectAndJump(target=$B3C613)
52 $B3C60B SetCCObjectParam4(a=$A7, ptr=$2BC6, d=$C6)
53 $B3C610 Jump(target=$B3C608)
54 $B3C613 JumpIfBetweenValue(mem=$7F1F1F, low=$0000, high=$00F9, target=$B3C624)
55 $B3C61D StartTextBox(text_id=$043D, mode=$00)
56 $B3C621 Jump(target=$B3C608)
57 $B3C624 StartTextBox(text_id=$0174, mode=$00)
58 $B3C628 Jump(target=$B3C608)
59 $B3C62B JumpIfEqualsByte(mem=$80091E, value=$02, target=$B3C666)
60 $B3C632 JumpIfEqualsByte(mem=$80091E, value=$06, target=$B3C680)
61 $B3C639 JumpIfBetweenByte(mem=$80091E, low=$01, high=$07, target=$B3C680)
62 $B3C641 JumpIfEqualsByte(mem=$80091E, value=$19, target=$B3C673)
63 $B3C648 JumpIfEqualsByte(mem=$80091E, value=$49, target=$B3C673)
64 $B3C64F JumpIfBetweenByte(mem=$80091E, low=$10, high=$17, target=$B3C68D)
65 $B3C657 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3C69A)
66 $B3C65F StartTextBox(text_id=$0200, mode=$00)
67 $B3C663 Jump(target=$B3C608)
68 $B3C666 StartTextBox(text_id=$03B0, mode=$00)
69 $B3C66A SetCCObjectParam8(a=$1F, b=$1F, c=$7F, d=$F8, e=$FF)
70 $B3C670 Jump(target=$B3C608)
71 $B3C673 StartTextBox(text_id=$0212, mode=$00)
72 $B3C677 SetCCObjectParam8(a=$1F, b=$1F, c=$7F, d=$04, e=$00)
73 $B3C67D Jump(target=$B3C608)
74 $B3C680 StartTextBox(text_id=$03B5, mode=$00)
75 $B3C684 SetCCObjectParam8(a=$1F, b=$1F, c=$7F, d=$03, e=$00)
76 $B3C68A Jump(target=$B3C608)
77 $B3C68D StartTextBox(text_id=$03B2, mode=$00)
78 $B3C691 SetCCObjectParam8(a=$1F, b=$1F, c=$7F, d=$05, e=$00)
79 $B3C697 Jump(target=$B3C608)
... truncated after 80 commands; use CSV/index for full count.
```

## Entry 01 -> `$B3C6AE`

- Commands decoded: `20`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3C6AE ChangeGameState2()
01 $B3C6AF StartNestedScriptSlot(slot=$01, target=$B3C6B9)
02 $B3C6B3 WaitOrSetCCCounter(value=$0001)
03 $B3C6B6 Jump(target=$B3C6B3)
04 $B3C6B9 SpawnOrMoveCCObject(x=$0068, y=$00E8, visual=$8354, mode=$00)
05 $B3C6C1 SetCCObjectAndJump(target=$B3C6CC)
06 $B3C6C4 SetCCObjectParam4(a=$E9, ptr=$D3C6, d=$C6)
07 $B3C6C9 Jump(target=$B3C6C1)
08 $B3C6CC StartTextBox(text_id=$01E0, mode=$00)
09 $B3C6D0 Jump(target=$B3C6C1)
10 $B3C6D3 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3C6E2)
11 $B3C6DB StartTextBox(text_id=$0200, mode=$00)
12 $B3C6DF Jump(target=$B3C6C1)
13 $B3C6E2 StartTextBox(text_id=$03B0, mode=$00)
14 $B3C6E6 Jump(target=$B3C6C1)
15 $B3C6E9 JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3C6F7)
16 $B3C6F0 StartTextBox(text_id=$005B, mode=$00)
17 $B3C6F4 Jump(target=$B3C6C1)
18 $B3C6F7 StartTextBox(text_id=$01CF, mode=$00)
19 $B3C6FB Jump(target=$B3C6C1)
```

## Entry 02 -> `$B3C6FE`

- Commands decoded: `59`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3C6FE ChangeGameState2()
01 $B3C6FF StartNestedScriptSlot(slot=$01, target=$B3C721)
02 $B3C703 Jump(target=$B3C70C)
03 $B3C706 WaitOrSetCCCounter(value=$0001)
04 $B3C709 Jump(target=$B3C706)
05 $B3C70C JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B3C71E)
06 $B3C713 JumpIfFlagSet(mem=$7F1F6C, bit=$00, target=$B3C71E)
07 $B3C71A StartNestedScriptSlot(slot=$02, target=$B3C758)
08 $B3C71E Jump(target=$B3C706)
09 $B3C721 SpawnOrMoveCCObject(x=$0028, y=$0168, visual=$83FC, mode=$02)
10 $B3C729 SetCCObjectAndJump(target=$B3C734)
11 $B3C72C SetCCObjectParam4(a=$51, ptr=$3BC7, d=$C7)
12 $B3C731 Jump(target=$B3C729)
13 $B3C734 StartTextBox(text_id=$01C6, mode=$00)
14 $B3C738 Jump(target=$B3C729)
15 $B3C73B JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3C74A)
16 $B3C743 StartTextBox(text_id=$0200, mode=$00)
17 $B3C747 Jump(target=$B3C729)
18 $B3C74A StartTextBox(text_id=$03B9, mode=$00)
19 $B3C74E Jump(target=$B3C729)
20 $B3C751 StartTextBox(text_id=$004B, mode=$00)
21 $B3C755 Jump(target=$B3C729)
22 $B3C758 SpawnOrMoveCCObject(x=$0058, y=$00B0, visual=$81C8, mode=$00)
23 $B3C760 Jump(target=$B3C763)
24 $B3C763 SetCCObjectAndJump(target=$B3C76E)
25 $B3C766 SetCCObjectParam4(a=$09, ptr=$86C8, d=$C7)
26 $B3C76B Jump(target=$B3C763)
27 $B3C76E JumpIfBetweenValue(mem=$7F1F23, low=$0000, high=$00F9, target=$B3C77F)
28 $B3C778 StartTextBox(text_id=$043F, mode=$00)
29 $B3C77C Jump(target=$B3C763)
30 $B3C77F StartTextBox(text_id=$0178, mode=$00)
31 $B3C783 Jump(target=$B3C763)
32 $B3C786 JumpIfEqualsByte(mem=$80091E, value=$02, target=$B3C7EF)
33 $B3C78D JumpIfEqualsByte(mem=$80091E, value=$05, target=$B3C7D5)
34 $B3C794 JumpIfEqualsByte(mem=$80091E, value=$06, target=$B3C7D5)
35 $B3C79B JumpIfBetweenByte(mem=$80091E, low=$01, high=$07, target=$B3C7C8)
36 $B3C7A3 JumpIfBetweenByte(mem=$80091E, low=$10, high=$17, target=$B3C7C8)
37 $B3C7AB JumpIfEqualsByte(mem=$80091E, value=$18, target=$B3C7E2)
38 $B3C7B2 JumpIfEqualsByte(mem=$80091E, value=$19, target=$B3C7FC)
39 $B3C7B9 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3C7EF)
40 $B3C7C1 StartTextBox(text_id=$0200, mode=$00)
41 $B3C7C5 Jump(target=$B3C763)
42 $B3C7C8 StartTextBox(text_id=$03B2, mode=$00)
43 $B3C7CC SetCCObjectParam8(a=$23, b=$1F, c=$7F, d=$02, e=$00)
44 $B3C7D2 Jump(target=$B3C763)
45 $B3C7D5 StartTextBox(text_id=$0212, mode=$00)
46 $B3C7D9 SetCCObjectParam8(a=$23, b=$1F, c=$7F, d=$08, e=$00)
47 $B3C7DF Jump(target=$B3C763)
48 $B3C7E2 StartTextBox(text_id=$03B1, mode=$00)
49 $B3C7E6 SetCCObjectParam8(a=$23, b=$1F, c=$7F, d=$FA, e=$FF)
50 $B3C7EC Jump(target=$B3C763)
51 $B3C7EF StartTextBox(text_id=$01D9, mode=$00)
52 $B3C7F3 SetCCObjectParam8(a=$23, b=$1F, c=$7F, d=$FC, e=$FF)
53 $B3C7F9 Jump(target=$B3C763)
54 $B3C7FC StartTextBox(text_id=$0143, mode=$00)
55 $B3C800 SetCCObjectParam8(a=$23, b=$1F, c=$7F, d=$04, e=$00)
56 $B3C806 Jump(target=$B3C763)
57 $B3C809 StartTextBox(text_id=$00C0, mode=$00)
58 $B3C80D Jump(target=$B3C763)
```

## Entry 03 -> `$B3C810`

- Commands decoded: `61`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3C810 ChangeGameState2()
01 $B3C811 StartNestedScriptSlot(slot=$01, target=$B3C82C)
02 $B3C815 Jump(target=$B3C81E)
03 $B3C818 WaitOrSetCCCounter(value=$0001)
04 $B3C81B Jump(target=$B3C818)
05 $B3C81E JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B3C829)
06 $B3C825 StartNestedScriptSlot(slot=$02, target=$B3C871)
07 $B3C829 Jump(target=$B3C818)
08 $B3C82C SpawnOrMoveCCObject(x=$0028, y=$0168, visual=$8318, mode=$02)
09 $B3C834 SetCCObjectAndJump(target=$B3C83F)
10 $B3C837 SetCCObjectParam4(a=$5C, ptr=$46C8, d=$C8)
11 $B3C83C Jump(target=$B3C834)
12 $B3C83F StartTextBox(text_id=$01CA, mode=$00)
13 $B3C843 Jump(target=$B3C834)
14 $B3C846 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3C855)
15 $B3C84E StartTextBox(text_id=$0200, mode=$00)
16 $B3C852 Jump(target=$B3C834)
17 $B3C855 StartTextBox(text_id=$0049, mode=$00)
18 $B3C859 Jump(target=$B3C834)
19 $B3C85C JumpIfFlagSet(mem=$7F1F6A, bit=$0E, target=$B3C86A)
20 $B3C863 StartTextBox(text_id=$0079, mode=$00)
21 $B3C867 Jump(target=$B3C834)
22 $B3C86A StartTextBox(text_id=$01DC, mode=$00)
23 $B3C86E Jump(target=$B3C834)
24 $B3C871 SpawnOrMoveCCObject(x=$00B8, y=$0098, visual=$8198, mode=$00)
25 $B3C879 SetCCObjectBoxOrAnim(a=$1820, b=$A401, c=$81, d=$10)
26 $B3C880 Jump(target=$B3C883)
27 $B3C883 SetCCObjectAndJump(target=$B3C88E)
28 $B3C886 SetCCObjectParam4(a=$15, ptr=$A6C9, d=$C8)
29 $B3C88B Jump(target=$B3C883)
30 $B3C88E JumpIfBetweenValue(mem=$7F1F21, low=$0000, high=$00F9, target=$B3C89F)
31 $B3C898 StartTextBox(text_id=$043E, mode=$00)
32 $B3C89C Jump(target=$B3C883)
33 $B3C89F StartTextBox(text_id=$0176, mode=$00)
34 $B3C8A3 Jump(target=$B3C883)
35 $B3C8A6 JumpIfEqualsByte(mem=$80091E, value=$02, target=$B3C8E1)
36 $B3C8AD JumpIfBetweenByte(mem=$80091E, low=$01, high=$07, target=$B3C8EE)
37 $B3C8B5 JumpIfBetweenByte(mem=$80091E, low=$10, high=$17, target=$B3C8EE)
38 $B3C8BD JumpIfEqualsByte(mem=$80091E, value=$06, target=$B3C8EE)
39 $B3C8C4 JumpIfEqualsByte(mem=$80091E, value=$19, target=$B3C8FB)
40 $B3C8CB JumpIfEqualsByte(mem=$80091E, value=$49, target=$B3C8FB)
41 $B3C8D2 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3C908)
42 $B3C8DA StartTextBox(text_id=$0200, mode=$00)
43 $B3C8DE Jump(target=$B3C883)
44 $B3C8E1 StartTextBox(text_id=$03B4, mode=$00)
45 $B3C8E5 SetCCObjectParam8(a=$21, b=$1F, c=$7F, d=$F8, e=$FF)
46 $B3C8EB Jump(target=$B3C883)
47 $B3C8EE StartTextBox(text_id=$03B2, mode=$00)
48 $B3C8F2 SetCCObjectParam8(a=$21, b=$1F, c=$7F, d=$06, e=$00)
49 $B3C8F8 Jump(target=$B3C883)
50 $B3C8FB StartTextBox(text_id=$0212, mode=$00)
51 $B3C8FF SetCCObjectParam8(a=$21, b=$1F, c=$7F, d=$02, e=$00)
52 $B3C905 Jump(target=$B3C883)
53 $B3C908 StartTextBox(text_id=$03B4, mode=$00)
54 $B3C90C SetCCObjectParam8(a=$21, b=$1F, c=$7F, d=$FE, e=$FF)
55 $B3C912 Jump(target=$B3C883)
56 $B3C915 JumpIfFlagSet(mem=$7F1F6A, bit=$0E, target=$B3C923)
57 $B3C91C StartTextBox(text_id=$00A9, mode=$00)
58 $B3C920 Jump(target=$B3C883)
59 $B3C923 StartTextBox(text_id=$01DE, mode=$00)
60 $B3C927 Jump(target=$B3C883)
```

## Entry 04 -> `$B3C92A`

- Commands decoded: `79`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3C92A ChangeGameState2()
01 $B3C92B StartNestedScriptSlot(slot=$01, target=$B3C96A)
02 $B3C92F StartNestedScriptSlot(slot=$02, target=$B3C9B2)
03 $B3C933 JumpIfFlagSet(mem=$7F1F6C, bit=$02, target=$B3C94E)
04 $B3C93A JumpIfFlagSet(mem=$7F1F6C, bit=$03, target=$B3C94E)
05 $B3C941 StartNestedScriptSlot(slot=$04, target=$B3C95C)
06 $B3C945 Jump(target=$B3C94E)
07 $B3C948 WaitOrSetCCCounter(value=$0001)
08 $B3C94B Jump(target=$B3C948)
09 $B3C94E JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B3C959)
10 $B3C955 StartNestedScriptSlot(slot=$03, target=$B3C9D4)
11 $B3C959 Jump(target=$B3C948)
12 $B3C95C SpawnOrMoveCCObject(x=$0087, y=$0097, visual=$8558, mode=$00)
13 $B3C964 WaitOrSetCCCounter(value=$0001)
14 $B3C967 Jump(target=$B3C964)
15 $B3C96A SpawnOrMoveCCObject(x=$0028, y=$0198, visual=$8330, mode=$02)
16 $B3C972 Jump(target=$B3C975)
17 $B3C975 SetCCObjectAndJump(target=$B3C980)
18 $B3C978 SetCCObjectParam4(a=$9D, ptr=$87C9, d=$C9)
19 $B3C97D Jump(target=$B3C975)
20 $B3C980 StartTextBox(text_id=$01C7, mode=$00)
21 $B3C984 Jump(target=$B3C975)
22 $B3C987 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3C996)
23 $B3C98F StartTextBox(text_id=$0200, mode=$00)
24 $B3C993 Jump(target=$B3C975)
25 $B3C996 StartTextBox(text_id=$03BB, mode=$00)
26 $B3C99A Jump(target=$B3C975)
27 $B3C99D JumpIfFlagSet(mem=$7F1F6C, bit=$02, target=$B3C9AB)
28 $B3C9A4 StartTextBox(text_id=$0050, mode=$00)
29 $B3C9A8 Jump(target=$B3C975)
30 $B3C9AB StartTextBox(text_id=$01ED, mode=$00)
31 $B3C9AF Jump(target=$B3C975)
32 $B3C9B2 SpawnOrMoveCCObject(x=$0088, y=$0158, visual=$8348, mode=$00)
33 $B3C9BA SetCCObjectParam4(a=$C9, ptr=$C2C9, d=$C9)
34 $B3C9BF Jump(target=$B3C9BA)
35 $B3C9C2 StartTextBox(text_id=$03BC, mode=$00)
36 $B3C9C6 Jump(target=$B3C9BA)
37 $B3C9C9 StartTextBox(text_id=$0054, mode=$02)
38 $B3C9CD StartTextBox(text_id=$0055, mode=$01)
39 $B3C9D1 Jump(target=$B3C9BA)
40 $B3C9D4 SpawnOrMoveCCObject(x=$0058, y=$01B8, visual=$81E0, mode=$00)
41 $B3C9DC SetCCObjectAndJump(target=$B3C9E7)
42 $B3C9DF SetCCObjectParam4(a=$83, ptr=$FFCA, d=$C9)
43 $B3C9E4 Jump(target=$B3C9DC)
44 $B3C9E7 JumpIfBetweenValue(mem=$7F1F25, low=$0000, high=$00F9, target=$B3C9F8)
45 $B3C9F1 StartTextBox(text_id=$0440, mode=$00)
46 $B3C9F5 Jump(target=$B3C9DC)
47 $B3C9F8 StartTextBox(text_id=$017A, mode=$00)
48 $B3C9FC Jump(target=$B3C9DC)
49 $B3C9FF JumpIfEqualsByte(mem=$80091E, value=$02, target=$B3CA42)
50 $B3CA06 JumpIfBetweenByte(mem=$80091E, low=$01, high=$05, target=$B3CA4F)
51 $B3CA0E JumpIfEqualsByte(mem=$80091E, value=$07, target=$B3CA4F)
52 $B3CA15 JumpIfEqualsByte(mem=$80091E, value=$19, target=$B3CA69)
53 $B3CA1C JumpIfEqualsByte(mem=$80091E, value=$49, target=$B3CA69)
54 $B3CA23 JumpIfBetweenByte(mem=$80091E, low=$10, high=$13, target=$B3CA4F)
55 $B3CA2B JumpIfBetweenByte(mem=$80091E, low=$14, high=$17, target=$B3CA5C)
56 $B3CA33 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3CA76)
57 $B3CA3B StartTextBox(text_id=$0200, mode=$00)
58 $B3CA3F Jump(target=$B3C9DC)
59 $B3CA42 StartTextBox(text_id=$03B0, mode=$00)
60 $B3CA46 SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$F8, e=$FF)
61 $B3CA4C Jump(target=$B3C9DC)
62 $B3CA4F StartTextBox(text_id=$03B2, mode=$00)
63 $B3CA53 SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$06, e=$00)
64 $B3CA59 Jump(target=$B3C9DC)
65 $B3CA5C StartTextBox(text_id=$03B3, mode=$00)
66 $B3CA60 SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$08, e=$00)
67 $B3CA66 Jump(target=$B3C9DC)
68 $B3CA69 StartTextBox(text_id=$0212, mode=$00)
69 $B3CA6D SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$05, e=$00)
70 $B3CA73 Jump(target=$B3C9DC)
71 $B3CA76 StartTextBox(text_id=$01DA, mode=$00)
72 $B3CA7A SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$FE, e=$FF)
73 $B3CA80 Jump(target=$B3C9DC)
74 $B3CA83 JumpIfFlagSet(mem=$7F1F6C, bit=$02, target=$B3CA91)
75 $B3CA8A StartTextBox(text_id=$00D5, mode=$00)
76 $B3CA8E Jump(target=$B3C9DC)
77 $B3CA91 StartTextBox(text_id=$01EE, mode=$00)
78 $B3CA95 Jump(target=$B3C9DC)
```

## Entry 05 -> `$B3CA98`

- Commands decoded: `47`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3CA98 StartNestedScriptSlot(slot=$01, target=$B3CAA6)
01 $B3CA9C StartNestedScriptSlot(slot=$02, target=$B3CB29)
02 $B3CAA0 WaitOrSetCCCounter(value=$0001)
03 $B3CAA3 Jump(target=$B3CAA0)
04 $B3CAA6 SpawnOrMoveCCObject(x=$0088, y=$0050, visual=$82E8, mode=$00)
05 $B3CAAE SetCCObjectAndJump(target=$B3CAB9)
06 $B3CAB1 SetCCObjectParam4(a=$DA, ptr=$C4CA, d=$CA)
07 $B3CAB6 Jump(target=$B3CAAE)
08 $B3CAB9 StartTextBox(text_id=$01CA, mode=$00)
09 $B3CABD SetCCObjectParam(param=$0288, value=$00)
10 $B3CAC1 Jump(target=$B3CAAE)
11 $B3CAC4 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3CAD3)
12 $B3CACC StartTextBox(text_id=$0200, mode=$00)
13 $B3CAD0 Jump(target=$B3CAAE)
14 $B3CAD3 StartTextBox(text_id=$03BB, mode=$00)
15 $B3CAD7 Jump(target=$B3CAAE)
16 $B3CADA JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3CAFD)
17 $B3CAE1 JumpIfFlagSet(mem=$7F1F6A, bit=$0E, target=$B3CB08)
18 $B3CAE8 JumpIfFlagSet(mem=$7F1F6C, bit=$00, target=$B3CB13)
19 $B3CAEF JumpIfFlagSet(mem=$7F1F6C, bit=$02, target=$B3CB1E)
20 $B3CAF6 StartTextBox(text_id=$0062, mode=$00)
21 $B3CAFA Jump(target=$B3CAAE)
22 $B3CAFD StartTextBox(text_id=$01D1, mode=$00)
23 $B3CB01 SetCCObjectParam(param=$0288, value=$00)
24 $B3CB05 Jump(target=$B3CAAE)
25 $B3CB08 StartTextBox(text_id=$01DD, mode=$00)
26 $B3CB0C SetCCObjectParam(param=$0288, value=$00)
27 $B3CB10 Jump(target=$B3CAAE)
28 $B3CB13 StartTextBox(text_id=$01E6, mode=$00)
29 $B3CB17 SetCCObjectParam(param=$0288, value=$00)
30 $B3CB1B Jump(target=$B3CAAE)
31 $B3CB1E StartTextBox(text_id=$01EF, mode=$00)
32 $B3CB22 SetCCObjectParam(param=$0288, value=$00)
33 $B3CB26 Jump(target=$B3CAAE)
34 $B3CB29 SpawnOrMoveCCObject(x=$0038, y=$0098, visual=$8390, mode=$00)
35 $B3CB31 SetCCObjectAndJump(target=$B3CB3C)
36 $B3CB34 SetCCObjectParam4(a=$59, ptr=$43CB, d=$CB)
37 $B3CB39 Jump(target=$B3CB31)
38 $B3CB3C StartTextBox(text_id=$01CB, mode=$00)
39 $B3CB40 Jump(target=$B3CB31)
40 $B3CB43 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3CB52)
41 $B3CB4B StartTextBox(text_id=$0200, mode=$00)
42 $B3CB4F Jump(target=$B3CB31)
43 $B3CB52 StartTextBox(text_id=$03BA, mode=$00)
44 $B3CB56 Jump(target=$B3CB31)
45 $B3CB59 StartTextBox(text_id=$0068, mode=$00)
46 $B3CB5D Jump(target=$B3CB31)
```

## Entry 06 -> `$B3CB60`

- Commands decoded: `17`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3CB60 StartNestedScriptSlot(slot=$01, target=$B3CB6A)
01 $B3CB64 WaitOrSetCCCounter(value=$0001)
02 $B3CB67 Jump(target=$B3CB64)
03 $B3CB6A SpawnOrMoveCCObject(x=$00E8, y=$009C, visual=$836C, mode=$03)
04 $B3CB72 SetCCObjectAndJump(target=$B3CB7D)
05 $B3CB75 SetCCObjectParam4(a=$9E, ptr=$88CB, d=$CB)
06 $B3CB7A Jump(target=$B3CB72)
07 $B3CB7D StartTextBox(text_id=$01C9, mode=$00)
08 $B3CB81 SetCCObjectParam(param=$02AF, value=$00)
09 $B3CB85 Jump(target=$B3CB72)
10 $B3CB88 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3CB97)
11 $B3CB90 StartTextBox(text_id=$0200, mode=$00)
12 $B3CB94 Jump(target=$B3CB72)
13 $B3CB97 StartTextBox(text_id=$03BB, mode=$00)
14 $B3CB9B Jump(target=$B3CB72)
15 $B3CB9E StartTextBox(text_id=$005E, mode=$00)
16 $B3CBA2 Jump(target=$B3CB72)
```

## Entry 07 -> `$B3CBA5`

- Commands decoded: `19`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B3CBA5 ChangeGameState2()
01 $B3CBA6 StartNestedScriptSlot(slot=$01, target=$B3CBEC)
02 $B3CBAA StartNestedScriptSlot(slot=$02, target=$B3CBB4)
03 $B3CBAE WaitOrSetCCCounter(value=$0001)
04 $B3CBB1 Jump(target=$B3CBAE)
05 $B3CBB4 SpawnOrMoveCCObject(x=$0058, y=$00B8, visual=$8234, mode=$00)
06 $B3CBBC SetCCObjectAndJump(target=$B3CBC7)
07 $B3CBBF SetCCObjectParam4(a=$E4, ptr=$CECB, d=$CB)
08 $B3CBC4 Jump(target=$B3CBBC)
09 $B3CBC7 StartTextBox(text_id=$01C8, mode=$00)
10 $B3CBCB Jump(target=$B3CBBC)
11 $B3CBCE JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3CBDD)
12 $B3CBD6 StartTextBox(text_id=$03BC, mode=$00)
13 $B3CBDA Jump(target=$B3CBBC)
14 $B3CBDD StartTextBox(text_id=$03BB, mode=$00)
15 $B3CBE1 Jump(target=$B3CBBC)
16 $B3CBE4 StartTextBox(text_id=$0150, mode=$00)
17 $B3CBE8 Jump(target=$B3CBBC)
18 $B3CBEB StopOrDisableCCSlot()
```

## Entry 08 -> `$B3CC71`

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$91`
- Pointer duplicate count: `8`

```text
00 $B3CC71 UnknownOpcode_$91()
```

## Entry 09 -> `$B3CC71` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$91`
- Pointer duplicate count: `8`

```text
00 $B3CC71 UnknownOpcode_$91()
```

## Entry 10 -> `$B3CC71` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$91`
- Pointer duplicate count: `8`

```text
00 $B3CC71 UnknownOpcode_$91()
```

## Entry 11 -> `$B3CC71` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$91`
- Pointer duplicate count: `8`

```text
00 $B3CC71 UnknownOpcode_$91()
```

## Entry 12 -> `$B3CC71` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$91`
- Pointer duplicate count: `8`

```text
00 $B3CC71 UnknownOpcode_$91()
```

## Entry 13 -> `$B3CC71` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$91`
- Pointer duplicate count: `8`

```text
00 $B3CC71 UnknownOpcode_$91()
```

## Entry 14 -> `$B3CC71` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$91`
- Pointer duplicate count: `8`

```text
00 $B3CC71 UnknownOpcode_$91()
```

## Entry 15 -> `$B3CC71` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$91`
- Pointer duplicate count: `8`

```text
00 $B3CC71 UnknownOpcode_$91()
```

