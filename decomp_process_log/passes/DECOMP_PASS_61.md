# DECOMP PASS 61 - PlayerAction/TextBox High-Bank DATA8 Closure 100%

Escopo fechado nesta pass:

1. **High-bank DATA8 closure 100%**: todos os labels genericos `DATA8_81xxxx`/`DATA8_83xxxx` que ainda eram tabelas locais reais dentro de `code_banks` foram substituidos por nomes semanticos.
2. **PlayerAction held-object GOBJ tables**: a rotina que cria/atualiza o objeto visual usado por acoes do jogador foi nomeada junto com suas tabelas de frame/threshold.
3. **TextBox prompt accept table**: a tabela que converte selecao/estado do prompt para text IDs foi nomeada.
4. **Rebuild byte-perfect mantido**: a ROM reconstruida continua identica byte-a-byte a ROM USA limpa.

## Area fechada em 100%

| Metrica | Antes da Pass 61 | Depois da Pass 61 | Status |
|---|---:|---:|---|
| DATA8 high-bank genericos locais em `code_banks` | 4 | 0 | 100% fechado |
| Labels antigos `DATA8_81D1E8`, `DATA8_81D210`, `DATA8_81D510`, `DATA8_839467` | 4 | 0 | 100% fechado |
| Rotinas auxiliares `CODE_81CFA0`, `CODE_81CFE6`, `CODE_81D1C5` | 3 | 0 | 100% fechado |
| Rebuild byte-perfect USA | 100% | 100% | mantido |

## Renomeacoes seguras

| Antes | Depois | Banco | Uso inferido |
|---|---|---|---|
| `CODE_81CFA0` | `PlayerAction_SpawnHeldObjectGOBJFromActionFrame` | `bank_81.asm` | cria/inicializa GOBJ visual para objeto/ferramenta ligado a frame de acao do jogador |
| `CODE_81CFE6` | `PlayerAction_UpdateHeldObjectGOBJFromActionFrame` | `bank_81.asm` | atualiza/reinicializa transform/metadados do GOBJ quando o frame de acao muda |
| `CODE_81D1C5` | `PlayerAction_FindFrameBucketFromThresholdTable` | `bank_81.asm` | procura bucket de frame/animacao usando tabela de thresholds |
| `DATA8_81D1E8` | `PlayerAction_FrameBucketThresholdTable` | `bank_81.asm` | thresholds de frame usados para classificar a animacao/acao |
| `DATA8_81D210` | `PlayerAction_HeldObjectGOBJFrameTripletTable` | `bank_81.asm` | triplets usados para objeto visual de ferramenta/item carregado pela acao do jogador |
| `DATA8_81D510` | `MapTilePatch_SeasonalDialogTextIdTable` | `bank_81.asm` | tabela de text IDs indexada por `$0990` e season antes de aplicar tile patch |
| `DATA8_839467` | `TextBox_PromptAcceptSelectionTextIdTable` | `bank_83.asm`/`bank_84.asm` | mapeia selecao/estado do prompt para text ID ao aceitar uma escolha |

## Validacao

```text
MD5 original: c9bf36a816b6d54aed79d43a6c45111a
MD5 rebuild:  c9bf36a816b6d54aed79d43a6c45111a
Resultado: OK, rebuild identico byte-a-byte.
```

## Contagem apos Pass 61 em `project_buildable/src`

| Metrica | Valor |
|---|---:|
| Labels `SUB_` unicos | 0 |
| Labels `DATA16_` unicos | 0 |
| Labels high-bank `DATA8_81/82/83/84/85xxxx` unicos | 0 |
| Labels `DATA8_` unicos totais | 203 |
| Labels `CODE_` unicos totais | 2322 |
| Ocorrencias `UNK_` | 0 |

## Observacao

A maior parte dos `DATA8_00xxxx` restantes aponta para labels absolutos de RAM/tabelas baixas herdadas do DIZ/rotinas antigas. Eles nao foram renomeados em massa nesta pass para evitar nomes falsos. A proxima pass recomendada e escolher uma familia concreta desses `DATA8_00xxxx`, por exemplo ponteiros de textos/dialogos de menus ou tabelas de shop/eventos, e fechar essa familia com validacao byte-perfect.
