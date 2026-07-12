#!/usr/bin/env python3
"""Inspecta um ROM SNES LoROM de Harvest Moon sem copiar o ROM para o pacote.

Uso:
  python tools/rom_info.py --rom "/caminho/Harvest Moon.smc"

Saidas:
  reports/rom_info.md
"""
from __future__ import annotations
from pathlib import Path
import argparse, hashlib, datetime

ROOT = Path(__file__).resolve().parents[1]
REPORTS = ROOT / "reports"
EXPECTED_USA_MD5 = "c9bf36a816b6d54aed79d43a6c45111a"


def file_hashes(data: bytes) -> dict[str, str]:
    return {
        "md5": hashlib.md5(data).hexdigest(),
        "sha1": hashlib.sha1(data).hexdigest(),
        "sha256": hashlib.sha256(data).hexdigest(),
    }


def printable_title(raw: bytes) -> str:
    return ''.join(chr(b) if 32 <= b <= 126 else '.' for b in raw).rstrip()


def parse_header(data: bytes, offset: int) -> dict[str, object] | None:
    if offset + 0x40 > len(data):
        return None
    raw = data[offset:offset+0x40]
    title = printable_title(raw[0:21])
    return {
        "offset": offset,
        "title": title,
        "map_mode": raw[0x15],
        "rom_type": raw[0x16],
        "rom_size_code": raw[0x17],
        "sram_size_code": raw[0x18],
        "region": raw[0x19],
        "developer": raw[0x1A],
        "version": raw[0x1B],
        "checksum_complement": int.from_bytes(raw[0x1C:0x1E], "little"),
        "checksum": int.from_bytes(raw[0x1E:0x20], "little"),
    }


def checksum16(data: bytes) -> int:
    return sum(data) & 0xFFFF


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--rom", required=True, type=Path)
    args = ap.parse_args()
    rom = args.rom.expanduser().resolve()
    if not rom.exists():
        raise SystemExit(f"ROM nao encontrado: {rom}")
    data = rom.read_bytes()
    hashes = file_hashes(data)
    has_copier_header = len(data) % 0x8000 == 512
    rom_no_header = data[512:] if has_copier_header else data
    headers = [parse_header(rom_no_header, off) for off in (0x7FC0, 0xFFC0, 0x40FFC0)]
    headers = [h for h in headers if h]

    REPORTS.mkdir(exist_ok=True)
    out = REPORTS / "rom_info.md"
    lines = []
    lines.append("# ROM info")
    lines.append("")
    lines.append(f"Gerado em: {datetime.datetime.now().isoformat(timespec='seconds')}")
    lines.append("")
    lines.append("## Arquivo analisado")
    lines.append("")
    lines.append(f"- Nome: `{rom.name}`")
    lines.append(f"- Tamanho: `{len(data)}` bytes / `0x{len(data):X}`")
    lines.append(f"- Header copier 512 bytes: `{'sim' if has_copier_header else 'nao'}`")
    lines.append(f"- MD5: `{hashes['md5']}`")
    lines.append(f"- SHA1: `{hashes['sha1']}`")
    lines.append(f"- SHA256: `{hashes['sha256']}`")
    lines.append("")
    lines.append("## Compatibilidade com o projeto")
    lines.append("")
    if hashes['md5'].lower() == EXPECTED_USA_MD5:
        lines.append("- Resultado: `bate com o MD5 USA esperado pelo README`.")
    else:
        lines.append("- Resultado: `NAO bate com o MD5 USA esperado pelo README`.")
        lines.append(f"- MD5 USA esperado pelo README: `{EXPECTED_USA_MD5}`")
        lines.append("- Isso geralmente significa outra revisao, traducao/patched ROM ou regiao diferente.")
    lines.append("")
    lines.append("## Cabecalhos SNES candidatos")
    lines.append("")
    for h in headers:
        ok_sum = ((h['checksum'] + h['checksum_complement']) & 0xFFFF) == 0xFFFF
        lines.append(f"### Offset `0x{h['offset']:X}`")
        lines.append("")
        lines.append(f"- Titulo: `{h['title']}`")
        lines.append(f"- Map mode: `0x{h['map_mode']:02X}`")
        lines.append(f"- ROM type: `0x{h['rom_type']:02X}`")
        lines.append(f"- ROM size code: `0x{h['rom_size_code']:02X}`")
        lines.append(f"- SRAM size code: `0x{h['sram_size_code']:02X}`")
        lines.append(f"- Regiao: `0x{h['region']:02X}`")
        lines.append(f"- Versao: `0x{h['version']:02X}`")
        lines.append(f"- Checksum/complemento: `0x{h['checksum']:04X}` / `0x{h['checksum_complement']:04X}`")
        lines.append(f"- Checksum + complemento == FFFF: `{'sim' if ok_sum else 'nao'}`")
        lines.append("")
    lines.append("## Observacao")
    lines.append("")
    lines.append("O ROM foi apenas lido para relatorio; ele nao deve ser colocado no ZIP final.")
    out.write_text('\n'.join(lines) + '\n', encoding='utf-8')
    print(out)
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
