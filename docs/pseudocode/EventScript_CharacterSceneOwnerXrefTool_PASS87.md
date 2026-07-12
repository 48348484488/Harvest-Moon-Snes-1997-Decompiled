# EventScript Character Scene Owner Xref Tool - PASS 87

Entrada:

- `pass78_eventscript_direct_dialog_text_xref.csv`
- `pass81_eventscript_all_entry_semantic_aliases.csv`
- `pass82_eventscript_entry_ownership_xref.csv`
- `pass86_eventscript_visual_named_xref_refined.csv`
- `pass80_eventscript_all_group_semantic_names.csv`

Processo:

1. Agrupa os dialogos diretos por `(group, entry)`.
2. Procura nomes exatos de bachelorettes com regex para evitar falsos positivos como `every`/`even`.
3. Usa labels/text preview para identificar familia, casamento, igreja, festival, animais, clima, status e servicos.
4. Para entradas sem texto direto, usa dominio Pass82, grupo Pass80 e evidencia visual Pass86.
5. Gera uma linha final por entrada EventScript com owner, tipo, confianca e evidencia.

Saida principal:

- `reports/pass87_eventscript_character_scene_owner_xref.csv`
