# Decomp Pass 01 - Tools / Seeds / Shed Items

Arquivos analisados:

- `src/constants/ram.asm`
- `src/code_banks/bank_81.asm`
- `src/code_banks/bank_82.asm`

## Variaveis de ferramentas e itens

| Variavel | Endereco | Descricao |
|---|---:|---|
| `!item_on_hand` | `$091D` | item atualmente carregado/segurado |
| `!old_item_on_hand` | `$091E` | item segurado anteriormente |
| `!tool_selected` | `$0921` | ferramenta/item selecionado |
| `!tool_backpack` | `$0923` | ferramenta/item no backpack |
| `!watering_can_water` | `$0926` | agua no regador |

## Quantidade de sementes/recursos

| Variavel | Endereco | Descricao |
|---|---:|---|
| `!seeds_grass_N` | `$0927` | sementes de grama |
| `!seeds_corn_N` | `$0928` | sementes de milho |
| `!seeds_tomato_N` | `$0929` | sementes de tomate |
| `!seeds_potato_N` | `$092A` | sementes de batata |
| `!seeds_turnip_N` | `$092B` | sementes de nabo |
| `!feed_cow_N` | `$092C` | racao de vaca |
| `!feed_chicks_N` | `$092D` | racao de galinha |

## IDs de `tool_selected`

Extraido/complementado de `ram.asm`:

| ID | Item/ferramenta |
|---:|---|
| `00` | nothing |
| `01` | sickle |
| `02` | hoe/plow |
| `03` | hammer |
| `04` | axe |
| `05` | yellow seed |
| `06` | red seed |
| `07` | brown seed |
| `08` | white seed |
| `09` | cow medicine |
| `0A` | miracle potion |
| `0B` | bell |
| `0C` | grass seed |
| `0D` | paint |
| `0E` | milker |
| `0F` | brush |
| `10` | watering can |
| `11` | gold sickle |
| `12` | gold hoe/plow |
| `13` | gold hammer |
| `14` | gold axe |
| `15` | sprinkler |
| `16` | bean |
| `17` | gem/blue diamond |
| `18` | blue feather |
| `19` | chicken feed |
| `1A` | cow feed |

## Shed bitfields

O jogo guarda itens do galpao como bitfields em SRAM/WRAM persistente:

| Variavel | Endereco | Comentario original/inferido |
|---|---:|---|
| `!shed_items_row_1` | `$7F1F00` | turnip, potato, tomato, corn, axe, hammer, plow/hoe, sickle |
| `!shed_items_row_2` | `$7F1F01` | watering can, brush, milker, paint, grass seed, bell, miracle potion, cow medicine |
| `!shed_items_row_3` | `$7F1F02` | blue feather, blue diamond/gem, bean, sprinkler, gold axe, gold hammer, gold plow, gold sickle |
| `!shed_items_row_4` | `$7F1F03` | ainda precisa confirmar |

## Conclusao

A parte de ferramentas ja esta bem proxima de ser documentada. A proxima etapa de decompilacao seria renomear as subrotinas de `bank_81.asm` que manipulam `tool_selected`, `tool_backpack` e os bitfields do shed.

