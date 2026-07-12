# Metas recomendadas apos Pass 56

A Pass 56 criou o radar de prioridade para os scripts B3-B5. As proximas passes devem parar de escolher grupos no escuro.

## Proximas metas sugeridas

| Pass | Meta | Observacao |
|---:|---|---|
| 57 | EventScriptGroup_00 Deep Profile | Maior grupo; provavelmente contem muitos scripts de interacao/cenas basicas. |
| 58 | EventScriptGroup_44/43 B5 Scene Profile | Bancos B5 tem grupos densos e menores, bons para nomeacao manual. |
| 59 | Dialog/Flag Script Cross Reference | Cruzar `1C/1D/21` com textos e flags para inferir NPC/cena. |
| 60 | EventScript Caller Cross Reference | Rastrear quem carrega cada grupo a partir dos bancos 81/84/mapas. |

## Regra de seguranca

Nao renomear `EventScriptGroup_XX` para nome final de cena sem confirmar origem de chamada.

Use primeiro:

```text
reports/event_script_decomp_priority_b3_b5.md
reports/event_script_opcode_profile_groups.csv
reports/event_script_opcode_profile_entries.csv
```
