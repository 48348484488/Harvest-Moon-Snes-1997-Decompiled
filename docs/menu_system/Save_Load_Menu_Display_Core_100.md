# Pass 33 - Save/Load Menu Display Core 100%

Esta pass fecha o escopo **Save/Load Menu Display Core**.

O objetivo foi mapear a parte visual do menu de carregar/continuar jogo, sem alterar comportamento da ROM. O sistema agora esta documentado como uma ponte entre:

- `SaveSystem_LoadSlotSummary`, que le o resumo do slot salvo;
- renderer de glyphs do TextBox, usado para desenhar nome/data;
- DMA programado para mandar tiles/glyphs para VRAM;
- estado de input/menu mapeado na Pass 23;
- sistema de save/SRAM mapeado nas Passes 11 e 12.

## Escopo fechado

O nucleo fechado nesta pass cobre:

- carregamento da cena de load/continue;
- preparacao visual do menu de save/load;
- desenho de resumo de slot valido;
- limpeza visual de slot vazio/invalido;
- posicoes de VRAM usadas por nome, ano, dia e nomes de data;
- blocos estaticos da interface;
- fluxo entre selecionar um slot e iniciar o jogo carregado.

## Rotinas principais

| Label | Funcao |
|---|---|
| `SaveLoadMenu_LoadSceneAndStaticBackground` | Inicializa a tela/menu de load/continue, prepara BG, paleta, musica e estado. |
| `SaveLoadMenu_DrawSlotSummaryIfValid` | Tenta ler resumo de um slot e desenha nome/data quando o save e valido. |
| `SaveLoadMenu_ClearSlotSummaryArea` | Limpa a area do slot quando nao existe save valido. |
| `SaveLoadMenu_DrawStaticTileBlocks` | Copia blocos estaticos de tiles da interface para VRAM. |
| `StartFromLoad` | Carrega o slot selecionado e pula para o spawn apos load. |
| `StartFromNewGame` | Inicia setup de novo jogo e pula para o spawn inicial. |

## Tabelas principais

| Label | Funcao |
|---|---|
| `SaveLoadMenu_BlankTilePatternTable` | Padroes usados para limpar area de slot. |
| `SaveLoadMenu_ClearAreaBaseOffsetTable` | Offsets base para limpar slot 1/slot 2. |
| `SaveLoadMenu_StaticTileSourceOffsetTable` | Origem dos blocos estaticos usados pela tela. |
| `SaveLoadMenu_StaticTileVRAMDestTable` | Destino VRAM dos blocos estaticos. |
| `SaveLoadMenu_StaticTileBlockCountTable` | Quantidade de blocos/copias por item da tabela. |
| `SaveLoadMenu_SlotSummaryVRAMPositionTable` | Posicoes VRAM dos campos de texto do resumo de save. |

## Fluxo de alto nivel

```text
entrar na tela de continue/load
  -> carrega tilemaps/paleta/musica da tela
  -> para cada slot visivel:
       -> chama SaveSystem_LoadSlotSummary
       -> se valido: desenha nome, ano, dia e data
       -> se invalido: limpa area do slot
  -> input escolhe slot
  -> StartFromLoad carrega o slot inteiro
  -> SpawnAfterLoad coloca o jogador no mapa salvo
```

## Observacoes

Este escopo nao tenta redesenhar o menu inteiro nem mudar layout. Ele documenta o nucleo de exibicao do resumo de save/load e renomeia as rotinas/tabelas que foram possiveis identificar com seguranca.

A build continua byte-perfect, entao as renomeacoes e comentarios nao alteraram a ROM gerada.
