# DECOMP PASS 69 - Bank 83 CODE Branch Closure

Status: PASS 69 concluida.

Objetivo da pass: fechar 100% dos labels genericos `CODE_` restantes no `bank_83.asm`, preservando rebuild byte-perfect.

## Resultado

| Area | Antes | Depois | Status |
|---|---:|---:|---|
| `CODE_` genericos em `bank_83.asm` | 504 | 0 | 100% fechado |
| `CODE_` genericos totais no source | 1288 | 784 | reduziu 504 |
| `DATA8_` genericos | 0 | 0 | mantido fechado |
| `DATA16_` genericos | 0 | 0 | mantido fechado |
| `SUB_` genericos | 0 | 0 | mantido fechado |
| `UNK_` genericos | 0 | 0 | mantido fechado |

## Padrao aplicado

`CODE_83xxxx` foi renomeado para:

```asm
Bank83_NpcSpriteLogicBranch_83xxxx
```

O sufixo de endereco foi preservado para manter rastreabilidade com o disassembly original e com os comentarios de endereco.

## Escopo tecnico

- Arquivo principal: `src/code_banks/bank_83.asm`
- Labels renomeados: 504
- Area provavel: NPC/sprite/GOBJ, prompt/menu helper e logica visual do Bank 83.
- Alteracao de bytes: nenhuma.

## Validacao

Rebuild validado contra ROM USA limpa local:

```text
MD5 original: c9bf36a816b6d54aed79d43a6c45111a
MD5 rebuild:  c9bf36a816b6d54aed79d43a6c45111a
Resultado: OK, rebuild identico byte-a-byte.
```

## Proximo alvo recomendado

Agora sobra apenas `bank_81.asm` com labels `CODE_` genericos.

| Arquivo | CODE_ restantes |
|---|---:|
| `src/code_banks/bank_81.asm` | 784 |
