# Pass 57 - EventScript RAM dependency index

This report indexes RAM/flag reads, RAM/flag writes and dialog text id references from B3-B5 EventScript bodies.

- ROM MD5: `c9bf36a816b6d54aed79d43a6c45111a`
- Dependency rows: `1257`
- Unique RAM symbols: `27`

## Global top RAM dependencies

| Symbol | Relation | Count |
|---:|---|---:|
| `$80091E` | read_condition | 175 |
| `$7F1F66` | read_condition | 68 |
| `$7F1F6C` | read_condition | 68 |
| `$7F1F19` | read_condition | 53 |
| `$7F1F1B` | read_condition | 46 |
| `$7F1F64` | read_condition | 36 |
| `$7F1F6A` | read_condition | 35 |
| `$7F1F1C` | read_condition | 35 |
| `$7F1F60` | write_value_or_flag | 23 |
| `$800196` | read_condition | 18 |
| `$7F1F37` | read_condition | 14 |
| `$7F1F39` | read_condition | 14 |
| `$7F1F5E` | write_value_or_flag | 11 |
| `$7F1F1A` | read_condition | 10 |
| `$7F1F1F` | read_condition | 9 |
| `$800921` | write_value_or_flag | 9 |
| `$7F1F25` | read_condition | 9 |
| `$7F1F23` | read_condition | 7 |
| `$80098C` | read_condition | 6 |
| `$7F1F21` | read_condition | 5 |
| `$7F1F5E` | read_condition | 5 |
| `$7F1F5A` | write_value_or_flag | 3 |
| `$7F1F18` | read_condition | 3 |
| `$7F1F27` | read_condition | 3 |
| `$8000D4` | read_condition | 2 |
| `$800926` | write_value_or_flag | 2 |
| `$800923` | write_value_or_flag | 2 |
| `$7F1F66` | write_value_or_flag | 1 |
| `$7F1F3B` | read_condition | 1 |

## Priority group dependency map

### EventScriptGroup_00

Top RAM symbols:

| Symbol | Relation | Count |
|---:|---|---:|
| `$7F1F19` | read_condition | 3 |
| `$8000D4` | read_condition | 2 |
| `$7F1F5A` | write_value_or_flag | 1 |

Top text ids referenced:

| Text id | Count |
|---:|---:|
| `Text_$1293` | 1 |
| `Text_$013A` | 1 |

### EventScriptGroup_44

Top RAM symbols:

| Symbol | Relation | Count |
|---:|---|---:|
| `$80091E` | read_condition | 38 |
| `$7F1F6C` | read_condition | 25 |
| `$7F1F19` | read_condition | 20 |
| `$800196` | read_condition | 10 |
| `$7F1F64` | read_condition | 10 |
| `$7F1F1A` | read_condition | 10 |
| `$7F1F1B` | read_condition | 10 |
| `$7F1F1C` | read_condition | 9 |
| `$7F1F37` | read_condition | 5 |
| `$7F1F39` | read_condition | 5 |
| `$80098C` | read_condition | 5 |
| `$7F1F1F` | read_condition | 2 |

Top text ids referenced:

| Text id | Count |
|---:|---:|
| `Text_$0212` | 9 |
| `Text_$0200` | 5 |
| `Text_$03B2` | 5 |
| `Text_$01BD` | 5 |
| `Text_$041D` | 5 |
| `Text_$041E` | 5 |
| `Text_$0166` | 5 |
| `Text_$015F` | 5 |
| `Text_$0160` | 5 |
| `Text_$0049` | 5 |
| `Text_$047D` | 5 |
| `Text_$0193` | 3 |

### EventScriptGroup_04

Top RAM symbols:

| Symbol | Relation | Count |
|---:|---|---:|
| `$80091E` | read_condition | 40 |
| `$7F1F6A` | read_condition | 8 |
| `$7F1F6C` | read_condition | 7 |
| `$7F1F66` | read_condition | 4 |
| `$7F1F19` | read_condition | 3 |
| `$7F1F1F` | read_condition | 1 |
| `$7F1F23` | read_condition | 1 |
| `$7F1F21` | read_condition | 1 |
| `$7F1F25` | read_condition | 1 |

Top text ids referenced:

| Text id | Count |
|---:|---:|
| `Text_$0200` | 13 |
| `Text_$0212` | 4 |
| `Text_$03B2` | 4 |
| `Text_$03BB` | 4 |
| `Text_$03B0` | 3 |
| `Text_$01C9` | 2 |
| `Text_$01C6` | 2 |
| `Text_$03B9` | 2 |
| `Text_$01D9` | 2 |
| `Text_$01CA` | 2 |
| `Text_$03B4` | 2 |
| `Text_$03BC` | 2 |

### EventScriptGroup_07

Top RAM symbols:

| Symbol | Relation | Count |
|---:|---|---:|
| `$7F1F1B` | read_condition | 22 |
| `$7F1F6A` | read_condition | 8 |
| `$7F1F6C` | read_condition | 8 |
| `$80091E` | read_condition | 7 |
| `$7F1F66` | read_condition | 4 |
| `$7F1F1F` | read_condition | 1 |
| `$7F1F23` | read_condition | 1 |
| `$7F1F21` | read_condition | 1 |
| `$7F1F25` | read_condition | 1 |

Top text ids referenced:

| Text id | Count |
|---:|---:|
| `Text_$0200` | 13 |
| `Text_$03B2` | 3 |
| `Text_$01C9` | 2 |
| `Text_$03EC` | 2 |
| `Text_$01C6` | 2 |
| `Text_$02AE` | 2 |
| `Text_$01CA` | 2 |
| `Text_$01C8` | 2 |
| `Text_$03BC` | 2 |
| `Text_$0393` | 1 |
| `Text_$01CD` | 1 |
| `Text_$02AD` | 1 |

### EventScriptGroup_01

Top RAM symbols:

| Symbol | Relation | Count |
|---:|---|---:|
| `$7F1F19` | read_condition | 14 |
| `$7F1F66` | read_condition | 13 |
| `$7F1F1B` | read_condition | 12 |
| `$7F1F6A` | read_condition | 4 |
| `$7F1F6C` | read_condition | 4 |
| `$80091E` | read_condition | 3 |
| `$7F1F18` | read_condition | 3 |
| `$7F1F1F` | read_condition | 1 |
| `$7F1F1C` | read_condition | 1 |

Top text ids referenced:

| Text id | Count |
|---:|---:|
| `Text_$0200` | 3 |
| `Text_$03DC` | 2 |
| `Text_$0047` | 2 |
| `Text_$01C9` | 1 |
| `Text_$03B8` | 1 |
| `Text_$0035` | 1 |
| `Text_$0036` | 1 |
| `Text_$020B` | 1 |
| `Text_$023D` | 1 |
| `Text_$02AD` | 1 |
| `Text_$03EC` | 1 |
| `Text_$01CD` | 1 |

### EventScriptGroup_06

Top RAM symbols:

| Symbol | Relation | Count |
|---:|---|---:|
| `$80091E` | read_condition | 31 |
| `$7F1F64` | read_condition | 13 |
| `$7F1F66` | read_condition | 4 |
| `$7F1F6C` | read_condition | 3 |
| `$7F1F6A` | read_condition | 2 |
| `$7F1F25` | read_condition | 2 |
| `$7F1F1F` | read_condition | 1 |
| `$7F1F23` | read_condition | 1 |

Top text ids referenced:

| Text id | Count |
|---:|---:|
| `Text_$0200` | 13 |
| `Text_$0212` | 4 |
| `Text_$03B2` | 3 |
| `Text_$03BB` | 3 |
| `Text_$03B9` | 2 |
| `Text_$0154` | 2 |
| `Text_$03B0` | 2 |
| `Text_$016F` | 2 |
| `Text_$0158` | 2 |
| `Text_$015E` | 2 |
| `Text_$03B8` | 1 |
| `Text_$0153` | 1 |

### EventScriptGroup_08

Top RAM symbols:

| Symbol | Relation | Count |
|---:|---|---:|
| `$80091E` | read_condition | 31 |
| `$7F1F66` | read_condition | 4 |
| `$7F1F6C` | read_condition | 3 |
| `$7F1F6A` | read_condition | 2 |
| `$7F1F25` | read_condition | 2 |
| `$7F1F1F` | read_condition | 1 |
| `$7F1F23` | read_condition | 1 |

Top text ids referenced:

| Text id | Count |
|---:|---:|
| `Text_$0200` | 13 |
| `Text_$03BB` | 5 |
| `Text_$0212` | 3 |
| `Text_$03B2` | 3 |
| `Text_$03BC` | 3 |
| `Text_$03B9` | 2 |
| `Text_$016B` | 2 |
| `Text_$03B0` | 2 |
| `Text_$03BA` | 2 |
| `Text_$03B4` | 2 |
| `Text_$0401` | 1 |
| `Text_$043D` | 1 |

### EventScriptGroup_02

Top RAM symbols:

| Symbol | Relation | Count |
|---:|---|---:|
| `$7F1F1C` | read_condition | 6 |
| `$80091E` | read_condition | 6 |
| `$7F1F6A` | read_condition | 6 |
| `$7F1F66` | read_condition | 5 |
| `$7F1F6C` | read_condition | 5 |
| `$7F1F19` | read_condition | 2 |
| `$7F1F5A` | write_value_or_flag | 2 |
| `$7F1F1F` | read_condition | 1 |
| `$800921` | write_value_or_flag | 1 |
| `$7F1F66` | write_value_or_flag | 1 |
| `$7F1F5E` | write_value_or_flag | 1 |

Top text ids referenced:

| Text id | Count |
|---:|---:|
| `Text_$0200` | 6 |
| `Text_$01CA` | 2 |
| `Text_$01C9` | 2 |
| `Text_$03B8` | 2 |
| `Text_$0049` | 1 |
| `Text_$0038` | 1 |
| `Text_$01CD` | 1 |
| `Text_$01C6` | 1 |
| `Text_$03B9` | 1 |
| `Text_$003D` | 1 |
| `Text_$01CE` | 1 |
| `Text_$01E0` | 1 |

### EventScriptGroup_43

Top RAM symbols:

| Symbol | Relation | Count |
|---:|---|---:|
| `$7F1F64` | read_condition | 12 |
| `$7F1F1C` | read_condition | 11 |
| `$7F1F5E` | write_value_or_flag | 10 |
| `$80091E` | read_condition | 8 |
| `$800196` | read_condition | 6 |
| `$7F1F19` | read_condition | 5 |
| `$7F1F5E` | read_condition | 5 |
| `$7F1F6C` | read_condition | 5 |
| `$7F1F37` | read_condition | 5 |
| `$7F1F39` | read_condition | 5 |
| `$7F1F3B` | read_condition | 1 |
| `$80098C` | read_condition | 1 |

Top text ids referenced:

| Text id | Count |
|---:|---:|
| `Text_$0212` | 2 |
| `Text_$0200` | 1 |
| `Text_$01D9` | 1 |
| `Text_$03B2` | 1 |
| `Text_$03B3` | 1 |
| `Text_$03BA` | 1 |
| `Text_$01BD` | 1 |
| `Text_$041D` | 1 |
| `Text_$041E` | 1 |

### EventScriptGroup_45

Top RAM symbols:

| Symbol | Relation | Count |
|---:|---|---:|
| `$7F1F66` | read_condition | 20 |
| `$7F1F1C` | read_condition | 4 |
| `$7F1F37` | read_condition | 4 |
| `$80091E` | read_condition | 4 |
| `$7F1F39` | read_condition | 4 |
| `$800196` | read_condition | 2 |
| `$7F1F19` | read_condition | 2 |
| `$7F1F6C` | read_condition | 2 |

Top text ids referenced:

| Text id | Count |
|---:|---:|
| `Text_$01C2` | 8 |
| `Text_$041D` | 2 |
| `Text_$041E` | 2 |
| `Text_$01D9` | 2 |
| `Text_$01C0` | 2 |
| `Text_$01C1` | 2 |

### EventScriptGroup_03

Top RAM symbols:

| Symbol | Relation | Count |
|---:|---|---:|
| `$7F1F66` | read_condition | 6 |
| `$7F1F6A` | read_condition | 5 |
| `$80091E` | read_condition | 5 |
| `$7F1F6C` | read_condition | 4 |
| `$7F1F1C` | read_condition | 3 |
| `$7F1F64` | read_condition | 1 |
| `$7F1F1F` | read_condition | 1 |
| `$7F1F21` | read_condition | 1 |
| `$7F1F23` | read_condition | 1 |
| `$7F1F25` | read_condition | 1 |
| `$7F1F27` | read_condition | 1 |

Top text ids referenced:

| Text id | Count |
|---:|---:|
| `Text_$0200` | 4 |
| `Text_$01C9` | 2 |
| `Text_$0049` | 2 |
| `Text_$01E0` | 1 |
| `Text_$03B0` | 1 |
| `Text_$0059` | 1 |
| `Text_$01CF` | 1 |
| `Text_$03B8` | 1 |
| `Text_$0037` | 1 |
| `Text_$01CD` | 1 |
| `Text_$01C6` | 1 |
| `Text_$03B9` | 1 |

### EventScriptGroup_47

Top RAM symbols:

| Symbol | Relation | Count |
|---:|---|---:|
| `$7F1F60` | write_value_or_flag | 23 |
| `$800921` | write_value_or_flag | 4 |
| `$800923` | write_value_or_flag | 2 |

Top text ids referenced:

| Text id | Count |
|---:|---:|
| - | 0 |

