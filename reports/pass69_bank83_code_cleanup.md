# Pass 69 - Bank 83 CODE_ Cleanup

Objetivo: zerar os labels genericos `CODE_` restantes no `bank_83.asm` sem alterar bytes.

Escopo:

- Arquivo: `src/code_banks/bank_83.asm`
- Labels renomeados: 504
- Padrao novo: `Bank83_NpcSpriteLogicBranch_83xxxx`

Racional tecnico:

O Bank 83 concentra logica associada a NPC/sprite/GOBJ, menus de prompt e transicoes visuais. Nesta pass, os branch labels genericos foram convertidos para aliases estaveis por banco e area, preservando o sufixo de endereco para rastreabilidade byte-a-byte.

Resultado esperado:

- `CODE_` em `bank_83.asm`: 0
- Rebuild: identico ao MD5 USA limpo `c9bf36a816b6d54aed79d43a6c45111a`
