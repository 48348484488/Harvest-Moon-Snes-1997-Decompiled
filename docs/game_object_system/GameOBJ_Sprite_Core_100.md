# GameOBJ / Sprite Object Core 100%

Esta pass documenta o nucleo de objetos visuais animados do jogo. No source, esse sistema aparece como **GameOBJ**: uma estrutura intermediaria que representa personagens, animais, objetos e sprites animados antes de virar dados reais de OAM/SNES.

## O que foi fechado neste escopo

O escopo **GameOBJ / Sprite Object Core** foi considerado 100% para a parte central porque agora estao nomeadas e documentadas as rotinas que:

- alocam um novo GameOBJ;
- atualizam posicao/flip de um GameOBJ existente;
- reinicializam metadata de animacao/sprite;
- liberam componentes e slot de objeto;
- carregam lista de componentes de sprite;
- verificam se os slots de VRAM dos componentes estao prontos;
- atualizam frames de animacao;
- convertem GameOBJ em SOBJ/OAM para o SNES;
- fazem acquire/release de componentes de sprite na VRAM.

Isso nao significa que **todos os NPCs do jogo** ja foram entendidos. Significa que o motor base que desenha/atualiza objetos animados esta mapeado.

## Estruturas principais

| Estrutura | Endereco/Label | Funcao |
|---|---|---|
| SOBJ low table | `!sobj_low_table` / `$7EA000` | dados baixos que serao copiados para OAM |
| SOBJ high table | `!sobj_high_table` / `$7EA200` | bits altos/tamanho/extra de OAM |
| GameOBJ struct | `!gobj_struct_initialized` / `$019C` | lista de objetos de jogo |
| GameOBJ order | `!gobj_order_array` / `$084C` | ordem de desenho dos objetos |
| GameOBJ slot offsets | `GameOBJ_SlotOffsetTable` | offsets de structs de $24 bytes |
| Anim metadata bank 86 | `GameOBJ_AnimPtrTable_Bank86` | ponteiros de animacao/metadados |
| Anim metadata bank 87 | `GameOBJ_AnimPtrTable_Bank87` | continuacao dos ponteiros |

## Tamanho e limite observados

| Item | Valor |
|---|---:|
| Tamanho da struct GameOBJ | `$24` bytes |
| Maximo observado de entradas | `40` objetos |
| Banco metadata primario | `$86` |
| Banco metadata secundario | `$87` |
| Threshold para banco secundario | sprite id `>= $0262` |

## Rotinas nomeadas nesta pass

| Label novo | Label antigo | Papel |
|---|---|---|
| `GameOBJ_AllocateAndInitNewSlot` | `CODE_858000` | cria novo slot GameOBJ |
| `GameOBJ_UpdateExistingSlotTransform` | `CODE_8580B9` | atualiza posicao/flip de slot existente |
| `GameOBJ_ReinitializeExistingSlotMetadata` | `CODE_858100` | troca/reinicializa metadata de um slot |
| `GameOBJ_ClearSlotAndReleaseComponents` | `CODE_8581A2` | limpa slot e libera componentes |
| `GameOBJ_LoadSlotStateToScratch` | `CODE_8581CB` | carrega dados do slot para scratch RAM |
| `GameOBJ_LoadComponentListAndAcquireVRAM` | `CODE_858AE5` | le componentes e reserva VRAM |
| `GameOBJ_ReleaseComponentVRAMSlots` | `CODE_858B41` | libera referencias de componentes |
| `GameOBJ_CheckComponentVRAMSlotsReady` | `CODE_858B7B` | verifica componentes ainda nao carregados |
| `GameOBJ_SlotOffsetTable` | `Table_GameOBJIndexes` | offsets das structs |
| `SOBJ_HighOAMXBitMaskTable` | `Table_HighOAMXbit` | mascara de bit alto de OAM |

## Fluxo central

1. Alguma rotina de mapa/NPC/animal escolhe um `sprite_table_idx`.
2. O jogo chama `GameOBJ_AllocateAndInitNewSlot`.
3. A rotina procura um slot livre de GameOBJ.
4. O slot recebe posicao, flip, metadata id e marcador `$7777`.
5. A metadata e buscada nos bancos `$86` ou `$87`.
6. A lista de componentes do sprite e carregada.
7. Cada componente recebe ou reutiliza um slot de VRAM.
8. A rotina de update avanca frames quando necessario.
9. A rotina de render converte GameOBJ em SOBJ/OAM.
10. O SNES desenha os objetos na tela.

## O que isso permite modificar com mais seguranca

Agora existe uma base melhor para:

- trocar sprites existentes;
- entender quais objetos usam metadata dos bancos 86/87;
- localizar onde personagens/animais entram na tela;
- estudar ordem de desenho;
- estudar limites de objetos por cena;
- evitar quebrar VRAM/OAM ao trocar bonecos.

## O que ainda nao esta 100%

Ainda nao foram fechados completamente:

- agenda individual de cada NPC;
- scripts de movimento de NPCs;
- todos os IDs de personagem;
- todas as animacoes nomeadas;
- todas as relacoes entre mapas e objetos;
- edicao automatica de graficos.

Essas partes pertencem a passes futuras de NPCs, mapas e sprites especificos.
