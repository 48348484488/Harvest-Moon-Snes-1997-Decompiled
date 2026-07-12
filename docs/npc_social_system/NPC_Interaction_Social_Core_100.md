# NPC / Social Interaction Core 100%

Esta pass fecha o escopo **NPC / Social Interaction Core**: a camada que liga mapa atual, NPC/eventos sociais, dialogos, flags persistentes, romance/familia e alteracao de felicidade global.

Ela nao significa que **todos os horarios individuais de todos os NPCs** ja estejam 100% documentados. O que ficou fechado aqui e o **nucleo de disparo e interacao social** usado para chamar eventos, dialogos e estados sociais a partir do mapa/area atual.

## Rotinas principais

| Rotina | Funcao |
|---|---|
| `NPCMapEvent_DispatchByCurrentArea` | Usa `!tilemap_to_load` como indice e despacha a rotina social/NPC/evento da area atual. |
| `NPCMapEvent_AreaDispatchTable` | Tabela por area/mapa com ponteiros para checagens de eventos sociais/NPC. |
| `NPCMapEvent_FarmHomeFamilyAndRomanceCheck` | Rotina de checagem social/familiar/romance em area residencial/fazenda. |
| `Social_AddPlayerHappiness` | Soma ou subtrai felicidade global do jogador com clamp entre 0 e 999. |
| `EventScript_LoadScriptPointerLong` | Carrega scripts/cenas sociais quando uma condicao e satisfeita. |
| `EventScript_LoadScriptPointerForFacingTile` | Carrega script/dialogo/interacao baseado no tile/objeto/NPC diante do jogador. |
| `TextBox_StartByTextId` | Inicia texto de dialogo por ID. |

## Fluxo geral

```text
1. O jogo atualiza mapa/eventos/input.
2. A rotina `NPCMapEvent_DispatchByCurrentArea` le `!tilemap_to_load`.
3. O valor do mapa seleciona uma entrada em `NPCMapEvent_AreaDispatchTable`.
4. A rotina da area checa flags, hora, dia, casamento, filhos, romance e eventos ja vistos.
5. Se a condicao passa, um script e carregado pelo EventScript core.
6. Esse script pode abrir dialogo, travar input, mover personagem, mudar mapa, tocar som, setar flag etc.
```

## Condicoes sociais ja documentadas

O nucleo social usa principalmente:

| Variavel/flag | Uso |
|---|---|
| `!tilemap_to_load` | ID do mapa/area atual. |
| `!hour`, `!minutes`, `!seconds` | Gatilhos por horario exato, especialmente manha. |
| `!day`, `!season`, `!weekday` | Gatilhos por calendario. |
| `!marriage_flags` | Estado de casamento/esposa. |
| `!family_event_flags` | Eventos familiares, filhos e eventos sociais persistentes. |
| `!child_flags` | Estado dos filhos. |
| `!kid1_age`, `!kid2_age` | Idade dos filhos. |
| `!hearts_maria`, `!hearts_ann`, `!hearts_nina`, `!hearts_ellen`, `!hearts_eve` | Coracoes das garotas. |
| `!happiness` | Felicidade global/ranch happiness. |
| `!inputstate` | Trava ou libera controle durante dialogo/cena. |
| `!game_state` | Flags globais de estado do jogo durante eventos. |

## Romance/social event threshold

Foi confirmado um padrao importante:

```text
Coracao >= $00C8 / 200
```

Esse valor aparece como limite para disparar eventos importantes das garotas quando as outras condicoes permitem.

## Social_AddPlayerHappiness

`Social_AddPlayerHappiness` recebe um delta em `A` e altera `!happiness`.

Comportamento:

```text
novo_valor = felicidade_atual + delta
se novo_valor < 0: falha, retorna 1
se novo_valor >= 999: grava 999, retorna 0
caso normal: grava novo_valor, retorna 0
```

Isso e usado por eventos sociais, animais, escolhas e recompensas/punicoes.

## Limite do escopo

Fechado em 100% nesta pass:

- dispatcher social por area;
- tabela central por mapa/area;
- conexao com scripts de evento;
- conexao com dialogos;
- conexao com coracoes/romance/familia;
- rotina central de felicidade global.

Ainda nao fechado como 100% geral:

- agenda individual detalhada de todos os NPCs;
- todos os scripts sociais especificos dos bancos `B3-B5` com nomes humanos;
- cada cena individual de festival/personagem;
- movimento/IA individual de cada NPC.

Esses ficam para passes futuras.
