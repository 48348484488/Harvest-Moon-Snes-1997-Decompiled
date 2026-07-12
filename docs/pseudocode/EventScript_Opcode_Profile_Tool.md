# Pseudocodigo - EventScript Opcode Profile Tool

```text
function build_opcode_profile(rom):
    groups = read EventScript_MasterGroupPointerTable at $B3:8000

    for each group in groups:
        table = group.pointer_table
        targets = unique 16-bit targets in same bank

        for each target in targets:
            ptr = target
            while ptr is before next target boundary:
                opcode = read8(ptr)
                classify opcode
                count opcode
                count semantic class

                if opcode has unknown size:
                    stop this entry

                if opcode is stop/wait:
                    stop this entry

                ptr += 1 + payload_size(opcode)

        summarize group:
            opcode histogram
            class histogram
            first opcode histogram
            semantic tags
            stop reasons

    write group CSV
    write entry CSV
    write markdown summary
    write priority ranking
```

## Importante

A ferramenta nao e um disassembler completo de EventScript. Ela e um radar para guiar as proximas passes.

Ela evita seguir branches porque muitos comandos de evento podem alterar o ponteiro de script de acordo com flags, RNG, texto, mapa e estado do slot CC. Seguir isso automaticamente sem contexto poderia produzir nomes errados.
