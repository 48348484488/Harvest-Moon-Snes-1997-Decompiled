# Status Pass 56

Escopo fechado: **Event Script Opcode Profile B3-B5**

## Concluido

- Ferramenta `tools/event_script_opcode_profile.py` adicionada.
- Perfil por grupo gerado para os 72 `EventScriptGroup_XX`.
- Perfil por entrada/alvo unico gerado.
- Ranking automatico de prioridade para proximas passes gerado.
- Documentacao de metodologia adicionada.
- Rebuild validado byte-a-byte contra ROM USA limpa.

## Resultado

| Item | Valor |
|---|---:|
| Grupos analisados | 72 |
| Entradas unicas aproximadas | 439 |
| Comandos lineares amostrados | 4190 |
| Comandos conhecidos | 4022 |
| Desconhecidos/nao parseados | 168 |
| MD5 rebuild | `c9bf36a816b6d54aed79d43a6c45111a` |

## Status geral apos a pass

| Area | Antes | Depois |
|---|---:|---:|
| Source recompilavel byte-perfect | 100% | 100% |
| Event Script Core | 100% | 100% |
| Catalogo B3-B5 | 100% | 100% |
| Perfil semantico B3-B5 | 0% | 100% |
| Scripts/cenas/eventos individuais | 45% | 50% |
| NPCs/rotinas/personagens | 33% | 35% |
| Engenharia reversa humana/documentada total | 96% - 98% | 97% - 98% |
