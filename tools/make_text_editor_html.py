#!/usr/bin/env python3
"""Generate a local searchable HTML helper for HM text editing."""
from __future__ import annotations
import argparse, csv, html, json
from pathlib import Path


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--repo", default=".")
    ap.add_argument("--csv", default="reports/decomp_pass04/text/text_edit_template.csv")
    ap.add_argument("--out", default="reports/decomp_pass04/text/text_editor_helper.html")
    args = ap.parse_args()
    repo = Path(args.repo)
    csv_path = repo / args.csv
    out_path = repo / args.out
    rows = list(csv.DictReader(csv_path.open(encoding="utf-8")))
    # Keep payload compact.
    payload = [{k: r.get(k, "") for k in ["index_hex", "bank", "snes_addr", "label", "category", "max_words", "markup_text"]} for r in rows]
    data = json.dumps(payload, ensure_ascii=False)
    doc = f'''<!doctype html>
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Harvest Moon SNES Text Editor Helper</title>
<style>
:root {{ color-scheme: dark; --bg:#101217; --panel:#181c24; --line:#2b3240; --text:#eef2ff; --muted:#9aa4b2; --accent:#8ab4ff; }}
* {{ box-sizing:border-box; }}
body {{ margin:0; font-family:system-ui,Segoe UI,Arial,sans-serif; background:var(--bg); color:var(--text); }}
header {{ position:sticky; top:0; background:linear-gradient(180deg,#171b23,#101217); border-bottom:1px solid var(--line); padding:16px; z-index:2; }}
h1 {{ margin:0 0 10px; font-size:20px; }}
.controls {{ display:grid; grid-template-columns: 1fr 170px 140px; gap:10px; }}
input, select, textarea {{ width:100%; background:#0c0f14; color:var(--text); border:1px solid var(--line); border-radius:10px; padding:10px; }}
main {{ padding:16px; display:grid; gap:12px; }}
.card {{ background:var(--panel); border:1px solid var(--line); border-radius:14px; padding:14px; }}
.meta {{ color:var(--muted); font-size:12px; display:flex; gap:10px; flex-wrap:wrap; margin-bottom:8px; }}
.label {{ color:var(--accent); font-family:ui-monospace,Consolas,monospace; }}
pre {{ white-space:pre-wrap; overflow-wrap:anywhere; background:#0c0f14; border:1px solid var(--line); border-radius:10px; padding:10px; }}
button {{ background:#263143; color:var(--text); border:1px solid #3a4658; border-radius:10px; padding:8px 10px; cursor:pointer; }}
button:hover {{ border-color:var(--accent); }}
.small {{ font-size:12px; color:var(--muted); }}
@media (max-width:760px) {{ .controls {{ grid-template-columns:1fr; }} }}
</style>
</head>
<body>
<header>
<h1>Harvest Moon SNES - Text Editor Helper</h1>
<div class="controls">
<input id="q" placeholder="Buscar por texto, label, banco, categoria...">
<select id="cat"><option value="">Todas categorias</option></select>
<select id="bank"><option value="">Todos bancos</option></select>
</div>
<div class="small" id="count"></div>
</header>
<main id="list"></main>
<script>
const DATA = {data};
const q = document.getElementById('q');
const cat = document.getElementById('cat');
const bank = document.getElementById('bank');
const list = document.getElementById('list');
const count = document.getElementById('count');
function esc(s) {{ return String(s ?? '').replace(/[&<>"']/g, m => ({{'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}}[m])); }}
function fillFilters() {{
  [...new Set(DATA.map(x => x.category).filter(Boolean))].sort().forEach(v => cat.insertAdjacentHTML('beforeend', `<option>${{esc(v)}}</option>`));
  [...new Set(DATA.map(x => x.bank).filter(Boolean))].sort().forEach(v => bank.insertAdjacentHTML('beforeend', `<option>${{esc(v)}}</option>`));
}}
async function copyText(text) {{ try {{ await navigator.clipboard.writeText(text); }} catch(e) {{ prompt('Copie:', text); }} }}
function render() {{
  const term = q.value.trim().toLowerCase();
  const rows = DATA.filter(x => (!cat.value || x.category === cat.value) && (!bank.value || x.bank === bank.value) && (!term || JSON.stringify(x).toLowerCase().includes(term))).slice(0, 250);
  count.textContent = `${{rows.length}} mostrado(s) de ${{DATA.length}}. Limite visual: 250 resultados.`;
  list.innerHTML = rows.map(x => `<section class="card"><div class="meta"><span>#${{esc(x.index_hex)}}</span><span>${{esc(x.bank)}}:${{esc(x.snes_addr)}}</span><span>${{esc(x.category)}}</span><span>max words: ${{esc(x.max_words)}}</span></div><div class="label">${{esc(x.label)}}</div><pre>${{esc(x.markup_text)}}</pre><button onclick="copyText('${{String(x.markup_text).replace(/\\/g,'\\\\').replace(/'/g,"\\'").replace(/\n/g,'\\n')}}')">copiar texto</button> <button onclick="copyText('${{esc(x.label)}}')">copiar label</button></section>`).join('');
}}
fillFilters();
[q, cat, bank].forEach(el => el.addEventListener('input', render));
render();
</script>
</body>
</html>'''
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(doc, encoding="utf-8")
    print(f"Wrote {out_path} ({len(rows)} rows)")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
