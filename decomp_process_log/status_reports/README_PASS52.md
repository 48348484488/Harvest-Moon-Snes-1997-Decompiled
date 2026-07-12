# HM-Decomp Codex Workspace - Pass 52

Pacote de trabalho para continuar a engenharia reversa/decompilacao documentada de Harvest Moon SNES.

## Estado atual

- Source ASM funcional/recompilavel: **100%**.
- Rebuild byte-perfect da ROM USA limpa: **validado localmente antes de remover a ROM do pacote**.
- Engenharia reversa humana/documentada estimada: **94% - 97%**.
- Ultimo escopo fechado: **Pass 52 - Tile Property / Collision Ruleset Core 100%**.

## ROM

A ROM comercial nao esta incluida neste pacote.

Para validar localmente, coloque sua copia legal em:

```text
project_buildable/roms/Harvest Moon (USA).sfc
```

MD5 esperado:

```text
c9bf36a816b6d54aed79d43a6c45111a
```

## Build

Linux:

```bash
cd project_buildable
./build_linux.sh
```

Windows:

```bat
cd project_buildable
build_windows.bat
```

## Pass 52

A Pass 52 fechou o escopo **Tile Property / Collision Ruleset Core 100%**.

O objetivo foi transformar o nucleo de propriedades de tile em algo documentado e navegavel:

- tabela paralela `TileProperty_RulesetPointerTable`;
- 7 rulesets principais de propriedades de tile;
- mascara de direcao por `!player_direction`;
- mascara de estacao por `!season`;
- relacao com `LoadMap`;
- relacao com `TileProperty_CheckToolUseAllowed`;
- relacao com colisao, ferramentas, crops, agua, itens e interacao de mapa.

Arquivos principais:

```text
source_decompilada/docs/tile_property_system/Tile_Property_Collision_Ruleset_Core_100.md
source_decompilada/docs/pseudocode/Tile_Property_Collision_Ruleset_Core.md
source_decompilada/VALIDACAO_BUILD_PASS52.md
source_decompilada/PROGRESSO_DECOMP.md
```

## Estrutura

```text
source_decompilada/   copia limpa da source + docs
project_buildable/    workspace completo com tools, build, reports e source
third_party/          terceiros permitidos, incluindo Asar
```
