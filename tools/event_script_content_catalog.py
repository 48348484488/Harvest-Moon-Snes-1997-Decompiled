#!/usr/bin/env python3
"""
Gera um catalogo dos grupos de conteudo de Event Script nos bancos B3-B5.

O script nao distribui ROM e nao grava dados comerciais extensos; ele usa uma ROM
fornecida localmente apenas para validar ponteiros, tamanhos de tabelas e metadados.

Uso:
  python3 tools/event_script_content_catalog.py --rom "roms/Harvest Moon (USA).sfc"
  python3 tools/event_script_content_catalog.py --rom "roms/Harvest Moon (USA).sfc" --out-dir reports
"""
from __future__ import annotations
from pathlib import Path
from collections import Counter
import argparse
import csv
import hashlib

EXPECTED_USA_MD5 = "c9bf36a816b6d54aed79d43a6c45111a"
MASTER_TABLE = 0xB38000
MASTER_GROUP_COUNT = 0x48


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


def summarize_first_bytes(rv: RomView, targets: list[int]) -> str:
    hist = Counter(rv.read8(t) for t in sorted(set(targets)))
    return " ".join(f"${b:02X}:{n}" for b, n in hist.most_common(12))


def build_catalog(rv: RomView) -> list[dict[str, object]]:
    rows: list[dict[str, object]] = []
    for group_id in range(MASTER_GROUP_COUNT):
        master_entry = MASTER_TABLE + group_id * 3
        group_addr = rv.read24(master_entry)
        group_bank = group_addr & 0xFF0000
        first_target_low = rv.read16(group_addr)
        table_size = (first_target_low - (group_addr & 0xFFFF)) & 0xFFFF
        if table_size % 2:
            raise ValueError(f"Tabela do grupo {group_id:02X} tem tamanho impar: ${table_size:04X}")
        pointer_entries = table_size // 2
        targets = [group_bank | rv.read16(group_addr + i * 2) for i in range(pointer_entries)]
        unique_targets = sorted(set(targets))
        repeated_entries = pointer_entries - len(unique_targets)
        outside_same_bank = [t for t in unique_targets if (t & 0xFF0000) != group_bank]
        rows.append(
            {
                "group_id_hex": f"{group_id:02X}",
                "group_label": f"EventScriptGroup_{group_id:02X}",
                "master_entry_addr": addr_s(master_entry),
                "group_table_addr": addr_s(group_addr),
                "bank": f"${(group_addr >> 16) & 0xFF:02X}",
                "table_size_hex": f"${table_size:04X}",
                "pointer_entries": pointer_entries,
                "unique_targets": len(unique_targets),
                "repeated_entries": repeated_entries,
                "first_target": addr_s(unique_targets[0]) if unique_targets else "",
                "last_target": addr_s(unique_targets[-1]) if unique_targets else "",
                "outside_same_bank": len(outside_same_bank),
                "entry_first_byte_histogram": summarize_first_bytes(rv, targets),
            }
        )
    return rows


def write_csv(rows: list[dict[str, object]], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", newline="", encoding="utf-8") as fp:
        writer = csv.DictWriter(fp, fieldnames=list(rows[0].keys()))
        writer.writeheader()
        writer.writerows(rows)


def write_md(rows: list[dict[str, object]], path: Path, rom_hash: str) -> None:
    total_entries = sum(int(r["pointer_entries"]) for r in rows)
    total_unique = sum(int(r["unique_targets"]) for r in rows)
    banks = Counter(str(r["bank"]) for r in rows)
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("w", encoding="utf-8") as fp:
        fp.write("# Event Script Content Catalog B3-B5\n\n")
        fp.write("Catalogo gerado a partir da ROM local apenas para metadados de engenharia reversa. ")
        fp.write("Nao inclui ROM nem conteudo textual/script bruto.\n\n")
        fp.write(f"- MD5 da ROM usada na validacao: `{rom_hash}`\n")
        fp.write(f"- Tabela mestre: `$B38000`\n")
        fp.write(f"- Grupos catalogados: `{len(rows)}` (`$00-$47`)\n")
        fp.write(f"- Entradas de ponteiro de subscript/event entry: `{total_entries}`\n")
        fp.write(f"- Destinos unicos aproximados: `{total_unique}`\n")
        fp.write("- Distribuicao por banco: " + ", ".join(f"{bank}={count}" for bank, count in sorted(banks.items())) + "\n\n")
        fp.write("## Como ler\n\n")
        fp.write("Cada grupo aponta para uma tabela local de ponteiros de 16 bits. ")
        fp.write("O banco efetivo vem do proprio grupo (`B3`, `B4` ou `B5`). ")
        fp.write("`repeated_entries` indica slots que reutilizam o mesmo destino, comum em grupos com variantes/direcoes vazias. ")
        fp.write("`entry_first_byte_histogram` e apenas uma assinatura tecnica do primeiro byte nos destinos unicos, nao uma traducao completa dos comandos.\n\n")
        fp.write("## Tabela de grupos\n\n")
        fp.write("| Grupo | Label | Tabela | Banco | Ponteiros | Destinos unicos | Repetidos | Primeiro alvo | Ultimo alvo | Assinatura primeiro byte |\n")
        fp.write("|---:|---|---:|---:|---:|---:|---:|---:|---:|---|\n")
        for r in rows:
            fp.write(
                f"| `${r['group_id_hex']}` | `{r['group_label']}` | `{r['group_table_addr']}` | `{r['bank']}` | "
                f"{r['pointer_entries']} | {r['unique_targets']} | {r['repeated_entries']} | "
                f"`{r['first_target']}` | `{r['last_target']}` | `{r['entry_first_byte_histogram']}` |\n"
            )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rom", required=True, type=Path, help="Caminho para ROM USA limpa local")
    parser.add_argument("--out-dir", type=Path, default=Path("reports"), help="Pasta de saida")
    args = parser.parse_args()

    rom_path = args.rom.expanduser().resolve()
    if not rom_path.exists():
        raise SystemExit(f"ROM nao encontrada: {rom_path}")
    rom_hash = md5(rom_path)
    if rom_hash.lower() != EXPECTED_USA_MD5:
        print(f"AVISO: MD5 diferente do esperado USA limpo: {rom_hash}")
    rows = build_catalog(RomView(rom_path.read_bytes()))
    out_dir = args.out_dir
    write_csv(rows, out_dir / "event_script_content_catalog_b3_b5.csv")
    write_md(rows, out_dir / "event_script_content_catalog_b3_b5.md", rom_hash)
    print(out_dir / "event_script_content_catalog_b3_b5.csv")
    print(out_dir / "event_script_content_catalog_b3_b5.md")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
