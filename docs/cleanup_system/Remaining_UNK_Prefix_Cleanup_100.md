# Pass 51 - Remaining UNK Prefix / Runtime Table Cleanup Core 100%

Esta pass fechou um escopo pequeno, mas importante para aproximar a source de uma base 100% documentada: remover os ultimos labels com prefixo `UNK_` do source principal e trocar esses nomes por simbolos baseados no uso real observado.

## Escopo fechado

**Remaining UNK Prefix / Runtime Table Cleanup Core 100%**

O escopo desta pass nao significa que todo label generico do projeto acabou. Ainda existem labels `CODE_`, `SUB_`, `DATA8_` e `DATA16_` em outras areas. O fechamento aqui e especifico: os labels com prefixo `UNK_` que restavam no source principal foram resolvidos.

## Resultado

Antes desta pass ainda existiam ocorrencias como:

```asm
UNK_PresetsMemory3
UNK_PointersTable
UNK_Audio_Table1
```

Depois desta pass, esses simbolos foram substituidos por nomes mais descritivos:

```asm
MapTilePatchRuntime_ClearAllSlots
TileProperty_MapPointerTable
AudioSPC_DriverProgram_BankAD
```

Tambem foram renomeados labels diretamente relacionados ao runtime de patch visual e as tabelas de propriedade de tiles.

## Renomeacoes principais

```text
UNK_PresetsMemory3 -> MapTilePatchRuntime_ClearAllSlots
BAAAA -> MapTilePatchRuntime_UpdateActiveSlots
CODE_81A4F1 -> MapTilePatchRuntime_ClearCurrentSlotActiveFlag
DATA8_81A58B -> MapTilePatchRuntime_BehaviorJumpTable
UNK_PointersTable -> TileProperty_MapPointerTable
UNK_Audio_Table1 -> AudioSPC_DriverProgram_BankAD
```

## Tile property sets

As tabelas de propriedade/atributo de tiles usadas pelo ponteiro `$0D-$0F` tambem receberam nomes neutros por endereco, evitando a nomenclatura generica `DATA16_...` neste nucleo:

```text
DATA16_82B3B4 -> TilePropertySet_B3B4
DATA16_82B7B4 -> TilePropertySet_B7B4
DATA16_82BBB4 -> TilePropertySet_BBB4
DATA16_82BFB4 -> TilePropertySet_BFB4
DATA16_82C3B4 -> TilePropertySet_C3B4
DATA16_82C7B4 -> TilePropertySet_C7B4
DATA16_82CBB4 -> TilePropertySet_CBB4
```

Essas tabelas sao carregadas via `TileProperty_MapPointerTable` durante `LoadMap` e depois lidas por rotinas de tile/collision/tool-use atraves do ponteiro de pagina direta `$0D-$0F`.

## MapTilePatch runtime

O runtime de patch visual usa uma lista de ate 10 slots de 16 bytes em WRAM, iniciando em `$7E:B4E6`.

- `MapTilePatchRuntime_ClearAllSlots` limpa o byte ativo de cada slot.
- `MapTilePatchRuntime_UpdateActiveSlots` itera os slots ativos.
- `MapTilePatchRuntime_ClearCurrentSlotActiveFlag` desativa o slot corrente.
- `MapTilePatchRuntime_BehaviorJumpTable` despacha o comportamento do slot.

Esse sistema complementa a Pass 50: a Pass 50 fechou os scripts de patch visual por area; a Pass 51 nomeia/organiza melhor o runtime desses slots e os ponteiros auxiliares de tile property.

## Audio SPC bank AD

`AudioSPC_DriverProgram_BankAD` marca o programa/dados brutos do SPC/APU localizados em `$AD:8000`. Ele permanece como bytes brutos, mas agora o label identifica corretamente que pertence ao driver/programa de audio do SPC, nao a uma tabela generica desconhecida.

## Validacao

A build foi revalidada apos as renomeacoes.

```text
MD5 ROM USA original: c9bf36a816b6d54aed79d43a6c45111a
MD5 rebuild Pass 51:  c9bf36a816b6d54aed79d43a6c45111a
Resultado: OK, identica byte-a-byte
```

Como as alteracoes sao renomeacoes/comentarios, a ROM reconstruida continua byte-perfect.
