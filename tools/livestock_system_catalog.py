#!/usr/bin/env python3
from __future__ import annotations
import csv, html, json, re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SRC = ROOT / 'src'
OUT = ROOT / 'reports' / 'decomp_pass10' / 'livestock'
OUT.mkdir(parents=True, exist_ok=True)

ASM_FILES = sorted(SRC.rglob('*.asm'))
KEYWORDS = [
    'cow', 'Cow', 'COW', 'chicken', 'Chicken', 'CHICK', 'chick', 'Chick',
    'dog', 'Dog', 'horse', 'Horse', 'animal', 'Animal', 'feed', 'Feed',
    'milk', 'Milk', 'egg', 'Egg', 'pregnant', 'Pregnant', 'barn', 'Barn', 'coop', 'Coop'
]

LABEL_RE = re.compile(r'^\s*([A-Za-z_][A-Za-z0-9_]*):\s*(?:;([0-9A-Fa-f]{6}))?')
ADDR_RE = re.compile(r';([0-9A-Fa-f]{6});')
HEX_RE = re.compile(r'\$([0-9A-Fa-f]{2,4})')

def lines_for(path: Path):
    return path.read_text(errors='ignore').splitlines()

def collect_xrefs():
    rows=[]
    for f in ASM_FILES:
        rel=str(f.relative_to(ROOT))
        for idx,line in enumerate(lines_for(f),1):
            if any(k in line for k in KEYWORDS):
                # keep comments and code terms, skip text pointer table flood? no, include but categorize
                cat='other'
                low=line.lower()
                if any(k in low for k in ['cow', 'barn', 'milker']): cat='cow'
                if any(k in low for k in ['chicken','chick','egg','coop']): cat='chicken'
                if 'dog' in low: cat='dog'
                if 'horse' in low: cat='horse'
                if 'feed' in low: cat='feed'
                if 'text_' in line: cat='text_pointer'
                rows.append({'file':rel,'line':idx,'category':cat,'text':line.rstrip()})
    return rows

def find_labels():
    rows=[]
    for f in ASM_FILES:
        rel=str(f.relative_to(ROOT))
        for idx,line in enumerate(lines_for(f),1):
            m=LABEL_RE.match(line)
            if not m: continue
            label=m.group(1)
            if any(k.lower() in label.lower() for k in ['cow','chicken','chick','dog','horse','livestock','barn','coop','egg','milk','feed']):
                addr=m.group(2) or ''
                rows.append({'label':label,'addr':addr,'file':rel,'line':idx})
    return rows

def parse_words_after_label(src_text: str, label: str, max_words=64):
    # starts at label line; collect hex values from following db/dw lines until next label-ish or blank block after data
    lines=src_text.splitlines()
    start=None
    for i,l in enumerate(lines):
        if re.match(r'^\s*'+re.escape(label)+r':', l):
            start=i; break
    if start is None: return []
    vals=[]
    for l in lines[start:start+20]:
        if l.strip().startswith(';'):
            continue
        # stop if a later non-local label starts and has no db/dw continuation
        if l is not lines[start] and LABEL_RE.match(l) and not re.search(r'\b(db|dw)\b', l):
            break
        for h in HEX_RE.findall(l):
            vals.append(int(h,16))
            if len(vals)>=max_words: return vals
    return vals

def make_spawn_tables():
    bank83=(SRC/'code_banks'/'bank_83.asm').read_text(errors='ignore')
    chicken_vals=parse_words_after_label(bank83, 'Chicken_CoopSpawnPositionTable', 26)
    cow_vals=parse_words_after_label(bank83, 'Cow_BarnSpawnPositionTable', 26)
    def pairs(vals):
        return [{'slot':i,'x':vals[i*2],'y':vals[i*2+1],'x_hex':f'${vals[i*2]:04X}','y_hex':f'${vals[i*2+1]:04X}'} for i in range(len(vals)//2)]
    return pairs(chicken_vals), pairs(cow_vals)

def write_csv(path, rows, fields=None):
    rows=list(rows)
    if not fields:
        fields=list(rows[0].keys()) if rows else []
    with open(path,'w',newline='',encoding='utf-8') as fh:
        w=csv.DictWriter(fh,fieldnames=fields)
        w.writeheader(); w.writerows(rows)

def md_table(rows, fields, limit=None):
    rows=list(rows)
    if limit: rows=rows[:limit]
    out=['|'+'|'.join(fields)+'|','|'+'|'.join(['---']*len(fields))+'|']
    for r in rows:
        out.append('|'+'|'.join(str(r.get(f,'')) for f in fields)+'|')
    return '\n'.join(out)

def main():
    xrefs=collect_xrefs()
    labels=find_labels()
    chicken_spawns,cow_spawns=make_spawn_tables()

    write_csv(OUT/'livestock_xrefs.csv', xrefs, ['file','line','category','text'])
    write_csv(OUT/'livestock_labels.csv', labels, ['label','addr','file','line'])
    write_csv(OUT/'chicken_spawn_positions.csv', chicken_spawns, ['slot','x_hex','y_hex','x','y'])
    write_csv(OUT/'cow_spawn_positions.csv', cow_spawns, ['slot','x_hex','y_hex','x','y'])
    (OUT/'livestock_labels.json').write_text(json.dumps(labels,indent=2),encoding='utf-8')

    # inferred structures from direct pointer functions and offsets used in bank_83
    structs_md = '''# Estruturas de RAM - animais / livestock\n\nEste arquivo documenta a leitura atual das estruturas de animais. Ainda e engenharia reversa incremental, mas ja e suficiente para evitar edicoes cegas.\n\n## Chicken slot\n\nBase calculada por `GetChickenPointer`: `$7E:C286 + slot * 8`.\n\nTamanho: **8 bytes por galinha**, ate **13 slots**.\n\n| Offset | Tamanho | Leitura atual | Observacao |\n|---:|---:|---|---|\n| `$00` | 8-bit | status/flags | bit `$01` existe; `$02` ovo chocando; `$04` pintinho; `$08` adulto/ativo; `$10` cranky/unfed; `$20` ignorar em spawn; outros ainda em analise |\n| `$01` | 8-bit | map/area ou localizacao logica | `$28` aparece como coop/feed check; valores `< $04` indicam fazenda/outdoor por grupo |\n| `$02` | 8-bit | timer/idade/cranky | usado para hatch/growth e countdown de cranky |\n| `$03` | 8-bit | desconhecido | pouco usado na rotina analisada |\n| `$04` | 16-bit | pos X | posicao do objeto quando renderizado/spawnado |\n| `$06` | 16-bit | pos Y | posicao do objeto quando renderizado/spawnado |\n\n## Cow slot\n\nBase calculada por `GetCowPointer`: `$7E:C1C6 + slot * 16`.\n\nTamanho: **16 bytes por vaca**, ate **12 slots**.\n\n| Offset | Tamanho | Leitura atual | Observacao |\n|---:|---:|---|---|\n| `$00` | 8-bit | status/flags | `$01` existe, `$02` baby/pregnancy-born state, `$04` child, `$08` adult/healthy child/adult flow, `$10` cranky, `$20` sick, `$40` pregnant, `$80` birth pending/special |\n| `$01` | 8-bit | daily flags | bit `$80` usado como gatilho de gravidez/milked-today-like flag; zera com `AND #$F8` no ciclo diario |\n| `$02` | 8-bit | map/area | `$27` barn; `< $04` outdoor/farm group |\n| `$03` | 8-bit | timer | gravidez, idade ou countdown de cranky/doenca dependendo do status |\n| `$04` | 8-bit | happiness | usado para calcular felicidade inicial do bezerro |\n| `$05` | 8-bit | contador/estado auxiliar | se `#$0A`, pode virar cranky |\n| `$06-$07` | 16-bit | ainda incerto | pouco tocado nesta passada |\n| `$08` | 16-bit | pos X no barn/farm | usado para spawn do objeto |\n| `$0A` | 16-bit | pos Y no barn/farm | usado para spawn do objeto |\n| `$0C-$0F` | 4 bytes | nome da vaca | preenchido apos compra/nascimento |\n\n## Flags globais relacionados\n\n| Simbolo/endereco | Uso atual |\n|---|---|\n| `!cow_N` | quantidade de vacas |\n| `!chicks_N` | quantidade de galinhas adultas/pintinhos ativos |\n| `!fed_cows_flags` | bitmask de vacas alimentadas no barn |\n| `!fed_cows_N` | contador de vacas alimentadas |\n| `!fed_chicks_N` | contador de galinhas alimentadas |\n| `!feed_cow_N` | quantidade de racoes de vaca disponiveis |\n| `!feed_chicks_N` | quantidade de racoes de galinha disponiveis |\n| `$7F1F6E` | flags de eventos livestock: funeral cow, egg/chicken flags, born flag etc. ainda parcial |\n'''
    (OUT/'livestock_memory_structures.md').write_text(structs_md,encoding='utf-8')

    flow_md = f'''# Catalogo Pass 10 - livestock\n\n## Resumo\n\n- Labels relacionados a animais encontrados: **{len(labels)}**.\n- Referencias relacionadas a animais/feed/egg/milk encontradas: **{len(xrefs)}**.\n- Spawn slots de galinha catalogados: **{len(chicken_spawns)}**.\n- Spawn slots de vaca catalogados: **{len(cow_spawns)}**.\n\n## Labels principais\n\n{md_table(labels, ['label','addr','file','line'], limit=80)}\n\n## Spawn positions - galinhas\n\n{md_table(chicken_spawns, ['slot','x_hex','y_hex','x','y'])}\n\n## Spawn positions - vacas\n\n{md_table(cow_spawns, ['slot','x_hex','y_hex','x','y'])}\n\n## Xrefs por categoria\n\n'''
    cats={}
    for r in xrefs: cats[r['category']]=cats.get(r['category'],0)+1
    flow_md += md_table([{'category':k,'refs':v} for k,v in sorted(cats.items())], ['category','refs'])
    (OUT/'livestock_catalog.md').write_text(flow_md,encoding='utf-8')

    # HTML viewer
    def tr(cells): return '<tr>' + ''.join(f'<td>{html.escape(str(c))}</td>' for c in cells) + '</tr>'
    html_doc = f'''<!doctype html><html lang="pt-BR"><meta charset="utf-8"><title>HM Livestock Catalog - Pass 10</title>
<style>body{{font-family:Arial, sans-serif;background:#111;color:#eee;margin:24px}}input{{width:100%;padding:12px;background:#222;color:#fff;border:1px solid #555;border-radius:8px;margin:12px 0}}table{{border-collapse:collapse;width:100%;font-size:13px}}td,th{{border:1px solid #333;padding:6px;vertical-align:top}}th{{background:#222;position:sticky;top:0}}.muted{{color:#aaa}}</style>
<h1>Harvest Moon SNES - Livestock Catalog - Pass 10</h1>
<p class="muted">Catalogo pesquisavel de labels/referencias de vacas, galinhas, dog/horse, feed, milk e egg.</p>
<input id="q" placeholder="pesquise: cow, chicken, feed, egg, GetCowPointer, bank_83..." oninput="filter()">
<h2>Labels</h2><table id="labels"><thead><tr><th>Label</th><th>Addr</th><th>Arquivo</th><th>Linha</th></tr></thead><tbody>
{''.join(tr([r['label'],r['addr'],r['file'],r['line']]) for r in labels)}
</tbody></table>
<h2>Xrefs</h2><table id="xrefs"><thead><tr><th>Categoria</th><th>Arquivo</th><th>Linha</th><th>Texto</th></tr></thead><tbody>
{''.join(tr([r['category'],r['file'],r['line'],r['text']]) for r in xrefs)}
</tbody></table>
<script>function filter(){{let q=document.getElementById('q').value.toLowerCase();for(const tb of document.querySelectorAll('tbody')){{for(const tr of tb.rows){{tr.style.display=tr.textContent.toLowerCase().includes(q)?'':'none';}}}}}}</script>
</html>'''
    (OUT/'livestock_catalog_viewer.html').write_text(html_doc,encoding='utf-8')
    print(f'wrote {OUT}')
    print(f'labels={len(labels)} xrefs={len(xrefs)} chicken_spawns={len(chicken_spawns)} cow_spawns={len(cow_spawns)}')

if __name__=='__main__':
    main()
