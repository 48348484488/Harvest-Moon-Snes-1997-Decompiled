# Decomp Pass 01 - Shipping / Money

Arquivos analisados:

- `src/code_banks/bank_82.asm`
- `src/code_banks/bank_81.asm`
- `src/constants/ram.asm`

## Variaveis principais

| Variavel | Endereco | Uso inferido |
|---|---:|---|
| `!shipping_moneyL` | `$7F1F07` | parte baixa/media do dinheiro acumulado por shipping |
| `!shipping_moneyH` | `$7F1F09` | parte alta do dinheiro acumulado por shipping |
| `!moneyL` | `$7F1F04` | dinheiro total do jogador, parte baixa; valor interno parece ser x10 |
| `!moneyH` | `$7F1F06` | dinheiro total do jogador, parte alta |

## Fluxo observado

1. Durante o dia, itens enviados somam valor em `!shipping_moneyL/H`.
2. Em algum horario/evento, `ShippingScene` prepara a cena de shipping.
3. `ShippingSceneDialogue` escolhe texto diferente se nao houve dinheiro de shipping.
4. Na virada do dia, `NightReset` chama `AddMoney` com `shipping_money`.
5. Depois disso, `shipping_money` e zerado.

## `ShippingSceneDialogue` - SNES $828165

### Pseudocodigo

```c
void ShippingSceneDialogue(void) {
    if (!(flags_7F1F5A & 0x0800)) return;
    if (game_state & 0x0040) return;

    inputstate = 2;

    text_id = 0x031A; // Text_Daily_Shipping

    if (shipping_moneyL == 0 && shipping_moneyH == 0) {
        text_id = 0x031B; // Text_Daily_Shipping_Nothing
    }

    StartTextBox(text_id);
    load_scene_data_or_dialogue_assets();
    flags_7F1F5A &= ~0x0400;
}
```

## `NightReset` trecho de dinheiro

### Pseudocodigo

```c
void NightReset_money_part(void) {
    scratch_72_74 = shipping_moneyL_H;
    AddMoney(scratch_72_74);

    shipping_moneyL = 0;
    shipping_moneyH = 0;
}
```

## Conclusao

O dinheiro de shipping fica separado do dinheiro total ate a virada do dia. Isso facilita criar hacks como:

- multiplicador de lucro;
- mostrar total enviado no dia;
- alterar precos de produtos;
- pagar instantaneamente sem esperar o dia virar;
- zerar/corrigir overflow de dinheiro.

