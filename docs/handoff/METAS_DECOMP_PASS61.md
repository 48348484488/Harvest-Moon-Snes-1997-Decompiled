# METAS DECOMP PASS 61

## Concluido

- Fechada a familia high-bank local `DATA8_`.
- Nomeadas rotinas auxiliares do GOBJ visual de acao do jogador.
- Nomeada tabela de prompt accept do TextBox.
- Build validado byte-perfect.

## Proxima meta recomendada

Pass 62 pode focar em uma destas opcoes:

1. `DATA8_00xxxx` de text/dialog pointers usados em `bank_81`.
2. `DATA8_00xxxx` consumidos por `bank_84` em menus/prompt/shop.
3. Um pacote pequeno de `CODE_81Dxxx` dentro das state machines de map tile patch/dialog.

Evitar renomeacao automatica massiva de `CODE_`, pois ainda ha muitas branches internas que precisam contexto.
