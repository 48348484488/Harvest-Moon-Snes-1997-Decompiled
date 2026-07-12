# Metas para continuar depois da Pass 58

## Estado herdado

A Pass 58 exportou todos os grupos B3-B5 para pseudocodigo simbolico por grupo.

Arquivos para abrir primeiro:

```text
reports/event_script_full_symbolic_export_pass58.md
reports/event_script_group_semantic_map_pass58.csv
reports/event_script_groups_pass58/EventScriptGroup_44.md
reports/event_script_groups_pass58/EventScriptGroup_04.md
reports/event_script_groups_pass58/EventScriptGroup_07.md
```

## Melhor Pass 59

Prioridade 1: reduzir opcodes desconhecidos dominantes.

Prioridade 2: renomear scripts familiares/romance com base em text ids + RAM:

- `marriage_flags`
- `family_event_flags`
- `child_flags`
- `wife_pregnancy`
- `hearts_maria`
- `hearts_ann`
- `hearts_nina`
- `hearts_ellen`
- `hearts_eve`
- `season`, `day`, `hour`, `weekday`

Prioridade 3: mapear `EventScriptGroup_00` contra sprites/GOBJ de animais/objetos.

## Regra obrigatoria

Toda alteracao de label ou tabela deve terminar com rebuild e MD5:

```text
c9bf36a816b6d54aed79d43a6c45111a
```
