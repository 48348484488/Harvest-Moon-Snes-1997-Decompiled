# Pass 64 - Bank 84 CODE Branch Cleanup

Esta pass removeu todos os labels genericos `CODE_` do `bank_84.asm`.

## Contagem

| Item | Antes | Depois |
|---|---:|---:|
| Bank 84 `CODE_` unicos | 590 | 0 |
| Total global `CODE_` no source | 2322 | 1732 |
| Reducao global | 590 | — |

## Escopo

O Bank 84 contem o nucleo de EventScript/EventCmd, incluindo scheduler, handlers e fluxo de execucao de comandos.

## Observacao

A limpeza e byte-safe: somente nomes de labels/refs foram alterados.
