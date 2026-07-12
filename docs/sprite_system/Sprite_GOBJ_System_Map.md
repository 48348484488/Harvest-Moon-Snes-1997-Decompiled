# Sistema de sprites / GOBJ - Pass 08

Esta passada mapeia a parte mais segura e viavel antes de qualquer edicao grafica: o sistema de **GOBJ** usado para desenhar sprites/personagens/objetos animados.

## Descoberta principal

O jogo usa duas tabelas principais de ponteiros de animacao:

- `GameOBJ_AnimPtrTable_Bank86` em `src/data_banks/bank_86.asm`
- `GameOBJ_AnimPtrTable_Bank87` em `src/data_banks/bank_87.asm`

O codigo em `src/code_banks/bank_85.asm` escolhe a tabela assim:

```asm
CMP.W #$0262
BCS .usa_banco_87
```

Isso indica:

- GOBJ `$0000-$0261` usam metadata no banco `86`.
- GOBJ `$0262+` usam metadata no banco `87`.

## Quantidade catalogada

- Banco 86: 610 entradas GOBJ.
- Banco 87: 494 entradas GOBJ.
- Total: 1104 entradas.

## Formato inferido de frame

Cada entrada de animacao aponta para uma sequencia de frames. Cada frame usa 3 bytes:

```text
word frame_component_table
byte delay/control
```

Valores observados:

- ponteiro `0000`: volta/reseta para o inicio da sequencia.
- delay `FE`: provavel terminador/remocao.
- delay `FF`: provavel frame estatico/hold.

## Formato inferido da component table

Cada frame aponta para uma tabela de componentes:

```text
byte component_count
repeat component_count:
    byte component_id
    byte unknown1
    byte x_offset_signed
    byte y_offset_signed
    byte attr_bits
```

O campo `component_id` nao e exatamente um tile solto; ele referencia um bloco 16x16 composto por 4 tiles 8x8 nos bancos graficos `88-91`.

## Mapeamento de component_id para grafico

A rotina `SpriteComponent_BuildVRAMUploadQueue` calcula a fonte grafica assim:

```text
graphics_bank = $88 + (component_id / 256)
block_in_bank = (component_id / 64) % 4
local_id      = component_id % 64
source_addr   = $8000 + block_in_bank*$2000 + local_id*$40
bottom_row    = source_addr + $0200
```

Ou seja, cada componente 16x16 usa:

- top row: `source_addr` por 64 bytes;
- bottom row: `source_addr+$0200` por 64 bytes.

## Por que isso e seguro?

Nesta passada eu nao inseri sprite novo. Apenas:

- renomeei labels claros;
- cataloguei metadata;
- gerei viewer/CSV/JSON;
- gerei atlas bruto dos componentes.

A build continua byte-perfect.
