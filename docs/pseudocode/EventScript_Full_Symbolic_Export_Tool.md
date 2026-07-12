# Pseudocode - EventScript Full Symbolic Export Tool

```text
open clean USA ROM
validate MD5 == c9bf36a816b6d54aed79d43a6c45111a
read master group pointer table at $B3:8000
for each group 00..47:
    read group pointer table
    compute each script target boundary from next unique target
    decode commands using Pass57 opcode table
    stop at boundary, stop/wait opcode, unknown opcode or max command limit
    write one markdown file for that group
    collect:
        command classes
        opcodes
        unknown count
        first opcodes
        RAM/flag dependencies from Pass57 dependency CSV
        text ids from Pass57 dependency CSV
    classify group into semantic bucket
write global CSV index
write global semantic map
write RAM role hints markdown
```

## Safety properties

```text
no dialog text extraction
no ROM patching
no source data rewrite
source ASM comments only
rebuild must remain byte-perfect
```
