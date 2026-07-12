# Pseudocode - Pass80 group semantic closure

```text
load pass73 group semantic map
load pass79 direct-dialog names
for group in EventScriptGroup_00..EventScriptGroup_47:
    if group has Pass79 dialog name:
        preserve that name
        confidence = high or medium from Pass79
    else:
        inspect pass73 bucket, dominant classes, dominant opcodes, symbols
        assign structural semantic name
        confidence = medium unless system bucket is already clear
write all 72 names to CSV/MD
append P80 comments to B3 master group pointer table
validate rebuild byte-perfect
package with no ROM
```
