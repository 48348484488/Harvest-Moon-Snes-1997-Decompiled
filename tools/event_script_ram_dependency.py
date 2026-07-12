#!/usr/bin/env python3
"""
Pass 57 helper: RAM/flag dependency index for EventScript B3-B5.

This extracts only symbolic dependencies: memory addresses, flag bits, text ids,
branch targets and opcode classes. It is intended to identify which scenes/NPC
scripts depend on calendar, weather, affection, event flags, inventory/money or
other gameplay state without dumping script bytes or dialog text.
"""
from __future__ import annotations
from pathlib import Path
from collections import Counter, defaultdict
import argparse
import csv
import hashlib

EXPECTED_USA_MD5 = "c9bf36a816b6d54aed79d43a6c45111a"
MASTER_TABLE = 0xB38000
MASTER_GROUP_COUNT = 0x48
PRIORITY_GROUPS = [0x00, 0x44, 0x04, 0x07, 0x01, 0x06, 0x08, 0x02, 0x43, 0x45, 0x03, 0x47]

PAYLOAD_LEN = {
    0x00: 1, 0x01: 0, 0x02: 0, 0x03: 1, 0x04: 0, 0x05: 4, 0x06: 1, 0x07: 1,
    0x08: 0, 0x09: 3, 0x0A: 1, 0x0B: 1, 0x0C: 1, 0x0D: 4, 0x0E: 1, 0x0F: 1,
    0x10: None, 0x11: 0, 0x12: 2, 0x13: 2, 0x14: 6, 0x15: 6, 0x16: 7,
    0x17: 1, 0x18: 3, 0x19: 3, 0x1A: 7, 0x1B: 3, 0x1C: 3, 0x1D: 3,
    0x1E: 2, 0x1F: 0, 0x20: 3, 0x21: 4, 0x22: 6, 0x23: 4, 0x24: 1,
    0x25: 1, 0x26: 4, 0x27: 4, 0x28: 4, 0x29: 5, 0x2A: 2, 0x2B: 3,
    0x2C: 5, 0x2D: 4, 0x2E: 4, 0x2F: 2, 0x30: 0, 0x31: 0, 0x32: 5,
    0x33: 0, 0x34: 0, 0x35: 0, 0x36: 0, 0x37: 0, 0x38: 0, 0x39: 4,
    0x3A: 4, 0x3B: 1, 0x3C: 0, 0x3D: 1, 0x3E: 1, 0x3F: 1, 0x40: 0,
    0x41: 5, 0x42: 6, 0x43: 7, 0x44: 8, 0x45: 9, 0x46: 11, 0x47: 4,
    0x48: 6, 0x49: 3, 0x4A: 0, 0x4B: 5, 0x4C: 0, 0x4D: 2, 0x4E: 0,
    0x4F: 0, 0x50: None,
}

COND_OPS = {0x14, 0x15, 0x16, 0x43, 0x44, 0x45, 0x46}
WRITE_OPS = {0x23, 0x26, 0x27, 0x28, 0x32, 0x47, 0x48}
TEXT_OPS = {0x1C, 0x1D, 0x21}


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


def mem_s(mem: int) -> str:
    return f"${mem:06X}"


def w(lo: int, hi: int) -> int:
    return lo | (hi << 8)


def read_payload(rv: RomView, addr: int, length: int) -> list[int]:
    return [rv.read8(addr + i) for i in range(length)]


def master_groups(rv: RomView):
    groups = []
    for group_id in range(MASTER_GROUP_COUNT):
        group_addr = rv.read24(MASTER_TABLE + group_id * 3)
        bank = group_addr & 0xFF0000
        first_target_low = rv.read16(group_addr)
        table_size = (first_target_low - (group_addr & 0xFFFF)) & 0xFFFF
        pointer_entries = table_size // 2
        targets = [bank | rv.read16(group_addr + i * 2) for i in range(pointer_entries)]
        groups.append((group_id, group_addr, targets))
    return groups


def unique_boundaries(targets):
    unique = sorted(set(targets))
    out = {}
    for i, target in enumerate(unique):
        if i + 1 < len(unique) and (unique[i + 1] & 0xFF0000) == (target & 0xFF0000):
            out[target] = unique[i + 1]
        else:
            out[target] = (target & 0xFF0000) | 0xFFFF
    return out


def parse_all(rv: RomView, max_commands: int):
    rows = []
    addr_counter = Counter()
    group_addr_counter = defaultdict(Counter)
    group_text_counter = defaultdict(Counter)
    for group_id, group_addr, targets in master_groups(rv):
        boundaries = unique_boundaries(targets)
        seen = set()
        for entry_idx, target in enumerate(targets):
            # For dependency totals count unique script bodies once per group.
            key = (group_id, target)
            if key in seen:
                continue
            seen.add(key)
            p = target
            for command_idx in range(max_commands):
                if p >= boundaries[target]:
                    break
                op = rv.read8(p)
                payload_len = PAYLOAD_LEN.get(op)
                if payload_len is None:
                    break
                if op not in PAYLOAD_LEN:
                    break
                payload = read_payload(rv, p + 1, payload_len)
                relation = None
                mem = None
                bit_or_value = ""
                extra = ""
                if op in {0x14, 0x15, 0x16, 0x23, 0x26, 0x27, 0x28, 0x32, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48}:
                    mem = payload[0] | (payload[1] << 8) | (payload[2] << 16)
                    if op in COND_OPS:
                        relation = "read_condition"
                    elif op in WRITE_OPS:
                        relation = "write_value_or_flag"
                    if op in {0x14, 0x23, 0x26, 0x27, 0x28}:
                        bit_or_value = f"bit_${payload[3]:02X}"
                    elif op in {0x15}:
                        bit_or_value = f"eq_${payload[3]:02X}"
                    elif op == 0x16:
                        bit_or_value = f"between_${payload[3]:02X}_${payload[4]:02X}"
                    elif op in {0x43, 0x45}:
                        bit_or_value = f"word_${w(payload[3], payload[4]):04X}"
                    elif op in {0x44, 0x46}:
                        val = payload[3] | (payload[4] << 8) | (payload[5] << 16)
                        bit_or_value = f"long_${val:06X}"
                    elif op == 0x32:
                        bit_or_value = f"store_${w(payload[3], payload[4]):04X}"
                    elif op == 0x47:
                        bit_or_value = f"set_${payload[3]:02X}"
                    elif op == 0x48:
                        val = payload[3] | (payload[4] << 8) | (payload[5] << 16)
                        bit_or_value = f"set_${val:06X}"
                elif op in TEXT_OPS:
                    relation = "dialog_text_id"
                    mem = w(payload[0], payload[1])
                    bit_or_value = f"mode_${payload[-1]:02X}"
                if relation is not None and mem is not None:
                    rows.append({
                        "group": f"${group_id:02X}",
                        "label": f"EventScriptGroup_{group_id:02X}",
                        "entry": entry_idx,
                        "script_target": addr_s(target),
                        "command_index": command_idx,
                        "command_addr": addr_s(p),
                        "opcode": f"${op:02X}",
                        "relation": relation,
                        "symbol": mem_s(mem) if relation != "dialog_text_id" else f"Text_${mem:04X}",
                        "bit_or_value": bit_or_value,
                        "extra": extra,
                    })
                    if relation != "dialog_text_id":
                        if ((mem >> 16) & 0xFF) in {0x7E, 0x7F, 0x80}:
                            addr_counter[(mem, relation)] += 1
                            group_addr_counter[group_id][(mem, relation)] += 1
                        else:
                            rows[-1]["extra"] = "outside_expected_ram_window"
                    else:
                        group_text_counter[group_id][mem] += 1
                p += 1 + payload_len
    return rows, addr_counter, group_addr_counter, group_text_counter


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--rom", required=True, type=Path)
    ap.add_argument("--out-dir", default=Path("reports"), type=Path)
    ap.add_argument("--max-commands", type=int, default=96)
    args = ap.parse_args()

    rom_md5 = md5(args.rom)
    if rom_md5 != EXPECTED_USA_MD5:
        raise SystemExit(f"ROM MD5 inesperado: {rom_md5}")
    rv = RomView(args.rom.read_bytes())
    args.out_dir.mkdir(parents=True, exist_ok=True)

    rows, addr_counter, group_addr_counter, group_text_counter = parse_all(rv, args.max_commands)

    csv_path = args.out_dir / "event_script_ram_dependency_pass57.csv"
    with csv_path.open("w", newline="", encoding="utf-8") as fp:
        writer = csv.DictWriter(fp, fieldnames=["group", "label", "entry", "script_target", "command_index", "command_addr", "opcode", "relation", "symbol", "bit_or_value", "extra"])
        writer.writeheader()
        writer.writerows(rows)

    top_csv = args.out_dir / "event_script_ram_dependency_top_symbols_pass57.csv"
    with top_csv.open("w", newline="", encoding="utf-8") as fp:
        writer = csv.DictWriter(fp, fieldnames=["symbol", "relation", "count"])
        writer.writeheader()
        for (mem, relation), count in addr_counter.most_common():
            writer.writerow({"symbol": mem_s(mem), "relation": relation, "count": count})

    md_path = args.out_dir / "event_script_ram_dependency_pass57.md"
    with md_path.open("w", encoding="utf-8") as fp:
        fp.write("# Pass 57 - EventScript RAM dependency index\n\n")
        fp.write("This report indexes RAM/flag reads, RAM/flag writes and dialog text id references from B3-B5 EventScript bodies.\n\n")
        fp.write(f"- ROM MD5: `{rom_md5}`\n")
        fp.write(f"- Dependency rows: `{len(rows)}`\n")
        fp.write(f"- Unique RAM symbols: `{len({mem for (mem, relation) in addr_counter})}`\n\n")
        fp.write("## Global top RAM dependencies\n\n")
        fp.write("| Symbol | Relation | Count |\n|---:|---|---:|\n")
        for (mem, relation), count in addr_counter.most_common(30):
            fp.write(f"| `{mem_s(mem)}` | {relation} | {count} |\n")
        fp.write("\n## Priority group dependency map\n\n")
        for gid in PRIORITY_GROUPS:
            fp.write(f"### EventScriptGroup_{gid:02X}\n\n")
            fp.write("Top RAM symbols:\n\n")
            fp.write("| Symbol | Relation | Count |\n|---:|---|---:|\n")
            if group_addr_counter[gid]:
                for (mem, relation), count in group_addr_counter[gid].most_common(12):
                    fp.write(f"| `{mem_s(mem)}` | {relation} | {count} |\n")
            else:
                fp.write("| - | - | 0 |\n")
            fp.write("\nTop text ids referenced:\n\n")
            fp.write("| Text id | Count |\n|---:|---:|\n")
            if group_text_counter[gid]:
                for text_id, count in group_text_counter[gid].most_common(12):
                    fp.write(f"| `Text_${text_id:04X}` | {count} |\n")
            else:
                fp.write("| - | 0 |\n")
            fp.write("\n")

    print(f"Wrote {csv_path}")
    print(f"Wrote {top_csv}")
    print(f"Wrote {md_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
