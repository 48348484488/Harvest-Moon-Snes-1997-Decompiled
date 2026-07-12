# Pass 57 - EventScript symbolic disassembly B3-B5

Conservative pseudocode generated from the local clean USA ROM. Dialog text is not exported; only text ids are shown.

- ROM MD5: `c9bf36a816b6d54aed79d43a6c45111a`
- Groups scanned: `72`
- Entries decoded: `1288`
- Priority groups expanded: `$00, $44, $04, $07, $01, $06, $08, $02, $43, $45, $03, $47`

## Priority group summary

| Group | Label | Entries | Unique targets | Commands | Unknown cmds | Dominant classes |
|---:|---|---:|---:|---:|---:|---|
| `$00` | `EventScriptGroup_00` | 136 | 135 | 480 | 24 | cc_state_object:204 script_control:201 unknown:24 special_unknown:22 animals:15 conditional:5 |
| `$44` | `EventScriptGroup_44` | 16 | 6 | 502 | 11 | conditional:172 script_control:126 dialog_text:113 cc_state_object:54 time_rng_palette:15 player_camera_motion:11 |
| `$04` | `EventScriptGroup_04` | 16 | 9 | 395 | 8 | script_control:167 dialog_text:91 conditional:66 cc_state_object:57 unknown:8 screen_transition:6 |
| `$07` | `EventScriptGroup_07` | 16 | 9 | 389 | 8 | script_control:165 dialog_text:89 cc_state_object:66 conditional:53 screen_transition:8 unknown:8 |
| `$01` | `EventScriptGroup_01` | 16 | 12 | 329 | 23 | script_control:129 conditional:68 cc_state_object:47 dialog_text:36 unknown:23 screen_transition:11 |
| `$06` | `EventScriptGroup_06` | 16 | 8 | 333 | 9 | script_control:134 dialog_text:73 conditional:57 cc_state_object:44 time_rng_palette:9 unknown:9 |
| `$08` | `EventScriptGroup_08` | 16 | 9 | 312 | 8 | script_control:131 dialog_text:65 cc_state_object:46 conditional:44 screen_transition:10 flags_values:8 |
| `$02` | `EventScriptGroup_02` | 16 | 6 | 214 | 12 | script_control:99 dialog_text:36 conditional:31 cc_state_object:25 unknown:12 screen_transition:6 |
| `$43` | `EventScriptGroup_43` | 16 | 6 | 184 | 16 | conditional:64 cc_state_object:45 script_control:36 unknown:16 flags_values:10 dialog_text:10 |
| `$45` | `EventScriptGroup_45` | 16 | 7 | 164 | 12 | conditional:50 script_control:50 cc_state_object:20 dialog_text:18 unknown:12 flags_values:10 |
| `$03` | `EventScriptGroup_03` | 16 | 4 | 175 | 14 | script_control:65 conditional:29 cc_state_object:27 dialog_text:24 unknown:14 flags_values:13 |
| `$47` | `EventScriptGroup_47` | 32 | 31 | 84 | 30 | unknown:30 flags_values:29 audio:23 script_control:2 |

## Expanded pseudocode samples

### EventScriptGroup_00

#### Entry 00 at `$B38CC8`

```text
00: SetCCObjectVisual(ptr=$815C, bank_or_mode=$00)
01: ChickenRelated()
02: Jump(target=$B38CCC)
; stop: next_entry_boundary
```

#### Entry 01 at `$B38CD0`

```text
00: SetCCObjectVisual(ptr=$8150, bank_or_mode=$00)
01: SetCCObjectParam5(a=$01, ptr=$8150, d=$10)
02: SetCCObjectParam10()
03: ChickenRelated()
04: Jump(target=$B38CDA)
; stop: next_entry_boundary
```

#### Entry 02 at `$B38CDE`

```text
00: SetCCObjectVisual(ptr=$8144, bank_or_mode=$00)
01: SetCCObjectParam5(a=$01, ptr=$8144, d=$10)
02: ChickenRelated()
03: Jump(target=$B38CE7)
; stop: next_entry_boundary
```

#### Entry 03 at `$B38CEB`

```text
00: SetCCObjectVisual(ptr=$86C0, bank_or_mode=$00)
01: SetCCObjectParam5(a=$01, ptr=$86CC, d=$10)
02: CowRelated()
03: Jump(target=$B38CF4)
; stop: next_entry_boundary
```

#### Entry 04 at `$B38CF8`

```text
00: SetCCObjectVisual(ptr=$86A8, bank_or_mode=$00)
01: SetCCObjectParam5(a=$01, ptr=$86B4, d=$10)
02: CowRelated()
03: Jump(target=$B38D01)
; stop: next_entry_boundary
```

#### Entry 05 at `$B38D05`

```text
00: SetCCObjectVisual(ptr=$80FC, bank_or_mode=$00)
01: SetCCObjectParam5(a=$01, ptr=$8108, d=$10)
02: CowRelated()
03: Jump(target=$B38D0E)
; stop: next_entry_boundary
```

#### Entry 06 at `$B38D12`

```text
00: SetCCObjectVisual(ptr=$8708, bank_or_mode=$00)
01: SetCCObjectParam5(a=$01, ptr=$8714, d=$10)
02: CowRelated()
03: Jump(target=$B38D1B)
; stop: next_entry_boundary
```

#### Entry 07 at `$B38D1F`

```text
00: SetCCObjectVisual(ptr=$86D8, bank_or_mode=$00)
01: SetCCObjectParam5(a=$02, ptr=$86E4, d=$10)
02: CowRelated()
03: Jump(target=$B38D28)
; stop: next_entry_boundary
```

Expanded unique entries shown: 8. See CSV for the complete symbolic index.

### EventScriptGroup_44

#### Entry 00 at `$B597F1`

```text
00: JumpIfFlagSet(mem=$800196, bit=$01, target=$B599EA)
01: JumpIfBetweenByte(mem=$7F1F1C, low=$06, high=$0A, target=$B599EA)
02: JumpIfBetweenByte(mem=$7F1F1C, low=$0F, high=$12, target=$B599EA)
03: JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B599EA)
04: JumpIfBetweenValue(mem=$7F1F37, low=$003C, high=$0059, target=$B5982E)
05: JumpIfBetweenValue(mem=$7F1F39, low=$003C, high=$0059, target=$B5982E)
06: SpawnOrMoveCCObject(x=$0168, y=$0168, visual=$8AEC, mode=$00)
07: Jump(target=$B59836)
08: SpawnOrMoveCCObject(x=$0168, y=$0168, visual=$8480, mode=$00)
09: SetCCObjectParam4(a=$0B, ptr=$3E99, d=$98)
10: Jump(target=$B59836)
11: JumpIfEqualsByte(mem=$80091E, value=$02, target=$B59880)
12: JumpIfBetweenByte(mem=$80091E, low=$01, high=$05, target=$B5988D)
13: JumpIfEqualsByte(mem=$80091E, value=$07, target=$B5988D)
14: JumpIfBetweenByte(mem=$80091E, low=$10, high=$17, target=$B5988D)
15: JumpIfEqualsByte(mem=$80091E, value=$19, target=$B598A1)
...
; stop: max_commands
```

#### Entry 01 at `$B599EB`

```text
00: JumpIfFlagSet(mem=$800196, bit=$01, target=$B59BD4)
01: JumpIfBetweenByte(mem=$7F1F1C, low=$06, high=$0A, target=$B59BD4)
02: JumpIfBetweenByte(mem=$7F1F1C, low=$0F, high=$12, target=$B59BD4)
03: JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B59BD4)
04: StartNestedScriptSlot(slot=$01, target=$B59BD5)
05: JumpIfBetweenValue(mem=$7F1F37, low=$003C, high=$0059, target=$B59A2C)
06: JumpIfBetweenValue(mem=$7F1F39, low=$003C, high=$0059, target=$B59A2C)
07: SpawnOrMoveCCObject(x=$0048, y=$0048, visual=$8AF8, mode=$00)
08: Jump(target=$B59A34)
09: SpawnOrMoveCCObject(x=$0048, y=$0048, visual=$8480, mode=$00)
10: SetCCObjectParam4(a=$F5, ptr=$3C9A, d=$9A)
11: Jump(target=$B59A34)
12: JumpIfEqualsByte(mem=$80091E, value=$02, target=$B59A77)
13: JumpIfBetweenByte(mem=$80091E, low=$03, high=$07, target=$B59A98)
14: JumpIfBetweenByte(mem=$80091E, low=$10, high=$17, target=$B59A98)
15: JumpIfEqualsByte(mem=$80091E, value=$06, target=$B59AAC)
...
; stop: max_commands
```

#### Entry 02 at `$B59BE3`

```text
00: JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B59DD2)
01: JumpIfFlagSet(mem=$800196, bit=$01, target=$B59DD2)
02: JumpIfBetweenByte(mem=$7F1F1C, low=$06, high=$0A, target=$B59DD2)
03: JumpIfBetweenByte(mem=$7F1F1C, low=$0F, high=$12, target=$B59DD2)
04: JumpIfBetweenValue(mem=$7F1F37, low=$003C, high=$0059, target=$B59C20)
05: JumpIfBetweenValue(mem=$7F1F39, low=$003C, high=$0059, target=$B59C20)
06: SpawnOrMoveCCObject(x=$0168, y=$0168, visual=$8B04, mode=$00)
07: Jump(target=$B59C28)
08: SpawnOrMoveCCObject(x=$0168, y=$0168, visual=$848C, mode=$00)
09: SetCCObjectParam4(a=$F6, ptr=$309C, d=$9C)
10: Jump(target=$B59C28)
11: JumpIfBetweenByte(mem=$80091E, low=$01, high=$04, target=$B59C8C)
12: JumpIfBetweenByte(mem=$80091E, low=$10, high=$17, target=$B59C8C)
13: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B59CA0)
14: JumpIfEqualsByte(mem=$80091E, value=$06, target=$B59CAD)
15: JumpIfEqualsByte(mem=$80091E, value=$05, target=$B59CAD)
...
; stop: max_commands
```

#### Entry 03 at `$B59DD3`

```text
00: JumpIfFlagSet(mem=$800196, bit=$01, target=$B59FC9)
01: JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B59FC9)
02: JumpIfBetweenByte(mem=$7F1F1C, low=$11, high=$12, target=$B59FC9)
03: JumpIfBetweenValue(mem=$7F1F37, low=$003C, high=$0059, target=$B59E08)
04: JumpIfBetweenValue(mem=$7F1F39, low=$003C, high=$0059, target=$B59E08)
05: SpawnOrMoveCCObject(x=$0168, y=$0168, visual=$8B04, mode=$00)
06: Jump(target=$B59E10)
07: SpawnOrMoveCCObject(x=$0168, y=$0168, visual=$848C, mode=$00)
08: SetCCObjectParam4(a=$ED, ptr=$189E, d=$9E)
09: Jump(target=$B59E10)
10: JumpIfEqualsByte(mem=$80091E, value=$02, target=$B59E5B)
11: JumpIfBetweenByte(mem=$80091E, low=$01, high=$07, target=$B59E68)
12: JumpIfBetweenByte(mem=$80091E, low=$10, high=$13, target=$B59E68)
13: JumpIfEqualsByte(mem=$80091E, value=$19, target=$B59E7C)
14: JumpIfEqualsByte(mem=$80091E, value=$49, target=$B59E7C)
15: JumpIfEqualsByte(mem=$80091E, value=$06, target=$B59EAA)
...
; stop: max_commands
```

#### Entry 04 at `$B59FCA`

```text
00: JumpIfFlagSet(mem=$800196, bit=$01, target=$B5A1C8)
01: JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B5A1C8)
02: JumpIfBetweenByte(mem=$7F1F1C, low=$06, high=$0A, target=$B5A1C8)
03: JumpIfBetweenByte(mem=$7F1F1C, low=$10, high=$12, target=$B5A1C8)
04: StartNestedScriptSlot(slot=$01, target=$B5A1C9)
05: StartNestedScriptSlot(slot=$02, target=$B5A1D7)
06: JumpIfBetweenValue(mem=$7F1F37, low=$003C, high=$0059, target=$B5A00F)
07: JumpIfBetweenValue(mem=$7F1F39, low=$003C, high=$0059, target=$B5A00F)
08: SpawnOrMoveCCObject(x=$0048, y=$0048, visual=$8AF8, mode=$03)
09: Jump(target=$B5A017)
10: SpawnOrMoveCCObject(x=$0048, y=$0048, visual=$8480, mode=$00)
11: SetCCObjectParam4(a=$EC, ptr=$1FA0, d=$A0)
12: Jump(target=$B5A017)
13: JumpIfEqualsByte(mem=$80091E, value=$02, target=$B5A061)
14: JumpIfEqualsByte(mem=$80091E, value=$07, target=$B5A061)
15: JumpIfBetweenByte(mem=$80091E, low=$01, high=$05, target=$B5A06E)
...
; stop: max_commands
```

#### Entry 05 at `$B5A1E5` / duplicate refs: 11

```text
00: SetPlayerPosition(x=$FDA2, y=$07A2)
01: UnknownOpcode_$A4()
; stop: unknown_opcode_$A4
```

Expanded unique entries shown: 6. See CSV for the complete symbolic index.

### EventScriptGroup_04

#### Entry 00 at `$B3C527`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3C54E)
02: StartNestedScriptSlot(slot=$02, target=$B3C5A1)
03: Jump(target=$B3C539)
04: WaitOrSetCCCounter(value=$0001)
05: Jump(target=$B3C533)
06: JumpIfFlagSet(mem=$7F1F66, bit=$00, target=$B3C54B)
07: JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3C54B)
08: StartNestedScriptSlot(slot=$03, target=$B3C600)
09: Jump(target=$B3C533)
10: SpawnOrMoveCCObject(x=$00C8, y=$0078, visual=$8300, mode=$00)
11: SetCCObjectAndJump(target=$B3C561)
12: SetCCObjectParam4(a=$7E, ptr=$68C5, d=$C5)
13: Jump(target=$B3C556)
14: StartTextBox(text_id=$01C9, mode=$00)
15: Jump(target=$B3C556)
...
; stop: next_entry_boundary
```

#### Entry 01 at `$B3C6AE`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3C6B9)
02: WaitOrSetCCCounter(value=$0001)
03: Jump(target=$B3C6B3)
04: SpawnOrMoveCCObject(x=$0068, y=$00E8, visual=$8354, mode=$00)
05: SetCCObjectAndJump(target=$B3C6CC)
06: SetCCObjectParam4(a=$E9, ptr=$D3C6, d=$C6)
07: Jump(target=$B3C6C1)
08: StartTextBox(text_id=$01E0, mode=$00)
09: Jump(target=$B3C6C1)
10: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3C6E2)
11: StartTextBox(text_id=$0200, mode=$00)
12: Jump(target=$B3C6C1)
13: StartTextBox(text_id=$03B0, mode=$00)
14: Jump(target=$B3C6C1)
15: JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3C6F7)
...
; stop: next_entry_boundary
```

#### Entry 02 at `$B3C6FE`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3C721)
02: Jump(target=$B3C70C)
03: WaitOrSetCCCounter(value=$0001)
04: Jump(target=$B3C706)
05: JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B3C71E)
06: JumpIfFlagSet(mem=$7F1F6C, bit=$00, target=$B3C71E)
07: StartNestedScriptSlot(slot=$02, target=$B3C758)
08: Jump(target=$B3C706)
09: SpawnOrMoveCCObject(x=$0028, y=$0168, visual=$83FC, mode=$02)
10: SetCCObjectAndJump(target=$B3C734)
11: SetCCObjectParam4(a=$51, ptr=$3BC7, d=$C7)
12: Jump(target=$B3C729)
13: StartTextBox(text_id=$01C6, mode=$00)
14: Jump(target=$B3C729)
15: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3C74A)
...
; stop: next_entry_boundary
```

#### Entry 03 at `$B3C810`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3C82C)
02: Jump(target=$B3C81E)
03: WaitOrSetCCCounter(value=$0001)
04: Jump(target=$B3C818)
05: JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B3C829)
06: StartNestedScriptSlot(slot=$02, target=$B3C871)
07: Jump(target=$B3C818)
08: SpawnOrMoveCCObject(x=$0028, y=$0168, visual=$8318, mode=$02)
09: SetCCObjectAndJump(target=$B3C83F)
10: SetCCObjectParam4(a=$5C, ptr=$46C8, d=$C8)
11: Jump(target=$B3C834)
12: StartTextBox(text_id=$01CA, mode=$00)
13: Jump(target=$B3C834)
14: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3C855)
15: StartTextBox(text_id=$0200, mode=$00)
...
; stop: next_entry_boundary
```

#### Entry 04 at `$B3C92A`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3C96A)
02: StartNestedScriptSlot(slot=$02, target=$B3C9B2)
03: JumpIfFlagSet(mem=$7F1F6C, bit=$02, target=$B3C94E)
04: JumpIfFlagSet(mem=$7F1F6C, bit=$03, target=$B3C94E)
05: StartNestedScriptSlot(slot=$04, target=$B3C95C)
06: Jump(target=$B3C94E)
07: WaitOrSetCCCounter(value=$0001)
08: Jump(target=$B3C948)
09: JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B3C959)
10: StartNestedScriptSlot(slot=$03, target=$B3C9D4)
11: Jump(target=$B3C948)
12: SpawnOrMoveCCObject(x=$0087, y=$0097, visual=$8558, mode=$00)
13: WaitOrSetCCCounter(value=$0001)
14: Jump(target=$B3C964)
15: SpawnOrMoveCCObject(x=$0028, y=$0198, visual=$8330, mode=$02)
...
; stop: next_entry_boundary
```

#### Entry 05 at `$B3CA98`

```text
00: StartNestedScriptSlot(slot=$01, target=$B3CAA6)
01: StartNestedScriptSlot(slot=$02, target=$B3CB29)
02: WaitOrSetCCCounter(value=$0001)
03: Jump(target=$B3CAA0)
04: SpawnOrMoveCCObject(x=$0088, y=$0050, visual=$82E8, mode=$00)
05: SetCCObjectAndJump(target=$B3CAB9)
06: SetCCObjectParam4(a=$DA, ptr=$C4CA, d=$CA)
07: Jump(target=$B3CAAE)
08: StartTextBox(text_id=$01CA, mode=$00)
09: SetCCObjectParam(param=$0288, value=$00)
10: Jump(target=$B3CAAE)
11: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3CAD3)
12: StartTextBox(text_id=$0200, mode=$00)
13: Jump(target=$B3CAAE)
14: StartTextBox(text_id=$03BB, mode=$00)
15: Jump(target=$B3CAAE)
...
; stop: next_entry_boundary
```

#### Entry 06 at `$B3CB60`

```text
00: StartNestedScriptSlot(slot=$01, target=$B3CB6A)
01: WaitOrSetCCCounter(value=$0001)
02: Jump(target=$B3CB64)
03: SpawnOrMoveCCObject(x=$00E8, y=$009C, visual=$836C, mode=$03)
04: SetCCObjectAndJump(target=$B3CB7D)
05: SetCCObjectParam4(a=$9E, ptr=$88CB, d=$CB)
06: Jump(target=$B3CB72)
07: StartTextBox(text_id=$01C9, mode=$00)
08: SetCCObjectParam(param=$02AF, value=$00)
09: Jump(target=$B3CB72)
10: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3CB97)
11: StartTextBox(text_id=$0200, mode=$00)
12: Jump(target=$B3CB72)
13: StartTextBox(text_id=$03BB, mode=$00)
14: Jump(target=$B3CB72)
15: StartTextBox(text_id=$005E, mode=$00)
...
; stop: next_entry_boundary
```

#### Entry 07 at `$B3CBA5`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3CBEC)
02: StartNestedScriptSlot(slot=$02, target=$B3CBB4)
03: WaitOrSetCCCounter(value=$0001)
04: Jump(target=$B3CBAE)
05: SpawnOrMoveCCObject(x=$0058, y=$00B8, visual=$8234, mode=$00)
06: SetCCObjectAndJump(target=$B3CBC7)
07: SetCCObjectParam4(a=$E4, ptr=$CECB, d=$CB)
08: Jump(target=$B3CBBC)
09: StartTextBox(text_id=$01C8, mode=$00)
10: Jump(target=$B3CBBC)
11: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3CBDD)
12: StartTextBox(text_id=$03BC, mode=$00)
13: Jump(target=$B3CBBC)
14: StartTextBox(text_id=$03BB, mode=$00)
15: Jump(target=$B3CBBC)
...
; stop: stop_or_wait_opcode_$10
```

Expanded unique entries shown: 8. See CSV for the complete symbolic index.

### EventScriptGroup_07

#### Entry 00 at `$B3DA17`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3DA3E)
02: StartNestedScriptSlot(slot=$02, target=$B3DA96)
03: Jump(target=$B3DA29)
04: WaitOrSetCCCounter(value=$0001)
05: Jump(target=$B3DA23)
06: JumpIfFlagSet(mem=$7F1F66, bit=$00, target=$B3DA3B)
07: JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3DA3B)
08: StartNestedScriptSlot(slot=$03, target=$B3DAEE)
09: Jump(target=$B3DA23)
10: SpawnOrMoveCCObject(x=$00C8, y=$0078, visual=$8300, mode=$00)
11: SetCCObjectAndJump(target=$B3DA58)
12: SetCCObjectParam4(a=$5F, ptr=$51DA, d=$DA)
13: Jump(target=$B3DA46)
14: StartTextBox(text_id=$0200, mode=$00)
15: Jump(target=$B3DA46)
...
; stop: next_entry_boundary
```

#### Entry 01 at `$B3DB72`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3DB7D)
02: WaitOrSetCCCounter(value=$0001)
03: Jump(target=$B3DB77)
04: SpawnOrMoveCCObject(x=$0068, y=$00E8, visual=$8354, mode=$00)
05: SetCCObjectAndJump(target=$B3DB97)
06: SetCCObjectParam4(a=$9E, ptr=$90DB, d=$DB)
07: Jump(target=$B3DB85)
08: StartTextBox(text_id=$0200, mode=$00)
09: Jump(target=$B3DB85)
10: StartTextBox(text_id=$01E0, mode=$00)
11: Jump(target=$B3DB85)
12: JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3DBBA)
13: JumpIfEqualsByte(mem=$7F1F1B, value=$17, target=$B3DBC1)
14: JumpIfEqualsByte(mem=$7F1F1B, value=$1E, target=$B3DBC8)
15: StartTextBox(text_id=$0397, mode=$00)
...
; stop: next_entry_boundary
```

#### Entry 02 at `$B3DBD5`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3DBF8)
02: Jump(target=$B3DBE3)
03: WaitOrSetCCCounter(value=$0001)
04: Jump(target=$B3DBDD)
05: JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B3DBF5)
06: JumpIfFlagSet(mem=$7F1F6C, bit=$00, target=$B3DBF5)
07: StartNestedScriptSlot(slot=$02, target=$B3DC4A)
08: Jump(target=$B3DBDD)
09: SpawnOrMoveCCObject(x=$0028, y=$0168, visual=$83FC, mode=$02)
10: SetCCObjectAndJump(target=$B3DC12)
11: SetCCObjectParam4(a=$19, ptr=$0BDC, d=$DC)
12: Jump(target=$B3DC00)
13: StartTextBox(text_id=$0200, mode=$00)
14: Jump(target=$B3DC00)
15: StartTextBox(text_id=$01C6, mode=$00)
...
; stop: next_entry_boundary
```

#### Entry 03 at `$B3DCD1`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3DCED)
02: Jump(target=$B3DCDF)
03: WaitOrSetCCCounter(value=$0001)
04: Jump(target=$B3DCD9)
05: JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B3DCEA)
06: StartNestedScriptSlot(slot=$02, target=$B3DD3F)
07: Jump(target=$B3DCD9)
08: SpawnOrMoveCCObject(x=$0028, y=$0168, visual=$8318, mode=$02)
09: SetCCObjectAndJump(target=$B3DD07)
10: SetCCObjectParam4(a=$0E, ptr=$00DD, d=$DD)
11: Jump(target=$B3DCF5)
12: StartTextBox(text_id=$0200, mode=$00)
13: Jump(target=$B3DCF5)
14: StartTextBox(text_id=$01CA, mode=$00)
15: Jump(target=$B3DCF5)
...
; stop: next_entry_boundary
```

#### Entry 04 at `$B3DDC7`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3DE07)
02: JumpIfFlagSet(mem=$7F1F6C, bit=$02, target=$B3DDEB)
03: JumpIfFlagSet(mem=$7F1F6C, bit=$03, target=$B3DDEB)
04: StartNestedScriptSlot(slot=$03, target=$B3DDF9)
05: StartNestedScriptSlot(slot=$04, target=$B3DE55)
06: Jump(target=$B3DDEB)
07: WaitOrSetCCCounter(value=$0001)
08: Jump(target=$B3DDE5)
09: JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B3DDF6)
10: StartNestedScriptSlot(slot=$02, target=$B3DE91)
11: Jump(target=$B3DDE5)
12: SpawnOrMoveCCObject(x=$0087, y=$0097, visual=$8558, mode=$00)
13: WaitOrSetCCCounter(value=$0001)
14: Jump(target=$B3DE01)
15: SpawnOrMoveCCObject(x=$0028, y=$0198, visual=$8330, mode=$02)
...
; stop: next_entry_boundary
```

#### Entry 05 at `$B3DF0F`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3DF1E)
02: StartNestedScriptSlot(slot=$02, target=$B3DF92)
03: WaitOrSetCCCounter(value=$0001)
04: Jump(target=$B3DF18)
05: SpawnOrMoveCCObject(x=$0088, y=$0050, visual=$82E8, mode=$00)
06: SetCCObjectAndJump(target=$B3DF38)
07: SetCCObjectParam4(a=$43, ptr=$31DF, d=$DF)
08: Jump(target=$B3DF26)
09: StartTextBox(text_id=$0200, mode=$00)
10: Jump(target=$B3DF26)
11: StartTextBox(text_id=$01CA, mode=$00)
12: SetCCObjectParam(param=$0288, value=$00)
13: Jump(target=$B3DF26)
14: JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3DF66)
15: JumpIfFlagSet(mem=$7F1F6A, bit=$0E, target=$B3DF71)
...
; stop: next_entry_boundary
```

#### Entry 06 at `$B3DFCE`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3DFD9)
02: WaitOrSetCCCounter(value=$0001)
03: Jump(target=$B3DFD3)
04: SpawnOrMoveCCObject(x=$00E8, y=$0098, visual=$836C, mode=$03)
05: SetCCObjectAndJump(target=$B3DFF7)
06: SetCCObjectParam4(a=$02, ptr=$ECE0, d=$DF)
07: Jump(target=$B3DFE1)
08: StartTextBox(text_id=$0200, mode=$00)
09: SetCCObjectParam(param=$02AF, value=$00)
10: Jump(target=$B3DFE1)
11: StartTextBox(text_id=$01C9, mode=$00)
12: SetCCObjectParam(param=$02AF, value=$00)
13: Jump(target=$B3DFE1)
14: JumpIfFlagSet(mem=$7F1F6C, bit=$02, target=$B3E01B)
15: JumpIfEqualsByte(mem=$7F1F1B, value=$1E, target=$B3E026)
...
; stop: next_entry_boundary
```

#### Entry 07 at `$B3E037`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3E083)
02: StartNestedScriptSlot(slot=$02, target=$B3E046)
03: WaitOrSetCCCounter(value=$0001)
04: Jump(target=$B3E040)
05: SpawnOrMoveCCObject(x=$0058, y=$00B8, visual=$8234, mode=$00)
06: SetCCObjectAndJump(target=$B3E060)
07: SetCCObjectParam4(a=$67, ptr=$59E0, d=$E0)
08: Jump(target=$B3E04E)
09: StartTextBox(text_id=$03BC, mode=$00)
10: Jump(target=$B3E04E)
11: StartTextBox(text_id=$01C8, mode=$00)
12: Jump(target=$B3E04E)
13: JumpIfEqualsByte(mem=$7F1F1B, value=$1E, target=$B3E075)
14: StartTextBox(text_id=$0150, mode=$00)
15: Jump(target=$B3E04E)
...
; stop: stop_or_wait_opcode_$10
```

Expanded unique entries shown: 8. See CSV for the complete symbolic index.

### EventScriptGroup_01

#### Entry 00 at `$B39379`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B393CE)
02: StartNestedScriptSlot(slot=$02, target=$B39498)
03: StartNestedScriptSlot(slot=$07, target=$B39CE8)
04: Jump(target=$B3938A)
05: StopOrDisableCCSlot()
; stop: stop_or_wait_opcode_$10
```

#### Entry 01 at `$B39D05`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B39D14)
02: StartNestedScriptSlot(slot=$02, target=$B39E2A)
03: WaitOrSetCCCounter(value=$0001)
04: Jump(target=$B39D0E)
05: SpawnOrMoveCCObject(x=$00A8, y=$0078, visual=$8300, mode=$00)
06: SetCCObjectBoxOrAnim(a=$1020, b=$0C01, c=$83, d=$14)
07: SetCCObjectAndJump(target=$B39D41)
08: SetCCObjectParam4(a=$5E, ptr=$489D, d=$9D)
09: Jump(target=$B39D23)
10: SetCCObjectAndJump(target=$B39D41)
11: SetCCObjectParam4(a=$BB, ptr=$489D, d=$9D)
12: Jump(target=$B39D2E)
13: SetCCObjectParam4(a=$09, ptr=$489E, d=$9D)
14: Jump(target=$B39D39)
15: StartTextBox(text_id=$01C9, mode=$00)
...
; stop: unknown_opcode_$CB
```

#### Entry 02 at `$B39F3E`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B39F49)
02: WaitOrSetCCCounter(value=$0001)
03: Jump(target=$B39F43)
04: SpawnOrMoveCCObject(x=$0068, y=$00E8, visual=$8354, mode=$00)
05: SetCCObjectAndJump(target=$B39F7D)
06: SetCCObjectParam4(a=$9A, ptr=$849F, d=$9F)
07: Jump(target=$B39F51)
08: SetCCObjectAndJump(target=$B39F7D)
09: SetCCObjectParam4(a=$9A, ptr=$849F, d=$9F)
10: Jump(target=$B39F5C)
11: SetCCObjectAndJump(target=$B39F7D)
12: SetCCObjectParam4(a=$9A, ptr=$849F, d=$9F)
13: Jump(target=$B39F67)
14: SetCCObjectAndJump(target=$B39F7D)
15: SetCCObjectParam4(a=$74, ptr=$84A0, d=$9F)
...
; stop: next_entry_boundary
```

#### Entry 03 at `$B3A086`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3A091)
02: WaitOrSetCCCounter(value=$0001)
03: Jump(target=$B3A08B)
04: SpawnOrMoveCCObject(x=$0028, y=$0168, visual=$83FC, mode=$02)
05: SetCCObjectAndJump(target=$B3A0A4)
06: SetCCObjectParam4(a=$C9, ptr=$ABA0, d=$A0)
07: Jump(target=$B3A099)
08: StartTextBox(text_id=$01C6, mode=$00)
09: Jump(target=$B3A099)
10: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3A0BE)
11: StartTextBox(text_id=$0200, mode=$00)
12: SetCCObjectParam(param=$02D0, value=$01)
13: Jump(target=$B3A099)
14: StartTextBox(text_id=$03B9, mode=$00)
15: SetCCObjectParam(param=$02D0, value=$01)
...
; stop: next_entry_boundary
```

#### Entry 04 at `$B3A162`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3A17E)
02: Jump(target=$B3A170)
03: WaitOrSetCCCounter(value=$0001)
04: Jump(target=$B3A16A)
05: JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B3A17B)
06: StartNestedScriptSlot(slot=$02, target=$B3A26D)
07: Jump(target=$B3A16A)
08: SpawnOrMoveCCObject(x=$0028, y=$0168, visual=$8318, mode=$02)
09: SetCCObjectAndJump(target=$B3A197)
10: SetCCObjectParam4(a=$BC, ptr=$9EA1, d=$A1)
11: Jump(target=$B3A186)
12: SetCCObjectParam2D()
13: UnknownOpcode_$62()
; stop: unknown_opcode_$62
```

#### Entry 05 at `$B3A438`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3A459)
02: StartNestedScriptSlot(slot=$02, target=$B3A538)
03: JumpIfFlagSet(mem=$7F1F6C, bit=$02, target=$B3A453)
04: JumpIfFlagSet(mem=$7F1F6C, bit=$03, target=$B3A453)
05: StartNestedScriptSlot(slot=$03, target=$B3A5A3)
06: WaitOrSetCCCounter(value=$0001)
07: Jump(target=$B3A453)
08: SpawnOrMoveCCObject(x=$0028, y=$0198, visual=$8330, mode=$02)
09: SetCCObjectAndJump(target=$B3A475)
10: SetCCObjectParam4(a=$9A, ptr=$7CA4, d=$A4)
11: Jump(target=$B3A461)
12: SetCCObjectAndJump(target=$B3A475)
13: SetCCObjectParam2D()
14: UnknownOpcode_$A8()
; stop: unknown_opcode_$A8
```

#### Entry 06 at `$B3A5B1`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3A5BC)
02: WaitOrSetCCCounter(value=$0001)
03: Jump(target=$B3A5B6)
04: SpawnOrMoveCCObject(x=$0088, y=$0050, visual=$82E8, mode=$00)
05: SetCCObjectAndJump(target=$B3A5E1)
06: SetCCObjectParam4(a=$0A, ptr=$ECA6, d=$A5)
07: Jump(target=$B3A5C4)
08: SetCCObjectAndJump(target=$B3A5E1)
09: SetCCObjectParam2D()
10: UnknownOpcode_$5C()
; stop: unknown_opcode_$5C
```

#### Entry 07 at `$B3A727`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3A732)
02: WaitOrSetCCCounter(value=$0001)
03: Jump(target=$B3A72C)
04: SpawnOrMoveCCObject(x=$00E8, y=$0098, visual=$836C, mode=$03)
05: SetCCObjectAndJump(target=$B3A74E)
06: SetCCObjectParam4(a=$77, ptr=$59A7, d=$A7)
07: Jump(target=$B3A73A)
08: SetCCObjectAndJump(target=$B3A74E)
09: SetCCObjectParam2D()
10: UnknownOpcode_$A4()
; stop: unknown_opcode_$A4
```

Expanded unique entries shown: 8. See CSV for the complete symbolic index.

### EventScriptGroup_06

#### Entry 00 at `$B3D467`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3D48E)
02: StartNestedScriptSlot(slot=$02, target=$B3D4D0)
03: Jump(target=$B3D479)
04: WaitOrSetCCCounter(value=$0001)
05: Jump(target=$B3D473)
06: JumpIfFlagSet(mem=$7F1F66, bit=$00, target=$B3D48B)
07: JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3D48B)
08: StartNestedScriptSlot(slot=$03, target=$B3D50B)
09: Jump(target=$B3D473)
10: SpawnOrMoveCCObject(x=$00A8, y=$0078, visual=$830C, mode=$00)
11: SetCCObjectBoxOrAnim(a=$1820, b=$0C01, c=$83, d=$10)
12: SetCCObjectParam4(a=$BB, ptr=$A5D4, d=$D4)
13: Jump(target=$B3D49D)
14: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3D4B4)
15: StartTextBox(text_id=$0200, mode=$00)
...
; stop: next_entry_boundary
```

#### Entry 01 at `$B3D59D`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3D5A8)
02: WaitOrSetCCCounter(value=$0001)
03: Jump(target=$B3D5A2)
04: SpawnOrMoveCCObject(x=$0068, y=$00E8, visual=$8354, mode=$00)
05: SetCCObjectParam4(a=$CE, ptr=$B8D5, d=$D5)
06: Jump(target=$B3D5B0)
07: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3D5C7)
08: StartTextBox(text_id=$0200, mode=$00)
09: Jump(target=$B3D5B0)
10: StartTextBox(text_id=$03B0, mode=$00)
11: Jump(target=$B3D5B0)
12: JumpIfFlagSet(mem=$7F1F64, bit=$05, target=$B3D5DC)
13: StartTextBox(text_id=$015A, mode=$00)
14: Jump(target=$B3D5B0)
15: StartTextBox(text_id=$016F, mode=$00)
...
; stop: next_entry_boundary
```

#### Entry 02 at `$B3D5E3`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3D606)
02: Jump(target=$B3D5F1)
03: WaitOrSetCCCounter(value=$0001)
04: Jump(target=$B3D5EB)
05: JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B3D603)
06: JumpIfFlagSet(mem=$7F1F6C, bit=$00, target=$B3D603)
07: StartNestedScriptSlot(slot=$02, target=$B3D641)
08: Jump(target=$B3D5EB)
09: SpawnOrMoveCCObject(x=$0028, y=$0168, visual=$83FC, mode=$02)
10: SetCCObjectParam4(a=$2C, ptr=$16D6, d=$D6)
11: Jump(target=$B3D60E)
12: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3D625)
13: StartTextBox(text_id=$0200, mode=$00)
14: Jump(target=$B3D60E)
15: StartTextBox(text_id=$03B9, mode=$00)
...
; stop: next_entry_boundary
```

#### Entry 03 at `$B3D6CF`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3D6EB)
02: Jump(target=$B3D6DD)
03: WaitOrSetCCCounter(value=$0001)
04: Jump(target=$B3D6D7)
05: JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B3D6E8)
06: StartNestedScriptSlot(slot=$02, target=$B3D726)
07: Jump(target=$B3D6D7)
08: SpawnOrMoveCCObject(x=$0028, y=$0168, visual=$8318, mode=$00)
09: SetCCObjectParam4(a=$11, ptr=$FBD7, d=$D6)
10: Jump(target=$B3D6F3)
11: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3D70A)
12: StartTextBox(text_id=$0200, mode=$00)
13: Jump(target=$B3D6F3)
14: StartTextBox(text_id=$0049, mode=$00)
15: Jump(target=$B3D6F3)
...
; stop: next_entry_boundary
```

#### Entry 04 at `$B3D7C9`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3D805)
02: JumpIfFlagSet(mem=$7F1F6C, bit=$02, target=$B3D7E9)
03: JumpIfFlagSet(mem=$7F1F6C, bit=$03, target=$B3D7E9)
04: StartNestedScriptSlot(slot=$03, target=$B3D7F7)
05: Jump(target=$B3D7E9)
06: WaitOrSetCCCounter(value=$0001)
07: Jump(target=$B3D7E3)
08: JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B3D7F4)
09: StartNestedScriptSlot(slot=$02, target=$B3D85E)
10: Jump(target=$B3D7E3)
11: SpawnOrMoveCCObject(x=$0087, y=$0097, visual=$8558, mode=$00)
12: WaitOrSetCCCounter(value=$0001)
13: Jump(target=$B3D7FF)
14: SpawnOrMoveCCObject(x=$0028, y=$0198, visual=$8330, mode=$02)
15: SetCCObjectParam4(a=$2B, ptr=$15D8, d=$D8)
...
; stop: next_entry_boundary
```

#### Entry 05 at `$B3D90E`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3D91D)
02: StartNestedScriptSlot(slot=$02, target=$B3D958)
03: WaitOrSetCCCounter(value=$0001)
04: Jump(target=$B3D917)
05: SpawnOrMoveCCObject(x=$0088, y=$0050, visual=$82E8, mode=$00)
06: SetCCObjectParam4(a=$43, ptr=$2DD9, d=$D9)
07: Jump(target=$B3D925)
08: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3D93C)
09: StartTextBox(text_id=$0200, mode=$00)
10: Jump(target=$B3D925)
11: StartTextBox(text_id=$03BB, mode=$00)
12: Jump(target=$B3D925)
13: JumpIfFlagSet(mem=$7F1F64, bit=$05, target=$B3D951)
14: StartTextBox(text_id=$015E, mode=$00)
15: Jump(target=$B3D925)
...
; stop: stop_or_wait_opcode_$10
```

#### Entry 06 at `$B3D99B`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3D9A6)
02: WaitOrSetCCCounter(value=$0001)
03: Jump(target=$B3D9A0)
04: SpawnOrMoveCCObject(x=$00E8, y=$009C, visual=$8378, mode=$03)
05: SetCCObjectParam4(a=$CC, ptr=$B6D9, d=$D9)
06: Jump(target=$B3D9AE)
07: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3D9C5)
08: StartTextBox(text_id=$0200, mode=$00)
09: Jump(target=$B3D9AE)
10: StartTextBox(text_id=$03BB, mode=$00)
11: Jump(target=$B3D9AE)
12: JumpIfFlagSet(mem=$7F1F64, bit=$05, target=$B3D9F0)
13: StartTextBoxCopy(text_id=$015B, mode=$00)
14: JumpIf018F(value=$00, target=$B3D9E2)
15: JumpIf018F(value=$01, target=$B3D9E9)
...
; stop: next_entry_boundary
```

#### Entry 07 at `$B3D9F7` / duplicate refs: 9

```text
00: GetRNG(value=$DA)
01: UnknownOpcode_$72()
; stop: unknown_opcode_$72
```

Expanded unique entries shown: 8. See CSV for the complete symbolic index.

### EventScriptGroup_08

#### Entry 00 at `$B3E0DF`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3E102)
02: Jump(target=$B3E0ED)
03: WaitOrSetCCCounter(value=$0001)
04: Jump(target=$B3E0E7)
05: JumpIfFlagSet(mem=$7F1F66, bit=$00, target=$B3E0FF)
06: JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3E0FF)
07: StartNestedScriptSlot(slot=$02, target=$B3E12F)
08: Jump(target=$B3E0E7)
09: SpawnOrMoveCCObject(x=$0188, y=$00A0, visual=$83F0, mode=$00)
10: SetCCObjectParam4(a=$28, ptr=$12E1, d=$E1)
11: Jump(target=$B3E10A)
12: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3E121)
13: StartTextBox(text_id=$0200, mode=$00)
14: Jump(target=$B3E10A)
15: StartTextBox(text_id=$03B9, mode=$00)
...
; stop: next_entry_boundary
```

#### Entry 01 at `$B3E1C9`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3E1D8)
02: StartNestedScriptSlot(slot=$02, target=$B3E205)
03: WaitOrSetCCCounter(value=$0001)
04: Jump(target=$B3E1D2)
05: SpawnOrMoveCCObject(x=$0068, y=$00E8, visual=$8354, mode=$02)
06: SetCCObjectParam4(a=$FE, ptr=$E8E1, d=$E1)
07: Jump(target=$B3E1E0)
08: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3E1F7)
09: StartTextBox(text_id=$0200, mode=$00)
10: Jump(target=$B3E1E0)
11: StartTextBox(text_id=$03B0, mode=$00)
12: Jump(target=$B3E1E0)
13: StartTextBox(text_id=$0411, mode=$00)
14: Jump(target=$B3E1E0)
15: SpawnOrMoveCCObject(x=$0078, y=$00E8, visual=$8300, mode=$03)
...
; stop: next_entry_boundary
```

#### Entry 02 at `$B3E232`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3E255)
02: Jump(target=$B3E240)
03: WaitOrSetCCCounter(value=$0001)
04: Jump(target=$B3E23A)
05: JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B3E252)
06: JumpIfFlagSet(mem=$7F1F6C, bit=$00, target=$B3E252)
07: StartNestedScriptSlot(slot=$02, target=$B3E282)
08: Jump(target=$B3E23A)
09: SpawnOrMoveCCObject(x=$0028, y=$0168, visual=$83FC, mode=$02)
10: SetCCObjectParam4(a=$7B, ptr=$65E2, d=$E2)
11: Jump(target=$B3E25D)
12: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3E274)
13: StartTextBox(text_id=$0200, mode=$00)
14: Jump(target=$B3E25D)
15: StartTextBox(text_id=$03B9, mode=$00)
...
; stop: next_entry_boundary
```

#### Entry 03 at `$B3E31F`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3E33B)
02: Jump(target=$B3E32D)
03: WaitOrSetCCCounter(value=$0001)
04: Jump(target=$B3E327)
05: JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B3E338)
06: StartNestedScriptSlot(slot=$02, target=$B3E368)
07: Jump(target=$B3E327)
08: SpawnOrMoveCCObject(x=$0028, y=$0168, visual=$8318, mode=$02)
09: SetCCObjectParam4(a=$61, ptr=$4BE3, d=$E3)
10: Jump(target=$B3E343)
11: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3E35A)
12: StartTextBox(text_id=$0200, mode=$00)
13: Jump(target=$B3E343)
14: StartTextBox(text_id=$0049, mode=$00)
15: Jump(target=$B3E343)
...
; stop: next_entry_boundary
```

#### Entry 04 at `$B3E413`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3E453)
02: StartNestedScriptSlot(slot=$02, target=$B3E483)
03: JumpIfFlagSet(mem=$7F1F6C, bit=$02, target=$B3E437)
04: JumpIfFlagSet(mem=$7F1F6C, bit=$03, target=$B3E437)
05: StartNestedScriptSlot(slot=$04, target=$B3E445)
06: Jump(target=$B3E437)
07: WaitOrSetCCCounter(value=$0001)
08: Jump(target=$B3E431)
09: JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B3E442)
10: StartNestedScriptSlot(slot=$03, target=$B3E4A5)
11: Jump(target=$B3E431)
12: SpawnOrMoveCCObject(x=$0087, y=$0097, visual=$8558, mode=$00)
13: WaitOrSetCCCounter(value=$0001)
14: Jump(target=$B3E44D)
15: SpawnOrMoveCCObject(x=$0028, y=$0198, visual=$8330, mode=$02)
...
; stop: next_entry_boundary
```

#### Entry 05 at `$B3E4ED`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3E4FE)
02: StartNestedScriptSlot(slot=$02, target=$B3E52B)
03: ScreenFadeIn(param=$01)
04: WaitOrSetCCCounter(value=$0001)
05: Jump(target=$B3E4F8)
06: SpawnOrMoveCCObject(x=$0088, y=$0050, visual=$82E8, mode=$00)
07: SetCCObjectParam4(a=$24, ptr=$0EE5, d=$E5)
08: Jump(target=$B3E506)
09: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3E51D)
10: StartTextBox(text_id=$0200, mode=$00)
11: Jump(target=$B3E506)
12: StartTextBox(text_id=$03BB, mode=$00)
13: Jump(target=$B3E506)
14: StartTextBox(text_id=$0168, mode=$00)
15: Jump(target=$B3E506)
...
; stop: stop_or_wait_opcode_$10
```

#### Entry 06 at `$B3E560`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3E56D)
02: ScreenFadeIn(param=$01)
03: WaitOrSetCCCounter(value=$0001)
04: Jump(target=$B3E567)
05: SpawnOrMoveCCObject(x=$00E8, y=$009C, visual=$836C, mode=$03)
06: SetCCObjectParam4(a=$93, ptr=$7DE5, d=$E5)
07: Jump(target=$B3E575)
08: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3E58C)
09: StartTextBox(text_id=$0200, mode=$00)
10: Jump(target=$B3E575)
11: StartTextBox(text_id=$03BB, mode=$00)
12: Jump(target=$B3E575)
13: StartTextBox(text_id=$016C, mode=$00)
14: Jump(target=$B3E575)
; stop: next_entry_boundary
```

#### Entry 07 at `$B3E59A`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3E5D6)
02: StartNestedScriptSlot(slot=$02, target=$B3E5A9)
03: WaitOrSetCCCounter(value=$0001)
04: Jump(target=$B3E5A3)
05: SpawnOrMoveCCObject(x=$0058, y=$00B8, visual=$8234, mode=$00)
06: SetCCObjectParam4(a=$CF, ptr=$B9E5, d=$E5)
07: Jump(target=$B3E5B1)
08: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3E5C8)
09: StartTextBox(text_id=$03BC, mode=$00)
10: Jump(target=$B3E5B1)
11: StartTextBox(text_id=$03BB, mode=$00)
12: Jump(target=$B3E5B1)
13: StartTextBox(text_id=$0414, mode=$00)
14: Jump(target=$B3E5B1)
15: SpawnOrMoveCCObject(x=$0098, y=$0088, visual=$8234, mode=$00)
...
; stop: next_entry_boundary
```

Expanded unique entries shown: 8. See CSV for the complete symbolic index.

### EventScriptGroup_02

#### Entry 00 at `$B3AE23`

```text
00: ChangeGameState2()
01: JumpIfEqualsByte(mem=$7F1F19, value=$02, target=$B3AE36)
02: StartNestedScriptSlot(slot=$01, target=$B3AECD)
03: StartNestedScriptSlot(slot=$02, target=$B3AF5A)
04: Jump(target=$B3AE3E)
05: StartNestedScriptSlot(slot=$01, target=$B3AE6C)
06: StartNestedScriptSlot(slot=$02, target=$B3AF0F)
07: StartNestedScriptSlot(slot=$03, target=$B3AF9C)
08: StartNestedScriptSlot(slot=$04, target=$B3B008)
09: StartNestedScriptSlot(slot=$05, target=$B3B07F)
10: Jump(target=$B3AE53)
11: WaitOrSetCCCounter(value=$0001)
12: Jump(target=$B3AE4D)
13: JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B3AE5E)
14: StartNestedScriptSlot(slot=$06, target=$B3B0EF)
15: JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B3AE69)
...
; stop: stop_or_wait_opcode_$10
```

#### Entry 01 at `$B3B44A`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3B459)
02: StartNestedScriptSlot(slot=$02, target=$B3B49E)
03: WaitOrSetCCCounter(value=$0001)
04: Jump(target=$B3B453)
05: SpawnOrMoveCCObject(x=$00A8, y=$0078, visual=$8300, mode=$00)
06: SetCCObjectAndJump(target=$B3B46C)
07: SetCCObjectParam4(a=$89, ptr=$73B4, d=$B4)
08: Jump(target=$B3B461)
09: StartTextBox(text_id=$01C9, mode=$00)
10: Jump(target=$B3B461)
11: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B3B482)
12: StartTextBox(text_id=$0200, mode=$00)
13: Jump(target=$B3B461)
14: StartTextBox(text_id=$03B8, mode=$00)
15: Jump(target=$B3B461)
...
; stop: next_entry_boundary
```

#### Entry 02 at `$B3B4E3`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3B50A)
02: StartNestedScriptSlot(slot=$02, target=$B3B54F)
03: Jump(target=$B3B4F5)
04: WaitOrSetCCCounter(value=$0001)
05: Jump(target=$B3B4EF)
06: JumpIfFlagSet(mem=$7F1F66, bit=$00, target=$B3B507)
07: JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3B507)
08: StartNestedScriptSlot(slot=$03, target=$B3B5CE)
09: Jump(target=$B3B4EF)
10: SpawnOrMoveCCObject(x=$0088, y=$0090, visual=$8354, mode=$00)
11: SetCCObjectAndJump(target=$B3B51D)
12: SetCCObjectParam4(a=$3A, ptr=$24B5, d=$B5)
13: Jump(target=$B3B512)
14: StartTextBox(text_id=$01E0, mode=$00)
15: Jump(target=$B3B4A6)
...
; stop: stop_or_wait_opcode_$10
```

#### Entry 03 at `$B3B6E1`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3B70F)
02: JumpIfFlagSet(mem=$7F1F6C, bit=$04, target=$B3B6FA)
03: StartNestedScriptSlot(slot=$02, target=$B3B79E)
04: Jump(target=$B3B6FA)
05: WaitOrSetCCCounter(value=$0001)
06: Jump(target=$B3B6F4)
07: JumpIfFlagSet(mem=$7F1F66, bit=$04, target=$B3B70C)
08: JumpIfFlagSet(mem=$7F1F6C, bit=$04, target=$B3B70C)
09: StartNestedScriptSlot(slot=$03, target=$B3B7DE)
10: Jump(target=$B3B6F4)
11: JumpIfBetweenByte(mem=$7F1F1C, low=$11, high=$12, target=$B3B79D)
12: JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B3B79D)
13: SpawnOrMoveCCObject(x=$0258, y=$0178, visual=$8270, mode=$00)
14: SetCCObjectAndJump(target=$B3B73C)
15: SetCCObjectParam4(a=$59, ptr=$43B7, d=$B7)
...
; stop: stop_or_wait_opcode_$10
```

#### Entry 04 at `$B3B8D2`

```text
00: ChangeGameState2()
01: Jump(target=$B3B8DC)
02: WaitOrSetCCCounter(value=$0001)
03: Jump(target=$B3B8D6)
04: JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B3B8EE)
05: JumpIfFlagSet(mem=$7F1F6C, bit=$00, target=$B3B8EE)
06: StartNestedScriptSlot(slot=$01, target=$B3B8F1)
07: Jump(target=$B3B8D6)
08: JumpIfBetweenByte(mem=$7F1F1C, low=$11, high=$12, target=$B3BA38)
09: SpawnOrMoveCCObject(x=$0058, y=$01A8, visual=$81D4, mode=$00)
10: SetCCObjectBoxOrAnim(a=$1018, b=$D401, c=$81, d=$10)
11: SetCCObjectAndJump(target=$B3B925)
12: SetCCObjectParam4(a=$C0, ptr=$3DB9, d=$B9)
13: Jump(target=$B3B908)
14: SetCCObjectAndJump(target=$B3B925)
15: SetCCObjectParam2D()
...
; stop: unknown_opcode_$F3
```

#### Entry 05 at `$B3BA39` / duplicate refs: 11

```text
00: UnknownOpcode_$59()
; stop: unknown_opcode_$59
```

Expanded unique entries shown: 6. See CSV for the complete symbolic index.

### EventScriptGroup_43

#### Entry 00 at `$B58020`

```text
00: JumpIfFlagSet(mem=$800196, bit=$01, target=$B58036)
01: JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B58036)
02: JumpIfBetweenByte(mem=$7F1F1C, low=$0B, high=$0E, target=$B584D4)
03: JumpIfEqualsByte(mem=$7F1F1C, value=$12, target=$B5805A)
04: JumpIfFlagSet(mem=$7F1F64, bit=$07, target=$B5804F)
05: SpawnOrMoveCCObject(x=$0058, y=$0068, visual=$845C, mode=$00)
06: Jump(target=$B58087)
07: SpawnOrMoveCCObject(x=$0148, y=$0078, visual=$845C, mode=$00)
08: Jump(target=$B58087)
09: SetCCObjectParam8(a=$1F, b=$1F, c=$7F, d=$FE, e=$FF)
10: JumpIfFlagSet(mem=$7F1F64, bit=$07, target=$B58077)
11: SpawnOrMoveCCObject(x=$0029, y=$0053, visual=$8468, mode=$00)
12: SetFlag(mem=$7F1F5E, bit=$0C)
13: Jump(target=$B58096)
14: SpawnOrMoveCCObject(x=$0119, y=$0063, visual=$8468, mode=$00)
15: SetFlag(mem=$7F1F5E, bit=$0C)
...
; stop: unknown_opcode_$CD
```

#### Entry 01 at `$B584DA`

```text
00: JumpIfFlagSet(mem=$800196, bit=$01, target=$B584F0)
01: JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B584F0)
02: JumpIfBetweenByte(mem=$7F1F1C, low=$0B, high=$0E, target=$B5898A)
03: JumpIfEqualsByte(mem=$7F1F1C, value=$12, target=$B58514)
04: JumpIfFlagSet(mem=$7F1F64, bit=$07, target=$B58509)
05: SpawnOrMoveCCObject(x=$0058, y=$0068, visual=$845C, mode=$00)
06: Jump(target=$B58541)
07: SpawnOrMoveCCObject(x=$0148, y=$0078, visual=$845C, mode=$00)
08: Jump(target=$B58541)
09: SetCCObjectParam8(a=$21, b=$1F, c=$7F, d=$FE, e=$FF)
10: JumpIfFlagSet(mem=$7F1F64, bit=$07, target=$B58531)
11: SpawnOrMoveCCObject(x=$0029, y=$0053, visual=$8468, mode=$00)
12: SetFlag(mem=$7F1F5E, bit=$0C)
13: Jump(target=$B58550)
14: SpawnOrMoveCCObject(x=$0119, y=$0063, visual=$8468, mode=$00)
15: SetFlag(mem=$7F1F5E, bit=$0C)
...
; stop: unknown_opcode_$83
```

#### Entry 02 at `$B58990`

```text
00: JumpIfFlagSet(mem=$800196, bit=$01, target=$B589A6)
01: JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B589A6)
02: JumpIfBetweenByte(mem=$7F1F1C, low=$0B, high=$0E, target=$B58E48)
03: JumpIfEqualsByte(mem=$7F1F1C, value=$12, target=$B589CA)
04: JumpIfFlagSet(mem=$7F1F64, bit=$07, target=$B589BF)
05: SpawnOrMoveCCObject(x=$0058, y=$0068, visual=$845C, mode=$00)
06: Jump(target=$B589F7)
07: SpawnOrMoveCCObject(x=$0148, y=$0078, visual=$845C, mode=$00)
08: Jump(target=$B589F7)
09: SetCCObjectParam8(a=$23, b=$1F, c=$7F, d=$FE, e=$FF)
10: JumpIfFlagSet(mem=$7F1F64, bit=$07, target=$B589E7)
11: SpawnOrMoveCCObject(x=$0029, y=$0053, visual=$8468, mode=$00)
12: SetFlag(mem=$7F1F5E, bit=$0C)
13: Jump(target=$B58A06)
14: SpawnOrMoveCCObject(x=$0119, y=$0063, visual=$8468, mode=$00)
15: SetFlag(mem=$7F1F5E, bit=$0C)
...
; stop: unknown_opcode_$68
```

#### Entry 03 at `$B58E4E`

```text
00: JumpIfFlagSet(mem=$800196, bit=$01, target=$B58E64)
01: JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B58E64)
02: JumpIfBetweenByte(mem=$7F1F1C, low=$0B, high=$0E, target=$B5930D)
03: JumpIfEqualsByte(mem=$7F1F1C, value=$12, target=$B58E88)
04: JumpIfFlagSet(mem=$7F1F64, bit=$07, target=$B58E7D)
05: SpawnOrMoveCCObject(x=$0058, y=$0068, visual=$845C, mode=$00)
06: Jump(target=$B58EB5)
07: SpawnOrMoveCCObject(x=$0148, y=$0078, visual=$845C, mode=$00)
08: Jump(target=$B58EB5)
09: SetCCObjectParam8(a=$25, b=$1F, c=$7F, d=$FE, e=$FF)
10: JumpIfFlagSet(mem=$7F1F64, bit=$07, target=$B58EA5)
11: SpawnOrMoveCCObject(x=$0029, y=$0053, visual=$8468, mode=$00)
12: SetFlag(mem=$7F1F5E, bit=$0C)
13: Jump(target=$B58EC4)
14: SpawnOrMoveCCObject(x=$0119, y=$0063, visual=$8468, mode=$00)
15: SetFlag(mem=$7F1F5E, bit=$0C)
...
; stop: unknown_opcode_$55
```

#### Entry 04 at `$B59313`

```text
00: JumpIfFlagSet(mem=$800196, bit=$01, target=$B59329)
01: JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B59329)
02: JumpIfBetweenByte(mem=$7F1F1C, low=$0B, high=$0E, target=$B597CB)
03: JumpIfEqualsByte(mem=$7F1F1C, value=$12, target=$B5934D)
04: JumpIfFlagSet(mem=$7F1F64, bit=$07, target=$B59342)
05: SpawnOrMoveCCObject(x=$0058, y=$0068, visual=$845C, mode=$00)
06: Jump(target=$B5937A)
07: SpawnOrMoveCCObject(x=$0148, y=$0078, visual=$845C, mode=$00)
08: Jump(target=$B5937A)
09: SetCCObjectParam8(a=$27, b=$1F, c=$7F, d=$FE, e=$FF)
10: JumpIfFlagSet(mem=$7F1F64, bit=$07, target=$B5936A)
11: SpawnOrMoveCCObject(x=$0029, y=$0053, visual=$8468, mode=$00)
12: SetFlag(mem=$7F1F5E, bit=$0C)
13: Jump(target=$B59389)
14: SpawnOrMoveCCObject(x=$0119, y=$0063, visual=$8468, mode=$00)
15: SetFlag(mem=$7F1F5E, bit=$0C)
...
; stop: unknown_opcode_$C4
```

#### Entry 05 at `$B597D1` / duplicate refs: 11

```text
00: UnknownOpcode_$F1()
; stop: unknown_opcode_$F1
```

Expanded unique entries shown: 6. See CSV for the complete symbolic index.

### EventScriptGroup_45

#### Entry 00 at `$B5A205`

```text
00: JumpIfFlagSet(mem=$800196, bit=$01, target=$B5A21B)
01: JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B5A21B)
02: JumpIfBetweenByte(mem=$7F1F1C, low=$0B, high=$0E, target=$B5A406)
03: JumpIfBetweenValue(mem=$7F1F37, low=$0000, high=$0059, target=$B5A2F1)
04: JumpIfBetweenByte(mem=$7F1F1C, low=$0F, high=$12, target=$B5A2B4)
05: JumpIfBetweenValue(mem=$7F1F37, low=$0078, high=$03E7, target=$B5A2BF)
06: SpawnOrMoveCCObject(x=$0158, y=$0098, visual=$84A4, mode=$00)
07: SetCCObjectBoxOrAnim(a=$1010, b=$A401, c=$84, d=$04)
08: SetCCObjectParam4(a=$99, ptr=$54A2, d=$A2)
09: Jump(target=$B5A246)
10: WaitOrSetCCCounter(value=$0001)
11: Jump(target=$B5A24E)
12: JumpIfEqualsByte(mem=$80091E, value=$06, target=$B5A26A)
13: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B5A292)
14: StartTextBox(text_id=$01C2, mode=$00)
15: Jump(target=$B5A246)
...
; stop: unknown_opcode_$52
```

#### Entry 01 at `$B5A2FD`

```text
00: JumpIfBetweenValue(mem=$7F1F37, low=$0000, high=$0059, target=$B5A406)
01: JumpIfFlagSet(mem=$7F1F66, bit=$00, target=$B5A32D)
02: JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B5A330)
03: JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B5A333)
04: JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B5A336)
05: JumpIfFlagSet(mem=$7F1F66, bit=$04, target=$B5A339)
06: Jump(target=$B5A33C)
07: Jump(target=$B5A33D)
08: Jump(target=$B5A33C)
09: Jump(target=$B5A380)
10: Jump(target=$B5A3C3)
11: Jump(target=$B5A33C)
12: StopOrDisableCCSlot()
; stop: stop_or_wait_opcode_$10
```

#### Entry 02 at `$B5A407`

```text
00: JumpIfBetweenValue(mem=$7F1F37, low=$0000, high=$0059, target=$B5A440)
01: JumpIfFlagSet(mem=$7F1F66, bit=$00, target=$B5A437)
02: JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B5A438)
03: JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B5A43B)
04: JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B5A43C)
05: JumpIfFlagSet(mem=$7F1F66, bit=$04, target=$B5A43D)
06: Jump(target=$B5A440)
07: StopOrDisableCCSlot()
; stop: stop_or_wait_opcode_$10
```

#### Entry 03 at `$B5A484`

```text
00: JumpIfFlagSet(mem=$800196, bit=$01, target=$B5A49A)
01: JumpIfEqualsByte(mem=$7F1F19, value=$03, target=$B5A49A)
02: JumpIfBetweenByte(mem=$7F1F1C, low=$0B, high=$0E, target=$B5A685)
03: JumpIfBetweenValue(mem=$7F1F39, low=$0000, high=$0059, target=$B5A570)
04: JumpIfBetweenByte(mem=$7F1F1C, low=$0F, high=$12, target=$B5A533)
05: JumpIfBetweenValue(mem=$7F1F39, low=$0078, high=$03E7, target=$B5A53E)
06: SpawnOrMoveCCObject(x=$0168, y=$0088, visual=$8498, mode=$02)
07: SetCCObjectBoxOrAnim(a=$1010, b=$A401, c=$84, d=$04)
08: SetCCObjectParam4(a=$18, ptr=$D3A5, d=$A4)
09: Jump(target=$B5A4C5)
10: WaitOrSetCCCounter(value=$0001)
11: Jump(target=$B5A4CD)
12: JumpIfEqualsByte(mem=$80091E, value=$06, target=$B5A4E9)
13: JumpIfBetweenByte(mem=$80091E, low=$09, high=$0C, target=$B5A511)
14: StartTextBox(text_id=$01C2, mode=$00)
15: Jump(target=$B5A4C5)
...
; stop: unknown_opcode_$53
```

#### Entry 04 at `$B5A57C`

```text
00: JumpIfBetweenValue(mem=$7F1F39, low=$0000, high=$0059, target=$B5A685)
01: JumpIfFlagSet(mem=$7F1F66, bit=$00, target=$B5A5AC)
02: JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B5A5AF)
03: JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B5A5B2)
04: JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B5A5B5)
05: JumpIfFlagSet(mem=$7F1F66, bit=$04, target=$B5A5B8)
06: Jump(target=$B5A5BB)
07: Jump(target=$B5A5BC)
08: Jump(target=$B5A5BB)
09: Jump(target=$B5A5FF)
10: Jump(target=$B5A642)
11: Jump(target=$B5A5BB)
12: StopOrDisableCCSlot()
; stop: stop_or_wait_opcode_$10
```

#### Entry 05 at `$B5A686`

```text
00: JumpIfBetweenValue(mem=$7F1F39, low=$0000, high=$0059, target=$B5A6BF)
01: JumpIfFlagSet(mem=$7F1F66, bit=$00, target=$B5A6B6)
02: JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B5A6B7)
03: JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B5A6BA)
04: JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B5A6BB)
05: JumpIfFlagSet(mem=$7F1F66, bit=$04, target=$B5A6BC)
06: Jump(target=$B5A6BF)
07: StopOrDisableCCSlot()
; stop: stop_or_wait_opcode_$10
```

#### Entry 06 at `$B5A703` / duplicate refs: 10

```text
00: SetFlag(mem=$A73DA7, bit=$57)
01: UnknownOpcode_$A7()
; stop: unknown_opcode_$A7
```

Expanded unique entries shown: 7. See CSV for the complete symbolic index.

### EventScriptGroup_03

#### Entry 00 at `$B3BA59`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3BB19)
02: StartNestedScriptSlot(slot=$02, target=$B3BBBB)
03: StartNestedScriptSlot(slot=$03, target=$B3BC06)
04: StartNestedScriptSlot(slot=$04, target=$B3BC51)
05: StartNestedScriptSlot(slot=$05, target=$B3BCB9)
06: JumpIfFlagSet(mem=$7F1F6C, bit=$06, target=$B3BAB8)
07: JumpIfFlagSet(mem=$7F1F64, bit=$06, target=$B3BA7F)
08: Jump(target=$B3BAB8)
09: JumpIfBetweenValue(mem=$7F1F1F, low=$00FA, high=$03E7, target=$B3BAB4)
10: JumpIfBetweenValue(mem=$7F1F21, low=$00FA, high=$03E7, target=$B3BAB4)
11: JumpIfBetweenValue(mem=$7F1F23, low=$00FA, high=$03E7, target=$B3BAB4)
12: JumpIfBetweenValue(mem=$7F1F25, low=$00FA, high=$03E7, target=$B3BAB4)
13: JumpIfBetweenValue(mem=$7F1F27, low=$00FA, high=$03E7, target=$B3BAB4)
14: Jump(target=$B3BAB8)
15: StartNestedScriptSlot(slot=$06, target=$B3BAC5)
...
; stop: unknown_opcode_$DB
```

#### Entry 01 at `$B3BD2D`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3BD7A)
02: StartNestedScriptSlot(slot=$02, target=$B3BDBF)
03: StartNestedScriptSlot(slot=$03, target=$B3BE18)
04: StartNestedScriptSlot(slot=$04, target=$B3BE71)
05: StartNestedScriptSlot(slot=$05, target=$B3BECA)
06: StartNestedScriptSlot(slot=$06, target=$B3BF01)
07: Jump(target=$B3BD4F)
08: WaitOrSetCCCounter(value=$0001)
09: Jump(target=$B3BD49)
10: JumpIfFlagSet(mem=$7F1F66, bit=$00, target=$B3BD61)
11: JumpIfFlagSet(mem=$7F1F6A, bit=$0C, target=$B3BD61)
12: StartNestedScriptSlot(slot=$09, target=$B3BF5A)
13: JumpIfFlagSet(mem=$7F1F66, bit=$01, target=$B3BD6C)
14: StartNestedScriptSlot(slot=$0A, target=$B3C03A)
15: JumpIfFlagSet(mem=$7F1F66, bit=$03, target=$B3BD77)
...
; stop: max_commands
```

#### Entry 02 at `$B3C1E4`

```text
00: ChangeGameState2()
01: StartNestedScriptSlot(slot=$01, target=$B3C482)
02: JumpIfFlagSet(mem=$7F1F6C, bit=$04, target=$B3C1FD)
03: StartNestedScriptSlot(slot=$02, target=$B3C224)
04: Jump(target=$B3C1FD)
05: WaitOrSetCCCounter(value=$0001)
06: Jump(target=$B3C1F7)
07: JumpIfFlagSet(mem=$7F1F66, bit=$04, target=$B3C20F)
08: JumpIfFlagSet(mem=$7F1F6C, bit=$04, target=$B3C20F)
09: StartNestedScriptSlot(slot=$03, target=$B3C273)
10: JumpIfFlagSet(mem=$7F1F66, bit=$02, target=$B3C221)
11: JumpIfFlagSet(mem=$7F1F6C, bit=$00, target=$B3C221)
12: StartNestedScriptSlot(slot=$04, target=$B3C2DF)
13: Jump(target=$B3C1F7)
14: JumpIfBetweenByte(mem=$7F1F1C, low=$11, high=$12, target=$B3C26B)
15: SpawnOrMoveCCObject(x=$0068, y=$0038, visual=$82D0, mode=$00)
...
; stop: stop_or_wait_opcode_$10
```

#### Entry 03 at `$B3C507` / duplicate refs: 13

```text
00: ResetFlagD(mem=$C6AEC5, bit=$FE)
01: UnknownOpcode_$C6()
; stop: unknown_opcode_$C6
```

Expanded unique entries shown: 4. See CSV for the complete symbolic index.

### EventScriptGroup_47

#### Entry 00 at `$B5ACAE`

```text
00: SetFlag(mem=$7F1F60, bit=$06)
01: PlayAudioOrMusic(id=$01)
02: UnknownOpcode_$B4()
; stop: unknown_opcode_$B4
```

#### Entry 01 at `$B5ACDE`

```text
00: SetFlag(mem=$7F1F60, bit=$06)
01: PlayAudioOrMusic(id=$01)
02: UnknownOpcode_$B4()
; stop: unknown_opcode_$B4
```

#### Entry 02 at `$B5AD25`

```text
00: SetValueByte(mem=$800921, value=$03)
01: SetValueByte(mem=$800923, value=$04)
02: SetFlag(mem=$7F1F60, bit=$06)
03: PlayAudioOrMusic(id=$01)
04: UnknownOpcode_$B4()
; stop: unknown_opcode_$B4
```

#### Entry 03 at `$B5AFF9`

```text
00: SetFlag(mem=$7F1F60, bit=$06)
01: PlayAudioOrMusic(id=$01)
02: UnknownOpcode_$B4()
; stop: unknown_opcode_$B4
```

#### Entry 04 at `$B5B050`

```text
00: UnknownOpcode_$58()
; stop: unknown_opcode_$58
```

#### Entry 05 at `$B5B261`

```text
00: SetFlag(mem=$7F1F60, bit=$06)
01: PlayAudioOrMusic(id=$01)
02: UnknownOpcode_$B4()
; stop: unknown_opcode_$B4
```

#### Entry 06 at `$B5B2B8`

```text
00: UnknownOpcode_$58()
; stop: unknown_opcode_$58
```

#### Entry 07 at `$B5B501`

```text
00: UnknownOpcode_$58()
; stop: unknown_opcode_$58
```

Expanded unique entries shown: 8. See CSV for the complete symbolic index.

