#!/usr/bin/env python3
"""
Gera catalogos do sistema de mapas/graficos do Harvest Moon SNES.

Saidas:
  reports/decomp_pass06/maps/map_graphics_catalog.csv
  reports/decomp_pass06/maps/map_graphics_catalog.json
  reports/decomp_pass06/maps/map_graphics_catalog.md
  reports/decomp_pass06/maps/map_asset_usage.md
  reports/decomp_pass06/maps/map_asset_viewer.html

Observacao: esta ferramenta nao altera o source e nao precisa da ROM.
"""
from __future__ import annotations
from pathlib import Path
import csv
import html
import json
import re
from collections import Counter, defaultdict

ROOT = Path(__file__).resolve().parents[1]
MAP_ASM = ROOT / "src" / "maps" / "Maps_Graphics.asm"
OUT_DIR = ROOT / "reports" / "decomp_pass06" / "maps"
TILEMAP_DIR = ROOT / "tilemaps"

TABLE_RE = re.compile(r"^\s*dw\s+([A-Za-z0-9_]+)\s*(?:;\s*([0-9A-Fa-f]{2})(.*))?")
LABEL_RE = re.compile(r"^([A-Za-z_][A-Za-z0-9_]*):\s*;?\s*([0-9A-Fa-f]{6})?")
DATA_RE = re.compile(r"^\s*(db|dw|dl)\s+\$?([0-9A-Fa-f]+)\b(?:\s*;\s*(.*))?")
DL_RE = re.compile(r"\bdl\s+\$([0-9A-Fa-f]{6})", re.I)


def read_lines() -> list[str]:
    return MAP_ASM.read_text(encoding="utf-8", errors="replace").splitlines()


def parse_table(lines: list[str]) -> list[dict]:
    in_table = False
    entries = []
    auto_idx = 0
    for line in lines:
        if line.startswith("Maps_Graphics_Table:"):
            in_table = True
            continue
        if in_table and line.startswith(";Backgrounds"):
            break
        if not in_table:
            continue
        m = TABLE_RE.match(line)
        if not m:
            continue
        label, idx_hex, comment = m.groups()
        if idx_hex is None:
            idx = auto_idx
            idx_hex = f"{idx:02X}"
        else:
            idx = int(idx_hex, 16)
        auto_idx = idx + 1
        entries.append({
            "map_id_dec": idx,
            "map_id_hex": idx_hex.upper(),
            "label": label,
            "table_comment": (comment or "").strip(),
        })
    return entries


def parse_bodies(lines: list[str]) -> dict[str, dict]:
    labels: dict[str, dict] = {}
    current = None
    for line in lines:
        lm = LABEL_RE.match(line)
        if lm:
            label, addr = lm.groups()
            current = {"label": label, "address": addr.upper() if addr else "", "lines": []}
            labels[label] = current
            continue
        if current is not None:
            current["lines"].append(line)
    return labels


def tilemap_png_for(addr: str) -> str:
    # Arquivos existentes usam formato Tilemap0x928000.png.
    p = TILEMAP_DIR / f"Tilemap0x{addr.lower()}.png"
    if p.exists():
        return str(Path("tilemaps") / p.name)
    p2 = TILEMAP_DIR / f"Tilemap0x{addr.upper()}.png"
    if p2.exists():
        return str(Path("tilemaps") / p2.name)
    return ""


def classify_asset(addr: str) -> str:
    bank = int(addr[:2], 16)
    if 0x92 <= bank <= 0x9F:
        return "tilemap/background_compressed"
    if 0xA0 <= bank <= 0xAF:
        return "character_graphics_compressed"
    if 0x80 <= bank <= 0x8F:
        return "code_or_table_reference"
    return "unknown_compressed_asset"


def parse_map_body(body: dict) -> dict:
    data = []
    dls = []
    for line in body.get("lines", []):
        dm = DATA_RE.match(line)
        if dm:
            kind, value, comment = dm.groups()
            data.append({"kind": kind, "value": value.upper(), "comment": (comment or "").strip()})
        for m in DL_RE.finditer(line):
            addr = m.group(1).upper()
            dls.append(addr)
    # Interpretacao conservadora apenas para mapas principais que seguem o formato comum.
    interpreted = {}
    if len(data) >= 10 and data[0]["kind"] == "db":
        try:
            interpreted = {
                "graphic_preset": data[0]["value"],
                "screen_config_or_flag": data[1]["value"] if len(data) > 1 else "",
                "unknown_0181": data[2]["value"] if len(data) > 2 else "",
                "unknown_0182": data[3]["value"] if len(data) > 3 else "",
                "tilemap_count": int(data[4]["value"], 16) if len(data) > 4 and data[4]["kind"] == "db" else None,
                "charactermap_count": int(data[5]["value"], 16) if len(data) > 5 and data[5]["kind"] == "db" else None,
            }
        except Exception:
            interpreted = {}
    return {"data_items": data, "dl_assets": dls, "interpreted": interpreted}


def main() -> int:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    lines = read_lines()
    table = parse_table(lines)
    bodies = parse_bodies(lines)
    rows = []
    asset_users: dict[str, list[str]] = defaultdict(list)
    for ent in table:
        body = bodies.get(ent["label"], {})
        parsed = parse_map_body(body)
        assets = []
        for addr in parsed["dl_assets"]:
            rel_png = tilemap_png_for(addr)
            asset = {
                "address": addr,
                "bank": addr[:2],
                "classification": classify_asset(addr),
                "preview_png": rel_png,
            }
            assets.append(asset)
            asset_users[addr].append(ent["map_id_hex"] + " " + ent["label"])
        interp = parsed["interpreted"]
        rows.append({
            **ent,
            "definition_address": body.get("address", ""),
            "graphic_preset": interp.get("graphic_preset", ""),
            "screen_config_or_flag": interp.get("screen_config_or_flag", ""),
            "unknown_0181": interp.get("unknown_0181", ""),
            "unknown_0182": interp.get("unknown_0182", ""),
            "tilemap_count": interp.get("tilemap_count", ""),
            "charactermap_count": interp.get("charactermap_count", ""),
            "dl_asset_count": len(assets),
            "dl_assets": ";".join(a["address"] for a in assets),
            "tilemap_pngs": ";".join(a["preview_png"] for a in assets if a["preview_png"]),
            "assets": assets,
        })

    # CSV
    csv_fields = [
        "map_id_hex", "map_id_dec", "label", "definition_address", "table_comment",
        "graphic_preset", "screen_config_or_flag", "unknown_0181", "unknown_0182",
        "tilemap_count", "charactermap_count", "dl_asset_count", "dl_assets", "tilemap_pngs",
    ]
    with (OUT_DIR / "map_graphics_catalog.csv").open("w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=csv_fields)
        w.writeheader()
        for row in rows:
            w.writerow({k: row.get(k, "") for k in csv_fields})

    # JSON
    (OUT_DIR / "map_graphics_catalog.json").write_text(json.dumps(rows, indent=2, ensure_ascii=False), encoding="utf-8")

    total_assets = sum(len(r["assets"]) for r in rows)
    unique_assets = sorted(asset_users)
    unknown_maps = [r for r in rows if "Unknown" in r["label"]]
    maps_with_png = sum(1 for r in rows if r["tilemap_pngs"])
    top_reused = sorted(asset_users.items(), key=lambda kv: (-len(kv[1]), kv[0]))[:30]

    md = []
    md.append("# Decomp Pass 06 - Catalogo de mapas e assets graficos\n")
    md.append("Esta passada mapeia a tabela `Maps_Graphics_Table` e os assets `dl $xxxxxx` usados por cada mapa/camada.\n")
    md.append("## Resumo\n")
    md.append(f"- Entradas na tabela de mapas/camadas: **{len(rows)}**\n")
    md.append(f"- Referencias `dl` encontradas nessas entradas: **{total_assets}**\n")
    md.append(f"- Assets unicos referenciados: **{len(unique_assets)}**\n")
    md.append(f"- Entradas com preview PNG em `tilemaps/`: **{maps_with_png}**\n")
    md.append(f"- Entradas ainda marcadas como `MapUnknown*`: **{len(unknown_maps)}**\n")
    md.append("\n## Arquivos gerados\n")
    md.append("- `map_graphics_catalog.csv` - tabela editavel/filtravel.\n")
    md.append("- `map_graphics_catalog.json` - dados estruturados.\n")
    md.append("- `map_asset_usage.md` - assets mais reutilizados.\n")
    md.append("- `map_asset_viewer.html` - visualizador pesquisavel de mapas/tilemaps.\n")
    md.append("\n## Entradas principais\n\n")
    md.append("| ID | Label | Addr | Preset | Tilemaps | CharMaps | Assets | Comentario |\n")
    md.append("|---:|---|---:|---:|---:|---:|---|---|\n")
    for r in rows:
        md.append(f"| {r['map_id_hex']} | `{r['label']}` | `{r['definition_address']}` | `{r['graphic_preset']}` | `{r['tilemap_count']}` | `{r['charactermap_count']}` | `{r['dl_assets']}` | {r['table_comment']} |\n")
    (OUT_DIR / "map_graphics_catalog.md").write_text("".join(md), encoding="utf-8")

    usage = []
    usage.append("# Uso/reuso de assets de mapa\n\n")
    usage.append("Assets reutilizados indicam tilesets/camadas compartilhadas entre estacoes, locais ou telas especiais.\n\n")
    usage.append("| Asset | Tipo inferido | Usado por | Qtde | Preview |\n")
    usage.append("|---:|---|---|---:|---|\n")
    for addr, users in top_reused:
        preview = tilemap_png_for(addr)
        usage.append(f"| `${addr}` | {classify_asset(addr)} | {', '.join('`'+u+'`' for u in users[:12])}{'...' if len(users)>12 else ''} | {len(users)} | `{preview}` |\n")
    (OUT_DIR / "map_asset_usage.md").write_text("".join(usage), encoding="utf-8")

    # HTML simples com preview dos PNGs existentes.
    cards = []
    for r in rows:
        pngs = []
        for a in r["assets"]:
            if a["preview_png"]:
                rel = "../../../" + a["preview_png"]
                pngs.append(f'<figure><img src="{html.escape(rel)}" alt="{a["address"]}"><figcaption>{a["address"]}</figcaption></figure>')
            else:
                pngs.append(f'<span class="asset noimg">{html.escape(a["address"])}<small>{html.escape(a["classification"])}</small></span>')
        cards.append(f'''
<section class="card" data-search="{html.escape((r['map_id_hex']+' '+r['label']+' '+r['table_comment']+' '+r['dl_assets']).lower())}">
  <h2>{r['map_id_hex']} - {html.escape(r['label'])}</h2>
  <p><b>Addr:</b> {html.escape(r['definition_address'])} <b>Preset:</b> {html.escape(str(r['graphic_preset']))} <b>Tilemaps:</b> {html.escape(str(r['tilemap_count']))} <b>CharMaps:</b> {html.escape(str(r['charactermap_count']))}</p>
  <p class="comment">{html.escape(r['table_comment'])}</p>
  <div class="assets">{''.join(pngs) if pngs else '<em>Sem assets dl detectados</em>'}</div>
</section>''')
    html_doc = f'''<!doctype html>
<html lang="pt-br"><head><meta charset="utf-8"><title>HM Map Asset Viewer - Pass 06</title>
<style>
body{{font-family:Arial, sans-serif;background:#111;color:#eee;margin:0;padding:24px}}h1{{margin-top:0}}input{{width:100%;padding:12px;font-size:16px;border-radius:8px;border:1px solid #555;background:#222;color:#fff;margin:12px 0 24px}}.grid{{display:grid;grid-template-columns:repeat(auto-fill,minmax(360px,1fr));gap:16px}}.card{{background:#1b1b1b;border:1px solid #333;border-radius:12px;padding:14px;box-shadow:0 4px 18px #0006}}.card h2{{font-size:17px;margin:0 0 8px;color:#fff}}.comment{{color:#b9b9b9;min-height:1.2em}}.assets{{display:flex;flex-wrap:wrap;gap:8px;align-items:flex-start}}figure{{margin:0;background:#0d0d0d;border:1px solid #333;border-radius:8px;padding:6px}}img{{max-width:150px;max-height:120px;image-rendering:pixelated;display:block}}figcaption{{font-size:12px;color:#bbb;text-align:center;margin-top:4px}}.asset{{display:inline-flex;flex-direction:column;background:#292929;border:1px solid #444;border-radius:8px;padding:8px;font-family:monospace}}.asset small{{color:#aaa;font-family:Arial,sans-serif;margin-top:4px}}.hidden{{display:none}}</style>
</head><body><h1>Harvest Moon SNES - Map Asset Viewer / Pass 06</h1>
<p>Visualizador local gerado a partir de <code>src/maps/Maps_Graphics.asm</code>. Pesquise por ID, label, comentario ou endereco de asset.</p>
<input id="q" placeholder="Pesquisar: farm, town, B6, MapUnknown, 92D3AB...">
<div id="count"></div><div class="grid">{''.join(cards)}</div>
<script>
const q=document.getElementById('q'), cards=[...document.querySelectorAll('.card')], count=document.getElementById('count');
function f(){{let s=q.value.toLowerCase().trim(), n=0; for(const c of cards){{const ok=!s||c.dataset.search.includes(s); c.classList.toggle('hidden',!ok); if(ok)n++;}} count.textContent=n+' entradas visiveis / '+cards.length;}}
q.addEventListener('input',f); f();
</script></body></html>'''
    (OUT_DIR / "map_asset_viewer.html").write_text(html_doc, encoding="utf-8")

    print(f"OK: {len(rows)} entradas, {total_assets} refs dl, {len(unique_assets)} assets unicos.")
    print(f"Saida: {OUT_DIR}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
