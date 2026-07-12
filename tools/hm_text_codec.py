#!/usr/bin/env python3
"""
Harvest Moon SNES text codec helpers.

This module is intentionally conservative: it decodes the character/control
codes that are obvious from the decompilation and keeps unknown/control words
visible as <XXXX>. It is meant for auditing and editing assistance, not as a
lossy pretty-printer.
"""
from __future__ import annotations

from typing import Iterable, List, Sequence

# Confirmed by the B6-BB text banks:
# 0000-0019 = a-z
# 001A-0033 = A-Z
# 00B1 = visible space/padding
# 00A2 = line/page break marker used in text dumps
# FFFF = text terminator
CHAR_TO_WORD = {}
WORD_TO_CHAR = {}

for i, ch in enumerate("abcdefghijklmnopqrstuvwxyz"):
    WORD_TO_CHAR[i] = ch
    CHAR_TO_WORD[ch] = i
for i, ch in enumerate("ABCDEFGHIJKLMNOPQRSTUVWXYZ", start=0x001A):
    WORD_TO_CHAR[i] = ch
    CHAR_TO_WORD[ch] = i

PUNCT = {
    0x0034: "'",
    0x0035: ",",
    0x0036: ".",
    0x0037: "?",
    0x0038: '"',
    0x0039: "!",
    0x003A: ":",
    0x003D: "&",   # provisional; uncommon in the original text banks
    0x003E: "-",
}

# Extra glyphs observed in the BR translation ROM. These are kept in the
# same codec so the comparison reports are readable. A few uncommon symbols
# remain intentionally undecoded as <$XXXX> until they are verified in-game.
BR_ACCENTS = {
    0x0041: ":",
    0x0043: "á",
    0x0044: "é",
    0x0045: "í",
    0x0047: "À",
    0x004B: "ó",
    0x004C: "ú",
    0x004D: "ã",
    0x004E: "Ó",
    0x0053: "õ",
    0x0054: "ê",
    0x0055: "ô",
    0x0057: "ç",
    0x005B: "â",
    0x005C: "à",
    0x005D: "É",
    0x005F: "Ú",
}
WORD_TO_CHAR.update(PUNCT)
WORD_TO_CHAR.update(BR_ACCENTS)
for table in (PUNCT, BR_ACCENTS):
    for k, v in table.items():
        CHAR_TO_WORD[v] = k

SPACE = 0x00B1
LINEBREAK = 0x00A2
END = 0xFFFF

# Known-ish control words. The symbolic names are descriptive, not final.
CONTROL_NAMES = {
    0x00A2: "LINE",
    0x00B1: "SPACE",
    0x00B2: "CTRL_B2",
    0x00B3: "CTRL_B3",
    0x00B4: "CTRL_B4",
    0x00B5: "CTRL_B5",
    0xFFFC: "CTRL_FFFC",
    0xFFFD: "CTRL_FFFD",
    0xFFFE: "CHOICE_OR_WAIT",
    0xFFFF: "END",
}


def decode_word(word: int, *, show_controls: bool = True) -> str:
    if word in WORD_TO_CHAR:
        return WORD_TO_CHAR[word]
    if word == SPACE:
        return " "
    if word == LINEBREAK:
        return "\n"
    if word == END:
        return ""
    if word in CONTROL_NAMES:
        return f"<{CONTROL_NAMES[word]}>" if show_controls else ""
    return f"<${word:04X}>"


def decode_words(words: Sequence[int], *, stop_at_end: bool = True, show_controls: bool = True, rstrip_padding: bool = True) -> str:
    out: List[str] = []
    for word in words:
        if word == END and stop_at_end:
            break
        out.append(decode_word(word, show_controls=show_controls))
    text = "".join(out)
    if rstrip_padding:
        # Preserve real internal spacing but remove most padding at line ends.
        text = "\n".join(line.rstrip() for line in text.split("\n"))
    return text


def encode_ascii_text(text: str, *, append_end: bool = True) -> List[int]:
    """Encode a safe ASCII-only edit preview.

    This deliberately refuses accents and unknown symbols; it is for simple
    English/no-accent Portuguese edits that fit the original engine alphabet.
    """
    words: List[int] = []
    for ch in text:
        if ch == "\n":
            words.append(LINEBREAK)
        elif ch == " ":
            words.append(SPACE)
        elif ch in CHAR_TO_WORD:
            words.append(CHAR_TO_WORD[ch])
        else:
            raise ValueError(f"Character not in current HM text table: {ch!r}")
    if append_end:
        words.append(END)
    return words


def format_dw(words: Iterable[int], *, per_line: int = 8, indent: str = "                       ") -> str:
    vals = list(words)
    lines = []
    for i in range(0, len(vals), per_line):
        chunk = vals[i:i+per_line]
        lines.append(indent + "dw " + ",".join(f"${w:04X}" for w in chunk))
    return "\n".join(lines)

# Pass 04 helper: reversible-ish markup encoder for safe text editing.
CONTROL_BY_NAME = {v: k for k, v in CONTROL_NAMES.items()}
# Aliases used by the editor/exporter.
CONTROL_BY_NAME.update({
    "BR": LINEBREAK,
    "NEWLINE": LINEBREAK,
    "LINEBREAK": LINEBREAK,
    "WAIT": 0xFFFE,
    "CHOICE": 0xFFFE,
})


def encode_markup_text(text: str, *, append_end: bool = True) -> List[int]:
    """Encode text using normal characters plus <CONTROL> markup.

    Supported examples:
      Hello\nWorld
      Hello<LINE>World<END>
      Price: <$00B1><CTRL_FFFC>G
      Yes No<CHOICE_OR_WAIT>c

    Unknown characters intentionally raise ValueError so edits do not silently
    corrupt the ROM text stream.
    """
    import re

    words: List[int] = []
    i = 0
    while i < len(text):
        ch = text[i]
        if ch == "<":
            end = text.find(">", i + 1)
            if end == -1:
                raise ValueError("Unclosed control markup '<...>'")
            token = text[i + 1:end].strip()
            token_upper = token.upper()
            if token_upper.startswith("$"):
                words.append(int(token_upper[1:], 16) & 0xFFFF)
            elif token_upper.startswith("CTRL_"):
                suffix = token_upper[5:]
                if suffix in ("B2", "B3", "B4", "B5"):
                    words.append(int(suffix, 16))
                elif suffix in ("FFFC", "FFFD", "FFFE", "FFFF"):
                    words.append(int(suffix, 16))
                else:
                    raise ValueError(f"Unknown CTRL token: <{token}>")
            elif token_upper in CONTROL_BY_NAME:
                words.append(CONTROL_BY_NAME[token_upper])
            else:
                raise ValueError(f"Unknown control token: <{token}>")
            i = end + 1
            continue
        if ch == "\r":
            i += 1
            continue
        if ch == "\n":
            words.append(LINEBREAK)
        elif ch == " ":
            words.append(SPACE)
        elif ch in CHAR_TO_WORD:
            words.append(CHAR_TO_WORD[ch])
        else:
            raise ValueError(f"Character not in current HM text table: {ch!r}")
        i += 1
    if append_end and (not words or words[-1] != END):
        words.append(END)
    return words


def decode_words_markup(words: Sequence[int], *, stop_at_end: bool = True) -> str:
    """Decode words into editor-friendly markup, preserving controls visibly."""
    out: List[str] = []
    for word in words:
        if word == END:
            if not stop_at_end:
                out.append("<END>")
            break
        if word == SPACE:
            out.append(" ")
        elif word == LINEBREAK:
            out.append("<LINE>")
        elif word in WORD_TO_CHAR:
            out.append(WORD_TO_CHAR[word])
        elif word in CONTROL_NAMES:
            out.append(f"<{CONTROL_NAMES[word]}>")
        else:
            out.append(f"<${word:04X}>")
    return "".join(out)
