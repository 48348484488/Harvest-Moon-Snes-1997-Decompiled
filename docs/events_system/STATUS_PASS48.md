# Status Pass 48 - Remaining Event Command Unknowns Core

Escopo fechado: **100%**.

## Concluido

- Renomeados os tres comandos `EventCmd_*Unknown*` restantes.
- Documentado comportamento dos opcodes `$37`, `$38` e `$4A`.
- Adicionados comentarios diretos em `bank_84.asm`.
- Confirmado que nao restam labels `EventCmd_*Unknown*` no source.
- Build revalidada byte-perfect.

## Validacao

```text
MD5 ROM USA original: c9bf36a816b6d54aed79d43a6c45111a
MD5 rebuild Pass 48:  c9bf36a816b6d54aed79d43a6c45111a
Resultado: OK, identica byte-a-byte
```
