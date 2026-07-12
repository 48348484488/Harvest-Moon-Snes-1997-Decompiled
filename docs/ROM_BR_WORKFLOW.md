# Workflow com ROM BR/traduzida

Este pacote agora tem ferramentas para trabalhar com a ROM que voce adicionou **sem colocar a ROM dentro do projeto final**.

## Resultado da ROM enviada

Arquivo analisado localmente:

`Harvest Moon (BR) (www.romsportugues.com).smc`

Resultado:

- Tamanho: `2.097.152 bytes` (`0x200000`), sem header copier de 512 bytes.
- Titulo SNES: `HARVEST MOON`.
- LoROM/FastROM: map mode `0x30`.
- MD5: `ac135a3d01e0224a356586dba2b4fd34`.
- O README original do decomp espera o MD5 USA: `c9bf36a816b6d54aed79d43a6c45111a`.

Conclusao: a ROM enviada e uma ROM modificada/traduzida baseada no jogo, nao o ROM USA limpo esperado pelo projeto.

## O que isso muda

A maior parte dos bancos graficos/mapas/dados bate com o source USA. As maiores diferencas estao nos bancos de texto/dialogos:

- `B6`
- `B7`
- `B8`
- `B9`
- `BA`
- `BB`

Tambem existem diferencas menores em tabelas e checksum/header.

## Scripts adicionados

### 1. Ver informacoes da ROM

```bash
python tools/rom_info.py --rom "roms/Harvest Moon BR.smc"
```

Gera:

- `reports/rom_info.md`

### 2. Comparar dados do source ASM contra uma ROM

```bash
python tools/verify_source_against_rom.py --rom "roms/Harvest Moon BR.smc"
```

Gera:

- `reports/source_vs_rom_data.md`
- `reports/source_vs_rom_data_mismatches.csv`

### 3. Agrupar diferencas por faixa

```bash
python tools/group_mismatch_ranges.py
```

Gera:

- `reports/mismatch_ranges.md`

### 4. Gerar bancos brutos localmente

```bash
python tools/make_raw_bank_asm.py --rom "roms/Harvest Moon BR.smc" --banks B6 BB --out build/raw_br_text_banks
```

Isso e util para estudo local das diferencas da traducao. Nao redistribua bancos brutos gerados de ROM comercial.

### 5. Corrigir checksum SNES depois de modificar/montar ROM

```bash
python tools/fix_snes_checksum.py --rom build/out.sfc --out build/out_fixed.sfc
```

## Estado da montagem com asar

O projeto usa sintaxe `asar`, mas o ambiente atual nao tem `asar` instalado e nao conseguiu baixar pacotes externos. Por isso, a montagem byte-a-byte ainda precisa ser feita em uma maquina local com `asar` instalado.

Depois de instalar o `asar`:

```bash
python tools/build_and_compare.py --original "roms/Harvest Moon USA.sfc"
```

Para a ROM BR, use primeiro os scripts de comparacao e depois decida se quer portar os bancos de texto/dados modificados.
