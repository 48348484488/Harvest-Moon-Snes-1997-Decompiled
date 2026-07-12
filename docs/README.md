# Documentação Técnica

Documentação de cada sistema do jogo, gerada durante o processo de engenharia reversa.
Cada subpasta corresponde a um sistema e normalmente contém um documento "Core" (visão geral
consolidada) e, às vezes, um `STATUS_PASS*.md` (estado no momento em que foi fechado).

## Sistemas de gameplay

- [`farm_system/`](./farm_system) — plantio, colheita, crescimento de plantações
- [`crop_growth_system/`](./crop_growth_system) — ciclo de crescimento de culturas
- [`livestock_system/`](./livestock_system) — animais de fazenda
- [`tool_actions_system/`](./tool_actions_system) — uso de ferramentas
- [`item_system/`](./item_system) — itens e inventário
- [`inventory_menu_system/`](./inventory_menu_system) — menu de inventário
- [`shop_system/`](./shop_system) — compras/vendas
- [`money_shipping_system/`](./money_shipping_system) — dinheiro e envio de produtos
- [`stamina_system/`](./stamina_system) — energia do personagem
- [`npc_social_system/`](./npc_social_system) / [`social_system/`](./social_system) — relacionamento com NPCs
- [`ending_system/`](./ending_system) — finais do jogo

## Motor / técnico

- [`event_script_system/`](./event_script_system) — o motor de scripts de evento (o mais documentado do projeto)
- [`events_system/`](./events_system) — eventos do calendário/jogo
- [`game_object_system/`](./game_object_system) — objetos de jogo (GOBJ)
- [`sprite_system/`](./sprite_system) — sprites e animação
- [`map_system/`](./map_system) / [`map_renderer_system/`](./map_renderer_system) / [`map_patch_system/`](./map_patch_system) — mapas
- [`tile_property_system/`](./tile_property_system) — propriedades/colisão de tiles
- [`palette_system/`](./palette_system) — paletas de cor
- [`player_movement_system/`](./player_movement_system) — movimentação do jogador
- [`save_system/`](./save_system) — save/load
- [`time_system/`](./time_system) — relógio/calendário do jogo

## Interface

- [`menu_system/`](./menu_system) / [`input_menu_system/`](./input_menu_system) — menus e input
- [`text_system/`](./text_system) / [`textbox_dialog_system/`](./textbox_dialog_system) — texto e diálogos
- [`hud_status_system/`](./hud_status_system) — HUD
- [`name_entry_system/`](./name_entry_system) — tela de nome do jogador
- [`video_system/`](./video_system) — vídeo/apresentação
- [`audio_system/`](./audio_system) — áudio/SFX

## Outros

- [`cleanup_system/`](./cleanup_system) — notas de limpeza geral de código
- [`utility_system/`](./utility_system) — rotinas utilitárias
- [`pseudocode/`](./pseudocode) — pseudocódigo de rotinas centrais
- [`handoff/`](./handoff) — documentos de onboarding para quem for continuar o projeto (inclui metas por pass)
