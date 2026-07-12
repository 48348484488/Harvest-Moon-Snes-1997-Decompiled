# Guia do catalogo de ponteiros de texto

A Pass 03 gerou um catalogo completo da `Text_Pointer_Table`.

Arquivo principal:

```text
reports/decomp_pass03/text/text_pointer_catalog.csv
```

Tambem existe uma versao HTML pesquisavel:

```text
reports/decomp_pass03/text/text_catalog_viewer.html
```

## Campos do CSV

| Campo | Significado |
|---|---|
| `index_hex` | indice do texto na tabela principal |
| `snes_addr` | endereco SNES apontado pela tabela |
| `bank` | banco do texto |
| `label` | label atual no source |
| `category` | categoria heuristica |
| `text_preview` | trecho decodificado do texto |

## Uso pratico

Para encontrar textos de shipping, por exemplo, abra o HTML e filtre por:

```text
Shipping
```

Para encontrar o texto da Power Berry, busque:

```text
Power Berry
```

Para encontrar uma entrada especifica da tabela, busque o indice:

```text
07B
```

## Limitacao

Este catalogo ainda nao diz qual NPC/evento chama cada indice. Ele mapeia a tabela de ponteiros e os textos. A proxima passada deve mapear as rotinas/event scripts que carregam esses indices.
