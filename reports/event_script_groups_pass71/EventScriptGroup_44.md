# EventScriptGroup_44 symbolic export

- Group id: `$44`
- Group table address: `$B597D1`
- Pointer entries: `16`
- Unique targets: `6`

This file is generated for decompilation handoff. It keeps dialog as text ids only.

## Entry 00 -> `$B597F1`

- Commands decoded: `101`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B597F1 JumpIfFlagSet(mem=$800196, bit=$01, target=$B599EA)
01 $B597F8 JumpIfBetweenByte(mem=$7F1F1C, low=$06, high=$0A, target=$B599EA)
02 $B59800 JumpIfBetweenByte(mem=$7F1F1C, low=$0F, high=$12, target=$B599EA)
03 $B59808 JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B599EA)
04 $B5980F JumpIfBetweenValue(mem=$7F1F37, low=$003C, high=$0059, target=$B5982E)
05 $B59819 JumpIfBetweenValue(mem=$7F1F39, low=$003C, high=$0059, target=$B5982E)
06 $B59823 SpawnOrMoveCCObject(x=$0168, y=$0168, visual=$8AEC, mode=$00)
07 $B5982B Jump(target=$B59836)
08 $B5982E SpawnOrMoveCCObject(x=$0168, y=$0168, visual=$8480, mode=$00)
09 $B59836 SetCCObjectParam4(a=$0B, ptr=$3E99, d=$98)
10 $B5983B Jump(target=$B59836)
11 $B5983E JumpIfEqualsByte(mem=$80091E, value=$02, target=$B59880)
12 $B59845 JumpIfBetweenByte(mem=$80091E, low=$01, high=$05, target=$B5988D)
13 $B5984D JumpIfEqualsByte(mem=$80091E, value=$07, target=$B5988D)
14 $B59854 JumpIfBetweenByte(mem=$80091E, low=$10, high=$17, target=$B5988D)
15 $B5985C JumpIfEqualsByte(mem=$80091E, value=$19, target=$B598A1)
16 $B59863 JumpIfEqualsByte(mem=$80091E, value=$49, target=$B598A1)
17 $B5986A JumpIfEqualsByte(mem=$80091E, value=$06, target=$B598C2)
18 $B59871 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B598B5)
19 $B59879 StartTextBox(text_id=$0200, mode=$00)
20 $B5987D Jump(target=$B59836)
21 $B59880 StartTextBox(text_id=$03B0, mode=$00)
22 $B59884 SetCCObjectParam8(a=$1F, b=$1F, c=$7F, d=$FA, e=$FF)
23 $B5988A Jump(target=$B59836)
24 $B5988D JumpIfFlagSet(mem=$7F1F6C, bit=$07, target=$B598E4)
25 $B59894 SetCCObjectParam8(a=$1F, b=$1F, c=$7F, d=$04, e=$00)
26 $B5989A StartTextBox(text_id=$03B2, mode=$00)
27 $B5989E Jump(target=$B59836)
28 $B598A1 JumpIfFlagSet(mem=$7F1F6C, bit=$07, target=$B598E4)
29 $B598A8 StartTextBox(text_id=$03B5, mode=$00)
30 $B598AC SetCCObjectParam8(a=$1F, b=$1F, c=$7F, d=$08, e=$00)
31 $B598B2 Jump(target=$B59836)
32 $B598B5 StartTextBox(text_id=$01D9, mode=$00)
33 $B598B9 SetCCObjectParam8(a=$1F, b=$1F, c=$7F, d=$FC, e=$FF)
34 $B598BF Jump(target=$B59836)
35 $B598C2 JumpIfFlagSet(mem=$7F1F6C, bit=$07, target=$B598E4)
36 $B598C9 JumpIfFlagSet(mem=$7F1F6C, bit=$08, target=$B598F1)
37 $B598D0 JumpIfFlagSet(mem=$7F1F6C, bit=$09, target=$B598FE)
38 $B598D7 SetCCObjectParam8(a=$1F, b=$1F, c=$7F, d=$08, e=$00)
39 $B598DD StartTextBox(text_id=$0212, mode=$00)
40 $B598E1 Jump(target=$B59836)
41 $B598E4 StartTextBox(text_id=$01BD, mode=$00)
42 $B598E8 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$1E, e=$00)
43 $B598EE Jump(target=$B59836)
44 $B598F1 StartTextBox(text_id=$041D, mode=$00)
45 $B598F5 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$1E, e=$00)
46 $B598FB Jump(target=$B59836)
47 $B598FE StartTextBox(text_id=$041E, mode=$00)
48 $B59902 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$1E, e=$00)
49 $B59908 Jump(target=$B59836)
50 $B5990B JumpIfFlagSet(mem=$7F1F64, bit=$04, target=$B59961)
51 $B59912 JumpIfEqualsByte(mem=$80098C, value=$03, target=$B59968)
52 $B59919 JumpIfFlagSet(mem=$800196, bit=$04, target=$B5996F)
53 $B59920 JumpIfFlagSet(mem=$7F1F64, bit=$05, target=$B59961)
54 $B59927 JumpIfBetweenValue(mem=$7F1F1F, low=$00C8, high=$00DC, target=$B59976)
55 $B59931 JumpIfBetweenValue(mem=$7F1F1F, low=$00DD, high=$00FA, target=$B5997D)
56 $B5993B JumpIfEqualsByte(mem=$7F1F1A, value=$00, target=$B5998B)
57 $B59942 JumpIfEqualsByte(mem=$7F1F1A, value=$06, target=$B59984)
58 $B59949 JumpIfEqualsByte(mem=$7F1F19, value=$00, target=$B59992)
59 $B59950 JumpIfEqualsByte(mem=$7F1F19, value=$01, target=$B599B4)
60 $B59957 JumpIfEqualsByte(mem=$7F1F19, value=$02, target=$B599C8)
61 $B5995E Jump(target=$B59836)
62 $B59961 StartTextBox(text_id=$0166, mode=$00)
63 $B59965 Jump(target=$B59836)
64 $B59968 StartTextBox(text_id=$015F, mode=$00)
65 $B5996C Jump(target=$B59836)
66 $B5996F StartTextBox(text_id=$0160, mode=$00)
67 $B59973 Jump(target=$B59836)
68 $B59976 StartTextBox(text_id=$01F3, mode=$00)
69 $B5997A Jump(target=$B59836)
70 $B5997D StartTextBox(text_id=$0049, mode=$00)
71 $B59981 Jump(target=$B59836)
72 $B59984 StartTextBox(text_id=$047D, mode=$00)
73 $B59988 Jump(target=$B59836)
74 $B5998B StartTextBox(text_id=$0195, mode=$00)
75 $B5998F Jump(target=$B59836)
76 $B59992 JumpIfEqualsByte(mem=$7F1F1B, value=$16, target=$B599AD)
77 $B59999 GetRNG(value=$02)
78 $B5999B JumpIfEqualsRNG(value=$00, target=$B599A6)
79 $B5999F StartTextBox(text_id=$041F, mode=$00)
... truncated after 80 commands; use CSV/index for full count.
```

## Entry 01 -> `$B599EB`

- Commands decoded: `98`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B599EB JumpIfFlagSet(mem=$800196, bit=$01, target=$B59BD4)
01 $B599F2 JumpIfBetweenByte(mem=$7F1F1C, low=$06, high=$0A, target=$B59BD4)
02 $B599FA JumpIfBetweenByte(mem=$7F1F1C, low=$0F, high=$12, target=$B59BD4)
03 $B59A02 JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B59BD4)
04 $B59A09 StartNestedScriptSlot(slot=$01, target=$B59BD5)
05 $B59A0D JumpIfBetweenValue(mem=$7F1F37, low=$003C, high=$0059, target=$B59A2C)
06 $B59A17 JumpIfBetweenValue(mem=$7F1F39, low=$003C, high=$0059, target=$B59A2C)
07 $B59A21 SpawnOrMoveCCObject(x=$0048, y=$0048, visual=$8AF8, mode=$00)
08 $B59A29 Jump(target=$B59A34)
09 $B59A2C SpawnOrMoveCCObject(x=$0048, y=$0048, visual=$8480, mode=$00)
10 $B59A34 SetCCObjectParam4(a=$F5, ptr=$3C9A, d=$9A)
11 $B59A39 Jump(target=$B59A34)
12 $B59A3C JumpIfEqualsByte(mem=$80091E, value=$02, target=$B59A77)
13 $B59A43 JumpIfBetweenByte(mem=$80091E, low=$03, high=$07, target=$B59A98)
14 $B59A4B JumpIfBetweenByte(mem=$80091E, low=$10, high=$17, target=$B59A98)
15 $B59A53 JumpIfEqualsByte(mem=$80091E, value=$06, target=$B59AAC)
16 $B59A5A JumpIfEqualsByte(mem=$80091E, value=$19, target=$B59A84)
17 $B59A61 JumpIfEqualsByte(mem=$80091E, value=$49, target=$B59A84)
18 $B59A68 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B59A77)
19 $B59A70 StartTextBox(text_id=$0200, mode=$00)
20 $B59A74 Jump(target=$B59A34)
21 $B59A77 StartTextBox(text_id=$03B4, mode=$00)
22 $B59A7B SetCCObjectParam8(a=$21, b=$1F, c=$7F, d=$FA, e=$FF)
23 $B59A81 Jump(target=$B59A34)
24 $B59A84 JumpIfFlagSet(mem=$7F1F6C, bit=$07, target=$B59ACE)
25 $B59A8B SetCCObjectParam8(a=$21, b=$1F, c=$7F, d=$08, e=$00)
26 $B59A91 StartTextBox(text_id=$0212, mode=$00)
27 $B59A95 Jump(target=$B59A34)
28 $B59A98 JumpIfFlagSet(mem=$7F1F6C, bit=$07, target=$B59ACE)
29 $B59A9F StartTextBox(text_id=$03B2, mode=$00)
30 $B59AA3 SetCCObjectParam8(a=$21, b=$1F, c=$7F, d=$05, e=$00)
31 $B59AA9 Jump(target=$B59A34)
32 $B59AAC JumpIfFlagSet(mem=$7F1F6C, bit=$07, target=$B59ACE)
33 $B59AB3 JumpIfFlagSet(mem=$7F1F6C, bit=$08, target=$B59ADB)
34 $B59ABA JumpIfFlagSet(mem=$7F1F6C, bit=$09, target=$B59AE8)
35 $B59AC1 SetCCObjectParam8(a=$21, b=$1F, c=$7F, d=$08, e=$00)
36 $B59AC7 StartTextBox(text_id=$0212, mode=$00)
37 $B59ACB Jump(target=$B59A34)
38 $B59ACE StartTextBox(text_id=$01BD, mode=$00)
39 $B59AD2 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$1E, e=$00)
40 $B59AD8 Jump(target=$B59A34)
41 $B59ADB StartTextBox(text_id=$041D, mode=$00)
42 $B59ADF SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$1E, e=$00)
43 $B59AE5 Jump(target=$B59A34)
44 $B59AE8 StartTextBox(text_id=$041E, mode=$00)
45 $B59AEC SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$1E, e=$00)
46 $B59AF2 Jump(target=$B59A34)
47 $B59AF5 JumpIfFlagSet(mem=$7F1F64, bit=$04, target=$B59B4B)
48 $B59AFC JumpIfEqualsByte(mem=$80098C, value=$03, target=$B59B52)
49 $B59B03 JumpIfFlagSet(mem=$800196, bit=$04, target=$B59B59)
50 $B59B0A JumpIfFlagSet(mem=$7F1F64, bit=$05, target=$B59B4B)
51 $B59B11 JumpIfBetweenValue(mem=$7F1F21, low=$00C8, high=$00DC, target=$B59B60)
52 $B59B1B JumpIfBetweenValue(mem=$7F1F21, low=$00DD, high=$00FA, target=$B59B67)
53 $B59B25 JumpIfEqualsByte(mem=$7F1F1A, value=$00, target=$B59B75)
54 $B59B2C JumpIfEqualsByte(mem=$7F1F1A, value=$06, target=$B59B6E)
55 $B59B33 JumpIfEqualsByte(mem=$7F1F19, value=$00, target=$B59B7C)
56 $B59B3A JumpIfEqualsByte(mem=$7F1F19, value=$01, target=$B59B9E)
57 $B59B41 JumpIfEqualsByte(mem=$7F1F19, value=$02, target=$B59BB2)
58 $B59B48 Jump(target=$B59A34)
59 $B59B4B StartTextBox(text_id=$0166, mode=$00)
60 $B59B4F Jump(target=$B59A34)
61 $B59B52 StartTextBox(text_id=$015F, mode=$00)
62 $B59B56 Jump(target=$B59A34)
63 $B59B59 StartTextBox(text_id=$0160, mode=$00)
64 $B59B5D Jump(target=$B59A34)
65 $B59B60 StartTextBox(text_id=$01F4, mode=$00)
66 $B59B64 Jump(target=$B59A34)
67 $B59B67 StartTextBox(text_id=$0049, mode=$00)
68 $B59B6B Jump(target=$B59A34)
69 $B59B6E StartTextBox(text_id=$047D, mode=$00)
70 $B59B72 Jump(target=$B59A34)
71 $B59B75 StartTextBox(text_id=$0194, mode=$00)
72 $B59B79 Jump(target=$B59A34)
73 $B59B7C JumpIfEqualsByte(mem=$7F1F1B, value=$16, target=$B59B97)
74 $B59B83 GetRNG(value=$02)
75 $B59B85 JumpIfEqualsRNG(value=$00, target=$B59B90)
76 $B59B89 StartTextBox(text_id=$0185, mode=$00)
77 $B59B8D Jump(target=$B59A34)
78 $B59B90 StartTextBox(text_id=$018F, mode=$00)
79 $B59B94 Jump(target=$B59A34)
... truncated after 80 commands; use CSV/index for full count.
```

## Entry 02 -> `$B59BE3`

- Commands decoded: `99`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B59BE3 JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B59DD2)
01 $B59BEA JumpIfFlagSet(mem=$800196, bit=$01, target=$B59DD2)
02 $B59BF1 JumpIfBetweenByte(mem=$7F1F1C, low=$06, high=$0A, target=$B59DD2)
03 $B59BF9 JumpIfBetweenByte(mem=$7F1F1C, low=$0F, high=$12, target=$B59DD2)
04 $B59C01 JumpIfBetweenValue(mem=$7F1F37, low=$003C, high=$0059, target=$B59C20)
05 $B59C0B JumpIfBetweenValue(mem=$7F1F39, low=$003C, high=$0059, target=$B59C20)
06 $B59C15 SpawnOrMoveCCObject(x=$0168, y=$0168, visual=$8B04, mode=$00)
07 $B59C1D Jump(target=$B59C28)
08 $B59C20 SpawnOrMoveCCObject(x=$0168, y=$0168, visual=$848C, mode=$00)
09 $B59C28 SetCCObjectParam4(a=$F6, ptr=$309C, d=$9C)
10 $B59C2D Jump(target=$B59C28)
11 $B59C30 JumpIfBetweenByte(mem=$80091E, low=$01, high=$04, target=$B59C8C)
12 $B59C38 JumpIfBetweenByte(mem=$80091E, low=$10, high=$17, target=$B59C8C)
13 $B59C40 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B59CA0)
14 $B59C48 JumpIfEqualsByte(mem=$80091E, value=$06, target=$B59CAD)
15 $B59C4F JumpIfEqualsByte(mem=$80091E, value=$05, target=$B59CAD)
16 $B59C56 JumpIfEqualsByte(mem=$80091E, value=$19, target=$B59C6B)
17 $B59C5D JumpIfEqualsByte(mem=$80091E, value=$49, target=$B59C78)
18 $B59C64 StartTextBox(text_id=$0200, mode=$00)
19 $B59C68 Jump(target=$B59C28)
20 $B59C6B StartTextBox(text_id=$03B1, mode=$00)
21 $B59C6F SetCCObjectParam8(a=$23, b=$1F, c=$7F, d=$F8, e=$FF)
22 $B59C75 Jump(target=$B59C28)
23 $B59C78 JumpIfFlagSet(mem=$7F1F6C, bit=$07, target=$B59CCF)
24 $B59C7F StartTextBox(text_id=$0212, mode=$00)
25 $B59C83 SetCCObjectParam8(a=$23, b=$1F, c=$7F, d=$08, e=$00)
26 $B59C89 Jump(target=$B59C28)
27 $B59C8C JumpIfFlagSet(mem=$7F1F6C, bit=$07, target=$B59CCF)
28 $B59C93 StartTextBox(text_id=$03B2, mode=$00)
29 $B59C97 SetCCObjectParam8(a=$23, b=$1F, c=$7F, d=$05, e=$00)
30 $B59C9D Jump(target=$B59C28)
31 $B59CA0 StartTextBox(text_id=$03BA, mode=$00)
32 $B59CA4 SetCCObjectParam8(a=$23, b=$1F, c=$7F, d=$FC, e=$FF)
33 $B59CAA Jump(target=$B59C28)
34 $B59CAD JumpIfFlagSet(mem=$7F1F6C, bit=$07, target=$B59CCF)
35 $B59CB4 JumpIfFlagSet(mem=$7F1F6C, bit=$08, target=$B59CDC)
36 $B59CBB JumpIfFlagSet(mem=$7F1F6C, bit=$09, target=$B59CE9)
37 $B59CC2 StartTextBox(text_id=$0212, mode=$00)
38 $B59CC6 SetCCObjectParam8(a=$23, b=$1F, c=$7F, d=$08, e=$00)
39 $B59CCC Jump(target=$B59C28)
40 $B59CCF StartTextBox(text_id=$01BD, mode=$00)
41 $B59CD3 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$1E, e=$00)
42 $B59CD9 Jump(target=$B59C28)
43 $B59CDC StartTextBox(text_id=$041D, mode=$00)
44 $B59CE0 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$1E, e=$00)
45 $B59CE6 Jump(target=$B59C28)
46 $B59CE9 StartTextBox(text_id=$041E, mode=$00)
47 $B59CED SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$1E, e=$00)
48 $B59CF3 Jump(target=$B59C28)
49 $B59CF6 JumpIfFlagSet(mem=$7F1F64, bit=$04, target=$B59D49)
50 $B59CFD JumpIfEqualsByte(mem=$80098C, value=$03, target=$B59D50)
51 $B59D04 JumpIfFlagSet(mem=$800196, bit=$04, target=$B59D57)
52 $B59D0B JumpIfFlagSet(mem=$7F1F64, bit=$05, target=$B59D49)
53 $B59D12 JumpIfBetweenValue(mem=$7F1F23, low=$00C8, high=$00DC, target=$B59D5E)
54 $B59D1C JumpIfBetweenValue(mem=$7F1F23, low=$00DD, high=$00FA, target=$B59D65)
55 $B59D26 JumpIfEqualsByte(mem=$7F1F1A, value=$00, target=$B59D6C)
56 $B59D2D JumpIfEqualsByte(mem=$7F1F1A, value=$06, target=$B59D73)
57 $B59D34 JumpIfEqualsByte(mem=$7F1F19, value=$00, target=$B59D7A)
58 $B59D3B JumpIfEqualsByte(mem=$7F1F19, value=$01, target=$B59D9C)
59 $B59D42 JumpIfEqualsByte(mem=$7F1F19, value=$02, target=$B59DB0)
60 $B59D49 StartTextBox(text_id=$0166, mode=$00)
61 $B59D4D Jump(target=$B59C28)
62 $B59D50 StartTextBox(text_id=$015F, mode=$00)
63 $B59D54 Jump(target=$B59C28)
64 $B59D57 StartTextBox(text_id=$0160, mode=$00)
65 $B59D5B Jump(target=$B59C28)
66 $B59D5E StartTextBox(text_id=$01F4, mode=$00)
67 $B59D62 Jump(target=$B59C28)
68 $B59D65 StartTextBox(text_id=$0049, mode=$00)
69 $B59D69 Jump(target=$B59C28)
70 $B59D6C StartTextBox(text_id=$0194, mode=$00)
71 $B59D70 Jump(target=$B59C28)
72 $B59D73 StartTextBox(text_id=$047D, mode=$00)
73 $B59D77 Jump(target=$B59C28)
74 $B59D7A JumpIfEqualsByte(mem=$7F1F1B, value=$16, target=$B59D95)
75 $B59D81 GetRNG(value=$02)
76 $B59D83 JumpIfEqualsRNG(value=$00, target=$B59D8E)
77 $B59D87 StartTextBox(text_id=$0189, mode=$00)
78 $B59D8B Jump(target=$B59C28)
79 $B59D8E StartTextBox(text_id=$018F, mode=$00)
... truncated after 80 commands; use CSV/index for full count.
```

## Entry 03 -> `$B59DD3`

- Commands decoded: `101`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B59DD3 JumpIfFlagSet(mem=$800196, bit=$01, target=$B59FC9)
01 $B59DDA JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B59FC9)
02 $B59DE1 JumpIfBetweenByte(mem=$7F1F1C, low=$11, high=$12, target=$B59FC9)
03 $B59DE9 JumpIfBetweenValue(mem=$7F1F37, low=$003C, high=$0059, target=$B59E08)
04 $B59DF3 JumpIfBetweenValue(mem=$7F1F39, low=$003C, high=$0059, target=$B59E08)
05 $B59DFD SpawnOrMoveCCObject(x=$0168, y=$0168, visual=$8B04, mode=$00)
06 $B59E05 Jump(target=$B59E10)
07 $B59E08 SpawnOrMoveCCObject(x=$0168, y=$0168, visual=$848C, mode=$00)
08 $B59E10 SetCCObjectParam4(a=$ED, ptr=$189E, d=$9E)
09 $B59E15 Jump(target=$B59E10)
10 $B59E18 JumpIfEqualsByte(mem=$80091E, value=$02, target=$B59E5B)
11 $B59E1F JumpIfBetweenByte(mem=$80091E, low=$01, high=$07, target=$B59E68)
12 $B59E27 JumpIfBetweenByte(mem=$80091E, low=$10, high=$13, target=$B59E68)
13 $B59E2F JumpIfEqualsByte(mem=$80091E, value=$19, target=$B59E7C)
14 $B59E36 JumpIfEqualsByte(mem=$80091E, value=$49, target=$B59E7C)
15 $B59E3D JumpIfEqualsByte(mem=$80091E, value=$06, target=$B59EAA)
16 $B59E44 JumpIfBetweenByte(mem=$80091E, low=$14, high=$17, target=$B59E90)
17 $B59E4C JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B59E9D)
18 $B59E54 StartTextBox(text_id=$0200, mode=$00)
19 $B59E58 Jump(target=$B59E10)
20 $B59E5B StartTextBox(text_id=$01D9, mode=$00)
21 $B59E5F SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$F8, e=$FF)
22 $B59E65 Jump(target=$B59E10)
23 $B59E68 JumpIfFlagSet(mem=$7F1F6C, bit=$07, target=$B59EC6)
24 $B59E6F StartTextBox(text_id=$03B2, mode=$00)
25 $B59E73 SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$06, e=$00)
26 $B59E79 Jump(target=$B59E10)
27 $B59E7C JumpIfFlagSet(mem=$7F1F6C, bit=$07, target=$B59EC6)
28 $B59E83 StartTextBox(text_id=$0212, mode=$00)
29 $B59E87 SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$06, e=$00)
30 $B59E8D Jump(target=$B59E10)
31 $B59E90 StartTextBox(text_id=$03B3, mode=$00)
32 $B59E94 SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$04, e=$00)
33 $B59E9A Jump(target=$B59E10)
34 $B59E9D StartTextBox(text_id=$03BA, mode=$00)
35 $B59EA1 SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$FC, e=$FF)
36 $B59EA7 Jump(target=$B59E10)
37 $B59EAA JumpIfFlagSet(mem=$7F1F6C, bit=$07, target=$B59EC6)
38 $B59EB1 JumpIfFlagSet(mem=$7F1F6C, bit=$08, target=$B59ED3)
39 $B59EB8 JumpIfFlagSet(mem=$7F1F6C, bit=$09, target=$B59EE0)
40 $B59EBF StartTextBox(text_id=$0212, mode=$00)
41 $B59EC3 Jump(target=$B59E10)
42 $B59EC6 StartTextBox(text_id=$01BD, mode=$00)
43 $B59ECA SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$1E, e=$00)
44 $B59ED0 Jump(target=$B59E10)
45 $B59ED3 StartTextBox(text_id=$041D, mode=$00)
46 $B59ED7 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$1E, e=$00)
47 $B59EDD Jump(target=$B59E10)
48 $B59EE0 StartTextBox(text_id=$041E, mode=$00)
49 $B59EE4 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$1E, e=$00)
50 $B59EEA Jump(target=$B59E10)
51 $B59EED JumpIfFlagSet(mem=$7F1F64, bit=$04, target=$B59F40)
52 $B59EF4 JumpIfEqualsByte(mem=$80098C, value=$03, target=$B59F47)
53 $B59EFB JumpIfFlagSet(mem=$800196, bit=$04, target=$B59F4E)
54 $B59F02 JumpIfFlagSet(mem=$7F1F64, bit=$05, target=$B59F40)
55 $B59F09 JumpIfBetweenValue(mem=$7F1F25, low=$00C8, high=$00DC, target=$B59F55)
56 $B59F13 JumpIfBetweenValue(mem=$7F1F25, low=$00DD, high=$00FA, target=$B59F5C)
57 $B59F1D JumpIfEqualsByte(mem=$7F1F1A, value=$00, target=$B59F63)
58 $B59F24 JumpIfEqualsByte(mem=$7F1F1A, value=$06, target=$B59F6A)
59 $B59F2B JumpIfEqualsByte(mem=$7F1F19, value=$00, target=$B59F71)
60 $B59F32 JumpIfEqualsByte(mem=$7F1F19, value=$01, target=$B59F93)
61 $B59F39 JumpIfEqualsByte(mem=$7F1F19, value=$02, target=$B59FA7)
62 $B59F40 StartTextBox(text_id=$0166, mode=$00)
63 $B59F44 Jump(target=$B59E10)
64 $B59F47 StartTextBox(text_id=$015F, mode=$00)
65 $B59F4B Jump(target=$B59E10)
66 $B59F4E StartTextBox(text_id=$0160, mode=$00)
67 $B59F52 Jump(target=$B59E10)
68 $B59F55 StartTextBox(text_id=$01F3, mode=$00)
69 $B59F59 Jump(target=$B59E10)
70 $B59F5C StartTextBox(text_id=$0049, mode=$00)
71 $B59F60 Jump(target=$B59E10)
72 $B59F63 StartTextBox(text_id=$0195, mode=$00)
73 $B59F67 Jump(target=$B59E10)
74 $B59F6A StartTextBox(text_id=$047D, mode=$00)
75 $B59F6E Jump(target=$B59E10)
76 $B59F71 JumpIfEqualsByte(mem=$7F1F1B, value=$16, target=$B59F8C)
77 $B59F78 GetRNG(value=$02)
78 $B59F7A JumpIfEqualsRNG(value=$00, target=$B59F85)
79 $B59F7E StartTextBox(text_id=$0427, mode=$00)
... truncated after 80 commands; use CSV/index for full count.
```

## Entry 04 -> `$B59FCA`

- Commands decoded: `102`
- Stop reason: `stop_or_wait_opcode_$10`
- Pointer duplicate count: `1`

```text
00 $B59FCA JumpIfFlagSet(mem=$800196, bit=$01, target=$B5A1C8)
01 $B59FD1 JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B5A1C8)
02 $B59FD8 JumpIfBetweenByte(mem=$7F1F1C, low=$06, high=$0A, target=$B5A1C8)
03 $B59FE0 JumpIfBetweenByte(mem=$7F1F1C, low=$10, high=$12, target=$B5A1C8)
04 $B59FE8 StartNestedScriptSlot(slot=$01, target=$B5A1C9)
05 $B59FEC StartNestedScriptSlot(slot=$02, target=$B5A1D7)
06 $B59FF0 JumpIfBetweenValue(mem=$7F1F37, low=$003C, high=$0059, target=$B5A00F)
07 $B59FFA JumpIfBetweenValue(mem=$7F1F39, low=$003C, high=$0059, target=$B5A00F)
08 $B5A004 SpawnOrMoveCCObject(x=$0048, y=$0048, visual=$8AF8, mode=$03)
09 $B5A00C Jump(target=$B5A017)
10 $B5A00F SpawnOrMoveCCObject(x=$0048, y=$0048, visual=$8480, mode=$00)
11 $B5A017 SetCCObjectParam4(a=$EC, ptr=$1FA0, d=$A0)
12 $B5A01C Jump(target=$B5A017)
13 $B5A01F JumpIfEqualsByte(mem=$80091E, value=$02, target=$B5A061)
14 $B5A026 JumpIfEqualsByte(mem=$80091E, value=$07, target=$B5A061)
15 $B5A02D JumpIfBetweenByte(mem=$80091E, low=$01, high=$05, target=$B5A06E)
16 $B5A035 JumpIfBetweenByte(mem=$80091E, low=$10, high=$17, target=$B5A06E)
17 $B5A03D JumpIfEqualsByte(mem=$80091E, value=$06, target=$B5A082)
18 $B5A044 JumpIfEqualsByte(mem=$80091E, value=$19, target=$B5A096)
19 $B5A04B JumpIfEqualsByte(mem=$80091E, value=$49, target=$B5A096)
20 $B5A052 JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B5A0B8)
21 $B5A05A StartTextBox(text_id=$0200, mode=$00)
22 $B5A05E Jump(target=$B5A017)
23 $B5A061 StartTextBox(text_id=$03B4, mode=$00)
24 $B5A065 SetCCObjectParam8(a=$27, b=$1F, c=$7F, d=$F8, e=$FF)
25 $B5A06B Jump(target=$B5A017)
26 $B5A06E JumpIfFlagSet(mem=$7F1F6C, bit=$07, target=$B5A0C5)
27 $B5A075 StartTextBox(text_id=$03B2, mode=$00)
28 $B5A079 SetCCObjectParam8(a=$27, b=$1F, c=$7F, d=$04, e=$00)
29 $B5A07F Jump(target=$B5A017)
30 $B5A082 JumpIfFlagSet(mem=$7F1F6C, bit=$07, target=$B5A0C5)
31 $B5A089 StartTextBox(text_id=$0212, mode=$00)
32 $B5A08D SetCCObjectParam8(a=$27, b=$1F, c=$7F, d=$08, e=$00)
33 $B5A093 Jump(target=$B5A017)
34 $B5A096 JumpIfFlagSet(mem=$7F1F6C, bit=$07, target=$B5A0C5)
35 $B5A09D JumpIfFlagSet(mem=$7F1F6C, bit=$08, target=$B5A0D2)
36 $B5A0A4 JumpIfFlagSet(mem=$7F1F6C, bit=$09, target=$B5A0DF)
37 $B5A0AB SetCCObjectParam8(a=$27, b=$1F, c=$7F, d=$08, e=$00)
38 $B5A0B1 StartTextBox(text_id=$0212, mode=$00)
39 $B5A0B5 Jump(target=$B5A017)
40 $B5A0B8 StartTextBox(text_id=$03BA, mode=$00)
41 $B5A0BC SetCCObjectParam8(a=$27, b=$1F, c=$7F, d=$FC, e=$FF)
42 $B5A0C2 Jump(target=$B5A017)
43 $B5A0C5 StartTextBox(text_id=$01BD, mode=$00)
44 $B5A0C9 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$1E, e=$00)
45 $B5A0CF Jump(target=$B5A017)
46 $B5A0D2 StartTextBox(text_id=$041D, mode=$00)
47 $B5A0D6 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$1E, e=$00)
48 $B5A0DC Jump(target=$B5A017)
49 $B5A0DF StartTextBox(text_id=$041E, mode=$00)
50 $B5A0E3 SetCCObjectParam8(a=$33, b=$1F, c=$7F, d=$1E, e=$00)
51 $B5A0E9 Jump(target=$B5A017)
52 $B5A0EC JumpIfFlagSet(mem=$7F1F64, bit=$04, target=$B5A13F)
53 $B5A0F3 JumpIfEqualsByte(mem=$80098C, value=$03, target=$B5A146)
54 $B5A0FA JumpIfFlagSet(mem=$800196, bit=$04, target=$B5A14D)
55 $B5A101 JumpIfFlagSet(mem=$7F1F64, bit=$05, target=$B5A13F)
56 $B5A108 JumpIfBetweenValue(mem=$7F1F27, low=$00C8, high=$00DC, target=$B5A154)
57 $B5A112 JumpIfBetweenValue(mem=$7F1F27, low=$00DD, high=$00FA, target=$B5A15B)
58 $B5A11C JumpIfEqualsByte(mem=$7F1F1A, value=$00, target=$B5A162)
59 $B5A123 JumpIfEqualsByte(mem=$7F1F1A, value=$06, target=$B5A169)
60 $B5A12A JumpIfEqualsByte(mem=$7F1F19, value=$00, target=$B5A170)
61 $B5A131 JumpIfEqualsByte(mem=$7F1F19, value=$01, target=$B5A192)
62 $B5A138 JumpIfEqualsByte(mem=$7F1F19, value=$02, target=$B5A1A6)
63 $B5A13F StartTextBox(text_id=$0166, mode=$00)
64 $B5A143 Jump(target=$B5A017)
65 $B5A146 StartTextBox(text_id=$015F, mode=$00)
66 $B5A14A Jump(target=$B5A017)
67 $B5A14D StartTextBox(text_id=$0160, mode=$00)
68 $B5A151 Jump(target=$B5A017)
69 $B5A154 StartTextBox(text_id=$01F4, mode=$00)
70 $B5A158 Jump(target=$B5A017)
71 $B5A15B StartTextBox(text_id=$0049, mode=$00)
72 $B5A15F Jump(target=$B5A017)
73 $B5A162 StartTextBox(text_id=$0194, mode=$00)
74 $B5A166 Jump(target=$B5A017)
75 $B5A169 StartTextBox(text_id=$047D, mode=$00)
76 $B5A16D Jump(target=$B5A017)
77 $B5A170 JumpIfEqualsByte(mem=$7F1F1B, value=$16, target=$B5A18B)
78 $B5A177 GetRNG(value=$02)
79 $B5A179 JumpIfEqualsRNG(value=$00, target=$B5A184)
... truncated after 80 commands; use CSV/index for full count.
```

## Entry 05 -> `$B5A1E5`

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$A4`
- Pointer duplicate count: `11`

```text
00 $B5A1E5 SetPlayerPosition(x=$FDA2, y=$07A2)
01 $B5A1EA UnknownOpcode_$A4()
```

## Entry 06 -> `$B5A1E5` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$A4`
- Pointer duplicate count: `11`

```text
00 $B5A1E5 SetPlayerPosition(x=$FDA2, y=$07A2)
01 $B5A1EA UnknownOpcode_$A4()
```

## Entry 07 -> `$B5A1E5` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$A4`
- Pointer duplicate count: `11`

```text
00 $B5A1E5 SetPlayerPosition(x=$FDA2, y=$07A2)
01 $B5A1EA UnknownOpcode_$A4()
```

## Entry 08 -> `$B5A1E5` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$A4`
- Pointer duplicate count: `11`

```text
00 $B5A1E5 SetPlayerPosition(x=$FDA2, y=$07A2)
01 $B5A1EA UnknownOpcode_$A4()
```

## Entry 09 -> `$B5A1E5` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$A4`
- Pointer duplicate count: `11`

```text
00 $B5A1E5 SetPlayerPosition(x=$FDA2, y=$07A2)
01 $B5A1EA UnknownOpcode_$A4()
```

## Entry 10 -> `$B5A1E5` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$A4`
- Pointer duplicate count: `11`

```text
00 $B5A1E5 SetPlayerPosition(x=$FDA2, y=$07A2)
01 $B5A1EA UnknownOpcode_$A4()
```

## Entry 11 -> `$B5A1E5` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$A4`
- Pointer duplicate count: `11`

```text
00 $B5A1E5 SetPlayerPosition(x=$FDA2, y=$07A2)
01 $B5A1EA UnknownOpcode_$A4()
```

## Entry 12 -> `$B5A1E5` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$A4`
- Pointer duplicate count: `11`

```text
00 $B5A1E5 SetPlayerPosition(x=$FDA2, y=$07A2)
01 $B5A1EA UnknownOpcode_$A4()
```

## Entry 13 -> `$B5A1E5` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$A4`
- Pointer duplicate count: `11`

```text
00 $B5A1E5 SetPlayerPosition(x=$FDA2, y=$07A2)
01 $B5A1EA UnknownOpcode_$A4()
```

## Entry 14 -> `$B5A1E5` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$A4`
- Pointer duplicate count: `11`

```text
00 $B5A1E5 SetPlayerPosition(x=$FDA2, y=$07A2)
01 $B5A1EA UnknownOpcode_$A4()
```

## Entry 15 -> `$B5A1E5` duplicate_target

- Commands decoded: `2`
- Stop reason: `unknown_opcode_$A4`
- Pointer duplicate count: `11`

```text
00 $B5A1E5 SetPlayerPosition(x=$FDA2, y=$07A2)
01 $B5A1EA UnknownOpcode_$A4()
```

