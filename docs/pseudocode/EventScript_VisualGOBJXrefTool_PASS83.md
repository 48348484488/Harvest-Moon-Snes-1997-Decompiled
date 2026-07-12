# EventScript Visual/GOBJ Xref Tool - PASS83

Entrada principal: `reports/pass82_eventscript_entry_ownership_xref.csv`.

Processo:

1. Varre as 1288 entradas EventScript.
2. Seleciona entradas com `visual_pointer_refs`.
3. Extrai comandos visuais no pseudocodigo: `SetCCObjectVisual`, `SetCCObjectPointer`, `SpawnOrMoveCCObject`, `DropItemAnimation`, `SetAnimation`, comandos `SetCCObjectParam*` e afins.
4. Classifica cada token `$xxxx` como ponteiro candidato, parametro imediato, WRAM/runtime, alvo local B3-B5 ou ponteiro de banco.
5. Emite tabelas CSV por entrada, por referencia, por grupo e por dominio visual.

Limite: a ferramenta nao converte todos os ponteiros em nomes finais de sprites. Ela cria a camada rastreavel para essa nomeacao posterior.
