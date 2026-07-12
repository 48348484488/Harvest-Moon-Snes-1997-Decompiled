# Decomp Pass 15 - Stamina / Fatigue Core

Este arquivo foi atualizado na Pass 15. A rotina antes chamada `ChangeStamina` foi renomeada para:

`Stamina_ApplyDeltaAndFatigueState`

Veja tambem:

- `docs/stamina_system/Stamina_Fatigue_Core_100.md`
- `docs/pseudocode/Stamina_Fatigue_Core.md`

---

# Historico original - Stamina

Arquivo analisado: `src/code_banks/bank_81.asm`

## `Stamina_ApplyDeltaAndFatigueState` - SNES $81D061

Essa rotina recebe em `A` uma mudanca de stamina. Valores positivos recuperam stamina. Valores negativos reduzem stamina.

### Variaveis principais

| Variavel | Endereco | Uso inferido |
|---|---:|---|
| `!max_stamina` | `$0917` | stamina maxima atual |
| `!current_stamina` | `$0918` | stamina atual |
| `!exhaustion_level` | `$096C` | nivel visual/funcional de cansaco |
| `!game_state` bit `$0008` | `$00D2` | flag de stamina zerada / sem stamina |
| `!player_action` | `$00D4` | acao atual do player |
| `$0901` | `$0901` | provavel animacao/efeito de cansaco |
| `$7F1F60` bit `$0008` | flag | desliga/ignora calculo de stamina em situacoes especiais |

### Pseudocodigo

```c
void Stamina_ApplyDeltaAndFatigueState(int8_t delta) {
    if (flags_7F1F60 & 0x0008) {
        return;
    }

    int new_stamina = current_stamina + delta;

    if (new_stamina <= 0) {
        current_stamina = 0;
        game_state |= 0x0008;        // sem stamina
        animation_or_state_0901 = 0x004D;
        player_action = 0x000B;      // acao de cansaco
        update_exhaustion_after_change(delta);
        return;
    }

    if (new_stamina >= max_stamina) {
        current_stamina = max_stamina;
        game_state &= ~0x0008;
        update_exhaustion_after_change(delta);
        return;
    }

    current_stamina = new_stamina;
    game_state &= ~0x0008;
    update_exhaustion_after_change(delta);
}
```

### Cansaco por faixas

A rotina usa divisao por 2 repetida do `max_stamina` para determinar faixas de exaustao.

Leitura inferida:

- stamina alta: sem cansaco relevante;
- abaixo de metade: aumenta possibilidade de animacao de cansaco;
- abaixo de 1/4: outro nivel;
- abaixo de 1/8: nivel mais severo;
- ao zerar: acao `0x000B`, provavelmente animacao de fadiga.

### Conclusao

`Stamina_ApplyDeltaAndFatigueState` nao apenas soma/subtrai stamina. Ela tambem controla:

- limite minimo `0`;
- limite maximo `max_stamina`;
- flag de sem stamina no `game_state`;
- animacao/estado de cansaco;
- nivel progressivo de exaustao.

Essa e uma boa rotina para modificar caso voce queira:

- stamina infinita;
- ferramentas gastando menos stamina;
- aumentar recuperacao do almoco;
- mexer nos limites de cansaco.

