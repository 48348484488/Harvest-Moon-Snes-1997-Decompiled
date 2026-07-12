# Pseudocode - Pass 86 Visual Low/Manual Resolver

```text
for each visual/GOBJ reference from Pass85:
    if confidence != low:
        preserve Pass85 alias
    else if low-word resolves into B3/B4/B5 event-script source region:
        classify as local EventScript branch/table anchor
    else if value is 0x8000-0x8FFF and used by SetCCObjectVisual/Pointer/Param commands:
        classify as CC visual/animation pointer, not final GOBJ id
    else:
        classify as contextual immediate/state value

rewrite refined xref tables with Pass86 aliases
emit remaining_low_manual_targets = empty
```
