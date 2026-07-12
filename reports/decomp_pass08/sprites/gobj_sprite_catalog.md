# Pass 08 - Catalogo GOBJ/Sprites
Esta passada foi feita de forma conservadora: nao troca graficos e nao adiciona bonecos. Ela mapeia o sistema para permitir substituicao segura depois.
## Resumo tecnico
- Entradas GOBJ no banco 86: **610**
- Entradas GOBJ no banco 87: **494**
- Total de entradas GOBJ catalogadas: **1104**
- Componentes graficos possiveis mapeados em bancos 88-91: **1024**
- Componentes referenciados por metadata GOBJ: **256**
- Componentes sem referencia e zerados: **18**
- Componentes sem referencia mas com bytes graficos: **750**
- GOBJ com loop/reset detectado: **1065**
- GOBJ com terminador FE em primeira/ultima sequencia: **0**
- Maior quantidade de componentes em um frame: **12**

## Componentes usados por banco grafico
- $88: 256 componentes usados

## Componentes mais reutilizados
| componente | usos | exemplos GOBJ |
|---:|---:|---|
| $08A | 165 | $0027 $0027 $0027 $0027 |
| $0B8 | 120 | $0051 $0051 $0051 $006D |
| $083 | 116 | $0027 $0027 $0027 $0027 |
| $082 | 107 | $0027 $0027 $0027 $0027 |
| $08C | 95 | $0033 $004E $006B $006B |
| $085 | 91 | $0027 $0027 $0027 $0028 |
| $08F | 91 | $0033 $004D $004E $006C |
| $084 | 90 | $0027 $0027 $0027 $0028 |
| $094 | 89 | $0033 $004F $006C $0084 |
| $001 | 75 | $0039 $0039 $003B $003B |
| $0C0 | 71 | $0034 $0034 $0034 $0034 |
| $073 | 61 | $004C $0064 $0064 $0064 |
| $080 | 60 | $0027 $0028 $0029 $002A |
| $0C1 | 59 | $0035 $0052 $0052 $0052 |
| $0D2 | 57 | $002B $0038 $0054 $0054 |
| $0A6 | 56 | $0021 $0022 $0025 $0050 |
| $088 | 56 | $0027 $0028 $0029 $002A |
| $0C3 | 56 | $0036 $0036 $0053 $0053 |
| $009 | 54 | $0000 $0044 $0056 $0056 |
| $09D | 54 | $0026 $0026 $0026 $0026 |
| $0D0 | 53 | $0029 $003F $003F $0054 |
| $0D4 | 53 | $002D $0038 $0038 $0055 |
| $0E5 | 53 | $003A $003A $003A $003A |
| $0E6 | 53 | $0057 $005A $005B $0070 |
| $096 | 52 | $0026 $0026 $0026 $0026 |
| $0D3 | 52 | $002C $0038 $0038 $0055 |
| $0C2 | 52 | $0035 $0035 $0053 $0053 |
| $0E3 | 52 | $003B $0056 $0070 $008C |
| $056 | 51 | $001B $001C $001E $001E |
| $09C | 50 | $0026 $0026 $0026 $0026 |

## Arquivos gerados
- `gobj_sprite_catalog.csv/json`: lista cada GOBJ, ponteiro, frames e componentes.
- `component_graphics_map.csv/json`: mapeia cada ID de componente para banco/endereco grafico.
- `component_atlas_bank_88.png` ate `component_atlas_bank_91.png`: preview bruto dos componentes 16x16.
- `sprite_gobj_viewer.html`: visualizador pesquisavel.
