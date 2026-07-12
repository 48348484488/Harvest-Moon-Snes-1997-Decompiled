#!/usr/bin/env python3
"""Build a standalone searchable HTML catalog for the HM SNES text pointer table."""
from __future__ import annotations
import argparse, csv, html, json
from pathlib import Path


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument('--catalog', default='reports/decomp_pass03/text/text_pointer_catalog.csv')
    ap.add_argument('--out', default='reports/decomp_pass03/text/text_catalog_viewer.html')
    args = ap.parse_args()
    rows = list(csv.DictReader(Path(args.catalog).open(encoding='utf-8')))
    data = json.dumps(rows, ensure_ascii=False)
    page = f'''<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Harvest Moon SNES - Text Catalog Pass 03</title>
<style>
:root {{ --bg:#0d1117; --panel:#161b22; --line:#30363d; --text:#e6edf3; --muted:#8b949e; --accent:#58a6ff; }}
* {{ box-sizing:border-box; }}
body {{ margin:0; font-family:Arial,Helvetica,sans-serif; background:var(--bg); color:var(--text); }}
header {{ padding:22px 26px; border-bottom:1px solid var(--line); background:linear-gradient(180deg,#161b22,#0d1117); position:sticky; top:0; z-index:2; }}
h1 {{ margin:0 0 8px; font-size:22px; }}
p {{ margin:0; color:var(--muted); }}
.controls {{ display:flex; gap:10px; flex-wrap:wrap; margin-top:16px; }}
input, select {{ background:#0d1117; color:var(--text); border:1px solid var(--line); border-radius:8px; padding:10px 12px; font-size:14px; }}
input {{ min-width:280px; flex:1; }}
main {{ padding:18px 26px 40px; }}
.stats {{ color:var(--muted); margin-bottom:12px; }}
table {{ width:100%; border-collapse:collapse; background:var(--panel); border:1px solid var(--line); border-radius:10px; overflow:hidden; }}
th, td {{ padding:9px 10px; border-bottom:1px solid var(--line); vertical-align:top; text-align:left; font-size:13px; }}
th {{ color:#fff; background:#21262d; position:sticky; top:121px; z-index:1; }}
code {{ color:#a5d6ff; white-space:nowrap; }}
.preview {{ color:#c9d1d9; max-width:780px; }}
.badge {{ display:inline-block; padding:3px 7px; border:1px solid var(--line); border-radius:999px; color:#d2a8ff; background:#0d1117; }}
</style>
</head>
<body>
<header>
  <h1>Harvest Moon SNES - Text Catalog Pass 03</h1>
  <p>Catalogo pesquisavel da Text_Pointer_Table apos renomear labels genericos de texto.</p>
  <div class="controls">
    <input id="q" placeholder="Buscar por label, texto, endereco, indice...">
    <select id="cat"><option value="">Todas categorias</option></select>
    <select id="bank"><option value="">Todos bancos</option></select>
  </div>
</header>
<main>
  <div class="stats" id="stats"></div>
  <table>
    <thead><tr><th>Index</th><th>Addr</th><th>Bank</th><th>Categoria</th><th>Label</th><th>Preview</th></tr></thead>
    <tbody id="body"></tbody>
  </table>
</main>
<script>
const rows = {data};
const q = document.getElementById('q');
const cat = document.getElementById('cat');
const bank = document.getElementById('bank');
const body = document.getElementById('body');
const stats = document.getElementById('stats');
function esc(s) {{ return String(s ?? '').replace(/[&<>"']/g, m => ({{'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}}[m])); }}
for (const c of [...new Set(rows.map(r=>r.category).filter(Boolean))].sort()) cat.insertAdjacentHTML('beforeend', `<option>${{esc(c)}}</option>`);
for (const b of [...new Set(rows.map(r=>r.bank).filter(Boolean))].sort()) bank.insertAdjacentHTML('beforeend', `<option>${{esc(b)}}</option>`);
function render() {{
  const term = q.value.trim().toLowerCase();
  const c = cat.value; const b = bank.value;
  const filtered = rows.filter(r => (!c || r.category === c) && (!b || r.bank === b) && (!term || JSON.stringify(r).toLowerCase().includes(term)));
  stats.textContent = `${{filtered.length}} de ${{rows.length}} entradas`;
  body.innerHTML = filtered.map(r => `<tr><td><code>$${{esc(r.index_hex)}}</code></td><td><code>$${{esc(r.snes_addr)}}</code></td><td>${{esc(r.bank)}}</td><td><span class="badge">${{esc(r.category)}}</span></td><td><code>${{esc(r.label)}}</code></td><td class="preview">${{esc(r.text_preview)}}</td></tr>`).join('');
}}
q.addEventListener('input', render); cat.addEventListener('change', render); bank.addEventListener('change', render); render();
</script>
</body>
</html>'''
    Path(args.out).parent.mkdir(parents=True, exist_ok=True)
    Path(args.out).write_text(page, encoding='utf-8')
    print(f'Wrote {args.out} with {len(rows)} rows')
    return 0

if __name__ == '__main__':
    raise SystemExit(main())
