#!/usr/bin/env python3
"""
Gera perfil semantico aproximado dos scripts de evento B3-B5.

A ferramenta usa uma ROM USA limpa local somente para engenharia reversa de
metadados: contagem de opcodes, categorias e grupos candidatos. Ela nao exporta
bytes brutos de script nem textos do jogo.

Uso:
  python3 tools/event_script_opcode_profile.py --rom "roms/Harvest Moon (USA).sfc"
"""
from __future__ import annotations
from pathlib import Path
from collections import Counter, defaultdict
import argparse
import csv
import hashlib
from dataclasses import dataclass

EXPECTED_USA_MD5 = "c9bf36a816b6d54aed79d43a6c45111a"
MASTER_TABLE = 0xB38000
MASTER_GROUP_COUNT = 0x48

# Payload size after opcode. Valores vieram de EventScript.txt + docs do core.
# None = comando para/espera/sem avanco seguro para scan linear.
PAYLOAD_LEN: dict[int, int | None] = {
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

OPCODE_NAME: dict[int, str] = {
    0x00: "AudioRelated", 0x01: "EnableTimeFlow", 0x02: "StopTimeFlow",
    0x03: "SetHour", 0x04: "Empty", 0x05: "SetPlayerPosition",
    0x06: "SetTransitionDestination", 0x07: "SetPlayerDirection",
    0x08: "ChangeGameState", 0x09: "StartNestedScriptSlot",
    0x0A: "ScreenFadeIn", 0x0B: "Set7AFlag", 0x0C: "Compare7AFlag",
    0x0D: "CCStateChange2", 0x0E: "AudioRelated2", 0x0F: "ScreenFadeOut",
    0x10: "DisableCCSlotStop", 0x11: "ChangeGameState2", 0x12: "Jump",
    0x13: "SetCC10", 0x14: "JumpIfFlagSet", 0x15: "JumpIfEquals",
    0x16: "JumpIfBetween", 0x17: "GetRNG", 0x18: "JumpIfEqualsRNG",
    0x19: "SetAnimation", 0x1A: "CCStateChange3", 0x1B: "CCStateChange4",
    0x1C: "StartTextBox", 0x1D: "StartTextBoxCopy", 0x1E: "CCStateChange5",
    0x1F: "CCStateChange5D", 0x20: "JumpIf018F", 0x21: "TextRelated",
    0x22: "CCStateChange6", 0x23: "SetFlag", 0x24: "TimeOfDayPalette",
    0x25: "CCStateChange7", 0x26: "ResetFlag", 0x27: "ResetFlagD",
    0x28: "ResetFlagDD", 0x29: "MapScrolling", 0x2A: "CFD1",
    0x2B: "CCStateChange8", 0x2C: "AudioRelated3", 0x2D: "CCStateChange9",
    0x2E: "CCStateChange10", 0x2F: "CCStateChange11", 0x30: "ChickenRelated",
    0x31: "CowRelated", 0x32: "StoreValue", 0x33: "PickupMole",
    0x34: "Fishing", 0x35: "PlayerPos", 0x36: "DogRelated",
    0x37: "EventCoreUNK1", 0x38: "EventCoreUNK2", 0x39: "CCStateChange12",
    0x3A: "CCStateChange13", 0x3B: "ChangeItemOnHand", 0x3C: "TransitionToHouse",
    0x3D: "TransitionToX", 0x3E: "SetItemOnHand", 0x3F: "DropItemAnimation",
    0x40: "Set5C", 0x41: "CCStateChange14", 0x42: "ChangeMoney",
    0x43: "JumpIfEqualsValue", 0x44: "JumpIfEqualsValueLong",
    0x45: "JumpIfBetweenValue", 0x46: "JumpIfBetweenValueLong", 0x47: "SetValueShort",
    0x48: "SetValueLong", 0x49: "CCStateChange15", 0x4A: "EventCoreUNK3",
    0x4B: "EditTileOnMap", 0x4C: "CCStateChange16", 0x4D: "CCStateChange17Jump",
    0x4E: "Reset5C", 0x4F: "Set60", 0x50: "ToolsStopOrWait",
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
for op in [0x1A, 0x1B, 0x1E, 0x1F, 0x22, 0x25, 0x2A, 0x2B, 0x2D, 0x2E, 0x2F, 0x39, 0x3A, 0x40, 0x41, 0x49, 0x4C, 0x4E, 0x4F]: CLASS_BY_OPCODE[op] = "cc_state_object"
for op in [0x04, 0x33, 0x34, 0x37, 0x38, 0x4A]: CLASS_BY_OPCODE[op] = "special_unknown"

TAG_RULES = [
    ("dialogo", {0x1C, 0x1D, 0x21}),
    ("flags_memoria", {0x14, 0x15, 0x16, 0x23, 0x26, 0x27, 0x28, 0x32, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48}),
    ("objeto_cc", {0x09, 0x1A, 0x1B, 0x1E, 0x1F, 0x22, 0x2B, 0x2D, 0x2E, 0x2F, 0x39, 0x3A, 0x41, 0x49, 0x4D, 0x4F}),
    ("transicao_tela", {0x06, 0x08, 0x0A, 0x0F, 0x11, 0x3C, 0x3D}),
    ("mapa_tile", {0x29, 0x4B}),
    ("audio", {0x00, 0x0E, 0x2C}),
    ("item_dinheiro", {0x3B, 0x3E, 0x3F, 0x42}),
    ("animal", {0x30, 0x31, 0x36}),
    ("player_anim", {0x05, 0x07, 0x19, 0x35}),
]

@dataclass
class EntryProfile:
    target: int
    first_opcode: int
    command_count: int
    known_count: int
    unknown_count: int
    stopped_by: str
    opcodes: Counter[int]
    classes: Counter[str]


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


def read24_le(rv: RomView, addr: int) -> int:
    p = snes_to_pc(addr)
    return rv.data[p] | (rv.data[p + 1] << 8) | (rv.data[p + 2] << 16)


def addr_s(addr: int) -> str:
    return f"${addr:06X}"


def master_groups(rv: RomView) -> list[tuple[int, int, list[int]]]:
    groups: list[tuple[int, int, list[int]]] = []
    for group_id in range(MASTER_GROUP_COUNT):
        group_addr = read24_le(rv, MASTER_TABLE + group_id * 3)
        bank = group_addr & 0xFF0000
        first_target_low = rv.read16(group_addr)
        table_size = (first_target_low - (group_addr & 0xFFFF)) & 0xFFFF
        pointer_entries = table_size // 2
        targets = [bank | rv.read16(group_addr + i * 2) for i in range(pointer_entries)]
        groups.append((group_id, group_addr, targets))
    return groups


def profile_entry(rv: RomView, target: int, next_boundary: int, max_commands: int) -> EntryProfile:
    p = target
    opcodes: Counter[int] = Counter()
    classes: Counter[str] = Counter()
    known = 0
    unknown = 0
    stopped_by = "max_commands"
    first = rv.read8(target)

    for _ in range(max_commands):
        if p >= next_boundary:
            stopped_by = "next_entry_boundary"
            break
        op = rv.read8(p)
        opcodes[op] += 1
        classes[CLASS_BY_OPCODE.get(op, "unknown")] += 1
        payload = PAYLOAD_LEN.get(op)
        if payload is None:
            if op in PAYLOAD_LEN:
                known += 1
                stopped_by = f"stop_or_wait_opcode_${op:02X}"
            else:
                unknown += 1
                stopped_by = f"unknown_opcode_${op:02X}"
            break
        if op not in PAYLOAD_LEN:
            unknown += 1
            stopped_by = f"unknown_opcode_${op:02X}"
            break
        known += 1
        p += 1 + payload
    else:
        stopped_by = "max_commands"

    return EntryProfile(
        target=target,
        first_opcode=first,
        command_count=sum(opcodes.values()),
        known_count=known,
        unknown_count=unknown,
        stopped_by=stopped_by,
        opcodes=opcodes,
        classes=classes,
    )


def tags_from_ops(ops: Counter[int]) -> str:
    tags = []
    op_set = set(ops)
    for tag, wanted in TAG_RULES:
        if op_set & wanted:
            tags.append(tag)
    return ", ".join(tags) if tags else "controle_basico"


def histogram_s(counter: Counter[int], limit: int = 12) -> str:
    return " ".join(f"${op:02X}:{count}" for op, count in counter.most_common(limit))


def class_s(counter: Counter[str], limit: int = 8) -> str:
    return " ".join(f"{name}:{count}" for name, count in counter.most_common(limit))


def build_profiles(rv: RomView, max_commands: int) -> tuple[list[dict[str, object]], list[dict[str, object]]]:
    group_rows: list[dict[str, object]] = []
    entry_rows: list[dict[str, object]] = []
    for group_id, group_addr, targets in master_groups(rv):
        unique = sorted(set(targets))
        # Limite conservador: proximo alvo dentro do mesmo banco ou fim da area LoROM do banco.
        all_boundaries = []
        for i, target in enumerate(unique):
            if i + 1 < len(unique) and (unique[i + 1] & 0xFF0000) == (target & 0xFF0000):
                all_boundaries.append(unique[i + 1])
            else:
                all_boundaries.append((target & 0xFF0000) | 0xFFFF)
        op_total: Counter[int] = Counter()
        class_total: Counter[str] = Counter()
        stop_reasons: Counter[str] = Counter()
        first_ops: Counter[int] = Counter()
        total_commands = 0
        known_commands = 0
        unknown_commands = 0
        entry_profiles = []
        for idx, target in enumerate(unique):
            boundary = all_boundaries[idx]
            prof = profile_entry(rv, target, boundary, max_commands)
            entry_profiles.append(prof)
            op_total.update(prof.opcodes)
            class_total.update(prof.classes)
            stop_reasons[prof.stopped_by] += 1
            first_ops[prof.first_opcode] += 1
            total_commands += prof.command_count
            known_commands += prof.known_count
            unknown_commands += prof.unknown_count
        tag_text = tags_from_ops(op_total)
        density = round(total_commands / len(unique), 2) if unique else 0
        group_rows.append(
            {
                "group_id_hex": f"{group_id:02X}",
                "group_label": f"EventScriptGroup_{group_id:02X}",
                "group_table_addr": addr_s(group_addr),
                "bank": f"${(group_addr >> 16) & 0xFF:02X}",
                "pointer_entries": len(targets),
                "unique_targets": len(unique),
                "linear_commands_sampled": total_commands,
                "avg_commands_per_unique_target": density,
                "known_commands": known_commands,
                "unknown_or_unparsed_commands": unknown_commands,
                "semantic_tags": tag_text,
                "dominant_classes": class_s(class_total),
                "opcode_histogram": histogram_s(op_total),
                "first_opcode_histogram": histogram_s(first_ops),
                "stop_reasons": "; ".join(f"{k}:{v}" for k, v in stop_reasons.most_common()),
            }
        )
        for prof in entry_profiles:
            entry_rows.append(
                {
                    "group_id_hex": f"{group_id:02X}",
                    "group_label": f"EventScriptGroup_{group_id:02X}",
                    "target_addr": addr_s(prof.target),
                    "first_opcode": f"${prof.first_opcode:02X}",
                    "first_opcode_name": OPCODE_NAME.get(prof.first_opcode, "Unknown"),
                    "linear_commands_sampled": prof.command_count,
                    "known_commands": prof.known_count,
                    "unknown_or_unparsed_commands": prof.unknown_count,
                    "semantic_tags": tags_from_ops(prof.opcodes),
                    "dominant_classes": class_s(prof.classes),
                    "opcode_histogram": histogram_s(prof.opcodes),
                    "stopped_by": prof.stopped_by,
                }
            )
    return group_rows, entry_rows


def write_csv(rows: list[dict[str, object]], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as fp:
        writer = csv.DictWriter(fp, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)


def write_group_md(rows: list[dict[str, object]], path: Path, rom_hash: str, max_commands: int) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    total_linear = sum(int(r["linear_commands_sampled"]) for r in rows)
    total_known = sum(int(r["known_commands"]) for r in rows)
    total_unknown = sum(int(r["unknown_or_unparsed_commands"]) for r in rows)
    with path.open("w", encoding="utf-8") as fp:
        fp.write("# Event Script Opcode Profile B3-B5\n\n")
        fp.write("Perfil gerado a partir da ROM local somente como metadado de engenharia reversa. ")
        fp.write("Nao exporta bytes brutos nem dialogos. A leitura e linear e conservadora: branches nao sao seguidos.\n\n")
        fp.write(f"- MD5 ROM usada: `{rom_hash}`\n")
        fp.write(f"- Grupos analisados: `{len(rows)}`\n")
        fp.write(f"- Maximo de comandos por entrada unica: `{max_commands}`\n")
        fp.write(f"- Comandos lineares amostrados: `{total_linear}`\n")
        fp.write(f"- Comandos conhecidos amostrados: `{total_known}`\n")
        fp.write(f"- Comandos desconhecidos/nao parseados: `{total_unknown}`\n\n")
        fp.write("## Tags usadas\n\n")
        fp.write("`dialogo`, `flags_memoria`, `objeto_cc`, `transicao_tela`, `mapa_tile`, `audio`, `item_dinheiro`, `animal`, `player_anim`.\n\n")
        fp.write("## Tabela por grupo\n\n")
        fp.write("| Grupo | Label | Banco | Entradas | Alvos unicos | Cmds | Media/alvo | Tags | Classes dominantes | Opcodes dominantes | Primeiro opcode | Paradas |\n")
        fp.write("|---:|---|---:|---:|---:|---:|---:|---|---|---|---|---|\n")
        for r in rows:
            fp.write(
                f"| `${r['group_id_hex']}` | `{r['group_label']}` | `{r['bank']}` | {r['pointer_entries']} | {r['unique_targets']} | "
                f"{r['linear_commands_sampled']} | {r['avg_commands_per_unique_target']} | {r['semantic_tags']} | "
                f"{r['dominant_classes']} | {r['opcode_histogram']} | {r['first_opcode_histogram']} | {r['stop_reasons']} |\n"
            )


def write_priority_md(rows: list[dict[str, object]], path: Path) -> None:
    def score(row: dict[str, object]) -> float:
        cmds = int(row["linear_commands_sampled"])
        uniq = int(row["unique_targets"])
        tags = str(row["semantic_tags"])
        bonus = 0
        for token in ["dialogo", "flags_memoria", "objeto_cc", "mapa_tile", "animal", "item_dinheiro"]:
            if token in tags:
                bonus += 15
        return cmds + uniq * 2 + bonus

    ranked = sorted(rows, key=score, reverse=True)
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as fp:
        fp.write("# Prioridade de Decompilacao dos EventScript Groups\n\n")
        fp.write("Ranking automatico para escolher proximas passes sem chute manual. ")
        fp.write("A pontuacao combina volume linear amostrado, quantidade de alvos unicos e tags de gameplay.\n\n")
        fp.write("| Rank | Grupo | Label | Banco | Cmds | Alvos unicos | Tags | Motivo pratico |\n")
        fp.write("|---:|---:|---|---:|---:|---:|---|---|\n")
        for i, r in enumerate(ranked[:24], 1):
            tags = str(r["semantic_tags"])
            if "dialogo" in tags and "flags_memoria" in tags:
                reason = "Scripts ricos em condicao + texto; bons para nomear cenas/NPCs."
            elif "objeto_cc" in tags:
                reason = "Controla objetos/slots CC; bom para comportamento visual e cutscenes."
            elif "animal" in tags:
                reason = "Toca subsistemas de animais; util para documentar rotinas de rancho."
            elif "mapa_tile" in tags:
                reason = "Altera mapa/tile; bom para eventos fisicos no cenario."
            else:
                reason = "Grupo com alto volume ou muitos destinos unicos."
            fp.write(
                f"| {i} | `${r['group_id_hex']}` | `{r['group_label']}` | `{r['bank']}` | {r['linear_commands_sampled']} | "
                f"{r['unique_targets']} | {tags} | {reason} |\n"
            )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rom", required=True, type=Path, help="ROM USA limpa local")
    parser.add_argument("--out-dir", type=Path, default=Path("reports"), help="Pasta de saida")
    parser.add_argument("--max-commands", type=int, default=96, help="Limite linear por entrada unica")
    args = parser.parse_args()

    rom_path = args.rom.expanduser().resolve()
    if not rom_path.exists():
        raise SystemExit(f"ROM nao encontrada: {rom_path}")
    rom_hash = md5(rom_path)
    if rom_hash.lower() != EXPECTED_USA_MD5:
        print(f"AVISO: MD5 diferente do esperado USA limpo: {rom_hash}")
    rv = RomView(rom_path.read_bytes())
    group_rows, entry_rows = build_profiles(rv, args.max_commands)
    out_dir = args.out_dir
    write_csv(group_rows, out_dir / "event_script_opcode_profile_groups.csv")
    write_csv(entry_rows, out_dir / "event_script_opcode_profile_entries.csv")
    write_group_md(group_rows, out_dir / "event_script_opcode_profile_b3_b5.md", rom_hash, args.max_commands)
    write_priority_md(group_rows, out_dir / "event_script_decomp_priority_b3_b5.md")
    print(out_dir / "event_script_opcode_profile_groups.csv")
    print(out_dir / "event_script_opcode_profile_entries.csv")
    print(out_dir / "event_script_opcode_profile_b3_b5.md")
    print(out_dir / "event_script_decomp_priority_b3_b5.md")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
