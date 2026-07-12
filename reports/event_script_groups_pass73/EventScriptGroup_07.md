# EventScriptGroup_07 symbolic export

- Group id: `$07`
- Group table address: `$B3D9F7`
- Pointer entries: `16`
- Unique targets: `9`

This file is generated for decompilation handoff. It keeps dialog as text ids only.

## Entry 00 -> `$B3DA17`

- Commands decoded: `78`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3DA17 ChangeGameState2()
01 $B3DA18 StartNestedScriptSlot(slot=$01, target=$B3DA3E)
02 $B3DA1C StartNestedScriptSlot(slot=$02, target=$B3DA96)
03 $B3DA20 Jump(target=$B3DA29)
04 $B3DA23 WaitOrSetCCCounter(value=$0001)
05 $B3DA26 Jump(target=$B3DA23)
06 $B3DA29 JumpIfFlagSet(mem=$7F1F66, bit=$00, target=$B3DA3B)
07 $B3DA30 JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3DA3B)
08 $B3DA37 StartNestedScriptSlot(slot=$03, target=$B3DAEE)
09 $B3DA3B Jump(target=$B3DA23)
10 $B3DA3E SpawnOrMoveCCObject(x=$00C8, y=$0078, visual=$8300, mode=$00)
11 $B3DA46 SetCCObjectAndJump(target=$B3DA58)
12 $B3DA49 SetCCObjectParam4(a=$5F, ptr=$51DA, d=$DA)
13 $B3DA4E Jump(target=$B3DA46)
14 $B3DA51 StartTextBox(text_id=$0200, mode=$00)
15 $B3DA55 Jump(target=$B3DA46)
16 $B3DA58 StartTextBox(text_id=$01C9, mode=$00)
17 $B3DA5C Jump(target=$B3DA46)
18 $B3DA5F JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3DA7B)
19 $B3DA66 JumpIfEqualsByte(mem=$7F1F1B, value=$17, target=$B3DA82)
20 $B3DA6D JumpIfEqualsByte(mem=$7F1F1B, value=$1E, target=$B3DA89)
21 $B3DA74 StartTextBox(text_id=$0393, mode=$00)
22 $B3DA78 Jump(target=$B3DA46)
23 $B3DA7B StartTextBox(text_id=$01CD, mode=$00)
24 $B3DA7F Jump(target=$B3DA46)
25 $B3DA82 StartTextBox(text_id=$02AD, mode=$00)
26 $B3DA86 Jump(target=$B3DA46)
27 $B3DA89 StartTextBox(text_id=$03EC, mode=$00)
28 $B3DA8D SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$05, e=$00)
29 $B3DA93 Jump(target=$B3DA46)
30 $B3DA96 SpawnOrMoveCCObject(x=$0188, y=$00A0, visual=$83F0, mode=$00)
31 $B3DA9E SetCCObjectAndJump(target=$B3DAB0)
32 $B3DAA1 SetCCObjectParam4(a=$B7, ptr=$A9DA, d=$DA)
33 $B3DAA6 Jump(target=$B3DA9E)
34 $B3DAA9 StartTextBox(text_id=$0200, mode=$00)
35 $B3DAAD Jump(target=$B3DA9E)
36 $B3DAB0 StartTextBox(text_id=$01C6, mode=$00)
37 $B3DAB4 Jump(target=$B3DA9E)
38 $B3DAB7 JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3DAD3)
39 $B3DABE JumpIfEqualsByte(mem=$7F1F1B, value=$17, target=$B3DADA)
40 $B3DAC5 JumpIfEqualsByte(mem=$7F1F1B, value=$1E, target=$B3DAE1)
41 $B3DACC StartTextBox(text_id=$003F, mode=$00)
42 $B3DAD0 Jump(target=$B3DA9E)
43 $B3DAD3 StartTextBox(text_id=$01CE, mode=$00)
44 $B3DAD7 Jump(target=$B3DA9E)
45 $B3DADA StartTextBox(text_id=$02AE, mode=$00)
46 $B3DADE Jump(target=$B3DA9E)
47 $B3DAE1 StartTextBox(text_id=$03ED, mode=$00)
48 $B3DAE5 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$05, e=$00)
49 $B3DAEB Jump(target=$B3DA9E)
50 $B3DAEE SpawnOrMoveCCObject(x=$0048, y=$0198, visual=$8168, mode=$00)
51 $B3DAF6 SetCCObjectAndJump(target=$B3DB01)
52 $B3DAF9 SetCCObjectParam4(a=$19, ptr=$42DB, d=$DB)
53 $B3DAFE Jump(target=$B3DAF6)
54 $B3DB01 JumpIfBetweenValue(mem=$7F1F1F, low=$0000, high=$00F9, target=$B3DB12)
55 $B3DB0B StartTextBox(text_id=$043D, mode=$00)
56 $B3DB0F Jump(target=$B3DAF6)
57 $B3DB12 StartTextBox(text_id=$0174, mode=$00)
58 $B3DB16 Jump(target=$B3DAF6)
59 $B3DB19 JumpIfEqualsByte(mem=$7F1F1B, value=$17, target=$B3DB2E)
60 $B3DB20 JumpIfEqualsByte(mem=$7F1F1B, value=$1E, target=$B3DB35)
61 $B3DB27 StartTextBox(text_id=$039A, mode=$00)
62 $B3DB2B Jump(target=$B3DAF6)
63 $B3DB2E StartTextBox(text_id=$02AF, mode=$00)
64 $B3DB32 Jump(target=$B3DAF6)
65 $B3DB35 StartTextBox(text_id=$03F8, mode=$00)
66 $B3DB39 SetCCObjectParam8(a=$1F, b=$1F, c=$7F, d=$05, e=$00)
67 $B3DB3F Jump(target=$B3DAF6)
68 $B3DB42 JumpIfEqualsByte(mem=$80091E, value=$56, target=$B3DB58)
69 $B3DB49 JumpIfBetweenByte(mem=$80091E, low=$10, high=$17, target=$B3DB65)
70 $B3DB51 StartTextBox(text_id=$0200, mode=$00)
71 $B3DB55 Jump(target=$B3DAF6)
72 $B3DB58 StartTextBox(text_id=$03B5, mode=$00)
73 $B3DB5C SetCCObjectParam8(a=$1F, b=$1F, c=$7F, d=$03, e=$00)
74 $B3DB62 Jump(target=$B3DAF6)
75 $B3DB65 StartTextBox(text_id=$03B2, mode=$00)
76 $B3DB69 SetCCObjectParam8(a=$1F, b=$1F, c=$7F, d=$05, e=$00)
77 $B3DB6F Jump(target=$B3DAF6)
```

## Entry 01 -> `$B3DB72`

- Commands decoded: `24`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3DB72 ChangeGameState2()
01 $B3DB73 StartNestedScriptSlot(slot=$01, target=$B3DB7D)
02 $B3DB77 WaitOrSetCCCounter(value=$0001)
03 $B3DB7A Jump(target=$B3DB77)
04 $B3DB7D SpawnOrMoveCCObject(x=$0068, y=$00E8, visual=$8354, mode=$00)
05 $B3DB85 SetCCObjectAndJump(target=$B3DB97)
06 $B3DB88 SetCCObjectParam4(a=$9E, ptr=$90DB, d=$DB)
07 $B3DB8D Jump(target=$B3DB85)
08 $B3DB90 StartTextBox(text_id=$0200, mode=$00)
09 $B3DB94 Jump(target=$B3DB85)
10 $B3DB97 StartTextBox(text_id=$01E0, mode=$00)
11 $B3DB9B Jump(target=$B3DB85)
12 $B3DB9E JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3DBBA)
13 $B3DBA5 JumpIfEqualsByte(mem=$7F1F1B, value=$17, target=$B3DBC1)
14 $B3DBAC JumpIfEqualsByte(mem=$7F1F1B, value=$1E, target=$B3DBC8)
15 $B3DBB3 StartTextBox(text_id=$0397, mode=$00)
16 $B3DBB7 Jump(target=$B3DB85)
17 $B3DBBA StartTextBox(text_id=$01CF, mode=$00)
18 $B3DBBE Jump(target=$B3DB85)
19 $B3DBC1 StartTextBox(text_id=$0405, mode=$00)
20 $B3DBC5 Jump(target=$B3DB85)
21 $B3DBC8 StartTextBox(text_id=$03F0, mode=$00)
22 $B3DBCC SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$05, e=$00)
23 $B3DBD2 Jump(target=$B3DB85)
```

## Entry 02 -> `$B3DBD5`

- Commands decoded: `57`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3DBD5 ChangeGameState2()
01 $B3DBD6 StartNestedScriptSlot(slot=$01, target=$B3DBF8)
02 $B3DBDA Jump(target=$B3DBE3)
03 $B3DBDD WaitOrSetCCCounter(value=$0001)
04 $B3DBE0 Jump(target=$B3DBDD)
05 $B3DBE3 JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B3DBF5)
06 $B3DBEA JumpIfFlagSet(mem=$7F1F6C, bit=$00, target=$B3DBF5)
07 $B3DBF1 StartNestedScriptSlot(slot=$02, target=$B3DC4A)
08 $B3DBF5 Jump(target=$B3DBDD)
09 $B3DBF8 SpawnOrMoveCCObject(x=$0028, y=$0168, visual=$83FC, mode=$02)
10 $B3DC00 SetCCObjectAndJump(target=$B3DC12)
11 $B3DC03 SetCCObjectParam4(a=$19, ptr=$0BDC, d=$DC)
12 $B3DC08 Jump(target=$B3DC00)
13 $B3DC0B StartTextBox(text_id=$0200, mode=$00)
14 $B3DC0F Jump(target=$B3DC00)
15 $B3DC12 StartTextBox(text_id=$01C6, mode=$00)
16 $B3DC16 Jump(target=$B3DC00)
17 $B3DC19 JumpIfEqualsByte(mem=$7F1F1B, value=$17, target=$B3DC2E)
18 $B3DC20 JumpIfEqualsByte(mem=$7F1F1B, value=$1E, target=$B3DC39)
19 $B3DC27 StartTextBox(text_id=$0394, mode=$00)
20 $B3DC2B Jump(target=$B3DC00)
21 $B3DC2E StartTextBox(text_id=$02AE, mode=$00)
22 $B3DC32 SetCCObjectParam(param=$02D0, value=$01)
23 $B3DC36 Jump(target=$B3DC00)
24 $B3DC39 StartTextBox(text_id=$03EF, mode=$00)
25 $B3DC3D SetCCObjectParam(param=$02D0, value=$01)
26 $B3DC41 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$05, e=$00)
27 $B3DC47 Jump(target=$B3DC00)
28 $B3DC4A SpawnOrMoveCCObject(x=$0068, y=$0098, visual=$81C8, mode=$00)
29 $B3DC52 Jump(target=$B3DC55)
30 $B3DC55 SetCCObjectAndJump(target=$B3DC60)
31 $B3DC58 SetCCObjectParam4(a=$A8, ptr=$78DC, d=$DC)
32 $B3DC5D Jump(target=$B3DC55)
33 $B3DC60 JumpIfBetweenValue(mem=$7F1F23, low=$0000, high=$00F9, target=$B3DC71)
34 $B3DC6A StartTextBox(text_id=$043F, mode=$00)
35 $B3DC6E Jump(target=$B3DC55)
36 $B3DC71 StartTextBox(text_id=$0178, mode=$00)
37 $B3DC75 Jump(target=$B3DC55)
38 $B3DC78 JumpIfEqualsByte(mem=$80091E, value=$06, target=$B3DC9B)
39 $B3DC7F JumpIfBetweenByte(mem=$80091E, low=$10, high=$17, target=$B3DC8E)
40 $B3DC87 StartTextBox(text_id=$0200, mode=$00)
41 $B3DC8B Jump(target=$B3DC55)
42 $B3DC8E StartTextBox(text_id=$03B2, mode=$00)
43 $B3DC92 SetCCObjectParam8(a=$23, b=$1F, c=$7F, d=$02, e=$00)
44 $B3DC98 Jump(target=$B3DC55)
45 $B3DC9B StartTextBox(text_id=$0212, mode=$00)
46 $B3DC9F SetCCObjectParam8(a=$23, b=$1F, c=$7F, d=$08, e=$00)
47 $B3DCA5 Jump(target=$B3DC55)
48 $B3DCA8 JumpIfEqualsByte(mem=$7F1F1B, value=$17, target=$B3DCBD)
49 $B3DCAF JumpIfEqualsByte(mem=$7F1F1B, value=$1E, target=$B3DCC4)
50 $B3DCB6 StartTextBox(text_id=$039C, mode=$00)
51 $B3DCBA Jump(target=$B3DC55)
52 $B3DCBD StartTextBox(text_id=$02B1, mode=$00)
53 $B3DCC1 Jump(target=$B3DC55)
54 $B3DCC4 StartTextBox(text_id=$03FA, mode=$00)
55 $B3DCC8 SetCCObjectParam8(a=$23, b=$1F, c=$7F, d=$05, e=$00)
56 $B3DCCE Jump(target=$B3DC55)
```

## Entry 03 -> `$B3DCD1`

- Commands decoded: `56`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3DCD1 ChangeGameState2()
01 $B3DCD2 StartNestedScriptSlot(slot=$01, target=$B3DCED)
02 $B3DCD6 Jump(target=$B3DCDF)
03 $B3DCD9 WaitOrSetCCCounter(value=$0001)
04 $B3DCDC Jump(target=$B3DCD9)
05 $B3DCDF JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B3DCEA)
06 $B3DCE6 StartNestedScriptSlot(slot=$02, target=$B3DD3F)
07 $B3DCEA Jump(target=$B3DCD9)
08 $B3DCED SpawnOrMoveCCObject(x=$0028, y=$0168, visual=$8318, mode=$02)
09 $B3DCF5 SetCCObjectAndJump(target=$B3DD07)
10 $B3DCF8 SetCCObjectParam4(a=$0E, ptr=$00DD, d=$DD)
11 $B3DCFD Jump(target=$B3DCF5)
12 $B3DD00 StartTextBox(text_id=$0200, mode=$00)
13 $B3DD04 Jump(target=$B3DCF5)
14 $B3DD07 StartTextBox(text_id=$01CA, mode=$00)
15 $B3DD0B Jump(target=$B3DCF5)
16 $B3DD0E JumpIfFlagSet(mem=$7F1F6A, bit=$0E, target=$B3DD27)
17 $B3DD15 JumpIfEqualsByte(mem=$7F1F1B, value=$1E, target=$B3DD2E)
18 $B3DD1C StartTextBox(text_id=$0079, mode=$00)
19 $B3DD20 SetCCObjectParam(param=$029A, value=$01)
20 $B3DD24 Jump(target=$B3DCF5)
21 $B3DD27 StartTextBox(text_id=$01DC, mode=$00)
22 $B3DD2B Jump(target=$B3DCF5)
23 $B3DD2E StartTextBox(text_id=$03EE, mode=$00)
24 $B3DD32 SetCCObjectParam(param=$029A, value=$01)
25 $B3DD36 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$05, e=$00)
26 $B3DD3C Jump(target=$B3DCF5)
27 $B3DD3F SpawnOrMoveCCObject(x=$0098, y=$0188, visual=$8198, mode=$00)
28 $B3DD47 Jump(target=$B3DD4A)
29 $B3DD4A SetCCObjectAndJump(target=$B3DD55)
30 $B3DD4D SetCCObjectParam4(a=$90, ptr=$6DDD, d=$DD)
31 $B3DD52 Jump(target=$B3DD4A)
32 $B3DD55 JumpIfBetweenValue(mem=$7F1F21, low=$0000, high=$00F9, target=$B3DD66)
33 $B3DD5F StartTextBox(text_id=$043E, mode=$00)
34 $B3DD63 Jump(target=$B3DD4A)
35 $B3DD66 StartTextBox(text_id=$0176, mode=$00)
36 $B3DD6A Jump(target=$B3DD4A)
37 $B3DD6D JumpIfEqualsByte(mem=$80091E, value=$06, target=$B3DD83)
38 $B3DD74 JumpIfBetweenByte(mem=$80091E, low=$10, high=$17, target=$B3DD83)
39 $B3DD7C StartTextBox(text_id=$0200, mode=$00)
40 $B3DD80 Jump(target=$B3DD4A)
41 $B3DD83 StartTextBox(text_id=$03B2, mode=$00)
42 $B3DD87 SetCCObjectParam8(a=$21, b=$1F, c=$7F, d=$06, e=$00)
43 $B3DD8D Jump(target=$B3DD4A)
44 $B3DD90 JumpIfFlagSet(mem=$7F1F6A, bit=$0E, target=$B3DDAC)
45 $B3DD97 JumpIfEqualsByte(mem=$7F1F1B, value=$17, target=$B3DDB3)
46 $B3DD9E JumpIfEqualsByte(mem=$7F1F1B, value=$1E, target=$B3DDBA)
47 $B3DDA5 StartTextBox(text_id=$039B, mode=$00)
48 $B3DDA9 Jump(target=$B3DD4A)
49 $B3DDAC StartTextBox(text_id=$01DE, mode=$00)
50 $B3DDB0 Jump(target=$B3DD4A)
51 $B3DDB3 StartTextBox(text_id=$02B0, mode=$00)
52 $B3DDB7 Jump(target=$B3DD4A)
53 $B3DDBA StartTextBox(text_id=$03F9, mode=$00)
54 $B3DDBE SetCCObjectParam8(a=$21, b=$1F, c=$7F, d=$05, e=$00)
55 $B3DDC4 Jump(target=$B3DD4A)
```

## Entry 04 -> `$B3DDC7`

- Commands decoded: `74`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3DDC7 ChangeGameState2()
01 $B3DDC8 StartNestedScriptSlot(slot=$01, target=$B3DE07)
02 $B3DDCC JumpIfFlagSet(mem=$7F1F6C, bit=$02, target=$B3DDEB)
03 $B3DDD3 JumpIfFlagSet(mem=$7F1F6C, bit=$03, target=$B3DDEB)
04 $B3DDDA StartNestedScriptSlot(slot=$03, target=$B3DDF9)
05 $B3DDDE StartNestedScriptSlot(slot=$04, target=$B3DE55)
06 $B3DDE2 Jump(target=$B3DDEB)
07 $B3DDE5 WaitOrSetCCCounter(value=$0001)
08 $B3DDE8 Jump(target=$B3DDE5)
09 $B3DDEB JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B3DDF6)
10 $B3DDF2 StartNestedScriptSlot(slot=$02, target=$B3DE91)
11 $B3DDF6 Jump(target=$B3DDE5)
12 $B3DDF9 SpawnOrMoveCCObject(x=$0087, y=$0097, visual=$8558, mode=$00)
13 $B3DE01 WaitOrSetCCCounter(value=$0001)
14 $B3DE04 Jump(target=$B3DE01)
15 $B3DE07 SpawnOrMoveCCObject(x=$0028, y=$0198, visual=$8330, mode=$02)
16 $B3DE0F SetCCObjectAndJump(target=$B3DE21)
17 $B3DE12 SetCCObjectParam4(a=$28, ptr=$1ADE, d=$DE)
18 $B3DE17 Jump(target=$B3DE0F)
19 $B3DE1A StartTextBox(text_id=$0200, mode=$00)
20 $B3DE1E Jump(target=$B3DE0F)
21 $B3DE21 StartTextBox(text_id=$01C7, mode=$00)
22 $B3DE25 Jump(target=$B3DE0F)
23 $B3DE28 JumpIfFlagSet(mem=$7F1F6C, bit=$02, target=$B3DE3D)
24 $B3DE2F JumpIfEqualsByte(mem=$7F1F1B, value=$1E, target=$B3DE44)
25 $B3DE36 StartTextBox(text_id=$0395, mode=$00)
26 $B3DE3A Jump(target=$B3DE0F)
27 $B3DE3D StartTextBox(text_id=$01ED, mode=$00)
28 $B3DE41 Jump(target=$B3DE0F)
29 $B3DE44 StartTextBox(text_id=$03EC, mode=$00)
30 $B3DE48 SetCCObjectParam(param=$02A1, value=$01)
31 $B3DE4C SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$05, e=$00)
32 $B3DE52 Jump(target=$B3DE0F)
33 $B3DE55 SpawnOrMoveCCObject(x=$0098, y=$0158, visual=$8348, mode=$00)
34 $B3DE5D SetCCObjectAndJump(target=$B3DE68)
35 $B3DE60 SetCCObjectParam4(a=$76, ptr=$6FDE, d=$DE)
36 $B3DE65 Jump(target=$B3DE5D)
37 $B3DE68 StartTextBox(text_id=$01C8, mode=$00)
38 $B3DE6C Jump(target=$B3DE5D)
39 $B3DE6F StartTextBox(text_id=$03BC, mode=$00)
40 $B3DE73 Jump(target=$B3DE5D)
41 $B3DE76 JumpIfEqualsByte(mem=$7F1F1B, value=$1E, target=$B3DE84)
42 $B3DE7D StartTextBox(text_id=$0396, mode=$00)
43 $B3DE81 Jump(target=$B3DE5D)
44 $B3DE84 StartTextBox(text_id=$03FD, mode=$00)
45 $B3DE88 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$05, e=$00)
46 $B3DE8E Jump(target=$B3DE5D)
47 $B3DE91 SpawnOrMoveCCObject(x=$00B8, y=$00A8, visual=$81E0, mode=$00)
48 $B3DE99 SetCCObjectAndJump(target=$B3DEA4)
49 $B3DE9C SetCCObjectParam4(a=$D8, ptr=$BCDE, d=$DE)
50 $B3DEA1 Jump(target=$B3DE99)
51 $B3DEA4 JumpIfBetweenValue(mem=$7F1F25, low=$0000, high=$00F9, target=$B3DEB5)
52 $B3DEAE StartTextBox(text_id=$0440, mode=$00)
53 $B3DEB2 Jump(target=$B3DE99)
54 $B3DEB5 StartTextBox(text_id=$017A, mode=$00)
55 $B3DEB9 Jump(target=$B3DE99)
56 $B3DEBC JumpIfBetweenByte(mem=$80091E, low=$14, high=$17, target=$B3DECB)
57 $B3DEC4 StartTextBox(text_id=$0200, mode=$00)
58 $B3DEC8 Jump(target=$B3DE99)
59 $B3DECB StartTextBox(text_id=$03B3, mode=$00)
60 $B3DECF SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$03, e=$00)
61 $B3DED5 Jump(target=$B3DE99)
62 $B3DED8 JumpIfFlagSet(mem=$7F1F6C, bit=$02, target=$B3DF08)
63 $B3DEDF JumpIfEqualsByte(mem=$7F1F1B, value=$17, target=$B3DEF4)
64 $B3DEE6 JumpIfEqualsByte(mem=$7F1F1B, value=$1E, target=$B3DEFB)
65 $B3DEED StartTextBox(text_id=$039D, mode=$00)
66 $B3DEF1 Jump(target=$B3DE99)
67 $B3DEF4 StartTextBox(text_id=$02B2, mode=$00)
68 $B3DEF8 Jump(target=$B3DE99)
69 $B3DEFB StartTextBox(text_id=$03FB, mode=$00)
70 $B3DEFF SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$05, e=$00)
71 $B3DF05 Jump(target=$B3DE99)
72 $B3DF08 StartTextBox(text_id=$01EE, mode=$00)
73 $B3DF0C Jump(target=$B3DE99)
```

## Entry 05 -> `$B3DF0F`

- Commands decoded: `46`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3DF0F ChangeGameState2()
01 $B3DF10 StartNestedScriptSlot(slot=$01, target=$B3DF1E)
02 $B3DF14 StartNestedScriptSlot(slot=$02, target=$B3DF92)
03 $B3DF18 WaitOrSetCCCounter(value=$0001)
04 $B3DF1B Jump(target=$B3DF18)
05 $B3DF1E SpawnOrMoveCCObject(x=$0088, y=$0050, visual=$82E8, mode=$00)
06 $B3DF26 SetCCObjectAndJump(target=$B3DF38)
07 $B3DF29 SetCCObjectParam4(a=$43, ptr=$31DF, d=$DF)
08 $B3DF2E Jump(target=$B3DF26)
09 $B3DF31 StartTextBox(text_id=$0200, mode=$00)
10 $B3DF35 Jump(target=$B3DF26)
11 $B3DF38 StartTextBox(text_id=$01CA, mode=$00)
12 $B3DF3C SetCCObjectParam(param=$0288, value=$00)
13 $B3DF40 Jump(target=$B3DF26)
14 $B3DF43 JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3DF66)
15 $B3DF4A JumpIfFlagSet(mem=$7F1F6A, bit=$0E, target=$B3DF71)
16 $B3DF51 JumpIfFlagSet(mem=$7F1F6C, bit=$00, target=$B3DF7C)
17 $B3DF58 JumpIfFlagSet(mem=$7F1F6C, bit=$02, target=$B3DF87)
18 $B3DF5F StartTextBox(text_id=$0398, mode=$00)
19 $B3DF63 Jump(target=$B3DF26)
20 $B3DF66 StartTextBox(text_id=$01D1, mode=$00)
21 $B3DF6A SetCCObjectParam(param=$0288, value=$00)
22 $B3DF6E Jump(target=$B3DF26)
23 $B3DF71 StartTextBox(text_id=$01DD, mode=$00)
24 $B3DF75 SetCCObjectParam(param=$0288, value=$00)
25 $B3DF79 Jump(target=$B3DF26)
26 $B3DF7C StartTextBox(text_id=$01E6, mode=$00)
27 $B3DF80 SetCCObjectParam(param=$0288, value=$00)
28 $B3DF84 Jump(target=$B3DF26)
29 $B3DF87 StartTextBox(text_id=$01EF, mode=$00)
30 $B3DF8B SetCCObjectParam(param=$0288, value=$00)
31 $B3DF8F Jump(target=$B3DF26)
32 $B3DF92 SpawnOrMoveCCObject(x=$0038, y=$0098, visual=$8384, mode=$00)
33 $B3DF9A SetCCObjectAndJump(target=$B3DFA5)
34 $B3DF9D SetCCObjectParam4(a=$B3, ptr=$ACDF, d=$DF)
35 $B3DFA2 Jump(target=$B3DF9A)
36 $B3DFA5 StartTextBox(text_id=$01CB, mode=$00)
37 $B3DFA9 Jump(target=$B3DF9A)
38 $B3DFAC StartTextBox(text_id=$0200, mode=$00)
39 $B3DFB0 Jump(target=$B3DF9A)
40 $B3DFB3 JumpIfEqualsByte(mem=$7F1F1B, value=$1E, target=$B3DFC1)
41 $B3DFBA StartTextBox(text_id=$0399, mode=$00)
42 $B3DFBE Jump(target=$B3DF9A)
43 $B3DFC1 StartTextBox(text_id=$0324, mode=$00)
44 $B3DFC5 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$05, e=$00)
45 $B3DFCB Jump(target=$B3DF9A)
```

## Entry 06 -> `$B3DFCE`

- Commands decoded: `26`
- Stop reason: `next_entry_boundary`
- Pointer duplicate count: `1`

```text
00 $B3DFCE ChangeGameState2()
01 $B3DFCF StartNestedScriptSlot(slot=$01, target=$B3DFD9)
02 $B3DFD3 WaitOrSetCCCounter(value=$0001)
03 $B3DFD6 Jump(target=$B3DFD3)
04 $B3DFD9 SpawnOrMoveCCObject(x=$00E8, y=$0098, visual=$836C, mode=$03)
05 $B3DFE1 SetCCObjectAndJump(target=$B3DFF7)
06 $B3DFE4 SetCCObjectParam4(a=$02, ptr=$ECE0, d=$DF)
07 $B3DFE9 Jump(target=$B3DFE1)
08 $B3DFEC StartTextBox(text_id=$0200, mode=$00)
09 $B3DFF0 SetCCObjectParam(param=$02AF, value=$00)
10 $B3DFF4 Jump(target=$B3DFE1)
11 $B3DFF7 StartTextBox(text_id=$01C9, mode=$00)
12 $B3DFFB SetCCObjectParam(param=$02AF, value=$00)
13 $B3DFFF Jump(target=$B3DFE1)
14 $B3E002 JumpIfFlagSet(mem=$7F1F6C, bit=$02, target=$B3E01B)
15 $B3E009 JumpIfEqualsByte(mem=$7F1F1B, value=$1E, target=$B3E026)
16 $B3E010 StartTextBox(text_id=$005E, mode=$00)
17 $B3E014 SetCCObjectParam(param=$02AF, value=$00)
18 $B3E018 Jump(target=$B3DFE1)
19 $B3E01B StartTextBox(text_id=$01F0, mode=$00)
20 $B3E01F SetCCObjectParam(param=$02AF, value=$00)
21 $B3E023 Jump(target=$B3DFE1)
22 $B3E026 StartTextBox(text_id=$0146, mode=$00)
23 $B3E02A SetCCObjectParam(param=$02AF, value=$00)
24 $B3E02E SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$05, e=$00)
25 $B3E034 Jump(target=$B3DFE1)
```

## Entry 07 -> `$B3E037`

- Commands decoded: `20`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B3E037 ChangeGameState2()
01 $B3E038 StartNestedScriptSlot(slot=$01, target=$B3E083)
02 $B3E03C StartNestedScriptSlot(slot=$02, target=$B3E046)
03 $B3E040 WaitOrSetCCCounter(value=$0001)
04 $B3E043 Jump(target=$B3E040)
05 $B3E046 SpawnOrMoveCCObject(x=$0058, y=$00B8, visual=$8234, mode=$00)
06 $B3E04E SetCCObjectAndJump(target=$B3E060)
07 $B3E051 SetCCObjectParam4(a=$67, ptr=$59E0, d=$E0)
08 $B3E056 Jump(target=$B3E04E)
09 $B3E059 StartTextBox(text_id=$03BC, mode=$00)
10 $B3E05D Jump(target=$B3E04E)
11 $B3E060 StartTextBox(text_id=$01C8, mode=$00)
12 $B3E064 Jump(target=$B3E04E)
13 $B3E067 JumpIfEqualsByte(mem=$7F1F1B, value=$1E, target=$B3E075)
14 $B3E06E StartTextBox(text_id=$0150, mode=$00)
15 $B3E072 Jump(target=$B3E04E)
16 $B3E075 StartTextBox(text_id=$03F6, mode=$00)
17 $B3E079 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$05, e=$00)
18 $B3E07F Jump(target=$B3E04E)
19 $B3E082 StopOrDisableCCSlot()
```

## Entry 08 -> `$B3E0BF`

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$DF`
- Pointer duplicate count: `8`

```text
00 $B3E0BF UnknownOpcode_$DF()
```

## Entry 09 -> `$B3E0BF` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$DF`
- Pointer duplicate count: `8`

```text
00 $B3E0BF UnknownOpcode_$DF()
```

## Entry 10 -> `$B3E0BF` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$DF`
- Pointer duplicate count: `8`

```text
00 $B3E0BF UnknownOpcode_$DF()
```

## Entry 11 -> `$B3E0BF` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$DF`
- Pointer duplicate count: `8`

```text
00 $B3E0BF UnknownOpcode_$DF()
```

## Entry 12 -> `$B3E0BF` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$DF`
- Pointer duplicate count: `8`

```text
00 $B3E0BF UnknownOpcode_$DF()
```

## Entry 13 -> `$B3E0BF` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$DF`
- Pointer duplicate count: `8`

```text
00 $B3E0BF UnknownOpcode_$DF()
```

## Entry 14 -> `$B3E0BF` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$DF`
- Pointer duplicate count: `8`

```text
00 $B3E0BF UnknownOpcode_$DF()
```

## Entry 15 -> `$B3E0BF` duplicate_target

- Commands decoded: `1`
- Stop reason: `unknown_opcode_$DF`
- Pointer duplicate count: `8`

```text
00 $B3E0BF UnknownOpcode_$DF()
```

