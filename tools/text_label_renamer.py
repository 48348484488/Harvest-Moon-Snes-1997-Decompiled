#!/usr/bin/env python3
"""Generate and optionally apply stable text label renames for Harvest Moon SNES.

Pass 03 focuses on labels such as DATA16_Bxxxxx that are directly referenced by
Text_Pointer_Table. It uses the text-table index plus a short decoded-text slug.
All generated labels are assembler-safe: [A-Za-z_][A-Za-z0-9_]* only.
"""
from __future__ import annotations
import argparse, csv, json, re
from pathlib import Path

from extract_text_banks import parse_bank_file

PTR_RE = re.compile(r"^\s*dl\s+([A-Za-z_][A-Za-z0-9_]*)\s*;([A-F0-9]{6});([0-9A-Fa-f]+)")
GENERIC_RE = re.compile(r"^(DATA16|DATA8|UNK)_[A-F0-9]{6}$")
TAG_RE = re.compile(r"<[^>]+>")
WORD_RE = re.compile(r"[A-Za-z0-9']+")
SAFE_RE = re.compile(r"[^A-Za-z0-9_]")

STOPWORDS = {
    "the","a","an","and","or","of","to","in","on","at","for","from","with","by","is","are","am","be","been",
    "it","its","i","you","your","we","our","they","them","he","she","his","her","this","that","there","here",
    "do","does","did","not","no","yes","can","cant","cannot","will","would","should","could","just","so",
    "what","when","where","why","how","hello","hi","hey","well","oh","ok","okay","please","really",
    "im","ive","ill","id","dont","doesnt","didnt","wont","wouldnt","shouldnt","couldnt","arent","isnt","thats",
}

CATEGORY_RULES = [
    ("Weather", ["weather", "rain", "sunny", "snow", "hurricane", "forecast", "storm"]),
    ("Diary", ["diary", "good night", "work hard", "save", "sleep"]),
    ("Manual", ["button", "sickle", "hoe", "axe", "hammer", "watering", "milker", "brush", "bell", "seeds"]),
    ("Sign", ["sign", "shop", "closed", "wood", "fodder", "mountain", "cave", "hotspring"]),
    ("Animal", ["cow", "cows", "chicken", "chickens", "hen", "hens", "horse", "dog", "livestock", "milk", "egg"]),
    ("Shipping", ["shipping", "ship", "box", "collect", "sell", "price"]),
    ("Shop", ["buy", "sell", "gold", "grocery", "store", "restaurant", "bar", "peddler"]),
    ("Festival", ["festival", "contest", "dance", "new years", "thanksgiving"]),
    ("Church", ["god", "church", "priest", "pray"]),
    ("Mountain", ["mountain", "fishing", "fish", "mushroom", "berry", "pond"]),
    ("Romance", ["love", "girl", "girls", "maria", "ann", "ellen", "eve", "nina", "bride", "married"]),
    ("Town", ["mayor", "town", "people", "flower", "fortune", "carpenter"]),
]

def normalize_word(w: str) -> str:
    # Remove apostrophes and all non-alnum characters so labels are valid for Asar.
    w = re.sub(r"[^A-Za-z0-9]", "", w)
    return w


def title_word(w: str) -> str:
    w = normalize_word(w)
    if not w:
        return ""
    if w.isdigit():
        return w
    return w[:1].upper() + w[1:].lower()


def text_slug(text: str, max_words: int = 5) -> str:
    clean = TAG_RE.sub(" ", text)
    replacements = {
        "can't":"cant", "Can't":"Cant", "don't":"dont", "Don't":"Dont", "doesn't":"doesnt", "Doesn't":"Doesnt",
        "it's":"its", "It's":"Its", "I'll":"Ill", "i'll":"ill", "I've":"Ive", "i've":"ive", "I'm":"Im", "i'm":"im",
        "aren't":"arent", "Aren't":"Arent", "won't":"wont", "Won't":"Wont", "you'd":"youd", "You'd":"Youd",
    }
    for a,b in replacements.items():
        clean = clean.replace(a,b)
    words = [normalize_word(w) for w in WORD_RE.findall(clean)]
    words = [w for w in words if w]
    chosen = []
    for w in words:
        lw = w.lower()
        if not lw or lw in STOPWORDS:
            continue
        tw = title_word(lw)
        if tw:
            chosen.append(tw)
        if len(chosen) >= max_words:
            break
    if not chosen:
        for w in words[:max_words]:
            tw = title_word(w.lower())
            if tw:
                chosen.append(tw)
    return "".join(chosen) or "Entry"


def safe_label(label: str) -> str:
    label = SAFE_RE.sub("", label)
    if not label or not re.match(r"[A-Za-z_]", label[0]):
        label = "Text_" + label
    return label


def category_for(text: str, old_label: str) -> str:
    base = (text + " " + old_label).lower()
    for cat, keys in CATEGORY_RULES:
        if any(k in base for k in keys):
            return cat
    return "Dialog"


def load_entries(repo: Path):
    entries = {}
    for bank in ["B6","B7","B8","B9","BA","BB"]:
        for e in parse_bank_file(repo / "src" / "data_banks" / f"bank_{bank}.asm"):
            entries[e["label"]] = e
    return entries


def parse_pointer_table(repo: Path):
    path = repo / "src" / "code_banks" / "bank_83.asm"
    rows = []
    in_table = False
    for lineno, line in enumerate(path.read_text(errors="ignore").splitlines(), 1):
        if "Text_Pointer_Table:" in line:
            in_table = True
            continue
        if in_table:
            if line.strip() == "" or line.lstrip().startswith(";"):
                continue
            m = PTR_RE.match(line)
            if m:
                label, addr, idx = m.groups()
                rows.append({"line": lineno, "label": label, "snes_addr": addr, "index_hex": idx.upper()})
            elif rows and not line.lstrip().startswith("dl"):
                if ":" in line or line.strip().startswith(("CODE_", "%", "LDA", "JSL", "RTL", "RTS")):
                    break
    return rows


def generate_map(repo: Path):
    entries = load_entries(repo)
    ptr_rows = parse_pointer_table(repo)
    used = set(entries)
    rename_rows = []
    new_names = set()
    for ptr in ptr_rows:
        old = ptr["label"]
        if not GENERIC_RE.match(old):
            continue
        e = entries.get(old)
        if not e:
            continue
        text = e.get("text", "")
        idx = int(ptr["index_hex"], 16)
        category = category_for(text, old)
        slug = text_slug(text)
        base = safe_label(f"Text_{idx:03X}_{category}_{slug}")
        if len(base) > 76:
            base = base[:76].rstrip("_")
        name = base
        suffix = 2
        while name in used or name in new_names:
            name = f"{base}_{suffix}"
            suffix += 1
        new_names.add(name)
        rename_rows.append({
            "index_hex": f"{idx:03X}",
            "snes_addr": ptr["snes_addr"],
            "old_label": old,
            "new_label": name,
            "category": category,
            "word_count": e.get("word_count", len(e.get("words", []))),
            "byte_count": e.get("byte_count", len(e.get("words", []))*2),
            "text_preview": " ".join(text.split())[:220],
        })
    return rename_rows, ptr_rows


def apply_renames(repo: Path, rows: list[dict], paths: list[Path]):
    mapping = {r["old_label"]: r["new_label"] for r in rows}
    if not mapping:
        return 0
    pattern = re.compile(r"\b(" + "|".join(re.escape(k) for k in sorted(mapping, key=len, reverse=True)) + r")\b")
    changed_files = 0
    for p in paths:
        text = p.read_text(errors="ignore")
        new = pattern.sub(lambda m: mapping[m.group(1)], text)
        if new != text:
            p.write_text(new, encoding="utf-8")
            changed_files += 1
    return changed_files


def write_reports(repo: Path, rows: list[dict], ptr_rows: list[dict], outdir: Path):
    outdir.mkdir(parents=True, exist_ok=True)
    fields = ["index_hex","snes_addr","old_label","new_label","category","word_count","byte_count","text_preview"]
    with (outdir / "text_label_rename_map.csv").open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader(); w.writerows(rows)
    (outdir / "text_label_rename_map.json").write_text(json.dumps(rows, indent=2, ensure_ascii=False), encoding="utf-8")
    by_cat = {}
    for r in rows:
        by_cat[r["category"]] = by_cat.get(r["category"], 0) + 1
    md = [
        "# Text label rename map - Pass 03", "",
        f"Text pointer table entries parsed: **{len(ptr_rows)}**", 
        f"Generic labels selected for rename: **{len(rows)}**", "",
        "## Renames by category", "",
        "| Category | Count |", "|---|---:|",
    ]
    for cat, n in sorted(by_cat.items(), key=lambda x: (-x[1], x[0])):
        md.append(f"| {cat} | {n} |")
    md += ["", "## First 140 applied/proposed names", "", "| Index | Address | Old label | New label | Preview |", "|---:|---|---|---|---|"]
    for r in rows[:140]:
        prev = r["text_preview"].replace("|", "\\|")
        md.append(f"| ${r['index_hex']} | ${r['snes_addr']} | `{r['old_label']}` | `{r['new_label']}` | {prev} |")
    (outdir / "text_label_rename_map.md").write_text("\n".join(md), encoding="utf-8")

    name_map = {r["old_label"]: r["new_label"] for r in rows}
    entries = load_entries(repo)
    cat_rows = []
    for p in ptr_rows:
        label = name_map.get(p["label"], p["label"])
        e = entries.get(p["label"]) or entries.get(label)
        text = e.get("text", "") if e else ""
        cat_rows.append({
            "index_hex": f"{int(p['index_hex'],16):03X}",
            "snes_addr": p["snes_addr"],
            "bank": p["snes_addr"][:2],
            "label": label,
            "category": category_for(text, label),
            "text_preview": " ".join(text.split())[:220],
        })
    fields2 = ["index_hex","snes_addr","bank","label","category","text_preview"]
    with (outdir / "text_pointer_catalog.csv").open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=fields2)
        w.writeheader(); w.writerows(cat_rows)
    (outdir / "text_pointer_catalog.json").write_text(json.dumps(cat_rows, indent=2, ensure_ascii=False), encoding="utf-8")
    md2 = ["# Text pointer catalog", "", f"Entries: **{len(cat_rows)}**", "", "| Index | Address | Bank | Label | Category | Preview |", "|---:|---|---:|---|---|---|"]
    for r in cat_rows[:400]:
        prev = r["text_preview"].replace("|", "\\|")
        md2.append(f"| ${r['index_hex']} | ${r['snes_addr']} | {r['bank']} | `{r['label']}` | {r['category']} | {prev} |")
    (outdir / "text_pointer_catalog.md").write_text("\n".join(md2), encoding="utf-8")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--repo", default=".")
    ap.add_argument("--outdir", default="reports/decomp_pass03/text")
    ap.add_argument("--apply", action="store_true", help="apply generated renames to src/*.asm")
    args = ap.parse_args()
    repo = Path(args.repo).resolve()
    rows, ptr_rows = generate_map(repo)
    outdir = repo / args.outdir
    write_reports(repo, rows, ptr_rows, outdir)
    changed = 0
    if args.apply:
        paths = list((repo / "src").rglob("*.asm"))
        changed = apply_renames(repo, rows, paths)
        write_reports(repo, rows, ptr_rows, outdir)
    print(f"Pointer rows: {len(ptr_rows)}")
    print(f"Generic text labels renamed/proposed: {len(rows)}")
    if args.apply:
        print(f"Files changed: {changed}")
    print(f"Reports: {outdir}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
