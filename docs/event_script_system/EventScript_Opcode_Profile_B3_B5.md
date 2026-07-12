# EventScript Opcode Profile B3-B5

A Pass 56 adiciona uma camada de analise semantica sobre os grupos de scripts catalogados na Pass 55.

A tabela mestre continua em:

```text
$B3:8000 = EventScript_MasterGroupPointerTable
```

Os grupos continuam nomeados como:

```text
EventScriptGroup_00 .. EventScriptGroup_47
```

## Objetivo

A Pass 55 dizia onde estao os grupos e quantas entradas cada grupo possui. A Pass 56 responde uma pergunta mais util para continuar a decompilacao:

```text
Que tipo de comportamento cada grupo parece controlar?
```

Para isso, a ferramenta nova gera perfis por opcode e classifica os grupos com tags.

## Tags semanticas

| Tag | Indica uso de |
|---|---|
| `dialogo` | comandos `1C`, `1D`, `21` |
| `flags_memoria` | checks e alteracoes de flags/valores |
| `objeto_cc` | slots de script, objeto anexado, estado CC |
| `transicao_tela` | fade, destino, troca de mapa/casa |
| `mapa_tile` | scroll/edicao de tile |
| `audio` | BGM/SFX/fade de audio |
| `item_dinheiro` | item na mao, drop, dinheiro |
| `animal` | galinha, vaca, cachorro |
| `player_anim` | posicao/direcao/animacao do player |

## Leitura conservadora

O perfil e propositalmente conservador:

- segue apenas fluxo linear;
- nao tenta resolver todos os branches;
- para em comandos de stop/wait;
- marca opcodes desconhecidos quando a tabela de tamanho ainda nao e segura;
- nao substitui a analise manual cena por cena.

Isso evita gerar nomes falsos para cenas ainda nao entendidas.

## Resultado principal

Resumo gerado:

```text
Grupos analisados: 72
Comandos lineares amostrados: 4190
Comandos conhecidos amostrados: 4022
Comandos desconhecidos/nao parseados: 168
```

## Grupos prioritarios

A ferramenta tambem gera `reports/event_script_decomp_priority_b3_b5.md`.

Top 10 grupos para passes futuras:

| Prioridade | Grupo | Motivo |
|---:|---|---|
| 1 | `EventScriptGroup_00` | maior volume e muitos alvos unicos; mistura dialogo, flags, objetos e animais |
| 2 | `EventScriptGroup_44` | grupo B5 muito denso em dialogo/flags/objeto CC |
| 3 | `EventScriptGroup_04` | alto volume de dialogo/flags/transicoes |
| 4 | `EventScriptGroup_07` | alto volume de dialogo/flags/transicoes |
| 5 | `EventScriptGroup_01` | rico em condicoes e dialogos |
| 6 | `EventScriptGroup_06` | rico em condicoes e dialogos |
| 7 | `EventScriptGroup_08` | rico em condicoes e dialogos |
| 8 | `EventScriptGroup_02` | scripts densos com dialogo e objetos CC |
| 9 | `EventScriptGroup_43` | banco B5, conteudo de cena com dialogo e flags |
| 10 | `EventScriptGroup_45` | banco B5, conteudo de cena com dialogo e objetos |

## Como usar na proxima pass

1. Abrir `reports/event_script_decomp_priority_b3_b5.md`.
2. Escolher um grupo de alta prioridade.
3. Cruzar o grupo com chamadas vindas do banco `81/84` e mapas/NPCs.
4. So depois trocar `EventScriptGroup_XX` por nome semantico real.

Regra: nao renomear grupo para nome de cena/NPC enquanto a origem de chamada nao estiver confirmada.
