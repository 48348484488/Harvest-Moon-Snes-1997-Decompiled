# DECOMP PASS 91 - Domain-Specific Exact Area Closure

Pass 91 refines the Pass 90 final confirmation queue. It promotes domain-specific EventScript lanes to exact area-level names where the existing evidence is already narrow enough: animal/livestock, farm/crop/weather, festival, and shipping/status.

## Results

| Metric | Value |
|---|---:|
| EventScript entries processed | 1288/1288 |
| Entries closed total after Pass 91 | 336/1288 (26.087%) |
| Entries closed specifically by Pass 91 domain closure | 268/1288 (20.807%) |
| Entries still pending structural exact name | 952/1288 (73.913%) |
| Confirmation units closed | 70/163 (42.945%) |
| Confirmation units pending | 93/163 (57.055%) |

## Closed domains

- Animal/livestock event lanes.
- Farm/crop/weather event lanes.
- Festival event lanes.
- Shipping/status event lanes.

## Remaining work

The remaining work is no longer broad domain identification. It is exact structural naming for family/romance/NPC/cutscene lanes and final sprite/GOBJ naming for a small visual lane.

## Build validation

Rebuild remains byte-perfect against the clean USA ROM.

```text
MD5 original: c9bf36a816b6d54aed79d43a6c45111a
MD5 rebuild:  c9bf36a816b6d54aed79d43a6c45111a
Result: OK, byte-perfect rebuild.
```
