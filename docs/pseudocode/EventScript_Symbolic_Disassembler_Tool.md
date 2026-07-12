# Pseudocode - EventScript symbolic disassembler tool

## Entrada

```text
python3 tools/event_script_symbolic_disasm.py --rom "roms/Harvest Moon (USA).sfc"
```

## Processo

1. Confere MD5 da ROM USA limpa.
2. Le a tabela mestre em `$B3:8000`.
3. Descobre o tamanho de cada tabela de grupo pelo primeiro ponteiro interno.
4. Decodifica cada entrada ate:
   - proximo alvo conhecido;
   - opcode de stop/wait;
   - opcode desconhecido;
   - limite conservador de comandos.
5. Escreve CSV completo e relatorio Markdown para os grupos prioritarios.

## Saida

```text
reports/event_script_symbolic_index_pass57.csv
reports/event_script_symbolic_group_summary_pass57.csv
reports/event_script_symbolic_disasm_priority_b3_b5.md
reports/event_script_symbolic_opcode_reference_pass57.md
```

## Politica da ferramenta

A ferramenta nao exporta dialogos. Ela mostra apenas IDs, por exemplo:

```text
StartTextBox(text_id=$0212, mode=$00)
```
