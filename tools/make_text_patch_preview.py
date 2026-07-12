#!/usr/bin/env python3
"""Generate an Asar dw block preview from plain ASCII/no-accent text.

Usage:
  python tools/make_text_patch_preview.py --label Text_Test --text "Ola mundo."
  python tools/make_text_patch_preview.py --label Text_Test --text-file message.txt
"""
from __future__ import annotations
import argparse
from pathlib import Path
from hm_text_codec import encode_ascii_text, format_dw


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--label", default="Text_Custom")
    group = ap.add_mutually_exclusive_group(required=True)
    group.add_argument("--text")
    group.add_argument("--text-file")
    args = ap.parse_args()
    text = args.text if args.text is not None else Path(args.text_file).read_text(encoding="utf-8")
    words = encode_ascii_text(text)
    print(f"{args.label}:")
    print(format_dw(words))
    print(f"; words={len(words)} bytes={len(words)*2}")

if __name__ == "__main__":
    main()
