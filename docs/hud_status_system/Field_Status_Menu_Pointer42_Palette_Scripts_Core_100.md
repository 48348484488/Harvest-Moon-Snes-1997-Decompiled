# Pass 44 - Field Status/Menu Pointer42 Palette Scripts Core 100%

Escopo fechado: decodificar o engine Pointer42 usado pelo menu/status e os scripts de paleta `$82F2A4/$82F2B5/$82F2C9/$82F2DA` instalados nos slots Pointer42.

Esta pass fecha o formato dos scripts e o papel das rotinas centrais. Ela nao decodifica todos os scripts Pointer42 do jogo inteiro.

## Engine Pointer42

| Rotina | Local | Funcao |
|---|---:|---|
| `PaletteAnim_SetPointer42Slot` | `$808E48` | Instala um slot Pointer42 com ponteiro de script e parametros de destino. |
| `PaletteAnim_UpdatePointer42Slots` | `$808E69` | Avanca scripts ativos, escreve cores no buffer de CGRAM e agenda DMA quando ha update. |
| `PaletteAnim_ClearPointer42Slot` | `$808F82` | Limpa um slot Pointer42. |
| `PaletteAnim_ClearPointer42SlotsFromIndex` | `$808F92` | Limpa slots do indice informado ate `$0F`. |
| `PaletteAnim_ClearAllPointer42Slots` | `$808FAB` | Limpa todos os slots Pointer42. |

`PaletteAnim_SetPointer42Slot` recebe:

- `X`: slot Pointer42;
- `A`: indice de cor dentro da linha de paleta;
- `Y`: linha de paleta;
- `$72/$74`: ponteiro 24-bit para o script.

`PaletteAnim_UpdatePointer42Slots` usa `PaletteBuffer_WriteColorToSelectedBuffer`, entao cada comando normal escreve uma cor SNES BGR555 em `$7F0900` ou `$7F0B00` conforme `$92`, e depois agenda DMA para CGRAM.

## Formato de script

| Comando | Bytes | Efeito |
|---|---|---|
| cor normal | `dw color`, `db delay` | Escreve `color` no destino do slot, grava `delay` em `$014A,X` e avanca 3 bytes. |
| fim | `dw $FFFF` | Limpa o ponteiro do slot. |
| salto | `dw $FFFE`, `dl target` | Troca o ponteiro do slot para `target` e continua por la. |

## Scripts do menu/status

| Script | Local | Uso |
|---|---:|---|
| `FieldStatusMenu_PaletteAnim_Slot4Intro` | `$82F2A4` | Fade inicial do slot Pointer42 `$04`; cai em loop no ultimo tom. |
| `FieldStatusMenu_PaletteAnim_Slot4Loop` | `$82F2AD` | Loop estavel do slot `$04`. |
| `FieldStatusMenu_PaletteAnim_Slot5Intro` | `$82F2B5` | Fade inicial do slot Pointer42 `$05`; cai em loop no ultimo tom. |
| `FieldStatusMenu_PaletteAnim_Slot5Loop` | `$82F2C1` | Loop estavel do slot `$05`. |
| `FieldStatusMenu_PaletteAnim_SelectedPulse` | `$82F2C9` | Pulso de selecao usado nos slots `$06-$08` conforme `$098D`. |
| `FieldStatusMenu_PaletteAnim_StaticHighlight` | `$82F2DA` | Highlight estatico usado nos slots `$06-$08` conforme `$098D`. |

### Slot 4

| Cor | Delay |
|---:|---:|
| `$7F10` | `$20` |
| `$7EF0` | `$10` |
| `$7E8E` | `$10` |
| `$720A` | `$10` |
| jump | `FieldStatusMenu_PaletteAnim_Slot4Loop` |

### Slot 5

| Cor | Delay |
|---:|---:|
| `$7A8A` | `$10` |
| `$724A` | `$10` |
| `$6DE5` | `$10` |
| `$65A3` | `$10` |
| `$58C3` | `$10` |
| jump | `FieldStatusMenu_PaletteAnim_Slot5Loop` |

### Selected Pulse

| Cor | Delay |
|---:|---:|
| `$629F` | `$08` |
| `$5E1F` | `$08` |
| `$59DF` | `$10` |
| `$5E1F` | `$08` |
| jump | `FieldStatusMenu_PaletteAnim_SelectedPulse` |

### Static Highlight

| Cor | Delay |
|---:|---:|
| `$7F3F` | `$08` |
| jump | `FieldStatusMenu_PaletteAnim_StaticHighlight` |

## Ligacao com stages 04/05

- Stage `$95 = $04` instala os slots fixos `$04/$05` e uma matriz inicial para `$06-$08`.
- Stage `$95 = $05` consome `$97` e reinstala `$06-$08` quando o cursor muda.
- `$098D` decide qual dos slots `$06-$08` recebe `SelectedPulse`; os outros ficam em `StaticHighlight`.

## Relacionados fora do escopo

`IntroMenu_PaletteAnim_YellowPulse` (`$82F2E2`) e `IntroMenu_PaletteAnim_YellowStatic` (`$82F2F9`) foram nomeados porque compartilham o mesmo bloco de dados e formato, mas nao fazem parte do menu/status fechado nesta pass.

## Limites do escopo

Fechado nesta pass:

- formato dos scripts Pointer42;
- contrato das rotinas centrais Pointer42;
- decodificacao dos quatro scripts usados pelo menu/status;
- separacao entre tabela de ano do save menu e scripts de paleta;
- rebuild byte-perfect apos reestruturar os dados.

Nao fechado nesta pass:

- todos os scripts Pointer42 em `bank_80_pointersubrutines.asm`;
- semantica visual de cada cor na tela final;
- todos os estados de intro/menu que usam os scripts amarelos `$82F2E2/$82F2F9`.
