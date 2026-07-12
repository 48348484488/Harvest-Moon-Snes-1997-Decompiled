# GameOBJ Bank85 / ToolAnimation CODE cleanup - PASS65

A Pass 65 fecha dois conjuntos pequenos de labels genericos `CODE_`:

- Bank 85: core de GameOBJ, alocacao, atualizacao de animacao, copia/ordem visual e rotinas relacionadas a sprite/object.
- Bank 82 ToolAnimation: pequenas branches locais da rotina de animacao de ferramenta.

## Padrao aplicado

```asm
.CODE_8582CD -> .GameOBJ_Bank85_Branch_8582CD
.CODE_8582E7 -> .GameOBJ_Bank85_Branch_8582E7
.CODE_8291E7 -> .ToolAnimation_Branch_8291E7
```

O prefixo ainda e mecanico, mas remove ambiguidade global: agora o leitor sabe que esses labels pertencem ao cluster GameOBJ/ToolAnimation, nao a codigo desconhecido solto.

## Estado apos a pass

| Grupo | CODE_ restante |
|---|---:|
| `bank_85.asm` | 0 |
| `bank_82_toolanimation_subrutines.asm` | 0 |
| `src` total | 1700 |
