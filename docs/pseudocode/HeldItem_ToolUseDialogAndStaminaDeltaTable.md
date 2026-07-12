# HeldItem_ToolUseDialogAndStaminaDeltaTable

Tabela compacta usada pela logica de item/ferramenta na mao.

## Estrutura inferida

```text
record[n]:
  word text_id
  byte stamina_delta
```

## Fluxo de uso

```text
index = (held_item_id - 1) * 3
text_id = table[index + 0..1]
TextBox_StartByTextId(text_id)

stamina_delta = table[index + 2]
Stamina_ApplyDeltaAndFatigueState(stamina_delta)
```

A inferencia vem do acesso em `bank_81.asm`: uma leitura word inicial e enviada para `TextBox_StartByTextId`; depois a rotina soma `+2` no mesmo registro e envia o byte para `Stamina_ApplyDeltaAndFatigueState`.
