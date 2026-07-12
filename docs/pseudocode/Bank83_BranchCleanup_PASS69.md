# Bank 83 Branch Cleanup - PASS69

O Bank 83 possuia 504 labels `CODE_` genericos. Eles foram convertidos para aliases semanticos estaveis:

```asm
CODE_839439 -> Bank83_NpcSpriteLogicBranch_839439
CODE_8394B0 -> Bank83_NpcSpriteLogicBranch_8394B0
CODE_83xxxx -> Bank83_NpcSpriteLogicBranch_83xxxx
```

A intencao ainda nao e afirmar o comportamento exato de cada branch individual, mas remover o label generico e colocar o bloco dentro do dominio tecnico correto: Bank 83, NPC/sprite/GOBJ/prompt/visual logic.

Isso melhora a manutencao porque:

- cada branch continua rastreavel pelo endereco;
- ferramentas futuras podem agrupar por `Bank83_NpcSpriteLogicBranch_`;
- nao ha mudanca binaria no rebuild.
