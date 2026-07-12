# Safe Save Edit Plan - Pass 12

Este plano descreve o caminho seguro para alterar dados de save sem quebrar a estrutura do jogo.

## Edicoes seguras de baixo risco

| Campo | Offset | Observacao |
|---|---:|---|
| Ano | `$0000` | Valor pequeno; validar efeitos de calendario. |
| Estacao | `$0001` | Afeta clima/crops/eventos. |
| Dia | `$0003` | Cuidado com festivais e fim de mes. |
| Sementes/feed | `$0004-$000A` | Contadores diretos. |
| Stamina maxima | `$000E` | Relacionado a power berries. |
| Ferramenta selecionada | `$000F` | Deve bater com inventario/backpack. |
| Agua do regador | `$0010` | Contador direto. |
| Madeira/grama armazenada | `$0040-$0042` | Contadores de recursos. |
| Corações | `$0048-$0050` | Maria/Ann/Nina/Ellen/Eve. |
| Nomes curtos | `$0080-$0097` | 4 bytes por nome. |

## Edicoes de risco medio

- `tool_shed bitfields` em `$0084-$0087`: precisa respeitar bits conhecidos da Pass 07.
- `chicken_array` em `$0098-$00FF`: precisa respeitar estrutura de 8 bytes por galinha.
- `cow_array` em `$0100-$01BF`: precisa respeitar estrutura de 16 bytes por vaca.

## Edicoes de alto risco

- `farm_map_array` em `$01C0-$0FFF`: altera tiles persistentes da fazenda, crops, grama, cercas e estados de campo.
- Flags brutas `$7F1Fxx`: ainda precisam de significado humano fechado antes de edicao direta.

## Regra obrigatoria

Depois de qualquer alteracao em save, recalcular o checksum em `$002F-$0030`.
