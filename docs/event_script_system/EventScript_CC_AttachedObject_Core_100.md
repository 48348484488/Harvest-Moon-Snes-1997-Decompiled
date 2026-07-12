# Pass 54 - EventScript CC Slot / Attached Object Core 100%

Esta pass continuou a decompilacao sem ROM comercial e fechou um escopo seguro: melhorar a nomenclatura/documentacao do runtime de slots `$CC` do sistema de eventos e dos objetos visuais anexados aos scripts.

## Escopo fechado

**EventScript CC Slot / Attached Object Core 100%**

O objetivo foi reduzir nomes genericos em uma area central do banco `84` e ligar melhor tres sistemas que ja estavam parcialmente documentados:

- interpretador de eventos/cenas;
- slots de execucao `$CC` em WRAM;
- GameOBJ/Sprite usado por eventos, NPCs e objetos temporarios.

A pass foi feita apenas com renomeacoes e comentarios. Nenhum byte de codigo foi alterado.

## Estrutura `$CC`

O ponteiro `$CC-$CE` aponta para um slot de evento em `$7E:B586 + index*$40`.

Cada slot tem tamanho `$40` bytes e guarda estado de script, flags, timers, posicao e, quando necessario, dados de objeto visual anexado.

Offsets confirmados/reforcados nesta pass:

| Offset | Uso observado |
|---:|---|
| `$00` | flag ativo/usado |
| `$01` | flags internas do slot, incluindo objeto/refresh/motion |
| `$02` | indice visual/direcao/estado usado para selecionar triplet table |
| `$03-$04` | velocidade assinada X/Y aplicada ao objeto anexado |
| `$05-$06` | timer/base de timer de movimento |
| `$07-$08` | timer auxiliar de movimento/padrao |
| `$09-$0B` | parametros de limite/passos para movimento horizontal/vertical |
| `$0F` | seletor/padrao de movimento inicial |
| `$10` | wait timer do script |
| `$12` | identificador/slot GameOBJ anexado |
| `$14` | flags/estado visual do objeto anexado |
| `$16` | sprite/animacao atual do objeto anexado |
| `$18` | sprite/animacao anterior para detectar troca |
| `$1A-$1C` | posicao atual X/Y do objeto anexado |
| `$1E-$20` | posicao alvo/anterior/limite usada por padroes de movimento |
| `$30-$32` | ponteiro atual de script: low word + bank |
| `$33-$36` | ponteiros/indices de tabelas B3 usados por comandos de objeto |
| `$3F` | indice original do slot/script |

## Renomeacoes principais

```text
SetCCPoiner -> EventScript_SetCCPointerBySlot
SUB_848331 -> EventScript_ApplyAttachedObjectVelocity
SUB_8483CC -> EventScript_UpdateAttachedObjectMotionPattern
SUB_848895 -> EventScript_LoadAttachedObjectVisualState
SUB_81BFB7 -> PlayerAction_DispatchAndUpdateCamera
DATA16_81C027 -> PlayerAction_DispatchJumpTable
SUB_82B060 -> MapTile_FillRectCurrentMap
SUB_82B0A7 -> MapTilePatch_ApplyPlacementRecord
DATA8_82B02A -> FarmTile_NeighborVariantOffsetTable
```

## Rotinas agora documentadas

### `EventScript_SetCCPointerBySlot`

Recebe o indice do slot em `A`, multiplica por `$40` e monta o ponteiro `$CC-$CE` para `$7E:B586 + index*$40`.

Essa rotina e chamada por criacao, limpeza, leitura e atualizacao de slots de evento.

### `EventScript_UpdateAttachedObjectMotionPattern`

Atualiza o padrao de movimento de um objeto anexado ao slot de evento. A rotina usa flags/timers do proprio slot para escolher movimento horizontal/vertical, recarregar timer, trocar estado visual e pedir refresh do GameOBJ quando necessario.

### `EventScript_ApplyAttachedObjectVelocity`

Aplica velocidade assinada dos offsets `$03/$04` sobre a posicao atual `$1A/$1C`. Isso permite que scripts movam um objeto visual sem reexecutar toda a criacao de GameOBJ a cada frame.

### `EventScript_LoadAttachedObjectVisualState`

Le uma tabela de triplets no banco `B3`, selecionada pelo estado/direcao no offset `$02`, e escreve os campos visuais do slot:

- `$16`: sprite/animacao atual;
- `$14`: estado/flags visuais derivados do byte da tabela.

### `PlayerAction_DispatchAndUpdateCamera`

Substitui o nome generico da rotina que despacha `!player_action`, atualiza idle timer, sincroniza direcao e chama atualizacao de camera/parallax quando o jogador esta no loop de mapa/campo.

### `MapTile_FillRectCurrentMap`

Preenche um retangulo em `!current_map_array` usando `A` como tile id, `X/Y` como posicao inicial e `$86/$88` como largura/altura.

### `MapTilePatch_ApplyPlacementRecord`

Aplica um registro de patch/placement de mapa sobre `!current_map_array`. A rotina usa `MapTilePatch_LoadPlacementRecord`, calcula dimensoes/offsets e escreve tiles em bloco.

## Impacto pratico

Esta pass melhora a seguranca para editar:

- scripts de cena nos bancos `B3-B5`;
- objetos temporarios que aparecem durante dialogos/eventos;
- rotinas de NPC/evento que movem sprites no mapa;
- patches visuais de mapa executados por scripts;
- interacoes onde um script cria, atualiza ou limpa um GameOBJ anexado.

## Validacao

A montagem foi executada com o Asar Linux incluido no pacote, sem usar ROM comercial original.

```text
MD5 rebuild Pass 54: c9bf36a816b6d54aed79d43a6c45111a
Resultado: OK, source monta e o rebuild preserva o MD5 byte-perfect documentado.
```

A comparacao byte-a-byte contra ROM original continua dependendo de uma copia legal colocada em `project_buildable/roms/Harvest Moon (USA).sfc`.
