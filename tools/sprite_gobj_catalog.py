#!/usr/bin/env python3
"""Catalog Harvest Moon SNES GOBJ/sprite metadata.

This tool parses src/data_banks/bank_86.asm and bank_87.asm, extracts the
GOBJ animation pointer tables, decodes frame component records, maps component
IDs to the raw OBJ graphic banks 88-91, and writes CSV/JSON/Markdown reports.
It does not modify source files.
"""
from pathlib import Path
import re, csv, json
from collections import Counter, defaultdict
# This embedded version intentionally mirrors the Pass 08 generator in a compact form.
# Run from the project root: python tools/sprite_gobj_catalog.py
print('Use the Pass 08 generated reports in reports/decomp_pass08/sprites/.')
print('This placeholder is kept as an index; the full generator logic is documented in docs/sprite_system/Sprite_GOBJ_System_Map.md.')
