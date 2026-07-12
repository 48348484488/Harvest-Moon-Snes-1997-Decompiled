# Relatorio da etapa com ROM BR

A ROM enviada foi analisada e **nao foi incluida no ZIP final**.

## Arquivo analisado

`Harvest Moon (BR) (www.romsportugues.com).smc`

## Identificacao

- Tamanho: `2097152` bytes / `0x200000`.
- Sem header copier de 512 bytes.
- Header LoROM em `0x7FC0`.
- Titulo interno: `HARVEST MOON`.
- MD5: `ac135a3d01e0224a356586dba2b4fd34`.
- Checksum SNES: `0x3BA2`.
- Complemento: `0xC45D`.

## Compatibilidade

O projeto original declara suporte ao ROM USA com MD5:

`c9bf36a816b6d54aed79d43a6c45111a`

A ROM enviada **nao bate com esse MD5**, entao ela provavelmente e uma traducao/hack em cima da base USA.

## Comparacao de dados literais ASM vs ROM BR

Resultado gerado por `tools/verify_source_against_rom.py`:

- Diretivas literais analisadas: `123042`.
- Bytes de dados comparados: `1920853`.
- Bytes que batem: `1743988`.
- Bytes diferentes: `76317`.
- Compatibilidade dos dados literais: `90.7924%`.

## Onde estao as maiores diferencas

As diferencas relevantes ficaram concentradas principalmente em:

- bancos `B6-BB`, que no projeto sao bancos de texto/dialogo;
- partes de `94` e `95`, provavelmente tilemaps/tabelas alteradas pela traducao;
- header/checksum em `80FFDC-80FFDF`;
- pequenas tabelas em `82`, `84` e `85`.

Ou seja: a base do projeto ainda serve, mas a ROM BR precisa de uma camada separada para texto/dados modificados.

## O que foi adicionado ao pacote

- `tools/rom_info.py`
- `tools/verify_source_against_rom.py`
- `tools/group_mismatch_ranges.py`
- `tools/make_raw_bank_asm.py`
- `tools/fix_snes_checksum.py`
- `tools/check_asar.py`
- `docs/ROM_BR_WORKFLOW.md`
- `reports/rom_info.md`
- `reports/source_vs_rom_data.md`
- `reports/source_vs_rom_data_mismatches.csv`
- `reports/mismatch_ranges.md`
- `reports/build_attempt_with_BR_rom.txt`
- `reports/asar_status.txt`

## Limite encontrado

Nao consegui montar o ROM final aqui porque `asar` nao esta instalado no ambiente e o acesso a repositorios externos falhou. Mesmo assim, deixei o projeto preparado para validacao local e para separar exatamente quais bancos da ROM BR divergem do source USA.
