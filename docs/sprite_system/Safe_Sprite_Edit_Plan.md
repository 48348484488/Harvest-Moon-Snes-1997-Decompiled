# Plano seguro para editar/adicionar sprites

## Etapa recomendada

A primeira edicao real deve ser **substituir um sprite existente**, nao adicionar NPC novo do zero.

Motivo: adicionar personagem novo exige sprite, paleta, animacao, ID, spawn, colisao, dialogo, flags e possivelmente save. Trocar grafico existente mexe em bem menos sistemas.

## Caminho seguro

1. Escolher um GOBJ especifico no `sprite_gobj_viewer.html`.
2. Ver quais `component_id` ele usa.
3. Localizar esses componentes no `component_graphics_map.csv`.
4. Editar somente os bytes graficos correspondentes nos bancos 88-91.
5. Recompilar.
6. Testar no jogo.

## O que ainda falta mapear

- Paletas exatas por personagem.
- Lista humana de qual GOBJ e qual NPC/objeto.
- Rotinas de spawn de cada personagem no mapa.
- Compressao/expansao grafica, caso a gente queira importar PNG automaticamente.

## Regra para nao quebrar

Nao alterar tamanho dos bancos e nao deslocar offsets enquanto a rotina de ponteiros/VRAM nao estiver totalmente dominada.
