#!/usr/bin/env python3
"""Extrai o arquivo .diz do DiztinGUIsh para XML legivel."""
from __future__ import annotations
from pathlib import Path
import gzip

ROOT = Path(__file__).resolve().parents[1]
DEFAULT_IN = ROOT / "decomps" / "Harvest Moon (USA)_Main.diz"
DEFAULT_OUT = ROOT / "decomps" / "Harvest_Moon_USA_Main.diz.xml"

def main() -> None:
    data = gzip.decompress(DEFAULT_IN.read_bytes())
    DEFAULT_OUT.write_bytes(data)
    print(f"XML extraido: {DEFAULT_OUT}")

if __name__ == "__main__":
    main()
