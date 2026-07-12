# Video / PPU / NMI / DMA Core 100%

Escopo fechado na Pass 34.

Este documento descreve o nucleo baixo nivel de video do jogo. Ele nao e um sistema de gameplay diretamente visivel como fazenda, inventario ou animais, mas e a base que permite todos eles aparecerem corretamente na tela.

## O que este escopo cobre

- reset/boot do hardware SNES;
- inicializacao dos registradores PPU principais;
- limpeza de WRAM inicial;
- limpeza de VRAM;
- limpeza de OAM;
- limpeza de CGRAM;
- rotina NMI por frame;
- leitura de joypad durante VBlank;
- calculo de novo input, input solto e autorepeat;
- dispatcher central de DMA programado;
- atualizacao de scroll/BG offsets;
- presets de BG mode, tilemap base, character base e layers;
- fade in/fade out por brilho de tela;
- escrita do brilho em `INIDISP`.

## Rotinas principais

| Label | Funcao |
|---|---|
| `System_ResetHardwareAndBoot` | Reset nativo/emulacao, limpa registradores e prepara o jogo |
| `NMI_WaitForNextFrame` | Espera uma VBlank/NMI completar |
| `NMI_WaitForFrames` | Espera N frames |
| `NMI_Handler_UpdatePPUInputAndDMA` | Handler de NMI: joypad, DMA, scroll, status |
| `DMA_StartProgrammedTransfer` | Executa DMA programado para VRAM/OAM/CGRAM/WRAM conforme fila |
| `VRAM_ClearAll` | Zera a VRAM inteira usando DMA |
| `VRAM_ClearBlock4KB` | Zera bloco parcial de VRAM |
| `OAM_ClearAll` | Zera OAM/sprites do PPU |
| `Palette_CGRAM_ClearAll` | Zera CGRAM/paletas |
| `VideoPPU_InitScreenModeAndLayerRegisters` | Inicializa presets de tela/camadas |
| `VideoFade_In` | Aumenta brilho ate o alvo |
| `VideoFade_Out` | Reduz brilho ate o alvo |
| `PPU_SetScreenBrightness` | Escreve brilho atual em `INIDISP` |

## Fluxo principal

1. `System_ResetHardwareAndBoot` desliga interrupcoes, entra em modo nativo 65816 e zera registradores do SNES.
2. Zera WRAM baixa, banco `$7E` e banco `$7F`.
3. Inicializa audio/SPC.
4. Inicializa video: PPU registers, VRAM, OAM, CGRAM e estruturas de sprite.
5. Habilita NMI e salta para a tela inicial.
6. Durante o jogo, `NMI_Handler_UpdatePPUInputAndDMA` roda a cada VBlank.
7. NMI atualiza input, executa DMA pendente e aplica offsets de BG.

## Presets de video

As tabelas `VideoPPU_*PresetTable` centralizam valores usados por diferentes modos/telas:

- `VideoPPU_BGModePresetTable`
- `VideoPPU_OBSELPresetTable`
- `VideoPPU_BG1SCPresetTable`
- `VideoPPU_BG2SCPresetTable`
- `VideoPPU_BG3SCPresetTable`
- `VideoPPU_BG4SCPresetTable`
- `VideoPPU_BG12NBAPresetTable`
- `VideoPPU_BG34NBAPresetTable`
- `VideoPPU_MainScreenLayerMaskPresetTable`
- `VideoPPU_SubScreenLayerMaskPresetTable`
- `VideoPPU_ColorMathSelectPresetTable`
- `VideoPPU_ColorMathAddSubPresetTable`

Essas tabelas explicam como o jogo troca entre telas de gameplay, menus, textbox e cenas especiais sem reescrever manualmente todos os registradores PPU.

## Por que isso importa

Com este nucleo fechado, as proximas modificacoes em HUD, menus, tilemaps, sprites, textbox e transicoes ficam mais seguras, porque agora a base de frame update, VBlank e DMA esta nomeada e documentada.
