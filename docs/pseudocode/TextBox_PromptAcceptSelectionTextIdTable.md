# TextBox Prompt Accept Selection TextId Table

`TextBox_PromptAcceptSelectionTextIdTable` e consumida por `PromptCursorInput_AcceptSelectionOrStartText` no banco `84`.

Quando o estado/selecao em `$018A` e menor que `$0B`, o valor e usado como indice de word na tabela. O resultado vira X e e passado para `TextBox_StartByTextId`.

Pseudocodigo:

```text
if $018A < 0x0B:
    text_id = TextBox_PromptAcceptSelectionTextIdTable[$018A]
    $0191 = 0
    TextBox_StartByTextId(text_id)
else:
    inputstate = 1
    TextBox_QueuePromptCursorTileDMA(1)
```
