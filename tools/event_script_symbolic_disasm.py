#!/usr/bin/env python3
"""
Pass 57 helper: symbolic EventScript disassembler for B3-B5.

It converts the highest-priority event script groups from opaque byte streams
into conservative pseudocode. The output avoids raw byte dumps and does not
export dialog text; text commands are shown only by numeric text id.

Usage:
  python3 tools/event_script_symbolic_disasm.py --rom "roms/Harvest Moon (USA).sfc"
"""
from __future__ import annotations
from pathlib import Path
from collections import Counter, defaultdict
from dataclasses import dataclass
import argparse
import csv
import hashlib

EXPECTED_USA_MD5 = "c9bf36a816b6d54aed79d43a6c45111a"
MASTER_TABLE = 0xB38000
MASTER_GROUP_COUNT = 0x48
PRIORITY_GROUPS = [0x00, 0x44, 0x04, 0x07, 0x01, 0x06, 0x08, 0x02, 0x43, 0x45, 0x03, 0x47]

PAYLOAD_LEN: dict[int, int | None] = {
    0x00: 2, 0x01: 0, 0x02: 0, 0x03: 1, 0x04: 0, 0x05: 4, 0x06: 1, 0x07: 1,
    0x08: 0, 0x09: 3, 0x0A: 1, 0x0B: 1, 0x0C: 1, 0x0D: 4, 0x0E: 1, 0x0F: 1,
    0x10: None, 0x11: 0, 0x12: 2, 0x13: 2, 0x14: 6, 0x15: 6, 0x16: 7,
    0x17: 1, 0x18: 3, 0x19: 3, 0x1A: 7, 0x1B: 3, 0x1C: 3, 0x1D: 3,
    0x1E: 2, 0x1F: 2, 0x20: 3, 0x21: 4, 0x22: 6, 0x23: 4, 0x24: 1,
    0x25: 1, 0x26: 4, 0x27: 4, 0x28: 4, 0x29: 5, 0x2A: 2, 0x2B: 3,
    0x2C: 5, 0x2D: 4, 0x2E: 4, 0x2F: 2, 0x30: 0, 0x31: 0, 0x32: 5,
    0x33: 0, 0x34: 0, 0x35: 0, 0x36: 0, 0x37: 0, 0x38: 0, 0x39: 3,
    0x3A: 3, 0x3B: 1, 0x3C: 0, 0x3D: 1, 0x3E: 1, 0x3F: 0, 0x40: 0,
    0x41: 5, 0x42: 6, 0x43: 7, 0x44: 8, 0x45: 9, 0x46: 11, 0x47: 4,
    0x48: 6, 0x49: 2, 0x4A: 0, 0x4B: 5, 0x4C: 0, 0x4D: 2, 0x4E: 0,
    0x4F: 0, 0x50: None, 0x51: 0, 0x52: 0, 0x53: 0, 0x54: 3, 0x55: 6, 0x56: 0, 0x57: 1, 0x58: 5, 0x59: 0,
}

OPCODE_NAME: dict[int, str] = {
    0x00: "PlayAudioOrMusic", 0x01: "EnableTimeFlow", 0x02: "StopTimeFlow",
    0x03: "SetHour", 0x04: "NoOp", 0x05: "SetPlayerPosition",
    0x06: "SetTransitionDestination", 0x07: "SetPlayerDirection",
    0x08: "ChangeGameState", 0x09: "StartNestedScriptSlot",
    0x0A: "ScreenFadeIn", 0x0B: "Set7AFlag", 0x0C: "Compare7AFlag",
    0x0D: "SetCCVelocityOrDelta", 0x0E: "AudioRelated2", 0x0F: "ScreenFadeOut",
    0x10: "StopOrDisableCCSlot", 0x11: "ChangeGameState2", 0x12: "Jump",
    0x13: "WaitOrSetCCCounter", 0x14: "JumpIfFlagSet", 0x15: "JumpIfEqualsByte",
    0x16: "JumpIfBetweenByte", 0x17: "GetRNG", 0x18: "JumpIfEqualsRNG",
    0x19: "SetAnimation", 0x1A: "SpawnOrMoveCCObject", 0x1B: "SetCCObjectParam",
    0x1C: "StartTextBox", 0x1D: "StartTextBoxCopy", 0x1E: "WaitForInteractionReadyThenJump",
    0x1F: "WaitForInteractionReadyThenJumpDuplicate", 0x20: "JumpIf018F", 0x21: "TextRelated",
    0x22: "SetCCObjectBoxOrAnim", 0x23: "SetFlag", 0x24: "TimeOfDayPalette",
    0x25: "SetCCObjectParam3", 0x26: "ResetFlag", 0x27: "ResetFlagD",
    0x28: "ResetFlagDD", 0x29: "MapScrolling", 0x2A: "SetCFD1Like",
    0x2B: "SetCCObjectVisual", 0x2C: "AudioRelated3", 0x2D: "SetCCObjectParam4",
    0x2E: "SetCCObjectParam5", 0x2F: "SetCCObjectPointer", 0x30: "ChickenRelated",
    0x31: "CowRelated", 0x32: "StoreValue", 0x33: "PickupMole",
    0x34: "Fishing", 0x35: "PlayerPos", 0x36: "DogRelated",
    0x37: "EventCoreUNK1", 0x38: "EventCoreUNK2", 0x39: "SetCCObjectParam6",
    0x3A: "SetCCObjectParam7", 0x3B: "ChangeItemOnHand", 0x3C: "TransitionToHouse",
    0x3D: "TransitionToMap", 0x3E: "SetItemOnHand", 0x3F: "DropItemAnimation",
    0x40: "Set5C", 0x41: "SetCCObjectParam8", 0x42: "ChangeMoney",
    0x43: "JumpIfEqualsValue", 0x44: "JumpIfEqualsValueLong",
    0x45: "JumpIfBetweenValue", 0x46: "JumpIfBetweenValueLong", 0x47: "SetValueByte",
    0x48: "SetValueLong", 0x49: "SetCCObjectParam9", 0x4A: "EventCoreUNK3",
    0x4B: "EditTileOnMap", 0x4C: "SetCCObjectParam10", 0x4D: "SetCCObjectAndJump",
    0x4E: "Reset5C", 0x4F: "Set60", 0x50: "ToolStopOrWait",
    0x51: "UseChickenDogOrHeldItemContext", 0x52: "WaitForAButtonSetInteractionFlag02",
    0x53: "WaitForAButtonSetInteractionFlag04", 0x54: "StartTextBoxAndAdvanceSlot",
    0x55: "JumpIfIndirectBitClear", 0x56: "StartSelectedToolAction",
    0x57: "ApplyStaminaDelta", 0x58: "EditTileAndSetRuntimeFlag", 0x59: "SetPlayerAction1C",
}

CLASS_BY_OPCODE: dict[int, str] = {}
for op in [0x01, 0x02, 0x03, 0x17, 0x18, 0x24]: CLASS_BY_OPCODE[op] = "time_rng_palette"
for op in [0x00, 0x0E, 0x2C]: CLASS_BY_OPCODE[op] = "audio"
for op in [0x0A, 0x0F, 0x06, 0x3C, 0x3D, 0x08, 0x11]: CLASS_BY_OPCODE[op] = "screen_transition"
for op in [0x05, 0x07, 0x19, 0x29, 0x35]: CLASS_BY_OPCODE[op] = "player_camera_motion"
for op in [0x09, 0x10, 0x12, 0x13, 0x20, 0x4D, 0x50]: CLASS_BY_OPCODE[op] = "script_control"
for op in [0x14, 0x15, 0x16, 0x18, 0x43, 0x44, 0x45, 0x46]: CLASS_BY_OPCODE[op] = "conditional"
for op in [0x23, 0x26, 0x27, 0x28, 0x32, 0x47, 0x48, 0x0B, 0x0C]: CLASS_BY_OPCODE[op] = "flags_values"
for op in [0x1C, 0x1D, 0x21]: CLASS_BY_OPCODE[op] = "dialog_text"
for op in [0x30, 0x31, 0x36]: CLASS_BY_OPCODE[op] = "animals"
for op in [0x3B, 0x3E, 0x3F, 0x42]: CLASS_BY_OPCODE[op] = "items_money"
for op in [0x4B]: CLASS_BY_OPCODE[op] = "map_tile_edit"
for op in [0x51, 0x54, 0x55, 0x57, 0x58]: CLASS_BY_OPCODE[op] = "eventcmd_51_59_extended"
for op in [0x52, 0x53, 0x56, 0x59]: CLASS_BY_OPCODE[op] = "player_interaction_control"
for op in [0x0D, 0x1A, 0x1B, 0x1E, 0x1F, 0x22, 0x25, 0x2A, 0x2B, 0x2D, 0x2E, 0x2F, 0x39, 0x3A, 0x40, 0x41, 0x49, 0x4C, 0x4E, 0x4F]: CLASS_BY_OPCODE[op] = "cc_state_object"
for op in [0x04, 0x33, 0x34, 0x37, 0x38, 0x4A]: CLASS_BY_OPCODE[op] = "special_unknown"

@dataclass
class DecodedCommand:
    addr: int
    op: int
    name: str
    text: str
    cls: str

@dataclass
class DecodedEntry:
    group_id: int
    pointer_index: int
    target: int
    commands: list[DecodedCommand]
    stop_reason: str
    duplicate_count: int


def md5(path: Path) -> str:
    h = hashlib.md5()
    with path.open("rb") as fp:
        for chunk in iter(lambda: fp.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def snes_to_pc(addr: int) -> int:
    bank = (addr >> 16) & 0xFF
    low = addr & 0xFFFF
    if low < 0x8000:
        raise ValueError(f"Endereco LoROM fora da area mapeada: ${addr:06X}")
    return ((bank & 0x7F) * 0x8000) + (low & 0x7FFF)


class RomView:
    def __init__(self, data: bytes) -> None:
        self.data = data

    def read8(self, addr: int) -> int:
        return self.data[snes_to_pc(addr)]

    def read16(self, addr: int) -> int:
        p = snes_to_pc(addr)
        return self.data[p] | (self.data[p + 1] << 8)

    def read24(self, addr: int) -> int:
        p = snes_to_pc(addr)
        return self.data[p] | (self.data[p + 1] << 8) | (self.data[p + 2] << 16)


def addr_s(addr: int) -> str:
    return f"${addr:06X}"


def low_s(word: int) -> str:
    return f"${word:04X}"


def b_s(byte: int) -> str:
    return f"${byte:02X}"


def master_groups(rv: RomView) -> list[tuple[int, int, list[int]]]:
    groups: list[tuple[int, int, list[int]]] = []
    for group_id in range(MASTER_GROUP_COUNT):
        group_addr = rv.read24(MASTER_TABLE + group_id * 3)
        bank = group_addr & 0xFF0000
        first_target_low = rv.read16(group_addr)
        table_size = (first_target_low - (group_addr & 0xFFFF)) & 0xFFFF
        pointer_entries = table_size // 2
        targets = [bank | rv.read16(group_addr + i * 2) for i in range(pointer_entries)]
        groups.append((group_id, group_addr, targets))
    return groups


def read_payload(rv: RomView, addr: int, length: int) -> list[int]:
    return [rv.read8(addr + i) for i in range(length)]


def w(lo: int, hi: int) -> int:
    return lo | (hi << 8)


def addr_in_same_bank(current_addr: int, low: int) -> str:
    return addr_s((current_addr & 0xFF0000) | low)


def decode_command(addr: int, op: int, payload: list[int]) -> str:
    # Only symbolic operands; no raw byte dump and no dialog text extraction.
    name = OPCODE_NAME.get(op, f"UnknownOpcode_{op:02X}")
    if op == 0x00:
        return f"PlayAudioOrMusic(id={b_s(payload[0])}, control={b_s(payload[1])})"
    if op == 0x03:
        return f"SetHour(hour={payload[0]})"
    if op == 0x05:
        return f"SetPlayerPosition(x={low_s(w(payload[0], payload[1]))}, y={low_s(w(payload[2], payload[3]))})"
    if op == 0x06:
        return f"SetTransitionDestination(index={b_s(payload[0])})"
    if op == 0x07:
        return f"SetPlayerDirection(dir={b_s(payload[0])})"
    if op == 0x09:
        return f"StartNestedScriptSlot(slot={b_s(payload[0])}, target={addr_in_same_bank(addr, w(payload[1], payload[2]))})"
    if op in (0x0A, 0x0F):
        return f"{name}(param={b_s(payload[0])})"
    if op in (0x0B, 0x0C, 0x17, 0x24, 0x25, 0x3B, 0x3D, 0x3E):
        return f"{name}(value={b_s(payload[0])})"
    if op == 0x0D:
        return f"SetCCVelocityOrDelta(a={b_s(payload[0])}, b={b_s(payload[1])}, c={b_s(payload[2])}, d={b_s(payload[3])})"
    if op == 0x0E:
        return f"AudioRelated2(param={b_s(payload[0])})"
    if op == 0x12:
        return f"Jump(target={addr_in_same_bank(addr, w(payload[0], payload[1]))})"
    if op == 0x13:
        return f"WaitOrSetCCCounter(value={low_s(w(payload[0], payload[1]))})"
    if op == 0x14:
        mem = payload[0] | (payload[1] << 8) | (payload[2] << 16)
        return f"JumpIfFlagSet(mem=${mem:06X}, bit={b_s(payload[3])}, target={addr_in_same_bank(addr, w(payload[4], payload[5]))})"
    if op == 0x15:
        mem = payload[0] | (payload[1] << 8) | (payload[2] << 16)
        return f"JumpIfEqualsByte(mem=${mem:06X}, value={b_s(payload[3])}, target={addr_in_same_bank(addr, w(payload[4], payload[5]))})"
    if op == 0x16:
        mem = payload[0] | (payload[1] << 8) | (payload[2] << 16)
        return f"JumpIfBetweenByte(mem=${mem:06X}, low={b_s(payload[3])}, high={b_s(payload[4])}, target={addr_in_same_bank(addr, w(payload[5], payload[6]))})"
    if op == 0x18:
        return f"JumpIfEqualsRNG(value={b_s(payload[0])}, target={addr_in_same_bank(addr, w(payload[1], payload[2]))})"
    if op == 0x19:
        return f"SetAnimation(entity={b_s(payload[0])}, anim={low_s(w(payload[1], payload[2]))})"
    if op == 0x1A:
        return f"SpawnOrMoveCCObject(x={low_s(w(payload[0], payload[1]))}, y={low_s(w(payload[2], payload[3]))}, visual={low_s(w(payload[4], payload[5]))}, mode={b_s(payload[6])})"
    if op == 0x1B:
        return f"SetCCObjectParam(param={low_s(w(payload[0], payload[1]))}, value={b_s(payload[2])})"
    if op in (0x1C, 0x1D):
        return f"{name}(text_id={low_s(w(payload[0], payload[1]))}, mode={b_s(payload[2])})"
    if op == 0x1E:
        return f"WaitForInteractionReadyThenJump(target={addr_in_same_bank(addr, w(payload[0], payload[1]))})"
    if op == 0x20:
        return f"JumpIf018F(value={b_s(payload[0])}, target={addr_in_same_bank(addr, w(payload[1], payload[2]))})"
    if op == 0x21:
        return f"TextRelated(a={low_s(w(payload[0], payload[1]))}, b={b_s(payload[2])}, c={b_s(payload[3])})"
    if op == 0x22:
        return f"SetCCObjectBoxOrAnim(a={low_s(w(payload[0], payload[1]))}, b={low_s(w(payload[2], payload[3]))}, c={b_s(payload[4])}, d={b_s(payload[5])})"
    if op in (0x23, 0x26, 0x27, 0x28):
        mem = payload[0] | (payload[1] << 8) | (payload[2] << 16)
        return f"{name}(mem=${mem:06X}, bit={b_s(payload[3])})"
    if op == 0x29:
        return f"MapScrolling(dx={low_s(w(payload[0], payload[1]))}, dy={low_s(w(payload[2], payload[3]))}, timer={b_s(payload[4])})"
    if op == 0x2A:
        return f"SetCFD1Like(value={low_s(w(payload[0], payload[1]))})"
    if op == 0x2B:
        return f"SetCCObjectVisual(ptr={low_s(w(payload[0], payload[1]))}, bank_or_mode={b_s(payload[2])})"
    if op == 0x2C:
        return f"AudioRelated3(a={b_s(payload[0])}, b={low_s(w(payload[1], payload[2]))}, c={low_s(w(payload[3], payload[4]))})"
    if op == 0x2D:
        return f"SetCCObjectParam4(a={b_s(payload[0])}, ptr={low_s(w(payload[1], payload[2]))}, d={b_s(payload[3])})"
    if op == 0x2E:
        return f"SetCCObjectParam5(a={b_s(payload[0])}, ptr={low_s(w(payload[1], payload[2]))}, d={b_s(payload[3])})"
    if op == 0x2F:
        return f"SetCCObjectPointer(ptr={low_s(w(payload[0], payload[1]))})"
    if op == 0x32:
        mem = payload[0] | (payload[1] << 8) | (payload[2] << 16)
        return f"StoreValue(mem=${mem:06X}, value={low_s(w(payload[3], payload[4]))})"
    if op == 0x39 or op == 0x3A:
        return f"{name}(mask={b_s(payload[0])}, timer={low_s(w(payload[1], payload[2]))})"
    if op == 0x41:
        return f"SetCCObjectParam8(a={b_s(payload[0])}, b={b_s(payload[1])}, c={b_s(payload[2])}, d={b_s(payload[3])}, e={b_s(payload[4])})"
    if op == 0x42:
        return f"ChangeMoney(value1=${payload[0] | (payload[1] << 8) | (payload[2] << 16):06X}, value2=${payload[3] | (payload[4] << 8) | (payload[5] << 16):06X})"
    if op == 0x43:
        mem = payload[0] | (payload[1] << 8) | (payload[2] << 16)
        return f"JumpIfEqualsValue(mem=${mem:06X}, value={low_s(w(payload[3], payload[4]))}, target={addr_in_same_bank(addr, w(payload[5], payload[6]))})"
    if op == 0x44:
        mem = payload[0] | (payload[1] << 8) | (payload[2] << 16)
        val = payload[3] | (payload[4] << 8) | (payload[5] << 16)
        return f"JumpIfEqualsValueLong(mem=${mem:06X}, value=${val:06X}, target={addr_in_same_bank(addr, w(payload[6], payload[7]))})"
    if op == 0x45:
        mem = payload[0] | (payload[1] << 8) | (payload[2] << 16)
        return f"JumpIfBetweenValue(mem=${mem:06X}, low={low_s(w(payload[3], payload[4]))}, high={low_s(w(payload[5], payload[6]))}, target={addr_in_same_bank(addr, w(payload[7], payload[8]))})"
    if op == 0x46:
        mem = payload[0] | (payload[1] << 8) | (payload[2] << 16)
        low = payload[3] | (payload[4] << 8) | (payload[5] << 16)
        high = payload[6] | (payload[7] << 8) | (payload[8] << 16)
        return f"JumpIfBetweenValueLong(mem=${mem:06X}, low=${low:06X}, high=${high:06X}, target={addr_in_same_bank(addr, w(payload[9], payload[10]))})"
    if op == 0x47:
        mem = payload[0] | (payload[1] << 8) | (payload[2] << 16)
        return f"SetValueByte(mem=${mem:06X}, value={b_s(payload[3])})"
    if op == 0x48:
        mem = payload[0] | (payload[1] << 8) | (payload[2] << 16)
        val = payload[3] | (payload[4] << 8) | (payload[5] << 16)
        return f"SetValueLong(mem=${mem:06X}, value=${val:06X})"
    if op == 0x49:
        return f"SetCCObjectParam9(ptr={low_s(w(payload[0], payload[1]))})"
    if op == 0x4B:
        return f"EditTileOnMap(tile={b_s(payload[0])}, x={low_s(w(payload[1], payload[2]))}, y={low_s(w(payload[3], payload[4]))})"
    if op == 0x4D:
        return f"SetCCObjectAndJump(target={addr_in_same_bank(addr, w(payload[0], payload[1]))})"
    if op == 0x51:
        return "UseChickenDogOrHeldItemContext()"
    if op == 0x52:
        return "WaitForAButtonSetInteractionFlag02()"
    if op == 0x53:
        return "WaitForAButtonSetInteractionFlag04()"
    if op == 0x54:
        return f"StartTextBoxAndAdvanceSlot(text_id={low_s(w(payload[0], payload[1]))}, mode={b_s(payload[2])})"
    if op == 0x55:
        mem = payload[0] | (payload[1] << 8) | (payload[2] << 16)
        return f"JumpIfIndirectBitClear(mem=${mem:06X}, bit={b_s(payload[3])}, target={addr_in_same_bank(addr, w(payload[4], payload[5]))})"
    if op == 0x56:
        return "StartSelectedToolAction()"
    if op == 0x57:
        return f"ApplyStaminaDelta(delta={b_s(payload[0])})"
    if op == 0x58:
        return f"EditTileAndSetRuntimeFlag(tile={b_s(payload[0])}, x={low_s(w(payload[1], payload[2]))}, y={low_s(w(payload[3], payload[4]))})"
    if op == 0x59:
        return "SetPlayerAction1C()"
    if op == 0x1F:
        return f"WaitForInteractionReadyThenJumpDuplicate(target={addr_in_same_bank(addr, w(payload[0], payload[1]))})"
    if op in (0x01, 0x02, 0x04, 0x08, 0x11, 0x30, 0x31, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x3C, 0x40, 0x4A, 0x4C, 0x4E, 0x4F):
        return f"{name}()"
    return f"{name}(operands={','.join(b_s(x) for x in payload)})"


def decode_entry(rv: RomView, group_id: int, pointer_index: int, target: int, next_boundary: int, duplicate_count: int, max_commands: int) -> DecodedEntry:
    p = target
    cmds: list[DecodedCommand] = []
    stop = "max_commands"
    for _ in range(max_commands):
        if p >= next_boundary:
            stop = "next_entry_boundary"
            break
        op = rv.read8(p)
        payload_len = PAYLOAD_LEN.get(op)
        if payload_len is None:
            name = OPCODE_NAME.get(op, f"UnknownOpcode_{op:02X}")
            cls = CLASS_BY_OPCODE.get(op, "unknown")
            if op in PAYLOAD_LEN:
                text = f"{name}()"
                stop = f"stop_or_wait_opcode_${op:02X}"
            else:
                text = f"UnknownOpcode_${op:02X}()"
                stop = f"unknown_opcode_${op:02X}"
            cmds.append(DecodedCommand(p, op, name, text, cls))
            break
        if op not in PAYLOAD_LEN:
            name = f"UnknownOpcode_{op:02X}"
            cmds.append(DecodedCommand(p, op, name, f"UnknownOpcode_${op:02X}()", "unknown"))
            stop = f"unknown_opcode_${op:02X}"
            break
        if p + 1 + payload_len > next_boundary:
            stop = f"payload_crosses_entry_boundary_${op:02X}"
            break
        payload = read_payload(rv, p + 1, payload_len)
        name = OPCODE_NAME.get(op, f"UnknownOpcode_{op:02X}")
        cls = CLASS_BY_OPCODE.get(op, "unknown")
        cmds.append(DecodedCommand(p, op, name, decode_command(p, op, payload), cls))
        p += 1 + payload_len
    else:
        stop = "max_commands"
    return DecodedEntry(group_id, pointer_index, target, cmds, stop, duplicate_count)


def unique_boundaries(targets: list[int]) -> dict[int, int]:
    unique = sorted(set(targets))
    boundaries: dict[int, int] = {}
    for i, target in enumerate(unique):
        if i + 1 < len(unique) and (unique[i + 1] & 0xFF0000) == (target & 0xFF0000):
            boundaries[target] = unique[i + 1]
        else:
            boundaries[target] = (target & 0xFF0000) | 0xFFFF
    return boundaries


def compact_cmds(entry: DecodedEntry, limit: int = 8) -> str:
    out = []
    for cmd in entry.commands[:limit]:
        out.append(cmd.text)
    if len(entry.commands) > limit:
        out.append("...")
    return " ; ".join(out)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--rom", required=True, type=Path)
    ap.add_argument("--out-dir", default=Path("reports"), type=Path)
    ap.add_argument("--max-commands", type=int, default=96)
    ap.add_argument("--detail-entries", type=int, default=8)
    args = ap.parse_args()

    rom_md5 = md5(args.rom)
    if rom_md5 != EXPECTED_USA_MD5:
        raise SystemExit(f"ROM MD5 inesperado: {rom_md5}")
    rv = RomView(args.rom.read_bytes())
    groups = master_groups(rv)
    args.out_dir.mkdir(parents=True, exist_ok=True)

    all_entries: list[DecodedEntry] = []
    group_summaries = []
    for group_id, group_addr, targets in groups:
        boundaries = unique_boundaries(targets)
        dup_counter = Counter(targets)
        decoded_for_group: list[DecodedEntry] = []
        for idx, target in enumerate(targets):
            ent = decode_entry(rv, group_id, idx, target, boundaries[target], dup_counter[target], args.max_commands)
            all_entries.append(ent)
            decoded_for_group.append(ent)
        unique_targets = sorted(set(targets))
        ops = Counter(cmd.op for ent in decoded_for_group if ent.duplicate_count >= 1 for cmd in ent.commands)
        classes = Counter(cmd.cls for ent in decoded_for_group for cmd in ent.commands)
        group_summaries.append({
            "group_id": group_id,
            "group_label": f"EventScriptGroup_{group_id:02X}",
            "group_addr": group_addr,
            "entry_count": len(targets),
            "unique_targets": len(unique_targets),
            "command_count": sum(len(e.commands) for e in decoded_for_group),
            "unknown_commands": sum(1 for e in decoded_for_group for c in e.commands if c.cls == "unknown"),
            "dominant_classes": " ".join(f"{k}:{v}" for k, v in classes.most_common(6)),
            "dominant_opcodes": " ".join(f"${k:02X}:{v}" for k, v in ops.most_common(10)),
        })

    csv_path = args.out_dir / "event_script_symbolic_index_pass57.csv"
    with csv_path.open("w", newline="", encoding="utf-8") as fp:
        writer = csv.DictWriter(fp, fieldnames=[
            "group", "label", "entry", "target", "duplicate_count", "commands", "unknown_commands", "stop_reason", "first_opcode", "first_name", "classes", "pseudocode_preview",
        ])
        writer.writeheader()
        for ent in all_entries:
            classes = Counter(cmd.cls for cmd in ent.commands)
            writer.writerow({
                "group": f"${ent.group_id:02X}",
                "label": f"EventScriptGroup_{ent.group_id:02X}",
                "entry": ent.pointer_index,
                "target": addr_s(ent.target),
                "duplicate_count": ent.duplicate_count,
                "commands": len(ent.commands),
                "unknown_commands": sum(1 for c in ent.commands if c.cls == "unknown"),
                "stop_reason": ent.stop_reason,
                "first_opcode": f"${ent.commands[0].op:02X}" if ent.commands else "",
                "first_name": ent.commands[0].name if ent.commands else "",
                "classes": " ".join(f"{k}:{v}" for k, v in classes.most_common(5)),
                "pseudocode_preview": compact_cmds(ent, 6),
            })

    summary_csv = args.out_dir / "event_script_symbolic_group_summary_pass57.csv"
    with summary_csv.open("w", newline="", encoding="utf-8") as fp:
        writer = csv.DictWriter(fp, fieldnames=list(group_summaries[0].keys()))
        writer.writeheader()
        writer.writerows(group_summaries)

    md_path = args.out_dir / "event_script_symbolic_disasm_priority_b3_b5.md"
    by_group: dict[int, list[DecodedEntry]] = defaultdict(list)
    for ent in all_entries:
        by_group[ent.group_id].append(ent)

    with md_path.open("w", encoding="utf-8") as fp:
        fp.write("# Pass 57 - EventScript symbolic disassembly B3-B5\n\n")
        fp.write("Conservative pseudocode generated from the local clean USA ROM. Dialog text is not exported; only text ids are shown.\n\n")
        fp.write(f"- ROM MD5: `{rom_md5}`\n")
        fp.write(f"- Groups scanned: `{MASTER_GROUP_COUNT}`\n")
        fp.write(f"- Entries decoded: `{len(all_entries)}`\n")
        fp.write(f"- Priority groups expanded: `{', '.join(f'${g:02X}' for g in PRIORITY_GROUPS)}`\n\n")
        fp.write("## Priority group summary\n\n")
        fp.write("| Group | Label | Entries | Unique targets | Commands | Unknown cmds | Dominant classes |\n")
        fp.write("|---:|---|---:|---:|---:|---:|---|\n")
        summary_by_gid = {row["group_id"]: row for row in group_summaries}
        for gid in PRIORITY_GROUPS:
            row = summary_by_gid[gid]
            fp.write(f"| `${gid:02X}` | `{row['group_label']}` | {row['entry_count']} | {row['unique_targets']} | {row['command_count']} | {row['unknown_commands']} | {row['dominant_classes']} |\n")
        fp.write("\n## Expanded pseudocode samples\n\n")
        for gid in PRIORITY_GROUPS:
            fp.write(f"### EventScriptGroup_{gid:02X}\n\n")
            entries = by_group[gid]
            seen_targets: set[int] = set()
            shown = 0
            for ent in entries:
                if ent.target in seen_targets:
                    continue
                seen_targets.add(ent.target)
                fp.write(f"#### Entry {ent.pointer_index:02d} at `{addr_s(ent.target)}`")
                if ent.duplicate_count > 1:
                    fp.write(f" / duplicate refs: {ent.duplicate_count}")
                fp.write("\n\n")
                fp.write("```text\n")
                for i, cmd in enumerate(ent.commands[:16]):
                    fp.write(f"{i:02d}: {cmd.text}\n")
                if len(ent.commands) > 16:
                    fp.write("...\n")
                fp.write(f"; stop: {ent.stop_reason}\n")
                fp.write("```\n\n")
                shown += 1
                if shown >= args.detail_entries:
                    remaining = len(seen_targets.symmetric_difference(set()))
                    break
            fp.write(f"Expanded unique entries shown: {shown}. See CSV for the complete symbolic index.\n\n")

    ref_path = args.out_dir / "event_script_symbolic_opcode_reference_pass57.md"
    with ref_path.open("w", encoding="utf-8") as fp:
        fp.write("# EventScript opcode reference used by Pass 57\n\n")
        fp.write("This is a conservative naming layer for pseudocode generation. Names are descriptive, not a claim that every opcode is fully understood.\n\n")
        fp.write("| Opcode | Name | Payload bytes | Class |\n")
        fp.write("|---:|---|---:|---|\n")
        for op in sorted(OPCODE_NAME):
            payload = PAYLOAD_LEN.get(op)
            payload_s = "stop/wait" if payload is None else str(payload)
            fp.write(f"| `${op:02X}` | `{OPCODE_NAME[op]}` | {payload_s} | {CLASS_BY_OPCODE.get(op, 'unknown')} |\n")

    print(f"Wrote {csv_path}")
    print(f"Wrote {summary_csv}")
    print(f"Wrote {md_path}")
    print(f"Wrote {ref_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
