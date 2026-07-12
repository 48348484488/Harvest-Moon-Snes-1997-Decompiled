#!/usr/bin/env python3
"""Audit EventCmd dispatch-table coverage for Harvest Moon SNES decomp.

Pass 71 verifies that the official EventInstructionPointers table is covered by
symbolic names/payload metadata for EventCmd $00-$59. Bytes above $59 reached by
linear export are not dispatch-table opcodes; they are treated as inline data,
misaligned pointer targets, or untyped table bytes requiring script-boundary work.
"""
from pathlib import Path
import re
import argparse

def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument('--asm', default='src/code_banks/bank_84.asm', type=Path)
    args = ap.parse_args()
    text = args.asm.read_text(encoding='utf-8')
    table = re.search(r'EventInstructionPointers:.*?(?=Events_Bank_Table:)', text, re.S)
    if not table:
        raise SystemExit('EventInstructionPointers not found')
    raw = re.findall(r'\$([0-9A-F]{4})', table.group(0))
    # first 90 are the actual dw table entries; comments duplicate addresses.
    entries = raw[:0x5A]
    comments = set(re.findall(r';dw\s+(EventCmd_[0-9A-F]{2}_[^;\n]+)\s*;([0-9A-F]{2});', table.group(0)))
    covered = {int(op,16) for _, op in comments}
    missing = [f'${i:02X}' for i in range(len(entries)) if i not in covered]
    print(f'official_dispatch_entries={len(entries)}')
    print(f'covered_symbolic_entries={len(entries)-len(missing)}')
    print(f'coverage_percent={(len(entries)-len(missing))/len(entries)*100:.3f}')
    print('missing=' + (','.join(missing) if missing else 'none'))
    return 0
if __name__ == '__main__':
    raise SystemExit(main())
