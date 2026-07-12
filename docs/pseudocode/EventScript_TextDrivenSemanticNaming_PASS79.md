# Pseudocode - Pass 79 text-driven semantic naming

```text
for each direct_dialog_row in pass78_xref:
    group = row.group
    entry = row.entry
    text_id = row.text_id
    label = row.text_label
    role = row.inferred_role
    category = row.text_category

for each group:
    count categories and roles
    choose group semantic name
    record confidence and reason

for each (group, entry, target):
    combine strongest roles/categories/person names
    produce proposed alias
    keep text labels/previews as audit evidence
```

The generated aliases are metadata. They are not hard-renamed into executable source labels until cross-checked with NPC/RAM/GOBJ evidence.
```
