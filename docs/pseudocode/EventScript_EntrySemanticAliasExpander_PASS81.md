# EventScript Entry Semantic Alias Expander - Pass 81

Pseudocode:

```text
load full symbolic EventScript entry export
load Pass79 direct-dialog aliases
load Pass80 group semantic names

for each EventScript entry:
    if entry has Pass79 direct text alias:
        preserve it as direct_text_anchor
    else:
        derive suffix from first decoded command
        if no first-command match:
            derive suffix from pseudocode preview
        if no preview match:
            derive suffix from command-class priority
        emit EventScript_Gxx_Entryyyy_<GroupName>_<Suffix>

emit complete CSV index
emit group-level coverage summary
emit remaining human semantic target list
```

This pass is metadata-only and safe for byte-perfect rebuilds.
```
